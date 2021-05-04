<%@ Page AutoEventWireup="false" CodeFile="stateprimaries.aspx.vb" EnableEventValidation="false"
    Inherits="admin_settings_stateprimaries" Language="VB" MasterPageFile="~/admin/settings/settings.master"
    Title="DMP - State Primaries" %>

<asp:Content ID="cphBody" runat="Server" ContentPlaceHolderID="cphBody">
   <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>

    <script type="text/javascript" language="javascript">
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        
        function Save()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
        
        function Return()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkReturn, Nothing) %>;
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="15" style="font-family: tahoma; font-size: 11px;
                width: 100%;">
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" href="~/admin/default.aspx" style="color: #666666;">
                            Admin</a>&nbsp;>&nbsp; <a id="A4" runat="server" class="lnk" href="~/admin/settings/default.aspx"
                                style="color: #666666;">Settings</a>&nbsp;>&nbsp; <a id="A5" runat="server" class="lnk"
                                    href="~/admin/settings/references/default.aspx" style="color: #666666;">References</a>&nbsp;>&nbsp;
                        <a id="A2" runat="server" class="lnk" href="~/admin/settings/attorneys.aspx"
                            style="color: #666666;">Attorneys</a>&nbsp;>&nbsp;State Primaries
                    </td>
                </tr>
                <tr id="trInfoBox" runat="server" visible="false">
                    <td style="padding: 5px">
                        <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                            <tr>
                                <td style="width: 16;" valign="top">
                                    <img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png" /></td>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblInfoBox" runat="server"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100%; vertical-align: top;">
                        <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                            width: 100%;">
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                    <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                        width: 100%;">
                                        <tr>
                                            <td style="color: rgb(50,112,163);">
                                                State Primaries</td>
                                            <td align="right">
                                                Settlement Attorney:&nbsp;
                                                <asp:DropDownList ID="ddlCompanyMain" runat="server" AutoPostBack="true" Font-Size="10px"
                                                    Height="16px">
                                                </asp:DropDownList>&nbsp;&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table class="list" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)"
                            onselectstart="return false;" cellspacing="0" cellpadding="3" style="border-right: 1px solid #F0F0F0;
                            width: 100%; vertical-align: top;">
                            <thead>
                                <tr>
                                    <th style="width: 22;" align="center">
                                        <img id="Img6" runat="server" src="~/images/16x16_icon.png" border="0" align="middle"
                                            alt="" /></th>
                                    <th align="left" style="width: 15%">
                                        State</th>
                                    <th align="left" style="width: 15%">
                                        Attorney</th>
                                    <th align="right">
                                        <span style="background-color: #ffffcc; 
                                            width: 25"></span>
                                        = No attorneys licensed
                                        <span style="background-color: #FFDFBF; width: 25"></span>
                                        = No primary selected
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptStatePrimary" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td id="tdAgent" runat="server" style="width: 22" align="center">
                                                <img id="Img7" runat="server" src="~/images/16x16_agent.png" border="0" alt="" />
                                            </td>
                                            <td id="tdState" runat="server" align="left">
                                                <%#DataBinder.Eval(Container.DataItem, "Name")%>
                                                <asp:HiddenField ID="hdnState" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"State")%>' />
                                            </td>
                                            <td id="tdAttorney" runat="server" align="center" nowrap="nowrap">
                                                <asp:DropDownList ID="ddlAttorney" runat="server" CssClass="entry" Width="150px">
                                                </asp:DropDownList><asp:HiddenField ID="hdnAttorneyID" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"AttorneyID")%>' />
                                            </td>
                                            <td id="tdPlaceHolder" runat="server">
                                                &nbsp;</td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkSave" runat="server" />
            <asp:LinkButton ID="lnkReturn" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
