Public Class DistributionHelper

#Region "Enumerations"
    Public Enum OrderDirection
        Ascending
        Descending
    End Enum
#End Region

    Public Shared Function DistributeEvenly(ByVal entityIDs As List(Of Integer), ByVal list As Dictionary(Of Integer, Double)) As Dictionary(Of Integer, List(Of Integer))
        Dim entities As New Dictionary(Of Integer, Double)()

        For Each entityID As Integer In entityIDs
            entities.Add(entityID, 0)
        Next

        Return DistributeEvenly(entities, list)
    End Function

    Public Shared Function DistributeEvenly(ByVal entities As Dictionary(Of Integer, Double), ByVal list As Dictionary(Of Integer, Double)) As Dictionary(Of Integer, List(Of Integer))
        Dim final As New Dictionary(Of Integer, List(Of Integer))
        Dim total As Double = 0
        Dim average As Double

        list = OrderDictionary(list, OrderDirection.Descending)

        For Each entityID As Integer In entities.Keys
            final.Add(entityID, New List(Of Integer))
        Next

        For Each value As Double In list.Values
            total += value
        Next

        If entities.Count > 0 And total > 0 Then
            average = total / entities.Count

            Dim used As Boolean
            Dim leastAmount As Double
            Dim leastID As Integer

            For Each itemID As Integer In list.Keys
                used = False
                leastID = -1

                entities = OrderDictionary(entities)

                For Each entityID As Integer In entities.Keys
                    If entities(entityID) < leastAmount Or leastID = -1 Then
                        leastAmount = entities(entityID)
                        leastID = entityID
                    End If

                    If entities(entityID) + list(itemID) <= average Then
                        entities(entityID) += list(itemID)
                        used = True

                        final(entityID).Add(itemID)

                        Exit For
                    End If
                Next

                If Not used Then
                    entities(leastID) += list(itemID)
                    final(leastID).Add(itemID)
                End If
            Next
        End If

        Return final
    End Function

    Private Shared Function OrderDictionary(ByVal dic As Dictionary(Of Integer, Double), Optional ByVal direction As OrderDirection = OrderDirection.Ascending) As Dictionary(Of Integer, Double)
        Dim newDic As New Dictionary(Of Integer, Double)()
        Dim key As Integer
        Dim value As Double

        For i As Integer = 1 To dic.Count
            key = -1
            value = -1

            For Each item As KeyValuePair(Of Integer, Double) In dic
                If ((direction = OrderDirection.Ascending And item.Value < value) Or (direction = OrderDirection.Descending And item.Value > value)) Or value = -1 Then

                    key = item.Key
                    value = item.Value
                End If
            Next

            newDic.Add(key, value)

            dic.Remove(key)
        Next

        Return newDic
    End Function
End Class