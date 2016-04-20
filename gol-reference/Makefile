all: test_ram.ghw test_processor.ghw

ram.o: ram.vhdl 
	ghdl -a $<

test_ram.o: test_ram.vhdl ram.o 
	ghdl -a $<

test_ram: test_ram.o
	ghdl -m $@

test_ram.ghw: test_ram
	./$< --wave=$@

processor.o: processor.vhdl 
	ghdl -a $<

test_processor.o: test_processor.vhdl processor.o 
	ghdl -a $<

test_processor: test_processor.o
	ghdl -m $@

test_processor.ghw: test_processor
	./$< --wave=$@

clean: 
	rm -f *.o *.cf *.ghw
	rm -rf ./test_ram
	rm -rf ./test_processor
