<%@ Page Language="VB" AutoEventWireup="false" CodeFile="UpdateDeliveryMethod.aspx.vb" Inherits="processing_popups_UpdateDeliveryMethod" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Update Delivery Method</title>
    <link href="../../css/default.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/json2.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }

    function CloseConfirmationWindow()
    {
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", -1);
        } else {
            window.returnValue ="-1";
        }
        window.close();
    }
    
    var rdDel1 = null;
    var rdDel2 = null;
    var txtAddress = null;
    var txtAttention = null;
    var txtCity = null;
    var txtZip = null;
    var txtContactName = null;
    var txtContactNumber = null;
    var txtPhoneFee = null;
    var txtEmail = null;
    var txtEmailFee = null;
    var hdnDelMethod = null;
    var hdnPayable = null;
    var hdnPay = null;
    
    
    function LoadControls(){
        rdDel1 = document.getElementById("<%= radMethod1.ClientID %>");
        rdDel2 = document.getElementById("<%=radMethod2.ClientID %>");
        txtAddress = document.getElementById("<%=txtAddress.ClientID %>")
        txtAttention = document.getElementById("<%=txtAttention.ClientID %>")
        txtCity = document.getElementById("<%=txtCity.ClientID %>")
        txtZip = document.getElementById("<%=txtZip.ClientID %>")
        txtContactName = document.getElementById("<%=txtContactName.ClientID %>")
        txtContactNumber = document.getElementById("<%=txtContactNumber.ClientID %>")
        txtPhoneFee = document.getElementById("<%=txtPhoneFee.ClientID %>")
        txtEmail = document.getElementById("<%=txtEmail.ClientID %>")
        txtEmailFee = document.getElementById("<%=txtEmailDelivery.ClientID %>")
        hdnDelMethod = document.getElementById("<%=hdnDelMethod.ClientID %>")
        hdnPayable = document.getElementById("<%=txtPayable.ClientID %>")
        hdnPay = document.getElementById("<%=hdnPay.ClientID %>")
    }
    
    function ChangeStatus(rdText) {
        //dvReason
       LoadControls()
        if (rdText == "Check By Phone") {
            document.getElementById("dvCheck").style.display = "none";
            document.getElementById("dvPhone").style.display = "inline";
            document.getElementById("dvEmail").style.display = "none";
            hdnDelMethod.value = "P"
        }
        else if (rdText == "Check"){
            document.getElementById("dvCheck").style.display = "inline";
            document.getElementById("dvPhone").style.display = "none";
            document.getElementById("dvEmail").style.display = "none";
            hdnDelMethod.value = "C"
        }
        else if(rdText == "Check By Email"){
            document.getElementById("dvCheck").style.display = "none";
            document.getElementById("dvPhone").style.display = "none";
            document.getElementById("dvEmail").style.display = "inline";
            hdnDelMethod.value = "E"
        }
    }
        
    function Record_Save() {
        LoadControls();
        
        RemoveBorder(txtAddress);
        RemoveBorder(txtCity);
        RemoveBorder(txtZip);
        RemoveBorder(txtAttention);
        RemoveBorder(rdDel1);
        RemoveBorder(rdDel2);
        RemoveBorder(txtContactName);
        RemoveBorder(txtContactNumber);
        RemoveBorder(txtEmail);
        RemoveBorder(txtEmailFee);
        RemoveBorder(txtPhoneFee);
        
        if(hdnPayable.value == ""){
            ShowMessage("Please enter Payable To")
            AddBorder(hdnPayable)
            return ;
        }
        else{
            hdnPay.value = hdnPayable.value
        }
        
        if(rdDel1.checked || rdDel2.checked){
            if (hdnDelMethod.value == "C"){
                 if(txtAddress.value == ""){
                    ShowMessage("Please enter delivery Address")
                    AddBorder(txtAddress)
                    return ;
                }
                if(txtCity.value == ""){
                    ShowMessage("Please enter City")
                    AddBorder(txtCity)
                    return ;
                }
                if(txtZip.value == ""){
                    ShowMessage("Please enter Zip Code")
                    AddBorder(txtZip)
                    return ;
                }
                if(txtAttention.value == ""){
                    ShowMessage("Please enter a value in the Address To field")
                    AddBorder(txtAttention)
                    return ;
                }
            }
        
            if (hdnDelMethod.value == "P"){
                if(txtContactName.value == ""){
                    ShowMessage("Please enter Contact Name")
                    AddBorder(txtContactName)
                    return ;
                }
                if(txtContactNumber.value == ""){
                    ShowMessage("Please enter the Contact number")
                    AddBorder(txtContactNumber)
                    return ;
                }
                if(txtPhoneFee.value == ""){
                    ShowMessage("Please enter the the Delivery Fees")
                    AddBorder(txtPhoneFee)
                    return ;
                }
            }
        
            if (hdnDelMethod.value == "E"){
                if(txtEmail.value == ""){
                    ShowMessage("Please enter Email Address")
                    AddBorder(txtEmail)
                    return ;
                }
                
                var strFromEmail = txtEmail.value.replace(',',';').split(";");
                for(i=0;i<strFromEmail.length;i++)
                {
                    if(strFromEmail[i]!="")
                    {
                        if (!RegexValidate(trim(strFromEmail[i]), "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                            ShowMessage("Please enter a valid email address");
                            AddBorder(txtEmail);
                            return false;
                        }
                    }
                }
                if(txtEmailFee.value == ""){
                    ShowMessage("Please enter the Delivery Fee")
                    AddBorder(txtEmailFee)
                    return ;
                }
            }
        }
        
        
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
    }
    
    function AddBorder(obj) {
          obj.style.border = "solid 2px red";
          obj.focus();
      }
      function RemoveBorder(obj) {

          obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
      }
      
      function RegexValidate(Value, Pattern) {
            //check to see if supposed to validate value
            if (Pattern != null && Pattern.length > 0) {
                var re = new RegExp(Pattern);

                return Value.match(re);
            }
            else {
                return false;
            }
    }

    function trim(stringToTrim) {
        return stringToTrim.replace(/^\s+|\s+$/g, "");
    }

      function ShowMessage(Value) {

          var dvError = document.getElementById("<%= dvError.ClientID %>");
          var tdError = document.getElementById("<%= tdError.ClientID %>");

          dvError.style.display = "inline";
          tdError.innerHTML = Value;
      }
      function HideMessage() {
          var dvError = document.getElementById("<%= dvError.ClientID %>");
          var tdError = document.getElementById("<%= tdError.ClientID %>");

          tdError.innerHTML = "";
          dvError.style.display = "none";
      }
    
    function PopulateAddress(){
          var dArray = {matterid: '<%= matterid %>'};
          $.ajax({
            type: "POST",
            url: "UpdateDeliveryMethod.aspx/RetrieveCreditorAddress",
            data: JSON.stringify(dArray),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                  if (response.d.status == "OK"){
                    if ($('#<%=txtPayable.ClientId %>').val() == ""){
                        $('#<%=txtPayable.ClientId %>').val(response.d.data.name);
                    }
                    if ($('#<%=txtAttention.ClientId %>').val() == ""){
                        $('#<%=txtAttention.ClientId %>').val(response.d.data.name);
                    }
                    $('#<%=txtAddress.ClientId %>').val(response.d.data.street);
                    $('#<%=txtCity.ClientId %>').val(response.d.data.city);
                    $('#<%=ddlState.ClientId %>').val(response.d.data.state);
                    $('#<%=txtZip.ClientId %>').val(response.d.data.zipcode);
                  } else {
                    alert(response.d.error);
                  }
            },
            error: function (response) {
                alert(response.d);
            }
        });
          return false;
     }
     
    </script>
    <style type="text/css">
        .style1
        {
            width: 223px;
            font-family:Arial;
            font-size:11px;
        }
        .style3
        {
            width: 183px;
            font-family:Arial;
            font-size:11px;
        }
        .style4
        {
            height: 26px;
            font-family:Arial;
            font-size:11px;
        }
        .style6
        {
            width: 107px;
            font-family:Arial;
            font-size:11px;
        }
        .style7
        {
            width: 165px;
            font-family:Arial;
            font-size:11px;
        }
        .style8
        {
            width: 209px;
            font-family:Arial;
            font-size:11px;
        }
        .style10
        {
            width: 100px;
            height: 24px;
        }
        .style11
        {
            width: 183px;
            font-family: Arial;
            font-size: 11px;
            height: 24px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table width="100%">
            <tr>
                <td colspan="2">
                    <div runat="server" id="dvError" style="display: none; vertical-align: bottom;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" style="width: 20;">
                                    <img id="Img5" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                </td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;" class="style10">
                                    Payable To:
                                </td>
                                <td align="left" class="style11">
                                     <asp:TextBox ID="txtPayable" runat="server" />
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;" class="style10">
                                    Delivery Method:
                                </td>
                                <td align="left" class="style11" style="width: 210px !important;">
                                     <asp:RadioButton ID="radMethod1" Text="" GroupName="radMethod" runat="server" Width="100px"/>
                                     <asp:RadioButton ID="radMethod2" Text="" GroupName="radMethod" runat="server" Width="100px" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div runat="server" id="dvCheck" style="display:none;">
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Attention To:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtAttention" runat="server" />
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Address:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtAddress" runat="server" />
                                </td><td></td>
                                <td class="style3">
                                    <asp:Button ID="btnGetAddress" Text="Get" ToolTip="Get Creditor's Address" runat="server" OnClientClick="return PopulateAddress();" Style="font-size: 12px;"/> 
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    City:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtCity" runat="server" />
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    State:
                                </td>
                                <td align="left" class="style3">
                                    <asp:DropDownList ID="ddlState" runat="server"/>
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Zip:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtZip" runat="server" MaxLength="5" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
             <tr>
                <td colspan="2">
                    <div runat="server" id="dvPhone" style="display:none;">
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Contact Name:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtContactName" runat="server" />
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    ContactNumber:
                                </td>
                                <td align="left" class="style3">
                                    <cc1:InputMask cssclass="entry" ID="txtContactNumber" runat="server" Mask="(nnn) nnn-nnnn"></cc1:InputMask>
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Extension:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtExt" runat="server" MaxLength="5" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Delivery Fee:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtPhoneFee" runat="server" />
                                </td>
                                <td></td><td></td><td></td><td></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>  
            <tr>
                <td colspan="2">
                    <div runat="server" id="dvEmail" style="display:none;">
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Email Address:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtEmail" runat="server" />
                                </td>
                                <td align="left" style="font-weight:bold;font-size:12px;width:100px;">
                                    Delivery Fee:
                                </td>
                                <td align="left" class="style3">
                                    <asp:TextBox ID="txtEmailDelivery" runat="server" />
                                </td>
                                <td></td><td></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>                            

            <tr>
                <td class="style1">
                    <a style="color: black" class="lnk" href="javascript:window.close();">
                        <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                            border="0" align="Middle" />
                        Cancel and Close </a>
                </td>
                <td class="style1" align="right">
                    <a style="color: black" class="lnk" href="#" onclick="Record_Save();return false;" >
                        Save and Process 
                        <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                            border="0" align="Middle" />
                    </a>                    
                </td>
        </tr>
        </table>
    </div>
    <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    <asp:HiddenField ID="hdnDelMethod" runat="server" />
    <asp:HiddenField ID="hdnPay" runat="server" />
    </form>
    
</body>
</html>
