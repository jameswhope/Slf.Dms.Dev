<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Clients_client_creditors_harassment_Default" %>

<%@ Register Src="~/CustomTools/UserControls/CreditorHarassmentFormControl.ascx"
    TagName="harassment" TagPrefix="uc1" %>
<%@ Register src="../../../../CustomTools/UserControls/CreditorHarassmentFormSearchControl.ascx" tagname="CreditorHarassmentFormSearchControl" tagprefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CLIENT DEBT COLLECTION ABUSE INTAKE FORM </title>
    <link href="../../../../css/default.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="smHarass" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <div>
    
    
        <%-- <uc1:harassment ID="harassment1" runat="server" />--%>
        <uc2:CreditorHarassmentFormSearchControl ID="CreditorHarassmentFormSearchControl1" 
            runat="server" />
    </div>
    </form>
</body>
</html>
