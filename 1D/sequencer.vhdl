library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.scma_types.all;

entity sequencer is
  port (
    clock: in std_logic;
    enable: in std_logic;
    address : out std_logic_vector(9 downto 0);
    direction : out direction_t;
    operation : out operation_t
  );
end entity sequencer;

architecture behavioural of sequencer is
  constant COLS : natural := 32;
  constant ROWS : natural := 32;
  type sequencer_state is (OUTFLOW_NORTH, OUTFLOW_SOUTH, INFLOW_NORTH, INFLOW_SOUTH);
  signal state : sequencer_state := OUTFLOW_NORTH;
  signal column : natural range 0 to COLS-1;
begin
  SEQUENTIAL: process(clock) 
  begin
    if rising_edge(clock) then
      if enable = '1' then
        case state is
        when OUTFLOW_NORTH =>
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= OUTFLOW_SOUTH;
          end if;
        when OUTFLOW_SOUTH =>
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= INFLOW_NORTH;
          end if;
        when INFLOW_NORTH =>
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= INFLOW_SOUTH;
          end if;
        when INFLOW_SOUTH =>
          if column < 31 then
            column <= column + 1;
          else
            column <= 0;
            state <= OUTFLOW_NORTH;
          end if;
        end case;
      end if; -- enablement
    end if; -- rising_edge
  end process SEQUENTIAL;

  COMBINATORIAL: process(column, state) 
  begin
    case state is
    -- RAM TO FIFO
    when OUTFLOW_NORTH =>
      direction <= NORTH;
      operation <= OUTFLOW;
      address <= std_logic_vector(to_unsigned(column + 1 * COLS, address'length)); 
    when OUTFLOW_SOUTH =>
      direction <= SOUTH;
      operation <= OUTFLOW;
      address <= std_logic_vector(to_unsigned(column + (ROWS-2) * COLS, address'length)); 
    -- FIFO TO RAM
    when INFLOW_NORTH =>
      direction <= NORTH;
      operation <= INFLOW;
      address <= std_logic_vector(to_unsigned(column, address'length)); 
    when INFLOW_SOUTH =>
      direction <= SOUTH;
      operation <= INFLOW;
      address <= std_logic_vector(to_unsigned(column + (ROWS-1) * COLS, address'length)); 
    end case;
  end process COMBINATORIAL;

end behavioural;
