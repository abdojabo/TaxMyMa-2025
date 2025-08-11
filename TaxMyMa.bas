Function TVA(HT As Double, Rate As Double) As Double
    TVA = HT * Rate
End Function

Function TTC(HT As Double, Rate As Double) As Double
    TTC = HT + TVA(HT, Rate)
End Function

Function ValideICE(ice As String) As Boolean
    ValideICE = (Len(ice) = 15 And IsNumeric(ice))
End Function

Sub ExportToWeb()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "POST", "http://localhost:3000/api/invoices", False
    http.setRequestHeader "Content-Type", "application/json"
    http.send "{""invoiceNumber"":""EXP-001"",""ht"":1000,""tvaRate"":0.2,""tva"":200,""ttc"":1200}"
    MsgBox IIf(http.Status = 201, "تم التصدير إلى TaxMyMa!", "فشل الاتصال بالخادم")
End Sub

Sub Auto_Open()
    Dim menu As CommandBarPopup
    Set menu = Application.CommandBars("Worksheet Menu Bar").Controls.Add(Type:=msoControlPopup)
    menu.Caption = "&TaxMyMa 2025"
    menu.Controls.Add(Type:=msoControlButton).Caption = "تصدير إلى TaxMyMa"
    menu.Controls(1).OnAction = "ExportToWeb"
End Sub
