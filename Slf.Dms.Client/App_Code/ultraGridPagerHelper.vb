Imports Microsoft.VisualBasic
Imports Infragistics.WebUI.UltraWebGrid
Public Class ultraGridPagerHelper

    ''' <summary>
    ''' Handles UltraWebGrid pager on post back event.
    ''' </summary>
    ''' <param name="UltraWebGrid1"></param>
    ''' <param name="dtRowCount"></param>
    ''' <remarks></remarks>
    Public Shared Sub PagerHandlerOnPostBack(ByVal UltraWebGrid1 As UltraWebGrid, ByVal dtRowCount As Integer)
        Dim currentIndex As Integer = UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex
        Dim iPageViewCount As Integer
        If (((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) = 0) Or (((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) > 5) And ((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) < 9))) Then
            iPageViewCount = CType((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize), Integer) Mod 5
        Else
            iPageViewCount = (CType((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize), Integer) Mod 5) + 1
        End If

        If (currentIndex = UltraWebGrid1.DisplayLayout.Pager.PageCount) Then
            Dim iTemp As Integer = UltraWebGrid1.DisplayLayout.Pager.PageCount - iPageViewCount
            Dim pattern As String = "[page:first:First] [page:"
            If (UltraWebGrid1.DisplayLayout.Pager.PageCount <> 5) Then
                If (iPageViewCount <> 0) Then
                    For i As Integer = 1 To iPageViewCount
                        If (i <> iPageViewCount) Then
                            pattern = pattern & (iTemp + i) & "] [page:"
                        Else
                            pattern = pattern & (iTemp + i) & "] [page:last:Last]"
                        End If
                    Next
                Else
                    For i As Integer = 1 To 5
                        If (i <> 5) Then
                            pattern = pattern & (iTemp - 5 + i) & "] [page:"
                        Else
                            pattern = pattern & (iTemp - 5 + i) & "] [page:last:Last]"
                        End If
                    Next
                End If
                UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
            Else
                UltraWebGrid1.DisplayLayout.Pager.Pattern = "[page:first:First] [page:1] [page:2] [page:3] [page:4] [page:5] [page:last:Last] &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
            End If
            Return
        End If

        Dim iPageSize As Integer = UltraWebGrid1.DisplayLayout.Pager.PageCount

        If ((currentIndex Mod 5) = 0) Then
            If (currentIndex = (iPageSize - iPageViewCount)) Then
                Dim pattern As String = "[page:first:First] [page:"
                For i As Integer = 1 To iPageViewCount
                    If (i <> iPageViewCount) Then
                        pattern = pattern & (currentIndex + i) & "] [page:"
                    Else
                        pattern = pattern & (currentIndex + i) & "] [page:last:Last]"
                    End If
                Next
                UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
            Else
                Dim pagerpattern As String = "[page:first:First] "
                If iPageViewCount * 5 > iPageSize Then
                    For i As Integer = currentIndex + 1 To iPageSize
                        pagerpattern += "[page:" & i & "] "
                    Next
                    pagerpattern += "[page:last:Last]"
                Else
                    pagerpattern = "[page:first:First] [page:" & (currentIndex + 1) & "] [page:" & (currentIndex + 2) & "] [page:" & (currentIndex + 3) & "] [page:" & (currentIndex + 4) & "] [page:" & (currentIndex + 5) & "] [page:last:Last]"
                End If
                UltraWebGrid1.DisplayLayout.Pager.Pattern = pagerpattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
            End If
        Else
            If ((currentIndex Mod 5) = 1) Then
                If (currentIndex = ((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize) - iPageViewCount)) Then
                    Dim pattern As String = "[page:first:First] [page:"
                    For i As Integer = iPageViewCount To 1 Step -1
                        If i <> iPageViewCount Then
                            pattern = pattern & (currentIndex + i) & "] [page:"
                        Else
                            pattern = pattern & (currentIndex + i) & "] [page:last:Last]"
                        End If
                    Next
                    UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
                Else
                    If currentIndex <> 1 Then
                        UltraWebGrid1.DisplayLayout.Pager.Pattern = "[page:first:First] [page:" & (currentIndex - 5) & "] [page:" & (currentIndex - 4) & "] [page:" & (currentIndex - 3) & "] [page:" & (currentIndex - 2) & "] [page:" & (currentIndex - 1) & "] [page:last:Last]  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
                    Else
                        If (iPageSize < 5) Then
                            Dim pattern As String = "[page:first:First] [page:"
                            For i As Integer = 1 To iPageViewCount
                                If i <> iPageViewCount Then
                                    pattern = pattern & (i) & "] [page:"
                                Else
                                    pattern = pattern & (i) & "] [page:last:Last]"
                                End If
                            Next
                            UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
                        Else
                            UltraWebGrid1.DisplayLayout.Pager.Pattern = "[page:first:First] [page:1] [page:2] [page:3] [page:4] [page:5] [page:last:Last]  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
                        End If
                    End If
                End If
            End If
        End If
    End Sub

    ''' <summary>
    ''' Handles UltraWebGrid pager on InitializeLayout event.
    ''' </summary>
    ''' <param name="UltraWebGrid1"></param>
    ''' <param name="dtRowCount"></param>
    ''' <remarks></remarks>
    Public Shared Sub PagerHandlerOnInitializeLayout(ByVal UltraWebGrid1 As UltraWebGrid, ByVal dtRowCount As Integer)

        If dtRowCount = 0 Or (((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize) > 0.5) And ((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize) < 1)) Then
            Dim pattern As String = "[page:first:First] [page:1] [page:last:Last]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
            UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern
            Return
        End If

        Dim currentIndex As Integer = UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex
        Dim iPageViewCount As Integer
        If (((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) = 0) Or (((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) > 5) And ((dtRowCount Mod UltraWebGrid1.DisplayLayout.Pager.PageSize) < 9))) Then
            iPageViewCount = CType((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize), Integer)
        Else
            iPageViewCount = (CType((dtRowCount / UltraWebGrid1.DisplayLayout.Pager.PageSize), Integer)) + 1
        End If

        If iPageViewCount < 5 Then
            Dim pattern As String = "[page:first:First] [page:"
            For i As Integer = 1 To iPageViewCount
                If i <> iPageViewCount Then
                    pattern = pattern & (i) & "] [page:"
                Else
                    pattern = pattern & (i) & "] [page:last:Last]"
                End If
            Next
            UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
        Else
            UltraWebGrid1.DisplayLayout.Pager.Pattern = "[page:first:First] [page:1] [page:2] [page:3] [page:4] [page:5] [page:last:Last]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"
        End If
    End Sub

    Public Shared Sub PagerHandler(ByVal UltraWebGrid1 As UltraWebGrid, ByVal rows As Integer)
        Dim currentIndex As Integer = UltraWebGrid1.DisplayLayout.Pager.CurrentPageIndex
        Dim pageCount As Integer = Math.Ceiling(rows / UltraWebGrid1.DisplayLayout.Pager.PageSize)
        Dim pattern As String = ""
        Dim x, y As Integer

        If (currentIndex Mod 10) = 0 Then
            x = currentIndex - 9
        Else
            x = (currentIndex + 1) - (currentIndex Mod 10)
        End If
        y = x + 9

        If y > pageCount Then
            y = pageCount
        End If

        If x > 1 Then
            pattern = "[page:first:<<] [page:" & x - 10 & ":<]"
        End If

        For i As Integer = x To y Step 1
            pattern &= " [page:" & i & "]"
        Next

        If pageCount > 1 AndAlso y < pageCount Then
            pattern &= " [page:" & y + 1 & ":>] [page:last:>>]"
        End If

        pattern &= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page [currentpageindex] of [pagecount]&nbsp;"

        UltraWebGrid1.DisplayLayout.Pager.Pattern = pattern
    End Sub
End Class
