#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"

g := Gui(, "Pixel Info")
g.BackColor := "202020"
g.AddText("cFFFFFF w300 h25", "Press F9 to capture pixel at mouse position")
g.AddText("cAAAAAA w300 h25", "F12 = Exit")
g.AddText("cFFFFFF w300 h25", "---")
coordText := g.AddText("cFFFFFF w300 h25", "X: --- Y: ---")
colorText := g.AddText("cFFFFFF w300 h25", "Color: ---")
g.AddText("cFFFFFF w300 h25", "---")
resultText := g.AddText("cFFFFFF w300 h50", "")
g.Show("x50 y50 w300 h200 NoActivate")

F9:: {
    global coordText, colorText, resultText
    
    MouseGetPos &x, &y
    color := PixelGetColor(x, y)
    
    coordText.Text := "X: " x " Y: " y
    colorText.Text := "Color: " color
    resultText.Text := "{x: " x ", y: " y ", color: " color "}"
}

F12::ExitApp