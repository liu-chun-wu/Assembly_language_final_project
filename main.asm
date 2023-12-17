INCLUDE Irvine32.inc
.data
board BYTE 90 DUP('+') 
sourceX DWORD 0
sourceY DWORD 0
targetX DWORD 0
targetY DWORD 0
x_axis BYTE "  0 1 2 3 4 5 6 7 8 x",0
y_axis BYTE "y",0
error_message BYTE "Invalid Input",0
playing_turn DWORD 1 ;1 stand for its green's turn ,2 stand for its red's turn
green_playing_turn_message BYTE "It is green's turn:",0
red_playing_turn_message BYTE "It is red's turn:",0
green_win_announcement BYTE "green is winner",0
red_win_announcement BYTE "Red is winner",0
game_status DWORD 3 ;3 stand for game not over ,1 stand for green win ,2 stand for red win
game_restart DWORD 0
game_terminate DWORD 0
game_re_enter DWORD 0
game_hint1 BYTE "First input (x,y) of the piece you want to move",0
game_hint2 BYTE "Then input (x,y) of the coordinate you want to move to",0
game_hint3 BYTE "Press 10 to restart or Press 11 to leave the game or Press 12 to re-enter you input",0
.code
init PROC uses eax ebx ecx edx
    mov edi,OFFSET board
    mov ecx,90
ini_board:
    mov al, 2bh
    mov [edi],al
    inc edi
    loop ini_board

    sub edi,90

    mov al,1h;C
    mov [edi],al
    mov [edi+8],al
    mov al,2h;H
    mov [edi+1],al
    mov [edi+7],al
    mov al,3h;E
    mov [edi+2],al
    mov [edi+6],al
    mov al,4h;W
    mov [edi+3],al
    mov [edi+5],al
    mov al,5h;G
    mov [edi+4],al
    mov al,6h;P
    mov [edi+19],al
    mov [edi+25],al
    mov al,7h;S
    mov [edi+27],al
    mov [edi+29],al
    mov [edi+31],al
    mov [edi+33],al
    mov [edi+35],al

    mov al,11h
    mov [edi+81], al
    mov [edi+89], al
    mov al,12h
    mov [edi+82], al
    mov [edi+88], al
    mov al,13h
    mov [edi+83], al
    mov [edi+87], al
    mov al,14h
    mov [edi+84], al
    mov [edi+86], al
    mov al,15h
    mov [edi+85], al
    mov al,16h
    mov [edi+64], al
    mov [edi+70], al
    mov al,17h
    mov [edi+54], al
    mov [edi+56], al
    mov [edi+58], al
    mov [edi+60], al
    mov [edi+62], al
    mov eax,3
    mov game_status,eax
    mov eax,1
    mov playing_turn,eax
    mov eax,0
    mov game_restart,eax
    mov eax,0
    mov game_re_enter,eax
    ret
init ENDP
 
print_chessboard PROC uses eax ebx ecx edx
    call Clrscr
    mov edi,OFFSET board
    mov ecx,10d
    mov ebx,0

    mov edx,OFFSET x_axis
    call WriteString
    call Crlf
    
    l1:
    .IF ecx == 5
        mov eax,white+(black*16)
        call SetTextColor
        push ecx
        mov ecx,19
        l3:
        mov eax,'-'
        call WriteChar
        loop l3
        pop ecx
        call crlf
    .ENDIF

    mov eax,white+(black*16)
    call SetTextColor
    mov eax,10
    sub eax,ecx
    call WriteDec
    mov eax,' '
    call WriteChar
    


    push ecx
    mov ecx,9d
    
    l2:
    mov eax,[edi+ebx]

    .IF al == '+'
        push eax
        mov  eax,white+(black*16)
        call SetTextColor
        pop eax
	    call WriteChar
        jmp bottom
    .ENDIF
    .IF al != '+'
        .IF al > 10h
            push eax
            mov  eax,green+(black*16)
            call SetTextColor
            pop eax
        .ENDIF
        .IF al < 10h
            push eax
            mov  eax,red+(black*16)
            call SetTextColor
            pop eax
        .ENDIF
        .IF al == 1h
            mov al, 43h
        .ENDIF
        .IF al == 2h
            mov al, 48h
        .ENDIF
        .IF al == 3h
            mov al, 45h
        .ENDIF
        .IF al == 4h
            mov al, 57h
        .ENDIF
        .IF al == 5h
            mov al, 47h
        .ENDIF
        .IF al == 6h
            mov al, 50h
        .ENDIF
        .IF al == 7h
            mov al, 53h
        .ENDIF
         .IF al == 11h
            mov al, 43h
        .ENDIF
        .IF al == 12h
            mov al, 48h
        .ENDIF
        .IF al == 13h
            mov al, 45h
        .ENDIF
        .IF al == 14h
            mov al, 57h
        .ENDIF
        .IF al == 15h
            mov al, 47h
        .ENDIF
        .IF al == 16h
            mov al, 50h
        .ENDIF
        .IF al == 17h
            mov al, 53h
        .ENDIF
        call WriteChar
    .ENDIF
    bottom:
    mov eax,' '
    call WriteChar
    inc ebx

    dec ecx
    jne l2

    call Crlf
    pop ecx

    dec ecx
    jne l1
            
    mov  eax,white+(black*16)
    call SetTextColor


    mov edx,OFFSET y_axis
    call WriteString
    call Crlf
    call Crlf

    mov edx,OFFSET game_hint1
    call WriteString
    call Crlf

    mov edx,OFFSET game_hint2
    call WriteString
    call Crlf

    mov edx,OFFSET game_hint3
    call WriteString
    call Crlf
    call Crlf

    mov eax,game_status
    .IF eax != 3
        jmp btm
    .ENDIF

    mov eax,playing_turn
    .IF eax == 1h
        mov edx,OFFSET green_playing_turn_message
    .ENDIF
    .IF eax == 2h
        mov edx,OFFSET red_playing_turn_message
    .ENDIF

    call WriteString
    call Crlf

