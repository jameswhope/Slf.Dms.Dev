<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addmatterexpense.aspx.vb"
    Inherits="Clients_client_creditors_matters_addmatterexpense" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Add Expense</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%# ResolveUrl("~/jscript/domain.js") %>"></script>    
    <style type="text/css">
        .style2
        {
            width: 10%;
        }
        .box
        {
            border: 1px solid #CCCCCC;
        }
    </style>

    <script type="text/javascript">
    
    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    }

    function windowclose()
    {
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", -1);  
        } else {
            window.returnValue ="-1";
        }
        window.close();  
    }
    function calc()
    {
        if(document.getElementById("txtBillTime").value!="" && document.getElementById("txtBillRate").value!="")
        document.getElementById("txtTotal").value ="$ "+(document.getElementById("txtBillRate").value * document.getElementById("txtBillTime").value)  
    }
    
        function SaveMatterExpenses() {
        
        var txtDesc= document.getElementById("txtDesc");
        var txtBillTime= document.getElementById("txtBillTime");
        var txtBillRate=document.getElementById("txtBillRate");
        var txtNote=document.getElementById("txtNote");
        var txtExpensesDate=document.getElementById("txtExpensesDate");
      var ddlAttorney = document.getElementById("ddlAttorney");
        
         RemoveBorder(txtDesc);
          RemoveBorder(txtBillTime);
           RemoveBorder(txtBillRate); 
           RemoveBorder(txtNote);
            RemoveBorder(txtExpensesDate);
             RemoveBorder(ddlAttorney);
          
           if (txtExpensesDate.value == "") {
            ShowMessage("Expense date is a required field");
            AddBorder(txtExpensesDate);
            return false;
        }
        
        
        if(ddlAttorney.value=="0")
        {
         ShowMessage("Attrorney is a required field");
            AddBorder(ddlAttorney);
            return false;
        }
           
        if(txtDesc.value=="" )
        {
             ShowMessage("Description is a required field");
            AddBorder(txtDesc);
            return false;
        }
         if(txtBillTime.value=="" )
        {
             ShowMessage("Billable time is a required field");
            AddBorder(txtBillTime);
            return false;
        }
          if(txtBillRate.value=="" )
        {
             ShowMessage("Billable rate is a required field");
            AddBorder(txtBillRate);
            return false;
        }
         if(txtNote.value=="" )
        {
             ShowMessage("Memo is a required field");
            AddBorder(txtNote);
            return false;
        }
        
           <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
        
           function AddBorder(obj) {
        obj.style.border = "solid 2px red";
        obj.focus();
    }
    function RemoveBorder(obj) {
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
    }


    function ShowMessage(Value) {
        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage() {
        tdError.innerHTML = "";
        dvError.style.display = "none";
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="5" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top" style="padding-left: 10; height: 100%; width: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                    cellspacing="0">
                    <tr>
                        <td colspan="2" class="cLEnrollHeader">
                            Add Expense
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Label CssClass="entry2" Text="" ForeColor="Red" ID="lblMsg" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                cellspacing="0" class="box">
                                <tr>
                                    <td class="cLEnrollHeader">
                                        Client Information
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                            cellspacing="0" class="box">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" width="15%" align="right">
                                                    Client Name:
                                                </td>
                                                <td width="20%">
                                                    <asp:TextBox ID="lblClient" CssClass="entry2" Width="200px" runat="server" ReadOnly="true"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" nowrap="true" width="10%" align="right">
                                                    Firm:
                                                </td>
                                                <td width="20%">
                                                    <asp:TextBox ID="lblFirm" CssClass="entry2" Width="200px" runat="server" ReadOnly="true"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" nowrap="true" width="10%" align="right">
                                                    ClientID:
                                                </td>
                                                <td width="25%">
                                                    <asp:TextBox ID="lblClientID" CssClass="entry2" Width="100px" runat="server" ReadOnly="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="cLEnrollHeader">
                                        Matter Information
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                            cellspacing="0" class="box">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" width="15%" align="right">
                                                    Matter Date:
                                                </td>
                                                <td width="20%">
                                                    <asp:TextBox ID="txtMatterDate" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" nowrap="true" width="20%" align="right">
                                                    Account Number:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAccountNumber" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" align="right">
                                                    Matter Number:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtMatterNumber" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" align="right">
                                                    Local Counsel:
                                                </td>
                                                <td>
                                                    <asp:DropDownList Width="200px" caption="Local Counsel" TabIndex="6" CssClass="entry"
                                                        Enabled="false" runat="server" ID="ddlLocalCounsel" Visible="false">
                                                    </asp:DropDownList>
                                                    <input type="text" style="width: 200px" readonly="readonly" class="entry" id="txtLocalCounsel"
                                                        runat="server" tabindex="4" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="cLEnrollHeader">
                                        Billing/Expense Details
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100%">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                            cellspacing="0" class="box">
                                            <tr>
                                                <td align="right" width="27%">
                                                    Billing/Expense Date:
                                                </td>
                                                <td width="15%">
                                                    <igsch:WebDateChooser ID="txtExpensesDate" runat="server" Width="150px" Value=""
                                                        EnableAppStyling="True" StyleSetName="Nautilus">
                                                        <calendarlayout changemonthtodateclicked="True">
										                            </calendarlayout>
                                                    </igsch:WebDateChooser>
                                                </td>
                                                <td align="right" width="3%">
                                                    Time:
                                                </td>
                                                <td width="5%">
                                                    <igtxt:WebDateTimeEdit ID="WebDateTimeEdit" runat="server" width="60px" EditModeFormat="HH:mm"
                                                        CssClass="entry2">
                                                        <spinbuttons display="OnRight" />
                                                    </igtxt:WebDateTimeEdit>
                                                </td>
                                                <td width="10%" align="right">
                                                    Attorney:
                                                </td>
                                                <td width="35%" align="left">
                                                    <asp:DropDownList Width="210px" caption="Attorney" CssClass="entry" runat="server"
                                                        ID="ddlAttorney">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" align="right">
                                                    Description:
                                                </td>
                                                <td colspan="5">
                                                    <asp:TextBox ID="txtDesc" runat="server" CssClass="entry2" Width="650px" MaxLength="200"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" align="right">
                                                    Billable Time:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtBillTime" runat="server" CssClass="entry2" Width="100px" MaxLength="6"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" nowrap="true" align="right">
                                                    Billable Rate:(in $)
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtBillRate" runat="server" Width="96px" CssClass="entry2"></asp:TextBox>
                                                </td>
                                                <td class="entrytitlecell" nowrap="true" align="right">
                                                    Total:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtTotal" runat="server" ReadOnly="true" CssClass="entry2"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" align="left" colspan="6">
                                                    Memo:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" align="left" colspan="6">
                                                    <asp:TextBox ID="txtNote" runat="server" CssClass="entry2" TextMode="MultiLine" Height="118px"
                                                        Width="800px"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 40px; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                padding-right: 10px; width: 100%;">
                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 90%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a tabindex="3" style="color: black" class="lnk" href="#" onclick="javascript:windowclose();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="absmiddle" />Cancel and Close</a>
                        </td>
                        <td align="right">
                            <a tabindex="4" runat="server" id="hylinkSave" style="color: black" class="lnk" href="#"
                                onclick="javascript: return SaveMatterExpenses();">Save Expense
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absmiddle" /></a>
                            <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
