; ===========================================
; 버전 1 - IME 상태 디버깅 (핫키 기반)
; Ctrl+Alt+D 누를 때마다 IME 상태를 MsgBox로 표시
; ===========================================

#NoEnv
#SingleInstance Force
SetBatchLines, -1
ListLines, Off
SetWorkingDir, %A_ScriptDir%

^!d::   ; Ctrl+Alt+D → 디버깅 실행
    hWnd := WinActive("A")
    hIMC := DllCall("imm32\ImmGetContext", "ptr", hWnd, "ptr")

    if (hIMC) {
        imeOpen := DllCall("imm32\ImmGetOpenStatus", "ptr", hIMC)
        DllCall("imm32\ImmReleaseContext", "ptr", hWnd, "ptr", hIMC)

        MsgBox, 64, IME Debug,
        (LTrim
            hWnd: %hWnd%
            hIMC: %hIMC%
            imeOpen: %imeOpen%
        )
    } else {
        MsgBox, 48, IME Debug,
        (LTrim
            hWnd: %hWnd%
            IME Context 없음 (hIMC=0)
        )
    }
return
