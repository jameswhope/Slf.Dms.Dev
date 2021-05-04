<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="data.aspx.vb" Inherits="clients_client_docs_data" title="DMP - Client - Data Entry" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entry2 { font-family:tahoma;font-size:11px; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
    
    <script type="text/javascript">

	function Record_CancelAndClose()
	{
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
	function Record_DeleteConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/deleteholder.aspx?t=Data Entry&p=data entry") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }

    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkDocuments" runat="server" class="lnk" style="color: #666666;">Documents</a>&nbsp;>&nbsp;<asp:label id="lblDataEntry" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr>
            <td valign="top" style="background-color:#f1f1f1;padding:10 10 10 10;">Entry Type:&nbsp;<asp:dropdownlist autopostback="true" cssclass="entry2" runat="server" id="cboDataEntryTypeID"></asp:dropdownlist><asp:label runat="server" id="lblDataEntryTypeName"></asp:label>&nbsp;&nbsp;Conducted:&nbsp;<cc1:inputmask mask="nn/nn/nnnn nn:nn aa" cssclass="entry2" style="width:120" runat="server" id="txtConducted"></cc1:inputmask><asp:label runat="server" id="lblConducted"></asp:label></td>
        </tr>
        <tr>
            <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-x;background-position:left center;" valign="top"><img id="Img1" width="1" height="1" src="~/images/spacer.gif" runat="server" border="0"/></td>
        </tr>
        <tr>
            <td valign="top" style="height:100%;">
                <asp:panel runat="server" id="pnlSheet">
                    <asp:placeholder runat="server" id="phSheet"></asp:placeholder>
                </asp:panel>
                <asp:panel runat="server" id="pnlNoSheet">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		                <tr>
			                <td valign="top" style="width:20;"><img id="imgError" runat="server" src="~/images/16x16_file_help.png" align="absmiddle" border="0"></td>
			                <td><asp:label runat="server" id="lblError"></asp:label></td>
		                </tr>
	                </table>&nbsp;
                </asp:panel>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>

</body>

</asp:Content>