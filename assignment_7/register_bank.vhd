library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity register_bank is
  port (
    clk,reset, write_enable           :in std_logic;
    data_in                           :in std_logic_vector(7 downto 0); -- input data to write to the registers
    address_w, address_r1, address_r2 :in std_logic_vector(3 downto 0); -- write address, Rx address, Ry address (in other words x and y)
    data_out1, data_out2              :out std_logic_vector(7 downto 0) -- Rx data, Ry data
  );
end register_bank;

architecture behavioral of register_bank is
  type memory_vector_array is array (0 to 15) of std_logic_vector(7 downto 0);
  signal RAM: memory_vector_array;
begin
  get_data: process(clk, reset, write_enable, address_r1, address_r2) begin
    if reset = '1' then
      for i in 0 to 15 loop
        RAM(i) <= "00000000";
      end loop;
    elsif (clk'event and clk = '1' and write_enable = '1') then
      RAM(conv_integer(address_w)) <= data_in;
    end if;

    data_out1 <= RAM(conv_integer(address_r1));
    data_out2 <= RAM(conv_integer(address_r2));
  end process;
end behavioral;
