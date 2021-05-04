Option Explicit On 

Imports WebChart
Imports System.Drawing

Public Class ChartHelper

    Public Shared Sub Format(ByVal cht As WebChart.ChartControl)

        With cht

            .VirtualPath = "webcharts/"

            .Padding = 0
            .ChartPadding = 0
            .TopPadding = 0
            .TopChartPadding = 15
            .RightChartPadding = 15
            .BottomChartPadding = 50
            .GridLines = WebChart.GridLines.Both
            .Background.Color = Color.FromArgb(245, 245, 245)
            .Border.Color = Color.Transparent
            .BorderStyle = Web.UI.WebControls.BorderStyle.None

            .LeftChartPadding = 50

            With .Border

                .Color = Color.Gainsboro

            End With

            With .YAxisFont

                .StringFormat.Alignment = StringAlignment.Far

                .Font = New Font("Tahoma", 10, FontStyle.Regular, GraphicsUnit.Pixel)

            End With

            With .YTitle

                .StringFormat.Alignment = StringAlignment.Far
                .StringFormat.FormatFlags = StringFormatFlags.NoWrap
                .StringFormat.HotkeyPrefix = System.Drawing.Text.HotkeyPrefix.None
                .StringFormat.LineAlignment() = StringAlignment.Center
                .StringFormat.Trimming = StringTrimming.Character

                .Font = New Font("Tahoma", 10, FontStyle.Regular, GraphicsUnit.Pixel)

            End With

            With .XAxisFont

                .StringFormat.Alignment = StringAlignment.Center
                .StringFormat.FormatFlags = StringFormatFlags.NoClip
                .StringFormat.HotkeyPrefix = System.Drawing.Text.HotkeyPrefix.None
                .StringFormat.LineAlignment() = StringAlignment.Center
                .StringFormat.Trimming = StringTrimming.Character

                .Font = New Font("Tahoma", 10, FontStyle.Regular, GraphicsUnit.Pixel)

            End With

            With .PlotBackground

                .Color = Color.FromArgb(245, 245, 245)
                '.Type = InteriorType.Solid
                '.Color = Color.FromArgb(245, 245, 245)
                .CenterPoint = New Point(0, 0)
                .EndPoint = New Point(100, 100)
                .ForeColor = Color.Gainsboro
                .Type = InteriorType.Solid

            End With

            .HasChartLegend = False

            For i As Integer = 0 To .Charts.Count - 1

                With .Charts(i)

                    With .DataLabels

                        .Background.Color = Color.Transparent
                        .Border.Color = Color.Transparent
                        .ShowLegend = True
                        .Font = New Font("Tahoma", 10, FontStyle.Regular, GraphicsUnit.Pixel)
                        .Position = DataLabelPosition.Top
                        .NumberFormat = "#,##0"
                        .Visible = True

                    End With

                    .ShowLineMarkers = True

                End With

            Next

        End With

    End Sub
End Class