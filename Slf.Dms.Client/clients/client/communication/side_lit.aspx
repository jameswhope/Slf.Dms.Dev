<%@ Page Language="VB" AutoEventWireup="false" CodeFile="side_lit.aspx.vb" Inherits="clients_client_communication_side_lit" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DMP - Litigation</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
</head>
<body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;"  onload="SetFocus('<%= txtMessage.ClientID %>');" >
    <form id="form1" runat="server">
        <script type="text/javascript">
        function RedirectTop(s)
        {
            self.top.location = s;
        }
        </script>
        
        <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="background-color:rgb(244,242,232);" >
                    <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                            <td style="width:100%;">
                                <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td nowrap="true">
                                             &nbsp;
                                        </td>
                                        <td nowrap="true" style="width:100%;height:25">&nbsp;</td>
                                        <td nowrap="true">
                                             <asp:LinkButton ID="lnkCancel" runat="server" class="gridButton">
                                                <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_cancel.png" />
                                                Cancel
                                            </asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width:10;">&nbsp;</td>
                                     </tr>
                                </table>
                            </td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
            <tr id="trInfoBox" runat="server" >
                <td style="padding:5px">
                    <div class="iboxDiv">
                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                            <tr>
                                <td valign="top" style="width:16;"><img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                <td>
                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="iboxHeaderCell"><asp:Literal id="ltrNew" runat="server"></asp:Literal>Litigation Entry for <b>Client</b> <%=ClientName %></td>
                                        </tr>
                                        
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr >
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
                        <tr style="padding-left:5px;padding-right:5px">
                            <td style="width:100%;" valign="top">
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
                                        <td class="entrytitlecell" colspan="2" style="width:100%">
                                            Message:<br />
                                            <div style="padding-top:5px">
                                                <asp:TextBox cssclass="entry" runat="server" id="txtMessage" Rows="20" TextMode="MultiLine" MaxLength="1000" Columns="50" ReadOnly="true" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height:100%;">
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </form>
</body>
</html>