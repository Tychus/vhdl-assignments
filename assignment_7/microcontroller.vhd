library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity microcontroller is
  port(
    clk,reset   :in std_logic;
    instruction :in std_logic_vector(16 downto 0); -- It receives a 17-bit instruction
    input_port  :in std_logic_vector(7 downto 0); -- input port to connect to peripheral devices
    oe_bar      :out std_logic; -- to read from the Instruction Memory
    address     :out std_logic_vector(7 downto 0); -- It indicates the current instruction address
    port_id     :out std_logic_vector(7 downto 0); -- It indicates the port address for export(EXP) operation.
    output_port :out std_logic_vector(7 downto 0) -- output port to connect to peripheral devices
  );
end microcontroller;

architecture behavioral of microcontroller is
  component instruction_decode_unit
    port(
      instruction            :in std_logic_vector(16 downto 0);
      operation              :out std_logic_vector(3 downto 0);
      shift_rotate_operation :out std_logic_vector(2 downto 0);
      operand_selection      :out std_logic;
      x_address,y_address    :out std_logic_vector(3 downto 0);
      port_address           :out std_logic_vector(7 downto 0);
      conditional            :out std_logic;
      jump                   :out std_logic;
      jump_address           :out std_logic_vector(7 downto 0);
      condition_flag         :out std_logic;
      export                 :out std_logic;
      halt                   :out std_logic
    );
  end component;

  component register_bank
    port (
      clk, reset, write_enable          :in std_logic;
      data_in                           :in std_logic_vector(7 downto 0);
      address_w, address_r1, address_r2 :in std_logic_vector(3 downto 0);
      data_out1,data_out2               :out std_logic_vector(7 downto 0)
    );
  end component;

  component alu is
    port (
      operation              :in std_logic_vector(3 downto 0);
      shift_rotate_operation :in std_logic_vector(2 downto 0);
      operand_a, operand_b   :in std_logic_vector(7 downto 0);
      input_port             :in std_logic_vector(7 downto 0);
      port_address           :in std_logic_vector(7 downto 0);
      zero, carry            :out std_logic;
      result                 :out std_logic_vector(7 downto 0);
      output_port            :out std_logic_vector(7 downto 0);
      port_id                :out std_logic_vector(7 downto 0)
    );
  end component;

  signal port_addr, jump_add, data_out_x, data_out_y, operand_1, operand_2 :std_logic_vector(7 downto 0) := "00000000";
  signal oe, op_sel, cond, jmp, cond_f, ex_p, hal_t, aluz, aluc :std_logic := '0';
  signal write_addr, op, xa, ya :std_logic_vector(3 downto 0);
  signal shift_rotate :std_logic_vector(2 downto 0) := "ZZZ";
  signal in_port, out_port, port_id_t :std_logic_vector(7 downto 0) := "ZZZZZZZZ";

  signal ram_in: std_logic_vector(7 downto 0):="ZZZZZZZZ";
  signal alu_res: std_logic_vector(7 downto 0):="ZZZZZZZZ";
  signal ram_ch1: std_logic_vector(7 downto 0):="ZZZZZZZZ";

  signal w_e: std_logic:='1';

  type controller_state is (reset_state, exec, write_back, invalid);
  signal state: controller_state;
begin
  idu:instruction_decode_unit port map(instruction, op, shift_rotate, op_sel, xa, ya, port_addr, cond, jmp, jump_add, cond_f, ex_p, hal_t);
  alunit:alu port map(op, shift_rotate, operand_1, operand_2, in_port, port_addr, aluz, aluc, alu_res, out_port, port_id_t);
  rbank:register_bank port map(clk, reset, w_e, ram_in, write_addr, xa, ya, data_out_x, data_out_y);

  get_state: process(clk, reset) begin
    if reset = '1' then
      state <= reset_state;
    elsif clk'event and clk = '1' then
      case state is
      when reset_state => state <= exec;
      when exec        => state <= write_back;
      when write_back  => state <= exec;
      when others      => state <= invalid;
      end case;
    end if;
  end process;

  processing: process(state)
    variable current_address :std_logic_vector(7 downto 0) := "00000000";
  begin
    if state = exec then
      w_e <= '0';
      oe_bar <= '0';

      if jmp = '1' then
        if cond = '1' then
          address <= instruction(7 downto 0);
          current_address := instruction(7 downto 0);
        else
          if (cond_f = '0' and aluz = '1') or (cond_f = '1' and aluc = '1') then -- JZ
            address <= instruction(7 downto 0);
            current_address := instruction(7 downto 0);
          else
            address <= current_address;
          end if;
        end if;

        current_address := current_address + 1;
      else
         address <= current_address;
         current_address := current_address + 1;
      end if;
    elsif state = write_back then
      if op = "0000" then
        w_e <= '1';
        write_addr <= instruction(11 downto 8);

        if op_sel = '1' then
          ram_ch1 <= instruction(7 downto 0);
        else
          ram_ch1 <= data_out_y;
        end if;
      -- load input
      elsif op = "0101" then
        w_e <= '1';
        write_addr <= instruction(11 downto 8);
        ram_ch1 <= "ZZZZZZZZ";
      -- export to output
      elsif op = "0111" then
        w_e <= '0';
        port_id <= port_addr;
        write_addr <= "ZZZZ";
        output_port <= data_out_x;
        ram_ch1 <= "ZZZZZZZZ";
      -- jump
      elsif op = "1111" then
        w_e <= '0';
        write_addr <= "ZZZZ";
        ram_ch1 <= "ZZZZZZZZ";
      -- alu ops
      else
        -- get RAM data for alu operations
        -- if op_sel = 0 means operation done with Ry (RAM(Ry)), 1 means ALU takes constant instruction(7 downto 0).
        -- need above data and RAM(Rx)
        -- data_out_x and data_out_y return data of Rx and Ry addresses,
        w_e <= '1';
        write_addr <= instruction(11 downto 8);
        ram_ch1 <= "ZZZZZZZZ";

        if op_sel = '0' then
          operand_1 <= data_out_x;
          operand_2 <= data_out_y;
        else
          operand_1 <= data_out_x;
          operand_2 <= instruction(7 downto 0);
        end if;
      end if;
    end if;
  end process;

  ram_process: process(alu_res, ram_ch1) begin
    if state = write_back then
      if op = "0000" then
        ram_in <= ram_ch1;
      elsif op = "0101" then
        ram_in <= input_port;
      else
        ram_in <= alu_res;
      end if;
     end if;
  end process;
end behavioral;
