library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplier1b is
  port(
    a,b		:in std_logic;
    sin,cin	:in std_logic;
    sum,carry	:out std_logic
  );
end multiplier1b;

architecture mult1b of multiplier1b is
	signal aa: std_logic;
begin
  aa <= a and b;
  sum <= (sin xor cin) xor aa;
  carry <= (aa and sin) or ( aa and cin) or (sin and cin);
end mult1b;
