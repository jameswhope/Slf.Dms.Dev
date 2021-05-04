<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PhoneBook.aspx.vb" Inherits="CallControlsAst_PhoneBook" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-size: 11px;
            font-family: Tahoma;
        }
        .filter
        {
            font-size: 11px;
            font-family: Tahoma;
            background-color: #FFFF99
        }
    </style>

    <script type="text/javascript">

        function pageLoad() {
        }
    
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <table>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                                Last Name
                            </td>
                            <td>
                                First Name
                            </td>
                            <td>
                                Ext.
                            </td>
                            <td>
                                Dept.
                            </td>
                            <td>
                                Status
                            </td>
                            <td>
                                On The Phone
                            </td>
                            <td>
                                Logged In
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtLastName" runat="server" Style="width: 80px;" CssClass="filter" ></asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFirstName" runat="server" Style="width: 80px;" 
                                    CssClass="filter"></asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="txtExtension" runat="server" Style="width: 30px;" 
                                    CssClass="filter"></asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="txtDepartment" runat="server" Style="width: 150px;" 
                                    CssClass="filter"></asp:TextBox>
                            </td>
                            <td>
                                <asp:TextBox ID="txtStatus" runat="server" Style="width: 80px;" 
                                    CssClass="filter"></asp:TextBox>
                            </td>
                            <td style="text-align: center;" >
                                <asp:CheckBox ID="chkOnthePhone" runat="server" />
                            </td>
                            <td style="text-align: center;" >
                                <asp:CheckBox ID="chkLoggedIn" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <asp:UpdatePanel ID="updPhoneBook" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="grdExtensions" runat="server" AutoGenerateColumns="False" GridLines="Both"
                                CellPadding="1" CellSpacing="1">
                                <RowStyle BorderColor="#666666" BorderStyle="Dotted" BorderWidth="1px" />
                                <Columns>
                                    <asp:BoundField HeaderText="Last Name" DataField="LastName" >
                                        <ItemStyle Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="First Name" DataField="FirstName" >
                                        <ItemStyle Width="80px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Ext." >
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkExtension" runat="server" ToolTip="Call extension"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Transfer" >
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImgTransfer" runat="server" ImageUrl="~/images/16x16_forward.png"
                                                ToolTip="Transfer to extension" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="70px"  />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Voice Mail" >
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImgVoiceMail" runat="server" ImageUrl="~/images/p_voicemail.gif"
                                                ToolTip="Send to extension's voicemail" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="70px" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Department" DataField="Dept" >
                                        <ItemStyle Width="100px" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Status" DataField="Presence" >
                                        <ItemStyle Width="80px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Time In Status" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblTimeInStatus" runat="server" Text=""></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="On the Phone" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblOnThePhone" runat="server" Text=""></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Logged In" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblLoggedIn" runat="server" Text=""></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle BackColor="#c0c0c0" Wrap="false" />
                            </asp:GridView>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                        </Triggers>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
        <asp:Timer ID="Timer1" runat="server" Interval="1000">
        </asp:Timer>
    </div>
    </form>
</body>
</html>
