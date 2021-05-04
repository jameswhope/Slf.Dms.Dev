<%@ Page Language="VB" AutoEventWireup="false" CodeFile="WorkgroupDir.aspx.vb" Inherits="CallControls_WorkgroupDir" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Workgroup Directories</title>
    <style type="text/css">
        body
        {
            background-color: #FFCCFF;
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
        div#grdPhoneBook
        {
            width: 720px;
            height: 200px;
            overflow: scroll;
            position: relative;
        }
        div#grdPhoneBook th
        {
            top: expression(document.getElementById("AdjResultsDiv").scrollTop-2);
            left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);
            position: relative;
            z-index: 20;
        }
        div#AdjResultsDiv
        {
            border: 1px solid #808080;
            width: 720px;
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
    <div>
        <table>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>Workgroup Directory:</td>
                            <td>
                                <asp:UpdatePanel ID="UpdateDDL" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional" >
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlWorkGroupQueues" runat="server" Width="235px" AutoPostBack="true" >
                                    </asp:DropDownList>
                                    <asp:ImageButton ID="ImgExpTrans" runat="server" ImageUrl="~/images/16x16_forward.png" ToolTip="Transfer to any available user" style="vertical-align:middle;"   />
                                </ContentTemplate> 
                                </asp:UpdatePanel>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" 
                                    AssociatedUpdatePanelID="UpdateDDL" DisplayAfter="0">
                                <ProgressTemplate>
                                    Searching ... 
                                </ProgressTemplate> 
                                </asp:UpdateProgress> 
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
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
                                    Status
                                </th>
                                <th>
                                    Not On Phone 
                                </th>
                                <th>
                                    Logged In 
                                 </th>
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
                                    <asp:TextBox ID="txtExtension" runat="server" Width="59px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStatus" runat="server" Width="80px"></asp:TextBox>
                                </td>
                                <td align="center">
                                    <asp:CheckBox ID="chkNotOnPhone" runat="server"  Checked="true" /></td>
                                <td align="center">
                                    <asp:CheckBox ID="chkLoggedIn" runat="server" Checked="true" />
                                    </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="margin: 10px; padding: 5px;">
                    <div id="AdjResultsDiv">
                      <asp:UpdatePanel ID="updContact" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional"    >
                        <ContentTemplate>
                        <asp:GridView ID="grdPhoneBook" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                             HeaderStyle-Height="15px" HeaderStyle-BackColor="#CCCCCC">
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
                            <asp:Timer ID="Timer5" runat="server" Enabled="True" Interval="1000">
                            </asp:Timer>
                        </ContentTemplate>
                        <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="Timer5" EventName="Tick" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </div>
                </td>
            </tr>
        </table> 
    </div>
    </form>
</body>
</html>
