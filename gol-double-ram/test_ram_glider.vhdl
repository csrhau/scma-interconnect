library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.test_utils.all;

entity test_RAM_glider is
end test_RAM_glider;

architecture behavioural of test_RAM_glider is

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
  signal read_address  : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal write_address  : std_logic_vector(5 downto 0); -- large enough to hold 8 by 8 square
  signal expect_address : std_logic_vector(5 downto 0) := (others => '0'); -- large enough to hold 8 by 8 square
  signal data_in_a  : std_logic_vector(7 downto 0) := (others => '0');
  signal data_out_a : std_logic_vector(7 downto 0);
  signal data_in_b  : std_logic_vector(7 downto 0) := (others => '0');
  signal data_out_b : std_logic_vector(7 downto 0);
  signal data_out_expect : std_logic_vector(7 downto 0);

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal finished : std_logic := '0';


  signal write_stim_key : std_logic := '0';
  signal write_resp_key : std_logic := '0';

  constant ALIVE: std_logic_vector(data_out_a'range) := (others => '1');
  constant DEAD: std_logic_vector(data_out_a'range) := (others => '0');

begin
  clock <= not clock after period/2 when finished='0';

  memory_a : RAM generic map (filename => "glider_8x8_t0.mif")
                    port map (clock, '0', read_address, data_in_a, data_out_a);

  memory_b : RAM generic map (filename => "blank_8x8.mif")
                    port map (clock, write_enable, write_address, data_in_b, data_out_b);

  expect : RAM generic map (filename => "glider_8x8_t1.mif")
                    port map (clock, '0', expect_address, data_in_a, data_out_expect);

  STIMULUS: process
  begin
    write_enable <= '0';

    -- Col 1
    read_address <= std_logic_vector(to_unsigned(0, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(1, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(2, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(8, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(9, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(10, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(16, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(17, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(18, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(9, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(24, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(25, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(26, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(17, write_address'length)); 
    write_enable <= '1';
    data_in_b <= ALIVE;

    read_address <= std_logic_vector(to_unsigned(32, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(33, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(34, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(25, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(40, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(41, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(42, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(33, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(48, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(49, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(50, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(41, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(56, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(57, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(58, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(49, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    -- Col 2
    read_address <= std_logic_vector(to_unsigned(1, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(2, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(3, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(9, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(10, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(11, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(17, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(18, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(19, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(10, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(25, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(26, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(27, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(18, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(33, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(34, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(35, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(26, write_address'length)); 
    write_enable <= '1';
    data_in_b <= ALIVE;
   
    read_address <= std_logic_vector(to_unsigned(41, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(42, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(43, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(34, write_address'length)); 
    write_enable <= '1';
    data_in_b <= ALIVE;

    read_address <= std_logic_vector(to_unsigned(49, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(50, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(51, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(42, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(57, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(58, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(59, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(50, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    -- Col 3
    read_address <= std_logic_vector(to_unsigned(2, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(3, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(4, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(10, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(11, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(12, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(18, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(19, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(20, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(11, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(26, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(27, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(28, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(19, write_address'length)); 
    write_enable <= '1';
    data_in_b <= ALIVE;

    read_address <= std_logic_vector(to_unsigned(34, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(35, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(36, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(27, write_address'length)); 
    write_enable <= '1';
    data_in_b <= ALIVE;
   
    read_address <= std_logic_vector(to_unsigned(42, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(43, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(44, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(35, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(50, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(51, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(52, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(43, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(58, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(59, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(60, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(51, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    -- Col 4
    read_address <= std_logic_vector(to_unsigned(3, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(4, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(5, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(11, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(12, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(13, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(19, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(20, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(21, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(12, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(27, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(28, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(29, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(20, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(35, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(36, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(37, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(28, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;
   
    read_address <= std_logic_vector(to_unsigned(43, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(44, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(45, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(36, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(51, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(52, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(53, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(44, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(59, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(60, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(61, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(52, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    -- Col 5
    read_address <= std_logic_vector(to_unsigned(4, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(5, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(6, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(12, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(13, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(14, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(20, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(21, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(22, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(13, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(28, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(29, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(30, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(21, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(36, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(37, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(38, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(29, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;
   
    read_address <= std_logic_vector(to_unsigned(44, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(45, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(46, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(37, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(52, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(53, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(54, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(45, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(60, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(61, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(62, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(53, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    -- Col 5
    read_address <= std_logic_vector(to_unsigned(5, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(6, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(7, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(13, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(14, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(15, read_address'length)); wait for period;
    
    read_address <= std_logic_vector(to_unsigned(21, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(22, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(23, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(14, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(29, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(30, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(31, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(22, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(37, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(38, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(39, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(30, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;
   
    read_address <= std_logic_vector(to_unsigned(45, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(46, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(47, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(38, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(53, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(54, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(55, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(46, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;

    read_address <= std_logic_vector(to_unsigned(61, read_address'length)); wait for period; write_enable <= '0';
    read_address <= std_logic_vector(to_unsigned(62, read_address'length)); wait for period;
    read_address <= std_logic_vector(to_unsigned(63, read_address'length)); wait for period;
    write_address <= std_logic_vector(to_unsigned(54, write_address'length)); 
    write_enable <= '1';
    data_in_b <= DEAD;
    wait for period;
    write_enable <= '0';

    -- Sequence to compare written with expect ram
    write_stim_key <= '1';
    
    for i in 0 to 7 loop
      for j in 0 to 7 loop
        write_address <= std_logic_vector(to_unsigned(i * 8 + j, write_address'length)); 
        expect_address <= std_logic_vector(to_unsigned(i * 8 + j, expect_address'length)); 
        wait for period;
      end loop;
    end loop;

    finished <= '1';
    wait;
  end process STIMULUS;

  RESPONSE: process
  begin

    -- Col 1
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    -- Col 2
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    -- Col 3
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    -- Col 4
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = ALIVE report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 
    wait for period; 
    assert data_out_a = DEAD report "mismatch" severity error; 

    -- Column 5 - 
    for i in 5 to 6 loop
      for j in 0 to 7 loop
        wait for period; 
        assert data_out_a = DEAD report "mismatch" severity error; 
        wait for period; 
        assert data_out_a = DEAD report "mismatch" severity error; 
        wait for period; 
        assert data_out_a = DEAD report "mismatch" severity error; 
      end loop;
    end loop;

    wait for period;
    wait for period;
    write_resp_key <= '1';
    -- Compare written with expect ram
    for i in 0 to 7 loop
      for j in 0 to 7 loop
        assert write_address = expect_address report "Some weird address bollocks " & slv2str(write_address) & " " & slv2str(expect_address) & " for "  & integer'image(i) & ", " & integer'image(j) severity error;
          wait for period;
          assert data_out_b = data_out_expect
            report "Mismatch at " & integer'image(i) & ", " & integer'image(j) & " " & slv2str(data_out_b) & " " & slv2str(data_out_expect)   & " " & slv2str(expect_address) severity error;
      end loop;
    end loop;
    wait;
  end process RESPONSE;

end behavioural;
