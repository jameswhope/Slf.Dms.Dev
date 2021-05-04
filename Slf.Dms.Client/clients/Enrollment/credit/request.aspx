<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="request.aspx.vb" Inherits="Clients_Enrollment_credit_request" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a id="aBack" class="menuButton" href="#" runat="server">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Back</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../Enrollment.css" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <script language="javascript">
        function FindCreditor(creditliabilitylookupid,creditor,street,street2,city,stateid,zipcode)
        {
            var hdn = document.getElementById('<%=hdnCreditorInfo.ClientID %>');
            var hdn2 = document.getElementById('<%=hdnCreditLiabilityLookupID.ClientID %>');
            hdn2.value = creditliabilitylookupid;
            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Find Creditor&p=findcreditorgroup.aspx") %>" + "&creditor=" + creditor + "&street=" + escape(street) + "&street2=" + escape(street2) + "&city=" + city + "&stateid=" + stateid + "&zipcode=" + zipcode, new Array(window, hdn, "CreditorFinderReturn"), "status:off;help:off;dialogWidth:650px;dialogHeight:520px");
        }
        
        function CreditorFinderReturn(hdn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
        {
            hdn.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
            document.getElementById("<%= btnCreditorRefresh.ClientID() %>").click();
        }  
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="enrollment_body" style="margin-top: 10px">
                <tr>
                    <td>
                        <table id="tblAuthQs" runat="server" class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Authentication Questions</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table id="tblQuestions" runat="server" width="650px">
                                        <tr>
                                            <td>
                                                1.
                                                <asp:Label ID="lblQuestion1" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlChoices1" runat="server" CssClass="entry2">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                2.
                                                <asp:Label ID="lblQuestion2" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlChoices2" runat="server" CssClass="entry2">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                3.
                                                <asp:Label ID="lblQuestion3" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlChoices3" runat="server" CssClass="entry2">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                4.
                                                <asp:Label ID="lblQuestion4" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlChoices4" runat="server" CssClass="entry2">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnSendAnswers" runat="server" Text="Send Answers" CssClass="entry2" />
                                    <asp:Button ID="btnRequestAgain" runat="server" Text="Request Again" CssClass="entry2" Visible="false" ToolTip="Note: New authentication questions will be provided." />
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                        DisplayAfter="0">
                                        <ProgressTemplate>
                                            <img src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                            Sending..
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </td>
                            </tr>
                        </table>
                        <asp:Label ID="lblErrorMsg" runat="server" ForeColor="Red"></asp:Label>
                        <table id="tblLiabilities" runat="server" class="window" visible="false">
                            <tr>
                                <td>
                                    <h2>
                                        <span style="float: left;">Credit Liabilities</span> <a id="aViewReport" runat="server"
                                            class="lnk" href="#" target="_blank">
                                            <img style="margin-right: 5;" src="~/images/16x16_pdf.png" runat="server" border="0"
                                                align="absmiddle" />View Full Credit Report</a></h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" DataKeyNames="CreditLiabilityID,CreditLiabilityLookupID,StateID">
                                        <Columns>
                                            <asp:TemplateField ItemStyle-CssClass="left-col">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkSelect" runat="server" />
                                                    <asp:HyperLink ID="lnkFindCreditor" runat="server" ToolTip="Creditor lookup required.."><img runat="server" src="~/images/16x16_search.png" style="border:solid 1px red" /></asp:HyperLink>
                                                    <asp:HiddenField ID="hdnCreditorID" runat="server" Value='<%#Eval("CreditorID")%>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="FirstName" HeaderText="Report" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="CreditorName" HeaderText="Creditor" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="AccountNumber" HeaderText="Account #" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />    
                                            <asp:BoundField DataField="Street" HeaderText="Street" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="City" HeaderText="City" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="StateCode" HeaderText="State" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="PostalCode" HeaderText="Postal" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="AccountType" HeaderText="Type" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="AccountStatus" HeaderText="Status" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="LoanType" HeaderText="Loan Type" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="UnpaidBalance" HeaderText="Balance" DataFormatString="{0:c}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" />
                                            <asp:BoundField DataField="MonthlyPayment" HeaderText="Pymt" DataFormatString="{0:c}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" />
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No acceptable credit liabilities found in credit report.
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnImport" runat="server" Text="Import Selected Creditors" CssClass="entry2" />
                                </td>
                            </tr>
                        </table>
                        <asp:Label ID="lblCreditReportId" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="btnCreditorRefresh" runat="server" />
            <asp:HiddenField ID="hdnCreditorInfo" runat="server" />
            <asp:HiddenField ID="hdnCreditLiabilityLookupID" runat="server" />
            <asp:HiddenField ID="hdnReportID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
