library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_RAM_glider is
end test_RAM_glider;

architecture behavioural  of test_RAM_glider is

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

  constant ALIVE: std_logic_vector(data_out'range) := (others => '1');
  constant DEAD: std_logic_vector(data_out'range) := (others => '0');

begin

  clock <= not clock after period/2 when finished='0';

  memory : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, write_enable, address, data_in, data_out);


  STIMULUS: process
  begin
    write_enable <= '0';

    -- Col 1
    address <= std_logic_vector(to_unsigned(0, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(1, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(2, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(8, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(9, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(10, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(16, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(17, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(18, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(24, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(25, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(26, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(32, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(33, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(34, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(40, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(41, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(42, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(48, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(49, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(50, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(56, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(57, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(58, address'length)); wait for period;

    -- Col 2
    address <= std_logic_vector(to_unsigned(1, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(2, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(3, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(9, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(10, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(11, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(17, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(18, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(19, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(25, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(26, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(27, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(33, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(34, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(35, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(41, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(42, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(43, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(49, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(50, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(51, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(57, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(58, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(59, address'length)); wait for period;

    -- Col 3
    address <= std_logic_vector(to_unsigned(2, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(3, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(4, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(10, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(11, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(12, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(18, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(19, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(20, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(26, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(27, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(28, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(34, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(35, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(36, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(42, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(43, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(44, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(50, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(51, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(52, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(58, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(59, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(60, address'length)); wait for period;

    -- Col 4
    address <= std_logic_vector(to_unsigned(3, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(4, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(5, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(11, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(12, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(13, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(19, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(20, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(21, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(27, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(28, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(29, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(35, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(36, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(37, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(43, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(44, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(45, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(51, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(52, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(53, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(59, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(60, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(61, address'length)); wait for period;

    -- Col 5
    address <= std_logic_vector(to_unsigned(4, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(5, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(6, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(12, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(13, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(14, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(20, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(21, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(22, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(28, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(29, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(30, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(36, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(37, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(38, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(44, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(45, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(46, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(52, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(53, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(54, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(60, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(61, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(62, address'length)); wait for period;

    -- Col 5
    address <= std_logic_vector(to_unsigned(5, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(6, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(7, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(13, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(14, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(15, address'length)); wait for period;
    
    address <= std_logic_vector(to_unsigned(21, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(22, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(23, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(29, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(30, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(31, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(37, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(38, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(39, address'length)); wait for period;
   
    address <= std_logic_vector(to_unsigned(45, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(46, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(47, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(53, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(54, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(55, address'length)); wait for period;

    address <= std_logic_vector(to_unsigned(61, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(62, address'length)); wait for period;
    address <= std_logic_vector(to_unsigned(63, address'length)); wait for period;

    finished <= '1';
    wait;
  end process STIMULUS;

  RESPONSE: process
  begin

    -- Col 1
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    -- Col 2
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    -- Col 3
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    -- Col 4
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out = DEAD report "mismatch" severity error; 

    -- Column 5 - 
    for i in 5 to 6 loop
      for j in 0 to 7 loop
        wait for period; 
        assert data_out = DEAD report "mismatch" severity error; 
        wait for period; 
        assert data_out = DEAD report "mismatch" severity error; 
        wait for period; 
        assert data_out = DEAD report "mismatch" severity error; 
      end loop;
    end loop;

    wait;
  end process RESPONSE;

end behavioural;
