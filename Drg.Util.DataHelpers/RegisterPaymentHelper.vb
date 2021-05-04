Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class RegisterPaymentHelper

   Public Shared Sub Remove(ByVal RegisterPaymentIDs() As Integer)
      Remove(RegisterPaymentIDs, Nothing)
   End Sub
   Public Shared Sub Remove(ByVal RegisterPaymentIDs() As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

      If Not RegisterPaymentIDs Is Nothing Then

         'loop through and remove each one
         For Each RegisterPaymentID As Integer In RegisterPaymentIDs
            Remove(RegisterPaymentID, DoCleanUp)
         Next

      End If

   End Sub
   Public Shared Sub Remove(ByVal RegisterPaymentID As Integer)
      Remove(RegisterPaymentID, Nothing)
   End Sub
   Public Shared Sub Remove(ByVal RegisterPaymentID As Integer, ByVal DoCleanup As Nullable(Of Boolean))

      If CanDelete(RegisterPaymentID) Then
         Delete(RegisterPaymentID, DoCleanup)
      Else
         Void(RegisterPaymentID, DoCleanup)
      End If

   End Sub
   Public Shared Sub Void(ByVal RegisterPaymentIDs() As Integer, ByVal UserID As Integer, Optional ByVal Reason As String = "")
      Void(RegisterPaymentIDs, Nothing, UserID, Reason)
   End Sub
   Public Shared Sub Void(ByVal RegisterPaymentIDs() As Integer, ByVal DoCleanup As Nullable(Of Boolean), ByVal UserID As Integer, Optional ByVal Reason As String = "")

      If Not RegisterPaymentIDs Is Nothing Then

         'loop through and void each one
         For Each RegisterPaymentID As Integer In RegisterPaymentIDs
            Void(RegisterPaymentID, DoCleanup, UserID, Reason)
         Next

      End If

   End Sub
   Public Shared Sub Void(ByVal RegisterPaymentID As Integer, ByVal UserID As Integer, Optional ByVal Reason As String = "")
      Delete(RegisterPaymentID, Nothing)
      AuditVoid(RegisterPaymentID, Reason, UserID)
   End Sub
   Public Shared Sub Void(ByVal RegisterPaymentID As Integer, ByVal DoCleanUp As Nullable(Of Boolean), ByVal UserID As Integer, Optional ByVal Reason As String = "")

      Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DoRegisterPaymentVoid")

         DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)
         If UserID > 0 Then
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)
         End If

         If DoCleanUp.HasValue Then
            DatabaseHelper.AddParameter(cmd, "DoCleanUp", DoCleanUp.Value)
         End If

         Using cn As IDbConnection = cmd.Connection

            cn.Open()
            cmd.ExecuteNonQuery()

         End Using
      End Using

      AuditVoid(RegisterPaymentID, Reason, UserID)
   End Sub
   Public Shared Sub AuditVoid(ByVal RegisterPaymentID As Integer, ByVal Reason As String, ByVal UserID As Integer)
      Dim amount As Double = DataHelper.FieldLookup("tblRegisterPayment", "Amount", "RegisterPaymentID = " + RegisterPaymentID.ToString())
      Dim registerID As Integer = DataHelper.FieldLookup("tblRegisterPayment", "FeeRegisterID", "RegisterPaymentID = " + RegisterPaymentID.ToString())
      Dim clientID As Integer = DataHelper.FieldLookup("tblRegister", "ClientID", "RegisterID = " + registerID.ToString())

      AuditTransaction.AuditTransaction(clientID, RegisterPaymentID, "registerpayment", Reason, amount, UserID)
   End Sub
   Public Shared Function CanDelete(ByVal RegisterPaymentID As Integer) As Boolean

      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

         cmd.CommandText = "SELECT dbo.udf_CanDeleteRegisterPayment(@RegisterPaymentID)"

         DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

         Using cn As IDbConnection = cmd.Connection

            cn.Open()
            Return StringHelper.ParseBoolean(cmd.ExecuteScalar())

         End Using
      End Using

   End Function
   Public Shared Sub Delete(ByVal RegisterPaymentIDs() As Integer)
      Delete(RegisterPaymentIDs, Nothing)
   End Sub
   Public Shared Sub Delete(ByVal RegisterPaymentIDs() As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

      If Not RegisterPaymentIDs Is Nothing Then

         'loop through and delete each one
         For Each RegisterPaymentID As Integer In RegisterPaymentIDs
            Delete(RegisterPaymentID, DoCleanUp)
         Next

      End If

   End Sub
   Public Shared Sub Delete(ByVal RegisterPaymentID As Integer)
      Delete(RegisterPaymentID, Nothing)
   End Sub
   Public Shared Sub Delete(ByVal RegisterPaymentID As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

      Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeleteRegisterPayment")

         DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

         If DoCleanUp.HasValue Then
            DatabaseHelper.AddParameter(cmd, "DoCleanUp", DoCleanUp.Value)
         End If

         Using cn As IDbConnection = cmd.Connection

            cn.Open()
            cmd.ExecuteNonQuery()

         End Using
      End Using

   End Sub
End Class