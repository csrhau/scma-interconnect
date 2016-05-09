library ieee;
use ieee.std_logic_1164.all;

entity test_stencil_engine_glider is
end test_stencil_engine_glider;


architecture behavioural of test_stencil_engine_glider is
  component stencil_engine is
    port (
      clock : in std_logic;
      enable: in std_logic;
      input : in std_logic_vector;
      result : out std_logic_vector 
    );
  end component stencil_engine;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

  signal enable : std_logic := '0';
  signal input : std_logic_vector(7 downto 0);
  signal result: std_logic_vector(7 downto 0);

  constant ALIVE: std_logic_vector(input'range) := (others => '1');
  constant DEAD: std_logic_vector(input'range) := (others => '0');

begin
  clock <= not clock after period/2 when finished='0';
  BUFF: stencil_engine port map (clock, enable, input, result);

  STIMULUS: process
  begin
    enable <= '1';

    -- COL 1
    -- 0,0 - 0,2
    input <= DEAD; wait for 3 * period;

    -- 1,0 - 1,2
    input <= DEAD; wait for 2 * period;
    input <= ALIVE; wait for 1 * period;

    -- 2,0 - 2,2
    input <= DEAD; wait for 3 * period;

    -- 3,0 - 3,2
    input <= DEAD; wait for 1 * period;
    input <= ALIVE; wait for 2 * period;

    -- 4,0 - 7,2
    input <= DEAD; wait for 12 * period;

    -- COL 2
    -- 0,1 - 0,3
    input <= DEAD; wait for 3 * period;

    -- 1,1 - 1,3
    input <= DEAD; wait for 1 * period;
    input <= ALIVE; wait for 1 * period;
    input <= DEAD; wait for 1 * period;

    -- 2,1 - 2,3
    input <= DEAD; wait for 2 * period;
    input <= ALIVE; wait for 1 * period;

    -- 3,1 - 3,3
    input <= ALIVE; wait for 3 * period;

    -- 4,1 - 7,3
    input <= DEAD; wait for 12 * period;

    -- COL 3
    -- 0,2 - 0,4
    input <= DEAD; wait for 3 * period;

    -- 1,2 - 1,4
    input <= ALIVE; wait for 1 * period;
    input <= DEAD; wait for 2 * period;

    -- 2,2 - 2,4
    input <= DEAD; wait for 1 * period;
    input <= ALIVE; wait for 1 * period;
    input <= DEAD; wait for 1 * period;

    -- 3,2 - 3,4
    input <= ALIVE; wait for 2 * period;
    input <= DEAD; wait for 1 * period;

    -- 4,2 - 7,4
    input <= DEAD; wait for 12 * period;

    -- COL 4
    -- 0,3 - 0,5
    input <= DEAD; wait for 3 * period;

    -- 1,3 - 1,5
    input <= DEAD; wait for 3 * period;

    -- 2,3 - 2,5
    input <= ALIVE; wait for 1 * period;
    input <= DEAD; wait for 2 * period;
  
    -- 3,3 - 3,5
    input <= ALIVE; wait for 1 * period;
    input <= DEAD; wait for 2 * period;

    -- 4,3 - 7,5
    input <= DEAD; wait for 12 * period;

    -- COL 5
    input <= DEAD; wait for 24 * period;

    -- COL 6
    input <= DEAD; wait for 24 * period;

    finished <= '1';
    wait;
  end process STIMULUS;


  RESPONSE: process
  begin
    -- COL 1
    wait for 9 * period;
    assert result = DEAD report "1,1 should be dead" severity error; 
    wait for 3 * period;
    assert result = ALIVE report "2,1 should be alive" severity error; 
    wait for 3 * period;
    assert result = DEAD report "3,1 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "4,1 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "5,1 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "6,1 should be dead" severity error; 

    -- COL 2
    wait for 9 * period;
    assert result = DEAD report "1,2 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "2,2 should be dead" severity error; 
    wait for 3 * period;
    assert result = ALIVE report "3,2 should be alive" severity error; 
    wait for 3 * period;
    assert result = ALIVE report "4,2 should be alive" severity error; 
    wait for 3 * period;
    assert result = DEAD report "5,2 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "6,2 should be dead" severity error; 

    -- COL 3
    wait for 9 * period;
    assert result = DEAD report "1,3 should be dead" severity error; 
    wait for 3 * period;
    assert result = ALIVE report "2,3 should be alive" severity error; 
    wait for 3 * period;
    assert result = ALIVE report "3,3 should be alive" severity error; 
    wait for 3 * period;
    assert result = DEAD report "4,3 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "5,3 should be dead" severity error; 
    wait for 3 * period;
    assert result = DEAD report "6,3 should be dead" severity error; 

    wait;
  end process RESPONSE;
end behavioural;
