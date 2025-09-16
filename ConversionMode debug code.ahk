^!c::   ; Ctrl+Alt+C → ConversionMode 값 출력
    hwnd := DllCall("GetForegroundWindow", "ptr")
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "ptr", hwnd, "ptr")
    if (!hIME) {
        MsgBox, 48, IME Debug, IME 핸들을 얻지 못했습니다.`n활성 창: %hwnd%
        return
    }

    convMode := DllCall("SendMessage", "ptr", hIME, "uint", 0x0283, "ptr", 0x0001, "ptr", 0, "ptr")

    ; 비트 상태 확인
    flags := ""
    if (convMode & 0x0001)
        flags .= "IME_CMODE_NATIVE (한글 모드)`n"
    if (convMode & 0x0008)
        flags .= "IME_CMODE_FULLSHAPE (전각 모드)`n"
    if (convMode & 0x0010)
        flags .= "IME_CMODE_ROMAN (로마자 모드)`n"
    if (convMode & 0x0020)
        flags .= "IME_CMODE_SYMBOL (기호 입력 모드)`n"

    if (flags = "")
        flags := "활성화된 플래그 없음 (기본 영어 모드)"

    ; convMode를 2진수 문자열로 변환
    binStr := ""
    tmp := convMode
    while (tmp > 0) {
        binStr := (tmp & 1) . binStr
        tmp >>= 1
    }
    if (binStr = "")
        binStr := "0"

    ; convMode를 16진수 문자열로 변환 (v1 방식)
    SetFormat, IntegerFast, H
    hexVal := convMode
    SetFormat, IntegerFast, D

    ; 결과 출력
    MsgBox, 64, IME ConversionMode Debug,
    (LTrim
        convMode (decimal): %convMode%
        convMode (hex): %hexVal%
        convMode (binary): %binStr%

        활성 플래그:
        %flags%
    )
return
