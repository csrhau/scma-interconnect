library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity sequencer is
  generic (
    rows : natural;
    cols : natural;
    radius : natural -- Stencil radius (1 for a 3x3)
  );
  port (
    clock : in std_logic;
    reset : in std_logic;
    step_complete : out std_logic;
    write_enable : out std_logic;
    read_address : out std_logic_vector;
    write_address : out std_logic_vector
  );
end entity sequencer;

architecture behavioural of sequencer is
  -- ROW I COL J 
  signal i      : natural range 0 to rows-1 := 0;
  signal j      : natural range radius to cols-radius := 1;
  signal offset : natural range -radius to radius := -radius;

begin
  SEQUENTIAL: process (clock)
    variable outbuff: line;
  begin
    if rising_edge(clock) then
      if reset = '1' then
        step_complete <= '0';
        write_enable <= '0';
        offset <= -radius;
        i <= 0;
        j <= 1;
      else
        step_complete <= '0'; -- Overridden after each frame
        write_enable <= '0'; -- Overridden after each span
        if offset < radius then
          offset <= offset + 1;
        else
          offset <= -radius;
          if i < rows - 1 then
            i <= i + 1;
          else
            i <= 0;
            if j < cols - 2 then
              j <= j + 1;
            else 
              j <= 1;
              step_complete <= '1';
            end if;
          end if;
          if i > radius then -- Output here
            write_address <= std_logic_vector(to_unsigned((i - radius) * cols + j , write_address'length));
            write_enable <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  COMBINATORIAL: process(offset, i, j)
  begin
    read_address <= std_logic_vector(to_unsigned(i * cols + j + offset, read_address'length));
  end process;

end architecture behavioural;