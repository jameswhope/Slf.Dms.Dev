<%@ Page Language="VB" MasterPageFile="~/clients/clients.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_new_default" title="DMP - Client Screening" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server"><asp:Panel ID="pnlMenu" runat="server">

    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_Save();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="OpenAddNote();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_note.png" />Add Note</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="OpenAddApplicant();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_people.png" />Add Co-Applicant</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="lnkDoesNotQualify_OnClick(this);return false;" id="lnkDoesNotQualify">
                        <img id="Img4" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_cancel.png" />Does Not Qualify</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="lnkWouldNotCommit_OnClick(this);return false;" id="lnkWouldNotCommit">
                        <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_personerror.png" />Would Not Commit</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a id="A3" runat="server" class="menuButton" href="~/search.aspx">
                        <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuNotQualified" style="display:none;">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_SaveNotQualified();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="lnkBackToEnrollment_OnClick(this);return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Back To Screening</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/clients/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_find.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuNotCommitted" style="display:none;">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_SaveNotCommitted();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="lnkBackToEnrollment_OnClick(this);return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Back To Screening</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/clients/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_find.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>

</asp:Panel></asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
<script type="text/javascript">

var optTooMuchUnsecuredDebt_idx = <%=optTooMuchUnsecuredDebt_idx %>;
var optOther_idx = <%=optOther_idx %>;

var TotalMonthlyPayment = 0.0;
var TotalUnsecuredDebt = 0.0;
var EstimatedEndAmount = 0.0;
var EstimatedEndTime = 0;
var DepositCommitment = 0.0;
var BalanceAtEnrollment = 0.0;
var BalanceAtSettlement = 0.0;

var EnrollmentMinimum = <%= EnrollmentMinimum %>;                           // minimum unsecured to be enrolled
var EnrollmentInflation = <%= EnrollmentInflation %>;                       // amount balance will rise by settlement
var EnrollmentDepositMinimum = <%= EnrollmentDepositMinimum %>;             // minimum whole amount can deposit
var EnrollmentDepositPercentage = <%= EnrollmentDepositPercentage %>;       // minimum percentage can deposit
var EnrollmentRetainerPercentage = <%= EnrollmentRetainerPercentage %>;     // enrollment retainer percentage
var EnrollmentSettlementPercentage = <%= EnrollmentSettlementPercentage %>; // percentage taken on saved debt
var EnrollmentMonthlyFee = <%= EnrollmentMonthlyFee %>;                     // monthly maintenance fee
var EnrollmentPBMAPR = <%= EnrollmentPBMAPR %>;                             // PBM APR
var EnrollmentPBMMinimum = <%= EnrollmentPBMMinimum %>;                     // PBM minimum monthly
var EnrollmentPBMPercentage = <%= EnrollmentPBMPercentage %>;               // PBM percentage assessed monthly

var txtTotalMonthlyPayment = null;
var txtTotalUnsecuredDebt = null;
var txtDepositCommitment = null;
var lblBalanceAtEnrollment = null;
var txtBalanceAtEnrollment = null;
var lblBalanceAtSettlement = null;
var txtBalanceAtSettlement = null;
var lblEstimatedEndAmount = null;
var txtEstimatedEndAmount = null;
var lblEstimatedEndTime = null;
var txtEstimatedEndTime = null;
var tblPlanOptions = null;
var txtApplicants = null;
var pnlMenuDefault = null;
var pnlMenuNotQualified = null;
var pnlMenuNotCommitted = null;
var pnlBodyDefault = null;
var pnlBodyNotQualified = null;
var pnlBodyNotCommitted = null;

var zipXml;
var Elements = new Array();

