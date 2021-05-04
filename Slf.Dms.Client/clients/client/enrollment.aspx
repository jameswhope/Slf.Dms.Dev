<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="enrollment.aspx.vb" Inherits="clients_client_enrollment" title="DMP - Client" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

    <script type="text/javascript">
    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    </script>
    
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
         <tr>
            <td>
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="bottom">
                                        <asp:Label Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                            runat="server" ID="lblName"></asp:Label>&nbsp;<a class="lnk" style="font-family:verdana;color:rgb(80,80,80);" runat="server" ID="lnkNumApplicants"></a><br />
                                        <asp:Label runat="server" ID="lblAddress"></asp:Label></td>
                                    <td align="right" valign="bottom">
                                        <asp:Label runat="server" ID="lblSSN"></asp:Label><br />
                                        Status:&nbsp;<asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server"
                                            ID="lnkStatus"></asp:LinkButton></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
                        background-repeat: repeat-x;">
                        <td><img height="30" width="1" runat="server" src="~/images/spacer.gif" /></td>
                    </tr>
                    <tr>
                        <td style="height: 100%;" valign="top">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width:50%;">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td style="width:100;">Qualified:</td>
                                                <td><asp:label runat="server" id="lblQualified"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Qualified Reason:</td>
                                                <td><asp:label runat="server" id="lblQualifiedReason"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="background-color:#f1f1f1;" colspan="2" align="center">Miscellaneous</td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Name:</td>
                                                <td><asp:label runat="server" id="lblNameName"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Phone:</td>
                                                <td><asp:label runat="server" id="lblPhone"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Zip Code:</td>
                                                <td><asp:label runat="server" id="lblZipCode"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Is Behind:</td>
                                                <td><asp:label runat="server" id="lblBehind"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Behind:</td>
                                                <td><asp:label runat="server" id="lblBehindName"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Concern:</td>
                                                <td><asp:label runat="server" id="lblConcern"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Agency:</td>
                                                <td><asp:label runat="server" id="lblAgencyName"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Company:</td>
                                                <td><asp:label runat="server" id="lblCompanyName"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:100;">Follow-Up Date:</td>
                                                <td><asp:label runat="server" id="lblFollowUpDate"></asp:label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td><img width="30" height="1" runat="server" src="~/images/spacer.gif"/></td>
                                    <td valign="top" style="width:50%;">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td style="width:120;">Committed:</td>
                                                <td><asp:label runat="server" id="lblCommitted"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Committed Reason:</td>
                                                <td><asp:label runat="server" id="lblCommittedReason"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="background-color:#f1f1f1;" colspan="2" align="center">Financial</td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Total Unsecured Debt:</td>
                                                <td><asp:label runat="server" id="lblTotalUnsecuredDebt"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Total Monthly Payment:</td>
                                                <td><asp:label runat="server" id="lblTotalMonthlyPayment"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Estimated End Amount:</td>
                                                <td><asp:label runat="server" id="lblEstimatedEndAmount"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Estimated End Time:</td>
                                                <td><asp:label runat="server" id="lblEstimatedEndTime"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Deposit Commitment:</td>
                                                <td><asp:label runat="server" id="lblDepositCommitment"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Balance At Screening:</td>
                                                <td><asp:label runat="server" id="lblBalanceAtEnrollment"></asp:label></td>
                                            </tr>
                                            <tr>
                                                <td style="width:120;">Balance At Settlement:</td>
                                                <td><asp:label runat="server" id="lblBalanceAtSettlement"></asp:label></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

</asp:Content>