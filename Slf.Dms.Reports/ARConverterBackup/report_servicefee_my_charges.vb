Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class report_servicefee_my_charges
    Inherits ActiveReport3
	Public Sub New()
	MyBase.New()
		InitializeReport()
	End Sub
	#Region "ActiveReports Designer generated code"
	Private Sub InitializeReport()
		Me.LoadLayout(Me.GetType(),"report_servicefee_my_charges.rpx")
	End Sub
	#End Region
End Class
