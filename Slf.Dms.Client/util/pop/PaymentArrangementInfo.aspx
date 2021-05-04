<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PaymentArrangementInfo.aspx.vb" Inherits="util_pop_PaymentArrangementInfo" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Address Book</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        .dvContainer 
        {
            width: 100%;
            text-align: center;
           
            }
        
        .dvContainer table
        { 
            font-family: Tahoma;
            font-size: 11px;
            border-collapse: collapse;
            width: 100%;
            border: solid 1px #c0c0c0;
            }
            
        .gridHead {
            background-color: #c0c0c0;
            font-weight: bold;
            }
            
        .gridItem{
             padding: 3px;
             border-bottom: dotted 1px #c0c0c0;
             border-top: none 0px;
             border-right: none;
             border-left: none;
            }
         
         .paidRow
         {
             background-color: #81F79F;
             }
         .openRow
         {
             background-color: #FFFFFF;
             }
         .closedRow
         {
             background-color: #D8D8D8;
             }
         .expiredRow
         {
             background-color: #F5A9BC;
             }
          .byclientRow
         {
             background-color: #F2F5A9;
             }
    </style>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dvContainer">
            <asp:GridView ID="gdPaymentSchedule" runat="server" AutoGenerateColumns="False" CellPadding="2" Width="100%" >
            <Columns>
                <asp:BoundField DataField="PmtScheduleId" Visible = "false" >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" />
                </asp:BoundField>
                <asp:BoundField DataField="Order" HeaderText="Pos."  >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="PmtDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}" >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="PmtAmount" HeaderText="Amount" DataFormatString="{0:c}" >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="Created" HeaderText="Created" DataFormatString="{0:MM/dd/yyyy}"  >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="CreatedByUser" HeaderText="Created By" >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Left" />
                </asp:BoundField>
                <asp:BoundField DataField="Status" HeaderText="Status" >
                    <HeaderStyle CssClass="gridHead" />
                    <ItemStyle CssClass="gridItem" HorizontalAlign="Center"/>
                </asp:BoundField>
            </Columns>
            <EmptyDataTemplate>
                There are no scheduled payments for this settlement.
            </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </form>
</body>
</html>