library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_bar is
  port(
    bcd      :in  std_logic_vector(3 downto 0);
    bargraph :out std_logic_vector(8 downto 0)
  );
end bcd_to_bar;

architecture selected_a of bcd_to_bar is
begin
  with bcd select
  bargraph <= "111111111" when "0000",
              "111111110" when "0001",
              "111111100" when "0010",
              "111111000" when "0011",
              "111110000" when "0100",
              "111100000" when "0101",
              "111000000" when "0110",
              "110000000" when "0111",
              "100000000" when "1000",
              "000000000" when "1001",
              "111111111" when others;
end selected_a;

architecture selected_b of bcd_to_bar is
begin
  with bcd select
  bargraph <= "111111111" when "0000",
              "111111110" when "0001",
              "111111100" when "0010",
              "111111000" when "0011",
              "111110000" when "0100",
              "111100000" when "0101",
              "111000000" when "0110",
              "110000000" when "0111",
              "100000000" when "1000",
              "000000000" when "1001",
              "---------" when others;
end selected_b;

architecture conditional_a of bcd_to_bar is
begin
  bargraph <= "111111111" when bcd = "0000" else
              "111111110" when bcd = "0001" else
              "111111100" when bcd = "0010" else
              "111111000" when bcd = "0011" else
              "111110000" when bcd = "0100" else
              "111100000" when bcd = "0101" else
              "111000000" when bcd = "0110" else
              "110000000" when bcd = "0111" else
              "100000000" when bcd = "1000" else
              "000000000" when bcd = "1001" else
              "111111111";
end conditional_a;

architecture conditional_b of bcd_to_bar is
begin
  bargraph <= "111111111" when bcd = "0000" else
              "111111110" when bcd = "0001" else
              "111111100" when bcd = "0010" else
              "111111000" when bcd = "0011" else
              "111110000" when bcd = "0100" else
              "111100000" when bcd = "0101" else
              "111000000" when bcd = "0110" else
              "110000000" when bcd = "0111" else
              "100000000" when bcd = "1000" else
              "000000000" when bcd = "1001" else
              "---------";
end conditional_b;
