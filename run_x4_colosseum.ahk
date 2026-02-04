#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

targetWindow := "ahk_exe MuMuNxDevice.exe"

emulators := [
    {
        pixels: [
            {x: 725, y: 332, color: 0x09BED4} ; Accept
        ]
    },
    {
        pixels: [
            {x: 1687, y: 331, color: 0x0BBED6} ; Auto Match
        ]
    },
    {
        pixels: [
            {x: 725, y: 847, color: 0x0BBED6} ; Auto Match
        ]
    },
    {
        pixels: [
            {x: 1688, y: 849, color: 0x08BED3} ; Auto Match
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