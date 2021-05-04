<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManagerOverrideInfo.aspx.vb" Inherits="processing_popups_ManagerOverrideInfo" %>
<%@ Register Src="~/processing/webparts/SettlementCalculations.ascx" TagName="SettlementCalculations"
    TagPrefix="webPart" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Settlement Information</title>
    <link href="../../css/default.css" rel="stylesheet" type="text/css" />
    <link href="../css/globalstyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
      var txtNote = null;
      var rdAccept = null;
      var rdReject = null;
    
      if (window.parent.currentModalDialog) {
           window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
      }

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
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", -1);
        } else {
            window.returnValue ="-1";
        }
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
    function OpenDocument(path) {
        window.open(path);
        return false;
    }
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="frmManagerOverrideInfo" runat="server">
        <div style="margin:10px">
        <table class="entry2" border="0" width="650px">
            <tr>               
                <td align="left" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;">
                    <asp:Label ID="lblClientName" runat="server" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"></asp:Label>
                    (<asp:Label ID="lblClientAccount" runat="server" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"></asp:Label>)
                </td>
            </tr>
            <tr>                
                <td align="left" style="color: rgb(120,120,120)">
                    <asp:Label ID="lblClientAddress" runat="server" CssClass="entry2" ></asp:Label>
                </td>
            </tr>
        </table>
        <hr />
        <table id="table_calc" style="width: 600px" cellpadding="0" cellspacing="0"
            border="0">
            <tr>               
                <td>
                    <webPart:SettlementCalculations ID="SettCalcs" runat="server" />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
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
                <td class="entry2" style="background-color:#EBEBEB; padding:5px">
                    <table id="tblDocuments" runat="server" class="box">
                    </table> 
                </td>
            </tr>
            <tr>
                <td class="entry2">
                    <br />
                    Notes:
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtNote" Width="300px" runat="server" TextMode="MultiLine" CssClass="entry2"
                        Height="50px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" class="entry2">
                    <asp:RadioButton ID="radAccept" GroupName="radStatus" Text="Accept" runat="server" />
                    <asp:RadioButton ID="radReject" GroupName="radStatus" Text="Reject" runat="server" />
                </td>
            </tr>   
        </table>        
        <hr />
        <table style="width: 650px" border="0">
            <tr>
                <td>
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
        </div>
        <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    </form>
</body>

</html>