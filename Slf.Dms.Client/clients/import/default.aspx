<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clientimport_default" title="Client Import" EnableEventValidation="false" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td nowrap="true" id="tdImport" runat="server">
                    <asp:LinkButton id="lnkImportClient" runat="server" />
                    <a runat="server" class="menuButton" href="javascript:ImportClient()" visible="false" id="btnClientImport">
                        <img id="imgImport" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_person_add.png" alt="" />
                        Import Client(s)
                    </a>
                </td>
                <td style="width:100%;">
                    <img id="Img1" width="8" height="28" src="~/images/spacer.gif" alt="" runat="server" />
                </td>
                <td nowrap="true" id="tdHelp" runat="server">
                    <asp:LinkButton id="LinkButton1" runat="server" />
                    <a runat="server" class="menuButton" href="#" onclick="window.open('help.aspx', 'Help', 'width=550,height=300,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0'); return false;" id="btnHelp">
                        <img id="imgHelp" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_file_help.png" alt="" />
                        Help
                    </a>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server"><asp:Panel runat="server" ID="pnlBody">

    <script language="javascript" type="text/javascript">
        var excel = -1;
        var intExcel = -1;
        
        function Validate()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkValidate, Nothing) %>;
        }
        
        function EditExcel()
        {
            var fileName = document.getElementById('<%=hdnFileName.ClientId %>');
            
            if (fileName.value != 'none')
            {
                if (fileName.value.length > 0)
                {
                    excel = window.open('file:///' + fileName.value);
                    intExcel = setInterval('CheckFocus()', 25);
                    //window.location.href = 'file:///' + fileName.value;
                }
            }
        }
        
        function CheckFocus()
        {
            if (excel.blur)
            {
                excel.close();
                clearInterval(intExcel);
            }
        }
        
        function ImportClient()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkImportClient, Nothing) %>;
        }
    </script>
    
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" colspan="2">
                <div runat="server" id="dvError" style="display:none;">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td valign="top" width="20"><img id="imgMessage" runat="server" src="~/images/message.png" align="middle" border="0"></td>
                            <td runat="server" id="tdError"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td style="background-color:rgb(244,242,232);" colspan="2">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <img id="Img2" runat="server" src="~/images/grid_top_left.png" border="0" />
                        </td>
                        <td style="width:100%;">
                            <table style="height:25;background-image:url(<%=ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="width:8px;">&nbsp;</td>
                                    <td style="width:15px;vertical-align:middle;">File:&nbsp;&nbsp;</td>
                                    <td style="width:200px;"><asp:FileUpload id="txtPath" style="width:100%;height:18px;font-family:Tahoma;font-size:11px" visible="true" runat="server" /></td>
                                    <td style="width:10px;">&nbsp;</td>
                                    <td style="width:130px;"><asp:DropDownList id="ddlAgency" width="125" runat="server" style="font-family:Tahoma;font-size:11px" Enabled="false" Visible="false" /></td>
                                    <td style="width:8px;">&nbsp;</td>
                                    <td style="width:130px;"><asp:DropDownList id="ddlCompany" width="125" runat="server" style="font-family:Tahoma;font-size:11px" Enabled="false" Visible="false" /></td>
                                    <td style="width:5px;">&nbsp;</td>
                                    <td style="width:15px;vertical-align:middle;"><asp:Label ID="lblDate" Text="Date:&nbsp;&nbsp;" Visible="false" runat="server" /></td>
                                    <td style="width:55px;"><cc1:InputMask class="entry" runat="server" ID="txtDate" Mask="nn/nn/nn" width="100%" height="18px" Enabled="false" Visible="false" /></td>
                                    <td style="width:5px;">&nbsp;&nbsp;&nbsp;</td>
                                    <td style="width:15px;vertical-align:middle;"><asp:Label ID="lblSheet" Text="Sheet:&nbsp;&nbsp;" Visible="false" runat="server" /></td>
                                    <td style="width:150px;"><asp:DropDownList id="ddlSheet" AccessKey="1" style="font-family:Tahoma;font-size:11px" AutoPostBack="true" OnSelectedIndexChanged="ddlSheet_OnSelectedIndexChanged" runat="server" Enabled="false" Visible="false" /></td>
                                    <td style="width:5px;">&nbsp;</td>
                                    <td style="width:10px;"><img id="imgSeparator" style="margin: 0px 3px 0px 3px;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td style="width:50px;text-align:right;">
                                        <asp:LinkButton id="lnkValidate" runat="server" />
                                        <a href="javascript:Validate()" class="gridButton"><img id="Img3" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Validate</a>
                                    </td>
                                    <td style="width:75px;text-align:right;">
                                        <a id="btnEdit" href="javascript:EditExcel();" class="gridButton" visible="true" runat="server"><img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/excel.png" />Edit File</a>
                                        <input id="hdnFileName" type="hidden" runat="server" value="none" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width:100%;height:auto;">
                <asp:Label style="text-align:Center" ID="lblFile" Width="100%"  BackColor="#FDF5E6" Font-Names="Tahoma" Font-Size="8" Font-Bold="False" BorderStyle="none" BorderColor="#FDF5E6" BorderWidth="5" runat="server" Visible="true" />
            </td>
        </tr>
        <tr>
            <td style="width:100%;height:auto;">
                <asp:Label ID="lblNote" Width="100%" BackColor="#ADD8E6" Font-Names="Tahoma" Font-Size="8" BorderStyle="solid" BorderColor="#ADD8E6" BorderWidth="3" runat="server" Visible="false" />
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td style="width:100%;height:100%;padding:5px;vertical-align:top;">
                <asp:DataGrid ID="dtgExcel" Font-Size="12px" Visible="true" runat="server" />
            </td>
        </tr>
    </table>
</asp:Panel></asp:Content>