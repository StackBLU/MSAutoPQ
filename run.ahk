#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

targetWindow := "ahk_exe MuMuNxDevice.exe"
img1 := "C:\Users\<user>\Desktop\MSAutoPQ\1.bmp"
img2 := "C:\Users\<user>\Desktop\MSAutoPQ\2.bmp"
img3 := "C:\Users\<user>\Desktop\MSAutoPQ\3.bmp"

var1 := 30
var2 := 50
var3 := 50
scanDelay := 500
postClickDelay := 500
paused := true

guiX := 50
guiY := 50

g := Gui(, "MSAuto Status")
g.BackColor := "202020"
t := g.AddText("cFFFFFF Center w300 h25", "Status: Paused")
g.AddText("cAAAAAA Center w300 h50", "F8  = Toggle Activation`nF12 = Exit")
g.Show("x" guiX " y" guiY " w300 h100 NoActivate")

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

ImgSize(p) {
    h := LoadPicture(p), b := Buffer(32, 0)
    DllCall("GetObject", "ptr", h, "int", b.Size, "ptr", b)
    w := NumGet(b, 4, "int"), hh := NumGet(b, 8, "int")
    DllCall("DeleteObject", "ptr", h)
    return [w, hh]
}

FindImg(p, x1, y1, x2, y2, v, &fx, &fy) {
    return ImageSearch(&fx, &fy, x1, y1, x2, y2, "*" v " " p)
}

ClickImg(p, hwnd, fx, fy) {
    s := ImgSize(p)
    Fg(hwnd)
    Click fx + s[1]//2, fy + s[2]//2
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
    if FindImg(img1, 0, 0, A_ScreenWidth, A_ScreenHeight, var1, &fx, &fy) {
        ClickImg(img1, hwnd, fx, fy)
        Sleep postClickDelay
    } else if FindImg(img2, 0, 0, A_ScreenWidth, A_ScreenHeight, var2, &fx, &fy) {
        ClickImg(img2, hwnd, fx, fy)
        Sleep postClickDelay
    } else if FindImg(img3, 0, 0, A_ScreenWidth, A_ScreenHeight, var3, &fx, &fy) {
        ClickImg(img3, hwnd, fx, fy)
        Sleep postClickDelay
    }
    Sleep scanDelay
}