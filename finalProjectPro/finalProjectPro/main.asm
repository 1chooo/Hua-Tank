include Irvine32.inc
printStartScene PROTO
decStrLevel PROTO, levelNumDec:WORD
decStrScore PROTO, scoreNumDec:WORD
decStrLives PROTO, livesNumDec:WORD
decStrBogys PROTO, bogysNumDec:WORD

printLevel PROTO, xyPosInit:COORD
printScore PROTO, xyPosInit:COORD
printLives PROTO, xyPosInit:COORD
printBogys PROTO, xyPosInit:COORD

bogyWalking PROTO, xyPosInBogy:COORD
bogyClear   PROTO, xyPosInBogy:COORD
printGreenLine PROTO, xyPosInLine:COORD

tankWalking PROTO, xyPosInit:COORD
tankClear   PROTO, xyPosInit:COORD
;controlTank PROTO

; bullet move
noWorkWalking PROTO, xyPosInit:COORD
noWorkClear   PROTO, xyPosInit:COORD

printEndScene PROTO
printGameStage PROTO

initialLevelBogyPos PROTO

; 	���C��   ebx = 1
; 	�Ȱ�		ebx = 2
; 	�����e��	ebx = 3
; 	���}�{��	ebx = 4

.data
	; �������ܼƭ�
	windowTitleStr BYTE "Hua Tank V.S Bogy",0 ; ���D
	windowBound    SMALL_RECT <0,0,125,25>    ; �����j�p
	consoleHandle  DWORD ?

	xyPos COORD   <6,5>
	xyPosTank COORD    <7,15>

	xyPosNoWork0 COORD <15,6>
	xyPosNoWork1 COORD <15,7>
	xyPosNoWork2 COORD <15,8>
	xyPosNoWork3 COORD <15,9>
	xyPosNoWork4 COORD <15,10>
	xyPosNoWork5 COORD <15,11>
	xyPosNoWork6 COORD <15,12>
	xyPosNoWork7 COORD <15,13>
	xyPosNoWork8 COORD <15,14>
	xyPosNoWork9 COORD <15,15>
	xyPosNoWork10 COORD <15,16>
	xyPosNoWork11 COORD <15,17>
	xyPosNoWork12 COORD <15,18>
	xyPosNoWork13 COORD <15,19>
	xyPosNoWork14 COORD <15,20>
	xyPosNoWork15 COORD <15,21>
	xyPosNoWork16 COORD <15,22>
	xyPosNoWork17 COORD <15,23>
	xyPosNoWork18 COORD <15,24>
	xyPosNoWork19 COORD <15,25>
	xyPosNoWork20 COORD <15,26>

	N0  WORD 0
	N1  WORD 0
	N2  WORD 0
	N3  WORD 0
	N4  WORD 0
	N5  WORD 0
	N6  WORD 0
	N7  WORD 0
	N8  WORD 0
	N9  WORD 0
	N10 WORD 0
	N11 WORD 0
	N12 WORD 0
	N13 WORD 0
	N14 WORD 0
	N15 WORD 0
	N16 WORD 0
	N17 WORD 0
	N18 WORD 0
	N19 WORD 0
	N20 WORD 0

	xPosBogy0LevelArr WORD 108, 109, 123
    xPosBogy1LevelArr WORD 135, 133, 124
    xPosBogy2LevelArr WORD 109, 119, 150
    xPosBogy3LevelArr WORD 120, 110, 174
    xPosBogy4LevelArr WORD 111, 124, 153
    xPosBogy5LevelArr WORD 122, 130, 122

    xyPosBogy0 COORD   <?,5>
    xyPosBogy1 COORD   <?,9>
    xyPosBogy2 COORD   <?,13>
    xyPosBogy3 COORD   <?,17>
    xyPosBogy4 COORD   <?,21>
    xyPosBogy5 COORD   <?,25>

	cells_Written DWORD ?

	; �}�l�e�����r
	startStr BYTE " _________    _      ____  _____ ___  ____   ____   ____  ______      ______     ___      ______ ____  ____ "
			 BYTE "|  _   _  |  / \    |_   \|_   _|_  ||_  _| |_  _| |_  _.' ____ \    |_   _ \  .'   `.  .' ___  |_  _||_  _|"
			 BYTE "|_/ | | \_| / _ \     |   \ | |   | |_/ /     \ \   / / | (___ \_|     | |_) |/  .-.  \/ .'   \_| \ \  / /  " 
			 BYTE "    | |    / ___ \    | |\ \| |   |  __'.      \ \ / /   _.____`.      |  __'.| |   | || |   ____  \ \/ /   " 
			 BYTE "   _| |_ _/ /   \ \_ _| |_\   |_ _| |  \ \_     \ ' /_  | \____) | _  _| |__) \  `-'  /\ `.___]  | _|  |_   " 
			 BYTE "  |_____|____| |____|_____|\____|____||____|     \_/(_)  \______.'(_)|_______/ `.___.'  `._____.' |______|  "

	;�L�}�l�e�������ܦr
	enterMsg  BYTE "Press 'E' to enter",0
	leaveMsg  BYTE "Press 'L' to leave",0
	restart   BYTE "Press 'R' to restart",0
	nextLevel BYTE "Press 'N' to next level",0
	finalMsg  BYTE "The day is saved, thanks to the Powerful Hua Tank!",0
	
	;�L�Z�J
	startTank BYTE "      C\                "
			  BYTE "       _\______         "
			  BYTE "      /        \=======D"
			  BYTE " ____|_HUA_TANK_\_____  "
			  BYTE "/ ___WHERE_ARE_YOU?__ \ "
			  BYTE "\/ _===============_ \/ "
			  BYTE "  \-===============-/   "
	;�LBogy
	startBogy BYTE " (\_/) "
			  BYTE " |OvO| "
			  BYTE "/ === \"
			  BYTE "\| X |/"
			  BYTE " |_|_| "

	gameIntro BYTE "*****************************************************************"
              BYTE "*                      Game Introduction:                       *"
              BYTE "*            Control the Hua Tank to kill the Bogy.             *"
              BYTE "*             Don't let Bogy cross the green line,              *"
			  BYTE "*                or your life will shock down!!                 *"
              BYTE "*   Start with 3 lives, once the live reaches zero, you lose!!  *"
              BYTE "*     Kill the last monsters, if you still alive, you win!!     *"
              BYTE "*                                                               *"
              BYTE "*                   How to control the tank:                    *"
              BYTE "*               + press 'up'    to move up                      *"
              BYTE "*               + press 'down'  to move down                    *"
              BYTE "*               + press 'right' to fire bullet                  *"
              BYTE "*                                                               *"
              BYTE "*                         How to play:                          *"
              BYTE "*               + press 'space' to start game                   *"
              BYTE "*               + press 'P'     to pause game                   *"
              BYTE "*****************************************************************"

	gameTank  BYTE "  __    "
			  BYTE " Hua\==D"
			  BYTE "(Tank)  "

	clearTank BYTE "        "
			  BYTE "        "
			  BYTE "        "

	gameBogy  BYTE "(\_/)"
			  BYTE "|OvO|"
			  BYTE "|_|_|"

	clearBogy BYTE "     "
			  BYTE "     "
			  BYTE "     "

	bullet BYTE "NOWORK",0
	clearBullet BYTE "      ",0

	line BYTE "|",0
	greenColor WORD 0Ah

	yellowColor WORD 0Eh

	level BYTE "Level: ",0
	state BYTE "State: ",0
	score BYTE "Score: ",0
	lives BYTE "Lives: ",0
	bogys BYTE "Bogies:",0

	levelNum WORD 1
	levelStr BYTE 4 DUP(?)

	paused BYTE "Paused ",0
	playing BYTE "Playing",0

	scoreNum WORD 0
	scoreStr BYTE 4 DUP(?)

	livesNum WORD 3
	livesStr BYTE 4 DUP(?)
	
	bogysNum WORD 1
	bogysStr BYTE 4 DUP(?)

	gameBgTB BYTE 110 DUP("*"),0
	gameBgM  BYTE "*", 108 DUP(" "), "*",0	
	
	winStr  BYTE "  ____      ____ _____ ____  _____  "
		    BYTE " |_  _|    |_  _|_   _|_   \|_   _| "
		    BYTE "   \ \  /\  / /   | |   |   \ | |   "
		    BYTE "    \ \/  \/ /    | |   | |\ \| |   "
		    BYTE "     \  /\  /    _| |_ _| |_\   |_  "
		    BYTE "      \/  \/    |_____|_____|\____| "

	loseStr BYTE " _____      ___    ______  ________ "
			BYTE "|_   _|   .'   `..' ____ \|_   __  |"
			BYTE "  | |    /  .-.  | (____\_| | |_ \_|"	
			BYTE "  | |   _| |   | |_.____ \  |  _| _ "
			BYTE " _| |__/ \  `-'  / \____) \_| |__/ |"
			BYTE "|________|`.___.' \_______/________|"


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

