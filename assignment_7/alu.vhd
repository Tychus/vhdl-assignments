library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
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
end alu;

architecture behavioral of alu is
  signal temp :std_logic_vector(8 downto 0);
begin
  calculate: process(operand_a, operand_b) begin
    case operation is
      when "0001"=> temp <= std_logic_vector(resize((signed(operand_a) and signed(operand_b)),9));
      when "0010"=> temp <= std_logic_vector(resize((signed(operand_a) or  signed(operand_b)),9));
      when "0011"=> temp <= std_logic_vector(resize((signed(operand_a) xor signed(operand_b)),9));
      when "0100"=> temp <= std_logic_vector(resize((signed(operand_a)  +  signed(operand_b)),9));
      when "0110"=> temp <= std_logic_vector(resize((signed(operand_a)  -  signed(operand_b)),9));

      when "1000"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sll to_integer(unsigned(shift_rotate_operation)));
      when "1001"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sla to_integer(unsigned(shift_rotate_operation)));
      when "1010"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) srl to_integer(unsigned(shift_rotate_operation)));
      when "1011"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sra to_integer(unsigned(shift_rotate_operation)));
      when "1100"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) rol to_integer(unsigned(shift_rotate_operation)));
      when "1101"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) ror to_integer(unsigned(shift_rotate_operation)));
      when others => temp <= "ZZZZZZZZZ";
    end case;
  end process;

  output_port <= "ZZZZZZZZ";
  zero <= '1' when temp(7 downto 0) = "00000000" else '0';
  carry <= '1' when temp(8) = '1' else '0';
  result <= temp(7 downto 0);
end behavioral;
