library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity traffic_controller is
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
    fr_light     :out std_logic_vector(2 downto 0);
    hw_light     :out std_logic_vector(2 downto 0)
  );
end traffic_controller;

architecture behavioral of traffic_controller is
  type t_light_color is (blank, red, yellow, red_yellow, green);
  type m_state is (gr, rg, yr_to_rr, yr_to_gr, ry_to_rr, ry_to_rg, rr_to_yr, rr_to_ry, blink_y, blink_b);

  signal current_state  :m_state;
  signal next_state     :m_state;
  signal fr_light_color :t_light_color;
  signal hw_light_color :t_light_color;
begin
  get_next_state: process(clock, reset)
    variable current_time :integer;
  begin
    current_time := to_integer(unsigned(timer_time));

    if reset = '1' then
      next_state <= gr;
      timer_reset <= '1';
    end if;

    if clock'event and clock = '1' then
      if blink = '1' then
        if current_state = blink_y then
          if current_time > 1 then
            next_state <= blink_b;
            timer_reset <= '1';
          else
            timer_reset <= '0';
          end if;
        else
          if current_time > 1 then
            next_state <= blink_y;
            timer_reset <= '1';
          else
            timer_reset <= '0';
          end if;
        end if;
      else
        case current_state is
        when blink_y =>
          next_state <= gr;
          timer_reset <= '1';
        when blink_b =>
          next_state <= gr;
          timer_reset <= '1';
        when gr =>
          if current_time > 30 and (fr_sensor_1 = '1' or fr_sensor_2 = '1') then
            next_state <= yr_to_rr;
            timer_reset <= '1';
          else
            timer_reset <= '0';
          end if;
        when yr_to_rr =>
          if (current_time > 2) then
            next_state <= rr_to_ry;
            timer_reset <= '1';
          else
            timer_reset <= '0';
          end if;
        when rr_to_ry =>
          if current_time > 2 then
            next_state <= ry_to_rg;
            timer_reset <= '1';
          else
            -- hw_light_color := red;
            -- fr_light_color := red;
            timer_reset <= '0';
          end if;
        when ry_to_rg =>
          if current_time > 2 then
            next_state <= rg;
            timer_reset <= '1';
          else
            -- hw_light_color := red;
            -- fr_light_color := yellow;
            timer_reset <= '0';
          end if;
        when rg =>
          if current_time > 10 and (hw_sensor_1 = '1' or hw_sensor_2 = '1') then
            next_state <= ry_to_rr;
            timer_reset <= '1';
          else
            -- hw_light_color := red;
            -- fr_light_color := green;
            timer_reset <= '0';
          end if;
        when ry_to_rr =>
          if current_time > 2 then
            next_state <= rr_to_yr;
            timer_reset <= '1';
          else
            -- hw_light_color := red;
            -- fr_light_color := yellow;
            timer_reset <= '0';
          end if;
        when rr_to_yr =>
          if current_time > 2 then
            next_state <= yr_to_gr;
            timer_reset <= '1';
          else
            -- hw_light_color := red;
            -- fr_light_color := red;
            timer_reset <= '0';
          end if;
        when yr_to_gr =>
          if current_time > 2 then
            next_state <= gr;
            timer_reset <= '1';
          else
            -- hw_light_color := yellow;
            -- fr_light_color := red;
            timer_reset <= '0';
          end if;
        end case;
      end if;
    end if;
  end process;

  get_current_state: process(clock, reset)
  begin
    if reset = '1' then
      current_state <= gr;
    end if;

    if clock'event and clock = '1' then
      current_state <= next_state;

      case current_state is
        -- [r,y,g]
        when gr =>
          hw_light_color <= green;
          fr_light_color <= red;
        when yr_to_rr =>
          hw_light_color <= yellow;
          fr_light_color <= red;
        when rr_to_ry =>
          hw_light_color <= red;
          fr_light_color <= red;
        when ry_to_rg =>
          hw_light_color <= red;
          fr_light_color <= red_yellow;
        when rg =>
          hw_light_color <= red;
          fr_light_color <= green;
        when ry_to_rr =>
          hw_light_color <= red;
          fr_light_color <= yellow;
        when rr_to_yr =>
          hw_light_color <= red;
          fr_light_color <= red;
        when yr_to_gr =>
          hw_light_color <= red_yellow;
          fr_light_color <= red;
        when blink_y =>
          hw_light_color <= yellow;
          fr_light_color <= yellow;
        when blink_b =>
          hw_light_color <= blank;
          fr_light_color <= blank;
      end case;
    end if;
  end process;

  get_hw_lights: process(clock)
  begin
    if clock'event and clock = '1' then
      case hw_light_color is
      when red =>
        hw_light <= "100";
      when red_yellow =>
        hw_light <= "110";
      when yellow =>
        hw_light <= "010";
      when green =>
        hw_light <= "001";
      when blank =>
        hw_light <= "000";
      end case;
    end if;
  end process;

  get_fr_lights: process(clock)
  begin
    if clock'event and clock = '1' then
      case fr_light_color is
      when red =>
        fr_light <= "100";
      when red_yellow =>
        fr_light <= "110";
      when yellow =>
        fr_light <= "010";
      when green =>
        fr_light <= "001";
      when blank =>
        fr_light <= "000";
      end case;
    end if;
  end process;
end behavioral;
