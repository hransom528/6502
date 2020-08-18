; IO
PORTB = $6000		; Port B of 6522
PORTA = $6001		; Port A of 6522
DDRB =  $6002		; Data Direction Register for Port B of 6522
DDRA =  $6003		; Data Direction Register for Port A of 6522

; RAM
value = $0200		; 2 bytes
mod10 = $0202		; 2 bytes
message = $0204		; 6 bytes
counter = $020a		; 2 bytes

; LCD
E =  %10000000		; LCD Enable pin on port A
RW = %01000000		; LCD R/W pin on port A
RS = %00100000		; LCD Register select pin on port A

	.org $8000      ; Start of ROM

reset:
	ldx #$ff	; Initialize stack pointer
	txs
	cli		; Enable interrupts

	lda #%11111111	; Set all pins on port B to output 
        sta DDRB
	lda #%11100000	; Set top 3 pins on port A to output
	sta DDRA

	; LCD Initialization
        lda #%00111000	; 8 bit, 2 line, 5x8 font
        jsr lcd_instruction
	lda #%00001110	; Display on, cursor on, blink off
	jsr lcd_instruction
	lda #%00000110	; Increment and shift cursor, but don't shift display 
	jsr lcd_instruction
	lda #%00000001	; Clear display
	jsr lcd_instruction
	
	; Initialize counter to 0
	lda #0 
	sta counter
	sta counter + 1

loop:
	; Set LCD cursor to home
	lda #%00000010
	jsr lcd_instruction
	
	; Initialize message
	lda #0
	sta message
	
	; Get counter
	sei		; Disable interrupts while adding
	lda counter
	sta value
	lda counter + 1
	sta value + 1
	cli		; Re-enable interrupts afterwards

divide:
	; Initialize remainder to 0
	lda #0
	sta mod10
	sta mod10 + 1
	clc

	ldx #16
divloop:
	; Rotate quotient and remainder
	rol value
	rol value + 1
	rol mod10
	rol mod10 + 1

	; Get dividend-divisor in A and Y
	sec		; Set carry for subtraction
	lda mod10
	sbc #10		; Subtract 10
	tay		; Save low byte in Y
	lda mod10 + 1	; Get high byte
	sbc #0		

	bcc ignore_result	; Branch if carry clear
	sty mod10		; Update upper half with remainder
	sta mod10 + 1

	
ignore_result:
	dex
	bne divloop	; Branch if X != 0
	rol value	; Shift in last bit of the quotient
	rol value + 1	

	lda mod10
	clc
	adc #"0" 
	jsr push_char
	
	lda value	; If value != 0, continue dividing	
	ora value + 1
	bne divide

	ldx #0		; Initialize X register for print
print:	
	lda message, x	; Start outputting message with X as index
	beq loop	; Exit if null terminator found
	jsr print_char	; Output selected character of message
	inx		; Increment X register (index)
	jmp print	; Loop to next character

number: .word 1729	; Number to convert

; Add the character in the A register to the beginning of the
; null-terminated string 'message'
push_char:
	pha		; Push new first char onto stack
	ldy #0		; Initialize Y (index)

char_loop:
	lda message, y	; Get char from string and put into X
	tax
	pla		; Pull char off stack and add it to string
	sta message, y	
	iny
	txa		; Push char from string onto stack
	pha
	bne char_loop
	
	pla 
	sta message, y	; Pull null terminator off stack and add to end of string
	rts

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

; Interrupts
nmi:
	inc counter
	bne exit_nmi
	inc counter + 1
exit_nmi:
	rti
irq:
	inc counter
	bne exit_irq
	inc counter + 1
exit_irq:
	rti

; Event vectors
    .org $fffa          ; Starting at fffa
    .word nmi		; NMI vector
    .word reset		; Reset vector
    .word irq		; IRQ vector

