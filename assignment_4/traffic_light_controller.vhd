library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity traffic_light_controller is
  port(
    t_reset       :in std_logic;
    t_clock       :in std_logic;
    t_blink       :in std_logic;
    t_hw_sensor_1 :in std_logic;
    t_hw_sensor_2 :in std_logic;
    t_fr_sensor_1 :in std_logic;
    t_fr_sensor_2 :in std_logic;
    t_fr_light    :out std_logic_vector(2 downto 0);
    t_hw_light    :out std_logic_vector(2 downto 0)
);
end entity;

architecture behavioral of traffic_light_controller is
  component timer
    port(
      timer_reset :in std_logic;
      timer_clock :in std_logic;
      timer_time  :out std_logic_vector (5 downto 0)
    );
  end component;

  component traffic_controller
    port(
      reset       :in std_logic;
      clock       :in std_logic;
      blink       :in std_logic;
      hw_sensor_1 :in std_logic;
      hw_sensor_2 :in std_logic;
      fr_sensor_1 :in std_logic;
      fr_sensor_2 :in std_logic;
      timer_time  :in std_logic_vector(5 downto 0);
      timer_reset :out std_logic;
      fr_light    :out std_logic_vector(2 downto 0);
      hw_light    :out std_logic_vector(2 downto 0)
    );
  end component;

  signal temp_reset :std_logic;
  signal temp_time  :std_logic_vector (5 downto 0);
begin
  timer_controller_unit: component timer
    port map(
      timer_clock => t_clock,
      timer_reset => temp_reset,
      timer_time => temp_time
    );

  traffic_controller_unit: component traffic_controller
     port map(
        reset => t_reset,
        clock => t_clock,
        blink => t_blink,
        hw_sensor_1 => t_hw_sensor_1,
        hw_sensor_2 => t_hw_sensor_2,
        fr_sensor_1 => t_fr_sensor_1,
        fr_sensor_2 => t_fr_sensor_2,
        timer_time => temp_time,
        timer_reset => temp_reset,
        fr_light =>   t_fr_light,
        hw_light =>   t_hw_light
     );

end behavioral;
