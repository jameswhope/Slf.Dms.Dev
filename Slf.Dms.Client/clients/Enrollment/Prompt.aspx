<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Prompt.aspx.vb" Inherits="Clients_Enrollment_Prompt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form1" runat="server">
    <table style="width:100%; height:100%" >
        <tr>
            <td valign="middle"  style="text-align:center; height:100%;" >
                <div class="tabContent" style="width: 400px;">
                    <table class="window" >
                        <tr>
                            <td>
                                <h5>Select the model to use for this lead:</h5>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left" >
                                <br />
                                <asp:RadioButton ID="rdNewEnrollment"  GroupName="model" runat="server" 
                                    Text="Subsequent year service fee. (old calculator)" Checked="True" /><br />
                                <asp:RadioButton ID="rdNewEnrollment2" GroupName="model" runat="server" Text="Service fee per account with a maximum fee amount. (new calculator)" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <br />
                                <asp:Button ID="btnAccept" runat="server" Text="Accept" />&nbsp;
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" />
                            </td>
                        </tr>
                    </table>
                </div>
           </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnPageReferrer" runat="server" /> 
    </form>
</body>
</html>
