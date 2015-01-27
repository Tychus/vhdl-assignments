library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity stack_testbench is
end stack_testbench;

architecture behavioral OF stack_testbench is
  component stack
    port (
      reset     :in std_logic;
      clock     :in std_logic;
      push      :in std_logic;
      pop       :in std_logic;
      stack_in  :in std_logic_vector (15 downto 0);
      empty     :out std_logic;
      full      :out std_logic;
      stack_out :out std_logic_vector (15 downto 0)
    );
  end component;

  signal reset_tb: std_logic;
  signal clock_tb: std_logic;
  signal stack_in_tb: std_logic_vector (15 downto 0);
  signal push_tb: std_logic;
  signal pop_tb: std_logic;
  signal stack_out_tb: std_logic_vector (15 downto 0);
  signal empty_tb: std_logic;
  signal full_tb: std_logic;

  constant clock_period : time := 20 ns;
begin
  stack_dut: stack
    port map(
      stack_in => stack_in_tb,
      clock => clock_tb,
      reset => reset_tb,
      push => push_tb,
      pop => pop_tb,
      stack_out => stack_out_tb,
      empty => empty_tb,
      full => full_tb
    );


  clock_generator: process
  begin
    clock_tb <= '0';
    wait for clock_period / 2;
    clock_tb <= '1';
    wait for clock_period / 2;
  end process;

  testing: process
  begin
    reset_tb <= '1';
    wait for 20 ns;
    reset_tb <= '0';

    stack_in_tb <= "0000000000000000";
    push_tb <= '1';
    pop_tb <= '0';
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000001";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000010";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000011";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000100";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000101";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000110";
    wait for 20 ns;

    push_tb <= '0';
    wait for 20 ns;

    push_tb <= '1';
    stack_in_tb <= "0000000000000111";
    wait for 20 ns;

    push_tb <= '0';
    wait for 50 ns;

    pop_tb <= '1';
    wait for 20 ns;

    pop_tb <= '0';
    wait for 20 ns;

    pop_tb <= '1';
    wait for 20 ns;

    pop_tb <= '0';
    wait for 20 ns;

    pop_tb <= '1';
    wait for 20 ns;

    pop_tb <= '0';
    wait for 20 ns;

    pop_tb <= '1';
    wait for 20 ns;

    pop_tb <= '0';
    wait for 20 ns;

    pop_tb <= '1';
    wait for 20 ns;

    pop_tb <= '0';
    wait for 20 ns;

    pop_tb <= '1';
    wait for 20 ns;

    wait;
  end process;
end behavioral;
