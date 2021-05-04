<%@ Control Language="VB" AutoEventWireup="false" CodeFile="4.ascx.vb" Inherits="clients_client_docs_sheets_4" %>
<%@ Reference Page="~/clients/client/docs/data.aspx" %>

<script type="text/javascript">

var txtAccountBalance = null;
var cboCreditor = null;
var txtNewAccountNumber = null;

var UploadBoxes = [];
var pnlUploadBoxes = null;

var dvError = null;
var tdError = null;

var cboDataEntryTypeID = null;
var txtParentConducted = null;
var txtConducted = null;

var rbExisting = null;
var rbNew = null;
var tblExisting = null;
var tblNew = null;

//function init()
//{
//    
//    cboCreditor = document.getElementById("<%= cboCreditor.ClientID %>");
//    if (cboCreditor != null)
//    {
//        cboCreditor.onchange = function () {cboCreditor_OnChange(this);};    
//        cboCreditor.selectedIndex = 2;
//    }
//}
function cboCreditor_OnChange(cbo)
{
    if (cbo.selectedIndex == 0) // they picked the < Add New Item > option
    {
        // load all controls
        LoadControls();

        var cbos = new Array(1);
        cbos[0] = cbo;

        // open the new creditor form (handing the cbo to it)
        showModalDialog("<%= ResolveUrl("~/util/pop/addcreditorholder.aspx") %>", new Array(window, cbos, cbo), "status:off;help:off;dialogWidth:550px;dialogHeight:400px");
    }
    else
    {
        // if not adding, save this selectedIndex
        cbo.lastIndex = cbo.selectedIndex;
    }
}
function switchType(type)
{
    if (tblNew == null)
        LoadControls();
        
    if (type == 'New')
    {
        tblExisting.style.display = "none";
        tblNew.style.display = "block";
    }
    else
    {
        tblExisting.style.display = "block";
        tblNew.style.display = "none";
    }
}
function Record_Save()
{
    LoadControls();

    if (RequiredExist())
    {
        // hide body and show status message
        ShowMessageBody("...Uploading Statement images and entering data...");

        // find and move txtConducted value over
        txtConducted.value = txtParentConducted.value;

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function ShowMessage(Value)
{
    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function HideMessage()
{
    tdError.innerHTML = "";
    dvError.style.display = "none";
}
function RequiredExist()
{
    RemoveBorder(txtAccountBalance);
    RemoveBorder(txtNewAccountNumber);
        
    for (i = 0; i < UploadBoxes.length; i++)
    {
        RemoveBorder(UploadBoxes[i]);
    }

    // txtParentConducted
    if (txtParentConducted.value.length == 0)
    {
        ShowMessage("The Conducted Date is a required field.");
        AddBorder(txtParentConducted);
        return false;
    }
    else
    {
        if (!RegexValidate(txtParentConducted.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
        {
            ShowMessage("The Conducted Date you entered is invalid.  Please enter a new value.");
            AddBorder(txtParentConducted);
            return false;
        }
    }

    // UploadBoxes
    for (i = 0; i < UploadBoxes.length; i++)
    {
        if (UploadBoxes[i].value.length == 0)
        {
            ShowMessage("The Scanned Creditor Statement Image is a required field.");
            AddBorder(UploadBoxes[i]);
            return false;
        }
    }

    // txtAccountBalance
    if (txtAccountBalance.value.length == 0)
    {
        ShowMessage("The Account Balance is a required field.");
        AddBorder(txtAccountBalance);
        return false;
    }
    else
    {
        RemoveBorder(txtAccountBalance);
    }
    
    // txtNewAccountNumber
    if (rbNew.checked == true && txtNewAccountNumber.value.length == 0)
    {
        ShowMessage("The New Account Number is a required field when adding a new account.");
        AddBorder(txtNewAccountNumber);
        return false;
    }
    else
    {
        RemoveBorder(txtNewAccountNumber);
    }
    
    // cboCreditor
    if (rbNew.checked == true && cboCreditor.selectedIndex <= 2)
    {
        ShowMessage("The Creditor is a required field when adding a new account.");
        AddBorder(cboCreditor);
        return false;
    }
    else
    {
        RemoveBorder(cboCreditor);
    }


    HideMessage()
    return true;
}
function AddBorder(obj)
{
    obj.style.border = "solid 2px red";
    obj.focus();
}
function RemoveBorder(obj)
{
    obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
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
function LoadControls()
{
    if (txtAccountBalance == null)
    {
        txtAccountBalance = document.getElementById("<%= txtAccountBalance.ClientID %>");
        cboCreditor = document.getElementById("<%= cboCreditor.ClientID %>");
        txtNewAccountNumber = document.getElementById("<%= txtNewAccountNumber.ClientID %>");
                
        pnlUploadBoxes = document.getElementById("<%= pnlUploadBoxes.ClientID %>");

        dvError = document.getElementById("<%= dvError.ClientID %>");
        tdError = document.getElementById("<%= tdError.ClientID %>");

        cboDataEntryTypeID = document.getElementById("<%= CType(Page, clients_client_docs_data).Control_cboDataEntryTypeID.ClientID() %>");
        txtParentConducted = document.getElementById("<%= CType(Page, clients_client_docs_data).Control_txtConducted.ClientID() %>");
        txtConducted = document.getElementById("<%= txtConducted.ClientID %>");
        
        rbExisting = document.getElementById("<%= rbExisting.ClientID %>");
        rbNew = document.getElementById("<%= rbNew.ClientID %>");
        tblExisting = document.getElementById("<%= tblExisting.ClientID %>");
        tblNew = document.getElementById("<%= tblNew.ClientID %>");
        
        
    }
}
function initUpload()
{
	uploadForm = document.getElementById("<%= Page.Form.ClientID %>");

	addUploadBox();	
}
function UploadBox_Changed(e)
{
//    LoadControls();

	if (this.value.length == 0 && UploadBoxes.length > 1)
	{
		for (var i = 0; i < UploadBoxes.length; i++)
		{
			if (UploadBoxes[i] == this)
			{
				UploadBoxes.splice(i, 1);

				break;
			}
		}

        if (this.nextSibling != null && this.nextSibling.tagName == "BR")
        {
            pnlUploadBoxes.removeChild(this.nextSibling);
        }

		pnlUploadBoxes.removeChild(this);
	}
	else
	{
		if (UploadBoxes[UploadBoxes.length - 1].value.length > 0)
			addUploadBox();
	}
}

function addUploadBox()
{
    LoadControls();

    if (pnlUploadBoxes != null)
    {
	    var newReturn = document.createElement("br");
	    var newBox = document.createElement("input");

	    newBox.type = "file";
	    newBox.style.width = "300";
	    newBox.style.paddingTop = "2";
	    newBox.style.paddingLeft = "2";
	    newBox.style.paddingRight = "2";
	    newBox.style.paddingBottom = "2";
	    newBox.className = "entry2";
	    newBox.name = "fuDeposit" + UploadBoxes.length;

	    newBox.ChangedHandler = UploadBox_Changed;
	    AddHandler(newBox, "propertychange", "ChangedHandler");
	    AddHandler(newBox, "keyup", "ChangedHandler");

        if (UploadBoxes.length > 0 && pnlUploadBoxes.childNodes[pnlUploadBoxes.childNodes.length - 1].tagName != "BR")
        {
	        pnlUploadBoxes.appendChild(newReturn);
        }

	    pnlUploadBoxes.appendChild(newBox);
	    UploadBoxes.push(newBox);
    }
}
function AddHandler(eventSource, eventName, handlerName, eventTarget)
{
	if (eventTarget == null)
		eventTarget = eventSource;
		
	if (eventSource.addEventListener)
	{
		eventSource.addEventListener(eventName, function(e) {eventTarget[handlerName](e);}, false);
	}
	else if (eventSource.attachEvent)
	{ 
		eventSource.attachEvent("on" + eventName, function(e) {eventTarget[handlerName](e);});
	}
	else
	{
		var originalHandler = eventSource["on" + eventName];
		
		if (originalHandler)
		{
			eventSource["on" + eventName] = function(e) {originalHandler(e); eventTarget[handlerName](e);};
		}
		else
		{
			eventSource["on" + eventName] = eventTarget[handlerName];
		}
	}
}
function ShowMessageBody(Value)
{
    var pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
    var pnlBodyMessage = document.getElementById("<%= pnlBodyMessage.ClientID %>");
    var pnlBodyMessageStatus = document.getElementById("<%= pnlBodyMessageStatus.ClientID %>");

    cboDataEntryTypeID.disabled = true;
    txtParentConducted.disabled = true;

    pnlBodyDefault.style.display = "none";
    pnlBodyMessage.style.display = "inline";
    pnlBodyMessageStatus.style.display = "inline";
    pnlBodyMessage.childNodes[0].rows[0].cells[0].innerHTML = Value;
    window.frames["ifrProgress"].location.href = "<%= ResolveUrl("~/util/upload/progress.aspx") %>";
}

</script>

<body onload="javascript:initUpload();">
    <asp:Panel runat="server" ID="pnlBodyDefault" Style="width: 100%; padding: 0 15 0 15;">
        <div runat="server" id="dvError" style="display: none;">
            <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                width="100%" border="0">
                <tr>
                    <td valign="top" style="width: 20;">
                        <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                    <td runat="server" id="tdError">
                    </td>
                </tr>
            </table>
            &nbsp;
        </div>
        <table style="font-family: Tahoma; font-size: 11px;" cellpadding="0" cellspacing="0"
            border="0">
            <tr>
                <td>
                    <table style="font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0"
                        border="0">
                        <tr>
                            <td colspan="2" style="padding-left: 15;">
                                <table style="font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0"
                                    border="0">
                                    <tr>
                                        <td style="width: 150; padding-top: 2;" valign="top">
                                            The scanned creditor statement images:</td>
                                        <td valign="top">
                                            <asp:Panel runat="server" ID="pnlUploadBoxes">
                                            </asp:Panel>
                                            <asp:Panel runat="server" ID="pnlUploadDocs" Visible="false">
                                                <asp:Repeater ID="rpDocs" runat="server">
                                                    <ItemTemplate>
                                                        <div style="margin-top: 4;">
                                                            <img style="margin-right: 6;" align="absmiddle" border="0" src="<%#DataBinder.Eval(Container.DataItem, "Icon")%>" /><a
                                                                href="<%= ResolveUrl("~/util/download/getfile.ashx?id=")%><%#DataBinder.Eval(Container.DataItem, "FileID")%>"
                                                                class="lnk"><%#DataBinder.Eval(Container.DataItem, "Name")%></a>&nbsp;&nbsp;(<%#DataBinder.Eval(Container.DataItem, "SizeFormatted")%>)<br />
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="height: 25;">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 15;">
                                <table id="tblRelAcct" runat="server" style="font-family: tahoma; font-size: 11px" cellpadding="0"
                                    cellspacing="0" border="0">
                                    <tr>
                                        <td valign="top" style="width: 115; padding-top: 15;">
                                            Relevant Account:</td>
                                        <td valign="top" style="padding-top: 15;">
                                            <input type="radio" name="Existing" value="0" id="rbExisting" runat="server" checked="true"
                                                onclick="javascript:switchType('Existing');" /><label for="<%= rbExisting.ClientID %>">Existing
                                                    Account</label><br />
                                            <input type="radio" name="Existing" value="1" id="rbNew" runat="server" onclick="javascript:switchType('New');" /><label
                                                for="<%= rbNew.ClientID %>">New Account</label>
                                        </td>
                                    </tr>
                                </table>
                                <table id="tblNew" runat="server" style="font-family: tahoma; font-size: 11px; display: none"
                                    cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="width: 100px; height: 22px;" nowrap>
                                            Creditor:</td>
                                        <td width="15">
                                        </td>
                                        <td style="height: 22px" width="300">
                                            <asp:DropDownList ID="cboCreditor" runat="server" class="entry" /></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100px; height: 22px;" nowrap>
                                            Account #:</td>
                                        <td width="15">
                                        </td>
                                        <td style="height: 22px">
                                            <input type="text" id="txtNewAccountNumber" runat="server" class="entry" /></td>
                                    </tr>
                                </table>
                                <table style="font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0"
                                    border="0">
                                    <tr id="tblExisting" runat="server">
                                        <td>
                                            Account:</td>
                                        <td width="15">
                                            &nbsp;</td>
                                        <td style="height: 22px">
                                            <asp:DropDownList ID="cboAccounts" runat="server" class="entry">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100">
                                            Account Balance:</td>
                                        <td style="width: 15;" align="center">
                                            $</td>
                                        <td style="width: 300;">
                                            <asp:TextBox Style="text-align: left; width: 100px" class="entry" runat="server"
                                                ID="txtAccountBalance"></asp:TextBox></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
        <table style="font-family: tahoma; font-size: 11px; width: 100%; padding: 20 0 10 0;"
            cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td valign="top" align="center">
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyMessageStatus" Style="display: none;">
        <div style="text-align: center;">
            <iframe frameborder="0" style="width: 50%;" name="ifrProgress" id="ifrProgress" src="<%= ResolveUrl("~/util/upload/blank.aspx") %>">
            </iframe>
        </div>
    </asp:Panel>
    <asp:TextBox runat="server" ID="txtConducted" Style="display: none;"></asp:TextBox>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
</body>
