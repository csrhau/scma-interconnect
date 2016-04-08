library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_sequencer_pe_integration is
end test_sequencer_pe_integration;

architecture behavioural of test_sequencer_pe_integration is 

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

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));

  signal clock, enable : std_logic;
  signal up_fifo_push, up_fifo_pop : std_logic;
  signal up_fifo_input, up_fifo_output : std_logic_vector(7 downto 0);
  signal down_fifo_push, down_fifo_pop : std_logic;
  signal pe_up_input, pe_down_input : std_logic_vector(7 downto 0);
  signal pe_output : std_logic_vector(7 downto 0);
  signal address : std_logic_vector(9 downto 0);

begin
  SEQU: sequencer port map(clock, enable, 
                           up_fifo_push, up_fifo_pop,
                           down_fifo_push, down_fifo_pop,
                           address);

  ELEMENT: PE generic map (pe_contents => input_deck)
              port map (clock, enable, up_fifo_pop, down_fifo_pop, address,
                         pe_up_input, pe_down_input, pe_output);

  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    clock <= '0';
    wait for 1 ns;
    assert enable = '0'
      report "Should now be disabled" severity error;
    CYCLE;
    assert enable = '1'
      report "Should now be enabled" severity error;
    wait;
  end process;
end architecture behavioural;
