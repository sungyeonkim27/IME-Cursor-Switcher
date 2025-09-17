; IME-aware cursor switcher
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

; ---- 상수/커서 ID ----
SPI_SETCURSORS := 0x57
IDC_ARROW := 32512
IDC_IBEAM := 32513
IDC_WAIT  := 32514
IDC_CROSS := 32515
IDC_UPARROW := 32516
IDC_SIZEALL := 32646
IDC_HAND := 32649

; 트레이 메뉴
Menu, Tray, NoStandard
Menu, Tray, Add, Restore default cursors, RestoreCursors
Menu, Tray, Add
Menu, Tray, Add, Exit, Quit

; ---- IME 메시지/플래그 ----
WM_IME_CONTROL        := 0x0283
IMC_GETCONVERSIONMODE := 0x0001
IME_CMODE_NATIVE      := 0x0001   ; 한글 모드 비트 플래그

; 강제 테스트 핫키 
^!k::ApplyAllCursors(koreanCur) ; Ctrl+Alt+K
^!e::ApplyAllCursors(englishCur) ; Ctrl+Alt+E
^!r::Gosub, RestoreCursors       ; Ctrl+Alt+R

; IME 상태 감시
LastIME := -1
SetTimer, CheckIME, 80
return

;라벨 및 함수 ------------------------------------------------------------
CheckIME:
    ; 현재 활성화된 윈도우(창)의 핸들을 가져옴
    ; → 이 창의 입력기(IME) 상태를 확인하기 위해 필요
    hWnd := DllCall("GetForegroundWindow", "ptr")

    ; 활성 창에 연결된 IME 컨텍스트 핸들을 얻음
    ; (IME 상태를 직접 조회할 수 있는 "핸들")
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "ptr", hWnd, "ptr")
    

    if (!hIME)
        return

    convMode := DllCall("SendMessage", "ptr", hIME, "uint", WM_IME_CONTROL, "ptr", IMC_GETCONVERSIONMODE, "ptr", 0, "ptr")
    imeOpen := (convMode & IME_CMODE_NATIVE) ? 1 : 0

    ; IME 상태가 바뀌었을 때만 실행
    ; → 불필요한 반복 호출 방지 (성능 최적화 + 깜빡임 방지)
    if (imeOpen != LastIME) {
        ; 마지막 상태를 갱신
        LastIME := imeOpen

        ; IME가 켜졌으면 korean.cur 적용, 꺼졌으면 english.cur 적용
        ApplyAllCursors( imeOpen ? koreanCur : englishCur )
    }
return


ApplyAllCursors(curFile) {
    global IDC_ARROW, IDC_IBEAM, IDC_HAND, IDC_WAIT, IDC_CROSS, IDC_UPARROW, IDC_SIZEALL
    hCur := DllCall("LoadCursorFromFile", "str", curFile, "ptr")
    if (!hCur) {
        ToolTip, 커서 로드 실패: %curFile%
        SetTimer, __HideTip, -1200
        return
    }
    ; 주요 커서 유형에 일괄 적용
    for _, id in [IDC_ARROW, IDC_IBEAM, IDC_HAND, IDC_WAIT, IDC_CROSS, IDC_UPARROW, IDC_SIZEALL] {
        DllCall("SetSystemCursor", "ptr", hCur, "int", id)
    }
    ToolTip, 적용됨: %curFile%
    SetTimer, __HideTip, -600
}

__HideTip:
    ToolTip
return

RestoreCursors:
    SPI_SETCURSORS := 0x57
    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
    ToolTip, 기본 커서 복원됨
    SetTimer, __HideTip, -600
return

Quit:
    Gosub, RestoreCursors
    ExitApp
