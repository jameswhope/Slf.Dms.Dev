Public Class Scenario
    Inherits BusinessServices.Commission

    Private m_dsScenario As DataSet
    Private m_objDAL As Drg.Util.DataHelpers.CommissionHelper
    Private m_format As ScenarioFormat

    Public Property dsScenario() As DataSet
        Get
            Return m_dsScenario
        End Get
        Set(ByVal value As DataSet)
            m_dsScenario = value
        End Set
    End Property

    Public WriteOnly Property format() As ScenarioFormat
        Set(ByVal value As ScenarioFormat)
            m_format = value
        End Set
    End Property

    Public Enum ScenarioFormat As Integer
        PoP = 1 'Percent of Percent
        PoT = 2 'Percent of Total
    End Enum

    'Private Enum editType As Integer
    '    None = 0
    '    Master = 1
    '    Deposit = 2
    'End Enum

    Public Sub New()
        m_objDAL = New Drg.Util.DataHelpers.CommissionHelper
    End Sub

    Private Sub InitScenario()
        m_dsScenario.Tables(0).TableName = "tblTypes"
        m_dsScenario.Tables(1).TableName = "tblRoot"
        m_dsScenario.Tables(2).TableName = "tblFees"
        m_dsScenario.Tables(2).Columns.Add("PoP")

        m_dsScenario.Tables(0).Constraints.Add("Key1", dsScenario.Tables(0).Columns("EntryTypeID"), True)
        'm_dsScenario.Tables(1).Constraints.Add("Key1", dsScenario.Tables(1).Columns("CommFeeID"), True)

        'If Not dsScenario.Relations.Contains("TypeFeesRelation") Then
        '    dsScenario.Relations.Add("TypeFeesRelation", dsScenario.Tables("tblTypes").Columns("EntryTypeID"), dsScenario.Tables("tblFees").Columns("EntryTypeID"))
        '    dsScenario.Relations("TypeFeesRelation").Nested = True
        'End If

        '*Cannot use this relation because CommStructIDs are not unqiue for existing scenarios
        'If Not dsScenario.Relations.Contains("SelfReferenceRelation") Then
        '    dsScenario.Relations.Add("SelfReferenceRelation", dsScenario.Tables("tblFees").Columns("CommStructID"), dsScenario.Tables("tblFees").Columns("ParentCommStructID"))
        '    dsScenario.Relations("SelfReferenceRelation").Nested = True
        'End If
    End Sub

    Public Function LoadScenario(ByVal intCommScenID As Integer, ByVal intCompanyID As Integer) As String
        m_dsScenario = m_objDAL.LoadScenario(intCommScenID, intCompanyID)
        InitScenario()
        RecalcPoPs()

        Return BuildTree()
    End Function

    Public Function LoadScenarios(ByVal intCommScenID As Integer) As String
        Dim html As New System.Text.StringBuilder
        Dim objCompany As New Company
        Dim tbl As DataTable = objCompany.CompanyList

        html.Append("<table><tr>")

        For Each row As DataRow In tbl.Rows
            m_dsScenario = m_objDAL.LoadScenario(intCommScenID, CInt(row("CompanyID")))
            If m_dsScenario.Tables(1).Rows.Count = 1 AndAlso CDate(m_dsScenario.Tables(1).Rows(0)("Created")) > DateAdd(DateInterval.Day, -21, Now) Then
                html.Append("<td valign='top'><u style='background-color:yellow'>" & row("ShortCoName").ToString & " (NEW)</u><br/><div>")
            Else
                html.Append("<td valign='top'><u>" & row("ShortCoName").ToString & "</u><br/><div>")
            End If
            InitScenario()
            RecalcPoPs()
            html.Append(BuildTreeR("", "-1", "", False))
            html.Append("</div></td>")
        Next

        html.Append("</tr></table>")

        Return html.ToString
    End Function

    Public Sub RecalcPoPs()
        Dim rowRoot, rowType As DataRow

        If dsScenario.Tables("tblRoot").Rows.Count > 0 Then
            rowRoot = dsScenario.Tables("tblRoot").Rows(0)

            For Each rowType In dsScenario.Tables("tblTypes").Rows
                CalcPoP(rowRoot("CommStructID").ToString, rowType("EntryTypeID").ToString, True, 1)
            Next
        End If
    End Sub

    Private Sub CalcPoP(ByVal commStructID As String, ByVal EntryTypeID As String, ByVal isFirst As Boolean, ByVal parentPoT As Double)
        Dim childRow As DataRow
        Dim children() As DataRow
        Dim PoT, PoP As Double

        If isFirst Then
            'Check if master account is recieving for this fee type
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and CommStructID = " & commStructID)
        Else
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and ParentCommStructID = " & commStructID)
        End If

        For Each childRow In children
            PoT = Val(childRow("Percent"))
            SumChildrenPoT(EntryTypeID, childRow("CommStructID").ToString, PoT)
            PoP = (PoT / parentPoT)
            childRow("PoP") = PoP

            'Repeat for each child
            CalcPoP(childRow("CommStructID").ToString, EntryTypeID, False, PoT)
        Next

        If children.Length = 0 And isFirst Then
            CalcPoP(commStructID, EntryTypeID, False, parentPoT)
        End If

    End Sub

    Public Sub RecalcPoTs()
        Dim rowRoot, rowType As DataRow

        If dsScenario.Tables("tblRoot").Rows.Count > 0 Then
            rowRoot = dsScenario.Tables("tblRoot").Rows(0)

            For Each rowType In dsScenario.Tables("tblTypes").Rows
                CalcPoT(rowRoot("CommStructID").ToString, rowType("EntryTypeID").ToString, True, 1)
            Next
        End If
    End Sub

    Private Sub CalcPoT(ByVal commStructID As String, ByVal EntryTypeID As String, ByVal isFirst As Boolean, ByVal parentTotalPoT As Double)
        Dim childRow As DataRow
        Dim children() As DataRow
        Dim PoP, PoT, TotalPoT As Double

        If isFirst Then
            'Check if master account is recieving for this fee type
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and CommStructID = " & commStructID)
        Else
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and ParentCommStructID = " & commStructID)
        End If

        For Each childRow In children
            TotalPoT = parentTotalPoT * Val(childRow("PoP"))
            SumChildrenPoP(EntryTypeID, childRow("CommStructID").ToString, PoP)
            If PoP > 0 Then
                PoT = TotalPoT - (PoP * TotalPoT)
            Else
                PoT = TotalPoT
            End If
            childRow("Percent") = PoT

            'Repeat for each child
            CalcPoT(childRow("CommStructID").ToString, EntryTypeID, False, TotalPoT)
        Next

        If children.Length = 0 And isFirst Then
            CalcPoT(commStructID, EntryTypeID, False, parentTotalPoT)
        End If

    End Sub

    Public Sub SumChildrenPoP(ByVal entryTypeID As String, ByVal parentCommStructID As String, ByRef PoP As Double)
        For Each child As DataRow In dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and ParentCommStructID = " & parentCommStructID)
            PoP += Val(child("PoP"))
        Next
    End Sub

    Public Sub SumChildrenPoT(ByVal entryTypeID As String, ByVal parentCommStructID As String, ByRef PoT As Double)
        For Each child As DataRow In dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and ParentCommStructID = " & parentCommStructID)
            PoT += Val(child("Percent"))
            SumChildrenPoT(entryTypeID, child("CommStructID").ToString, PoT)
        Next
    End Sub

    Public Function ScenarioIsValid() As Boolean
        Dim row, type, fee As DataRow
        Dim pct As Double
        Dim invalidPct As Boolean

        row = dsScenario.Tables("tblRoot").Rows(0)
        If CInt(row("CommRecID")) < 1 Or CInt(row("ParentCommRecID")) < 1 Then
            Return False
        End If

        If dsScenario.Tables("tblTypes").Rows.Count = 0 Then
            Return False
        End If

        For Each type In dsScenario.Tables("tblTypes").Rows
            pct = 0
            invalidPct = False
            For Each fee In dsScenario.Tables("tblFees").Select("EntryTypeID = '" & type("EntryTypeID").ToString & "'")
                If fee("IsPercent") = True Then
                    pct += Val(fee("Percent"))
                    If Val(fee("Percent")) < 0.0 Or Val(fee("Percent")) > 100.0 Then
                        invalidPct = True
                    End If
                End If
            Next
            If Math.Round(pct, 4) <> 1.0 Or invalidPct Then
                Return False
            End If
        Next

        Return True
    End Function

    Public Sub AssignDepositMaster(ByVal intCompanyID As Integer)
        Dim tblCommRec As DataTable
        Dim row As DataRow = dsScenario.Tables("tblRoot").Rows(0)

        tblCommRec = MyBase.GetCommRec(intCompanyID, AccountType.Trust)
        row("ParentCommRecID") = tblCommRec.Rows(0)("CommRecID")
        row("ParentCommRec") = tblCommRec.Rows(0)("Abbreviation")

        tblCommRec = MyBase.GetCommRec(intCompanyID, AccountType.GCA)
        row("CommRecID") = tblCommRec.Rows(0)("CommRecID")
        row("CommRec") = tblCommRec.Rows(0)("Abbreviation")
        row.AcceptChanges()
    End Sub

    Public Function BuildTreewEditDeposit() As String
        Return BuildTreeR("", "-1", "") ', editType.Deposit)
    End Function

    Public Function BuildTreewEditMaster() As String
        Return BuildTreeR("", "-1", "") ', editType.Master)
    End Function

    Public Function BuildTreewEdit(ByVal editCommFeeID As String) As String
        Return BuildTreeR("", "-1", editCommFeeID) ', editType.None)
    End Function

    Public Function BuildTreewAdd(ByVal newEntryTypeID As String, ByVal newParentCommStructID As String) As String
        Return BuildTreeR(newEntryTypeID, newParentCommStructID, "") ', editType.None)
    End Function

    Public Function BuildTree() As String
        Return BuildTreeR("", "-1", "") ', editType.None)
    End Function

    Private Function BuildTreeR(ByVal newEntryTypeID As String, ByVal newParentCommStructID As String, ByVal editCommFeeID As String, Optional ByVal allowEdit As Boolean = True) As String ', ByVal edit As editType) As String
        Dim sTree As New System.Text.StringBuilder
        Dim foreColor As String
        Dim rowType, rowFee, rowRoot As DataRow
        Dim pct As Double
        Dim parentFound As Boolean
        'Dim tblCommRecs As DataTable
        'Dim row As DataRow

        If dsScenario.Tables("tblRoot").Rows.Count > 0 Then
            rowRoot = dsScenario.Tables("tblRoot").Rows(0)
        Else 'new scenario
            rowRoot = dsScenario.Tables("tblRoot").NewRow
            rowRoot("CommStructID") = 100
            rowRoot("CommScenID") = -1
            rowRoot("CommRecID") = -1
            rowRoot("ParentCommRecID") = -1
            rowRoot("Order") = 0
            'rowRoot("CompanyID") = -1
            rowRoot("CommRec") = "Master Account"
            rowRoot("ParentCommRec") = "Deposit Account"
            dsScenario.Tables("tblRoot").Rows.Add(rowRoot)
        End If

        With sTree
            .Append("<span style='height: 5'></span>")

            'Deposit account
            .Append("<table style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""0"" cellPadding=""0"" border=""0"">")
            .Append("  <tr>")
            .Append("   <td nowrap=""true"" style='padding: 0 0 0 5'>")
            .Append("       <table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" border='0' cellpadding='0' cellspacing='0' style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;'>")
            .Append("          <tr>")
            .Append("              <td style='width: 20; padding-right: 3px' align='center'><img title='Deposit' align=""absmiddle"" src=""../../images/16x16_trust.png"" border=""0""></td>")
            .Append("              <td style='width: auto; height: 20'>")
            'If edit = editType.Deposit Then
            '    tblCommRecs = m_objDAL.GetCommRecs(CommRecType.Attorney)
            '    .Append("                  <select id='selCommRec' name='selCommRec' runat='server' class='entry2' onchange='selCommRec_onchange(this, 1)'>")
            '    For Each row In tblCommRecs.Rows
            '        If row("CommRecID").ToString = rowRoot("ParentCommRecID").ToString Then
            '            .Append("                  <option value='" & row("CommRecID").ToString & "' selected='selected'>" & row("Abbreviation").ToString & "</option>")
            '        Else
            '            .Append("                  <option value='" & row("CommRecID").ToString & "'>" & row("Abbreviation").ToString & "</option>")
            '        End If
            '    Next
            '    .Append("                  </select>")
            'Else
            .Append("                   " & rowRoot("ParentCommRec").ToString)
            'End If
            .Append("               </td>")
            If allowEdit Then
                .Append("              <td style='width: 20' align='center'></td>")
                .Append("              <td style='width: 20' align='center'></td>") '<img src=""../../images/16x16_file_change.png"" style=""cursor: pointer"" title='Edit Deposit Account' onclick='EditDeposit()' /></td>")
                .Append("              <td style='width: 20' align='center'></td>")
            End If
            .Append("          </tr>")
            .Append("       </table>")

            'Master account
            .Append("       <table style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""0"" cellPadding=""0"" border=""0"">")
            .Append("           <tr>")
            .Append("               <td style='width: 20; padding: 0 0 0 5' valign='top' nowrap='nowrap'><img align=""absmiddle"" src=""../../images/arrow_end.png"" border=""0""></td>")
            .Append("               <td nowrap=""true"" style='padding: 0 0 0 5'>")
            .Append("                   <table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" border='0' cellpadding='0' cellspacing='0' style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;'>")
            .Append("                       <tr>")
            .Append("                           <td style='width: 20; padding-right: 3px' align='center'><img title='Master' align=""absmiddle"" src=""../../images/16x16_accounts.png"" border=""0""></td>")
            .Append("                           <td style='width: auto; height: 20'>")
            'If edit = editType.Master Then
            '    tblCommRecs = m_objDAL.GetCommRecs(CommRecType.Attorney)
            '    .Append("                           <select id='selCommRec' name='selCommRec' runat='server' class='entry2' onchange='selCommRec_onchange(this, 0)'>")
            '    For Each row In tblCommRecs.Rows
            '        If row("CommRecID").ToString = rowRoot("CommRecID").ToString Then
            '            .Append("                           <option value='" & row("CommRecID").ToString & "' selected='selected'>" & row("Abbreviation").ToString & "</option>")
            '        Else
            '            .Append("                           <option value='" & row("CommRecID").ToString & "'>" & row("Abbreviation").ToString & "</option>")
            '        End If
            '    Next
            '    .Append("                           </select>")
            'Else
            .Append("                           " & rowRoot("CommRec").ToString)
            'End If
            .Append("                           </td>")
            If allowEdit Then
                .Append("                           <td style='width: 20' align='center'></td>")
                .Append("                           <td style='width: 20' align='center'></td>") '<img src=""../../images/16x16_file_change.png"" style=""cursor: pointer"" title='Edit Master Account' onclick='EditMaster()' /></td>")
                .Append("                           <td style='width: 20' align='center'></td>")
            End If
            .Append("                       </tr>")
            .Append("                   </table>")
            'Fee types will be nested inside of this table..
        End With

        For Each rowType In dsScenario.Tables("tblTypes").Rows
            pct = 0

            'Add the percentage of payouts
            For Each rowFee In dsScenario.Tables("tblFees").Select("EntryTypeID = '" & rowType("EntryTypeID").ToString & "'")
                If rowFee("IsPercent") = True Then
                    pct += Val(rowFee("Percent"))
                End If
            Next

            'Flag fees that are not paying out correctly
            If Math.Round(pct, 4) = 1.0 Then
                foreColor = "black"
            Else
                foreColor = "red"
            End If

            sTree.Append("<table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""0"" cellPadding=""0"" border=""0"">")
            sTree.Append("  <tr>")
            sTree.Append("   <td style='font-weight: bold; color: " & foreColor & "' nowrap='true'>" & rowType("EntryType").ToString & "</td>")
            sTree.Append("   <td style='font-weight: bold; color: " & foreColor & "; padding-right: 10px' align='right'>" & String.Format("{0:0.00%}", pct) & "</td>")
            If allowEdit Then
                sTree.Append("   <td style='width: 20' align='center'><img src=""../../images/16x16_file_add.png"" onclick=""AddRec(" & rowType("EntryTypeID").ToString & "," & rowRoot("CommStructID") & ")"" style=""cursor: pointer"" title='Add Fee Recipient' /></td>")
                sTree.Append("   <td style='width: 20' align='center'></td>") 'Cannot edit a Fee Type
                sTree.Append("   <td style='width: 20' align='center'><img src=""../../images/16x16_delete.png"" style=""cursor: pointer"" onclick='RemoveFeeType(" & rowType("EntryTypeID").ToString & ")' title=""Remove Fee Type"" /></td>")
            End If
            sTree.Append("  </tr>")
            sTree.Append("</table>")

            BuildTreeRecursively(rowRoot("CommStructID").ToString, rowType("EntryTypeID").ToString, sTree, True, newEntryTypeID, newParentCommStructID, parentFound, editCommFeeID, allowEdit) ', 0)

            If newParentCommStructID = rowRoot("CommStructID").ToString And rowType("EntryTypeID").ToString = newEntryTypeID And Not parentFound Then
                sTree.Append(AddRow)
            End If

            sTree.Append("<span style='height: 10'></span>")
        Next

        'Close deposit and master account tables
        With sTree
            .Append("                   </td>")
            .Append("               </tr>")
            .Append("           </table>")
            .Append("       </td>")
            .Append("   </tr>")
            .Append("</table>")
        End With

        Return sTree.ToString
    End Function

    Private Sub BuildTreeRecursively(ByVal commStructID As String, ByVal EntryTypeID As String, ByRef sTree As System.Text.StringBuilder, ByVal isFirst As Boolean, ByVal newEntryTypeID As String, ByVal newParentCommStructID As String, ByRef parentFound As Boolean, ByVal editCommFeeID As String, ByVal allowEdit As Boolean) ', ByVal parentPoT As Double)
        Dim childRow As DataRow
        Dim children() As DataRow
        Dim isLast As Boolean
        Dim count As Integer
        Dim cur As Integer
        'Dim PoP, PoT As Double
        Dim pct As Double
        Dim pctColor As String

        If isFirst Then
            'Is master account recieving for this fee type?
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and CommStructID = " & commStructID) ' row.GetChildRows("SelfReferenceRelation")
            If children.Length = 0 Then 'no
                children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and ParentCommStructID = " & commStructID) ' row.GetChildRows("SelfReferenceRelation")
            End If
        Else
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & EntryTypeID & " and ParentCommStructID = " & commStructID) ' row.GetChildRows("SelfReferenceRelation")
        End If

        count = children.Length

        For Each childRow In children
            cur += 1
            isLast = (cur = count)

            If m_format = ScenarioFormat.PoP Then
                'If isFirst Then
                '    PoT = Val(childRow("Percent"))
                '    SumChildrenPoT(EntryTypeID, childRow("CommStructID").ToString, PoT)
                '    PoP = PoT
                'Else
                '    PoT = Val(childRow("Percent"))
                '    SumChildrenPoT(EntryTypeID, childRow("CommStructID").ToString, PoT)
                '    PoP = (PoT / parentPoT)
                'End If
                pct = Val(childRow("PoP")) 'PoP
            Else
                pct = Val(childRow("Percent"))
            End If

            If pct < 0.0 Or pct > 1.0 Then
                pctColor = "red"
            Else
                pctColor = "black"
            End If

            sTree.Append("<table style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""0"" cellPadding=""0"" border=""0"">")
            sTree.Append("  <tr>")
            If isLast Then
                If childRow("CommStructID").ToString = newParentCommStructID And childRow("EntryTypeID").ToString = newEntryTypeID Then
                    'User clicked add on a fee type
                    parentFound = True
                    sTree.Append("   <td nowrap=""true"" style='padding: 0 0 0 5; width: 20;' valign='top'><img align=""absmiddle"" src=""../../images/arrow_connector.png"" border=""0""></td>")
                Else
                    sTree.Append("   <td nowrap=""true"" style='padding: 0 0 0 5; width: 20;' valign='top'><img align=""absmiddle"" src=""../../images/arrow_end.png"" border=""0""></td>")
                End If
            Else
                sTree.Append("   <td nowrap=""true"" style='padding: 0 0 0 5; width: 20;' valign='top'><img align=""absmiddle"" src=""../../images/arrow_connector.png"" border=""0""></td>")
            End If

            sTree.Append("   <td nowrap=""true"" style='padding: 0 0 0 5'>")
            If childRow("CommFeeID").ToString = editCommFeeID Then
                sTree.Append(EditRow(childRow("CommRecTypeID").ToString, childRow("CommRecID").ToString, pct.ToString))
            Else
                sTree.Append("      <table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" border='0' cellpadding='0' cellspacing='0' style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;'>")
                sTree.Append("          <tr>")
                Select Case CType(childRow("CommRecTypeID"), Integer)
                    Case CommRecType.Attorney
                        sTree.Append("      <td style='width: 20;'><img title='Attorney' align=""absmiddle"" src=""../../images/16x16_person.png"" border=""0""></td>")
                    Case CommRecType.Agency
                        sTree.Append("      <td style='width: 20;'><img title='Agency' align=""absmiddle"" src=""../../images/16x16_user.png"" border=""0""></td>")
                    Case CommRecType.Processor
                        sTree.Append("      <td style='width: 20;'><img title='Processor' align=""absmiddle"" src=""../../images/16x16_users.png"" border=""0""></td>")
                    Case Else
                        sTree.Append("      <td style='width: 20;'><img title='' align=""absmiddle"" src=""../../images/16x16_usergroup.png"" border=""0""></td>")
                End Select
                sTree.Append("              <td style='width: auto; height: 20'><span title='" & childRow("CommRecFull").ToString & "'>" & childRow("CommRec").ToString & "</span></td>")
                sTree.Append("              <td style='width: 110; height: 20; padding-right: 10px; color: " & pctColor & "' align='right'>" & String.Format("{0:0.00%}", pct) & "</td>")
                If allowEdit Then
                    sTree.Append("              <td style='width: 20' align='center'><img src=""../../images/16x16_file_add.png"" onclick=""AddRec(" & childRow("EntryTypeID").ToString & ", " & childRow("CommStructID").ToString & ")"" style=""cursor: pointer"" title=""Add Fee Recipient"" /></td>")
                    sTree.Append("              <td style='width: 20' align='center'><img src=""../../images/16x16_file_change.png"" style=""cursor: pointer"" title='Edit Fee Recipient' onclick='EditRec(" & childRow("CommFeeID").ToString & ")' /></td>")
                    sTree.Append("              <td style='width: 20' align='center'><img src=""../../images/16x16_delete.png"" style=""cursor: pointer"" title=""Remove Fee Recipient(s)"" onclick='RemoveRec(" & childRow("CommFeeID").ToString & ")' /></td>")
                End If
                sTree.Append("          </tr>")
                sTree.Append("      </table>")
            End If

            'Repeat for each child
            BuildTreeRecursively(childRow("CommStructID").ToString, EntryTypeID, sTree, False, newEntryTypeID, newParentCommStructID, parentFound, editCommFeeID, allowEdit) ', PoT)

            If childRow("CommStructID").ToString = newParentCommStructID And childRow("EntryTypeID").ToString = newEntryTypeID Then
                sTree.Append(AddRow)
            End If

            sTree.Append("   </td>")
            sTree.Append("  </tr>")
            sTree.Append("</table>")
        Next
    End Sub

    Private Function EditRow(ByVal commRecTypeID As String, ByVal commRecID As String, ByVal percent As String) As String
        Dim sTree As New System.Text.StringBuilder
        Dim tblCommRecTypes As DataTable = m_objDAL.CommRecTypes
        Dim tblCommRecs As DataTable = m_objDAL.GetCommRecs(-1)
        Dim row As DataRow

        'row = tblCommRecs.NewRow
        'row("CommRecTypeID") = Commission.CommRecType.Agency
        'row("CommRecID") = -99
        'row("Abbreviation") = "[Agency]"
        'tblCommRecs.Rows.InsertAt(row, 0)
        'tblCommRecs.AcceptChanges()

        With sTree
            .Append("      <table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" border='0' cellpadding='0' cellspacing='0' style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;'>")
            .Append("          <tr>")
            .Append("              <td style='width: auto; height: 20'>")
            .Append("                  <select id='selCommRecType' runat='server' class='entry2' onchange='selCommRecType_onchange(this.form.selCommRec, this)'>")
            .Append("                      <option value='-1'>Select Type</option>")
            For Each row In tblCommRecTypes.Rows
                If row("CommRecTypeID").ToString = commRecTypeID Then
                    .Append("                  <option value='" & row("CommRecTypeID").ToString & "' selected='selected'>" & row("Name").ToString & "</option>")
                Else
                    .Append("                  <option value='" & row("CommRecTypeID").ToString & "'>" & row("Name").ToString & "</option>")
                End If
            Next
            .Append("                  </select>&nbsp;")
            .Append("                  <select id='selCommRec' name='selCommRec' runat='server' class='entry2'>")
            For Each row In tblCommRecs.Rows
                If row("CommRecTypeID").ToString = commRecTypeID And row("CommRecID").ToString = commRecID Then
                    .Append("                  <option value='" & row("CommRecTypeID").ToString & "|" & row("CommRecID").ToString & "' selected='selected'>" & row("Abbreviation").ToString & " (" & row("CommRecID").ToString & ")</option>")
                Else
                    .Append("                  <option value='" & row("CommRecTypeID").ToString & "|" & row("CommRecID").ToString & "'>" & row("Abbreviation").ToString & " (" & row("CommRecID").ToString & ")</option>")
                End If
            Next
            .Append("                  </select>")
            .Append("              </td>")
            .Append("              <td style='width: 65; height: 20; padding-right: 10px' align='right'><input id='txtValue' runat='server' type='text' style='width: 50; text-align: right' class='entry2' onblur='txtValue_onblur(this.form.selCommRec, this)' value='" & String.Format("{0:0.00}", (Val(percent) * 100)) & "' />%</td>")
            .Append("              <td style='width: 20'>&nbsp;</td>")
            .Append("              <td style='width: 20'>&nbsp;</td>")
            .Append("              <td style='width: 20' align='center'><img src=""../../images/16x16_delete.png"" style=""cursor: pointer"" onclick='CancelAddEdit()' title=""Cancel Edit"" /></td>")
            .Append("          </tr>")
            .Append("      </table>")
        End With

        Return sTree.ToString
    End Function

    Private Function AddRow() As String
        Dim sTree As New System.Text.StringBuilder
        Dim tblCommRecTypes As DataTable = m_objDAL.CommRecTypes
        Dim tblCommRecs As DataTable = m_objDAL.GetCommRecs(-1)
        Dim row As DataRow

        'row = tblCommRecs.NewRow
        'row("CommRecTypeID") = Commission.CommRecType.Agency
        'row("CommRecID") = -99
        'row("Abbreviation") = "[Agency]"
        'tblCommRecs.Rows.InsertAt(row, 0)
        'tblCommRecs.AcceptChanges()

        With sTree
            .Append("<table onmouseover=""RowHover(this, true)"" onmouseout=""RowHover(this, false)"" style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""0"" cellPadding=""0"" border=""0"">")
            .Append("  <tr>")
            .Append("   <td nowrap=""true"" style='padding: 0 0 0 5; width: 20;' valign='top'><img align=""absmiddle"" src=""../../images/arrow_end.png"" border=""0""></td>")
            .Append("   <td nowrap=""true"" style='padding: 0 0 0 5'>")
            .Append("      <table border='0' cellpadding='0' cellspacing='0' style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;'>")
            .Append("          <tr>")
            .Append("              <td style='width: auto; height: 20'>")
            .Append("                  <select id='selCommRecType' runat='server' class='entry2' onchange='selCommRecType_onchange(this.form.selCommRec, this)'>")
            .Append("                      <option value='-1'>Select Type</option>")
            For Each row In tblCommRecTypes.Rows
                .Append("                  <option value='" & row("CommRecTypeID").ToString & "'>" & row("Name").ToString & "</option>")
            Next
            .Append("                  </select>&nbsp;")
            .Append("                  <select id='selCommRec' name='selCommRec' runat='server' class='entry2' disabled='disabled'>")
            .Append("                      <option value='-1|-1'>Select Recipient</option>")
            For Each row In tblCommRecs.Rows
                .Append("                  <option value='" & row("CommRecTypeID").ToString & "|" & row("CommRecID").ToString & "'>" & row("Abbreviation").ToString & "</option>")
            Next
            .Append("                  </select>")
            .Append("              </td>")
            .Append("              <td style='width: 65; height: 20; padding-right: 10px' align='right'><input id='txtValue' runat='server' type='text' style='width: 50; text-align: right' class='entry2' onblur='txtValue_onblur(this.form.selCommRec, this)' />%</td>")
            .Append("              <td style='width: 20'>&nbsp;</td>")
            .Append("              <td style='width: 20'>&nbsp;</td>")
            .Append("              <td style='width: 20' align='center'><img src=""../../images/16x16_delete.png"" style=""cursor: pointer"" onclick='CancelAddEdit()' title=""Cancel Add"" /></td>")
            .Append("          </tr>")
            .Append("      </table>")
            .Append("   </td>")
            .Append("  </tr>")
            .Append("</table>")
        End With

        Return sTree.ToString
    End Function

    Public Function SaveScenario(ByVal intCompanyID As Integer, ByVal intAgencyID As Integer, ByVal intUserID As Integer, ByVal startDate As String, ByVal endDate As String, ByVal retFrom As Integer, ByVal retTo As Integer) As Boolean
        Dim intCommScenID As Integer
        Dim intCommStructID As Integer
        Dim intCommRecID As Integer
        Dim origCommStructID As String
        Dim row As DataRow

        intCommScenID = m_objDAL.SaveCommScen(intAgencyID, intCompanyID, startDate, endDate, retFrom, retTo, intUserID)

        If intCommScenID > 0 Then
            'Add deposit/master account
            row = dsScenario.Tables("tblRoot").Rows(0)
            intCommRecID = CInt(row("CommRecID"))
            origCommStructID = row("CommStructID").ToString
            intCommStructID = m_objDAL.SaveCommStruct(intCommScenID, intCommRecID, CInt(row("ParentCommRecID")), 0, intUserID, intCompanyID, -1)

            'Add fee recipients by fee type
            For Each row In dsScenario.Tables("tblTypes").Rows
                RecSaveScenario(intCommScenID, row("EntryTypeID").ToString, intCommStructID, origCommStructID, intCommRecID, True, intUserID, intCompanyID)
            Next
        End If

        Return intCommScenID > 0
    End Function

    Private Sub RecSaveScenario(ByVal intCommScenID As Integer, ByVal entryTypeID As String, ByVal intParentCommStructID As Integer, ByVal origParentCommStructID As String, ByVal intParentCommRecID As Integer, ByVal isFirst As Boolean, ByVal intUserID As Integer, ByVal intCompanyID As Integer)
        Dim children() As DataRow
        Dim child As DataRow
        Dim intCommStructID As Integer
        Dim intOrder As Integer = 1

        If isFirst Then
            'Check if the master account is a fee recipient for this fee type
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and CommStructID = " & origParentCommStructID.ToString & " and ParentCommStructID = -1")
            If children.Length = 0 Then
                children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and ParentCommStructID = " & origParentCommStructID)
            End If
        Else
            children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and ParentCommStructID = " & origParentCommStructID)
        End If

        For Each child In children
            intCommStructID = m_objDAL.SaveCommStruct(intCommScenID, CInt(child("CommRecID")), intParentCommRecID, intOrder, intUserID, intCompanyID, intParentCommStructID)
            m_objDAL.SaveCommFee(intCommStructID, CInt(child("EntryTypeID")), Val(child("Percent")), CInt(child("IsPercent")), intUserID)
            intOrder += 1
            RecSaveScenario(intCommScenID, entryTypeID, intCommStructID, child("CommStructID").ToString, CInt(child("CommRecID")), False, intUserID, intCompanyID)
        Next

    End Sub

End Class