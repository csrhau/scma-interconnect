library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;
use work.test_helpers.all;

entity test_pe is
end entity test_pe;

architecture behavioural of test_pe is
  component PE is
    generic (
      pe_contents : memory_t := (others => (others => '0'))
    );
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

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));


  signal clock: std_logic;
  signal enable: std_logic;
  signal seq_address : std_logic_vector(9 downto 0);
  signal seq_orientation : orientation_t;
  signal seq_operation :  operation_t;
  signal north_input : std_logic_vector(7 downto 0);
  signal south_input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);

begin
  ELEMENT : PE generic map(pe_contents => input_deck)
                port map (clock, enable, seq_address, seq_orientation,
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

    -- NORTH OUTFLOW: Should match input_deck(32 to 63)
    seq_orientation <= NORTH;
    seq_operation <= OUTFLOW;
    for i in 32 to 63 loop
      seq_address <= std_logic_vector(to_unsigned(i, seq_address'length));
      CYCLE;
      assert output = input_deck(i)
        report "Cycle " & natural'image(i) & " Expected: " & str(input_deck(i))
                                           & " Received: " & str(output)
        severity error;
    end loop;

    -- SOUTH OUTFLOW: Should match input deck(960 to 991)
    seq_orientation <= SOUTH;
    seq_operation <= OUTFLOW;
    for i in 960 to 991 loop
      seq_address <= std_logic_vector(to_unsigned(i, seq_address'length));
      CYCLE;
      assert output = input_deck(i)
        report "Cycle " & natural'image(i) & " Expected: " & str(input_deck(i))
                                           & " Received: " & str(output)
        severity error;
    end loop;

    -- NORTH INFLOW: Should write to storage(0 to 31)
    south_input <= "XXXXXXXX";
    seq_orientation <= NORTH;
    seq_operation <= INFLOW;
    for i in 0 to 31 loop
      seq_address <= std_logic_vector(to_unsigned(i, seq_address'length));
      north_input <= std_logic_vector(to_unsigned(i, north_input'length));
      CYCLE;
    end loop;

    -- SOUTH INFLOW: Should write to storage(992 to 1023)
    north_input <= "XXXXXXXX";
    seq_orientation <= SOUTH;
    seq_operation <= INFLOW;
    for i in 992 to 1023 loop
      seq_address <= std_logic_vector(to_unsigned(i, seq_address'length));
      south_input <= std_logic_vector(to_unsigned(i-900, south_input'length)); -- -900 prevents overflow
      CYCLE;
    end loop;

    -- TODO: CHECK INNER STORAGE. Need to add a way to read from RAM externally
    --                            Either by externalizing RAM, or add a read interface to the processing element
    --                            along with a bus implementation and element selectors.
    --                            This is quite easy; it's adding another flag driving an output in combinatorial logic
    --                            Need to be sure this still allows for synthesis, however.

    enable <= '0';
    CYCLE;
    CYCLE;
    CYCLE;
    CYCLE;





    wait;
  end process;
end architecture behavioural;

