# Scroll "SHE" back and forth on an 8-digit 7-segment display (8255 at 0x640)
# Port A (0x640) = digit select, active low  (0 = digit on, PA0 = rightmost)
# Port B (0x641) = segments, active high     (bits: X g f e d c b a)

        .code16
        .equ PORTA, 0x640
        .equ PORTB, 0x641
        .equ CTRL,  0x643

start:
        mov  $0b10000000,%al     # control word 0x80: Mode 0, ports A, B, C = outputs
        mov  $CTRL,%dx
        out  %al,%dx

        mov  $2,%si              # SI = digit of 'S' (start at right edge)
        mov  $1,%bp              # BP = direction (+1 left, -1 right)

next_pos:
        mov  $100,%di            # DI = refreshes before moving
refresh:
        mov  %si,%cx             # CX = digit for S
        mov  $0x6D,%bl           # S = 0110 1101
        call show
        dec  %cx                 # H is one digit to the right
        mov  $0x76,%bl           # H = 0111 0110
        call show
        dec  %cx                 # E is one more to the right
        mov  $0x79,%bl           # E = 0111 1001
        call show
        dec  %di
        jnz  refresh

        cmp  $7,%si              # at left edge? reverse
        jne  check_right
        mov  $-1,%bp
check_right:
        cmp  $2,%si              # at right edge? reverse
        jne  move
        mov  $1,%bp
move:
        add  %bp,%si             # shift SHE one digit
        jmp  next_pos

# show: BL = segment pattern, CL = digit number (0-7)
show:
        push %cx
        mov  $0xFF,%al           # all digits off (prevents ghosting)
        mov  $PORTA,%dx
        out  %al,%dx
        mov  %bl,%al             # letter pattern -> Port B
        mov  $PORTB,%dx
        out  %al,%dx
        mov  $0xFE,%al           # 1111 1110 = digit 0 on
        rol  %cl,%al             # move the 0 to bit CL = digit CL on
        mov  $PORTA,%dx
        out  %al,%dx
        mov  $0x200,%cx          # short on-time delay
delay:  loop delay
        pop  %cx
        ret
