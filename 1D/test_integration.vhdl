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
      enable        : out std_logic;
      up_fifo_push  : out std_logic;
      up_fifo_pop   : out std_logic;
      down_fifo_push: out std_logic;
      down_fifo_pop : out std_logic;
      address       : out std_logic_vector(9 downto 0)
    );
  end component sequencer;

  component PE is 
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
  end component PE; 

  component FIFO is 
    generic (
      addr_bits: natural;
      capacity : natural
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

  type PE_PORTS is array(0 to 2) of std_logic_vector(7 downto 0); 
  subtype FIFO_SIGNALS is std_logic_vector(5 downto 0); 
  -- GLOBAL signals
  signal clock : std_logic := '0';
  signal enable : std_logic := '0';
  signal up_fifo_push  : std_logic := '0';
  signal up_fifo_pop   : std_logic := '0';
  signal down_fifo_push: std_logic := '0';
  signal down_fifo_pop : std_logic := '0';
  signal address       : std_logic_vector(9 downto 0) := (others => '0');

  signal pe_down_inputs : PE_PORTS := (others => (others => '0'));
  signal pe_up_inputs : PE_PORTS := (others => (others => '0'));
  signal pe_outputs : PE_PORTS := (others => (others => '0'));

  signal full_signals : FIFO_SIGNALS := (others => '0');
  signal empty_signals : FIFO_SIGNALS := (others => '1');


begin
  SEQ : sequencer port map (clock, enable, up_fifo_push, up_fifo_pop, down_fifo_push, down_fifo_pop, address);

  PE_0: PE generic map (pe_contents => ( others => "00000000"))
           port map (
             clock, enable, up_fifo_pop, down_fifo_pop, address,
             pe_up_inputs(0), pe_down_inputs(0), pe_outputs(0)
           );
 
  PE_1: PE generic map (pe_contents => ( others => "00000001"))
           port map (
             clock, enable, up_fifo_pop, down_fifo_pop, address,
             pe_up_inputs(1), pe_down_inputs(1), pe_outputs(1)
           );

  PE_2: PE generic map (pe_contents => ( others => "00000010"))
           port map (
             clock, enable, up_fifo_pop, down_fifo_pop, address,
             pe_up_inputs(2), pe_down_inputs(2), pe_outputs(2)
           );
 
  FIFO_0_DOWN : FIFO generic map (5, 32)
                port map (
                  clock, down_fifo_push, down_fifo_pop,
                  pe_outputs(0), pe_down_inputs(1),
                  full_signals(0), empty_signals(0)
                );

  FIFO_1_DOWN : FIFO generic map (5, 32)
                port map (
                  clock, down_fifo_push, down_fifo_pop,
                  pe_outputs(1), pe_down_inputs(2),
                  full_signals(1), empty_signals(1)
                );

  FIFO_2_DOWN : FIFO generic map (5, 32)
                port map (
                  clock, down_fifo_push, down_fifo_pop,
                  pe_outputs(2), pe_down_inputs(0),
                  full_signals(2), empty_signals(2)
                );

   FIFO_3_UP : FIFO generic map (5, 32)
              port map (
                clock, up_fifo_push, up_fifo_pop,
                pe_outputs(1), pe_up_inputs(0),
                full_signals(3), empty_signals(3)
              );

  FIFO_4_UP : FIFO generic map (5, 32)
              port map (
                clock, up_fifo_push, up_fifo_pop,
                pe_outputs(2), pe_up_inputs(1),
                full_signals(4), empty_signals(4)
              );

  FIFO_5_UP : FIFO generic map (5, 32)
              port map (
                clock, up_fifo_push, up_fifo_pop,
                pe_outputs(0), pe_up_inputs(2),
                full_signals(5), empty_signals(5)
              );
  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;
    wait;
  end process;
end architecture behavioural;
