library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequencer is
  generic (
    rows : natural;
    cols : natural
  );
  port (
    clock : in std_logic;
    read_address : out std_logic_vector
  );
end entity sequencer;

architecture behavioural of sequencer is
  type position is (POS_UPPER, POS_CENTER, POS_LOWER); 
  signal pos_state : position := POS_UPPER;
  signal j : natural range 0 to cols-1 := 0;
  signal i : natural range 1 to rows-2 := 1;
begin
  -- ROW I COL J
  -- J is fastest increment
  SEQUENTIAL: process (clock)
  begin
    if rising_edge(clock) then
      case pos_state is 
        when POS_UPPER =>
          pos_state <= POS_CENTER;
        when POS_CENTER =>
          pos_state <= POS_LOWER;
        when POS_LOWER =>
          pos_state <= POS_UPPER;
          if j = cols-1 then
            j <= 0;
            if i = rows-2 then
              i <= 1;
            else
              i <= i + 1;
            end if;
          else
            j <= j + 1;
          end if;
      end case;
    end if;
  end process;

  COMBINATORIAL: process(pos_state, i, j)
  begin
    case pos_state is 
      when POS_UPPER =>
        read_address <= std_logic_vector(to_unsigned((i-1) * cols + j, read_address'length));
      when POS_CENTER =>
        read_address <= std_logic_vector(to_unsigned(i * cols + j, read_address'length));
      when POS_LOWER =>
        read_address <= std_logic_vector(to_unsigned((i+1) * cols + j, read_address'length));
    end case;
  end process;

end architecture behavioural;
