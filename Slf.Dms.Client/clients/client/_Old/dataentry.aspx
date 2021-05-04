<%@ Page Language="VB" EnableEventValidation="false" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="dataentry.aspx.vb" Inherits="clients_client_dataentry" title="DMP - Client - Data Entry" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">

    <asp:Panel runat="server" ID="pnlMenuResolve">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_Resolve();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Resolve</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_SaveForLater();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save For Later</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="/*Record_ViewFeeStructure();*/return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_trust.png" />View Fee Structure</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true" id="tdSendBackToAgency" runat="server">
                    <a runat="server" class="menuButton" href="#" onclick="SendBackToAgency();">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_personerror.png" />Send Back to Agency</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuView" visible="false">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_Return();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Return</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_ViewFeeStructure();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_trust.png" />View Fee Structure</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/clients/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_find.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
            </tr>
        </table>
    </asp:Panel>

</asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<style>

.stanTbl {font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed;}
.stanTblNoH {font-family:tahoma;font-size:11px;width:100%;table-layout:fixed;}

div.grid {border:solid 1px rgb(172,168,153);overflow:auto;position:relative;} /* border:solid 2px #dedede;scrollbar-face-color:#cccccc; scrollbar-highlight-color: #eeeeee; scrollbar-shadow-color: buttonface; scrollbar-3dlight-color: #aaaaaa; scrollbar-arrow-color: #ffffff; scrollbar-track-color: #eeeeee; scrollbar-darkshadow-color: #aaaaaa; */
div.grid table {font-family:tahoma;font-size:11px;table-layout:fixed;}
div.grid table th {cursor:default;}

div.grid table thead th {text-align:left;background-color:rgb(235,234,219);white-space:nowrap;border-bottom:solid 1px rgb(203,199,184);font-weight:normal;}
div.grid table thead th div.header {border-bottom:solid 1px rgb(214,210,194);}
div.grid table thead th div.header div {padding:3 4 2 4;border-bottom:solid 1px red} /* rgb(226,222,205); */

div.grid table tbody td {padding:0 4 0 4;white-space:nowrap;border-bottom:solid 1px rgb(241,239,226);border-right:solid 1px rgb(241,239,226);}
div.grid table tbody th {border-bottom:solid 1px rgb(226,222,206);background:rgb(235,234,219);white-space:nowrap;border-bottom:solid 1px rgb(214,210,194);border-top:solid 1px rgb(250,249,244);border-right:solid 1px rgb(214,210,194);font-weight:normal;}
div.grid table tbody th div {padding:2 4 2 4;border-bottom:solid 1px rgb(226,222,205);}

/* rows selected */
div.grid table tbody tr.sel {background-color:rgb(182,202,234);}
div.grid table tbody th.sel {background-color:rgb(222,223,216);}

/* restrict scrolling on row and column headers */
div.grid table thead th {position:relative;fix1:expression(Grid_FixHeader(this));}
div.grid table th.first {position:relative;fix2:expression(Grid_FixColumn(this));}
div.grid table tbody th {position:relative;fix3:expression(Grid_FixColumn(this));}

