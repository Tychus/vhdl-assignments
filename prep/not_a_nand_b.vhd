library ieee;
use ieee.std_logic_1164.all;

entity not_a_nand_b is
  port (
    input_0 :in std_logic;
    input_1 :in std_logic;
    result  :out std_logic
  );
end not_a_nand_b;

architecture dataflow of not_a_nand_b is
begin
  result <= not input_0 nand input_1;
end dataflow;