Ex:	
	.IF ebx == 3
		call Clrscr
		INVOKE printEndScene
	.ENDIF

	.IF ebx == 4        ;�������}
		call Clrscr
		jmp ExitProgram
	.ENDIF

	.IF ebx == 1 ; �i�J�C��
		mov scoreNum, 0
		.IF levelNum == 1
			mov livesNum, 3
			mov bogysNum, 5
		.ENDIF
		.IF levelNum == 2
			mov livesNum, 5
			mov bogysNum, 10
		.ENDIF
		.IF levelNum == 3
			mov livesNum, 7
			mov bogysNum, 15
		.ENDIF
		INVOKE printGameStage


		INVOKE initialLevelBogyPos

		mov xyPosTank.y, 15

		mov N0, 0
		mov N1, 0
		mov N2, 0
		mov N3, 0
		mov N4 , 0 
		mov N5 , 0 
		mov N6 , 0 
		mov N7 , 0 
		mov N8 , 0 
		mov N9 , 0 
		mov N10, 0 
		mov N11, 0 
		mov N12, 0 
		mov N13, 0 
		mov N14, 0 
		mov N15, 0 
		mov N16, 0 
		mov N17, 0 
		mov N18, 0 
		mov N19, 0 
		mov N20, 0

		mov xyPosNoWork0.x , 15
		mov xyPosNoWork1.x , 15
		mov xyPosNoWork2.x , 15
		mov xyPosNoWork3.x , 15
		mov xyPosNoWork4.x , 15
		mov xyPosNoWork5.x , 15
		mov xyPosNoWork6.x , 15
		mov xyPosNoWork7.x , 15
		mov xyPosNoWork8.x , 15
		mov xyPosNoWork9.x , 15
		mov xyPosNoWork10.x, 15
		mov xyPosNoWork11.x, 15
		mov xyPosNoWork12.x, 15
		mov xyPosNoWork13.x, 15
		mov xyPosNoWork14.x, 15
		mov xyPosNoWork15.x, 15
		mov xyPosNoWork16.x, 15
		mov xyPosNoWork17.x, 15
		mov xyPosNoWork18.x, 15
		mov xyPosNoWork19.x, 15
		mov xyPosNoWork20.x, 15
	.ENDIF

