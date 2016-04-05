library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_pe is
end entity test_pe;

architecture behavioural of test_pe is
  component PE is 
    port (
      clock: in std_logic;
      enable: in std_logic;
      seq_address : in std_logic_vector(9 downto 0);
      seq_orientation :in orientation_t;
      seq_operation : in  operation_t;
      north_input : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
      south_input : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
      output : out std_logic_vector(7 downto 0)        -- The output to both fifos (gets switched by sequencer)
    );
  end component PE;

  signal clock: std_logic;
  signal enable: std_logic;
  signal seq_address : std_logic_vector(9 downto 0);
  signal seq_orientation : orientation_t;
  signal seq_operation :  operation_t;
  signal north_input : std_logic_vector(7 downto 0); 
  signal south_input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);

begin
  ELEMENT : PE port map (clock, enable, seq_address, seq_orientation,
                         seq_operation, north_input, south_input, output);
  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    enable <= '1';
    seq_address <= std_logic_vector(to_unsigned(32, seq_address'length)); 
    seq_orientation <= NORTH;
    seq_operation <= OUTFLOW;
    north_input <= "--------";
    north_input <= "--------";




    wait;
  end process;
end architecture behavioural;
