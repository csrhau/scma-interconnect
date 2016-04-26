library ieee;
use ieee.std_logic_1164.all;

entity test_integration is
end test_integration;


architecture behavioural of test_integration is
  clock <= not clock after period/2 when finished='0';

  memory : RAM generic map (filename => "glider_8x8_t0.mif")
               port map (clock, write_enable, address, data_in, data_out);

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
