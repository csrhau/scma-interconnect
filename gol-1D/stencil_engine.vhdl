library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- NB in practice the stencil buffer shouldn't expose all these values;
-- More commonly, the stencil buffer will be a stencil engine, and produce
-- A single result based on some f(tl, tc, tr... br)
-- This file exists to help understand and iron out offsets

entity stencil_engine is
  port (
    clock : in std_logic;
    enable: in std_logic;
    input : in std_logic_vector;
    result : out std_logic_vector 
  );
end entity stencil_engine;

architecture behavioural of stencil_engine is

  constant ADDR_BITS: natural := 4;
  constant DEAD: std_logic_vector(input'range) := (others => '0');
  constant ALIVE: std_logic_vector(input'range) := (others => '1');

  type direction_t is (NORTH_WEST, NORTH,  NORTH_EAST,
                       WEST,       CENTER,       EAST,
                       SOUTH_WEST, SOUTH,  SOUTH_EAST);
  type neighbourhood_t is array(integer range 0 to (2**ADDR_BITS-1)) of std_logic_vector(input'range);

  function offset_addr(address: std_logic_vector; direction: direction_t) return natural is
    variable offset : natural range 1 to 9;
  begin
    case direction is
      when NORTH_WEST => offset := 9;
      when NORTH      => offset := 8;
      when NORTH_EAST => offset := 7;
      when WEST       => offset := 6;
      when CENTER     => offset := 5;
      when EAST       => offset := 4;
      when SOUTH_WEST => offset := 3;
      when SOUTH      => offset := 2;
      when SOUTH_EAST => offset := 1;
    end case;
    return to_integer(unsigned(address) - offset);
  end function offset_addr;

  function popcnt (head: std_logic_vector; neighbourhood: neighbourhood_t) return natural is
    variable life_count : natural := 0;
  begin
      for dir in direction_t loop
        if neighbourhood(offset_addr(head, dir)) = ALIVE then
          life_count := life_count + 1;
        else
        end if;
      end loop;
      return life_count;
  end function popcnt;

  signal neighbourhood : neighbourhood_t := (others => (others => '0'));
  signal head : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');

begin
  SEQUENTIAL: process(clock)
  begin
    if rising_edge(clock) then
      if enable = '1' then
        neighbourhood(to_integer(unsigned(head))) <= input;
        head <= std_logic_vector(unsigned(head) + 1);
      end if;
    end if;
  end process;

  COMBI: process(head)
    variable life_count : natural := 0;
    variable outbuff : line;
  begin
    life_count := popcnt(head, neighbourhood);
    if life_count = 3 then
      result <= ALIVE;
    elsif life_count = 4 then
      result <= neighbourhood(offset_addr(head, CENTER));
    else 
      result <= DEAD;
    end if;
  end process COMBI;

end behavioural;
