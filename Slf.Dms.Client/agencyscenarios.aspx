<%@ Page Language="VB" MasterPageFile="~/Site.master"  AutoEventWireup="false" CodeFile="agencyscenarios.aspx.vb" Inherits="AgencyScenarios"  %>
<asp:Content ID="phMenu" ContentPlaceHolderID="cphMenu" Runat="Server">
</asp:Content>
<asp:Content ID="phBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <style type="text/css">
           .firstTD { width: 150px; font-weight: bold;font-family:tahoma;font-size:11;}
    </style>
    <div>
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table style="table-layout:fixed;" border="0" cellpadding="5" cellspacing="0">
                        <tr>
						    <td style="background-color:rgb(222,223,216);font-weight:bold;font-family:tahoma;font-size:11px;"> 
                                &nbsp;&nbsp;<asp:Label ID="lblAgency" runat="server" Text="lblAgency" Width="411px"></asp:Label>
                            </td>
                        </tr>
                     </table>
                 </td>
            </tr>
            <tr> 
                <td valign="top" style="height:100%;width:100%;">
                    <div style="margin-left: 20px;">
                        &nbsp;
                        <table style="width:100%;height:100%;" cellspacing="15px" >
                            <asp:Literal ID="ltrGrid" runat="server" ></asp:Literal>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>


