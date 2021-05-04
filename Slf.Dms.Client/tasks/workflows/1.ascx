<%@ Control Language="VB" AutoEventWireup="false" CodeFile="1.ascx.vb" Inherits="tasks_workflows_1" %>
<%@ Reference Page="~/tasks/task/resolve.aspx"   %>

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

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function LoadControls()
{
    if (txtResolved == null)
    {
        txtResolved = document.getElementById("<%= txtResolved.ClientID %>");
        cboTaskResolutionID = document.getElementById("<%= cboTaskResolutionID.ClientID %>");
        txtNotes = document.getElementById("<%= txtNotes.ClientID %>");
        txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
        txtParentResolved = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_txtResolved.ClientID %>");
        cboParentTaskResolutionID = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_cboTaskResolutionID.ClientID %>");
        txtParentNotes = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_txtNotes.ClientID %>");
        txtParentPropagations = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_txtPropagations.ClientID %>");
        dvError = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_dvError.ClientID %>");
        tdError = document.getElementById("<%= CType(Page, tasks_task_resolve).Control_tdError.ClientID %>");
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

Follow the steps below in order.
<ul>
    <li>
        Create a new Legal Service Agreement (LSA) from the standard DMS template file.
    <li>
        Fill in the LSA with the correct state and service information for this client.
    <li>
        Email, fax or mail the LSA to the client depending on their delivery preference.
    <li>
        Make sure the Task Resolution fields above are filled properly, then click the Resolve Task
        button on the menu bar.
    </li>
</ul>
Eventually, this workflow will allow you to select the state and service information for this
client and generate the LSA dyanmically.  Automatic emailing will also be included.  This
portion is under development.

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