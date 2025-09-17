; ===========================================
; IME-aware cursor switcher (Key Hook + Debounce)
; - ConversionMode API 제거
; - 한/영 전환 키 입력 감지
; - 디바운스로 중복 실행 방지
; ===========================================

#NoEnv
#SingleInstance Force
SetBatchLines, -1
ListLines, Off
SetWorkingDir, %A_ScriptDir%

; ---- 커서 파일 경로 ----
koreanCur := A_ScriptDir . "\korean.cur"
englishCur := A_ScriptDir . "\english.cur"

if !FileExist(koreanCur) || !FileExist(englishCur) {
    MsgBox, 16, Cursor files missing, korean.cur 또는 english.cur 파일을 찾을 수 없습니다.`n스크립트와 같은 폴더에 두세요.
    ExitApp
}

; ---- 커서 ID ----
SPI_SETCURSORS := 0x57
IDC_ARROW     := 32512
IDC_IBEAM     := 32513
IDC_WAIT      := 32514
IDC_CROSS     := 32515
IDC_UPARROW   := 32516
IDC_SIZEALL   := 32646
IDC_HAND      := 32649

; ---- 내부 상태 ----
global isHangul := false          ; 현재 상태 (false=영문, true=한글)
global suppressUntil := 0         ; 디바운스 제한 시간(ms)

; ---- 트레이 메뉴 ----
Menu, Tray, NoStandard
Menu, Tray, Add, Restore default cursors, RestoreCursors
Menu, Tray, Add
Menu, Tray, Add, Exit, Quit

; ---- 강제 전환용 핫키 ----
^!k::ApplyAllCursors(koreanCur)   ; Ctrl+Alt+K
^!e::ApplyAllCursors(englishCur)  ; Ctrl+Alt+E
^!r::Gosub, RestoreCursors        ; Ctrl+Alt+R

return


; ========= 키 후킹 =========
*~vk15::  ; 한/영 키
    if (A_TickCount < suppressUntil) ; 아직 디바운스 시간 안 지남 → 무시
        return
    isHangul := !isHangul
    ApplyAllCursors(isHangul ? koreanCur : englishCur)
    suppressUntil := A_TickCount + 200   ; 200ms 동안 중복 실행 방지
return

*~^Space::   ; Ctrl+Space
*~#Space::   ; Win+Space
*~!Shift::   ; Alt+Shift
*~^Shift::   ; Ctrl+Shift
    if (A_TickCount < suppressUntil)
        return
    isHangul := !isHangul
    ApplyAllCursors(isHangul ? koreanCur : englishCur)
    suppressUntil := A_TickCount + 200
return


; -------- 커서 적용 --------
ApplyAllCursors(curFile) {
    global IDC_ARROW, IDC_IBEAM, IDC_HAND, IDC_WAIT, IDC_CROSS, IDC_UPARROW, IDC_SIZEALL
    hCur := DllCall("LoadCursorFromFile", "str", curFile, "ptr")
    if (!hCur)
        return
    for _, id in [IDC_ARROW, IDC_IBEAM, IDC_HAND, IDC_WAIT, IDC_CROSS, IDC_UPARROW, IDC_SIZEALL] {
        DllCall("SetSystemCursor", "ptr", hCur, "int", id)
    }
}

; -------- 커서 복원 --------
RestoreCursors:
    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
return

; -------- 종료 --------
Quit:
    Gosub, RestoreCursors
    ExitApp
