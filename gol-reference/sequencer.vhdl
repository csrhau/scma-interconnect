library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequencer is
  generic (
    rows : natural;
    cols : natural;
    radius : natural -- Stencil radius (1 for a 3x3)
  );
  port (
    clock : in std_logic;
    reset : in std_logic;
    write_enable : out std_logic;
    address : out std_logic_vector
  );
end entity sequencer;

architecture behavioural of sequencer is
  -- ROW I COL J 
  signal i      : natural range 0 to rows-1 := 0;
  signal j      : natural range 1 to cols-2 := 1;
  signal offset : natural range -radius to radius := -radius;

begin
  SEQUENTIAL: process (clock)
  begin
    if rising_edge(clock) then
      if reset = '1' then
        write_enable <= '0';
        offset <= -radius;
        i <= 0;
        j <= 1;
      else
        write_enable <= '0'; -- Overridden after each span
        if offset < radius then
          offset <= offset + 1;
        else
          offset <= -radius;
          if i > radius then
            write_enable <= '1';
          end if;
          if i < rows - 1 then
            i <= i + 1;
          else
            i <= 0;
            if j < cols - 2 then
              j <= j + 1;
            else 
              j <= 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

  COMBINATORIAL: process(offset, i, j)
  begin
    address <= std_logic_vector(to_unsigned(i * cols + j + offset, address'length));
  end process;

end architecture behavioural;
