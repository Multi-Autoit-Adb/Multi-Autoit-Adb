#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include "GUIScrollbars_Ex.au3"

Opt("GUIOnEventMode", 1)

Global $aControlIDs[1][3]

; Create main GUI
$hGUI_Main = GUICreate("Test", 500, 440, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_RESIZED, "Resize")

GUICtrlCreateButton("Create", 10, 10, 50, 20)
GUICtrlSetOnEvent(-1, "CreateBtns")

GUICtrlCreateButton("Delete", 70, 10, 50, 20)
GUICtrlSetOnEvent(-1, "DeleteBtns")

GUICtrlCreateLabel("Button Count", 200, 10, 100, 20)
$cInput = GUICtrlCreateInput(25, 300, 10, 50, 20)

; Create child GUI
$hGUI_Child = GUICreate("Child", 480, 270, 10, 120, $WS_CHILD, $WS_EX_CLIENTEDGE, $hGUI_Main)

GUISetState(@SW_SHOW, $hGUI_Child)
GUISetState(@SW_SHOW, $hGUI_Main)

While 1
    Sleep(10)
WEnd

Func _Exit()
    Exit
EndFunc

Func Resize()

    ; Get size of main GUI
    $aSize = WinGetClientSize($hGUI_Main)
    ; Resize Child
    WinMove($hGUI_Child, "", 10, 120, $aSize[0] - 20, $aSize[1] - 130)
    ; Redraw the buttons
    CreateBtns()

EndFunc

Func CreateBtns()

    DeleteBtns()

    ; How many buttons
    $iNumber = GUICtrlRead($cInput)
    ; Size array to fit
    Global $aControlIDs[$iNumber][3]

    ; Sizing info
    $iSpacing = 65

    ; Get size of child GUI
    $aChild = WinGetClientSize($hGUI_Child)
    ; How many rows and columns can we fit in
    $iHorz_Limit = Int($aChild[0] / $iSpacing)
    $iVert_Limit = Int($aChild[1] / $iSpacing)
    ; How may rows do we need
    $iRows_Required = Ceiling($iNumber / $iHorz_Limit
    ; Create scrollbatrs if needed
    If $iRows_Required > $iVert_Limit Then
        $aScroll = _GUIScrollbars_Generate($hGUI_Child, 0, $iRows_Required * $iSpacing, 0, 0, True)
    EndIf

    l; Create buttons
    GUISwitch($hGUI_Child)
    For $i = 0 To $iRows_Required - 1
        $iY = $i * $iSpacing
        For $j = 0 To $iHorz_Limit -1
            $iX = $j * $iSpacing
            ; Which button
            $iItem = $j + ($i * $iHorz_Limit)
            ; Have we created enough?
            If $iItem = $iNumber Then
                ExitLoop 2
            EndIf
            ; Create buttons
            $aControlIDs[$iItem][0] = GUICtrlCreateCheckbox("", $iX + 6, $iY + 13, 13, 13)
            $aControlIDs[$iItem][1] = GUICtrlCreateButton("", $iX + 26, $iY + 6, 30, 30)
            $aControlIDs[$iItem][2] = GUICtrlCreateLabel($iItem + 1, $iX + 5, $iY + 40, 60, 15)
        Next

    Next

EndFunc

Func DeleteBtns()

    For $m = 0 To UBound($aControlIDs) - 1
        For $n = 0 To 2
            GUICtrlDelete($aControlIDs[$m][$n])
        Next
    Next

EndFunc