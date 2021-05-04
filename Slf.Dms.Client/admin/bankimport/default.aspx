<%@ Page Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="bankimport_default" title="Bank Import Interface" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server"><asp:Panel runat="server" ID="pnlBody">

    <script type="text/javascript" language="javascript">
        function ImportFile()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkImportFile, Nothing) %>;
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
                            <img runat="server" src="~/images/grid_top_left.png" border="0" alt="" />
                        </td>
                        <td style="width:100%;">
                            <table style="height:25;background-image:url(<%=ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="width:5px;">
                                        &nbsp;
                                    </td>
                                    <td style="width:15px;vertical-align:middle;">
                                        File:&nbsp;&nbsp;
                                    </td>
                                    <td style="width:200px;">
                                        <asp:FileUpload id="txtFile" style="width:100%;height:18px;font-family:Tahoma;font-size:11px" visible="true" runat="server" />
                                    </td>
                                    <td style="width:15px;">
                                        &nbsp;
                                    </td>
                                    <td style="width:60px;vertical-align:middle;">
                                        Report To:&nbsp;&nbsp;
                                    </td>
                                    <td style="width:155px;">
                                        <asp:TextBox id="txtReportTo" style="width:150px;height:18px;font-family:Tahoma;font-size:11px" visible="true" runat="server" />
                                    </td>
                                    <td style="width:25px;">
                                        &nbsp;
                                    </td>
                                    <td style="width:auto;text-align:left;">
                                        <a id="btnImport" href="javascript:ImportFile()" class="gridButton" visible="true" runat="server"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_file_add.png" />
                                            Import Bank File
                                        </a>
                                        <asp:LinkButton id="lnkImportFile" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width:100%;height:100%;vertical-align:top;text-align:left;">
                <asp:Label ID="lblLog" runat="server" />
            </td>
        </tr>
    </table>
</asp:Panel></asp:Content>