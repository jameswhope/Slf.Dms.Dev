<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="deposits.aspx.vb" Inherits="clients_client_finances_bytype_deposits"
    Title="DMP - Client - Deposits" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

    <script type="text/javascript">

        function Record_AddTransaction()
        {
            window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
        }
        function RowHover(td, on)
        {
            var tr = td.parentElement;

            //preceding deposits
            while (tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.previousSibling;
            }

            //main row
            if (on)
                tr.style.backgroundColor = "#f3f3f3";
            else
                tr.style.backgroundColor = "#ffffff";

            //following deposits
            tr = td.parentElement.nextSibling;
            while (tr != null && tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.nextSibling;
            }
        }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;"
        border="0" cellspacing="15">
        <tr>
            <td valign="top" style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a
                    id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Finances&nbsp;>&nbsp;Transactions
                By Type
            </td>
        </tr>
        <tr>
            <td style="height: 100%;" valign="top">
                <asi:TabStrip runat="server" ID="tsMain">
                </asi:TabStrip>
                <div id="dvPanel0" runat="server">
                    <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                        width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                Deposits
                            </td>
                            <td style="padding-right: 7;" align="right">
                            <asp:ImageButton ID="lnkPrint" runat="server" Text="Print" 
                                     ImageUrl="~/images/16x16_print.png" />
                            </td>
                        </tr>
                    </table>
                    <div id="innerData">  
                        
   

                        <asp:GridView ID="gvDeposits" runat="server" DataSourceID="dsDeposits" AutoGenerateColumns="False"
                        DataKeyNames="RegisterId" CssClass="entry" GridLines="none" HeaderStyle-Height="25px" AllowSorting="true">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <img id="Img2" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <img id="Img1" runat="server" src="~/images/16x16_cheque.png" border="0" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Width="22" />
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" Width="22"/>
                            </asp:TemplateField>
                            <asp:BoundField DataField="RegisterId" HeaderText="RegisterId" InsertVisible="False"
                                ReadOnly="True" SortExpression="RegisterId" Visible="False" />
                            <asp:BoundField DataField="ClientId" HeaderText="ClientId" SortExpression="ClientId"
                                Visible="False" />
                            <asp:BoundField DataField="AccountID" HeaderText="AccountID" SortExpression="AccountID"
                                Visible="False" />
                            <asp:BoundField DataField="TransactionDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Date"
                                SortExpression="TransactionDate">
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" Width="75"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="CheckNumber" HeaderText="Check #" SortExpression="CheckNumber">
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description"
                                Visible="False" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:c2}">
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                                <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Balance" HeaderText="Balance" SortExpression="Balance"
                                Visible="False" />
                            <asp:BoundField DataField="EntryTypeId" HeaderText="EntryTypeId" SortExpression="EntryTypeId"
                                Visible="False" />
                            <asp:TemplateField HeaderText="IFU" SortExpression="IsFullyPaid">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "IsFullyPaid"), Me)%>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center"  Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center"  Width="75"/>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Void" SortExpression="Void">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Void"), Me)%>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center"  Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center"  Width="75"/>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bounce" SortExpression="Bounce">
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Bounce"), Me)%>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center"  Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center"  Width="75"/>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Hold" SortExpression="Hold">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Hold"), Me)%>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center"  Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center"  Width="75"/>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Clear" SortExpression="Clear">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Clear"), Me)%>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center"  Width="75"/>
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center"  Width="75"/>
                            </asp:TemplateField>
                            <asp:BoundField DataField="BounceBy" HeaderText="BounceBy" SortExpression="BounceBy"
                                Visible="False" />
                            <asp:BoundField DataField="VoidBy" HeaderText="VoidBy" SortExpression="VoidBy" Visible="False" />
                            <asp:BoundField DataField="HoldBy" HeaderText="HoldBy" SortExpression="HoldBy" Visible="False" />
                            <asp:BoundField DataField="ClearBy" HeaderText="ClearBy" SortExpression="ClearBy"
                                Visible="False" />
                            <asp:BoundField DataField="ImportID" HeaderText="ImportID" SortExpression="ImportID">
                                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="MediatorID" HeaderText="MediatorID" SortExpression="MediatorID"
                                Visible="False" />
                            <asp:BoundField DataField="OldTable" HeaderText="OldTable" SortExpression="OldTable"
                                Visible="False" />
                            <asp:BoundField DataField="OldID" HeaderText="OldID" SortExpression="OldID" Visible="False" />
                            <asp:BoundField DataField="ACHMonth" HeaderText="ACHMonth" SortExpression="ACHMonth"
                                Visible="False" />
                            <asp:BoundField DataField="ACHYear" HeaderText="ACHYear" SortExpression="ACHYear"
                                Visible="False" />
                            <asp:BoundField DataField="FeeMonth" HeaderText="FeeMonth" SortExpression="FeeMonth"
                                Visible="False" />
                            <asp:BoundField DataField="FeeYear" HeaderText="FeeYear" SortExpression="FeeYear"
                                Visible="False" />
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                Visible="False" />
                            <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" SortExpression="CreatedBy"
                                Visible="False" />
                            <asp:BoundField DataField="AdjustedRegisterID" HeaderText="AdjustedRegisterID" SortExpression="AdjustedRegisterID"
                                Visible="False" />
                            <asp:BoundField DataField="OriginalAmount" HeaderText="OriginalAmount" SortExpression="OriginalAmount"
                                Visible="False" />
                            <asp:BoundField DataField="PFOBalance" HeaderText="PFOBalance" SortExpression="PFOBalance"
                                Visible="False" />
                            <asp:BoundField DataField="SDABalance" HeaderText="SDABalance" SortExpression="SDABalance"
                                Visible="False" />
                            <asp:BoundField DataField="RegisterSetID" HeaderText="RegisterSetID" SortExpression="RegisterSetID"
                                Visible="False" />
                            <asp:CheckBoxField DataField="InitialDraftYN" HeaderText="InitialDraftYN" SortExpression="InitialDraftYN"
                                Visible="False" />
                            <asp:BoundField DataField="CompanyID" HeaderText="CompanyID" SortExpression="CompanyID"
                                Visible="False" />
                            <asp:BoundField DataField="BouncedReason" HeaderText="BouncedReason" SortExpression="BouncedReason"
                                Visible="False" />
                            <asp:BoundField DataField="ClientDepositID" HeaderText="ClientDepositID" SortExpression="ClientDepositID"
                                Visible="False" />
                            <asp:CheckBoxField DataField="NotC21" HeaderText="NotC21" SortExpression="NotC21"
                                Visible="False" />
                        </Columns>
                        <EmptyDataTemplate>
                         <asp:Panel runat="server" ID="pnlNone" Style="text-align: center; padding: 20 5 5 5;">
                        This client has no deposits.</asp:Panel>
                        </EmptyDataTemplate>
                    </asp:GridView>
                        <asp:SqlDataSource ID="dsDeposits" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                        SelectCommandType="StoredProcedure" SelectCommand="stp_GetTransactionByType_Deposits"
                        ProviderName="System.Data.SqlClient">
                        <SelectParameters>
                            <asp:Parameter Name="clientId" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                  
                    <div style="text-align:center; margin-right: 100px;">Total: <asp:Label id="lblAmount" runat="server" /></div> 
                    </div>     
                    
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
