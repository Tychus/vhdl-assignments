library ieee;
use ieee.std_logic_1164.all;

-- tesbenches have no entity
entity mux_2_1_testbench is
end mux_2_1_testbench;

architecture behavioral of mux_2_1_testbench is
  component mux_2_1
    port(
      input_0  :in std_logic;
      input_1  :in std_logic;
      selector :in std_logic;
      result   :out std_logic
    );
  end component;

  -- this vector will contain all input values for MUX:
  -- input 1, input 2 and selector
  signal test_input_vector: std_logic_vector(2 downto 0);
  signal test_result: std_logic;
begin
  mux_2_1_unit: mux_2_1 port map(
    input_0  => test_input_vector(2),
    input_1  => test_input_vector(1),
    selector => test_input_vector(0),
    result   => test_result
  );

  testing: process
  begin
    test_input_vector <= "000";
    wait for 10 ns;
    test_input_vector <= "001";
    wait for 10 ns;
    test_input_vector <= "010";
    wait for 10 ns;
    test_input_vector <= "011";
    wait for 10 ns;
    test_input_vector <= "100";
    wait for 10 ns;
    test_input_vector <= "101";
    wait for 10 ns;
    test_input_vector <= "110";
    wait for 10 ns;
    test_input_vector <= "111";
    wait;
  end process;
end behavioral;
