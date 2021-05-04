﻿<%@ Page Title="" Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="admin_checkscan_Default" EnableEventValidation="false"
    Async="true" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.19/themes/redmond/jquery-ui.css"
        rel="stylesheet" />
    <style type="text/css">
        .sideRollupCellBodyScan
        {
            border-bottom: rgb(112,168,209) 1px solid;
            border-left: rgb(112,168,209) 1px solid;
            border-right: rgb(112,168,209) 1px solid;
            padding-bottom: 5px;
        }
        .navCell
        {
            padding: 3px 5px 3px 5px;
        }
        .cellHdr
        {
            background-color: #DCDCDC;
            padding: 3px;
            width: 75px;
        }
        .cellCnt
        {
            background-color: #F0E68C;
            padding: 3px;
        }
        .totHdr
        {
            width: 100%;
            background-color: #F0E68C;
            text-align: center;
            font-weight: bold;
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .totCnt
        {
            text-align: center;
            padding-top: 3px;
            padding-bottom: 3px;
        }
    </style>

    <ajaxToolkit:ToolkitScriptManager ID="smCheckScan" runat="server" EnablePageMethods="true"
        AsyncPostBackTimeout="360000">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.19/jquery-ui.min.js"
                ScriptMode="Release" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="upCheckScan" runat="server">
        <ContentTemplate>
            <table id="pageContent" runat="server" style="width: 100%; height: 100%;" cellpadding="0"
                cellspacing="0" border="0">
                <tr>
                    <td style="width: 200px!important; background-color: rgb(214,231,243); padding-top: 35px;"
                        valign="top">
                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                            cellspacing="0" border="0">
                            <tr>
                                <td style="padding: 15 15 20 15;">
                                    <asp:Panel ID="pnlNavHdr" runat="server" CssClass="sideRollupCellHeader" Height="30px"
                                        Width="200px">
                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                            <div style="float: left;">
                                                Common Tasks</div>
                                            <div style="float: right; vertical-align: middle;">
                                                <asp:ImageButton ID="imgHeader" runat="server" ImageUrl="~/images/expand.png" AlternateText="(Show Links...)" />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlNavContent" runat="server" CssClass="sideRollupCellBodyScan" Width="200px">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton ID="lnkScan" runat="server" Text="Scan Checks" CssClass="lnk" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton ID="lnkSaveDeposit" runat="server" Text="Save Deposit" CssClass="lnk" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <hr />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton ID="lnkICLReports" runat="server" Text="View ICL Reports" CssClass="lnk" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <hr />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton CssClass="lnk" ID="lnkProcessBatches" runat="server" Text="Process Batch(es)"
                                                     OnClientClick="return ProcessBatch();" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton CssClass="lnk" ID="lnkMergeBatches" runat="server" Text="Merge Batch(es)" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:LinkButton CssClass="lnk" ID="lnkDeleteBatches" runat="server" OnClientClick="return confirm('Are you sure you want to delete this batch(es)?');"
                                                        Text="Delete Batch(es)" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <ajaxToolkit:CollapsiblePanelExtender ID="cpeDemo" runat="Server" TargetControlID="pnlNavContent"
                                        ExpandControlID="pnlNavHdr" CollapseControlID="pnlNavHdr" Collapsed="False" AutoExpand="false"
                                        ImageControlID="imgHeader" ExpandedText="(Hide Links...)" CollapsedText="(Show Links...)"
                                        ExpandedImage="~/images/collapse.png" CollapsedImage="~/images/expand.png" SuppressPostBack="true"
                                        CollapsedSize="1" />
                                    <br />
                                    <div id="dvMsg" runat="server" style="display: none; vertical-align: top; padding: 5px;
                                        width: 100%!important; min-height: 50px">
                                    </div>
                                    <br />
                                    <asp:Panel ID="pnlResultsHdr" runat="server" CssClass="sideRollupCellHeader" Style="border: solid 1px #4791C5;
                                        height: 25px!important">
                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                            <div style="float: left;">
                                                Results</div>
                                            <div style="float: right; vertical-align: middle;">
                                                <asp:ImageButton ID="imgResultsHdr" runat="server" ImageUrl="~/images/expand.png"
                                                    AlternateText="(Show Links...)" />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlResultsContent" runat="server" CssClass="collapsePanel">
                                    </asp:Panel>
                                    <ajaxToolkit:CollapsiblePanelExtender AutoExpand="false" ID="cpeResults" runat="Server"
                                        TargetControlID="pnlResultsContent" ExpandControlID="pnlResultsHdr" CollapseControlID="pnlResultsHdr"
                                        Collapsed="False" CollapsedSize="1" ImageControlID="imgResultsHdr" ExpandedText="(Hide Links...)"
                                        CollapsedText="(Show Links...)" ExpandedImage="~/images/collapse.png" CollapsedImage="~/images/expand.png"
                                        SuppressPostBack="true" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <div style="padding: 10px;" class="entry" id="divCheckScan">
                            <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/default.aspx">
                                            Admin</a>&nbsp>&nbsp;Scan Checks
                                    </td>
                                </tr>
                                <tr valign="top">
                                    <td>
                                        <table class="entry">
                                            <tr>
                                                <td>
                                                    <fieldset class="entry" style="padding: 10px; height: 300px;">
                                                        <legend>Scanned Checks</legend>
                                                        <asp:GridView ID="gvUnverified" runat="server" CssClass="entry" AllowPaging="True"
                                                            PageSize="1" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="CheckID"
                                                            DataSourceID="dsUnverified">
                                                            <RowStyle CssClass="checkRow" />
                                                            <PagerStyle BackColor="#DCDCDC" Font-Names="Tahoma" Font-Size="Smaller" />
                                                            <Columns>
                                                                <asp:BoundField DataField="CheckID" ReadOnly="true" Visible="false" />
                                                                <asp:TemplateField InsertVisible="False" SortExpression="Amount">
                                                                    <EditItemTemplate>
                                                                        <table class="entry">
                                                                            <tr valign="top">
                                                                                 <td style="text-align: left; width: 300px;">
                                                                                    <table class="entry" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Client Name:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label ID="lblClientName" runat="server" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Routing:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:TextBox CssClass="entry2" ID="txtRouting" runat="server" Text='<%# Eval("Routing") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Account:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:TextBox CssClass="entry2" ID="txtAccount" runat="server" Text='<%# Bind("Account") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Amount:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:TextBox CssClass="entry2" ID="txtAmount" runat="server" Text='<%# Bind("Amount","{0:N2}") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                CheckNumber:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:TextBox ID="txtCheckNumber" CssClass="entry2" runat="server" Text='<%# Eval("CheckNumber") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                CheckType:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("CheckType") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Verified Date:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblVerified" runat="server" Text='<%# Eval("verified") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Process Date:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblProcess" runat="server" Text='<%# Eval("processed") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="2">
                                                                                                <div style="white-space: nowrap;">
                                                                                                    <div id="dvCheckStatus" runat="server" style="float: left; width: 100%; display: inline-block" />
                                                                                                    <div id="dvClientStatus" runat="server" style="float: left; width: 100%;" />
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td style="text-align: left;">
                                                                                    <ajaxToolkit:TabContainer ID="tbChecks" runat="server" CssClass="tabContainer">
                                                                                        <ajaxToolkit:TabPanel ID="tabFront" runat="server">
                                                                                            <HeaderTemplate>
                                                                                                Front</HeaderTemplate>
                                                                                            <ContentTemplate>
                                                                                                <div style="padding: 5px;">
                                                                                                    <asp:Image ID="imgEditFront" runat="server" ImageUrl='<%# Eval("frontimagepath", "getCheckImage.ashx?fid={0}") %>' />
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </ajaxToolkit:TabPanel>
                                                                                        <ajaxToolkit:TabPanel ID="tabBack" runat="server">
                                                                                            <HeaderTemplate>
                                                                                                Back</HeaderTemplate>
                                                                                            <ContentTemplate>
                                                                                                <div style="padding: 5px;">
                                                                                                    <asp:Image ID="imgEditBack" runat="server" ImageUrl='<%# Eval("backimagepath", "getCheckImage.ashx?fid={0}") %>' />
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </ajaxToolkit:TabPanel>
                                                                                    </ajaxToolkit:TabContainer>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                <div class="btnBar">
                                                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update"
                                                                                        Text="Update" CssClass="lnk" OnClientClick="return CheckVerification();" />
                                                                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                                                        Text="Cancel" CssClass="lnk" />
                                                                                        </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </EditItemTemplate>
                                                                    <ItemTemplate>
                                                                        <table class="entry" style="height: 250px;">
                                                                            <tr valign="top">
                                                                                <td style="text-align: left; width: 300px;">
                                                                                    <table class="entry" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Client Name:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label ID="lblClientName" runat="server" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Routing:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:Label CssClass="entry2" ID="txtRouting" runat="server" Text='<%# Eval("Routing") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Account:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblAccount" runat="server" Text='<%# eval("Account") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Amount:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblAmount" runat="server" Text='<%# eval("Amount","{0:N2}") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                CheckNumber:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label ID="txtCheckNumber" runat="server" CssClass="entry2" Text='<%# eval("CheckNumber") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                CheckType:
                                                                                            </td>
                                                                                            <td class="cellCnt">
                                                                                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("CheckType") %>'></asp:Label>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Verified Date:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblVerified" runat="server" Text='<%# Eval("verified") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="cellHdr">
                                                                                                Process Date:
                                                                                            </td>
                                                                                            <td class="cellcnt">
                                                                                                <asp:Label CssClass="entry2" ID="lblProcess" runat="server" Text='<%# Eval("processed") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="2">
                                                                                                <div style="white-space: nowrap;">
                                                                                                    <div id="dvCheckStatus" runat="server" style="float: left; width: 100%; display: inline-block" />
                                                                                                    <div id="dvClientStatus" runat="server" style="float: left; width: 100%; display: inline-block" />
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td style="text-align: left;">
                                                                                    <ajaxToolkit:TabContainer ID="tbChecks" runat="server" CssClass="tabContainer entry">
                                                                                        <ajaxToolkit:TabPanel ID="tabFront" runat="server">
                                                                                            <HeaderTemplate>
                                                                                                Front</HeaderTemplate>
                                                                                            <ContentTemplate>
                                                                                                <div style="padding: 5px;">
                                                                                                    <asp:Image ID="imgFront" runat="server" ImageUrl='<%# Eval("frontimagepath", "getCheckImage.ashx?fid={0}") %>' />
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </ajaxToolkit:TabPanel>
                                                                                        <ajaxToolkit:TabPanel ID="tabBack" runat="server">
                                                                                            <HeaderTemplate>
                                                                                                Back</HeaderTemplate>
                                                                                            <ContentTemplate>
                                                                                                <div style="padding: 5px;">
                                                                                                    <asp:Image ID="imgBack" runat="server" ImageUrl='<%# Eval("backimagepath", "getCheckImage.ashx?fid={0}") %>' />
                                                                                                </div>
                                                                                            </ContentTemplate>
                                                                                        </ajaxToolkit:TabPanel>
                                                                                    </ajaxToolkit:TabContainer>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table class="entry">
                                                                            <tr>
                                                                                <td>
                                                                                    <div class="btnBar">
                                                                                        <asp:LinkButton ID="lnkVerify" runat="server" CausesValidation="False" CommandName="Edit"
                                                                                            Text="Verify Check" ToolTip="Update amount of check for client transaction."
                                                                                            CssClass="jqButton" />
                                                                                        <asp:LinkButton ID="lnkRemoveInfo" runat="server" CausesValidation="False" CommandName="RemoveCheckInfo"
                                                                                            OnClientClick="return confirm('Are you sure you want to delete this checks verification?');"
                                                                                            CommandArgument='<%#eval("checkid") %>' Text="Remove Verification" ToolTip="Removes Verification info from check."
                                                                                            CssClass="lnk" />
                                                                                    </div>
                                                                                </td>
                                                                                <td align="right">
                                                                                    <div class="btnBar">
                                                                                        <asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="False" OnClientClick="return confirm('Are you sure you want to delete this check?');"
                                                                                            CommandName="DeleteCheck" CommandArgument='<%#eval("checkid") %>' Text="Delete Check"
                                                                                            ToolTip="Delete check from batch." CssClass="jqButton" />
                                                                                        <asp:LinkButton ID="lnkRemove" runat="server" CausesValidation="False" CommandName="RemoveCheck"
                                                                                            Text="Remove from Batch" ToolTip="Removes check from batch." CssClass="lnk" CommandArgument='<%#eval("checkid") %>' />
                                                                                        <asp:LinkButton ID="lnkSwap" runat="server" CausesValidation="false" CommandName="Switch"
                                                                                            Text="Switch Front Image w/ Back" CssClass="lnk" CommandArgument='<%#Eval("CheckID") %>' />
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </ItemTemplate>
                                                                    <HeaderTemplate>
                                                                        <div style="padding: 3px;">
                                                                            Check Info
                                                                        </div>
                                                                    </HeaderTemplate>
                                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" BackColor="#3376AB" ForeColor="White" />
                                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <PagerTemplate>
                                                                <div id="pager">
                                                                    <table class="entry">
                                                                        <tr class="entry2">
                                                                            <td style="padding-left: 10px; text-align: left;">
                                                                                <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                                                    ID="btnFirst" />
                                                                                <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                                                    ID="btnPrevious" />
                                                                                -
                                                                                <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                                                    ID="btnNext" />
                                                                                <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                                                    ID="btnLast" />
                                                                            </td>
                                                                            <td style="text-align: right; padding-right: 10px;">
                                                                                Check
                                                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
                                                                                of
                                                                                <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </PagerTemplate>
                                                            <EmptyDataTemplate>
                                                                <div class="info">
                                                                    No Unverified Checks!</div>
                                                            </EmptyDataTemplate>
                                                        </asp:GridView>
                                                        <asp:SqlDataSource ID="dsUnverified" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                            SelectCommand="SELECT nc.Check21ID AS CheckID, nc.RegisterID, nc.ClientID, nc.CheckFrontPath AS frontimagepath, nc.CheckBackPath AS backimagepath, nc.CheckRouting AS routing, nc.CheckAccountNum[Account], nc.CheckAmount AS Amount, nc.CheckAuxOnus AS AuxOnUs, nc.CheckNumber, nc.CheckType, nc.CheckOnUs AS OnUs, nc.CheckRoutingCheckSum AS RoutingCheckSum, nc.CheckMicrLine AS MicrLine , [verified] = cast(nc.verified as varchar)+ ' By ' + vu.firstname + ' ' + vu.lastname,[processed] = cast(nc.processed  as varchar)+ ' By ' + pu.firstname + ' ' + pu.lastname  FROM tblICLChecks nc with(nolock) left join tbluser vu with(nolock) on vu.userid = nc.verifiedby left join tbluser pu with(nolock) on pu.userid = nc.verifiedby WHERE (nc.SaveGUID = @saveGUID) and (DeleteDate is null) AND (nc.Verified is null or @bunverifiedonly IS NULL OR @bunverifiedonly = 0)"
                                                            ProviderName="System.Data.SqlClient" UpdateCommand="UPDATE tblICLChecks SET CheckRouting = @CheckRouting, CheckAccountNum = @CheckAccountNum, CheckAmount = @CheckAmount, CheckNumber = @CheckNumber, Processed = @Processed, ProcessedBy = @ProcessedBy, Verified = @Verified, VerifiedBy = @VerifiedBy WHERE (Check21ID = @checkid)">
                                                            <SelectParameters>
                                                                <asp:Parameter Name="saveGUID" DefaultValue="-1" />
                                                                <asp:Parameter Name="bunverifiedonly" DefaultValue="0" />
                                                            </SelectParameters>
                                                            <UpdateParameters>
                                                                <asp:Parameter Name="CheckRouting" DefaultValue="-1" />
                                                                <asp:Parameter Name="CheckAccountNum" DefaultValue="-1" />
                                                                <asp:Parameter Name="CheckAmount" DefaultValue="0" />
                                                                <asp:Parameter Name="CheckNumber" DefaultValue="-1" />
                                                                <asp:Parameter Name="Processed" DefaultValue="" ConvertEmptyStringToNull="true" />
                                                                <asp:Parameter Name="ProcessedBy" DefaultValue="" ConvertEmptyStringToNull="true" />
                                                                <asp:Parameter Name="Verified" DefaultValue="" ConvertEmptyStringToNull="true" />
                                                                <asp:Parameter Name="VerifiedBy" DefaultValue="" ConvertEmptyStringToNull="true" />
                                                                <asp:Parameter Name="checkid" DefaultValue="-1" />
                                                            </UpdateParameters>
                                                        </asp:SqlDataSource>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                    <ajaxToolkit:TabContainer ID="tabActions" runat="server" CssClass="tabContainer"
                                                        ActiveTabIndex="1" Width="100%">
                                                        <ajaxToolkit:TabPanel ID="tbSearch" runat="server">
                                                            <HeaderTemplate>
                                                                Client Search</HeaderTemplate>
                                                            <ContentTemplate>
                                                                <div class="ui-widget-header" style="padding: 3px;">
                                                                    <asp:TextBox ID="txtClient" runat="server" CssClass="entry2" ToolTip="Enter Search criteria to find client" />
                                                                    <small>
                                                                        <asp:LinkButton ID="btnSearch" runat="server" Text="Search" CssClass="jqFilterButton" />
                                                                        <asp:LinkButton ID="lnkClear" runat="server" Text="Clear" CssClass="jqCancelButton" />
                                                                    </small>
                                                                    <asp:Literal ID="Literal1" runat="server" Text="  " />
                                                                    <span>(ie. Client Account Number, Last Name, Full Name ,Street, SSN)</span>
                                                                </div>
                                                                <asp:GridView ID="gvSearch" DataSourceID="dsSearch" runat="server" AutoGenerateColumns="False"
                                                                    AllowPaging="True" AllowSorting="True" CssClass="entry">
                                                                    <PagerStyle BackColor="Gainsboro" Font-Names="Tahoma" Font-Size="Smaller" />
                                                                    <Columns>
                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkAddToCheck" runat="server" Text="Add to Check" OnClick="lnkAddClientToCheck_Click" />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="50px" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="50px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" alt="" />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="clientid" ReadOnly="True" Visible="False">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Accountnumber" SortExpression="Accountnumber" HeaderText="Account #"
                                                                            ReadOnly="True">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="name" SortExpression="name" HeaderText="Name" ReadOnly="True">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="gender" SortExpression="gender" HeaderText="Gender" ReadOnly="True">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                                                        </asp:BoundField>
                                                                        <asp:TemplateField SortExpression="ssn" HeaderText="SSN">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="SSNLabel" runat="server" Text='<%#eval("SSN") %>' />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                                Contact Info</HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblAddress" runat="server" Text='<%#eval("Address") %>' /><br />
                                                                                <asp:Label ID="lblContactInfo" runat="server" Text='<%#eval("ContactInfo") %>' /><br />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                    <PagerTemplate>
                                                                        <div id="pager">
                                                                            <table class="entry">
                                                                                <tr>
                                                                                    <td style="padding-left: 10px;">
                                                                                        Page(s)
                                                                                        <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true">
                                                                                        </asp:DropDownList>
                                                                                        of
                                                                                        <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                                                    </td>
                                                                                    <td style="padding-right: 10px; text-align: right;">
                                                                                        <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                                                            ID="btnFirst" />
                                                                                        <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                                                            ID="btnPrevious" />
                                                                                        -
                                                                                        <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                                                            ID="btnNext" />
                                                                                        <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                                                            ID="btnLast" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </PagerTemplate>
                                                                    <RowStyle VerticalAlign="Top" />
                                                                </asp:GridView>
                                                                <asp:SqlDataSource ID="dsSearch" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    SelectCommandType="StoredProcedure" SelectCommand="stp_CheckScan_ClientSearch"
                                                                    ProviderName="System.Data.SqlClient">
                                                                    <SelectParameters>
                                                                        <asp:Parameter Name="searchTerm" Type="String" DefaultValue="" />
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="tbHistory" runat="server">
                                                            <HeaderTemplate>
                                                                Deposit History</HeaderTemplate>
                                                            <ContentTemplate>
                                                                <div class="ui-widget-header" style="height: 25px;">
                                                                    <div style="float: left">
                                                                        <span>Filter By Batch Type</span>
                                                                        <asp:DropDownList ID="ddlBatchType" runat="server" AutoPostBack="true">
                                                                            <asp:ListItem Text="All" Value="" />
                                                                            <asp:ListItem Text="Not Processed" Value="np" />
                                                                            <asp:ListItem Text="Processed" Value="p" />
                                                                        </asp:DropDownList>
                                                                    </div>
                                                                    <div style="float: left">
                                                                        <asp:CheckBox ID="chkOnlyUnverified" runat="server" Text="Show only unverified" ToolTip="After checking you must reselect a batch!" />
                                                                    </div>
                                                                    <div style="float: right; padding: 3px">
                                                                        <span>Filter By Date</span>
                                                                        <asp:TextBox ID="txtScanDate" runat="server" CssClass="entry2" />
                                                                        <ajaxToolkit:CalendarExtender ID="txtFrom_CalendarExtender" runat="server" Enabled="True"
                                                                            TargetControlID="txtScanDate" CssClass="MyCalendar">
                                                                        </ajaxToolkit:CalendarExtender>
                                                                        <small>
                                                                            <asp:LinkButton ID="lnkFilterHistory" runat="server" Text="Go" CssClass="jqFilterButton" />
                                                                            <asp:LinkButton ID="lnkClearFilter" runat="server" Text="Clear" CssClass="jqCancelButton"
                                                                                ToolTip="reset search" />
                                                                        </small>
                                                                    </div>
                                                                </div>
                                                                <asp:GridView ID="gvHistory" runat="server" CssClass="entry" DataSourceID="dsHistory"
                                                                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="SaveGuid">
                                                                    <EmptyDataTemplate>
                                                                        No Deposit History
                                                                    </EmptyDataTemplate>
                                                                    <SelectedRowStyle BackColor="#D6E7F3" />
                                                                    <Columns>
                                                                        <asp:TemplateField>
                                                                            <HeaderTemplate>
                                                                                &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <input type="checkbox" runat="server" id="chk_select" />
                                                                                <asp:HiddenField ID="hdnSaveGuid" runat="server" Value='<%#eval("saveGuid") %>' />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="SaveGUID" HeaderText="SaveGUID" SortExpression="SaveGUID"
                                                                            Visible="False">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Created" HeaderText="Scanned" ReadOnly="True" SortExpression="Created" DataFormatString="{0:MM/dd/yyyy}">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="CreatedBy" HeaderText="Scanned By" ReadOnly="True" SortExpression="CreatedBy">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="listItem" Wrap="false" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total Verified Clients" HeaderText="Total Verified Clients"
                                                                            ReadOnly="True" SortExpression="Total Verified Clients" Visible="false">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total Verified Count" HeaderText="Total Verified Count"
                                                                            ReadOnly="True" SortExpression="Total Verified Count">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total Verified Amt" HeaderText="Total Verified Amt" ReadOnly="True"
                                                                            SortExpression="Total Verified Amt" DataFormatString="{0:c2}">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total Processed" HeaderText="Total Processed" ReadOnly="True"
                                                                            SortExpression="Total Processed">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total Processed Amt" HeaderText="Total Processed Amt"
                                                                            ReadOnly="True" SortExpression="Total Processed Amt" DataFormatString="{0:c2}">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total ICL Processed" HeaderText="Total ICL Processed"
                                                                            ReadOnly="True" SortExpression="Total ICL Processed">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Total ICL Processed Amt" HeaderText="Total ICL Processed Amt"
                                                                            ReadOnly="True" SortExpression="Total ICL Processed Amt" DataFormatString="{0:c2}">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="TotalItems" HeaderText="Total Items" ReadOnly="True" SortExpression="TotalItems">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="TotalAmt" HeaderText="Total Amt" ReadOnly="True" SortExpression="TotalAmt"
                                                                            DataFormatString="{0:c2}">
                                                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                                                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Processed Date" HeaderText="Processed" ReadOnly="True"
                                                                            SortExpression="Processed Date">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="ProcessedBy" HeaderText="Processed By" ReadOnly="True"
                                                                            SortExpression="ProcessedBy">
                                                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Wrap="false" />
                                                                        </asp:BoundField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                                <asp:SqlDataSource ID="dsHistory" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    ProviderName="System.Data.SqlClient" SelectCommand="stp_CheckScan_LoadHistory"
                                                                    CancelSelectOnNullParameter="false" DeleteCommand="UPDATE tblICLChecks SET DeleteDate = Getdate() WHERE (SaveGUID = @SaveID)"
                                                                    SelectCommandType="StoredProcedure">
                                                                    <SelectParameters>
                                                                        <asp:Parameter Name="filterdate" ConvertEmptyStringToNull="true" />
                                                                        <asp:Parameter Name="batchstatus" ConvertEmptyStringToNull="true" />
                                                                    </SelectParameters>
                                                                    <DeleteParameters>
                                                                        <asp:Parameter Name="SaveID" />
                                                                    </DeleteParameters>
                                                                </asp:SqlDataSource>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="tabSeachHistory" runat="server">
                                                            <HeaderTemplate>
                                                                Deposit Search</HeaderTemplate>
                                                            <ContentTemplate>
                                                                <div class="ui-widget-header entry2" style="padding: 3px;">
                                                                    <asp:TextBox ID="txtDepositSearch" runat="server" CssClass="entry2" />
                                                                    <small>
                                                                        <asp:LinkButton ID="lnkSearchDepositHistory" runat="server" Text="Search" CssClass="entry2" />
                                                                        <asp:LinkButton ID="lnkClearDepositHistorySearch" runat="server" Text="Clear" CssClass="entry2" />
                                                                    </small>
                                                                </div>
                                                                <asp:GridView ID="gvHistorySearch" runat="server" CssClass="entry" DataSourceID="dsHistorySearch"
                                                                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False">
                                                                    <EmptyDataTemplate>
                                                                        No Deposit History
                                                                    </EmptyDataTemplate>
                                                                </asp:GridView>
                                                                <asp:SqlDataSource ID="dsHistorySearch" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    ProviderName="System.Data.SqlClient"></asp:SqlDataSource>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                    </ajaxToolkit:TabContainer>
                                                </td>
                                            </tr>
                                        </table>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
                TargetControlID="lnkScan" PopupControlID="programmaticPopup" BackgroundCssClass="modalBackgroundNeg"
                DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle" OnCancelScript="ReloadPage();">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel runat="server" CssClass="modalPopup" ID="programmaticPopup" Style="display: none;
                padding: 0px; width: 60%;">
                <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #D6E7F3;
                    border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
                    <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #3376AB;">
                        <tr class="headerstyle" style="height: 25px;">
                            <td align="left" style="padding-left: 10px;">
                                <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Scan Check(s)" />
                            </td>
                            <td align="right" style="padding-right: 5px;">
                                <asp:ImageButton ID="imgClose" runat="server" OnClientClick="ReloadPage();" ImageUrl="~/images/16x16_close.png"
                                    onmouseover="this.style.cursor='pointer';" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel runat="Server" ID="pnlRpt">
                    <div id="dvReport" runat="server" style="height: 530px; z-index: 51; visibility: visible;
                        background-color: Transparent;">
                        <iframe id="frmReport" runat="server" src="scanning.aspx" style="width: 100%; height: 100%;"
                            frameborder="0" />
                    </div>
                </asp:Panel>
            </asp:Panel>
            <div id="updateScanDiv" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
        <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnRefresh" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
    <script type="text/javascript">
        var loadingImg = '<div class="info">Looking for new checks...<img src="../../images/loading.gif" alt="Loading..." /></div>';
        var searchingImg = '<div class="info">Searching...<img src="../../images/loading.gif" alt="Loading..." /></div>';
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                loadButtons();
            });
        }
        function refresh() { 
            <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
        }
        function getChecksJQ() {
            showMsg(loadingImg);
            var uid = <%= Userid %> ;
            var dArray = "{";
            dArray += "'userid': '" + uid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "default.aspx/PM_LoadChecks",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    showMsg(response.d);
                },
                error: function (response) {
                    showMsg(response.responseText, true);
                }
            });
        }

        function getChecks() {
            getChecksJQ();
            //PageMethods.PM_LoadChecks(<%=Userid %>,OnSuccess, OnError);
            //return false;
        }
        function OnSuccess(response) {
            showMsg(response);
        }
        function OnError(error) {
            showMsg(response);
        } 
        function showMsg(msgtext, bSticky) {
            var dv = document.getElementById('<%=dvMsg.ClientID %>');
            dv.style.display = 'block';
            dv.innerHTML = msgtext;

            bSticky = (typeof bSticky === "undefined") ? true : bSticky;
            if (bSticky == false) {
                $('#<%=dvMsg.ClientID %>').delay(5000).fadeOut(1000)
            }

        }
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
     
        function loadButtons() {
            $(".btnBar").buttonset();
            $(".jqButton").button();
            $(".jqCancelButton").button({
                icons: {
                    primary: "ui-icon-closethick"
                },
                text: false
            });
            $(".jqFilterButton").button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: false
            });
        }
    function ProcessBatch(){
        showMsg('<div class="info">Processing Batch(es)...<br/><img src="../../images/loading.gif" alt="Loading..." /></div>', false);
        var bids = Array();
        $('#<%=gvHistory.ClientID %> tr:has(input:checked) input[type=hidden]').each(function(i, item){ 
            bids.push($(item).val());
        });
        var dArray = "{";
        dArray += "'batchids': '" + bids.join() + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "default.aspx/ProcessBatches",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                var rtext = response.d;
                if (rtext.indexOf('success') > 0){
                    refresh();
                }
            },
            error: function (response) {
                showMsg(response.responseText, true);
            }
        });
        return false;
    }
    function AttachClient(did, cid) {
        var dArray = "{";
        dArray += "'dataclientid': '" + did + "',";
        dArray += "'currentcheckid': '" + cid + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "default.aspx/AttachClientToCheck",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                var obj = eval('(' + response.d + ')');
                $("*[id$='lblClientName']").text(obj[1]);
                $("*[id$='dvClientStatus']").html(obj[0]);
                $("*[id$='dvClientStatus']").attr('class', 'success');
            },
            error: function (response) {
                showMsg(response.responseText, true);
            }
        });
        return false;
    }

    function CheckVerification() {
        //var cid = '';
        var chkrouting = $("*[id$='txtRouting']").val();
        var chkacct = $("*[id$='txtAccount']").val();
        var chkamt = $("*[id$='txtAmount']").val();
        var chknum = $("*[id$='txtCheckNumber']").val();
        var msg = '';
        if (chkrouting.length == 0) {
            msg += '<strong>Check routing cannot be blank!</strong><br/>';
            $("*[id$='txtRouting']").css('backgroundColor', '#FFBABA');
        }
        if (chkrouting.length != 9) {
            msg += '<strong>Check routing must be 9 digits!</strong><br/>';
            $("*[id$='txtRouting']").css('backgroundColor', '#FFBABA');
        }
        if (chkacct.length == 0) {
            msg += '<strong>Check account # cannot be blank!</strong><br/>';
            $("*[id$='txtAccount']").css('backgroundColor', '#FFBABA');
        }
        if (chkamt == 0) {
            msg += '<strong>Check amount cannot equal $0.00!</strong><br/>';
            $("*[id$='txtAmount']").css('backgroundColor', '#FFBABA');
        }
        if (msg != '') {
            showMsg('<div class="error">' + msg + '</div>', true);
            return false;
        } else {
            return true;
        }
        
    }

    </script>
    <script type="text/javascript">
        var dragapproved = false
        var z, x, y
        function move() {
            if (event.button == 1 && dragapproved) {
                z.style.pixelLeft = temp1 + event.clientX - x
                z.style.pixelTop = temp2 + event.clientY - y
                return false
            }
        }
        function drags() {
            if (!document.all)
                return
            if (event.srcElement.className == "drag") {
                dragapproved = true
                z = event.srcElement
                temp1 = z.style.pixelLeft
                temp2 = z.style.pixelTop
                x = event.clientX
                y = event.clientY
                document.onmousemove = move
            }
        }
        document.onmousedown = drags
        document.onmouseup = new Function("dragapproved=false")
        //--> 

        function sideTab_OnMouseOver(obj) {
            obj.style.color = "rgb(90,90,90)";
            obj.style.backgroundColor = "rgb(240,245,251)";
        }
        function sideTab_OnMouseOut(obj) {
            obj.style.color = "";
            obj.style.backgroundColor = "";
        }

        function ReloadPage() {
            window.location.reload();
        }

        function toggleDocument(accountNumber, gridviewID) {
            var rowName = 'tr_' + accountNumber
            var gv = document.getElementById(gridviewID);
            var rows = gv.getElementsByTagName('tr');
            for (var row in rows) {
                var rowID = rows[row].id
                if (rowID != undefined) {
                    if (rowID.indexOf(rowName + '_child') != -1) {
                        rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                    } else if (rowID.indexOf(rowName + '_parent') != -1) {
                        var tree = rows[row].cells[1].children[0].src
                        rows[row].cells[1].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                    }
                }
            }
        }

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateScanDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('divCheckScan');

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
            var updateProgressDiv = $get('updateScanDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
        function ClosePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
            window.location.reload();
        }
    </script>
    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeCheckScan" BehaviorID="checkscananimation"
        runat="server" TargetControlID="upCheckScan">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="divCheckScan" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="divCheckScan" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