GameLoop:
	
	INVOKE tankWalking, xyPosTank

	.IF N0 == 1
        INVOKE noWorkWalking, xyPosNoWork0 
    .ENDIF
    .IF N1 == 1
        INVOKE noWorkWalking, xyPosNoWork1 
    .ENDIF
    .IF N2 == 1
        INVOKE noWorkWalking, xyPosNoWork2 
    .ENDIF
    .IF N3 == 1
        INVOKE noWorkWalking, xyPosNoWork3 
    .ENDIF
    .IF N4 == 1
        INVOKE noWorkWalking, xyPosNoWork4 
    .ENDIF
    .IF N5 == 1
        INVOKE noWorkWalking, xyPosNoWork5 
    .ENDIF
    .IF N6 == 1
        INVOKE noWorkWalking, xyPosNoWork6 
    .ENDIF
    .IF N7 == 1
        INVOKE noWorkWalking, xyPosNoWork7 
    .ENDIF
    .IF N8 == 1
        INVOKE noWorkWalking, xyPosNoWork8 
    .ENDIF
    .IF N9 == 1
        INVOKE noWorkWalking, xyPosNoWork9 
    .ENDIF
    .IF N10 == 1
        INVOKE noWorkWalking, xyPosNoWork10 
    .ENDIF
    .IF N11 == 1
        INVOKE noWorkWalking, xyPosNoWork11 
    .ENDIF
    .IF N12 == 1
        INVOKE noWorkWalking, xyPosNoWork12
    .ENDIF
    .IF N13 == 1
        INVOKE noWorkWalking, xyPosNoWork13
    .ENDIF
    .IF N14 == 1
        INVOKE noWorkWalking, xyPosNoWork14
    .ENDIF
    .IF N15 == 1
        INVOKE noWorkWalking, xyPosNoWork15
    .ENDIF
    .IF N16 == 1
        INVOKE noWorkWalking, xyPosNoWork16
    .ENDIF
    .IF N17 == 1
        INVOKE noWorkWalking, xyPosNoWork17
    .ENDIF
    .IF N18 == 1
        INVOKE noWorkWalking, xyPosNoWork18
    .ENDIF
    .IF N19 == 1
        INVOKE noWorkWalking, xyPosNoWork19
    .ENDIF
    .IF N20 == 1
        INVOKE noWorkWalking, xyPosNoWork20
    .ENDIF

	.IF xyPosBogy0.x < 107
		INVOKE bogyWalking, xyPosBogy0
	.ENDIF
	.IF xyPosBogy1.x < 107
		INVOKE bogyWalking, xyPosBogy1
	.ENDIF
	.IF xyPosBogy2.x < 107
		INVOKE bogyWalking, xyPosBogy2
	.ENDIF
	.IF xyPosBogy3.x < 107
		INVOKE bogyWalking, xyPosBogy3
	.ENDIF
	.IF xyPosBogy4.x < 107
		INVOKE bogyWalking, xyPosBogy4
	.ENDIF
	.IF xyPosBogy5.x < 107
		INVOKE bogyWalking, xyPosBogy5
	.ENDIF

	mov xyPos.x, 36
	mov xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR playing,
		SIZEOF playing,
		xyPos,
		ADDR cells_Written
	call ReadKey

	.IF ax == 1970h
	mov xyPos.x, 36
	mov xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR paused,
		SIZEOF paused,
		xyPos,
		ADDR cells_Written
pauseLoop:
		call ReadKey
		.IF ax == 3920h
			jmp backToGame
		.ENDIF
		jmp pauseLoop
	.ENDIF

