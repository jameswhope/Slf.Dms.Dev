<%@ Control Language="VB" AutoEventWireup="false" CodeFile="29.ascx.vb" Inherits="tasks_workflows_3" %>
<%@ Reference Page="~/tasks/task/resolve.aspx"   %>
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">

var txtResolved = null;
var cboTaskResolutionID = null;
var txtNotes = null;
var txtPropagations = null;
var txtParentResolved = null;
var cboParentTaskResolutionID = null;
var txtParentNotes = null;
var txtParentPropagations = null;
var dvError = null;
var tdError = null;

var txtSetupFee = null;
var txtSetupFeePercentage = null;
var txtSettlementFeePercentage = null;
var txtAdditionalAccountFee = null;
var txtReturnedCheckFee = null;
var txtOvernightDeliveryFee = null;

var cboTrustID = null;
var txtTrustID = null;
var txtAccountNumber = null;

var cbos = new Array();

function cboTrustID_OnChange(cbo)
{
    if (cbo.selectedIndex == 0) // they picked the < Add New Item > option
    {
        // load all controls
        LoadControls();

         var url = '<%= ResolveUrl("~/util/pop/addtrust.aspx") %>';
         window.dialogArguments = new Array(window, cbos, cbo);
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Trust",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 450, width: 550});
        }
    else
    {
        // if not adding, save this selectedIndex
        cbo.lastIndex = cbo.selectedIndex;
    }
}
function Record_Save()
{
    LoadControls();

    if (RequiredExist())
    {
        // fill values from task page to post back with
        txtResolved.value = txtParentResolved.value;
        cboTaskResolutionID.selectedIndex = cboParentTaskResolutionID.selectedIndex;
        txtNotes.value = txtParentNotes.value;
        txtPropagations.value = txtParentPropagations.value;

        // save cboTrustID into txtTrustID for postback
        txtTrustID.value = cboTrustID.options[cboTrustID.selectedIndex].value;

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function LoadControls()
{
    if (txtResolved == null)
    {

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
    RemoveBorder(txtParentResolved);
    RemoveBorder(cboParentTaskResolutionID);

    RemoveBorder(txtSetupFee);
    RemoveBorder(txtSetupFeePercentage);
    RemoveBorder(txtSettlementFeePercentage);
    RemoveBorder(txtAdditionalAccountFee);
    RemoveBorder(txtReturnedCheckFee);
    RemoveBorder(txtOvernightDeliveryFee);

    RemoveBorder(cboTrustID);
    RemoveBorder(txtAccountNumber);

    if (txtParentResolved.value == null || txtParentResolved.value.length == 0)
    {
        ShowMessage("The Resolve Date is a required field");
        AddBorder(txtParentResolved);
        return false;
    }
    else if (!RegexValidate(txtParentResolved.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
    {
        ShowMessage("The Resolve Date you entered is invalid.  Please enter a new value.");
        AddBorder(txtParentResolved);
        return false;
    }
    else
    {
        RemoveBorder(txtParentResolved);
    }

    // txtSetupFee
    if (txtSetupFee.value.length == 0)
    {
        ShowMessage("The Setup Fee is a required field.");
        AddBorder(txtSetupFee);
        return false;
    }
    else
    {
        var Value = new String(txtSetupFee.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtSetupFee);
            return false;
        }
        else
        {
            txtSetupFee.value = parseFloat(Value);
            RemoveBorder(txtSetupFee);
        }
    }

    // txtSetupFeePercentage
    if (txtSetupFeePercentage.value.length == 0)
    {
        ShowMessage("The Setup Fee Percentage is a required field.");
        AddBorder(txtSetupFeePercentage);
        return false;
    }
    else
    {
        var Value = new String(txtSetupFeePercentage.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtSetupFeePercentage);
            return false;
        }
        else
        {
            txtSetupFeePercentage.value = parseFloat(Value);
            RemoveBorder(txtSetupFeePercentage);
        }
    }

    // txtSettlementFeePercentage
    if (txtSettlementFeePercentage.value.length == 0)
    {
        ShowMessage("The Settlement Fee Percentage is a required field.");
        AddBorder(txtSettlementFeePercentage);
        return false;
    }
    else
    {
        var Value = new String(txtSettlementFeePercentage.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtSettlementFeePercentage);
            return false;
        }
        else
        {
            txtSettlementFeePercentage.value = parseFloat(Value);
            RemoveBorder(txtSettlementFeePercentage);
        }
    }

    // txtAdditionalAccountFee
    if (txtAdditionalAccountFee.value.length == 0)
    {
        ShowMessage("The Additional Account Fee is a required field.");
        AddBorder(txtAdditionalAccountFee);
        return false;
    }
    else
    {
        var Value = new String(txtAdditionalAccountFee.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtAdditionalAccountFee);
            return false;
        }
        else
        {
            txtAdditionalAccountFee.value = parseFloat(Value);
            RemoveBorder(txtAdditionalAccountFee);
        }
    }

    // txtReturnedCheckFee
    if (txtReturnedCheckFee.value.length == 0)
    {
        ShowMessage("The Returned Check Fee is a required field.");
        AddBorder(txtReturnedCheckFee);
        return false;
    }
    else
    {
        var Value = new String(txtReturnedCheckFee.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtReturnedCheckFee);
            return false;
        }
        else
        {
            txtReturnedCheckFee.value = parseFloat(Value);
            RemoveBorder(txtReturnedCheckFee);
        }
    }

    // txtOvernightDeliveryFee
    if (txtOvernightDeliveryFee.value.length == 0)
    {
        ShowMessage("The Overnight Delivery Fee is a required field.");
        AddBorder(txtOvernightDeliveryFee);
        return false;
    }
    else
    {
        var Value = new String(txtOvernightDeliveryFee.value);

        if (isNaN(parseFloat(Value)) || parseFloat(Value) <= 0)
        {
            ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
            AddBorder(txtOvernightDeliveryFee);
            return false;
        }
        else
        {
            txtOvernightDeliveryFee.value = parseFloat(Value);
            RemoveBorder(txtOvernightDeliveryFee);
        }
    }

    // cboTrustID
    if (cboTrustID.selectedIndex == -1 || cboTrustID.options[cboTrustID.selectedIndex].value == 0)
    {
        ShowMessage("The Account Location is a required field.");
        AddBorder(cboTrustID);
        return false;
    }
    else
    {
        RemoveBorder(cboTrustID);
    }

    // txtAccountNumber
    if (txtAccountNumber.value.length == 0)
    {
        ShowMessage("The Account Number is a required field.");
        AddBorder(txtAccountNumber);
        return false;
    }
    else
    {
        RemoveBorder(txtAccountNumber);
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

</script>

<br />PREJUDGMENT CLIENT INTAKE<br /><br />

<table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">


   <tr>
        <td style="width:150;">Date:</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtDate"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Firm:</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox2"></asp:TextBox></td>
        <td>&nbsp;</td>
    </tr>
       <tr>
        <td style="width:150;">Account Number</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox1"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Client Name:</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox3"></asp:TextBox></td>
        <td>&nbsp;</td>
    
      </tr>
       <tr>
        <td style="width:150;">Address</td>
        <td style="width:15;" align="center"></td>
        <td colspan="2" style="width:270;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox4"></asp:TextBox></td>
        
        <td>&nbsp;</td>
    <tr>
        <td style="width:150;">Phone</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox5"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Email:</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox6"></asp:TextBox></td>
        <td>&nbsp;</td>
    
      </tr>
       <tr>
        <td style="width:150;">Litigation Document</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox7"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Ammount:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox8"></asp:TextBox></td>
        <td>&nbsp;</td>
    
      </tr>
      <tr>
        <td style="width:150;">Date Client Received Document</td>
        <td style="width:15;" align="center"></td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox9"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">How doc received:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="TextBox10"></asp:TextBox></td>
        <td>&nbsp;</td>
    
      </tr>
   <%-- <tr>
        <td style="width:150;">Setup fee:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtSetupFee"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Additional account fee:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtAdditionalAccountFee"></asp:TextBox></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td style="width:150;">Setup fee percentage:</td>
        <td style="width:15;" align="center">%</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtSetupFeePercentage"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Returned check fee:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtReturnedCheckFee"></asp:TextBox></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td style="width:150;">Settlement fee percentage:</td>
        <td style="width:15;" align="center">%</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtSettlementFeePercentage"></asp:TextBox></td>
        <td style="width:120;padding-left:15;">Overnight delivery fee:</td>
        <td style="width:15;" align="center">$</td>
        <td style="width:50;"><asp:TextBox style="text-align:right;" class="entry" runat="server" ID="txtOvernightDeliveryFee"></asp:TextBox></td>
        <td>&nbsp;</td>
    </tr>--%>
</table>
<%--<br /><br />2. Setup this client's account:<br /><br />
<table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td style="width:165;">Bank location of account:</td>
        <td style="width:250;"><asp:DropDownList CssClass="entry" runat="server" ID="cboTrustID"></asp:DropDownList><asp:HiddenField runat="server" id="txtTrustID"></asp:HiddenField></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td style="width:165;padding-top:3;">New virtual account number:</td>
        <td style="width:250;padding-top:3;"><asp:TextBox CssClass="entry" runat="server" ID="txtAccountNumber"></asp:TextBox></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td style="width:165;padding-top:3;">&nbsp;</td>
        <td style="width:250;padding-top:8;padding-left:10;"><asp:CheckBox runat="server" id="chkInsertSetupFee" Text="Collect setup fee" /></td>
        <td>&nbsp;</td>
    </tr>
</table>
--%>
<!-- The following controls are only on the page so that the client script (above)
        can fill these controls with values to be post backed with the form.  They have no inner 
        value so they will not be visibly displayed on the page -->

<asp:HiddenField runat="server" ID="txtNotes" />
<asp:HiddenField runat="server" ID="txtPropagations" />
<asp:HiddenField runat="server" ID="txtResolved" />
<asp:DropDownList runat="server" ID="cboTaskResolutionID" style="display:none;"></asp:DropDownList>

<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->

<asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>