div.grid table tbody tr.hover {background:#FFCCFF;}
div.grid table tbody tr:hover {background-color:#f1f1f1;}
div.grid table col.hover {background:#FFCCFF;}

input.grdTXT {font-family:tahoma;font-size:11px;position:absolute;}
input.uns {display:none;}
input.sel {}

select.grdDDL {font-family:tahoma;font-size:11px;position:absolute;}
select.uns {display:none;}
select.sel {}

col.c0 {width:28;}
col.c1 {width:125;}
col.c2 {width:25;}
col.c3 {width:125;}
col.c4 {width:25;}
col.c5 {width:75;}
col.c6 {width:125;}
col.c7 {width:125;}
col.c8 {width:0;}
col.c9 {width:0;}
col.c10 {width:0;}
col.c11 {width:0;}
col.c12 {width:0;}
col.c13 {width:100;}
col.c14 {width:100;}

</style>

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/inputgrid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
<script type="text/javascript">

var chkReceivedLSA = null;
var chkReceivedDeposit = null;

var txtFirstName = null;
var txtLastName = null;
var txtStreet1 = null;
var txtStreet2 = null;
var txtCity = null;
var cboStateID = null;
var txtZipCode = null;
var imDateOfBirth = null;
var imSSN = null;
var imHomePhone = null;
var imHomeFax = null;
var imBusinessPhone = null;
var imBusinessFax = null;
var imAlternatePhone = null;
var imCellPhone = null;
var txtEmailAddress = null;

var txtFirstName2 = null;
var txtLastName2 = null;
var txtStreet12 = null;
var txtStreet22 = null;
var txtCity2 = null;
var cboStateID2 = null;
var txtZipCode2 = null;
var imDateOfBirth2 = null;
var imSSN2 = null;
var imHomePhone2 = null;
var imHomeFax2 = null;
var imBusinessPhone2 = null;
var imBusinessFax2 = null;
var imAlternatePhone2 = null;
var imCellPhone2 = null;
var txtEmailAddress2 = null;

var cboDepositMethod = null;
var txtDepositAmount = null;
var cboDepositDay = null;
var txtRoutingNumber = null;
var txtAccountNumber = null;
var cboBankType = null;
var txtBankName = null;
var txtBankCity = null;
var cboBankStateID = null;
var imDepositStartDate = null;

var grdAccounts = null;
var grdAccountsUpdates = null;
var grdAccountsInserts = null;
var grdAccountsDeletes = null;
var grdAccountsSelected = null;

var chkCollectInsert = null;
var chkCollectUpdate = null;

var pnlBodyDefault = null;
var pnlBodyMessage = null;

var dvErrorReceived = null;
var dvErrorPrimary = null;
var dvErrorSecondary = null;
var dvErrorSetup = null;
var dvErrorAccounts = null;

var Inputs = new Array();

function Record_Return()
{
    // postback to return
    <%= Page.ClientScript.GetPostBackEventReference(lnkReturn, Nothing) %>;
}
function ShowMessageBody(Value)
{
    pnlBodyDefault.style.display = "none";
    pnlBodyMessage.style.display = "inline";
    pnlBodyMessage.childNodes[0].rows[0].cells[0].innerHTML = Value;
}
function HideMessageBody()
{
    pnlBodyDefault.style.display = "";
    pnlBodyMessage.style.display = "none";
}
function Record_Resolve()
{
    LoadControls();

    if (RequiredExist(true) && Grid_Validate(grdAccounts) && RequiredSpouseExist() && RequiredACHExist())
    {
        ShowMessageBody("Resolving data entry worksheet...");

        // get total setup fee
        var InsertValues = Grid_GetAccountInserts();
        var UpdateValues = Grid_GetAccountUpdates();

        if (InsertValues.length > 0 || UpdateValues.length > 0)
        {
            // open the "collect setup fee" pop-up
            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Collect Retainer Fee?&p=collectsetupfee.aspx") %>" + "&id=<%= ClientID %>&i=" + encodeURIComponent(InsertValues) + "&u=" + encodeURIComponent(UpdateValues), window, "status:off;help:off;dialogWidth:350px;dialogHeight:250px");
        }
        else
        {
            // postback to save
            <%= Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
        }
    }
}
function Grid_GetAccountInserts()
{
    if (grdAccountsInserts.value.length > 0)
    {
        var Return = new Array();
        var Values = grdAccountsInserts.value.split("<-$$->");

        for (v = 0; v < Values.length; v++)
        {
            var Parts = Values[v].split(":");

            var KeyID = Parts[0];
            var Field = Parts[1];
            var Type = Parts[2];
            var Value = Values[v].substring(KeyID.length + Field.length + Type.length + 3);

            if (Field.toLowerCase() == "amount" || Field.toLowerCase() == "creditorname")
            {
                Return[Return.length] = KeyID + ":" + Field + ":" + Value;
            }
        }

        return Return.join("<-$$->");
    }
    else
    {
        return "";
    }
}
function Grid_GetAccountUpdates()
{
    if (grdAccountsUpdates.value.length > 0)
    {
        var Return = new Array();
        var Values = grdAccountsUpdates.value.split("<-$$->");

        for (v = 0; v < Values.length; v++)
        {
            var Parts = Values[v].split(":");

            var KeyID = Parts[0];
            var Field = Parts[1];
            var Type = Parts[2];
            var Value = Values[v].substring(KeyID.length + Field.length + Type.length + 3);

            if (Field.toLowerCase() == "amount" || Field.toLowerCase() == "creditorname")
            {
                Return[Return.length] = KeyID + ":" + Field + ":" + Value;
            }
        }

        return Return.join("<-$$->");
    }
    else
    {
        return "";
    }
}
function Record_ResolveCancel()
{
    // return to normal view
    HideMessageBody();
}
function Record_ResolveWithCollect()
{
    chkCollectInsert.checked = true;
    chkCollectUpdate.checked = true;

    // postback to save
    <%= Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
}
function Record_ResolveWithCollectInsert()
{
    chkCollectInsert.checked = true;
    chkCollectUpdate.checked = false;

    // postback to save
    <%= Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
}
function Record_ResolveWithCollectUpdate()
{
    chkCollectInsert.checked = false;
    chkCollectUpdate.checked = true;

    // postback to save
    <%= Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
}
function Record_ResolveWithoutCollect()
{
    chkCollectInsert.checked = false;
    chkCollectUpdate.checked = false;

    // postback to save
    <%= Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
}
function Record_SaveForLater()
{
    LoadControls();

    if (RequiredExist(false) && Grid_Validate(grdAccounts) && RequiredSpouseExist() && RequiredACHExist())
    {
        ShowMessageBody("Saving data entry verification worksheet...");

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSaveForLater, Nothing) %>;
    }
}
function RequiredACHExist()
{
    var Message = "";
    var Control = null;

    // if the deposit method is set to ACH then all bank info is required
    if (cboDepositMethod.selectedIndex != -1 
        && cboDepositMethod.options[cboDepositMethod.selectedIndex].value.toLowerCase() == "ach")
    {
        if (txtDepositAmount.value.length == 0)
        {
            Message = "The Deposit Amount field is required.";
            Control = txtDepositAmount;
        }
        else if (!IsValidNumberFloat(txtDepositAmount.value, true, txtDepositAmount))
        {
            Message = "The Deposit Amount field is invalid.  The value must be greater than zero.";
            Control = txtDepositAmount;
        }
        else if (cboDepositDay.selectedIndex == -1 || cboDepositDay.options[cboDepositDay.selectedIndex].value <= 0)
        {
            Message = "The Deposit Day field is required.";
            Control = cboDepositDay;
        }
        else if (txtRoutingNumber.value.length == 0)
        {
            Message = "The Routing Number field is required.";
            Control = txtRoutingNumber;
        }
        else if (txtAccountNumber.value.length == 0)
        {
            Message = "The Account Number field is required.";
            Control = txtAccountNumber;
        }
        else if (txtBankName.value.length == 0)
        {
            Message = "The Bank Name field is required.";
            Control = txtBankName;
        }
        else if (cboBankStateID.selectedIndex == -1 || cboBankStateID.options[cboBankStateID.selectedIndex].value <= 0)
        {
            Message = "The Bank State field is required.";
            Control = cboBankStateID;
        }
    }

    if (Message.length > 0)
    {
        ShowMessage(Control, Message + " The bank and deposit information is not required; but if you select "
            + "ACH as the deposit method, you must also enter the other required fields.  <a "
            + "class=\"lnk\" href=\"javascript:ClearACH();\">Click here</a> to clear all ACH data.");

        AddBorder(Control);
        return false;
    }
    else
    {
        return true;
    }
}
function RequiredSpouseExist()
{
    var Message = "";
    var Control = null;

    // if any spouse field has info, they all must be validated
    if (txtFirstName2.value.length > 0 || txtLastName2.value.length > 0 || txtStreet12.value.length
        || txtStreet22.value.length > 0 || txtCity2.value.length > 0 || !(cboStateID2.selectedIndex == -1
        || cboStateID2.options[cboStateID2.selectedIndex].value <= 0) || txtZipCode2.value.length > 0
        || imDateOfBirth2.value.length > 0 || imSSN2.value.length > 0 || imHomePhone2.value.length > 0
        || imHomeFax2.value.length > 0 || imBusinessPhone2.value.length > 0 || imBusinessFax2.value.length > 0
        || imAlternatePhone2.value.length > 0 || imCellPhone2.value.length > 0 || txtEmailAddress2.value.length > 0)
    {
        if (txtFirstName2.value.length == 0)
        {
            Message = "The First Name field is required.";
            Control = txtFirstName2;
        }
        else if (txtLastName2.value.length == 0)
        {
            Message = "The Last Name field is required.";
            Control = txtLastName2;
        }
        else if (txtStreet12.value.length == 0)
        {
            Message = "The Street field is required.";
            Control = txtStreet12;
        }
        else if (txtZipCode2.value.length == 0)
        {
            Message = "The Zip Code field is required.";
            Control = txtZipCode2;
        }
        else if (txtCity2.value.length == 0)
        {
            Message = "The City field is required.";
            Control = txtCity2;
        }
        else if (cboStateID2.selectedIndex == -1 || cboStateID.options[cboStateID2.selectedIndex].value <= 0)
        {
            Message = "The State field is required.";
            Control = cboStateID2;
        }
    }

    if (Message.length > 0)
    {
        ShowMessage(Control, Message + " The Spouse applicant is not required; but if you enter "
            + "any data for the Spouse column, you must also enter the other required fields.  <a "
            + "class=\"lnk\" href=\"javascript:ClearSpouse();\">Click here</a> to clear all Spouse data.");

        AddBorder(Control);
        return false;
    }
    else
    {
        return true;
    }
}
function ClearACH()
{
    cboDepositMethod.value = "";
    txtDepositAmount.value = "";
    cboDepositDay.selectedIndex = -1;
    txtRoutingNumber.value = "";
    txtAccountNumber.value = "";
    cboBankType.selectedIndex = -1;
    txtBankName.value = "";
    txtBankCity.value = "";
    cboBankStateID.selectedIndex = -1;
    imDepositStartDate.value = "";

    CleanBorders();
}
function ClearSpouse()
{
    txtFirstName2.value = "";
    txtLastName2.value = "";
    txtStreet12.value = "";
    txtStreet22.value = "";
    txtCity2.value = "";
    cboStateID2.selectedIndex = -1;
    txtZipCode2.value = "";
    imDateOfBirth2.value = "";
    imSSN2.value = "";
    imHomePhone2.value = "";
    imHomeFax2.value = "";
    imBusinessPhone2.value = "";
    imBusinessFax2.value = "";
    imAlternatePhone2.value = "";
    imCellPhone2.value = "";
    txtEmailAddress2.value = "";

    CleanBorders();
}
function CleanBorders()
{
    // hide all error boxes
    dvErrorReceived.style.display = "none";
    dvErrorPrimary.style.display = "none";
    dvErrorSecondary.style.display = "none";
    dvErrorSetup.style.display = "none";
    dvErrorAccounts.style.display = "none";

    // remove all display residue
    for (i = 0; i < Inputs.length; i++)
    {
        RemoveBorder(Inputs[i]);
    }
}
function RequiredExist(Resolving)
{
    CleanBorders();

    // validate inputs
    for (i = 0; i < Inputs.length; i++)
    {
        var Input = Inputs[i];

        var reqSav = Input.getAttribute("reqSave");
        var reqRes = Input.getAttribute("reqResolve");
        var valCap = Input.getAttribute("valCap");
        var valFun = Input.getAttribute("valFun");

        // check for content existence if required
        if (reqSav != null || (Resolving && reqRes != null))
        {
            if (Input.tagName.toLowerCase() == "select")
            {
                // control is a dropdownlist
                if (Input.selectedIndex == -1 || Input.options[Input.selectedIndex].value <= 0)
                {
                    ShowMessage(Input, "The " + valCap + " field is required.");
                    AddBorder(Input);
                    return false;
                }
            }
            else if (Input.tagName.toLowerCase() == "input" && Input.type == "text")
            {
                if (Input.value.length == 0)
                {
                    ShowMessage(Input, "The " + valCap + " field is required.");
                    AddBorder(Input);
                    return false;
                }
            }
            else if (Input.tagName.toLowerCase() == "input" && Input.type == "checkbox")
            {
                if (!Input.checked)
                {
                    ShowMessage(Input, "The " + valCap + " field must be checked.");
                    AddBorder(Input);
                    return false;
                }
            }
        }

        // check, if control is textbox and content exists, that it is valid
        if (Input.tagName.toLowerCase() == "input" && Input.value.length > 0 && valFun != null)
        {
            if (!(eval(valFun)))
            {
                ShowMessage(Input, "The value you entered for " + valCap + " is invalid.");
                AddBorder(Input);
                return false;
            }
        }
    }

    return true;
}
function HideMessage(obj)
{
    var dv = obj.getAttribute("dvErr");

    if (dv != null)
    {
        dv = document.getElementById(dv);

        dv.style.display = "none";
    }
}
function ShowMessage(obj, message)
{
    var dv = obj.getAttribute("dvErr");

    if (dv != null)
    {
        dv = document.getElementById(dv);
        var td = dv.childNodes[0].rows[0].cells[1];

        dv.style.display = "";
        td.innerHTML = message;
    }
}
function LoadControls()
{
    if (txtFirstName == null)
    {
        chkReceivedLSA = document.getElementById("<%= chkReceivedLSA.ClientID %>");
        chkReceivedDeposit = document.getElementById("<%= chkReceivedDeposit.ClientID %>");

        txtFirstName = document.getElementById("<%= txtFirstName.ClientID %>");
        txtLastName = document.getElementById("<%= txtLastName.ClientID %>");
        txtStreet1 = document.getElementById("<%= txtStreet1.ClientID %>");
        txtStreet2 = document.getElementById("<%= txtStreet2.ClientID %>");
        txtCity = document.getElementById("<%= txtCity.ClientID %>");
        cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
        txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");
        imDateOfBirth = document.getElementById("<%= imDateOfBirth.ClientID %>");
        imSSN = document.getElementById("<%= imSSN.ClientID %>");
        imHomePhone = document.getElementById("<%= imHomePhone.ClientID %>");
        imHomeFax = document.getElementById("<%= imHomeFax.ClientID %>");
        imBusinessPhone = document.getElementById("<%= imBusinessPhone.ClientID %>");
        imBusinessFax = document.getElementById("<%= imBusinessFax.ClientID %>");
        imAlternatePhone = document.getElementById("<%= imAlternatePhone.ClientID %>");
        imCellPhone = document.getElementById("<%= imCellPhone.ClientID %>");
        txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID %>");

        txtFirstName2 = document.getElementById("<%= txtFirstName2.ClientID %>");
        txtLastName2 = document.getElementById("<%= txtLastName2.ClientID %>");
        txtStreet12 = document.getElementById("<%= txtStreet12.ClientID %>");
        txtStreet22 = document.getElementById("<%= txtStreet22.ClientID %>");
        txtCity2 = document.getElementById("<%= txtCity2.ClientID %>");
        cboStateID2 = document.getElementById("<%= cboStateID2.ClientID %>");
        txtZipCode2 = document.getElementById("<%= txtZipCode2.ClientID %>");
        imDateOfBirth2 = document.getElementById("<%= imDateOfBirth2.ClientID %>");
        imSSN2 = document.getElementById("<%= imSSN2.ClientID %>");
        imHomePhone2 = document.getElementById("<%= imHomePhone2.ClientID %>");
        imHomeFax2 = document.getElementById("<%= imHomeFax2.ClientID %>");
        imBusinessPhone2 = document.getElementById("<%= imBusinessPhone2.ClientID %>");
        imBusinessFax2 = document.getElementById("<%= imBusinessFax2.ClientID %>");
        imAlternatePhone2 = document.getElementById("<%= imAlternatePhone2.ClientID %>");
        imCellPhone2 = document.getElementById("<%= imCellPhone2.ClientID %>");
        txtEmailAddress2 = document.getElementById("<%= txtEmailAddress2.ClientID %>");

        cboDepositMethod = document.getElementById("<%= cboDepositMethod.ClientID %>");
        txtDepositAmount = document.getElementById("<%= txtDepositAmount.ClientID %>");
        cboDepositDay = document.getElementById("<%= cboDepositDay.ClientID %>");
        txtRoutingNumber = document.getElementById("<%= txtRoutingNumber.ClientID %>");
        txtAccountNumber = document.getElementById("<%= txtAccountNumber.ClientID %>");
        cboBankType = document.getElementById("<%= cboBankType.ClientID %>");
        txtBankName = document.getElementById("<%= txtBankName.ClientID %>");
        txtBankCity = document.getElementById("<%= txtBankCity.ClientID %>");
        cboBankStateID = document.getElementById("<%= cboBankStateID.ClientID %>");
        imDepositStartDate = document.getElementById("<%= imDepositStartDate.ClientID %>");

        grdAccounts = document.getElementById("<%= grdAccounts.ClientID %>");
        grdAccountsUpdates = document.getElementById("<%= grdAccountsUpdates.ClientID %>");
        grdAccountsInserts = document.getElementById("<%= grdAccountsInserts.ClientID %>");
        grdAccountsDeletes = document.getElementById("<%= grdAccountsDeletes.ClientID %>");
        grdAccountsSelected = document.getElementById("<%= grdAccountsSelected.ClientID %>");

        chkCollectInsert = document.getElementById("<%= chkCollectInsert.ClientID %>");
        chkCollectUpdate = document.getElementById("<%= chkCollectUpdate.ClientID %>");

        pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
        pnlBodyMessage = document.getElementById("<%= pnlBodyMessage.ClientID %>");

        dvErrorReceived = document.getElementById("<%= dvErrorReceived.ClientID %>");
        dvErrorPrimary = document.getElementById("<%= dvErrorPrimary.ClientID %>");
        dvErrorSecondary = document.getElementById("<%= dvErrorSecondary.ClientID %>");
        dvErrorSetup = document.getElementById("<%= dvErrorSetup.ClientID %>");
        dvErrorAccounts = document.getElementById("<%= dvErrorAccounts.ClientID %>");

        Inputs[Inputs.length] = chkReceivedLSA;
        Inputs[Inputs.length] = chkReceivedDeposit;

        Inputs[Inputs.length] = txtFirstName;
        Inputs[Inputs.length] = txtLastName;
        Inputs[Inputs.length] = txtStreet1;
        Inputs[Inputs.length] = txtStreet2;
        Inputs[Inputs.length] = txtCity;
        Inputs[Inputs.length] = cboStateID;
        Inputs[Inputs.length] = txtZipCode;
        Inputs[Inputs.length] = imDateOfBirth;
        Inputs[Inputs.length] = imSSN;
        Inputs[Inputs.length] = imHomePhone;
        Inputs[Inputs.length] = imHomeFax;
        Inputs[Inputs.length] = imBusinessPhone;
        Inputs[Inputs.length] = imBusinessFax;
        Inputs[Inputs.length] = imAlternatePhone;
        Inputs[Inputs.length] = imCellPhone;
        Inputs[Inputs.length] = txtEmailAddress;

        Inputs[Inputs.length] = txtFirstName2;
        Inputs[Inputs.length] = txtLastName2;
        Inputs[Inputs.length] = txtStreet12;
        Inputs[Inputs.length] = txtStreet22;
        Inputs[Inputs.length] = txtCity2;
        Inputs[Inputs.length] = cboStateID2;
        Inputs[Inputs.length] = txtZipCode2;
        Inputs[Inputs.length] = imDateOfBirth2;
        Inputs[Inputs.length] = imSSN2;
        Inputs[Inputs.length] = imHomePhone2;
        Inputs[Inputs.length] = imHomeFax2;
        Inputs[Inputs.length] = imBusinessPhone2;
        Inputs[Inputs.length] = imBusinessFax2;
        Inputs[Inputs.length] = imAlternatePhone2;
        Inputs[Inputs.length] = imCellPhone2;
        Inputs[Inputs.length] = txtEmailAddress2;

        Inputs[Inputs.length] = cboDepositMethod;
        Inputs[Inputs.length] = txtDepositAmount;
        Inputs[Inputs.length] = cboDepositDay;
        Inputs[Inputs.length] = txtRoutingNumber;
        Inputs[Inputs.length] = txtAccountNumber;
        Inputs[Inputs.length] = cboBankType;
        Inputs[Inputs.length] = txtBankName;
        Inputs[Inputs.length] = txtBankCity;
        Inputs[Inputs.length] = cboBankStateID;
        Inputs[Inputs.length] = imDepositStartDate;
    }
}
function IsValidCurrency(Value)
{
    if (isNaN(parseFloat(Value)))
    {
        return false;
    }
    else
    {
        if (parseFloat(Value) == 0.0)
        {
            return false;
        }
    }

    return true;
}
function txtFirstName2_OnBlur(obj)
{
    CopyFields(true, true);
}
function txtLastName2_OnBlur(obj)
{
    CopyFields(false, true);
}
function CopyFields(Name, Address)
{
    LoadControls();

    if (txtFirstName2.value.length > 0 || txtLastName2.value.length > 0)
    {
        if (Name)
        {
            if (txtLastName2.value.length == 0)
            {
                txtLastName2.value = txtLastName.value;
            }
        }

        if (Address)
        {
            if (txtStreet12.value.length == 0)
            {
                txtStreet12.value = txtStreet1.value;
            }

            if (txtStreet22.value.length == 0)
            {
                txtStreet22.value = txtStreet2.value;
            }

            if (txtCity2.value.length == 0)
            {
                txtCity2.value = txtCity.value;
            }

            if (cboStateID2.selectedIndex != -1)
            {
                cboStateID2.selectedIndex = cboStateID.selectedIndex;
            }

            if (txtZipCode2.value.length == 0)
            {
                txtZipCode2.value = txtZipCode.value;
            }
        }
    }
}
function txtZipCode_OnBlur(obj)
{
    LoadControls();

	if (obj.value.length > 0)
	{
		xml = new ActiveXObject("Microsoft.XMLDOM");
		xml.async = false;

		xml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

		var address = xml.getElementsByTagName("address")[0];

		if (address != null && address.attributes.length > 0)
		{
			if (address.attributes.getNamedItem("city") != null)
			{
				txtCity.value = address.attributes.getNamedItem("city").value;
			}

			if (cboStateID != null)
			{
				if (address.attributes.getNamedItem("statename") != null) {
					for (i = 0; i < cboStateID.options.length; i++) {
						if (cboStateID.options[i].text == address.attributes.getNamedItem("statename").value)
							cboStateID.selectedIndex = i;
					}
				}
			}
		}
		else
		{
		    txtCity.value = "";
		    cboStateID.selectedIndex = 0;
		}
	}
	else
	{
	    txtCity.value = "";
	    cboStateID.selectedIndex = 0;
	}
}
function txtZipCode2_OnBlur(obj)
{
    LoadControls();

	if (obj.value.length > 0)
	{
		xml = new ActiveXObject("Microsoft.XMLDOM");
		xml.async = false;

		xml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

		var address = xml.getElementsByTagName("address")[0];

		if (address != null && address.attributes.length > 0)
		{
			if (address.attributes.getNamedItem("city") != null)
			{
				txtCity2.value = address.attributes.getNamedItem("city").value;
			}

			if (cboStateID2 != null)
			{
				if (address.attributes.getNamedItem("statename") != null) {
					for (i = 0; i < cboStateID2.options.length; i++) {
						if (cboStateID2.options[i].text == address.attributes.getNamedItem("statename").value)
							cboStateID2.selectedIndex = i;
					}
				}
			}
		}
		else
		{
		    txtCity2.value = "";
		    cboStateID2.selectedIndex = 0;
		}
	}
	else
	{
	    txtCity2.value = "";
	    cboStateID2.selectedIndex = 0;
	}
}
function FindCreditor(btn)
{
    var td = btn.parentNode.parentNode;
    var tr = td.parentNode;

    var creditor = tr.cells[1].childNodes[0].innerText;
    var street = tr.cells[8].childNodes[0].innerText;
    var street2 = tr.cells[9].childNodes[0].innerText;
    var city = tr.cells[10].childNodes[0].innerText;
    var stateid = tr.cells[11].childNodes[1].innerHTML;
    var zipcode = tr.cells[12].childNodes[0].innerText;

    // open the find window
    showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Find Creditor&p=findcreditor.aspx") %>" + "&creditor=" + creditor + "&street=" + street + "&street2=" + street2 + "&city=" + city + "&stateid=" + stateid + "&zipcode=" + zipcode, new Array(window, btn, "CreditorFinderReturn"), "status:off;help:off;dialogWidth:650px;dialogHeight:500px");
}
function FindFor(btn)
{
    var td = btn.parentNode.parentNode;
    var tr = td.parentNode;

    var forcreditor = tr.cells[3].childNodes[0].innerText;

    // open the find window
    showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Find Creditor&p=findcreditor.aspx") %>" + "&creditor=" + forcreditor, new Array(window, btn, "CreditorFinderReturnFor"), "status:off;help:off;dialogWidth:650px;dialogHeight:500px");
}
function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode)
{

    
    var td = btn.parentNode.parentNode;
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;
    var txt = tbl.nextSibling;

    Grid_LoadControls(tbl);
    var col = tbl.rows[0].cells[tr.cells[11].cellIndex];
    var controls = tbl.getAttribute("controls");
    var controlIndex = parseInt(col.getAttribute("control"));
    var ddl = controls[controlIndex];

    if (name == "&nbsp;")
    {
        name = "";
    }

    if (street == "&nbsp;")
    {
        street = "";
    }

    if (street2 == "&nbsp;")
    {
        street2 = "";
    }

    if (city == "&nbsp;")
    {
        city = "";
    }

    if (zipcode == "&nbsp;")
    {
        zipcode = "";
    }

    // creditor name
    txt.setAttribute("row", tr.cells[1]);
    txt.value = name;
    Grid_TXT_Save(txt);

    // street
    txt.setAttribute("row", tr.cells[8]);
    txt.value = street;
    Grid_TXT_Save(txt);

    // street2
    txt.setAttribute("row", tr.cells[9]);
    txt.value = street2;
    Grid_TXT_Save(txt);

    // city
    txt.setAttribute("row", tr.cells[10]);
    txt.value = city;
    Grid_TXT_Save(txt);

    // state
    ddl.setAttribute("row", tr.cells[11]);

    SetSelected(ddl, stateid);

    Grid_DDL_Save(ddl);

    // zipcode
    txt.setAttribute("row", tr.cells[12]);
    txt.value = zipcode;
    Grid_TXT_Save(txt);
}
function CreditorFinderReturnFor(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode)
{
    var td = btn.parentNode.parentNode;
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;
    var txt = tbl.nextSibling;

    if (name == "&nbsp;")
    {
        name = "";
    }

    // for creditor name
    txt.setAttribute("row", tr.cells[3]);
    txt.value = name;
    Grid_TXT_Save(txt);
}
function SetSelected(ddl, value)
{
    if (ddl != null && ddl.options != null)
    {
        for (v = 0; v < ddl.options.length; v++)
        {
            if (ddl.options[v].value == value)
            {
                ddl.selectedIndex = v;
                break;
            }
        }
    }
}

