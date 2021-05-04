<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="admin_settings_references_default" Title="DMP - Admin Settings - References" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;References
            </td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width: 16;">
                                <img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png" />
                            </td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">
                                            INFORMATION:
                                        </td>
                                        <td class="iboxCloseCell" valign="top" align="right">
                                            <asp:LinkButton runat="server" ID="lnkCloseInformation">
                                                <img id="Img2" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            The entities below are called references tables. The system uses these reference
                                            tables to keep information up to date and strictly defined. Most of the time, these
                                            references tables are used in drop-down lists throughout the system so that users
                                            may only select a value instead of entering ad hoc text.
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Finance
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=13">
                                <img style="margin-right: 5;" src="~/images/16x16_trust.png" runat="server" border="0"
                                    align="absmiddle" />Trusts</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=12">
                                <img style="margin-right: 5;" src="~/images/16x16_entrytype.png" runat="server" border="0"
                                    align="absmiddle" />Entry Types</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="#">
                                <img style="margin-right: 5;" src="~/images/16x16_scale.png" runat="server" border="0"
                                    align="absmiddle" />Deposit Methods</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Tasks
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/tasktypes.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_tasktype.png" runat="server" border="0"
                                    align="absmiddle" />Types</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=17">
                                <img style="margin-right: 5;" src="~/images/16x16_taskcategory.png" runat="server"
                                    border="0" align="absmiddle" />Categories</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="#">
                                <img style="margin-right: 5;" src="~/images/16x16_taskpropagation.png" runat="server"
                                    border="0" align="absmiddle" />Propagations</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=18">
                                <img style="margin-right: 5;" src="~/images/16x16_taskresolution.png" runat="server"
                                    border="0" align="absmiddle" />Resolutions</a>
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Data Entry
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=1">
                                <img style="margin-right: 5;" src="~/images/16x16_dataentrytype.png" runat="server"
                                    border="0" align="absmiddle" />Types</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="#">
                                <img style="margin-right: 5;" src="~/images/16x16_dataentrypropagation.png" runat="server"
                                    border="0" align="absmiddle" />Propagations</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=11">
                                <img style="margin-right: 5;" src="~/images/16x16_folder2.png" runat="server" border="0"
                                    align="absmiddle" />Document Folders</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Screening
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=5">
                                <img style="margin-right: 5;" src="~/images/16x16_prospect.png" runat="server" border="0"
                                    align="absmiddle" />Prospect Concerns</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=6">
                                <img style="margin-right: 5;" src="~/images/16x16_behind.png" runat="server" border="0"
                                    align="absmiddle" />How Far Behind</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=7">
                                <img style="margin-right: 5;" src="~/images/16x16_reason.png" runat="server" border="0"
                                    align="absmiddle" />Screening Failure Reasons</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Creditors
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=14">
                                <img style="margin-right: 5;" src="~/images/16x16_users.png" runat="server" border="0"
                                    align="absmiddle" />Creditors</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A1" runat="server" class="lnk" href="~/admin/creditors/creditorvalidation.aspx">
                                <img id="Img3" style="margin-right: 5;" src="~/images/16x16_check.png" runat="server"
                                    border="0" align="absmiddle" />Validate Creditors</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=19">
                                <img style="margin-right: 5;" src="~/images/16x16_accounts.png" runat="server" border="0"
                                    align="absmiddle" />Account Status Types</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Structural
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=10">
                                <img style="margin-right: 5;" src="~/images/16x16_web_home.png" runat="server" border="0"
                                    align="absmiddle" />Settlement Attorneys</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A3" runat="server" class="lnk" href="~/admin/settings/attorneys.aspx">
                                <img id="Img5" style="margin-right: 5;" src="~/images/16x16_people.png" runat="server"
                                    border="0" align="absmiddle" />Attorneys</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=8">
                                <img style="margin-right: 5;" src="~/images/16x16_company.png" runat="server" border="0"
                                    align="absmiddle" />Agencies</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=9">
                                <img style="margin-right: 5;" src="~/images/16x16_agent.png" runat="server" border="0"
                                    align="absmiddle" />Agents</a>
                        </td>
                    </tr>
                    <!--<tr>
                        <td style="padding-left:20;"><a id="A2" runat="server" class="lnk" href="~/research/reports/financial/commission/paydirection.aspx?From=c"><img id="Img4" style="margin-right:5;" src="~/images/16x16_cheque.png" runat="server" border="0" align="absmiddle"/>Fee Scenarios</a></td>
                    </tr>-->
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A4" runat="server" class="lnk" href="~/admin/commission/buildscenario.aspx">
                                <img id="Img6" style="margin-right: 5;" src="~/images/16x16_tools.png" runat="server"
                                    border="0" align="absmiddle" />Build Scenario</a>
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Miscellaneous
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=2">
                                <img style="margin-right: 5;" src="~/images/16x16_phone3.png" runat="server" border="0"
                                    align="absmiddle" />Phone Types</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=3">
                                <img style="margin-right: 5;" src="~/images/16x16_user.png" runat="server" border="0"
                                    align="absmiddle" />Languages</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=4">
                                <img style="margin-right: 5;" src="~/images/16x16_globe.png" runat="server" border="0"
                                    align="absmiddle" />States</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/modifyreasons.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_personerror.png" runat="server"
                                    border="0" align="absmiddle" />Cancellation Reasons</a>
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Documents
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/documents.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_file_new.png" runat="server" border="0"
                                    align="absmiddle" />Document Types</a>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=25">
                                <img style="margin-right: 5;" src="~/images/16x16_lock.png" runat="server" border="0"
                                    align="absmiddle" />Document View Permissions</a>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=25">
                                <img style="margin-right: 5;" src="~/images/16x16_lock.png" runat="server" border="0"
                                    align="absmiddle" />Document Create Permissions</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Matters
                        </td>
                    </tr>
                 
                    
                 <%--   <tr>
                        <td style="padding-left: 20;">
                            <a id="A5" runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=20">
                                <img id="Img9" style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Status Codes</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A6" runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=21">
                                <img alt="" id="Img10" style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Sub Status Codes</a>
                        </td>
                    </tr>--%>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/mattergroups.aspx">
                                <img alt="" style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Group</a>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="padding-left: 20;">
                            <a  runat="server" class="lnk" href="~/admin/settings/mattertypes.aspx">
                                <img alt="" style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Type</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=22">
                                <img alt="" id="Img7" style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Classification</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A22" runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=24">
                                <img style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Status</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A23" runat="server" class="lnk" href="~/admin/settings/references/multi.aspx?id=25">
                                <img style="margin-right: 5;" src="~/images/matter.jpg" runat="server" border="0"
                                    align="absmiddle" />Matter Sub Status</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Templates
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td style="padding-left: 20;">
                            <a id="A21" runat="server" class="lnk" href="~/admin/settings/matteremails.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_email.png" runat="server" border="0"
                                    align="absmiddle" />Matters</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A29" runat="server" class="lnk" href="~/admin/settings/generalemails.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_email.png" runat="server" border="0"
                                    align="absmiddle" />Email Template</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A25" runat="server" class="lnk" href="~/admin/settings/MatterPhoneNotes.aspx">
                                <img id="Img10" style="margin-right: 5;" src="~/images/16x16_email.png" runat="server" border="0"
                                    align="absmiddle" />Matter Phone Note Template</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>