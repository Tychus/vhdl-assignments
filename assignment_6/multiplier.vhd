library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplier is
  generic (
    n: natural := 4;
    m: natural := 4
  );

  port(
    a      :in std_logic_vector(n - 1 downto 0);
    b      :in std_logic_vector(m - 1 downto 0);
    result :out std_logic_vector((n + m) - 1 downto 0)
  );
end multiplier;

architecture behavioral of multiplier is
  constant nn :integer := m - 1;
  constant np :integer := nn + 1;
  constant nm :integer := nn - 1;
  type arr is array (0 to np) of std_logic_vector((n - 1) downto 0);

  signal c : arr;
  signal s : arr;
  signal z : std_logic := '0';

component multiplier1b
  port(
    a,b:in std_logic;
    sin,cin:in std_logic;
    sum,carry: out std_logic

  );
end component;

begin
  --Centre
  for1:for i in 1 to nn generate
    for2:for j in 0 to (n-2) generate
      multt:multiplier1b port map(a=>a(j),b=>b(i),sin=>c(i-1)(j),cin=>s(i-1)(j+1),sum=>s(i)(j),carry=>c(i)(j));
    end generate for2;
  end generate for1;

  --Top row
  for3: for j in 0 to (n-1) generate
    multy:multiplier1b port map(a=>a(j),b=>b(0),sin=>z,cin=>z,sum=>s(0)(j),carry=>c(0)(j));
  end generate for3;

  --left col
  for4: for i in 1 to nn generate
    mult0:multiplier1b port map(a=>a(n-1),b=>b(i),sin=>c(i-1)(n-1),cin=>z,sum=>s(i)(n-1),carry=>c(i)(n-1));
  end generate for4;

  --bottorm row
  mult1:multiplier1b port map(a=>'0',b=>'1',sin=>c(nn)(0),cin=>s(nn)(1),sum=>s(np)(0),carry=>c(np)(0));

  for5: for j in 1 to (n-2) generate
    mult3: multiplier1b port map(a=>c(np)(j-1),b=>'1',sin=>c(nn)(j),cin=>s(nn)(j+1),sum=>s(np)(j),carry=>c(np)(j));
  end generate for5;

  mult2:multiplier1b port map(a=>c(np)(n-2),b=>'1',sin=>c(nn)(n-1),cin=>z,sum=>s(np)(n-1),carry=>c(np)(n-1));

  for6: for i in 0 to nn generate
    res1: result(i)<= s(i)(0);
  end generate for6;

  for7: for i in 0 to (n - 1) generate
    res2: result(i + np) <= s(np)(i);
  end generate for7;
end behavioral;
