library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplier_tb is
end multiplier_tb;

architecture testbench of multiplier_tb is
  signal test_1 : std_logic_vector(3 downto 0) := (others => '0');
  signal test_2 : std_logic_vector(3 downto 0) := (others => '0');
  signal testres: std_logic_vector(7 downto 0);
  signal control: std_logic_vector(7 downto 0);

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
      a => test_1,
      b => test_2,
      result => testres
    );

  controlling: process(test_1)
  begin
    control <= std_logic_vector(unsigned(test_1) * unsigned(test_2));
  end process controlling;

  testing: process
  begin
    loopz: for i in 0 to 15 loop
      test_1 <= test_1 + 1;
      test_2 <= test_2 + 1;
      wait for 10 ns;
    end loop loopz;

    wait;
  end process testing;
end testbench;
