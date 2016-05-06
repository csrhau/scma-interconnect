library ieee;
use ieee.std_logic_1164.all;
use work.scma_types.all;

entity PE is 
  generic (
    pe_contents : memory_t
  );
  port (
    clock         : in std_logic;
    enable        : in std_logic;
    up_fifo_pop   : in std_logic;
    down_fifo_pop : in std_logic;
    address       : in std_logic_vector(9 downto 0);
    up_input      : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
    down_input    : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
    output        : out std_logic_vector(7 downto 0) := (others => '0')
  );
end entity PE; 

architecture mixed of PE is
  component RAM is 
    generic (
      contents : memory_t
    );        
    port (
      clock : in std_logic;
      write_enable : in std_logic; 
      address : in std_logic_vector(9 downto 0);
      data_in : in std_logic_vector(7 downto 0);
      data_out : out std_logic_vector(7 downto 0)
    );
  end component RAM;

  signal ram_write_enable : std_logic := '0';
  signal ram_data_in : std_logic_vector(7 downto 0);

begin
  STORAGE: RAM generic map(contents => pe_contents) 
               port map(clock, ram_write_enable, address, ram_data_in, output);

  SEQUENTIAL: process (clock)
  begin
    if rising_edge(clock) then
      if up_fifo_pop = '1' then
        ram_data_in <= up_input;
        ram_write_enable <= enable;
      elsif down_fifo_pop = '1' then
        ram_data_in <= down_input;
        ram_write_enable <= enable;
      else
        ram_data_in <= (others => '0');
        ram_write_enable <= '0';
      end if;
    end if;
  end process SEQUENTIAL;

end architecture mixed;
