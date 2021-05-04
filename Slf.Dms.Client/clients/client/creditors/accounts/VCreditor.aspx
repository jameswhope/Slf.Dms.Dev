<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="VCreditor.aspx.vb" Inherits="admin_settings_references_VCreditor" Title="Creditor Management" %>
<%@ MasterType TypeName="admin_settings_settings" %>

<%@ Register Assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebCombo" tagprefix="igcmbo" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>


<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebDataInput" tagprefix="igtxt" %>


<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server">

<asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:none;"></asp:Panel>
<asp:Panel runat="server" ID="pnlMain" style="width:100%;height:100%;padding-left:15;">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript" language="javascript">
        
var txtCreditor = null;
var txtCreditor1 = null;
var txtStreet = null;
var txtStreet2 = null;
var txtCity = null;
var cboStateID = null;
var txtZipCode = null;
var txtValidated = null;
var cboMasterList = null;
var cboMasterAddress = null;
var cboAddType = null;

var txtSelected = null;

var aOk = null;
       
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
       
       var lastTr = null;

var xml = new ActiveXObject("Microsoft.XMLDOM");

xml.async = true;
xml.onreadystatechange = Display;

function GetZipCode()
    {
        var input = document.createElement("INPUT");

        // dynamically create an input mask
        input.type = "text"
        input.className = "entry";
		input.mask = "nnnnn-nnnn";
		input.maskDisplay="_";
		input.maskAlpha = "a";
		input.maskNumeric="n";
		input.maskAlphaNumeric="x";
		input.RegexPattern = "";
		input.OnRegexMatch = "";
		input.OnRegexNoMatch = "";
		input.OnWrongKeyPressed = "";
		input.oncut = function () {ASI_InputMask_OnCut(this)};
		input.onblur = function () {ASI_InputMask_LostFocus(this)};
		input.oninput = function () {ASI_InputMask_OnInput(event, this)};
		input.onpaste = function () {ASI_InputMask_OnPaste(this)};
		input.onfocus = function () {ASI_InputMask_GotFocus(this)};
		input.onclick = function () {ASI_InputMask_OnClick(event, this)};
		input.onkeydown = function () {ASI_InputMask_KeyDown(event, this)};
		input.onkeypress = function () {ASI_InputMask_KeyPress(event, this)};

        return input;
    }

