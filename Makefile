.PHONY: all
all: main.out


CC=riscv64-linux-gnu-gcc

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
