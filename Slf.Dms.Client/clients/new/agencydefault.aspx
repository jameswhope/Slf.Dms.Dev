<%@ Page Language="VB" MasterPageFile="~/clients/clients.master" AutoEventWireup="false" CodeFile="agencydefault.aspx.vb" Inherits="clients_new_agencydefault" title="DMP - Clients" %>
<asp:Content ID="cntMenu" ContentPlaceHolderID="cphMenu" Runat="Server"><asp:Panel runat="server" ID="pnlMenu">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            <td nowrap="true">
                <a class="menuButton" href="<%=ResolveUrl("~/") %>">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_arrowleft_clear.png" />Home</a></td>
            <td class="menuSeparator">|</td>
            <td nowrap="true">
                <a class="menuButton" href="#" onclick="Record_Save_Confirm();return false;">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Submit Clients</a></td>
            
            
            <td width="100%"></td>
        </tr>
    </table>   
</asp:Panel></asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">
<link href='<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css") %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/inputgrid2.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
    var grdClients;
    var txtSelected;
    function LoadControls()
    {
        grdClients = document.getElementById("<%=grdClients.ClientID %>");
        txtSelected = document.getElementById("<%=txtSelected.ClientID %>");
    }
    function Record_Save_Confirm()
    {
        LoadControls();
       
        if (Grid_Validate(grdClients.childNodes[0], true))
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx?f=Record_Save&t=Confirm Submission&m=This will submit entered client information to verification.  If you have made a selection of rows, only information for the clients on these rows will be submitted.  Are you sure you wish to proceed?") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Confirm Submission",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400, scrollable: false});  
        }
        else
        {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx")%>?t=Unable to validate&m=Some of the information you entered did not validate.  Please correct all information bordered in red.  You should be aware of the following requirements:<br/><br/> - Dates should follow the format \'dd/MM/yyyy\'.<br/> - Currency must contain only numeric values (\'10.00\' or \'$10.00\').<br/> - The \'First Name\' and \'Last Name\' fields are required.';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Unable to validate",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 400, scrollable: false});  
        }
    }
    function Record_Save()
    {
        LoadControls();
        
        txtSelected.value = Grid_GetSelectedStr(grdClients.childNodes[0]);

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    
    function ShowMessageBody(Value)
    {
        pnlBodyDefault.style.display = "none";
        pnlBodyMessage.style.display = "inline";
        pnlBodyMessage.childNodes[0].rows[0].cells[0].innerHTML = Value;
    }
    function SetURL()
    {
        Grid_AjaxURL = "<%= ResolveURL("~/clients/new/savecell.ashx") %>";
    }
</script>
<style type="text/css">

.stanTbl {font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed;}
.stanTblNoH {font-family:tahoma;font-size:11px;width:100%;table-layout:fixed;}

div.grid {border:solid 1px rgb(172,168,153);overflow:auto;position:relative;width:100%;height:100%;} /* border:solid 2px #dedede;scrollbar-face-color:#cccccc; scrollbar-highlight-color: #eeeeee; scrollbar-shadow-color: buttonface; scrollbar-3dlight-color: #aaaaaa; scrollbar-arrow-color: #ffffff; scrollbar-track-color: #eeeeee; scrollbar-darkshadow-color: #aaaaaa; */
div.grid table {font-family:tahoma;font-size:11px;table-layout:fixed;}
div.grid table th {cursor:default;}

div.grid table thead th {text-align:left;background-color:rgb(235,234,219);white-space:nowrap;border-bottom:solid 1px rgb(203,199,184);font-weight:normal;}
div.grid table thead th div.header {border-bottom:solid 1px rgb(214,210,194);}
div.grid table thead th div.header div {padding:3 4 2 4;border-bottom:solid 1px red} /* rgb(226,222,205); */

div.grid table tbody td {padding:0 4 0 4;white-space:nowrap;border-bottom:solid 1px rgb(241,239,226);border-right:solid 1px rgb(241,239,226);}
div.grid table tbody th {border-bottom:solid 1px rgb(226,222,206);background:rgb(235,234,219);white-space:nowrap;border-bottom:solid 1px rgb(214,210,194);border-top:solid 1px rgb(250,249,244);border-right:solid 1px rgb(214,210,194);font-weight:normal;}
div.grid table tbody th div {padding:2 4 2 4;border-bottom:solid 1px rgb(226,222,205);}

/* rows selected */
div.grid table tbody tr.sel {background-color:rgb(182,202,234);}
div.grid table tbody th.sel {background-color:rgb(222,223,216);}

/* restrict scrolling on row and column headers */
div.grid table thead th{z-index:9998; position:relative; top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);}
div.grid table th.first{z-index:9999; position:relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);}
div.grid table tbody th{z-index:9997; position:relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);}

div.grid table tbody tr.hover {background:#FFCCFF;}
div.grid table tbody tr:hover {background-color:#f1f1f1;}
div.grid table col.hover {background:#FFCCFF;}

input.grdTXT {font-family:tahoma;font-size:11px;position:absolute;}
input.uns {display:none;}
input.sel {}

select.grdDDL {font-family:tahoma;font-size:11px;position:absolute;}
select.uns {display:none;}
select.sel {}

col.c0 {width:28;}
col.c1 {width:100;}
col.c2 {width:100;}
col.c3 {width:100;}
col.c4 {width:100;}
col.c5 {width:100;}
col.c6 {width:100;}
col.c7 {width:100;}
col.c8 {width:100;}
col.c9 {width:100;}
col.c10 {width:100;}
col.c11 {width:100;}
col.c12 {width:100;}
col.c13 {width:100;}

</style>
<asp:ScriptManager ID="ScriptManager1" runat="server">
    <Scripts>
        <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
        <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        <asp:ScriptReference Path="~/jquery/json2.js" />
        <asp:ScriptReference Path="~/jquery/jquery.modaldialog.js" />
    </Scripts>
</asp:ScriptManager>
<body scroll="no" onload="SetURL();">
    <table cellpadding="0" cellspacing="12" style="table-layout:fixed;width:100%;height:100%">
        <tr id="trInfoBoxLanguages" runat="server">
            <td style="padding-bottom:0;height:52" valign="top">
                <div class="iboxDiv" id="iboxDiv" style="height:42">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table id="tblIbox" class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell" style="color:black;" valign="top">
                                            Enter all the new clients in the grid below.  Only the First Name
                                            and Last Name fields are required, and all date fields are checked
                                            for valid entry.  Once you have completed your entry, you may
                                            click the Submit button above to submit the new clients to verification.
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="errorDiv" id="errorDiv" style="display:none;height:42">
                    <table class="errorTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_exclamationpoint.png"/></td>
                            <td>
                                <table class="errorTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="errorHeaderCell" style="color:black;" valign="top" id="tdError"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr valign="top">
            <td style="height:100%;width:100%;" valign="top">
                <div style="width:100%;height:100%;" onkeydown="javascript:if(event.keyCode==13){event.cancelBubble=true;return false;};">
                    <div id="grdClients" class="grid" runat="server"></div><input runat="server" id="grdClientsSelected" type="hidden" /><div style="display:none">tdError;errorDiv;iboxDiv</div>
                    <div id="innerHtml" runat="server"><input type="text" class="grdTXT uns" onkeydown="Grid_TXT_OnKeyDown(this);" onblur="Grid_TXT_OnBlur(this);" /></div>
                </div>
            </td>
        </tr>
    </table>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <input type="hidden" runat="server" id="txtSelected" />
    
</body>
</asp:Panel></asp:Content>
