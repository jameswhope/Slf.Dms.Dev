<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="request2.aspx.vb" Inherits="Clients_Enrollment_credit_request" %>

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
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <link href="../Enrollment.css" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <style type="text/css" >
        .credError 
        {
            margin-bottom: 10px; 
            padding: 10 10 10 10;
            border: solid 1px #c0c0c0;
            width: 100%;
            background-color: #F5F6CE
            }
         .imgResult
         {
             vertical-align: middle; 
             }
         .errorMsg
         {
             color: Red;
             }
          .warningMsg
         {
             color: #DF7401;
             }
    </style>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script language="javascript" type="text/jscript" >
      function pageLoad(){
            $(document).ready(function () {
                //$("#mnuCreditReport").menu({position: {my:'left top',at:'left bottom+3'}});  
                
                $("#mnuCreditReport li").first().hover(
                function(){$(this).children("ul").show();}, 
                function () { $(this).children("ul").hide(); });  
                
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
                        <asp:Label ID="lblErrorMsg" runat="server" ForeColor="Red" CssClass="credError" ></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                    <table id="tbLeads" runat="server" class="window" >
                            <tr>
                                <td>
                                    <h2>
                                        <span style="float: left;">Lead Information</span>
                                    </h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="grdborrowers" runat="server" AutoGenerateColumns="false" DataKeyNames="SSN">
                                        <Columns>
                                             <asp:TemplateField HeaderText="Result" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col2" >
                                                <ItemTemplate>
                                                    <asp:Image ID="imgResult" runat="server" Width="16" Height="16" CssClass="imgResult" />
                                                    <asp:Label ID="lblResult" runat="server"/>
                                                </ItemTemplate>
                                             </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Is Valid?" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3" >
                                                <ItemTemplate>
                                                    <asp:Image ID="imgValid" runat ="server" Width="16" Height="16" /> 
                                                </ItemTemplate>
                                             </asp:TemplateField>
                                            <asp:BoundField DataField="SSN" HeaderText="SSN" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="FirstName" HeaderText="First Name" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="LastName" HeaderText="Last Name" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="Address" HeaderText="Street" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="City" HeaderText="City" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="State" HeaderText="State" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="ZipCode" HeaderText="Zip Code" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="ApplicantType" HeaderText="Applicant" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="dob" HeaderText="Date of Birth" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                            <asp:BoundField DataField="LastOKDate" HeaderText="Last OK Request" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                             <asp:BoundField DataField="FileHitIndicator" HeaderText="File Hit" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                             <asp:BoundField DataField="Flags" HeaderText="Flags" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" />
                                             <asp:TemplateField HeaderText="Reuse" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3" >
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkReuse" runat="server" />
                                                </ItemTemplate>
                                             </asp:TemplateField>
                                             <asp:TemplateField HeaderText="Exclude" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3" >
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkExclude" runat="server" />
                                                </ItemTemplate>
                                             </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No leads available
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnSendRequest" runat="server" Text="Run Credit Report" CssClass="entry2" />
                        <asp:Button ID="btnRequestAgain" runat="server" Text="Request Again" CssClass="entry2" Visible="false" />
                        <asp:Button ID="btnSave" runat="server" Text="Save Report" CssClass="entry2" Visible="false" />
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                            DisplayAfter="0">
                            <ProgressTemplate>
                                <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                Sending..
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table id="tblLiabilities" runat="server" class="window" visible="false">
                            <tr>
                                <td>
                                    <h2>
                                        <span style="float: left;">Credit Liabilities</span> <asp:Literal ID="aViewReport" runat="server"></asp:Literal></h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="CreditLiabilityID,CreditLiabilityLookupID,StateID">
                                        <Columns>
                                            <asp:TemplateField ItemStyle-CssClass="left-col">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkSelect" runat="server" />
                                                    <asp:HyperLink ID="lnkFindCreditor" runat="server" ToolTip="Creditor lookup required.."><img runat="server" src="~/images/16x16_search.png" style="border:solid 1px red" /></asp:HyperLink>
                                                    <asp:HiddenField ID="hdnCreditorID" runat="server" Value='<%#Eval("CreditorID")%>' />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="left-col" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="FirstName" HeaderText="Report" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CreditorName" HeaderText="Creditor" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="AccountNumber" HeaderText="Account #" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >    
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Street" HeaderText="Street" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="City" HeaderText="City" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="StateCode" HeaderText="State" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="PostalCode" HeaderText="Postal" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="AccountType" HeaderText="Type" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="AccountStatus" HeaderText="Status" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="LoanType" HeaderText="Loan Type" HeaderStyle-CssClass="top-col"
                                                ItemStyle-CssClass="center-col2" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col2" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="UnpaidBalance" HeaderText="Balance" DataFormatString="{0:c}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" >
                                            <HeaderStyle CssClass="top-col" ForeColor="White" />
                                            <ItemStyle CssClass="center-col" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="MonthlyPayment" HeaderText="Pymt" DataFormatString="{0:c}"
                                                HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col" >
                                            <HeaderStyle CssClass="top-col" />
                                            <ItemStyle CssClass="center-col" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="exists" HeaderText="Exists" Visible="False" />
                                            <asp:BoundField DataField="Street2" HeaderText="Street2" Visible="False" />
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
                        <asp:Label ID="lblCreditReportId" runat="server" Visible="False" ></asp:Label>
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
