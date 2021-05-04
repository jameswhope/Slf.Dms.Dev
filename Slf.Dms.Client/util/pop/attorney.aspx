<%@ Page Language="VB" AutoEventWireup="false" CodeFile="attorney.aspx.vb" Inherits="util_pop_attorney" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attorney</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    
    <script type="text/javascript" language="javascript">
        function SetSelectedValue(ddl, value)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].text == value)
                {
                    ddl[idx].selected = true;
                }
            }
        }
        
        function GetSelectedValue(ddl)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].selected == true)
                {
                    return ddl.options[idx].text;
                }
            }
            
            return '';
        }
        
        function IsSelected(ddl, value)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].value == value && ddl[idx].selected == true)
                {
                    return idx;
                }
            }
            
            return -1;
        }
        
        function CancelQuery()
        {
            window.close();
        }
        
        function SubmitQuery()
        {
            var first = document.getElementById('<%=txtFirstName.ClientID %>');
            var last = document.getElementById('<%=txtLastName.ClientID %>');
            
            if (!first || !last)
            {
                ShowMessage('Please enter a first and last name!');
                return;
            }
            else
            {
                if (first)
                {
                    if (first.value.length < 1)
                    {
                        ShowMessage('Please enter a first and last name!');
                        return;
                    }
                }
                
                if (last)
                {
                    if (last.value.length < 1)
                    {
                        ShowMessage('Please enter a first and last name!');
                        return;
                    }
                }
            }
            
            if (document.getElementById('lblStates').value == '')
            {
                ShowMessage('Please select a state!');
                return;
            }
            
            if (IsSelected(document.getElementById('<%=ddlCompany.ClientID %>'), -1) > 0)
            {
                ShowMessage('Please select a company!');
                return;
            }
            
            if (IsSelected(document.getElementById('<%=ddlRelations.ClientID %>'), -1) > 0)
            {
                ShowMessage('Please select an attorney relation!');
                return;
            }
            
            var action = '<%=Action %>';
            
            if (action == 'a')
            {
                self.dialogArguments.Dialog_AddAttorney(document.getElementById('<%=txtFirstName.ClientID %>').value, document.getElementById('<%=txtMiddleName.ClientID %>').value, document.getElementById('<%=txtLastname.ClientID %>').value, document.getElementById('<%=txtSuffix.ClientID %>').value, document.getElementById('<%=ddlCompany.ClientID %>').value, document.getElementById('<%=ddlRelations.ClientID %>').value, document.getElementById('<%=lblStates.ClientID %>').value, document.getElementById('<%=ckPrime.ClientID %>').checked);
                self.close();
            }
            else
            {
                self.dialogArguments.Dialog_UpdateAttorney('<%=AttorneyRelationID %>', document.getElementById('<%=txtFirstName.ClientID %>').value, document.getElementById('<%=txtMiddleName.ClientID %>').value, document.getElementById('<%=txtLastname.ClientID %>').value, document.getElementById('<%=txtSuffix.ClientID %>').value, document.getElementById('<%=ddlCompany.ClientID %>').value, document.getElementById('<%=ddlRelations.ClientID %>').value, document.getElementById('<%=lblStates.ClientID %>').value, document.getElementById('<%=ckPrime.ClientID %>').checked);
                self.close();
            }
        }

        function ShowMessage(Value)
        {
            var dvError = document.getElementById("<%=dvError.ClientID %>");
            var tdError = document.getElementById("<%=tdError.ClientID %>");

            dvError.style.display = "inline";
            tdError.innerHTML = Value;
        }
        
        function StateChange()
        {
            var lblStates = document.getElementById('<%=lblStates.ClientID %>');
            var state = GetSelectedValue(document.getElementById('<%=ddlStates.ClientID %>'));
            
            if (state != '') 
            {
                if (lblStates.value.length > 0)
                {
                    lblStates.value = lblStates.value + ',' + state;
                }
                else
                {
                    lblStates.value = state;
                }
            }
        }
        
        function DeleteState()
        {
            var lblStates = document.getElementById('<%=lblStates.ClientID %>');
            lblStates.value = lblStates.value.substring(0, lblStates.value.lastIndexOf(','));
        }
    </script>
