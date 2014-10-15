library ieee;
use ieee.std_logic_1164.all;

entity a_nand_b is
  port (
    input_0 :in std_logic;
    input_1 :in std_logic;
    result  :out std_logic
  );
end a_nand_b;

architecture dataflow of a_nand_b is
begin
  result <= input_0 nand input_1;
end dataflow;
