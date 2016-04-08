library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_sequencer_fifo_integration is
end test_sequencer_fifo_integration;

architecture behavioural of test_sequencer_fifo_integration is 

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


  signal clock, enable : std_logic;
  signal up_fifo_push, up_fifo_pop : std_logic;
  signal up_fifo_full, up_fifo_empty : std_logic;
  signal up_fifo_input, up_fifo_output : std_logic_vector(7 downto 0);
  signal down_fifo_push, down_fifo_pop : std_logic;
  signal down_fifo_full, down_fifo_empty : std_logic;
  signal down_fifo_input, down_fifo_output : std_logic_vector(7 downto 0);
  signal address : std_logic_vector(9 downto 0);


begin

  SEQU: sequencer port map(clock, enable, 
                           up_fifo_push, up_fifo_pop,
                           down_fifo_push, down_fifo_pop,
                           address);

  UP_FIFO: FIFO generic map(5, 32)
                port map (clock, 
                          up_fifo_push, up_fifo_pop,
                          up_fifo_input, up_fifo_output,
                          up_fifo_full, up_fifo_empty);
 DOWN_FIFO: FIFO generic map(5, 32)
                 port map (clock, 
                           down_fifo_push, down_fifo_pop,
                           down_fifo_input, down_fifo_output,
                           down_fifo_full, down_fifo_empty);

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


    assert enable = '0'
      report "Should start disabled" severity error;
    CYCLE;
    assert enable = '1'
      report "Should now be enabled" severity error;
    assert address = std_logic_vector(to_unsigned(32, address'length))
      report "Should be scheduling a read from value 32" severity error;
    assert up_fifo_push = '0'
      report "Should still be waiting for value 32 here" severity error; -- Read col 0
    assert up_fifo_empty = '1'
      report "Should not have added to fifo yet" severity error;

    CYCLE;
    -- Read complete
    up_fifo_input <= std_logic_vector(to_unsigned(32, up_fifo_input'length));
    assert up_fifo_push = '1'
      report "Should schedule a push for value 32 into fifo" severity error;

    assert address = std_logic_vector(to_unsigned(33, address'length))
      report "Should be scheduling a read from value 33" severity error;

    assert up_fifo_empty = '1'
      report "Should not have added to fifo yet" severity error;

    CYCLE;
    up_fifo_input <= std_logic_vector(to_unsigned(33, up_fifo_input'length));

    assert up_fifo_push = '1'
      report "Should schedule a push for value 33 into fifo" severity error;

    assert up_fifo_empty = '0' and up_fifo_full = '0'
      report "First read (32) should have made it to the fifo by now" severity error;

    up_fifo_input <= "11110000";
    down_fifo_input <= "00001111";

    for i in 0 to 512 loop
      CYCLE;
    end loop;

    wait;
  end process;
end architecture behavioural;
