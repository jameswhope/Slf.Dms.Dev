<%@ Page Language="VB" AutoEventWireup="false" CodeFile="optionsm.aspx.vb" Inherits="mobile_financial_optionsm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="../css/mobile.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #ddlCompany td
        {
            width: 250px;
            }
        #ddlAgency td
        {
            width: 250px;
            }
    </style>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script language="javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $('#<%=chkAttorneySelectAll.ClientId %>').change(function() {
                    $('#<%=ddlCompany.ClientId %>').find("input[type='checkbox']").prop('checked', $(this).is(":checked"));
                });
                $('#<%=ddlCompany.ClientId %>').find("input[type='checkbox']")
                                                  .change(function() {
                                                      var itms = $('#<%=ddlCompany.ClientId %>').find("input[type='checkbox']");
                                                      var chkitems = itms.filter(":checked");
                                                      $('#<%=chkAttorneySelectAll.ClientId %>').prop('checked', (itms.length == chkitems.length));
                                                  });
                $('#<%=chkAgencySelectAll.ClientId %>').change(function() {
                    $('#<%=ddlAgency.ClientId %>').find("input[type='checkbox']").prop('checked', $(this).is(":checked"));
                });
                $('#<%=ddlAgency.ClientId %>').find("input[type='checkbox']")
                                              .change(function() {
                                                  var itms = $('#<%=ddlAgency.ClientId %>').find("input[type='checkbox']");
                                                  var chkitems = itms.filter(":checked");
                                                  $('#<%=chkAgencySelectAll.ClientId %>').prop('checked', (itms.length == chkitems.length));
                                              });
            });
        }
    
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
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
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
        <li><span style="width:250px;display:inline-block;" >Settlement Attorney</span> <asp:CheckBox ID="chkAttorneySelectALL" runat="server" Text="Select/Deselect All" Style="left: 250px; font-size: 16px;" />
            <ul class="options">
                <li>
                    <div style="width:100%;">
                        <asp:CheckBoxList ID="ddlCompany" runat="server" RepeatColumns="2" />
                    </div>
                </li>
            </ul>
        </li>
        <li><span style="width:250px;display:inline-block;" >Agency</span><asp:CheckBox ID="chkAgencySelectAll" runat="server" Text="Select/Deselect All" Style="font-size: 16px;" />
            <ul class="options">
                <li>
                    <div style="width:100%;">
                        <asp:CheckBoxList ID="ddlAgency" runat="server" RepeatColumns="2" />
                    </div>
                </li>
            </ul>
        </li>
    </ul>
    </form>
</body>
</html>
