library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_reintegration is
end entity test_reintegration;

architecture behavioural of test_reintegration is
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

  component rePE is 
    generic (
      pe_contents : memory_t
    );
    port (
      clock         : in std_logic;
      enable        : in std_logic;
      down_fifo_pop : in std_logic;
      up_fifo_pop   : in std_logic;
      address       : in std_logic_vector(9 downto 0);
      down_input    : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
      up_input      : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
      output        : out std_logic_vector(7 downto 0)
    );
  end component rePE; 

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));

  -- GLOBAL
  signal clock : std_logic;
  
  -- Sequencer
  signal enable  : std_logic := '0';
  signal up_fifo_push, up_fifo_pop  : std_logic := '0';
  signal down_fifo_push, down_fifo_pop  : std_logic := '0';
  signal address : std_logic_vector (9 downto 0)  := (others => '0');

  -- Remote (NON-PE) FIFO Endpoints
  signal n_in_fifo_input : std_logic_vector(7 downto 0) := (others => '0');
  signal n_out_fifo_output : std_logic_vector(7 downto 0) := (others => '0');
  signal s_in_fifo_input: std_logic_vector(7 downto 0) := (others => '0');
  signal s_out_fifo_output : std_logic_vector(7 downto 0) := (others => '0');

  -- PE FIFO Endpoints
  signal pe_down_input : std_logic_vector(7 downto 0) := (others => '0');
  signal pe_up_input   : std_logic_vector(7 downto 0) := (others => '0');
  signal pe_output     : std_logic_vector(7 downto 0) := (others => '0');

  -- FIFO Status ports
  signal n_in_fifo_full, n_in_fifo_empty : std_logic;
  signal n_out_fifo_full, n_out_fifo_empty : std_logic;
  signal s_in_fifo_full, s_in_fifo_empty : std_logic;
  signal s_out_fifo_full, s_out_fifo_empty : std_logic;


begin
  RESEQ: resequencer port map (clock, enable,
                              up_fifo_push, up_fifo_pop,
                              down_fifo_push, down_fifo_pop,
                              address);

  REPEL : rePE generic map (pe_contents => input_deck)
               port map (clock, enable, down_fifo_pop, up_fifo_pop, -- TODO, re-order
                        address, pe_down_input, pe_up_input, pe_output);
                              
  N_IN_FIFO  : FIFO generic map (5, 32) 
                    port map (clock, 
                              push   => down_fifo_push,
                              pop    => down_fifo_pop,
                              input  => n_in_fifo_input,
                              output => pe_down_input,
                              full   => n_in_fifo_full,
                              empty  => n_in_fifo_empty);

  N_OUT_FIFO : FIFO generic map (5, 32)  
                    port map (clock,
                              push   => up_fifo_push,
                              pop    => up_fifo_pop,
                              input  => pe_output,
                              output => n_out_fifo_output,
                              full   => n_out_fifo_full,
                              empty  => n_out_fifo_empty);

  S_IN_FIFO  : FIFO generic map (5, 32) 
                    port map (clock,
                              push   => up_fifo_push,
                              pop    => up_fifo_pop,
                              input  => s_in_fifo_input,
                              output => pe_up_input,
                              full   => s_in_fifo_full,
                              empty  => s_in_fifo_empty);

  S_OUT_FIFO : FIFO generic map (5, 32) 
                    port map (clock,
                              push   => down_fifo_push,
                              pop    => down_fifo_pop,
                              input  => pe_output,
                              output => s_out_fifo_output,
                              full   => s_out_fifo_full,
                              empty  => s_out_fifo_empty);



  process
  begin

    n_in_fifo_input <= "11000000";
    n_out_fifo_output <= "00110000";
    s_in_fifo_input <= "00001100";
    s_out_fifo_output  <= "00000011";

  -- PE FIFO Endpoints

    for i in 0 to 31 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    for i in 0 to 31 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    for i in 0 to 31 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;
    for i in 0 to 31 loop
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end loop;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;

    clock <= '0';
    wait for 1 ns;
    clock <= '1';
    wait for 1 ns;

   wait;
  end process;
end architecture behavioural;
