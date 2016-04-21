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

  signal input : std_logic_vector(7 downto 0) := "10101010";
  signal output : std_logic_vector(7 downto 0);

  constant ALIVE : std_logic_vector(7 downto 0) := "00000001";
  constant DEAD  : std_logic_vector(7 downto 0) := "00000000";



begin
  clock <= not clock after period/2 when finished='0';

  process
  begin

    -- Glider:
    -- 0,0,0,0,0,0
    -- 0,0,1,0,0,0
    -- 0,0,0,1,0,0
    -- 0,1,1,1,0,0
    -- 0,0,0,0,0,0
    -- 0,0,0,0,0,0

    -- Glider input stream (glider_stream.mif)
    -- 000 000 010 001 000 000
    -- 000 001 101 011 000 000
    -- 000 010 010 110 000 000 
    -- 000 100 100 100 000 000




    finished <= '1';
    wait;
  end process;
end behavioural;
