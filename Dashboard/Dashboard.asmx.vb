Imports Drg.Util.DataAccess

Imports System.ComponentModel
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml

<System.Web.Services.WebService(Namespace:="http://www.lexxiom.com/Dashboard/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class Dashboard
    Inherits System.Web.Services.WebService

#Region "Structures"
    Private Structure DashboardItemRaw
        Public DesignXML As String
        Public SQLParamXML As String
        Public ClientX As Integer
        Public ClientY As Integer
        Public ClientWidth As String
        Public ClientHeight As String

        Public Sub New(ByVal _DesignXML As String, ByVal _SQLParamXML As String, ByVal _ClientX As Integer, ByVal _ClientY As Integer, ByVal _ClientWidth As String, ByVal _ClientHeight As String)
            Me.DesignXML = _DesignXML
            Me.SQLParamXML = _SQLParamXML
            Me.ClientX = _ClientX
            Me.ClientY = _ClientY
            Me.ClientWidth = _ClientWidth
            Me.ClientHeight = _ClientHeight
        End Sub
    End Structure

    Public Structure DashboardItem
        Public XML As XmlDocument
        Public ClientX As Integer
        Public ClientY As Integer
        Public ClientWidth As String
        Public ClientHeight As String

        Public Sub New(ByVal _XML As String, ByVal _ClientX As Integer, ByVal _ClientY As Integer, ByVal _ClientWidth As String, ByVal _ClientHeight As String)
            Me.XML = New XmlDocument()
            Me.XML.InnerXml = _XML
            Me.ClientX = _ClientX
            Me.ClientY = _ClientY
            Me.ClientWidth = _ClientWidth
            Me.ClientHeight = _ClientHeight
        End Sub
    End Structure
#End Region

#Region "SQLParamDB"
    Public Class SQLParamColumn
        Inherits Dictionary(Of String, String)

        Public Sub AddColumn(ByVal name As String, ByVal value As String)
            If Me.ContainsKey(name) Then
                Me(name) = value
            Else
                Me.Add(name, value)
            End If
        End Sub
    End Class

    Public Class SQLParamRow
        Inherits Dictionary(Of Integer, SQLParamColumn)

        Public Sub AddRow(ByVal index As Integer, ByVal name As String, ByVal value As String)
            If Not Me.ContainsKey(index) Then
                Me.Add(index, New SQLParamColumn())
            End If

            Me(index).AddColumn(name, value)
        End Sub
    End Class

    Public Class SQLParamDB
        Inherits Dictionary(Of String, SQLParamRow)

        Public Sub AddEntry(ByVal id As String, ByVal index As Integer, ByVal name As String, ByVal value As String)
            If Not Me.ContainsKey(id) Then
                Me.Add(id, New SQLParamRow())
            End If

            Me(id).AddRow(index, name, value)
        End Sub

        Public Function GetEntry(ByVal id As String, ByVal index As Integer, ByVal name As String) As String
            If Me.ContainsKey(id) AndAlso Me(id).ContainsKey(index) AndAlso Me(id)(index).ContainsKey(name) Then
                Return Me(id)(index)(name)
            End If

            Return ""
        End Function
    End Class
#End Region

    <WebMethod()> _
    Public Function GetDashboard(ByVal userID As Integer, ByVal scenario As String, ByVal params As String) As List(Of DashboardItem)
        Dim userParams As Dictionary(Of String, String) = GetUserParams(params)
        Dim items As List(Of DashboardItem) = GetDashboardItems(userID, scenario, userParams)

        Return items
    End Function

    Private Function GetUserParams(ByVal str As String) As Dictionary(Of String, String)
        Dim userParams As New Dictionary(Of String, String)()
        Dim pairs() As String = str.Split(";")
        Dim values() As String

        For Each pair As String In pairs
            values = pair.Split("|")
            userParams.Add(values(0), values(1))
        Next

        Return userParams
    End Function

    Private Function GetDashboardItems(ByVal userID As Integer, ByVal scenario As String, ByVal userParams As Dictionary(Of String, String)) As List(Of DashboardItem)
        Dim itemsRaw As New List(Of DashboardItemRaw)()
        Dim items As New List(Of DashboardItem)()

        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.CommandText = "stp_DashboardGetItems"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add(New SqlParameter("UserID", userID))
                cmd.Parameters.Add(New SqlParameter("Scenario", scenario))

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        itemsRaw.Add(New DashboardItemRaw( _
                            reader("DesignXML"), _
                            reader("SQLParamXML"), _
                            Integer.Parse(reader("ClientX")), _
                            Integer.Parse(reader("ClientY")), _
                            reader("ClientWidth"), _
                            reader("ClientHeight")))
                    End While

                    If Not reader.HasRows() Then
                        items.Add(New DashboardItem("<div>Insufficient Permissions.</div>", 0, 0, "null", "null"))
                    End If
                End Using

                cmd.CommandType = CommandType.Text
                cmd.Parameters.Clear()

                For Each item As DashboardItemRaw In itemsRaw
                    items.Add(New DashboardItem( _
                        ParseDashboardXML(cmd, _
                            ParseUserParams(item.DesignXML, userParams), _
                            ParseUserParams(item.SQLParamXML, userParams)), _
                        item.ClientX, item.ClientY, item.ClientWidth, item.ClientHeight))
                Next
            End Using
        End Using

        Return items
    End Function

    Private Function ParseDashboardXML(ByVal cmd As SqlCommand, ByVal designXML As String, ByVal sqlParamXML As String) As String
        Dim sqlDB As SQLParamDB = ParseSQLXML(cmd, sqlParamXML)
        Dim finalXML As String = designXML
        Dim colName As String
        Dim rowNum As Integer

        Using text As TextReader = New StringReader(designXML)
            Using reader As XmlReader = XmlReader.Create(text)
                While reader.Read()
                    If reader.Name.ToLower() = "sqlparam" Then
                        colName = reader("value")

                        If String.IsNullOrEmpty(colName) Then
                            colName = "default"
                        End If

                        If Not Integer.TryParse(reader("row"), rowNum) Then
                            rowNum = 0
                        End If

                        Try
                            finalXML = finalXML.Replace(GetOuterXML(finalXML, reader("id")), sqlDB.GetEntry(reader("id"), rowNum, colName))
                        Catch e As Exception
                        End Try
                    End If
                End While
            End Using
        End Using

        Return finalXML.Replace("<design>", "").Replace("</design>", "")
    End Function

    Private Function ParseSQLXML(ByVal cmd As SqlCommand, ByVal sqlParamXML As String) As SQLParamDB
        Dim sqlDB As New SQLParamDB()
        Dim colName As String
        Dim rowNum As Integer
        Dim value As String

        Using text As TextReader = New StringReader(sqlParamXML)
            Using reader As XmlReader = XmlReader.Create(text)
                While reader.Read()
                    If reader.Name.ToLower() = "sqlparam" Then
                        cmd.CommandText = reader("value")

                        rowNum = 0

                        Using sqlReader As SqlDataReader = cmd.ExecuteReader()
                            While sqlReader.Read()
                                For i As Integer = 0 To sqlReader.FieldCount() - 1
                                    colName = sqlReader.GetName(i)

                                    If String.IsNullOrEmpty(colName) Then
                                        colName = "default"
                                    End If

                                    If sqlReader(i) Is DBNull.Value Then
                                        value = ""
                                    Else
                                        value = sqlReader(i)
                                    End If

                                    sqlDB.AddEntry(reader("id"), rowNum, colName, value)
                                Next

                                rowNum += 1
                            End While

                            If Not sqlReader.HasRows And Not String.IsNullOrEmpty(reader("isnull")) Then
                                sqlDB.AddEntry(reader("id"), 0, sqlReader.GetName(0), reader("isnull"))
                            End If
                        End Using
                    End If
                End While
            End Using
        End Using

        Return sqlDB
    End Function

    Private Function ParseUserParams(ByVal sqlStr As String, ByVal userParams As Dictionary(Of String, String)) As String
        Dim finalStr As String = sqlStr

        For Each id As String In userParams.Keys
            finalStr = finalStr.Replace("{" & id & "}", userParams(id))
        Next

        Return finalStr
    End Function

    Private Function GetOuterXML(ByVal xml As String, ByVal id As String) As String
        Using text As TextReader = New StringReader(xml)
            Using reader As XmlReader = XmlReader.Create(text)
                While reader.Read()
                    If reader("id") = id Then
                        Return reader.ReadOuterXml()
                    End If
                End While
            End Using
        End Using

        Return ""
    End Function
End Class