<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="modifyreasons.aspx.vb" Inherits="admin_settings_references_modifyreasons" title="DMP - Admin Settings - References - Modify Reasons" %>
<%@ MasterType TypeName="admin_settings_settings" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <script type="text/javascript" language="javascript">
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == 'IMG')
                obj = obj.parentElement;
                
            if (obj.tagName == 'TD')
            {
                //remove hover from last tr
                if (tbl.getAttribute('lastTr') != null)
                {
                    var lastTr = tbl.getAttribute('lastTr');
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = '#ffffff';
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = '#f4f4f4';
                    tbl.setAttribute('lastTr', curTr);
                }
            }
        }
        
        function RowClick(parent)
        {
            window.location.href = 'modifyreasons.aspx?parent=' + parent;
        }
        
        function ShowAddReason()
        {
            document.getElementById('tblAddReason').style.display = 'block';
        }
        
        function RemoveReason()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRemoveReason, Nothing) %>;
        }
        
        function AddReason()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkAddReason, Nothing) %>;
        }
    </script>
    
    <table style="width:100%;height:100%;vertical-align:top;font-family:Tahoma;font-size:11px;">
        <tr>
            <td>
                <asp:Label ID="lblTree" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <table id="tblAddReason" style="width:100%;vertical-align:top;font-family:Tahoma;font-size:11px;display:none;">
                    <tr>
                        <td>
                            Display Order:
                        </td>
                        <td>
                            Description:
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtOrder" runat="server" />
                        </td>
                        <td>
                            <asp:TextBox ID="txtDesc" runat="server" />
                        </td>
                        <td>
                            <a href="javascript:AddReason()">Add</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table class="list" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="3" style="border-right:1px solid #F0F0F0;width:100%;vertical-align:top;">
                    <thead>
                        <tr>
                            <th nowrap align="left">Display Order</th>
                            <th nowrap align="left">Description&nbsp;&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:repeater id="rptReasons" runat="server">
                            <itemtemplate>
                                <a href="#" onclick="RowClick(<%#CType(Container.DataItem, ReasonDesc).id %>);"><tr>
                                    <td nowrap align="left">
                                        <%#CType(Container.DataItem, ReasonDesc).order %>
                                    </td>
                                    <td nowrap align="left">
                                        <%#CType(Container.DataItem, ReasonDesc).desc %>
                                    </td>
                                </tr></a>
                            </itemtemplate>
                        </asp:repeater>
                    </tbody>
                </table>
            </td>
        </tr>
        <tr style="height:100%;">
            <td>
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkAddReason" runat="server" />
    <asp:LinkButton ID="lnkRemoveReason" runat="server" />
</asp:Content>