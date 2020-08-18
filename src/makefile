all: main rotateLights

main: main.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o main main.s # && minipro -p AT28C256 -w main
	
rotateLights: rotateLights.s
	vasm6502_oldstyle -Fbin -dotdir -esc -o rotateLights rotateLights.s # && minipro -p AT28C256 -w rotateLights
	
clean: main rotateLights
	rm main rotateLights
