<%@ Page Language="VB" AutoEventWireup="false" CodeFile="findcreditor.aspx.vb" Inherits="util_pop_findcreditor" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Find Creditor</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body onload="SetFocus('<%= txtCreditor.ClientID() %>');Requery();" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

<style>

div.grid {border:solid 1px #d3d3d3;overflow-y:scroll;position:relative;height:100%;}

/* restrict scrolling on row and column headers */
div.grid table td.headItem {position:relative;fix1:expression(Grid_FixHeader(this));}
div.grid table td.headItem3 {position:relative;fix2:expression(Grid_FixHeader(this));}

</style>

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>
<script type="text/javascript">

var txtCreditor = null;
var txtStreet = null;
var txtStreet2 = null;
var txtCity = null;
var cboStateID = null;
var txtZipCode = null;

var txtSelected = null;

var tblCreditors = null;
var aOk = null;

var lastTr = null;

var xml = new ActiveXObject("Microsoft.XMLDOM");

xml.async = true;
xml.onreadystatechange = Display;

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
	xml.load("<%= ResolveUrl("~/util/creditorfinder.ashx?name=") %>" + txtCreditor.value
	    + "&street=" + txtStreet.value + "&street2=" + txtStreet2.value + "&city=" + txtCity.value
	    + "&stateid=" + StateID + "&zipcode=" + txtZipCode.value);

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
                var validCreditor = creditor.attributes.getNamedItem("validated").value;
                
                // insert new row
                var tr = tblCreditors.insertRow(-1)

                if (validCreditor == 'True'){
                    tr.style.backgroundColor = '#D2FFD2'
                }
                
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
         + "|" + stateid + "|" + statename + "|" + stateabbreviation + "|" + zipcode;

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

        txtSelected = document.getElementById("<%= txtSelected.ClientID() %>");

        tblCreditors = document.getElementById("<%= tblCreditors.ClientID() %>");
        aOk = document.getElementById("<%= aOk.ClientId() %>");
    }
}
function TrimString(value)
{
    value = value.replace( /^\s+/g, "");   // strip leading
    return value.replace( /\s+$/g, "");    // strip trailing
}
function Record_UpdateOKCaption()
{
    LoadControls();
    if (txtSelected.value.length == 0 && tblCreditors.rows.length == 3) //one result - unselected
    {
        aOk.innerHTML = "Use This Creditor" + aOk.imgText;
    }
    else if (txtSelected.value.length == 0)
    {
        aOk.innerHTML = "Use Typed Creditor" + aOk.imgText;
    }
    else
    {
        aOk.innerHTML = "Use Selected Creditor" + aOk.imgText;
    }
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
        var stateabbreviation = cboStateID[cboStateID.selectedIndex].innerHTML;
        
        var message = "";
        if (txtCreditor.value == null || TrimString(txtCreditor.value).length == 0)
        {
            message += "Please enter the creditor name.<br>";
        }
        else if (txtCreditor.value == null || TrimString(txtCreditor.value).length == 0 || txtStreet.value == null || TrimString(txtStreet.value).length == 0 || txtCity.value == null || TrimString(txtCity.value).length == 0 || txtZipCode.value == null || TrimString(txtZipCode.value).length == 0 || TrimString(stateabbreviation).length == 0)
        {
            message += "Please enter a complete creditor name and address to use a typed creditor.<br>";
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
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    tdError.innerHTML = "";
    dvError.style.display = "none";
}

</script>

    <form id="form1" runat="server" style="height:100%;">
    <asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:none;"><center>Saving trust...</center></asp:Panel>
    <asp:Panel runat="server" ID="pnlMain" style="width:100%;height:100%;padding-left:15;">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    Type in as much information as you know about the creditor in the boxes below.
                    Then select one of the matches that is returned.  Only the top 25 results are 
                    returned in any search, so continue entering address information to refine the matches.
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <table style="margin-top:10;width:100%;BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" border="0">
					        <tr>
						        <td valign="top" width="16"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absMiddle" border="0"></td>
						        <td runat="server" id="tdError">asdf</td>
					        </tr>
				        </table>
				    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top:15;height:100%;">
                    <div class="grid">
                        <table id="tblCreditors" runat="server" style="table-layout:fixed;width:100%;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="5" border="0">
                            <tr>
                                <td class="headItem">Creditor</td>
                                <td class="headItem" style="width:150;">Street</td>
                                <td class="headItem" style="width:125;">City</td>
                                <td class="headItem" style="width:60;">State</td>
                                <td class="headItem" style="width:55;">Zip Code</td>
                            </tr>
                            <tr>
                                <td valign="top" class="headItem3"><asp:TextBox CssClass="entry" runat="server" ID="txtCreditor"></asp:TextBox></td>
                                <td valign="top" class="headItem3"><asp:TextBox CssClass="entry" runat="server" ID="txtStreet"></asp:TextBox><br /><asp:TextBox CssClass="entry" runat="server" ID="txtStreet2"></asp:TextBox></td>
                                <td valign="top" class="headItem3"><asp:TextBox CssClass="entry" runat="server" ID="txtCity"></asp:TextBox></td>
                                <td valign="top" class="headItem3"><asp:DropDownList CssClass="entry" runat="server" ID="cboStateID"></asp:DropDownList></td>
                                <td valign="top" class="headItem3"><asp:TextBox CssClass="entry" runat="server" ID="txtZipCode"></asp:TextBox></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height:15;">&nbsp;</td>
            </tr>
            <tr>
                <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a TabIndex="6" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                            <td align="right"><a id="aOk" runat="server" TabIndex="7" style="color:black"  class="lnk" href="#" onclick="Record_UseSelected();return false;">Use Selected Creditor<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    
    <asp:HiddenField runat="server" ID="txtSelected" />

</form>
</body>
</html>