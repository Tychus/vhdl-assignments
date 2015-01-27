library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity muliplier1b_tb is
end muliplier1b_tb;

architecture onebit_tb of muliplier1b_tb is
  component multiplier1b is
  port(
    a,b:in std_logic;
    sin,cin:in std_logic;
    sum,carry: out std_logic
  );
end component;
  signal at:std_logic_vector(3 downto 0):="0000";
  signal cout, sout  :  std_logic;
begin
  DUT: multiplier1b port map(
    a => at(3),
    b => at(2),
    sin => at(1),
    cin => at(0),
    sum => sout,
    carry => cout
  );

  testprocess: process
  begin
    loopz: for i in 0 to 15 loop
      at <= at +1;
      wait for 10 ns;
    end loop loopz;
  end process;
end onebit_tb;
