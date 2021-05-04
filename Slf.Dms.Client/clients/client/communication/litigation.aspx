<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="litigation.aspx.vb" Inherits="clients_client_communication_litigation" Title="DMP - Client - Communication" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/clients/">Clients</a>&nbsp;>&nbsp;<a
                    id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Communication</td>
        </tr>
        
        <tr>
            <td style="height:100%" valign="top">
                <asi:TabStrip runat="server" id="tsMain"></asi:TabStrip>
                <div id="dvPanel0" runat="server"></div>
                <div id="dvPanel1" runat="server"></div>
                <div id="dvPanel2" runat="server">
                    <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding:5 7 5 7;color:rgb(50,112,163);">Litigation Communication</td>
                            <td style="padding-right:7;" align="right"></td>
                            <td align="right">&nbsp;</td>
                        </tr>
                    </table>
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                        <asp:placeholder id="phCommunication_default" runat="server">
                            <tr>
                                <td valign="top" hover="false">
                                    <div style="overflow:auto;height:100%">
                                        <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)" class="list" onselectstart="return false;" id="tblNotes" style="font-size:11px;font-family:tahoma;height:100%" cellspacing="0" cellpadding="3" width="100%" border="0">
                                            <colgroup>
                                                <col width="30px" align="center" />
                                                <col width="150px" align="left" />
                                                <col align="left" />
                                                <col width="35px" align="right" />
                                                <col width="20px" />
                                            </colgroup>
                                            <thead>
                                                <tr style="height:20px">
                                                    <th class="headItem" style="width:30px" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" /></th>
                                                    <th class="headItem" style="width:100px" align="center">Date&nbsp;<img runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle" /></th>
                                                    <th class="headItem" align="left">Subject</th>
                                                    <th class="headItem" style="width:35px" align="right">Staff</th>
                                                    <th class="headItem" style="width:20px">&nbsp;</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <asp:repeater id="rpLitCommunication" runat="server">
						                            <itemtemplate>
						                                <a href="<%=ResolveUrl("~\clients\client\communication\litcomm.aspx") %>?id=<%#ClientID %>&table=<%#CType(Container.DataItem, LitCommunication).CommTable %>&date=<%#CType(Container.DataItem, LitCommunication).CommDate %>&time=<%#CType(Container.DataItem, LitCommunication).CommTime %>&staff=<%#CType(Container.DataItem, LitCommunication).Staff %>">
							                                <tr>
						                                        <td class="noBorder"><img src="<%#GetImage(CType(Container.DataItem, LitCommunication).CommType) %>" />&nbsp;</td>
						                                        <td class="noBorder"><%#CType(Container.DataItem, LitCommunication).Date.ToString("g") %>&nbsp;</td>
						                                        <td class="noBorder"><%#CType(Container.DataItem, LitCommunication).Description %>&nbsp;</td>
						                                        <td class="noBorder"><%#CType(Container.DataItem, LitCommunication).Staff %>&nbsp;</td>
						                                        <td class="noBorder">&nbsp;</td>
							                                </tr>
							                                <tr>
							                                    <td colspan="1">&nbsp;</td>
							                                    <td colspan="4" align="left" style="color:#909090;"><%#MakeSnippet(CType(Container.DataItem, LitCommunication).Content, 185) %>&nbsp;</td>
							                                </tr>
							                            </a>
						                            </itemtemplate>
					                            </asp:repeater>
							                </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </asp:placeholder>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>