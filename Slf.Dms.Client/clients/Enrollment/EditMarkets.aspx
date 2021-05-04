<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="EditMarkets.aspx.vb" Inherits="Clients_Enrollment_EditMarkets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space:nowrap">
                <a id="A1" runat="server" class="menuButton" href="Default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_web_home.png" />Enrollment Home</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space: nowrap;">
                <a id="A2" runat="server" class="menuButton" href="PhoneList.aspx">
                    <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_phone.png" />Phone List</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../../FormMgr/FormMgr.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .modalBackground
        {
            background-color: Gray;
            filter: alpha(opacity=50);
            opacity: 0.50;
        }
        .updateProgress
        {
            border-width: 1px;
            border-style: solid;
            background-color: #FFFFFF;
            position: absolute;
            width: 180px;
            height: 65px;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 200px; background-color: rgb(214,231,243); padding: 20px;"
                        valign="top">
                        <div class="TaskBox">
                            <h6>
                                <span>Common Tasks</span></h6>
                            <div class="box">
                                <asp:LinkButton ID="btnRename" runat="server" CssClass="lnk">
                                    <img id="Img5" src="~/images/16x16_save.png" runat="server" alt="Save" border="0"
                                        style="vertical-align: middle" />&nbsp;&nbsp;Save Name Changes</asp:LinkButton>
                                <div style="padding-top: 5px">
                                    <asp:LinkButton ID="btnCombine" runat="server" CssClass="lnk">
                                        <img id="Img4" src="~/images/16x16_copy.png" runat="server" alt="Save" border="0"
                                            style="vertical-align: middle" />&nbsp;&nbsp;Combine Selected Markets</asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <h2>
                                Edit Markets</h2>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                DisplayAfter="0">
                                <ProgressTemplate>
                                    <div>
                                        <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                        Loading..
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                            <div class="box">
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            <asp:Label ID="lblMsgs" runat="server" CssClass="entry2"></asp:Label>&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="5" ShowFooter="true" CssClass="entry2" DataKeyNames="LeadMarketID"
                                                Width="100%">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkMarket" runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Market" HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtMarket" runat="server" CssClass="entry2" Text='<%# DataBinder.Eval(Container.DataItem,"Market")%>'
                                                                Width="250px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
