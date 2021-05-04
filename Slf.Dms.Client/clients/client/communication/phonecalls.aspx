<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="phonecalls.aspx.vb" Inherits="clients_client_communication_phonecalls" Title="DMP - Client - Communication" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Import Namespace="Drg.Util.DataHelpers" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;

    function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
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
           var url = '<%= ResolveUrl("~/delete.aspx?t=Phone Calls&p=selection of Phone Calls") %>';
           window.dialogArguments = window;
           currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Phone Calls",
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

	    for (var c = 1; c < table.rows.length; c++)
	    {
	        var cell = table.rows[c].cells[0];
	        if (cell.getAttribute("isCheck") == "true")
	        {
		        var off = table.rows[c].cells[0].childNodes(0);
		        var on = table.rows[c].cells[0].childNodes(1);
		        var chk = table.rows[c].cells[0].childNodes(2);

		        off.style.display = "none";
		        on.style.display = "inline";
		        chk.checked = true;
		    }
	    }
    }
    function UncheckAll(obj)
    {
	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (u = 1; u < table.rows.length; u++)
	    {
	    	var cell = table.rows[u].cells[0];
	        if (cell.getAttribute("isCheck") == "true")
	        {
		        var off = cell.childNodes(0);
		        var on = cell.childNodes(1);
		        var chk = cell.childNodes(2);

		        on.style.display = "none";
		        off.style.display = "inline";
		        chk.checked = false;
		    }
	    }
    }
    </script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    
    
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients/">Clients</a>&nbsp;>&nbsp;<a
                    id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Communication</td>
        </tr>
        
        <tr>
            <td style="height:100%" valign="top">
                <asi:TabStrip runat="server" id="tsMain"></asi:TabStrip>
                <div id="dvPanel0" runat="server">
                    <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding:5 7 5 7;color:rgb(50,112,163);">Phone Calls</td>
                            <td style="padding-right:7;" align="right"></td>
                            <td align="right">
                            <a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="javascript:Record_DeleteConfirm();">
                                Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A1" runat="server" href="~/search.aspx"><img id="Img1"
                                    runat="server" src="~/images/16x16_find.png" border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A2"
                                        runat="server" href="javascript:window.print();"><img id="Img2" runat="server" src="~/images/16x16_print.png"
                                            border="0" align="absmiddle" /></a></td>
                        </tr>
                    </table>
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                        <asp:placeholder id="phCommunication_default" runat="server">
                            <tr>
                                <td valign="top" hover="false">
                                    <div style="overflow:auto;height:100%">
                                        <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)" class="list" onselectstart="return false;" id="tblNotes" style="font-size:11px;font-family:tahoma;height:100%" cellspacing="0" cellpadding="3" width="100%" border="0">
                                            <colgroup>
                                                <col width="22px" align="center" />
                                                <col width="22px" align="center" />
                                                <col width="22px" align="center" />
                                                <col align="left" />
                                                <col align="left" />
                                                <col align="left" />
                                                <col align="center" />
                                                <col align="left" />
                                            </colgroup>
                                            <thead>
                                                <tr style="height:20px">
                                                    <th align="center" style="width: 20;" class="headItem">
                                                        <img id="Img8" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);"
                                                            style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                            border="0" /><img id="Img9" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);"
                                                                style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                                                border="0" /></th>
                                                    <th class="headItem" style="width: 25;" align="center">
                                                        <img id="Img3" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                    </th>
                                                    <th class="headItem" style="width:20px;" runat="server"><img src="~/images/11x16_paperclip.png" border="0" alt="" runat="server" /></th>
                                                    <th onclick="Sort(this)" runat="server" id="tdUser" class="headItem" style="cursor:pointer">Internal</th>
                                                    <th onclick="Sort(this)" runat="server" id="tdUserType" class="headItem" style="cursor:pointer">User Type</th>
                                                    <th onclick="Sort(this)" runat="server" id="tdPerson" class="headItem" style="cursor:pointer">External</th>
                                                    <th onclick="Sort(this)" runat="server" id="tdDate" class="headItem" style="cursor:pointer">Call Date</th>
                                                    <th onclick="Sort(this)" runat="server" id="tdDuration" class="headItem" style="cursor:pointer">Duration</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <asp:repeater id="rpPhoneCalls" runat="server">
						                            <itemtemplate>
						                                <a style="background-color:<%#CType(Container.DataItem, GridPhoneCall).Color%>" href="<%# ResolveUrl("~/clients/client/communication/phonecall.aspx?id=") + DataClientID.tostring() + "&pcid=" + Ctype(Container.DataItem, GridPhoneCall).PhoneCallID.ToString()  %>">
							                                <tr style="color:<%#CType(Container.DataItem, GridPhoneCall).TextColor%>;background-color:<%#CType(Container.DataItem, GridPhoneCall).Color%>">
							                                    <td isCheck="true" class="noBorder" style="padding-top:7;width:20;" valign="top" align="center" class="listItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#ctype(Container.DataItem, GridPhoneCall).PhoneCallID%>);" style="display:none;" type="checkbox" /></td>
						                                        <td class="noBorder"><img src="<%#ResolveURL("~/images/16x16_call" + iif(ctype(container.dataitem,gridphonecall).direction,"out","in") + ".png")%>" border="0"/></td>
						                                        <td class="noBorder" nowrap="true" style="width:20px;"><%#GetAttachmentText(CType(Container.DataItem, GridPhoneCall).PhoneCallID, "phonecall")%></td>
				                                                <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, GridPhoneCall).UserName%></td>
				                                                <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, GridPhoneCall).UserType%></td>
				                                                <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, GridPhoneCall).PersonName%></td>
				                                                <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, GridPhoneCall).CallDate.ToString("MM/dd/yyyy")%></td>
				                                                <td class="noBorder">
				                                                    <%#CType(Container.DataItem, GridPhoneCall).Duration%>&nbsp;&nbsp;(<%#CType(Container.DataItem, GridPhoneCall).CallDate.ToString("hh:mm tt")%><img style="margin:0 5 0 5" border="0" align="absmiddle" src="<%=ResolveURL("~/images/16x16_arrowright (thin gray).png")%>" /><%#CType(Container.DataItem, GridPhoneCall).CallDateEnd.ToString("hh:mm tt")%>)
                                                                </td>
							                                </tr>
							                                <tr style="color:<%#CType(Container.DataItem, GridPhoneCall).BodyColor%>;background-color:<%#CType(Container.DataItem, GridPhoneCall).Color%>">
							                                    <td colspan="3">&nbsp;</td>
							                                    <td colspan="5" align="left" >
							                                        <b><%#MakeSnippet(CType(Container.DataItem, GridPhoneCall).Subject, 250)%>:</b>&nbsp;<%#MakeSnippet(CType(Container.DataItem, GridPhoneCall).Body, 250)%>
							                                    </td>
							                                </tr>
							                            </a>
						                            </itemtemplate>
					                            </asp:repeater>
					                            <a><tr><td></td></tr></a>
							                </tbody>
                                        </table>
                                        <asp:panel runat="server" id="pnlNoNotes" style="text-align: center; font-style: italic;
                                            padding: 10 5 5 5;">This client has no phone calls</asp:panel>
                                        <input type="hidden" runat="server" id="txtSelected" />
                                    </div>
                                </td>
                            </tr>
                        </asp:placeholder>
                    </table>
                </div>
                <div id="dvPanel1" runat="server"></div>
                <div id="dvPanel2" runat="server"></div>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:linkbutton runat="server" id="lnkDelete"></asp:linkbutton>
    <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
    <input type="hidden" runat="server" id="txtSortField" />
</asp:Content>
