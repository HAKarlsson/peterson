all: main.out


CC=riscv64-linux-gnu-gcc
GDB=gdb

FLAGS=-pthread -static

%.o: %.c
	$(CC) $(FLAGS) -c $^ 
%.o: %.S
	$(CC) $(FLAGS) -c $^

main.out: main.o peterson.o
	$(CC) $(FLAGS) -o $@ $^

.PHONY: run
run: main.out
	./main.out

.PHONY: run
clean: 
	rm -f *.out *.da *.o