btm:
    ret
print_chessboard ENDP

print_error_message PROC uses eax ebx ecx edx
    mov edx,OFFSET error_message
    call WriteString
    call crlf
    call WaitMsg
    ret
print_error_message ENDP

print_green_win PROC uses eax ebx ecx edx
    mov edx,OFFSET green_win_announcement
    call WriteString
    call crlf
    ret
print_green_win ENDP

print_red_win PROC uses eax ebx ecx edx
    mov edx,OFFSET red_win_announcement
    call WriteString
    call crlf
    ret
print_red_win ENDP
 
move PROC uses eax ebx ecx edx
    LOCAL temp:BYTE
    mov eax,0
    mov eax,sourceY
    mov bl,9
    mul bl
    mov ebx,sourceX
    add eax,ebx
    mov edi,OFFSET board
    mov bl,[edi+eax]
    mov temp,bl
    mov bl,'+'
    mov [edi+eax],bl

    mov eax,targetY
    mov bl,9
    mul bl
    mov ebx,targetX
    add eax,ebx
    mov bl,temp
    mov [edi+eax],bl

    mov eax,playing_turn
    .IF eax == 1
        mov eax,2h
        mov playing_turn,eax
        jmp bottom
    .ENDIF 
    .IF eax == 2
        mov eax,1h
        mov playing_turn,eax
        jmp bottom
    .ENDIF
    bottom:
    ret
move ENDP

restart PROC uses eax ebx ecx edx
    mov eax,1
    mov game_restart,eax
    ret
restart ENDP

terminate PROC uses eax ebx ecx edx
    mov eax,1
    mov game_terminate,eax
    ret
terminate ENDP

re_enter PROC uses eax ebx ecx edx
    call Clrscr
    call print_chessboard
    call input
    ret
re_enter ENDP

input PROC uses eax ebx ecx edx
    input_sourceX:
    call ReadDec
    .IF eax == 10
        call restart
        jmp bottom
    .ENDIF
    .IF eax == 11
        call terminate
        jmp bottom
    .ENDIF
    .IF eax == 12
        call re_enter
        jmp bottom
    .ENDIF
    .IF eax > 8
        call print_error_message
        jmp bottom
    .ENDIF
    mov sourceX,eax
    ;-----------------------
    input_sourceY:
    call ReadDec
    .IF eax == 10
        call restart
        jmp bottom
    .ENDIF
    .IF eax == 11
        call terminate
        jmp bottom
    .ENDIF
    .IF eax == 12
        call re_enter
        jmp bottom
    .ENDIF
    .IF eax > 9
        call print_error_message
        jmp bottom
    .ENDIF
    mov sourceY,eax
    ;-----------------------
    input_targetX:
    call ReadDec
    .IF eax == 10
        call restart
        jmp bottom
    .ENDIF
    .IF eax == 11
        call terminate
        jmp bottom
    .ENDIF
    .IF eax == 12
        call re_enter
        jmp bottom
    .ENDIF
    .IF eax > 8
        call print_error_message
        jmp bottom
    .ENDIF
    mov targetX,eax
    ;-----------------------
    input_targetY:
    call ReadDec
    .IF eax == 10
        call restart
        jmp bottom
    .ENDIF
    .IF eax == 11
        call terminate
        jmp bottom
    .ENDIF
    .IF eax == 12
        call re_enter
        jmp bottom
    .ENDIF
    .IF eax > 9
        call print_error_message
        jmp bottom
    .ENDIF
    mov targetY,eax
    ;-------------------------
    bottom:
    ret
input ENDP

play_car PROC uses eax ebx ecx edx
    
    LOCAL if_no_ally_on_target:DWORD, current:BYTE, target:BYTE

    mov eax, 0
    mov if_no_ally_on_target, eax
    mov current, al
    mov target, al
    mov edi, OFFSET board

    mov eax, sourceX
    mov ebx, targetX

    .IF eax != ebx
        mov eax, sourceY
        mov ebx, targetY
        .IF eax != ebx
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    mov eax, sourceX
    mov ebx, targetX
    
    .IF eax == ebx
        mov eax, sourceY
        mov ebx, targetY
        .IF eax >= ebx
            mov ecx, eax
            sub ecx, ebx
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_verti_up
        .ENDIF
        .IF eax < ebx
            mov ecx, ebx
            sub ecx, eax
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_verti_down
        .ENDIF
    .ENDIF
    .IF eax != ebx
        .IF eax >= ebx
            mov ecx, eax
            sub ecx, ebx
            mov eax, sourceY
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_hori_left
        .ENDIF
        .IF eax < ebx
            mov ecx, ebx
            sub ecx, eax
            mov eax, sourceY
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_hori_right
        .ENDIF
    .ENDIF

check_hori_left:
    .IF ecx == 1
        jmp assign
     .ENDIF
    sub eax, 1
    mov bl, [edi+eax]
    .IF bl != '+'
        call print_error_message
        ret
    .ENDIF
    loop check_hori_left

check_hori_right:
    .IF ecx == 1
        jmp assign
     .ENDIF
    add eax, 1
    mov bl, [edi+eax]
    .IF bl != '+'
        call print_error_message
        ret
    .ENDIF
    loop check_hori_right