function GetElement(index)
{
    if (Elements.length == 0)   //not loaded, so add controls
    {
        Elements[0] = document.getElementById("<%= txtStreet.ClientID %>");
        Elements[1] = document.getElementById("<%= txtStreet2.ClientID %>");
        Elements[2] = document.getElementById("<%= txtCity.ClientID %>");
        Elements[3] = document.getElementById("<%= cboStateID.ClientID %>");
        Elements[4] = document.getElementById("<%= txtZipCode.ClientID %>");
    }

    return Elements[index];
}
function initDocs()
{
	zipXml = new ActiveXObject("Microsoft.XMLDOM");
	zipXml.async = false;
}
function txtZipCode2_OnBlur(obj)
{
    var txtPhone = document.getElementById("<%= txtPhone.ClientID %>");
	var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");
	var txtHomePhone = document.getElementById("<%= txtHomePhone.ClientID %>");

    if (obj.value.length > 0)
    {
        txtZipCode.value = obj.value;

        if (txtHomePhone.value.length == 0)
        {
            txtHomePhone.value = txtPhone.value;
        }

        txtZipCode_OnBlur(txtZipCode);
    }
}
function txtZipCode_OnBlur(obj)
{
	var txtCity = document.getElementById("<%= txtCity.ClientID %>");
	var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
	var lblAppointmentTime = document.getElementById("<%= lblAppointmentTime.ClientID %>");

	if (obj.value.length > 0)
	{
        initDocs();

        // get city and state info
		zipXml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

		var address = zipXml.getElementsByTagName("address")[0];

		if (address != null && address.attributes.length > 0)
		{
			if (address.attributes.getNamedItem("city") != null)
			{
				txtCity.value = address.attributes.getNamedItem("city").value;
			}

			if (cboStateID != null)
			{
				if (address.attributes.getNamedItem("stateabbreviation") != null) {
					for (i = 0; i < cboStateID.options.length; i++) {
						if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
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

        // get time and zone info
		zipXml.load("<%= ResolveUrl("~/util/getlocaltime.ashx?format=hh%3Amm+tt&zip=") %>" + obj.value);

		var location = zipXml.getElementsByTagName("location")[0];

		if (location != null && location.attributes.length > 0)
		{
			if (location.attributes.getNamedItem("time") != null)
			{
				lblAppointmentTime.innerHTML = location.attributes.getNamedItem("time").value 
				    + "&nbsp;&nbsp;(" + location.attributes.getNamedItem("zone").value.toUpperCase() + "ST)" ;
			}
		}
		else
		{
		    lblAppointmentTime.innerHTML = "";
		}
	}
	else
	{
	    txtCity.value = "";
	    cboStateID.selectedIndex = 0;
	    lblAppointmentTime.innerHTML = "";
	}
}
function txtName_OnBlur(obj)
{
	var txtFirstName = document.getElementById("<%= txtFirstName.ClientID %>");
	var txtLastName = document.getElementById("<%= txtLastName.ClientID %>");

    if (obj.value.length > 0)
    {
        var Names = obj.value.split(" ");

        txtFirstName.value = Names[0];

        if (Names.length > 1)
        {
            txtLastName.value = Names[Names.length - 1];
        }
    }

    txtLastName_OnBlur(txtLastName);
}
function txtPhone_OnBlur(obj)
{
	var txtHomePhone = document.getElementById("<%= txtHomePhone.ClientID %>");

    if (obj.value.length > 0)
    {
        txtHomePhone.value = obj.value;
    }
}
function txtLastName_OnBlur(obj)
{
	var txtLastNameSpouse = document.getElementById("<%= txtLastNameSpouse.ClientID %>");

    txtLastNameSpouse.value = obj.value;
}
function txtAppointmentDays_OnFocus(obj)
{
    var imAppointmentDate = document.getElementById("<%= imAppointmentDate.ClientID %>");
    var txtAppointmentDays = obj;

    if (imAppointmentDate.value.length == 0)
    {
        txtAppointmentDays.value = "";
    }
}
function txtAppointmentDays_OnBlur(obj)
{
    var imAppointmentDate = document.getElementById("<%= imAppointmentDate.ClientID %>");
    var txtAppointmentDays = obj;

    if (IsValidNumberFloat(txtAppointmentDays.value, false, txtAppointmentDays))
    {
        if (IsValidDateTime(imAppointmentDate.value) || imAppointmentDate.value.length == 0)
        {
            imAppointmentDate.value = Functoid_Date_FormatDateTimeMedium(Functoid_Date_AddDays(new Date(), parseFloat(txtAppointmentDays.value)));
        }
    }
    else
    {
        if (txtAppointmentDays.value.length == 0)
        {
            imAppointmentDate.value = "";
        }
    }
}
function imAppointmentDate_OnMatch()
{
    var imAppointmentDate = document.getElementById("<%= imAppointmentDate.ClientID %>");
    var txtAppointmentDays = document.getElementById("<%= txtAppointmentDays.ClientID %>");

    if (IsValidDateTime(imAppointmentDate.value))
    {
        txtAppointmentDays.value = FormatNumber(Functoid_Date_SubtractDays(new Date(imAppointmentDate.value), new Date()), false, 4);
    }
}
function imAppointmentDate_OnNoMatch()
{
    var imAppointmentDate = document.getElementById("<%= imAppointmentDate.ClientID %>");
    var txtAppointmentDays = document.getElementById("<%= txtAppointmentDays.ClientID %>");

    if (!IsValidDateTime(imAppointmentDate.value))
    {
        txtAppointmentDays.value = "";
    }
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function ShowMessageNotQualified(Value)
{
    var dvErrorNotQualified = document.getElementById("<%= dvErrorNotQualified.ClientID %>");
    var tdErrorNotQualified = document.getElementById("<%= tdErrorNotQualified.ClientID %>");

    dvErrorNotQualified.style.display = "inline";
    tdErrorNotQualified.innerHTML = Value;
}
function ShowMessageNotCommitted(Value)
{
    var dvErrorNotCommitted = document.getElementById("<%= dvErrorNotCommitted.ClientID %>");
    var tdErrorNotCommitted = document.getElementById("<%= tdErrorNotCommitted.ClientID %>");

    dvErrorNotCommitted.style.display = "inline";
    tdErrorNotCommitted.innerHTML = Value;
}
function ShowMessageBody(Value)
{
    var pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
    var pnlBodyNotQualified = document.getElementById("<%= pnlBodyNotQualified.ClientID %>");
    var pnlBodyNotCommitted = document.getElementById("<%= pnlBodyNotCommitted.ClientID %>");
    var pnlBodyMessage = document.getElementById("<%= pnlBodyMessage.ClientID %>");

    pnlBodyDefault.style.display = "none";
    pnlBodyNotQualified.style.display = "none";
    pnlBodyNotCommitted.style.display = "none";
    pnlBodyMessage.style.display = "inline";
    pnlBodyMessage.childNodes[0].rows[0].cells[0].innerHTML = Value;
}
function Record_Save()
{
    if (RequiredToSaveExist())
    {
        ShowMessageBody("...Saving new screening...");

        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function Record_SaveNotQualified()
{
    if (RequiredToSaveNotQualifiedExist())
    {
        ShowMessageBody("...Saving unqalified screening...");

        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSaveNotQualified, Nothing) %>;
    }
}
function Record_SaveNotCommitted()
{
    if (RequiredToSaveNotCommittedExist())
    {
        ShowMessageBody("...Saving uncommitted screening...");

        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSaveNotCommitted, Nothing) %>;
    }
}
function RequiredToSaveExist()
{
    var txtName = document.getElementById("<%= txtName.ClientID %>");
    var txtPhone = document.getElementById("<%= txtPhone.ClientID %>");
    var txtZipCode2 = document.getElementById("<%= txtZipCode2.ClientID %>");
    var cboBehindID = document.getElementById("<%= cboBehindID.ClientID %>");
    var cboConcernID = document.getElementById("<%= cboConcernID.ClientID %>");
    var txtTotalUnsecuredDebt = document.getElementById("<%= txtTotalUnsecuredDebt.ClientID %>");
    var txtFirstName = document.getElementById("<%= txtFirstName.ClientID %>");
    var txtLastName = document.getElementById("<%= txtLastName.ClientID %>");
    var txtStreet = document.getElementById("<%= txtStreet.ClientID %>");
    var txtCity = document.getElementById("<%= txtCity.ClientID %>");
    var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
    var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");
    var txtHomePhone = document.getElementById("<%= txtHomePhone.ClientID %>");
    var txtBusinessPhone = document.getElementById("<%= txtBusinessPhone.ClientID %>");
    var txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID %>");
    var imAppointmentDate = document.getElementById("<%= imAppointmentDate.ClientID %>");

    // enrollment minimum
    if (txtTotalUnsecuredDebt.value == null || txtTotalUnsecuredDebt.value.length == 0
        || parseFloat(txtTotalUnsecuredDebt.value) < EnrollmentMinimum)
    {
        ShowMessage("This prospect does not have enough unsecured debt.  An applicant must have at least $" + CurrencyAndCommaFormat(EnrollmentMinimum) + " unsecured debt to be screened.");
        AddBorder(txtTotalUnsecuredDebt);
        return false;
    }
    else
    {
        RemoveBorder(txtTotalUnsecuredDebt);
    }

    // txtName
    if (txtName.value == null || txtName.value.length == 0)
    {
        ShowMessage("The Name field is required.");
        AddBorder(txtName);
        return false;
    }
    else
    {
        RemoveBorder(txtName);
    }

    // txtPhone
    if (txtPhone.value == null || txtPhone.value.length == 0)
    {
        ShowMessage("The Phone field is required.");
        AddBorder(txtPhone);
        return false;
    }
    else
    {
        if (!RegexValidate(txtPhone.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
        {
            ShowMessage("The Phone you entered is invalid.  Please enter a new value.  This is not a required field.");
            AddBorder(txtPhone);
            return false;
        }
        else
        {
            RemoveBorder(txtPhone);
        }
    }

    // txtZipCode2
    if (txtZipCode2.value == null || txtZipCode2.value.length == 0)
    {
        ShowMessage("The Zip Code is a required field");
        AddBorder(txtZipCode2);
        return false;
    }
    else
    {
        RemoveBorder(txtZipCode2);
    }

    // cboBehindID
    if (cboBehindID.selectedIndex == -1 || cboBehindID.options[cboBehindID.selectedIndex].value == 0)
    {
        ShowMessage("The Behind field is required.");
        AddBorder(cboBehindID);
        return false;
    }
    else
    {
        RemoveBorder(cboBehindID);
    }

    // cboConcernID
    if (cboConcernID.selectedIndex == -1 || cboConcernID.options[cboConcernID.selectedIndex].value == 0)
    {
        ShowMessage("The Concern field is required.");
        AddBorder(cboConcernID);
        return false;
    }
    else
    {
        RemoveBorder(cboConcernID);
    }

    // txtFirstName
    if (txtFirstName.value == null || txtFirstName.value.length == 0)
    {
        ShowMessage("The First Name is a required field");
        AddBorder(txtFirstName);
        return false;
    }
    else
    {
        RemoveBorder(txtFirstName);
    }

    // txtLastName
    if (txtLastName.value == null || txtLastName.value.length == 0)
    {
        ShowMessage("The Last Name is a required field");
        AddBorder(txtLastName);
        return false;
    }
    else
    {
        RemoveBorder(txtLastName);
    }

    // txtStreet
    if (txtStreet.value == null || txtStreet.value.length == 0)
    {
        ShowMessage("The Street is a required field");
        AddBorder(txtStreet);
        return false;
    }
    else
    {
        RemoveBorder(txtStreet);
    }

    // txtZipCode
    if (txtZipCode.value == null || txtZipCode.value.length == 0)
    {
        ShowMessage("The Zip Code is a required field");
        AddBorder(txtZipCode);
        return false;
    }
    else
    {
        RemoveBorder(txtZipCode);
    }

    // txtCity
    if (txtCity.value == null || txtCity.value.length == 0)
    {
        ShowMessage("The City is a required field");
        AddBorder(txtCity);
        return false;
    }
    else
    {
        RemoveBorder(txtCity);
    }

    // cboStateID
    if (cboStateID.selectedIndex == -1 || cboStateID.options[cboStateID.selectedIndex].value == 0)
    {
        ShowMessage("The State is a required field");
        AddBorder(cboStateID);
        return false;
    }
    else
    {
        RemoveBorder(cboStateID);
    }

    // txtHomePhone
    if (txtHomePhone.value != null && txtHomePhone.value.length > 0)
    {
        if (!RegexValidate(txtHomePhone.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
        {
            ShowMessage("The Home Phone you entered is invalid.  Please enter a new value.  This is not a required field.");
            AddBorder(txtHomePhone);
            return false;
        }
        else
        {
            RemoveBorder(txtHomePhone);
        }
    }
    else
    {
        RemoveBorder(txtHomePhone);
    }

    // txtBusinessPhone
    if (txtBusinessPhone.value != null && txtBusinessPhone.value.length > 0)
    {
        if (!RegexValidate(txtBusinessPhone.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
        {
            ShowMessage("The Business Phone you entered is invalid.  Please enter a new value.  This is not a required field.");
            AddBorder(txtBusinessPhone);
            return false;
        }
        else
        {
            RemoveBorder(txtBusinessPhone);
        }
    }
    else
    {
        RemoveBorder(txtBusinessPhone);
    }

    // txtEmailAddress
    if (txtEmailAddress.value != null && txtEmailAddress.value.length > 0)
    {
        if (!RegexValidate(txtEmailAddress.value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"))
        {
            ShowMessage("The Email Address you entered is invalid.  Please enter a new value.  This is not a required field.");
            AddBorder(txtEmailAddress);
            return false;
        }
        else
        {
            RemoveBorder(txtEmailAddress);
        }
    }
    else
    {
        RemoveBorder(txtEmailAddress);
    }

    // imAppointmentDate
    if (imAppointmentDate.value != null && imAppointmentDate.value.length > 0)
    {
        if (!IsValidDateTime(imAppointmentDate.value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"))
        {
            ShowMessage("The Follow-Up Appointment Date you entered is invalid.  Please enter a new value.  This is not a required field.");
            AddBorder(imAppointmentDate);
            return false;
        }
        else
        {
            RemoveBorder(imAppointmentDate);
        }
    }
    else
    {
        RemoveBorder(imAppointmentDate);
    }

    return true;
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
function RequiredToSaveNotQualifiedExist()
{
    var optNotQualifiedReason = document.getElementById("<%= optNotQualifiedReason.ClientID %>");
    var txtNotQualifiedReason = document.getElementById("<%= txtNotQualifiedReason.ClientID %>");

    var FoundOn = -1;

    for (i = 0; i < optNotQualifiedReason.rows.length; i++)
    {
        if (optNotQualifiedReason.rows[i].cells[0].childNodes[0].checked)
        {
            FoundOn = i;
        }
    }

    if (FoundOn == -1)
    {
        ShowMessageNotQualified("You must select a reason this prospect did not qualify.");
        return false;
    }
    else
    {
        if (FoundOn == (optNotQualifiedReason.rows.length - 1)) // last option (custom reason)
        {
            if (txtNotQualifiedReason.value == null || txtNotQualifiedReason.value.length == 0)
            {
                ShowMessageNotQualified("Please enter a custom reason this prospect did not qualify.");
                AddBorder(txtNotQualifiedReason);
                return false;
            }
            else
            {
                RemoveBorder(txtNotQualifiedReason);
                return true;
            }
        }
        else
        {
            RemoveBorder(txtNotQualifiedReason);
            return true;
        }
    }
}
function RequiredToSaveNotCommittedExist()
{
    var optNotCommittedReason = document.getElementById("<%= optNotCommittedReason.ClientID %>");
    var txtNotCommittedReason = document.getElementById("<%= txtNotCommittedReason.ClientID %>");

    var FoundOn = -1;

    for (i = 0; i < optNotCommittedReason.rows.length; i++)
    {
        if (optNotCommittedReason.rows[i].cells[0].childNodes[0].checked)
        {
            FoundOn = i;
        }
    }

    if (FoundOn == -1)
    {
        ShowMessageNotCommitted("You must select a reason this prospect did not commit.");
        return false;
    }
    else
    {
        if (FoundOn == (optNotCommittedReason.rows.length - 1)) // last option (custom reason)
        {
            if (txtNotCommittedReason.value == null || txtNotCommittedReason.value.length == 0)
            {
                ShowMessageNotCommitted("Please enter a custom reason this prospect did not commit.");
                AddBorder(txtNotCommittedReason);
                return false;
            }
            else
            {
                RemoveBorder(txtNotCommittedReason);
                return true;
            }
        }
        else
        {
            RemoveBorder(txtNotCommittedReason);
            return true;
        }
    }
}
function AddBorder(obj)
{
    if (obj != null)
    {
        obj.style.border = "solid 2px red";
        obj.focus();
    }
}
function RemoveBorder(obj)
{
    if (obj != null)
    {
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
    }
}
function lnkBackToEnrollment_OnClick(obj)
{
    if (pnlMenuDefault == null)
        LoadControls();

    pnlMenuDefault.style.display = "inline";
    pnlMenuNotQualified.style.display = "none";
    pnlMenuNotCommitted.style.display = "none";

    pnlBodyDefault.style.display = "inline";
    pnlBodyNotQualified.style.display = "none";
    pnlBodyNotCommitted.style.display = "none";
}
function lnkDoesNotQualify_OnClick(obj)
{
    if (pnlMenuDefault == null)
        LoadControls();

    //autofill values if they can be anticipated
    //if they don't have enough unsecured debt
    if (parseInt(txtTotalUnsecuredDebt.value) < EnrollmentMinimum)
    {
		var opt = document.getElementById("<%=OptNotQualifiedReason.ClientID %>_" + optTooMuchUnsecuredDebt_idx);
		opt.checked=true;
    }
    //if they live in Texas
    var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
    if (parseInt(cboStateID.value) == 45)
    {
		var opt = document.getElementById("<%=OptNotQualifiedReason.ClientID %>_" + optOther_idx);
		var txt = document.getElementById("<%=txtNotQualifiedReason.ClientID %>");
		opt.checked=true;
		txt.value = "Client's state of residence (Texas) is not valid.";
		
    }
    
    pnlMenuDefault.style.display = "none";
    pnlMenuNotQualified.style.display = "inline";
    pnlMenuNotCommitted.style.display = "none";

    pnlBodyDefault.style.display = "none";
    pnlBodyNotQualified.style.display = "inline";
    pnlBodyNotCommitted.style.display = "none";
}
function lnkWouldNotCommit_OnClick(obj)
{
    if (pnlMenuDefault == null)
        LoadControls();

    pnlMenuDefault.style.display = "none";
    pnlMenuNotQualified.style.display = "none";
    pnlMenuNotCommitted.style.display = "inline";

    pnlBodyDefault.style.display = "none";
    pnlBodyNotQualified.style.display = "none";
    pnlBodyNotCommitted.style.display = "inline";
}
function OpenAddNote()
{
    showModalDialog("<%= ResolveUrl("~/addnoteholder.aspx") %>", window, "status:off;help:off;dialogWidth:550px;dialogHeight:350px");
}
function AddNote(Value)
{
    var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

    if (txtNotes.value != null && txtNotes.value.length > 0)
    {
        txtNotes.value += "|--$--|" + Value;
    }
    else
    {
        txtNotes.value = Value;
    }

    ResetNotes();
}
function ClearNotes()
{
    document.getElementById("<%= txtNotes.ClientID %>").value = "";

    ResetNotes();
}
function DeleteNotes()
{
    var tblNotes = document.getElementById("<%= tblNotes.ClientID %>");
    var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

    tblNotes = tblNotes.rows[0].cells[0].childNodes[0];

    var NewValue = "";

    for (i = 1; i < tblNotes.rows.length; i++)
    {
        var txtNote = tblNotes.rows[i].cells[0].childNodes[0];
        var chkNote = tblNotes.rows[i].cells[0].childNodes[1];

        if (!chkNote.checked)
        {
            if (NewValue.length > 0)
            {
                NewValue += "|--$--|" + txtNote.value;
            }
            else
            {
                NewValue = txtNote.value;
            }
        }
    }

    txtNotes.value = NewValue;

    ResetNotes();
}
function ResetNotes()
{
    var tblNotes = document.getElementById("<%= tblNotes.ClientID %>");
    var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

    if (txtNotes.value != null && txtNotes.value.length > 0)
    {
        var Notes = txtNotes.value.split("|--$--|");

        // start table
        var NewTable = "<table style=\"width:100%;font-family:tahoma;font-size:11px;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"
            + "<tr>"
            + "<td class=\"cLEnrollApplicantHeaderItem\" style=\"width:20;\" align=\"center\"><img src=\"<%= ResolveUrl("~/images/11x11_checkall.png") %>\"/></td>"
            + "<td class=\"cLEnrollApplicantHeaderItem\">Note</td>"
            + "</tr>";

        for (i = 0; i < Notes.length; i++)
        {
            var Note = Notes[i];

            if (Note.length > 100)
            {
                Note = Note.substring(0, 100) + "..."
            }

            // add rows to table
            NewTable += "<tr>"
                + "<td class=\"clEnrollApplicantListItem\" style=\"width:20;background-color:rgb(255,255,234);\" align=\"center\"><input type=\"hidden\" value=\"" + Note + "\"/><input type=\"checkbox\"/></td>"
                + "<td class=\"clEnrollApplicantListItem\" style=\"background-color:rgb(255,255,234);\">" + Note + "</td>"
                + "</tr>";
        }

        // finish off table
        NewTable += "</table>";

        tblNotes.rows[0].cells[0].innerHTML = NewTable;

        tblNotes.rows[0].cells[0].style.display = "inline";
        tblNotes.rows[1].cells[0].style.display = "inline";
        tblNotes.rows[2].cells[0].style.display = "none";
    }
    else
    {
        tblNotes.rows[0].cells[0].style.display = "none";
        tblNotes.rows[1].cells[0].style.display = "none";
        tblNotes.rows[2].cells[0].style.display = "inline";
    }
}
function OpenAddApplicant()
{
    showModalDialog("addapplicantholder.aspx", window, "status:off;help:off;dialogWidth:650px;dialogHeight:500px");
}
function AddApplicant(Value)
{
    var txtApplicants = document.getElementById("<%= txtApplicants.ClientID %>");

    if (txtApplicants.value != null && txtApplicants.value.length > 0)
    {
        txtApplicants.value += "$" + Value;
    }
    else
    {
        txtApplicants.value = Value;
    }

    ResetApplicants();
}
function ClearApplicants()
{
    document.getElementById("<%= txtApplicants.ClientID %>").value = "";

    ResetApplicants();
}
function DeleteApplicants()
{
    var tblApplicants = document.getElementById("<%= tblApplicants.ClientID %>");
    var txtApplicants = document.getElementById("<%= txtApplicants.ClientID %>");

    tblApplicants = tblApplicants.rows[0].cells[0].childNodes[0];

    var NewValue = "";

    for (i = 1; i < tblApplicants.rows.length; i++)
    {
        var txtApplicant = tblApplicants.rows[i].cells[0].childNodes[0];
        var chkApplicant = tblApplicants.rows[i].cells[0].childNodes[1];

        if (!chkApplicant.checked)
        {
            if (NewValue.length > 0)
            {
                NewValue += "$" + txtApplicant.value;
           }
           else
           {
                NewValue = txtApplicant.value;
           }
        }
    }

    txtApplicants.value = NewValue;

    ResetApplicants();
}
function ResetApplicants()
{
    var tblApplicants = document.getElementById("<%= tblApplicants.ClientID %>");
    var txtApplicants = document.getElementById("<%= txtApplicants.ClientID %>");

    if (txtApplicants.value != null && txtApplicants.value.length > 0)
    {
        var Applicants = txtApplicants.value.split("$");

        // start table
        var NewTable = "<table style=\"width:100%;font-family:tahoma;font-size:11px;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"
            + "<tr>"
            + "<td class=\"cLEnrollApplicantHeaderItem\" style=\"width:20;\" align=\"center\"><img src=\"<%= ResolveUrl("~/images/11x11_checkall.png") %>\"/></td>"
            + "<td class=\"cLEnrollApplicantHeaderItem\" align=\"center\">Type</td>"
            + "<td class=\"cLEnrollApplicantHeaderItem\">Name</td>"
            + "</tr>";

        for (i = 0; i < Applicants.length; i++)
        {
            var Parts = Applicants[i].split("|");

            var FirstName = Parts[0];
            var LastName = Parts[1];
            var Type = Parts[25];

            // add rows to table
            NewTable += "<tr>"
                + "<td class=\"clEnrollApplicantListItem\" style=\"width:20;\" align=\"center\"><input type=\"hidden\" value=\"" + Applicants[i] + "\"/><input type=\"checkbox\"/></td>"
                + "<td class=\"clEnrollApplicantListItem\" align=\"center\">" + Type + "</td>"
                + "<td class=\"clEnrollApplicantListItem\">" + FirstName + " " + LastName + "</td>"
                + "</tr>";
        }

        // finish off table
        NewTable += "</table>";

        tblApplicants.rows[0].cells[0].innerHTML = NewTable;

        tblApplicants.rows[0].cells[0].style.display = "inline";
        tblApplicants.rows[1].cells[0].style.display = "inline";
        tblApplicants.rows[2].cells[0].style.display = "none";
    }
    else
    {
        tblApplicants.rows[0].cells[0].style.display = "none";
        tblApplicants.rows[1].cells[0].style.display = "none";
        tblApplicants.rows[2].cells[0].style.display = "inline";
    }
}
function GetAge(BirthDate)
{
    var dtAsOfDate;
    var dtBirth;
    var dtAnniversary;
    var intSpan;
    var intYears;

    // get born date
    dtBirth = new Date(BirthDate);

    // get as of date
    dtAsOfDate = new Date();

    // if as of date is on or after born date
    if ( dtAsOfDate >= dtBirth )
      {

      // get time span between as of time and birth time
      intSpan = ( dtAsOfDate.getUTCHours() * 3600000 +
                  dtAsOfDate.getUTCMinutes() * 60000 +
                  dtAsOfDate.getUTCSeconds() * 1000    ) -
                ( dtBirth.getUTCHours() * 3600000 +
                  dtBirth.getUTCMinutes() * 60000 +
                  dtBirth.getUTCSeconds() * 1000       )

      // start at as of date and look backwards for anniversary 

      // if as of day (date) is after birth day (date) or
      //    as of day (date) is birth day (date) and
      //    as of time is on or after birth time
      if ( dtAsOfDate.getUTCDate() > dtBirth.getUTCDate() ||
           ( dtAsOfDate.getUTCDate() == dtBirth.getUTCDate() && intSpan >= 0 ) )
         {

         // most recent day (date) anniversary is in as of month
         dtAnniversary = 
            new Date( Date.UTC( dtAsOfDate.getUTCFullYear(),
                                dtAsOfDate.getUTCMonth(),
                                dtBirth.getUTCDate(),
                                dtBirth.getUTCHours(),
                                dtBirth.getUTCMinutes(),
                                dtBirth.getUTCSeconds() ) );

         }

      // if as of day (date) is before birth day (date) or
      //    as of day (date) is birth day (date) and
      //    as of time is before birth time
      else
         {

         // most recent day (date) anniversary is in month before as of month
         dtAnniversary = 
            new Date( Date.UTC( dtAsOfDate.getUTCFullYear(),
                                dtAsOfDate.getUTCMonth() - 1,
                                dtBirth.getUTCDate(),
                                dtBirth.getUTCHours(),
                                dtBirth.getUTCMinutes(),
                                dtBirth.getUTCSeconds() ) );

         // get previous month
         intMonths = dtAsOfDate.getUTCMonth() - 1;
         if ( intMonths == -1 )
            intMonths = 11;

         // while month is not what it is supposed to be (it will be higher)
         while ( dtAnniversary.getUTCMonth() != intMonths )

            // move back one day
            dtAnniversary.setUTCDate( dtAnniversary.getUTCDate() - 1 );

         }

      // if anniversary month is on or after birth month
      if ( dtAnniversary.getUTCMonth() >= dtBirth.getUTCMonth() )
         {

         // months elapsed is anniversary month - birth month
         intMonths = dtAnniversary.getUTCMonth() - dtBirth.getUTCMonth();

         // years elapsed is anniversary year - birth year
         intYears = dtAnniversary.getUTCFullYear() - dtBirth.getUTCFullYear();

         }

        else
        {
            intYears = (dtAnniversary.getUTCFullYear() - 1) - dtBirth.getUTCFullYear();
        }

        return intYears;
    }
    else
    {
        return 0;
    }
}
function txtTotalMonthlyPayment_OnKeyUp(obj)
{
    if (obj.value != null && obj.value.length > 0)
    {
        TotalMonthlyPayment = parseFloat(obj.value);
    }
    else
    {
        TotalMonthlyPayment = 0.0;
    }

    Reset(obj);
}
function txtTotalUnsecuredDebt_OnKeyUp(obj)
{
    if (obj.value != null && obj.value.length > 0)
    {
        TotalUnsecuredDebt = parseFloat(obj.value);
    }
    else
    {
        TotalUnsecuredDebt = 0.0;
    }

    BalanceAtEnrollment = TotalUnsecuredDebt;

    //adjust initial total for future total (counting inflation)
    BalanceAtSettlement = BalanceAtEnrollment + (BalanceAtEnrollment * EnrollmentInflation);

    //setup minimum deposit commitment
    if ((EnrollmentDepositPercentage * TotalUnsecuredDebt) > EnrollmentDepositMinimum)
    {
        DepositCommitment = EnrollmentDepositPercentage * TotalUnsecuredDebt;
    }
    else
    {
        DepositCommitment = EnrollmentDepositMinimum;
    }

    Reset(obj);
}
function txtDepositCommitment_OnKeyUp(obj)
{
    DepositCommitment = parseFloat(obj.value);

    Reset(obj);
}
function LoadControls()
{
    if (txtTotalMonthlyPayment == null)
    {
        txtTotalMonthlyPayment = document.getElementById("<%= txtTotalMonthlyPayment.ClientID %>");
        txtTotalUnsecuredDebt = document.getElementById("<%= txtTotalUnsecuredDebt.ClientID %>");
        lblEstimatedEndAmount = document.getElementById("<%= lblEstimatedEndAmount.ClientID %>");
        txtEstimatedEndAmount = document.getElementById("<%= txtEstimatedEndAmount.ClientID %>");
        lblEstimatedEndTime = document.getElementById("<%= lblEstimatedEndTime.ClientID %>");
        txtEstimatedEndTime = document.getElementById("<%= txtEstimatedEndTime.ClientID %>");
        txtDepositCommitment = document.getElementById("<%= txtDepositCommitment.ClientID %>");
        lblBalanceAtEnrollment = document.getElementById("<%= lblBalanceAtEnrollment.ClientID %>");
        txtBalanceAtEnrollment = document.getElementById("<%= txtBalanceAtEnrollment.ClientID %>");
        lblBalanceAtSettlement = document.getElementById("<%= lblBalanceAtSettlement.ClientID %>");
        txtBalanceAtSettlement = document.getElementById("<%= txtBalanceAtSettlement.ClientID %>");
        tblPlanOptions = document.getElementById("<%= tblPlanOptions.ClientID %>");
        txtApplicants = document.getElementById("<%= txtApplicants.ClientID %>");
        pnlMenuDefault = document.getElementById("<%= pnlMenuDefault.ClientID %>");
        pnlMenuNotQualified = document.getElementById("<%= pnlMenuNotQualified.ClientID %>");
        pnlMenuNotCommitted = document.getElementById("<%= pnlMenuNotCommitted.ClientID %>");
        pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
        pnlBodyNotQualified = document.getElementById("<%= pnlBodyNotQualified.ClientID %>");
        pnlBodyNotCommitted = document.getElementById("<%= pnlBodyNotCommitted.ClientID %>");
    }
}
function Reset(obj)
{
    SetEstimates(); // estimates - on their own plan

    LoadControls();

    if (txtTotalMonthlyPayment != obj)
        txtTotalMonthlyPayment.value = RoundOff(TotalMonthlyPayment);

    if (txtTotalUnsecuredDebt != obj)
        txtTotalUnsecuredDebt.value = RoundOff(TotalUnsecuredDebt);

    if (txtDepositCommitment != obj)
        txtDepositCommitment.value = RoundOff(DepositCommitment);

    lblBalanceAtEnrollment.innerHTML = "$ " + FormatNumber(BalanceAtEnrollment, true, 2);
    txtBalanceAtEnrollment.value = BalanceAtEnrollment;
    lblBalanceAtSettlement.innerHTML = "$ " + FormatNumber(BalanceAtSettlement, true, 2);
    txtBalanceAtSettlement.value = BalanceAtSettlement;
    lblEstimatedEndAmount.innerHTML = "$ " + FormatNumber(EstimatedEndAmount, true, 2);
    txtEstimatedEndAmount.value = EstimatedEndAmount;
    lblEstimatedEndTime.innerHTML = MonthsToYears(EstimatedEndTime);
    txtEstimatedEndTime.value = EstimatedEndTime;

    // set the debt options
    var Options = (tblPlanOptions.rows[0].cells.length - 3);

    for (i = 0; i < Options; i++)
    {
        var Percentage = parseFloat(tblPlanOptions.rows[0].cells[i + 2].childNodes[0].value);
        var txtEstimatedTotalPaid = tblPlanOptions.rows[1].cells[i + 2];
        var txtEstimatedEnrollmentFee = tblPlanOptions.rows[2].cells[i + 2];
        var txtEstimatedMaintenanceFee = tblPlanOptions.rows[3].cells[i + 2];
        var txtEstimatedSettlementFee = tblPlanOptions.rows[4].cells[i + 2];
        var txtEstimatedPlanCost = tblPlanOptions.rows[5].cells[i + 2];
        var txtEstimatedDebtFree = tblPlanOptions.rows[6].cells[i + 2];
        var txtEstimatedSavings = tblPlanOptions.rows[7].cells[i + 2];

        var EstimatedTotalPaid = BalanceAtSettlement * Percentage;
        var EstimatedEnrollmentFee = BalanceAtEnrollment * EnrollmentRetainerPercentage;
        var EstimatedSettlementFee = (BalanceAtSettlement - (BalanceAtSettlement * Percentage)) * EnrollmentSettlementPercentage;
        var EstimatedDebtFree = Math.round((EstimatedTotalPaid + EstimatedEnrollmentFee + EstimatedSettlementFee) / (DepositCommitment - EnrollmentMonthlyFee));
        var EstimatedMaintenanceFee = (EnrollmentMonthlyFee * EstimatedDebtFree);
        var EstimatedPlanCost = EstimatedTotalPaid + EstimatedEnrollmentFee + EstimatedSettlementFee + EstimatedMaintenanceFee;

        txtEstimatedTotalPaid.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedTotalPaid);
        txtEstimatedEnrollmentFee.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedEnrollmentFee);
        txtEstimatedSettlementFee.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedSettlementFee);
        txtEstimatedDebtFree.innerHTML = MonthsToYears(EstimatedDebtFree);
        txtEstimatedMaintenanceFee.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedMaintenanceFee);
        txtEstimatedPlanCost.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedPlanCost);
        txtEstimatedSavings.innerHTML = "$" + CurrencyAndCommaFormat(EstimatedEndAmount - EstimatedPlanCost);
    }
}
function SetEstimates()
{
    var newBal = TotalUnsecuredDebt;
    var MPR = parseFloat(EnrollmentPBMAPR / 12).toFixed(6);

    var mip = 0;
    var payment = 0.0;
    var sumpayment = 0.0;

    while (newBal > 0)
    {
        //if (TotalMonthlyPayment < (newBal * EnrollmentPBMPercentage))
        //{
        if (newBal < EnrollmentPBMMinimum)
        {
            payment = newBal;
        }
        else
        {
            if ((newBal * EnrollmentPBMPercentage) <= EnrollmentPBMMinimum)
            {
                if (newBal < EnrollmentPBMMinimum)
                    payment = newBal;
                else
                    payment = EnrollmentPBMMinimum;
            }
            else
            {
                payment = newBal * EnrollmentPBMPercentage;
            }
        }

        //newBal += newBal * MPR;
        //}
        //else
        //{
        //    if (newBal < TotalMonthlyPayment)
        //        payment = newBal;
        //    else
        //        payment = TotalMonthlyPayment;
        //}

        if (newBal < EnrollmentPBMMinimum) //last payment, last month
        {
            payment += newBal * MPR;
            sumpayment += payment;
            newBal -= payment;
        }
        else
        {
            sumpayment += payment;
            newBal = ((newBal + (newBal * MPR)) - payment);
        }

        mip += 1;
    }

    EstimatedEndAmount = sumpayment;
    EstimatedEndTime = mip;
}
function RoundOff(Value)
{
    return Math.round(Value * 100) / 100;
}
function MonthsToYears(Value)
{
    return Math.floor(Value / 12) + " yrs " + Math.round(Value % 12) + " mo";
}
function CurrencyFormat(Amount)
{
	var i = parseFloat(Amount);
	if(isNaN(i)) { i = 0.00; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	i = parseInt((i + .005) * 100);
	i = i / 100;
	s = new String(i);
	if(s.indexOf('.') < 0) { s += '.00'; }
	if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
	s = minus + s;
	return s;
}
function CommaFormat(Amount)
{
	var delimiter = ","; // replace comma if desired
	var a = Amount.split('.',2)
	var d = a[1];
	var i = parseInt(a[0]);
	if(isNaN(i)) { return ''; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	var n = new String(i);
	var a = [];
	while(n.length > 3)
	{
		var nn = n.substr(n.length-3);
		a.unshift(nn);
		n = n.substr(0,n.length-3);
	}
	if(n.length > 0) { a.unshift(n); }
	n = a.join(delimiter);
	if(d.length < 1) { Amount = n; }
	else { Amount = n + '.' + d; }
	Amount = minus + Amount;
	return Amount;
}
function CurrencyAndCommaFormat(Amount)
{
    return CommaFormat(CurrencyFormat(Amount));
}

</script>

<body onload="SetFocus('<%= Me.txtName.ClientID %>');">
<ajaxToolkit:ToolkitScriptManager ID="smScreen" runat="server" />
    <asp:Panel runat="server" ID="pnlBodyDefault">
        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top">
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td valign="top" style="width: 22%;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="cLEnrollHeader">
                                            1. Setup</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 10 10 10 10;">
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                cellspacing="3" border="0">
                                                <tr>
                                                    <td style="width: 50;">
                                                        Name:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="1" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtName"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Phone:</td>
                                                    <td>
                                                        <cc1:InputMask TabIndex="2" Mask="(xxx) xxx-xxxx" Width="100%" Font-Names="tahoma" Font-Size="11px"
                                                            ID="txtPhone" runat="server"></cc1:InputMask></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Zip Code:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="3" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtZipCode2"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Behind:</td>
                                                    <td>
                                                        <asp:DropDownList TabIndex="4" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                            ID="cboBehindID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Concern:</td>
                                                    <td><asp:DropDownList TabIndex="5" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                            ID="cboConcernID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Agency:</td>
                                                    <td>
                                                        <asp:DropDownList TabIndex="6" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                            ID="cboAgencyID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Company:</td>
                                                    <td>
                                                        <asp:DropDownList TabIndex="7" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                            ID="cboCompanyID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Trust:</td>
                                                    <td>
                                                        <asp:DropDownList TabIndex="7" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                            ID="cboTrustID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;"><img width="50" height="15" runat="server" src="~/images/spacer.gif" /></td>
                                                    <td><img width="100" height="15" runat="server" src="~/images/spacer.gif" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="cLEnrollHeader">Follow-Up Appointment</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 10 10 10 10;">
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                cellspacing="3" border="0">
                                                <tr>
                                                    <td style="height:17;width: 50;">Current:</td>
                                                    <td><asp:Label style="color:rgb(0,0,210);" runat="server" ID="lblAppointmentTime"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td style="width:50;">Date:</td>
                                                    <td><cc1:InputMask TabIndex="25" Mask="nn/nn/nnnn nn:nn aa" Width="100%" Font-Names="tahoma" Font-Size="11px" ID="imAppointmentDate" runat="server"></cc1:InputMask></td>
                                                </tr>
                                                <tr>
                                                    <td style="width:50;">Days:</td>
                                                    <td><asp:TextBox TabIndex="26" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtAppointmentDays"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;"><img width="50" height="15" runat="server" src="~/images/spacer.gif" /></td>
                                                    <td><img width="100" height="15" runat="server" src="~/images/spacer.gif" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="cLEnrollHeader">Notes</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table runat="server" id="tblNotes" style="width: 100%; font-family: tahoma; font-size: 11px;"
                                                cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="display: none;">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="display: none; padding-top: 5px;" align="center">
                                                        <a href="#" onclick="ClearNotes();return false;" class="lnk" style="color: rgb(0,0,159);">
                                                            Clear All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="#" onclick="DeleteNotes();return false;"
                                                                class="lnk" style="color: rgb(0,0,159);">Delete Selected</a></td>
                                                </tr>
                                                <tr>
                                                    <td align="center" style="padding-top: 10px; color: #a1a1a1">
                                                        No notes have been entered</td>
                                                </tr>
                                            </table>
                                            <input runat="server" id="txtNotes" type="hidden" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="cLEnrollSplitter"><img width="40" height="1" src="~/images/spacer.gif" runat="server" /></td>
                            <td valign="top" style="width: 55%;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="cLEnrollHeader">
                                            2. Calculator</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 10 10 0 10;">
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                cellspacing="0" border="0">
                                                <tr>
                                                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">
                                                        Debt path comparison</td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5 10 10 10;">
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                            cellspacing="3" border="0">
                                                            <tr>
                                                                <td style="width: 15;" align="center">
                                                                    1.</td>
                                                                <td style="width: 130" nowrap="true">
                                                                    Current monthly payment:</td>
                                                                <td style="width: 70;">
                                                                    $&nbsp;<asp:TextBox TabIndex="8" MaxLength="10" Width="60" Font-Names="Tahoma" Font-Size="11px"
                                                                        runat="server" ID="txtTotalMonthlyPayment"></asp:TextBox>
                                                                        
                                                                        <ajaxToolkit:FilteredTextBoxExtender ID="ftbeMonthlyPayment" runat="server" ValidChars="0123456789,." 
                                                                         TargetControlID="txtTotalMonthlyPayment"/>
                                                                        </td>
                                                                <td style="padding-left: 15px; width: 115;" nowrap="true">
                                                                    5. Deposit commitment:</td>
                                                                <td style="width: 70;">
                                                                    $&nbsp;<asp:TextBox TabIndex="10" Width="60" Font-Names="Tahoma" Font-Size="11px" runat="server"
                                                                        ID="txtDepositCommitment"></asp:TextBox>
                                                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" ValidChars="0123456789,." 
                                                                         TargetControlID="txtDepositCommitment"/></td>
                                                                <td>
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center">
                                                                    2.</td>
                                                                <td style="width: 130" nowrap="true">
                                                                    Total owed to creditors:</td>
                                                                <td style="width: 70;">
                                                                    $&nbsp;<asp:TextBox TabIndex="9" MaxLength="10" Width="60" Font-Names="Tahoma" Font-Size="11px"
                                                                        runat="server" ID="txtTotalUnsecuredDebt"></asp:TextBox>
                                                                         <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" ValidChars="0123456789,." 
                                                                         TargetControlID="txtTotalUnsecuredDebt"/></td>
                                                                <td style="padding-left: 15px; width: 115;" nowrap="true">
                                                                    6. Balance at screening:</td>
                                                                <td style="width: 70;">
                                                                    <span runat="server" id="lblBalanceAtEnrollment">$ 0.00</span><input type="hidden" runat="server" id="txtBalanceAtEnrollment" /></td>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;padding:3 0 3 0" align="center">
                                                                    3.</td>
                                                                <td style="width: 130" nowrap="true">
                                                                    Estimated total paid:</td>
                                                                <td nowrap="nowrap" style="width: 70; color: red;"><span runat="server" id="lblEstimatedEndAmount">$ 0.00</span><input type="hidden" runat="server" id="txtEstimatedEndAmount" /></td>
                                                                <td style="padding-left: 15px; width: 115;" nowrap="true">7. Settlement balance:</td>
                                                                <td style="width: 70;">
                                                                    <span runat="server" id="lblBalanceAtSettlement">$ 0.00</span><input type="hidden" runat="server" id="txtBalanceAtSettlement" /></td>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15; padding:3 0 3 0;" align="center">
                                                                    4.</td>
                                                                <td style="width: 130;" nowrap="true">
                                                                    Estimated debt free in:</td>
                                                                <td nowrap="nowrap" style="width: 70; padding-top: 3px; padding-bottom: 3px; color: red;"><span runat="server" id="lblEstimatedEndTime">0 yrs 0 mo</span><input type="hidden" runat="server" id="txtEstimatedEndTime" /></td>
                                                                <td style="padding-left: 15px; width: 115;">&nbsp;</td>
                                                                <td style="width: 70;">&nbsp;</td>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">
                                                        Our settlement services options</td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 0 10 0 10;">
                                                        <table runat="server" id="tblPlanOptions" style="border-collapse: collapse; : 100%;
                                                            font-family: tahoma; font-size: 11px;" cellpadding="5" cellspacing="0" border="0">
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trEnrollmentDisclosure">
                                                    <td align="center" style="padding-top:20;"><asp:Label runat="server" ID="lblEnrollmentDisclosure"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="cLEnrollSplitter"><img width="40" height="1" src="~/images/spacer.gif" runat="server" /></td>
                            <td valign="top" style="width: 23%;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="cLEnrollHeader">3. Primary</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 10 10 10 10;">
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                                                <tr>
                                                    <td style="width: 60;">
                                                        First / Last:</td>
                                                    <td>
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="width:50%;padding-right:6;"><asp:TextBox TabIndex="11" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtFirstName"></asp:TextBox></td>
                                                                <td style="width:50%;"><asp:TextBox TabIndex="12" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtLastName"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">Spouse:</td>
                                                    <td>
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="width:50%;padding-right:6;"><asp:TextBox TabIndex="13" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtFirstNameSpouse"></asp:TextBox></td>
                                                                <td style="width:50%;"><asp:TextBox TabIndex="14" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtLastNameSpouse"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        Street 1:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="15" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtStreet"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        Street 2:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="16" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtStreet2"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        City:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="18" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtCity"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        State / Zip:</td>
                                                    <td>
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="width:40;"><asp:DropDownList TabIndex="19" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="cboStateID"></asp:DropDownList></td>
                                                                <td style="padding-left:6;"><asp:TextBox TabIndex="17" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtZipCode"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Home Ph:</td>
                                                    <td>
                                                        <cc1:InputMask TabIndex="20" Mask="(xxx) xxx-xxxx" Width="100%" Font-Names="tahoma" Font-Size="11px"
                                                            ID="txtHomePhone" runat="server"></cc1:InputMask></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Busin. Ph:</td>
                                                    <td><cc1:InputMask TabIndex="21" Mask="(xxx) xxx-xxxx" Width="100%" Font-Names="tahoma" Font-Size="11px"
                                                            ID="txtBusinessPhone" runat="server"></cc1:InputMask></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">Language:</td>
                                                    <td><asp:DropDownList TabIndex="22" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server" ID="cboLanguageID"></asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        Email:</td>
                                                    <td>
                                                        <asp:TextBox TabIndex="23" MaxLength="50" Width="100%" Font-Names="tahoma" Font-Size="11px" runat="server"
                                                            ID="txtEmailAddress"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;">
                                                        Delivery:</td>
                                                    <td>
                                                        <asp:DropDownList TabIndex="24" Width="100%" Font-Names="Tahoma" Font-Size="11px" runat="server" ID="cboDeliveryMethod">
                                                            <asp:ListItem Value="MAIL" Text="By US Mail" Selected="true"></asp:ListItem>
                                                            <asp:ListItem Value="FAX" Text="By Fax Machine"></asp:ListItem>
                                                            <asp:ListItem Value="EMAIL" Text="By Email Message"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 60;"><img width="60" height="15" runat="server" src="~/images/spacer.gif" runat="server" /></td>
                                                    <td><img width="100" height="15" runat="server" src="~/images/spacer.gif" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="cLEnrollHeader">4. Co-Applicants</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table runat="server" id="tblApplicants" style="width: 100%; font-family: tahoma;
                                                font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="display: none;">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="display: none; padding-top: 5px;" align="center">
                                                        <a href="#" onclick="ClearApplicants();return false;" class="lnk" style="color: rgb(0,0,159);">
                                                            Clear All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="#" onclick="DeleteApplicants();return false;"
                                                                class="lnk" style="color: rgb(0,0,159);">Delete Selected</a></td>
                                                </tr>
                                                <tr>
                                                    <td align="center" style="padding-top: 10px; color: #a1a1a1">
                                                        No co-applicants have been entered</td>
                                                </tr>
                                            </table>
                                            <input runat="server" id="txtApplicants" type="hidden" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyNotQualified" Style="display: none;">
        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" align="center">
                    <table cellpadding="0" cellspacing="0" border="0" style="font-family:Tahoma;font-size:11px">
                        <tr>
                            <td>
                            <div runat="server" id="dvErrorNotQualified" style="display: none;">
                                <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                    width="100%" border="0">
                                    <tr>
                                        <td valign="top" width="20">
                                            <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                        <td runat="server" id="tdErrorNotQualified">
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="cLEnrollHeader">
                                Why did this prospect not pass screening?</td>
                        </tr>
                        <tr>
                            <td style="padding: 10 10 5 10;">
                                <asp:RadioButtonList Font-Names="tahoma" Font-Size="11px" ID="optNotQualifiedReason" runat="server">
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 10 0 40;">Reason: <asp:TextBox Width="200px" MaxLength="255" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtNotQualifiedReason"></asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyNotCommitted" Style="display: none;">
        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" align="center">
                    <table cellpadding="0" cellspacing="0" border="0" style="font-family:Tahoma;font-size:11px">
                        <tr>
                            <td>
                            <div runat="server" id="dvErrorNotCommitted" style="display: none;">
                                <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                    width="100%" border="0">
                                    <tr>
                                        <td valign="top" width="20">
                                            <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                        <td runat="server" id="tdErrorNotCommitted">
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="cLEnrollHeader">
                                Why would this prospect not commit?</td>
                        </tr>
                        <tr>
                            <td style="padding: 10 10 5 10;">
                                <asp:RadioButtonList Font-Names="tahoma" Font-Size="11px" ID="optNotCommittedReason" runat="server">
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0 10 0 40;">Reason: <asp:TextBox Width="200px" MaxLength="255" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtNotCommittedReason"></asp:TextBox></td>
                        </tr>
                    </table>
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

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveNotQualified"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveNotCommitted"></asp:LinkButton>

</body>

</asp:Panel></asp:Content>