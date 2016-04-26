library ieee;
use ieee.std_logic_1164.all;

entity test_integration is
end test_integration;


architecture behavioural of test_integration is
  clock <= not clock after period/2 when finished='0';


  signal write_enable : std_logic; 
  signal address  : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal data_in  : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);



  memory_a : RAM generic map (filename => "glider_8x8_t0.mif")
                 port map (clock, 0, address, "00000000", data_out);
  memory_b : RAM generic map (filename => "glider_8x8_t0.mif")
                 port map (clock, write_enable, address, data_in, data_out);
  expected : RAM generic map (filename => "glider_8x8_t0.mif")
                 port map (clock, 0, address, data_in, data_out);



  engine: stencil_engine port map (clock, enable, input, result);


  STIMULUS: process 
  begin
    -- Start with a nice cleansing reset
    reset <= '1';
    wait for period;
    reset <= '0';
    wait;
  end process STIMULUS;

  RESPONSE: process 
  begin

    wait;
  end process RESPONSE;


end behavioural;
