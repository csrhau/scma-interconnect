all: test_fifo.ghw test_ram.ghw test_pe.ghw test_pe.ghw test_integration.ghw test_resequencer.ghw

scma_types.o: scma_types.vhdl
	ghdl -a $<

fifo.o: fifo.vhdl
	ghdl -a $<

test_fifo.o: test_fifo.vhdl fifo.o
	ghdl -a $<

test_fifo: test_fifo.o
	ghdl -m $@

test_fifo.ghw: test_fifo
	./$< --wave=$@

ram.o: ram.vhdl scma_types.o
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o 
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@

sequencer.o: sequencer.vhdl scma_types.o
	ghdl -a $<

resequencer.o: resequencer.vhdl scma_types.o
	ghdl -a $<

test_resequencer.o: test_resequencer.vhdl resequencer.o scma_types.o
	ghdl -a $<

test_resequencer: test_resequencer.o
	ghdl -m $@

test_resequencer.ghw: test_resequencer
	./$< --wave=$@

test_helpers.o: test_helpers.vhdl
	ghdl -a $<

pe.o: pe.vhdl ram.o scma_types.o
	ghdl -a $<

test_pe.o: test_pe.vhdl pe.o ram.o scma_types.o test_helpers.o
	ghdl -a $<

test_pe: test_pe.o
	ghdl -m $@

test_pe.ghw: test_pe
	./$< --wave=$@

test_integration.o: test_integration.vhdl fifo.o sequencer.o ram.o scma_types.o
	ghdl -a $<

test_integration: test_integration.o
	ghdl -m $@

test_integration.ghw: test_integration
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_fifo 
	rm -rf ./test_ram 
	rm -rf ./test_resequencer
	rm -rf ./test_integration
