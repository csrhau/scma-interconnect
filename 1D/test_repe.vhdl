library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;
use work.test_helpers.all;

entity test_repe is
end entity test_repe;

architecture behavioural of test_repe is
  component rePE is
    generic (
      pe_contents : memory_t
    );
    port (
      clock         : in std_logic;
      enable        : in std_logic;
      down_fifo_pop : in std_logic;
      up_fifo_pop   : in std_logic;
      address       : in std_logic_vector(9 downto 0);
      down_input    : in std_logic_vector(7 downto 0);   -- The output of the north in fifo
      up_input      : in std_logic_vector(7 downto 0);   -- the output of the south in fifo
      output        : out std_logic_vector(7 downto 0)
    );
  end component rePE;

  constant input_deck : memory_t := ( 0 to 31 => "11111111",
                                      32 to 63 => "00001010",
                                      960 to 991 => "11110101",
                                      992 to 1023 => "11110000",
                                      others => (others => '0'));

  signal clock         : std_logic;
  signal enable        : std_logic;
  signal down_fifo_pop : std_logic;
  signal up_fifo_pop   : std_logic;
  signal address       : std_logic_vector(9 downto 0);
  signal down_input    : std_logic_vector(7 downto 0);
  signal up_input      : std_logic_vector(7 downto 0);
  signal output        : std_logic_vector(7 downto 0);

begin
  ELEMENT : rePE generic map (pe_contents => input_deck)
                 port map (clock, enable, down_fifo_pop, up_fifo_pop, address,
                           down_input, up_input, output);
  process
    procedure CYCLE is
    begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
    end procedure;
  begin
    wait;
  end process;
end architecture behavioural;
