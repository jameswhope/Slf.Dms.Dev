<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="processing_TaskSummary_Default"
    MasterPageFile="~/processing/Processing.master" EnableEventValidation="false" %>

<%@ Register Src="~/processing/webparts/CreditorInfoControl.ascx" TagName="CreditorInfoControl"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/SettlementInformation.ascx" TagName="SettlementInformation"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/ClientApprovalTask.ascx" TagName="ClientApproval"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/SettlementNotes.ascx" TagName="SettlementNotes"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/SettlementCalculations.ascx" TagName="SettlementCalculations"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/ClientAccountSummary.ascx" TagName="ClientAccountSummary"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/ClientInfoControl.ascx" TagName="ClientInfo"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/PendingCalculator.ascx" TagName="PendingClientSettlements"
    TagPrefix="webPart" %>
<%@ Register Src="~/processing/webparts/StipulationLetterSentHistory.ascx" TagName="StipulationLetterSentHistory"
    TagPrefix="webPart" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphProcessingBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <link href="<%= ResolveUrl("~/processing/css/globalstyle.css") %>" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>    
    <asp:ScriptManagerProxy ID="smTaskSum" runat="server">
    </asp:ScriptManagerProxy>
    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0"
        id="tblProc" class="entryformat">
        <tr>
            <td style="width: 270px; background-color: rgb(214,231,243); padding-top: 35px;"
                valign="top" class="entryFormat">
                <asp:UpdatePanel ID="upProcessing" runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        <ajaxToolkit:Accordion ID="accTaskSummary" runat="server" SuppressHeaderPostbacks="true"
                            FadeTransitions="true" TransitionDuration="200" FramesPerSecond="20" RequireOpenedPane="true">
                            <Panes>
                                <ajaxToolkit:AccordionPane ID="accClientInfo" runat="server">
                                    <Header>
                                        <div class="header" style="padding-left: 10px; padding-top: 4px">
                                            <img id="Img3" runat="server" src="~/images/16x16_arrowright_clear.png" align="absmiddle" />&nbsp;&nbsp;<label
                                                class="entryFormat">Client Information</label>
                                        </div>
                                    </Header>
                                    <Content>
                                        <div class="content">
                                            <webPart:ClientInfo ID="wpClientInfo" runat="server" />
                                        </div>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="accAcctSummary" runat="server">
                                    <Header>
                                        <div class="header" style="padding-left: 10px; padding-top: 4px">
                                            <img id="Img4" runat="server" src="~/images/16x16_arrowright_clear.png" align="absmiddle" />&nbsp;&nbsp;<label
                                                class="entryFormat">Account Summary</label>
                                        </div>
                                    </Header>
                                    <Content>
                                        <div class="content">
                                            <webPart:ClientAccountSummary ID="AcctSummary" runat="server" />
                                        </div>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="accCreditorSummary" runat="server">
                                    <Header>
                                        <div class="header" style="padding-left: 10px; padding-top: 4px">
                                            <img id="Img5" runat="server" src="~/images/16x16_arrowright_clear.png" align="absmiddle" />&nbsp;&nbsp;<label
                                                class="entryFormat">Creditor Summary</label>
                                        </div>
                                    </Header>
                                    <Content>
                                        <div class="content">
                                            <webPart:CreditorInfoControl ID="wpCreditorInfoControl" runat="server" />
                                        </div>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="accDocuments" runat="server">
                                    <Header>
                                        <div class="header" style="padding-left: 10px; padding-top: 4px">
                                            <img id="Img6" runat="server" src="~/images/16x16_arrowright_clear.png" align="absmiddle" />&nbsp;&nbsp;<label
                                                class="entryFormat">Documents</label>
                                        </div>
                                    </Header>
                                    <Content>
                                        <div class="content">
                                        </div>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                            </Panes>
                        </ajaxToolkit:Accordion>
                        <div style="height: 35px; padding-left: 2">
                            &nbsp;</div>
                        <asp:Panel Style="padding: 10px" runat="server" ID="pnlRollupCommonTasks" Width="150">
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Common Tasks
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table id="tblRollupCommonTasks" runat="server" class="sideRollupCellBodyTable" cellpadding="0"
                                            cellspacing="7" border="0">
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <div style="height: 20px;">
                                &nbsp;</div>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
            <td valign="top">
                <table class="ibox-container" style="clear: both; padding-top: 5px">
                    <tr>
                        <td colspan="3" class="ibox-container" style="padding: 5px;">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Always">
                                <ContentTemplate>
                                    <ajaxToolkit:TabContainer ID="tabInfo" runat="server" Width="98%" ActiveTabIndex="0"
                                        Height="350px" CssClass="tabContainer">
                                        <ajaxToolkit:TabPanel ID="tabCalc" runat="server">
                                            <HeaderTemplate>
                                                Settlement Calculations
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <webPart:SettlementCalculations ID="SettCalcs" runat="server" />
                                                <asp:Literal ID="lblPayments" runat="server"></asp:Literal>
                                            </ContentTemplate>
                                        </ajaxToolkit:TabPanel>
                                        <ajaxToolkit:TabPanel ID="tabHist" runat="server">
                                            <HeaderTemplate>
                                                Settlement Roadmap
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <webPart:SettlementInformation ID="wpSettlementInformation" runat="server" />
                                            </ContentTemplate>
                                        </ajaxToolkit:TabPanel>
                                        <ajaxToolkit:TabPanel ID="tabNotes" runat="server">
                                            <HeaderTemplate>
                                                Settlement Notes
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <webPart:SettlementNotes ID="SettNotes" runat="server" />
                                            </ContentTemplate>
                                        </ajaxToolkit:TabPanel>
                                        <ajaxToolkit:TabPanel ID="tabPending" runat="server">
                                            <HeaderTemplate>
                                                Pending Settlements
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <webPart:PendingClientSettlements ID="wpPendingSettlement" runat="server" />
                                            </ContentTemplate>
                                        </ajaxToolkit:TabPanel>
                                    </ajaxToolkit:TabContainer>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                                <ContentTemplate>
                                    <div id="updateProcessingProgressDiv" style="display: none; height: 40px; width: 40px">
                                        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                                    </div>
                                    <asp:PlaceHolder runat="server" ID="phWorkflow"></asp:PlaceHolder>
                                    <asp:Panel runat="server" ID="pnlNoWorkflow" Style="text-align: center; color: #a1a1a1;
                                        padding: 0 5 5 5;">
                                        There is no workflow section for this task.</asp:Panel>
                                    <asp:LinkButton ID="lnkRefresh" runat="server"></asp:LinkButton>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hiddenIDs" runat="server" />
    <asp:LinkButton runat="server" ID="lnkAttach" />
    <div id="dvSettVerbal" title="Settlement Approval Call">
        <iframe id="ifrSettVerbal" src="" style="width: 640px; height: 360px;" frameborder="0">
        </iframe>
    </div>
    <script type="text/javascript">
        var closinrecording = false;
        
        try {
            var windowname = '';
            try { windowname = window.top.parent.name.toLowerCase(); }
            catch (e1) {
                document.domain = "dmsi.local";
                windowname = window.top.parent.name.toLowerCase(); 
            } 
          }
        catch (e) { }
        
        function pageLoad() {
            docReady();
        }
        
        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateProcessingProgressDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('upProcessing');

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
            var updateProgressDiv = $get('updateProcessingProgressDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }        
        
        function OpenScanning()
        {       
             var relID = <%=DataClientID %>;
            
             var url = '<%= ResolveUrl("~/processing/popups/scanning.aspx") %>?sid=<%=SettlementID%>&ttypeid=<%=TaskTypeID%>&TimeStamp=' + new Date().getTime();
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Scan Document",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 720, width: 700,
                       onClose: function(){
                                    scanWin = $(this).modaldialog("returnValue");
                                    if (scanWin == -1) {
                                         document.getElementById('<%=lnkRefresh.ClientId %>').click();
                                    }
                                }
                       });   
                       
        }
        
        function docReady() {
            $(document).ready(function() {
                $('.lnkPA').button();
                if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx'))
                {
                    $("#dvSettVerbal").dialog({width: "670", height: "400 !important",
                                    closeOnEscape: false,
                                    autoOpen: false,
                                    modal: true,
                                    resizable: false,
                                    open: function(event, ui) {
                                        $("#ifrSettVerbal").attr("src", '<%= ResolveUrl("~/CallControlsAst/SettlementVerbalAuth.aspx")%>?matterid=<%=MatterID%>&settid=<%=SettlementID%>&rand=' + Math.floor(Math.random() * 99999)); 
                                        },
                                    close: function(){ 
                                        if (!closinrecording){
                                            $("#ifrSettVerbal").get(0).contentWindow.StopRecording('','');
                                        }
                                        $("#ifrSettVerbal").attr("src","");
                                        closinrecording = false;
                                        }});
                } else {
                    $("#dvSettVerbal").hide();
                }
            });
        }

        function OpenRecording()
        {     
             if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                $('#dvSettVerbal').dialog("open");
            } else {
                alert("Call controls not present.");
            }
           return false;
        }
        
        function closeSettDialog(approved){
            if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                if (!closinrecording) {
                    closinrecording = true;
                    $("#dvSettVerbal").dialog("close");
                    if (approved) {
                        document.getElementById('<%=lnkRefresh.ClientId %>').click();
                     } 
                 }
             }
        }
        
        function OpenPABox(settid){
             var url = '<%= ResolveUrl("~/util/pop/PaymentArrangementInfo.aspx?sid=") %>' + settid;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Payment Arrangement Info",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 450, width: 550});
             return false;
        } 
        
        function SendStipulationLetter(settid){
            var url = '<%= ResolveUrl("~/processing/popups/SendStipulationLetter.aspx?sid=") %>' + settid;
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Send Stipulation Letter to Client",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 530, width: 450,
                onClose: function(){
                            if ($(this).modaldialog("returnValue") == -1)
                            {
                                document.getElementById('<%=lnkRefresh.ClientId %>').click();
                            }
                         }
            });
            return false;
        } 
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeprocessing" BehaviorID="processinganimation"
        runat="server" TargetControlID="upProcessing">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />                                                   
                            <%-- fade-out the GridView --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the GridView --%>
                            <FadeIn minimumOpacity=".5" />
                            <%-- re-enable the search button 
                            <EnableAction AnimationTarget="btnSearch" Enabled="true" />
                            --%>  
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