check_verti_up:
    .IF ecx == 1
        jmp assign
     .ENDIF
    sub eax, 9
    mov bl, [edi+eax]
    .IF bl != '+'
        mov ebx, targetY
        call print_error_message
        ret
    .ENDIF
    loop check_verti_up   

check_verti_down:
    .IF ecx == 1
        jmp assign
     .ENDIF
    mov ebx, 9
    add eax, ebx
    mov bl, [edi+eax]
    .IF bl != '+'
        mov ebx, targetY
        call print_error_message
        ret
    .ENDIF
    loop check_verti_down

assign:
    mov eax, targetY
    mov bl, 9
    mul bl
    mov ebx, targetX
    add eax, ebx
    mov bl, [edi+eax]
    mov target, bl

    mov eax, sourceY
    mov bl, 9
    mul bl
    mov ebx, sourceX
    add eax, ebx
    mov bl, [edi+eax]
    mov current, bl

    mov al,current
    mov bl,target 
    .IF bl == '+'
        mov eax,1
        mov if_no_ally_on_target,eax
    .ENDIF
    .IF bl != '+'
        .IF al > 10h
            .IF bl < 10h
                mov eax,1
                mov if_no_ally_on_target,eax
                jmp m
            .ENDIF
        .ENDIF
        mov al,current
        mov bl,target
        .IF al < 10h
            .IF bl > 10h
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
        .ENDIF
    .ENDIF
m:
    mov eax,if_no_ally_on_target
    .IF eax == 1
        call move
        ret
    .ENDIF

    call print_error_message
    ret
play_car ENDP
;-----------------------------------------------------------
play_horse PROC uses eax ebx ecx edx

    LOCAL if_no_ally_on_target:DWORD, current:BYTE, target:BYTE, hori:DWORD, verti:DWORD

    mov eax, 0
    mov if_no_ally_on_target, eax
    mov current, al
    mov target, al
    mov edi, OFFSET board

    mov eax, sourceX
    mov ebx, targetX
    .IF eax == ebx
        call print_error_message
        ret
    .ENDIF
    .IF eax != ebx
        .IF eax > ebx
            sub eax, ebx
            .IF eax == 1
                mov eax, sourceY
                mov ebx, targetY
                .IF eax > ebx
                    sub eax, ebx
                    .IF eax != 2
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 1
                    mov verti, 2
                    jmp left_up
                .ENDIF
                .IF eax < ebx
                    sub ebx, eax
                    .IF ebx != 2
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 1
                    mov verti, 2
                    jmp left_down
                .ENDIF
            .ENDIF
            .IF eax == 2
                mov eax, sourceY
                mov ebx, targetY
                .IF eax > ebx
                    sub eax, ebx
                    .IF eax != 1
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 2
                    mov verti, 1
                    jmp left_up
                .ENDIF
                .IF eax < ebx
                    sub ebx, eax
                    .IF ebx != 1
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 2
                    mov verti, 1
                    jmp left_down
                .ENDIF
            .ENDIF
        .ENDIF
        .IF eax < ebx
            sub ebx, eax
            .IF ebx == 1
                mov eax, sourceY
                mov ebx, targetY
                .IF eax > ebx
                    sub eax, ebx
                    .IF eax != 2
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 1
                    mov verti, 2
                    jmp right_up
                .ENDIF
                .IF eax < ebx
                    sub ebx, eax
                    .IF ebx != 2
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 1
                    mov verti, 2
                    jmp right_down
                .ENDIF
            .ENDIF
            .IF ebx == 2
                mov eax, sourceY
                mov ebx, targetY
                .IF eax > ebx
                    sub eax, ebx
                    .IF eax != 1
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 2
                    mov verti, 1
                    jmp right_up
                .ENDIF
                .IF eax < ebx
                    sub ebx, eax
                    .IF ebx != 1
                        call print_error_message
                        ret
                    .ENDIF
                    mov hori, 2
                    mov verti, 1
                    jmp right_down
                .ENDIF
            .ENDIF
        .ENDIF
    .ENDIF

left_up:
    mov eax, hori
    .IF eax == 1
        mov eax, sourceY
        dec eax
        mov bl, 9
        mul bl
        mov ebx, sourceX
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF
    .IF eax == 2
        mov eax, sourceY
        mov bl, 9
        mul bl
        mov ebx, sourceX
        dec ebx
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF
    
left_down:
    mov eax, hori
    .IF eax == 1
        mov eax, sourceY
        inc eax
        mov bl, 9
        mul bl
        mov ebx, sourceX
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
     .ENDIF
    .IF eax == 2
        mov eax, sourceY
        mov bl, 9
        mul bl
        mov ebx, sourceX
        dec ebx
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF

right_up:
    mov eax, hori
    .IF eax == 1
        mov eax, sourceY
        dec eax
        mov bl, 9
        mul bl
        mov ebx, sourceX
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF
    .IF eax == 2
        mov eax, sourceY
        mov bl, 9
        mul bl
        mov ebx, sourceX
        inc ebx
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF

right_down:
    mov eax, hori
    .IF eax == 1
        mov eax, sourceY
        inc eax
        mov bl, 9
        mul bl
        mov ebx, sourceX
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF
    .IF eax == 2
        mov eax, sourceY
        mov bl, 9
        mul bl
        mov ebx, sourceX
        inc ebx
        add eax, ebx
        mov bl, [edi+eax]
        .IF bl != '+'
            call print_error_message
            ret
        .ENDIF
        jmp assign
    .ENDIF

