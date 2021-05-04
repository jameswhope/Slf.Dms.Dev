Imports Microsoft.VisualBasic
Imports System.Data

Public Class ToolsHelper
    Public Structure ClientInfo
        Public DataClientID As Integer
        Public CreditorInstanceID As Integer
        Public ClientSixHundredNumber As String
        Public ClientSSN As String
        Public CreditorAcctNum As String
        Public CreditorID As String
        Public CreditorAccountID As String
        Public CreditorName As String
        Sub New(ByVal dataClientID As Integer, ByVal credInstanceID As Integer, ByVal ClientSixHundredNumber As String, ByVal ssn As String, ByVal CreditoracctNumber As String, ByVal IDOfCreditor As String, ByVal ClientCreditorAccountID As String, ByVal creditorName As String)

            Me.DataClientID = dataClientID
            Me.CreditorInstanceID = credInstanceID
            Me.ClientSixHundredNumber = ClientSixHundredNumber
            Me.ClientSSN = ssn
            Me.CreditorAcctNum = CreditoracctNumber
            Me.CreditorID = IDOfCreditor
            Me.CreditorAccountID = ClientCreditorAccountID
            Me.CreditorName = creditorName
        End Sub
    End Structure
    Public Structure CreditorInfo
        Public CreditorID As Integer
        Public Name As String

        Public Sub New(ByVal id As Integer, ByVal credname As String)
            Me.CreditorID = id
            Me.Name = credname
        End Sub
    End Structure
    Public Shared Function getAccountsForClient(ByVal clientAcctNumber As String, ByVal creditorAcctLastFour As String) As DataTable

        Dim clientid = SharedFunctions.AsyncDB.executeScalar("Select top 1 clientid from tblclient where accountnumber = " & clientAcctNumber, ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim sSQL As String
        sSQL = "select top 1 a.clientid, ci.creditorinstanceid,p.ssn,ci.accountnumber, ci.creditorid,a.accountid,c.name [CreditorName] "
        sSQL += "from tblaccount a "
        sSQL += "inner join tblcreditorinstance ci on a.accountid=ci.accountid "
        sSQL += "inner join tblcreditor c on ci.creditorid=c.creditorid "
        sSQL += "inner join tblperson p on a.clientid=p.clientid "
        sSQL += "where ci.accountnumber like '%" & creditorAcctLastFour.Trim & "' and a.clientid = " & clientid

        Dim dtAccts = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)

        Return dtAccts

    End Function
    Public Shared Function getModifiedLetterOfReps(ByVal dataClientID As String, ByVal creditorAccountID As String) As DataTable
        Dim sqlMod As New StringBuilder
        sqlMod.Append("select top 1 [FilePath] = '\\' + c.storageserver +'\' + c.storageroot + '\' + c.accountnumber + '\CreditorDocs\' + dr.subfolder")
        sqlMod.Append(",[FileName] = c.accountnumber + '_' + dr.doctypeid + '_' + dr.docid + '_' + datestring + '.pdf' ")
        sqlMod.Append("from tbldocrelation dr with(nolock) inner join tblclient c with(nolock) on c.clientid = dr.clientid ")
        sqlMod.Append("where doctypeid = 'D6003A' and relationtype = 'account' ")
        sqlMod.AppendFormat("and c.clientid = {0} and dr.relationid = {1} ", dataClientID, creditorAccountID)
        sqlMod.Append("order by relateddate desc")
        Return SharedFunctions.AsyncDB.executeDataTableAsync(sqlMod.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Function
End Class
