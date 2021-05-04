<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_BankReturns_Default" Title="Bank Check/ACH Returns" MasterPageFile="~/Site.Master" %>

 <%@ Register assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>

    <%@ Register assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebCombo" tagprefix="igcmbo" %>
    
    <%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc2" %>
    <%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
    
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">

   <style type="text/css">
        .FilterList { PADDING-RIGHT: 3px; PADDING-LEFT: 3px; FONT-SIZE: 9pt; FILTER: progid:DXImageTransform.Microsoft.Alpha(opacity=95); BACKGROUND-IMAGE: url(options.png); PADDING-BOTTOM: 10px; OVERFLOW: auto; WIDTH: 150px; COLOR: black; PADDING-TOP: 10px; FONT-FAMILY: verdana; HEIGHT: 280px; BACKGROUND-COLOR: #f1f1f1; opacity: .95 }
        .FilterList TABLE { WIDTH: 182px }
        .FilterList TD { PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 2px; PADDING-TOP: 2px; TEXT-ALIGN: left }
        .FilterHighlight { BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; FONT-WEIGHT: bold; BORDER-LEFT: black 1px solid; CURSOR: default; COLOR: white; BORDER-BOTTOM: black 1px solid; BACKGROUND-COLOR: #3c7fb1 }
       .style4
       {
           height: 4px;
           width: 133px;
       }
    </style>
    
    <script type="text/javascript" >
    
    var StartDate = null;
    var EndDate = null;
    var ClientID = null;
    var AccountNumber = null;

    function Print()
    {
         window.print()
    }

    function View()
    {
          document.getElementById("<%=hdnStartDate.ClientID %>").value = document.getElementById("<%= dtStartDate.ClientID %>").value;
          document.getElementById("<%=hdnEndDate.ClientID %>").value = document.getElementById("<%= dtEndDate.ClientID %>").value;
          <%= ClientScript.GetPostBackEventReference(lnkView, nothing) %>;
    }
    
    function GetDates()
    {
          document.getElementById("<%=hdnStartDate.ClientID %>").value = document.getElementById("<%= dtStartDate.ClientID %>").value;
          document.getElementById("<%=hdnEndDate.ClientID %>").value = document.getElementById("<%= dtEndDate.ClientID %>").value;
          
    }
    
    </script>
    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"></asp:SqlDataSource>
 
<table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="imgSpacer" runat="server" width="8" height="1" src="~/images/spacer.gif"/>
            <td style="height: 28px" valign="middle">
                <a id="btnHome" runat="server" class="menuButton" href="~/Clients/Default.aspx">
                    <img id="imgHome" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_web_home.png" atl=" " />Back</a>
            </td>
            <td class="menuSeparator">
                &nbsp;</td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;" valign="middle">
                <a id="btnPrint" runat="server" class="menuButton" onclick="javascript:Window.Print();" href="#">
                    <img id="imgprint" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_Print.png" alt= " " />Print 
                this page</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;" valign="middle">
                <a id="btnView" runat="server" class="menuButton" onclick="javascript:View();" href="#">
                    <img id="img2" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_Report.png" alt= " " />View 
                Information</a>
            </td>
            <td style="white-space:nowrap; width: 100%; padding-left:5;" valign="middle" align="right">
                &nbsp;
                <asp:Label ID="lblCount" runat="server" Text="Total Item(s) Count:  0" 
                    Width="150px"></asp:Label>
                </td>
        </tr>
    </table>
    
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="~/../FormMgr/FormMgr.css" rel="stylesheet" type="text/css" />
    
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" 
        runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    
    <table   cellspacing="2" style="width: 100%">
       <tr style="background-color:#99CCFF" align="left" >
            <td style="font-family:Tahoma; font-size:11; font-weight: Bold; width:300;" align="left" 
                valign="middle" class="style4" nowrap="nowrap">Start: 
                &nbsp;
            <asp:dropdownlist ID="ddlStartDate" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Applicant" DataValueField="LeadApplicantID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Select a period." Width="75px" Visible="false">
                    <asp:ListItem Text="Custom"></asp:ListItem>
                    <asp:ListItem Text="Yesterday"></asp:ListItem>
                    <asp:ListItem Text="Last Week"></asp:ListItem>
                    <asp:ListItem Text="Last Month"></asp:ListItem>
                    <asp:ListItem Text="Last Year"></asp:ListItem>
                </asp:dropdownlist>Date:
                    &nbsp; 
                    <cc2:InputMask class="entry" runat="server" ID="dtStartDate" BorderWidth="1" Mask="nn/nn/nnnn" Width="75px" ToolTip="Enter a start date.">
                    </cc2:InputMask>
<%--                    <asp:ImageButton runat="server" ID="CallImage1" ImageUrl="../../images/16x16_calendar.png" AlternateText="" />
                    <ajaxToolkit:CalendarExtender ID="CalExt1" runat="server" TargetControlID="dtStartDate" PopupButtonID="../../images/16x16_calendar.pgp" />--%>
            </td>
            <td style="width: 180px; font-family: Tahoma; font-size: 11; font-weight: Bold; height: 4px;" align="left" 
                valign="middle" nowrap="nowrap">End Date:
                &nbsp;
                     <cc2:InputMask class="entry" runat="server" ID="dtEndDate" BorderWidth="1" Mask="nn/nn/nnnn" Width="75px" ToolTip="Enter an end date.">
                    </cc2:InputMask>
<%--                    <asp:ImageButton runat="server" ID="CallImage2" ImageUrl="../../images/16x16_calendar.png" AlternateText="" />
                    <ajaxToolkit:CalendarExtender ID="CalExt2" runat="server" TargetControlID="dtEndDate" PopupButtonID="../../images/16x16_calendar.pgp" />--%>
            </td>
            <%--<td style="font-family: Tahoma; font-size: 11; font-weight: Bold; " align="left" 
                valign="middle" class="style3">Client Acct. #:
                &nbsp;
                <asp:TextBox ID="txtAccountNo" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Description" DataValueField="StatusID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Enter a client account number." Width="100px">
                </asp:TextBox>
            </td>
            <td style="font-family: Tahoma; font-size: 11; font-weight: Bold; " align="left" 
                valign="middle" class="style1">Client Name:
                &nbsp;
                <asp:dropdownlist ID="ddlClientName" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Name" DataValueField="ClientID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Select a client name." Height="16px" 
                    Width="200px">
                    <asp:ListItem Text="Select"></asp:ListItem>
                </asp:dropdownlist>
            </td>--%>
        </tr>
    </table>
    
    <asp:GridView ID="grdReturned" runat="server" Caption="Deposit Disposition" 
        CaptionAlign="Top" Font-Names="Tahoma" Font-Size="11pt" 
        AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField AccessibleHeaderText="ClientID" DataField="ClientID" 
                HeaderText="ClientID" ShowHeader="False" Visible="False" />
            <asp:BoundField DataField="RegisterID" HeaderText="NachaRegisterID" 
                ShowHeader="False" Visible="False" />
            <asp:HyperLinkField AccessibleHeaderText="Lexx-Account"
                DataTextField="AccountNo" HeaderText="Lexx-Account" 
                DataNavigateUrlFields="ClientID" 
                DataNavigateUrlFormatString="~/Clients/Client/finances/default.aspx?id={0}">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="100px" />
            <HeaderStyle BackColor="#336699" Font-Bold="False" Font-Names="Tahoma" 
                Font-Size="10pt" ForeColor="White" HorizontalAlign="Left" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="100px" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="ClientName" HeaderText="Client Name" 
                ReadOnly="True">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="200px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="200px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="200px" />
            </asp:BoundField>
            <asp:BoundField DataField="RoutingNumber" HeaderText="Routing #" 
                ReadOnly="True">
            <ControlStyle Font-Bold="False" Font-Names="Tahoma" Font-Size="10pt" 
                Width="100px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="100px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="100px" />
            </asp:BoundField>
            <asp:BoundField DataField="AccountNumber" HeaderText="Account #">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="125px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="125px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="125px" />
            </asp:BoundField>
            <asp:BoundField DataField="Amount" DataFormatString="{0:c}" HeaderText="Amount">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="100px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="100px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" HorizontalAlign="Right" 
                Width="100px" />
            </asp:BoundField>
            <asp:BoundField DataField="LawFirm" HeaderText="Law Firm" ReadOnly="True">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="200px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="200px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="200px" />
            </asp:BoundField>
            <asp:BoundField DataField="SettlementDate" DataFormatString="{0:d}" 
                HeaderText="Settlement" ReadOnly="True">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="75px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" Width="75px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="75px" />
            </asp:BoundField>
            <asp:BoundField DataField="BouncedDesription" HeaderText="Status" 
                ReadOnly="True">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="250px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="250px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="250px" />
            </asp:BoundField>
            <asp:BoundField DataField="BouncedDate" HeaderText="Adjustment Applied" 
                ReadOnly="True">
            <ControlStyle Font-Names="Tahoma" Font-Size="10pt" Width="250px" />
            <HeaderStyle BackColor="#336699" Font-Names="Tahoma" Font-Size="10pt" 
                ForeColor="White" HorizontalAlign="Left" Width="250px" />
            <ItemStyle Font-Names="Tahoma" Font-Size="10pt" Width="250px" />
            </asp:BoundField>
        </Columns>
        <SelectedRowStyle BackColor="#66CCFF" />
    </asp:GridView>
    
        <asp:HiddenField ID="hdnClientID" runat="server"/>
        <asp:HiddenField ID="hdnAccountNo" runat="server"/>
        <asp:HiddenField ID="hdnStartDate" runat="server"/>
        <asp:HiddenField ID="hdnEndDate" runat="server"/>
        <asp:LinkButton ID="lnkView" runat="server" />

</asp:Content>