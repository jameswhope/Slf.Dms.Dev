<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_default" title="DMP - Client" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:ScriptManager ID="smClient" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/rgbcolor.js" />
            <asp:ScriptReference Path="~/jscript/controls/grid.js" />
        </Scripts>
    </asp:ScriptManager>
    <%--<script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>--%>

    <script type="text/javascript">
    var attachWin;
    var intAttachWin;
    
    function IsNullOrEmpty(s)
    {
        return s == null || s == "";
    }
    function RowHover(td, on)
    {
        var tr = td.parentElement;
        var trOther = null;
        
        var HotColor = "";
        var ColdColor = "";

        if (tr.getAttribute("MainRow") != null)
        {
            if (tr.nextSibling != null && tr.nextSibling.getAttribute("MainRow") == null)
            {
                trOther = tr.nextSibling;
            }
        }
        else
        {
            trOther = tr.previousSibling;
        }

        if (IsNullOrEmpty(tr.style.backgroundColor))
        {
            tr.style.backgroundColor = "#ffffff";
        }

        if (IsNullOrEmpty(tr.getAttribute("coldColor")))
        {
            tr.setAttribute("coldColor", tr.style.backgroundColor);

            //set the highlighted color for this row
            var color = new RGBColor(tr.style.backgroundColor);

            var r = color.r - 15;
            var g = color.g - 15;
            var b = color.b - 15;

            if (r < 0) r = 0;
            if (g < 0) g = 0;
            if (b < 0) b = 0;

            tr.setAttribute("hotColor", "rgb(" + r + "," + g + "," + b + ")");
        }

        HotColor = tr.getAttribute("hotColor");
        ColdColor = tr.getAttribute("coldColor");

        if (on)
            tr.style.backgroundColor = HotColor;
        else
            tr.style.backgroundColor = ColdColor;

        if (trOther != null)
        {
            if (on)
                trOther.style.backgroundColor = HotColor;
            else
                trOther.style.backgroundColor = ColdColor;
        }
    }
    function RowClick(TaskID)
    {
        window.navigate("<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);
    }
    function UnresolveDEConfirm()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=UnresolveDE&t=Unresolve Data Entry&m=Are you sure you want to unresolve the Data Entry worksheet for this client?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
    }
    function UnresolveDE()
    {
        <%= ClientScript.GetPostBackEventReference(lnkUnresolveDE, Nothing) %>;
    }
    function UnresolveUWConfirm()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=UnresolveUW&t=Unresolve Verification&m=Are you sure you want to unresolve the Verification worksheet for this client?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
    }
    function UnresolveUW()
    {
        <%= ClientScript.GetPostBackEventReference(lnkUnresolveUW, Nothing) %>;
    }
    function Record_Delete()
    {
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_DeleteConfirm()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx") %>?f=Record_Delete&t=Delete Client&m=Are you sure you want to delete this client?  This action will permanently remove the client and all associated data including:<br><br> - Associated applicants<br> - All personal applicant information<br> - Related Tasks<br> - Related Notes<br> - Transactions<br> - Related Commission<br> - Data Entry information<br> - Negotiation information", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
    }
    function OpenScanning()
    {
        scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=client&rel=<%=ClientID %>', 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
    }
    function ResetPassword()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkResetPassword, Nothing) %>;
    }
    function Enter_Hardship()
    {
        <%= ClientScript.GetPostBackEventReference(lnkHardship, Nothing) %>;
    }
    function Print_Package()
    {
        <%= ClientScript.GetPostBackEventReference(lnkPrintPackage, Nothing) %>;
    }
     function Generate_ClientFile()
    {
        <%= ClientScript.GetPostBackEventReference(lnkGenerateClientFile, Nothing) %>;
    }
    </script>

    <asp:Label ID="lblNote" runat="server" />
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="height: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td>
                                        <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                            cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td valign="top">
                                                    <asp:LinkButton CssClass="lnk" Style="color: rgb(80,80,80); font-family: tahoma;
                                                        font-size: medium;" runat="server" ID="lnkName"></asp:LinkButton>
                                                    &nbsp; <a class="lnk" style="font-family: verdana; color: rgb(80,80,80);" runat="server"
                                                        id="lnkNumApplicants"></a>-
                                                    <asp:Label runat="server" Style="color: rgb(160,80,80); font-family: tahoma; font-size: medium;"
                                                        ID="lblCompany"></asp:Label>
                                                    <br />
                                                    <asp:Label runat="server" ID="lblAddress"></asp:Label>
                                                </td>
                                                <td align="right" valign="top">
                                                    <asp:Label runat="server" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                                        ID="lblAccountNumber"></asp:Label>
                                                    <asp:Label runat="server" ID="lblSSN" Visible="false"></asp:Label>
                                                    <asp:Label runat="server" ID="lblLeadNumber"></asp:Label>
                                                    Status:&nbsp;
                                                    <asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="lnkStatus"></asp:LinkButton>
                                                    <asp:Label runat="server" ID="lnkStatus_ro" Visible="false"></asp:Label>
                                                    <br />Hardship:&nbsp;
                                                    <asp:Label ID="lblHardship" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
                                    background-repeat: repeat-x;">
                                    <td>
                                        <img height="30" width="1" runat="server" src="~/images/spacer.gif" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" ID="pnlMessage" Visible="false">
                                            <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                font-family: Verdana, Arial, Helvetica; background-color: #ffffda" cellspacing="10"
                                                cellpadding="0" width="100%" border="0">
                                                <tr>
                                                    <td valign="top">
                                                        <img id="imgMessage" runat="server" src="~/images/message.png" align="absmiddle"
                                                            border="0">
                                                    </td>
                                                    <td runat="server" id="tdMessage" style="width: 100%;">
                                                    </td>
                                                </tr>
                                            </table>
                                            &nbsp;</asp:Panel>
                                    </td>
                                </tr>
                                <asp:PlaceHolder ID="phCommunication" runat="server">
                                    <asp:PlaceHolder ID="phCommunication_default" runat="server">
                                        <tr>
                                            <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                    cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <a style="color: rgb(50,112,163);" class="lnk" href="<%= ResolveUrl("~/clients/client/communication/?id=") + DataClientID.ToString() %>">
                                                                Recent Communication</a>
                                                        </td>
                                                        <td align="right">
                                                            <asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="lnkAllEmail">All Email</asp:LinkButton>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:LinkButton
                                                                Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="lnkAllNotes">All Notes</asp:LinkButton><asp:PlaceHolder
                                                                    ID="phSearch" runat="server">&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="~/search.aspx"><img
                                                                        runat="server" src="~/images/16x16_find.png" border="0" align="absmiddle" /></a></asp:PlaceHolder>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 100%;" valign="top">
                                                <table onselectstart="return false;" id="tblCommunication" style="table-layout: fixed;
                                                    font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%"
                                                    border="0">
                                                    <tr>
                                                        <td class="headItem" style="width: 20;" align="center">
                                                            <img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </td>
                                                        <td class="headItem" style="width: 15;" align="left">
                                                            <img runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                        </td>
                                                        <td class="headItem" style="width: 75">
                                                            Date<img style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png" border="0"
                                                                align="absmiddle" />
                                                        </td>
                                                        <td class="headItem" style="width: 25%">
                                                            By
                                                        </td>
                                                        <td class="headItem">
                                                            Message
                                                        </td>
                                                    </tr>
                                                    <asp:Repeater ID="rpCommunication" runat="server">
                                                        <ItemTemplate>
                                                            <a href="<%# ResolveUrl("~/clients/client/communication/" + GetPage(DataBinder.Eval(Container.DataItem, "type").ToString()) + ".aspx") + "?id=" + dataclientid.tostring() + "&" + GetQSID(DataBinder.Eval(Container.DataItem, "type").ToString()) + "=" + DataBinder.Eval(Container.DataItem, "FieldID").ToString()  %>">
                                                                <tr>
                                                                    <td style="width: 20" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                        class="listItem" nowrap="true">
                                                                        <img src="<%#GetImage(DataBinder.Eval(Container.DataItem, "type").ToString(),DataBinder.Eval(Container.DataItem, "direction"))%>"
                                                                            border="0" />
                                                                    </td>
                                                                    <td style="width: 15" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                        class="listItem" nowrap="true">
                                                                        <%#GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                                                    </td>
                                                                    <td style="width: 75" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                        class="listItem" nowrap="true">
                                                                        <%#DataBinder.Eval(Container.DataItem, "Date", "{0:MMM d, yy}")%>
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                                        nowrap="true">
                                                                        <%#DataBinder.Eval(Container.DataItem, "By")%>&nbsp;
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                        <%#DataBinder.Eval(Container.DataItem, "ShortMessage")%>
                                                                    </td>
                                                                </tr>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </table>
                                                <asp:Panel runat="server" ID="pnlNoCommunication" Style="text-align: center; font-style: italic;
                                                    padding: 10 5 5 5;">
                                                    This client has no email or notes</asp:Panel>
                                            </td>
                                        </tr>
                                    </asp:PlaceHolder>
                                    <tr id="trCommunication_agency" runat="server">
                                        <td style="height: 100%;" valign="top">
                                            <asi:StandardGrid2 ID="grdCommunication_agency" XmlSchemaFile="~/standardgrids.xml"
                                                runat="server">
                                            </asi:StandardGrid2>
                                        </td>
                                    </tr>
                                    <tr id="trCommunication_my" runat="server">
                                        <td style="height: 100%;" valign="top">
                                            <asi:StandardGrid2 ID="grdCommunication_my" XmlSchemaFile="~/standardgrids.xml" runat="server">
                                            </asi:StandardGrid2>
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phRegister" runat="server">
                                    <tr runat="server" id="trRegistersSeparator">
                                        <td style="height: 35;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trRegistersHeader">
                                        <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                cellspacing="0" border="0">
                                                <tr>
                                                    <td style="color: rgb(50,112,163);">
                                                        Last 4 Transactions
                                                    </td>
                                                    <td align="right">
                                                        <a style="color: rgb(50,112,163);" class="lnk" runat="server" id="lnkRegister">Register</a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trRegistersBody">
                                        <td>
                                            <table onselectstart="return false;" style="width: 100%; font-family: tahoma; font-size: 11px;"
                                                border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="center" style="width: 20;" class="headItem4">
                                                        <img runat="server" src="~/images/16x16_icon.png" border="0" />
                                                    </td>
                                                    <td align="center" style="width: 15;" class="headItem4">
                                                        <img runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                    </td>
                                                    <td nowrap="true" class="headItem4">
                                                        Date<img style="margin-left: 5;" border="0" align="absmiddle" src="~/images/sort-desc.png"
                                                            runat="server" />
                                                    </td>
                                                    <td nowrap="true" class="headItem4" style="padding: 3 10 3 3">
                                                        UID
                                                    </td>
                                                    <td nowrap="true" class="headItem4">
                                                        Type
                                                    </td>
                                                    <td nowrap="true" class="headItem4" style="width: 100%;">
                                                        Associated To
                                                    </td>
                                                    <td nowrap="true" class="headItem4" align="right" style="width: 80; padding-right: 7;">
                                                        Amount
                                                    </td>
                                                </tr>
                                                <asp:Repeater runat="server" ID="rpTransactions">
                                                    <ItemTemplate>
                                                        <a href="<%#rpTransactions_Redirect(CType(Container.DataItem, RegisterTransaction))%>">
                                                            <tr mainrow="true" <%#rpTransactions_RowStyle(CType(Container.DataItem, RegisterTransaction))%>>
                                                                <td runat="server" id="tdIcon" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    align="center" style="width: 20;" class="listItem4">
                                                                    <img id="Img7" runat="server" src="~/images/16x16_cheque.png" border="0" />
                                                                </td>
                                                                <td runat="server" id="tdAttachments" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    align="center" style="width: 15;" class="listItem4">
                                                                    <%#GetAttachmentText(CType(Container.DataItem, RegisterTransaction).ID, "register")%>
                                                                </td>
                                                                <td runat="server" id="tdDate" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    nowrap="true" class="listItem4" style="padding-right: 10">
                                                                    <%#CType(Container.DataItem, RegisterTransaction).Date.ToString("M/d/yyyy")%>
                                                                </td>
                                                                <td runat="server" id="tdID" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    nowrap="true" class="listItem4" style="padding: 3 10 3 3;">
                                                                    <%#CType(Container.DataItem, RegisterTransaction).ID%>
                                                                </td>
                                                                <td runat="server" id="tdType" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    nowrap="true" class="listItem4" style="padding-right: 10">
                                                                    <%#CType(Container.DataItem, RegisterTransaction).EntryTypeName%>
                                                                </td>
                                                                <td runat="server" id="tdAssociatedTo" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    class="listItem4" style="font-style: italic; color: #757575;">
                                                                    <%#rpTransactions_Associations(CType(Container.DataItem, RegisterTransaction))%>&nbsp;
                                                                </td>
                                                                <td runat="server" id="tdAmount" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                    nowrap="true" class="listItem4" align="right" style="padding-right: 7;">
                                                                    <%#rpTransactions_Amount(CType(Container.DataItem, RegisterTransaction).OriginalAmount, CType(Container.DataItem, RegisterTransaction).Amount)%>
                                                                </td>
                                                            </tr>
                                                        </a>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                            </table>
                        </td>
                        <td style="width: 35; background-position: center top; background-repeat: repeat-y;
                            background-image: url(<%= ResolveUrl("~/images/dot.png") %>);">
                            <img height="35" runat="server" src="~/images/spacer.gif" border="0" />
                        </td>
                        <td style="width: 150;" valign="top">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <asp:PlaceHolder ID="phTasks" runat="server">
                                    <tr runat="server" id="trUpcomingTasksHeader">
                                        <td style="padding: 5 5 10 5;">
                                            <a style="color: rgb(50,112,163);" runat="server" class="lnk" href="~/tasks">Your Upcoming
                                                Tasks</a>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trUpcomingTasksBody">
                                        <td>
                                            <table onselectstart="return false;" id="tblUpcomingTasks" style="table-layout: fixed;
                                                font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="5" width="100%"
                                                border="0">
                                                <tr>
                                                    <td class="headItem">
                                                        Description
                                                    </td>
                                                    <td class="headItem" style="width: 55">
                                                        Due
                                                    </td>
                                                </tr>
                                                <asp:Repeater ID="rpUpcomingTasks" runat="server">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                <%#DataBinder.Eval(Container.DataItem, "ShortDescription")%>&nbsp;
                                                            </td>
                                                            <td onclick="RowClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="width: 55;">
                                                                <asp:Label ID="lblDue" runat="server"><%#DataBinder.Eval(Container.DataItem, "Due", "{0:MM/dd/yy}")%></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trUpcomingTasksSeparator">
                                        <td style="height: 20;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phAttorney" runat="server">
                                    <tr>
                                        <td style="padding: 5; background-color: #f1f1f1;">
                                            <a style="color: rgb(50,112,163);" class="lnk">Attorney Information</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 100%;">
                                                        <asp:Label runat="server" ID="lblRemittance" Text="Remittance:" Font-Underline="true" ForeColor="Gray"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblRemittAdd"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblRemittAdd2" Visible="false"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblRemittCity"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblRemittState"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                               <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 100%;">
                                                        <asp:Label runat="server" ID="lblClientServices" Text="Client Services:" ForeColor="Gray" Font-Underline="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblClientSvcsAdd"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblClientSvcsAdd2" Visible="false"></asp:Label>
                                                    </td>
                                                    <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblClientSvcsCity"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblClientSvcsState"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 25;">
                                                        <asp:Label runat="server" ID="lblClientServicesPhone" Text="Phone:" ForeColor="Gray"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" align="left" style="width: 75;">
                                                        <asp:Label runat="server" ID="lblClientSvcsPhone"></asp:Label>
                                                    </td>
                                                    </tr>
                                                    <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 25;">
                                                        <asp:Label runat="server" ID="lblClientServicesFax" Text="Fax:" ForeColor="Gray"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblClientSvcsFax" style="width: 75;"></asp:Label>
                                                    </td>
                                                </tr>
                                                </table>
                                                <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 100%;">
                                                        <asp:Label runat="server" ID="lblCreditorServices"  Text="Creditor Services:" ForeColor="Gray" Font-Underline="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblCreditorSvcsAdd"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblCreditorSvcsAdd2" Visible="false"></asp:Label>
                                                    </td>
                                                    <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblCreditorSvcsCity"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" align="left">
                                                        <asp:Label runat="server" ID="lblCreditorSvcsState"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="nowrap" align="left" style="width: 25;">
                                                        <asp:Label runat="server" ID="lblCreditorServicesPhone" Text="Phone:" ForeColor="Gray"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" align="left" style="width: 75;">
                                                        <asp:Label runat="server" ID="lblCreditorSvcsPhone"></asp:Label>
                                                    </td>
                                                    </tr>
                                                    <tr>
                                                </tr>
                                                </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 20;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phStatistics" runat="server">
                                    <tr>
                                        <td style="padding: 5; background-color: #f1f1f1;">
                                            <a style="color: rgb(50,112,163);" class="lnk">Statistics</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                                cellspacing="5">
                                                <tr>
                                                    <td nowrap="true" style="width: 75;">
                                                        <a runat="server" id="lnkAccountsToSettle" class="lnk" style="color: black;">Accounts:</a>
                                                    </td>
                                                    <td nowrap="true" align="right">
                                                        <asp:Label runat="server" ID="lblAccountsToSettle"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="true" style="width: 75;">
                                                        <a runat="server" id="lnkUnverified" class="lnk" style="color: black;">Unverified:</a>
                                                    </td>
                                                    <td nowrap="true" align="right">
                                                        <asp:Label runat="server" ID="lblUVAccounts"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="true">
                                                        <a runat="server" id="lnkSDABalance" class="lnk" style="color: black;">SDA Balance:</a>
                                                    </td>
                                                    <td nowrap="true" align="right">
                                                        <asp:Label runat="server" ID="lblSDABalance"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="true">
                                                        <a runat="server" class="lnk" id="lnkPFOBalance" style="color: black;">PFO Balance:</a>
                                                    </td>
                                                    <td nowrap="true" align="right">
                                                        <asp:Label runat="server" ID="lblPFOBalance"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="true">
                                                        <a runat="server" id="lnkAgency" class="lnk" style="color: black;">Agency:</a>
                                                    </td>
                                                    <td nowrap="true" align="right">
                                                        <asp:Label runat="server" ID="lblAgency"></asp:Label>
                                                    </td>
                                                </tr>
                                                <%-- <tr>
                                                <td nowrap="true"><a runat="server" id="lnkCompany" class="lnk" style="color:black;">Company:</a></td>
                                                <td nowrap="true" align="right"><asp:Label runat="server" id="lblCompany"></asp:Label></td>
                                            </tr>--%>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 20;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phRoadmap" runat="server">
                                    <tr>
                                        <td style="padding: 5 5 10 5;" id="tdBigRoadmap" runat="server">
                                            <a style="color: rgb(50,112,163);" class="lnk" href="roadmap.aspx<%= QueryString %>">
                                                Roadmap</a>
                                        </td>
                                        <td style="padding: 5 5 10 5;" id="tdBigRoadmap_No" runat="server" visible="false">
                                            Roadmap
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Panel runat="server" ID="pnlRoadmap">
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
        TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
        BackgroundCssClass="modalBackgroundNeg" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel runat="server" CssClass="modalPopupNeg" ID="programmaticPopup" Style="display: none;
        width: 725px; padding: 10px">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #DDDDDD;
            border: solid 1px Gray; color: Black; text-align: center;width:725px">
            <div id="dvCloseMenu" runat="server" style="width: 100%; height: 25px; background-color: white;
                z-index: 51">
                <asp:LinkButton runat="server" Font-Bold="true" Font-Size="Medium" ID="hideModalPopupViaServer"
                    Text="Close" OnClick="hideModalPopupViaServer_Click" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlRpt">
            <div id="dvReport" runat="server" style="width: 725px; height: 550px; z-index: 51;
                visibility: visible; background-color: Transparent;">
                <iframe id="frmReport" runat="server" src="../../Clients/client/reports/report.aspx"
                    style="width: 100%; height: 95%;" frameborder="0" />
            </div>
        </asp:Panel>
    </asp:Panel>
    <asp:LinkButton runat="server" ID="lnkUnresolveDE" />
    <asp:LinkButton runat="server" ID="lnkUnresolveUW" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:LinkButton runat="server" ID="lnkHardship" />
    <asp:LinkButton runat="server" ID="lnkPrintPackage" />
    <asp:LinkButton runat="server" ID="lnkResetPassword" />
    <asp:LinkButton runat="server" ID="lnkGenerateClientFile" />
</asp:Content>
