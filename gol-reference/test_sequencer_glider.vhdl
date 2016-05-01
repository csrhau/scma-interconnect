library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_sequencer_glider is
end test_sequencer_glider;

architecture behavioural of test_sequencer_glider is

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

  signal period: time := 10 ns;
  signal clock : std_logic := '0';
  signal reset : std_logic := '0';
  signal step_complete : std_logic;
  signal write_enable : std_logic;
  signal finished : std_logic := '0';

  signal read_address : std_logic_vector(5 downto 0);
  signal write_address : std_logic_vector(5 downto 0);

begin
  clock <= not clock after period/2 when finished='0';

  SEQ: sequencer generic map (8, 8, 1)
                 port map(clock, reset, step_complete, write_enable, read_address, write_address);

  STIMULUS: process
  begin
    reset <= '1';
    wait for period;
    reset <= '0';
    wait for 24 * 6 * period; 
    finished <= '1';
    wait;
  end process STIMULUS;

  READ_RESPONSE: process
  begin
    wait for period; -- Reset
    assert read_address = std_logic_vector(to_unsigned(0, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(1, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(2, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(8, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(9, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(10, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(16, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(17, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(18, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(24, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(25, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(26, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(32, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(33, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(34, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(40, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(41, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(42, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(48, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(49, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(50, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(56, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(57, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(58, read_address'length))
      report "Read address mismatch" severity error;

    -- Col 2
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(1, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(2, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(3, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(9, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(10, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(11, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(17, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(18, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(19, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(25, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(26, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(27, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(33, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(34, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(35, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(41, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(42, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(43, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(49, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(50, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(51, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(57, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(58, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(59, read_address'length))
      report "Read address mismatch" severity error;

    -- Col 3
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(2, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(3, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(4, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(10, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(11, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(12, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(18, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(19, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(20, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(26, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(27, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(28, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(34, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(35, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(36, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(42, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(43, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(44, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(50, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(51, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(52, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(58, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(59, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(60, read_address'length))
      report "Read address mismatch" severity error;

    -- Col 4
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(3, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(4, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(5, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(11, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(12, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(13, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(19, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(20, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(21, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(27, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(28, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(29, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(35, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(36, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(37, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(43, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(44, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(45, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(51, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(52, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(53, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(59, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(60, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(61, read_address'length))
      report "Read address mismatch" severity error;

    -- Col 5
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(4, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(5, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(6, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(12, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(13, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(14, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(20, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(21, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(22, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(28, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(29, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(30, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(36, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(37, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(38, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(44, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(45, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(46, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(52, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(53, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(54, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(60, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(61, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(62, read_address'length))
      report "Read address mismatch" severity error;

    -- Col 5
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(5, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(6, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(7, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(13, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(14, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(15, read_address'length))
      report "Read address mismatch" severity error;
    
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(21, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(22, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(23, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(29, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(30, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(31, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(37, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(38, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(39, read_address'length))
      report "Read address mismatch" severity error;
   
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(45, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(46, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(47, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(53, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(54, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(55, read_address'length))
      report "Read address mismatch" severity error;

    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(61, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(62, read_address'length))
      report "Read address mismatch" severity error;
    wait for period; 
    assert read_address = std_logic_vector(to_unsigned(63, read_address'length))
      report "Read address mismatch" severity error;

    wait;
  end process READ_RESPONSE; 

  WRITE_RESPONSE: process
  begin
    wait for period; -- reset

    -- Col 1
    -- Read row 0, no write
    wait for 3 * period; -- Read 0x00, 0x01, 0x02
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period; -- Read 0x08, 0x09, 0x0A
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,1
    wait for 3 * period; -- Read 0x10, 0x11, 0x12
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(9, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,1
    wait for 3 * period; 
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(17, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,1
    wait for 3 * period; 
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(25, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 5, write 4,1
    wait for 3 * period; 
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(33, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,1
    wait for 3 * period; 
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(41, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,1
    wait for 3 * period; 
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(49, write_address'length))
      report "Write address mismatch" severity error;

    -- Col 2
    -- Read row 0, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(10, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(18, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(26, write_address'length)) report "Write address mismatch" severity error;
    -- Read row 5, write 4,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(34, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(42, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,2
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(50, write_address'length))
      report "Write address mismatch" severity error;

    -- Col 3
    -- Read row 0, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(11, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(19, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(27, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 5, write 4,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(35, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(43, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,3
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(51, write_address'length))
      report "Write address mismatch" severity error;

    -- Col 4
    -- Read row 0, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(12, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(20, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(28, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 5, write 4,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(36, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(44, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,4
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(52, write_address'length))
      report "Write address mismatch" severity error;

    -- Col 5
    -- Read row 0, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(13, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(21, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(29, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 5, write 4,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(37, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(45, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,5
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(53, write_address'length))
      report "Write address mismatch" severity error;

    -- Col 6
    -- Read row 0, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 1, no write
    wait for 3 * period;
    assert write_enable = '0' report "Shouldn't be on a write cycle" severity error;
    -- Read row 2, write 1,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(14, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 3, write 2,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(22, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 4, write 3,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(30, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 5, write 4,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(38, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 6, write 5,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(46, write_address'length))
      report "Write address mismatch" severity error;
    -- Read row 7, write 6,6
    wait for 3 * period;
    assert write_enable = '1' report "Should be on a write cycle" severity error;
    assert write_address = std_logic_vector(to_unsigned(54, write_address'length))
      report "Write address mismatch" severity error;
    -- Step complete
    assert step_complete = '1' report "Should have finished a step" severity error;

    wait;
  end process WRITE_RESPONSE;

end behavioural;
