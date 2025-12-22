#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

targetWindow := "ahk_exe MuMuNxDevice.exe"

emulators := [
    {
        pixels: [
            {x: 760, y: 487, color: 0xA1C21B}, ; Auto Match
            
            {x: 515, y: 375, color: 0x1FB7C8}, ; Accept
            {x: 516, y: 472, color: 0x0CB0C2}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 1486, y: 377, color: 0x3DBFCC}, ; Accept
            {x: 1475, y: 467, color: 0x09B3C6}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 528, y: 894, color: 0x3DBDCC}, ; Accept
            {x: 510, y: 987, color: 0x0BB1C3}, ; Leave
        ]
    },
    {
        pixels: [
            {x: 1487, y: 897, color: 0x3DBBC9}, ; Accept
            {x: 1470, y: 983, color: 0x09B3C6}, ; Leave
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