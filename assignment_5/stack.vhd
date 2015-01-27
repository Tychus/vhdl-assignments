library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity stack is
  generic(
    data_width :integer := 16;
    addr_width :integer := 3;
    max :std_logic_vector := "111"
  );

  port(
    reset     :in std_logic;
    clock     :in std_logic;
    push      :in std_logic;
    pop       :in std_logic;
    stack_in  :in std_logic_vector (data_width - 1 downto 0);
    empty     :out std_logic;
    full      :out std_logic;
    stack_out :out std_logic_vector (data_width - 1 downto 0)
  );
end entity;

architecture behavioral of stack is
  signal i           :std_logic := '0';
  signal j           :std_logic := '0';
  signal chip_select :std_logic := '0';
  signal address     :std_logic_vector(addr_width - 1 downto 0) := (others => '0');

  signal is_empty    :std_logic;
  signal is_full     :std_logic;

  component sp_ram
    generic(
      data_width :integer := 16;
      addr_width :integer := 3
    );

    port(
      cs      :in std_logic;
      rw      :in std_logic;
      oe      :in std_logic;
      clock   :in std_logic;
      address :in std_logic_vector(addr_width - 1 downto 0);
      data    :in std_logic_vector(data_width - 1 downto 0);
      dataout :out std_logic_vector(data_width - 1 downto 0)
    );
  end component;
begin
  sp_ram_controler: component sp_ram
    generic map(
      data_width => data_width,
      addr_width => addr_width
    )

    port map(
      address => address,
      data => stack_in,
      dataout => stack_out,
      cs => chip_select,
      rw => push,
      oe => pop,
      clock => clock
    );

  update: process(pop, push, reset)
  begin
    if reset = '1' then
      chip_select <= '1';
      address <= (others => '0');
    else
      if pop = '1' and is_empty /= '1' then
        address <= address - i;
        i <= '1';
        j <= '0';
      elsif push = '1' and is_full /= '1' then
        address <= address + j;
        i <= '0';
        j <= '1';
      end if;
    end if;
  end process;

  check_state: process(address)
  begin
    if address >= max then
      is_full <= '1';
    else
      is_full <= '0';
    end if;

    if address = 0 then
      is_empty <= '1';
    else
      is_empty <= '0';
    end if;

    full <= is_full;
    empty <= is_empty;

    if is_full = '1' or is_empty = '1' then
      chip_select <= '0';
    else
      chip_select <= '1';
    end if;
  end process;
end behavioral;