assign:
    mov eax, targetY
    mov bl, 9
    mul bl
    mov ebx, targetX
    add eax, ebx
    mov bl, [edi+eax]
    mov target, bl

    mov eax, sourceX
    mov bl, 9
    mul bl
    mov ebx, sourceY
    add eax, ebx
    mov bl, [edi+eax]
    mov current, bl

    mov al,current
    mov bl,target 
    .IF bl == '+'
        mov eax,1
        mov if_no_ally_on_target,eax
    .ENDIF
    .IF bl != '+'
        .IF al > 10h
            .IF bl < 10h
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
        .ENDIF
        .IF al < 10h
            .IF bl > 10h
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
        .ENDIF
    .ENDIF
    mov eax,if_no_ally_on_target
    .IF eax == 1
        call move
        ret
    .ENDIF

    call print_error_message
    ret
play_horse ENDP
;----------------------------------------------------------
play_elephant PROC uses eax ebx ecx edx       
    LOCAL if_X_same:DWORD,if_Y_same:DWORD,if_path_middle_empty:DWORD,if_no_ally_on_target:DWORD,if_not_cross_river:DWORD,current:BYTE,target:BYTE
    mov eax,0
    mov if_X_same,eax
    mov if_Y_same,eax
    mov if_path_middle_empty,eax
    mov if_no_ally_on_target,eax
    mov if_not_cross_river,eax

    ;up_right(2,-2)
    mov eax,sourceX
    .IF eax < 7
        mov eax,sourceY
        .IF eax > 1

            mov eax,sourceX
            add eax,2
            mov ebx,targetX
            .IF eax == ebx
                mov if_X_same,1
            .ENDIF

            mov eax,sourceY
            sub eax,2
            mov ebx,targetY
            .IF eax == ebx
                mov if_Y_same,1
            .ENDIF

            mov eax,0
            mov eax,sourceY
            sub eax,1
            mov bl,9
            mul bl
            mov ebx,sourceX
            add ebx,1
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            .IF bl == '+'
                mov eax,1
                mov if_path_middle_empty,eax
            .ENDIF

            mov eax,0
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov current,bl

            mov eax,0
            mov eax,sourceY
            sub eax,2
            mov bl,9
            mul bl
            mov ebx,sourceX
            add ebx,2
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov target,bl

            mov al,current
            mov bl,target
            .IF bl == '+'
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
            .IF bl != '+'
                .IF al > 10h
                    .IF bl < 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
                .IF al < 10h
                    .IF bl > 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
            .ENDIF

            mov eax,playing_turn
            .IF eax == 2
                mov eax,1
                mov if_not_cross_river,eax
                jmp bottom1
            .ENDIF
            .IF eax == 1
                mov eax,sourceY
                sub eax,2
                .IF eax > 4
                    mov eax,1
                    mov if_not_cross_river,eax
                .ENDIF
            .ENDIF

            bottom1:
            mov eax,if_X_same
            mov ebx,if_Y_same
            and eax,ebx
            mov ebx,if_path_middle_empty
            and eax,ebx
            mov ebx,if_no_ally_on_target
            and eax,ebx
            mov ebx,if_not_cross_river
            and eax,ebx

            .IF eax == 1
                call move
                ret
            .ENDIF

        .ENDIF
    .ENDIF
    ;--------------
    mov eax,0
    mov if_X_same,eax
    mov if_Y_same,eax
    mov if_path_middle_empty,eax
    mov if_no_ally_on_target,eax
    mov if_not_cross_river,eax
    ;up_left (-2,-2)
    mov eax,sourceX
    .IF eax  > 1
        mov eax,sourceY
        .IF eax > 1

            mov eax,sourceX
            sub eax,2
            mov ebx,targetX
            .IF eax == ebx
                mov if_X_same,1
            .ENDIF

            mov eax,sourceY
            sub eax,2
            mov ebx,targetY
            .IF eax == ebx
                mov if_Y_same,1
            .ENDIF

            mov eax,0
            mov eax,sourceY
            sub eax,1
            mov bl,9
            mul bl
            mov ebx,sourceX
            sub ebx,1
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            .IF bl == '+'
                mov eax,1
                mov if_path_middle_empty,eax
            .ENDIF

            mov eax,0
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov current,bl

            mov eax,0
            mov eax,sourceY
            sub eax,2
            mov bl,9
            mul bl
            mov ebx,sourceX
            sub ebx,2
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov target,bl

            mov al,current
            mov bl,target
            .IF bl == '+'
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
            .IF bl != '+'
                .IF al > 10h
                    .IF bl < 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
                .IF al < 10h
                    .IF bl > 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
            .ENDIF

            mov eax,playing_turn
            .IF eax == 2
                mov eax,1
                mov if_not_cross_river,eax
                jmp bottom2
            .ENDIF
            .IF eax == 1
                mov eax,sourceY
                sub eax,2
                .IF eax > 4
                    mov eax,1
                    mov if_not_cross_river,eax
                .ENDIF
            .ENDIF
            bottom2:
            mov eax,if_X_same
            mov ebx,if_Y_same
            and eax,ebx
            mov ebx,if_path_middle_empty
            and eax,ebx
            mov ebx,if_no_ally_on_target
            and eax,ebx
            mov ebx,if_not_cross_river
            and eax,ebx

            .IF eax == 1
                call move
                ret
            .ENDIF

        .ENDIF
    .ENDIF
    ;--------------
    mov eax,0
    mov if_X_same,eax
    mov if_Y_same,eax
    mov if_path_middle_empty,eax
    mov if_no_ally_on_target,eax
    mov if_not_cross_river,eax
    ;down_right(2,2)
    mov eax,sourceX
    .IF eax < 7
        mov eax,sourceY
        .IF eax < 8

            mov eax,sourceX
            add eax,2
            mov ebx,targetX
            .IF eax == ebx
                mov if_X_same,1
            .ENDIF

            mov eax,sourceY
            add eax,2
            mov ebx,targetY
            .IF eax == ebx
                mov if_Y_same,1
            .ENDIF

            mov eax,0
            mov eax,sourceY
            add eax,1
            mov bl,9
            mul bl
            mov ebx,sourceX
            add ebx,1
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            .IF bl == '+'
                mov eax,1
                mov if_path_middle_empty,eax
            .ENDIF

            mov eax,0
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov current,bl

            mov eax,0
            mov eax,sourceY
            add eax,2
            mov bl,9
            mul bl
            mov ebx,sourceX
            add ebx,2
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov target,bl

            mov al,current
            mov bl,target
            .IF bl == '+'
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
            .IF bl != '+'
                .IF al > 10h
                    .IF bl < 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
                .IF al < 10h
                    .IF bl > 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
            .ENDIF

            mov eax,playing_turn
            .IF eax == 1
                mov eax,1
                mov if_not_cross_river,eax
                jmp bottom3
            .ENDIF
            .IF eax == 2
                mov eax,sourceY
                add eax,2
                .IF eax < 5
                    mov eax,1
                    mov if_not_cross_river,eax
                .ENDIF
            .ENDIF
            bottom3:
            mov eax,if_X_same
            mov ebx,if_Y_same
            and eax,ebx
            mov ebx,if_path_middle_empty
            and eax,ebx
            mov ebx,if_no_ally_on_target
            and eax,ebx
            mov ebx,if_not_cross_river
            and eax,ebx

            .IF eax == 1
                call move
                ret
            .ENDIF

        .ENDIF
    .ENDIF
    ;--------------
    mov eax,0
    mov if_X_same,eax
    mov if_Y_same,eax
    mov if_path_middle_empty,eax
    mov if_no_ally_on_target,eax
    mov if_not_cross_river,eax
    ;down_left(-2,2)
    mov eax,sourceX
    .IF eax > 1
        mov eax,sourceY
        .IF eax < 8

            mov eax,sourceX
            sub eax,2
            mov ebx,targetX
            .IF eax == ebx
                mov if_X_same,1
            .ENDIF

            mov eax,sourceY
            add eax,2
            mov ebx,targetY
            .IF eax == ebx
                mov if_Y_same,1
            .ENDIF

            mov eax,0
            mov eax,sourceY
            add eax,1
            mov bl,9
            mul bl
            mov ebx,sourceX
            sub ebx,1
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            .IF bl == '+'
                mov eax,1
                mov if_path_middle_empty,eax
            .ENDIF

            mov eax,0
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov current,bl

            mov eax,0
            mov eax,sourceY
            add eax,2
            mov bl,9
            mul bl
            mov ebx,sourceX
            sub ebx,2
            add eax,ebx
            mov edi,OFFSET board
            mov bl,[edi+eax]
            mov target,bl

            mov al,current
            mov bl,target
            .IF bl == '+'
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
            .IF bl != '+'
                .IF al > 10h
                    .IF bl < 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
                .IF al < 10h
                    .IF bl > 10h
                        mov eax,1
                        mov if_no_ally_on_target,eax
                    .ENDIF
                .ENDIF
            .ENDIF

            mov eax,playing_turn
            .IF eax == 1
                mov eax,1
                mov if_not_cross_river,eax
                jmp bottom4
            .ENDIF
            .IF eax == 2
                mov eax,sourceY
                add eax,2
                .IF eax < 5
                    mov eax,1
                    mov if_not_cross_river,eax
                .ENDIF
            .ENDIF
            bottom4:
            mov eax,if_X_same
            mov ebx,if_Y_same
            and eax,ebx
            mov ebx,if_path_middle_empty
            and eax,ebx
            mov ebx,if_no_ally_on_target
            and eax,ebx
            mov ebx,if_not_cross_river
            and eax,ebx

            .IF eax == 1
                call move
                ret
            .ENDIF

        .ENDIF
    .ENDIF
    ;--------------

    call print_error_message
    ret
