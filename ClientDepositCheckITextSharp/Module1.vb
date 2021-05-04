Imports System.IO
Imports System.Text

Imports iTextSharp.text
Imports iTextSharp.text.html.simpleparser
Imports iTextSharp.text.pdf
Imports com.itextpdf
Imports iText.Html2pdf

Module Module1

    Sub Main()

        Dim outputFile As File("C:\Users\Charles\Desktop\Trades\pdftesting\test1.pdf")
        Dim pw As PdfWriter(outputFile)
        Dim Check As StringBuilder = BuildHTMLCheck()
        HtmlConverter.ConvertToPdf(Check.ToString(), pw)
    End Sub

    Function BuildHTMLCheck() As StringBuilder

        Dim sb As New StringBuilder()
        sb.AppendLine("<!DOCTYPE html>")
        sb.AppendLine("<html lang=""en"">")
        sb.AppendLine("<head>")
        sb.AppendLine("<meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">")
        sb.AppendLine("<meta http-equiv=""X-UA-Compatible"" content=""ie=edge"">")
        sb.AppendLine("<style type=""text/css"">")
        sb.AppendLine("@font-face {font-family: ""Micr""; src: url('MICR.ttf') format('truetype');}")
        sb.AppendLine(".right {text-align: right;}")
        sb.AppendLine(".border-bottom {border-bottom: 1px solid black;}")
        sb.AppendLine("#printPage {margin: 0px;padding: 0px;width: 670px; height: 900px; clear: both; background-color: gray; page-break-after: always;}")
        sb.AppendLine("#cube {position: relative; top: 600px; left: 15px; width: 640px; height: 285px; background-color: white;}")
        sb.AppendLine("#checkNumber {position: absolute; top: 15px; right: 15px; width: 100px;}")
        sb.AppendLine("#clientName {position: absolute; top: 15px; left: 15px; font-size: .75em;}")
        sb.AppendLine("#address {position: absolute; top: 30px; left: 15px; font-size: .75em;}")
        sb.AppendLine("#ctyStZip {position: absolute; top: 45px; left: 15px; font-size: .75em;}")
        sb.AppendLine("#phone {position: absolute; top: 60px; left: 15px; font-size: .75em;}")
        sb.AppendLine("#payTo {position: absolute; top: 105px; left: 15px;}")
        sb.AppendLine("#recipient {position: absolute; top: 123px; left: 90px; width: 350px;font-size: .75em;}")
        sb.AppendLine("#numericAmount {position: absolute; top: 120px; right: 15px; width: 75px;}")
        sb.AppendLine("#spelledOutAmount {position: absolute; top: 147px; left: 15px; width: 450px; font-size: .75em;}")
        sb.AppendLine("#payeeBank {position: absolute; top: 180px; left: 15px; width: 300px;}")
        sb.AppendLine("#disclaimer {position: absolute; top: 195px; right: 15px; width: 250px; font-size: .5em; text-align: center;}")
        sb.AppendLine("#memoLabel {position: absolute; top: 205px; left: 15px; width: 50px;}")
        sb.AppendLine("#memo {position: absolute; top: 208px; left: 65px; width: 250px; font-size: .75em;}")
        sb.AppendLine("#micr {position: absolute; top: 250px; left: 75px; width: 500px; font-family: Micr;}")
        sb.AppendLine("</style>")
        sb.AppendLine("</head>")
        sb.AppendLine("<body>")
        sb.AppendLine("<div id=""printPage"">")
        sb.AppendLine("<div id=""cube"">")
        sb.AppendLine("<div class=""right"" id=""checkNumber"">45648416</div>")
        sb.AppendLine("<div class=""left"" id=""clientName"">Chuck Castelo</div>")
        sb.AppendLine("<div class=""left"" id=""address"">5230 Wonderland Drive</div>")
        sb.AppendLine("<div class=""left"" id=""ctyStZip"">Riverside, CA 92509</div>")
        sb.AppendLine("<div class=""left"" id=""phone"">(909) 555-5555</div>")
        sb.AppendLine("<div class=""left"" id=""payTo"">Pay To The<br />Order Of</div>")
        sb.AppendLine("<div class=""left border-bottom"" id=""recipient"">Philip Sellers Attorney At Law</div>")
        sb.AppendLine("<div class=""right border-bottom"" id=""numericAmount"">$260.00</div>")
        sb.AppendLine("<div class=""left border-bottom"" id=""spelledOutAmount"">Two Hundred Sixty Dollars</div>")
        sb.AppendLine("<div class=""left"" id=""payeeBank"">Chase Bank</div>")
        sb.AppendLine("<div class=""right"" id=""disclaimer"">Your Depositor has authorized this payment to Payee. Payer to hold you harmless for payment of this document. This document shall be deposited only to credit of Payee. Absence of endorsement is guaranteed by
        Payer.</div>")
        sb.AppendLine("<div class=""left"" id=""memoLabel"">Memo&nbsp;</div>")
        sb.AppendLine("<div class=""left border-bottom"" id=""memo"">Monthly Deposit for Account# 7001564</div>")
        sb.AppendLine("<div class=""micr"" id=""micr"">c5407944c&nbsp;a856478521a&nbsp;154986548c</div>")
        sb.AppendLine("</div>")
        sb.AppendLine("</div>")
        sb.AppendLine("</body>")
        sb.AppendLine("</html>")

        Return sb
    End Function

End Module
