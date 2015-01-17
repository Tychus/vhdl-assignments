library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light_controller_testbench is
end traffic_light_controller_testbench;

architecture behavioral OF traffic_light_controller_testbench is
  component traffic_light_controller
    port (
      t_clock       :in std_logic;
      t_reset       :in std_logic;
      t_blink       :in std_logic;
      t_hw_sensor_1 :in std_logic;
      t_hw_sensor_2 :in std_logic;
      t_fr_sensor_1 :in std_logic;
      t_fr_sensor_2 :in std_logic;
      t_fr_light    :out std_logic_vector(2 downto 0);
      t_hw_light    :out std_logic_vector(2 downto 0)
    );
  end component;

  signal reset_r       :std_logic;
  signal clock_r       :std_logic;
  signal blink_r       :std_logic;
  signal hw_sensor_1_r :std_logic;
  signal hw_sensor_2_r :std_logic;
  signal fr_sensor_1_r :std_logic;
  signal fr_sensor_2_r :std_logic;
  signal fr_light_r    :std_logic_vector(2 downto 0);
  signal hw_light_r    :std_logic_vector(2 downto 0);

  signal finish_simulation :boolean := false;
  constant clock_period    :time := 1 ms;
begin
  traffic_light_controller_dut:  traffic_light_controller
    port map(
      t_reset => reset_r,
      t_clock => clock_r,
      t_blink => blink_r,
      t_hw_sensor_1 => hw_sensor_1_r,
      t_hw_sensor_2 => hw_sensor_2_r,
      t_fr_sensor_1 => fr_sensor_1_r,
      t_fr_sensor_2 => fr_sensor_2_r,
      t_fr_light => fr_light_r,
      t_hw_light => hw_light_r
    );

  clock_generator: process
  begin
    clock_r <= '0';
    loop
      wait for clock_period / 2;
      clock_r <= not clock_r;
      exit when finish_simulation = true;
    end loop;
    wait;
  end process;

  testing: process
  begin
    reset_r <= '1';
    blink_r <= '0';
    hw_sensor_1_r <= '0';
    hw_sensor_2_r <= '0';
    fr_sensor_1_r <= '1';
    fr_sensor_2_r <= '0';
    wait until clock_r'event and clock_r = '1';
    reset_r <= '0';

    wait for 70 sec;

    reset_r <= '1';
    blink_r <= '1';
    hw_sensor_1_r <= '0';
    hw_sensor_2_r <= '0';
    fr_sensor_1_r <= '1';
    fr_sensor_2_r <= '0';
    wait until clock_r'event and clock_r = '1';
    reset_r <= '0';

    wait for 10 sec;

    finish_simulation <= true;
  end process;
end behavioral;
