  
;*********MAIN PROG*******************
  DOSSEG 
  .186
  .model large
  .stack 200h

;*******MAIN PROG DATA SEG*************
 .data
  Arr dw 10 dup(?)
  Length dw 9  ;size is 10 however index runs through 0-9
 UnsortedPrompt  db   'Unsorted: $'
 SortedPrompt	 db  'Sorted: $'

  ;int main()
;*******MAIN PROG CODE SEG**************
.code
 extrn	PutStr: PROC, PutCrLf: PROC
	extrn	GetDec: PROC, PutDec: PROC

 ProgStart PROC near
 ;initialize the ds register to hold the data segment adress
  mov ax,@data
   mov ds,ax

  call Greet ;greet function 

  ;call input function for the user to enter values
  push  Arr
  call Input

;print the unsorted array upon return from input
   mov dx,OFFSET UnsortedPrompt  ; point to the output mesg
  mov	ah,9	     ; DOS print string function #
   int	21h	     ; print string
  call    PutCrLf

	mov cx,0;counter
	mov bx,0;index

	WHILELOOP:
	 cmp cx,Length
	 jnle ENDWHILELOOP
	 mov ax,[Arr+bx]
	 call	PutDec       ; print the decimal integer in ax
	 call    PutCrLf
	 add bx, 2 ;move to the next index 
	 add cx,1 ;increment the counter
	 jmp WHILELOOP
	 

 	 ENDWHILELOOP:

 	 ;sorting function
         call  PutCrLf
 	 push OFFSET Arr
 	 push Length
  	 call Sort
	 jmp printsort

;print the sorted array upon return from sort
	printsort:
    mov	dx,OFFSET SortedPrompt  ; point to the output mesg
	mov	ah,9	     ; DOS print string function #
	int	21h	     ; print string
	 call    PutCrLf

	mov cx,0;counter
	mov bx,0;index

	WHILELOOP2:
	 cmp cx,Length
	 jnle endprintsort

	 mov ax,[Arr+bx]
	 call	PutDec       ; print the decimal integer in ax
	 call    PutCrLf
	 add bx, 2
	 add cx,1
	 jmp WHILELOOP2
	 

      endprintsort:


   ; Exit to the operating system
	mov	ah,4ch	     ; DOS terminate program fn #
	int	21h
ProgStart endp
;return 0

 
   
  comment |
******* PROCEDURE HEADER **************************************
  PROCEDURE NAME : Greet
  PURPOSE :  To print initial greeting messages to the user
  INPUT PARAMETERS : None
  OUTPUT PARAMETERS or RETURN VALUE:  None
  NON-LOCAL VARIABLES REFERENCED: None
  NON-LOCAL VARIABLES MODIFIED :None
  PROCEDURES CALLED :
	FROM iofar.lib: PutCrLf
  CALLED FROM : main program
|
;****** SUBROUTINE DATA SEGMENT ********************************
	.data
Msgg1	 db  'Program:  Print integers in sorted and unsorted order  $'
Msgg2	 db  'Programmer:Nafis Mortuza $'
Msgg3	 db  'Date: April 8th, 2022 $'


;****** SUBROUTINE CODE SEGMENT ********************************
	.code
Greet	PROC    near

; Save registers on the stack
	pusha
	pushf

; Print name of program
	mov	dx,OFFSET Msgg1 ; set pointer to 1st greeting message
	mov	ah,9	          ; DOS print string function #
	int	21h	          ; print string
	call	PutCrLf

; Print name of programmer
	mov	dx,OFFSET Msgg2    ; set pointer to 2nd greeting message
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf

; Print date
	mov	dx,OFFSET Msgg3    ; set pointer to 3rd greeting message
	mov	ah,9	           ; DOS print string function #
	int	21h	               ; print string
	call	PutCrLf
 	call	PutCrLf


; Restore registers from stack
	popf
	popa

; Return to caller module
	ret
Greet	ENDP

;*************Input***************
.data
Prompt1 db 'Enter an integer: $'
Prompt2 db 'You entered the integer: $'
.code
Input PROC near

 ;push the registers onto stack and initialize bp with the value of sp
  pusha
  pushf
  mov bp,sp

  mov bx,[bp+20] ;access the array passed on stack
  mov cx,0    ;initialize cx to 0
  mov si,0 ;index of the array

  WHILE: 
   cmp cx,10  ;compare the value of cx with the size of the array,num of iterations is 10
   jnl exitwhile

   continue: ;if cx,10 continue 

   printprompt:
   mov dx,OFFSET Prompt1 ;print the prompt for input
   mov ah,9
   int 21h

   call GetDec     ;takes the user input and stores it in the array
   mov [bx+si],ax

   printinput:
   mov dx,OFFSET Prompt2 ;print the input user just entered
   mov ah,9
   int 21h
   call    PutCrLf
   call    PutCrLf

   mov ax,[bx+si];  move the input into ax for printing
   call PutDec
   call    PutCrLf
   call    PutCrLf

   inc cx ;i++
   add si,2 ;move to the index
   jmp WHILE ;loop




   exitwhile:
   ;Restore registers from stack
   popf
	popa

; Return to caller module
	ret	

 Input ENDP
 

 ;****** Sort ********************************
	.data
	h dw ?
	i dw 1
	j dw ?
	y dw ?
	k dw ?


	.code
Sort PROC    near

; Initialize ds register to hold data segment address
	mov	ax,@data
	mov	ds,ax

; Save registers on the stack
	pusha
	pushf
	mov bp, sp
	
	mov cx, [bp + 20] ; cx now holds the length of the array
	mov bx, [bp + 22] ; bx now holds arr
	
	
	
FOR01:
	cmp i, cx     ;compare i with the length of the array
	jg ENDFOR01 ;if i is greater than the length of the array, then jump to the end of the loop
	
	mov ax, i
	mov dx, 2
	mul dx
	mov si, ax
	mov dx, [bx + si]
	mov y, dx
	
	mov di, si
	sub di, 2
	
WHILE02:
	mov dx, [bx + di]
	cmp y, dx
	jge endWHILE02
	mov dx, [bx + di]
	mov [bx + si], dx
	sub si, 2
	cmp di, 0
	je endWHILE02
	sub di, 2
	jmp WHILE02
endWHILE02:
	mov dx, y
	mov [bx + si], dx
	inc i
	jmp FOR01
	
ENDFOR01:
	popf
	popa
	ret 4
Sort ENDP	
 end ProgStart