play_elephant ENDP
;---------------------------------------------------------
play_warrior PROC uses eax ebx ecx edx
    local temp:BYTE
    mov eax,0
    mov eax,targetY
    mov bl,9
    mul bl
    mov ebx,targetX
    add eax,ebx
    mov edi,OFFSET board
    mov bl,[edi+eax]
    mov temp,bl
 
    mov eax,playing_turn
    .if eax == 1
        mov al,temp
        .if al != '+'
            .if al > 10h
                call print_error_message
                ret
            .endif
        .endif
        mov eax,sourceX
        mov ebx,targetX
        .if eax == ebx
            call print_error_message
            ret
        .endif
        .if ebx < 3
            call print_error_message
            ret
        .endif
        .if ebx > 5
            call print_error_message
            ret
        .endif
        .if eax > ebx
            sub eax,ebx
            .if eax != 1
                call print_error_message
                ret
            .endif
        .endif
        mov eax,sourceX
        mov ebx,targetX
        .if eax < ebx
            sub ebx,eax
            .if ebx != 1
                call print_error_message
                ret
            .endif
        .endif
        ;-------------------------------------
        mov eax,sourceY
        mov ebx,targetY
        .if eax == ebx
            call print_error_message
            ret
        .endif
        .if ebx < 7
            call print_error_message
            ret
        .endif
        .if ebx > 9
            call print_error_message
            ret
        .endif
        .if eax > ebx
            sub eax,ebx
            .if eax != 1
                call print_error_message
                ret
            .endif
        .endif
        mov eax,sourceX
        mov ebx,targetX
        .if eax < ebx
            sub ebx,eax
            .if ebx != 1
                call print_error_message
                ret
            .endif
        .endif
    .endif
 
    mov eax,playing_turn
    .if eax == 2
        mov al,temp
        .if al < 10h
            call print_error_message
            ret
        .endif
        mov eax,sourceX
        mov ebx,targetX
        .if eax == ebx
            call print_error_message
            ret
        .endif
        .if ebx < 3
            call print_error_message
            ret
        .endif
        .if ebx > 5
            call print_error_message
            ret
        .endif
        .if eax > ebx
            sub eax,ebx
            .if eax != 1
                call print_error_message
                ret
            .endif
        .endif
        mov eax,sourceY
        mov ebx,targetY
        .if eax < ebx
            sub ebx,eax
            .if ebx != 1
                call print_error_message
                ret
            .endif
        .endif
        ;------------------------------------
        mov eax,sourceY
        mov ebx,targetY
        .if eax == ebx
            call print_error_message
            ret
        .endif
        .if ebx < 0
            call print_error_message
            ret
        .endif
        .if ebx > 2
            call print_error_message
            ret
        .endif
        .if eax > ebx
            sub eax,ebx
            .if eax != 1
                call print_error_message
                ret
            .endif
        .endif
        mov eax,sourceY
        mov ebx,targetY
        .if eax < ebx
            sub ebx,eax
            .if ebx != 1
                call print_error_message
                ret
            .endif
        .endif
    .endif
 
    call move
    ret