function Grid_FixHeader(obj)
{
    var tbl = obj.parentNode.parentNode.parentNode;
    var div = tbl.parentNode;

    obj.style.top = (div.scrollTop) + "px";
    obj.style.zIndex = (10000 - obj.sourceIndex);
}
function Record_CheckReset()
{
    var selc = window.top.dialogArguments[2];

    if (selc.selectedIndex == 0) // still on add new option
    {
        selc.selectedIndex = parseInt(selc.lastIndex);
    }
}
function Record_Propagate(ID, Name)
{
    var wind = window.top.dialogArguments[0];
    var cbos = window.top.dialogArguments[1];
    var selc = window.top.dialogArguments[2];

    var added = false;

    // insert the id/name into the original dropdown; start at index three
    for (i = 3; i < selc.options.length; i++)
    {
        if (selc.options[i].text > Name)
        {
            Insert(wind, cbos, ID, Name, i, true);

            added = true;
            break;
        }
    }

    if (!added) // all list items are greater
    {
        Insert(wind, cbos, ID, Name, i, false);
    }

    // select the recently inserted option
    selc.selectedIndex = i;
    selc.lastIndex = selc.selectedIndex;
}
function Requery()
{
    LoadControls();

    var StateID = 0;

    if (cboStateID.selectedIndex == -1)
    {
        StateID = 0
    }
    else
    {
        StateID = cboStateID.options[cboStateID.selectedIndex].value;
    }

    // send request
	xml.load("<%= ResolveUrl("~/util/creditorfinder.ashx?name=") %>" + txtCreditor.value 	    + "&street=" + txtStreet.value + "&street2=" + txtStreet2.value + "&city=" + txtCity.value + "&stateid=" + StateID + "&zipcode=" + txtZipCode.value);

    txtSelected.value = "";
    HideMessage();
}
function Display()
{
    if (xml.readyState == 4)
    {
        //remove all current rows except for first two
        while (tblCreditors.rows.length > 2)
        {
            tblCreditors.deleteRow(2);
        }

        if (xml.childNodes.length == 2 && xml.childNodes[1].baseName == "creditors")
        {
            var creditors = xml.childNodes[1];

            for (x = 0; x < creditors.childNodes.length; x++)
            {
                var creditor = creditors.childNodes[x];

                var creditorid = creditor.attributes.getNamedItem("creditorid").value;
                var name = creditor.attributes.getNamedItem("name").value;
                var street = creditor.attributes.getNamedItem("street").value;
                var street2 = creditor.attributes.getNamedItem("street2").value;
                var city = creditor.attributes.getNamedItem("city").value;
                var stateid = creditor.attributes.getNamedItem("stateid").value;
                var statename = creditor.attributes.getNamedItem("statename").value;
                var stateabbreviation = creditor.attributes.getNamedItem("stateabbreviation").value;
                var zipcode = creditor.attributes.getNamedItem("zipcode").value;

                // insert new row
                var tr = tblCreditors.insertRow(-1)
                
                tr.setAttribute("creditorid", creditorid);

                var tdName = tr.insertCell(-1);
                var tdStreet = tr.insertCell(-1);
                var tdCity = tr.insertCell(-1);
                var tdState = tr.insertCell(-1);
                var tdZipCode = tr.insertCell(-1);

                tdName.innerHTML = name;

                if (street2.length > 0 && street2 != "&nbsp;")
                {
                    tdStreet.innerHTML = street + "<br \>" + street2;
                }
                else
                {
                    tdStreet.innerHTML = street;
                }

                tdCity.innerHTML = city;
                tdState.innerHTML = stateabbreviation;
                tdZipCode.innerHTML = zipcode;

                tdName.vAlign = "top";
                tdName.className = "listItem5";
                tdName.onclick = SelectTD;

                tdStreet.setAttribute("street", street);
                tdStreet.setAttribute("street2", street2);
                tdStreet.vAlign = "top";
                tdStreet.className = "listItem5";
                tdStreet.onclick = SelectTD;

                tdCity.vAlign = "top";
                tdCity.className = "listItem5";
                tdCity.onclick = SelectTD;

                tdState.setAttribute("stateid", stateid);
                tdState.setAttribute("statename", statename);
                tdState.vAlign = "top";
                tdState.className = "listItem5";
                tdState.onclick = SelectTD;

                tdZipCode.vAlign = "top";
                tdZipCode.className = "listItem5";
                tdZipCode.onclick = SelectTD;
            }
        }
        Record_UpdateOKCaption()
    }
}
function SelectTD(tr)
{
    if(tr == null)
        tr = this.parentNode;
        
    // turn off last selected row
    if (lastTr != null)
    {
        lastTr.style.backgroundColor = "";
    }

    tr.style.backgroundColor = "rgb(197,226,247)";

    var creditorid = tr.getAttribute("creditorid");
    var name = tr.cells[0].innerHTML;
    var street = tr.cells[1].getAttribute("street");
    var street2 = tr.cells[1].getAttribute("street2");
    var city = tr.cells[2].innerHTML;
    var stateid = tr.cells[3].getAttribute("stateid");
    var statename = tr.cells[3].getAttribute("statename");
    var stateabbreviation = tr.cells[3].innerHTML;
    var zipcode = tr.cells[4].innerHTML;

    txtSelected.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city
         + "|" + stateid + "|" + statename + "|" + stateabbreviation + "|" + zipcode + "|" + groupid + "|" + addresstype;

    // set the last selected row to current
    lastTr = tr;
    Record_UpdateOKCaption()
}
function LoadControls()
{
    if (txtCreditor == null)
    {
        txtCreditor = document.getElementById("<%= txtCreditor.ClientID() %>");
        txtStreet = document.getElementById("<%= txtStreet.ClientID() %>");
        txtStreet2 = document.getElementById("<%= txtStreet2.ClientID() %>");
        txtCity = document.getElementById("<%= txtCity.ClientID() %>");
        cboStateID = document.getElementById("<%= cboStateID.ClientID() %>");
        txtZipCode = document.getElementById("<%= txtZipCode.ClientID() %>");
        txtCreditor1 = document.getElementById("<%= txtCreditor1.ClientID() %>");
        
        cboMasterAddress = document.getElementById("<%= txtStreet.ClientID() %>");
        cboAddType = document.getElementById("<%= cboAddType.ClientID %>");

        txtSelected = document.getElementById("<%= txtSelected.ClientID() %>");

        tblCreditors = document.getElementById("<%= tblCreditors.ClientID() %>");
        tblMasterCreditors = document.getElementById("<%= tblMasterCreditors.ClientID() %>");
        
    }
}
function TrimString(value)
{
    value = value.replace( /^\s+/g, "");   // strip leading
    return value.replace( /\s+$/g, "");    // strip trailing
}

