<%@ Page Language="VB" AutoEventWireup="false" CodeFile="options.aspx.vb" Inherits="mobile_financial_options" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="../css/mobile.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
        function SetDates(ddl) {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="toolbar">
        <h1>
            Options</h1>
        <a href="javascript:history.go(-1);" class="cancelButton">cancel</a>
        <asp:ImageButton ID="btnRefresh" runat="server" CssClass="toprightimgbutton" ImageUrl="../images/refresh.png" />
        <h3 id="hPage" runat="server"></h3>
    </div>
    <ul class="edgetoedge">
        <li>Date Range
            <ul class="options">
                <li>
                    <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                    </asp:DropDownList>
                </li>
                <li>
                    <asp:TextBox ID="txtTransDate1" runat="server" Size="8" MaxLength="10"></asp:TextBox>&nbsp;:&nbsp;<asp:TextBox ID="txtTransDate2" runat="server" MaxLength="10" Size="8"></asp:TextBox>
                </li>
            </ul>
        </li>
        <li>Settlement Attorney
            <ul class="options">
                <li>
                    <asp:DropDownList ID="ddlCompany" runat="server">
                    </asp:DropDownList>
                </li>
            </ul>
        </li>
        <li>Agency
            <ul class="options">
                <li>
                    <asp:DropDownList ID="ddlAgency" runat="server">
                    </asp:DropDownList>
                </li>
            </ul>
        </li>
    </ul>
    </form>
</body>
</html>
