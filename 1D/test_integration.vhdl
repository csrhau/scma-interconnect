library ieee;
use ieee.std_logic_1164.all;
use work.scma_types.all;

entity test_integration is
end entity test_integration;

architecture behavioural of test_integration is
  component sequencer is
    port (
      clock: in std_logic;
      enable : in std_logic;
      address : out std_logic_vector(9 downto 0);
      orientation : out orientation_t;
      operation : out operation_t
    );
  end component sequencer;
  
  component RAM is port (
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

  signal clock : std_logic;

  
  -- SEQUENCER
  signal seq_enable : std_logic;
  signal seq_address : std_logic_vector(9 downto 0);
  signal seq_orientation : orientation_t;
  signal seq_operation : operation_t;
   
  -- RAM 
  signal ram_write_enable : std_logic; 
  signal ram_address : std_logic_vector(9 downto 0); 
  signal ram_data_in : std_logic_vector(7 downto 0);
  signal ram_data_out : std_logic_vector(7 downto 0);

  -- FIFO push/pops
  signal down_fifo_push, down_fifo_pop : std_logic;
  signal up_fifo_push, up_fifo_pop : std_logic;

  -- FIFO statuses
  signal n_in_fifo_full, n_in_fifo_empty : std_logic;
  signal n_out_fifo_full, n_out_fifo_empty : std_logic;
  signal s_in_fifo_full, s_in_fifo_empty : std_logic;
  signal s_out_fifo_full, s_out_fifo_empty : std_logic;

  -- FIFO inputs/outputs
  signal n_in_fifo_input, n_in_fifo_output : std_logic_vector(7 downto 0);
  signal                  n_out_fifo_output : std_logic_vector(7 downto 0);
  signal s_in_fifo_input, s_in_fifo_output : std_logic_vector(7 downto 0);
  signal                  s_out_fifo_output : std_logic_vector(7 downto 0);

begin
  N_IN_FIFO : FIFO port map(clock, down_fifo_push, down_fifo_pop, n_in_fifo_input, n_in_fifo_output, n_in_fifo_full, n_in_fifo_empty);
  N_OUT_FIFO : FIFO port map(clock, up_fifo_push, up_fifo_pop, ram_data_out, n_out_fifo_output, n_out_fifo_full, n_out_fifo_empty);
  S_IN_FIFO : FIFO port map(clock, down_fifo_push, down_fifo_pop, s_in_fifo_input, s_in_fifo_output, s_in_fifo_full, s_in_fifo_empty);
  S_OUT_FIFO : FIFO port map(clock, up_fifo_push, up_fifo_pop, ram_data_out, s_out_fifo_output, s_out_fifo_full, s_out_fifo_empty);
  MEMORY : RAM port map(clock, ram_write_enable, ram_address, ram_data_in, ram_data_out);
  SEQ : sequencer port map(clock, seq_enable, seq_address, seq_orientation, seq_operation);

  down_fifo_pop  <= '1' when seq_orientation = NORTH and seq_operation = INFLOW and seq_enable = '1' else '0';
  down_fifo_push <= '1' when seq_orientation = SOUTH and seq_operation = OUTFLOW and seq_enable = '1' else '0';
  up_fifo_pop  <= '1' when seq_orientation = SOUTH and seq_operation = INFLOW and seq_enable = '1' else '0';
  up_fifo_push <= '1' when seq_orientation = NORTH and seq_operation = OUTFLOW and seq_enable = '1' else '0';

  -- RAM control signals
  -- Multiplexer
  ram_data_in <= n_in_fifo_output when seq_orientation = NORTH else s_in_fifo_output;
  ram_write_enable <= '1' when seq_operation = INFLOW else '0';

  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    -- NORTH OUTFLOW
    -- manually fill south in fifo
    s_in_fifo_input <= "10101010";
    for i in 0 to 31 loop
      CYCLE;
    end loop;
    assert s_in_fifo_full = '1'
      report "Manually filled FIFO should be filled" severity error;
    assert n_out_fifo_full = '1'
      report "The sequencer should have filled the north output fifo" severity error;

    wait;
  end process;
end architecture behavioural;
