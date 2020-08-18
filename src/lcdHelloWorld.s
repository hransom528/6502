PORTB = $6000		; Port B of 6522
PORTA = $6001		; Port A of 6522
DDRB =  $6002		; Data Direction Register for Port B of 6522
DDRA =  $6003		; Data Direction Register for Port A of 6522

E =  %10000000		; LCD Enable pin on port A
RW = %01000000		; LCD R/W pin on port A
RS = %00100000		; LCD Register select pin on port A

    .org $8000          ; Start of ROM

reset:
	ldx #$ff	; Initialize stack pointer
	txs

        lda #%11111111	; Set all pins on port B to output 
        sta DDRB
       
	lda #%11100000	; Set top 3 pins on port A to output
	sta DDRA

        lda #%00111000	; 8 bit, 2 line, 5x8 font
        jsr lcd_instruction
	lda #%00001110	; Display on, cursor on, blink off
	jsr lcd_instruction
	lda #%00000110	; Increment and shift cursor, but don't shift display 
	jsr lcd_instruction
	lda #%00000001	; Clear display
	jsr lcd_instruction
	ldx #0		; Initialize X register

print:	
	lda message, x	; Start outputting message with X as index
	beq loop	; Exit if null terminator found
	jsr print_char	; Output selected character of message
	inx		; Increment X register (index)
	jmp print	; Loop to next character

loop:
	jmp loop

message: .asciiz "Hello, world!"

lcd_wait:
	pha		; Push A register (instruction) onto stack
	lda #%00000000	; Set Port B as input 
	sta DDRB

lcd_busy:
	lda #RW		; Set RW, clear E and RS
	sta PORTA
	lda #(RW | E)	; Set E bit
	sta PORTA

	lda PORTB	; Read Port B
	and #%10000000	; Isolate busy flag
	bne lcd_busy	; Loop if LCD is busy

	lda #RW		; Clear E bit
	sta PORTA
	lda #%11111111	; Set Port B back to output	
	sta DDRB
	pla		; Pull instruction to be sent from stack to A register
	rts

lcd_instruction:
	jsr lcd_wait	; Check busy flag
	sta PORTB	; Put instruction on port
	lda #0		; Clear RS/RW/E bits
	sta PORTA
	lda #E		; Set E bit to send instruction
	sta PORTA	
	lda #0		; Clear RS/RW/E bits
	sta PORTA
	rts

print_char:
	jsr lcd_wait	; Check busy flag
	sta PORTB	; Put character on port
	lda #RS		; Set RS, clear RW/E bits
	sta PORTA
	lda #(RS | E)	; Set E bit to send instruction
	sta PORTA
	lda #RS		; Clear E bit
	sta PORTA
	rts

    .org $fffc          ; Reset vector
    .word reset
    .word $0000         ; Padding for EOF
