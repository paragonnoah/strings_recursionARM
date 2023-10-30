.section .data
input_prompt: .asciz "Please enter a string: \n"
output_format: .asciz "%c"
new_line: .asciz "\n"

.section .bss
buffer: .space 100

.section .text
.global _start
_start:

    # Display input prompt
    ldr x0, =input_prompt
    bl printf

    # Allocate stack space for input
    sub sp, sp, #100

    # Read input string to the stack
    ldr x0, sp
    ldr x1, =input_format
    bl scanf

    # Call the reverseString function
    ldr x0, sp
    bl reverseString

    # Clean up stack
    add sp, sp, #100

    # Exit the program
    mov x0, 0
    mov x8, 93
    svc 0

reverseString:
    stp x29, x30, [sp, -16]!   # Store LR and FP
    mov x29, sp                # Set up a new frame pointer

    ldrb x1, [x0], #1         # Load a character from the string
    cbz x1, end_reverse       # If it's null, end the recursion

    # Recursive call to reverseString
    stp x1, x30, [sp, -16]!   # Store the character and LR
    bl reverseString
    ldp x1, x30, [sp], 16     # Restore the character and LR

    # Print the character
    mov x0, x1
    ldr x1, =output_format
    bl printf

    b reverseString

end_reverse:
    ldp x29, x30, [sp], 16     # Restore LR and FP
    ret

.section .data
input_format: .asciz "%c"