play_warrior ENDP
;---------------------------------------------------------
play_general PROC uses eax ebx ecx edx
    LOCAL if_no_ally_on_target:DWORD,current:BYTE,target:BYTE
    mov eax,0
    mov if_no_ally_on_target,eax

    mov eax,sourceY
    .IF eax > 4 ;黑方的將
        mov eax,targetX
        .IF eax > 5
            call print_error_message
            ret
        .ENDIF
        mov eax,targetX
        .IF eax < 3
            call print_error_message
            ret
        .ENDIF
        mov eax,targetY
        .IF eax < 7
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    mov eax, sourceY
    .IF eax < 5 ;紅方的帥
        mov eax,targetX
        .IF eax > 5
            call print_error_message
            ret
        .ENDIF
        mov eax,targetX
        .IF eax < 3
            call print_error_message
            ret
        .ENDIF
        mov eax,targetY
        .IF eax > 2
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    mov eax,sourceX
    mov ebx,targetX
    
    .IF eax < ebx
        sub ebx,eax
        .IF ebx != 1
            call print_error_message
            ret
        .ENDIF

        mov eax,sourceY
        mov ebx,targetY
        sub eax, ebx
        .IF eax != 0
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    .IF eax > ebx
        sub eax,ebx
        .IF eax != 1
            call print_error_message
            ret
        .ENDIF

        mov eax,sourceY
        mov ebx,targetY
        sub eax, ebx
        .IF eax != 0
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    .IF eax == ebx
        mov eax,sourceY
        mov ebx,targetY
        .IF eax > ebx
            sub eax,ebx
            .IF eax != 1
                call print_error_message
                ret
            .ENDIF
        .ENDIF

        mov eax,sourceY
        mov ebx,targetY
        .IF eax < ebx
            sub ebx,eax
            .IF ebx != 1
                call print_error_message
                ret
            .ENDIF
        .ENDIF
    .ENDIF    

    mov edi,OFFSET board

    mov eax,targetY
    mov bl,9
    mul bl
    mov ebx,targetX
    add eax,ebx
    mov bl,[edi+eax]
    mov target,bl
            
    mov eax,sourceY
    mov bl,9
    mul bl
    mov ebx,sourceX
    add eax,ebx
    mov bl,[edi+eax]
    mov current,bl

    mov al,current
    mov bl,target
    .IF bl == '+'
        mov eax,1
        mov if_no_ally_on_target,eax
    .ENDIF
    .IF bl != '+'
        .IF al > 10h
            .IF bl < 10h
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
        .ENDIF
        .IF al < 10h
            .IF bl > 10h
                mov eax,1
                mov if_no_ally_on_target,eax
            .ENDIF
        .ENDIF
    .ENDIF

    mov eax,if_no_ally_on_target
    .IF eax == 1
        call move
        ret
    .ENDIF

    call print_error_message
    ret 
   
play_general ENDP
;------------------------------------------------------------
play_pow PROC uses eax ebx ecx edx
    LOCAL if_no_ally_on_target:DWORD, current:BYTE, target:BYTE, piece_num_on_path:DWORD, temp:DWORD

    mov eax, 0
    mov if_no_ally_on_target, eax
    mov current, al
    mov target, al
    mov piece_num_on_path, eax         ;Initialize len to 0
    ;mov temp, eax        ;Initialize temp to 0
    mov edi, OFFSET board
    

    mov eax, sourceX
    mov ebx, targetX

    .IF eax != ebx
        mov eax, sourceY
        mov ebx, targetY
        .IF eax != ebx
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    mov eax, sourceX
    mov ebx, targetX
    
    .IF eax == ebx
        mov eax, sourceY
        mov ebx, targetY
        .IF eax >= ebx
            mov ecx, eax
            sub ecx, ebx
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_verti_up
        .ENDIF
        .IF eax < ebx
            mov ecx, ebx
            sub ecx, eax
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_verti_down
        .ENDIF
    .ENDIF
    .IF eax != ebx
        .IF eax >= ebx
            mov ecx, eax
            sub ecx, ebx
            mov eax, sourceY
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_hori_left
        .ENDIF
        .IF eax < ebx
            mov ecx, ebx
            sub ecx, eax
            mov eax, sourceY
            mov bl, 9
            mul bl
            mov ebx, sourceX
            add eax, ebx
            jmp check_hori_right
        .ENDIF
    .ENDIF

