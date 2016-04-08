library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_errors is
end entity test_errors;

architecture behavioural of test_errors is
  component resequencer is
    port (
      clock         : in std_logic;
      enable        : out std_logic := '0';
      up_fifo_push  : out std_logic := '0';
      up_fifo_pop   : out std_logic := '0';
      down_fifo_push: out std_logic := '0';
      down_fifo_pop : out std_logic := '0';
      address       : out std_logic_vector(9 downto 0)
    );
  end component resequencer;

  component FIFO is 
    generic (
      addr_bits: natural := 5;
      capacity : natural := 32
    );
    port (
      clock   : in std_logic;
      push    : in std_logic;      -- Enable data write
      pop     : in std_logic;       -- Enable data read if possible (push takes priority)
      input   : in std_logic_vector(7 downto 0); -- Data in 
      output  : out std_logic_vector(7 downto 0); -- Data out
      full    : out std_logic;
      empty   : out std_logic
     );
  end component FIFO;

  signal clock, enable, up_fifo_push, up_fifo_pop, fifo_full, fifo_empty : std_logic;
  signal address : std_logic_vector(9 downto 0);
  signal n_out_fifo_output : std_logic_vector(7 downto 0);

  signal down_fifo_push, down_fifo_pop : std_logic;

begin


  RESEQ: resequencer port map (clock, enable,
                              up_fifo_push, up_fifo_pop,
                              down_fifo_push, down_fifo_pop,
                              address);



  N_OUT_FIFO : FIFO generic map (5, 32)  
                    port map (clock,
                              push   => up_fifo_push,
                              pop    => up_fifo_pop,
                              input  => "11111111",
                              output => n_out_fifo_output,
                              full   => fifo_full,
                              empty  => fifo_empty);


  process
  begin
    for i in 0 to 128 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    wait;
  end process;
end architecture behavioural;
