<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NonDepositControl.ascx.vb"
    Inherits="CustomTools_UserControls_NonDepositControl" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<div id="divNonDeposit" runat="server" visible="false" style="padding: 0px 0px 20px 0px">
    <asi:TabStrip runat="server" ID="tsNonDeposits">
    </asi:TabStrip>
    <div id="phOpenNonDeposits" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table class="entry2">
                        <tr>
                            <td style="padding-left: 5px">
                                    Firm:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlNonDepositFirmList" runat="server" CssClass="entry2">
                                    </asp:DropDownList>
                                </td>  
                                <td style="padding-left: 5px">
                                    Matter Status:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlNonDepositMatterStatus" runat="server" CssClass="entry2">
                                    </asp:DropDownList>
                                </td> 
                                <td style="padding-left: 5px">
                                    Type:
                                </td>
                                 <td>
                                    <asp:DropDownList ID="ddlNonDepositType" runat="server" CssClass="entry2" >
                                        <asp:ListItem Text="-- All --" Value="0" Selected="True" />
                                        <asp:ListItem Text="Missed" Value="1" />
                                        <asp:ListItem Text="Bounced" Value="2" />
                                    </asp:DropDownList>
                                </td> 
                                <td style="padding-left: 5px">
                                    Letter:
                                </td> 
                                <td>
                                    <asp:DropDownList ID="ddlLetter" runat="server" CssClass="entry2" >
                                        <asp:ListItem Text="-- All --" Value="All" Selected="True" />
                                        <asp:ListItem Text="First" Value="First" />
                                        <asp:ListItem Text="Second" Value="Second" />
                                        <asp:ListItem Text="Third" Value="Third" />
                                        <asp:ListItem Text="NSF" Value="NSF" />
                                    </asp:DropDownList>
                                </td>      
                                <td style="padding-left: 5px">
                                    4+:
                                </td> 
                                <td>
                                    <asp:CheckBox ID="chk4plus" runat="server" />
                                </td>                                                     
                                <td align="right">
                                    <asp:LinkButton ID="lnkNonDepositFilter" runat="server" class="gridButton"><img src="images/16x16_funnel.png" alt="filter" border="0" class="gridButtonImage" onclick="javascript:SubmitNonDepositFilter()" align="absmiddle" />Apply Filter</asp:LinkButton>
                                </td>
                        </tr>
                    </table>
                 </td>
            </tr>
             <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvNonDeposits" runat="server" class="grid" style="width: 100%">
                         <asp:GridView ID="gvNonDeposits" runat="server" AutoGenerateColumns="false"
                                AllowPaging="True" AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="50"
                                Width="100%" CssClass="entry2">
                            <AlternatingRowStyle BackColor="White" />
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img id="imgHeader" src="~/images/16x16_icon.png" alt="" runat="server" border="0" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="imgItem" src="~/images/16x16_calendar.png" alt="" runat="server" border="0" />
                                        <input type="hidden" id="hdnNonDepositMatterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                                        <input type="hidden" id="hdnNonDepositClientId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                        <input type="hidden" id="hdnNonDepositId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "NonDepositId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Due" HeaderText="Due Date" DataFormatString="{0:MMM d yyyy}" SortExpression="Due">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MatterSubStatus" HeaderText="Status">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="shortconame" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Account #" ControlStyle-CssClass="lnk" DataTextField="AccountNumber"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="NonDepositType" HeaderText="Type">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NonDepositDate" HeaderText="Date" DataFormatString="{0:MM/dd/yy}" >
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="NonDepositAmount" HeaderText="Amount" DataFormatString="{0:c}" >
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BouncedReason" HeaderText="Reason">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Letter" HeaderText="Letter">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        4+
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#IIf(DataBinder.Eval(Container.DataItem, "InCancel") = 1, "Yes", "")%> 
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagerstyle" />
                         </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnOpenNonDeposits" />
                </td>
            </tr>
        </table>
    </div>
    <div id="phNonDepositExceptions" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table class="entry2">
                        <tr>
                            <td style="padding-left: 5px">
                                Firm:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlNonDepositExceptionsFirmList" runat="server" CssClass="entry2">
                                </asp:DropDownList>
                            </td>  
                            <td align="right">
                                 <asp:LinkButton ID="lnkNonDepositExceptionsFilter" runat="server" class="gridButton"><img src="images/16x16_funnel.png" alt="filter" border="0" class="gridButtonImage" onclick="javascript:SubmitNonDepositExceptionsFilter()" align="absmiddle" />Apply Filter</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvNondepositExceptions" runat="server" class="grid" style="width: 100%">
                         <asp:GridView ID="gvNondepositExceptions" runat="server" AutoGenerateColumns="false"
                                AllowPaging="True" AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="50"
                                Width="100%" CssClass="entry2" DataKeyNames="ExceptionId" >
                            <AlternatingRowStyle BackColor="White" />
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img id="imgHeaderE" src="~/images/16x16_icon.png" alt="" runat="server" border="0" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="imgItemE" src="~/images/16x16_calendar.png" alt="" runat="server" border="0" />
                                        <input type="hidden" id="hdnExceptionId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ExceptionId")%>' />
                                        <input type="hidden" id="hdnExceptionPlanId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PlanId")%>' />
                                        <input type="hidden" id="hdnExceptionClientId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                                <asp:HyperLinkField HeaderText="Account #" ControlStyle-CssClass="lnk" DataTextField="AccountNumber" 
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname" 
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="shortconame" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ScheduledDate" HeaderText="Scheduled Date" DataFormatString="{0:MM/dd/yy}" SortExpression="ScheduledDate" >
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ExpectedDepositAmount" HeaderText="Amount" DataFormatString="{0:c}" >
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:Label ID="Label1" runat="server" Text="Create Matter?"></asp:Label>
                                        &nbsp;<asp:Button ID="btnFixAll" runat="server" Text="Go" ToolTip="Approve All Selected" OnClientClick="return FixSelectedExceptions();" CommandName="FixSelectedExceptions"   />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:RadioButton ID="rdCreateYes" runat="server" GroupName="rdCreateMatter" Text="Yes" />
                                        <asp:RadioButton ID="rdCreateNo" runat="server" GroupName="rdCreateMatter" Text="No"/>
                                        &nbsp;
                                        <asp:Button ID="btnFix" runat="server" Text="Go" ToolTip="Approve this" CommandName="FixException" CommandArgument="<%# CType(Container,GridViewRow).RowIndex %>" OnClientClick="return FixException(this);"  />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagerstyle" />
                         </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnNonDepositExceptions" />
                    <asp:LinkButton ID="LnkFixExceptions" runat="server"></asp:LinkButton>
                </td>
            </tr>
        </table>
    </div> 
    <div id="phNonDepositCanCellations" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table class="entry2">
                        <tr>
                            <td style="padding-left: 5px">
                                Firm:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlNonDepositCancellationFirmList" runat="server" CssClass="entry2">
                                </asp:DropDownList>
                            </td>  
                            <td align="right">
                                 <asp:LinkButton ID="lnkNonDepositCancellationFilter" runat="server" class="gridButton"><img src="images/16x16_funnel.png" alt="filter" border="0" class="gridButtonImage" onclick="javascript:SubmitNonDepositCancellationsFilter()" align="absmiddle" />Apply Filter</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvNondepositCancellations" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvNondepositCancellations" runat="server" AutoGenerateColumns="false"
                                AllowPaging="True" AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="50"
                                Width="100%" CssClass="entry2" DataKeyNames="CancellationId" >
                            <AlternatingRowStyle BackColor="White" />
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img id="imgHeaderCanc" src="~/images/16x16_icon.png" alt="" runat="server" border="0" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="imgItemCanc" src="~/images/16x16_calendar.png" alt="" runat="server" border="0" />
                                        <input type="hidden" id="hdnNDCancellationId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "CancellationId")%>' />
                                        <input type="hidden" id="hdnNDClientId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Created" HeaderText="Created Date" DataFormatString="{0:MM/dd/yy}" SortExpression="Created" >
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Account #" ControlStyle-CssClass="lnk" DataTextField="AccountNumber" 
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname" 
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="shortconame" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                               
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblRemoveCanc" runat="server" Text="Remove"></asp:Label>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Button ID="btnRemoveCanc" runat="server" Text="Go" ToolTip="Remove From the Pending Cancellation List" CommandName="RemoveNDCancel" CommandArgument="<%# CType(Container,GridViewRow).RowIndex %>" OnClientClick="return RemoveNDCancel();"  />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                            </Columns> 
                         </asp:GridView>
                         <input type="hidden" runat="server" id="hdnNonDepositCancellations" />
                         <asp:LinkButton ID="lnkRemoveCancel" runat="server"></asp:LinkButton>
                    </div>
                </td>
            </tr>
        </table>
     </div>   
