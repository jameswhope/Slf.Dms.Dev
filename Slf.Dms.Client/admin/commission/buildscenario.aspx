<%@ Page AutoEventWireup="false" CodeFile="buildscenario.aspx.vb" Inherits="admin_commission_buildscenario"
    Language="VB" MasterPageFile="~/admin/settings/settings.master" %>

<asp:Content ID="cphBody" runat="Server" ContentPlaceHolderID="cphBody">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script language="javascript" type="text/javascript">
        var backup;
        
        function AddRec(entryTypeID, parentCommStructID)
        {
            document.getElementById('<%=hdnEntryTypeID.ClientID %>').value = entryTypeID;
            document.getElementById('<%=hdnParentCommStructID.ClientID %>').value = parentCommStructID;
            // reset fields
            document.getElementById('<%=hdnCommFeeID.ClientID %>').value = '';
            document.getElementById('<%=hdnCommRecIDs.ClientID %>').value = '-1|-1'; // CommRecTypeID|CommRecID
            document.getElementById('<%=hdnCommRec.ClientID %>').value = '';
            document.getElementById('<%=hdnPercent.ClientID %>').value = '';
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkAddRec, Nothing) %>;
        }
        
        function EditRec(commFeeID)
        {
            document.getElementById('<%=hdnCommFeeID.ClientID %>').value = commFeeID;
            <%=Page.ClientScript.GetPostBackEventReference(lnkEditRec, Nothing) %>;
        }
        
        /*function EditDeposit()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkEditDeposit, Nothing) %>;
        }
        
        function EditMaster()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkEditMaster, Nothing) %>;
        }*/
        
        function RemoveRec(commFeeID)
        {
            document.getElementById('<%=hdnCommFeeID.ClientID %>').value = commFeeID;
            <%=Page.ClientScript.GetPostBackEventReference(lnkRemoveRec, Nothing) %>;
        }
        
        function CancelAddEdit()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkCancelAddEdit, Nothing) %>;
        }
        
        function RemoveFeeType(entryTypeID)
        {
            document.getElementById('<%=hdnEntryTypeID.ClientID %>').value = entryTypeID;
            <%=Page.ClientScript.GetPostBackEventReference(lnkRemoveFeeType, Nothing) %>;
        }
        
        function selCommRecType_onchange(sel, caller)
        {
            var prefix = caller.options[caller.selectedIndex].value;
            if (backup == null)
            {
                makeBackup(sel.options);
            }
            sel.disabled = '';
            makeOptions(sel, prefix);
        }
        
        /* Set to trigger when editing deposit(trust) and master(gca) accounts only
        function selCommRec_onchange(sel, isDeposit)
        {
            document.getElementById('<%=hdnCommRec.ClientID %>').value = sel.options[sel.selectedIndex].innerHTML;
            document.getElementById('<%=hdnCommRecIDs.ClientID %>').value = sel.options[sel.selectedIndex].value;
            
            if (isDeposit == 1)
                <%=Page.ClientScript.GetPostBackEventReference(lnkSaveDeposit, Nothing) %>;
            else
                <%=Page.ClientScript.GetPostBackEventReference(lnkSaveMaster, Nothing) %>;
        }*/
        
        function txtValue_onblur(sel, caller)
        {
            document.getElementById('<%=hdnCommRecIDs.ClientID %>').value = sel.options[sel.selectedIndex].value; // CommRecTypeID|CommRecID
            document.getElementById('<%=hdnCommRec.ClientID %>').value = sel.options[sel.selectedIndex].innerHTML;
            document.getElementById('<%=hdnPercent.ClientID %>').value = caller.value;
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkSaveRec, Nothing) %>;
        }
        
        function makeBackup(ops)
        {
            backup = new Array(ops.length);
            for (var i=0; i<ops.length; i++)
            {
                backup[i] = new Option(ops[i].innerHTML, ops[i].value);
            }
        }
        
        function makeOptions(sel, prefix)
        {
            var j=0;
            for (var i = 0; i< backup.length; i++)
            {
                var thisop = backup[i];
                if (thisop.value.indexOf(prefix+'|')==0)
                {
                    sel.options[j] = thisop;
                    j++;
                }
            }
            sel.options.length = j;
        }
        
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        
        function CheckAll()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkCheckAll, Nothing) %>;
        }
        
        function Assign()
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx") %>?f=AssignConfirm&t=Assign Scenario&m=Are you sure you want to assign this scenario to the selected agency(s)?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Assign Scenario",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 300, scrollable: false});  
        }
        
        function AssignConfirm()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkAssign, Nothing) %>;
        }
        
        function ShowMessageHolder(title, msg)
        {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx")%>?t='+title+'&m='+msg;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: title,
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400, scrollable: false});  
        }
        
        function hideCalendar(oCalendar)
        {
            oCalendar.hide();
            oCalendar.get_element().blur();
        }
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
            <asp:ScriptReference Path="~/jquery/json2.js" />
            <asp:ScriptReference Path="~/jquery/jquery.modaldialog.js" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <img id="Img2" runat="server" src="~/images/grid_top_left.png" border="0" />
                    </td>
                    <td style="width: 100%;">
                        <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                            background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                            font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                            border="0">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlCommScenCompany" runat="server" CssClass="entry2">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 15;">
                                    &nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlCommScen" runat="server" CssClass="entry2" DataSourceID="dsCommScen"
                                        DataTextField="scenario" DataValueField="commscenid">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="dsCommScen" runat="server" SelectCommandType="Text" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                                        SelectCommand="select s.commscenid,'(' + cast(s.commscenid as varchar(10)) + ') ' + '(' + cast(s.agencyid as varchar(10)) + ') ' + a.name + ' ' + convert(varchar(10),s.startdate,101) + '-' + convert(varchar(10),isnull(s.enddate,'1/1/2050'),101) + ' (' + convert(varchar(5),s.retentionfrom) + '-' + convert(varchar(5),s.retentionto) + ')' [scenario] from tblcommscen s join tblagency a on a.agencyid = s.agencyid order by s.agencyid, s.startdate, s.enddate, s.retentionfrom, s.retentionto">
                                    </asp:SqlDataSource>
                                </td>
                                <td style="width: 15;">
                                    &nbsp;
                                </td>
                                <td nowrap="true">
                                    <asp:Button ID="btnLoad" runat="server" Text="Load Scenario" CssClass="entry2" />
                                </td>
                                <td style="width: 100%;">
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table id="tblBody" runat="server" border="0" cellpadding="0" cellspacing="10" width="100%">
                <tr id="trInfoBox" runat="server" visible="false">
                    <td colspan="3">
                        <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                            <tr>
                                <td style="width: 16;" valign="top">
                                    <img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png" />
                                </td>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblInfoBox" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="width: 55%">
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; font-family: tahoma;
                            font-size: 11px;">
                            <tr>
                                <td style="padding: 5; background-color: #f1f1f1;">
                                    <span style="color: rgb(50,112,163)">Add Fee Type</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5">
                                    <asp:DropDownList ID="ddlFeeTypes" runat="server" CssClass="entry2" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 10px">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5; background-color: #f1f1f1;">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; font-family: tahoma;
                                        font-size: 11px;">
                                        <tr>
                                            <td>
                                                <span style="color: rgb(50,112,163)">Commission Scenario</span>
                                            </td>
                                            <td align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;">
                                                    <tr>
                                                        <td>
                                                            <span style="color: rgb(50,112,163)">Format:</span>
                                                        </td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rblFormat" runat="server" AutoPostBack="true" BorderStyle="None"
                                                                CellPadding="0" CellSpacing="0" CssClass="entry2" RepeatDirection="horizontal">
                                                                <asp:ListItem Text="% of Total" Selected="true"></asp:ListItem>
                                                                <asp:ListItem Text="% of Percent"></asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td id="tdScenario" runat="server" style="padding: 0px 5px 0px 5px">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width: 5px; background-image: url(../../images/arrow_vertical.png); background-repeat: repeat-y;
                        background-position: left">
                    </td>
                    <td valign="top">
                        <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;">
                            <tr>
                                <td style="padding: 5; background-color: #f1f1f1;" nowrap="nowrap">
                                    <span style="color: rgb(50,112,163)">Settlement Attorney</span>
                                </td>
                                <td style="padding: 5; background-color: #f1f1f1;">
                                    <span style="color: rgb(50,112,163)">Start Date</span>
                                </td>
                                <td style="padding: 5; background-color: #f1f1f1;">
                                    <span style="color: rgb(50,112,163)">End Date</span>
                                </td>
                                <td style="padding: 5; background-color: #f1f1f1;" nowrap="nowrap">
                                    <span style="color: rgb(50,112,163)">Ret From</span>
                                </td>
                                <td style="padding: 5; background-color: #f1f1f1;" nowrap="nowrap">
                                    <span style="color: rgb(50,112,163)">Ret To</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5">
                                    <asp:DropDownList ID="ddlCompany" CssClass="entry2" AutoPostBack="true" runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td style="padding: 5">
                                    <asp:TextBox ID="txtStartDate" runat="server" Width="100px" CssClass="entry2"></asp:TextBox>
                                </td>
                                <td style="padding: 5">
                                    <asp:TextBox ID="txtEndDate" runat="server" Width="100px" CssClass="entry2"></asp:TextBox>
                                </td>
                                <td style="padding: 5">
                                    <asp:TextBox ID="txtRetFrom" runat="server" Width="35px" CssClass="entry2" MaxLength="4"
                                        Text="0"></asp:TextBox>
                                </td>
                                <td style="padding: 5">
                                    <asp:TextBox ID="txtRetTo" runat="server" Width="35px" CssClass="entry2" Text="9999"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 10px" colspan="5">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5; background-color: #f1f1f1;" colspan="5">
                                    <span style="width: 20;">
                                        <img id="imgCheckAll" runat="server" alt="Check All" border="0" onclick="CheckAll();"
                                            src="~/images/11x11_checkall.png" style="cursor: pointer;" />
                                    </span><span style="color: rgb(50,112,163)">Agency</span><asp:LinkButton ID="lnkCheckAll"
                                        runat="server"></asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5" valign="top">
                                    <asp:CheckBoxList ID="cblAgency" runat="server" CssClass="entry2" RepeatColumns="2"
                                        RepeatDirection="vertical">
                                    </asp:CheckBoxList>
                                    <br />
                                    <span style="color: blue">*Selecting these agencies will create a new scenario.</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkAssign" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkAddRec" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkEditRec" runat="server"></asp:LinkButton>
            <!--<asp:LinkButton ID="lnkEditDeposit" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkEditMaster" runat="server"></asp:LinkButton>-->
            <asp:LinkButton ID="lnkSaveRec" runat="server"></asp:LinkButton>
            <!--<asp:LinkButton ID="lnkSaveDeposit" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkSaveMaster" runat="server"></asp:LinkButton>-->
            <asp:LinkButton ID="lnkRemoveFeeType" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkRemoveRec" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkCancelAddEdit" runat="server"></asp:LinkButton>
            <asp:HiddenField ID="hdnEntryTypeID" runat="server" />
            <asp:HiddenField ID="hdnCommStructID" runat="server" />
            <asp:HiddenField ID="hdnParentCommStructID" runat="server" />
            <asp:HiddenField ID="hdnCommRec" runat="server" />
            <asp:HiddenField ID="hdnCommRecIDs" runat="server" />
            <asp:HiddenField ID="hdnPercent" runat="server" />
            <asp:HiddenField ID="hdnCommFeeID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
