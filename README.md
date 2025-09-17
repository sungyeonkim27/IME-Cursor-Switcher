# IME-CURSOR-SWITCHER

## 📌 프로젝트 목적
Windows 환경에서 **한/영 입력 전환 상태를 마우스 커서 이미지에 반영**하는 AutoHotkey 스크립트입니다.  
입력 전환 시 커서 모양이 바뀌므로, 현재 입력 모드를 직관적으로 확인할 수 있어 사용 편의성을 높입니다.

## 📖 프로젝트 내용
- **핵심 기능**
  - 한/영 키, Ctrl+Space, Alt+Shift, Ctrl+Shift 입력을 감지
  - 입력 모드에 따라 커서 이미지를 자동 전환
  - 빠른 연속 입력 시 중복 실행을 방지하기 위해 **디바운스(200ms)** 적용
  - 커서 복원 기능 및 강제 전환 핫키 지원

- **개발 과정**
  - 초기에는 IME API(`ConversionMode`)를 이용해 상태를 확인했으나,  
    최신 Windows 환경에서는 안정적으로 동작하지 않아 키 후킹 방식으로 전환
  - 기능 안정성을 위해 디바운스 기능을 추가하여 중복 이벤트 처리 문제를 해결

## 📂 디렉토리 구조

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

## 실행영상

https://github.com/user-attachments/assets/41e5e1b6-d8b9-4809-a28e-ad8e945eb65b