check_hori_left:
    sub eax, 1
    mov bl, [edi+eax]
    
    .IF bl != '+'
        inc piece_num_on_path
        ;without comment => unable to cross other pieces
        ;.IF ecx != 1
        ;    call print_error_message
        ;    ret
        ;.ENDIF
    .ENDIF
    .IF ecx == 1
        jmp assign
     .ENDIF
    loop check_hori_left

check_hori_right:
    add eax, 1
    mov bl, [edi+eax]
    .IF bl != '+'
        inc piece_num_on_path
        ;.IF ecx != 1
        ;    call print_error_message
        ;    ret
        ;.ENDIF
    .ENDIF
    .IF ecx == 1
        jmp assign
     .ENDIF
    loop check_hori_right

check_verti_up:
    sub eax, 9
    mov bl, [edi+eax]
    .IF bl != '+'
        mov ebx, targetY
        inc piece_num_on_path
        ;.IF ecx != 1
        ;    call print_error_message
        ;    ret
        ;.ENDIF
    .ENDIF
    .IF ecx == 1
        jmp assign
     .ENDIF
    loop check_verti_up   

check_verti_down:
    mov ebx, 9
    add eax, ebx
    mov bl, [edi+eax]
    .IF bl != '+'
        inc piece_num_on_path
        mov ebx, targetY
        ;.IF ecx != 1
        ;    call print_error_message
        ;    ret
        ;.ENDIF
    .ENDIF
    .IF ecx == 1
        jmp assign
     .ENDIF
    loop check_verti_down

assign:
    mov eax, targetY
    mov bl, 9
    mul bl
    mov ebx, targetX
    add eax, ebx
    mov bl, [edi+eax]
    mov target, bl

    mov eax, sourceY
    mov bl, 9
    mul bl
    mov ebx, sourceX
    add eax, ebx
    mov bl, [edi+eax]
    mov current, bl

    mov al,current
    mov bl,target 
    .IF bl == '+'
        mov eax,1
        mov if_no_ally_on_target,eax
    .ENDIF
    .IF bl != '+'
        .IF al > 10h
            .IF bl < 10h
                mov temp, ebx   ;store the value of ebx to temp
                mov ebx, piece_num_on_path    ;To check the value of piece_num_on_path, it has to be stored in a register.
                .IF ebx == 2    
                    mov eax,1
                    mov if_no_ally_on_target,eax
                .ENDIF
                .IF ebx != 2
                    call print_error_message
                    ret
                .ENDIF
                mov ebx, temp
            .ENDIF
        .ENDIF
        .IF al < 10h
            .IF bl > 10h
                mov temp, ebx
                mov ebx, piece_num_on_path
                .IF ebx == 2
                    mov eax,1
                    mov if_no_ally_on_target,eax
                .ENDIF
                ;.IF ebx != 2
                    ;call print_error_message
                    ;ret
                ;.ENDIF
                mov ebx,temp
            .ENDIF
        .ENDIF
    .ENDIF
    mov eax, if_no_ally_on_target
   
    .IF eax == 1
        ; The move is valid, call move
        call move
        ret
    .ENDIF

    ; If the move is not valid, print an error message
    call print_error_message
    
    ret
