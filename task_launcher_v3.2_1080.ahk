#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

BreakLoop = 0

^h::
  PixelGetColor, bossHP1, 344, 286
  PixelGetColor, knightHP, 153, 98
  PixelGetColor, action, 538, 112 
  PixelGetColor, autobtn, 298, 82
msgbox %bossHP1% (should be 68E302) %knightHP% (should be 67DE02) %action% (should be FFFFFF) %autobtn% (should be BD4436)
return


^j::
; WinGetPos, X, Y, Width, Height, NoxPlayer ; 761x1380 
; Assumptions: Any process is started, application is opened and corresponding window active
; Counter to run only for a limited amount of time
start_time := A_TickCount
time_to_run := 600000   ; in "ms"
end_time := start_time + time_to_run


g1 = 1
punchit = 0
ct = 0

while (g1 = 1 and A_tickcount < end_time)
{  
  if (BreakLoop = 1)
    break   

  ; Need to scan horizontally
  if punchit = 0
  {
    PixelGetColor, bossHP1, 344, 286 ;  
    if (bossHP1 = 0x68E302 ) ;        
    {
      punchit = 1
    }
  }
  
  ;msgbox %bossHP1% %punchit% lcikquit
  PixelGetColor, knightHP, 153, 98
  if knightHP != 0x67DE02  ; Check if Knight need some healing
  {
    
    ;Click, 474, 1272  ; Try to use first power
    ;Sleep, 50
    Click, 530, 980  ; Try to use second power
    Sleep, 50
    Click, 135, 903  ; Punch (rage power)
    Sleep, 50
    
    if punchit = 1
      MouseClickDrag, Left, 333, 642, 333, 582
    else
      Click, 333, 642  ; Stab!
  }
  else ; Still need to check
  {
    if punchit = 1
      MouseClickDrag, Left, 333, 642, 333, 582
    else
      Click, 333, 642  ; Stab!
  }
  
  Sleep, 650
  ;Sleep, 50
	
  ; Check if that's the ennemy's turn; then speed it up
  PixelGetColor, action, 538, 112 ; White frame of 4th bubble
  PixelGetColor, autobtn, 298, 82 ; White "T" of the "auto" HUD
  if (action != 0xFFFFFF && autobtn = 0xBD4436)  ; Action bar is still there
  {
  Sleep, 200
  PixelGetColor, action, 538, 112 ; White frame of 4th bubble
  PixelGetColor, autobtn, 298, 82 ; White "T" of the "auto" HUD
  ;msgbox ennemyturn?
  if (action != 0xFFFFFF && autobtn = 0xBD4436)  ; Action bar is still ther
  {
    punchit = 0
    ;msgbox ennemyturn
    ct:=ct+1
    ;Click, 333, 642, down ; Hold click in the center of the screen
    Click down
    while action != 0xFFFFFF
    {
      Sleep, 200
      PixelGetColor, action, 538, 112 ; White frame of 4th bubble
    }
    Click up
  }
  }
}

MsgBox %ct% turns played

MsgBox Script has been stopped.
BreakLoop = 0
return


^q::
BreakLoop = 1
return

