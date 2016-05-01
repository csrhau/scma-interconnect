library ieee;
use ieee.std_logic_1164.all;

entity test_stencil_engine is 
end test_stencil_engine;


architecture behavioural of test_stencil_engine is

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

  process
  begin

    -- TIMING TEST
    enable <= '1';
    input <= ALIVE;

    wait for period;
    assert result = DEAD
      report "System should be dead with one live neighbour" severity error;

    wait for period;
    assert result = DEAD
      report "System should be dead with two live neighbours" severity error;

    wait for period;
    assert result = ALIVE
      report "System should be alive with three live neighbours" severity error;

    -- PURGE
    input <= DEAD;
    wait for 17 * period;

    -- 0 0 0 0 0 0 0 0 0 : 0 => dead
    assert result = DEAD report "0 life => death" severity error;

    -- 1 0 0 0 0 0 0 0 0 : 1 => dead
    input <= ALIVE;
    wait for period;
    assert result = DEAD report "1 life => death" severity error;

    -- 0 1 0 0 0 0 0 0 0 : 1 => dead
    input <= DEAD;
    wait for period;
    assert result = DEAD report "1 life => death" severity error;

    -- 1 0 1 0 0 0 0 0 0 : 2 => dead 
    input <= ALIVE;
    wait for period;
    assert result = DEAD report "2 life => death" severity error;

    -- 1 1 0 1 0 0 0 0 0 : 3 => alive
    input <= ALIVE;
    wait for period;
    assert result = ALIVE report "3 life => life" severity error;

    -- 1 1 1 0 1 0 0 0 0 : 4 => central; central => alive
    input <= ALIVE;
    wait for period;
    assert result = ALIVE report "4 life => central; central => alive" severity error;

    -- 0 1 1 1 0 1 0 0 0 : 4 => central; central => dead
    input <= DEAD;
    wait for period;
    assert result = DEAD report "4 life => central; central => dead" severity error;

    -- 1 0 1 1 1 0 1 0 0 : 5 => dead
    input <= ALIVE;
    wait for period;
    assert result = DEAD report "5 life => dead" severity error;

    -- 1 1 0 1 1 1 0 1 0 : 6 => dead
    input <= ALIVE;
    wait for period;
    assert result = DEAD report "6 life => dead" severity error;

    -- 1 1 1 0 1 1 1 0 1 : 7 => dead
    input <= ALIVE;
    wait for period;
    assert result = DEAD report "7 life => dead" severity error;

    finished <= '1';
    wait;
  end process;
end behavioural;
