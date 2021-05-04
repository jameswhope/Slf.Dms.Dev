<%@ Control Language="VB" AutoEventWireup="false" CodeFile="generic.ascx.vb" Inherits="tasks_workflows_generic" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Reference Page="~/tasks/task/resolve.aspx" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
<style type="text/css">
    .style2
    {
        width: 10%;
    }
    .box
    {
        border: 1px solid #CCCCCC;
    }
</style>
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\xptabstrip.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\rgbcolor.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">

//for checkall and uncheckall functionality
   var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;
    
 function ClearArray()
    {
	    ids = null;
	    ids = new Array();
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
    function CheckAll(obj)
    {
        ClearArray();

	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (c = 1; c <= table.rows.length-1; c++)
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

	    for (u = 1; u <= table.rows.length-1; u++)
	    {
	   
		    var off = table.rows[u].cells[0].childNodes(0);
		    var on = table.rows[u].cells[0].childNodes(1);
		    var chk = table.rows[u].cells[0].childNodes(2);

		    on.style.display = "none";
		    off.style.display = "inline";
		    chk.checked = false;
	    }
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
        LoadControlsD1();
 
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
    function LoadControlsD1()
    {

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= hdnCurrentDoc.ClientID %>");
        }
    }
//end


    var txtAcquired = null;
    var txtAccountNumber = null;
    var txtOriginalAmount = null;
    var txtCurrentAmount = null;
    
    var hdnCreditor = null;
    var txtCreditor = null;
    
    var chkIsVerified = null;
    var chkAddFee = null;
    var txtAddFee = null;
    var chkRetainerFee = null;
    var txtRetainerFee = null;

    var tblBody = null;
    var tblMessage = null;
    var txtAccountId = null;
    
    var txtMatterNumber = null;
    var txtMatterDate = null;
    
    function SortNotes(obj)
    {
        document.getElementById("<%=txtSortFieldNotes.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResortNotes, Nothing) %>;
    }
  
     function IsResolved()
    {
        var chkResolved = document.getElementById("<%= chkResolved.ClientID %>");

        return chkResolved.checked;
    }

   
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function HideMessage()
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    tdError.innerHTML = "";
	    dvError.style.display = "none";
	}
	
</script>

<table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" style="padding-left: 10; height: 100%;">
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
                border="0" cellpadding="0" cellspacing="10">
                <tr>
                    <td valign="top">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="3">
                                    <div runat="server" id="dvError" style="display: none;">
                                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                            width="100%" border="0">
                                            <tr>
                                                <td valign="top" style="width: 20;">
                                                    <img id="Img2" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                                </td>
                                                <td runat="server" id="tdError">
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1;"><b>Task Instruction</b></td>
                </tr>
                <tr>
                    <td style="padding: 5 10 20 10;">
                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td><asp:label runat="server" ID="lblInstruction"></asp:label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                
                <!-- Start Matter Task View -->
                <tr>
                    <td style="height: 100%" valign="top">
                        <asi:TabStrip runat="server" ID="tsMatterView">
                        </asi:TabStrip>
                        <div id="dvPanel1" runat="server" style="padding-top: 10;">
                            <!-- put Notes of Matter in content page here -->
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td valign="top" hover="false">
                                        <div style="overflow: auto; height: 100%">
                                            <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)"
                                                class="list" onselectstart="return false;" id="Table1" style="font-size: 11px;
                                                font-family: tahoma; height: 100%" cellspacing="0" cellpadding="3" width="100%"
                                                border="0">
                                                <colgroup>
                                                    <col align="center" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                </colgroup>
                                                <thead>
                                                    <tr style="height: 20px">
                                                        <th class="headItem" style="width: 5%;" align="center">
                                                            <img id="Img17" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th2" class="headItem" style="width: 30%;cursor: pointer">
                                                            Author
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th3" class="headItem" style="width: 15%;cursor: pointer">
                                                            Task Note
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th4" class="headItem" style="width: 10%;cursor: pointer">
                                                            Date
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:Repeater ID="rpNotes" runat="server">
                                                        <ItemTemplate>
                                                            <a style="background-color: <%#CType(Container.DataItem, GridNote).Color%>" href="#">
                                                                <tr style="color: <%#CType(Container.DataItem, GridNote).TextColor%>; background-color: <%#CType(Container.DataItem, GridNote).Color%>">
                                                                    <td class="listItem" >
                                                                        <img src="<%=ResolveURL("~/images/16x16_note.png")%>" border="0" />
                                                                    </td>
                                                                    <td class="listItem" >
                                                                        <%#CType(Container.DataItem,GridNote).Author %>
                                                                    </td>
                                                                    <td class="listItem" >
                                                                        <%#CType(Container.DataItem, GridNote).Value%>
                                                                    </td>
                                                                    <td class="listItem" >
                                                                        <%#CType(Container.DataItem, GridNote).NoteDate.ToString("MM/dd/yyyy")%>
                                                                    </td>
                                                                </tr>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                            <asp:Panel runat="server" ID="pnlNoNotes" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                There is no notes for this task</asp:Panel>
                                            <input type="hidden" runat="server" id="hdnNotesCount" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <!-- End Matter Task View -->
                
            </table>
            <table runat="server" id="tblMessage" style="color: #666666; display: none; font-family: tahoma;
                font-size: 13px;" border="0" cellpadding="0" cellspacing="15">
                <tr>
                    <td>
                    </td>
                    <td>
                        <img id="Img21" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" />
                    </td>
                </tr>
            </table>
            <asp:HiddenField runat="server" ID="txtResolved" />
            <asp:HiddenField runat="server" ID="hdnTaskResolutionID" />
            <input id="hdnCurrentDoc" type="hidden" runat="server" />
            <input id="hdnTempAccountID" type="hidden" runat="server" />
            <input id="hdnTempMatterID" type="hidden" runat="server" />
            <asp:CheckBox runat="server" ID="chkIsVerified" Style="display: none;"></asp:CheckBox>
            <asp:CheckBox runat="server" ID="chkAddFee" Style="display: none;"></asp:CheckBox>
            <asp:CheckBox runat="server" ID="chkRetainerFee" Style="display: none;"></asp:CheckBox>
            <asp:CheckBox runat="server" ID="chkResolved" Style="display: none;" />
            <asp:HiddenField runat="server" ID="txtAddFee"></asp:HiddenField>
            <asp:HiddenField runat="server" ID="txtRetainerFee"></asp:HiddenField>
            <asp:HiddenField runat="server" ID="txtPropagations" />
            <input type="hidden" runat="server" id="txtSortField" />
            <input type="hidden" runat="server" id="txtSortFieldNotes" />
            <input type="hidden" runat="server" id="txtSortFieldPhones" />
            <input type="hidden" runat="server" id="txtSortFieldEmails" />
            <asp:LinkButton ID="lnkShowDocs" runat="server" />
            <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
            <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortNotes" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortPhones" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortEmails" runat="server"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
        </td>
    </tr>
