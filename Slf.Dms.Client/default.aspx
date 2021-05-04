<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="default.aspx.vb"
    Inherits="_default" Title="DMP - Home" EnableEventValidation="false" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Import Namespace="Drg.Util.DataHelpers" %>
<%@ Import Namespace="Drg.Util.DataAccess" %>
<%@ Register TagPrefix="cc1" Namespace="AssistedSolutions.WebControls" Assembly="AssistedSolutions.WebControls.InputMask" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Register Src="CustomTools/UserControls/Verification.ascx" TagName="Verification" TagPrefix="uc1" %>
<%@ Register Src="CustomTools/UserControls/SwitchUserGroup.ascx" TagName="SwitchUserGroup" TagPrefix="uc2" %>
<%--<%@ Register src="CustomTools/UserControls/RecentDialerCalls.ascx" tagname="RecentDialerCalls" tagprefix="uc3" %>--%>
<%@ Register src="CustomTools/UserControls/SettlementProcessing.ascx" tagname="SettlementProcessing" tagprefix="uc4" %>
<%@ Register src="CustomTools/UserControls/NonDepositControl.ascx" tagname="NonDepositControl" tagprefix="uc5" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>

    <style type="text/css">
	thead th{
		position:relative; 
		top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
	}
	.divSwitch table{font-family:Tahoma; font-size:11px;}
	.divSwitch select{font-family:Tahoma; font-size:11px;}
	</style>
    <asp:Panel ID="pnlMenuAgency" runat="server" Visible="false">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td>
                    <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
                <td nowrap="true">
                    <a class="menuButton" href="~/agency/default.aspx" runat="server">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_accounts.png" />Payment
                        Dashboard</a>
                </td>
                <td class="menuSeparator">
                    |
                </td>
                <td nowrap="true">
                    <a class="menuButton" href="~/agency/paymentsummary.aspx" runat="server">
                        <img id="Img46" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_graph.png" />Payment Summary</a>
                </td>
                <td class="menuSeparator">
                    |
                </td>
                <td nowrap="true">
                    <a class="menuButton" href="~/agency/comparison.aspx" runat="server">
                        <img id="Img47" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_chart_bar.png" />Daily Comparison</a>
                </td>
                <td>
                    |
                </td>
                <td nowrap="true">
                    <a class="menuButton" href="agency/client_retention.aspx">
                        <img id="Img48" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_graph.png" />Client Retention</a>
                </td>
                <td style="width: 100%;">
                    &nbsp;
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlMenuAttorney" runat="server">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td>
                    <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
                <td nowrap="true">
                    <a id="A4" class="menuButton" href="~/research/queries/clients/attorney.aspx" runat="server">
                        <img id="Img5" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_person.png" />My Clients</a>
                </td>
                <td style="width: 100%;">
                    &nbsp;
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlMenuAgent" runat="server">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td>
                    <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
                <td nowrap="true">
                    <a id="A1" class="menuButton" href="~/research/queries/clients/agency.aspx" runat="server">
                        <img id="Img1" alt="" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_person.png" />My Clients</a>
                </td>
                <td class="menuSeparator">
                    |
                </td>
                <td nowrap="true" id="tdReferNewClients" runat="server">
                    <a id="A2" class="menuButton" href="~/clients/new/agencydefault.aspx" runat="server">
                        <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_person_add.png" />Refer Clients</a>
                </td>
                <asp:PlaceHolder ID="phMenuServiceFees" runat="server">
                    <td class="menuSeparator">
                        |
                    </td>
                    <td nowrap="true">
                        <a id="A3" class="menuButton" href="~/research/reports/financial/servicefees/agency.aspx"
                            runat="server">
                            <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_trust.png" />Service Fees</a>
                    </td>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phMenuBatchPayment" runat="server">
                    <td class="menuSeparator">
                        |
                    </td>
                    <td nowrap="true">
                        <a id="A5" class="menuButton" href="~/research/reports/financial/commission/batchpaymentsagency.aspx"
                            runat="server">
                            <img id="Img4" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_trust.png" />Batches</a>
                    </td>
                </asp:PlaceHolder>
                <td style="width: 100%;">
                    &nbsp;
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td>
                    <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
                <asp:PlaceHolder ID="pnlEnrollNewClient" runat="server">
                    <td nowrap="true">
                        <a id="A6" class="menuButton" href="~/clients/new" runat="server">
                            <img id="Img6" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_person.png" />Screen New Client</a>
                    </td>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="pnlValidateCreditors" runat="server" Visible="false">
                    <td class="menuSeparator">
                        |
                    </td>
                    <td nowrap="true">
                        <a class="menuButton" href="~/admin/creditors/creditorvalidation.aspx" runat="server">
                            <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_check.png" /><asp:Label
                                ID="lblValidateCreditors" runat="server" Text="Validate Creditors"></asp:Label></a>
                    </td>
                </asp:PlaceHolder>
                <!--<td nowrap="true" id="tdAddNewTask" runat="server">
                    <a id="A7" class="menuButton" runat="server" href="~/tasks/task/new.aspx">
                        <img id="Img7" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_calendar_add.png" />Add New Task</a></td>-->
                <td style="width: 100%;">
                    &nbsp;
                </td>
                <td nowrap="true" id="tdSearch" runat="server">
                    <a id="A8" runat="server" class="menuButton" href="~/search.aspx">
                        <img id="Img8" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_search.png" />Search</a>
                </td>
                <td>
                    <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">
		function RowHover2(tbl, over)
		{
			var obj = event.srcElement;
		    
			if (obj.tagName == "IMG")
				obj = obj.parentElement;
		        
			if (obj.tagName == "TD")
			{
				//remove hover from last tr
				if (tbl.getAttribute("lastTr") != null)
				{
					tbl.getAttribute("lastTr").style.backgroundColor = "#ffffff";
				}

				//if the mouse is over the table, set hover to current tr
				if (over)
				{
					var curTr = obj.parentElement;
					curTr.style.backgroundColor = "#f3f3f3";
					tbl.setAttribute("lastTr", curTr);
				}
			}
		}
		function RowClick_Roadmap(tr, ClientStatusId)
		{
			var txt = document.getElementById("<%=txtRoadmap_ClientStatusId.ClientID %>");
			txt.value = ClientStatusId;
			<%=Page.ClientScript.GetPostBackEventReference(lnkSearch_Roadmap, Nothing) %>;
		}
    </script>

    <asp:Panel runat="server" ID="pnlBodyDefault">
        <body>

            <script type="text/javascript">
            function ShowResult(queryid)
            {
                window.open("<%=ResolveUrl("~/queryresultsholder.aspx") %>?queryid=" + queryid,"winQueryResults","width=800,height=600,left=75,top=100,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes",true);
            }
            function SetKeyPress()
            {
                var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
                if (txtTransDate1 != null)
                {
                    txtTransDate1.OnKeyPress = SetCustom;
                    AddHandler(txtTransDate1, "keypress", "OnKeyPress");

                    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
                    txtTransDate2.OnKeyPress = SetCustom;
                    AddHandler(txtTransDate2, "keypress", "OnKeyPress");
                }
            }
            function RowHover(td, on)
            {
                if (on)
	                td.parentElement.style.backgroundColor = "#f3f3f3";
                else
	                td.parentElement.style.backgroundColor = "#ffffff";
            }
            function TaskClick(TaskID)
            {
                window.navigate("<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);
            }
            function SettlementClick(TaskId)
            {
                window.navigate('<%= ResolveUrl("~/processing/TaskSummary/default.aspx") %>?id=' + TaskId );   
            }
            function ClientClick(ClientID)
            {
                window.navigate("<%= ResolveUrl("~/clients/client/?id=") %>" + ClientID);

                window.event.cancelBubble = true;

                return false;
            }
            
            function popupFeeAdjustment(id)
            {
                var r=  showModalDialog('<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Settlement Processing Confirmation&sid='+ id +'&p=<%= ResolveUrl("~/processing/popups/ProcessSettlement.aspx") %>', window, 'status:off;help:off;dialogWidth:390px;dialogHeight:300px');
                  if(r==-1)
                   {
                    window.location =window.location.href.replace(/#/g,"") ;  
                   }
            }
         
            function OpenDocument(path) {
                var filepath = "file:"+path;
                window.open(filepath);
                return false;
            }
            

    
            function AddHandler(eventSource, eventName, handlerName, eventParent)
            {
                // TODO: factor into the event function so multiple parents are possible
                //if (eventParent != null)
                //	eventSource.parent = eventParent;
                var eventHandler = function(e) {eventSource[handlerName](e, eventParent);};
            	
                if (eventSource.addEventListener)
                {
	                eventSource.addEventListener(eventName, eventHandler, false);
                }
                else if (eventSource.attachEvent)
                { 
	                eventSource.attachEvent("on" + eventName, eventHandler);
                }
                else
                {
	                var originalHandler = eventSource["on" + eventName];
            		
	                if (originalHandler)
	                {
		                eventHandler = function(e) {originalHandler(e); eventSource[handlerName](e, eventParent);};
	                }

	                eventSource["on" + eventName] = eventHandler;
                }
            }
            </script>

            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
                        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
                            <tr>
                                <td valign="top" style="width: 150px">
                                    <table style="table-layout: fixed; font-family: tahoma; font-size: 11px; width: 180px;"
                                        cellpadding="5" cellspacing="0" border="0">
                                        <asp:PlaceHolder ID="pnlSearch" runat="server">
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Search
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%" cellpadding="0"
                                                        cellspacing="5" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox runat="server" ID="txtSearch" CssClass="entry"></asp:TextBox>
                                                            </td>
                                                            <td style="width: 16;">
                                                                <asp:LinkButton runat="server" ID="lnkSearch">
                                                                    <img id="Img9" src="~/images/16x16_arrowright_clear.png" runat="server" align="absmiddle"
                                                                        border="0" /></asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 0 5 10 10; color: #a1a1a1; font-style: italic;">
                                                    Previous search terms...
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rpSearches" runat="server">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td nowrap="true" style="padding: 0 5 5 20;">
                                                            <li>
                                                                <asp:LinkButton ID="Linkbutton1" runat="server" CssClass="lnk" Style="color: Black;"
                                                                    CommandName="Search" CommandArgument='<%#DataBinder.Eval(Container.DataItem, "Terms")%>'><%#DataBinder.Eval(Container.DataItem, "Terms")%></asp:LinkButton></li>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <tr runat="server" id="trNoSearches">
                                                <td style="padding: 0 5 5 20;">
                                                    <li><font style="color: #a1a1a1;"><em>No Previous Searches</em></font></li>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="pnlSearchMyClients" runat="server">
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Search My Clients
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%" cellpadding="0"
                                                        cellspacing="5" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox runat="server" ID="txtSearchMyClients" CssClass="entry"></asp:TextBox>
                                                            </td>
                                                            <td style="width: 16;">
                                                                <asp:LinkButton runat="server" ID="lnkSearchMyClients">
                                                                    <img id="Img10" src="~/images/16x16_arrowright_clear.png" runat="server" align="absmiddle"
                                                                        border="0" /></asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phSearchMyClientsAttorney" runat="server">
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Search My Clients
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%" cellpadding="0"
                                                        cellspacing="5" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox runat="server" ID="txtSearchMyClientsAttorney" CssClass="entry"></asp:TextBox>
                                                            </td>
                                                            <td style="width: 16;">
                                                                <asp:LinkButton runat="server" ID="lnkSearchMyClientsAttorney">
                                                                    <img id="Img11" src="~/images/16x16_arrowright_clear.png" runat="server" align="absmiddle"
                                                                        border="0" /></asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <%--                                        <asp:PlaceHolder ID="phReceivables" runat="server">
                                        <tr>
                                            <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-x;background-position:left center;"><img height="20" width="1" runat="server" src="~/images/spacer.gif" /></td>
                                        </tr>
                                        <tr>
                                            <td style="background-color:#f1f1f1;font-weight:bold;">Receivables</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a class="lnk" href="<%=ResolveUrl("~/research/queries/financial/servicefees/remainingreceivables.aspx") %>" >As of&nbsp;<asp:Literal ID="lblNow" runat="server"></asp:literal>:&nbsp;&nbsp;<asp:Literal ID="lblReceivables" runat="server"></asp:literal></a>
                                            </td>
                                        </tr>
                                        
                                        </asp:PlaceHolder>--%>
                                        <asp:PlaceHolder ID="phBatches" runat="server">
                                            <tr>
                                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                                    background-position: left center;">
                                                    <img id="Img12" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Commission&nbsp;<a class="lnk" href="<%=ResolveURL("~/research/reports/financial/commission/batchpaymentsagency.aspx") %>"
                                                        style="font-weight: normal">(All Batches)</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="width: 100%;">
                                                    <iframe id="ifmBatches" style="width: 100%;" frameborder="0" scrolling="no"></iframe>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phAgencyScenarios" runat="server" Visible="false">
                                            <tr>
                                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                                    background-position: left center;">
                                                    <img id="Img42" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="width: 100%;">
                                                    <a class="lnk" href='<%=ResolveUrl("~/agencyscenarios.aspx?id=" & AgencyId)%>'>
                                                        <img id="Img43" style="margin-right: 5;" src="~/images/16x16_cheque.png" runat="server"
                                                            border="0" align="absmiddle" />Fee Scenarios</a>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phRecentVisits" runat="server">
                                            <tr>
                                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                                    background-position: left center;">
                                                    <img id="Img14" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 0 5 15 5;">
                                                    <a id="A9" runat="server" class="lnk" href="~/">Recent Visits</a>
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rpVisits" runat="server">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td nowrap="true" style="padding: 0 5 5 20;">
                                                            <li><a class="lnk" href="<%= ResolveUrl("~/") %><%#DataBinder.Eval(Container.DataItem, "Link")%>">
                                                                <img style="margin-right: 5;" border="0" align="absmiddle" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "Icon")%>" /><%#DataBinder.Eval(Container.DataItem, "Display")%></a></li>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <tr runat="server" id="trNoVisits">
                                                <td style="text-align: center; font-style: italic; padding: 0 5 5 5;">
                                                    You have no recent visits
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phSwitchGroup" runat="server">
                                            <tr>
                                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                                    background-position: left center;">
                                                    <img id="ImgSG" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Switch Group
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trSG">
                                                <td style="text-align: center; font-size: 11px; font-style: italic; padding: 0 5 5 5;">
                                                    <div class="divSwitch">
                                                        <uc2:SwitchUserGroup ID="SwitchUserGroup1" runat="server" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
<%--                                        <asp:PlaceHolder ID="phRecentDialerCalls" runat="server">
                                            <tr>
                                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                                    background-position: left center;">
                                                    <img id="Img77" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #f1f1f1; font-weight: bold;">
                                                    Recent Dialer Calls
                                                </td>
                                            </tr>
                                            <tr runat="server" id="trRDC">
                                                <td style="text-align: center; font-size: 11px; font-style: italic; padding: 0 5 5 5;">
                                                    <div class="divSwitch">
                                                        <uc3:RecentDialerCalls ID="RDC" runat="server" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>--%>
                                    </table>
                                </td>
                                <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-y;
                                    background-position: center top;">
                                    <img id="Img15" width="3" height="1" runat="server" src="~/images/spacer.gif" />
                                </td>
                                <td valign="top" style="width: 90%;">
                                    <uc1:Verification ID="Verification1" runat="server" />
                                    <uc4:SettlementProcessing ID="SettlementProcessing1" runat="server" />
                                    <uc5:NonDepositControl ID="NonDepositControl1" runat="server" />
                                    <%-- <asp:placeholder id="phClientsPendingReview" runat="server">
    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="background-color:#f5f5f5;padding: 2 5 2 5;">
                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td nowrap="true">Clients Pending Review</td>
                        <td align="right" style="width:100%" ><asp:DropDownList ID="cboAgencyID" runat="server" style="font-family:Tahoma;font-size:11px" AutoPostBack="true"></asp:DropDownList></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asi:StandardGrid2 ID="grdClientsPendingReview" XmlSchemaFile="~/standardgrids.xml" runat="server"></asi:StandardGrid2>
    <div><img id="Img7" runat="server" src="~/images/spacer.gif" height="25" width="1"/></div>
</asp:placeholder>--%>
                                    <asi:TabStrip runat="server" ID="tsTasksView">
                                    </asi:TabStrip>
                                    <div id="phTasks" runat="server" style="display: none">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <a style="color: black;" runat="server" class="lnk" href="~/tasks">Individual Tasks</a>
                                                            </td>
                                                            <td align="right">
                                                                <asp:CheckBox AutoPostBack="true" runat="server" ID="chkOpenOnly" Text=" Open Only" /><asp:PlaceHolder
                                                                    ID="pnlSearchTasks" runat="server">&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A11" runat="server"
                                                                        href="~/search.aspx"><img id="Img16" runat="server" src="~/images/16x16_find.png"
                                                                            border="0" align="absmiddle" /></a></asp:PlaceHolder>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <div id="dvUpcomingTasks" runat="server">
                                                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                                                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                            <tr>
                                                                <td class="headItem" style="width: 25;" align="center">
                                                                    <img id="Img17" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 75">
                                                                    Due<img id="Img18" style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png"
                                                                        border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 95;">
                                                                    Client
                                                                </td>
                                                                <td class="headItem" style="width: 70;">
                                                                    Language
                                                                </td>
                                                                <td class="headItem" style="width: 70;">
                                                                    Client State
                                                                </td>
                                                                <td class="headItem">
                                                                    Task
                                                                </td>
                                                                <td class="headItem" style="width: 70;">
                                                                    Status
                                                                </td>
                                                            </tr>
                                                            <asp:Repeater ID="rpUpcomingTasks" runat="server">
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <img id="Img19" runat="server" src="~/images/16x16_calendar.png" border="0" />
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).DueDate.ToString("MMM d, yy")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                            <a class="lnk" href="#" onclick="ClientClick(<%#CType(Container.DataItem, GridTask).ClientId%>);">
                                                                                <%#CType(Container.DataItem, GridTask).Client%>
                                                                            </a>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).Language%>
                                                                        </td>
                                                                          <td align="center" onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).ClientState%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).TaskDescription%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).Status%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </table>
                                                    </div>
                                                    <asp:Panel runat="server" ID="pnlNoUpcomingTasks" Style="text-align: center; font-style: italic;
                                                        padding: 10 5 5 5;">
                                                        You have no upcoming tasks</asp:Panel>
                                                    <input type="hidden" runat="server" id="hdnTasksCount" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <%--Time Matters Code Starts--%>
                                    <div id="phTeamTasks" runat="server" style="display: none">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <a style="color: black;" runat="server" class="lnk" href="~/tasks?type=T">Team Tasks</a>
                                                            </td>
                                                            <td align="right">
                                                                <asp:LinkButton ID="lnkUpdateTaskUsers" CssClass="lnk" runat="server" Text="Assign Task"></asp:LinkButton>
                                                                &nbsp;&nbsp;<asp:CheckBox AutoPostBack="true" runat="server" ID="chkTeamOpenOnly"
                                                                    Text=" Open Only" /><asp:PlaceHolder ID="pnlSearchTeamTasks" runat="server">&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                                                        id="A15" runat="server" href="~/search.aspx"><img id="Img71" runat="server" src="~/images/16x16_find.png"
                                                                            border="0" align="absmiddle" /></a></asp:PlaceHolder>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <div id="dvTeamTasks" runat="server">
                                                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                                                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                            <tr>
                                                                <td class="headItem" style="width: 25;" align="center">
                                                                    <img id="Img13" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 50">
                                                                    Due<img id="Img33" style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png"
                                                                        border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 60;">
                                                                    Client
                                                                </td>
                                                                <td class="headItem" style="width: 70;">
                                                                    Language
                                                                </td>
                                                                <td class="headItem" style="width: 70;">
                                                                    Client State
                                                                </td>
                                                                <td class="headItem" style="width: 100;">
                                                                    Task
                                                                </td>
                                                                <td class="headItem" style="width: 90;">
                                                                    Created By
                                                                </td>
                                                                <td class="headItem" style="width: 90;">
                                                                    Assigned To Group
                                                                </td>
                                                                <td class="headItem" style="width: 100;" id="tdAssignHeader" runat="server">
                                                                    Assigned To
                                                                </td>
                                                                <td class="headItem" style="width: 50;">
                                                                    Status
                                                                </td>
                                                            </tr>
                                                            <asp:Repeater ID="rpTeamTasks" runat="server">
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <img id="Img19" runat="server" src="~/images/16x16_calendar.png" border="0" />
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).DueDate.ToString("MMM d, yy")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                            <a class="lnk" href="#" onclick="ClientClick(<%#CType(Container.DataItem, GridTask).ClientId%>);">
                                                                                <%#CType(Container.DataItem, GridTask).Client%>
                                                                            </a>
                                                                        </td>
                                                                         <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).Language%>
                                                                        </td>
                                                                          <td align="center" onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).ClientState%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).TaskDescription%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).CreatedBy%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).AssignedToGroupName%>
                                                                        </td>
                                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                                            nowrap="true" id="tdAssignItem" runat="server">
                                                                            <input type="hidden" id="hdnTaskID" runat="server" value='<%#CType(Container.DataItem, GridTask).TaskID%>' />
                                                                            <asp:DropDownList CssClass="entry" ID="ddlGroupUsers" Width="100px" runat="server">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).Status%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </table>
                                                    </div>
                                                    <asp:Panel runat="server" ID="pnlNoTeamTasks" Style="text-align: center; font-style: italic;
                                                        padding: 10 5 5 5;">
                                                        You have no team tasks</asp:Panel>
                                                    <input type="hidden" runat="server" id="hdnTeamTasksCount" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div id="phManagerTasks" runat="server" style="display: none">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <a style="color: black;" runat="server" class="lnk" href="~/tasks?type=M">Tasks Created
                                                                    by Manager</a>
                                                            </td>
                                                            <td align="right">
                                                                <asp:CheckBox AutoPostBack="true" runat="server" ID="chkManagerOpenOnly" Text=" Open Only" /><asp:PlaceHolder
                                                                    ID="pnlSearchManagerTasks" runat="server">&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A17" runat="server"
                                                                        href="~/search.aspx"><img id="Img40" runat="server" src="~/images/16x16_find.png"
                                                                            border="0" align="absmiddle" /></a></asp:PlaceHolder>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <div id="dvManagerTasks" runat="server">
                                                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                                                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                            <tr>
                                                                <td class="headItem" style="width: 25;" align="center">
                                                                    <img id="Img41" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 50">
                                                                    Due<img id="Img49" style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png"
                                                                        border="0" align="absmiddle" />
                                                                </td>
                                                                <td class="headItem" style="width: 55;">
                                                                    Client
                                                                </td>
                                                                <td class="headItem" style="width: 100;">
                                                                    Task
                                                                </td>
                                                                <td class="headItem" style="width: 95;">
                                                                    Created By
                                                                </td>
                                                                <td class="headItem" style="width: 100;">
                                                                    Asigned To
                                                                </td>
                                                                <td class="headItem" style="width: 50;">
                                                                    Status
                                                                </td>
                                                            </tr>
                                                            <asp:Repeater ID="rpManagerTasks" runat="server">
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <img id="Img19" runat="server" src="~/images/16x16_calendar.png" border="0" />
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#DataBinder.Eval(Container.DataItem, "Due", "{0:MMM d, yy}")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" nowrap="true"
                                                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                            <a class="lnk" href="#" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);">
                                                                                <%#DataBinder.Eval(Container.DataItem, "Client")%>
                                                                            </a>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#DataBinder.Eval(Container.DataItem, "TypeOrDescription")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#DataBinder.Eval(Container.DataItem, "CreatedByName")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#DataBinder.Eval(Container.DataItem, "AssignedToName")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#DataBinder.Eval(Container.DataItem, "TaskID")%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#DataBinder.Eval(Container.DataItem, "StatusFormatted")%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </table>
                                                    </div>
                                                    <asp:Panel runat="server" ID="pnlNoManagerTasks" Style="text-align: center; font-style: italic;
                                                        padding: 10 5 5 5;">
                                                        You have no tasks created by manager</asp:Panel>
                                                    <input type="hidden" runat="server" id="hdnManagerTasksCount" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                   <%-- Time Matters Code Ends--%>
                                    <asp:PlaceHolder ID="phCommunication" runat="server">
                                        <div>
                                            <img id="Img20" runat="server" src="~/images/spacer.gif" height="25" width="1" /></div>
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 5 5 5 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <a id="A12" style="color: black;" runat="server" class="lnk" href="~/default.aspx">All
                                                                    Communication</a>
                                                            </td>
                                                            <td align="right">
                                                                <asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="lnkAllEmail">All Emails</asp:LinkButton>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:LinkButton
                                                                    Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="lnkAllNotes">All Notes</asp:LinkButton><asp:PlaceHolder
                                                                        ID="pnlSearchCommunication" runat="server">&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A13" runat="server"
                                                                            href="~/search.aspx"><img id="Img21" runat="server" src="~/images/16x16_find.png"
                                                                                border="0" align="absmiddle" /></a></asp:PlaceHolder>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <table onselectstart="return false;" id="tblCommunication" style="table-layout: fixed;
                                                        font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%"
                                                        border="0">
                                                        <tr>
                                                            <td class="headItem" style="width: 25;" align="center">
                                                                <img id="Img22" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                            </td>
                                                            <td class="headItem" style="width: 75">
                                                                Date<img id="Img23" style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png"
                                                                    border="0" align="absmiddle" />
                                                            </td>
                                                            <td class="headItem" style="width: 95">
                                                                Client
                                                            </td>
                                                            <td class="headItem">
                                                                Message
                                                            </td>
                                                        </tr>
                                                        <asp:Repeater ID="rpCommunication" runat="server">
                                                            <ItemTemplate>
                                                                <a href="<%# ResolveUrl("~/clients/client/communication/" + GetPage(DataBinder.Eval(Container.DataItem, "type").ToString()) + ".aspx") + "?id=" + DataBinder.Eval(Container.DataItem, "ClientID").ToString() + "&" + GetQSID(DataBinder.Eval(Container.DataItem, "type").ToString()) + "=" + DataBinder.Eval(Container.DataItem, "FieldID").ToString()  %>">
                                                                    <tr>
                                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                                            nowrap="true">
                                                                            <img src="<%#GetImage(DataBinder.Eval(Container.DataItem, "type").ToString())%>"
                                                                                border="0" />
                                                                        </td>
                                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                                            nowrap="true">
                                                                            <%#DataBinder.Eval(Container.DataItem, "Date", "{0:MMM d, yy}")%>
                                                                        </td>
                                                                        <td nowrap="true" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                            class="listItem">
                                                                            <a class="lnk" href="#" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);">
                                                                                <%#DataBinder.Eval(Container.DataItem, "Client")%>
                                                                            </a>
                                                                        </td>
                                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#NoteHelper.TruncateMessage(DataBinder.Eval(Container.DataItem, "Message"), 40)%>
                                                                        </td>
                                                                    </tr>
                                                                </a>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                    <asp:Panel runat="server" ID="pnlNoCommunication" Style="text-align: center; font-style: italic;
                                                        padding: 10 5 5 5;">
                                                        You have no email or notes</asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="phClientsIncompleteData" runat="server">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                            <td nowrap="true" style="height: 20px">
                                                                Clients Rejected by DE
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <asi:StandardGrid2 ID="grdClientsIncompleteData" XmlSchemaFile="~/standardgrids.xml"
                                            runat="server">
                                        </asi:StandardGrid2>
                                        <div>
                                            <img id="Img25" runat="server" src="~/images/spacer.gif" height="25" width="1" /></div>
                                    </asp:PlaceHolder>

                                    <script type="text/javascript">
                                            function UpdateStatistics()
                                            {
	                                            if (document.getElementById("<%=dvStats1.ClientID %>") != null)
		                                            UpdateStatistics_Financial();
                                            		
	                                            if (document.getElementById("<%=dvStats2.ClientID %>") != null)
	                                                UpdateStatistics_Clients();
                                            	
	                                            if (document.getElementById("<%=dvStats0.ClientID %>") != null)
	                                                UpdateStatistics_MasterFinancial();
                                            }
                                    </script>

                                    <asp:PlaceHolder runat="server" ID="phStatistics">

                                        <script type="text/javascript">

