#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

targetWindow := "ahk_exe MuMuNxDevice.exe"

emulators := [
    {
        pixels: [
            {x: 746, y: 465, color: 0xAED220}, ; Auto Match
            {x: 432, y: 376, color: 0x1FB6C7}, ; Accept

            {x: 712, y: 395, color: 0xFFFFFF}, ; LPQ Boxes

            {x: 434, y: 476, color: 0x0CACBE}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 1706, y: 473, color: 0xAACB1C}, ; Auto Match
            {x: 1475, y: 372, color: 0x20B9CB}, ; Accept
            {x: 1392, y: 477, color: 0x0CACBE}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 744, y: 984, color: 0xAECF20}, ; Auto Match
            {x: 434, y: 899, color: 0x1EB0C0}, ; Accept
            {x: 439, y: 989, color: 0x0BAEC1}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 1703, y: 983, color: 0xAECF20}, ; Auto Match
            {x: 1388, y: 894, color: 0x1FB4C5}, ; Accept
            {x: 1400, y: 989, color: 0x0CAEC1}, ; Leave
        ]
    }
]

scanDelay := 250
postClickDelay := 250
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
        windows := WinGetList(targetWindow)
        if windows.Length = 0 {
            Sleep 200
            continue
        }
        
        for i, hwnd in windows {
            if i > emulators.Length
                break
                
            Fg(hwnd)
            
            for pixel in emulators[i].pixels {
                if CheckPixel(pixel) {
                    Click pixel.x, pixel.y
                    Sleep postClickDelay
                    break
                }
            }
        }
    } catch {
        Sleep 200
        continue
    }
    
    Sleep scanDelay
}