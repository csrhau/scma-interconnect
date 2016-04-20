all: test_fifo.ghw test_sequencer.ghw test_ram.ghw test_pe.ghw test_sequencer_fifo_integration.ghw test_sequencer_pe_integration.ghw test_integration.ghw

fifo.o: fifo.vhdl
	ghdl -a $<

test_fifo.o: test_fifo.vhdl fifo.o 
	ghdl -a $<

test_fifo: test_fifo.o
	ghdl -m $@

test_fifo.ghw: test_fifo
	./$< --wave=$@

sequencer.o: sequencer.vhdl
	ghdl -a $<

test_sequencer.o: test_sequencer.vhdl sequencer.o 
	ghdl -a $<

test_sequencer: test_sequencer.o
	ghdl -m $@

test_sequencer.ghw: test_sequencer
	./$< --wave=$@

scma_types.o: scma_types.vhdl
	ghdl -a $<

ram.o: ram.vhdl scma_types.o
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o scma_types.o
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@


pe.o: pe.vhdl ram.o scma_types.o
	ghdl -a $<

test_pe.o: test_pe.vhdl pe.o ram.o scma_types.o
	ghdl -a $<

test_pe: test_pe.o
	ghdl -m $@

test_pe.ghw: test_pe
	./$< --wave=$@

test_sequencer_fifo_integration.o: test_sequencer_fifo_integration.vhdl sequencer.o fifo.o 
	ghdl -a $<

test_sequencer_fifo_integration: test_sequencer_fifo_integration.o
	ghdl -m $@

test_sequencer_fifo_integration.ghw: test_sequencer_fifo_integration
	./$< --wave=$@

test_sequencer_pe_integration.o: test_sequencer_pe_integration.vhdl sequencer.o pe.o scma_types.o
	ghdl -a $<

test_sequencer_pe_integration: test_sequencer_pe_integration.o
	ghdl -m $@

test_sequencer_pe_integration.ghw: test_sequencer_pe_integration
	./$< --wave=$@

test_integration.o: test_integration.vhdl fifo.o sequencer.o pe.o scma_types.o
	ghdl -a $<

test_integration: test_integration.o
	ghdl -m $@

test_integration.ghw: test_integration
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ram
	rm -rf ./test_pe
	rm -rf ./test_fifo
	rm -rf ./test_sequencer
	rm -rf ./test_sequencer_fifo_integration
	rm -rf ./test_sequencer_pe_integration
	rm -rf ./test_integration
