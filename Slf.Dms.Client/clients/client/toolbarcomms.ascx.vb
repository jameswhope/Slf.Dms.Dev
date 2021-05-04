Imports system.data
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class clients_client_toolbarcomms
    Inherits System.Web.UI.UserControl

    Public AutoSyncQS As String
    Public _MyPage As Object

    Public Property MyPage() As Object
        Get
            Return _MyPage
        End Get
        Set(ByVal value As Object)
            _MyPage = value
        End Set
    End Property

    Public ReadOnly Property DataClientID() As Integer
        Get
            Return CType(MyPage, IClientPage).DataClientID
        End Get
    End Property
    Public ReadOnly Property ClientEntityName() As String
        Get
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.CommandText = "select firstname + ' ' + lastname from tblclient inner join tblperson on tblclient.primarypersonid=tblperson.personid where tblclient.clientid=@clientid"
                    DatabaseHelper.AddParameter(cmd, "@clientid", DataClientID)
                    Return cmd.ExecuteScalar()
                End Using
            End Using
        End Get
    End Property

    Public ReadOnly Property HasEntity() As Boolean
        Get
            If Not TypeOf (Me.Page) Is IEntityPage Then
                Return False
            Else
                Return Not CType(Me.Page, IEntityPage).IsAdd
            End If
        End Get
    End Property

    Public ReadOnly Property EntityRelationTypeID() As Integer
        Get
            If HasEntity Then
                Return CType(Me.Page, IEntityPage).RelationTypeID
            Else
                Return -1
            End If
        End Get
    End Property
    Public ReadOnly Property EntityRelationID() As Integer
        Get
            If HasEntity Then
                Return CType(Me.Page, IEntityPage).RelationID
            Else
                Return -1
            End If
        End Get
    End Property
   Public ReadOnly Property EntityName() As String
      Get
         If HasEntity Then
            Return Server.UrlEncode(CType(Me.Page, IEntityPage).EntityName)
         Else
            Return ""
         End If
      End Get
   End Property

    Public ReadOnly Property NoteCountEntity() As Integer
        Get
            If Not HasEntity Then
                Return 0
            Else
                Return DataHelper.FieldCount("tblnoterelation", "noteid", "relationtypeid=" & EntityRelationTypeID & " and relationid=" & EntityRelationID)
            End If
        End Get
    End Property
    Public ReadOnly Property NoteCountAll() As Integer
        Get
            Return DataHelper.FieldCount("tblnote", "noteid", "clientid=" & DataClientID)
        End Get
    End Property
    Public ReadOnly Property PhoneCallCountEntity() As Integer
        Get
            If Not HasEntity Then
                Return 0
            Else
                Return DataHelper.FieldCount("tblPhoneCallrelation", "PhoneCallid", "relationtypeid=" & EntityRelationTypeID & " and relationid=" & EntityRelationID)
            End If
        End Get
    End Property
    Public ReadOnly Property PhoneCallCountAll() As Integer
        Get
            Return DataHelper.FieldCount("tblPhoneCall", "PhoneCallid", "clientid=" & DataClientID)
        End Get
    End Property

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        ltrCommCount.Text = ""
        If HasEntity Then
            ltrCommCount.Text += (NoteCountEntity + PhoneCallCountEntity).ToString & "&nbsp;of&nbsp;"
        End If
        ltrCommCount.Text += (NoteCountAll + PhoneCallCountAll).ToString

        Dim AutoSync As Boolean = False
        Dim PageAutoSync As Boolean = PageAutoSync = Session("Comms_AutoSync") IsNot Nothing AndAlso Session("Comms_AutoSync") = True

        If PageAutoSync Then
            If Not TypeOf (Me.Page) Is IEntityPageOverrideSync Then
                AutoSyncQS = "ClientID=" & DataClientID() & "&RelationTypeID=" & EntityRelationTypeID & "&RelationID=" & EntityRelationID & "&EntityName=" & EntityName
                If Session("Comms_LastQS") Is Nothing Then
                    AutoSync = True
                ElseIf Not AutoSyncQS.Equals(Session("Comms_LastQS")) Then
                    AutoSync = True
                End If
            End If
        End If

        If AutoSync Then
            Page.ClientScript.RegisterStartupScript(Me.GetType, "AutoSync", "Comms();", True)
        End If
    End Sub
End Class


