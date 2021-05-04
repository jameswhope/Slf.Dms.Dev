<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master"  AutoEventWireup="false" CodeFile="FeeView.aspx.vb" Inherits="admin_settings_rules_Fees_Default" title="Fee distrabution" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="admin_settings_settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

<ajaxToolkit:ToolkitScriptManager runat="server" LoadScriptsBeforeUI="true" />

<style type="text/css">
        .drag{position:relative;cursor:hand}
    </style>

<body runat="server" id="bdMain">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    
    <script type="text/javascript">
   var dragapproved=false
    var z,x,y
    function move(){
    if (event.button==1&&dragapproved){
    z.style.pixelLeft=temp1+event.clientX-x
    z.style.pixelTop=temp2+event.clientY-y
    return false
    }
    }
    function drags(){
    if (!document.all)
    return
    if (event.srcElement.className=="drag"){
    dragapproved=true
    z=event.srcElement
    temp1=z.style.pixelLeft
    temp2=z.style.pixelTop
    x=event.clientX
    y=event.clientY
    document.onmousemove=move
    }
    }
    document.onmousedown=drags
    document.onmouseup=new Function("dragapproved=false")
    //-->
   </script>

<table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/../admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/../admin/settings/rules/fees">Settings> Rules</a>&nbsp;>&nbsp;Fees</td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
              <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            The images below are called settlement entities, agencys and fee catagories. Each commission recipeint
                                            agent and fee catagory are moveable objects representing an entity and a fee. Settlement entities and Agencys
                                            can all be commission recipients or not. You can move and link any settlement entity to another, add a fee, name as
                                            a commission recipient and set the percentage of that fee and order of  payment for each.   
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
       <div>
                <table> 
                    <tr>
                        <td style="font-family:Tahoma; font-size:11px; font-weight: bold; width:300">Select a fee to work with:
                        <asp:DropDownList ID="DropDownList1" Width="100%" runat="server"></asp:DropDownList></td>
                        <td>&nbsp;</td>
                    </tr>
                 </table>   
            </div>  
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Settlement Entities</td>
                    </tr>
                    <tr>
                        <td>
                            <%--<asp:DropDownList ID="ddl" Width="100%" runat="server"></asp:DropDownList>--%>
                            <%--<img src="../../../../images/48x48_users.png" class="drag" title="Seideman" name="Seideman"><br>--%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../../../images/48x48_users.png" class="drag" title="Palmer">Palmer<br>
                        </td>
                    </tr>
                    <tr><td style="height:16;">&nbsp;</td></tr>
                </table>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:100;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Agencys</td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../../../images/48x48_reports.png" class="drag" title="Epic">Epic<br>
                        </td>
                    <tr>
                        <td>
                            <img src="../../../../images/48x48_reports.png" class="drag" title="DebtChoice">DebtChoice<br>
                        </td>
                    </tr>
                    <tr><td style="height:16;">&nbsp;</td></tr>
                </table>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:100;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Fees</td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../../../images/email.jpg" class="drag" title="Retainer">Retainer<br>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../../../images/email.jpg" class="drag" title="Retainer">Maintenance<br>
                        </td>
                    </tr>
                    <tr><td style="height:16;">&nbsp;</td></tr>
                </table>
               <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:50%;" border="0" cellpadding="0" cellspacing="5">
                    <tr>  
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold; width:50%;" nowrap="nowrap">Working surface</td>
                    </tr>
                    <asp:Panel ID="pnlWorking" runat="server" BorderColor="Black" BorderStyle="Ridge" BackColor="AliceBlue">
                        <tr>
                            <td>
                                
                            </td>
                        </tr>
                    </asp:Panel>
              </table>  
            </td>
        </tr>
    </table>
 </body> 
</asp:Content>

