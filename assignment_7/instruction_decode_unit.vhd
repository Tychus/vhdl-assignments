library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity instruction_decode_unit is
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
end instruction_decode_unit;

architecture behavioral of instruction_decode_unit is
begin
  decoding: process(instruction)
  begin
    operation <= instruction(15 downto 12);
    operand_selection <= instruction(16);

    if (instruction(15 downto 12) = "1000" or
        instruction(15 downto 12) = "1001" or
        instruction(15 downto 12) = "1010" or
        instruction(15 downto 12) = "1011" or
        instruction(15 downto 12) = "1100" or
        instruction(15 downto 12) = "1101") then
      shift_rotate_operation <= instruction(2 downto 0);
    else
      shift_rotate_operation <= "ZZZ";
    end if;

    if ((instruction(16)='1') or
        (instruction(15 downto 12) = "0101") or
        (instruction(15 downto 12) = "0111") or
        (instruction(15 downto 12) = "1111") or
        (instruction(15 downto 12) = "0101")) then
      y_address <= "ZZZZ";
    else
      y_address <= instruction(7 downto 4);
    end if;

    if ((instruction(15 downto 12) = "0000") or
        (instruction(15 downto 12) = "0101") or
        (instruction(15 downto 12) = "1111")) then
      x_address <= "ZZZZ";
    else
      x_address <= instruction(11 downto 8);
    end if;

    if (instruction(16) = '0' and instruction(15 downto 12) = "1111") then
      conditional <= '1';

      if instruction(11) = '1' then
        condition_flag <= '1';
      else
        condition_flag <= '0';
      end if;
    else
      conditional <= '0';
    end if;

    if instruction(15 downto 12) = "1111" then
      jump <= '1';
    else
      jump <= '0';
    end if;

    if instruction(15 downto 12) = "1111" then
      jump_address <= instruction(7 downto 0);
    else
      jump_address <= "ZZZZZZZZ";
    end if;

    if instruction(16 downto 12) = "10111" then
      export <= '1';
      port_address <= instruction(7 downto 0);
    else
      export <= '0';
      port_address <= "ZZZZZZZZ";
    end if;

    if instruction(15 downto 12) = "1110" then
      halt <= '1';
    else
      halt <= '0';
    end if;
  end process;
end behavioral;
