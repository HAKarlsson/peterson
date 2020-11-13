.PHONY: all
all: main.out

RISCV_PREFIX ?= riscv64-linux-gnu

CC=$(RISCV_PREFIX)-gcc

FLAGS=-pthread -static -O2

%.o: %.c
	$(CC) $(FLAGS) -c $^ 
%.o: %.S
	$(CC) $(FLAGS) -c $^

main.out: main.o peterson.o
	$(CC) $(FLAGS) -o $@ $^

.PHONY: run
run: main.out
	./main.out

.PHONY: clean
clean: 
	rm -f *.out *.da *.o
