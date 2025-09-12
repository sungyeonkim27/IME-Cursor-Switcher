; korean.cur 강제 적용 테스트
koreanCur := A_ScriptDir . "\korean.cur" ; 커서 위치
IDC_ARROW := 32512
hCur := DllCall("LoadCursorFromFile", "str", koreanCur, "ptr")
if (hCur) {
    DllCall("SetSystemCursor", "ptr", hCur, "int", IDC_ARROW)
}
