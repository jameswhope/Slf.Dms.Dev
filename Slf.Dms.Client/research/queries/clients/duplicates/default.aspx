<%@ Page Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_clients_duplicates_default" title="DMP - Research - Duplicates" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server"><asp:placeholder id="pnlBody" runat="server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
var tblCriteria = null;
var txtCriteria = null;
var trCriteriaTemplate = null;

function Resolve(span)
{
    var arrAllIDs = new Array();
    var arrSelIDs = new Array();
    
    var arr = span.getElementsByTagName("input");
    for (var i = 0; i < arr.length; i++)
    {
		var obj = arr[i];
        if (obj.type=="checkbox")
        {
			var ClientID = obj.getAttribute("ClientID");
			arrAllIDs.push(ClientID);
			if (obj.checked==true)
				arrSelIDs.push(ClientID);
        }
    }
    
    var IDs = null
    if (arrSelIDs.length >= 2)
		IDs=arrSelIDs.join(",");
    else
		IDs=arrAllIDs.join(",");
		
     var url = '<%= ResolveUrl("~/research/queries/clients/duplicates/action.aspx")%>?ids' + IDs;
     window.dialogArguments = window;
     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
               title: "Duplicates - Resolution",
               dialogArguments: window,
               resizable: false,
               scrollable: false,
               height: 600, width: 800});       
}
function Record_DeleteConfirm(obj)
{
    if (!obj.disabled){
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Clients&m=Are you sure you want to delete all checked clients on this page?  Please ensure that they are all empty duplicates or abandoned.';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Clients",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});
     }                      
}
function Record_UniqueConfirm(obj)
{
    if (!obj.disabled){
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Unique&t=Set Clients as Unique&m=Are you sure you want to set all checked clients as unique in their respective groups?  They will never show up again as duplicates with any other clients in their group.';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Set Clients as Unique",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});
    }
}

function Record_Delete()
{
	<%=Page.ClientScript.GetPostBackEventReference(lnkDelete,Nothing) %>;
}
function Record_Unique()
{
	<%=Page.ClientScript.GetPostBackEventReference(lnkUnique,Nothing) %>;
}
function Criteria_Add()
{
	LoadControls();
	var newRow = trCriteriaTemplate.cloneNode(true);
	var lastRow = tblCriteria.rows[tblCriteria.rows.length-1];
	lastRow.insertAdjacentElement("afterEnd", newRow);
	newRow.style.display="block";
}
function Criteria_Delete(row)
{
	row.parentElement.removeChild(row);
}
function Criteria_Update()
{
	var result="";
	LoadControls();
	
	for(var i = 0; i < tblCriteria.rows.length; i++)
	{
		var r = tblCriteria.rows[i];
		if (r.style.display != "none")
		{
			if (result != "") result += "|";
			result += r.cells[1].childNodes[0].value;
			result += ",";
			result += r.cells[2].childNodes[0].value;
			result += ",";
			result += r.cells[3].childNodes[0].value;
		}
	}
	txtCriteria.value=result;

}
function Requery()
{
	Criteria_Update();
	<%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
}
function LoadControls()
{
	if (tblCriteria == null)
	{
		tblCriteria = document.getElementById("tblCriteria");
		txtCriteria = document.getElementById("<%=txtCriteria.ClientID %>");
		trCriteriaTemplate = document.getElementById("<%=trCriteriaTemplate.ClientID %>");
	}
}
function FixChecks()
{

	LoadControls();
	var tbl = document.getElementById("tblClients");
	var txtSelected = tbl.nextSibling;
    
    var arr = tbl.getElementsByTagName("input");
    
    
    for (var i = 0; i < arr.length; i++)
    {
		var obj = arr[i];
        if (obj.type=="checkbox")
        {
			obj.checked=false;
        }
    }
    txtSelected.value="";
    
    var txtControls = txtSelected.nextSibling;

    if (txtControls.value.length > 0)
    {
        var Controls = txtControls.value.split(",");

        for (c = 0; c < Controls.length; c++)
        {
            document.getElementById(Controls[c]).disabled = txtSelected.value.length == 0;
        }
    }
    
}
</script>
<style>
    thead th{position:relative; top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);}
    td.l{padding-left:8;border-left:solid 1px silver;border-right:none}
    td.lr{padding-right:8;}
    td.r{padding-right:8;border-right:solid 1px silver;border-left:none}
    table tfoot tr td{background-color:white}
