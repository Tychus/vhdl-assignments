library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tally_testbench is
end tally_testbench;

architecture behavioral of tally_testbench is
  signal test_scores_a, test_scores_b: std_logic_vector(2 downto 0);
  signal test_winner: std_logic_vector(1 downto 0);
  signal clk: std_logic := '0';

  signal control_winner: std_logic_vector(1 downto 0);
begin
  tally_dut: entity work.tally(loopy)
    port map(
      scores_a => test_scores_a,
      scores_b => test_scores_b,
      winner   => test_winner,
      clock    => clk
    );

  testing: process
  begin
    for i in 0 to 7 loop
      test_scores_a <= std_logic_vector(to_unsigned(i, 3));

      for j in 0 to 7 loop
        test_scores_b <= std_logic_vector(to_unsigned(j, 3));

        clk <= not clk;
        wait for 10 ns;
        clk <= not clk;
        wait for 10 ns;
      end loop;
    end loop;

    wait;
  end process;

  verification: process(clk)
    variable temp_a, temp_b: integer;
  begin
    if rising_edge(clk) then
      temp_a := 0;
      temp_b := 0;

      for t in 2 downto 0 loop
        if test_scores_a(t) = '1' then
          temp_a := temp_a + 1;
        end if;

        if test_scores_b(t) = '1' then
          temp_b := temp_b + 1;
        end if;
      end loop;

      if temp_a > temp_b then
        control_winner <= "01";
      elsif temp_a < temp_b then
        control_winner <= "10";
      elsif temp_a = temp_b then
        control_winner <= "11";
      else
        control_winner <= "00";
      end if;
    end if;
  end process;
end behavioral;