function Record_UseSelected()
{
    LoadControls();

    if (txtSelected.value.length == 0 && tblCreditors.rows.length == 3) //one result - unselected
    {
        //select this result
        SelectTD(tblCreditors.rows[2]);
    }
    else if (txtSelected.value.length == 0)
    {
    
        //use the typed data
        var stateabbreviation = cboStateID.childNodes[cboStateID.selectedIndex].innerHTML;
        
        var message = "";
        if (txtCreditor.value == null || TrimString(txtCreditor.value).length == 0)
        {
            message += "Please enter the creditor name.<br>";
        }

        if (message.length > 0)
        {
            ShowMessage(message);
        }
        else
        {
    
            txtSelected.value = "-1|" + txtCreditor.value + "|" + txtStreet.value + "|" + txtStreet2.value + "|" + txtCity.value
                 + "|" + cboStateID.value + "|" + stateabbreviation + "|" + stateabbreviation + "|" + txtZipCode.value;
        }
    }
    
    if (txtSelected.value.length > 0)
    {
        var win = window.top.dialogArguments[0];
        var btn = window.top.dialogArguments[1];
        var fun = window.top.dialogArguments[2];

        var parts = txtSelected.value.split("|");

        var creditorid = parts[0];
        var name = parts[1];
        var street = parts[2];
        var street2 = parts[3];
        var city = parts[4];
        var stateid = parts[5];
        var statename = parts[6];
        var stateabbreviation = parts[7];
        var zipcode = parts[8];

        eval("win." + fun + "(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode)");

        window.close();
    }
    
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}

   function RemoveCreditor()
   {
        <%=Page.ClientScript.GetPostBackEventReference(lnkRemoveCreditor, Nothing) %>;
   }
   function SaveMasterCreditor()
   {
   txtCreditor1 = document.getElementById("<%= txtCreditor.ClientID %>");
    if(txtCreditor1.value != "")
        {
        cboMasterList = document.getElementById("<%= cboMasterList.ClientID %>");
            if(cboMasterList.Value > 0)
                {
                    <%=Page.ClientScript.GetPostBackEventReference(lnkSaveMasterCreditor, Nothing) %>;
                }                
            else
                {
                    var bShow;
                    var url = '<%= ResolveUrl("~/util/pop/ConfirmMasterCreditor.aspx") %>';
                     window.dialogArguments = window;
                     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Creditor",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400,
                               onClose: function(){
                                            bShow = $(this).modaldialog("returnValue");
                                            if (bShow.Status=='OK'){
                                                <%=Page.ClientScript.GetPostBackEventReference(lnkSaveMasterCreditor, Nothing) %>;
                                            }
                                        }
                               });    
                }
         }
 else
        {
            alert("You must choose a creditor first.");
        }
   }

   function SaveAddress()
   {
        cboMasterAddress = document.getElementById("<%= cboMasterAddress.ClientID %>");
        if(cboMasterAddress.Value > 1)
            {
            cboAddType = document.getElementById("<%= cboAddType.ClientID %>");
                if(cboAddType.value > 0)
                {
                    <%=Page.ClientScript.GetPostBackEventReference(lnkSaveAddress, Nothing) %>;
                }
             }
        else
            {
                alert("You must choose an Address and Address Type before saving this creditor.");
            }
   }
   
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    tdError.innerHTML = "";
    dvError.style.display = "none";
}

function RowHover(objRow, bShow)
    {
        if (bShow == true)
        {
            objRow.style.background = "#ffffda";
        }
        else
        {
            objRow.style.background = "";
        }
    }
function FillInfo(creditorid, name, street, street2, city, state, zipcode)
    {
        document.getElementById('<%=txtSelected.ClientID %>').value = creditorid; 
        document.getElementById('<%=txtCreditor.ClientID %>').value = name.replace(/^\s+|\s+$/g,"");
;
        document.getElementById('<%=txtStreet.ClientID %>').value = street;
        document.getElementById('<%=txtStreet2.ClientID %>').value = street2;
        document.getElementById('<%=txtCity.ClientID %>').value = city;
        document.getElementById('<%=cboStateID.ClientID %>').value = state;
        document.getElementById('<%=txtZipCode.ClientID %>').value = zipcode;
        
        document.getElementById('<%=txtCreditor1.ClientID %>').value = name.replace(/^\s+|\s+$/g,"");
        document.getElementById('<%=cboMasterList.ClientID %>').value = creditorid;
        document.getElementById('<%=txtServicedBy.ClientID %>').value = name;
        document.getElementById('<%=cboMasterAddress.ClientID %>').value = cboMasterAddress;
        document.getElementById('<%=txtMStreet2.ClientID %>').value = street2;
        document.getElementById('<%=txtMCity.ClientID %>').value = city;
        document.getElementById('<%=cboMState.ClientID %>').value = state;
        document.getElementById('<%=txtMZip.ClientID %>').value = zipcode;
        
        __doPostBack('__Page','btnPopulate');

    }
   
   window.onload = function()
    {
        document.getElementById('dvScroll').style.height = screen.availHeight -500;
    } 
   
    function ValidateCreditor() 
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkValidateCreditor, Nothing) %>;
    } 
   window.onload = 'pageload'; 
   

