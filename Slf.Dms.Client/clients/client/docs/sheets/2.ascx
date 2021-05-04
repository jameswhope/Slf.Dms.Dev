<%@ Control Language="VB" AutoEventWireup="false" CodeFile="2.ascx.vb" Inherits="clients_client_docs_sheets_2" %>
<%@ Reference Page="~/clients/client/docs/data.aspx"   %>

<script type="text/javascript">

var optTypePersonCheck = null;
var optTypeACHInformation = null;
var optTypeCashiersCheck = null;

var txtDepositRoutingNumber = null;
var txtDepositAccountNumber = null;
var txtDepositBankName = null;
var txtDepositAmount = null;

var txtMonthlyRoutingNumber = null;
var txtMonthlyAccountNumber = null;
var txtMonthlyBankName = null;
var txtMonthlyAmount = null;
var cboMonthlyDay = null;
var lnkCopy = null;

var UploadBoxes = [];
var pnlUploadBoxes = null;

var dvError = null;
var tdError = null;

var cboDataEntryTypeID = null;
var txtParentConducted = null;
var txtConducted = null;

function Record_Save()
{
    LoadControls();

    if (RequiredExist())
    {
        // hide body and show status message
        ShowMessageBody("...Uploading deposit images and entering data...");

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
    RemoveBorder(txtParentConducted);
    RemoveBorder(txtDepositRoutingNumber);
    RemoveBorder(txtDepositAccountNumber);
    RemoveBorder(txtDepositBankName);
    RemoveBorder(txtDepositAmount);
    RemoveBorder(txtMonthlyRoutingNumber);
    RemoveBorder(txtMonthlyAccountNumber);
    RemoveBorder(txtMonthlyBankName);
    RemoveBorder(txtMonthlyAmount);
    RemoveBorder(cboMonthlyDay);

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

//    // --------------------------
//    // THE BELOW SECTION IS COMMENTED OUT BECAUSE IT IS NOT REQUIRED HERE
//    // --------------------------

//    // UploadBoxes
//    for (i = 0; i < UploadBoxes.length; i++)
//    {
//        if (UploadBoxes[i].value.length == 0)
//        {
//            ShowMessage("The Scanned Deposit Image is a required field.");
//            AddBorder(UploadBoxes[i]);
//            return false;
//        }
//    }

    // optTypeACHInformation
    if (optTypeACHInformation.checked)
    {
        // txtDepositRoutingNumber
        if (txtDepositRoutingNumber.value.length == 0)
        {
            ShowMessage("The Deposit Routing Number is a required field.  It is only required because you selected ACH as the deposit type.");
            AddBorder(txtDepositRoutingNumber);
            return false;
        }

        // txtDepositAccountNumber
        if (txtDepositAccountNumber.value.length == 0)
        {
            ShowMessage("The Deposit Account Number is a required field.  It is only required because you selected ACH as the deposit type.");
            AddBorder(txtDepositAccountNumber);
            return false;
        }

        // txtDepositBankName
        if (txtDepositBankName.value.length == 0)
        {
            ShowMessage("The Deposit Bank Name is a required field.  It is only required because you selected ACH as the deposit type.");
            AddBorder(txtDepositBankName);
            return false;
        }

        // txtDepositAmount
        if (txtDepositAmount.value.length == 0)
        {
            ShowMessage("The Deposit Amount is a required field.  It is only required because you selected ACH as the deposit type.");
            AddBorder(txtDepositAmount);
            return false;
        }
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
    if (optTypePersonCheck == null)
    {
        optTypePersonCheck = document.getElementById("<%= optTypePersonCheck.ClientID %>");
        optTypeACHInformation = document.getElementById("<%= optTypeACHInformation.ClientID %>");
        optTypeCashiersCheck = document.getElementById("<%= optTypeCashiersCheck.ClientID %>");

        txtDepositRoutingNumber = document.getElementById("<%= txtDepositRoutingNumber.ClientID %>");
        txtDepositAccountNumber = document.getElementById("<%= txtDepositAccountNumber.ClientID %>");
        txtDepositBankName = document.getElementById("<%= txtDepositBankName.ClientID %>");
        txtDepositAmount = document.getElementById("<%= txtDepositAmount.ClientID %>");

        txtMonthlyRoutingNumber = document.getElementById("<%= txtMonthlyRoutingNumber.ClientID %>");
        txtMonthlyAccountNumber = document.getElementById("<%= txtMonthlyAccountNumber.ClientID %>");
        txtMonthlyBankName = document.getElementById("<%= txtMonthlyBankName.ClientID %>");
        txtMonthlyAmount = document.getElementById("<%= txtMonthlyAmount.ClientID %>");
        cboMonthlyDay = document.getElementById("<%= cboMonthlyDay.ClientID %>");
        lnkCopy = document.getElementById("<%= lnkCopy.ClientID %>");

        pnlUploadBoxes = document.getElementById("<%= pnlUploadBoxes.ClientID %>");

        dvError = document.getElementById("<%= dvError.ClientID %>");
        tdError = document.getElementById("<%= tdError.ClientID %>");

        cboDataEntryTypeID = document.getElementById("<%= CType(Page, clients_client_docs_data).Control_cboDataEntryTypeID.ClientID() %>");
        txtParentConducted = document.getElementById("<%= CType(Page, clients_client_docs_data).Control_txtConducted.ClientID() %>");
        txtConducted = document.getElementById("<%= txtConducted.ClientID %>");
    }
}
function optTypePersonCheck_OnPropertyChange(opt)
{
    LoadControls();

    txtDepositRoutingNumber.disabled = opt.checked;
    txtDepositAccountNumber.disabled = opt.checked;
    txtDepositBankName.disabled = opt.checked;
    txtDepositAmount.disabled = opt.checked;
}
function optTypeCashiersCheck_OnPropertyChange(opt)
{
    LoadControls();

    txtDepositRoutingNumber.disabled = opt.checked;
    txtDepositAccountNumber.disabled = opt.checked;
    txtDepositBankName.disabled = opt.checked;
    txtDepositAmount.disabled = opt.checked;
}
function lnkCopy_OnClick(lnk)
{
    if (!lnk.disabled)
    {
        LoadControls();

        txtMonthlyRoutingNumber.value = txtDepositRoutingNumber.value;
        txtMonthlyAccountNumber.value = txtDepositAccountNumber.value;
        txtMonthlyBankName.value = txtDepositBankName.value;
    }
}
function initUpload()
{
	uploadForm = document.getElementById("<%= Page.Form.ClientID %>");

	addUploadBox();	
}
function UploadBox_Changed(e)
{
    LoadControls();

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

<body onload="initUpload();">
<asp:panel runat="server" id="pnlBodyDefault" style="width:100%; padding: 0 15 0 15;">
<div runat="server" id="dvError" style="display:none;">
    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
        <tr>
            <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
            <td runat="server" id="tdError"></td>
        </tr>
    </table>&nbsp;
</div>
<table style="width:100%;font-family:Tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td>
            <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td colspan="2" style="padding-left:15;">
                        <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width:150;padding-top:2;" valign="top">The scanned deposit images:</td>
                                <td valign="top"><asp:Panel runat="server" ID="pnlUploadBoxes"></asp:Panel>
                                    <asp:Panel runat="server" ID="pnlUploadDocs" Visible="false">
	                                    <asp:repeater id="rpDocs" runat="server">
		                                    <itemtemplate>
		                                        <div style="margin-top:4;"><img style="margin-right:6;" align="absmiddle" border="0" src="<%#DataBinder.Eval(Container.DataItem, "Icon")%>"/><a href="<%= ResolveUrl("~/util/download/getfile.ashx?id=")%><%#DataBinder.Eval(Container.DataItem, "FileID")%>" class="lnk"><%#DataBinder.Eval(Container.DataItem, "Name")%></a>&nbsp;&nbsp;(<%#DataBinder.Eval(Container.DataItem, "SizeFormatted")%>)<br /></div>
		                                    </itemtemplate>
	                                    </asp:repeater>
                                    </asp:Panel>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" style="width:150;padding-top:15;">The deposit was sent as:</td>
                                <td valign="top" style="padding-top:15;">
                                    <input type="radio" name="optType" value="0" id="optTypePersonCheck" runat="server" checked="true"/><label for="<%= optTypePersonCheck.ClientID %>">Personal check</label><br />
                                    <input type="radio" name="optType" value="1" id="optTypeACHInformation" runat="server" /><label for="<%= optTypeACHInformation.ClientID %>">ACH information</label><br />
                                    <input type="radio" name="optType" value="2" id="optTypeCashiersCheck" runat="server" /><label for="<%= optTypeCashiersCheck.ClientID %>">Cashier's check</label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="height:25;">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" style="color:#a1a1a1;border-bottom:solid 1px #d1d1d1;">Payment Processing</td>
                </tr>
                <tr>
                    <td style="padding-left:15;width:150;font-weight:bold;">&nbsp;</td>
                    <td>
                        <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="background-color:#f1f1f1;width:70;padding:4 5 4 4;">Routing No.</td>
                                <td style="background-color:#f1f1f1;width:90;padding:4 5 4 0;">Account No.</td>
                                <td style="background-color:#f1f1f1;width:90;padding:4 5 4 0;">Bank Name</td>
                                <td style="background-color:#f1f1f1;width:5;padding:4 3 4 0;">&nbsp;</td>
                                <td style="background-color:#f1f1f1;width:55;padding:4 5 4 0;" align="right">Amount</td>
                                <td style="background-color:#f1f1f1;width:75;padding:4 5 4 0;">Processing Day</td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left:15;width:150;">Process deposit payment:</td>
                    <td>
                        <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width:70;padding:2 5 2 0;"><asp:TextBox MaxLength="9" Enabled="false" runat="server" ID="txtDepositRoutingNumber" cssclass="entry"></asp:TextBox></td>
                                <td style="width:90;padding:2 5 2 0;"><asp:TextBox MaxLength="50" Enabled="false" runat="server" ID="txtDepositAccountNumber" cssclass="entry"></asp:TextBox></td>
                                <td style="width:90;padding:2 5 2 0;"><asp:TextBox MaxLength="50" Enabled="false" runat="server" ID="txtDepositBankName" cssclass="entry"></asp:TextBox></td>
                                <td style="width:5;padding:2 3 2 0;">$</td>
                                <td style="width:55;padding:2 5 2 0;"><asp:TextBox style="text-align:right;" Enabled="false" runat="server" ID="txtDepositAmount" cssclass="entry"></asp:TextBox></td>
                                <td style="width:75;padding:2 5 2 0;" align="center">Immediately</td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left:15;width:150;">Setup monthly payment:</td>
                    <td>
                        <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width:70;padding:2 5 2 0;"><asp:TextBox MaxLength="9" runat="server" ID="txtMonthlyRoutingNumber" cssclass="entry"></asp:TextBox></td>
                                <td style="width:90;padding:2 5 2 0;"><asp:TextBox MaxLength="50" runat="server" ID="txtMonthlyAccountNumber" cssclass="entry"></asp:TextBox></td>
                                <td style="width:90;padding:2 5 2 0;"><asp:TextBox MaxLength="50" runat="server" ID="txtMonthlyBankName" cssclass="entry"></asp:TextBox></td>
                                <td style="width:5;padding:2 3 2 0;">$</td>
                                <td style="width:55;padding:2 5 2 0;"><asp:TextBox style="text-align:right;" runat="server" ID="txtMonthlyAmount" cssclass="entry"></asp:TextBox></td>
                                <td style="width:75;padding:2 5 2 0;"><asp:dropdownlist style="text-align:right;" runat="server" ID="cboMonthlyDay" cssclass="entry">
                                    <asp:ListItem Value="1">Day 1</asp:ListItem>
                                    <asp:ListItem Value="2">Day 2</asp:ListItem>
                                    <asp:ListItem Value="3">Day 3</asp:ListItem>
                                    <asp:ListItem Value="4">Day 4</asp:ListItem>
                                    <asp:ListItem Value="5">Day 5</asp:ListItem>
                                    <asp:ListItem Value="6">Day 6</asp:ListItem>
                                    <asp:ListItem Value="7">Day 7</asp:ListItem>
                                    <asp:ListItem Value="8">Day 8</asp:ListItem>
                                    <asp:ListItem Value="2">Day 9</asp:ListItem>
                                    <asp:ListItem Value="10">Day 10</asp:ListItem>
                                    <asp:ListItem Value="11">Day 11</asp:ListItem>
                                    <asp:ListItem Value="12">Day 12</asp:ListItem>
                                    <asp:ListItem Value="13">Day 13</asp:ListItem>
                                    <asp:ListItem Value="14">Day 14</asp:ListItem>
                                    <asp:ListItem Value="15">Day 15</asp:ListItem>
                                    <asp:ListItem Value="16">Day 16</asp:ListItem>
                                    <asp:ListItem Value="17">Day 17</asp:ListItem>
                                    <asp:ListItem Value="18">Day 18</asp:ListItem>
                                    <asp:ListItem Value="19">Day 19</asp:ListItem>
                                    <asp:ListItem Value="20">Day 20</asp:ListItem>
                                    <asp:ListItem Value="21">Day 21</asp:ListItem>
                                    <asp:ListItem Value="22">Day 22</asp:ListItem>
                                    <asp:ListItem Value="23">Day 23</asp:ListItem>
                                    <asp:ListItem Value="24">Day 24</asp:ListItem>
                                    <asp:ListItem Value="25">Day 25</asp:ListItem>
                                    <asp:ListItem Value="26">Day 26</asp:ListItem>
                                    <asp:ListItem Value="27">Day 27</asp:ListItem>
                                    <asp:ListItem Value="28">Day 28</asp:ListItem>
                                    <asp:ListItem Value="-1">Last Day</asp:ListItem>
                                </asp:dropdownlist></td>
                                <td style="padding-left:10;"><a runat="server" id="lnkCopy" href="javascript:function S(){return false;}" onclick="lnkCopy_OnClick(this);" class="lnk">Copy</a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</asp:panel>
<asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
    <table style="font-family:tahoma;font-size:11px;width:100%;padding:20 0 10 0;" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td valign="top" align="center"></td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel runat="server" ID="pnlBodyMessageStatus" Style="display:none;">
    <div style="text-align:center;">
        <iframe frameborder="0" style="width:50%;" name="ifrProgress" id="ifrProgress" src="<%= ResolveUrl("~/util/upload/blank.aspx") %>"></iframe>
    </div>
</asp:Panel>

<asp:TextBox runat="server" ID="txtConducted" style="display:none;"></asp:TextBox>

<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->

<asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>

</body>