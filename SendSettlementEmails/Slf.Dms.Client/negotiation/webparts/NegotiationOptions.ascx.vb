Imports Drg.Util.DataAccess

Imports LexxiomWebPartsControls

Imports System.Data
Imports System.Data.SqlClient

Partial Class negotiation_webparts_NegotiationOptions
    Inherits System.Web.UI.UserControl
    Implements wNegotiationOptions

#Region "Variables"
    Private _options As NegotiationOptions
#End Region

#Region "Page Events"
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        accOptions.FindControl("nothing")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadColumns()
        End If
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        If Not Session("NegotiationFiltersConsumer_chkFilters") Is Nothing Then
            _options.chkFilters = CType(Session("NegotiationFiltersConsumer_chkFilters"), CheckBoxList)
        End If

        _options.chkColumns = chkColumns
        _options.radGroups = radGroups
        _options.radGroupShow = radGroupShow
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadColumns()
        Using ds As New DataSet()
            Using sa = New SqlDataAdapter("stp_NegotiationViewColumnSelect 1", ConnectionFactory.Create().ConnectionString())
                sa.Fill(ds, "Columns")

                Using dtColumns As DataTable = ds.Tables("Columns")
                    chkColumns.Items.Clear()
                    chkColumns.DataTextField = "Column_Name"
                    chkColumns.DataValueField = "Column_Name"
                    chkColumns.DataSource = dtColumns
                    chkColumns.DataBind()

                    For Each tItem As System.Web.UI.WebControls.ListItem In chkColumns.Items
                        Dim strText As String = tItem.Text
                        tItem.Text = InsertSpaceAfterCap(strText).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
                        tItem.Selected = True
                    Next

                    radGroups.DataTextField = "Column_Name"
                    radGroups.DataValueField = "Column_Name"
                    radGroups.DataSource = dtColumns
                    radGroups.DataBind()

                    For Each tItem As System.Web.UI.WebControls.ListItem In radGroups.Items
                        Dim strText As String = tItem.Text
                        tItem.Text = InsertSpaceAfterCap(strText).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
                    Next

                    radGroups.SelectedIndex = 6
                End Using
            End Using
        End Using
    End Sub

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        Dim sChars() As Char = strToChange.ToCharArray()
        Dim strNew As String = ""

        For Each c As Char In sChars
            Select Case Asc(c)
                Case 65 To 95   'upper caps
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
            End Select
        Next

        Return strNew.Trim
    End Function
#End Region

#Region "WebPart Connections"
    <ConnectionProvider("Negotiation Options Provider", "NegotiationOptionsProvider")> _
    Public Function ProvideNegotiationOptions() As wNegotiationOptions
        Return Me
    End Function

    Public ReadOnly Property Options() As NegotiationOptions Implements wNegotiationOptions.Options
        Get
            Return Me._options
        End Get
    End Property

    <ConnectionConsumer("Negotiation Filters Consumer", "NegotiationFiltersConsumer")> _
    Public Sub ConsumeEntityIDs(ByVal negotiationFilters As wNegotiationFilters)
        If Not negotiationFilters.chkFilters Is Nothing Then
            Session("NegotiationFiltersConsumer_chkFilters") = negotiationFilters.chkFilters
        Else
            Session("NegotiationFiltersConsumer_chkFilters") = Nothing
        End If
    End Sub
#End Region

End Class