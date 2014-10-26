library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tally is
  port (
    clock              :in  std_logic;
    scores_a, scores_b :in  std_logic_vector(2 downto 0);
    winner             :out std_logic_vector(1 downto 0)
  );
end tally;

architecture loopy of tally is
begin
  count: process(clock)
    variable total_a, total_b: integer;
  begin
    if rising_edge(clock) then
      total_a := 0;
      total_b := 0;

      counter: for i in 2 downto 0 loop
        if scores_a(i) = '1' then
          total_a := total_a + 1;
        end if;

        if scores_b(i) = '1' then
          total_b := total_b + 1;
        end if;
      end loop;

      if total_a = total_b then
        winner <= "11";
      elsif total_a < total_b then
        winner <= "10";
      elsif total_a > total_b then
        winner <= "01";
      else
        winner <= "00";
      end if;
    end if;
  end process;
end loopy;
