miniwho: miniwho.c
	clang -o miniwho miniwho.c

run: miniwho
	./miniwho

clean:
	rm miniwho
