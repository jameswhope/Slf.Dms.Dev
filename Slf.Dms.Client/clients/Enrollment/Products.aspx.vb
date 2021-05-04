Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Data.SqlClient

Partial Class Clients_Enrollment_admin_products
    Inherits System.Web.UI.Page

    Private lastCat, lastVendor, lastProduct As String
    Private userID As Integer
    Private vendorList As New Hashtable
    Private catList As New Hashtable
    Private temp As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        userID = DataHelper.Nz_int(Page.User.Identity.Name)
    End Sub

    Private Sub GetTotalSpent()
        lblSpent.Text = String.Format("{0:c0}", SqlHelper.ExecuteScalar(String.Format("select sum(cost) from tblleadapplicant where month(created) = month('{0}') and year(created) = year('{0}') and refund = 0", ddlMonth.SelectedItem.Value), CommandType.Text))
    End Sub

    Protected Sub gvList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvList.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim category As String = CStr(row("category")).Replace(" ", "")
            Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
            Dim imgAdd As Image = TryCast(e.Row.FindControl("imgAdd"), Image)
            Dim imgEffectiveDate As Image = TryCast(e.Row.FindControl("imgEffectiveDate"), Image)
            Dim txtCost As TextBox = TryCast(e.Row.FindControl("txtCost"), TextBox)
            Dim txtCurrentCost As TextBox = TryCast(e.Row.FindControl("txtCurrentCost"), TextBox)

            If catList.Contains(category) Then
                imgTree.Visible = False
                e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", category, e.Row.RowIndex))
                e.Row.Cells(1).Text = "" 'Vendor
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#E3E3E3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                If Not (category = temp) Then
                    e.Row.Style("display") = "none"
                End If

                If Not (Month(CDate(ddlMonth.SelectedItem.Value)) = Month(Now) And Year(CDate(ddlMonth.SelectedItem.Value)) = Year(Now)) Then
                    'Can only set effective dates when working on the current month
                    imgEffectiveDate.Visible = False
                End If

                If Val(txtCost.Text) = 0 Then
                    txtCost.ForeColor = System.Drawing.Color.Red
                End If

                If lastVendor = e.Row.Cells(2).Text Then
                    e.Row.Cells(2).Text = ""
                Else
                    lastVendor = e.Row.Cells(2).Text
                End If

                If lastProduct = e.Row.Cells(3).Text Then
                    e.Row.Cells(3).Text = ""
                Else
                    lastProduct = e.Row.Cells(3).Text
                End If
            Else
                'New category
                catList.Add(category, Nothing)
                imgTree.Attributes.Add("onclick", "toggleDocument('" & category & "','" & e.Row.Parent.ClientID & "');")
                If category = temp Then
                    imgTree.Src = "~/images/tree_minus.bmp"
                End If
                imgEffectiveDate.Visible = False
                txtCost.Visible = False
                txtCurrentCost.Visible = False
                e.Row.Cells(4).Text = "" 'Current Cost
                e.Row.Cells(5).Text = "" 'Lead Cost
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", category))
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If
        End If
    End Sub

    Protected Sub gvSelfGen_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSelfGen.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim vendorcode As String = CStr(row("vendorcode"))
            Dim productCode As String = CStr(row("productcode"))
            Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
            Dim imgEffectiveDate As Image = TryCast(e.Row.FindControl("imgEffectiveDate"), Image)
            Dim imgAdd As Image = TryCast(e.Row.FindControl("imgAdd"), Image)
            Dim txtCost As TextBox = TryCast(e.Row.FindControl("txtCost"), TextBox)
            Dim txtCurrentCost As TextBox = TryCast(e.Row.FindControl("txtCurrentCost"), TextBox)
            Dim bRev As Boolean = CBool(row("revshare"))
            Dim imgRev As HtmlImage = TryCast(e.Row.FindControl("imgRev"), HtmlImage)

            If vendorList.Contains(vendorcode) Then
                imgTree.Visible = False
                e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", vendorcode, e.Row.RowIndex))
                e.Row.Cells(1).Text = ""
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#E3E3E3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                If Not (vendorcode = temp) Then
                    e.Row.Style("display") = "none"
                End If
                If Len(Trim(productCode)) = 0 Then
                    productCode = "(blank)"
                    e.Row.Cells(3).Text = productCode
                End If
                If productCode = lastProduct Then
                    e.Row.Cells(3).Text = ""
                    imgAdd.Visible = False
                    txtCurrentCost.Visible = False
                    e.Row.Cells(4).Text = ""
                Else
                    lastProduct = productCode
                    imgRev.Visible = bRev
                End If
                If Not (Month(CDate(ddlMonth.SelectedItem.Value)) = Month(Now) And Year(CDate(ddlMonth.SelectedItem.Value)) = Year(Now)) Then
                    'Can only set effective dates when working on the current month
                    imgEffectiveDate.Visible = False
                    'txtCurrentCost.Visible = False
                    'e.Row.Cells(3).Text = ""
                End If
                If Val(txtCost.Text) = 0 Then
                    txtCost.ForeColor = System.Drawing.Color.Red
                End If
            Else
                vendorList.Add(vendorcode, Nothing)
                imgTree.Attributes.Add("onclick", "toggleDocument('" & vendorcode & "','" & e.Row.Parent.ClientID & "');")
                If vendorcode = temp Then
                    imgTree.Src = "~/images/tree_minus.bmp"
                End If
                imgEffectiveDate.Visible = False
                imgAdd.Visible = False
                txtCost.Visible = False
                e.Row.Cells(5).Text = "" 'Lead Cost
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", vendorcode))
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If
        End If
    End Sub

    Protected Sub gvList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvList.RowCommand
        If e.CommandName = "Update Cost" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvList.Rows(index)
            Dim ProductID As Integer = CInt(gvList.DataKeys(index).Value)
            Update(row, ProductID)
        End If
    End Sub

    Protected Sub gvSelfGen_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSelfGen.RowCommand
        If e.CommandName = "Update Cost" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvSelfGen.Rows(index)
            Dim ProductID As Integer = CInt(gvSelfGen.DataKeys(index).Value)
            Update(row, ProductID)
        End If
    End Sub

    Private Sub Update(ByVal row As GridViewRow, ByVal ProductID As Integer)
        Dim txtFrom As TextBox = TryCast(row.FindControl("txtFrom"), TextBox)
        Dim txtTo As TextBox = TryCast(row.FindControl("txtTo"), TextBox)
        Dim txtNewCost As TextBox = TryCast(row.FindControl("txtNewCost"), TextBox)
        Dim aFrom() As String = Split(txtFrom.Text, ",")
        Dim aTo() As String = Split(txtTo.Text, ",")
        Dim aCost() As String = Split(txtNewCost.Text, ",")

        'apply cost change to existing leads only
        SqlHelper.ExecuteNonQuery(String.Format("update tblLeadApplicant set cost={0}, lastmodified=getdate(), lastmodifiedbyid={1} where productid = {2} and (created between '{3}' and '{4} 23:59') and (cost <> {0})", aCost(1), userID, ProductID, aFrom(1), aTo(1)), Data.CommandType.Text)

        'get open category/vendor to keep open after postback
        temp = CStr(SqlHelper.ExecuteScalar(String.Format("select case when v.categoryid = 101 then v.vendorcode else c.category end from tblleadvendors v join tblleadproducts p on p.vendorid = v.vendorid and p.productid = {0} join tblleadcategories c on c.categoryid = v.categoryid", ProductID), CommandType.Text))

        gvSelfGen.DataBind()
        gvList.DataBind()
        GetTotalSpent()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Save(gvList)
        Save(gvSelfGen)
        gvList.DataBind()
        gvSelfGen.DataBind()
        GetTotalSpent()
    End Sub

    Private Sub Save(ByVal theList As GridView)
        Dim intProductID As Integer
        Dim txtCost As TextBox
        Dim txtCurrentCost As TextBox
        Dim hdnCost As HiddenField

        For Each row As GridViewRow In theList.Rows
            If row.RowType = DataControlRowType.DataRow Then
                txtCost = CType(row.FindControl("txtCost"), TextBox)
                txtCurrentCost = TryCast(row.FindControl("txtCurrentCost"), TextBox)
                hdnCost = TryCast(row.FindControl("hdnCost"), HiddenField)

                If row.Cells(3).Text = "Default Cost" Then 'Self-gen only
                    SqlHelper.ExecuteNonQuery(String.Format("update tblLeadVendors set defaultcost={0}, lastmodified=getdate(), lastmodifiedby={1} where vendorcode = '{2}' and (defaultcost <> {0})", Val(txtCurrentCost.Text), userID, row.Cells(1).Text), CommandType.Text)
                Else
                    intProductID = CInt(theList.DataKeys(row.RowIndex).Value)

                    'apply cost change to existing leads
                    If Not IsNothing(hdnCost) AndAlso intProductID > 0 Then
                        If Val(txtCost.Text) <> Val(hdnCost.Value) Then
                            SqlHelper.ExecuteNonQuery(String.Format("update tblLeadApplicant set cost={0}, lastmodified=getdate(), lastmodifiedbyid={1} where (productid = {2} or origproductid = {2}) and (created between '{3}' and '{4} 23:59') and cost = {5}", Val(txtCost.Text), userID, intProductID, row.Cells(7).Text, row.Cells(8).Text, Val(hdnCost.Value)), Data.CommandType.Text)
                        End If
                    End If

                    If Not IsNothing(txtCurrentCost) Then
                        If IsNumeric(txtCurrentCost.Text) Then
                            'apply new cost
                            SqlHelper.ExecuteNonQuery(String.Format("update tblLeadProducts set cost={0}, lastmodified=getdate(), lastmodifiedby={1} where productid = {2} and (cost <> {0})", Val(txtCurrentCost.Text), userID, intProductID), Data.CommandType.Text)
                        End If
                    End If
                End If
            End If
        Next
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        Dim params(3) As SqlParameter
        Dim tbl As DataTable

        params(0) = New SqlParameter("@ProductCode", txtCode.Text.Trim)
        params(1) = New SqlParameter("@VendorID", CInt(ddlVendor.SelectedItem.Value))
        params(2) = New SqlParameter("@ProductDesc", txtDesc.Text.Trim)
        params(3) = New SqlParameter("@Cost", Val(txtCost.Text))
        params(4) = New SqlParameter("@Rev", IIf(chkRev.Checked, 1, 0))

        tbl = SqlHelper.GetDataTable("stp_LeadProductIDLookup", CommandType.StoredProcedure, params)
        txtCode.Text = ""
        txtDesc.Text = ""
        txtCost.Text = "0.00"

        gvSelfGen.DataBind()
        gvList.DataBind()
        GetTotalSpent()
    End Sub

    Public Function ShowEffectiveDate(ByVal ProductID As Integer, ByVal EffectiveDate As String, ByVal NewCost As Double) As String
        If IsDate(EffectiveDate) Then
            If CDate(EffectiveDate) <> "1/1/1900" Then
                Return String.Format("<div><font style='color:blue;font-size:9px'>${0} effective {1}</font> <img src='../../images/11x11_delete.png' style='cursor:pointer' onclick='RemoveNewCost({2});' title='Remove'/></div>", NewCost, Format(CDate(EffectiveDate), "M/d/yy"), ProductID)
            End If
        End If
    End Function

    Protected Sub lnkRemoveNewCost_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveNewCost.Click
        SqlHelper.ExecuteNonQuery(String.Format("update tblleadproducts set newcost = null, effectivedate = null, lastmodified = getdate(), lastmodifiedby = {0} where productid = {1}", userID, hdnProductID.Value), CommandType.Text)
        gvList.DataBind()
        gvSelfGen.DataBind()
        GetTotalSpent()
    End Sub

    Protected Sub ddlMonth_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMonth.DataBound
        GetTotalSpent()
    End Sub

    Protected Sub ddlMonth_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMonth.SelectedIndexChanged
        gvSelfGen.DataBind()
        gvList.DataBind()
        GetTotalSpent()
    End Sub
End Class
