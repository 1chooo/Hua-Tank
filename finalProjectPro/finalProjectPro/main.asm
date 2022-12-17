include Irvine32.inc
printStartScene PROTO

; 	���C��   eax = 1
; 	�Ȱ�		eax = 2
; 	�����e��	eax = 3
; 	���}�{��	eax = 4

.data
	; �������ܼƭ�
	windowTitleStr BYTE "Tank V.S Bogy",0 ; ���D
	windowBound    SMALL_RECT <0,0,125,25>    ; �����j�p
	consoleHandle  DWORD ?

	xyPos COORD   <6,5>
	cells_Written DWORD ?

	; �}�l�e�����r
	startStr BYTE " _________    _      ____  _____ ___  ____   ____   ____  ______      ______     ___      ______ ____  ____ "
			 BYTE "|  _   _  |  / \    |_   \|_   _|_  ||_  _| |_  _| |_  _.' ____ \    |_   _ \  .'   `.  .' ___  |_  _||_  _|"
			 BYTE "|_/ | | \_| / _ \     |   \ | |   | |_/ /     \ \   / / | (___ \_|     | |_) |/  .-.  \/ .'   \_| \ \  / /  " 
			 BYTE "    | |    / ___ \    | |\ \| |   |  __'.      \ \ / /   _.____`.      |  __'.| |   | || |   ____  \ \/ /   " 
			 BYTE "   _| |_ _/ /   \ \_ _| |_\   |_ _| |  \ \_     \ ' /_  | \____) | _  _| |__) \  `-'  /\ `.___]  | _|  |_   " 
			 BYTE "  |_____|____| |____|_____|\____|____||____|     \_/(_)  \______.'(_)|_______/ `.___.'  `._____.' |______|  "

	;�L�}�l�e�������ܦr
	enterMsg BYTE "Press ��E�� to enter"
	leaveMsg BYTE "Press ��L�� to leave"

	;�L�Z�J
	startTank BYTE "       \                "
			  BYTE "       _\______         "
			  BYTE "      /        \========"
			  BYTE " ____|__________\_____  "
			  BYTE "/ ___________________ \ "
			  BYTE "\/ _===============_ \/ "
			  BYTE "  \-===============-/   "

	clearTank BYTE "                        "
			  BYTE "                        "
			  BYTE "                        "
			  BYTE "                        "
			  BYTE "                        "
			  BYTE "                        "
			  BYTE "                        "

	;�LBogy
	startBogy BYTE " /===\ "
			  BYTE " |oVo| "
			  BYTE "/ ___ \"
			  BYTE "||===||"
			  BYTE " |_|_| "

	clearBogy BYTE "       "
			  BYTE "       "
			  BYTE "       "
			  BYTE "       "
			  BYTE "       "

	gameIntro BYTE "*****************************************************************"
              BYTE "*                      Game Introduction:                       *"
              BYTE "*              Control the tank to kill the Bogy.               *"
              BYTE "*   Don't cross the green line, or your life will shock down!!  *"
              BYTE "*   Start with 3 lives, once the live reaches zero, you lose!!  *"
              BYTE "*     Kill the last monsters, if you still alive, you win!!     *"
              BYTE "*                                                               *"
              BYTE "*                   How to control the tank:                    *"
              BYTE "*             +    press the 'up' to move up                    *"
              BYTE "*             +  press the 'down' to move down                  *"
              BYTE "*             +  press the 'right' to kill Bogy                 *"
              BYTE "*                                                               *"
              BYTE "*                         How to play:                          *"
              BYTE "*              + press 'space' to start the game                *"
              BYTE "*              +  press 'Esc' to pause the game                 *"
              BYTE "*****************************************************************"

.code

main PROC
	INVOKE GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	
	INVOKE SetConsoleTitle, ADDR windowTitleStr			; �]�w�������D

	INVOKE SetConsoleWindowInfo,						; �]�w�����j�p
     	consoleHandle,
     	TRUE,
     	ADDR windowBound
	
	INVOKE printStartScene
	.IF eax == 4        ;�������}
		jmp ExitProgram
	.ENDIF



	call WaitMsg

ExitProgram:
	exit
main ENDP

printStartScene PROC
	LOCAL cursorInfo:CONSOLE_CURSOR_INFO
	mov cursorInfo.dwSize, 100
	mov cursorInfo.bVisible, 0
	INVOKE SetConsoleCursorInfo,
    	consoleHandle,
        ADDR cursorInfo

	; �M�ŵe��
	call Clrscr

	mov ecx, 6
	mov esi, 0

; �L�}�l�e�������D
ShowStartStr:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [startStr + esi],
		108,
		xyPos,
		ADDR cells_Written

	add esi, 108
	inc xyPos.y
	pop ecx
	loop ShowStartStr

; �L�}�l�e�����ﶵ
PrintOption:
    add xyPos.y, 7
    add xyPos.x, 48

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR enterMsg,
        SIZEOF enterMsg,
        xyPos,
        ADDR cells_Written

    add xyPos.y, 2

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR LeaveMsg,
        SIZEOF LeaveMsg,
        xyPos,
        ADDR cells_Written

	mov ecx, 7
	mov esi, 0
	mov xyPos.x, 20
	mov xyPos.y, 15

PrintStartTank:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [startTank + esi],
		24,
		xyPos,
		ADDR cells_Written

	add esi, 24
	inc xyPos.y
	pop ecx
	loop PrintStartTank

	mov ecx, 5
	mov esi, 0
	mov xyPos.x, 85
	mov xyPos.y, 16

PrintStartBogy:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [startBogy + esi],
		7,
		xyPos,
		ADDR cells_Written

	add esi, 7
	inc xyPos.y
	pop ecx
	loop PrintStartBogy

StartOrNot:
    call ReadChar

	.IF ax == 1265h     ;press e to start game
        call Clrscr
		mov xyPos.x, 28
		mov xyPos.y, 7

		mov ecx, 16
		mov esi, 0
		jmp PrintIntro
    .ENDIF
    .IF ax == 266ch     ;press l to leave
		mov eax, 4
		call Clrscr
        ret
    .ENDIF
	jmp StartOrNot

PrintIntro:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameIntro + esi],
		65,
		xyPos,
		ADDR cells_Written

	add esi, 65
	inc xyPos.y
	pop ecx
	loop PrintIntro

	ret
printStartScene ENDP

END main