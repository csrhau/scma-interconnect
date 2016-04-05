library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_sequencer is
end test_sequencer;

architecture behavioural of test_sequencer is
  component sequencer is
    port (
      clock: in std_logic;
      address : out std_logic_vector(9 downto 0);
      direction : out direction_t;
      operation : out operation_t
    );
  end component sequencer;

  signal clock : std_logic;
  signal address : std_logic_vector(9 downto 0);
  signal direction : direction_t;
  signal operation : operation_t;

begin

  SEQ : sequencer port map(clock, address, direction, operation);

  process
    -- Helper procedures
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    wait for 1 ns;

    -- NORTH_OUTFLOW
    assert direction = NORTH
      report "North outflow direction should be NORTH" severity error;
    assert operation = OUTFLOW
      report "North outflow operation should be OUTFLOW" severity error;
    assert to_integer(unsigned(address)) = 32
      report "First read should come from cell 0, row 1 (cell 32)" severity error;
    for i in 1 to 31 loop
      CYCLE;
      assert direction = NORTH
        report "North outflow direction should be NORTH" severity error;
      assert operation = OUTFLOW
        report "North outflow operation should be OUTFLOW" severity error;
      assert to_integer(unsigned(address)) = (32 + i)
        report "read should come from correct cell" severity error;
    end loop;
    -- SOUTH_OUTFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert direction = SOUTH
        report "South outflow direction should be SOUTH" severity error;
      assert operation = OUTFLOW
        report "South outflow operation should be OUTFLOW" severity error;
      assert to_integer(unsigned(address)) = (30 * 32 + i)
        report "read should come from correct cell" severity error;
    end loop;
    -- NORTH_INFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert direction = NORTH
        report "North inflow direction should be NORTH" severity error;
      assert operation = INFLOW
        report "North inflow operation should be INFLOW" severity error;
      assert to_integer(unsigned(address)) = i
        report "Write should go to correct cell" severity error;
    end loop;
    -- SOUTH_INFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert direction = SOUTH
        report "South inflow direction should be SOUTH" severity error;
      assert operation = INFLOW
        report "South inflow operation should be INFLOW" severity error;
      assert to_integer(unsigned(address)) = (31 * 32 + i) 
        report "Write should go to correct cell" severity error;
    end loop;
    -- Back to start
    CYCLE;

    wait;
  end process;
end behavioural;
