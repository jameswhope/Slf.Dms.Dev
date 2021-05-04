<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Clients/client/client.master" CodeFile="Default.aspx.vb" Inherits="Clients.client.finances.Statements.Clients_client_finances_Statements_Default" Title="Client Statements" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>

<%@ Register Assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebCombo" tagprefix="igcmbo" %>
    
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript">

//    function RowHover(td, on)
//    {
//	    if (on)
//		    td.parentElement.style.backgroundColor = "#f3f3f3";
//	    else
//		    td.parentElement.style.backgroundColor = "#ffffff";
//    }
    function Record_Show()
    {
        <%= ClientScript.GetPostBackEventReference(lnkView, Nothing) %>;
    }
    function Record_Print() {
        <%= ClientScript.GetPostBackEventReference(lnkPrint, Nothing) %>;
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0" cellpadding="15">
        <tr>
            <td style="height: 100%;" valign="top">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;height:100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="font-size:11px;color:#666666;" width="78%" valign="top"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;Client Statements<br /><br />
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color:rgb(244,242,232);">
                                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td><img id="Img4" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                                <td style="width:100%;" valign="middle">
                                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td valign="middle" nowrap="nowrap" 
                                                                style="font-family: tahoma; font-size:11px; font-weight: bold">
                                                                Please choose a month and year
                                                            </td>
                                                            <td>
                                                                <asp:Image ID="imgArrow" runat="server" ImageUrl="~/images/16x16_arrowright (thin gray).png" ImageAlign="Bottom" />
                                                            </td>
                                                            <td nowrap="nowrap">
                                                            <asp:DropDownList AutoPostBack="false" style="font-size:11px;font-family:tahoma;" runat="server" id="ddlMonth">
                                                            <asp:ListItem value="January" text="January"></asp:ListItem>
                                                            <asp:ListItem value="February" text="February"></asp:ListItem>
                                                            <asp:ListItem value="March" text="March"></asp:ListItem>
                                                            <asp:ListItem value="April" text="April"></asp:ListItem>
                                                            <asp:ListItem value="May" text="May"></asp:ListItem>
                                                            <asp:ListItem value="June" text="June"></asp:ListItem>
                                                            <asp:ListItem value="July" text="July"></asp:ListItem>
                                                            <asp:ListItem value="August" text="August"></asp:ListItem>
                                                            <asp:ListItem value="September" text="September"></asp:ListItem>
                                                            <asp:ListItem value="October" text="October"></asp:ListItem>
                                                            <asp:ListItem value="November" text="November"></asp:ListItem>
                                                            <asp:ListItem value="December" text="December"></asp:ListItem>
                                                            </asp:DropDownList>
                                                            </td>
                                                            <td>
                                                                |
                                                            </td>
                                                            <td nowrap="nowrap"><asp:DropDownList AutoPostBack="true"  style="font-size:11px;font-family:tahoma;" runat="server" id="ddlYear">
                                                            <%--<asp:ListItem value="2007" text="2007"></asp:ListItem>
                                                            <asp:ListItem value="2008" text="2008"></asp:ListItem>
                                                            <asp:ListItem value="2009" text="2013"></asp:ListItem>--%>
                                                            <asp:ListItem value="2010" text="2013"></asp:ListItem>
                                                            <asp:ListItem value="2011" text="2014"></asp:ListItem>
                                                            <asp:ListItem value="2012" text="2015"></asp:ListItem>
                                                            <asp:ListItem value="2013" text="2016"></asp:ListItem>
                                                            <asp:ListItem value="2014" text="2017"></asp:ListItem>
                                                            </asp:DropDownList></td>
                                                            <td>
                                                                &nbsp;</td>
                                                            <td nowrap="nowrap" style="width:100%;">&nbsp;</td>
                                                            <td runat="server" id="tdShow" align="right"><a class="lnk" id="lnkShow" disabled="false" runat="server" href="javascript:Record_Show();">View</a></td>
                                                            <td nowrap="nowrap"><img id="Img1" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="nowrap"><a id="prtButton" runat="server" class="gridButton" href="javascript:Record_Print();"><img id="Img11" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                                            <td nowrap="nowrap" style="width:10;">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%--Statement starts here--%>
                                <tr>
                                    <td valign="top">
                                        <table style="font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                            <tr>
                                                <td style="width:400px; font-family: tahoma; font-size: x-large; font-weight: bold;" 
                                                    id="tdAtty">
                                                    <asp:Table ID="tblAtty" runat="server" Height="66px" Width="342px">
                                                        <asp:TableRow ID="TableRow1" runat="server" BorderStyle="Solid" BorderWidth="1px">
                                                            <asp:TableCell ID="tcAttyName" runat="server" Font-Bold="True" 
                                                                Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow ID="TableRow2" runat="server">
                                                            <asp:TableCell ID="tcAttyAddress" runat="server" Font-Bold="false" 
                                                                Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow ID="TableRow3" runat="server">
                                                            <asp:TableCell ID="tcAttyCSZ" runat="server" Font-Bold="false" Font-Names="Tahoma" 
                                                                Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                    </asp:Table>
                                                    <asp:Table ID="tblClient" runat="server" Height="66px" Width="342px" 
                                                        BorderColor="#ADD8E6" BorderWidth="1px">
                                                        <asp:TableRow runat="server" BorderStyle="Solid" BorderWidth="1px">
                                                            <asp:TableCell ID="tcClientName" runat="server" Font-Bold="True" 
                                                                Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow runat="server">
                                                            <asp:TableCell ID="tcClientAddress" runat="server" Font-Bold="True" 
                                                                Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow runat="server">
                                                            <asp:TableCell runat="server" ID="tcClientCSZ" Font-Bold="True" Font-Names="Tahoma" 
                                                                Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                    </asp:Table>
                                                    
                                                    <asp:Label ID="lblPeriod" runat="server" Font-Names="Tahoma" Font-Size="Medium" ></asp:Label>
                                                    <br />
                                                    Transaction Detail:
                                                    </td>
                                                <td style="width:400px; font-family: tahoma; font-size: x-large; font-weight: bold; text-align: right;" 
                                                    valign="top" id="lblStatus" align="right">

                                                    <asp:Table ID="tblDepDates" runat="server" BorderWidth="1px" BorderColor="#ADD8E6" 
                                                        Caption="Deposits" Font-Bold="True" Font-Names="Tahoma" Font-Size="11px" 
                                                        Height="121px" Width="471px">
                                                        <asp:TableRow ID="rowDeposit1" runat="server">
                                                            <asp:TableCell ID="tcDepDate1" runat="server" Width="100px" Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell ID="tcDepAmt1" runat="server" Width="50px" Wrap="false" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell runat="server" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px">Account Number</asp:TableCell>
                                                            <asp:TableCell runat="server" ID="tcAccountNo"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow ID="rowDeposit2" runat="server">
                                                            <asp:TableCell ID="tcDepDate2" runat="server" Width="100px" Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell ID="tcDepAmt2" runat="server" Width="50px"  Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell runat="server" Width="150" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px">Deposit Due Date</asp:TableCell>
                                                            <asp:TableCell runat="server" Width="85" ID="tcDepDate0"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow ID="rowDeposit3" runat="server">
                                                            <asp:TableCell ID="tcDepDate3" runat="server" Width="100px" Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell ID="tcDepAmt3" runat="server" Width="50px"  Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow ID="rowDeposit4" runat="server">
                                                            <asp:TableCell ID="tcDepDate4" runat="server" Width="100px" Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                            <asp:TableCell ID="tcDepAmt4" runat="server" Width="50px"  Wrap="False" Font-Bold="false" Font-Names="Tahoma" Font-Size="11px"></asp:TableCell>
                                                        </asp:TableRow>
                                                        <asp:TableRow runat="server">
                                                            <asp:TableCell runat="server" ColumnSpan="3" RowSpan="2" Width="200px">Monthly Deposit commitment</asp:TableCell>
                                                            <asp:TableCell runat="server" Width="50px" ID="tcMinDeposit"></asp:TableCell>
                                                        </asp:TableRow>
                                                    </asp:Table>
                                                    <asp:Label ID="lblStatusReport" runat="server" Font-Bold="True" 
                                                        Font-Names="Tahoma" Font-Size="X-Large" Text="STATUS REPORT"></asp:Label>
                                                    <br />
                                                    <asp:Label runat="server" ID="spAccountNo" style="font-weight: normal; font-size: medium; font-family: tahoma;"></asp:Label></td>
                                            </tr>
                                        </table>
                                        <input type="hidden" runat="server" id="txtSelectedAccounts"/><input type="hidden" runat="server" id="txtSelectedControlsClientIDs"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height:50%" valign="top"> 
                            <asp:GridView ID="grdTransactions" runat="server" AutoGenerateColumns="False" 
                                Height="60px" Width="100%" HeaderStyle-Height="20px" >
                                <Columns>
                                    <asp:BoundField HeaderText="Date" ReadOnly="True" DataField="TransactionDate" DataFormatString="{0:MM/dd/yyyy}">
                                        <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Description" ReadOnly="true" DataField="EntryTypeName">
                                        <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Amount" ReadOnly="true" DataField="Amount" DataFormatString="{0:c}" >
                                        <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px"  HorizontalAlign="Right"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Account Balance" ReadOnly="true" DataField="SDABalance" DataFormatString="{0:c}">
                                        <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px" BackColor="#F0F8FF" HorizontalAlign="Right"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Balance Owed" ReadOnly="true" DataField="PFOBalance" DataFormatString="{0:c}">
                                        <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px" BackColor="#ADD8E6" HorizontalAlign="Right"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                                <HeaderStyle BackColor="#ADD8E6" />
                            </asp:GridView>
                        </td>
                   </tr>
                    <tr>
                        <td style="height:50%;" valign="top">
                            <asp:Label ID="Label1"  runat="server" Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Large" Text="Creditor Status:"></asp:Label>
                            <asp:GridView ID="grdCreditor" runat="server" AutoGenerateColumns="False" 
                                Width="100%" HeaderStyle-Height="20px">
                                <Columns>
                                    <asp:BoundField HeaderText="Creditor" ReadOnly="true" DataField="Cred_Name" >
                                    <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Account Number" ReadOnly="true" DataField="Orig_Acct_No">
                                    <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="*Current Balance" ReadOnly="true" DataField="Balance" DataFormatString="{0:c}">
                                    <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px" BackColor="#F0F8FF" HorizontalAlign="Right"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Status" ReadOnly="true" DataField="Status">
                                    <HeaderStyle Font-Names="Tahoma" Font-Size="12px" />
                                        <ItemStyle Font-Names="Tahoma" Font-Size="11px" Height="15px" BackColor="#ADD8E6" HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                                <HeaderStyle BackColor="#ADD8E6" />
                            </asp:GridView>
                            <br />
                            <br />
                    <table>
                        <tr>
                            <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                AR - Account removed from program.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                IF - Insufficient funds to negotiate balance.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                OM - Offer made to creditor. Waiting for a response.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                CN - Creditor not ready to settle at this time.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                SA - Settled Account.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                SC - Settlement cancelled.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                SR - Settlement Rejected by client.
                             </td>
                             <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" >
                                UD - Unverified Debt.
                             </td>
                        </tr>
                        <tr>
                            <td valign="top" style="font-weight:Normal; font-family: tahoma; font-size:xx-small;" colspan="8" >
                                *The above current balance was received by your creditor and is deemed reliable but its accuracy is not guaranteed.
                            </td>
                        </tr>
                    </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:LinkButton runat="server" ID="lnkView"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkPrint"></asp:LinkButton>
</asp:Content>