<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManagerOverrideStatus.aspx.vb" Inherits="processing_popups_ManagerOverrideStatus" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settlement Information</title>
    <style type="text/css">
        .entrycell
        { }
        .entrytitlecell
        {
            width: 85;
        }
        .style1
        {
            width: 370px;
        }
        .entry2
        {
            margin-left: 0px;
        }
        .style2
        {
            width: 199px;
        }
        .style3
        {
            margin-left: 0px;
            width: 199px;
        }
    </style>
       <script type="text/javascript">
      var txtNote = null;
      var rdAccept = null;
      var rdReject = null;

      function LoadControls() {
          txtNote  = document.getElementById("<%=txtNote.ClientID %>");
          rdAccept = document.getElementById("<%=radAccept.ClientID %>")
          rdReject = document.getElementById("<%=radReject.ClientID %>")
      }
      function Record_Save() {
          LoadControls()
          RemoveBorder(txtNote)
          RemoveBorder(rdAccept)
          RemoveBorder(rdReject)


          if (!(rdReject.checked || rdAccept.checked)) {
              ShowMessage("Please select status")
              AddBorder(rdAccept)
              AddBorder(rdReject)
              return false;
          }

          if (rdReject.checked) {
              if (txtNote.value == "") {
                  ShowMessage("Please enter the notes")
                  AddBorder(txtNote);
                  return false;
              }
          }
          
          <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
          

      }
      
    function CloseManagerOverride()
    {
        window.returnValue ="-1"
        window.close();  
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
  
    </script>
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="form1" runat="server">
     <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="5">
     <table id="table_calc" style="font-size: 8pt; width: 75%" cellpadding="0" cellspacing="0"
            border="0">
            <tr>
                <td colspan="3">
                    <div runat="server" id="dvError" style="display: none; vertical-align: bottom;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" style="width: 20;">
                                    <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                </td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="entry2" colspan="3">
                    <asp:TextBox ID="txtNote" Width="585px" runat="server" TextMode="MultiLine" CssClass="entry2"
                        Height="108px"></asp:TextBox>
                </td>
            </tr>
           
            <tr>
                <td class="entry2" colspan="3">
                    <asp:RadioButton ID="radAccept" GroupName="radStatus" Text="Accept" runat="server" />
                    <asp:RadioButton ID="radReject" GroupName="radStatus" Text="Reject" runat="server" />
                </td>
            </tr>
                <tr>
                <td class="entry2" colspan="3">&nbsp;
                 </td>
            </tr>    
        </table>        
    
    <table style="font-size: 8pt; width: 75%;" cellpadding="0" cellspacing="0" 
        border="0">
            <tr>
                <td class="style1">
                    <a tabindex="6" style="color: black" class="lnk" href="javascript:window.close();">
                        <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                            border="0" align="absMiddle" />
                        Cancel and Close </a>
                </td>
                <td align="right">
                    <a tabindex="7" style="color: black" class="lnk" href="#" onclick="Record_Save();return false;">
                        <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                            border="0" align="absMiddle" />
                        Save </a>                    
                </td>
            </tr>
        </table>
       </table>
    <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    </form>
</body>
</html>
