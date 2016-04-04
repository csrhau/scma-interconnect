library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_sequencer is
end test_sequencer;

architecture behavioural of test_sequencer is
  component sequencer is
    port (
      clock: in std_logic;
      address : out std_logic_vector(9 downto 0);
      write_enable : out std_logic
    );
  end component sequencer;

  signal clock : std_logic;
  signal address : std_logic_vector(9 downto 0);
  signal write_enable: std_logic;

begin

  SEQ : sequencer port map(clock, address, write_enable);

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
    assert write_enable = '0'
      report "write should be disabled initially" severity error;
    assert to_integer(unsigned(address)) = 32
      report "First read should come from cell 0, row 1 (cell 32)" severity error;
    for i in 1 to 31 loop
      CYCLE;
      assert write_enable = '0'
        report "Write should not be enabled during NORTH OUTFLOW" severity error;
      assert to_integer(unsigned(address)) = (32 + i)
        report "read should come from correct cell" severity error;
    end loop;
    -- SOUTH_OUTFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert write_enable = '0'
        report "Write should not be enabled during SOUTH OUTFLOW" severity error;
      assert to_integer(unsigned(address)) = (30 * 32 + i)
        report "read should come from correct cell" severity error;
    end loop;
    -- NORTH_INFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert write_enable = '1'
        report "Write should be enabled during NORTH INFLOW" severity error;
      assert to_integer(unsigned(address)) = i
        report "Write should go to correct cell" severity error;
    end loop;
    -- SOUTH_INFLOW
    for i in 0 to 31 loop
      CYCLE;
      assert write_enable = '1'
        report "Write should be enabled during SOUTH INFLOW" severity error;
      assert to_integer(unsigned(address)) = (31 * 32 + i) 
        report "Write should go to correct cell" severity error;
    end loop;
    -- Back to start
    CYCLE;
    assert write_enable = '0'
      report "Write should not be enabled during NORTH OUTFLOW" severity error;

    wait;
  end process;
end behavioural;
