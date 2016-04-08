library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_resequencer is
end test_resequencer;

architecture behavioural of test_resequencer is

  component resequencer is
    port (
      clock: in std_logic;
      enable        : out std_logic;
      up_fifo_push  : out std_logic;
      up_fifo_pop   : out std_logic;
      down_fifo_push: out std_logic;
      down_fifo_pop : out std_logic;
      address       : out std_logic_vector(9 downto 0)
    );
  end component resequencer;

  signal clock:  std_logic;
  signal enable:  std_logic;
  signal up_fifo_push   : std_logic;
  signal up_fifo_pop    : std_logic;
  signal down_fifo_push : std_logic;
  signal down_fifo_pop  : std_logic;
  signal address        : std_logic_vector(9 downto 0);

begin
  SEQU: resequencer port map(clock, enable, up_fifo_push, up_fifo_pop, down_fifo_push, down_fifo_pop, address);
  process
    -- Helper procedures
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin

    wait for 1 ns;
    assert enable = '0'
      report "Starts disabled" severity error;
    assert up_fifo_push = '0' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '0'
      report "All fifo control signals should be zero" severity error;

    CYCLE;
    assert enable = '1'
      report "Self-enables" severity error;
    assert up_fifo_push = '0' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '0'
      report "All fifo control signals should be zero" severity error;
    assert to_integer(unsigned(address)) = 32
      report "First read should be from address 32";

    for i in 33 to 63 loop 
      CYCLE;
      assert up_fifo_push = '1' and up_fifo_pop = '0' and 
             down_fifo_push = '0' and down_fifo_pop = '0'
        report "Up fifo should be taking data" severity error;
      assert to_integer(unsigned(address)) = i
        report "read should be from address " & natural'image(i);
    end loop;

    -- Here we read the first cell of the bottom inner, but we're still pushing
    -- from the last read of the top
    CYCLE;
    assert up_fifo_push = '1' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '0'
      report "Up fifo should be taking data" severity error;
    assert to_integer(unsigned(address)) = 960 --  32*30
      report "First read should be from address 960";

    for i in 961 to 990 loop
      CYCLE;
      assert up_fifo_push = '0' and up_fifo_pop = '0' and 
             down_fifo_push = '1' and down_fifo_pop = '0'
        report "Down fifo should be taking data" severity error;
      assert to_integer(unsigned(address)) = i
        report "read should be from address " & natural'image(i);
    end loop;

    -- Here we are performing the last read, and pushing from the penultimate read,
    -- and scheduling a pop
    CYCLE;
    assert up_fifo_push = '0' and up_fifo_pop = '1' and 
           down_fifo_push = '1' and down_fifo_pop = '0'
      report "Should be pushing down and popping from up" severity error;
    assert to_integer(unsigned(address)) = 991
      report "Should be reading the last cell of the bottom inner row" severity error;

    -- Here we are performing the first write, and pushing from the final read,
    -- and scheduling a pop
    CYCLE;
    assert up_fifo_push = '0' and up_fifo_pop = '1' and 
           down_fifo_push = '1' and down_fifo_pop = '0'
      report "Should be pushing down and popping from up" severity error;
    assert to_integer(unsigned(address)) = 992
      report "Should be writing the first cell of the bottom ghost row" severity error;

    for i in 993 to 1022 loop
      CYCLE;
      assert up_fifo_push = '0' and up_fifo_pop = '1' and 
             down_fifo_push = '0' and down_fifo_pop = '0'
        report "Should be popping from the upwards fifo only" severity error;
      assert to_integer(unsigned(address)) = i
        report "Should be writing to address " & natural'image(i);
    end loop;


    -- Here we write to the last cell in the bottom ghost row, and schedule a pop for the
    -- value of the first ghost cell
    CYCLE;
    assert up_fifo_push = '0' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '1'
       report "Down fifo should be active" severity error;
    assert to_integer(unsigned(address)) = 1023
      report "Should be writing to address 1023";

   -- Here we pop and write to the top ghost row
    for i in 0 to 30 loop
      CYCLE;
      assert up_fifo_push = '0' and up_fifo_pop = '0' and 
             down_fifo_push = '0' and down_fifo_pop = '1'
        report "Should be popping from the down fifo only" severity error;
      assert to_integer(unsigned(address)) = i
        report "Should be writing to address " & natural'image(i);
    end loop;

    -- Final write to rhs of top ghost row, should not have any push/pop activity
    CYCLE;
    assert up_fifo_push = '0' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '0'
      report "FIFOs should be inactive for final write" severity error;
    assert to_integer(unsigned(address)) = 31
      report "Should be writing to address 31";

    -- Back to start, we should have no FIFO activity and a read of the first cell
    -- in the top inner row
    -- The next bits simply prove we go full cycle
    CYCLE;
    assert up_fifo_push = '0' and up_fifo_pop = '0' and 
           down_fifo_push = '0' and down_fifo_pop = '0'
      report "All fifo control signals should be zero" severity error;
    assert to_integer(unsigned(address)) = 32
      report "First read should be from address 32";

    for i in 33 to 63 loop 
      CYCLE;
      assert up_fifo_push = '1' and up_fifo_pop = '0' and 
             down_fifo_push = '0' and down_fifo_pop = '0'
        report "Up fifo should be taking data" severity error;
      assert to_integer(unsigned(address)) = i
        report "read should be from address " & natural'image(i);
    end loop;

    wait for 1 ns;
    wait;
  end process;
end architecture behavioural;
