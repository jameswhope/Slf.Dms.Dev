<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_settings_properties_default" title="DMP - Admin Settings - Properties" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <script type="text/javascript">

    function FolderClick(obj)
    {
	    var tr = obj.parentElement;
	    var tbl = tr.parentElement.parentElement;
	    var td = tbl.rows[tr.rowIndex + 1].cells[0];
	    var imgPlus = tr.cells[0].childNodes[0];
	    var imgMinus = tr.cells[0].childNodes[1];

	    if (td.style.display != "none")
	    {
		    td.style.display = "none";
		    imgPlus.style.display = "inline";
		    imgMinus.style.display = "none";
	    }
	    else
	    {
		    td.style.display = "inline";
		    imgPlus.style.display = "none";
		    imgMinus.style.display = "inline";
	    }
    }
    function FileClick(obj, PropertyID)
    {
	    window.navigate("property.aspx?id=" + PropertyID);
    }
    function FolderShow(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#e7e7e7";
	    else
		    td.parentElement.style.backgroundColor = "#f3f3f3";
    }
    function FileShow(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function Record_Print()
    {
        alert("Under Construction");
    }

    </script>

    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;Properties</td>
        </tr>
        <tr>
            <td>
                <table class="pgHeaderTable" onselectstart="return false;" cellspacing="0" cellpadding="0"
                    border="0">
                    <tr>
                        <td class="pgHeaderName">Property</td>
                        <td class="pgHeaderValue" align="right">Current Value</td>
                        <td class="pgHeaderLastModified">Last Modified</td>
                        <td class="pgHeaderLastModifiedBy">By</td>
                    </tr>
                </table>
                <asp:Panel runat="server" ID="pnlProperties" CssClass="propgridHolder"></asp:Panel>
            </td>
        </tr>
        <tr>
            <td valign="top" style="height: 100%">
            </td>
        </tr>
    </table>

</asp:Content>