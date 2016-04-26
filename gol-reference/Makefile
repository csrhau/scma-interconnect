all: test_stencil_engine.ghw test_sequencer.ghw

stencil_engine.o: stencil_engine.vhdl
	ghdl -a $<

test_stencil_engine.o: test_stencil_engine.vhdl stencil_engine.o
	ghdl -a $<

test_stencil_engine: test_stencil_engine.o
	ghdl -m $@

test_stencil_engine.ghw: test_stencil_engine
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
	rm -rf ./test_stencil_engine
	rm -rf ./test_sequencer
