library ieee;
use ieee.std_logic_1164.all;

entity test_RAM is
end test_RAM;

architecture behavioural  of test_RAM is

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

  signal write_enable : std_logic; 
  signal address  : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal data_in  : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';
begin

  clock <= not clock after period/2 when finished='0';

  memory : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, write_enable, address, data_in, data_out);
  process
  begin


    address <= "000000";
    write_enable <= '0';
    data_in <= "01010101";
    wait for period;
    assert data_out = "00000000"
      report "RAM(0) should report 0" severity error;

    wait for period;
    assert data_out = "00000000"
      report "RAM(0) should not take on new values when write disabled" severity error;

    address <= "001010";
    wait for period;
    assert data_out = "11111111"
      report "RAM(10) should hold an alive cell" severity error;


    finished <= '1';
    wait;
  end process;

end behavioural;
