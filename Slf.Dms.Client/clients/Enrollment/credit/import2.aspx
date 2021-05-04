<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="import2.aspx.vb" Inherits="Clients_Enrollment_credit_import" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
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
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<link href="../Enrollment.css" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script language="javascript">
        function pageLoad(){
            $(document).ready(function () {
               // $("#mnuCreditReport").menu({position: {my:'left top',at:'left bottom+3'}});
               
               $("#mnuCreditReport li").first().hover(
                function(){$(this).children("ul").show();}, 
                function(){$(this).children("ul").hide();}); 
            });
          }
        function FindCreditor(creditliabilitylookupid,creditor,street,street2,city,stateid,zipcode)
        {
            var hdn = document.getElementById('<%=hdnCreditorInfo.ClientID %>');
            var hdn2 = document.getElementById('<%=hdnCreditLiabilityLookupID.ClientID %>');
            hdn2.value = creditliabilitylookupid;
            var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>creditor=' + escape(creditor) + '&street=' + escape(street) + '&street2=' + escape(street2) + '&city=' + city + '&stateid=' + stateid + '&zipcode=' + zipcode;
            window.dialogArguments = new Array(window, btn, "CreditorFinderReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Find Creditor",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 700, width: 650
            });    
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
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        <span style="float: left;">Credit Liabilities</span> <asp:Literal ID="aViewReport" runat="server"></asp:Literal></h2>
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
                                            <asp:BoundField DataField="FirstName" HeaderText="Source" HeaderStyle-CssClass="top-col"
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
                                            <asp:BoundField DataField="LoanTypeDescription" HeaderText="Loan Type" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="UnpaidBalance" HeaderText="Balance" DataFormatString="{0:c}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" />
                                            <asp:BoundField DataField="DateImported" HeaderText="Imported" DataFormatString="{0:d}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" />    
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No acceptable credit liabilities found in credit report. See full credit report.
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
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="btnCreditorRefresh" runat="server" />
            <asp:HiddenField ID="hdnCreditorInfo" runat="server" />
            <asp:HiddenField ID="hdnCreditLiabilityLookupID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

