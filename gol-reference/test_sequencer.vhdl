library ieee;
use ieee.std_logic_1164.all;

entity test_sequencer is
end test_sequencer;

architecture behavioural of test_sequencer is

  component sequencer is
    generic (
      rows : natural;
      cols : natural
    );
    port (
      clock : in std_logic;
      address : out std_logic_vector
    );
  end component sequencer;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

  signal address : std_logic_vector(5 downto 0);

begin
  clock <= not clock after period/2 when finished='0';

  SEQ: sequencer generic map (8, 8)
                 port map(clock, address);

  process
  begin
    wait for 1 ns;

    -- Upper
    assert address = "000000"
      report "Should read address zero first" severity error;

    -- Center
    wait for period;
    assert address = "001000"
      report "Should read address eight second" severity error;

    -- Lower
    wait for period;
    assert address = "010000"
      report "Should read address sixteen third" severity error;



    -- Move along one column
    -- Upper
    wait for period;
    assert address = "000001" report "Incorrect address" severity error;
    wait for period;
    assert address = "001001" report "Incorrect address" severity error;
    wait for period;
    assert address = "010001" report "Incorrect address" severity error;


    -- Last slice on first row
    wait for 16*period;
    assert address = "000111" report "Incorrect address" severity error;
    wait for period;
    assert address = "001111" report "Incorrect address" severity error;
    wait for period;
    assert address = "010111" report "Incorrect address" severity error;

    -- First slice on second row
    wait for period;
    assert address = "001000" report "Incorrect address" severity error;
    wait for period;
    assert address = "010000" report "Incorrect address" severity error;
    wait for period;
    assert address = "011000" report "Incorrect address" severity error;

    wait for 22 * period; -- At the start of row 3

    assert address = "010000" report "Incorrect address" severity error;

    wait for 24 * period; -- Start of row 4
    wait for 24 * period; -- Start of row 5
    wait for 24 * period; -- Start of row 6 (final inner row)
    assert address = "101000" report "Incorrect address" severity error;
    wait for period;
    assert address = "110000" report "Incorrect address" severity error;
    wait for period;
    assert address = "111000" report "Incorrect address" severity error;

    wait for 22 * period; -- At the start of row 1 -- Loopback

    -- Upper
    assert address = "000000"
      report "Should read address zero first" severity error;

    -- Center
    wait for period;
    assert address = "001000"
      report "Should read address eight second" severity error;

    -- Lower
    wait for period;
    assert address = "010000"
      report "Should read address sixteen third" severity error;

    finished <= '1';
    wait;
  end process;

end behavioural;
