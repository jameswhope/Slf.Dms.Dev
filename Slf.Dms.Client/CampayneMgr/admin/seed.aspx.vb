Imports DataManagerHelper
Imports System.Data

Partial Class admin_seed
    Inherits System.Web.UI.Page

    Protected Sub btnSubmit_Click(sender As Object, e As System.EventArgs) Handles btnSubmit.Click
        Dim result As String = ""
        If ddlContract.SelectedIndex > 0 Then
            Try
                Dim dm As DeliveryMethodObject = DeliveryMethodObject.getDeliveryMethod(ddlContract.SelectedItem.Value)
                Dim dpo As New DataPostObject
                Dim tblLookup As DataTable = SqlHelper.GetDataTable(String.Format("stp_ZipCodeLookup '{0}'", txtZip.Text))

                With dpo
                    .FirstName = txtFirst.Text
                    .LastName = txtLast.Text
                    .Email = txtEmail.Text
                    .Phone = txtPhone.Text.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
                    .ZipCode = txtZip.Text
                    If tblLookup.Rows.Count > 0 Then
                        .City = StrConv(tblLookup.Rows(0)("City").ToString, VbStrConv.ProperCase)
                        .StateCode = tblLookup.Rows(0)("State").ToString
                    Else
                        Throw New Exception("Enter a valid zip code")
                    End If
                End With

                Dim requestUriData As String = ""
                'Dim postData As String = BuildPostString(dm, dpo, requestUriData) **switch to new BuildPostString method**
                'If Len(requestUriData) > 0 Then
                '    dm.PostUrl &= requestUriData
                'End If
                'result = String.Format("Test Post Result for {0}<br/><br/>Post URL<br/><br/>{1}?{2}<br/><br/>Response<br/><br/>", dpo.Email, dm.PostUrl, postData)
                'result &= Server.HtmlEncode(PostTestData(-1, postData, dm.PostUrl, False))
            Catch ex As Exception
                result = ex.Message
            Finally
                lblResponse.Text = result
            End Try
        End If
    End Sub

End Class