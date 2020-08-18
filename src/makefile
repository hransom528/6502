all: main rotateLights lcdHelloWorld

main: main.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o main main.s # && minipro -p AT28C256 -w main
	
rotateLights: rotateLights.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o rotateLights rotateLights.s # && minipro -p AT28C256 -w rotateLights

lcdHelloWorld: lcdHelloWorld.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o lcdHelloWorld lcdHelloWorld.s # && minipro -p AT28C256 -w lcdHelloWorld
	
clean: main rotateLights lcdHelloWorld
	rm main rotateLights lcdHelloWorld