</script>
<script type="text/javascript">
function SendBackToAgency()
{
    showModalDialog("<%= ResolveUrl("~/util/pop/clientsendbackholder.aspx?clientid=" & clientid) %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px");
}
</script>
<body onload="SetFocus('<%= txtFirstName.ClientID %>');">

<asp:Panel runat="server" ID="pnlBodyDefault">
<table class="stanTblNoH" cellpadding="0" cellspacing="15" border="0">
    <tr>
        <td style="background-color:#f1f1f1;padding:8;font-weight:bold;" colspan="3">Data Entry Verification<font style="font-weight:normal;">&nbsp;&nbsp;for<img runat="server" src="~/images/16x16_person.png" style="margin:0 3 0 3;" border="0" align="absmiddle" /><a class="lnk" runat="server" ID="lnkClientName"></a></font></td>
    </tr>
    <tr>
        <td colspan="3">
            <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td valign="top" ><asp:Label runat="server" ID="lblInfoBox"></asp:Label></td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="padding-left:20;">
            <div runat="server" id="dvErrorReceived" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorReceived"></td>
                    </tr>
                </table>&nbsp;<br />
            </div>
            <input type="checkbox" reqResolve="true" valCap="Received LSA" runat="server" ID="chkReceivedLSA" /><label for="<%= chkReceivedLSA.ClientID() %>">&nbsp;The LSA has been received from this client.</label><br />
            <input type="checkbox" runat="server" ID="chkReceivedDeposit" /><label for="<%= chkReceivedDeposit.ClientID() %>">&nbsp;The retainer deposit has been received from this client.</label>
        </td>
    </tr>
    <tr>
        <td valign="top"> <!-- primary applicant cell -->
            <div runat="server" id="dvErrorPrimary" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorPrimary"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:300;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Primary Applicant</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="width:100;">Name:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><asp:TextBox reqSave="true" valCap="First Name" TabIndex="1" MaxLength="50" CssClass="entry" runat="server" ID="txtFirstName"></asp:TextBox></td>
                                            <td style="padding-left:5;"><asp:TextBox reqSave="true" valCap="Last Name" TabIndex="2" MaxLength="50" CssClass="entry" runat="server" ID="txtLastName"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Address Street:</td>
                                <td><asp:TextBox reqSave="true" valCap="Street" TabIndex="3" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet1"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Address Street 2:</td>
                                <td><asp:TextBox TabIndex="4" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet2"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Address City:</td>
                                <td><asp:TextBox reqSave="true" valCap="City" TabIndex="6" MaxLength="50" CssClass="entry" runat="server" ID="txtCity"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>State / Zip:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><asp:DropDownList reqSave="true" valCap="State" TabIndex="7" CssClass="entry" runat="server" ID="cboStateID"></asp:DropDownList></td>
                                            <td style="padding-left:5;"><asp:TextBox reqSave="true" valCap="Zip Code" TabIndex="5" MaxLength="50" CssClass="entry" runat="server" ID="txtZipCode"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>DOB / SSN:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Date of Birth" valFun="IsValidDateTime(Input.value);" TabIndex="8" CssClass="entry" runat="server" ID="imDateOfBirth" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="SSN" valFun="IsValidTextSSN(Input.value);" TabIndex="9" CssClass="entry" runat="server" ID="imSSN" Mask="nnn-nn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Home Phone / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Home Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="10" CssClass="entry" runat="server" ID="imHomePhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Home Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="11" CssClass="entry" runat="server" ID="imHomeFax" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Bus. Phone / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Business Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="12" CssClass="entry" runat="server" ID="imBusinessPhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Business Phone Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="13" CssClass="entry" runat="server" ID="imBusinessFax" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Alternate / Cell:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Alternate Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="14" CssClass="entry" runat="server" ID="imCellPhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Cell Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="15" CssClass="entry" runat="server" ID="imAlternatePhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Email Address:</td>
                                <td><asp:TextBox valCap="Email Address" valFun="IsValidTextEmailAddress(Input.value);" TabIndex="16" MaxLength="50" CssClass="entry" runat="server" ID="txtEmailAddress"></asp:TextBox></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td valign="top"> <!-- secondary applicant cell -->
            <div runat="server" id="dvErrorSecondary" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorSecondary"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:300;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Spouse</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="width:100;">Name:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><asp:TextBox TabIndex="17" MaxLength="50" CssClass="entry" runat="server" ID="txtFirstName2"></asp:TextBox></td>
                                            <td style="padding-left:5;"><asp:TextBox TabIndex="18" MaxLength="50" CssClass="entry" runat="server" ID="txtLastName2"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Address Street:</td>
                                <td><asp:TextBox TabIndex="19" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet12"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Address Street 2:</td>
                                <td><asp:TextBox TabIndex="20" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet22"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Address City:</td>
                                <td><asp:TextBox TabIndex="22" MaxLength="50" CssClass="entry" runat="server" ID="txtCity2"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>State / Zip:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><asp:DropDownList TabIndex="23" CssClass="entry" runat="server" ID="cboStateID2"></asp:DropDownList></td>
                                            <td style="padding-left:5;"><asp:TextBox TabIndex="21" MaxLength="50" CssClass="entry" runat="server" ID="txtZipCode2"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>DOB / SSN:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Date of Birth" valFun="IsValidDateTime(Input.value);" TabIndex="24" CssClass="entry" runat="server" ID="imDateOfBirth2" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="SSN" valFun="IsValidTextSSN(Input.value);" TabIndex="25" CssClass="entry" runat="server" ID="imSSN2" Mask="nnn-nn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Home Phone / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Home Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="26" CssClass="entry" runat="server" ID="imHomePhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Home Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="27" CssClass="entry" runat="server" ID="imHomeFax2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Bus. Phone / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Business Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="28" CssClass="entry" runat="server" ID="imBusinessPhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Business Phone Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="29" CssClass="entry" runat="server" ID="imBusinessFax2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Alternate / Cell:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Alternate Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="30" CssClass="entry" runat="server" ID="imAlternatePhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Cell Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="31" CssClass="entry" runat="server" ID="imCellPhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Email Address:</td>
                                <td><asp:TextBox valCap="Email Address" valFun="IsValidTextEmailAddress(Input.value);" TabIndex="32" MaxLength="50" CssClass="entry" runat="server" ID="txtEmailAddress2"></asp:TextBox></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td valign="top"> <!-- non-grid fields cell -->
            <div runat="server" id="dvErrorSetup" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorSetup"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:300;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Setup & ACH Info</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="height:21;width:110;">Company:</td>
                                <td><asp:Label CssClass="entry" runat="server" ID="lblCompanyName"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="height:21;">Agency:</td>
                                <td><asp:Label CssClass="entry" runat="server" ID="lblAgencyName"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="height:21;">Trust:</td>
                                <td><asp:Label CssClass="entry" runat="server" ID="lblTrustName"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>Method / Amt. / Day:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="padding-right:5;width:55;">
                                                <asp:DropDownList TabIndex="37" CssClass="entry" runat="server" ID="cboDepositMethod">
                                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                                    <asp:ListItem Value="ACH" Text="ACH"></asp:ListItem>
                                                    <asp:ListItem Value="Check" Text="Check"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td style="padding-right:5;width:50;"><asp:TextBox valCap="Deposit Amount" valFun="IsValidNumberFloat(Input.value, false, Input);" style="text-align:right;" TabIndex="38" MaxLength="50" CssClass="entry" runat="server" ID="txtDepositAmount"></asp:TextBox></td>
                                            <td>
                                                <asp:DropDownList TabIndex="39" class="entry" id="cboDepositDay" runat="server">
                                                    <asp:ListItem value="0" text=""></asp:ListItem>
                                                    <asp:ListItem value="1" text="Day 1"></asp:ListItem>
                                                    <asp:ListItem value="2" text="Day 2"></asp:ListItem>
                                                    <asp:ListItem value="3" text="Day 3"></asp:ListItem>
                                                    <asp:ListItem value="4" text="Day 4"></asp:ListItem>
                                                    <asp:ListItem value="5" text="Day 5"></asp:ListItem>
                                                    <asp:ListItem value="6" text="Day 6"></asp:ListItem>
                                                    <asp:ListItem value="7" text="Day 7"></asp:ListItem>
                                                    <asp:ListItem value="8" text="Day 8"></asp:ListItem>
                                                    <asp:ListItem value="9" text="Day 9"></asp:ListItem>
                                                    <asp:ListItem value="10" text="Day 10"></asp:ListItem>
                                                    <asp:ListItem value="11" text="Day 11"></asp:ListItem>
                                                    <asp:ListItem value="12" text="Day 12"></asp:ListItem>
                                                    <asp:ListItem value="13" text="Day 13"></asp:ListItem>
                                                    <asp:ListItem value="14" text="Day 14"></asp:ListItem>
                                                    <asp:ListItem value="15" text="Day 15"></asp:ListItem>
                                                    <asp:ListItem value="16" text="Day 16"></asp:ListItem>
                                                    <asp:ListItem value="17" text="Day 17"></asp:ListItem>
                                                    <asp:ListItem value="18" text="Day 18"></asp:ListItem>
                                                    <asp:ListItem value="19" text="Day 19"></asp:ListItem>
                                                    <asp:ListItem value="20" text="Day 20"></asp:ListItem>
                                                    <asp:ListItem value="21" text="Day 21"></asp:ListItem>
                                                    <asp:ListItem value="22" text="Day 22"></asp:ListItem>
                                                    <asp:ListItem value="23" text="Day 23"></asp:ListItem>
                                                    <asp:ListItem value="24" text="Day 24"></asp:ListItem>
                                                    <asp:ListItem value="25" text="Day 25"></asp:ListItem>
                                                    <asp:ListItem value="26" text="Day 26"></asp:ListItem>
                                                    <asp:ListItem value="27" text="Day 27"></asp:ListItem>
                                                    <asp:ListItem value="28" text="Day 28"></asp:ListItem>
                                                    <asp:ListItem value="29" text="Day 29"></asp:ListItem>
                                                    <asp:ListItem value="30" text="Day 30"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Routing Number:</td>
                                <td><asp:TextBox TabIndex="40" MaxLength="9" CssClass="entry" runat="server" ID="txtRoutingNumber"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Account Number:</td>
                                <td><asp:TextBox TabIndex="41" MaxLength="50" CssClass="entry" runat="server" ID="txtAccountNumber"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Account Type:</td>
                                <td>
                                    <asp:DropDownList TabIndex="42" class="entry" id="cboBankType" runat="server" style="font-size:11px">
                                        <asp:ListItem value="0" text=""></asp:ListItem>
                                        <asp:ListItem value="C" text="Checking"></asp:ListItem>
                                        <asp:ListItem value="S" text="Savings"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Bank Name:</td>
                                <td><asp:TextBox TabIndex="43" MaxLength="50" CssClass="entry" runat="server" ID="txtBankName"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Bank City / State:</td>
                                <td>
                                    <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width:50%;"><asp:TextBox TabIndex="44" MaxLength="50" CssClass="entry" runat="server" ID="txtBankCity"></asp:TextBox></td>
                                            <td style="width:50%;padding-left:5;"><asp:DropDownList TabIndex="45" CssClass="entry" runat="server" ID="cboBankStateID"></asp:DropDownList></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Start Date:</td>
                                <td><cc1:InputMask valCap="Deposit Start Date" valFun="IsValidDateTime(Input.value);" TabIndex="45" CssClass="entry" runat="server" ID="imDepositStartDate" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                            </tr>
                            <tr>
                                <td>Monthly Fee:</td>
                                <td>
                                    <asp:DropDownList TabIndex="42" class="entry" id="monthlyFee" runat="server" style="font-size:11px">
                                        <asp:ListItem value="55.00" text="">55.00</asp:ListItem>
                                        <asp:ListItem value="65.00" text="Checking">65.00</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id="trAccounts" runat="server">
        <td valign="top" colspan="3"> <!-- bottom creditor accounts grid cell -->
            <div style="width:100%;">
                <div runat="server" id="dvErrorAccounts" style="display:none;">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
	                    <tr>
		                    <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
		                    <td runat="server" id="tdErrorAccounts"></td>
	                    </tr>
                    </table>&nbsp;
                </div>
                <div id="grdAccounts" class="grid" runat="server" style="width:100%;height:145;"><input type="text" class="grdTXT uns" onkeydown="Grid_TXT_OnKeyDown(this);" onblur="Grid_TXT_OnBlur(this);" /></div><input runat="server" id="grdAccountsUpdates" type="hidden" /><input runat="server" id="grdAccountsInserts" type="hidden" /><input runat="server" id="grdAccountsDeletes" type="hidden" /><input runat="server" id="grdAccountsSelected" type="hidden" />
            </div>
        </td>
    </tr>
</table>
</asp:Panel>
<asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" cellpadding="0" cellspacing="20" border="0">
        <tr>
            <td valign="top" align="center">
            </td>
        </tr>
    </table>
</asp:Panel>

<asp:DropDownList runat="server" ID="cboTaskResolutionID" style="display:none;"></asp:DropDownList>
<asp:CheckBox runat="server" ID="chkCollectInsert" style="display:none;" />
<asp:CheckBox runat="server" ID="chkCollectUpdate" style="display:none;" />

<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->

<asp:LinkButton runat="server" ID="lnkReturn"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkResolve"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkSaveForLater"></asp:LinkButton>

</body>

</asp:Content>