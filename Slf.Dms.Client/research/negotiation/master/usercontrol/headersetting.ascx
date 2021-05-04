<%@ Control Language="VB" AutoEventWireup="false" CodeFile="headersetting.ascx.vb"
    Inherits="admin_settings_rules_negotiation_usercontrol_headersetting" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="cc1" %>
<asp:ScriptManagerProxy ID="ScriptManager1" runat="server" >
</asp:ScriptManagerProxy>
<table cellpadding="0" cellspacing="0" border="0" style="font-family: tahoma; font-size: 11px;
    height: 20px">
    <tr>
        <td>
            <asp:UpdateProgress ID="updProgress" runat="server" DisplayAfter="0" AssociatedUpdatePanelID="updheader">
                <ProgressTemplate>
                    <asp:Image ID="imgLoading" Style="font-family: tahoma; font-size: 11px;" runat="server"
                        ImageAlign="middle" ImageUrl="~/images/Loading.gif" />&nbsp;&nbsp;<span style="font-family: tahoma;
                            font-size: 11px;">Processing Please wait ...</span>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </td>
    </tr>
</table>
<asp:UpdatePanel ID="updheader" runat="server">
    <ContentTemplate>
        <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" align="center">
            <tr>
                <td valign="bottom" style="font-family: tahoma; font-size: 11px; color: rgb(50,112,163);">
                    Assignment Header Settings</td>
            </tr>
            <tr>
                <td valign="top" align="left">
                    <table style="font-family: tahoma; font-size: 11px">
                        <tr>
                            <td align="center">
                                <table border="0" cellpadding="0" cellspacing="0" width="430px">
                                    <tr bgcolor="#cccccc" height="18px">
                                        <td style="font-family: tahoma; font-size: 11px">
                                            &nbsp;</td>
                                        <td style="font-family: tahoma; font-size: 11px" align="center">
                                            Header Name</td>
                                        <td style="font-family: tahoma; font-size: 11px" align="center">
                                            Aggregation</td>
                                        <td style="font-family: tahoma; font-size: 11px" align="center">
                                            Order</td>
                                        <td style="font-family: tahoma; font-size: 11px" align="center">
                                            Default Grouping</td>
                                            
                                    </tr>
                                    <asp:Repeater ID="rptheader" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-family: tahoma; font-size: 11px">
                                                    <asp:CheckBox ID="chkHeader" AutoPostBack="true" OnCheckedChanged="EnableRow" Style="font-family: tahoma;
                                                        font-size: 11px" runat="server"></asp:CheckBox></td>
                                                <td style="font-family: tahoma; font-size: 11px">
                                                    <asp:TextBox ID="txtHeaderName" Style="font-family: tahoma; font-size: 11px" runat="server"
                                                        Text='<%# DataBinder.Eval(Container.DataItem,"FieldName") %>' Enabled="false"></asp:TextBox></td>
                                                <td style="font-family: tahoma; font-size: 11px" align="center">
                                                    <asp:DropDownList ID="drpAggregate" Style="font-family: tahoma; font-size: 11px"
                                                        runat="server" Width="100px">
                                                    </asp:DropDownList></td>
                                                <td style="font-family: tahoma; font-size: 11px" align="right">
                                                    <asp:DropDownList ID="drpOrder" OnSelectedIndexChanged = "CascadeSelection" AutoPostBack="true" Style="font-family: tahoma; font-size: 11px" runat="server"
                                                        Width="100px">
                                                    </asp:DropDownList><asp:TextBox ID="txtDataType" Style="font-family: tahoma; font-size: 11px"
                                                        Width="1px" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DataType") %>'
                                                        Visible="false"></asp:TextBox>
                                                </td>
                                                <td align="center"><asp:RadioButton Enabled=false AutoPostBack="true" ID="defaultGroup" OnCheckedChanged="RefreshDefaultGrouping" GroupName="defaultGroup" runat="server" /></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <img id="imgMsg" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                        <td>
                                            &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" Style="font-family: tahoma; font-size: 11px;"
                                                Width="100%" ForeColor="Red" Font-Bold="false"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 430px;"
                                    border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="border-top: solid 2px rgb(149,180,234);" colspan="4">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <img id="Img3" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />
                                        </td>
                                        <td align="left">
                                            <a tabindex="1" style="color: black" class="lnk" href="javascript:window.close();">Cancel
                                                and Close</a></td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkCommit" Text="Commit Settings" runat="server" class="lnk"
                                                Style="color: black" />
                                        <td align="right">
                                            <img id="Img4" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