</script>
    
       <table>
       <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img3" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img4" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell" style="font-family:Tahoma; font-size:11px;">
                                            Below is a list of recent, un-verified, creditors assigned to clients. This creditor information needs to be validated.
                                            Please verify that the creditor names, below, are spelled properly and that their addresses are correct. 
                                            Just click the creditor you wish to work with. Once you are satisfied the infomation is correct, you can make this Creditor
                                            a new Master Creditor or just add a new address for an existing master creditor. Just use the buttons on the common tasks panel to save your updated creditor information.                 
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
   </table>
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">     
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <table style="margin-top:10;width:100%;BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" border="0">
					        <tr>
						        <td valign="top" width="16"><img id="Img1" runat="server" src="~/images/16x16_exclamationpoint.png" align="absMiddle" border="0"></td>
						        <td runat="server" id="tdError">asdf</td>
					        </tr>
				        </table>
				    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top:5;">
                    <table id="tblMasterCreditors" runat="server" 
                        style="table-layout:auto;width:100%; font-size:11px;font-family:tahoma;" 
                        cellspacing="0" cellpadding="5" border="0" language="javascript">
                        <tr>
                            <td class="headItem" style="width:122px">Master Creditor Name/Servicer</td>
                            <td class="headItem" style="width:150;">Serviced By/Address Type</td>
                            <td class="headItem" style="width:91px;">Street/Street 2</td>
                            <td class="headItem" style="width:125;">City/Phone Number</td>
                            <td class="headItem" style="width:13px;">State/Phone Type</td>
                            <td class="headItem" style="width:60;">Zip Code</td>
                       </tr> 
                       <tr> 
                            <td valign="top" class="headItem3" style="width: 122px">
                                <asp:DropDownList ID="cboMasterList" width="170px" runat="server" 
                                    Font-Names="Tahoma" Font-Size="11px" 
                                    OnSelectedIndexChanged="cboMasterList_Change" Height="16px" ></asp:DropDownList><br />
                                </td>
                            <td valign="top" class="headItem3">
                                <asp:TextBox CssClass="entry" runat="server" 
                                    ID="txtServicedBy" Width="150px"></asp:TextBox><br />
                                </td>
                            <td valign="top" class="headItem3" style="width: 150px">
                                <asp:DropDownList ID="cboMasterAddress" runat="server" autopostback="true" 
                                    CssClass="entry" OnSelectedIndexChanged="cboStreet_Changed"></asp:DropDownList><br />
                                </td>
                            <td valign="top" class="headItem3">
                                <asp:TextBox ID="txtMCity" runat="server" CssClass="entry" Width="150px"></asp:TextBox><br />
                                </td>
                            <td valign="top" class="headItem3" style="width: 50px"><asp:DropDownList CssClass="entry" runat="server" ID="cboMState"></asp:DropDownList>
                            </td>
                            <td class="headItem3" valign="top">
                                <asp:TextBox ID="txtMZip" runat="server" CssClass="entry" Width="78px"></asp:TextBox>
                            </td>
                      </tr>
                        <tr>
                            <td class="headItem3" style="width: 122px" valign="top">
                                <asp:TextBox ID="txtCreditor1" runat="server" width="170px" CssClass="entry"></asp:TextBox>
                            </td>
                            <td class="headItem3" valign="top">
                                <asp:DropDownList ID="cboAddType" runat="server" CssClass="entry">
                                </asp:DropDownList>
                            </td>
                            <td class="headItem3" style="width: 91px" valign="top">
                                <asp:TextBox ID="txtMStreet2" runat="server" width="150px" CssClass="entry"></asp:TextBox>
                            </td>
                            <td class="headItem3" valign="top">
                                <igtxt:WebMaskEdit ID="txtMPhone" runat="server" DataMode="RawText" 
                                    InputMask="(###) ###-####" Height="20px" Width="150px">
                                </igtxt:WebMaskEdit>
                            </td>
                            <td class="headItem3" colspan="2" valign="top">
                                <asp:DropDownList ID="cboPhoneType" runat="server" CssClass="entry" 
                                    Height="16px" Width="160px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                      </table>
                </td>
                <tr>
                    <td style="padding-top:5;height:100%;" valign="top">
                        <table ID="tblCreditors" runat="server" border="0" cellpadding="5" 
                            cellspacing="0" language="javascript" 
                            style="table-layout:fixed;width:100%;font-size:11px;font-family:tahoma;">
                            <tr>
                                <td class="headItem" style="width:200">Creditor</td>
                                <td class="headItem" style="width:200;">Street/Street 2</td>
                                <td class="headItem" style="width:125;">City</td>
                                <td class="headItem" style="width:50;">State</td>
                                <td class="headItem" style="width:60;">Zip Code</td>
                            </tr>
                            <tr>
                                <td class="headItem3" valign="top"></td>
                                <td class="headItem3" valign="top">
                                    <input ID="txtCreditor" runat="server" CssClass="entry" type="hidden"/>
                                    <input ID="txtStreet" runat="server" CssClass="entry" type="hidden" />
                                    <input ID="txtStreet2" runat="server" CssClass="entry" type="hidden" /></td>
                                <td class="headItem3" valign="top">
                                    <input ID="txtCity" runat="server" CssClass="entry" type="hidden"/></td>
                                <td class="headItem3" style="width:45" valign="top">
                                    <input ID="cboStateID" runat="server" CssClass="entry" type="hidden"/></td>
                                <td class="headItem3" valign="top">
                                    <input ID="txtZipCode" runat="server" CssClass="entry" type="hidden" /></td>
                            </tr>
                        </table>
                        <div ID="dvScroll" style="overflow-y:scroll;">
                            <table cellpadding="3" cellspacing="0" class="list" 
                                style="border-right:1px solid #F0F0F0;width:100%;vertical-align:top;">
                                <asp:Repeater ID="repeater1" runat="server">
                                    <ItemTemplate>
                                        <a href="#" 
                                            onclick="javascript:FillInfo('<%#Ctype(Container.DataItem, Creditors).CreditorID %>', '<%#CType(Container.DataItem, Creditors).Name.replace("'"c, " "c)%>', '<%#CType(Container.DataItem, Creditors).Street%>', '<%#CType(Container.DataItem, Creditors).Street2%>', '<%#CType(Container.DataItem, creditors).City%>', '<%#CType(Container.DataItem, creditors).State%>', '<%#CType(Container.DataItem, creditors).ZipCode%>');"
                                        <tr onmouseout="RowHover(this, false)" onmouseover="RowHover(this, true)" style="border-right: 1px solid #F0F0F0;">
                                            <td align="left" nowrap style="width:185;">
                                                <%#CType(Container.DataItem, Creditors).Name.Replace("'"c, " "c)%>&nbsp;
                                            </td>
                                            <td align="left" nowrap style="width:150;">
                                                <%#CType(Container.DataItem, Creditors).Street%>&nbsp;
                                            </td>
                                            <td align="left" nowrap style="width:75;">
                                                <%#CType(Container.DataItem, creditors).Street2%>&nbsp;
                                            </td>
                                            <td align="left" nowrap style="width:125;">
                                                <%#CType(Container.DataItem, creditors).City%>&nbsp;
                                            </td>
                                            <td align="left" nowrap style="width:50;">
                                                <%#CType(Container.DataItem, Creditors).StAbrev%>&nbsp;
                                            </td>
                                            <td align="left" nowrap style="width:80;">
                                                <%#CType(Container.DataItem, creditors).ZipCode%>&nbsp;
                                            </td>
                                            <asp:HiddenField ID="HiddenField1" runat="server" Value="<%#Ctype(container.dataitem, creditors).State%>" />
                                        </tr>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height:15;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                        padding-right: 10px;" valign="top">
                        <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; font-family: tahoma;
                            font-size: 11px; width: 100%;">
                            <tr>
                                <td align="center">
                                    <a class="lnk" href="javascript:window.close();" style="color: black" tabindex="6">
                                        <img id="Img2" runat="server" align="absMiddle" border="0" src="~/images/16x16_back.png"
                                            style="margin-right: 6px;" />Cancel and Close</a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tr>
        </table>
       
    <asp:LinkButton ID="lnkValidateCreditor" runat="server" />
    <asp:LinkButton ID="lnkRemoveCreditor" runat="server" />
    <asp:LinkButton ID="lnkBackToSettings" runat="server" />
    <asp:LinkButton ID="lnkSaveMasterCreditor" runat="server" />
    <asp:LinkButton ID="lnkSaveAddress" runat="server" />
    
</asp:Panel>
<asp:HiddenField runat="server" ID="txtSelected" />
</asp:content>

