library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity stencil_engine is
  port (
    clock : in std_logic;
    input : in std_logic_vector;
    output : out std_logic_vector
  );
end entity stencil_engine;

architecture behavioural of stencil_engine is

  constant ALIVE: std_logic_vector(input'range) := (others => '1');
  constant DEAD: std_logic_vector(input'range) := (others => '0');

  type neighbourhood_t is array(0 to 8) of std_logic_vector(input'range);

  impure function popcnt (neighbours: neighbourhood_t) return natural is
    variable result : natural range 0 to neighbours'length := 0;
  begin
    for i in neighbours'range loop
      if neighbours(i) = ALIVE then
        result := result + 1;
      else
      end if;
    end loop;
    return result;
  end function popcnt;

  signal neighbourhood : neighbourhood_t := (others => "110000011");
  signal n: natural range 0 to 8 := 8; -- Start at 8; first cycle is wasted
  signal m: natural range 0 to 8 := 3; -- 'Middle' cell

begin
  SEQUENTIAL: process (clock)
  begin
    if rising_edge(clock) then
      neighbourhood(n) <= input;
      if n = neighbourhood'right then
        n <= 0;
      else
        n <= n + 1;
      end if;
      if m = neighbourhood'right then
        m <= 0;
      else
        m <= m + 1;
      end if;
    end if;
  end process;


  COMBINATORIAL: process(n)
    variable count: natural range 0 to neighbourhood'length;
  begin
      count := popcnt(neighbourhood);
      -- Update output; should this be combinatorial?
      if count = 3 then
        output <= ALIVE;
      elsif count = 4 then
        output <= neighbourhood(m);
      else 
        output <= DEAD;
      end if;
  end process;

end architecture behavioural;
