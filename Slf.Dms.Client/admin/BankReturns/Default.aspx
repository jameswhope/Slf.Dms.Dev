<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_BankReturns_Default" Title="Bank Check/ACH Returns" MasterPageFile="~/Site.Master" %>

 <%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>

    <%@ Register Assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebCombo" tagprefix="igcmbo" %>
    
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
    
    <igtbl:UltraWebGrid ID="grdReturnedItems" runat="server" Height="100%" Width="100%" CaptionAlign="Left">
        <bands>
            <igtbl:UltraGridBand AllowAdd="No" AllowDelete="No" AllowSorting="Yes"
                AllowUpdate="Yes">
                <addnewrow view="NotSet" visible="NotSet">
                </addnewrow>
                <Columns>
                    <igtbl:UltraGridColumn BaseColumnName="ClientID" DataType="System.Int64" 
                        Hidden="True" Key="ClientID">
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn BaseColumnName="RegisterID" DataType="System.Int64" 
                        Hidden="True" Key="RegisterID">
                        <Header>
                            <RowLayoutColumnInfo OriginX="1" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="1" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="AccountNo" 
                        FieldLen="75" Key="AccountNo" Type="HyperLink" Width="100px">
                        <ValueList Key="AccountNo">
                        </ValueList>
                        <Header Caption="Lexx-Account">
                            <RowLayoutColumnInfo OriginX="2" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="2" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="ClientName" 
                        FieldLen="250" Key="ClientName" Width="250px">
                        <ValueList Key="ClientName">
                        </ValueList>
                        <Header Caption="Client Name">
                            <RowLayoutColumnInfo OriginX="3" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="3" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="RoutingNumber" 
                        FieldLen="9" Key="RoutingNumber" Width="100px">
                        <ValueList Key="RoutingNumber">
                        </ValueList>
                        <Header Caption="Routing Number">
                            <RowLayoutColumnInfo OriginX="4" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="4" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="AccountNumber" 
                        Key="AccountNumber" Width="125px">
                        <Header Caption="Account Number">
                            <RowLayoutColumnInfo OriginX="5" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="5" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="Amount" 
                        Format="$ ###,###,##0.00" Key="Amount" Width="75px">
                        <Header Caption="Amount">
                            <RowLayoutColumnInfo OriginX="6" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="6" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" BaseColumnName="LawFirm" 
                        FieldLen="200" Key="LawFirm" Width="200px">
                        <Header Caption="Law Firm">
                            <RowLayoutColumnInfo OriginX="7" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="7" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" 
                        BaseColumnName="SettlementDate" FieldLen="15" Format="MM/dd/yyyy" 
                        Key="SettlementDate" Width="80px">
                        <Header Caption="Settlement Date">
                            <RowLayoutColumnInfo OriginX="8" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="8" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                    <igtbl:UltraGridColumn AllowRowFiltering="False" 
                        BaseColumnName="BouncedDescription" Key="BouncedDescription" Width="250px">
                        <Header Caption="Description">
                            <RowLayoutColumnInfo OriginX="9" />
                        </Header>
                        <Footer>
                            <RowLayoutColumnInfo OriginX="9" />
                        </Footer>
                    </igtbl:UltraGridColumn>
                </Columns>
            </igtbl:UltraGridBand>
        </bands>
        <displaylayout allowcolsizingdefault="Free" allowcolumnmovingdefault="OnClient" allowsortingdefault="Yes" 
            allowupdatedefault="Yes" bordercollapsedefault="Separate"
            headerclickactiondefault="SortMulti" name="UltraWebGrid1" CellClickActionDefault="RowSelect"
            rowheightdefault="20px" rowselectorsdefault="No" selecttyperowdefault="Single" 
            StationaryMarginsOutlookGroupBy="True" 
            tablelayout="Fixed" usefixedheaders="True" version="4.00" 
            AutoGenerateColumns="true" 
            ViewType="OutlookGroupBy">
            <framestyle backcolor="Window" bordercolor="InactiveCaption" 
                borderstyle="Double" borderwidth="3px" font-names="Verdana" 
                font-size="8pt" height="100%" width="100%" Cursor="Default" 
                ForeColor="Black">
            </framestyle>
            <Images>
                <FilterImage Url="~/../ig_res/images/ig_tblFilter.gif" />
            </Images>
            <ClientSideEvents AfterCellUpdateHandler="grdReturnedItems_AfterCellUpdateHandler" />
            <pager minimumpagesfordisplay="2" PageSize="35">
                <PagerStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                    widthtop="1px" />
                </PagerStyle>
            </pager>
            <editcellstyledefault borderstyle="None" 
            borderwidth="0px">
            </editcellstyledefault>
            <footerstyledefault backcolor="LightGray" borderstyle="Solid" borderwidth="1px">
                <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                    widthtop="1px" />
            </footerstyledefault>
            <headerstyledefault backcolor="#4684B4" borderstyle="Solid" horizontalalign="Left" Cursor="Hand" ForeColor="White">
                <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                    widthtop="1px" />
            </headerstyledefault>
            <rowstyledefault backcolor="White" bordercolor="Gray" borderstyle="None" 
                borderwidth="1px" font-names="Verdana" font-size="8pt">
                <padding left="3px" />
                <borderdetails colorleft="White" colortop="White" />
            </rowstyledefault>
            <groupbyrowstyledefault backcolor="Control" bordercolor="Window" 
            ForeColor="Black">
            </groupbyrowstyledefault>
            <SelectedRowStyleDefault BackColor="#5796DE" 
            ForeColor="Black">
            </SelectedRowStyleDefault>
            <groupbybox>
                <BandLabelStyle ForeColor="Black">
                </BandLabelStyle>
                <boxstyle backcolor="Khaki" bordercolor="Window">
                </boxstyle>
            </groupbybox>
            <addnewbox hidden="False">
                <boxstyle backcolor="LightGray" bordercolor="InactiveCaption" borderstyle="Solid" 
                    borderwidth="1px">
                    <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                        widthtop="1px" />
                </boxstyle>
            </addnewbox>
            <activationobject bordercolor="Black" 
            borderwidth="">
            </activationobject>
            <FixedHeaderStyleDefault BackColor="SteelBlue" 
            ForeColor="White">
            </FixedHeaderStyleDefault>
            <filteroptionsdefault FilterUIType="HeaderIcons" AllowRowFiltering="OnServer" AllString="(All)">
                <filterdropdownstyle CssClass="FilterList">
                    <padding left="2px" />
                </filterdropdownstyle>
                <filterhighlightrowstyle backcolor="#151C55" forecolor="White" 
                    BorderColor="White" Cursor="Hand">
                </filterhighlightrowstyle>
                <FilterRowStyle BorderColor="Black">
                </FilterRowStyle>
                <filteroperanddropdownstyle backcolor="White" bordercolor="Silver" 
                    borderstyle="Solid" borderwidth="1px" customrules="overflow:auto;" 
                    font-names="Verdana,Arial,Helvetica,sans-serif" font-size="11px">
                    <padding left="2px" />
                </filteroperanddropdownstyle>
            </filteroptionsdefault>
         </displaylayout>
</igtbl:UltraWebGrid>

        <asp:HiddenField ID="hdnClientID" runat="server"/>
        <asp:HiddenField ID="hdnAccountNo" runat="server"/>
        <asp:HiddenField ID="hdnStartDate" runat="server"/>
        <asp:HiddenField ID="hdnEndDate" runat="server"/>
        <asp:LinkButton ID="lnkView" runat="server" />

</asp:Content>