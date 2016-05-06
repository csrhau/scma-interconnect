library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity test_PE is
end entity test_PE;

architecture behavioural of test_PE is
  component pe is
    generic (
      pe_contents : memory_t
    );
    port (
      clock         : in std_logic;
      enable        : in std_logic;
      up_fifo_pop   : in std_logic;
      down_fifo_pop : in std_logic;
      address       : in std_logic_vector(9 downto 0);
      up_input      : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
      down_input    : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
      output        : out std_logic_vector(7 downto 0)
    );
  end component pe;

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));

  signal clock         : std_logic;
  signal enable        : std_logic;
  signal up_fifo_pop   : std_logic;
  signal down_fifo_pop : std_logic;
  signal address       : std_logic_vector(9 downto 0);
  signal up_input      : std_logic_vector(7 downto 0);
  signal down_input    : std_logic_vector(7 downto 0);
  signal output        : std_logic_vector(7 downto 0);

begin
  ELEMENT : pe generic map (pe_contents => input_deck)
               port map (clock, enable, up_fifo_pop, down_fifo_pop, address,
                         up_input, down_input, output);
  process
  begin
    clock <= '0';
    enable <= '0';
    up_fifo_pop <= '0';
    down_fifo_pop <= '0';
    address <= (others => '0');
    up_input <= (others => '0');
    down_input <= (others => '0');

    wait for 1 ns;
    enable <= '1';

    for i in 32 to 63 loop
      address <= std_logic_vector(to_unsigned(i, address'length));
      clock <= '1';
      wait for 1 ns;
      clock <= '0';
      wait for 1 ns;
    end loop;

    for i in 960 to 990 loop
      address <= std_logic_vector(to_unsigned(i, address'length));
      clock <= '1';
      wait for 1 ns;
      clock <= '0';
      wait for 1 ns;
    end loop;

    -- Last cell of south inner, pop while pushing
    address <= std_logic_vector(to_unsigned(991, address'length));
    up_fifo_pop <= '1';
    clock <= '1';
    wait for 1 ns;
    clock <= '0';
    wait for 1 ns;

    -- TODO, really not finished at all.

    wait;
  end process;
end architecture behavioural;
