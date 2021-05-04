Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class project_assignment_Default
    Inherits System.Web.UI.Page

#Region "Structures"
    Public Structure NegotiationHeader
        Public Name As String
        Public SQLString As String
        Public SQLAggregation As String
        Public Aggregation As String
        Public GroupedAggregation As String
        Public Format As String
        Public CanGroup As Boolean

        Public Sub New(ByVal _Name As String, ByVal _SQLString As String, ByVal _SQLAggregation As String, ByVal _Aggregation As String, ByVal _GroupedAggregation As String, ByVal _Format As String, ByVal _CanGroup As Boolean)
            Me.Name = _Name
            Me.SQLString = _SQLString
            Me.SQLAggregation = _SQLAggregation
            Me.Aggregation = _Aggregation
            Me.GroupedAggregation = _GroupedAggregation
            Me.Format = _Format
            Me.CanGroup = _CanGroup
        End Sub
    End Structure

    Public Structure NegotiationFilter
        Public EntityID As Integer
        Public Description As String
        Public FilterType As String

        Public Sub New(ByVal _EntityID As Integer, ByVal _Description As String, ByVal _FilterType As String)
            Me.EntityID = _EntityID
            Me.Description = _Description
            Me.FilterType = _FilterType
        End Sub
    End Structure
#End Region

