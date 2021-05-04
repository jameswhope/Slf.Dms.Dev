<%@ Page Title="" Language="VB" MasterPageFile="~/negotiation/Negotiation.master"
    AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="negotiation_chkbyphone_Default" %>

<%@ MasterType TypeName="negotiation_Negotiation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<style type="text/css">
        .chkModalBackground
        {
            background-color: #808080;
            filter: alpha(opacity=70);
            opacity: 0.7;
            z-index: 10000;
        }
        .chkModalPopup
        {
            background-color: #F5FAFD;
            filter: progid:DXImageTransform.Microsoft.dropShadow(color=black,offX=5,offY=5, positive=true);
            border-width: 1px;
            border-style: ridge;
            border-color: Gray;
            padding: 0px;
            position: absolute;
            width: 600px;
        }
    </style>
    <script type="text/javascript">
    function popupPhoneInfo(Id, chk, pid) {
        var url = '<%= ResolveUrl("~/processing/popups/PhoneProcessing.aspx") %>?type=' + status + '&sid=' + Id + '&chk=' + chk + '&pmtid=' + pid;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Phone Processing",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: true,
                           height: 600, width: 660, 
                           onClose: function (){
                                if ($(this).modaldialog("returnValue") == -1) {
                                   afterPopupPhoneInfo(Id,pid);
                                } 
                              }
                           });  
    }
    
    function afterPopupPhoneInfo(Id,pId){
        var hdn = document.getElementById('<%=hdnComfirmationSettlementID.ClientID %>');
        var hdnpid = document.getElementById('<%=hdnComfirmationPaymentID.ClientID %>');
        hdn.value = Id;
        hdnpid.value = pId;
        var modalPopupBehavior = $find('mpeCheckbyphone');
        document.getElementById('<%=txtEmailConfirmationTo.ClientId%>').value='';
        modalPopupBehavior.show();
    }
    
    function ReloadChecks() {
        <%=Page.ClientScript.GetPostBackEventReference(btnReloadCheckByPhone,Nothing) %>;
    }
    
    function popupDeliveryMethod(paymentid, matterId, delMethod, payableTo)
    {
         var url = '<%= ResolveUrl("~/processing/popups/UpdateDeliveryMethod.aspx?mid=")%>'+ matterId + '&pmtid='+ paymentid +'&delMethod='+ delMethod +'&payTo='+ payableTo;
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Change Delivery Method",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: true,
                   height: 370, width: 740, 
                   onClose: function(){
                        if ($(this).modaldialog("returnValue") == -1) {
                            ReloadChecks();
                        } 
                   }});
         return false;
    }
    
    function closePopup() {
        var modalPopupBehavior = $find('mpeCheckbyphone');
        modalPopupBehavior.hide();
        ReloadChecks();
        return false;
    }
    function SendConfirmation(elem){
     //confirmationToAddress , settlementID , currentUserID     
        var cEmail = '';
        var sid = '';
        var pid = '';
        var uid = '<%=UserID %>';
        var pr = elem.parentNode.parentNode;
        var ctls = pr.getElementsByTagName('input');
        for (i=0;i<=ctls.length;i++) {
            if (ctls[i].type='text'){
                cEmail = ctls[i].value;
                break;
            }
        }
        var hdn = document.getElementById('<%=hdnComfirmationSettlementID.ClientID %>');
        sid = hdn.value;
        var hdnpid = document.getElementById('<%=hdnComfirmationPaymentID.ClientID %>');
        pid = hdnpid.value;
       
        PageMethods.PM_sendConfirmation(cEmail, pid, sid, uid, EmailSentComplete, EmailSentError);
        return false;
    } 
    function EmailSentError(error, userContext, methodName) {
        if (error != null) {
            alert(error.get_message());
        }
    }
    function EmailSentComplete(result, userContext, methodName) {
       alert(result);
    }    
    </script>

    
    <asp:UpdatePanel ID="upChkByTel" runat="server">
        <ContentTemplate>
            <div id="holder" style="width: 98%; padding: 10px; text-align: left;">
                <div id="divPhoneProcessBox" runat="server" class="ibox nego">
                    <h1 id="hChecks" runat="server">
                        Checks By Phone Processing
                    </h1>
                     <table style="font-family: tahoma; font-size: 11px; width: 100%; margin-bottom: 10px; margin-top: 10px; margin-left: 20px;" cellpadding="3"
                        cellspacing="0" border="0">
                        <tr>
                            <td nowrap="nowrap">
                                Creditor:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlCBPCreditors" runat="server" CssClass="entry2" AppendDataBoundItems="true">
                                    <asp:ListItem Text="--All--"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td nowrap="nowrap">
                                <asp:LinkButton ID="lnkCBPFiler" runat="server" CssClass="lnk"><img src="~/images/16x16_funnel.png" border="0" align="absmiddle" runat="server" /> Apply Filter</asp:LinkButton>
                            </td>
                            <td nowrap="nowrap" style="width: 100%;" class="entryFormat">
                                &nbsp;
                            </td>
                            <td style="white-space: nowrap">
                            </td>
                        </tr>
                    </table>
                    <div id="dvPhoneProcessing" class="collapsable" style="display: block">
                        <asp:GridView ID="gvPhoneProcessing" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            AllowSorting="True" CssClass="entry2" CellPadding="3" BorderWidth="0px" PageSize="50"
                            GridLines="None" Width="100%" DataSourceID="dsPhoneProcessing">
                            <AlternatingRowStyle BackColor="White" />
                            <RowStyle CssClass="row" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img id="Img1" src="~/images/16x16_icon.png" runat="server" alt="icon" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="ImgPhoneIcon" src="~/images/16x16_phone3.png" runat="server" alt="Phone" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DueDate" SortExpression="DueDate" HeaderText="Due&nbsp;Date"
                                    DataFormatString="{0:MM/dd/yyyy}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="negname" HeaderText="Negotiator" SortExpression="negname">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Firm" HeaderText="Firm" SortExpression="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="accountnumber" HeaderText="Acct #">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="clientname" HeaderText="Client" SortExpression="clientname">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="creditorname" HeaderText="Creditor" SortExpression="creditorname">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Check&nbsp;Amount" DataFormatString="{0:c}"
                                    SortExpression="Amount">
                                    <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <input type="hidden" id="hdnChkPhoneMatterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                                        <input type="hidden" id="hdnPhoneCheck" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "CheckNumber")%>' />
                                        <input type="hidden" id="hdnPaymentId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Panel runat="server" ID="pnlNoChecksPhone" Style="text-align: center; font-style: italic;
                                    padding: 10 5 5 5;">
                                    You have no Checks to Process By Phone</asp:Panel>
                            </EmptyDataTemplate>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="dsPhoneProcessing" ConnectionString="<%$ AppSettings:connectionstring %>"
                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetCheckByPhoneProcessing"
                            SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:Parameter Name="userid" DefaultValue="-1" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <input type="hidden" runat="server" id="hdnChecksByPhone" />
                </div>
                <div id="updateChkByTelDiv" style="display: none; height: 40px; width: 40px">
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                </div>
            </div>
            <asp:LinkButton ID="btnReloadCheckByPhone" runat="server"></asp:LinkButton>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnComfirmationSettlementID" runat="server" />
    <asp:HiddenField ID="hdnComfirmationPaymentID" runat="server" />
    <asp:Button ID="btnDummy" runat="server" Style="display: none;" />
    <ajaxToolkit:ModalPopupExtender ID="mpeChk" BehaviorID="mpeCheckbyphone" runat="server"
        BackgroundCssClass="chkModalBackground" PopupControlID="pnlchk" PopupDragHandleControlID="pnlHeader"
        TargetControlID="btnDummy" Y="20">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="pnlchk" runat="server" CssClass="chkModalPopup" Style="display: none; width:600px">
        <asp:Panel ID="pnlHeader" runat="server" Style="display: block;" CssClass="PanelDragHeader"
            Width="100%">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr class="headerstyle">
                    <td align="left" style="padding-left: 10px;">
                        <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Send Check by Phone Email Confirmation" />
                    </td>
                    <td align="right" style="padding-right: 5px;">
                        <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="closePopup();return false;"
                            ImageUrl="~/images/16x16_close.png" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlContent" Style="display: block; text-align: center;" runat="server"
            CssClass="entry">
            <table class="entry" border="0" style="width: 100%; background-color: #DCDCDC; border-top: solid 1px #3D3D3D;
                height: 125px">
                <tr valign="middle">
                    <td class="info">
                        <fieldset>
                        <legend>Enter Recipient's Email Address</legend>
                        <table class="entry">
                        <tr>
                        <td><asp:TextBox ID="txtEmailConfirmationTo" runat="server" CssClass="entry" /></td>
                        <td width="50px"><asp:Button ID="Button2" runat="server" Text="Send" OnClientClick="return SendConfirmation(this);"
                                CssClass="fakeButtonStyle" /></td>
                        </tr>
                        </table>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="entry" style="text-align: right; padding-right: 3px; height: 15px; vertical-align: middle;">
                            <asp:Button ID="Button4" runat="server" Text="Close" OnClientClick="closePopup();return false;"
                                CssClass="fakeButtonStyle" />
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
