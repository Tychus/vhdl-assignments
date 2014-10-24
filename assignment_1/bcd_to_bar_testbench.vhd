library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_to_bar_testbench is
end bcd_to_bar_testbench;

architecture behavioral of bcd_to_bar_testbench is
  signal bcd_test_vector:             std_logic_vector(3 downto 0);
  signal bargraph_test_vector:        std_logic_vector(8 downto 0);

  signal control_output:              std_logic;
  signal control_output_vector:       std_logic_vector(8 downto 0);
begin
  bcd_to_bar_dut: entity work.bcd_to_bar(selected_a)
    port map(
      bcd      => bcd_test_vector,
      bargraph => bargraph_test_vector
    );

  testing: process
    variable initial_output : std_logic_vector(8 downto 0) := "111111111";
  begin
    for counter in 0 to 15 loop
      bcd_test_vector <= std_logic_vector(to_unsigned(counter, 4));

      if counter > 0 and counter < 10 then
        -- Perform logical left shift 1 to 9 times
        control_output_vector <= std_logic_vector(unsigned(initial_output) sll counter);
      else
        -- If the input is "0000" or it's higher than "1001" the output would be all ones
        control_output_vector <= "111111111";
      end if;

      -- Check if IC's output is the same as generated control output
      if control_output_vector = bargraph_test_vector then
        control_output <= '1';
      else
        control_output <= '0';
      end if;

      wait for 10 ns;
    end loop;

    wait;
  end process;
end behavioral;
