<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CallHistory.aspx.vb" Inherits="CallControls_CallHistory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Call History</title>
    <style type="text/css" >
     body
        {
            font-family: Tahoma;
            font-size: 11px;
        }
    </style>
   
    <script type="text/javascript" >
        function CloseDialog() {
            window.close();
            return false;
        }
        function MakeCall(lnk) {
            var parentW = window.dialogArguments;
            parentW.make_call(lnk.innerText); 
        }
    </script>  
</head>
<body>
    <form id="form1" runat="server">
     <asp:ScriptManager runat="server"></asp:ScriptManager>
     <div>
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional"  >
         <ContentTemplate>
             <asp:GridView ID="grdInteractions" runat="server" AutoGenerateColumns="False" 
                CellPadding="3" DataKeyNames="InteractionId" 
                SelectedRowStyle-BackColor="#FFFF66" HeaderStyle-BackColor="#C0C0C0" RowStyle-Wrap="false" >
                <Columns>
                    <asp:BoundField DataField="InteractionId" HeaderText="Call Id" />
                    <asp:BoundField DataField="Direction" HeaderText="Direction" />
                    <asp:BoundField DataField="RemoteName" HeaderText="Name" />
                     <asp:TemplateField HeaderText="Number" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkPhoneNumber" runat="server"  OnClientClick="MakeCall(this);" ><%#DataBinder.Eval(Container.DataItem, "RemoteAddress")%></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="BeginTime" HeaderText="Start" />
                    <asp:BoundField DataField="EndTime" HeaderText="End" />
                    <asp:TemplateField HeaderText="Duration" ItemStyle-Width="30px" runat="server" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="lblDuration" runat="server" Text='<%#String.Format("{0}", DataBinder.Eval(Container.DataItem, "EndTime").Subtract(Cdate(DataBinder.Eval(Container.DataItem, "BeginTime")))) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
               <AlternatingRowStyle BackColor="LightGray" Wrap="false"   /> 
            </asp:GridView>
         </ContentTemplate>
         </asp:UpdatePanel> 
    </div>
    
    </form>
</body>
</html>
