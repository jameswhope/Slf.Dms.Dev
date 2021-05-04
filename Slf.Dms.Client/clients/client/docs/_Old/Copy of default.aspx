<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_docs_default" title="DMP - Client - Documents" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <script type="text/javascript" language="javascript">
        window.onload = function ()
        {
            history.back(1);
        }
    </script>
    
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td></td>
        </tr>
    </table>
</asp:Content>