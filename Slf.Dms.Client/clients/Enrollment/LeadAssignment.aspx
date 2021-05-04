<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LeadAssignment.aspx.vb" Inherits="Clients_Enrollment_LeadAssignment" Title="Lead Assignment" MasterPageFile="~/Site.master"%>

    <%@ Register assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>

    <%@ Register assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebCombo" tagprefix="igcmbo" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
   <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
   <style type="text/css">
        .FilterList { PADDING-RIGHT: 3px; PADDING-LEFT: 3px; FONT-SIZE: 9pt; FILTER: progid:DXImageTransform.Microsoft.Alpha(opacity=95); BACKGROUND-IMAGE: url(options.png); PADDING-BOTTOM: 10px; OVERFLOW: auto; WIDTH: 150px; COLOR: black; PADDING-TOP: 10px; FONT-FAMILY: verdana; HEIGHT: 280px; BACKGROUND-COLOR: #f1f1f1; opacity: .95 }
        .FilterList TABLE { WIDTH: 182px }
        .FilterList TD { PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 2px; PADDING-TOP: 2px; TEXT-ALIGN: left }
        .FilterHighlight { BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; FONT-WEIGHT: bold; BORDER-LEFT: black 1px solid; CURSOR: default; COLOR: white; BORDER-BOTTOM: black 1px solid; BACKGROUND-COLOR: #3c7fb1 }
    </style>
   <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
   <script type="text/javascript" >
    
    var LeadApplicantID = null;
    var RepID = null;
    var StatusID = null;
    var StateID = null;
    var Aging = null;
    var i = 0
    var leads = new Array();
    var check = null;
    
    function AssignRep()
    {
        <%= ClientScript.GetPostBackEventReference(lnkAssignRep, Nothing) %>;
    }
    function View()
    {
        LeadApplicantID = document.getElementById("<%= ddlSelApplicant.ClientID %>");
        document.getElementById("<%=hdnApplicantID.ClientID %>").value = LeadApplicantID.value;
        RepID = document.getElementById("<%= ddlSelReps.ClientID %>");
        document.getElementById("<%=hdnRepID.ClientID %>").value = RepID.value;
        StateID = document.getElementById("<%= ddlSelState.ClientID %>");
        document.getElementById("<%=hdnStateID.ClientID %>").value = StateID.value;
        StatusID = document.getElementById("<%= ddlSelStatus.ClientID %>");
        document.getElementById("<%=hdnStatusID.ClientID %>").value = StatusID.value;
        Aging = document.getElementById("<%= ddlSelAging.ClientID %>");
        document.getElementById("<%=hdnAging.ClientID %>").value = Aging.value;
        <%= ClientScript.GetPostBackEventReference(lnkView, Nothing) %>;
    }
    function CheckAll()
    {
        check = document.getElementById("<%= CkAll.ClientID %>");
        document.getElementById("<%=hdnChecked.ClientID %>").value = check.checked;
//         <%= ClientScript.GetPostBackEventReference(lnkCkBox, Nothing) %>;
    }
    function grdLeadAssignment_BeforeFilterPopulated(gridName,oColumnFilter,oColumn, workingFilterList, lastKnownFilterList)
        {
            if (oColumn.Key=="ContactTitle")
            {
                return true;
            }
            if (lastKnownFilterList)
            {
                oColumnFilter.setWorkingFilterList(lastKnownFilterList);
                return true;
            }
            
            window.status = "Populating Filter.  Please wait........";
        }
    function UltraWebGrid1_AfterFilterPopulated(gridName, oColumn, workingList){

        window.status = "Filter Populated.";
    }

	 function ModifyAging()
    {
        var url = '<%= ResolveUrl("~/util/pop/aging.aspx") %>';
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Modify Aging",
                dialogArguments: window,
                resizable: false,
                scrollable: true,
                height: 700, width: 500,
                onClose: function(){
                            window.location = window.location;
                        }
            });
    }

    function grdLeadAssignment_AfterCellUpdateHandler(gn, cellId)
    {
        var checkbox = igtbl_getCellById(cellId);
        var leadId = document.getElementById("<%= grdLeadAssignment.ClientID %>");
 
        if (checkbox.text == true)
            {
                i = leads.length +1;
                leads[i] = leadId;
                hdnleads.text += "|" + leadId[i];    
            }
//        else
//            {
//                alert("The Checkbox was Un-Checked I think");
//            }  
     }
    
  </script> 
     
   <asp:SqlDataSource ID="SqlDataSource2" 
            runat="server"> 
        </asp:SqlDataSource>
  
   <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="imgSpacer" runat="server" width="8" height="1" src="~/images/spacer.gif"/>
            </td>
            <td style="height: 28px" valign="middle">
                <a id="btnEnrollment" runat="server" class="menuButton" href="Default.aspx">
                    <img id="imgHome" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_web_home.png" atl=" " />Enrollment</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;" valign="middle">
                <a id="btnAging" runat="server" class="menuButton" onclick="javascript:ModifyAging();" href="#">
                    <img id="img2" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_calendar.png" atl=" " />Modify Aging</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;" valign="middle">
                <a id="btnSave" runat="server" class="menuButton" onclick="javascript:AssignRep();" href="#">
                    <img id="imgSave" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_Save.png" alt= " " />Assign New Rep.</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="white-space:nowrap" valign="middle">
                &nbsp;
                <asp:Label width="100px" ID="lblRep" Height="16px" runat="server" Text="Choose a New Rep:" Font-Names="tahoma" Font-Size="11px"></asp:Label>
            </td>
            <td>
                <asp:dropdownlist ID="ddlReps" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Rep" DataValueField="UserID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Choose a Law Firm Rep to assign these clients to." 
                    DataSourceID="SqlDataSource2">
                </asp:dropdownlist>
            </td>
