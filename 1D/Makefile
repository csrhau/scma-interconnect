all: test_fifo.ghw test_ram.ghw test_sequencer.ghw

fifo.o: fifo.vhdl
	ghdl -a $<

test_fifo.o: test_fifo.vhdl fifo.o
	ghdl -a $<

test_fifo: test_fifo.o
	ghdl -m $@

test_fifo.ghw: test_fifo
	./$< --wave=$@

ram.o: ram.vhdl 
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o 
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@

sequencer.o: sequencer.vhdl 
	ghdl -a $<

test_sequencer.o: test_sequencer.vhdl sequencer.o 
	ghdl -a $<

test_sequencer: test_sequencer.o
	ghdl -m $@

test_sequencer.ghw: test_sequencer
	./$< --wave=$@



clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_fifo 
	rm -rf ./test_ram 
	rm -rf ./test_sequencer
