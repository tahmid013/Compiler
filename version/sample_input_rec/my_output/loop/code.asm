.MODEL SMALL
.STACK 100H
.DATA
	a1_1_1 dw ?
	b1_1_1 dw ?
	c1_1_1 dw ?
	i1_1_1 dw ?
	t0 dw ?
	t1 dw ?
	t2 dw ?
	t3 dw ?
	address dw ?
	ret_val dw ?
.CODE
PRINT_ID PROC
	pop address
	push bx                        
	push cx                        
	push dx                        
	cmp ax, 0     
	jge start        ;jump if positive number 
	push ax                        
	mov ah, 2                      
	mov dl, "-"    ;print '-' otherwise        
	int 21h                        
	pop ax                         
	neg ax                        
	start:                        
	xor cx, cx    ;clearing register                
	mov bx, 10    ;initalize bx by 10                 
	output_:                       
		xor dx, dx  ;clear dx                
		div bx      ;ax = ax/bx (10)               
		push dx     ;pushing remainder into stack           
		inc cx      ;to count number of digit              
		or ax, ax                   
	jne output_    ;loop until zf not 1                
	mov ah, 2                     
	display:                      
		pop dx       ;printing remainder from reverse order  
		or dl, 30h                  
		int 21h                     
	loop display                  
	mov dl, ' '
	mov ah, 2
	int 21h              
	pop dx                        
	pop cx                        
	pop bx                        
	push address
	ret
PRINT_ID ENDP

MAIN PROC

	;INITIALIZE DATA SEGMENT
	MOV AX, @DATA
	MOV DS, AX

	mov ax, 0
	mov b1_1_1, ax
	mov ax, 1
	mov c1_1_1, ax
	mov ax, 0
	mov i1_1_1, ax
	L4:
	 mov ax, i1_1_1
	cmp ax, 4
	jl L0
	mov ax, 0 
	mov t0, ax
	jmp L1
	L0:
	mov ax, 1 
	mov t0, ax
L1:
	mov ax, t0
	cmp ax, 0
	je L5
	mov ax, 3
	mov a1_1_1, ax
	L2:
	mov ax, a1_1_1
	mov t2, ax
	dec a1_1_1
	mov ax, t2
	cmp ax, 0
	je L3
	mov ax, b1_1_1
	mov t3, ax
	inc b1_1_1
	jmp L2
	L3:
	mov ax, i1_1_1
	mov t1, ax
	inc i1_1_1
	jmp L4
	L5:

	MOV AX, a1_1_1
	CALL PRINT_ID

	MOV AX, b1_1_1
	CALL PRINT_ID

	MOV AX, c1_1_1
	CALL PRINT_ID
	MOV AH , 4CH
	INT 21H
	endp main
end main