backToGame:

	.IF ax == 4800h
		INVOKE tankClear, xyPosTank
		sub xyPosTank.y, 2
		.IF xyPosTank.y < 5
			mov xyPosTank.y, 5
		.ENDIF
		INVOKE tankWalking, xyPosTank
	.ENDIF

	.IF ax == 5000h
		INVOKE tankClear, xyPosTank
		add xyPosTank.y, 2
		.IF xyPosTank.y > 25
			mov xyPosTank.y, 25
		.ENDIF
		INVOKE tankWalking, xyPosTank
	.ENDIF

	.IF ax == 4D00h
		.IF xyPosTank.y == 5
            mov N0, 1
        .ENDIF
        .IF xyPosTank.y == 6
            mov N1, 1
        .ENDIF
        .IF xyPosTank.y == 7
            mov N2, 1
        .ENDIF
        .IF xyPosTank.y == 8
            mov N3, 1
        .ENDIF
        .IF xyPosTank.y == 9
            mov N4, 1
        .ENDIF
        .IF xyPosTank.y == 10
            mov N5, 1
        .ENDIF
        .IF xyPosTank.y == 11
            mov N6, 1
        .ENDIF
        .IF xyPosTank.y == 12
            mov N7, 1
        .ENDIF
        .IF xyPosTank.y == 13
            mov N8, 1
        .ENDIF
        .IF xyPosTank.y == 14
            mov N9, 1
        .ENDIF
        .IF xyPosTank.y == 15
            mov N10, 1
        .ENDIF
        .IF xyPosTank.y == 16
            mov N11, 1
        .ENDIF
        .IF xyPosTank.y == 17
            mov N12, 1
        .ENDIF
        .IF xyPosTank.y == 18
            mov N13, 1
        .ENDIF
        .IF xyPosTank.y == 19
            mov N14, 1
        .ENDIF
        .IF xyPosTank.y == 20
            mov N15, 1
        .ENDIF
        .IF xyPosTank.y == 21
            mov N16, 1
        .ENDIF
        .IF xyPosTank.y == 22
            mov N17, 1
        .ENDIF
        .IF xyPosTank.y == 23
            mov N18, 1
        .ENDIF
        .IF xyPosTank.y == 24
            mov N19, 1
        .ENDIF
        .IF xyPosTank.y == 25
            mov N20, 1
        .ENDIF
	.ENDIF

	push eax
	mov eax, 500
	call Delay
	pop eax

	.IF xyPosBogy0.x < 107
		INVOKE bogyClear, xyPosBogy0
	.ENDIF
	.IF xyPosBogy1.x < 107
		INVOKE bogyClear, xyPosBogy1
	.ENDIF
	.IF xyPosBogy2.x < 107
		INVOKE bogyClear, xyPosBogy2
	.ENDIF
	.IF xyPosBogy3.x < 107
		INVOKE bogyClear, xyPosBogy3
	.ENDIF
	.IF xyPosBogy4.x < 107
		INVOKE bogyClear, xyPosBogy4
	.ENDIF
	.IF xyPosBogy5.x < 107
		INVOKE bogyClear, xyPosBogy5
	.ENDIF

	; clear no work
	.IF N0 == 1
        INVOKE noWorkClear, xyPosNoWork0
    .ENDIF
    .IF N1 == 1
        INVOKE noWorkClear, xyPosNoWork1
    .ENDIF
    .IF N2 == 1
        INVOKE noWorkClear, xyPosNoWork2
    .ENDIF
    .IF N3 == 1
        INVOKE noWorkClear, xyPosNoWork3
    .ENDIF
    .IF N4 == 1
        INVOKE noWorkClear, xyPosNoWork4
    .ENDIF
    .IF N5 == 1
        INVOKE noWorkClear, xyPosNoWork5
    .ENDIF
    .IF N6 == 1
        INVOKE noWorkClear, xyPosNoWork6
    .ENDIF
    .IF N7 == 1
        INVOKE noWorkClear, xyPosNoWork7
    .ENDIF
    .IF N8 == 1
        INVOKE noWorkClear, xyPosNoWork8
    .ENDIF
    .IF N9 == 1
        INVOKE noWorkClear, xyPosNoWork9
    .ENDIF
    .IF N10 == 1
        INVOKE noWorkClear, xyPosNoWork10 
    .ENDIF
    .IF N11 == 1
        INVOKE noWorkClear, xyPosNoWork11 
    .ENDIF
    .IF N12 == 1
        INVOKE noWorkClear, xyPosNoWork12
    .ENDIF
    .IF N13 == 1
        INVOKE noWorkClear, xyPosNoWork13
    .ENDIF
    .IF N14 == 1
        INVOKE noWorkClear, xyPosNoWork14
    .ENDIF
    .IF N15 == 1
        INVOKE noWorkClear, xyPosNoWork15
    .ENDIF
    .IF N16 == 1
        INVOKE noWorkClear, xyPosNoWork16
    .ENDIF
    .IF N17 == 1
        INVOKE noWorkClear, xyPosNoWork17
    .ENDIF
    .IF N18 == 1
        INVOKE noWorkClear, xyPosNoWork18
    .ENDIF
    .IF N19 == 1
        INVOKE noWorkClear, xyPosNoWork19
    .ENDIF
    .IF N20 == 1
        INVOKE noWorkClear, xyPosNoWork20
    .ENDIF

	
	INVOKE printGreenLine, xyPos
	.IF levelNum == 1
		sub xyPosBogy0.x, 1
		sub xyPosBogy1.x, 1
		sub xyPosBogy2.x, 1
		sub xyPosBogy3.x, 1
		sub xyPosBogy4.x, 1
		sub xyPosBogy5.x, 1
	.ENDIF
	.IF levelNum == 2
		push eax
		mov eax, 4
		call RandomRange
		inc eax
		sub xyPosBogy0.x, ax
		mov eax, 4
		call RandomRange
		inc eax
		sub xyPosBogy1.x, ax
		mov eax, 4
		call RandomRange
		sub xyPosBogy2.x, ax
		mov eax, 4
		call RandomRange
		inc eax
		sub xyPosBogy3.x, ax
		mov eax, 4
		call RandomRange
		sub xyPosBogy4.x, ax
		mov eax, 4
		call RandomRange
		sub xyPosBogy5.x, ax
		pop eax
	.ENDIF
	.IF levelNum == 3
		push eax
		mov eax, 5
		call RandomRange
		add eax, 2
		sub xyPosBogy0.x, ax
		mov eax, 7
		call RandomRange
		sub xyPosBogy1.x, ax
		mov eax, 9
		call RandomRange
		sub xyPosBogy2.x, ax
		mov eax, 7
		call RandomRange
		sub xyPosBogy3.x, ax
		mov eax, 9
		call RandomRange
		sub xyPosBogy4.x, ax
		mov eax, 5
		call RandomRange
		sub xyPosBogy5.x, ax
		pop eax
	.ENDIF

	.IF N0 == 1
        add xyPosNoWork0.x, 3
		.IF levelNum == 3
			inc xyPosNoWork0.x
		.ENDIF
        push eax
        mov ax, xyPosBogy0.x
        sub ax, 6
        .IF xyPosNoWork0.x >= ax
            mov N0, 0
            mov xyPosNoWork0.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF
			.IF levelNum == 1
				mov ax, [xPosBogy0LevelArr + 0]
			.ENDIF
			.IF levelNum == 2
				mov ax, [xPosBogy0LevelArr + 2]
			.ENDIF
			.IF levelNum == 3
				mov ax, [xPosBogy0LevelArr + 4]
			.ENDIF
			mov xyPosBogy0.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork0.x > 106
            mov N0, 0
            mov xyPosNoWork0.x, 15
        .ENDIF
    .ENDIF

	.IF N1 == 1
        add xyPosNoWork1.x, 3
        .IF levelNum == 3
			inc xyPosNoWork1.x
		.ENDIF
		push eax
        mov ax, xyPosBogy0.x
        sub ax, 6
        .IF xyPosNoWork1.x >= ax
            mov N1, 0
            mov xyPosNoWork1.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy0LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy0LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy0LevelArr + 4]
            .ENDIF
            mov xyPosBogy0.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork1.x > 106
            mov N1, 0
            mov xyPosNoWork1.x, 15
        .ENDIF
    .ENDIF

	.IF N2 == 1
        add xyPosNoWork2.x, 3
        .IF levelNum == 3
			inc xyPosNoWork2.x
		.ENDIF
		.IF xyPosNoWork2.x > 106
            mov N2, 0
            mov xyPosNoWork2.x, 15
        .ENDIF
    .ENDIF

	.IF N3 == 1
        add xyPosNoWork3.x, 3
		.IF levelNum == 3
			inc xyPosNoWork3.x
		.ENDIF
        push eax
        mov ax, xyPosBogy1.x
        sub ax, 6
        .IF xyPosNoWork3.x >= ax
            mov N3, 0
            mov xyPosNoWork3.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy1LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy1LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy1LevelArr + 4]
            .ENDIF
            mov xyPosBogy1.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork3.x > 106
            mov N3, 0
            mov xyPosNoWork3.x, 15
        .ENDIF
    .ENDIF

	.IF N4 == 1
        add xyPosNoWork4.x, 3
		.IF levelNum == 3
			inc xyPosNoWork4.x
		.ENDIF
        push eax
        mov ax, xyPosBogy1.x
        sub ax, 6
        .IF xyPosNoWork4.x >= ax
            mov N4, 0
            mov xyPosNoWork4.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy1LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy1LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy1LevelArr + 4]
            .ENDIF
            mov xyPosBogy1.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork4.x > 106
            mov N4, 0
            mov xyPosNoWork4.x, 15
        .ENDIF
    .ENDIF

	.IF N5 == 1
        add xyPosNoWork5.x, 3
        .IF levelNum == 3
			inc xyPosNoWork5.x
		.ENDIF
		push eax
        mov ax, xyPosBogy1.x
        sub ax, 6
        .IF xyPosNoWork5.x >= ax
            mov N5, 0
            mov xyPosNoWork5.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy1LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy1LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy1LevelArr + 4]
            .ENDIF
            mov xyPosBogy1.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork5.x > 106
            mov N5, 0
            mov xyPosNoWork5.x, 15
        .ENDIF
    .ENDIF

	.IF N6 == 1
        add xyPosNoWork6.x, 3
		.IF levelNum == 3
			inc xyPosNoWork6.x
		.ENDIF
        .IF xyPosNoWork6.x > 106
            mov N6, 0
            mov xyPosNoWork6.x, 15
        .ENDIF
    .ENDIF

	.IF N7 == 1
        add xyPosNoWork7.x, 3
        .IF levelNum == 3
			inc xyPosNoWork7.x
		.ENDIF
		push eax
        mov ax, xyPosBogy2.x
        sub ax, 6
        .IF xyPosNoWork7.x >= ax
            mov N7, 0
            mov xyPosNoWork7.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy2LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy2LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy2LevelArr + 4]
            .ENDIF
            mov xyPosBogy2.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork7.x > 106
            mov N7, 0
            mov xyPosNoWork7.x, 15
        .ENDIF
    .ENDIF

	.IF N8 == 1
        add xyPosNoWork8.x, 3
        .IF levelNum == 3
			inc xyPosNoWork8.x
		.ENDIF
		push eax
        mov ax, xyPosBogy2.x
        sub ax, 6
        .IF xyPosNoWork8.x >= ax
            mov N8, 0
            mov xyPosNoWork8.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy2LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy2LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy2LevelArr + 4]
            .ENDIF
            mov xyPosBogy2.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork8.x > 106
            mov N8, 0
            mov xyPosNoWork8.x, 15
        .ENDIF
    .ENDIF

	.IF N9 == 1
        add xyPosNoWork9.x, 3
        .IF levelNum == 3
			inc xyPosNoWork9.x
		.ENDIF
		push eax
        mov ax, xyPosBogy2.x
        sub ax, 6
        .IF xyPosNoWork9.x >= ax
            mov N9, 0
            mov xyPosNoWork9.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy2LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy2LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy2LevelArr + 4]
            .ENDIF
            mov xyPosBogy2.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork9.x > 106
            mov N9, 0
            mov xyPosNoWork9.x, 15
        .ENDIF
    .ENDIF

	.IF N10 == 1
		add xyPosNoWork10.x, 3
		.IF levelNum == 3
			inc xyPosNoWork10.x
		.ENDIF
		.IF xyPosNoWork10.x > 106
			mov N10, 0
			mov xyPosNoWork10.x, 15
		.ENDIF
	.ENDIF

	.IF N11 == 1
		add xyPosNoWork11.x, 3
		.IF levelNum == 3
			inc xyPosNoWork11.x
		.ENDIF
		push eax
		mov ax, xyPosBogy3.x
		sub ax, 6
		.IF xyPosNoWork11.x >= ax
			mov N11, 0
			mov xyPosNoWork11.x, 15
			add scoreNum, 10
			sub bogysNum, 1
			INVOKE printScore, xyPos
			INVOKE printBogys, xyPos
			.IF bogysNum == 0
				mov ebx, 3
				jmp Ex
			.ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy3LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy3LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy3LevelArr + 4]
            .ENDIF
			mov xyPosBogy3.x, ax
		.ENDIF
		pop eax
		.IF xyPosNoWork11.x > 106
			mov N11, 0
			mov xyPosNoWork11.x, 15
		.ENDIF
	.ENDIF

	.IF N12 == 1
        add xyPosNoWork12.x, 3
		.IF levelNum == 3
			inc xyPosNoWork12.x
		.ENDIF
        push eax
        mov ax, xyPosBogy3.x
        sub ax, 6
        .IF xyPosNoWork12.x >= ax
            mov N12, 0
            mov xyPosNoWork12.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy3LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy3LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy3LevelArr + 4]
            .ENDIF
            mov xyPosBogy3.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork12.x > 106
            mov N12, 0
            mov xyPosNoWork12.x, 15
        .ENDIF
    .ENDIF

	.IF N13 == 1
        add xyPosNoWork13.x, 3
		.IF levelNum == 3
			inc xyPosNoWork13.x
		.ENDIF
        push eax
        mov ax, xyPosBogy3.x
        sub ax, 6
        .IF xyPosNoWork13.x >= ax
            mov N13, 0
            mov xyPosNoWork13.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy3LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy3LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy3LevelArr + 4]
            .ENDIF
            mov xyPosBogy3.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork13.x > 106
            mov N13, 0
            mov xyPosNoWork13.x, 15
        .ENDIF
    .ENDIF

	.IF N14 == 1
        add xyPosNoWork14.x, 3
		.IF levelNum == 3
			inc xyPosNoWork14.x
		.ENDIF
        .IF xyPosNoWork14.x > 106
            mov N14, 0
            mov xyPosNoWork14.x, 15
        .ENDIF
    .ENDIF

	.IF N15 == 1
        add xyPosNoWork15.x, 3
        .IF levelNum == 3
			inc xyPosNoWork15.x
		.ENDIF
		push eax
        mov ax, xyPosBogy4.x
        sub ax, 6
        .IF xyPosNoWork15.x >= ax
            mov N15, 0
            mov xyPosNoWork15.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy4LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy4LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy4LevelArr + 4]
            .ENDIF
            mov xyPosBogy4.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork15.x > 106
            mov N15, 0
            mov xyPosNoWork15.x, 15
        .ENDIF
    .ENDIF
	
	.IF N16 == 1
        add xyPosNoWork16.x, 3
        .IF levelNum == 3
			inc xyPosNoWork16.x
		.ENDIF
		push eax
        mov ax, xyPosBogy4.x
        sub ax, 6
        .IF xyPosNoWork16.x >= ax
            mov N16, 0
            mov xyPosNoWork16.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy4LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy4LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy4LevelArr + 4]
            .ENDIF
            mov xyPosBogy4.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork16.x > 106
            mov N16, 0
            mov xyPosNoWork16.x, 15
        .ENDIF
    .ENDIF

	.IF N17 == 1
        add xyPosNoWork17.x, 3
        .IF levelNum == 3
			inc xyPosNoWork17.x
		.ENDIF
		push eax
        mov ax, xyPosBogy4.x
        sub ax, 6
        .IF xyPosNoWork17.x >= ax
            mov N17, 0
            mov xyPosNoWork17.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy4LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy4LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy4LevelArr + 4]
            .ENDIF
            mov xyPosBogy4.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork17.x > 106
            mov N17, 0
            mov xyPosNoWork17.x, 15
        .ENDIF
    .ENDIF

	.IF N18 == 1
        add xyPosNoWork18.x, 3
		.IF levelNum == 3
			inc xyPosNoWork18.x
		.ENDIF
        .IF xyPosNoWork18.x > 106
            mov N18, 0
            mov xyPosNoWork18.x, 15
        .ENDIF
    .ENDIF

	.IF N19 == 1
        add xyPosNoWork19.x, 3
        .IF levelNum == 3
			inc xyPosNoWork19.x
		.ENDIF
		push eax
        mov ax, xyPosBogy5.x
        sub ax, 6
        .IF xyPosNoWork19.x >= ax
            mov N19, 0
            mov xyPosNoWork19.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF

			.IF levelNum == 1
                mov ax, [xPosBogy5LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy5LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy5LevelArr + 4]
            .ENDIF
            mov xyPosBogy5.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork19.x > 106
            mov N19, 0
            mov xyPosNoWork19.x, 15
        .ENDIF
    .ENDIF

	.IF N20 == 1
        add xyPosNoWork20.x, 3
        .IF levelNum == 3
			inc xyPosNoWork20.x
		.ENDIF
		push eax
        mov ax, xyPosBogy5.x
        sub ax, 6
        .IF xyPosNoWork20.x >= ax
            mov N20, 0
            mov xyPosNoWork20.x, 15
            add scoreNum, 10
            sub bogysNum, 1
            INVOKE printScore, xyPos
            INVOKE printBogys, xyPos
            .IF bogysNum == 0
                mov ebx, 3
                jmp Ex
            .ENDIF
            
			.IF levelNum == 1
                mov ax, [xPosBogy5LevelArr + 0]
            .ENDIF
            .IF levelNum == 2
                mov ax, [xPosBogy5LevelArr + 2]
            .ENDIF
            .IF levelNum == 3
                mov ax, [xPosBogy5LevelArr + 4]
            .ENDIF
            mov xyPosBogy5.x, ax
        .ENDIF
        pop eax
        .IF xyPosNoWork20.x > 106
            mov N20, 0
            mov xyPosNoWork20.x, 15
        .ENDIF
    .ENDIF

	.IF xyPosBogy0.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy0LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy0LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy0LevelArr + 4]
		.ENDIF
		mov xyPosBogy0.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF

	.IF xyPosBogy1.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy1LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy1LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy1LevelArr + 4]
		.ENDIF
		mov xyPosBogy1.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF
	.IF xyPosBogy2.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy2LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy2LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy2LevelArr + 4]
		.ENDIF
		mov xyPosBogy2.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF

	.IF xyPosBogy3.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy3LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy3LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy3LevelArr + 4]
		.ENDIF
		mov xyPosBogy3.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF

	.IF xyPosBogy4.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy4LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy4LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy4LevelArr + 4]
		.ENDIF
		mov xyPosBogy4.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF

	.IF xyPosBogy5.x <= 16
		push eax
		.IF levelNum == 1
			mov ax, [xPosBogy5LevelArr + 0]
		.ENDIF
		.IF levelNum == 2
			mov ax, [xPosBogy5LevelArr + 2]
		.ENDIF
		.IF levelNum == 3
			mov ax, [xPosBogy5LevelArr + 4]
		.ENDIF
		mov xyPosBogy5.x, ax
		pop eax
		sub livesNum, 1
		INVOKE printLives, xyPos
		.IF livesNum == 0
			mov ebx, 3 ;����n��3
			jmp Ex		
		.ENDIF
	.ENDIF
	
	jmp GameLoop



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

		mov ecx, 17
		mov esi, 0
		jmp PrintIntro
    .ENDIF
    .IF ax == 266ch     ;press l to leave
		mov ebx, 4
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

