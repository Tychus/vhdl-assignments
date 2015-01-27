library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity sp_ram is
  generic(
    data_width :integer := 16;
    addr_width :integer := 3
  );

  port(
    cs       :in std_logic;
    rw       :in std_logic;
    oe       :in std_logic;
    clock    :in std_logic;
    address  :in std_logic_vector (addr_width - 1 downto 0);
    data     :in std_logic_vector (data_width - 1 downto 0);
    dataout  :out std_logic_vector (data_width - 1 downto 0)
  );
end entity;

architecture behavioral of sp_ram is
  type memory is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector (data_width - 1 downto 0);
  signal ram: memory := ((others => (others => '0')));
  signal addr_reg :integer range 0 to 2 ** addr_width - 1;
begin
  main: process(oe,rw,clock)
  begin
    if clock = '1' and clock'event then
      if cs = '1' then
        if oe = '1' then
          dataout <= ram(to_integer(unsigned(address)));
        elsif (rw = '1' and oe = '0') then
          ram(to_integer(unsigned(address))) <= data;
        end if;
      end if;
    end if;
  end process;
end behavioral;