#Region "Variables"
    Private UserID As Integer
    Private IsAdministrator As Boolean
    Private EntityType As String
    Private CurrentEntities As List(Of String)
    Private Trail As BreadTrail
    Public Headers As List(Of NegotiationHeader)
    Public GroupBy As String
    Public GroupByName As String
    Public IsGroupNumeric As Boolean
    Public GlobalHeaders As List(Of NegotiationHeader)
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        IsAdministrator = NegotiationHelper.IsAdministrator(UserID)

        EntityType = "Entity"
        GlobalHeaders = GetTableHeaders()
        GroupByName = GetNameBySQL(GroupBy)

        rptAssignHeaders.DataSource = GlobalHeaders
        rptAssignHeaders.DataBind()

        rptUnassignHeaders.DataSource = GlobalHeaders
        rptUnassignHeaders.DataBind()

        lblAssignHeaderEntity.Text = EntityType

        lblUnassignHeaderEntity.Text = EntityType

        If Not IsPostBack Then
            Dim ids As New List(Of String)

            ids.Add("-1")

            Using cmd As New SqlCommand("stp_CacheView", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    'cmd.CommandType = Data.CommandType.StoredProcedure

                    'cmd.Parameters.Clear()
                    'cmd.Parameters.AddWithValue("view", "vwNegotiationDistributionSource")

                    'cmd.ExecuteNonQuery()

                    cmd.CommandType = Data.CommandType.Text

                    If IsAdministrator Then
                        cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and ParentNegotiationEntityID is null"
                    Else
                        cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and UserID = " & UserID
                    End If

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            ids.Add(reader("NegotiationEntityID"))
                        End While
                    End Using

                    hdnEntityID.Value = String.Join(", ", ids.ToArray())

                    Session("RootEntityID") = hdnEntityID.Value
                End Using
            End Using
        End If
    End Sub

    Protected Sub lnkAssignBy_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAssignBy.Click
        Save()

        GroupBy = hdnAssignBy.Value
        GroupByName = GetNameBySQL(GroupBy)

        GetCriteriaCode()
    End Sub

    Protected Sub lnkUnassignAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnassignAll.Click
        GroupBy = hdnAssignBy.Value
        GroupByName = GetNameBySQL(GroupBy)

        Using cmd As New SqlCommand("DELETE xr FROM tblNegotiationFilters as nf inner join tblNegotiationFilterXref as xr on xr.FilterID = nf.FilterID WHERE not nf.FilterType = 'root'", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

                cmd.CommandText = "DELETE tblNegotiationFilters WHERE not FilterType = 'root'"
                cmd.ExecuteNonQuery()

                cmd.CommandText = "UPDATE tblNegotiationFilters SET Deleted = 0"
                cmd.ExecuteNonQuery()

                cmd.CommandText = "UPDATE tblNegotiationFilterXref SET Deleted = 0"
                cmd.ExecuteNonQuery()
            End Using
        End Using

        GetCriteriaCode()
    End Sub

    Protected Sub lnkDistributeEvenly_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDistributeEvenly.Click
        Save()

        GroupBy = hdnAssignBy.Value
        GroupByName = GetNameBySQL(GroupBy)

        For Each id As String In hdnDistributeFilterID.Value.Split(",")
            DistributeCriteriaEvenly(Integer.Parse(id))
        Next

        GetCriteriaCode()
    End Sub

    Private Sub DistributeCriteriaEvenly(ByVal filterID As Integer)
        Dim final As New Dictionary(Of Integer, List(Of String))
        Dim items As New Dictionary(Of String, Double)
        Dim pods As New Dictionary(Of Integer, Double)
        Dim count As Integer = 0
        Dim total As Double = 0
        Dim average As Double
        Dim queryStr As String
        Dim distBy As String

        Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and NegotiationEntityID in (" & String.Join(", ", Session("CurrentEntities").ToArray()) & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        pods.Add(Integer.Parse(reader("NegotiationEntityID")), 0)
                        final.Add(Integer.Parse(reader("NegotiationEntityID")), New List(Of String))

                        count += 1
                    End While
                End Using

                cmd.CommandText = "SELECT TOP 1 Aggregation + '(' + [SQL] + ')' FROM tblNegotiationAssignment WHERE DistributeBy = 1"

                distBy = cmd.ExecuteScalar()

                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.CommandText = "stp_NegotiationDashboardGetByID"

                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("filterid", filterID)
                cmd.Parameters.AddWithValue("query", "sum(FundsAvailable)")

                total = Double.Parse(cmd.ExecuteScalar())

                If count = 0 Or total = 0 Then
                    Return
                End If

                average = total / count

                queryStr = GroupBy & " as GroupBy, " & distBy & " as DistributeBy"

                cmd.CommandText = "stp_NegotiationDashboardGetByID"

                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("filterid", filterID)
                cmd.Parameters.AddWithValue("query", queryStr)
                cmd.Parameters.AddWithValue("orderby", "DistributeBy desc")
                cmd.Parameters.AddWithValue("groupby", GroupBy)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        items.Add(reader("GroupBy"), reader("DistributeBy"))
                    End While
                End Using

                cmd.CommandType = Data.CommandType.Text

                Dim sda As Double
                Dim used As Boolean
                Dim leastAmount As Double
                Dim leastID As Integer

                For Each group As String In items.Keys
                    sda = items(group)
                    used = False
                    leastID = -1

                    For Each podID As Integer In pods.Keys
                        If pods(podID) < leastAmount Or leastID = -1 Then
                            leastAmount = pods(podID)
                            leastID = podID
                        End If

                        If pods(podID) + sda <= average Then
                            pods(podID) += sda
                            used = True

                            final(podID).Add(GroupBy & " = " & IIf(IsGroupNumeric, group, "'" & group & "'"))

                            Exit For
                        End If
                    Next

                    If Not used Then
                        pods(leastID) += sda
                        final(leastID).Add(GroupBy & " = " & IIf(IsGroupNumeric, group, "'" & group & "'"))
                    End If
                Next

                cmd.CommandText = "UPDATE xr SET xr.Deleted = 1 FROM tblNegotiationFilters as nf inner join tblNegotiationFilterXref as xr on " & _
                    "xr.FilterID = nf.FilterID WHERE xr.EntityID is null and (nf.ParentFilterID = " & filterID & " or (nf.FilterType = 'root' and nf.FilterID = " & filterID & "))"
                cmd.ExecuteNonQuery()

                cmd.CommandText = "UPDATE nf SET nf.Deleted = 1 FROM tblNegotiationFilters as nf inner join tblNegotiationFilterXref as xr on " & _
                    "xr.FilterID = nf.FilterID WHERE xr.EntityID is null and (nf.ParentFilterID = " & filterID & " or (nf.FilterType = 'root' and nf.FilterID = " & filterID & "))"
                cmd.ExecuteNonQuery()

                For Each podID As Integer In final.Keys
                    If final(podID).Count > 0 Then
                        AddCriteria(cmd, podID, filterID, GroupBy, String.Join(" OR ", final(podID).ToArray()))
                    End If
                Next
            End Using
        End Using
    End Sub

    Protected Sub lnkSaveCriteria_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveCriteria.Click
        Save()
        Unlock()
    End Sub

    Private Sub Save()
        If Not String.IsNullOrEmpty(hdnSaveCriteria.Value) Then
            Dim criteriaList() As String = hdnSaveCriteria.Value.Split(";")
            Dim split() As String
            Dim sqlCriteria As List(Of String)
            Dim stems As New List(Of Integer)()

            Using cmd As New SqlCommand("UPDATE nf SET nf.Deleted = null FROM tblNegotiationFilters as nf inner join tblNegotiationFilterXref as xr on xr.FilterID = nf.FilterID WHERE nf.Deleted = 0 and ((not nf.FilterType = 'stem' and (xr.EntityID is null or xr.EntityID in (" & String.Join(", ", Session("CurrentEntities").ToArray()) & "))) or (nf.FilterType = 'stem' and (nf.EntityID in (SELECT ParentNegotiationEntityID FROM tblNegotiationEntity WHERE NegotiationEntityID in (" & String.Join(", ", Session("CurrentEntities").ToArray()) & ")) or xr.EntityID in (" & String.Join(", ", Session("CurrentEntities").ToArray()) & "))))", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "UPDATE tblNegotiationFilterXref SET tblNegotiationFilterXref.Deleted = tblNegotiationFilters.Deleted FROM tblNegotiationFilterXref inner join tblNegotiationFilters on tblNegotiationFilters.FilterID = tblNegotiationFilterXref.FilterID"
                    cmd.ExecuteNonQuery()

                    For Each criteria As String In criteriaList
                        split = criteria.Split("|")
                        sqlCriteria = New List(Of String)

                        For i As Integer = 3 To split.Length - 1
                            sqlCriteria.Add(split(i))
                        Next

                        If split(0) = "unassigned" Then
                            AddUnassignedCriteria(cmd, split(1), split(2), String.Join(" OR ", sqlCriteria.ToArray()))
                        Else
                            AddCriteria(cmd, split(0), split(1), split(2), String.Join(" OR ", sqlCriteria.ToArray()))
                        End If
                    Next

                    cmd.CommandText = "SELECT FilterID FROM tblNegotiationFilters WHERE FilterType = 'stem' and Deleted = 0"

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            stems.Add(Integer.Parse(reader("FilterID")))
                        End While
                    End Using

                    Dim diff As String()
                    Dim hasDiff As Boolean

                    For Each stemID As Integer In stems
                        cmd.CommandType = Data.CommandType.Text

                        hasDiff = False

                        cmd.CommandText = "SELECT nf.FilterClause as StemFilter, nf2.FilterClause as LeafFilter, nfp.FilterClause as ParentClause FROM tblNegotiationFilters as nf right join tblNegotiationFilterXref as xr on xr.EntityID = nf.EntityID left join tblNegotiationFilters as nf2 on nf2.FilterID = xr.FilterID inner join tblNegotiationFilters as nfp on nfp.FilterID = nf2.ParentFilterID WHERE nf.Deleted = 0 and xr.Deleted = 0 and nf2.Deleted = 0 and nf.FilterID = " & stemID

                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                diff = ListDifference(ListDifference(reader("LeafFilter").ToString().Split(New String() {" OR "}, StringSplitOptions.RemoveEmptyEntries), reader("ParentClause").ToString().Split(New String() {" OR "}, StringSplitOptions.RemoveEmptyEntries)), reader("StemFilter").ToString().Split(New String() {" OR "}, StringSplitOptions.RemoveEmptyEntries))
                                hasDiff = True
                            End If
                        End Using

                        If hasDiff AndAlso diff.Length > 0 Then
                            cmd.CommandText = "UPDATE tblNegotiationFilters SET FilterClause = FilterClause + ' OR ' + '" & String.Join(" OR ", diff).Replace("'", "''") & "' WHERE FilterID = " & stemID

                            cmd.ExecuteNonQuery()
                        End If

                        cmd.CommandType = Data.CommandType.StoredProcedure

                        cmd.CommandText = "stp_NegotiationStemFilterUpdate"

                        cmd.Parameters.Clear()
                        cmd.Parameters.AddWithValue("FilterID", stemID)

                        'cmd.ExecuteNonQuery()
                    Next

                    cmd.CommandType = Data.CommandType.Text

                    cmd.CommandText = "UPDATE nf SET nf.Deleted = 1 FROM tblNegotiationFilters as nf WHERE nf.FilterType = 'stem' and nf.Deleted = 0 and nf.EntityID not in (SELECT isnull(EntityID, -1) FROM tblNegotiationFilterXref WHERE not FilterID = nf.FilterID and Deleted = 0)"
                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "UPDATE tblNegotiationFilters set Deleted = 1 WHERE Deleted is null"
                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "UPDATE tblNegotiationFilterXref set Deleted = 1 WHERE Deleted is null"
                    cmd.ExecuteNonQuery()

                    Dim aryEntity() As String = Session("CurrentEntities").ToArray()

                    For i As Integer = 0 To aryEntity.Length - 1
                        cmd.CommandText = "exec stp_UpdateNegotiationXrefTable " & aryEntity(i) & ", 0"
                        cmd.CommandTimeout = 500
                        cmd.ExecuteNonQuery()
                    Next
                End Using
            End Using
        End If
    End Sub

    Private Function ListDifference(ByVal base() As String, ByVal cmp() As String) As String()
        Dim ret As New List(Of String)

        For Each str As String In base
            If Array.IndexOf(cmp, str) = -1 Then
                ret.Add(str)
            End If
        Next

        Return ret.ToArray()
    End Function

    Private Sub AddCriteria(ByVal cmd As SqlCommand, ByVal entityID As Integer, ByVal filterID As Integer, ByVal group As String, ByVal sqlStr As String)
        Dim desc As String
        Dim text As String
        Dim type As String
        Dim eid As Integer
        Dim aggregateClause As String
        Dim curID As Integer
        Dim criteria As New List(Of String)
        Dim spl() As String = Split(sqlStr, " OR ")

        For Each c As String In spl
            criteria.Add(c)
        Next

        cmd.CommandText = "SELECT Description, FilterText, FilterType, AggregateClause, isnull(EntityID, -1) as EntityID FROM tblNegotiationFilters WHERE FilterID = " & filterID

        Using reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                aggregateClause = reader("AggregateClause")
                desc = reader("Description")
                text = reader("FilterText")
                type = reader("FilterType")
                eid = reader("EntityID")

                If type = "root" Then
                    type = "leaf"
                End If
            Else
                Exit Sub
            End If
        End Using

        Dim idx0 As Integer = aggregateClause.IndexOf("and", 0)

        If idx0 >= 0 Then
            Dim idx1 As Integer = aggregateClause.IndexOf(group, idx0)
            Dim idx2 As Integer
            Dim idx2Temp As Integer
            Dim ch As String
            Dim b As Boolean

            While idx1 > -1
                idx2 = aggregateClause.IndexOf(" OR ", idx1)
                idx2Temp = aggregateClause.IndexOf(")", idx1 + group.Length)
                b = False

                If (idx2Temp < idx2 And Not idx2Temp = -1) Or idx2 = -1 Then
                    idx2 = idx2Temp
                    b = True
                End If

                ch = aggregateClause.Substring(idx1, idx2 - idx1)

                If Not criteria.Contains(ch) Then
                    aggregateClause = aggregateClause.Replace(IIf(b, " OR " & ch, ch & " OR "), "")
                End If

                If idx2 >= 0 And idx2 < aggregateClause.Length Then
                    If Not criteria.Contains(ch) And Not b Then
                        idx1 = aggregateClause.IndexOf(group, IIf(b, idx1 - 3, idx1))
                    Else
                        idx1 = aggregateClause.IndexOf(group, idx1 + 1)
                    End If
                Else
                    Exit While
                End If
            End While
        End If

        For Each c As String In spl
            If aggregateClause.Contains(c) Then
                criteria.Remove(c)
            End If
        Next

        If criteria.Count > 0 Then
            Dim idx As Integer

            If idx0 >= 0 Then
                idx = aggregateClause.IndexOf(group, idx0)
            Else
                idx = -1
            End If

            If idx = -1 Then
                aggregateClause = "(" & aggregateClause & ") and (" & String.Join(" OR ", criteria.ToArray()) & ")"
            Else
                aggregateClause = aggregateClause.Substring(0, idx) & String.Join(" OR ", criteria.ToArray()) & " OR " & aggregateClause.Substring(idx)
            End If
        End If

        cmd.CommandText = "INSERT INTO tblNegotiationFilters ([Description], FilterClause, FilterType, FilterText, AggregateClause, " & _
            "ParentFilterID, Created, CreatedBy, Modified, ModifiedBy, GroupBy, EntityID) VALUES ('" & desc.Replace("'", "''") & "', '" & _
            sqlStr.Replace("'", "''") & "', '" & type & "', '" & text.Replace("'", "''") & "', '" & aggregateClause.Replace("'", "''") & "', " & _
            filterID & ", getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & _
            IIf(eid = -1, "null", eid) & ") SELECT scope_identity()"
        'IIf(type = "stem", "null", filterID) & ", getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & _

        curID = cmd.ExecuteScalar()

        cmd.CommandText = "INSERT INTO tblNegotiationFilterXref (FilterID, EntityID, Created, CreatedBy, Modified, ModifiedBy) VALUES (" & _
            curID & ", " & entityID & ", getdate(), " & UserID & ", getdate(), " & UserID & ")"

        cmd.ExecuteNonQuery()

        cmd.CommandText = "SELECT count(*) FROM tblNegotiationFilters as nf inner join tblNegotiationFilterXref as xr on xr.FilterID = nf.FilterID WHERE nf.Deleted is null and xr.Deleted is null and nf.FilterID = " & filterID & " and xr.EntityID = " & entityID

        If Integer.Parse(cmd.ExecuteScalar()) = 0 Then
            Dim stemID As Integer

            cmd.CommandText = "INSERT INTO tblNegotiationFilters ([Description], FilterClause, FilterType, FilterText, AggregateClause, " & _
                "ParentFilterID, Created, CreatedBy, Modified, ModifiedBy, GroupBy, EntityID) VALUES ('" & desc.Replace("'", "''") & _
                "', '" & sqlStr.Replace("'", "''") & "', 'stem', '" & text.Replace("'", "''") & "', '" & aggregateClause.Replace("'", "''") & _
                "', " & filterID & ", getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & entityID & ") SELECT scope_identity()"
            '"', null, getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & entityID & ") SELECT scope_identity()"

            stemID = cmd.ExecuteScalar()

            cmd.CommandText = "INSERT INTO tblNegotiationFilterXref (FilterID, EntityID, Created, CreatedBy, Modified, ModifiedBy) VALUES (" & _
                stemID & ", null, getdate(), " & UserID & ", getdate(), " & UserID & ")"

            cmd.ExecuteNonQuery()
        End If
    End Sub

    Private Sub AddUnassignedCriteria(ByVal cmd As SqlCommand, ByVal filterID As Integer, ByVal group As String, ByVal sqlStr As String)
        Dim desc As String
        Dim text As String
        Dim type As String
        Dim eid As Integer
        Dim aggregateClause As String
        Dim curID As Integer
        Dim criteria As New List(Of String)
        Dim spl() As String = Split(sqlStr, " OR ")

        For Each c As String In spl
            criteria.Add(c)
        Next

        cmd.CommandText = "SELECT Description, FilterText, FilterType, AggregateClause, isnull(EntityID, -1) as EntityID FROM tblNegotiationFilters WHERE FilterID = " & filterID

        Using reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                aggregateClause = reader("AggregateClause")
                desc = reader("Description")
                text = reader("FilterText")
                type = reader("FilterType")
                eid = reader("EntityID")

                If type = "root" Then
                    type = "leaf"
                End If
            Else
                Exit Sub
            End If
        End Using

        Dim idx0 As Integer = aggregateClause.IndexOf("and", 0)

        If idx0 >= 0 Then
            Dim idx1 As Integer = aggregateClause.IndexOf(group, idx0)
            Dim idx2 As Integer
            Dim idx2Temp As Integer
            Dim ch As String
            Dim b As Boolean

            While idx1 > -1
                idx2 = aggregateClause.IndexOf(" OR ", idx1)
                idx2Temp = aggregateClause.IndexOf(")", idx1 + group.Length)
                b = False

                If (idx2Temp < idx2 And Not idx2Temp = -1) Or idx2 = -1 Then
                    idx2 = idx2Temp
                    b = True
                End If

                ch = aggregateClause.Substring(idx1, idx2 - idx1)

                If Not criteria.Contains(ch) Then
                    aggregateClause = aggregateClause.Replace(IIf(b, " OR " & ch, ch & " OR "), "")
                End If

                If idx2 >= 0 And idx2 < aggregateClause.Length Then
                    If Not criteria.Contains(ch) And Not b Then
                        idx1 = aggregateClause.IndexOf(group, IIf(b, idx1 - 3, idx1))
                    Else
                        idx1 = aggregateClause.IndexOf(group, idx1 + 1)
                    End If
                Else
                    Exit While
                End If
            End While
        End If

        For Each c As String In spl
            If aggregateClause.Contains(c) Then
                criteria.Remove(c)
            End If
        Next

        For Each c As String In spl
            If aggregateClause.Contains(c) Then
                criteria.Remove(c)
            End If
        Next

        If criteria.Count > 0 Then
            Dim idx As Integer

            If idx0 >= 0 Then
                idx = aggregateClause.IndexOf(group, idx0)
            Else
                idx = -1
            End If

            If idx = -1 Then
                aggregateClause = "(" & aggregateClause & ") and (" & String.Join(" OR ", criteria.ToArray()) & ")"
            Else
                aggregateClause = aggregateClause.Substring(0, idx) & String.Join(" OR ", criteria.ToArray()) & " OR " & aggregateClause.Substring(idx)
            End If
        End If

        cmd.CommandText = "INSERT INTO tblNegotiationFilters ([Description], FilterClause, FilterType, FilterText, AggregateClause, " & _
            "ParentFilterID, Created, CreatedBy, Modified, ModifiedBy, GroupBy, EntityID) VALUES ('" & desc.Replace("'", "''") & "', '" & _
            sqlStr.Replace("'", "''") & "', '" & type & "', '" & text.Replace("'", "''") & "', '" & aggregateClause.Replace("'", "''") & "', " & _
            filterID & ", getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & _
            IIf(eid = -1, "null", eid) & ") SELECT scope_identity()"
        'IIf(type = "stem", "null", filterID) & ", getdate(), " & UserID & ", getdate(), " & UserID & ", '" & group & "', " & _

        curID = cmd.ExecuteScalar()

        cmd.CommandText = "INSERT INTO tblNegotiationFilterXref (FilterID, EntityID, Created, CreatedBy, Modified, ModifiedBy) VALUES (" & _
            curID & ", null, getdate(), " & UserID & ", getdate(), " & UserID & ")"

        cmd.ExecuteNonQuery()
    End Sub

    Private Function GetTableHeaders() As List(Of NegotiationHeader)
        Dim headers As New List(Of NegotiationHeader)
        Dim groupCol As String = ""
        Dim temp As Object
        Dim dt As String
        Dim button As RadioButton
        Dim count As Integer = 0
        Dim groupByCol As String = ""

        Using cmd As New SqlCommand("SELECT HeaderName, ColumnName, isnull([SQL], HeaderName) as [SQL], isnull(SQLAggregation, '') as SQLAggregation, " & _
            "coalesce(GroupedAggregation, SQLAggregation, '') as GroupedAggregation, Aggregation, isnull(Format, '') as Format, [Default], " & _
            "CanGroup FROM tblNegotiationAssignment ORDER BY [Order], HeaderName", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        headers.Add(New NegotiationHeader(reader("HeaderName"), reader("SQL"), reader("SQLAggregation"), reader("Aggregation"), reader("GroupedAggregation"), reader("Format"), Boolean.Parse(reader("CanGroup"))))

                        groupCol = reader("ColumnName").ToString()

                        If Boolean.Parse(reader("CanGroup")) Then
                            button = New RadioButton()
                            button.ID = "rbnAssign" & count
                            button.GroupName = "Assign"
                            button.Text = reader("HeaderName")
                            button.Attributes.Add("onclick", "javascript:AssignBy('" & reader("SQL") & "', true);")

                            If Boolean.Parse(reader("Default")) Then
                                button.Checked = True
                            Else
                                button.Checked = False
                            End If

                            pnlGroups.Controls.Add(button)
                        End If

                        If Boolean.Parse(reader("Default")) Then
                            GroupBy = reader("SQL").ToString()
                            groupByCol = reader("ColumnName").ToString()
                        End If

                        count += 1
                    End While
                End Using

                If Not String.IsNullOrEmpty(groupByCol) Then
                    cmd.CommandText = "SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'vwNegotiationDistributionSource' and " & _
                        "COLUMN_NAME = '" & groupByCol & "'"

                    temp = cmd.ExecuteScalar()

                    If Not temp Is Nothing Then
                        dt = temp.ToString().ToLower()

                        If dt = "char" Or dt = "varchar" Or dt = "nvarchar" Then
                            IsGroupNumeric = False
                        Else
                            IsGroupNumeric = True
                        End If
                    End If
                End If
            End Using
        End Using

        Return headers
    End Function

    Private Sub LoadEntities(ByRef handler As ListEntityHandler)
        CurrentEntities = New List(Of String)()

        CurrentEntities.Add("-1")

        Using cmd As New SqlCommand("SELECT p.NegotiationEntityID, p.[Name], count(c.NegotiationEntityID) as NumChildren FROM tblNegotiationEntity as p left join tblNegotiationEntity as c on c.ParentNegotiationEntityID = p.NegotiationEntityID and c.Deleted = 0 WHERE p.Deleted = 0 and p.NegotiationEntityID in (" & String.Join(", ", GetFunctionalIDs().ToArray()) & ") GROUP BY p.NegotiationEntityID, p.[Name], p.[Type] ORDER BY p.[Type], p.[Name]", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        handler.AddEntity(Integer.Parse(reader("NegotiationEntityID")), reader("Name"), GroupByName, Integer.Parse(reader("NumChildren")) > 0)

                        CurrentEntities.Add(reader("NegotiationEntityID"))

                        Session("CurrentEntities") = CurrentEntities
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Function GetFunctionalIDs() As List(Of String)
        Dim ids As New List(Of String)()

        ids.Add("-1")

        Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and ParentNegotiationEntityID in (" & hdnEntityID.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ids.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        Return ids
    End Function

    Public Sub GetCriteriaCode()
        Dim filterIDs As New Dictionary(Of Integer, NegotiationFilter)()
        Dim query As New List(Of String)()
        Dim queryStr As String
        Dim handler As New ListEntityHandler()
        Dim container As ListCriteriaContainer
        Dim item As ListCriteriaItem
        Dim addGroupBy As String = ""
        Dim value As String
        Dim aggQuery As New List(Of String)()
        Dim aggQueryStr As String
        Dim entityID As Integer

        Trail = New BreadTrail(Session("RootEntityID"))

        Trail.BuildTo(hdnEntityID.Value)

        Trail.ToControl(pnlTrail)

        For Each header As NegotiationHeader In GlobalHeaders
            If Not header.SQLString = GroupBy Then
                If Not String.IsNullOrEmpty(header.SQLAggregation.Trim()) Then
                    query.Add(header.SQLAggregation & " as [" & header.Name & "]")
                    handler.AddHeader(header.Name, "<" & header.Aggregation & ">:" + header.Format)
                Else
                    addGroupBy &= ", " & header.SQLString
                    query.Add(header.SQLString & " as [" & header.Name & "]")
                    handler.AddHeader(header.Name, "<" & header.GroupedAggregation & ">:" + header.Format)
                End If

                aggQuery.Add("Isnull(" & header.SQLAggregation & ",0) as [" & header.Name & "]")
            Else
                query.Add(header.SQLString & " as [" & header.Name & "]")
                handler.AddHeader(header.Name, "<" & header.GroupedAggregation & ">:" + header.Format)

                aggQuery.Add("count(DISTINCT " & GroupBy & ") as [" & header.Name & "]")
            End If
        Next

        aggQueryStr = String.Join(", ", aggQuery.ToArray())

        LoadEntities(handler)
        handler.AddUnassigned("Master Criteria", GroupByName)
        handler.AddUnassigned("Sub Criteria", GroupByName)

        queryStr = String.Join(", ", query.ToArray())

        For Each i As Integer In handler.entities.Keys
            handler.entities(i).AddAggregateHeaders(LoadAggHeaders(handler.entities(i).entityID, aggQueryStr))
        Next

        Using cmd As New SqlCommand("SELECT nf.FilterID, nf.[Description], nf.FilterType, isnull(xr.EntityID, 0) as EntityID FROM tblNegotiationFilters as nf " & _
            "left join tblNegotiationFilterXref as xr on xr.FilterID = nf.FilterID WHERE nf.Deleted = 0 and xr.Deleted = 0 and ((not nf.FilterType = 'stem' and (xr.EntityID is null or xr.EntityID in (" & String.Join(", ", GetFunctionalIDs().ToArray()) & "))) or (nf.FilterType = 'stem' and (xr.EntityID in (" & String.Join(", ", GetFunctionalIDs().ToArray()) & ") or nf.EntityID in (" & hdnEntityID.Value & "))))", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        filterIDs.Add(Integer.Parse(reader("FilterID")), New NegotiationFilter(Integer.Parse(reader("EntityID")), reader("Description"), reader("FilterType")))
                    End While
                End Using

                cmd.CommandType = Data.CommandType.StoredProcedure

                For Each filterID As Integer In filterIDs.Keys
                    If filterIDs(filterID).EntityID = 0 And filterIDs(filterID).FilterType = "stem" Then
                        entityID = -1
                    Else
                        entityID = filterIDs(filterID).EntityID
                    End If

                    container = handler.GetEntity(entityID).AddContainer(GroupBy, filterID, GetRootFilter(cmd, filterID, "leaf"), filterIDs(filterID).Description)

                    cmd.CommandText = "stp_NegotiationDashboardGetByID"
                    cmd.CommandTimeout = 240
                    cmd.Parameters.Clear()
                    cmd.Parameters.AddWithValue("filterid", filterID)
                    cmd.Parameters.AddWithValue("query", queryStr)
                    cmd.Parameters.AddWithValue("orderby", GroupBy & addGroupBy)
                    cmd.Parameters.AddWithValue("groupby", GroupBy & addGroupBy)

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If reader(GroupByName) Is DBNull.Value Then
                                value = "null"
                            Else
                                value = reader(GroupByName)
                            End If

                            item = container.AddItem(GroupBy & " = " & IIf(IsGroupNumeric, value, "'" & value & "'"))

                            For index As Integer = 0 To reader.FieldCount() - 1
                                item.AddCriteria(reader.GetName(index), GetFormattedStr(reader.GetName(index), reader(index)))
                            Next
                        End While
                    End Using
                Next
            End Using
        End Using

        Dim script As String = "function LoadInterface(handler) {var tableAssigned = document.getElementById('tblAssignments');var tableUnassigned = document.getElementById('tblUnassigned');" & handler.ToString() & "}"

        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "EntityScript", script, True)
    End Sub

    Private Function LoadAggHeaders(ByVal entityID As String, ByVal queryStr As String) As Dictionary(Of String, String)
        Dim aggHeaders As New Dictionary(Of String, String)()
        Dim list As New List(Of String)()

        AddChildFiltersRec(list, entityID)

        If list.Count > 0 Then
            Using cmd As New SqlCommand("stp_NegotiationDashboardGet", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.CommandType = Data.CommandType.StoredProcedure

                    cmd.Parameters.Clear()
                    cmd.Parameters.AddWithValue("ids", String.Join(", ", list.ToArray()))
                    cmd.Parameters.AddWithValue("query", queryStr)
                    cmd.Parameters.AddWithValue("orderby", DBNull.Value)
                    cmd.Parameters.AddWithValue("groupby", DBNull.Value)

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            For index As Integer = 0 To reader.FieldCount() - 1
                                aggHeaders.Add(reader.GetName(index), reader(index))
                            Next
                        End If
                    End Using
                End Using
            End Using
        Else
            For Each header As NegotiationHeader In GlobalHeaders
                aggHeaders.Add(header.Name, GetFormattedStr(header.Name, "0"))
            Next
        End If

        Return aggHeaders
    End Function

    Private Sub AddChildFiltersRec(ByRef list As List(Of String), ByVal entityID As String)
        Dim ids As New List(Of String)

        Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE ParentNegotiationEntityID = " & entityID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ids.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        If ids.Count > 0 Then
            Using cmd As New SqlCommand("SELECT isnull(xr.FilterID, 0) as FilterID FROM tblNegotiationFilterXref as xr inner join tblNegotiationFilters as nf on nf.FilterID = xr.FilterID WHERE xr.Deleted = 0 and nf.Deleted = 0 and nf.FilterType = 'leaf' and xr.EntityID in (" & String.Join(", ", ids.ToArray()) & ")", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If Not list.Contains(reader("FilterID")) Then
                                list.Add(reader("FilterID"))
                            End If
                        End While
                    End Using
                End Using
            End Using

            For Each id As Integer In ids
                AddChildFiltersRec(list, id)
            Next
        End If
    End Sub

    Private Function GetNameBySQL(ByVal sqlStr As String) As String
        For Each temp As NegotiationHeader In GlobalHeaders
            If temp.SQLString = sqlStr Then
                Return temp.Name
            End If
        Next

        Return ""
    End Function

    Private Function GetFormattedStr(ByVal column As String, ByVal value As Object) As String
        Dim format As String = "{0}"
        Dim str As String

        For Each temp As NegotiationHeader In GlobalHeaders
            If temp.Name = column And Not String.IsNullOrEmpty(temp.Format.Trim()) Then
                format = "{0:" & temp.Format & "}"
            End If
        Next

        str = String.Format(format, value)

        Return str
    End Function

    Private Function GetRootFilter(ByVal cmd As SqlCommand, ByVal filterID As Integer, ByVal filterType As String, Optional ByVal groupByStr As String = "") As Integer
        If Not filterType = "root" And Not filterType = "stem" Then
            Dim parentFilterID As Integer
            Dim parentFilterType As String = "leaf"
            Dim parentGroup As String = ""

            Using cmd2 As New SqlCommand("SELECT isnull(ParentFilterID, '') as ParentFilterID, FilterType, isnull(GroupBy, '') as GroupBy FROM " & _
                "tblNegotiationFilters WHERE FilterID = " & filterID, cmd.Connection)
                Using reader As SqlDataReader = cmd2.ExecuteReader()
                    If reader.Read() AndAlso Integer.TryParse(reader("ParentFilterID"), parentFilterID) Then
                        parentFilterType = reader("FilterType")
                        parentGroup = reader("GroupBy")

                        If parentFilterType = "root" Or (groupByStr.Length > 0 And Not groupByStr = parentGroup) Then
                            Return filterID
                        End If
                    End If
                End Using
            End Using

            Return GetRootFilter(cmd, parentFilterID, parentFilterType, parentGroup)
        End If

        Return filterID
    End Function

    Public Sub Unlock()
        If NegotiationHelper.IsLockedBy() = UserID Then
            NegotiationHelper.Unlock(UserID)
        End If
    End Sub
End Class

#Region "Support Classes"
Public Class ListCriteriaItem
    Private parent As ListCriteriaContainer
    Private criteria As Dictionary(Of String, String)
    Private sqlStr As String

    Public Sub New(ByVal _parent As ListCriteriaContainer, ByVal _sqlStr As String)
        Me.parent = _parent
        Me.sqlStr = _sqlStr

        Me.criteria = New Dictionary(Of String, String)()
        Me.criteria.Add("Entity", "")
    End Sub

    Public Sub AddCriteria(ByVal column As String, ByVal value As String)
        criteria.Add(column, value)
    End Sub

    Public Overrides Function ToString() As String
        Dim criteriaList As New List(Of String)

        For Each key As String In criteria.Keys
            criteriaList.Add(key & "|" & criteria(key))
        Next

        Return parent.name & ".addNewItem('" & String.Join(";", criteriaList.ToArray()).Replace("'", "\'").Replace(vbCrLf, " ") & "', '" & sqlStr.Replace("'", "\'").Replace(vbCrLf, " ") & "');"
    End Function
End Class

Public Class ListCriteriaContainer
    Public name As String
    Public children As Dictionary(Of Integer, ListCriteriaItem)
    Private parent As ListEntity
    Private groupBy As String
    Private parentID As Integer
    Private criteriaID As Integer
    Private title As String

    Public Sub New(ByVal _parent As ListEntity, ByVal _groupBy As String, ByVal _parentID As Integer, ByVal _criteriaID As Integer, ByVal _title As String)
        Me.parent = _parent
        Me.groupBy = _groupBy
        Me.parentID = _parentID
        Me.criteriaID = _criteriaID
        Me.title = _title

        Me.name = _parent.name & "_container" & _parent.childNameNum
        Me.children = New Dictionary(Of Integer, ListCriteriaItem)()
    End Sub

    Public Function AddItem(ByVal sqlStr As String) As ListCriteriaItem
        children.Add(children.Count, New ListCriteriaItem(Me, sqlStr))

        Return children(children.Count - 1)
    End Function

    Public Overrides Function ToString() As String
        Dim codeStr As String = "var " & name & " = " & parent.name & ".addNewItem('" & groupBy & "', " & parentID & ", " & criteriaID & ", '" & title.Replace("'", "\'").Replace(vbCrLf, " ") & "');"

        For Each child As ListCriteriaItem In children.Values
            codeStr &= child.ToString()
        Next

        Return codeStr
    End Function
End Class

Public Class ListEntity
    Public name As String
    Public childNameNum As Integer
    Public children As Dictionary(Of Integer, ListCriteriaContainer)
    Private headers As Dictionary(Of String, String)
    Private aggHeaders As Dictionary(Of String, String)
    Private unassigned As Boolean
    Private unassignedName As String
    Public entityID As Integer
    Private sort As String
    Private hasChildren As Boolean

    Public Sub New(ByVal _entityID As Integer, ByVal _headers As Dictionary(Of String, String), ByVal entityName As String, ByVal nameNum As Integer, ByVal _sort As String, ByVal _hasChildren As Boolean, Optional ByVal _unassigned As Boolean = False)
        Me.entityID = _entityID
        Me.headers = CopyHeaders(_headers)
        Me.headers("Entity") = entityName
        Me.name = "entity" & nameNum
        Me.unassigned = _unassigned
        Me.unassignedName = entityName
        Me.sort = _sort
        Me.hasChildren = _hasChildren

        Me.childNameNum = 0
        Me.children = New Dictionary(Of Integer, ListCriteriaContainer)()
    End Sub

    Private Function CopyHeaders(ByVal _headers As Dictionary(Of String, String)) As Dictionary(Of String, String)
        Dim newHeaders As New Dictionary(Of String, String)()

        For Each pair As KeyValuePair(Of String, String) In _headers
            newHeaders.Add(pair.Key, pair.Value)
        Next

        Return newHeaders
    End Function

    Public Sub AddAggregateHeaders(ByVal _aggHeaders As Dictionary(Of String, String))
        aggHeaders = CopyHeaders(_aggHeaders)
    End Sub

    Public Function AddContainer(ByVal groupBy As String, ByVal parentID As Integer, ByVal criteriaID As Integer, ByVal title As String) As ListCriteriaContainer
        children.Add(childNameNum, New ListCriteriaContainer(Me, groupBy, parentID, criteriaID, title))

        childNameNum += 1

        Return children(childNameNum - 1)
    End Function

    Public Overrides Function ToString() As String
        Dim codeStr As String
        Dim headerList As New List(Of String)()
        Dim aggHeaderList As New List(Of String)()

        For Each column As String In headers.Keys
            If unassigned Then
                headerList.Add(column)
            Else
                headerList.Add(column & "|" & headers(column))
            End If
        Next

        For Each column As String In aggHeaders.Keys
            aggHeaderList.Add(column & "|" & aggHeaders(column))
        Next

        codeStr = "var " & name & " = new " & IIf(unassigned, "Custom.UI.ListUnassignedContainer(tableUnassigned, '" & unassignedName & "'", _
            "Custom.UI.ListEntityContainer(" & entityID & ", " & hasChildren.ToString().ToLower() & ", tableAssigned") & ", '" & String.Join(";", headerList.ToArray()).Replace("'", "\'").Replace(vbCrLf, " ") & "', '" & sort & "', '" & String.Join(";", aggHeaderList.ToArray()).Replace("'", "\'").Replace(vbCrLf, " ") & "');"

        For Each child As ListCriteriaContainer In children.Values
            codeStr &= child.ToString()
        Next

        Return codeStr
    End Function
End Class

Public Class ListEntityHandler
    Public entities As Dictionary(Of Integer, ListEntity)
    Private headers As Dictionary(Of String, String)
    Private uassignedCount As Integer

    Public Sub New()
        Me.entities = New Dictionary(Of Integer, ListEntity)()
        Me.headers = New Dictionary(Of String, String)()
        Me.headers.Add("Entity", "")
        Me.uassignedCount = 0
    End Sub

    Public Function AddEntity(ByVal id As Integer, ByVal name As String, ByVal sort As String, ByVal hasChildren As Boolean) As ListEntity
        entities.Add(id, New ListEntity(id, headers, name, entities.Count + 1, sort, hasChildren))

        Return entities(id)
    End Function

    Public Function AddUnassigned(ByVal name As String, ByVal sort As String) As ListEntity
        Dim id As Integer = uassignedCount

        entities.Add(id, New ListEntity(uassignedCount, headers, name, 0, sort, False, True))

        uassignedCount = uassignedCount - 1

        Return entities(id)
    End Function

    Public Sub AddHeader(ByVal column As String, ByVal aggregation As String)
        headers.Add(column, aggregation)
    End Sub

    Public Function GetEntity(ByVal id As Integer) As ListEntity
        Return entities(id)
    End Function

    Public Overrides Function ToString() As String
        Dim codeStr As String = ""

        For Each entity As ListEntity In entities.Values
            codeStr &= entity.ToString() & "handler[handler.length] = " & entity.name & ";"
        Next

        Return codeStr
    End Function
End Class

Public Class BreadCrumb
    Private entityID As String
    Private name As String

    Public Sub New(ByVal _entityID As String, ByVal _name As String)
        Me.entityID = _entityID
        Me.name = _name
    End Sub

    Public Function GetControl() As HtmlAnchor
        Dim a As New HtmlAnchor()

        a.HRef = "javascript:AssignByEntity('" & entityID & "')"
        a.InnerText = name

        Return a
    End Function
End Class

Public Class BreadTrail
    Public crumbs As Dictionary(Of Integer, BreadCrumb)
    Public root As String

    Public Sub New(ByVal _root As String)
        Me.root = _root
        crumbs = New Dictionary(Of Integer, BreadCrumb)()
    End Sub

    Public Sub BuildTo(ByVal entityIDs As String)
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                BuildToRec(cmd, entityIDs)
                AddBreadCrumb(root, "Root")
            End Using
        End Using
    End Sub

    Private Sub BuildToRec(ByVal cmd As SqlCommand, ByVal entityID As String)
        Dim name As String
        Dim parentID As String = ""

        If Integer.TryParse(entityID, Nothing) Then

            cmd.CommandText = "SELECT [Name], isnull(ParentNegotiationEntityID, -1) as ParentNegotiationEntityID FROM tblNegotiationEntity WHERE NegotiationEntityID in (" & entityID & ")"

            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    name = reader("Name")
                    parentID &= ", " & Integer.Parse(reader("ParentNegotiationEntityID"))
                End While
            End Using

            If parentID.Length > 2 Then
                parentID = parentID.Substring(2)
            End If

            If Not ArrayContains(root.Split(","), entityID) And Not entityID = root Then
                AddBreadCrumb(entityID, name)

                BuildToRec(cmd, parentID)
            End If
        End If
    End Sub

    Private Sub AddBreadCrumb(ByVal entityID As String, ByVal name As String)
        crumbs.Add(crumbs.Count, New BreadCrumb(entityID, name))
    End Sub

    Public Sub ToControl(ByRef c As Control)
        Dim img As HtmlImage

        For i As Integer = crumbs.Count - 1 To 0 Step -1
            c.Controls.Add(crumbs(i).GetControl())

            img = New HtmlImage()
            img.Src = "../../../images/arrow_right.png"

            c.Controls.Add(img)
        Next
    End Sub

    Private Function ArrayContains(ByVal arr As String(), ByVal value As String) As Boolean
        For Each i As String In arr
            If i.Trim() = value.Trim() Then
                Return True
            End If
        Next

        Return False
    End Function
End Class
#End Region