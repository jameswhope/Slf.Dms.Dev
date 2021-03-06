<%@ Page Title="" Language="VB" MasterPageFile="~/negotiation/Negotiation.master"
    AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="negotiation_Managers_Default"
    EnableEventValidation="false" EnableViewState="true" %>

<%@ MasterType TypeName="negotiation_Negotiation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        function checkAll(chk_SelectAll) {
            var frm = document.forms[0];
            var chkState = chk_SelectAll.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                    el.checked = chkState;
                }
            }
        }
        function OpenPABox(settid) {
            var url = '<%= ResolveUrl("~/util/pop/PaymentArrangementInfo.aspx?sid=") %>' + settid;
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Payment Arrangement Info",
                dialogArguments: window,
                resizable: false,
                scrollable: true,
                height: 450, width: 550
            });
            return false;
        }
    </script>

    <asp:UpdatePanel ID="upManager" runat="server">
        <ContentTemplate>
            <div id="holder" class="entry2" style="width:97%;padding: 10px; text-align: left;">
                <div class="entry" style="padding:15px;">
                <asp:Button ID="btnApprove" runat="server" CausesValidation="False" CssClass="fakeButtonStyle"
                    Text="Approve" OnClientClick="return confirm('APPROVE selected?');" />
                <asp:Button ID="btnReject" runat="server" CausesValidation="False" CssClass="fakeButtonStyle"
                    Text="Reject" OnClientClick="return confirm('REJECT Selected?');" />
                    </div>
                <asp:GridView ID="gvManager" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataSourceID="dsManager" CssClass="entry" Width="100%"
                    GridLines="None" PageSize="50" DataKeyNames="ActionID,accountid,clientid,settType">
                    <EmptyDataTemplate>
                    There are no items to approve.
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input type="checkbox" runat="server" id="chk_select" />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="settType" HeaderText="Type" ReadOnly="True" SortExpression="settType">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left"/>
                        </asp:BoundField>
                        <asp:BoundField DataField="ActionID" HeaderText="ActionID" ReadOnly="True" SortExpression="ActionID"
                            Visible="False">
                            <ItemStyle CssClass="listItem" />
                        </asp:BoundField>
                        <asp:BoundField DataField="clientid" HeaderText="clientid" ReadOnly="True" SortExpression="clientid"
                            Visible="False">
                            <ItemStyle CssClass="listItem" />
                        </asp:BoundField>
                        <asp:BoundField DataField="accountid" HeaderText="accountid" ReadOnly="True" SortExpression="accountid"
                            Visible="false">
                            <HeaderStyle CssClass="headItem5" />
                            <ItemStyle CssClass="listItem" />
                        </asp:BoundField>
                        <asp:BoundField DataField="accountnumber" HeaderText="Client Acct #" ReadOnly="True"
                            SortExpression="accountnumber">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left"/>
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left"/>
                        </asp:BoundField>
                        <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="client name"
                            DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}" SortExpression="client name">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                        </asp:HyperLinkField>
                        <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditor name" SortExpression="creditor name"
                            DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                        </asp:HyperLinkField>
                        <asp:BoundField DataField="CurrentAmount" HeaderText="Creditor Acct Bal" ReadOnly="True"
                            SortExpression="CurrentAmount" DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                         
                        <asp:BoundField DataField="SettlementAmount" HeaderText="Sett Amt" ReadOnly="True"
                            SortExpression="SettlementAmount" DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="settlementpercent" HeaderText="Sett %" ReadOnly="True"
                            SortExpression="settlementpercent" DataFormatString="{0:n2}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="SDABalance" HeaderText="SDA Bal" ReadOnly="True" SortExpression="SDABalance"
                            DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Expected">
                            <ItemTemplate>
                                <asp:Label ID="lblExpected" runat="server" CssClass="entry2" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="right"  />
                            <ItemStyle CssClass="listItem" HorizontalAlign="right"  />
                        </asp:TemplateField>
                        <asp:BoundField DataField="OverAmount" HeaderText="Shortage Amt" ReadOnly="True" SortExpression="OverAmount"
                            DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                      
                        <asp:BoundField DataField="settlementduedate" HeaderText="Sett Due Date" ReadOnly="True"
                            SortExpression="settlementduedate" DataFormatString="{0:MM/dd/yyyy}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" Wrap="true"/>
                            <ItemStyle CssClass="listItem" HorizontalAlign="Center"/>
                        </asp:BoundField>
                        <asp:CheckBoxField DataField="IsClientStipulation" SortExpression="IsClientStipulation" HeaderText="Client Stipulation" >
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center"/>
                            <ItemStyle CssClass="listItem" HorizontalAlign="Center"/>
                        </asp:CheckBoxField> 
                        <asp:TemplateField HeaderText="P.A.">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                            <HeaderTemplate>
                                <a>P.A.</a>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsPaymentArrangement")) AndAlso DataBinder.Eval(Container.DataItem, "IsPaymentArrangement"), "<a href=""javascript:void()"" onclick=""OpenPABox('" & DataBinder.Eval(Container.DataItem, "SettlementId") & "');return false;"">Yes</a>", "No")%>
                            </ItemTemplate>
                         </asp:TemplateField> 
                        <asp:BoundField DataField="Created By" HeaderText="Created By" ReadOnly="True" SortExpression="Created By">
                            <HeaderStyle CssClass="headItem5" />
                            <ItemStyle CssClass="listItem" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="dsManager" ConnectionString="<%$ AppSettings:connectionstring %>"
                    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_settlements_getSettlementsWaitingForManagerApproval"
                    SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                <asp:PlaceHolder ID="phMsg" runat="server" />
                <div id="updateMangerDiv" style="display: none; height: 40px; width: 40px">
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateMangerDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('holder');

            // get the bounds of both the gridview and the progress div
            var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
            var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

            //    do the math to figure out where to position the element (the center of the gridview)
            var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
            var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

            //    set the progress element to this position
            Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
        }

        function onUpdated() {
            // get the update progress div
            var updateProgressDiv = $get('updateMangerDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeManager" BehaviorID="manageranimation"
        runat="server" TargetControlID="upManager">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="holder" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="holder" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
