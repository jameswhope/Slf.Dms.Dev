<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="true"
    CodeFile="default.aspx.vb" Inherits="clients_client_reports_Default" Title="DMP - Client - Reports" %>

<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script src="../../../jscript/reporttemplates.js" type="text/javascript"></script>

    <script src="/aspnet_client/system_web/1_0_3617_0/WebUIValidation.js" type="text/javascript"></script>

    <style type="text/css">
        .acc-header, .acc-selected
        {
            background-color: #3376AB;
            margin-bottom: 2px;
            padding: 5px;
            color: white;
            font-weight: bold;
            cursor: pointer;
            height: 25px;
            vertical-align: middle;
        }
        .acc-content
        {
            margin-bottom: 2px;
            padding: 2px;
        }
        .acc-selected, .acc-content
        {
            border: solid 1px #666666;
        }
        .modalBackgroundRpts
        {
            background-color: #808080;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupRpts
        {
            background-color: #F5FAFD;
            border-width: 1px;
            border-style: ridge;
            border-color: Gray;
            padding: 0px;
            width: 70%;
        }
        .argumentSpan
        {
            width: 100%;
            background-color: #3376AB;
            color: White;
            height: 25px;
            font-size: 10pt;
            font-weight: bold;
            padding: 5px;
        }
        .radiobtn_list input{	float: left;}
        .radiobtn_list label{	margin-left:25px;		display:block;	}
    </style>
  
    <asp:UpdatePanel ID="upReports" runat="server">
        <ContentTemplate>
            <asp:Panel ID="pnlReport" runat="server" CssClass="entry">
                <asp:UpdatePanel ID="pnlUpdate" runat="server">
                    <ContentTemplate>
                        <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
                            height: 100%;" border="0" cellpadding="0" cellspacing="15">
                            <tr>
                                <td style="color: #666666;">
                                    <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a
                                        id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Reports
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" style="height: 100%;">
                                    <div id="divMsg" runat="server" style="width: 50%; display: none" />
                                    <table id="holder" class="entry" border="0">
                                        <tr valign="top">
                                            <td>
                                                <ajaxToolkit:Accordion ID="acReports" runat="server" DataKeyNames="ReportType" ContentCssClass="acc-content"
                                                    HeaderCssClass="acc-header" HeaderSelectedCssClass="acc-selected" CssClass="entry"
                                                    Width="100%" AutoSize="Limit" SuppressHeaderPostbacks="true" FadeTransitions="true"
                                                    TransitionDuration="150" FramesPerSecond="40" Height="500px">
                                                    <HeaderTemplate>
                                                        <span id="spnHdr" runat="server" class="entry2" style="padding: 5px;">
                                                            <%#Eval("ReportType")%>: </span>
                                                    </HeaderTemplate>
                                                    <ContentTemplate>
                                                        <asp:GridView ID="gvReportsChildren" runat="server" EnableViewState="False" AutoGenerateColumns="False"
                                                            AllowPaging="false" DataKeyNames="ReportTypeName" CssClass="fixedHeader" GridLines="None"
                                                            Width="100%">
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <input type="checkbox" id="chk_selectAll" runat="server" />
                                                                    </HeaderTemplate>
                                                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox runat="server" ID="chk_select" />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" VerticalAlign="Top" Width="15px" />
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ReportType" HeaderText="Report Type" Visible="false" />
                                                                <asp:BoundField DataField="ReportName" SortExpression="ReportName" HeaderText="Report Name"
                                                                    ItemStyle-Wrap="true">
                                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                    <ItemStyle Wrap="True" CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Middle" />
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ReportTypeName" HeaderText="Report Type Name">
                                                                    <HeaderStyle CssClass="headItem5" />
                                                                    <ItemStyle Wrap="True" CssClass="listItem" />
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ReportSentDate" SortExpression="ReportSentDate" HeaderText="Report Sent Date"
                                                                    ItemStyle-Wrap="false">
                                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                    <ItemStyle Wrap="False" CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top"
                                                                        Width="125px" />
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ReportArguments" HeaderText="Report Arguments" Visible="false" />
                                                                <asp:BoundField DataField="RequiredFieldsList" HeaderText="Required Fields List"
                                                                    Visible="false" />
                                                            </Columns>
                                                        </asp:GridView>
                                                    </ContentTemplate>
                                                </ajaxToolkit:Accordion>
                                            </td>
                                            <td style="width: 40%;">
                                                <span class="argumentSpan">Report Arguments</span>
                                                <div id="phArgs" runat="server">
                                                    <table class="entry" id="tblClientCreditors" runat="server" style="border-right: gray 1px inset;
                                                        border-top: gray 1px inset; display: none; border-left: gray 1px inset; border-bottom: gray 1px inset;
                                                        background-color: lightgrey" border="0">
                                                        <tbody>
                                                            <tr class="entry">
                                                                <td>
                                                                    <div style="padding-left: 5px; width: 100%; color: white; background-color: #006699">
                                                                        Select Creditor</div>
                                                                    <asp:ListBox runat="server" CssClass="entry2" ID="lstCreditorInstances" Style="width: 100%;
                                                                        height: 150px" DataSourceID="" SelectionMode="Multiple" DataTextField="Name"
                                                                        DataValueField="CurrentCreditorInstanceID" />
                                                                    <%--<asp:SqlDataSource ID="dsCreditors" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                        SelectCommandType="StoredProcedure" SelectCommand="stp_LetterTemplates_GetClientCreditors">
                                                                        <SelectParameters>
                                                                            <asp:QueryStringParameter Name="clientid" QueryStringField="id" />
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>--%>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="entry" id="tblClientSettlements" runat="server" style="border-right: gray 1px inset;
                                                        border-top: gray 1px inset; display: none; border-left: gray 1px inset; border-bottom: gray 1px inset;
                                                        background-color: lightgrey" border="0">
                                                        <tbody>
                                                            <tr class="entry">
                                                                <td>
                                                                    <div style="padding-left: 5px; width: 100%; color: white; background-color: #006699">
                                                                        Select Settlement</div>
                                                                    <asp:ListBox runat="server" CssClass="entry2" ID="lstClientSettlements" Style="width: 100%;
                                                                        height: 150px" DataSourceID="" SelectionMode="Single" DataTextField="SettInfo"
                                                                        DataValueField="SettlementID" />
                                                                    <%--<asp:SqlDataSource ID="dsCreditors" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                        SelectCommandType="StoredProcedure" SelectCommand="stp_LetterTemplates_GetClientCreditors">
                                                                        <SelectParameters>
                                                                            <asp:QueryStringParameter Name="clientid" QueryStringField="id" />
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>--%>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="entry" id="tblLocalCounsel" runat="server" style="border-right: gray 1px inset;
                                                        border-top: gray 1px inset; display: none; border-left: gray 1px inset; border-bottom: gray 1px inset;
                                                        background-color: lightgrey" border="0">
                                                        <tbody>
                                                            <tr class="entry">
                                                                <td>
                                                                    <div style="padding-left: 5px; width: 100%; color: white; background-color: #006699">
                                                                        Select Local Counsel</div>
                                                                    <asp:dropdownlist runat="server" CssClass="entry2" ID="lstLocalCounsel" Style="width: 100%;
                                                                        height: 150px" DataSourceID="" SelectionMode="Single" DataTextField="LocalCounselName"
                                                                        DataValueField="attorneyid" />
                                                                    <%--<asp:SqlDataSource ID="dsCreditors" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                        SelectCommandType="StoredProcedure" SelectCommand="stp_LetterTemplates_GetClientCreditors">
                                                                        <SelectParameters>
                                                                            <asp:QueryStringParameter Name="clientid" QueryStringField="id" />
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>--%>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="entry" id="tblReasonList" runat="server" style="border-right: gray 1px inset;
                                                        border-top: gray 1px inset; display: none; border-left: gray 1px inset; border-bottom: gray 1px inset;
                                                        background-color: lightgrey" border="0">
                                                        <tbody>
                                                            <tr class="entry">
                                                                <td>
                                                                    <div style="padding-left: 5px; width: 100%; color: white; background-color: #006699">
                                                                        Select Reason</div>
                                                                    <asp:RadioButtonList runat="server" CssClass="entry2" ID="ddlReason" Style="width: 100%;
                                                                        height: 150px" DataSourceID="" SelectionMode="Single" DataTextField="reasondesc"
                                                                        DataValueField="reasonID"  />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
                TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
                BackgroundCssClass="modalBackgroundRpts" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle"
                CancelControlID="hideModalPopupViaServer">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel runat="server" CssClass="modalPopupRpts" ID="programmaticPopup" Style="display: none;
                padding: 0px">
                <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #D6E7F3;
                    border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
                    <div id="dvCloseMenu" runat="server" style="width: 100%; height: 25px; background-color: white;
                        z-index: 51; text-align: right;">
                        <asp:LinkButton runat="server" Font-Size="Medium" Font-Bold="true" ID="hideModalPopupViaServer"
                            Text="Close" Style="padding: 5px;" />
                    </div>
                </asp:Panel>
                <asp:Panel runat="Server" ID="pnlRpt">
                    <div id="dvReport" runat="server" style="height: 440px; z-index: 51; visibility: visible;
                        background-color: Transparent;">
                        <iframe id="frmReport" runat="server" src="report.aspx" style="width: 100%; height: 100%;"
                            frameborder="0" />
                    </div>
                </asp:Panel>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkPrint" EventName="Click" />
            <%--<asp:PostBackTrigger ControlID="lnkPrint" />--%>
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="lnkPrint" runat="server" />
    <asp:HiddenField ID="sortDir" runat="server" />
    <div id="updateReportDiv" style="display: none; height: 40px; width: 40px">
        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
    </div>

    <script type="text/javascript">
        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateReportDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get("<%=tblBody.ClientID %>");

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
            var updateProgressDiv = $get('updateReportDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
        function pageLoad() {
            //            var acc = $get("<%= acReports.ClientID %>");
            //            AddMouseOverToAccordion(acc);

        }
       
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeReports" BehaviorID="reportsanimation"
        runat="server" TargetControlID="upReports">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="tblBody" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="tblBody" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>

    <script type="text/javascript" language="javascript">
        var intCount = 0;       //keeps track of number of creditor param requests, >0 =show creditor selection
        var intSettCount = 0;       //keeps track of number of settlement param requests, >0 =show settlement selection
        var intLocalCount = 0;       //keeps track of number of local counsel param requests, >0 =show settlement selection
        var intNondepositCount = 0;       //keeps track of number of local counsel param requests, >0 =show settlement selection
        function chk_Select(chkObject, pnlObject, bCreditorNeeded, bSettlementsNeeded, bLocalCounselNeeded, bNonDepositReasonNeeded) {

            var pnl = document.getElementById(pnlObject);                                       //panel to show/hide
            var credpnl = document.getElementById("<%= tblClientCreditors.CLientID %>");        //creditor panel
            var settpnl = document.getElementById("<%= tblClientSettlements.CLientID %>");        //settlement panel
            var localpnl = document.getElementById("<%= tblLocalCounsel.CLientID %>");        //local Counsel panel
            var nondepositpnl = document.getElementById("<%= tblReasonList.CLientID %>");        //Nondeposit reason panel
            var ph = document.getElementById('phArgs');                                         //arg panel

            if (chkObject.checked == true) {
                pnl.style.display = 'block';                                                    //toggle display;(pnl.style.display != 'block' ? 'block' : 'none' )
                if (bCreditorNeeded == 'True') {
                    credpnl.style.display = 'block';
                    intCount += 1;
                } else {
                    credpnl.style.display = 'none';
                    intCount -= 1;
                }
                if (bSettlementsNeeded == 'True') {
                    settpnl.style.display = 'block';
                    intSettCount += 1;
                } else {
                    settpnl.style.display = 'none';
                    intSettCount -= 1;
                }
                if (bLocalCounselNeeded == 'True') {
                    localpnl.style.display = 'block';
                    intLocalCount += 1;
                } else {
                    localpnl.style.display = 'none';
                    intLocalCount -= 1;
                }
                 if (bNonDepositReasonNeeded == 'True') {
                    nondepositpnl.style.display = 'block';
                    intNondepositCount += 1;
                } else {
                    nondepositpnl.style.display = 'none';
                    intNondepositCount -= 1;
                }
            } else {
                pnl.style.display = 'none';                                                     //toggle display;
                if (bCreditorNeeded == 'True') {
                    credpnl.style.display = (credpnl.style.display != 'none' ? 'none' : '');   //toggle display;
                    intCount -= 1;
                }
                if (bSettlementsNeeded == 'True') {
                    settpnl.style.display = (settpnl.style.display != 'none' ? 'none' : '');   //toggle display;
                    intSettCount -= 1;
                }
                 if (bLocalCounselNeeded == 'True') {
                    localpnl.style.display = (localpnl.style.display != 'none' ? 'none' : '');   //toggle display;
                    intLocalCount -= 1;
                }
                if (bNonDepositReasonNeeded == 'True') {
                    nondepositpnl.style.display = (nondepositpnl.style.display != 'none' ? 'none' : '');   //toggle display;
                    intNondepositCount -= 1;
                }
            }
            
            if (intCount <= 0) {                                                                //if no creditor param needed hide creditor panel
                credpnl.style.display = 'none';
                intCount = 0
            } else {
                credpnl.style.display = 'block';
            }
            if (intSettCount <= 0) {                                                                //if no creditor param needed hide creditor panel
                settpnl.style.display = 'none';
                intSettCount = 0
            } else {
                settpnl.style.display = 'block';
            }
            if (intLocalCount <= 0) {                                                                //if no creditor param needed hide creditor panel
                localpnl.style.display = 'none';
                intLocalCount = 0
            } else {
                localpnl.style.display = 'block';
            }
            if (intNondepositCount <= 0) {                                                                //if no creditor param needed hide creditor panel
                nondepositpnl.style.display = 'none';
                intNondepositCount = 0
            } else {
                nondepositpnl.style.display = 'block';
            }
        }

        function Print_Reports() {
            //print reports
            var rptFrame = $get("<%=frmReport.ClientID %>");
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            var acc = $get("<%= acReports.ClientID %>");
            var credlist = $get("<%=lstCreditorInstances.ClientID %>");
            var settlist = $get("<%=lstClientSettlements.ClientID %>");
            var locallist = $get("<%=lstLocalCounsel.ClientID %>");
            var nondepositlist = $get("<%= ddlReason.CLientID %>");        //Nondeposit reason panel
            buildReports(rptFrame,modalPopupBehavior,acc,credlist,settlist,locallist,nondepositlist);
            //below is the server postback version
            //<%= ClientScript.GetPostBackEventReference(lnkPrint, Nothing) %>;
        }
       
 function buildReports(reportFrameObject, modalPopupObject, accordionObject, creditorListObject, settlementListObject, localcounselListObject,nondepositlistObject) {
    try {
        var rptsCol = new ActiveXObject("Scripting.Dictionary");
        
        reportFrameObject.src = '';

        for (paneIdx = 0; paneIdx < accordionObject.AccordionBehavior.get_Count(); paneIdx++) {
            var pane = accordionObject.AccordionBehavior.get_Pane(paneIdx)
            var pContent = pane.content;
            var grids = pContent.getElementsByTagName('table');
            var rCount = grids[0].rows.length;
            var rowIdx = 1;
            for (rowIdx; rowIdx <= rCount - 1; rowIdx++) {
                var rowElement = grids[0].rows[rowIdx];
                var chkBox = rowElement.cells[0].firstChild;
                if (chkBox.checked == true) {
                    var sRpt = rowElement.id;
                    var rptNameInfo = sRpt.split('_');
                    
                    for (x in ReportArgsArray) {
                        var ReportInfo = ReportArgsArray[x].split('|');
                        var cName = ReportInfo[0];
                        if (cName == rptNameInfo[1]) {
                            //got the report & args
                            var strArgs = formatArguments(ReportInfo[1]);
                            if (ValidateReportArguments(strArgs)==true){
                                if (strArgs.indexOf('CreditorInstanceIDsCommaSeparated') != -1) {
                                    var creditors = getSelectedCreditors(creditorListObject);
                                    var credids = creditors.split(",");
                                    if (credids.length > 0) {
                                        for (c in credids) {
                                            strArgs = formatArguments(ReportInfo[1]);
                                            strArgs = strArgs.replace("CreditorInstanceIDsCommaSeparated", credids[c]);
                                            //get the args
                                            var rptArgTbl = 'ctl00_ctl00_cphBody_cphBody_tbl_' + sRpt;
                                            var argRows = document.getElementById(rptArgTbl).rows;
                                            strArgs = extractArguments(argRows,strArgs)
                                           rptsCol.add(rptNameInfo[1] + '_' + credids[c], rptNameInfo[1] + '_' + strArgs)
                                        }
                                    }
                                } else if (strArgs.indexOf('SettlementID') != -1) {
                                //get settlement id
                                    var settid = getSelectedCreditors(settlementListObject);
                                    if (settid ==''){
                                        settid = 0;
                                    }
                                    
                                    strArgs = formatArguments(ReportInfo[1]);
                                    strArgs = strArgs.replace("SettlementID", settid);
                                    //get the args
                                    var rptArgTbl = 'ctl00_ctl00_cphBody_cphBody_tbl_' + sRpt;
                                    var argRows = document.getElementById(rptArgTbl).rows;
                                    strArgs = extractArguments(argRows,strArgs)
                                    rptsCol.add(rptNameInfo[1] + '_' + settid, rptNameInfo[1] + '_' + strArgs)
                                } else if (strArgs.indexOf('LocalCounselAttorneyID') != -1) {
                                //get local counsel id
                                    var attid = getSelectedCreditors(localcounselListObject);
                                    if (attid ==''){
                                        attid = 0;
                                    }
                                    strArgs = formatArguments(ReportInfo[1]);
                                    strArgs = strArgs.replace("LocalCounselAttorneyID", attid);
                                    //get the args
                                    var rptArgTbl = 'ctl00_ctl00_cphBody_cphBody_tbl_' + sRpt;
                                    var argRows = document.getElementById(rptArgTbl).rows;
                                    strArgs = extractArguments(argRows,strArgs)
                                    rptsCol.add(rptNameInfo[1] + '_' + settid, rptNameInfo[1] + '_' + strArgs)
                                } else if (strArgs.indexOf('ReasonID') != -1) {
                                //get Reason ID 
                                    var reasonid = extractSelectedFromRBLTable(nondepositlistObject);//getSelectedCreditors(nondepositlistObject);
                                    if (reasonid ==''){
                                        reasonid = 0;
                                    }
                                    strArgs = formatArguments(ReportInfo[1]);
                                    strArgs = strArgs.replace("ReasonID", reasonid);
                                    //get the args
                                    var rptArgTbl = 'ctl00_ctl00_cphBody_cphBody_tbl_' + sRpt;
                                    var argRows = document.getElementById(rptArgTbl).rows;
                                    strArgs = extractArguments(argRows,strArgs)
                                    rptsCol.add(rptNameInfo[1] + '_' + settid, rptNameInfo[1] + '_' + strArgs)                                    
                                } else {
                                        //get the args
                                        var rptArgTbl = 'ctl00_ctl00_cphBody_cphBody_tbl_' + sRpt;
                                        var argRows = document.getElementById(rptArgTbl).rows;
                                        strArgs = extractArguments(argRows,strArgs)
                                        if (strArgs != '') {
                                            rptsCol.add(rptNameInfo[1], rptNameInfo[1] + '_' + strArgs)
                                        } else {
                                            rptsCol.add(rptNameInfo[1], rptNameInfo[1])
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //if (Page_IsValid){
            var reportURL = new String();
            var reports = new String();
            var rptArray = (new VBArray(rptsCol.Keys())).toArray();
            var argArray = (new VBArray(rptsCol.Items())).toArray();
            for (i in rptArray) {
                //reports += argArray[i] + '|'
                reports += argArray[i] 
                var docid = '<%=AddDocIDToReportArguments() %>';
                reports +=  '_' + docid + '|'
            }
            reportURL= '?clientid=' + <%=DataClientID.ToString() %> + '&reports=' + escape(reports) + '&user=' + <%=UserID.ToString() %>;
            reportFrameObject.src = 'report.aspx' + reportURL;
            modalPopupObject.show();
        //}

    }
    catch (e) {
        alert(e.message);
    }
}       

     

       
      
    </script>

</asp:Content>
