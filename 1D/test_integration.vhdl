library ieee;
use ieee.std_logic_1164.all;
use work.scma_types.all;

entity test_integration is
end entity test_integration;

architecture behavioural of test_integration is
  component sequencer is
    port (
      clock: in std_logic;
      address : out std_logic_vector(9 downto 0);
      direction : out direction_t;
      operation : out operation_t
    );
  end component sequencer;
  
  component RAM is 
    port (
      clock : in std_logic;
      write_enable : in std_logic; 
      address : in std_logic_vector(9 downto 0);
      data_in : in std_logic_vector(7 downto 0);
      data_out : out std_logic_vector(7 downto 0)
    );
  end component RAM;

  component FIFO is 
    generic (
      addr_bits: natural := 5
    );
    port (
      clock   : in std_logic;
      push : in std_logic;      -- Enable data write
      pop : in std_logic;       -- Enable data read if possible (push takes priority)
      input   : in std_logic_vector(7 downto 0); -- Data in 
      output  : out std_logic_vector(7 downto 0); -- Data out
      full    : out std_logic;
      empty   : out std_logic
     );
  end component fifo;


begin
  process
  begin
    wait;
  end process;
end architecture behavioural;
