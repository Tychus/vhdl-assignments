library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplier_tb is
end multiplier_tb;

architecture testbench of multiplier_tb is
  signal test : std_logic_vector(7 downto 0):=(others => '0');
  signal testres: std_logic_vector(7 downto 0);

  component multiplier is
    generic (
      n: natural := 4;
      m: natural := 4
    );

    port(
      a: in std_logic_vector(n-1 downto 0);
      b: in std_logic_vector(m-1 downto 0);
      result: out std_logic_vector((n+m)-1 downto 0)
    );
  end component;

begin
  DUT: multiplier
    port map(
      a => test(7 downto 4),
      b => test(3 downto 0),
      result => testres
    );

  testing: process
  begin
    loopz: for i in 0 to 15 loop
      test <= test +1;
      wait for 10 ns;
    end loop loopz;
  end process testing;
end testbench;
