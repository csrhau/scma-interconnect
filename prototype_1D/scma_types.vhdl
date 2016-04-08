library ieee;
use ieee.std_logic_1164.all;

package scma_types is
  type orientation_t is (NORTH, SOUTH);
  type operation_t is (INFLOW, OUTFLOW);
  type memory_t is array(0 to 1023) of std_logic_vector(7 downto 0);
end package scma_types;
