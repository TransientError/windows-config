#SingleInstance

XButton1::RButton

RButton::{
  Loop {
    Sleep 10
    if !GetKeyState("RButton", "P") {
      Send "#{Tab}"
      break
    } else if GetKeyState("XButton1", "P") {
      Send "^v"
      break
    } else if GetKeyState("LButton", "P") {
      Send "^c"
      break
    }
  }
}
