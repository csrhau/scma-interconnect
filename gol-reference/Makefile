all: test_stencil_engine.ghw test_stencil_engine_glider.ghw test_sequencer.ghw test_sequencer_glider.ghw test_ram.ghw test_ram_glider.ghw test_integration.ghw

stencil_engine.o: stencil_engine.vhdl
	ghdl -a $<

test_stencil_engine.o: test_stencil_engine.vhdl stencil_engine.o
	ghdl -a $<

test_stencil_engine: test_stencil_engine.o
	ghdl -m $@

test_stencil_engine.ghw: test_stencil_engine
	./$< --wave=$@

test_stencil_engine_glider.o: test_stencil_engine_glider.vhdl stencil_engine.o
	ghdl -a $<

test_stencil_engine_glider: test_stencil_engine_glider.o
	ghdl -m $@

test_stencil_engine_glider.ghw: test_stencil_engine_glider
	./$< --wave=$@

sequencer.o: sequencer.vhdl 
	ghdl -a $<

test_sequencer.o: test_sequencer.vhdl sequencer.o 
	ghdl -a $<

test_sequencer: test_sequencer.o
	ghdl -m $@

test_sequencer.ghw: test_sequencer
	./$< --wave=$@

test_sequencer_glider.o: test_sequencer_glider.vhdl sequencer.o 
	ghdl -a $<

test_sequencer_glider: test_sequencer_glider.o
	ghdl -m $@

test_sequencer_glider.ghw: test_sequencer_glider
	./$< --wave=$@

ram.o: ram.vhdl 
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o 
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@

test_ram_glider.o: test_ram_glider.vhdl ram.o 
	ghdl -a $<

test_ram_glider: test_ram_glider.o
	ghdl -m $@

test_ram_glider.ghw: test_ram_glider
	./$< --wave=$@

test_utils.o: test_utils.vhdl
	ghdl -a $<

test_integration.o: test_integration.vhdl ram.o sequencer.o stencil_engine.o test_utils.o
	ghdl -a $<

test_integration: test_integration.o
	ghdl -m $@

test_integration.ghw: test_integration
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_stencil_engine
	rm -rf ./test_stencil_engine_glider
	rm -rf ./test_sequencer
	rm -rf ./test_sequencer_glider
	rm -rf ./test_ram
	rm -rf ./test_ram_glider
	rm -rf ./test_integration
