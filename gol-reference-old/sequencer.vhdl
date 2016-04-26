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
    address : out std_logic_vector
  );
end entity sequencer;

architecture behavioural of sequencer is
  type position_t is (POS_UPPER, POS_CENTER, POS_LOWER); 

  signal position : position_t := POS_UPPER;
  signal i : natural range 1 to rows-2 := 1;
  signal j : natural range 0 to cols-1 := 0;

begin
  -- ROW I COL J
  -- J is fastest increment
  SEQUENTIAL: process (clock)
  begin
    if rising_edge(clock) then
      case position is 
        when POS_UPPER =>
          position <= POS_CENTER;
        when POS_CENTER =>
          position <= POS_LOWER;
        when POS_LOWER =>
          position <= POS_UPPER;
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

  COMBINATORIAL: process(position, i, j)
  begin
    case position is 
      when POS_UPPER =>
        address <= std_logic_vector(to_unsigned((i-1) * cols + j, address'length));
      when POS_CENTER =>
        address <= std_logic_vector(to_unsigned(i * cols + j, address'length));
      when POS_LOWER =>
        address <= std_logic_vector(to_unsigned((i+1) * cols + j, address'length));
    end case;
  end process;

end architecture behavioural;
