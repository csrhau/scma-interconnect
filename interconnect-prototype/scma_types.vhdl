library ieee;
use ieee.std_logic_1164.all;

package scma_types is
  type memory_t is array(0 to 1023) of std_logic_vector(7 downto 0);
end package scma_types;
