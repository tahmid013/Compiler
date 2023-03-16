.MODEL SMALL
.STACK 100H
.DATA
	t0 dw ?
	a1_1 dw ?
	x1_2 dw ?
	t1 dw ?
	t2 dw ?
	t3 dw ?
	b1_2 dw ?
	a1_2 dw ?
	a1_3_1 dw ?
	b1_3_1 dw ?
	t4 dw ?
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

f PROC

	pop address
	pop a1_1
	mov ax, 2
	mov bx, a1_1
	mul bx
	mov t0, ax
	push t0
	push address
	ret
	mov ax, 9
	mov a1_1, ax
	f endp
g PROC

	pop address
	pop b1_2
	pop a1_2

	push address
	push a1_2
	call f
	pop t1
	pop address


	push address
	push a1_2
	call f
	pop t1
	pop address

	mov ax, t1
	add ax,  a1_2
	mov t2, ax

	push address
	push a1_2
	call f
	pop t1
	pop address


	push address
	push a1_2
	call f
	pop t1
	pop address

	mov ax, t1
	add ax,  a1_2
	mov t2, ax
	add ax,  b1_2
	mov t3, ax
	mov x1_2, ax
	push x1_2
	push address
	ret
	g endp
MAIN PROC

	;INITIALIZE DATA SEGMENT
	MOV AX, @DATA
	MOV DS, AX

	mov ax, 1
	mov a1_3_1, ax
	mov ax, 2
	mov b1_3_1, ax

	push address
	push a1_3_1
	push b1_3_1
	call g
	pop t4
	pop address

	mov ax, t4
	mov a1_3_1, ax

	MOV AX, a1_3_1
	CALL PRINT_ID
	push 0
	push address
	MOV AH , 4CH
	INT 21H
	endp main
end main
