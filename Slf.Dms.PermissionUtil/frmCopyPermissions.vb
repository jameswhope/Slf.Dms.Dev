Imports Drg.Util.DataAccess
Imports System.Text

Public Class frmCopyPermissions
    Private Analyzed As Boolean
    Private frmInst As Form
    Private Sub frmCopyPermissions_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Sub btnAnalyze_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAnalyze.Click
        Dim message As String = "Ensure that the selected database has the following tables, in addition to standard permission tables: "

        message += vbCrLf & " - tblFunction_old"
        message += vbCrLf & " - tblGroupPermission_new"
        message += vbCrLf & " - tblPermission_new"

        If MessageBox.Show(message, "Confirm Tables Exist", MessageBoxButtons.OKCancel) = Windows.Forms.DialogResult.OK Then
            Analyzed = Analyze()
        End If

    End Sub
    Private Structure IDPair
        Dim OldID As Integer
        Dim NewID As Integer
    End Structure

    Private Function GetFunctionPairs() As Dictionary(Of Integer, IDPair)
        Dim fps As New Dictionary(Of Integer, IDPair)
        Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.CommandText = "select tblfunction.functionid as newfunctionid,tblfunction_old.functionid as oldfunctionid from tblfunction_old left outer join tblfunction on tblfunction.fullname=tblfunction_old.fullname"
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        Dim fp As New IDPair
                        fp.OldID = DatabaseHelper.Peel_int(rd, "oldfunctionid")
                        If Not rd.IsDBNull(rd.GetOrdinal("newfunctionid")) Then
                            fp.NewID = DatabaseHelper.Peel_int(rd, "newfunctionid")
                            fps.Add(fp.OldID, fp)
                        Else
                            'try to find the manual link
                            For Each p As Panel In pnlManual.Controls
                                If p.Tag = fp.OldID Then
                                    For Each c As Control In p.Controls
                                        If TypeOf c Is TextBox Then
                                            Dim t As TextBox = CType(c, TextBox)
                                            Dim i As Integer
                                            If Integer.TryParse(t.Text, i) Then
                                                fp.NewID = i
                                                fps.Add(fp.OldID, fp)
                                            End If
                                        End If
                                    Next
                                End If
                            Next
                        End If
                    End While
                End Using
            End Using
        End Using
        Return fps
    End Function

    Private Sub Copy()
        If MessageBox.Show("This program assumes the user groups are resolved.  Do you want to proceed?", "Confirmation", MessageBoxButtons.YesNo) = Windows.Forms.DialogResult.Yes Then
            Try
                Dim fps As Dictionary(Of Integer, IDPair) = GetFunctionPairs()

                'first, update all old permissions with new functionids
                For Each fp As IDPair In fps.Values
                    If Not fp.NewID = fp.OldID Then
                        Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
                            Using cmd.Connection
                                cmd.Connection.Open()

                                cmd.CommandText = "update tblpermission set functionid=@newid where functionid=@oldid"
                                DatabaseHelper.AddParameter(cmd, "newid", fp.NewID)
                                DatabaseHelper.AddParameter(cmd, "oldid", fp.OldID)
                                cmd.ExecuteNonQuery()
                            End Using
                        End Using
                    End If
                Next

                'copy new group permissions
                Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.CommandText = "select usertypeid,usergroupid,tblpermission_new.* from tblgrouppermission_new inner join tblpermission_new on tblgrouppermission_new.permissionid=tblpermission_new.permissionid"
                        Using rd As IDataReader = cmd.ExecuteReader
                            While rd.Read
                                Dim FunctionID As Integer = DatabaseHelper.Peel_int(rd, "functionid")
                                Dim PermissionTypeID As Integer = DatabaseHelper.Peel_int(rd, "permissiontypeid")
                                Dim UserGroupID As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "usergroupid")
                                Dim UserTypeID As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "usertypeid")
                                Dim Value As Boolean = DatabaseHelper.Peel_bool(rd, "value")

                                InsertGroupPermission(FunctionID, PermissionTypeID, UserGroupID, UserTypeID, Value)
                            End While
                        End Using
                    End Using
                End Using
            Catch e As Exception
                MessageBox.Show("Copy failed.  Error: " & vbCrLf & e.ToString)
            End Try
            MessageBox.Show("done")
        End If
    End Sub

    Private Sub InsertGroupPermission(ByVal FunctionId As Integer, ByVal PermissionTypeId As Integer, ByVal UserGroupId As Nullable(Of Integer), ByVal UserTypeId As Nullable(Of Integer), ByVal Value As Boolean)
        Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
            cmd.CommandType = CommandType.StoredProcedure
            Using cmd.Connection
                cmd.Connection.Open()
                DatabaseHelper.AddParameter(cmd, "functionid", FunctionId)
                DatabaseHelper.AddParameter(cmd, "permissiontypeid", PermissionTypeId)
                DatabaseHelper.AddParameter(cmd, "value", Value)
                DatabaseHelper.AddParameter(cmd, "overwriteold", False)

                If UserGroupId.HasValue Then 'group permission
                    DatabaseHelper.AddParameter(cmd, "usergroupid", UserGroupId.Value)
                    cmd.CommandText = "stp_Permissions_Group_IoU_Single"
                ElseIf UserTypeId.HasValue Then 'usertype permission
                    DatabaseHelper.AddParameter(cmd, "usertypeid", UserTypeId.Value)
                    cmd.CommandText = "stp_Permissions_UserType_IoU_Single"
                End If

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Function Analyze() As Boolean
        Try
            pnlManual.Controls.Clear()
            pnlNew.Controls.Clear()

            Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
                Using cmd.Connection
                    cmd.Connection.Open()
                    cmd.CommandText = "select * from tblfunction order by fullname"
                    Dim top As Integer = 0
                    Using rd As IDataReader = cmd.ExecuteReader
                        While rd.Read
                            Dim l As New Label
                            l.AutoSize = True
                            l.Text = DatabaseHelper.Peel_int(rd, "functionid") & "   " & DatabaseHelper.Peel_string(rd, "fullname") & "   """ & DatabaseHelper.Peel_string(rd, "name") & """"
                            pnlNew.Controls.Add(l)
                            l.Top = top + l.Height
                            top = l.Top
                        End While
                    End Using

                    top = 0

                    cmd.CommandText = "select * from tblfunction_old where not fullname in (select fullname from tblfunction)"
                    Using rd As IDataReader = cmd.ExecuteReader
                        While rd.Read
                            Dim pnl As New Panel

                            Dim l As New Label
                            Dim t As New TextBox
                            t.Width = "25"
                            l.AutoSize = True
                            l.Text = DatabaseHelper.Peel_string(rd, "fullname") & "   """ & DatabaseHelper.Peel_string(rd, "name") & """"
                            pnl.Tag = DatabaseHelper.Peel_int(rd, "functionid")
                            pnl.Controls.Add(t)
                            pnl.Controls.Add(l)
                            t.Left = 0
                            l.Left = 30
                            pnlManual.Controls.Add(pnl)
                            pnl.Height = 20
                            pnl.Top = top + pnl.Height
                            pnl.Width = l.Width + 30

                            top = pnl.Top
                        End While
                    End Using
                End Using
            End Using
        Catch e As Exception
            MessageBox.Show("Analysis failed.  Error: " & vbCrLf & e.ToString)
            Return False
        End Try
        Return True
    End Function

    Private Sub btnCopy_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCopy.Click
        If Analyzed Then
            Copy()
        Else
            MessageBox.Show("You must successfully analyze first")
        End If

    End Sub

    Private Sub ToolStripButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ToolStripButton1.Click
        frmInst = New frmInstructions
        frmInst.Show()

    End Sub

    Private Function GetInserts(ByVal table As String, ByVal DestName As String) As String
        Dim sb As New StringBuilder

        If String.IsNullOrEmpty(DestName) Then
            sb.AppendLine("set identity_insert " & table & " on")
        Else
            sb.AppendLine("set identity_insert " & DestName & " on")
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create(cboConnString.Text).CreateCommand
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "sp_generate_inserts"
            DatabaseHelper.AddParameter(cmd, "table_name", table)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        Dim statement As String = rd.GetString(0)
                        If Not String.IsNullOrEmpty(DestName) Then
                            statement = statement.Replace(table, DestName)
                        End If
                        sb.AppendLine(statement)
                    End While
                End Using
            End Using
        End Using

        If String.IsNullOrEmpty(DestName) Then
            sb.AppendLine("set identity_insert " & table & " off")
        Else
            sb.AppendLine("set identity_insert " & DestName & " off")
        End If
        Return sb.ToString
    End Function



    Private Sub btnPrep_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPrep.Click
        If MessageBox.Show("This must be run on the source database.  The script will be copied to the clipboard.  Press OK to continue.", "Confirmation", MessageBoxButtons.OKCancel) = Windows.Forms.DialogResult.OK Then
            Dim sb As New StringBuilder

            sb.AppendLine("exec sp_rename 'tblFunction', 'tblFunction_old'")
            sb.AppendLine("truncate table tblControl")
            sb.AppendLine("truncate table tblControlFunction")
            sb.AppendLine("truncate table tblPage")

            sb.AppendLine(GetInserts("tblControl", Nothing))
            sb.AppendLine(GetInserts("tblControlFunction", Nothing))
            sb.AppendLine(GetInserts("tblPage", Nothing))

            'Create tblFunction
            Dim tblScript As String = "CREATE TABLE [dbo].[tblFunction](	[FunctionId] [int] IDENTITY(1,1) NOT NULL,	[ParentFunctionId] [int] NULL,	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,	[FullName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,	[Description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,	[IsSystem] [bit] NOT NULL CONSTRAINT [DF_tblFunction_IsSystem_$x$]  DEFAULT (0),	[IsOperation] [bit] NOT NULL CONSTRAINT [DF_tblFunction_IsOperation_$x$]  DEFAULT (0), CONSTRAINT [PK_tblFunction_$x$] PRIMARY KEY CLUSTERED (	[FunctionId] ASC)) ON [PRIMARY]"
            Dim rnd As String = Guid.NewGuid().ToString.Replace("-", "")
            sb.AppendLine(tblScript.Replace("$x$", rnd))
            sb.AppendLine("GO")

            'Create tblGroupPermission_new
            sb.AppendLine("CREATE TABLE [dbo].[tblGroupPermission_new](	[GroupPermissionId] [int] IDENTITY(1,1) NOT NULL,	[UserTypeId] [int] NULL,	[UserGroupId] [int] NULL,	[PermissionId] [int] NOT NULL, CONSTRAINT [PK_tblGroupPermission_new] PRIMARY KEY CLUSTERED (	[GroupPermissionId] ASC)) ON [PRIMARY]")
            sb.AppendLine("GO")

            'Create tblPermission_new
            sb.AppendLine("CREATE TABLE [dbo].[tblPermission_new](	[PermissionId] [int] IDENTITY(1,1) NOT NULL,	[PermissionTypeId] [int] NOT NULL,	[Value] [bit] NULL,	[FunctionId] [int] NOT NULL, CONSTRAINT [PK_tblPermission_new] PRIMARY KEY CLUSTERED (	[PermissionId] ASC)) ON [PRIMARY]")
            sb.AppendLine("GO")

            'Populate tables
            sb.AppendLine(GetInserts("tblFunction", Nothing))
            sb.AppendLine(GetInserts("tblGroupPermission", "tblGroupPermission_new"))
            sb.AppendLine(GetInserts("tblPermission", "tblPermission_new"))

            Clipboard.SetText(sb.ToString)
            MessageBox.Show("Script has been copied to clipboard")
        End If
    End Sub
End Class