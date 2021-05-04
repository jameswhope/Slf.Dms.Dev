<%@ Page Language="VB" AutoEventWireup="false" CodeFile="approveschedpayment.aspx.vb" Inherits="util_pop_approveschedpayment" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Approve Scheduled Payment</title>
    <base target="_self" />
    <script type="text/javascript" >
        function Approve()
        {
        
            if(document.getElementById("<%=txtCheckNumber.ClientID%>").value=='')
            {
                    ShowMessage("The check number is required.");
                    //AddBorder(document.getElementById("<%=txtCheckNumber.ClientID%>"));
                    return false;
            }  
                <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;        
           
        }
     
        
        function ShowMessage(Value) {
            var dvError = document.getElementById("<%= dvError.ClientId %>");  
            var tdError = document.getElementById("<%= tdError.ClientId %>");  
            dvError.style.display = "inline";
            tdError.innerHTML = Value;
        }
        function HideMessage() {
            var dvError = document.getElementById("<%= dvError.ClientId %>");  
            var tdError = document.getElementById("<%= tdError.ClientId %>");
            tdError.innerHTML = "";
            dvError.style.display = "none";
        }
    </script> 
</head>
<body>
    <form id="form1" runat="server">
     <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0" runat="server" id="tblBody">
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top" style="padding-left: 10; height: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                    cellspacing="0">
                    <tr>
                        <td style="background-color: #f1f1f1; white-space: nowrap;" >
                           Enter Check Number:
                        </td>
                        <td>
                            <asp:TextBox ID="txtCheckNumber" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                            <td>Account #:</td>
                            <td>
                                <asp:Label ID="lblAccoutNumber" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Pay to:</td>
                            <td>
                                <asp:Label ID="lblCreditorName" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Amount:</td>
                            <td>
                                <asp:Label ID="lblCheckAmount" runat="server" Text="lblAccoutNumber"></asp:Label>
                            </td>
                        </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 40px; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                padding-right: 10px;">
                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a tabindex="3" style="color: black" class="lnk" href="javascript:window.close();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="absmiddle" />Cancel and Close</a>
                        </td>
                        <td align="right">
                            <a tabindex="4" style="color: black" class="lnk" href="#" onclick="javascript:return Approve();">
                                Approve
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absmiddle" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    </form>
</body>
</html>
