Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_settings_references_VCreditor
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private _creditor As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateid As Integer
    Private _zipcode As String
    Private _validated As Boolean
    Private _stabrev As String
    Private _CreditorGroupID As Integer
    Private _addresstype As Integer
    'Private qs As QueryStringCollection
    Private qs As String
#End Region

#Region "Structure"
    Public Structure Creditors
        Friend CreditorID As Integer
        Friend Name As String
        Friend Street As String
        Friend Street2 As String
        Friend City As String
        Friend State As Integer
        Friend StateAbr As String
        Friend ZipCode As String
        Friend Validated As Boolean
        Friend StAbrev As String
        Friend CreditorGroupID As Integer
        Friend CreditorAddressTypeID As Integer

        Public Sub New(ByVal _CreditorID As Integer, ByVal _CreditorName As String, ByVal _CreditorStreet As String, ByVal _CreditorStreet2 As String, ByVal _CreditorCity As String, ByVal _CreditorState As Integer, ByVal _CreditorZip As String, ByVal _Validated As Boolean, ByVal _StAbrev As String, ByVal _CreditorGroupID As Integer, ByVal _CreditorAddressTypeID As Integer)
            Me.CreditorID = _CreditorID
            Me.Name = _CreditorName
            Me.Street = _CreditorStreet
            Me.Street2 = _CreditorStreet2
            Me.City = _CreditorCity
            Me.State = _CreditorState
            Me.ZipCode = _CreditorZip
            Me.Validated = _Validated
            Me.StAbrev = _StAbrev
            Me.CreditorGroupID = _CreditorGroupID
            Me.CreditorAddressTypeID = _CreditorAddressTypeID
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadRecord()
        End If
        SetRollups()

        If Page.IsPostBack Then
            Dim eventArg As String = Request("__EVENTARGUMENT")
            If eventArg = "btnPopulate" Then
                PopulateDropDown()
            End If
        End If


    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SaveMasterCreditor();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_note_add.png") + """ align=""absmiddle""/>New Master Creditor</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SaveAddress();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_web_home.png") + """ align=""absmiddle""/>New Address</a>")
        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:ValidateCreditor();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_check.png") + """ align=""absmiddle""/>Validate Creditor</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:RemoveCreditor();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_delete.png") + """ align=""absmiddle""/>Remove Creditor</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_book.png") + """ align=""absmiddle""/>Return To Settings</a>")

    End Sub