GameOrNot:
    call ReadChar
	.IF ax == 3920h     ;press space to start game
        call Clrscr
		INVOKE printGameStage
		mov ebx, 1
		jmp ExitFunc
	.ENDIF
	jmp GameOrNot

ExitFunc:
	ret
printStartScene ENDP

printGameStage PROC
	PrintGameSceneTop:
	mov xyPos.x, 5
	mov xyPos.y, 4
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR gameBgTB,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y

	mov ecx, 24
PrintGameScene:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR gameBgM,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y
	pop ecx
	loop PrintGameScene

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR gameBgTB,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y

	INVOKE printGreenLine, xyPos
	
PrintBar:
	mov xyPos.x, 5
	mov xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR level,
		SIZEOF level,
		xyPos,
		ADDR cells_Written

	INVOKE printLevel, xyPos

	mov xyPos.x, 29
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR state,
		SIZEOF state,
		xyPos,
		ADDR cells_Written
	
	mov xyPos.x, 56
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR score,
		SIZEOF score,
		xyPos,
		ADDR cells_Written

	INVOKE printScore, xyPos

	mov xyPos.x, 80
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR lives,
		SIZEOF lives,
		xyPos,
		ADDR cells_Written

	INVOKE printLives, xyPos

	mov xyPos.x, 104
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogys,
		SIZEOF bogys,
		xyPos,
		ADDR cells_Written

	INVOKE printBogys, xyPos
	ret
