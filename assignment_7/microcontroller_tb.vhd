library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity microcontroller_tb is
end microcontroller_tb;

architecture testbench of microcontroller_tb is
  component instruction_rom
    port(
      oe_bar: in std_logic;
      address: in std_logic_vector(7 downto 0);
      data_out: out std_logic_vector(16 downto 0)
    );
  end component;

  component microcontroller
    port(
      clk,reset : in std_logic;
      oe_bar: out std_logic; -- to read from the Instruction Memory
      address: out std_logic_vector(7 downto 0); -- It indicates the current instruction address
      instruction: in std_logic_vector(16 downto 0); -- It receives a 17-bit instruction
      input_port: in std_logic_vector(7 downto 0); -- input port to connect to peripheral devices
      output_port: out std_logic_vector(7 downto 0); -- output port to connect to peripheral devices
      port_id:out std_logic_vector(7 downto 0) -- It indicates the port address for export(EXP) operation.
    );
  end component;

  signal input_port, output_port, port_id :std_logic_vector(7 downto 0) :="ZZZZZZZZ";
  signal address_tb                       :std_logic_vector(7 downto 0) := "00000000";
  signal instruction_tb                   :std_logic_vector(16 downto 0);
  signal clk, reset, oe_bar_tb            :std_logic := '0';

begin
  instruction_rom_unit: instruction_rom
    port map(
      oe_bar => oe_bar_tb,
      address => address_tb,
      data_out => instruction_tb
    );

  microcontroller_unit: microcontroller
    port map(
      clk => clk,
      reset => reset,
      oe_bar => oe_bar_tb,
      address => address_tb,
      instruction => instruction_tb,
      input_port => input_port,
      output_port => output_port,
      port_id => port_id
    );

  clock_generator: process
  begin
     clk <= not clk;
     wait for 10 ns;
  end process;

  testing: process
  begin
     reset <= '1';
     wait for 2 ns;
     reset <= '0';
     wait;
  end process;
end testbench;