</head>

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;overflow:auto;">
<form id="Form1" runat="server" action="">
    <table style="width:100%;" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="2">
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img4" runat="server" src="~/images/message.png" align="absmiddle" border="0" alt="" /></td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
            </td>
        </tr>
        <tr>
            <td style="width:100%;">
                <table id="tblAttorney" style="width:100%;height:100%;text-align:center;font-family:Tahoma,Arial;font-size:12px;">
                    <tr>
                        <td>
                            <div style="font-family:Tahoma,Arial;font-size:12px;">
                                <table style="width:100%;height:auto;font-family:Tahoma,Arial;font-size:12px;">
                                    <tr>
                                        <td colspan="2">
                                            <table style="width:100%;height:auto;font-family:Tahoma,Arial;font-size:12px;">
                                            	<tr>
                                            		<td align="left">First</td>
                                            		<td align="left">Middle</td>
                                            		<td align="left">Last</td>
                                            		<td align="right">Suffix</td>
                                            		<td align="left"></td>
                                            	</tr>
                                            	<tr>
                                            	    <td align="left"><asp:TextBox ID="txtFirstName" Width="115px" Height="16px" MaxLength="50" Font-Size="10px" runat="server" /></td>
                                            		<td align="left" style="width:50px;"><asp:TextBox ID="txtMiddleName" Width="45px" Height="16px" MaxLength="15" Font-Size="10px" runat="server" /></td>
                                            		<td align="left"><asp:TextBox ID="txtLastName" Width="115px" Height="16px" MaxLength="50" Font-Size="10px" runat="server" /></td>
                                            		<td align="right" style="width:25px;"><asp:TextBox ID="txtSuffix" Width="35px" Height="16px" MaxLength="10" Font-Size="10px" runat="server" /></td>
                                            	</tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            State:
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlStates" Height="16px" Font-Size="10px" onchange="javascript:StateChange();" runat="server" />
                                        </td>
                                        <td align="left" style="width:100%;height:25px;vertical-align:center;">
                                            <input id="lblStates" type="text" readonly="readonly" style="width:185px;" runat="server" />
                                            <a href="javascript:DeleteState();" class="gridButton" visible="true" style="height:16px;width:16px;vertical-align:center;" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" alt="" /></a>
                                        </td>
                                    </tr>
                                    <tr style="height:10px;"><td>&nbsp;</td></tr>
                                    <tr>
                                        <td>
                                            Relation:
                                        </td>
                                        <td align="left">
                                            Company:
                                        </td>
                                    </tr>
                                    <tr style="height:50px;vertical-align:top;width:100%;">
                                        <td>
                                            <asp:DropDownList ID="ddlRelations" Height="16px" Font-Size="10px" runat="server" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlCompany" Height="16px" Font-Size="11px" runat="server" /><asp:checkBox ID="ckPrime" text="State primary attorney" Height="16px" Font-Bold="true" Font-Size="11px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr style="width:100%;height:25px;background-color:#D5D5F0;vertical-align:middle;text-align:center;">
                                        <td style="width:50%;">
                                            <a href="javascript:SubmitQuery();" class="gridButton" visible="true" style="width:100%;height:100%;" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_prospect.png" alt="" />&nbsp;Add \ Update</a>
                                        </td>
                                        <td>
                                            <a href="javascript:CancelQuery();" class="gridButton" visible="true" style="width:100%;height:100%;" runat="server"><img id="Img1" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" alt="" />&nbsp;Cancel</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
   <asp:HiddenField ID=hdnPrimary runat="server" />
    <asp:LinkButton ID="lnkSubmit" runat="server" />
</form>
</body>
</html>