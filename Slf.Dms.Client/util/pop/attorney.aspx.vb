Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class util_pop_attorney
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public Action As String
    Public AttorneyRelationID As Integer
    Private ThisAttorney As Attorney
#End Region

#Region "Structures"
    Public Structure Attorney
        Public AttorneyRelationID As Integer
        Public States As String
        Public FirstName As String
        Public MiddleName As String
        Public LastName As String
        Public Suffix As String
        Public Relation As String
        Public CompanyID As Integer
        Public StatePrimary As Boolean

        Public Sub New(ByVal id As Integer, ByVal abbrs As String, ByVal first As String, ByVal middle As String, ByVal last As String, ByVal suf As String, ByVal rel As String, ByVal compID As String, ByVal SPrime As Boolean)
            Me.AttorneyRelationID = id
            Me.States = abbrs
            Me.FirstName = first
            Me.MiddleName = middle
            Me.LastName = last
            Me.Suffix = suf
            Me.Relation = rel
            Me.CompanyID = compID
            Me.StatePrimary = sPrime
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        Action = Request.QueryString("action")

        If Not IsPostBack Then
            LoadCompanies()
            LoadStates()
            LoadRelations()
        End If

        If Not Request.QueryString("id") Is Nothing Then
            AttorneyRelationID = Integer.Parse(Request.QueryString("id"))
            LoadAttorney()
        Else
            AttorneyRelationID = 0
        End If

        If Request.QueryString("company") Then
            ddlCompany.SelectedValue = Request.QueryString("company")
        End If
    End Sub

    Private Sub LoadAttorney()

        Dim ckValue As Boolean = False
        Using cmd As New SqlCommand("SELECT ar.CompanyID, ar.AttyRelation, a.States, a.FirstName, isnull(a.MiddleName, '') as MiddleName, " + _
        "a.LastName, isnull(a.Suffix, '') as Suffix, a.StatePrimary FROM tblAttyRelation as ar inner join tblAttorney as a on a.AttorneyID = ar.AttorneyID1 " + _
        "WHERE AttyPivotID = " + AttorneyRelationID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        If reader("StatePrimary") Is DBNull.Value Then
                            ckValue = False
                        Else
                            ckValue = CType(reader("StatePrimary"), Boolean)
                        End If
                        ThisAttorney = New Attorney(AttorneyRelationID, reader("States"), reader("FirstName"), reader("MiddleName"), reader("LastName"), reader("Suffix"), reader("AttyRelation"), reader("CompanyID"), ckValue)

                        txtFirstName.Text = ThisAttorney.FirstName
                        txtMiddleName.Text = ThisAttorney.MiddleName
                        txtLastName.Text = ThisAttorney.LastName
                        txtSuffix.Text = ThisAttorney.Suffix
                        ckPrime.Checked = ThisAttorney.StatePrimary

                        lblStates.Value = ThisAttorney.States

                        ddlCompany.SelectedValue = Integer.Parse(ThisAttorney.CompanyID)
                        ddlRelations.SelectedIndex = ddlRelations.Items.IndexOf(ddlRelations.Items.FindByText(ThisAttorney.Relation))
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadCompanies()
        Using cmd As New SqlCommand("SELECT CompanyID, ShortCoName FROM tblCompany ORDER BY ShortCoName ASC", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlCompany.Items.Add(New ListItem(StrConv(reader("ShortCoName").ToString(), vbProperCase), CInt(reader("CompanyID"))))
                    End While
                End Using
            End Using
        End Using

        ddlCompany.Items.Add(New ListItem("", -1))
    End Sub

    Private Sub LoadStates()
        ddlStates.Items.Add(New ListItem("", -1))
        Using cmd As New SqlCommand("SELECT StateID, Abbreviation FROM tblState ORDER BY Abbreviation ASC", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlStates.Items.Add(New ListItem(reader("Abbreviation").ToString(), CInt(reader("StateID"))))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadRelations()
        Using cmd As New SqlCommand("SELECT DISTINCT AttyRelation FROM tblAttyRelation ORDER BY AttyRelation ASC", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlRelations.Items.Add(New ListItem(reader("AttyRelation").ToString(), reader("AttyRelation").ToString()))
                    End While
                End Using
            End Using
        End Using

        ddlRelations.Items.Add(New ListItem("", -1))
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class