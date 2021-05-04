Imports Drg.Util.DataAccess

Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO

Partial Class util_pop_cancellationdrilldown
    Inherits PermissionPage

#Region "Variables"
    Private StartDate As Date
    Private EndDate As Date
    Private ReasonsDescID As Integer
#End Region

#Region "Structures"
    Public Structure DrillDown
        Public AccountNumber As String
        Public Name As String
        Public Cancelled As Date
        Public Refund As Double

        Public Sub New(ByVal _AccountNumber As String, ByVal _Name As String, ByVal _Cancelled As Date, ByVal _Refund As Double)
            Me.AccountNumber = _AccountNumber
            Me.Name = _Name
            Me.Cancelled = _Cancelled
            Me.Refund = _Refund
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        StartDate = Date.Parse(Request.QueryString("begin"))
        EndDate = Date.Parse(Request.QueryString("end"))
        ReasonsDescID = Integer.Parse(Request.QueryString("descid"))

        If Not IsPostBack Then
            LoadDrillDown()
        End If
    End Sub

    Private Sub LoadDrillDown()
        Dim Results As New List(Of DrillDown)

        Using cmd As New SqlCommand("SELECT c.AccountNumber, ltrim(rtrim(p.FirstName)) + ' ' + ltrim(rtrim(p.LastName)) as [Name], rs.Created as Cancelled, " + _
        "isnull(sum(ta.Amount), 0) as Refund FROM tblReasons as rs left join tblTransactionAudit as ta on ta.ClientID = rs.[Value] and " + _
        "ta.[Type] = 'registerpayment' inner join tblClient as c on c.ClientID = rs.[Value] inner join tblPerson as p on p.PersonID = c.PrimaryPersonID " + _
        "WHERE rs.Created between '" + StartDate.ToString("MM-dd-yyyy") + "' and '" + EndDate.ToString("MM-dd-yyyy") + "' and " + _
        "rs.ValueType = 'ClientID' and rs.ReasonsDescID = " + ReasonsDescID.ToString() + _
        " GROUP BY c.AccountNumber, p.LastName, p.FirstName, rs.Created ORDER BY p.LastName, p.FirstName", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Results.Add(New DrillDown(reader("AccountNumber"), reader("Name"), Date.Parse(reader("Cancelled")), Double.Parse(reader("Refund"))))
                    End While
                End Using
            End Using
        End Using

        rptDrillDown.DataSource = Results
        rptDrillDown.DataBind()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class