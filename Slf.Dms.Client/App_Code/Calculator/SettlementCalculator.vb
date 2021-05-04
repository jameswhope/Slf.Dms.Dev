
Imports System.Data
Imports System.Collections.Generic

Public MustInherit Class SettlementCalculator

#Region "Fields"
    Protected _Applicant As Applicant
    Protected _Results As Results
    Protected _Funds As Double
    Protected _Debt As Double
    Protected _TotalPaid As Double
    Protected _CurrentMonth As Integer
    Protected _SettlementAmount As Double
#End Region 'Fields

#Region "Properties"
    Public Property Applicant() As Applicant
        Get
            Return _Applicant
        End Get
        Set(value As Applicant)
            _Applicant = value
        End Set
    End Property

    Public Property Results() As Results
        Get
            Return _Results
        End Get
        Set(value As Results)
            _Results = value
        End Set
    End Property
#End Region 'Properties

#Region "Methods - Must Inherit"

    Public MustOverride Function Calculate() As List(Of Results)
    Public MustOverride Function GetSettlementData() As DataTable

#End Region 'Methods - Must Inherit

#Region "Methods - Can Override"

    Public Shared Function Create(ByVal Version As String) As SettlementCalculator
        Dim classname As String = String.Format("{0}", Version.Trim)
        Return Activator.CreateInstance(CType(System.Web.Compilation.BuildManager.CodeAssemblies(0), System.Reflection.Assembly).GetType(classname))
        'Dim currentDomain As AppDomain = AppDomain.CurrentDomain

        ''Make an array for the list of assemblies. 
        'Dim assems As System.Reflection.Assembly() = currentDomain.GetAssemblies()

        'Return Activator.CreateInstance(currentDomain.GetAssemblies()(0).GetType(classname))
    End Function

    Protected Function GetMonths(Months As Integer) As String
        Return String.Format("{0} mos", Months)
    End Function

    Protected Function GetYearsMonths(Months As Integer) As String
        Dim NumberOfYears As Integer = Math.Floor(Months / 12)
        Dim NumberOfMonths As Integer = Months - (NumberOfYears * 12)
        Return String.Format("{0} yrs {1} mos", NumberOfYears, NumberOfMonths)
    End Function

#End Region

End Class
