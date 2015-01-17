library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity timer is
port
(
  timer_reset    :in std_logic;
  timer_clock :in std_logic;
  timer_time  :out std_logic_vector (5 downto 0)
);
end entity;

architecture behavioral of timer is
  -- clock period 1 ms
  constant counts_to_tick :integer := 1000;
begin
  timing: process(timer_reset, timer_clock)
    variable count_var   :integer;
    variable secs_passed :integer;
    variable temp_sec    :integer;
  begin
    if timer_reset = '1' then
      count_var := 0;
      secs_passed := 0;
    end if;

    if (timer_clock'event and timer_clock = '1') then
      count_var := count_var + 1;
      temp_sec := integer(real(count_var / counts_to_tick));

      if temp_sec = 1 then
        secs_passed := secs_passed + 1;
        count_var := 0;
      end if;

      timer_time <= std_logic_vector(to_unsigned(secs_passed, timer_time'length));
    end if;
  end process;
end behavioral;
