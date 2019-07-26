#Aaron VanderGraaff
#CSC 225

all: charCount charCount_a

charCount: 
	cd C && gcc -o charCount charCount.c

charCount_a: 
	cd LC3 && lc3as charCount.asm
	cd LC3 && lc3as main.asm
clean: 
	rm -rf C/*.o
	rm -rf LC3/*.obj
	rm -rf LC3/*.sym