printGameStage ENDP

printEndScene PROC
	mov xyPos.x, 40
	mov xyPos.y, 5
	mov ecx, 6
	mov esi, 0
	.IF bogysNum == 0
printWin:
		push ecx
		INVOKE WriteConsoleOutputCharacter,
			consoleHandle,
			ADDR [winStr + esi],
			36,
			xyPos,
			ADDR cells_Written
		pop ecx
		add esi, 36
		inc xyPos.y
		loop printWin
	.ENDIF

	.IF livesNum == 0
printLose:
		push ecx
		INVOKE WriteConsoleOutputCharacter,
			consoleHandle,
			ADDR [loseStr + esi],
			36,
			xyPos,
			ADDR cells_Written
		pop ecx
		add esi, 36
		inc xyPos.y
		loop printLose
	.ENDIF

	mov xyPos.y, 15
	mov xyPos.x, 32
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR score,
		SIZEOF score,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	mov dx, scoreNum
	INVOKE decStrScore, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR scoreStr,
		4,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 15
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR lives,
		SIZEOF lives,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	mov dx, livesNum
	INVOKE decStrLives, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR livesStr,
		4,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 15
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogys,
		SIZEOF bogys,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	mov dx, bogysNum
	INVOKE decStrBogys, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogysStr,
		4,
		xyPos,
		ADDR cells_Written

	add xyPos.y, 3
	mov xyPos.x, 50
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR restart,
		SIZEOF restart,
		xyPos,
		ADDR cells_Written

	add xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR leaveMsg,
		SIZEOF leaveMsg,
		xyPos,
		ADDR cells_Written

	.IF bogysNum == 0
		add xyPos.y, 2
		.IF levelNum < 3
			INVOKE WriteConsoleOutputCharacter,
				consoleHandle,
				ADDR nextLevel,
				SIZEOF nextLevel,
				xyPos,
				ADDR cells_Written
		.ENDIF
		.IF levelNum == 3
			sub xyPos.x, 15
			INVOKE WriteConsoleOutputCharacter,
				consoleHandle,
				ADDR finalMsg,
				SIZEOF finalMsg,
				xyPos,
				ADDR cells_Written
		.ENDIF
	.ENDIF

