<%@ WebHandler Language="VB" Class="AccountBreakdownGraphHandler" %>

Imports System
Imports System.Data
Imports System.Web

Imports WebChart

Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Public Class AccountBreakdownGraphHandler : Inherits BaseGraphHandler
    Protected Overrides Sub SetupChart(ByVal engine As WebChart.ChartEngine, ByVal queryString As NameValueCollection)
        Dim clientId As Integer = StringHelper.ParseInt(queryString("id"), -1)

        If Not clientId = -1 Then
            Dim chart As PieChart = New PieChart()

            'pieChart.DataLabels.ShowXTitle = True
            'pieChart.DataLabels.ShowValue = False
            'pieChart.DataLabels.Visible = True

            chart.Colors = DefaultColors
            chart.Explosion = 6
            chart.Shadow.OffsetY = 5
            chart.Shadow.OffsetX = 5
            chart.Shadow.Visible = True
            chart.Shadow.Color = System.Drawing.Color.FromArgb(210, 210, 210)
            
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_ClientAccountOverviewList")
                DatabaseHelper.AddParameter(cmd, "ClientId", clientId)

                Using cmd.Connection
                    cmd.Connection.Open()

                    Using rd As IDataReader = cmd.ExecuteReader()
                        While rd.Read()

                            'Dim CreditorName As String = DatabaseHelper.Peel_string(rd, "CreditorName")
                            Dim AccountNumber As String = DatabaseHelper.Peel_string(rd, "CurrentAccountNumber")
                            Dim CurrentAmount As Double = DatabaseHelper.Peel_double(rd, "CurrentAmount")

                            'Dim Parts() As String = CreditorName.Split(" ")

                            'Dim Capitals As String = Nothing

                            'For Each Part As String In Parts
                            '    If Part.Trim.Length > 0 Then
                            '        Capitals += Part.Trim.Substring(0, 1).ToUpper
                            '    End If
                            'Next

                            chart.Data.Add(New ChartPoint(AccountNumber, CurrentAmount))

                        End While
                    End Using
                End Using
            End Using

            engine.Charts.Add(chart)
        End If
    End Sub
End Class