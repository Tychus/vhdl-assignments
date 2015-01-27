library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity instruction_rom is
  port (
    oe_bar   :in std_logic; -- output_enable
    address  :in std_logic_vector(7 downto 0); -- It indicates the current instruction address
    data_out :out std_logic_vector(16 downto 0) -- It returns a 17-bit instruction
  );
end instruction_rom;

architecture behavioral of instruction_rom is
  type memory_vector_array is array (0 to 256) of std_logic_vector(16 downto 0);

  constant ROM :memory_vector_array := (
    0 => B"1_0000_0011_0000_1100", -- LOAD $R3, 12
    1 => B"1_0000_0000_0000_0000", -- LOAD $R0, 00
    2 => B"1_0000_0001_0000_0001", -- LOAD $R1, 01
    3 => B"1_0111_0000_1111_1111", -- EXP $R0, 255
    4 => B"1_0111_0001_1111_1111", -- EXP $R1, 255
    5 => B"0_0000_0010_0001_0000", -- LOAD $R2, $R1
    6 => B"0_0100_0001_0000_0000", -- ADD $R1, $R0
    7 => B"1_0111_0001_1111_1111", -- EXP $R1, 255
    8 => B"0_0000_0000_0010_0000", -- LOAD $R0, $R2
    9 => B"1_0110_0011_0000_0001", -- SUB $R3, 01
    10 => B"1_1111_0000_0000_1100", -- JZ 12
    11 => B"0_1111_0000_0000_0101", -- JMP 05
    12 => B"1_0000_0100_0011_1111", -- LOAD $R4, 63
    13 => B"0_1000_0100_0000_0100", -- SLL $R4, 04
    14 => B"1_0111_0100_1111_1110", -- EXP $R4, 254
    15 => B"1_1111_1000_0001_0001", -- JC 17
    16 => B"0_1111_0000_0000_1101", -- JMP 13
    17 => B"0_1110_0000_0000_0000", -- HLT
    others => B"0_0000_0000_0000_0000"
  );

begin
  process(oe_bar, address)
  begin
    if oe_bar = '0' then
      data_out <= ROM (conv_integer(address));
    end if;
  end process;
end behavioral;
