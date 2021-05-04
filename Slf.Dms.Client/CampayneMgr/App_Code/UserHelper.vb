Imports System.Data
Imports System.Data.SqlClient
Imports System.Security.Cryptography

Imports Microsoft.VisualBasic

Public Class UserHelper

#Region "Methods"

    Public Shared Function GenerateSHAHash(ByVal Password As String) As String
        Dim data As Byte()
        Dim hasher As SHA1 = SHA1.Create()

        data = hasher.ComputeHash(Encoding.ASCII.GetBytes(Password.Trim()))

        Dim sb As New StringBuilder(data.Length * 2, data.Length * 2)

        Dim i As Integer = 0
        While i < data.Length
            sb.Append(data(i).ToString("x").PadLeft(2, "0"c))
            System.Math.Max(System.Threading.Interlocked.Increment(i), i - 1)
        End While

        Return sb.ToString()
    End Function

    Public Shared Function GetUserObject(UserName As String, Password As String) As UserObj
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@UserName", SqlDbType.VarChar)
        param.Value = UserName.Trim
        params.Add(param)

        param = New SqlParameter("@Password", SqlDbType.VarChar)
        param.Value = Password.Trim
        params.Add(param)
        Dim currentU As New UserObj

        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetUserByCredentials", CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                With currentU
                    .Active = dr("active").ToString
                    .Created = dr("Created").ToString
                    .ext = dr("ext").ToString
                    .FirstName = dr("FirstName").ToString
                    If Not IsDBNull(dr("GroupID")) Then
                        .GroupID = dr("GroupID").ToString
                    End If
                    .LastName = dr("LastName").ToString
                    .Password = dr("Password").ToString
                    .Spanish = dr("Spanish").ToString
                    .UserId = dr("UserId").ToString
                    .UserName = dr("UserName").ToString
                    .UserTypeId = dr("UserTypeId").ToString
                    .HasTempPassword = dr("HasTempPassword").ToString
                    If Not IsDBNull(dr("UserTypeUniqueID")) Then
                        .UserTypeUniqueID = dr("UserTypeUniqueID").ToString
                    Else
                        .UserTypeUniqueID = -1
                    End If
                End With

                Exit For
            Next
        End Using

        Return currentU
    End Function

    Public Shared Function GetUserObject(UserID As Integer) As UserObj
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@UserID", SqlDbType.VarChar)
        param.Value = UserID
        params.Add(param)

        Dim currentU As New UserObj

        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetUserById", CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                With currentU
                    .Active = dr("active").ToString
                    .Created = dr("Created").ToString
                    .ext = IIf(IsDBNull(dr("ext")), "", dr("ext").ToString)
                    .FirstName = dr("FirstName").ToString
                    If Not IsDBNull(dr("GroupID")) Then
                        .GroupID = dr("GroupID").ToString
                    End If
                    .LastName = dr("LastName").ToString
                    .Password = dr("Password").ToString
                    .Spanish = dr("Spanish").ToString
                    .UserId = dr("UserId").ToString
                    .UserName = dr("UserName").ToString
                    .UserTypeId = dr("UserTypeId").ToString
                    .HasTempPassword = dr("HasTempPassword").ToString

                    If Not IsDBNull(dr("UserTypeUniqueID")) Then
                        .UserTypeUniqueID = dr("UserTypeUniqueID").ToString
                    Else
                        .UserTypeUniqueID = -1
                    End If

                End With

                Exit For
            Next
        End Using

        Return currentU
    End Function
    Public Shared Function GetUserWebsites(userid As Integer) As List(Of String)
        Dim ssql As String = "SELECT uwx.UserWebsiteID, uwx.WebsiteID, w.Name FROM tblUserWebsitesX AS uwx INNER JOIN tblWebsites AS w ON uwx.WebsiteID = w.WebsiteID where userid = @userid"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("UserId", userid))

        GetUserWebsites = New List(Of String)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text, params.ToArray)
            For Each dr As DataRow In dt.Rows
                GetUserWebsites.Add(dr("name").ToString)
            Next
        End Using
    End Function
    Public Shared Sub ResetPassword(userid As String, newpassword As String)
        Dim ssql As String = "update tbluser set password = '{0}', HasTempPassword = 1 where userid = {1}"
        ssql = String.Format(ssql, GenerateSHAHash(newpassword), userid)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub
    Public Shared Function ChangePassword(userid As String, oldpassword As String, newpassword As String) As Boolean
        Dim result As Boolean = True
        Try
            Dim ssql As String = "update tbluser set password = '{0}', HasTempPassword = 0 where userid = {1} and password = '{2}'"
            ssql = String.Format(ssql, GenerateSHAHash(newpassword), userid, oldpassword)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
        Catch ex As Exception
            result = False
            Throw
        End Try

        Return result
    End Function
    Public Shared Function SaveUser(u As UserObj) As Integer
        Dim ssql As String = "stp_users_InsertUpdateUser"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("UserId", u.UserId))
        params.Add(New SqlParameter("UserName", u.UserName))
        params.Add(New SqlParameter("UserTypeId", u.UserTypeId))
        If u.UserId = -1 Then
            u.Password = GenerateSHAHash(u.Password)
        End If
        params.Add(New SqlParameter("Password", u.Password))
        params.Add(New SqlParameter("FirstName", u.FirstName))
        params.Add(New SqlParameter("LastName", u.LastName))
        params.Add(New SqlParameter("Active", u.Active))
        params.Add(New SqlParameter("ext", u.ext))
        params.Add(New SqlParameter("Spanish", u.Spanish))
        params.Add(New SqlParameter("GroupID", u.GroupID))
        params.Add(New SqlParameter("UserTypeUniqueID", u.UserTypeUniqueID))

        Dim uid As String = SqlHelper.ExecuteScalar(ssql, CommandType.StoredProcedure, params.ToArray)

        Return uid

    End Function

    Public Shared Sub RedirectUser(_UserTypeId As Integer, _UserID As Integer)
        Select Case _UserTypeId
            Case 5
                HttpContext.Current.Response.Redirect("portals/affiliate/")
            Case 6
                HttpContext.Current.Response.Redirect("portals/buyer/")
            Case 7
                HttpContext.Current.Response.Redirect("portals/advertiser/")
            Case Else
                HttpContext.Current.Response.Redirect("default.aspx")
        End Select
    End Sub

