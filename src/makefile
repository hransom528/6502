all: main rotateLights lcdHelloWorld decToBin

main: main.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o main main.s # && minipro -p AT28C256 -w main
	
rotateLights: rotateLights.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o rotateLights rotateLights.s # && minipro -p AT28C256 -w rotateLights

lcdHelloWorld: lcdHelloWorld.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o lcdHelloWorld lcdHelloWorld.s # && minipro -p AT28C256 -w lcdHelloWorld

decToBin: decToBin.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o decToBin decToBin.s # && minipro -p AT28C256 -w decToBin
	
clean: main rotateLights lcdHelloWorld decToBin
	rm main rotateLights lcdHelloWorld decToBin
