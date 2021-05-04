<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ClientStatements.aspx.vb" Inherits="Clients_client_finances_Statements_ClientStatement" %>

<%@ Register Assembly="GrapeCity.ActiveReports.Web, Version=13.0.15823.0, Culture=neutral, PublicKeyToken=cc4967777c49a3ff"
    Namespace="GrapeCity.ActiveReports.Web" TagPrefix="ActiveReportsWeb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="height: 100%; width: 100%;">
                <ActiveReportsWeb:WebViewer ID="WebViewer1" runat="server"></ActiveReportsWeb:WebViewer>
        </div>
    </form>
</body>
</html>
