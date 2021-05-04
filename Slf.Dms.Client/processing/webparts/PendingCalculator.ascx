<%@ Control Language="VB" AutoEventWireup="false" CodeFile="PendingCalculator.ascx.vb" Inherits="processing_webparts_PendingCalculator" %>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

<script type="text/javascript">
    function checkAll(chk_SelectAll) {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                el.checked = chkState;
            }
        }

        UpdateSettlementData();
    }

    function UpdateSettlementData() {
        var totalSettAmount = 0;
        var totalFees = 0;
        var totalSaving = 0;
        var totalCredit = 0;
        var totalDeliveryFees = 0;
        var totalAmtAvailable = 0;
        var totalOwed = 0;
        var totalFeeAvailable = 0;
        var totalFeeOwed = 0;
        var totalSettlementCosts = 0;
        
        var gridControl = document.getElementById("<%=GridView1.ClientID %>");
        var txtDeliveryFees = document.getElementById("<%=lblDeliveryFee.ClientID %>");
        var txtFees = document.getElementById("<%=lblFee.ClientID %>");
        var txtSavings = document.getElementById("<%=lblSavings.ClientID %>");
        var txtCredit = document.getElementById("<%=lblFeeCredit.ClientID %>");
        var txtAmount = document.getElementById("<%=lblSettAmount.ClientID %>");
        var txtSDA = document.getElementById("<%=lblSDABalance.ClientID %>");
        var txtPFO = document.getElementById("<%=lblPFOBalance.ClientID %>");
        var txtFeeAvailable = document.getElementById("<%=lblFeeAvailable.ClientID %>");
        var txtFeeOwed = document.getElementById("<%=lblFeeOwed.ClientID %>");
        var txtAmtAvailable = document.getElementById("<%=lblAvailable.ClientID %>");
        var txtAmtOwed = document.getElementById("<%=lblAmountOwed.ClientID %>");
        var txtSettCost = document.getElementById("<%=lblSettCost.ClientID %>");

        var rowcount = gridControl.rows.length;

        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) {
                if (isNaN(parseFloat(gridControl.rows[i].cells[4].innerText.replace("$", "").replace(",", ""))) == false) {
                    totalSettAmount += parseFloat(gridControl.rows[i].cells[4].innerText.replace("$", "").replace(",", ""));
                }

               if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[1].value)) == false) {
                   totalSettlementCosts += parseFloat(gridControl.rows[i].cells[0].children[1].value);
               }

               if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[2].value)) == false) {
                   totalAmtAvailable += parseFloat(gridControl.rows[i].cells[0].children[2].value);
               }

               if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[4].value)) == false) {
                   totalOwed += parseFloat(gridControl.rows[i].cells[0].children[4].value);
               }

               if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[5].value)) == false) {
                   totalFeeAvailable += parseFloat(gridControl.rows[i].cells[0].children[5].value);
               }

               if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[7].value)) == false) {
                   totalFeeOwed += parseFloat(gridControl.rows[i].cells[0].children[7].value);
               }
                
                if (isNaN(parseFloat(gridControl.rows[i].cells[11].innerText.replace("$", "").replace(",", ""))) == false) {
                    totalSaving += parseFloat(gridControl.rows[i].cells[11].innerText.replace("$", "").replace(",", ""));
                }

                if (isNaN(parseFloat(gridControl.rows[i].cells[10].innerText.replace("$", "").replace(",", ""))) == false) {
                    totalCredit += parseFloat(gridControl.rows[i].cells[10].innerText.replace("$", "").replace(",", ""));
                }

                if (isNaN(parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""))) == false) {
                    totalDeliveryFees += parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""));
                }

                if (isNaN(parseFloat(gridControl.rows[i].cells[7].innerText.replace("$", "").replace(",", ""))) == false) {
                    totalFees += parseFloat(gridControl.rows[i].cells[7].innerText.replace("$", "").replace(",", ""));
                }
            }
        }

        var regbal = parseFloat(txtSDA.innerText.replace("$", "").replace(",", ""));
        var pfobal = parseFloat(txtPFO.innerText.replace("$", "").replace(",", ""));

        txtAmount.innerText = "$" + FormatNumber(totalSettAmount, false, 2);
        txtCredit.innerText = "$" + FormatNumber(totalCredit, false, 2);
        txtDeliveryFees.innerText = "$" + FormatNumber(totalDeliveryFees, false, 2);
        txtFees.innerText = "$" + FormatNumber(totalFees, false, 2);
        txtSavings.innerText = "$" + FormatNumber(totalSaving, false, 2);
        txtAmtAvailable.innerText = "$" + FormatNumber(totalAmtAvailable, false, 2);
        if (regbal > totalSettAmount) {
            txtAmtAvailable.style.color = "green";
        }
        else {
            txtAmtAvailable.style.color = "red";
        }
        
        txtAmtOwed.innerText = "$" + FormatNumber(totalOwed, false, 2);
        
        if ((regbal - pfobal - totalSettAmount) > totalSettlementCosts) {
            txtFeeAvailable.style.color = "green";
            txtFeeAvailable.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
            txtFeeOwed.innerText = "$" + FormatNumber(0, false, 2);
        }
        else {
            txtFeeAvailable.style.color = "red";
            if ((regbal - pfobal - totalSettAmount) >= 0) {
                txtFeeAvailable.innerText = "$" + FormatNumber((regbal - pfobal - totalSettAmount), false, 2);
                txtFeeOwed.innerText = "$" + FormatNumber((totalSettlementCosts - (regbal - pfobal - totalSettAmount)), false, 2);
            }
            else {
                txtFeeAvailable.innerText = "$" + FormatNumber(0, false, 2);
                txtFeeOwed.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
            }
        }
        
        txtSettCost.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
    }
    
