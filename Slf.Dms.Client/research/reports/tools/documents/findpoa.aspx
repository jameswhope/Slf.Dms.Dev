<%@ Page Title="" Language="VB" MasterPageFile="~/research/tools/tools.master" AutoEventWireup="false"
    CodeFile="findpoa.aspx.vb" Inherits="research_tools_documents_findpoa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server" >
    <script type="text/javascript">
        function FindPOA() {
            __doPostBack('<%= btnProcess.UniqueID %>', '')
        }
    </script>
    <style type="text/css">
        ul
        {
            list-style-position: outside;
            list-style-type: none;
            padding: 0px;
            margin: 0px;
            text-indent: 0px;
        }
        li
        {
            text-indent: 0px;
        }
    </style>
   <asp:UpdatePanel ID="udpPoa" runat="server">
        <ContentTemplate>
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
                border="0" cellpadding="0" cellspacing="15" >
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                            id="A2" runat="server" class="lnk" style="color: #666666;" href="~/research/tools">Tools</a>&nbsp;>&nbsp;<a
                                id="A3" runat="server" class="lnk" style="color: #666666;" href="~/research/tools/documents/">Documents</a>&nbsp;>&nbsp;Find
                        POA
                    </td>
                </tr>
                
                <tr id="trInfoBox" runat="server">
                    <td>
                        <div class="iboxDiv">
                            <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width: 16;">
                                        <img id="Img12" runat="server" border="0" src="~/images/16x16_note3.png" />
                                    </td>
                                    <td>
                                        <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="iboxHeaderCell">
                                                    INFORMATION:
                                                </td>
                                                <td class="iboxCloseCell" valign="top" align="right">
                                                    <asp:LinkButton runat="server" ID="lnkCloseInformation">
                                                        <img id="Img22" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="iboxMessageCell">
                                                    <b>Find POA's - </b>Emails a pdf containing POA with option to annotate with creditor information and to attach a Modified Letter of Rep.<br />
                                                    Enter Client 600 number's. Separated by a comma (ie. 600000,600001,600002).
                                                    <ul class="entry">
                                                        <li>
                                                            <asp:CheckBox ID="chkAddInfo" runat="server" AutoPostBack="false" Text="Add Creditor Account Info?"
                                                                CssClass="entry2" Font-Bold="true" />
                                                            Adds the following information to the bottom of the document <br />
                                                            <span style="font-style:italic; padding-left:15px;">Client 600: xxxxxx Client SSN: xxx-xx-xxxx/ Creditor Acct #:xxxxxxxxxxxxxx</span>
                                                            
                                                        </li>
                                                        <li>
                                                            <asp:CheckBox ID="chkMLOR" runat="server" AutoPostBack="false" Text="Attach Modified Letter of Rep.?"
                                                                CssClass="entry2" Font-Bold="true" />
                                                        </li>
                                                        <li>For these features to work the 600 number must be accompanied by the last 4 of the
                                                            creditor account number (ie. 600000.1234)</li>
                                                    </ul>
                                                    <br />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div ID="divStatus" runat="server"></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table id="tblPOA" runat="server" style="display: block; width: 100%; font-size: 10px;
                            font-family: tahoma;">
                            <tr>
                                <td class="headerCell" style="font-size: 10px; font-family: tahoma">
                                    <asp:TextBox ID="txtAccts" runat="server" CssClass="entry" Rows="15" TextMode="MultiLine"></asp:TextBox>
                                   <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAccts"
                                        ErrorMessage="At least 1 account must be specified!" Font-Names="tahoma" Display="Dynamic"
                                        Font-Size="Large"></asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center; height: 35px; border-top: solid 1px black;">
                                    <asp:Button ID="btnProcess" Width="35%" Height="30px" runat="server" Text="Find POA's"
                                        Font-Size="Large" style="display:block;" />
                                </td>
                            </tr>
                        </table>
                        </div>
                    </td>
                </tr>
                
            </table>
            
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnProcess" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="lnkGetPOA" runat="server" />
</asp:Content>