play_pow ENDP
;-------------------------------------------------------------
play_soilder PROC uses eax ebx ecx edx
    LOCAL if_no_ally_on_target:DWORD,current:BYTE,target:BYTE
    mov eax,0
    mov if_no_ally_on_target,eax
    mov current,al
    mov target,al
    mov edi, OFFSET board

    mov eax,playing_turn    
    .If eax == 1 ; green turn
        mov eax,sourceY
        .IF eax > 4 ;before crossing river
            mov eax,sourceX
            mov ebx,targetX
            .IF eax != ebx
                call print_error_message
                ret
            .ENDIF

            mov eax,sourceY
            mov ebx,targetY

            .IF eax < ebx
                call print_error_message
                ret
            .ENDIF

            sub eax,ebx
            .IF eax != 1
                call print_error_message
                ret
            .ENDIF

            mov eax,targetY
            mov bl,9
            mul bl
            mov ebx,targetX
            add eax,ebx
            mov bl,[edi+eax]
            mov target,bl
            
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov bl,[edi+eax]
            mov current,bl
        .ENDIF

        mov eax,sourceY
        .IF eax < 5 ;after crossing river
            mov eax,sourceX
            mov ebx,targetX
    
            .IF eax < ebx ;right
                sub ebx,eax
                .IF ebx != 1
                    call print_error_message
                    ret
                .ENDIF

                mov eax,sourceY
                mov ebx,targetY
                .IF eax != ebx
                    call print_error_message
                    ret
                .ENDIF
            .ENDIF

            .IF eax > ebx ;left
                sub eax,ebx
                .IF eax != 1
                    call print_error_message
                    ret
                .ENDIF

                mov eax,sourceY
                mov ebx,targetY
                .IF eax != ebx
                    call print_error_message
                    ret
                .ENDIF
            .ENDIF

            .IF eax == ebx
                mov eax,sourceY
                mov ebx,targetY
                .IF eax < ebx          ;cant go backward         
                    call print_error_message
                    ret                    
                .ENDIF

                .IF eax > ebx
                    sub eax,ebx
                    .IF eax != 1
                        call print_error_message
                        ret
                    .ENDIF
                .ENDIF            
            .ENDIF

            mov eax,targetY
            mov bl,9
            mul bl
            mov ebx,targetX
            add eax,ebx
            mov bl,[edi+eax]
            mov target,bl
            
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov bl,[edi+eax]
            mov current,bl                   
        .ENDIF
    .ENDIF

    mov eax,playing_turn    
    .If eax == 2; red turn
        mov eax,sourceY
        .IF eax < 5 ;before crossing river
            mov eax,sourceX
            mov ebx,targetX
            .IF eax != ebx
                call print_error_message
                ret
            .ENDIF

            mov eax,sourceY
            mov ebx,targetY

            .IF eax > ebx
                call print_error_message
                ret
            .ENDIF

            sub ebx,eax
            .IF ebx != 1
                call print_error_message
                ret
            .ENDIF

            mov eax,targetY
            mov bl,9
            mul bl
            mov ebx,targetX
            add eax,ebx
            mov bl,[edi+eax]
            mov target,bl
            
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov bl,[edi+eax]
            mov current,bl   
        .ENDIF

        mov eax,sourceY
        .IF eax > 4 ;after crossing river
            mov eax,sourceX
            mov ebx,targetX
    
            .IF eax < ebx ;right
                sub ebx,eax
                .IF ebx != 1
                    call print_error_message
                    ret
                .ENDIF

                mov eax,sourceY
                mov ebx,targetY
                .IF eax != ebx
                    call print_error_message
                    ret
                .ENDIF
            .ENDIF

            .IF eax > ebx ;left
                sub eax,ebx
                .IF eax != 1
                    call print_error_message
                    ret
                .ENDIF

                mov eax,sourceY
                mov ebx,targetY
                .IF eax != ebx
                    call print_error_message
                    ret
                .ENDIF
            .ENDIF

            .IF eax == ebx
                mov eax,sourceY
                mov ebx,targetY
                .IF eax > ebx          ;cant go backward         
                    call print_error_message
                    ret                    
                .ENDIF

                .IF eax < ebx
                    sub ebx,eax
                    .IF ebx != 1
                        call print_error_message
                        ret
                    .ENDIF
                .ENDIF            
            .ENDIF

            mov eax,targetY
            mov bl,9
            mul bl
            mov ebx,targetX
            add eax,ebx
            mov bl,[edi+eax]
            mov target,bl
            
            mov eax,sourceY
            mov bl,9
            mul bl
            mov ebx,sourceX
            add eax,ebx
            mov bl,[edi+eax]
            mov current,bl                   
        .ENDIF
    .ENDIF

    mov al,current
    mov bl,target 
    .IF bl == '+'
            mov eax,1
            mov if_no_ally_on_target,eax
        .ENDIF
        .IF bl != '+'
            .IF al > 10h
                .IF bl < 10h
                    mov eax,1
                    mov if_no_ally_on_target,eax
                .ENDIF
            .ENDIF
            .IF al < 10h
                .IF bl > 10h
                    mov eax,1
                    mov if_no_ally_on_target,eax
                .ENDIF
            .ENDIF
        .ENDIF
    mov eax,if_no_ally_on_target
    .IF eax == 1
        call move
        ret
    .ENDIF

    call print_error_message
    ret 
play_soilder ENDP
;--------------------------------------------------------
play PROC uses eax ebx ecx edx
    ;use coordinate to calculate the type of piece 
    mov eax,0
    mov eax,sourceY
    mov bl,9
    mul bl
    mov ebx,sourceX
    add eax,ebx
    mov edi,OFFSET board
    add edi,eax
    mov al,[edi]
    ;call correspoding procedure according to the type of piece
    .IF al == '+'
        call print_error_message
        ret
    .ENDIF
    push eax
    mov eax,playing_turn
    .IF eax == 1
        pop eax
        .IF al < 10h
            call print_error_message
            ret
        .ENDIF
    .ENDIF
    .IF eax == 2
        pop eax
        .IF al > 10h
            call print_error_message
            ret
        .ENDIF
    .ENDIF

    .IF al > 10h
        sub al,10h
    .ENDIF
    .IF al == 1h
        call play_car
        ret
    .ENDIF
    .IF al == 2h
        call play_horse
        ret
    .ENDIF
    .IF al == 3h
        call play_elephant
        ret
    .ENDIF
    .IF al == 4h
        call play_warrior
        ret
    .ENDIF
    .IF al == 5h
        call play_general
        ret
    .ENDIF
    .IF al == 6h
        call play_pow
        ret
    .ENDIF
    .IF al == 7h
        call play_soilder
        ret
    .ENDIF
    ret
play ENDP

change_game_status PROC uses eax ebx ecx edx
    LOCAL redalive:DWORD, greenalive:DWORD
    mov eax,0
    mov redalive,eax
    mov greenalive,eax
    mov ecx,90d
    mov edi,OFFSET board    
L1:
    mov bl,[edi]
    .IF bl == 5h
        mov redalive, 2h
    .ENDIF
    .IF bl == 15h
        mov greenalive, 1h
    .ENDIF
    inc edi
    loop L1

    mov eax, redalive
    mov ebx, greenalive
    add eax, ebx
    mov game_status, eax
    ret
change_game_status ENDP

main PROC
    initialize_game:
    call init
    
playing: 
    call change_game_status
    call print_chessboard

    mov eax,game_status
    .IF eax == 1h
        call print_green_win
        mov eax,1
        mov game_restart,eax
        call WaitMsg
    .ENDIF
    .IF eax == 2h
        call print_red_win
        mov eax,1
        mov game_restart,eax
        call WaitMsg
    .ENDIF

    mov eax,game_restart
    .IF eax == 1
        jmp initialize_game
    .ENDIF

    call input

    mov eax,game_restart
    .IF eax == 1
        jmp initialize_game
    .ENDIF

    mov eax,game_terminate
    .IF eax == 1
        jmp game_end
    .ENDIF

    call play

    jmp playing    
    
game_end:

    call WaitMsg
    exit
main ENDP
END main