function UpdateStatistics_MasterFinancial()
{
	SetLoading("ProjectedCommission", true);
	<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_MasterFinancial('0')", "CallbackUpdate", "'masterfinancial0'", True) %>;
	
	SetLoading("MonthlyComparison", true);
    UpdateStatistics_MasterFinancialGraph();
    
    UpdateBatches();
}
function UpdateStatistics_MasterFinancialGraph()
{
    
    var img = document.getElementById("imgMonthlyComparison");
    var where = "<%=ResolveURL("~/research/metrics/financial/commissiongraph.ashx") %>?h=240";
	    //+ "&mOffset=" + document.getElementById("<%=ddlMonthOffset.ClientID %>").value
	    //+ "&crid=" + document.getElementById("<%=ddlMasterFinancialRecipient.ClientID %>").value
	var commrec = document.getElementById("<%=ddlCommRec.ClientID %>");
	
	if (commrec)
	{
	    where   += "&commrecs=" + commrec.value;
	}
	
    where   += "&company=" + document.getElementById("<%=ddlCompany.ClientID %>").value
            + "&w=" + img.offsetWidth
            + "&u=" + Math.random(); //to force a reload even when the url would otherwise be the same.
	    
    img.src = where;
}
function UpdateStatistics_Financial()
{
	var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
    
    var date1 = txtTransDate1.value.substring(0, 6) + "20" + txtTransDate1.value.substr(6,2);
    var date2 = txtTransDate2.value.substring(0, 6) + "20" + txtTransDate2.value.substr(6,2);
    
    if (!IsValidDateTime(date1))
    {
        ShowMessage("You entered an invalid date in the begin range selector.")
    }
    else if (!IsValidDateTime(date2))
    {
        ShowMessage("You entered an invalid date in the end range selector.")
    }
    else
    {
		HideMessage();
		SetLoading("TrustAccounts", true)
		SetLoading("FeesAndPayments", true)
		SetLoading("Deposits", true)
		SetLoading("Commission", true)
		
		<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Financial('0')", "CallbackUpdate", "'financial0'", True) %>;
		<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Financial('1')", "CallbackUpdate", "'financial1'", True) %>;
		<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Financial('2')", "CallbackUpdate", "'financial2'", True) %>;
		<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Financial('3')", "CallbackUpdate", "'financial3'", True) %>;
	}
}
function UpdateBatches()
{
    var company = document.getElementById("<%=ddlCompany.ClientID %>");
    var commrec = document.getElementById("<%=ddlCommRec.ClientID %>");
    var commrecid;
    var newsrc = "<%=ResolveURL("~\agencybatches.aspx") %>";
    
    if (!commrec)
    {
        commrecid = <%=CommRecID %>;
    }
    
    if (commrecid = 5)
    {
        commrecid = '5, 24';
    }
    
    newsrc += '?commrecid=' + commrecid + '&company=' + company.value;
    //document.getElementById("ifmBatches").src = newsrc;
}
function UpdateStatistics_Clients()
{
	SetLoading("Clients", true)
	SetLoading("ClientDeposits", true)
	SetLoading("Longevity", true)
	
	<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Clients('0')", "CallbackUpdate", "'clients0'", True) %>;
	<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Clients('1')", "CallbackUpdate", "'clients1'", True) %>;
	<%=ClientScript.GetCallbackEventReference(Me, "GetCriteria_Clients('2')", "CallbackUpdate", "'clients2'", True) %>;
}
function SetLoading(id, disp)
{
    try{
        var obj = document.getElementById("td" + id + "Hdr");
    
        obj.innerText = obj.innerText.replace(" (Loading...)", "");
        
	    if (disp)
		    obj.innerText = obj.innerText + " (Loading...)";
    }
    catch(e){
    
    }
    
}
function CallbackUpdate(result, context)
{
    try{
        switch (context.toLowerCase())
	    {
		    case 'financial0':
			    document.getElementById("dvTrustAccounts").innerHTML = result;
			    SetLoading("TrustAccounts", false)
			    break;
		    case 'financial1':
			    document.getElementById("dvFeesAndPayments").innerHTML = result;
			    SetLoading("FeesAndPayments", false)
			    break;
		    case 'financial2':
			    document.getElementById("dvDeposits").innerHTML = result;
			    SetLoading("Deposits", false)
			    break;
		    case 'financial3':
			    document.getElementById("dvCommission").innerHTML = result;
			    SetLoading("Commission", false)
			    break;
		    case 'clients0':
			    document.getElementById("dvClients").innerHTML = result;
			    SetLoading("Clients", false)
			    break;
		    case 'clients1':
			    document.getElementById("dvClientDeposits").innerHTML = result;
			    SetLoading("ClientDeposits", false)
			    break;
		    case 'clients2':
			    document.getElementById("dvLongevity").innerHTML = result;
			    SetLoading("Longevity", false)
			    break;
		    case 'masterfinancial0':
			    document.getElementById("dvMasterFinancial").innerHTML = result;
			    SetLoading("ProjectedCommission", false);
			    break;
	    }
    }
    catch(e){
    
    }

	
}
function GetCriteria_MasterFinancial(id)
{
	var result= "masterfinancial" + id + "|" + document.getElementById("<%=ddlMonthOffset.ClientId %>").value;
//	var ddlAgency=document.getElementById("<%=ddlMasterFinancialRecipient.ClientId %>");
//	if (ddlAgency != null)
//		result += "|" + ddlAgency.value;
//	else		
	result += "|" + document.getElementById("<%=ddlCompany.ClientId %>").value;
		
	var commrec = document.getElementById("<%=ddlCommRec.ClientID %>");
	
    if (commrec)
    {
		result += "|" + commrec.value;
	}
	else
	{
	    result += "|<%=CommRecID %>";    
	}

	return result;
}
function GetCriteria_Financial(id)
{
	return "financial" + id + "|" 
		+ document.getElementById("<%=txtTransDate1.ClientID %>").value + "|" 
		+ document.getElementById("<%=txtTransDate2.ClientID %>").value + "|"
		+ document.getElementById("<%=ddlCompanyFinancial.ClientID %>").value + "|"
		+ document.getElementById("<%=ddlAgencyFinancial.ClientID %>").value;
}
function GetCriteria_Clients(id)
{
	return "clients" + id + "|" 
		+ document.getElementById("<%=ddlChartGrouping_Stat.ClientID %>").value + "|" 
		+ document.getElementById("<%=txtDataPoints.ClientID %>").value + "|" 
		+ document.getElementById("<%=chkCumulative.ClientID %>").checked;
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    dvError.style.display = "none";
}
function SetDates(ddl)
{
    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

    var str = ddl.value;
    if (str != "Custom")
    {
        var parts = str.split(",");
        txtTransDate1.value=parts[0];
        txtTransDate2.value=parts[1];
    }
}
function SetCustom()
{
    var ddl = document.getElementById("<%=ddlQuickPickDate.ClientId %>");
    ddl.selectedIndex=8;	
}
                                        </script>

                                        <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td valign="top">
                                                    <div runat="server" id="dvError" style="display: none;">
                                                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                                            width="100%" border="0">
                                                            <tr>
                                                                <td valign="top" width="20">
                                                                    <img id="Img26" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                                                </td>
                                                                <td runat="server" id="tdError">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                        <table style="width: 100%; font-family: tahoma; font-size: 11px; padding-top: 0px"
                                            cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td>
                                                    <asi:TabStrip runat="server" ID="tsStatistics">
                                                    </asi:TabStrip>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="dvStats0" runat="server">
                                                        <asp:Panel runat="server" ID="pnlMasterFinancial">
                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="background-color: rgb(244,242,232);">
                                                                        <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma"
                                                                            border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <img id="Img27" runat="server" src="~/images/grid_top_left.png" border="0" />
                                                                                </td>
                                                                                <td style="width: 100%;">
                                                                                    <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                                                        background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                                                        font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                                                        border="0">
                                                                                        <tr>
                                                                                            <td nowrap="true" style="width: 100px">
                                                                                                <select class="entry" runat="server" id="ddlMonthOffset">
                                                                                                </select>
                                                                                            </td>
                                                                                            <td>
                                                                                                &nbsp;&nbsp;&nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 100px;">
                                                                                                <asp:DropDownList ID="ddlCompany" runat="server" Style="font-family: tahoma; font-size: 11px;
                                                                                                    width: 100%;">
                                                                                                </asp:DropDownList>
                                                                                            </td>
                                                                                            <td>
                                                                                                &nbsp;&nbsp;&nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true">
                                                                                                <asp:DropDownList ID="ddlCommRec" runat="server" Style="font-family: tahoma; font-size: 11px;
                                                                                                    width: 100px;" Visible="false">
                                                                                                </asp:DropDownList>
                                                                                            </td>
                                                                                            <asp:PlaceHolder ID="phMasterFinancialAgency" runat="server">
                                                                                                <td nowrap="true" style="width: 8;">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <!--
                                <td nowrap="true" style="width:100px">
									<asp:DropDownList Width="100px" Font-Names="Tahoma" Font-Size="11px" runat="server" ID="ddlMasterFinancialRecipient"></asp:DropDownList>
                                </td>
                                -->
                                                                                            </asp:PlaceHolder>
                                                                                            <td nowrap="true">
                                                                                                <img id="Img28" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                                                            </td>
                                                                                            <td nowrap="true">
                                                                                                <a href="javascript:UpdateStatistics_MasterFinancial()" class="gridButton">
                                                                                                    <img id="Img29" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                                                        src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 100%;">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 10;">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td>
                                                                                    <img id="Img30" runat="server" src="~/images/grid_top_right.png" border="0" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="font-size: 10px">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                            cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="background-color: #f3f3f3; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" id="tdProjectedCommissionHdr">
                                                                                    Planned / Actual Fees Earned <span id="debug" runat="server" visible="true" enableviewstate="true">
                                                                                    </span>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <div id="dvMasterFinancial" style="overflow: auto; height: 170; width: 100%">
                                                                        </div>
                                                                        <br />
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                            cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="background-color: #f3f3f3; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" id="tdMonthlyComparisonHdr">
                                                                                    Agent Fees Paid
                                                                                </td>
                                                                                <td style="background-color: #f3f3f3; padding: 0 5 0 0; color: rgb(50,112,163);"
                                                                                    align="right" id="tdResearchMonthlyComparison" runat="server">
                                                                                    <a id="A14" class="lnk" href="~/research/metrics/financial/commission.aspx" runat="server">
                                                                                        <img id="Img31" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                                                                            src="~/images/16x16_chart_bar.png" />More Detail </a>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <div style="width: 100%; height: 100%">
                                                                            <img style="width: 100%; height: 240px" id="imgMonthlyComparison" onload="SetLoading('MonthlyComparison', false)"
                                                                                onresize="UpdateStatistics_MasterFinancialGraph()" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                    </div>
                                                    <div id="dvStats1" runat="server">
                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td style="background-color: rgb(244,242,232);" colspan="3">
                                                                    <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                                                                        border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <img id="Img32" runat="server" src="~/images/grid_top_left.png" border="0" />
                                                                            </td>
                                                                            <td style="width: 100%;">
                                                                                <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                                                    background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                                                    font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                                                    border="0">
                                                                                    <tr>
                                                                                        <td nowrap="true">
                                                                                            <asp:DropDownList ID="ddlQuickPickDate" runat="server" Style="font-family: Tahoma;
                                                                                                font-size: 11px">
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 8;">
                                                                                            &nbsp;
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 65; padding-right: 5;">
                                                                                            <cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask>
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 8;">
                                                                                            :
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 65; padding-right: 5;">
                                                                                            <cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask>
                                                                                        </td>
                                                                                        <td nowrap="true" style="padding-right: 5;">
                                                                                            <asp:DropDownList ID="ddlCompanyFinancial" runat="server" CssClass="entry2">
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td nowrap="true" style="margin: 0 3 0 3;">
                                                                                            <asp:DropDownList ID="ddlAgencyFinancial" runat="server" CssClass="entry2">
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                        <td nowrap="true">
                                                                                            <asp:LinkButton ID="lnkRequery" runat="server"></asp:LinkButton>
                                                                                            <a href="javascript:UpdateStatistics_Financial()" class="gridButton">
                                                                                                <img id="Img34" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                                                    src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 100%;">
                                                                                            &nbsp;
                                                                                        </td>
                                                                                        <td nowrap="true" style="width: 10;">
                                                                                            &nbsp;
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                            <td>
                                                                                <img id="Img35" runat="server" src="~/images/grid_top_right.png" border="0" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="font-size: 10px">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3" id="tdTrustAccountsHdr2">
                                                                    <asp:Panel ID="pnlTrustAccounts" runat="server" Width="100%">
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td style="font-size: 8pt; background-color: #DEDEDE; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    id="tdTrustAccountsHdr">
                                                                                    Trust Account
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <div id="dvTrustAccounts" style="height: 65px">
                                                                                    </div>
                                                                                    <asp:Repeater ID="rpTrustAccounts" runat="server">
                                                                                        <HeaderTemplate>
                                                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%" cellspacing="0"
                                                                                                cellpadding="0">
                                                                                                <tr style="font-weight: bold">
                                                                                                    <th align="left" class="StatHeadItem">
                                                                                                        Account
                                                                                                    </th>
                                                                                                    <th align="left" class="StatHeadItem">
                                                                                                        Statistic
                                                                                                    </th>
                                                                                                    <th align="right" class="StatHeadItem">
                                                                                                        Value
                                                                                                    </th>
                                                                                                </tr>
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td class="StatListItem">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "trustname" )%>
                                                                                                </td>
                                                                                                <td class="StatListItem">
                                                                                                    Current Balance
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "balance", "{0:c}")%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="3" style="height: 2; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                                                    background-position: bottom bottom; background-repeat: repeat-x;">
                                                                                                    <img id="Img42" src="~/images/spacer.gif" border="0" width="1" height="1" runat="server" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </ItemTemplate>
                                                                                        <FooterTemplate>
                                                                                            </table>
                                                                                        </FooterTemplate>
                                                                                    </asp:Repeater>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="font-size: 15px">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" colspan="3" id="tdFeesAndPaymentsHdr2">
                                                                    <asp:Panel ID="pnlFeesAndPayments" runat="server" Width="100%">
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td style="font-size: 8pt; background-color: #DEDEDE; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" id="tdFeesAndPaymentsHdr">
                                                                                    Client Fees & Payments
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <div style="overflow: auto; height: 140px" id="dvFeesAndPayments">
                                                                                    </div>
                                                                                    <asp:Repeater ID="rpFeesAndPayments" runat="server">
                                                                                        <HeaderTemplate>
                                                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed;"
                                                                                                cellspacing="0" cellpadding="0">
                                                                                                <colgroup>
                                                                                                    <col />
                                                                                                    <col style="background-color: #f5f5f5" />
                                                                                                    <col />
                                                                                                    <col style="background-color: #f5f5f5" />
                                                                                                    <col />
                                                                                                </colgroup>
                                                                                                <tr style="font-weight: bold">
                                                                                                    <th align="left" class="StatHeadItem" nowrap="true" style="width: 30%">
                                                                                                        Fee Type
                                                                                                    </th>
                                                                                                    <th colspan="2" align="center" class="StatHeadItem">
                                                                                                        Newly Assessed
                                                                                                    </th>
                                                                                                    <th colspan="2" align="center" class="StatHeadItem">
                                                                                                        Payments Made
                                                                                                    </th>
                                                                                                </tr>
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td class="StatListItem" align="left">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "feetype")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "countassessed", "{0:#,##0}")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "sumassessed", "{0:c}")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "countpaid", "{0:#,##0}")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "sumpaid", "{0:c}")%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="5" style="height: 2; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                                                    background-position: bottom bottom; background-repeat: repeat-x;">
                                                                                                    <img id="Img43" src="~/images/spacer.gif" border="0" width="1" height="1" runat="server" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </ItemTemplate>
                                                                                        <FooterTemplate>
                                                                                            </table>
                                                                                        </FooterTemplate>
                                                                                    </asp:Repeater>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="font-size: 15px">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" colspan="3" id="tdDepositsHdr2" style="vertical-align: top">
                                                                    <asp:Panel ID="pnlDeposits" runat="server" Width="100%">
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td style="font-size: 8pt; background-color: #DEDEDE; padding: 5px; color: rgb(50,112,163);"
                                                                                    align="left" id="tdDepositsHdr">
                                                                                    Client Deposits
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <div id="dvDeposits" style="overflow: auto; height: 140px">
                                                                                    </div>
                                                                                    <asp:Repeater ID="rpDeposits" runat="server">
                                                                                        <HeaderTemplate>
                                                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                                                cellspacing="0" cellpadding="0">
                                                                                                <tr style="font-weight: bold">
                                                                                                    <th align="left" class="StatHeadItem">
                                                                                                        Statistic
                                                                                                    </th>
                                                                                                    <th align="left" class="StatHeadItem" style="width: 40px">
                                                                                                        Count
                                                                                                    </th>
                                                                                                    <th align="right" class="StatHeadItem">
                                                                                                        Value
                                                                                                    </th>
                                                                                                </tr>
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td class="StatListItem">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "statistic")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "count", "{0:#,##0}")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "value", "{0:c}")%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="3" style="height: 2; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                                                    background-position: bottom bottom; background-repeat: repeat-x;">
                                                                                                    <img id="Img44" src="~/images/spacer.gif" border="0" width="1" height="1" runat="server" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </ItemTemplate>
                                                                                        <FooterTemplate>
                                                                                            </table>
                                                                                        </FooterTemplate>
                                                                                    </asp:Repeater>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="font-size: 15px">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" colspan="3" id="tdCommissionHdr2" style="vertical-align: top">
                                                                    <asp:Panel ID="pnlCommission" runat="server" Width="100%">
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td style="font-size: 8pt; background-color: #DEDEDE; padding: 5px; color: rgb(50,112,163);"
                                                                                    align="left" id="tdCommissionHdr">
                                                                                    Agent Fees Paid
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="top" align="left">
                                                                                    <div id="dvCommission" style="overflow: auto; height: 140px">
                                                                                    </div>
                                                                                    <asp:Repeater ID="rpCommission" runat="server">
                                                                                        <HeaderTemplate>
                                                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                                                cellspacing="0" cellpadding="0">
                                                                                                <tr style="font-weight: bold">
                                                                                                    <th align="left" class="StatHeadItem">
                                                                                                        Recipient
                                                                                                    </th>
                                                                                                    <th align="left" class="StatHeadItem" style="width: 40px">
                                                                                                        Count
                                                                                                    </th>
                                                                                                    <th align="right" class="StatHeadItem">
                                                                                                        Amount
                                                                                                    </th>
                                                                                                </tr>
                                                                                        </HeaderTemplate>
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td class="StatListItem">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "commrecname")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "count", "{0:#,##0}")%>
                                                                                                </td>
                                                                                                <td class="StatListItem" align="right">
                                                                                                    <%#DataBinder.Eval(Container.DataItem, "amount", "{0:c}")%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="3" style="height: 2; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                                                    background-position: bottom bottom; background-repeat: repeat-x;">
                                                                                                    <img id="Img45" src="~/images/spacer.gif" border="0" width="1" height="1" runat="server" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </ItemTemplate>
                                                                                        <FooterTemplate>
                                                                                            </table>
                                                                                        </FooterTemplate>
                                                                                    </asp:Repeater>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 10px;">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div id="dvStats2" runat="server" style="display: none">
                                                        <asp:Panel runat="server" ID="pnlClients">
                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                                                                cellspacing="0">
                                                                <tr>
                                                                    <td style="background-color: rgb(244,242,232);">
                                                                        <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                                                                            border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <img id="Img36" runat="server" src="~/images/grid_top_left.png" border="0" />
                                                                                </td>
                                                                                <td style="width: 100%;">
                                                                                    <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                                                        background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                                                        font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                                                        border="0">
                                                                                        <tr>
                                                                                            <td nowrap="true" style="width: 100px">
                                                                                                <select class="entry" runat="server" id="ddlChartGrouping_Stat">
                                                                                                    <option value="0" text="Daily"></option>
                                                                                                    <option value="1" text="Weekly" selected></option>
                                                                                                    <option value="2" text="Monthly"></option>
                                                                                                    <option value="3" text="Annually"></option>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 8;">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true">
                                                                                                Data Points:&nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true" style="padding-right: 5;">
                                                                                                <input style="font-size: 11px; width: 25" type="text" runat="server" value="5" maxlength="1"
                                                                                                    onkeypress="return AllowOnlyNumbersStrict();" id="txtDataPoints" />
                                                                                            </td>
                                                                                            <td nowrap="true" style="padding-right: 5;">
                                                                                                <asp:CheckBox ID="chkCumulative" runat="server" Text="Cumulative" Style="font-size: 11px" />
                                                                                            </td>
                                                                                            <td nowrap="true">
                                                                                                <img id="Img37" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                                                            </td>
                                                                                            <td nowrap="true">
                                                                                                <a href="javascript:UpdateStatistics_Clients()" class="gridButton">
                                                                                                    <img id="Img38" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                                                        src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 100%;">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                            <td nowrap="true" style="width: 10;">
                                                                                                &nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td>
                                                                                    <img id="Img39" runat="server" src="~/images/grid_top_right.png" border="0" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="font-size: 10px">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                            cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="background-color: #f3f3f3; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" colspan="3" id="tdClientsHdr">
                                                                                    Clients
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <div id="dvClients" style="overflow: auto; height: 115px;">
                                                                        </div>
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                            cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="background-color: #f3f3f3; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" colspan="3" id="tdClientDepositsHdr">
                                                                                    Client Deposits
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <div id="dvClientDeposits" style="overflow: auto; height: 75px;">
                                                                        </div>
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; table-layout: fixed"
                                                                            cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="background-color: #f3f3f3; padding: 5 5 5 5; color: rgb(50,112,163);"
                                                                                    align="left" colspan="3" id="tdLongevityHdr">
                                                                                    Longevity
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <div id="dvLongevity" style="overflow: auto; height: 70px;">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                    </div>
                                                    <div id="dvStats3" runat="server" style="display: none">
                                                        <asp:PlaceHolder ID="phGlobalRoadmap" runat="server">
                                                            <br />
                                                            <table style="font-family: tahoma; font-size: 11px; width: 100%" cellpadding="0"
                                                                cellspacing="0" border="0">
                                                                <tr>
                                                                    <td style="background-color: #f5f5f5; padding: 5 5 5 5;">
                                                                        Global Roadmap
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div style="width: 100%; height: 320; overflow: auto">
                                                                <table class="list" onmouseover="RowHover2(this, true)" onmouseout="RowHover2(this, false)"
                                                                    onselectstart="return false;" cellspacing="0" cellpadding="0" width="100%" border="0">
                                                                    <thead>
                                                                        <tr>
                                                                            <th nowrap style="width: 22; height: 22" align="center">
                                                                                <img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                            </th>
                                                                            <th nowrap align="left">
                                                                                Status
                                                                            </th>
                                                                            <th nowrap align="left">
                                                                                Clients
                                                                            </th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <asp:Repeater ID="rpGlobalRoadmap" runat="server">
                                                                            <ItemTemplate>
                                                                                <a href="#" onclick="RowClick_Roadmap(this.childNodes(0), <%#CType(Container.DataItem,Roadmap).ClientStatusID %>);">
                                                                                    <tr>
                                                                                        <tr>
                                                                                            <td style="width: 22; height: 22" align="middle">
                                                                                                <img runat="server" src="~/images/16x16_person.png" border="0" />
                                                                                            </td>
                                                                                            <td nowrap="true" align="absmiddle" valign="middle">
                                                                                                <%#GetGRImg(CType(Container.DataItem, Roadmap))%>
                                                                                                <%#CType(Container.DataItem, Roadmap).Name%>
                                                                                            </td>
                                                                                            <td align="left">
                                                                                                <%#CType(Container.DataItem, Roadmap).Count%>
                                                                                            </td>
                                                                                        </tr>
                                                                                </a>
                                                                            </ItemTemplate>
                                                                        </asp:Repeater>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </asp:PlaceHolder>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:PlaceHolder>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </body>
        <!-- The following linkbutton controls are only on the page so that the client script (above)
                    can call a postback event handled by one of these controls.  They have no inner value
                    so they will not be visibly displayed on the page -->
        <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkClear"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSearch_Roadmap"></asp:LinkButton>
        <input type="hidden" runat="server" id="txtRoadmap_ClientStatusId" />
    </asp:Panel>

    <script>
    var vartabIndex=<%=tabIndex %>;
    
    if(vartabIndex ==2)
        document.getElementById("<%=phManagerTasks.ClientID%>").style.display="block"  
    else if(vartabIndex ==1)
        document.getElementById("<%=phTeamTasks.ClientID%>").style.display="block"  
    else if(document.getElementById("<%=phTasks.ClientID%>") != null) {
        document.getElementById("<%=phTasks.ClientID%>").style.display="block"  
    }
    </script>

</asp:Content>