</style>
<body scroll="no" onload="FixChecks()">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:225;">
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2" style="padding-bottom:10;"><b>Created</b></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imCreatedDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imCreatedDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Dup Matching Criteria</b></td>
						<td><a href="#" onclick="Criteria_Add(this.parentElement.parentElement)"><img runat="Server" src="~/images/16x16_transaction_add.png" style="border:none" /></a></td>
                    </tr>
                    <tr>
						<td colspan="2">
							<table id="tblCriteria" style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
								<tr id="trCriteriaTemplate" runat="server" style="display:none">
									<td>
										<a href="#" onclick="Criteria_Delete(this.parentElement.parentElement)"><img runat="Server" src="~/images/16x16_delete.png" style="border:none" /></a>
									</td>
									<td><%=GetSelect("Field", "0")%></td>
									<td><%=GetSelect("Operator", "0")%></td>
									<td>
										<input type="text" style="font-family:Tahoma;font-size:11;width:20" onkeypress="AllowOnlyNumbers();" />
									</td>
								</tr>
								<asp:repeater id="rpCriteria" runat="server">
									<itemtemplate>
										<tr>
											<td>
												<a href="#" onclick="Criteria_Delete(this.parentElement.parentElement)"><img runat="Server" src="~/images/16x16_delete.png" style="border:none" /></a>
											</td>
											<td><%#GetSelect("Field", CType(Container.DataItem, Criteria).val1)%></td>
											<td><%#GetSelect("Operator", CType(Container.DataItem, Criteria).val2)%></td>
											<td>
												<input type="text" style="font-family:Tahoma;font-size:11;width:20" value="<%#CType(Container.DataItem, Criteria).val3 %>" onkeypress="AllowOnlyNumbers();"/>
											</td>
										</tr>
									</itemtemplate>
								</asp:repeater>
							</table>
							<input type="hidden" id="txtCriteria" runat="server" />
						</td>
                    </tr>
                </table>
            </div>
        </td>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
            <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td nowrap="true"><asp:LinkButton id="lnkShowFilter" class="gridButtonSel" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true">
												<a class="gridButton" href="#" onclick="Requery();"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Requery</a>
												<asp:LinkButton id="lnkRequery" runat="server"></asp:LinkButton>
											</td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkClear" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton></td>
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            <td nowrap="true"><a id="lnkUniqueConfirm" disabled="true" runat="server" class="gridButton" href="javascript:Record_UniqueConfirm(this);"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/18x18_thumbsup.png" />Unique</a></td>
                                            <td nowrap="true"><a id="lnkDeleteConfirm" disabled="true" runat="server" class="gridButton" href="javascript:Record_DeleteConfirm(this);"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" />Delete</a></td>
                                            <!--<td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:printResults()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                            --><td nowrap="true" style="width:10;">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="height:100%;width:100%">
                        <div style="width:100%;height:100%;overflow:auto;padding: 0 0 0 0">
                            <table class="list" id="tblClients" onmouseover="Grid_RowHover(this,true)" onmouseout="Grid_RowHover(this,false)" style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0">
                                <thead>
                                    <tr>
										<th style="width:32px">&nbsp;</th>
										<th nowrap="true" style="width:22;height:22" align="center"><img runat="server" src="~/images/16x16_checkall2.png" border="0" align="absmiddle"/></th>
                                        <th nowrap="true" style="width:22;height:22" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                        <th align="left">ClientID</th>
                                        <th align="left">First Name</th>
                                        <th align="left">Last Name</th>
                                        <th align="left">SSN</th>
                                        <th align="left">Gen</th>
                                        <th align="left" nowrap="true" style="width:75;">Acct No.</th>
                                        <th align="left">Status</th>
                                        <th align="left">Agency</th>
                                        <th align="left">City</th>
                                        <th align="left">State</th>
                                        <th align="left">Zip</th>
                                        <th align="left">Nt</th>
                                        <th align="left">PC</th>
                                        <th align="left">Ac</th>
                                        <th align="left">Rg</th>
                                        <th align="right">Bal</th>
                                        <th align="center">DE</th>
                                        <th align="center">UW</th>
                                        <th align="left">Created</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:repeater id="rpResults" runat="server"><itemtemplate>
                                    <%#GetRows(CType(Container.DataItem, DupSet)) %>
                                    </itemtemplate></asp:repeater>
                                    <tr><td style="cursor:default;font-size:1px;background-color:rgb(200,200,200);border-bottom:none" colspan="22">&nbsp;</td></tr>
                                </tbody>
                            </table><input type="hidden" runat="server" id="txtSelected" /><input type="hidden" value="<%=lnkDeleteConfirm.ClientID %>,<%=lnkUniqueConfirm.ClientID %>" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table onselectstart="return false;" style="height:25;background-color:rgb(239,236,222);background-image:url(<%= ResolveUrl("~/images/grid_bottom_back.bmp") %>);background-repeat:repeat-x;background-position:left bottom;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tr>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkFirst" runat="server" class="gridButton"><img id="imgFirst" align="absmiddle" runat="server" src="~/images/16x16_selector_first.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkPrev" runat="server" class="gridButton"><img id="imgPrev" align="absmiddle" runat="server" src="~/images/16x16_selector_prev.png" border="0"/></asp:LinkButton></td>
                                <td><img style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td nowrap="true">Page&nbsp;&nbsp;<asp:TextBox AutoPostBack="true" CssClass="entry2" style="width:40;text-align:center;" runat="server" id="txtPageNumber"></asp:TextBox>&nbsp;&nbsp;of&nbsp;<asp:Label ID="lblPageCount" runat="server"></asp:Label></td>
                                <td><img style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkNext" runat="server" class="gridButton"><img id="imgNext" align="absmiddle" runat="server" src="~/images/16x16_selector_next.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkLast" runat="server" class="gridButton"><img id="imgLast" align="absmiddle" runat="server" src="~/images/16x16_selector_last.png" border="0"/></asp:LinkButton></td>
                                <td style="width:100%;">&nbsp;</td>
                                <td style="padding-right:7;" nowrap="true" align="right"><asp:Label runat="server" id="lblResults"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:linkbutton id="lnkDelete" runat="server"></asp:linkbutton>
<asp:linkbutton id="lnkUnique" runat="server"></asp:linkbutton>
</body>
</asp:placeholder></asp:Content>