<%--            <td class="menuSeparator">
                |
            </td>--%>
            <td style="white-space:nowrap; width: 100%; padding-left:5;" valign="middle">
                &nbsp;
                <asp:Label ID="lblCount" Height="16px" runat="server" ForeColor="Black" Font-Names="tahoma" Font-Size="11px" Font-Bold="true"></asp:Label>
            </td>
        </tr>
    </table>
    
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../../FormMgr/FormMgr.css" rel="stylesheet" type="text/css" />
    
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" 
        runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    
    <table   cellspacing="5" style="width: 100%">
       <tr style="background-color:#F0E68C;">
            <td style="height: 4px; font-family:tahoma; font-size:11px; font-weight:bold; width:105px;" 
                valign="middle">
                    <asp:CheckBox id="ckAll" name="Ck1" runat="server" width="75px" Text="Select All" nowrap="nowrap" autopostback = "true" OnCheckedChanged="Check_All"/>
            </td>
            <td style="width: 320px; font-family:Tahoma; font-size:11; font-weight: Bold; height: 4px;" align="left" 
                valign="middle">Applicant &nbsp;
                <asp:dropdownlist ID="ddlSelApplicant" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Applicant" DataValueField="LeadApplicantID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Select an Applicant.">
                    <asp:ListItem Text="-- All --"></asp:ListItem>
                </asp:dropdownlist>
            </td>
            <td style="width: 180px; font-family: Tahoma; font-size: 11; font-weight: Bold; height: 4px;" align="left" 
                valign="middle">State
                &nbsp;
                <asp:dropdownlist ID="ddlSelState" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Abbreviation" DataValueField="StateID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Choose a state.">
                    <asp:ListItem Text="-- All --"></asp:ListItem>
                </asp:dropdownlist>
            </td>
            <td style="width: 190px; font-family: Tahoma; font-size: 11; font-weight: Bold; height: 4px;" align="left" 
                valign="middle">Status
                &nbsp;
                <asp:dropdownlist ID="ddlSelStatus" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Description" DataValueField="StatusID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Choose a Status.">
                    <asp:ListItem Text="-- All --"></asp:ListItem>
                </asp:dropdownlist>
            </td>
            <td style="width: 165px; font-family: Tahoma; font-size: 11; font-weight: Bold; height: 4px;" align="left" 
                valign="middle">Rep.
                &nbsp;
                <asp:dropdownlist ID="ddlSelReps" runat="server" CssClass="entry2" TabIndex="1" 
                    DataTextField="Rep" DataValueField="UserID" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Choose a Law Firm Rep Assignments to View.">
                    <asp:ListItem Text="-- All --"></asp:ListItem>
                    <asp:ListItem Text="**Unassigned**"></asp:ListItem>
                </asp:dropdownlist>
            </td>
            <td style="width: 170px; font-family: Tahoma; font-size: 11; font-weight: Bold; height: 4px;" align="left" valign="middle">Past
                &nbsp;
                <asp:dropdownlist ID="ddlSelAging" runat="server" CssClass="entry2" TabIndex="1" 
                    Font-Names="Tahoma" Font-Size="11px" 
                    ToolTip="Choose Applicant Aging."
                    DataTextField="Aging">
                    <asp:ListItem Text="-- All --"></asp:ListItem>
                </asp:dropdownlist>&nbsp; Days
            </td>
            <td valign="middle" style="font-family: Tahoma; font-weight:bold; width:10">
                <a id="A1" runat="server" class="menuButton" onclick="javascript:View();" href="#">
                    <img id="img1" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_Report.png" alt= " " />View</a>
            </td>
        </tr>
    </table>
    
    <igtbl:UltraWebGrid ID="grdLeadAssignment" runat="server" Height="100%" Width="100%" CaptionAlign="Left">
        <bands>
            <igtbl:UltraGridBand AllowAdd="No" AllowDelete="No" AllowSorting="Yes"
                AllowUpdate="Yes" DataKeyField="LeadApplicantID">
                <addnewrow view="NotSet" visible="NotSet">
                </addnewrow>
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
                <FilterImage Url="./images/ig_tblFilter.gif" />
            </Images>
            <ClientSideEvents AfterCellUpdateHandler="grdLeadAssignment_AfterCellUpdateHandler" />
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
            <%--<CLIENTSIDEEVENTS BeforeFilterPopulated="grdLeadAssignment_BeforeFilterPopulated" 
            AfterFilterPopulated="grdLeadAssignment_AfterFilterPopulated">
            </CLIENTSIDEEVENTS>--%>
        </displaylayout>
</igtbl:UltraWebGrid>

        <asp:LinkButton ID="lnkAssignRep" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkView" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkCkBox" runat="server"></asp:LinkButton>
        <asp:HiddenField ID="hdnApplicantID" runat="server"/>
        <asp:HiddenField ID="hdnRepID" runat="server"/>
        <asp:HiddenField ID="hdnStateID" runat="server"/>
        <asp:HiddenField ID="hdnStatusID" runat="server"/>
        <asp:HiddenField ID="hdnAging" runat="server"/>
        <asp:HiddenField ID="hdnLeads" runat="server"/>
        <asp:HiddenField ID="hdnChecked" runat="server"/>

</asp:Content>
        