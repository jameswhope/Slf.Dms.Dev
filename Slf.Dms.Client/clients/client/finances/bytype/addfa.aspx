<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="addfa.aspx.vb" Inherits="clients_client_finances_bytype_addfa" title="DMP - Client - Add Fee Adjustment" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript">

    var txtTransactionDate = null;
    var lblOriginalAmount = null;
    var txtAmount = null;
    var ddlDirection = null;
    var lblFinalAmount = null;
    var txtDescription = null;
    var txtSelected = null;
    var txtSelectedAmount = null;

    var dvError = null;
    var tdError = null;

    var tblBody = null;
    var tblMessage = null;

    function Record_Save()
    {
        LoadControls();

        if (Record_RequiredExist())
        {
            // postback to save
            Record_Display("Saving fee adjustment...");
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function LoadControls()
    {
        if (txtTransactionDate == null)
        {
            txtTransactionDate = document.getElementById("<%= txtTransactionDate.ClientID %>");
            lblOriginalAmount = document.getElementById("<%= lblOriginalAmount.ClientID %>");
            ddlDirection = document.getElementById("<%= ddlDirection.ClientID %>");
            txtAmount = document.getElementById("<%= txtAmount.ClientID %>");
            lblFinalAmount = document.getElementById("<%= lblFinalAmount.ClientID %>");
            txtDescription = document.getElementById("<%= txtDescription.ClientID %>");

            txtSelected = document.getElementById("<%= txtSelected.ClientID %>");
            txtSelectedAmount = document.getElementById("<%= txtSelectedAmount.ClientID %>");

            dvError = document.getElementById("<%= dvError.ClientID %>");
            tdError = document.getElementById("<%= tdError.ClientID %>");

            tblBody = document.getElementById("<%= tblBody.ClientID %>");
            tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
        }
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
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
    function Record_RequiredExist()
    {
        RemoveBorder(txtTransactionDate);
        RemoveBorder(txtAmount);

        // date is always required
	    if (txtTransactionDate.value.length == 0)
	    {
            ShowMessage("The Adjustment Date is required.");
            AddBorder(txtTransactionDate);
            return false;
	    }
	    else
	    {
	        if (!IsValidDateTime(txtTransactionDate.value))
	        {
                ShowMessage("The Adjustment Date you entered is invalid.  Please enter a new value.");
                AddBorder(txtTransactionDate);
                return false;
	        }
	    }


        // a selected fee is always required
	    if (txtSelected.value.length == 0)
	    {
            ShowMessage("You must select a fee from the Fees Assessed grid below.");
            return false;
	    }


        // amount is always required
	    if (txtAmount.value.length == 0)
	    {
            ShowMessage("The Amount is required.");
            AddBorder(txtAmount);
            return false;
	    }
	    else
	    {
	        if (!IsValidNumberFloat(txtAmount.value, true, txtAmount))
	        {
                ShowMessage("The Amount you entered is invalid.  Please enter a new value.");
                AddBorder(txtAmount);
                return false;
	        }

            // check to make sure that if "downing" the adjustment amount is not greater then the original
            if (ddlDirection.options[ddlDirection.selectedIndex].value == "1")
            {
                var OriginalAmount = 0.0;
                var AdjustmentAmount = 0.0;

                if (txtSelectedAmount.value.length > 0)
                    OriginalAmount = Math.abs(parseFloat(txtSelectedAmount.value));

                if (txtAmount.value.length > 0)
                    AdjustmentAmount = Math.abs(parseFloat(txtAmount.value));

                if (AdjustmentAmount > OriginalAmount)
                {
                    ShowMessage("The Amount you entered is greater then the entire, original fee.  You cannot have a negative total.");
                    AddBorder(txtAmount);
                    return false;
                }
            }
	    }

        HideMessage()
	    return true;
	}
    function opt_OnPropertyChange(opt, RegisterID, Amount)
    {
        LoadControls();

        var tr = opt.parentElement.parentElement;

        if (opt.checked)
        {
            tr.style.backgroundColor = "rgb(225,234,254)"
            tr.setAttribute("selected", "true");

            txtSelected.value = RegisterID;
            txtSelectedAmount.value = Amount;

            ResetTotals();
        }
        else
        {
            tr.style.backgroundColor = "";
            tr.removeAttribute("selected");
        }
    }
    function RowHover(td, on)
    {
        var tr = td.parentElement;

        if (tr.getAttribute("selected") != "true")
        {
            if (on)
                tr.style.backgroundColor = "#f3f3f3";
            else
                tr.style.backgroundColor = "";
        }
    }
    function SetToNow(lnk)
    {
        var d = new Date();
        var month = d.getMonth() + 1
        var day = d.getDate()
        var year = d.getFullYear()

        if (day <= 9)
            day = "0" + day;
        if (month <= 9)
            month = "0" + month;

        var s = "/";
        var curDate = month + s + day + s + year;

        var hours = d.getHours();
        var minutes = d.getMinutes();
        var seconds = d.getSeconds();
        var td="AM";

        if (hours >= 12)
            td = "PM";
        if (hours > 12)
            hours = hours - 12;
        if (hours == 0)
            hours = 12;
        if (minutes <= 9)
            minutes = "0" + minutes;
        if (hours <= 9)
            hours = "0" + hours;
        if (seconds <= 9)
            seconds = "0" + seconds;

        var curTime = hours + ":" + minutes + " " + td;

        var txtDate = lnk.parentElement.previousSibling.childNodes[0];

        txtDate.value = curDate + " " + curTime;
    }
    function SelectRow(td)
    {
        LoadControls();

        var tr = td.parentElement;

        tr.cells[0].childNodes[0].checked = true;
    }
    function ResetTotals()
    {
        LoadControls();

        var OriginalAmount = 0.0;
        var AdjustmentAmount = 0.0;

        if (txtSelectedAmount.value.length > 0)
            OriginalAmount = Math.abs(parseFloat(txtSelectedAmount.value));

        if (txtAmount.value.length > 0)
            AdjustmentAmount = Math.abs(parseFloat(txtAmount.value));

        if (ddlDirection.options[ddlDirection.selectedIndex].value == "0") //up
        {
            lblOriginalAmount.innerHTML = FormatNumber(OriginalAmount, true, 2);
            lblFinalAmount.innerHTML = FormatNumber(OriginalAmount + AdjustmentAmount, true, 2);
        }
        else
        {
            lblOriginalAmount.innerHTML = FormatNumber(OriginalAmount, true, 2);
            lblFinalAmount.innerHTML = FormatNumber(OriginalAmount - AdjustmentAmount, true, 2);
        }
    }
    function Record_Display(Message)
    {
        LoadControls();

        tblBody.style.display = "none";
        tblMessage.style.display = "inline";
        tblMessage.rows[0].cells[0].innerHTML = Message;
    }

    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="font-size:11px;color:#666666;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkFinanceRegister" runat="server" class="lnk" style="font-size:11px;color:#666666;">Finances</a>&nbsp;>&nbsp;Add Fee Adjustment</td>
        </tr>
        <tr>
            <td valign="top">
                <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3">
                            <div runat="server" id="dvError" style="display:none;">
                                <table style="width:100%;BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                <tr>
						                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="font-family:tahoma;font-size:11px;width:310;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="3" nowrap="true">General&nbsp;Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" nowrap="true">Adjustment&nbsp;Date:</td>
                                    <td><cc1:InputMask CssClass="entry" mask="nn/nn/nnnn nn:nn aa" runat="server" id="txtTransactionDate"></cc1:InputMask></td>
                                    <td style="width:60;"><a class="lnk" href="#" onclick="SetToNow(this);return false;">Set to Now</a></td>
                                </tr>
                            </table>
                            <br />
                        </td>
                        <td valign="top" >
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                cellspacing="0">
                                <tr>
                                    <td style="background-color: #f1f1f1;" nowrap="true">
                                        Adjustment Reason
                                    </td>
                                </tr>
                                <tr>
                                    
                                    <td align="left" >
                                        <asp:DropDownList ID="ddlAdjReason" runat="server" CssClass="entry">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;padding:5;" nowrap="true">Fees&nbsp;Assessed</td>
                                </tr>
                                <tr>
                                    <td style="padding:0 0 8 0;border-top:solid 1px #b3b3b3;">
                                        <div runat="server" id="dvFees">
                                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                <tr>
                                                    <td nowrap="true" class="headItem" style="width:23;" align="center"><img runat="server" src="~/images/11x11_uncheckall.png" border="0" align="absmiddle"/></td>
                                                    <td nowrap="true" class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                                                    <td nowrap="true" class="headItem" style="width:75;">Date<img align="absmiddle" style="margin-left:5;" runat="server" border="0" src="~/images/sort-asc.png" /></td>
                                                    <td nowrap="true" class="headItem">Type</td>
                                                    <td nowrap="true" class="headItem" style="width:100%;">Associated To</td>
                                                    <td nowrap="true" class="headItem" style="width:70;padding-right:10;" align="right">Amount</td>
                                                </tr>
                                                <asp:repeater id="rpFees" runat="server">
                                                    <itemtemplate>
                                                        <tr runat="server" id="trFee">
                                                            <td nowrap="true" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center">
                                                                <input name="fees" type="radio" onpropertychange="opt_OnPropertyChange(this, <%#DataBinder.Eval(Container.DataItem, "ID")%>, <%#Math.Abs(DataBinder.Eval(Container.DataItem, "Amount"))%>);return false;" ></input>
                                                            </td>
                                                            <td nowrap="true" onclick="SelectRow(this);return false;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td nowrap="true" onclick="SelectRow(this);return false;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "Date", "{0:MMM d, yyyy}")%>&nbsp;
                                                            </td>
                                                            <td nowrap="true" onclick="SelectRow(this);return false;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style="padding-right:10"><%#DataBinder.Eval(Container.DataItem, "EntryTypeName")%></td>
                                                            <td  onclick="SelectRow(this);return false;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style="font-style:italic;color:#757575;"><%#rpFees_Associations(Container)%></td>
                                                            <td nowrap="true" onclick="SelectRow(this);return false;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="padding-right:10;">
                                                                <%#Math.Abs(CType(DataBinder.Eval(Container.DataItem, "Amount"), Double)).ToString("c")%>&nbsp;
                                                            </td>
                                                        </tr>
                                                    </itemtemplate>
                                                </asp:repeater>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td><img width="20" height="1" runat="server" src="~/images/spacer.gif" border="0"/></td>
                        <td valign="top" style="width:220;">
                            <table style="width:100%;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;padding:5;" nowrap="true">Adjustment Calculator</td>
                                </tr>
                                <tr>
                                    <td style="padding:0 0 8 0;border-top:solid 1px #b3b3b3;">
                                        <table style="width:100%;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td nowrap="true">Original Fee Amount:</td>
                                                <td style="width:10;" align="center">$</td>
                                                <td align="right"><asp:Label runat="server" id="lblOriginalAmount">0.00</asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td nowrap="true">Adjust Up or Down:</td>
                                                <td style="width:10;" align="center">&nbsp;</td>
                                                <td style="width:80;">
                                                    <asp:DropDownList sytle="text-align:right;" CssClass="entry" runat="server" id="ddlDirection">
                                                        <asp:ListItem value="0" text="UP (+)"></asp:ListItem>
                                                        <asp:ListItem value="1" text="DOWN (-)"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="true">Adjustment Amount:</td>
                                                <td style="width:10;" align="center">$</td>
                                                <td style="width:80;"><asp:TextBox style="text-align:right;" CssClass="entry" runat="server" id="txtAmount"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td nowrap="true" style="font-weight:bold;">New Fee Total:</td>
                                                <td style="width:10;font-weight:bold;" align="center">$</td>
                                                <td align="right" style="font-weight:bold;"><asp:Label runat="server" id="lblFinalAmount">0.00</asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                            </table>
                        </td>
                    </tr>
                </table><br />
                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                    <tr>
                        <td nowrap="true" style="background-color:#f1f1f1;">Description</td>
                    </tr>
                    <tr>
                        <td><asp:TextBox MaxLength="255" style="width:100%;" Rows="5" CssClass="entry" runat="server" id="txtDescription" TextMode="MultiLine"></asp:TextBox></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table runat="server" id="tblMessage" style="color:#666666;display:none;font-family:tahoma;font-size:13px;" border="0" cellpadding="0" cellspacing="15"><tr><td></td><td><img id="Img2" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" /></td></tr></table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:TextBox runat="server" id="txtSelected" style="display:none;"></asp:TextBox>
    <asp:TextBox runat="server" id="txtSelectedAmount" style="display:none;"></asp:TextBox>

</body>

</asp:Content>