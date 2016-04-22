library ieee;
use ieee.std_logic_1164.all;

entity test_integration is
end test_integration;

architecture behavioural of test_integration is

  component stencil_engine is
    port (
      clock : in std_logic;
      input : in std_logic_vector;
      output : out std_logic_vector
    );
  end component stencil_engine;

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

  component RAM is
    generic (
      filename: string
    );
    port (
      clock : in std_logic;
      write_enable : in std_logic;
      address : in std_logic_vector;
      data_in : in std_logic_vector;
      data_out : out std_logic_vector
    );
  end component RAM;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';
  signal write_enable : std_logic := '0';

  signal expected_output : std_logic := '0';


  signal ram_to_engine : std_logic_vector(7 downto 0);
  signal engine_to_ram : std_logic_vector(7 downto 0);

  signal address : std_logic_vector(5 downto 0);

  type board_state is array(0 to 7, 0 to 7) of integer range 0 to 1;
  constant GLIDER_0: board_state := ((0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 1, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 1, 0, 0, 0, 0),
                                     (0, 1, 1, 1, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0));
  constant GLIDER_1: board_state := ((0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 1, 0, 1, 0, 0, 0, 0),
                                     (0, 0, 1, 1, 0, 0, 0, 0),
                                     (0, 0, 1, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0),
                                     (0, 0, 0, 0, 0, 0, 0, 0));

begin
  clock <= not clock after period/2 when finished='0';

  MEMORY : RAM generic map (filename => "glider_8x8.mif")
               port map (clock, write_enable, address, engine_to_ram, ram_to_engine);

  SEQ : sequencer generic map (8, 8)
                  port map(clock, address);

  ENGINE: stencil_engine port map(clock, ram_to_engine, engine_to_ram);

  process
  begin
    wait for 1 ns;

    assert address = "000000" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "001000" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "010000" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "000001" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "001001" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "010001" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "000010" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "001010" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "11111111" report "Should be alive"  severity error;

    assert address = "010010" report "Incorrect address" severity error;
    wait for period; -- Here we start seeing valid output
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,1 should be dead" severity error;

    assert address = "000011" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "001011" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;

    assert address = "010011" report "Incorrect address" severity error;
    wait for period;
    assert ram_to_engine = "11111111" report "Should be alive"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,2 should be dead" severity error;


    wait for 3 * period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,3 should be dead" severity error;

    wait for 3 * period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,4 should be dead" severity error;

    wait for 3 * period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,5 should be dead" severity error;

    wait for 3 * period;
    assert ram_to_engine = "00000000" report "Should be dead"  severity error;
    assert engine_to_ram = "00000000" report "t1_1,6 should be dead" severity error;

    assert address = "001000" report "Incorrect address" severity error; -- 8
    wait for 3 * period;
    assert address = "001001" report "Incorrect address" severity error; -- 9
    wait for 3 * period;
    assert address = "001010" report "Incorrect address" severity error; -- 10
    wait for 2 * period;
    assert address = "011010" report "Incorrect address" severity error; -- 26
    wait for period;
    assert address = "001011" report "Incorrect address" severity error; -- 11
    assert ram_to_engine = "11111111" report "Should be alive" severity error;


    wait for period;
    expected_output <= '1';
    assert engine_to_ram = "11111111" report "t1_2,1 should be alive" severity error;





















    finished <= '1';
    wait;
  end process;
end behavioural;
