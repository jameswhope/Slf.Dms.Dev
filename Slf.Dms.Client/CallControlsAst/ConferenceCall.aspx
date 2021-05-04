<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ConferenceCall.aspx.vb" Inherits="CallControlsAst_ConferenceCall" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>3-Way Call</title>
    <style type="text/css">
        .button
        {
            width: 100px;
        }
    </style>
    <script type="text/javascript" >
        function Initiate3WayCall() {
            var phonenumber = document.getElementById('<%=txtPhoneNumber.ClientId %>').value;
            var callerid = window.top.parent.getCurrentCall().GetRemoteNumber();    
            window.top.parent.Create3WayCall(phonenumber, callerid);
        }
        function Leave3WayCall() {
            window.top.parent.Hangup();
        }
    </script> 
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width: 100%;">
            <tr>
                <td>
                    Transfer To:
                </td>
                <td>
                    <asp:TextBox ID="txtPhoneNumber" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="btnStartConference" runat="server" Text="Initiate 3-Way" OnClientClick="Initiate3WayCall(); return false;" CssClass="button"/>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    <asp:Button ID="btnLeaveConference" runat="server" Text="Leave 3-Way" OnClientClick="Leave3WayCall(); return false;" CssClass="button"/>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
