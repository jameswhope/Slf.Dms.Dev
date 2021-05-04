<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="credits.aspx.vb" Inherits="clients_client_finances_bytype_credits" Title="DMP - Client - Credits" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript">

        function Record_AddTransaction()
        {
            window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
        }
        function RowHover(td, on)
        {
            var tr = td.parentElement;
            
            //preceding deposits
            while (tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.previousSibling;
            }
            
            //main row
            if (on)
                tr.style.backgroundColor = "#f3f3f3";
            else
                tr.style.backgroundColor = "#ffffff";
            
            //following deposits
            tr = td.parentElement.nextSibling;
            while (tr != null && tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.nextSibling;
            }
        }

    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0" cellspacing="15">
        <tr>
            <td valign="top" style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Finances&nbsp;>&nbsp;Transactions By Type
            </td>
        </tr>
        <tr>
            <td style="height:100%;" valign="top">
                <asi:TabStrip runat="server" id="tsMain"></asi:TabStrip>
                <div id="dvPanel0" runat="server">
                    <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding:5 7 5 7;color:rgb(50,112,163);">Credits</td>
                            <td style="padding-right:7;" align="right"></td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                            <td class="headItem">Date<img align="absmiddle" style="margin-left:5;" runat="server" border="0" src="~/images/sort-asc.png" /></td>
                            <td class="headItem">Explanation</td>
                            <td class="headItem">Amount</td>
                            <td class="headItem">IFU</td>
                            <td class="headItem">Void</td>
                            <td class="headItem">Bounced</td>
                            <td class="headItem">Hold</td>
                            <td class="headItem">Clear</td>
                            <td class="headItem">Import ID</td>
                        </tr>
                        <asp:repeater id="rpPayments" runat="server">
                            <itemtemplate>
                                <a href="register.aspx?id=<%=ClientID %>&rid=<%#DataBinder.Eval(Container.DataItem, "RegisterId")%>">
                                <tr IsMainRow="true">
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center">
                                        <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetDateString(DataBinder.Eval(Container.DataItem, "TransactionDate"))%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#DataBinder.Eval(Container.DataItem, "EntryTypeName")%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"  style="<%#LocalHelper.GetCurrencyColor(DataBinder.Eval(Container.DataItem, "Amount")) %>">
                                        <%#LocalHelper.GetCurrencyString(DataBinder.Eval(Container.DataItem, "Amount"))%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "IsFullyPaid"), Me)%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Void"), Me)%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Bounce"), Me)%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Hold"), me)%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Clear"), me)%>&nbsp;
                                    </td>
                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" >
                                        <%#DataBinder.Eval(Container.DataItem, "ImportID")%>&nbsp;
                                    </td>
                                </tr>
                                </a>
                            </itemtemplate>
                             <FooterTemplate>
                               
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td style="text-align:left">Amount Total: <asp:Label ID="lblPaidTotal" runat="server"/></td>
                                    <td></td>                      
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                
                            </FooterTemplate>
                        </asp:repeater>
                    </table>
                   
                    <asp:panel runat="server" id="pnlNone" style="text-align:center;padding:20 5 5 5;">This client has no credits.</asp:panel>
                </div>
                <div id="dvPanel1" runat="server"></div>
                <div id="dvPanel2" runat="server"></div>
                <div id="dvPanel3" runat="server"></div>
                <div id="dvPanel4" runat="server"></div>
            </td>
        </tr>
    </table>

</asp:Content>