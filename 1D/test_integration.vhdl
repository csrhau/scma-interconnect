library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
  
  component PE is 
    generic (
      pe_contents : memory_t := (others => (others => '0'))
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
  end component PE;

  component FIFO is 
    generic (
      addr_bits: natural := 5;
      capacity : natural := 32
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
  end component FIFO;

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));

  -- GLOBAL
  signal clock  : std_logic;
  signal enable : std_logic := '1'; -- Start enabled!

  -- PE
  signal seq_address     : std_logic_vector(9 downto 0);
  signal seq_orientation : orientation_t;
  signal seq_operation   : operation_t;
  signal pe_north_input     : std_logic_vector(7 downto 0);
  signal pe_south_input     : std_logic_vector(7 downto 0);
  signal pe_output          : std_logic_vector(7 downto 0);

  -- Remaining FIFO Data Ports
  signal n_in_fifo_input, n_out_fifo_output : std_logic_vector(7 downto 0);
  signal s_in_fifo_input, s_out_fifo_output : std_logic_vector(7 downto 0);

  -- FIFO Status ports
  signal n_in_fifo_full, n_in_fifo_empty : std_logic;
  signal n_out_fifo_full, n_out_fifo_empty : std_logic;
  signal s_in_fifo_full, s_in_fifo_empty : std_logic;
  signal s_out_fifo_full, s_out_fifo_empty : std_logic;

  -- Fifo control signals
  signal down_fifo_push, down_fifo_pop : std_logic;
  signal up_fifo_push, up_fifo_pop : std_logic;

begin
  SEQ : sequencer port map(clock, enable, seq_address, seq_orientation, seq_operation);
  ELEMENT : PE generic map (pe_contents => input_deck) 
               port map (clock, enable, seq_address, seq_orientation,
                         seq_operation, pe_north_input, pe_south_input, pe_output);
  N_IN_FIFO  : FIFO port map (clock, 
                              push   => down_fifo_push,
                              pop    => down_fifo_pop,
                              input  => n_in_fifo_input,
                              output => pe_north_input,
                              full   => n_in_fifo_full,
                              empty  => n_in_fifo_empty);

  N_OUT_FIFO : FIFO port map (clock,
                              push   => up_fifo_push,
                              pop    => up_fifo_pop,
                              input  => pe_output,
                              output => n_out_fifo_output,
                              full   => n_out_fifo_full,
                              empty  => n_out_fifo_empty);

  S_IN_FIFO  : FIFO port map (clock,
                              push   => up_fifo_push,
                              pop    => up_fifo_pop,
                              input  => s_in_fifo_input,
                              output => pe_south_input,
                              full   => s_in_fifo_full,
                              empty  => s_in_fifo_empty);

  S_OUT_FIFO : FIFO port map (clock,
                              push   => down_fifo_push,
                              pop    => down_fifo_pop,
                              input  => pe_output,
                              output => s_out_fifo_output,
                              full   => s_out_fifo_full,
                              empty  => s_out_fifo_empty);

  down_fifo_pop  <= '1' when seq_orientation = NORTH and seq_operation = INFLOW and enable = '1' else '0';
  down_fifo_push <= '1' when seq_orientation = SOUTH and seq_operation = OUTFLOW and enable = '1' else '0';
  up_fifo_pop  <= '1' when seq_orientation = SOUTH and seq_operation = INFLOW and enable = '1' else '0';
  up_fifo_push <= '1' when seq_orientation = NORTH and seq_operation = OUTFLOW and enable = '1' else '0';

  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    wait for 1 ns;

    -- NORTH OUTFLOW (Flow out upwards from top)
    for i in 0 to 31 loop
      -- Dummy Inputs
      s_in_fifo_input <= std_logic_vector(to_unsigned(i, s_in_fifo_input'length));
      assert seq_orientation = NORTH and seq_operation = OUTFLOW
        report "System should be in NORTH OUTFLOW STATE on iteration " & integer'image(i)
        severity error;
        CYCLE;
    end loop;

    -- Upwards tubes filled, Downwards tubes empty
    assert n_out_fifo_full = '1' and n_out_fifo_empty = '0'
      report "After north outflow, the north output fifo should be full" severity error;
    assert s_out_fifo_full = '0' and s_out_fifo_empty = '1'
      report "After north outflow, the south output fifo should be empty" severity error;
    assert s_in_fifo_full = '1' and s_in_fifo_empty = '0'
      report "Test rig should have filled in dummy upwards fifo" severity error;
    assert n_in_fifo_full = '0' and n_in_fifo_empty = '1'
      report "Test rig should not have filled in dummy downwards fifo" severity error;

    -- SOUTH OUTFLOW (Flow out downwards from base)
    for i in 0 to 31 loop
      -- Dummy Inputs
      n_in_fifo_input <= std_logic_vector(to_unsigned(i, n_in_fifo_input'length));
      assert seq_orientation = SOUTH and seq_operation = OUTFLOW
        report "System should be in SOUTH OUTFLOW STATE on iteration " & integer'image(32 + i)
        severity error;
        CYCLE;
    end loop;

    -- All tubes filled here!
    assert n_out_fifo_full = '1' and n_out_fifo_empty = '0'
      report "After south outflow, the north output fifo should be full" severity error;
    assert s_out_fifo_full = '1' and s_out_fifo_empty = '0'
      report "After south outflow, the south output fifo should be empty" severity error;
    assert s_in_fifo_full = '1' and s_in_fifo_empty = '0'
      report "Test rig should have filled in dummy upwards fifo" severity error;
    assert n_in_fifo_full = '1' and n_in_fifo_empty = '0'
      report "Test rig should not have filled in dummy downwards fifo" severity error;

    -- NORTH INFLOW (Flow in downwards from top)
    for i in 0 to 31 loop
      assert seq_orientation = NORTH and seq_operation = INFLOW
        report "System should be in NORTH INFLOW STATE on iteration " & integer'image(64 + i)
        severity error;
        CYCLE;
    end loop;
    -- Downwards tubes empty
    assert n_out_fifo_full = '1' and n_out_fifo_empty = '0'
      report "After north inflow, the north output fifo should be full" severity error;
    assert s_out_fifo_full = '0' and s_out_fifo_empty = '1'
      report "After north inflow, the south output fifo should be empty" severity error;
    assert s_in_fifo_full = '1' and s_in_fifo_empty = '0'
      report "After north inflow, dummy upwards fifo should be full" severity error;
    assert n_in_fifo_full = '0' and n_in_fifo_empty = '1'
      report "After north inflow, dummy downwards fifo should be full" severity error;

    -- SOUTH INFLOW (Flow in upwards from base)
    for i in 0 to 31 loop
      assert seq_orientation = SOUTH and seq_operation = INFLOW
        report "System should be in SOUTH INFLOW STATE on iteration " & integer'image(96 + i)
        severity error;
        CYCLE;
    end loop;
    -- Downwards tubes empty
    assert n_out_fifo_full = '0' and n_out_fifo_empty = '1'
      report "After south inflow, the north output fifo should be full" severity error;
    assert s_out_fifo_full = '0' and s_out_fifo_empty = '1'
      report "After south inflow, the south output fifo should be empty" severity error;
    assert s_in_fifo_full = '0' and s_in_fifo_empty = '1'
      report "After south inflow, dummy upwards fifo should be full" severity error;
    assert n_in_fifo_full = '0' and n_in_fifo_empty = '1'
      report "After south inflow, dummy downwards fifo should be full" severity error;




    wait;
  end process;
end architecture behavioural;
