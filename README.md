<img width="248" height="84" alt="image" src="https://github.com/user-attachments/assets/4a3b8e64-6661-491c-af03-efd620e680ba" />

# IME-CURSOR-SWITCHER
👉 [노션 프로젝트 페이지 바로가기](https://pacific-climb-77d.notion.site/AutoHotKey-IME-Cursor-Switcher-26a34bbabdcb80b4b9fdfad0352168d8)

##  프로젝트 목적
Windows 환경에서 **한/영 입력 전환 상태를 마우스 커서 이미지에 반영**하는 AutoHotkey 스크립트입니다.  
입력 전환 시 커서 모양이 바뀌므로, 현재 입력 모드를 직관적으로 확인할 수 있어 사용 편의성을 높입니다.

## 사용방법
1. `images` 폴더에 `korean.cur`, `english.cur` 커서 파일을 준비합니다. (기본 커서파일 포함되어있음)
2. `application` 폴더의 `IME-Cursor-Switcher4.ahk` 파일을 실행합니다.  
   - AutoHotkey가 설치되어 있어야 실행 가능합니다.
3. 한/영 전환 키 입력 시 커서 이미지가 자동으로 변경됩니다.  
4. 트레이 메뉴에서 커서 복원 또는 종료가 가능합니다.  
5. 강제 전환 핫키를 사용할 수 있습니다.  
   - `Ctrl+Alt+K` → 한글 커서 적용  
   - `Ctrl+Alt+E` → 영어 커서 적용  
   - `Ctrl+Alt+R` → 기본 커서 복원  

##  프로젝트 내용
- **핵심 기능**
  - 한/영 키, Ctrl+Space, Alt+Shift, Ctrl+Shift 입력을 감지
  - 입력 모드에 따라 커서 이미지를 자동 전환
  - 빠른 연속 입력 시 중복 실행을 방지하기 위해 **디바운스(200ms)** 적용
  - 커서 복원 기능 및 강제 전환 핫키 지원

- **개발 과정**
  - 초기에는 IME API(`ConversionMode`)를 이용해 상태를 확인했으나,  
    최신 Windows 환경에서는 안정적으로 동작하지 않아 키 후킹 방식으로 전환
  - 기능 안정성을 위해 디바운스 기능을 추가하여 중복 이벤트 처리 문제를 해결

##  디렉토리 구조

```
IME-CURSOR-SWITCHER
├─ application ← 현재 사용하는 실행 스크립트
│ └─ IME-Cursor-Switcher4.ahk
├─ archive ← 이전 버전 보관
│ ├─ IME-Cursor-Switcher1.ahk
│ ├─ IME-Cursor-Switcher2.ahk
│ └─ IME-Cursor-Switcher3.ahk
├─ debugCode ← 실험/테스트 코드
│ ├─ ConversionMode debug code.ahk
│ └─ ImmGetContext debug code.ahk
├─ images ← 커서 이미지(.cur)
└─ README.md
```

## 📹실행영상

https://github.com/user-attachments/assets/96b416f6-607f-4645-994d-c71a623061e4



