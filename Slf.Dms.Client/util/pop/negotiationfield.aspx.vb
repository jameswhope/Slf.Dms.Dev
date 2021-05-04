Imports System
Imports System.Data
Imports System.Text
Imports System.Web.Services

Partial Class util_pop_negotiationfield
    Inherits System.Web.UI.Page
    Dim sFieldName As String = ""
    Dim sControlId As String = ""
    Dim sCurrentValue As String = ""
    Dim bsCriteriaBuilder As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()
    Dim sDefaultCount As Integer = 20

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        sFieldName = "" & Request.QueryString("fieldNameValue")
        sControlId = "" & Request.QueryString("ControlID")
        sCurrentValue = "" & Request.QueryString("CurrentValue")
        txtCriteriaInputId.Value = sControlId
        txtFieldName.Value = sFieldName
        txtCompareType.Value = "any"

        If Not Page.IsPostBack Then
            txtSearchval.Attributes("onkeyup") = "Requery();"
            lblHeader.Text = FormatFieldName(sFieldName)
            If (sCurrentValue.Trim() <> "") Then
                If (sCurrentValue.Trim().Length > 250) Then
                    txtcurrent.Text = sCurrentValue.Substring(0, sCurrentValue.Substring(0, 250).LastIndexOf("|") + 1) & "More..."
                Else
                    txtcurrent.Text = sCurrentValue.Trim()
                End If
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dbFieldName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function FormatFieldName(ByVal dbFieldName As String) As String
        If (dbFieldName.IndexOf(" ") <= 0) Then

            Dim arLetters As New ArrayList
            Dim arLetterIndx As New ArrayList
            Dim indx, prevIndx As Integer

            Dim reg As RegularExpressions.Regex
            Dim rgMatch As RegularExpressions.MatchCollection

            rgMatch = reg.Matches(dbFieldName, "[A-Z]")
            For indx = 0 To rgMatch.Count - 1
                arLetters.Add(rgMatch(indx).Value)
                arLetterIndx.Add(rgMatch(indx).Index)
            Next

            For indx = 0 To arLetters.Count - 1
                If ((indx > 0) AndAlso (arLetterIndx(indx) = (arLetterIndx(indx - 1) + 1)) AndAlso (arLetters(indx) = (arLetters(indx - 1)))) Then
                    dbFieldName = dbFieldName.Replace(" " & arLetters(indx), arLetters(indx))
                ElseIf ((indx > 0) AndAlso (arLetterIndx(indx) = (arLetterIndx(indx - 1) + 1))) Then
                    dbFieldName = dbFieldName.Replace(arLetters(indx), "" & arLetters(indx))
                Else
                    dbFieldName = dbFieldName.Replace(arLetters(indx), " " & arLetters(indx))
                End If
            Next

            're-check for last index
            Dim sLastField As String = dbFieldName.Substring(dbFieldName.LastIndexOf(arLetters(arLetters.Count - 1))).Trim()
            If (sLastField <> "" AndAlso sLastField.Length > 1) Then
                dbFieldName = dbFieldName.Replace(sLastField, " " & sLastField)
            End If

        End If

        Return dbFieldName.Trim()

    End Function
End Class