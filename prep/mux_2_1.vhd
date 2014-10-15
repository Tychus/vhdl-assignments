library ieee;
use ieee.std_logic_1164.all;

entity mux_2_1 is
  port (
    input_0  :in std_logic;
    input_1  :in std_logic;
    selector :in std_logic;
    result   :out std_logic);
end mux_2_1;

architecture dataflow of mux_2_1 is
  signal inverted_selector, nand_0, nand_1: std_logic;
begin
  -- Invert selector signal using NAND
  inverted_selector <= selector nand selector;

  nand_0 <= inverted_selector nand input_0;
  nand_1 <= selector nand input_1;

  result <= nand_0 nand nand_1;
end dataflow;

architecture structural of mux_2_1 is
  signal internal_0, internal_1: std_logic;

  component a_nand_b
    port(
      input_0 :in std_logic;
      input_1 :in std_logic;
      result  :out std_logic
    );
  end component;

  component not_a_nand_b
    port(
      input_0 :in std_logic;
      input_1 :in std_logic;
      result  :out std_logic
    );
  end component;
begin
  unit_0: a_nand_b port map(
    input_0 => selector,
    input_1 => input_0,
    result  => internal_0
  );

  unit_1: not_a_nand_b port map(
    input_0 => selector,
    input_1 => input_1,
    result => internal_1
  );

  unit_2: a_nand_b port map(
    input_0 => internal_0,
    input_1 => internal_1,
    result => result
  );
end architecture;

architecture behavioral of mux_2_1 is
begin
  mux_2_1_process: process(input_0, input_1, selector)
  begin
    if selector = '0' then
      result <= input_0;
    else
      result <= input_1;
    end if;
  end process mux_2_1_process;
end behavioral;