</table>

<script>
var vartabIndex=<%=tabIndex %>;
if(vartabIndex ==1)
document.getElementById("<%=dvPanel1.ClientID%>").style.display="block";
 
function OpenMatterNotes()
{
    var url = '<%= ResolveUrl("~/util/pop/addmatternote.aspx") %>?t=Add New Note for a Matter&a=m&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>';
     window.dialogArguments = window;
     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
               title: "Add New Note for a Matter",
               dialogArguments: window,
               resizable: false,
               scrollable: false,
               height: 550, width: 600,
               onClose: function(){
                            if ($(this).modaldialog("returnValue") == -1){
                                window.location=window.location.href.replace("#","");
                            }
                        }
               }); 
}
function OpenPhoneCalls()
{
    var url = '<%= ResolveUrl("~/util/pop/addphonecall.aspx") %>?t=Add New phone call for a Matter&a=m&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>';
     window.dialogArguments = window;
     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
               title: "Add New phone call for a Matter",
               dialogArguments: window,
               resizable: false,
               scrollable: false,
               height: 750, width: 700,
               onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                            if (attachWin == -1){
                                window.location=window.location.href.replace("#","");
                            }
                        }
               }); 
}

function OpenMatterRoadmap()
{
     var url = '<%= ResolveUrl("~/util/pop/matterroadmap.aspx") %>?t=Matter Road Map&a=m&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>';
     window.dialogArguments = window;
     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
               title: "Matter Road Map",
               dialogArguments: window,
               resizable: false,
               scrollable: true,
               height: 700, width: 900,
               onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                        }
               }); 
}

function OpenMatterInstance()
{
    window.location = "<%= ResolveUrl("~/clients/client/creditors/matters/matterinstance.aspx") %>?aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&type=<%=MatterTypeId%>&ciid=<%=CreditorInstanceId%>";
}

</script>

