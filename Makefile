.PHONY: all
all: main.out objdump

RISCV_LINUX_GNU_PREFIX ?= riscv64-linux-gnu

CC=$(RISCV_LINUX_GNU_PREFIX)-gcc
OBJDUMP=$(RISCV_LINUX_GNU_PREFIX)-objdump

FLAGS=-pthread -static -O2

%.o: %.c
	$(CC) $(FLAGS) -c $^ 
%.o: %.S
	$(CC) $(FLAGS) -c $^

%.da: %.o
	$(OBJDUMP) -d $^ > $@
	

main.out: main.o peterson.o
	$(CC) $(FLAGS) -o $@ $^

.PHONY: objdump
objdump: peterson.da 


.PHONY: run
run: main.out
	./main.out

.PHONY: clean
clean: 
	rm -f *.out *.da *.o
