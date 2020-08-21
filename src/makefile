all: main rotateLights lcdHelloWorld decToBin interrupt

main: main.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o ../bin/main main.s # && minipro -p AT28C256 -w main
	
rotateLights: rotateLights.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o ../bin/rotateLights rotateLights.s # && minipro -p AT28C256 -w rotateLights

lcdHelloWorld: lcdHelloWorld.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o ../bin/lcdHelloWorld lcdHelloWorld.s # && minipro -p AT28C256 -w lcdHelloWorld

decToBin: decToBin.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o ../bin/decToBin decToBin.s # && minipro -p AT28C256 -w decToBin

interrupt: interrupt.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o ../bin/interrupt interrupt.s # && minipro -p AT28C256 -w interrupt
	
clean: main rotateLights lcdHelloWorld decToBin interrupt
	rm main rotateLights lcdHelloWorld decToBin interrupt
