<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PhoneBook.aspx.vb" Inherits="CallControls_PhoneBook" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Company Phone Book</title>
    <style type="text/css">
        body
        {
            background-color: #CCDEF9;
        }
        table
        {
            font-family: Tahoma;
            font-size: 11px;
        }
        table th
        {
            text-align: left;
        }
        table input
        {
            border-width: 1px;
            font-family: Tahoma;
            font-size: 11px;
            background-color: #FFFFCC;
        }
        div#MyGrid
        {
            width: 99%;
            height: 200px;
            overflow: scroll;
            position: relative;
        }
        div#MyGrid th
        {
            top: expression(document.getElementById("AdjResultsDiv").scrollTop-2);
            left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);
            position: relative;
            z-index: 20;
        }
        div#AdjResultsDiv
        {
            border: 1px solid #808080;
            width: 99%;
            height: 200px;
            overflow: scroll;
            position: relative;
            background-color: #999999;
        }
        div#AdjResultsDiv th
        {
            top: expression(document.getElementById("AdjResultsDiv").scrollTop-2);
            left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);
            position: relative;
            z-index: 20;
        }
        .style1
        {
            height: 13px;
        }
    </style>
    <script type="text/javascript" >
        function CloseDialog(ext, action) {
            var o = new Object();
            o.action = action;
            o.extension = ext;
            window.returnValue = o;
            window.close();
            return false;
        }  
    </script>  
</head>
<body>
    <form id="form1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="1000"></asp:Timer>
    <div>
        <table>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="2">
                        <thead>
                            <tr>
                                <th>
                                    Last Name
                                </th>
                                <th>
                                    First Name
                                </th>
                                <th>
                                    Ext.
                                </th>
                                <th>
                                    Department
                                </th>
                                <th>
                                    Status
                                </th>
                                <th>
                                </th>
                                <th>
                                    &nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtLastName" runat="server" Width="80px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFirstName" runat="server" Width="80px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtExtension" runat="server" Width="30px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDepartment" runat="server" Width="120px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStatus" runat="server" Width="80px"></asp:TextBox>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="margin: 10px; padding: 5px;">
                    <div id="AdjResultsDiv">
                      <asp:UpdatePanel ID="updContact" runat="server" ChildrenAsTriggers="True" UpdateMode="Conditional"    >
                        <ContentTemplate>
                        <asp:GridView ID="grdPhoneBook" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                            Width="700px" HeaderStyle-Height="15px" HeaderStyle-BackColor="#CCCCCC">
                            <RowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField HeaderText="Last Name" DataField="LastName" ItemStyle-Width="80px" >
                                </asp:BoundField>
                                <asp:BoundField HeaderText="First Name" DataField="FirstName" ItemStyle-Width="80px">
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Ext." ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkExt" runat="server" Text='<%# Eval("Extension")%>' OnClientClick='<%# Eval("Extension", "return CloseDialog(""{0}"",""call"");")%>' ></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Transfer" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgTrans" runat="server" ImageUrl="~/images/16x16_forward.png" OnClientClick='<%# Eval("Extension", "return CloseDialog(""{0}"",""transfer"");")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Park" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgPark" runat="server" ImageUrl="~/images/p_park.gif" OnClientClick='<%# Eval("Extension", "return CloseDialog(""{0}"",""park"");")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Voicemail" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImgVoiceMail" runat="server" ImageUrl="~/images/p_voicemail.gif" OnClientClick='<%# Eval("Extension", "return CloseDialog(""{0}"",""voicemail"");")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Department" DataField="Department" ItemStyle-Width="120px">
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Status" ItemStyle-Wrap="false"  >
                                    <ItemTemplate>
                                        <asp:Image ID="ImgStatus" runat="server" />
                                        <asp:Label ID="lbStatus" runat="server" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Time In Status" HeaderStyle-Wrap="false" >
                                    <ItemTemplate>
                                        <asp:Label ID="lblTimeInStatus" runat="server" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="On Phone" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign="Center" >
                                    <ItemTemplate>
                                        <asp:Label ID="lblOnPhone" runat="server" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Logged In" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign="Center" >
                                    <ItemTemplate>
                                        <asp:Label ID="lblLoggedIn" runat="server" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle BackColor="#CCCCCC" VerticalAlign="Top"></HeaderStyle>
                        </asp:GridView>   
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                        </Triggers> 
                        </asp:UpdatePanel>
                    </div>
                </td>
            </tr>
        </table> 
    </div>
    <asp:HiddenField ID="hdnSort" runat="server" />
    <asp:HiddenField ID="hdnFilter" runat="server" />
    </form>
</body>
</html>
