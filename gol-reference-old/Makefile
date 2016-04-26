all: test_ram.ghw test_sequencer.ghw test_stencil_engine.ghw test_integration.ghw

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

stencil_engine.o: stencil_engine.vhdl 
	ghdl -a $<

test_stencil_engine.o: test_stencil_engine.vhdl stencil_engine.o 
	ghdl -a $<

test_stencil_engine: test_stencil_engine.o
	ghdl -m $@

test_stencil_engine.ghw: test_stencil_engine
	./$< --wave=$@

test_integration.o: test_integration.vhdl stencil_engine.o ram.o sequencer.o
	ghdl -a $<

test_integration: test_integration.o
	ghdl -m $@

test_integration.ghw: test_integration
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ram
	rm -rf ./test_sequencer
	rm -rf ./test_stencil_engine
	rm -rf ./test_integration
