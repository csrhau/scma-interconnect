library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity resequencer is
  port (
    clock: in std_logic;
    enable        : out std_logic := '0';
    up_fifo_push  : out std_logic := '0';
    up_fifo_pop   : out std_logic := '0';
    down_fifo_push: out std_logic := '0';
    down_fifo_pop : out std_logic := '0';
    write_enable  : out std_logic := '0';
    address       : out std_logic_vector(9 downto 0)
  );
end entity resequencer;

architecture behavioural of resequencer is
  constant COLS : natural := 32;
  constant ROWS : natural := 32;
  type resequencer_state_t is  (NORTH_INNER, SOUTH_INNER, SOUTH_GHOST, NORTH_GHOST);
  signal state : resequencer_state_t;
  signal column : natural range 0 to COLS-1 := 0;
  signal up_fifo_push_s   : std_logic := '0';
  signal down_fifo_push_s : std_logic := '0';
begin
  SEQUENTIAL: process(clock)
  begin
    if rising_edge(clock) then
      case state is
        when NORTH_INNER => -- Data outflow upwards
          address <= std_logic_vector(to_unsigned(column + 1 * COLS, address'length)); 
          write_enable <= '0';
          up_fifo_push_s <= '1';
          down_fifo_push_s <= '0';
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= SOUTH_INNER;
          end if;
        when SOUTH_INNER => -- Data outflow downwards
          address <= std_logic_vector(to_unsigned(column + (ROWS-2) * COLS, address'length)); 
          write_enable <= '0';
          up_fifo_push_s <= '0';
          down_fifo_push_s <= '1';
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= SOUTH_GHOST;
          end if;

        when SOUTH_GHOST => -- Data inflow upwards 
          up_fifo_push_s <= '0';
          down_fifo_push_s <= '0';
          address <= std_logic_vector(to_unsigned(column + (ROWS-1) * COLS, address'length)); 
          write_enable <= '1';
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= NORTH_GHOST;
          end if;

        when NORTH_GHOST => -- Data inflow downwards
          up_fifo_push_s <= '0';
          down_fifo_push_s <= '0';
          address <= std_logic_vector(to_unsigned(column, address'length)); 
          write_enable <= '1';
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= NORTH_INNER;
          end if;
      end case;
      enable <= '1';
      up_fifo_push <= up_fifo_push_s;
      down_fifo_push <= down_fifo_push_s;
    end if;
  end process SEQUENTIAL;

  -- Combinatorial assignments happen instantly - NO DELAY
  COMBINATORIAL: process(column, state) 
  begin
    case state is
    when NORTH_INNER => -- Data outflow upwards
      down_fifo_pop <= '0';
      up_fifo_pop <= '0';
    when SOUTH_INNER => -- Data outflow downwards
      down_fifo_pop <= '0';
      up_fifo_pop <= '0';
    when SOUTH_GHOST => -- Data inflow upwards
      down_fifo_pop <= '0';
      up_fifo_pop <= '1';
    when NORTH_GHOST => -- Data inflow downwards
      down_fifo_pop <= '1';
      up_fifo_pop <= '0';
    end case;
  end process COMBINATORIAL;
end behavioural;
