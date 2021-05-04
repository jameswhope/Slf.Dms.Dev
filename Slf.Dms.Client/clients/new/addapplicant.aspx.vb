Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Partial Class clients_new_addapplicant
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            LoadStates()
            LoadLanguages()
            LoadPhoneTypes()

            SetAttributes()

        End If

    End Sub
    Private Sub SetAttributes()
        txtZipCode.Attributes("onblur") = "javascript:txtZipCode_OnBlur(this);"
    End Sub
    Private Sub LoadStates()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Abbreviation]"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_int(rd, "StateID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadLanguages()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblLanguage ORDER BY [Default] DESC, [Name]"

        cboLanguageID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboLanguageID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "LanguageID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPhoneTypes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneType ORDER BY [Name]"

        cboPhoneTypeID1.Items.Clear()
        cboPhoneTypeID2.Items.Clear()
        cboPhoneTypeID3.Items.Clear()
        cboPhoneTypeID4.Items.Clear()
        cboPhoneTypeID5.Items.Clear()

        cboPhoneTypeID1.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID2.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID3.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID4.Items.Add(New ListItem(String.Empty, 0))
        cboPhoneTypeID5.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                cboPhoneTypeID1.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID2.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID3.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID4.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))
                cboPhoneTypeID5.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "PhoneTypeID")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        cboPhoneTypeID1.Items.FindByText("Home").Selected = True            'home
        cboPhoneTypeID2.Items.FindByText("Business").Selected = True        'business
        cboPhoneTypeID3.Items.FindByText("Business Fax").Selected = True    'business fax
        cboPhoneTypeID4.Items.FindByText("Mobile").Selected = True          'mobile
        cboPhoneTypeID5.Items.FindByText("Pager").Selected = True           'pager

    End Sub
End Class