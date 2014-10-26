library ieee;
use ieee.std_logic_1164.all;

entity universal_counter_testbench is
end universal_counter_testbench;

architecture behavioral of universal_counter_testbench is
  signal test_mode:   std_logic;
  signal test_reset:  std_logic;
  signal test_enable: std_logic;
  signal test_load:   std_logic;
  signal test_data:   std_logic_vector(3 downto 0);
  signal test_clock:  std_logic := '0';

  signal test_counter: std_logic_vector(3 downto 0);
  signal test_over:    std_logic;
begin
  universal_counter_dut: entity work.universal_counter
    port map(
      downup => test_mode,
      reset  => test_reset,
      enable => test_enable,
      load   => test_load,
      data   => test_data,
      clock  => test_clock,

      count  => test_counter,
      over   => test_over
    );

  testing: process
  begin
    -- test that it's adding and overflowing properly
    test_reset <= '1';
    test_mode <= '0';
    test_clock <= not test_clock;
    wait for 10 ns;
    test_clock <= not test_clock;
    wait for 10 ns;
    test_reset <= '0';

    test_enable <= '1';
    test_loop_1: for i in 0 to 16 loop
      test_clock <= not test_clock;
      wait for 10 ns;
      test_clock <= not test_clock;
      wait for 10 ns;
    end loop;

    -- test that it's not doing anything when disabled
    test_reset <= '1';
    test_clock <= not test_clock;
    wait for 10 ns;
    test_clock <= not test_clock;
    wait for 10 ns;
    test_reset <= '0';

    test_enable <= '0';
    test_loop_2: for i in 0 to 5 loop
      test_clock <= not test_clock;
      wait for 10 ns;
      test_clock <= not test_clock;
      wait for 10 ns;
    end loop;

    -- test that it's subtracting and overflowing properly
    test_reset <= '1';
    test_mode <= '1';
    test_clock <= not test_clock;
    wait for 10 ns;
    test_clock <= not test_clock;
    wait for 10 ns;
    test_reset <= '0';

    test_enable <= '1';
    test_loop_3: for i in 0 to 16 loop
      test_clock <= not test_clock;
      wait for 10 ns;
      test_clock <= not test_clock;
      wait for 10 ns;
    end loop;

    -- test that it's loading data and counting properly
    test_reset <= '1';
    test_mode <= '0';
    test_clock <= not test_clock;
    wait for 10 ns;
    test_clock <= not test_clock;
    wait for 10 ns;
    test_reset <= '0';

    test_load <= '1';
    test_data <= "1100";
    test_clock <= not test_clock;
    wait for 10 ns;
    test_clock <= not test_clock;
    wait for 10 ns;
    test_load <= '0';

    test_enable <= '1';
    test_loop_4: for i in 0 to 5 loop
      test_clock <= not test_clock;
      wait for 10 ns;
      test_clock <= not test_clock;
      wait for 10 ns;
    end loop;

    wait;
  end process;
end behavioral;