restartOrLeave:
	call ReadChar
	.IF ax == 1372h
		mov ebx, 1
		call Clrscr
		jmp ExitEndScene
	.ENDIF
	.IF ax == 266ch
		mov ebx, 4
		jmp ExitEndScene
	.ENDIF
	.IF bogysNum == 0
		.IF ax == 316eh
			mov ebx, 1
			.IF levelNum < 3
				inc levelNum
			.ENDIF
			jmp ExitEndScene
		.ENDIF
	.ENDIF
	jmp restartOrLeave

ExitEndScene:
	ret
printEndScene ENDP

printLevel PROC,
	xyPosInit:COORD
	mov xyPosInit.x, 12
	mov xyPosInit.y, 2

	mov dx, levelNum
	INVOKE decStrLevel, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR levelStr,
		4,
		xyPosInit,
		ADDR cells_Written
	ret
printLevel ENDP

printScore PROC,
	xyPosInit:COORD
	mov xyPosInit.x, 63
	mov xyPosInit.y, 2

	mov dx, scoreNum
	INVOKE decStrScore, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR scoreStr,
		4,
		xyPosInit,
		ADDR cells_Written
	ret
printScore ENDP

printLives PROC,
	xyPosInit:COORD
	mov xyPosInit.x, 87
	mov xyPosInit.y, 2

	mov dx, livesNum
	INVOKE decStrLives, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR livesStr,
		4,
		xyPosInit,
		ADDR cells_Written
	ret
printLives ENDP

printBogys PROC,
	xyPosInit:COORD
	mov xyPosInit.x, 111
	mov xyPosInit.y, 2

	mov dx, bogysNum
	INVOKE decStrBogys, dx

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogysStr,
		4,
		xyPosInit,
		ADDR cells_Written
	ret
printBogys ENDP

