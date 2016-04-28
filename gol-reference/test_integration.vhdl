library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

  component stencil_engine is
    port (
      clock : in std_logic;
      enable: in std_logic;
      input : in std_logic_vector;
      result : out std_logic_vector 
    );
  end component stencil_engine;


  -- Seq signals
  signal reset : std_logic;
  signal step_complete : std_logic;

  -- Ram signals
  signal write_enable_a, write_enable_b : std_logic;
  signal address_a : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal address_b : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal data_in_a, data_in_b  : std_logic_vector(7 downto 0);
  signal data_out_a, data_out_b : std_logic_vector(7 downto 0);

  -- Engine signals
  signal enable : std_logic;

  -- Clock signals
  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';

  -- Test signals, allows us to disconnect the `to' ram and poke around inside it
  signal test : std_logic := '0';
  signal test_address : std_logic_vector(5 downto 0);
  signal test_data : std_logic_vector(7 downto 0);
  signal address_b_meta : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal write_enable_b_meta : std_logic;

  signal test_write_enable: std_logic := '0';


begin

  clock <= not clock after period/2 when finished='0';
  enable <= not reset;
  address_b_meta <= address_b when test = '0' else test_address;
  write_enable_b_meta <= write_enable_b when test = '0' else '0';

  seq : sequencer generic map (8, 8, 1)
                  port map (clock, reset, step_complete, step_complete, address_a, address_b);

  -- From a to b
  memory_a : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, write_enable_a, address_a, data_in_a, data_out_a);

  memory_b : RAM generic map (filename => "blank_8x8.mif")
                    port map (clock, write_enable_b_meta, address_b_meta, data_in_b, data_out_b);

  -- This ram is in the state we desire
  reference : RAM generic map (filename => "glider_8x8_t1.mif")
                     port map (clock, test_write_enable, test_address, data_in_a, test_data);

  engine : stencil_engine port map (clock, enable, data_out_a, data_in_b);

  STIMULUS: process
  begin
    data_in_a <= (others => '0');
    reset <= '1';
    wait for period;
    reset <= '0';
    wait for 3 * 8 * 6 * period;

    


    wait;
  end process STIMULUS;

  RESPONSE: process
  begin
    wait for period;
    -- Reset
    wait for 3 * 8 * 6 * period;
    test <= '1';
    wait for period;


    for i in 0 to 63 loop
      test_address <= std_logic_vector(to_unsigned(i, test_address'length)); 
      wait for period;
      assert test_data = "00000000" report "Should match the testcase at " & natural'image(i) severity error;
    end loop;


    finished <= '1';
    wait;
  end process RESPONSE; 

end behavioural;
