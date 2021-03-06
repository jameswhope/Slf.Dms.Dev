<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PhoneProcessing.aspx.vb"
    Inherits="processing_popups_PhoneProcessing" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Check Processing By Phone</title>
    <link href="../../css/default.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
	<script type="text/javascript" src="<%= ResolveUrl("~/jquery/json2.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
    if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
    function ClosePhWindow(){
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", -1);
        } else {
            var win = window.parent.dialogArguments[0]; 
            var fun = window.parent.dialogArguments[1]; 
            eval('win.' + fun + '()');
        } 
        window.close();
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
    var fee = null;

    function Record_Save() {
        fee = document.getElementById("<%= txtFees.ClientID %>");
        var updatedFee = document.getElementById("<%= hdnFee.ClientID %>");
        var trCity = document.getElementById("<%= trCity.ClientID %>");
        var txtAddress = document.getElementById("<%= txtAddress.ClientID %>");
        var txtAttention = document.getElementById("<%= txtAttention.ClientID %>");
        var txtCity = document.getElementById("<%= txtCity.ClientID %>");
        var txtZip = document.getElementById("<%= txtZip.ClientID %>");
        var hdnDel = document.getElementById("<%= hdnDelMethod.ClientID %>");
        var hdnState = document.getElementById("<%= hdnSelectedState.ClientID %>");
        var ddlState = document.getElementById("<%= ddlState.ClientID %>");
        
        RemoveBorder(txtAddress)
        RemoveBorder(txtCity)
        RemoveBorder(txtZip)
        RemoveBorder(txtAttention)
        
        if(trCity.style.display != "none"){
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
            
            hdnState.value = ddlState.value;
            hdnDel.value = "Check";
        }
        else{
            hdnDel.value = "Check By Phone";
        }
        
        if(!isNaN(parseFloat(fee.value.replace("$","").replace(",","")))){
            updatedFee.value = parseFloat(fee.value.replace("$","").replace(",",""));
        }
        else{
            updatedFee.value = "0"
        }
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
    }
    
    function ChangeDelMethod(){
        var delText = document.getElementById("<%= lblDelMethod.ClientID %>");
        fee = document.getElementById("<%= txtFees.ClientID %>");
        var confirm = document.getElementById("<%= txtConfirm.ClientID %>");
        var cancel = document.getElementById("<%= tdCancel.ClientID %>");
        var changeMethod = document.getElementById("<%= tdEdit.ClientID %>");
        var trAddress = document.getElementById("<%= trAddress.ClientID %>");
        var trCity = document.getElementById("<%= trCity.ClientID %>");
        
        
        delText.innerHTML = "Check";
        fee.readOnly = true;
        confirm.readOnly = true;
        cancel.style.display = "";
        changeMethod.style.display = "none";
        trAddress.style.display = "";
        trCity.style.display = "";
    }
    
    function CancelChange(){
        var delText = document.getElementById("<%= lblDelMethod.ClientID %>");
        fee = document.getElementById("<%= txtFees.ClientID %>");
        var confirm = document.getElementById("<%= txtConfirm.ClientID %>");
        var cancel = document.getElementById("<%= tdCancel.ClientID %>");
        var changeMethod = document.getElementById("<%= tdEdit.ClientID %>");
        var trAddress = document.getElementById("<%= trAddress.ClientID %>");
        var trCity = document.getElementById("<%= trCity.ClientID %>");
        
        delText.innerHTML = "Check By Phone";
        fee.readOnly = false;
        confirm.readOnly = false;
        cancel.style.display = "none";
        changeMethod.style.display = "";
        trAddress.style.display = "none";
        trCity.style.display = "none";
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
      
      function EditPhone(){
          var txtphone = document.getElementById('<%= txtPhone.ClientId%>');
          var txtphoneExt = document.getElementById('<%= txtPhoneExt.ClientId%>');
          txtphone.setAttribute("oldValue", txtphone.value);
          txtphoneExt.setAttribute("oldValue", txtphoneExt.value);
          document.getElementById("dvPhoneNumberEdit").style.display='inline';
          document.getElementById("dvPhoneNumber").style.display='none';
          return false;
      }
      
      function CancelEditPhone(){
          var txtphone = document.getElementById('<%= txtPhone.ClientId%>');
          var txtphoneExt = document.getElementById('<%= txtPhoneExt.ClientId%>');
          txtphone.value = txtphone.getAttribute("oldValue");
          txtphoneExt.value = txtphoneExt.getAttribute("oldValue");
          document.getElementById("dvPhoneNumberEdit").style.display='none';
          document.getElementById("dvPhoneNumber").style.display='inline'; 
          return false;
      }
      
      function RegexValidate(Value, Pattern)
     {
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0)
        {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else
        {
            return false;
        }
     }
     
     function trimStr(str){
        return str.replace(/^\s+|\s+$/g, ''); 
     }
     
     function IsPhoneValid(txtPhoneNumber){
        var phonenumber = trimStr(txtPhoneNumber.value);
        if (phonenumber.length == 0)
        {
            alert("The Phone Number is a required field.");
            return false;
        }
        else
        {
            if (!(RegexValidate(phonenumber, "^(1?)(-| ?)(\\()?([0-9]{3})(\\)|-| |\\)-|\\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$")))
            {
	            alert("The Phone Number is invalid.  Please enter a new value.");
                return false;
            }
        }
        return true;
     }
     
     
     function IsPhoneExtValid(txtPhoneExt){
        var phonenumber = trimStr(txtPhoneExt.value);
        if (phonenumber.length != 0){
            if (!(RegexValidate(phonenumber, "^\\d{0,5}$")))
            {
	            alert("The Extension Number is invalid.  Please enter a new value.");
                return false;
            }
        }
        return true;
     }
     
     
     function FormatPhone(phonenumber){
     var f = '';
     var f1 = phonenumber.slice(-10);
     f = phonenumber.substring(0, phonenumber.length - f1.length) + '('+ f1.substring(0,3) + ') ' + f1.substring(3,6) + '-' + f1.substring(6);
     return f;    
     }
      
     function SaveEditPhone(){
          var txtphone = document.getElementById('<%= txtPhone.ClientId%>');
          var txtphoneExt = document.getElementById('<%= txtPhoneExt.ClientId%>');
          if (IsPhoneValid(txtphone) && IsPhoneExtValid(txtphoneExt))
          {
              var phonenumber = txtphone.value.replace(/\D+/g,'');
              var ext = trimStr(txtphoneExt.value);
              ext = ((ext.length>0)?'x'+ext:'');
              var dArray = {settlementid: '<%= SettlementId %>', phonenumber: phonenumber+ext, userid: '<%= userid %>'};
              $.ajax({
                type: "POST",
                url: "PhoneProcessing.aspx/SavePhoneNumber",
                data: JSON.stringify(dArray),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                      document.getElementById('lblPhone').innerHTML = FormatPhone(phonenumber) + ext;
                      document.getElementById("dvPhoneNumberEdit").style.display='none';
                      document.getElementById("dvPhoneNumber").style.display='inline'; 
                },
                error: function (response) {
                    alert(response.d);
                }
            });
              
              
          }
          return false;
     }
    
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div id="divProcessing" style="padding:15px">
                <table width="600px" class="entry2">
                    <tr id="trInfoBox" runat="server">
                        <td colspan="2">
                            <div class="iboxDiv" style="background-color: rgb(213,236,188);">
                                <table class="iboxTable" style="background-color: rgb(213,236,188);" border="0" cellpadding="7"
                                    cellspacing="0">
                                    <tr>
                                        <td valign="top" class="style9">
                                            <img id="Img4" runat="server" border="0" src="~/images/16x16_note3.png" />
                                        </td>
                                        <td valign="top">
                                            <asp:Label runat="server" ID="lblInfoBox"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
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
                            <table style="border-style: solid; border-width: thin; border-color: Black; width: 600px">
                                <tr>
                                    <td style="font-weight: bold; white-space: nowrap; width: 100px">
                                        Delivery Method:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblDelMethod" Text="Check By Phone" runat="server" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td align="right" id="tdCancel" runat="server" style="display: none;">
                                        <a id="lnkCancelEdit" class="lnk" href="javascript:CancelChange();">Cancel</a>
                                    </td>
                                    <td id="tdEdit" runat="server" align="right" style="display: none;">
                                        <a id="lnkEdit" class="lnk" href="javascript:ChangeDelMethod();">Change Method To Check</a>
                                    </td>
                                </tr>
                                <tr id="trAddress" runat="server" style="display: none;">
                                    <td style="font-weight: bold;">
                                        Attention To:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAttention" runat="server" CssClass="entry2" />
                                    </td>
                                    <td style="font-weight: bold;">
                                        Address:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAddress" runat="server" CssClass="entry2" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr id="trCity" runat="server" style="display: none;">
                                    <td style="font-weight: bold;">
                                        City:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCity" runat="server" CssClass="entry2" />
                                    </td>
                                    <td style="font-weight: bold;">
                                        State:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlState" runat="server" CssClass="entry2" />
                                    </td>
                                    <td style="font-weight: bold;">
                                        Zip:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtZip" runat="server" CssClass="entry2" Width="60px" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="border-style: solid; border-width: thin; border-color: Black; width: 100%">
                                <tr>
                                    <td align="center" style="font-weight: bold; font-size: 12px">
                                        Bank Details
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBankDispaly" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBankStreet" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBankAddress" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table style="border-style: solid; border-width: thin; border-color: Black; width: 100%">
                                <tr>
                                    <td align="center" style="font-weight: bold; font-size: 12px">
                                        Firm Account Details
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblAccountName" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblAccountStreet" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblAccountAddress" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="border-style: solid; border-width: thin; border-color: Black; width: 600px">
                                <tr>
                                    <td style="font-weight: bold;">
                                        Client:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblClient" runat="server" /><br />
                                        <asp:Label ID="lblCoApp" runat="server" />
                                    </td>
                                    <td style="font-weight: bold;">
                                        Amount:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblAmount" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Pay To:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCreditor" runat="server" />
                                    </td>
                                    <td style="font-weight: bold;">
                                        Creditor Account:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCreditorAccount" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Contact Info:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblName" runat="server" />
                                        &nbsp;&nbsp;
                                        <div id="dvPhoneNumber" style="display:inline;">
                                            <asp:Image ID="Img1" ImageUrl="~/images/16x16_phone2.png" runat="server" Style="vertical-align: middle;" />
                                            <asp:Label ID="lblPhone" runat="server" />
                                            <a id="lnkEditContactNumber" href="javascript:void();" onclick="return EditPhone();" runat="server">Edit</a>
                                         </div>
                                        <div id="dvPhoneNumberEdit" style="display:none;">
                                            <asp:TextBox ID="txtPhone" runat="server" Width="60px" CssClass="entry2"></asp:TextBox>
                                            <asp:TextBox ID="txtPhoneExt" runat="server" Width="20px" CssClass="entry2"></asp:TextBox>
                                            <a href="javascript:void();" onclick="return SaveEditPhone();">Save</a>
                                            <a href="javascript:void();" onclick="return CancelEditPhone();">Cancel</a>
                                        </div>
                                    </td>
                                    <td style="font-weight: bold;">
                                        Reference #:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblRefNo" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Check #:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCheck" runat="server" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Routing #:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblRouting" runat="server" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Bank Account #:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblBankAccount" runat="server" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="border-style: solid; border-width: thin; border-color: Black; width: 600px;">
                                <tr>
                                    <td>
                                        Check By Phone Fees:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFees" runat="server" CssClass="entry2" />
                                    </td>
                                    <td>
                                        Confirmation Number:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtConfirm" runat="server" CssClass="entry2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" CssClass="entry2" Height="50px"
                                            Width="530px"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a class="lnk" href="javascript:window.close();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="Middle" />
                                Cancel and Close </a>
                        </td>
                        <td align="right">
                            <a id="aSave" runat="server" class="lnk" href="javascript:Record_Save();">Save
                                and Process
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="Middle" />
                            </a>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divLoading" style="display: none; height: 48px; width: 48px; border: solid 1px #999999;
                background-color: #ffffff; padding: 20px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
            </div>
            <asp:LinkButton ID="lnkSave" runat="server" Text=""></asp:LinkButton>
            <asp:HiddenField ID="hdnFee" runat="server" />
            <asp:HiddenField ID="hdnDelMethod" runat="server" />
            <asp:HiddenField ID="hdnSelectedState" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        function onUpdating() {
            var aSave = $get('aSave');
            aSave.setAttribute('href', '#');
        
            var divLoading = $get('divLoading');
            divLoading.style.display = '';

            var div = $get('divProcessing');

            var bounds = Sys.UI.DomElement.getBounds(div);
            var loadingBounds = Sys.UI.DomElement.getBounds(divLoading);

            var x = bounds.x + Math.round(bounds.width / 2) - Math.round(loadingBounds.width / 2);
            var y = bounds.y + Math.round(bounds.height / 2) - Math.round(loadingBounds.height / 2);

            Sys.UI.DomElement.setLocation(divLoading, x, y);
        }

        function onUpdated() {
            var aSave = $get('aSave');
            aSave.setAttribute('href', 'javascript:Record_Save();');
            
            var divLoading = $get('divLoading');
            divLoading.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1">
        <Animations>
            <OnUpdating>
                <Parallel duration="0">
                    <ScriptAction Script="onUpdating();" />                                                                           
                    <EnableAction AnimationTarget="divProcessing" Enabled="false" />
                    <FadeOut minimumOpacity=".5" />
                 </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration="0">
                    <FadeIn minimumOpacity=".5" />
                    <EnableAction AnimationTarget="divProcessing" Enabled="true" />
                    <ScriptAction Script="onUpdated();" /> 
                </Parallel> 
            </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
    </form>
</body>
</html>