</div> 

<script language="javascript" type="text/javascript">
    var ndvartabIndex=<%=NDtabIndex %>;
    
    if(ndvartabIndex ==1)
        document.getElementById("<%=phOpenNonDeposits.ClientID%>").style.display="block";  //NonDeposit 
    else if (ndvartabIndex ==2)
        document.getElementById("<%=phNonDepositExceptions.ClientID%>").style.display="block";  //NonDeposit Exception
    else if (ndvartabIndex ==3)
        document.getElementById("<%=phNonDepositCancellations.ClientID%>").style.display="block";  //NonDeposit Cancellations

    function setMouseOverColor(element, bgColor)
    {
        if (typeof bgColor != "undefined")
            element.style.backgroundColor=bgColor;
        else 
            element.style.backgroundColor="#e5e5e5";
            
        element.style.cursor='hand';
    }

    function setMouseOutColor(element, bgColor)
    {
        if (typeof bgColor != "undefined")
            element.style.backgroundColor=bgColor;
        else 
            element.style.backgroundColor="#ffffff";
            
        element.style.textDecoration='none';
    }
      
     //NonDeposit Filter 
    function SubmitNonDepositFilter()
    {
        //SubmitFilter
        <%=Page.ClientScript.GetPostBackEventReference(lnkNonDepositFilter,Nothing) %>
    }
    
     //NonDeposit Exceptions Filter 
    function SubmitNonDepositExceptionsFilter()
    {
        //SubmitFilter
        <%=Page.ClientScript.GetPostBackEventReference(lnkNonDepositExceptionsFilter,Nothing) %>
    }
    
    //NonDeposit Cancellations Filter 
    function SubmitNonDepositCancellationsFilter()
    {
        //SubmitFilter
        <%=Page.ClientScript.GetPostBackEventReference(lnkNonDepositCancellationFilter,Nothing) %>
    }
    
    function FixException(btn){
        if(btn.parentNode.childNodes[0].checked||btn.parentNode.childNodes[3].checked) {
            return confirm("Press Ok to confirm this action.");  
        } else {
            alert("Please select an option."); 
            return false;
        }
    }
    
    function FixSelectedExceptions(){
        return confirm("Press Ok to confirm all your selected options.");
    }
    
    function RemoveNDCancel(){
        return confirm("Press Ok to remove this client from the Pending Cancellation list.");
    }
    
</script>

