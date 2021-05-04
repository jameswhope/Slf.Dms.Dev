Module Module1

    Sub Main()

        Dim _documentid As String
        Dim _accountnumber As String
        Dim _date As String

        Dim ClientIdentiers As New List(Of Integer)
        ClientIdentiers = GetClientIdentiers()
        
        For Each clientid As Integer In ClientIdentiers
            Dim clientinfo As DataTable = Nothing
            clientinfo = GetClientInfo(clientid)

            For Each dr As DataRow In clientinfo.Rows
                _documentid = dr("documentid").ToString
                _accountnumber = dr("accountnumber").ToString
                _date = dr("YYYYMMDD").ToString

                Try
                    IO.File.Copy(String.Format("\\dc02\LeadDocuments\{0}.pdf", _documentid), String.Format("\\nas02\ClientStorage\{0}\ClientDocs\{0}_AttorneyTransfer_T1010_{1}.pdf", _accountnumber, _date), True)
                Catch ex As Exception

                End Try

            Next

        Next
        
    End Sub

    Private Function GetClientIdentiers() As List(Of Integer)

        Dim list As New List(Of Integer)

        Dim clientInfo As DataTable = Nothing
        clientInfo = SqlHelper.GetDataTable("stp_attorneytransfer_getclientesigned", CommandType.StoredProcedure)

        For Each dr As DataRow In clientInfo.Rows
            list.Add(CInt(dr("ClientId").ToString))
        Next
        Return list

    End Function

    Private Function GetClientInfo(ByVal clientid As Integer) As DataTable

        Dim clientInfo As DataTable = Nothing
        clientInfo = SqlHelper.GetDataTable("stp_attorneytransfer_getclientesigned", CommandType.StoredProcedure)

        Return clientInfo

    End Function

End Module
