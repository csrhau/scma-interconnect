library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stencil_engine is
  port (
    clock : in std_logic;
    input : in std_logic_vector;
    output : out std_logic_vector
  );
end entity stencil_engine;

architecture behavioural of stencil_engine is
  type neighbourhood_t is array(0 to 8) of std_logic_vector(input'range);
  signal neighbourhood : neighbourhood_t := (others => (others => '0')); 
  signal n: natural range 0 to 8 := 0;

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
    end if;
  end process;

end architecture behavioural;
