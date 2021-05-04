<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Goals.aspx.vb" Inherits="Clients_Enrollment_Goals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img runat="server" width="8" height="1" src="~/images/spacer.gif" alt="" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a runat="server" class="menuButton" href="default.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png"
                        alt="" />Home</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .cal td
        {
            border: solid 1px #000;
        }
        .cal th
        {
            border-right: solid 1px #000;
            background-color: #ECE9D8;
        }
        .cal th.last
        {
            border-right: none;
            background-color: #ECE9D8;
        }
        h2
        {
            margin: 0;
            padding: 10px 0 0 10px;
            font-weight: normal;
        }
        .goal td
        {
            border: none;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="width: 1058px">
                <h2 id="hMonth" runat="server" style="float: left; width: 300px">
                </h2>
                <div style="float: right; width: 120px; padding:10px">
                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                        DisplayAfter="0">
                        <ProgressTemplate>
                            <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                            <span style="color:blue">Loading..</span>
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>
            <div style="clear: both; padding: 10px">
                <div style="background-color: #F1F1F1; width: 1058px; padding: 5px;">
                    <div style="float: left; width: 300px">
                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="lnk"><img src="~/images/16x16_edit.gif" runat="server" align="absmiddle" border="0" />&nbsp;&nbsp;Edit</asp:LinkButton>
                        <asp:LinkButton ID="btnSave" runat="server" CssClass="lnk" Visible="false"><img src="~/images/16x16_save.png" runat="server" align="absmiddle" border="0" />&nbsp;Save</asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CssClass="lnk" Visible="false"><img src="~/images/16x16_cancel.png" runat="server" align="absmiddle" border="0" />&nbsp;Cancel</asp:LinkButton>
                    </div>
                    <div style="float: right; width: 45px">
                        <asp:LinkButton ID="btnPrev" runat="server" CssClass="lnk">
                            <img id="Img3" src="~/images/16x16_selector_prev.png" runat="server" align="absmiddle"
                                border="0" title="Last Month" /></asp:LinkButton>
                        <asp:LinkButton ID="btnNext" runat="server" CssClass="lnk">
                            <img id="Img4" src="~/images/16x16_selector_next.png" runat="server" align="absmiddle"
                                border="0" title="Next Month" /></asp:LinkButton>
                    </div>
                </div>
                <asp:DataList ID="DataList1" runat="server" RepeatColumns="7" RepeatDirection="Horizontal"
                    CellPadding="0" CssClass="cal">
                    <HeaderTemplate>
                        <table cellpadding="0" cellspacing="0" style="border-collapse: collapse">
                            <tr>
                                <th>
                                    <div style="width: 150px; padding: 5px">
                                        Sunday</div>
                                </th>
                                <th>
                                    <div style="width: 150px">
                                        Monday</div>
                                </th>
                                <th>
                                    <div style="width: 150px">
                                        Tuesday</div>
                                </th>
                                <th>
                                    <div style="width: 150px">
                                        Wednesday</div>
                                </th>
                                <th>
                                    <div style="width: 150px">
                                        Thursday</div>
                                </th>
                                <th>
                                    <div style="width: 150px">
                                        Friday</div>
                                </th>
                                <th class="last">
                                    <div style="width: 150px">
                                        Saturday</div>
                                </th>
                            </tr>
                        </table>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div style='width: 150px; background-color: <%#Eval("bgcolor")%>;'>
                            <div style="float: left; font-weight: bold; padding: 2px">
                                <%#Eval("day")%>
                            </div>
                            <div style="height: 130px; text-align: center; clear: both; padding-top: 15px">
                                <table id="tblGoal" runat="server" class="goal">
                                    <tr>
                                        <td>
                                            Goal
                                        </td>
                                        <td align="right" style="width: 50px">
                                            <asp:Label ID="lblGoal" runat="server" Font-Size="20px" Text='<%#Eval("goal")%>'></asp:Label>
                                            <asp:TextBox ID="txtGoal" runat="server" Width="45px" MaxLength="3" Style="font-size: 20px;
                                                text-align: right" Visible="false" Text='<%#Eval("goal")%>'></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Sub
                                        </td>
                                        <td align="right" style="font-size: 20px">
                                            <%#Eval("submitted")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            +/-
                                        </td>
                                        <td align="right" style="font-size: 20px">
                                            <asp:Label ID="lblDiff" runat="server" Font-Size="20px" Text='<%#Eval("diff")%>'></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                                <asp:HiddenField ID="hdnDate" runat="server" Value='<%#Eval("date")%>' />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:DataList>
            </div>
            <asp:HiddenField ID="hdnCurMonth" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
