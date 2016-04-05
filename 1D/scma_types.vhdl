library ieee;
use ieee.std_logic_1164.all;

package scma_types is
  type direction_t is (NORTH, SOUTH);
  type operation_t is (INFLOW, OUTFLOW);
end package scma_types;