#Region "Data loading routines"

    Private Sub LoadRecord()

        Dim UnVCreditors As New List(Of Creditors)
      Using cmd As New SqlCommand("SELECT c.CreditorID, c.[name], c.street, c.street2, c.city, c.stateid, c.zipcode, c.validated, s.abbreviation, c.CreditorGroupID, c.CreditorAddressTypeID " _
      & "FROM tblcreditor c " _
      & "INNER JOIN tblcreditorinstance ci " _
      & "ON ci.creditorid = c.creditorid " _
      & "INNER JOIN tblAccount a " _
      & "ON a.currentcreditorinstanceid = ci.creditorinstanceid " _
      & "INNER JOIN tblState s " _
      & "ON s.StateID = c.StateID " _
      & "LEFT JOIN tblCreditorGroup cg ON cg.CreditorGroupID = c.CreditorGroupID " _
      & "WHERE(a.created > DateAdd(Day, -60, getdate())) AND c.validated < 1 ORDER BY c.[name]", ConnectionFactory.Create())

         Using cmd.Connection
            cmd.Connection.Open()
            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  UnVCreditors.Add(New Creditors(Integer.Parse(reader("CreditorID")), _
                  IIf(Not reader("name") Is DBNull.Value, reader("name"), ""), _
                  IIf(Not reader("street") Is DBNull.Value, reader("street"), ""), _
                  IIf(Not reader("street2") Is DBNull.Value, reader("street2"), ""), _
                  IIf(Not reader("city") Is DBNull.Value, reader("city"), ""), _
                  IIf(Not reader("stateid") Is DBNull.Value, reader("stateid"), 0), _
                  IIf(Not reader("zipcode") Is DBNull.Value, reader("zipcode"), ""), _
                  IIf(Not reader("Validated") Is DBNull.Value, reader("Validated"), False), _
                  IIf(Not reader("Abbreviation") Is DBNull.Value, reader("Abbreviation"), ""), _
                  IIf(Not reader("CreditorGroupID") Is DBNull.Value, reader("CreditorGroupID"), 0), _
                  IIf(Not reader("CreditorAddressTypeID") Is DBNull.Value, reader("CreditorAddressTypeID"), 0)))
               End While
            End Using
         End Using
      End Using

        repeater1.DataSource = UnVCreditors
        repeater1.DataBind()

      LoadStates(_stateid)
        LoadAddressType()
      LoadMasterList(_creditor)
      LoadPhoneTypes()

        'ListHelper.SetSelected(cboStateID, _stateid)

    End Sub

    Private Sub LoadAddressType()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT CreditorAddressTypeID, AddressType FROM tblCreditorAddressTypes ORDER BY AddressType"

        cboAddType.Items.Clear()
        cboAddType.Items.Add(New ListItem("Select an Address Type", 0))

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader
            While rd.Read
                cboAddType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "AddressType"), DatabaseHelper.Peel_int(rd, "CreditorAddressTypeID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

   Private Sub LoadStates(Optional ByVal SelectedStateID As Integer = 0)

      Dim rd As IDataReader = Nothing
      Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      cmd.CommandText = "SELECT * FROM tblState ORDER BY Abbreviation"

      cboMState.Items.Clear()
      cboMState.Items.Add(New ListItem(String.Empty, 0))

      Try

         cmd.Connection.Open()
         rd = cmd.ExecuteReader()

         While rd.Read()
            cboMState.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_int(rd, "StateID")))
         End While

      Catch ex As Exception

      Finally
         DatabaseHelper.EnsureReaderClosed(rd)
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
      End Try

   End Sub

   Private Sub LoadPhoneTypes(Optional ByVal SelectedPhoneID As Integer = 0)

      Dim rd As IDataReader = Nothing
      Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      cmd.CommandText = "SELECT * FROM tblCreditorPhoneType ORDER BY PhoneType"

      cboPhoneType.Items.Clear()
      cboPhoneType.Items.Add(New ListItem(String.Empty, 0))

      Try

         cmd.Connection.Open()
         rd = cmd.ExecuteReader()

         While rd.Read()
            cboPhoneType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "PhoneType"), DatabaseHelper.Peel_int(rd, "CreditorPhoneTypeID")))
         End While

      Catch e As Exception

      Finally
         DatabaseHelper.EnsureReaderClosed(rd)
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
      End Try

   End Sub

    Private Sub LoadMasterList(ByVal CreditorName As String)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      cmd.CommandText = "SELECT [Name], CreditorGroupID FROM tblCreditorGroup ORDER BY [Name]"

        cboMasterList.Items.Clear()
        cboMasterList.Items.Add(New ListItem("Unknown Creditor Group", 0))

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader
            While rd.Read
            cboMasterList.Items.Add(New ListItem(Trim(DatabaseHelper.Peel_string(rd, "Name")), DatabaseHelper.Peel_int(rd, "CreditorGroupID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Private Function GetZipCode(ByVal Value As String) As AssistedSolutions.WebControls.InputMask

        GetZipCode = New AssistedSolutions.WebControls.InputMask

        GetZipCode.CssClass = "entry"
        GetZipCode.Mask = "nnnnn-nnnn"
        GetZipCode.Text = Value

    End Function

    Public Sub cboMasterList_Change(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboMasterList.SelectedIndexChanged
        'Dim GroupID As Integer

        'Dim rd As IDataReader = Nothing
        'Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'Me.txtMCity.Text = ""
        'Me.cboMState.SelectedIndex = 0
        'Me.txtMZip.Text = ""


        'GroupID = CInt(cboMasterList.Items.FindByText(txtServicedBy.Text).Value)
        'cboMasterList.SelectedValue = GroupID

        'cmd.CommandText = "SELECT c.CreditorID, c.street FROM tblCreditor c WHERE CreditorGroupID = " & GroupID & " ORDER BY Street"

        'cboMasterAddress.Items.Clear()
        'cboMasterAddress.Items.Add(New ListItem(String.Empty, 0))

        'Try
        '   cmd.Connection.Open()
        '   rd = cmd.ExecuteReader
        '   While rd.Read
        '      cboMasterAddress.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Street"), DatabaseHelper.Peel_int(rd, "CreditorID")))
        '   End While

        '   If cboMasterAddress.Items.Count > 1 Then
        '      cboMasterAddress.Items(0).Text = "Select an address"
        '      txtMCity.Text = "Select an address"
        '   End If

        'Finally
        '   DatabaseHelper.EnsureReaderClosed(rd)
        '   DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        'End Try

    End Sub

    Public Sub PopulateDropDown()
        Dim GroupID As Integer

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Me.txtMCity.Text = ""
        Me.cboMState.SelectedIndex = 0
        Me.txtMZip.Text = ""

        Dim CreditorID As Integer = Val(txtSelected.Value.ToString)

        Try
            GroupID = CInt(cboMasterList.Items.FindByText(txtServicedBy.Text).Value)
            cboMasterList.SelectedValue = GroupID
        Catch e As Exception
            cboMasterList.SelectedIndex = 0
        End Try

        If GroupID = 0 Then
            cmd.CommandText = "SELECT c.CreditorID, c.street FROM tblCreditor c WHERE CreditorID = " & txtSelected.Value & " ORDER BY Street"
        Else
            cmd.CommandText = "SELECT c.CreditorID, c.street FROM tblCreditor c WHERE CreditorGroupID = " & GroupID & " ORDER BY Street"
        End If

        cboMasterAddress.Items.Clear()
        cboMasterAddress.Items.Add(New ListItem("Unknown Address", 0))

        cboMasterAddress.Items.Add(New ListItem(txtStreet.Value.ToString, txtSelected.Value))

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader
            While rd.Read
                If txtStreet.Value <> DatabaseHelper.Peel_string(rd, "Street") Then
                    cboMasterAddress.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Street"), DatabaseHelper.Peel_int(rd, "CreditorID")))
                End If
            End While

            If cboMasterAddress.Items.Count > 1 Then
                cboMasterAddress.Items(0).Text = "Select an address"
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Sub cboStreet_Changed(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboMasterAddress.SelectedIndexChanged
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT c.CreditorID, c.Street, c.City, c.StateID, ZipCode FROM tblCreditor c INNER JOIN tblState s ON s.StateID = c.StateID WHERE CreditorID = " & txtSelected.Value 'Me.cboMasterAddress.SelectedValue

        Me.txtMCity.Text = ""
        Me.cboMState.SelectedValue = 0
        Me.txtMZip.Text = ""

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader
            While rd.Read
                Me.txtMCity.Text = DatabaseHelper.Peel_string(rd, "City")
                Me.cboMState.Text = DatabaseHelper.Peel_int(rd, "StateID")
                Me.txtMZip.Text = DatabaseHelper.Peel_string(rd, "ZipCode")
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

#End Region

#Region "Link Routines"

    Protected Sub lnkSaveMasterCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveMasterCreditor.Click

        Dim GotIt As Integer = 0
        Dim strSQL As String = ""
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'Does the master creditor exist? If it's not choosen get it anyway and verify.
        If cboMasterList.SelectedIndex = 0 Then
            cmd.CommandText = "SELECT CreditorGroupID FROM tblCreditorGroup WHERE [Name] = '" & txtServicedBy.Text & "'"
        Else
            cmd.CommandText = "SELECT CreditorGroupID FROM tblCreditorGroup WHERE CreditorGroupID = " & cboMasterList.SelectedValue
        End If

        Using cmd
            cmd.Connection.Open()
            GotIt = cmd.ExecuteScalar
            cmd.Connection.Close()

            If GotIt > 0 Then
                'The master is here, don't add anything, just assign this address to the master
                strSQL = "UPDATE tblCreditor SET " _
                & "Name = '" & Me.txtServicedBy.Text & "', " _
                & "Street = '" & Me.cboMasterAddress.Text & "', " _
                & "Street2 = '" & Me.txtMStreet2.Text & "', " _
                & "City = '" & Me.txtMCity.Text & "', " _
                & "Stateid = " & CInt(Me.cboStateID.Value.ToString) & ", " _
                & "Zipcode = '" & Me.txtMZip.Text & "', " _
                & "Validated = " & 1 & ", " _
                & "LastModifiedBy = " & Me.UserID & ", " _
                & "LastModified = '" & Now & "' " _
                & "CreditorGroupID = " & GotIt & ", " _
                & "CreditorAddressTypeID = " & cboAddType.SelectedValue & " " _
                & "WHERE CreditorID = " & Me.txtSelected.Value
            Else
                'Add this creditor as a Master creditor group table first
                strSQL = "INSERT INTO tblCreditorGroup ([Name], Created, CreatedBy, LastModified, LastModifiedBy) " _
                & "OUTPUT INSERTED.CreditorGroupID " _
                & "VALUES ('" & txtServicedBy.Text & "', '" & Now & "', " & UserID & ", '" & Now & "', " & UserID & ") "

                'Get the new Group ID
                cmd.CommandText = strSQL
                cmd.Connection.Open()
                GotIt = cmd.ExecuteScalar
                cmd.Connection.Close()

                'Now update tblCreditor and set the group id and address type id
                If GotIt > 0 Then
                    strSQL = "UPDATE tblCreditor SET " _
                    & "Validated = " & 1 & ", " _
                    & "CreditorGroupID = " & GotIt & ", " _
                    & "CreditorAddressTypeID = " & cboAddType.SelectedValue & ", " _
                    & "LastModifiedBy = " & Me.UserID & ", " _
                    & "LastModified = '" & Now & "' " _
                    & "WHERE CreditorID = " & txtSelected.Value
                End If
            End If

            'Execute this and clean up
            cmd.CommandText = strSQL
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

        End Using

        Me.txtCreditor.Value = ""
        Me.txtServicedBy.Text = ""
        cboMasterAddress.SelectedIndex = 0
        Me.txtMStreet2.Text = ""
        Me.txtMPhone.Text = ""
        Me.txtMCity.Text = ""
        Me.txtMZip.Text = ""
        Me.cboMState.SelectedIndex = 0

        LoadRecord()
    End Sub

    Protected Sub lnkSaveAddress_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAddress.Click

        'Does the address exist?
        Dim GotIt As Integer = 0
        Dim strSQL As String = ""
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'Set the creditor ID.
        GotIt = CInt(Me.txtSelected.Value)

        Using cmd
            cmd.Connection.Open()
            GotIt = cmd.ExecuteScalar

            If GotIt > 0 Then
                'The master is here, don't add anything, just assign this address to the master
                strSQL = "UPDATE tblCreditor SET " _
                & "Name = '" & Me.txtServicedBy.Text & "', " _
                & "Street = '" & Me.cboMasterAddress.Text & "', " _
                & "Street2 = '" & Me.txtMStreet2.Text & "', " _
                & "City = '" & Me.txtMCity.Text & "', " _
                & "Stateid = " & CInt(Me.cboStateID.Value.ToString) & ", " _
                & "Zipcode = '" & Me.txtMZip.Text & "', " _
                & "Validated = " & 1 & ", " _
                & "LastModifiedBy = " & Me.UserID & ", " _
                & "LastModified = '" & Now & "' " _
                & "CreditorGroupID = " & GotIt & ", " _
                & "CreditorAddressTypeID = " & cboAddType.SelectedValue & " " _
                & "WHERE CreditorID = " & Me.txtSelected.Value
            End If

            'Execute this and clean up
            cmd.CommandText = strSQL
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
        End Using

        Me.txtCreditor.Value = ""
        Me.txtServicedBy.Text = ""
        cboMasterAddress.SelectedIndex = 0
        Me.txtMStreet2.Text = ""
        Me.txtMPhone.Text = ""
        Me.txtMCity.Text = ""
        Me.txtMZip.Text = ""
        Me.cboMState.SelectedIndex = 0

        LoadRecord()

    End Sub

    Protected Sub lnkValidateCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkValidateCreditor.Click

        If Me.txtServicedBy.Text = "" Then
            Exit Sub
        End If

        Dim strSQL As String = ""
        Dim cmSQL As SqlCommand
        Dim cnSQL As SqlConnection

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        strSQL = "UPDATE tblCreditor SET " _
        & "Name = '" & Me.txtServicedBy.Text & "', " _
        & "Street = '" & Me.cboMasterAddress.Text & "', " _
        & "Street2 = '" & Me.txtMStreet2.Text & "', " _
        & "City = '" & Me.txtMCity.Text & "', " _
        & "Stateid = " & CInt(Me.cboStateID.Value.ToString) & ", " _
        & "Zipcode = '" & Me.txtMZip.Text & "', " _
        & "Validated = " & 1 & ", " _
        & "LastModifiedBy = " & Me.UserID & ", " _
        & "LastModified = '" & Now & "' " _
        & "WHERE CreditorID = " & Me.txtSelected.Value

        cnSQL = New SqlConnection(cmd.Connection.ConnectionString)
        cnSQL.Open()

        cmSQL = New SqlCommand(strSQL, cnSQL)

        cmSQL.ExecuteNonQuery()

        cmSQL.Dispose()
        cnSQL.Close()

        'Me.txtCreditor.Text = ""
        'Me.txtStreet.Text = ""
        'Me.txtStreet2.Text = ""
        'Me.txtCity.Text = ""
        'Me.txtZipCode.Text = ""
        'Me.cboStateID.SelectedValue = 0

        LoadRecord()

    End Sub

    Protected Sub lnkRemoveCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveCreditor.Click
        If Me.txtCreditor.Value = "" Then
            Exit Sub
        End If

        Dim strSQL As String = ""
        Dim cmSQL As SqlCommand
        Dim cnSQL As SqlConnection

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        strSQL = "DELETE FROM tblCreditor " _
        & "WHERE CreditorID = " & Me.txtSelected.Value

        cnSQL = New SqlConnection(cmd.Connection.ConnectionString)
        cnSQL.Open()

        cmSQL = New SqlCommand(strSQL, cnSQL)

        cmSQL.ExecuteNonQuery()

        cmSQL.Dispose()
        cnSQL.Close()
    End Sub

    Protected Sub lnkCloseInformation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformation.Click

        'insert flag record
        UserInfoBoxHelper.Insert(1, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

#End Region

End Class