#End Region 'Methods

#Region "Nested Types"
    
    Public Class UserObj
        Implements IDisposable

#Region "Fields"

        Private _Active As Boolean
        Private _Created As Date
        Private _FirstName As String
        Private _GroupID As Integer
        Private _HasTempPassword As Boolean
        Private _LastName As String
        Private _Password As String
        Private _Spanish As Boolean
        Private _UserId As Integer
        Private _UserName As String
        Private _UserTypeId As Integer
        Private _UserTypeUniqueID As Integer
        Private _UserOwnedWebsites As List(Of String)
        Private _ext As String
        Private disposedValue As Boolean 'To detect redundant calls

#End Region 'Fields

#Region "Properties"

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal Value As Boolean)
                _Active = Value
            End Set
        End Property

        Public Property Created() As Date
            Get
                Return _Created
            End Get
            Set(ByVal Value As Date)
                _Created = Value
            End Set
        End Property

        Public Property FirstName() As String
            Get
                Return _FirstName
            End Get
            Set(ByVal Value As String)
                _FirstName = Value
            End Set
        End Property

        Public Property GroupID() As Integer
            Get
                Return _GroupID
            End Get
            Set(ByVal Value As Integer)
                _GroupID = Value
            End Set
        End Property

        Public Property HasTempPassword() As Boolean
            Get
                Return _HasTempPassword
            End Get
            Set(ByVal value As Boolean)
                _HasTempPassword = value
            End Set
        End Property

        Public Property LastName() As String
            Get
                Return _LastName
            End Get
            Set(ByVal Value As String)
                _LastName = Value
            End Set
        End Property

        Public Property Password() As String
            Get
                Return _Password
            End Get
            Set(ByVal Value As String)
                _Password = Value
            End Set
        End Property

        Public Property Spanish() As Boolean
            Get
                Return _Spanish
            End Get
            Set(ByVal Value As Boolean)
                _Spanish = Value
            End Set
        End Property

        Public Property UserId() As Integer
            Get
                Return _UserId
            End Get
            Set(ByVal Value As Integer)
                _UserId = Value
            End Set
        End Property

        Public Property UserName() As String
            Get
                Return _UserName
            End Get
            Set(ByVal Value As String)
                _UserName = Value
            End Set
        End Property

        Public Property UserOwnedWebsites() As List(Of String)
            Get
                Return _UserOwnedWebsites
            End Get
            Set(ByVal value As List(Of String))
                _UserOwnedWebsites = value
            End Set
        End Property
        Public Property UserTypeId() As Integer
            Get
                Return _UserTypeId
            End Get
            Set(ByVal Value As Integer)
                _UserTypeId = Value
            End Set
        End Property

        Public Property UserTypeUniqueID() As Integer
            Get
                Return _UserTypeUniqueID
            End Get
            Set(ByVal value As Integer)
                _UserTypeUniqueID = value
            End Set
        End Property

        Public Property ext() As String
            Get
                Return _ext
            End Get
            Set(ByVal Value As String)
                _ext = Value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        ' TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        'Protected Overrides Sub Finalize()
        '    ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        '    Dispose(False)
        '    MyBase.Finalize()
        'End Sub
        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        ' IDisposable
        Protected Overridable Sub Dispose(disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: dispose managed state (managed objects).
                End If

                ' TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

#End Region 'Methods

    End Class

#End Region 'Nested Types

End Class