</script>

<asp:UpdatePanel ID="updPendingSettlementCalculator" runat="server">
    <ContentTemplate>
        <table style="height: 80%; width: 100%;">
            <tr valign="top">
                <td style="height:100%;">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="False" AllowSorting="True"
                        AutoGenerateColumns="False" BorderStyle="None" 
                        GridLines="none" PageSize="7" Width="100%" CssClass="entry">
                        <HeaderStyle ForeColor="Black" />
                        <EmptyDataTemplate>
                            <div>
                                No records to display.</div>
                        </EmptyDataTemplate>
                        <Columns>     
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <input type="checkbox" runat="server" id="chk_select" onclick="UpdateSettlementData();"/>
                                    <input type="hidden" runat="server" id="hdnSettCost" value='<%#DataBinder.Eval(Container.DataItem, "SettlementCost")%>'/>
                                    <input type="hidden" runat="server" id="hdnAmtAvail" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtAvailable")%>'/>
                                    <input type="hidden" runat="server" id="hdnAmtSent" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtBeingSent")%>'/>
                                    <input type="hidden" runat="server" id="henAmtOwed" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtStillOwed")%>'/>
                                    <input type="hidden" runat="server" id="hdnFeeAvail" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtAvailable")%>'/>
                                    <input type="hidden" runat="server" id="hdnFeePaid" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtBeingPaid")%>'/>
                                    <input type="hidden" runat="server" id="hdnFeeOwed" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtStillOwed")%>'/>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Width="25" />
                                <ItemStyle HorizontalAlign="Left" CssClass="listItem" Width="25" />
                             </asp:TemplateField>                                                                                      
                            <asp:BoundField DataField="CreditorName" HeaderText="CreditorName"
                                HtmlEncode="False" >
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AccountNumber" HeaderText="Acct#" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AccountBalance" DataFormatString="{0:C}" HeaderText="Account Balance"
                                HtmlEncode="False" >
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>   
                            <asp:BoundField DataField="SettlementAmount" DataFormatString="{0:C}" HeaderText="Settlement Amount"
                                HtmlEncode="False" SortExpression="SettlementAmount" >
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true" />
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SettlementPercent" DataFormatString="{0:N}" HeaderText="Settlement %"
                                HtmlEncode="False" >
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SettlementDueDate" DataFormatString="{0:d}" HeaderText="Due Date"
                                HtmlEncode="False" SortExpression="SettlementDueDate">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>          
                             <asp:BoundField DataField="SettlementFee" HeaderText="Sett Fee" DataFormatString="{0:C}"
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField> 
                            <asp:BoundField DataField="SettlementFeePercentage" HeaderText="Sett Fee %" DataFormatString="{0:N}"
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField> 
                             <asp:BoundField DataField="DeliveryFee" HeaderText="Delivery Fee" DataFormatString="{0:C}"
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField> 
                             <asp:BoundField DataField="SettlementFeeCredit" HeaderText="Sett Fee Credit" DataFormatString="{0:C}"
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField> 
                            <asp:BoundField DataField="SettlementSavings" HeaderText="Savings" DataFormatString="{0:C}"
                                HtmlEncode="false" SortExpression="SettlementSavings">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem"  />
                            </asp:BoundField> 
                            <asp:BoundField DataField="Status" HeaderText="Status" 
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" Wrap="true"/>
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem"  />
                            </asp:BoundField> 
                        </Columns>
                    </asp:GridView>                    
                </td>
            </tr> 
            </table>  
                       
            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                cellspacing="0" border="0">
                <tr>
                    <td style="background-color: #DCDCDC; height:20px; border-bottom: solid 1px #d3d3d3; font-weight:bold;color:Black; font-size:11px; font-family:tahoma;">
                             Calculator
                    </td> 
                </tr>                        
                <tr>
                    <td style="padding: 5 10 10 10;">
                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                    cellspacing="3" border="0">
                            <tr>
                                <td>
                                    <table style="width:100%;">
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Available SDA Balance:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblSDABalance" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black" />
                                            </td>                                                
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                PFO Balance:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblPFOBalance" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Next Deposit Amount:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblDeliveryAmount" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Next Deposit Date:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblDeliveryDate" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                        </tr>
                                    </table>
                                </td>
                                 <td>
                                    <table style="border-right-color:#BEDCE6;border-right-width:2px;border-right-style:solid;border-left-color:#BEDCE6;border-left-width:2px;border-left-style:solid;width:100%">
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Settlement Amount:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblSettAmount" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black;"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Savings:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblSavings" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Amount Owed:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblAmountOwed" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Amount Available:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblAvailable" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Fee Owed:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblFeeOwed" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table style="width:100%;">
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Fee:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblFee" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>                                    
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Fee Credit:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblFeeCredit" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Delivery Fees:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblDeliveryFee" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px">
                                                Total Fee Amount Available:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblFeeAvailable" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15;" align="center" />
                                            <td style="width: 130; color:Black;font-family:Tahoma;font-size:11px" nowrap="true">
                                                Total Settlement Costs:</td>
                                            <td style="width: 70;">
                                                <asp:Label id="lblSettCost" runat="server" style="width:60;font-family:Tahoma;font-size:11px;color:Black"/>
                                            </td>
                                        </tr>
                                    </table>                         
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>                                               
            </table>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="Sorting" />
    </Triggers>
</asp:UpdatePanel>
      
