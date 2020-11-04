all: main.out


CC=riscv64-linux-gnu-gcc
GDB=riscv64-linux-gnu-gdb

FLAGS=-pthread -static

%.o: %.c
	$(CC) $(FLAGS) -c $^ 
%.o: %.S
	$(CC) $(FLAGS) -c $^

main.out: main.o peterson.o
	$(CC) $(FLAGS) -o $@ $^


.PHONY: debug
debug: main.out
	$(GDB) \
	    -ex 'file main.out' \
	    -ex 'target sim' \
	    -ex 'load main.out' \
	    -ex 'b main' \
	    -ex 'run'

.PHONY: run
run: main.out
	./main.out

.PHONY: run
clean: 
	rm -f *.out *.da *.o
