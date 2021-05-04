<%@ Page Title="" Language="VB" MasterPageFile="~/admin/Admin.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_ClientStatements_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <asp:Panel runat="server" ID="pnlBodyDefault">
        <table style="font-family:tahoma;font-size:11px;width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" style="width:75%;">
                    <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                        <tr>
                            <td><a runat="server" id="lnkSimple">S</a>ingle Statement&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" id="lnkAdvanced">S</a>tatements 
                                for the Period</td>
                        </tr>
                        <tr>
                            <td>
                                <table style="font-family:tahoma;font-size:11px;width:750px;" cellpadding="0" 
                                    cellspacing="0" border="0">
                                    <caption>
                                        Statement(s) for the period
                                    </caption>
                                            <tr>
                                                <td style="width: 112px">
                                                    <asp:Label runat="server" text="Account # for statement:" Width="130px"></asp:Label>
                                                </td>
                                                <td align="left" style="width: 221px">
                                                    <asp:TextBox ID="txtAccountNumber" runat="server" CssClass="entry" Width="100px" ></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 112px">
                                                    <asp:label Text="Start Date:" Width="80" runat="server"></asp:label>
                                                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="entry" Width="100px"></asp:TextBox>
                                                </td>
                                                <td style="width: 112px">
                                                    <asp:label Text="End Date:" runat="server" Width="80"></asp:label>
                                                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="entry" Width="100px"></asp:TextBox>
                                                </td>
                                                <td style="padding-left:5;width:80;">
                                                    <asp:label Text="Create Statements: " runat="server" Width="80"></asp:label>
                                                    <asp:LinkButton ID="lnkCreateStatements" runat="server"><img id="Img4" 
                                            src="~/images/16x16_form_red.png" runat="server" align="middle" 
                                            border="0" />
</asp:LinkButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left:5;width:80;">
                                                    <asp:label ID="lblNumToPrint" Text="Num To Print:" runat="server" Width="120"></asp:label>
                                                    <asp:TextBox ID="txtNumToPrint" runat="server" CssClass="entry" Width="100px"></asp:TextBox>
                                                </td>
                                                <td style="padding-left:5;width:80;">
                                                    <asp:label ID="lblPrintStatements" Text="Print Statements: " runat="server" Width="80"></asp:label>
                                                    <asp:LinkButton ID="lnkPrintStmts" runat="server"><img id="Img2" 
                                            src="~/images/16x16_printing.png" runat="server" align="middle" 
                                            border="0" />
</asp:LinkButton>
                                                </td>
                                            </tr>
                                  </table>
                                    </table>
                                  </td>
                                </tr>
                        </table>
            <table>
            <tr>
                <td style="padding:0 5 10 5;color:#a1a1a1;font-style:italic;">
                    <br />
                </td>
            </tr>
        </table>
        <div ID="dvSearch1" runat="server" style="padding-top:10;">
            <asp:Panel ID="pnlNoStatement" runat="server" 
                style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">
                No statement information is available for the period selected.</asp:Panel>
        </div>
        <table>
        <tr>
        <td>
        <div ID="dvStatementsPrepared" runat="server" style="padding-top:10;">
        </div>
        </td>
        <td style='background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-y; background-position: center top;'>
            <img id="Img1" runat="server" height="1" src="~/images/spacer.gif" width="3" /></td>
        <td style="width:20%;" valign="top">
            <table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
                <tr>
                    <td>
                        &nbsp;</td>
                </tr>
            </table>
        </td>
        </tr>
        </table>
    </asp:Panel>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClear"></asp:LinkButton>
</asp:Content>

