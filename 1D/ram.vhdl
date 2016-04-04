library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is 
  port (
    clock : in std_logic;
    write_enable : in std_logic; 
    address : in std_logic_vector(9 downto 0);
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0)
  );
end entity RAM;

architecture behavioural of RAM is
  type memory is array(0 to 1023) of std_logic_vector(7 downto 0);
  signal storage : memory := (others => (others => '0'));
 begin

  process(clock)
  begin
    if rising_edge(clock) then
      data_out <= storage(to_integer(unsigned(address))); 
      if write_enable = '1' then
        storage(to_integer(unsigned(address))) <= data_in;
      end if;
    end if;
  end process;
end behavioural;
