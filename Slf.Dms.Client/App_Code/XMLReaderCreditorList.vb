Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class XMLReaderCreditorList
    Public Shared Function Read(ByVal XML As String) As List(Of Creditor)
        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.LoadXml(XML.ToString())

        Dim CreditorList As New List(Of Creditor)

        Dim Nodes As XmlNodeList = xmlDoc.SelectNodes("//creditor_contact_information_segments/*")

        For j As Integer = 0 To Nodes.Count - 1
            Dim creditor As New Creditor
            If Nodes.Item(j).Name = "creditor_contact_information" Then
                creditor.CreditorName = Convert.ToString(Nodes.Item(j).ChildNodes.Item(5).InnerText) 'subscriber name
                creditor.MemberCode = Convert.ToString(Nodes.Item(j).ChildNodes.Item(4).InnerText) 'member code
                creditor.MethodOfContact = Convert.ToString(Nodes.Item(j).ChildNodes.Item(6).InnerText) 'method of contact
                Try
                    If Nodes.Item(j + 1).Name = "subscriber_address" Then
                        creditor.Address = Convert.ToString(Nodes.Item(j + 1).ChildNodes.Item(0).InnerText) 'address1
                        creditor.Address2 = Convert.ToString(Nodes.Item(j + 1).ChildNodes.Item(1).InnerText) 'address2
                        creditor.City = Convert.ToString(Nodes.Item(j + 1).ChildNodes.Item(2).InnerText) 'city
                        creditor.State = Convert.ToString(Nodes.Item(j + 1).ChildNodes.Item(3).InnerText) 'state
                        creditor.ZipCode = Convert.ToString(Nodes.Item(j + 1).ChildNodes.Item(4).InnerText) 'zip
                        Try
                            If Nodes.Item(j + 2).Name = "phone_information" Then
                                creditor.PhoneType = Convert.ToString(Nodes.Item(j + 2).ChildNodes.Item(2).InnerText) 'type
                                creditor.AvailabilityCode = Convert.ToString(Nodes.Item(j + 2).ChildNodes.Item(3).InnerText) 'availability
                                creditor.AreaCode = Convert.ToString(Nodes.Item(j + 2).ChildNodes.Item(4).InnerText) 'area
                                creditor.PhoneNumber = Convert.ToString(Nodes.Item(j + 2).ChildNodes.Item(5).InnerText) 'phone
                                creditor.ExtensionNumber = Convert.ToString(Nodes.Item(j + 2).ChildNodes.Item(6).InnerText) 'extension
                            End If
                        Catch e As Exception
                            'do nothing
                        End Try
                    End If
                Catch e As Exception
                    'do nothing
                End Try

                'Dim exists As Boolean = CompareCreditor(creditor.CreditorName, creditor.City, creditor.Address, creditor.Address2, creditor.State, creditor.ZipCode)
                'creditor.Exists = exists.ToString
                'CreditorList.Add(creditor)
                'Dim exists As String = CompareCreditor(creditor.CreditorName, creditor.City, creditor.Address, creditor.Address2, creditor.State, creditor.ZipCode) 'changed to string 9/8/2020
                'creditor.Exists = exists.ToString
                CreditorList.Add(creditor)
            End If
        Next

        Return CreditorList
    End Function


    'Replaced with original creditor compare cholt 9/11/2020
    'Public Shared Function CompareCreditor(ByVal cName As String, Optional ByVal cCity As String = " ", Optional ByVal cStreet As String = " ", Optional ByVal cStreet2 As String = " ", Optional ByVal cAbbrreviation As String = " ", Optional ByVal cZipCode As String = " ") As Boolean
    '    Dim exists As Boolean

    '    Dim dt As DataTable = New DataTable()
    '    Dim creditorName As String = cName
    '    Dim creditorCityName As String = cCity
    '    Dim creditorStreetName As String = cStreet
    '    creditorStreetName = creditorStreetName.ToString.Replace("PO BOX", "P.O. Box").Replace("POB", "P.O. Box")
    '    Dim creditorStreet2Name As String = cStreet2
    '    Dim creditorStateAbbreviation As String = cAbbrreviation
    '    Dim creditorZipCode As String = cZipCode
    '    'Dim queryString As String = "SELECT c.Name, c.Street, c.Street2, c.City, c.ZipCode, s.Abbreviation AS StateAbbr, s.[Name] AS stateName, c.ZipCode FROM tblCreditor c INNER JOIN tblState s ON s.StateID = c.StateID LEFT JOIN tblcreditorphone cp on c.CreditorID = cp.CreditorID WHERE c.Name = @creditorName AND c.City = @creditorCityName AND c.ZipCode = @creditorZipCode AND c.Street = @creditorStreetName AND c.Street2 = @creditorStreet2Name AND s.Abbreviation = @creditorStateAbbreviation"
    '    Dim queryString As String = "SELECT TOP 1 * FROM tblCreditor c INNER JOIN tblState s ON s.StateID = c.StateID LEFT JOIN tblcreditorphone cp on c.CreditorID = cp.CreditorID WHERE c.Name = @creditorName AND c.City = @creditorCityName AND c.ZipCode = @creditorZipCode AND c.Street = @creditorStreetName AND c.Street2 = @creditorStreet2Name AND s.Abbreviation = @creditorStateAbbreviation" 'changed select statement to better match creditors cholt 9/8/2020
    '    Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
    '    'Dim connectionString As String = "server= lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180"

    '    Using connection As SqlConnection = New SqlConnection(connectionString)

    '        Using command As SqlCommand = New SqlCommand(queryString, connection)

    '            Using sda As SqlDataAdapter = New SqlDataAdapter(command)
    '                command.Parameters.AddWithValue("@creditorName", creditorName)
    '                command.Parameters.AddWithValue("@creditorCityName", creditorCityName)
    '                command.Parameters.AddWithValue("@creditorStreetName", creditorStreetName)
    '                command.Parameters.AddWithValue("@creditorStreet2Name", creditorStreet2Name)
    '                command.Parameters.AddWithValue("@creditorStateAbbreviation", creditorStateAbbreviation)
    '                command.Parameters.AddWithValue("@creditorZipCode", creditorZipCode)
    '                connection.Open()
    '                sda.Fill(dt)
    '                connection.Close()
    '                If Not dt Is Nothing Then
    '                    If dt.Rows.Count > 0 Then
    '                        exists = True
    '                    End If
    '                Else
    '                    exists = False
    '                End If
    '            End Using
    '        End Using
    '    End Using
    '    Return exists
    'End Function
End Class
