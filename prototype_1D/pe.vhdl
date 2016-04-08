library ieee;
use ieee.std_logic_1164.all;
use work.scma_types.all;

entity PE is 
  generic (
    pe_contents : memory_t
  );
  port (
    clock: in std_logic;
    enable: in std_logic;
    seq_address : in std_logic_vector(9 downto 0);
    seq_orientation :in orientation_t;
    seq_operation : in  operation_t;
    north_input : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
    south_input : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
    output : out std_logic_vector(7 downto 0)        -- The output to both fifos (gets switched by sequencer)
  );
end entity PE; 
architecture structural of PE is

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

  signal ram_write_enable : std_logic;
  signal ram_data_in : std_logic_vector(7 downto 0);

begin

  STORAGE: RAM generic map(contents => pe_contents) 
              port map(clock, ram_write_enable, seq_address, ram_data_in, output);

  ram_write_enable <= '1' when seq_operation = INFLOW and enable = '1' else '0';
  ram_data_in <= north_input when seq_orientation = NORTH else south_input;

end architecture structural;
