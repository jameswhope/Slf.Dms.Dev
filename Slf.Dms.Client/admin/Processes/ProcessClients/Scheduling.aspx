<%@ Page Language="VB" MasterPageFile="~/admin/Processes/Processes.master" AutoEventWireup="false" CodeFile="Scheduling.aspx.vb" Inherits="admin_Processes_ProcessClients_Scheduling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <ajaxToolkit:ToolkitScriptManager runat="server" ID="ScriptManager"></ajaxToolkit:ToolkitScriptManager>
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/Processes/default.aspx">Processes</a>&nbsp;>&nbsp;Client Processes</td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img2" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            Below is the scheduling module. If you wish to change the schedule for 
                                            creating client statements please use this page. The current schedule is
                                            shown under Current Settings below. Client statements can be scheduled to run at any 
                                            day, date or time for any period.  
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
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Current Schedule</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:20; width:100%"><a id="A7" runat="server"><img id="Img7" style="margin-right:5;" src="~/images/calendar.png" runat="server" border="0" align="absmiddle"/>Run Day(s)</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:40; width:100%"><a id="A3" runat="server"><img id="Img3" style="margin-right:5;" src="~/images/Alarm.png" runat="server" border="0" align="absmiddle"/>Run Time(s)</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:35; width:100%"><a id="A4" runat="server"><img id="Img4" style="margin-right:5;" src="~/images/Animation.png" runat="server" border="0" align="absmiddle"/>Run Frequency</a></td>
                    </tr>
                 </table>
                 <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Current Settings</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:25" id="A5" runat="server">
                            <asp:label id="lblDays" Text="1st. & 16th."  Height="20px" width="100px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:47" id="A6" runat="server">
                            <asp:label id="lblTime" Text="4:00 AM"  Height="20px" width="100px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left:20; padding-top:40" id="Td1" runat="server">
                            <asp:label id="lblFrequency" Text="Monthly"  Height="20px" width="100px" runat="server" />
                        </td>
                    </tr>
                    </table>
                    <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:100;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Pick Day/Time/Frequency</td>
                    </tr>
                    <tr>
                    <td>
                    <asp:CheckBoxList id="ckDayOfWeek" 
                           AutoPostBack="True"
                           CellPadding="5"
                           CellSpacing="5"
                           RepeatColumns="4"
                           RepeatDirection="Vertical"
                           RepeatLayout="Table"
                           Font-Size="8"
                           TextAlign="Right"
                           runat="server">

                         <asp:ListItem>Monday</asp:ListItem>
                         <asp:ListItem>Tuesday</asp:ListItem>
                         <asp:ListItem>Wednesday</asp:ListItem>
                         <asp:ListItem>Thursday</asp:ListItem>
                         <asp:ListItem>Friday</asp:ListItem>
                         <asp:ListItem>Saturday</asp:ListItem>
                        <asp:ListItem>Sunday</asp:ListItem> 

                      </asp:CheckBoxList>
                     </td> 
                    </tr>
                    <tr>
                    <td style="padding-left:20; padding-top:15; padding-bottom:25" id="A9" runat="server">
                        <asp:ImageButton ID="btnTimeUp" runat="server" ImageUrl="~/images/up_h.png" /><asp:ImageButton ID="btnTimeDn" runat="server" ImageUrl="~/images/down_h.png" /><asp:Label ID="spcLbl1" runat="server" Width="10" /><asp:TextBox ID="txtTime" runat="server" Width="45"/>
                    </td>
                    </tr>
                    <tr>
                    <td>
                    <asp:RadioButtonList id="ckBoxFrequency" 
                           AutoPostBack="False"
                           CellPadding="5"
                           CellSpacing="5"
                           RepeatColumns="2"
                           RepeatDirection="Vertical"
                           RepeatLayout="Table"
                           Font-Size="8"
                           TextAlign="Right"
                           runat="server">

                         <asp:ListItem>Daily</asp:ListItem>
                         <asp:ListItem>Weekly</asp:ListItem>
                         <asp:ListItem>Monthly</asp:ListItem>
                         <asp:ListItem>Quarterly</asp:ListItem>
                         <asp:ListItem>Semi-annually</asp:ListItem>
                         <asp:ListItem>Annually</asp:ListItem>

                      </asp:RadioButtonList>
                    </td>
                    </tr>
                    </table>
                    <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:200;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5; font-size:11px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">or Day of The Month</td>
                    </tr>
                    <tr>
                    <td style="padding-left:20; padding-top:20; padding-bottom:25" id="A10" runat="server">
                        <asp:ImageButton ID="btnDayUp" runat="server" ImageUrl="~/images/up_h.png" /><asp:ImageButton ID="btnDayDn" runat="server" ImageUrl="~/images/down_h.png" /><asp:Label ID="spDay" runat="server" Width="10" /><asp:TextBox ID="txtDay" runat="server" Width="25"/>
                    </td>
                    </tr>
                    </table>
            </td>
        </tr>
    </table>
            <ajaxtoolkit:NumericUpDownExtender ID="udCalDays" runat="server"
                targetcontrolid="txtDay" 
                RefValues="1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31"
                TargetButtonDownID="btnDayDn"
                TargetButtonUpID="btnDayUp" 
             /> 
              
              <ajaxtoolkit:NumericUpDownExtender ID="udTime" runat="server"
                targetcontrolid="txtTime"
                RefValues="1 AM;2 AM;3 AM;4 AM;5 AM;6 AM;7 AM;8 AM;9 AM;10 AM;11 AM;12 AM;1 PM;2 PM;3 PM;4 PM;5 PM;6 PM;7 PM;8 PM;9 PM;10 PM;11 PM;12 PM"
                TargetButtonDownID="btnTimeDn"
                TargetButtonUpID="btnTimeUp" 
              /> 
</asp:Content>
