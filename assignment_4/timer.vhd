library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity timer is
port
(
  timer_reset    :in std_logic;
  timer_clock :in std_logic;
  timer_time  :out std_logic_vector (5 downto 0)
);
end entity;

architecture behavioral of timer is
begin
  timing: process(timer_reset, timer_clock)
    variable count_var: integer := 0;
  begin
    if timer_reset = '1' then
      count_var := 0;
    end if;

    if rising_edge(timer_clock) then
      count_var := count_var + 1;
    end if;

    timer_time <= std_logic_vector(to_unsigned(count_var, timer_time'length));
  end process;
end behavioral;
