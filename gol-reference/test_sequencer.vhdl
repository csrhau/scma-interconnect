library ieee;
use ieee.std_logic_1164.all;

entity test_sequencer is
end test_sequencer;

architecture behavioural of test_sequencer is

  component sequencer is
    generic (
      rows : natural;
      cols : natural;
      radius : natural -- Stencil radius (1 for a 3x3)
    );
    port (
      clock : in std_logic;
      reset : in std_logic;
      step_complete : out std_logic;
      write_enable : out std_logic;
      read_address : out std_logic_vector;
      write_address : out std_logic_vector
    );
  end component sequencer;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal reset : std_logic := '0';
  signal step_complete : std_logic;
  signal write_enable : std_logic;
  signal finished : std_logic := '0';

  signal read_address : std_logic_vector(5 downto 0);
  signal write_address : std_logic_vector(5 downto 0);

begin
  clock <= not clock after period/2 when finished='0';

  SEQ: sequencer generic map (8, 8, 1)
                 port map(clock, reset, step_complete, write_enable, read_address, write_address);

  STIMULUS: process
  begin
    reset <= '1';
    wait for period;
    reset <= '0';

    wait for 2 * 8 * 3 * period;
    reset <= '1';
    wait for period;
    reset <= '0';

    wait;
  end process STIMULUS;

  RESPONSE: process
  begin

    -- Row 0, cols 0,1,2
    wait for period; -- Reset
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "000000" report "Should read address 0" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "000001" report "Should read address 1" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "000010" report "Should read address 2" severity error;

    -- Row 1
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001000" report "Should read address 8" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001001" report "Should read address 9" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001010" report "Should read address 10" severity error;

     -- Row 2
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010000" report "Should read address 16" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010001" report "Should read address 17" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010010" report "Should read address 18" severity error;


     -- Row 3
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    -- Here we have filled our buffer, so expect a result on the next cycle
    assert read_address = "011000" report "Should read address 24" severity error;
    wait for period;
    assert write_enable = '1' report "First result should be written now" severity error;
    assert write_address = "001001" report "Result should be written to address 9" severity error;
    assert read_address = "011001" report "Should read address 25" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "011010" report "Should read address 26" severity error;

    -- Row 4
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "100000" report "Should read address 32" severity error;
    wait for period;
    assert write_enable = '1' report "First result should be written now" severity error;
    assert write_address = "010001" report "Result should be written to address 17" severity error;
    assert read_address = "100001" report "Should read address 33" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "100010" report "Should read address 34" severity error;


    -- Skip Row 5 - 6
    wait for 3 * period; -- 5: 40 41 42
    wait for 3 * period; -- 6: 48 49 50

    -- Row 7 - Last row
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "111000" report "Should read address 56" severity error;
    wait for period;
    assert write_enable = '1' report "result should be written now" severity error;
    assert write_address = "101001" report "Result should be written to address 41" severity error;
    assert read_address = "111001" report "Should read address 57" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "111010" report "Should read address 58" severity error;

    -- Row 0, Cols 1,2,3
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "000001" report "Should read address 1" severity error;
    wait for period;
    assert write_enable = '1' report "last result should be written now" severity error;
    assert write_address = "110001" report "Result should be written to address 49" severity error;
    assert read_address = "000010" report "Should read address 2" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "000011" report "Should read address 3" severity error;

    -- Row 1, cols 1,2,3
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001001" report "Should read address 9" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001010" report "Should read address 10" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "001011" report "Should read address 11" severity error;

    -- Row 2, cols 1,2,3
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010001" report "Should read address 17" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010010" report "Should read address 18" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "010011" report "Should read address 19" severity error;

    -- Row 3, cols 1,2,3
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "011001" report "Should read address 25" severity error;
    wait for period;
    assert write_enable = '1' report "result should be written now" severity error;
    assert write_address = "001010" report "Result should be written to address 10" severity error;
    assert read_address = "011010" report "Should read address 26" severity error;
    wait for period;
    assert write_enable = '0' report "No result should be written" severity error;
    assert read_address = "011011" report "Should read address 27" severity error;

    wait for 3 * period; -- Skip row 4
    wait for 3 * period; -- Skip row 5
    wait for 3 * period; -- Skip row 6

    -- Row 7, cols 1, 2, 3
    wait for period;
    assert read_address = "111001" report "Should read address 57" severity error;
    wait for period;
    assert read_address = "111010" report "Should read address 58" severity error;
    wait for period;
    assert read_address = "111011" report "Should read address 59" severity error;

    wait for period;

    -- Reset triggers
    wait for period; -- Reset
    assert read_address = "000000" report "Should read address 0 after reset" severity error;


    for i in integer range 0 to 6 * 8 * 3 - 2 loop
      wait for period;
      assert step_complete = '0' report "Step should not have completed" severity error;
    end loop;

    wait for 2 *  period;
    assert step_complete = '1' report "Step should have completed" severity error;

    -- Test the complete thing works

    wait for 9 * 3 * period;
    finished <= '1';
    wait;
  end process RESPONSE; 

end behavioural;