initialLevelBogyPos PROC
	push eax

    .IF levelNum == 1
        mov ax, [xPosBogy0LevelArr + 0]
        mov xyPosBogy0.x, ax

        mov ax, [xPosBogy1LevelArr + 0]
        mov xyPosBogy1.x, ax

        mov ax, [xPosBogy2LevelArr + 0]
        mov xyPosBogy2.x, ax

        mov ax, [xPosBogy3LevelArr + 0]
        mov xyPosBogy3.x, ax

        mov ax, [xPosBogy4LevelArr + 0]
        mov xyPosBogy4.x, ax

        mov ax, [xPosBogy5LevelArr + 0]
        mov xyPosBogy5.x, ax
    .ENDIF

    .IF levelNum == 2
        mov ax, [xPosBogy0LevelArr + 2]
        mov xyPosBogy0.x, ax

        mov ax, [xPosBogy1LevelArr + 2]
        mov xyPosBogy1.x, ax

        mov ax, [xPosBogy2LevelArr + 2]
        mov xyPosBogy2.x, ax

        mov ax, [xPosBogy3LevelArr + 2]
        mov xyPosBogy3.x, ax

        mov ax, [xPosBogy4LevelArr + 2]
        mov xyPosBogy4.x, ax

        mov ax, [xPosBogy5LevelArr + 2]
        mov xyPosBogy5.x, ax
    .ENDIF

    .IF levelNum == 3
        mov ax, [xPosBogy0LevelArr + 4]
        mov xyPosBogy0.x, ax

        mov ax, [xPosBogy1LevelArr + 4]
        mov xyPosBogy1.x, ax

        mov ax, [xPosBogy2LevelArr + 4]
        mov xyPosBogy2.x, ax

        mov ax, [xPosBogy3LevelArr + 4]
        mov xyPosBogy3.x, ax

        mov ax, [xPosBogy4LevelArr + 4]
        mov xyPosBogy4.x, ax

        mov ax, [xPosBogy5LevelArr + 4]
        mov xyPosBogy5.x, ax
    .ENDIF

    pop eax
    ret
initialLevelBogyPos ENDP

bogyWalking PROC,
	xyPosInBogy:COORD
	mov ecx, 3
	mov esi, 0

	;mov ebx, xyPosInBogy.y
printBogy:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameBogy + esi],
		5,
		xyPosInBogy,
		ADDR cells_Written
	add esi, 5
	inc xyPosInBogy.y
	pop ecx
	loop printBogy
	
	ret
bogyWalking ENDP

bogyClear PROC,
	xyPosInBogy:COORD
	mov ecx, 3
	mov esi, 0
removeBogy:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [clearBogy + esi],
		5,
		xyPosInBogy,
		ADDR cells_Written
	add esi, 5
	inc xyPosInBogy.y
	pop ecx
	loop removeBogy
	ret
bogyClear ENDP

tankWalking PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0

	;mov ebx, xyPosInit.y
printTank:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameTank + esi],
		8,
		xyPosInit,
		ADDR cells_Written
	add esi, 8
	inc xyPosInit.y
	pop ecx
	loop printTank
	ret
tankWalking ENDP

tankClear PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0
removeTank:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [clearTank + esi],
		8,
		xyPosInit,
		ADDR cells_Written
	add esi, 8
	inc xyPosInit.y
	pop ecx
	loop removeTank
	ret
tankClear ENDP

noWorkWalking PROC,
	xyPosInit:COORD
printNoWork:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bullet,
		SIZEOF bullet,
		xyPosInit,
		ADDR cells_Written
	pop ecx
	ret
noWorkWalking ENDP

noWorkClear PROC,
	xyPosInit:COORD
removeNoWork:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR clearBullet,
		SIZEOF clearBullet,
		xyPosInit,
		ADDR cells_Written
	pop ecx
	ret
noWorkClear ENDP

printGreenLine PROC,
	xyPosInLine:COORD
	mov xyPosInLine.x, 20
	mov xyPosInLine.y, 5

	mov ecx, 24
	mov esi, 0
PrintLine:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR greenColor,
		1,
		xyPosInLine,
		ADDR cells_Written

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR line,
		1,
		xyPosInLine,
		ADDR cells_Written
	inc xyPosInLine.y
	pop ecx
	loop PrintLine
	ret
printGreenLine ENDP

decStrLevel PROC,
	levelNumDec:WORD
	mov ecx, 4					;WORD���A�̰�4���
	mov dl, 10					;����
	mov ax, levelNumDec			;�Q����
change:
	push ecx
	div dl
	add ah, '0'					;�l���ন�r�s��levelNum_inLevel
	dec ecx
	mov [levelStr + ecx], ah
	movzx ax, al				;���~��
	pop ecx
	loop change
	ret
decStrLevel ENDP

decStrScore PROC,
	scoreNumDec:WORD
	mov ecx, 4					;WORD���A�̰�4���
	mov dl, 10					;����
	mov ax, scoreNumDec			;�Q����
change:
	push ecx
	div dl
	add ah, '0'					;�l���ন�r�s��levelNum_inLevel
	dec ecx
	mov [scoreStr + ecx], ah
	movzx ax, al				;���~��
	pop ecx
	loop change
	ret
decStrScore ENDP

decStrLives PROC,
	livesNumDec:WORD
	mov ecx, 4					;WORD���A�̰�4���
	mov dl, 10					;����
	mov ax, livesNumDec			;�Q����
change:
	push ecx
	div dl
	add ah, '0'					;�l���ন�r�s��levelNum_inLevel
	dec ecx
	mov [livesStr + ecx], ah
	movzx ax, al				;���~��
	pop ecx
	loop change
	ret
decStrLives ENDP

decStrBogys PROC,
	bogysNumDec:WORD
	mov ecx, 4					;WORD���A�̰�4���
	mov dl, 10					;����
	mov ax, bogysNumDec			;�Q����
change:
	push ecx
	div dl
	add ah, '0'					;�l���ন�r�s��levelNum_inLevel
	dec ecx
	mov [bogysStr + ecx], ah
	movzx ax, al				;���~��
	pop ecx
	loop change
	ret
decStrBogys ENDP

END main