<%@ Page Language="VB" AutoEventWireup="false" CodeFile="JoinConference.aspx.vb" Inherits="CallControls_JoinConference" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add to conference</title>
    <style type="text/css" >
     body
        {
            font-family: Tahoma;
            font-size: 11px;
        }
    </style>
   
    <script type="text/javascript" >
        function CloseDialog(interid) {
            var o = new Object();
            o.interaction = interid;
            window.returnValue = o;
            window.close();
            return false;
        }  
    </script>  
</head>
<body>
    <form id="form1" runat="server">
     <asp:ScriptManager runat="server"></asp:ScriptManager>
     <asp:Timer ID="Timer1" runat="server" Interval="1500"></asp:Timer>
     <div>
        Select a phone call to add to the conference: <br /><br />
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional"  >
         <ContentTemplate>
             <asp:GridView ID="grdInteractions" runat="server" AutoGenerateColumns="False" 
                CellPadding="3" DataKeyNames="InteractionId" 
                SelectedRowStyle-BackColor="#FFFF66" HeaderStyle-BackColor="#C0C0C0">
                <Columns>
                     <asp:TemplateField HeaderText="Join" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImgTrans" runat="server" ImageUrl="~/images/16x16_phone_add.png" OnClientClick='<%# Eval("InteractionId.Id", "return CloseDialog(""{0}"");")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="InteractionId" HeaderText="Call Id" />
                    <asp:TemplateField HeaderText="Direction">
                        <ItemTemplate>
                            <asp:Label ID="lblirection" runat="server" 
                                Text='<%# iif(Eval("Direction")=1, "From","To") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RemoteName" HeaderText="Name" />
                    <asp:BoundField DataField="RemoteAddress" HeaderText="Number" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                    <asp:BoundField DataField="StateDescription" HeaderText="State" />
                </Columns>
            </asp:GridView>
         </ContentTemplate>
         <Triggers>
            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" /> 
         </Triggers>
         </asp:UpdatePanel> 
    </div>
    
    </form>
</body>
</html>
