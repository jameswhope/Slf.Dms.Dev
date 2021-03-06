<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_applicants_default" title="DMP - Client - Applicants" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
          
    function make_call(phonenumber, clientid) {
        window.top.parent.MakeClientOutboundCall(clientid, phonenumber);    
    }
    
    var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;

    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function RowClick(PersonID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/applicants/applicant.aspx?id=" & ClientID & "&pid=") %>" + PersonID);
    }
    function Record_AddApplicant()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/applicants/applicant.aspx?id=" & ClientID & "&a=a") %>");
    }
    function Record_DeleteConfirm()
    {
        LoadControls();

        if (!lnkDeleteConfirm.disabled)
        {
            var url = '<%= ResolveUrl("~/delete.aspx?t=Applicant&p=selection of applicants") %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Applicant",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 350, width: 400}); 
        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function AddOrDrop(obj, id)
    {
	    if (obj.checked)
	    {
		    AddString(id, ids);
	    }
	    else
	    {
		    RemoveString(id, ids);
	    }

        UpdateSelected();
    }
    function AddString(string, array)
    {
	    array[array.length] = string;
    }
    function RemoveString(string, array)
    {
	    var index = StringExists(string, array);

	    if (index >= 0 && index < array.length)
	    {
		    array.splice(index, 1);
	    }

	    return array;
    }
    function UpdateSelected()
    {
        LoadControls();

        txtSelected.value = ids.join(",");

        if (txtSelected.value.length > 0)
        {
            lnkDeleteConfirm.disabled = false;
        }
        else
        {
            lnkDeleteConfirm.disabled = true;
        }
    }
    function LoadControls()
    {
        if (lnkDeleteConfirm == null)
        {
            lnkDeleteConfirm = document.getElementById("<%= lnkDeleteConfirm.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= txtSelected.ClientID %>");
        }
    }
    function StringExists(string, array)
    {
	    for (i = 0; i < array.length; i++)
	    {
		    if (array[i] == string)
			    return i;
	    }

	    return -1;
    }
    function ClearArray()
    {
	    ids = null;
	    ids = new Array();
    }
    function CheckAll(obj)
    {
        ClearArray();

	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (c = 1; c < table.rows.length; c++)
	    {
		    var off = table.rows[c].cells[0].childNodes(0);
		    var on = table.rows[c].cells[0].childNodes(1);
		    var chk = table.rows[c].cells[0].childNodes(2);

		    off.style.display = "none";
		    on.style.display = "inline";
		    chk.checked = true;
	    }
    }
    function UncheckAll(obj)
    {
	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (u = 1; u < table.rows.length; u++)
	    {
		    var off = table.rows[u].cells[0].childNodes(0);
		    var on = table.rows[u].cells[0].childNodes(1);
		    var chk = table.rows[u].cells[0].childNodes(2);

		    on.style.display = "none";
		    off.style.display = "inline";
		    chk.checked = false;
	    }
    }
     function Record_CancelConfirm()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkCancelClient, Nothing) %>;
    }
    </script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Applicants</td>
        </tr>
        <tr>
            <td valign="top" style="height:100%;">
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color:#f3f3f3;padding: 5 5 5 5;">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="color:rgb(50,112,163);">Applicants</td>
                                    <td align="right"><asp:placeholder id="phDelete" runat="server"><a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="javascript:Record_DeleteConfirm();">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;</asp:placeholder><asp:placeholder id="phSearch" runat="server"><a runat="server" href="~/search.aspx"><img runat="server" src="~/images/16x16_find.png" border="0" align="absmiddle"/></a>&nbsp;&nbsp;|&nbsp;&nbsp;</asp:placeholder><a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" runat="server" id="tdMain">
                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
		                        <tr>
			                        <td align="center" style="width:20;" class="headItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
			                        <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
			                        <!--<td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_checkall2.png" border="0" align="absmiddle"/></td>-->
			                        <td class="headItem" style="width:25;" align="center">3rd</td>
			                        <td class="headItem">Type</td>
			                        <td class="headItem">First Name</td>
			                        <td class="headItem">Last Name</td>
			                        <td class="headItem">(Age) DOB<img style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td>
			                        <td class="headItem">Deceased</td>
			                        <td class="headItem">Address</td>
			                        <td class="headItem" style="width:75;">Contact Type</td>
			                        <td class="headItem" style="width:120;">Number</td>
		                        </tr>
		                        <asp:repeater id="rpApplicants" runat="server">
			                        <itemtemplate>
				                        <tr>
					                        <td style="padding-top:7;width:20;" valign="top" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" style="display:none;" type="checkbox" /></td>
				                            <td style="padding-top:6;width:22;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center">
				                                <img runat="server" src="~/images/16x16_person.png" border="0"/>
				                            </td>
				                            <!--
				                            <td style="padding-top:6;width:22;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center">
				                                <img title="Can Authorize" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconLock")%>" border="0"/>
				                            </td>
				                            -->
				                            <td style="padding-top:6;width:25;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center">
				                                <img title="3rd Party Only" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconThirdParty")%>" border="0"/>
				                            </td>
				                            <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#DataBinder.Eval(Container.DataItem, "Relationship")%>
				                            </td>
				                            <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
				                            </td>
				                            <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#DataBinder.Eval(Container.DataItem, "LastName")%>
				                            </td>
				                            <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#DataBinder.Eval(Container.DataItem, "AgeAndDateOfBirth")%>
				                            </td>
				                             <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#DataBinder.Eval(Container.DataItem, "IsDeceased")%>
				                            </td>
					                        <td style="padding-top:6;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" valign="top">
					                            <%#DataBinder.Eval(Container.DataItem, "Address").ToString.Replace(vbCrLf, "<br>")%>&nbsp;
					                        </td>
					                        <td style="padding-top:5;" onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" colspan="2" valign="top">
					                            <asp:label runat="server" id="lblPhones"></asp:label>
					                        </td>
				                        </tr>
			                        </itemtemplate>
		                        </asp:repeater>
	                        </table>
	                        <asp:panel runat="server" id="pnlNoApplicants" style="text-align:center;font-style:italic;padding: 10 5 5 5;">This client has no applicants</asp:panel>
	                        <input type="hidden" runat="server" id="txtSelected"/>
                        </td>
                        <td valign="top" id="tdAgency" runat="server">
                            <table class="fixedlist" onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
		                        <thead><tr style="font-weight:normal">
			                        <th class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
			                        <th class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_checkall2.png" border="0" align="absmiddle"/></th>
			                        <th class="headItem" align="left">Type</th>
			                        <th class="headItem" align="left">First Name</th>
			                        <th class="headItem" align="left">Last Name</th>
			                        <th class="headItem" align="left">(Age) DOB<img style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></th>
			                        <th class="headItem" align="left">Address</th>
			                        <th class="headItem" style="width:75;" align="left">Contact Type</th>
			                        <th class="headItem" style="width:120;" align="left">Number</th>
		                        </tr></thead><tbody>
		                        <asp:repeater id="rpApplicants_agency" runat="server">
			                        <itemtemplate>
				                        <tr>
					                        <td style="padding-top:6;width:22;" valign="top" align="center">
				                                <img runat="server" src="~/images/16x16_person.png" border="0"/>
				                            </td>
				                            <td style="padding-top:6;width:22;" valign="top" align="center">
				                                <img title="Can Authorize" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconLock")%>" border="0"/>
				                            </td>
				                            <td style="padding-top:6;" valign="top" align="left">
				                                <%#DataBinder.Eval(Container.DataItem, "Relationship")%>
				                            </td>
				                            <td style="padding-top:6;" valign="top" align="left">
				                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
				                            </td>
				                            <td style="padding-top:6;" valign="top" align="left">
				                                <%#DataBinder.Eval(Container.DataItem, "LastName")%>
				                            </td>
				                            <td style="padding-top:6;" valign="top"align="left">
				                                <%#DataBinder.Eval(Container.DataItem, "AgeAndDateOfBirth")%>
				                            </td>
					                        <td style="padding-top:6;" nowrap="true" valign="top" align="left">
					                            <%#DataBinder.Eval(Container.DataItem, "Address").ToString.Replace(vbCrLf, "<br>")%>&nbsp;
					                        </td>
					                        <td style="padding-top:5;" valign="top" align="left">
					                            <asp:label runat="server" id="lblPhones_agency"></asp:label>
					                        </td>
				                        </tr>
			                        </itemtemplate>
		                        </asp:repeater>
	                        </tbody></table>
	                        <asp:panel runat="server" id="pnlNoApplicants_agency" style="text-align:center;font-style:italic;padding: 10 5 5 5;">This client has no applicants</asp:panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td></td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkCancelClient" />
</asp:Content>