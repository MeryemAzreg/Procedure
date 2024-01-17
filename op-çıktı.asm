.model small

.data
    row		db	0           ;Create a label and initialize
    column	db	0           ;Create a label and initialize
    char    db  ?           ;Create a label

.code

main proc  
    ;this instr. set up the DS with address of the data section
    ;necessary for the program to access data variables
    mov     ax, @data
    mov     ds, ax  
    
    ;calls the read procedure to get a char from user
    ;char is then stored in the 'char' var.
    
    call    read 
    mov char,al  
    
    ;this is for loop counter, outer loop will execute 5 times
    ; each iteraion represents a ROW in the pattern
    mov cx,5 
    for_i:        
    ;and this is for inner, loop bx is the counter      
        mov bx,5
        for_k:       
        
        ;cursor = to position the cursor on the screen
        ;display= show the char and manage the loop counters for inner loop      
            call    cursor
            call    display
            inc     row    
            dec     bx
        jnz for_k              
        
        ;after completing inner loop for a row, adjust the column and row
        ;counter the next iteration of the outer loop , loop for_i is for
        ;decrease the cx and jump back to for_i if cx not zero
        inc column
        sub row,4
        call cursor   
    loop for_i  
    
    ;ah with 0 val for ending the program, then trigger a software
    ;interrupt int 21h to call the op sys and end the program  
    mov ah,0
    int 21h                 ;0-Program terminate   

QUIT:	RET
        
endp           

;it loads the char into dl, and using int 21h to op the char
display proc                ;write
        mov dl,char
        mov ah,2
        int 21h             ;2-Character output with echo
        ret
display endp
 
 
;ah with 1(char ip ) int 21h to call op sys for ip char 
read    proc
        mov ah,1
        int 21h             ;1-Character input with echo
        ret
read    endp
            
            
;sets up registers with values to position the cursor and
;trigger int 10h to move the cursor            
cursor proc
        mov ah,02h  ; with int 10h, set the cursor position
        mov bh,00h ; default video page    
        mov dl,column   
        mov dh,row       
        int 10h
        ret
cursor endp


end main