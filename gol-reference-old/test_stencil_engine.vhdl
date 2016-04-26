library ieee;
use ieee.std_logic_1164.all;

entity test_stencil_engine is
end test_stencil_engine;

architecture behavioural of test_stencil_engine is
  component stencil_engine is
    port (
      clock : in std_logic;
      input : in std_logic_vector;
      output : out std_logic_vector
    );
  end component stencil_engine;

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

  signal debug_flag : std_logic := '0';

  signal ram_to_engine : std_logic_vector(7 downto 0);
  signal engine_to_ram : std_logic_vector(7 downto 0);

begin
  clock <= not clock after period/2 when finished='0';

  ENGINE: stencil_engine port map(clock, ram_to_engine, engine_to_ram);
  process
  begin
    wait for period;

    -- Timing test
    ram_to_engine <= "00000000";
    wait for 9 * period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 0 life cells
    ram_to_engine <= "11111111";
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 1 life cells; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 2 life cells; lags input
    wait for period;
    assert engine_to_ram = "11111111" report "incorrect"; -- based on 3 life cells; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 4 life cells; non centered; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 5 life cells; non centered; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 6 life cells; non centered; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 7 life cells; non centered; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 8 life cells; non centered; lags input
    wait for period;
    assert engine_to_ram = "00000000" report "incorrect"; -- based on 9 life cells; non centered; lags input

    -- Timing test
    ram_to_engine <= "00000000";
    wait for 27 * period;


    -- 0 0 0 0 0 0 0 0 0 : 0 => dead
    assert engine_to_ram = "00000000" report "0 life => death" severity error;

    -- 1 0 0 0 0 0 0 0 0 : 1 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "1 life => death" severity error; 

    -- 0 1 0 0 0 0 0 0 0 : 1 => dead
    ram_to_engine <= "00000000";
    wait for period; 
    assert engine_to_ram = "00000000" report "1 life => death" severity error; 

    -- 1 0 1 0 0 0 0 0 0 : 2 => dead 
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "2 life => death" severity error; 

    -- 1 1 0 1 0 0 0 0 0 : 3 => alive
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "11111111" report "3 life => life" severity error; 

    -- 1 1 1 0 1 0 0 0 0 : 4 => central; central => alive
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "11111111" report "4 life => central, central => life" severity error; 

    -- 0 1 1 1 0 1 0 0 0 : 4 => central; central => dead

    ram_to_engine <= "00000000";
    wait for period; 
    debug_flag <= '1';
    assert engine_to_ram = "00000000" report "4 life => central, central => death" severity error;

    -- 1 0 1 1 1 0 1 0 0 : 5 => dead
    
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "5 life => death" severity error;

    -- 1 1 0 1 1 1 0 1 0 : 6 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "6 life => death" severity error;

    -- 1 1 1 0 1 1 1 0 1 : 7 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "7 life => death" severity error;

    -- 1 1 1 1 0 1 1 1 0 : 7 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "7 life => death" severity error;

    -- 1 1 1 1 0 1 1 1 0 : 7 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "7 life => death" severity error;

    -- 1 1 1 1 1 0 1 1 1 : 8 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "8 life => death" severity error;

    -- 1 1 1 1 1 1 0 1 1 : 8 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "8 life => death" severity error;

    -- 1 1 1 1 1 1 1 0 1 : 8 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "8 life => death" severity error;

    -- 1 1 1 1 1 1 1 1 0 : 8 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "8 life => death" severity error;

    -- 1 1 1 1 1 1 1 1 1 : 9 => dead
    ram_to_engine <= "11111111";
    wait for period; 
    assert engine_to_ram = "00000000" report "9 life => death" severity error;


   finished <= '1';
    wait;
  end process;
end behavioural;
