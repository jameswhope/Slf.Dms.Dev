<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="litcomm.aspx.vb" Inherits="clients_client_communciation_litcomm" title="DMP - Client - Note" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:placeholder id="phBody" runat="server">

<body onload="SetFocus('<%= txtMessage.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    
    <script type="text/javascript" language="javascript">
        function CancelAndClose()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
        }
    </script>
    
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:auto;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;height:25px">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkCommunications" runat="server" class="lnk" style="color: #666666;">Communications</a>&nbsp;>&nbsp;<asp:label id="lblNote" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="50%">
                    <tr>
                        <td colspan="3">
                            <div runat="server" id="dvError" style="display:none;">
                                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                <tr>
						                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:50%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="2">Details</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Created by:</td>
                                    <td><asp:label cssclass="entry2" runat="server" id="txtCreatedBy"></asp:label> on <asp:label cssclass="entry2" runat="server" id="txtCreatedDate"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Last modified by:</td>
                                    <td><asp:label cssclass="entry2" runat="server" id="txtLastModifiedBy"></asp:label> on <asp:label cssclass="entry2" runat="server" id="txtLastModifiedDate"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Subject:</td>
                                    <td><asp:label cssclass="entry2" runat="server" id="lblSubject"></asp:label></td>
                                </tr>
                                <tr id="trMessage" runat="server">
                                    <td class="entrytitlecell" colspan="2">Message:<br /><asp:textbox TabIndex="3" cssclass="entry" runat="server" id="txtMessage" Rows="10" TextMode="MultiLine" MaxLength="5000" Columns="50" style="width:50em" ReadOnly="true"></asp:textbox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

<asp:LinkButton ID="lnkCancelAndClose" runat="server" />

</asp:placeholder></asp:Content>