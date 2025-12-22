#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

targetWindow := "ahk_exe MuMuNxDevice.exe"

pixel1 := {x: 1518, y: 942, color: 0xABCC1F} ; Auto Match
pixel2 := {x: 868, y: 750, color: 0x1FB4C4} ; Accept
pixel3 := {x: 868, y: 948, color: 0x0BAEC1} ; Leave
pixel4 := {x: 890, y: 693, color: 0x1AB8C9} ; Failed to connect

scanDelay := 500
postClickDelay := 500
paused := true

g := Gui(, "MSAuto Status")
g.BackColor := "202020"
t := g.AddText("cFFFFFF Center w300 h25", "Status: Paused")
g.AddText("cAAAAAA Center w300 h50", "F8  = Toggle Activation`nF12 = Exit")
g.Show("x50 y50 w300 h100 NoActivate")

F8:: { 
    global paused, t
    paused := !paused
    t.Text := paused ? "Status: Paused" : "Status: Running"
}

F12::ExitApp

Fg(hwnd) {
    if !WinActive("ahk_id " hwnd) {
        WinActivate("ahk_id " hwnd)
        WinWaitActive("ahk_id " hwnd, , 0.3)
        Sleep 25
    }
}

CheckPixel(p) {
    return PixelSearch(&rx, &ry, p.x, p.y, p.x, p.y, p.color)
}

Loop {
    if paused {
        Sleep 100
        continue
    }
    
    Sleep 200
    
    try {
        hwnd := WinExist(targetWindow)
        if !hwnd {
            Sleep 200
            continue
        }
        Fg(hwnd)
    } catch {
        Sleep 200
        continue
    }
    
    if CheckPixel(pixel1) {
        Click pixel1.x, pixel1.y
        Sleep postClickDelay
    } else if CheckPixel(pixel2) {
        Click pixel2.x, pixel2.y
        Sleep postClickDelay
    } else if CheckPixel(pixel3) {
        Click pixel3.x, pixel3.y
        Sleep postClickDelay
    } else if CheckPixel(pixel4) {
        Click pixel4.x, pixel4.y
        Sleep postClickDelay
    }
    
    Sleep scanDelay
}