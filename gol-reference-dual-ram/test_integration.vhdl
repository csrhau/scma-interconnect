library ieee;
use ieee.std_logic_1164.all;

entity test_integration is
end test_integration;

architecture behavioural  of test_integration is

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


  -- Seq signals
  signal reset : std_logic;
  signal step_complete : std_logic;

  -- Ram signals
  signal write_enable_a, write_enable_b : std_logic;
  signal address_a : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal address_b : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal data_in_a, data_in_b  : std_logic_vector(7 downto 0);
  signal data_out_a, data_out_b : std_logic_vector(7 downto 0);

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

begin

  clock <= not clock after period/2 when finished='0';

  seq : sequencer generic map (8, 8, 1)
                  port map (clock, reset, step_complete, step_complete, address_a, address_b);

  -- From a to b
  memory_a : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, write_enable_a, address_a, data_in_a, data_out_a);

  memory_b : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, write_enable_b, address_b, data_in_b, data_out_b);



  STIMULUS: process
  begin
    data_in_a <= (others => '0');
    reset <= '1';
    wait for period;
    reset <= '0';
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;
    wait for 3 *  period;






    finished <= '1';
    wait;
  end process STIMULUS;

  RESPONSE: process
  begin
    wait;
  end process RESPONSE; 

end behavioural;
