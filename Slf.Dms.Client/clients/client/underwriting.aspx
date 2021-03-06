<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="underwriting.aspx.vb" Inherits="clients_client_underwriting" title="DMP - Client - Underwriting" EnableEventValidation="true"%>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register src="MultipleDeposit.ascx" tagname="MultipleDeposit" tagprefix="uc1" %>
<%@ Register src="calculator.ascx" tagname="calculator" tagprefix="uc2" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">
    <style type="text/css">
        .enrollmentMenuButton
        {
	        margin:1px;
	        padding:2px 5px 2px 5px;
	        white-space:nowrap;
	        height:22px;
	        color:Black;
	        text-decoration:none;
        }
        .enrollmentMenuButtonHover, .enrollmentMenuButton:hover
        {
	        margin:1px;
	        padding:1px 4px 1px 4px;
	        background-color:#e8f3ff;
	        border:solid 1px #336699;
        }    
    </style>
    <asp:Panel runat="server" ID="pnlMenuResolve">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img id="Img1" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a id="aResolve" runat="server" class="menuButton" href="#" onclick="Record_Resolve();return false;">
                        <img id="imgSave" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Resolve</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_SaveForLater();return false;">
                        <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save For Later</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_ViewFeeStructure();return false;">
                        <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_trust.png" />View Fee Structure</a></td>
                <div id="divCID" runat="server" visible="false">
                <td class="menuSeparator">|</td>
                <td nowrap="nowrap">
                        <table cellpadding="0" cellspacing="0" id="tblOptions" runat="server">
                            <tr>
                                <td class="enrollmentMenuButton" onclick="generateLSA();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                text-align: center; white-space:nowrap">
                                    <img id="Img222" align="absmiddle" runat="server" style="margin: 0px;" src="~/images/16x16_form_setup.png" alt="" />
                                       Generate LSA
                                </td>
                            </tr>
                        </table>
                        <obo:Flyout ID="oboOptions" runat="server" AttachTo="tblOptions" Align="LEFT"
                            Position="BOTTOM_CENTER" OpenTime="100">
                            <div class="entry2" style="background-color: #D6E7F3; width: 150px;">
                            <script language="javascript" type="text/javascript">
                                function ClearLSAOptions() {
                                    var rdoLst = document.getElementsByName('ctl00$cphMenu$oboOptions$LSAOptions');
                                    for (var i = 0; i < rdoLst.length; i++) {
                                        if (rdoLst[i].checked) document.getElementById(rdoLst[i].id).checked = false;
                                    }
                                }
                            </script>
                            <table class="entry">
                                <tr>
                                    <td style="background-color:#3376AB; height:25px; color:White; padding:2px; text-align:center;" >
                                        LSA Options
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkElectronicLSA" runat="server" Text="Generate e-LSA" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkFormLetter" runat="server" Text="Add'l Cover Letter" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="chkVoidedCheck" runat="server" Text="Include Voided Check" GroupName="LSAOptions" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="chkOnlyScheduleA" runat="server" Text="Only Schedule A" GroupName="LSAOptions" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                            <asp:RadioButton ID="chkOnlyVoidedCheck" runat="server" Text="Only Voided Check"
                                                GroupName="LSAOptions" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:RadioButton ID="chkTruthInService" runat="server" Text="Only Truth In Service"
                                                GroupName="LSAOptions" />
                                    </td>
                                </tr>
								<tr>
                                	<td>
										<asp:RadioButton ID="chkFeeAddendum" runat="server" Text="Only Fee Addendum" GroupName="LSAOptions" />
									</td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <a href="javascript:ClearLSAOptions();">Clear</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </obo:Flyout>
                </td>
                <td id="td3PVSep" runat="server" class="menuSeparator">|</td>
                <td id="td3PVMenu" nowrap="nowrap" runat="server"  >
                    <a class="menuButton" href="#" onclick="submitVerification();return false;">
                        <img id="Img333" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_check.png" />Submit Verification</a>
                </td>
                <td id="tdVerificationMenu" nowrap="nowrap" runat="server">
                        <a class="menuButton" href="#" onclick="submitCallVerification();return false;">
                            <img id="ImgVerificationCall" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_check.png" />Submit Verification</a>
                     <asp:LinkButton ID="lnkVerificationCall" runat="server" CssClass="menuButton" Visible="False"/> 
                    </td>
                <td class="menuSeparator">|</td>
                <td nowrap="nowrap">
                    <asp:LinkButton ID="lnkReturnToCID" runat="server" CssClass="menuButton" ><img id="Img23" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_file_remove.png" />Return to CID</asp:LinkButton>                                       
                    <obo:Flyout ID="Flyout1" runat="server" AttachTo="lnkReturnToCID" Align="LEFT" Position="BOTTOM_CENTER"
                        OpenTime="100">
                        <div class="entry2" style="background-color: #D6E7F3;">
                            <table class="entry">
                                <tr>
                                    <td>
                                        Notes (required):
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtReturnNotes" runat="server" CssClass="entry2" Width="300px" TextMode="MultiLine" Rows="6"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </obo:Flyout>
                </td>
                </div>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a id="A1" runat="server" class="menuButton" href="~/search.aspx">
                        <img id="Img4" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
                <td><img id="Img444" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                 <td id="trCalc" nowrap="true" runat="server" >
                    <a class="menuButton" href="#" onclick="ShowCalc();return false;">
                        <img id="ImgCalc1" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_taskcategory.png" />Calculator</a></td>
                <td><img id="Img9" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuView" visible="false">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img id="Img5" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_Return();return false;">
                        <img id="Img6" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Return</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_ViewFeeStructure();return false;">
                        <img id="Img7" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_trust.png" />View Fee Structure</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a id="A2" runat="server" class="menuButton" href="~/clients/search.aspx">
                        <img id="Img8" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_find.png" />Search</a></td>
                <td><img id="Img999" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                 <td id="trCalc2" nowrap="true" runat="server" >
                    <a id="ImgCalc2" class="menuButton" href="#" onclick="ShowCalc();return false;">
                        <img id="Img1010" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_taskcategory.png" />Calculator</a></td>
                <td><img id="Img14" width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<style type="text/css">

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
col.c5 {width:65;}
col.c6 {width:100;}
col.c7 {width:85;}
col.c8 {width:125;}
col.c9 {width:100;}
col.c10 {width:100;}
col.c11 {width:75;}
col.c12 {width:75;}
col.c13 {width:100;}
col.c14 {width:100;}
col.c15 {width:0;}
col.c16 {width:0;}
col.c17 {width:0;}
col.c18 {width:0;}
col.c19 {width:0;}
col.c20 {width:0;}
col.c21 {width:0;}
col.c22 {width:0;}
col.c23 {width:0;}

    .dvMultiDep
    {
        border: 1px outset #808080;
        position: absolute;
        background-color: #88AEFF;
    }
    .modalCalc
    {
	    position: absolute;
	    display:none;
	    opacity: 0.5;
        filter:alpha(opacity=50);
        z-index: 1000;
        background-color: gray;
        top: 0;
        left: 0;
	}
    .divCalc
    {
	    position: absolute;
	    top: 100px;
        left: 100px;
        background-color: White;
        border: ridge 2px gray; 
        width: 300px; 
        overflow: visible;  
        z-index: 1001;
        display:none;
     }
     
    .btnCalc
    {
    	font-family: Tahoma;
    	font-size: 11px;
    	height: 19px;  
    	}
    	
    .menuButtonHover 
    {
        margin: 1px; 
        background:rgb(232, 243, 255); 
        border:solid 1px rgb(51, 102, 153); 
        font-family: Tahoma;
        font-size: 11px;
        text-decoration: none;
        color: Black;
    }
    .DocHeader
    {
        background-color:#fff;
        text-decoration:underline;
        font-weight: normal;
        font-size:11px;
        font-family:Tahoma;
        border-width: 0px;
        white-space: nowrap;
    }
    .DocItem
    {
    	color:#999999;
        border-width: 0px;
        white-space: nowrap;
        font-size:11px;
        font-family:Tahoma;
    }
</style>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/inputgrid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">

var closinrecording = false;
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

var AlreadyCreated = null;
var hdnMultiDeposit = null;
var Inputs = new Array();

function pageLoad(){
        
            $(document).ready(function () {
                 if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx'))
                {
                    $("#dvVerifVerbal").dialog({width: "670", height: "400 !important",
                                    closeOnEscape: false,
                                    autoOpen: false,
                                    modal: true,
                                    resizable: false,
                                    open: function(event, ui) {
                                        $("#ifrVerifVerbal").attr("src", '<%= ResolveUrl("~/CallControlsAst/CallVerification.aspx?clientid=" & ClientId)%>' + '&rand=' + Math.floor(Math.random() * 99999)); 
                                        },
                                    close: function(){ 
                                        if (!closinrecording){
                                            $("#ifrVerifVerbal").get(0).contentWindow.StopRecording('');
                                        }
                                        $("#ifrVerifVerbal").attr("src","");
                                        closinrecording = false;
                                        }});
                   
                } else {
                    $("#dvVerifVerbal").hide();
                }                             
            
            });
}


function Record_ViewFeeStructure()
{
	window.navigate("<%= ResolveUrl("~/clients/client/finances/ach/?id=" & ClientID) %>");
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
        ShowMessageBody("Resolving verification worksheet...");

        // get total setup fee
        var InsertValues = Grid_GetAccountInserts();
        var UpdateValues = Grid_GetAccountUpdates();

        if (InsertValues.length > 0 || UpdateValues.length > 0)
        {
            // open the "collect setup fee" pop-up
            var url = '<%= ResolveUrl("~/util/pop/collectsetupfee.aspx") %>?id=<%= ClientID %>&i=' + encodeURIComponent(InsertValues) + '&u=' + encodeURIComponent(UpdateValues);
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Collect Retainer Fee",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 350, scrollable: false});                  
            
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
        ShowMessageBody("Saving verification worksheet...");

        // postback to save
        <%= Page.ClientScript.GetPostBackEventReference(lnkSaveForLater, Nothing) %>;
    }
}
function RequiredACHExist()
{
    if (hdnMultiDeposit.value=="True")
        return RequiredACHExistMultiDeposit();
    else
        return RequiredACHExistSingleDeposit();
}

function RequiredACHExistSingleDeposit()
{
    var Message = "";
    var Control = null;
    
    //Validate the deposit start date is correctly entered
      var DepStDate = document.getElementById("<%= imDepositStartDate.ClientID %>");
      var startDate = new Date(DepStDate.value);
      var sMonth = startDate.getMonth() + 1;
      var sDay = startDate.getDate();
      var sYear = startDate.getFullYear();
      var sDate = new Date(sMonth + "/" + sDay + "/" + sYear);
      var currentTime = new Date();
      var month = currentTime.getMonth() + 1;
      var day = currentTime.getDate();
      var year = currentTime.getFullYear();
      var eDate = new Date(month + "/" + day + "/" + year);
      //var daysApart = Math.abs(Math.round((sDate-eDate)/86400000));
      var daysApart = 14;
      if (startDate < currentTime)
      {
        //daysApart = startDate - currentTime;
        daysApart = 14;
      }

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
        else if (cboBankStateID.selectedIndex == -1 || cboBankStateID.options[cboBankStateID.selectedIndex].value <= 0)
        {
            Message = "The Bank State field is required.";
            Control = cboBankStateID;
        }
        else if(daysApart < 2)
        {
            Message = "The Deposit Start Date must be at least 2 days but not more than 60 days from today. "
            Control = imDepositStartDate
        }
        if(AlreadyCreated.value != AlreadyCreated.defaultValue)
            {
                if(daysApart < 2)
            {
                Message = "The Deposit Start Date must be at least 2 days but not more than 60 days from today. ";
                Control = imDepositStartDate;
            }
            else if(daysApart > 60)
            {
                Message = "The Deposit Start Date must be within 60 days but not less than 2 days from today. ";
                Control = imDepositStartDate;
            }
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

function RequiredACHExistMultiDeposit()
{
      var Message = "";
      var Control = null;
      //Validate the deposit start date is correctly entered
      var DepStDate = document.getElementById("<%= imDepositStartDate.ClientID %>");
      var startDate = new Date(DepStDate.value);
      var sMonth = startDate.getMonth() + 1;
      var sDay = startDate.getDate();
      var sYear = startDate.getFullYear();
      var sDate = new Date(sMonth + "/" + sDay + "/" + sYear);
      var currentTime = new Date();
      var month = currentTime.getMonth() + 1;
      var day = currentTime.getDate();
      var year = currentTime.getFullYear();
      var eDate = new Date(month + "/" + day + "/" + year);
      //var daysApart = Math.abs(Math.round((sDate-eDate)/86400000));
      var daysApart = 14;
      //if (startDate < currentTime) daysApart = startDate - currentTime;


        // if the deposit method is set to ACH then all bank info is required
        if (daysApart < 2) {
            Message = "The Deposit Start Date must be at least 2 days but not more than 60 days from today. "
            Control = imDepositStartDate
        } else if(AlreadyCreated.value != AlreadyCreated.defaultValue) {
            if(daysApart < 2) {
                Message = "The Deposit Start Date must be at least 2 days but not more than 60 days from today. ";
                Control = imDepositStartDate;
            }
            else if(daysApart > 60) {
                Message = "The Deposit Start Date must be within 60 days but not less than 2 days from today. ";
                Control = imDepositStartDate;
            }
        } else { 
            var tbl = grdAccounts.childNodes[0];
            var totalDebt = 0;
            var acctsToSettle = 0;
            
            for (i=1; i < tbl.rows.length-2; i++) {
                totalDebt += parseFloat(tbl.rows[i].cells[5].childNodes[0].innerText);
                acctsToSettle += 1;
            }

            Message = ValidateDepositList(totalDebt,acctsToSettle);
            if (Message.length > 0)
            {
                Control = document.getElementById('<%=trMultiDepositPanel.ClientId %>');
            }
        }

        if (Message.length > 0)
        {
            ShowMessage(Control, Message);
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
            if(cboStateID2.options[cboStateID2.selectedIndex].text != "St. Kitts") 
	        {         
	            {
	                Message = "The Zip Code field is required.";
                    Control = txtZipCode2;
	            }
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
                if(valCap == "Zip Code"){
                    if(cboStateID.options[cboStateID.selectedIndex].text != "St. Kitts"){
                        if (Input.value.length == 0)
                        {
                            ShowMessage(Input, "The " + valCap + " field is required.");
                            AddBorder(Input);
                            return false;
                        }
                    }
                }
                else
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
        hdnMultiDeposit = document.getElementById("<%= hdnMultiDeposit.ClientID %>");
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
        AlreadyCreated = document.getElementById("<%= imDepositStartDate.ClientID %>");

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

		if (address != null && address.attributes.length > 0 && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan")
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
		 if(cboStateID.options[cboStateID.selectedIndex].text != "St. Kitts" && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan") 
	    {         
	        {
	            txtCity.value = "";
	            cboStateID.selectedIndex = 0;
	        }
	    }
	}
	else
	if(cboStateID.options[cboStateID2.selectedIndex].text != "St. Kitts" && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan") 
	    {         
	        {
	            txtCity.value = "";
	            cboStateID.selectedIndex = 0;
	        }
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

		if (address != null && address.attributes.length > 0 && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan")
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
		 if(cboStateID2.options[cboStateID2.selectedIndex].text != "St. Kitts" && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan") 
	    {         
	        {
	            txtCity2.value = "";
	            cboStateID2.selectedIndex = 0;
	        }
	    }
	}
	else
	if(cboStateID2.options[cboStateID2.selectedIndex].text != "St. Kitts" && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan") 
	    {         
	        {
	            txtCity2.value = "";
	            cboStateID2.selectedIndex = 0;
	        }
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
    var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>creditor=' + escape(creditor) + '&street=' + escape(street) + '&street2=' + escape(street2) + '&city=' + city + '&stateid=' + stateid + '&zipcode=' + zipcode;
    window.dialogArguments =  new Array(window, btn, "CreditorFinderReturn");
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
    title: "Find Creditor",
        dialogArguments: window,
        resizable: false,
        scrollable: false,
        height: 700, width: 650
    });  
    
 }
function FindFor(btn)
{
    var td = btn.parentNode.parentNode;
    var tr = td.parentNode;

    var creditor = tr.cells[3].childNodes[0].innerText;
    var street = tr.cells[15].childNodes[0].innerText;
    var street2 = tr.cells[16].childNodes[0].innerText;
    var city = tr.cells[17].childNodes[0].innerText;
    var stateid = tr.cells[18].childNodes[0].innerText;
    var zipcode = tr.cells[19].childNodes[0].innerText;

    // open the find window
    var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>creditor=' + escape(creditor) + '&street=' + escape(street) + '&street2=' + escape(street2) + '&city=' + city + '&stateid=' + stateid + '&zipcode=' + zipcode;
    window.dialogArguments =  new Array(window, btn, "CreditorFinderReturnFor");
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
    title: "Find Creditor",
        dialogArguments: window,
        resizable: false,
        scrollable: false,
        height: 700, width: 650
    });  
    
}
function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
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
    
    tr.setAttribute("validated", validated);
    
    if (validated == 0) 
        tr.style.backgroundColor = '#FFDB72';
    else if (validated == 1)
        tr.style.backgroundColor = '#D2FFD2';
    else 
        tr.style.backgroundColor = '';

    if (name == "&nbsp;")
        name = "";

    if (street == "&nbsp;")
        street = "";

    if (street2 == "&nbsp;")
        street2 = "";

    if (city == "&nbsp;")
        city = "";

    if (zipcode == "&nbsp;")
        zipcode = "";

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
    
    // creditorid
    txt.setAttribute("row", tr.cells[20]);
    txt.value = creditorid;
    Grid_TXT_Save(txt);
    
    // creditorgroupid
    txt.setAttribute("row", tr.cells[22]);
    txt.value = creditorgroupid;
    Grid_TXT_Save(txt);
    
    var key = tr.nextSibling.getAttribute("key");
    
    if (key == '*') {
        tr.nextSibling.style.backgroundColor = '';
    }        
    
    CanResolve(tbl);
}
function CreditorFinderReturnFor(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid)
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
    
    // street
    txt.setAttribute("row", tr.cells[15]);
    txt.value = street;
    Grid_TXT_Save(txt);

    // street2
    txt.setAttribute("row", tr.cells[16]);
    txt.value = street2;
    Grid_TXT_Save(txt);

    // city
    txt.setAttribute("row", tr.cells[17]);
    txt.value = city;
    Grid_TXT_Save(txt);

    // state
    txt.setAttribute("row", tr.cells[18]);
    txt.value = stateid;
    Grid_TXT_Save(txt);

    // zipcode
    txt.setAttribute("row", tr.cells[19]);
    txt.value = zipcode;
    Grid_TXT_Save(txt);
    
    // creditorid
    txt.setAttribute("row", tr.cells[21]);
    txt.value = creditorid;
    Grid_TXT_Save(txt);
    
    // creditorgroupid
    txt.setAttribute("row", tr.cells[23]);
    txt.value = creditorgroupid;
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
function CanResolve(tbl)
{
    var aResolve = document.getElementById('<%=aResolve.ClientID %>');
    var imgSave = document.getElementById('<%=imgSave.ClientID %>');
    var div = document.getElementById('<%=dvErrorAccounts.ClientID %>');
    var td = document.getElementById('<%=tdErrorAccounts.ClientID %>');
    var cnt=0;
    
    for (i = 0; i < tbl.rows.length-2; i++)
    {
        var val = tbl.rows[i].getAttribute("validated");
        if (val == 0) {
            cnt+=1;
        }
    }

    if (cnt > 0)
    {
        //cannot resolve, unvalidated creditors in list
        aResolve.disabled = true;
        imgSave.src = '<%=ResolveUrl("~/images/16x16_save_disabled.png") %>';
        div.style.display = '';
        td.innerHTML = 'There are unvalidated creditors on this worksheet. You will not be able to resolve this worksheet until they have been validated by a manager.';
    }
    else
    {
        //can resolve
        aResolve.disabled = false;
        imgSave.src = '<%=ResolveUrl("~/images/16x16_save.png") %>';
        div.style.display = 'none';
        td.innerHTML = '';
    }
}
function SendBackToAgency()
{
    var url = '<%= ResolveUrl("~/util/pop/clientsendback.aspx?clientid=" & clientid) %>';
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Send client back to Agency",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 450, width: 420, scrollable: false});   
}
function ShowCalc()
{
    document.getElementById("modalcalcbackground").style.display = "block"; 
    document.getElementById("modalcalcbackground").style.width = screen.width;
    document.getElementById("modalcalcbackground").style.height = screen.height;
    document.getElementById("dvCalculator").style.display = "block";
    InitFocus();   
}
function HideCalc()
{
    document.getElementById("dvCalculator").style.display = "none";   
    document.getElementById("modalcalcbackground").style.display = "none"; 
}
function ResetTab(e)
{
 if (e.keyCode==9) InitFocus();
 return false;
}
function submitVerification() {
    document.getElementById("<%=lnkSubmitVerification.ClientID() %>").click();
}
function submitCallVerification(){
   if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                $('#dvVerifVerbal').dialog("open");
            } else {
                alert("Call controls not present.");
            }
           return false;
}
function closeVerifDialog(approved){
            if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                if (!closinrecording) {
                    closinrecording = true;
                    $("#dvVerifVerbal").dialog("close");
                    document.getElementById('<%=ImgRefreshVerif.ClientID %>').click(); 
                 }
             }
        }

function generateLSA() {
    var chk = document.getElementById('<%=chkElectronicLSA.ClientID %>');
    
    if (chk.checked==true){
        var modalPopupBehavior = $find('programmaticModalPopupBehavior2');
        modalPopupBehavior.show();
    }else{
        document.getElementById("<%= lnkGenerate.ClientID() %>").click();
    }
}

function closePopup() {
    var modalPopupBehavior = $find('programmaticModalPopupBehavior2');
    modalPopupBehavior.hide();
}

function make_call(phonenumber){
    window.top.parent.MakeClientOutboundCall('<%=ClientId%>',phonenumber);
}
</script>
<asp:ScriptManager ID="ScriptManager1" runat="server" >
</asp:ScriptManager>
<asp:Panel runat="server" ID="pnlBodyDefault">
<table class="stanTblNoH" cellpadding="0" cellspacing="15" border="0">
    <tr>
        <td style="background-color:#f1f1f1;padding:8;font-weight:bold;" colspan="3">Information Verification<font style="font-weight:normal;">&nbsp;&nbsp;for<img id="Img10" runat="server" src="~/images/16x16_person.png" style="margin:0 3 0 3;" border="0" align="absmiddle" /><a class="lnk" runat="server" ID="lnkClientName"></a></font></td>
    </tr>
    <tr>
        <td colspan="3">
            <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img id="Img11" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td valign="top" ><asp:Label runat="server" ID="lblInfoBox"></asp:Label></td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr id="trAssign" runat="server" visible="false">
        <td colspan="3">
           <asp:CheckBox ID="chkAssign" runat="server" Text="Assign myself as the underwriter for this client" TextAlign="Right" CssClass="entry2" BackColor="#ffffda" />
        </td>
    </tr>
    <tr id="trWelcomeCallLtrNeeded" runat="server" visible="true">
    	<td colspan="3">
    		<asp:CheckBox ID="chkWelcomeCallLtrNeeded" runat="server" Text="Welcome Call Letter Needed?" AutoPostBack="true"
                        TextAlign="Right" CssClass="entry2" BackColor="#ffffda" ToolTip="Check if Welcome Call Letter is needed for Welcome Package." />
    	</td>
    </tr>    
    <tr>
        <td colspan="3" style="padding-left:20;">
            <div runat="server" id="dvErrorReceived" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img id="Img12" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorReceived"></td>
                    </tr>
                </table>&nbsp;<br />
            </div>
        </td>
    </tr>
    <tr id="trCID" runat="server" visible="false">
        <td valign="top">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table style="width: 100%;" class="stanTblNoH" cellpadding="3" cellspacing="0" border="0">
		                                    <tr>
		                                        <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1;">
		                                            e-LSA
		                                        </td>
		                                        <td style="border-bottom: solid 1px #d1d1d1; text-align: right">
		                                            <asp:ImageButton ID="btnRefreshDocs" runat="server" ImageUrl="~/images/16x16_refresh.png"
		                                                ToolTip="Check for signed documents" />
		                                        </td>
		                                    </tr>
		                                    <tr>
		                                        <td colspan="2">
		                                            <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="false" BorderWidth="0"
							                                                DataSourceID="ds_leaddocuments" Width="100%">
							                                                <Columns>
							                                                    <asp:BoundField DataField="SignatoryEmail" HeaderText="Sent To" HeaderStyle-CssClass="DocHeader"
							                                                        ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" ItemStyle-Wrap="true" />
							                                                    <asp:TemplateField>
							                                                        <HeaderStyle CssClass="DocHeader" HorizontalAlign="Left" />
							                                                        <ItemStyle CssClass="DocItem" />
							                                                        <HeaderTemplate>
							                                                            Status
							                                                        </HeaderTemplate>
							                                                        <ItemTemplate>
							                                                            <%#SetCurrentStatus(Eval("DocumentId"), Eval("CurrentStatus"))%>
							                                                        </ItemTemplate>
							                                                    </asp:TemplateField>
							                                                    <asp:BoundField DataField="Completed" HeaderText="Signed" DataFormatString="{0:d}"
							                                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
							                                                         <asp:BoundField DataField="DocumentName" HeaderText="Document" HeaderStyle-CssClass="DocHeader"
							                                                        ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" ItemStyle-Wrap="true"
							                                                         ItemStyle-Width="85px" Visible="false"/>
							                                                </Columns>
							                                                <EmptyDataTemplate>
							                                                    <span class="entry2">No e-LSA's exist for this client.</span>
							                                                </EmptyDataTemplate>
                                        </asp:GridView>
		                                            <asp:SqlDataSource ID="ds_leaddocuments" runat="server" SelectCommand="stp_enrollment_leaddocuments"
		                                                SelectCommandType="StoredProcedure" ConnectionString="<%$ AppSettings:connectionstring %>">
		                                                <SelectParameters>
		                                                    <asp:Parameter Name="LeadApplicantID" DbType="Int32" />
		                                                </SelectParameters>
		                                            </asp:SqlDataSource>
		                                        </td>
		                                    </tr>
                            </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
        <td valign="top">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <table id="tbOldVerification" style="width:310;" class="stanTblNoH" cellpadding="3" cellspacing="0" border="0" runat="server">
                        <tr>
                            <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Verification</td>
                            <td style="border-bottom: solid 1px #d1d1d1; text-align: right"><asp:ImageButton ID="btnRefreshVerification" runat="server" ImageUrl="~/images/16x16_refresh.png" ToolTip="Check for completed verifications" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:GridView ID="gvVerification" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                    DataSourceID="ds_leadverification" Width="100%">
                                    <Columns>
                                        <asp:BoundField DataField="Submitted" HeaderText="Submitted" DataFormatString="{0:d}"
                                            HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="SubmittedBy" HeaderText="Submitted By" HeaderStyle-CssClass="DocHeader"
                                            ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="PVN" HeaderText="Code" HeaderStyle-CssClass="DocHeader"
                                            ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="Completed" HeaderText="Completed" DataFormatString="{0:d}"
                                            HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <span class="entry2">No verifications have been submitted.</span>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                                <asp:SqlDataSource ID="ds_leadverification" runat="server" SelectCommand="stp_enrollment_leadverification"
                                    SelectCommandType="StoredProcedure" ConnectionString="<%$ AppSettings:connectionstring %>">
                                    <SelectParameters>
                                        <asp:Parameter Name="LeadApplicantID" DbType="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                    </table>
                    <table id="tbNewVerification" style="width:310;" class="stanTblNoH" cellpadding="3" cellspacing="0" border="0" runat="server">
                        <tr>
                            <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Verification</td>
                            <td style="border-bottom: solid 1px #d1d1d1; text-align: right">
                                <asp:ImageButton ID="ImgRefreshVerif" runat="server" 
                                    ImageUrl="~/images/16x16_refresh.png" 
                                    ToolTip="Check for completed verifications" style="width: 16px" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:GridView ID="grdVerification" runat="server" AutoGenerateColumns="false" BorderWidth="0" Width="100%">
                                    <Columns>
                                        <asp:BoundField DataField="Submitted" HeaderText="Submitted" DataFormatString="{0:d}"
                                            HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="SubmittedBy" HeaderText="Submitted By" HeaderStyle-CssClass="DocHeader"
                                            ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="Completed" HeaderText="Completed" DataFormatString="{0:d}"
                                            HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="LastStep" HeaderText="Last Step" 
                                            HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                       <asp:TemplateField HeaderText="Doc" HeaderStyle-CssClass="DocHeader" >
                                             <ItemTemplate>                                                     
                                                  <a href='<%#DataBinder.Eval(Container.DataItem, "DocumentPath") %>' target='_blank'  title='Click to view' >
                                                        <%#IIf(DataBinder.Eval(Container.DataItem, "DocumentPath") Is DBNull.Value OrElse DataBinder.Eval(Container.DataItem, "DocumentPath").trim.length = 0, "", "<img src='" & ResolveUrl("~/images/16x16_pdf.png") & "' style='border-width:0px;'/>")%>
                                                  </a> 
                                            </ItemTemplate> 
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Rec" HeaderStyle-CssClass="DocHeader" >
                                             <ItemTemplate> 
                                                  <a id="aRecFile" href="#" runat="server" > 
                                                    <img  id="ImgRec" runat="server" style='border-width:0px;' /> 
                                                  </a> 
                                            </ItemTemplate> 
                                        </asp:TemplateField>     
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <span class="entry2">No verifications have been submitted.</span>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
        <td id="tdVerAccessNumber" valign="top" runat="server" >
            <table style="width:360;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Verification Submitted</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="height:21;width:110;">Access Number:</td>
                                <td id="tdAccessNum" runat="server" style="font-weight: bold; color: Green;" nowrap="nowrap">
                                </td>
                            </tr>
                            <tr>
                                <td style="height:21;width:110;">Verification Code:</td>
                                <td id="tdPVN" runat="server" style="font-weight: bold; color: Green; padding-top:3px;" nowrap="nowrap">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top"> <!-- primary applicant cell -->
            <div runat="server" id="dvErrorPrimary" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
                    <tr>
                        <td valign="top" style="width:20;"><img id="Img13" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorPrimary"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:315;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Primary Applicant</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="width:85;">Name:</td>
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
                                <td>Street:</td>
                                <td><asp:TextBox reqSave="true" valCap="Street" TabIndex="3" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet1"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Street 2:</td>
                                <td><asp:TextBox TabIndex="4" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet2"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>City:</td>
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
                                <td>Home / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Home Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="10" CssClass="entry2" Width="82px" runat="server" ID="imHomePhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img16" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imHomePhone.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Home Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="11" CssClass="entry" runat="server" ID="imHomeFax" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Business / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Business Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="12" CssClass="entry2" Width="82px" runat="server" ID="imBusinessPhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img17" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imBusinessPhone.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
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
                                            <td><cc1:InputMask valCap="Alternate Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="14" CssClass="entry2" Width="82px" runat="server" ID="imCellPhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img14" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imCellPhone.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Cell Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="15" CssClass="entry2" Width="82px" runat="server" ID="imAlternatePhone" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img18" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imAlternatePhone.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Email Address:</td>
                                <td><asp:TextBox valCap="Email Address" valFun="IsValidTextEmailAddress(Input.value);" TabIndex="16" MaxLength="50" CssClass="entry" runat="server" ID="txtEmailAddress"></asp:TextBox></td>
                            </tr>
                            <tr>
                            <td>Retainer:</td>
                                <td>
                                    <asp:DropDownList ID="ddlRetainer" CssClass="entry" Font-Size="11px" runat="server">
                                        <asp:ListItem Text = "0" Value="0" />
                                        <asp:ListItem Text = "5" Value="5" />
                                        <asp:ListItem Text="8" Value="8" />
                                        <asp:ListItem Text="10" Value="10" />
                                    </asp:DropDownList>
                                </td>
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
                        <td valign="top" style="width:20;"><img id="Img15" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorSecondary"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:315;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Co-Applicant</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="width:85;">Name:</td>
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
                                <td>Street:</td>
                                <td><asp:TextBox TabIndex="19" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet12"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Street 2:</td>
                                <td><asp:TextBox TabIndex="20" MaxLength="50" CssClass="entry" runat="server" ID="txtStreet22"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>City:</td>
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
                                <td>Home / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Home Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="26" CssClass="entry2" Width="82px" runat="server" ID="imHomePhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img19" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imHomePhone2.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Home Fax" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="27" CssClass="entry" runat="server" ID="imHomeFax2" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>Business / Fax:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td><cc1:InputMask valCap="Business Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="28" CssClass="entry2" Width="82px" runat="server" ID="imBusinessPhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img20" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imBusinessPhone2.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
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
                                            <td><cc1:InputMask valCap="Alternate Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="30" CssClass="entry2" Width="82px" runat="server" ID="imAlternatePhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img21" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imAlternatePhone2.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
                                            <td style="padding-left:5;"><cc1:InputMask valCap="Cell Phone" valFun="IsValidTextPhoneNumber(Input.value);" TabIndex="31" CssClass="entry2" Width="82px" runat="server" ID="imCellPhone2" Mask="(nnn) nnn-nnnn"></cc1:InputMask><img id="img22" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="parent.make_call(document.getElementById('<%=imCellPhone2.ClientId %>').value);" style="cursor:hand; margin-left:3px;" align="absmiddle" /></td>
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
                        <td valign="top" style="width:20;"><img id="Img16" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorSetup"></td>
                    </tr>
                </table>&nbsp;
            </div>
            <table style="width:360;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
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
                                <td style="height:21;">SDA Account No:</td>
                                <td><asp:Label CssClass="entry" runat="server" ID="lblSDAAccountNumber"></asp:Label></td>
                            </tr>
                            <tr id="trSingleDepositMethod" runat="server" >
                                <td>Method / Amt. / Day:</td>
                                <td>
                                    <table class="stanTblNoH" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="padding-right:5;width:58;">
                                                <asp:DropDownList TabIndex="37" CssClass="entry" runat="server" ID="cboDepositMethod">
                                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                                    <asp:ListItem Value="ACH" Text="ACH"></asp:ListItem>
                                                    <asp:ListItem Value="Check" Text="Check"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td style="padding-right:5;width:50;">
                                                <asp:TextBox valCap="Deposit Amount" valFun="IsValidNumberFloat(Input.value, false, Input);" style="text-align:right;" TabIndex="38" MaxLength="50" CssClass="entry" runat="server" ID="txtDepositAmount"></asp:TextBox>
                                            </td>
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
                            <tr id="trSingleDepositRouting" runat="server"> 
                                <td>Routing Number:
                                </td>
                                <td>
                                    <asp:TextBox TabIndex="40" MaxLength="9" CssClass="entry" runat="server" ID="txtRoutingNumber"></asp:TextBox>
                                </td>
                            </tr>
                            <tr id="trSingleDepositAccountNumber" runat="server">
                                <td>Account Number:</td>
                                <td><asp:TextBox TabIndex="41" MaxLength="50" CssClass="entry" runat="server" ID="txtAccountNumber"></asp:TextBox></td>
                            </tr>
                            <tr id="trSingleDepositAccountType" runat="server">
                                <td>Account Type:</td>
                                <td>
                                    <asp:DropDownList TabIndex="42" class="entry" id="cboBankType" runat="server" style="font-size:11px">
                                        <asp:ListItem value="0" text=""></asp:ListItem>
                                        <asp:ListItem value="C" text="Checking"></asp:ListItem>
                                        <asp:ListItem value="S" text="Savings"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trSingleDepositBankName" runat="server">
                                <td>Bank Name:</td>
                                <td style="height: 23px"><asp:Label ID="lblBankName" runat="server" CssClass="entry"></asp:Label></td>
                            </tr>
                            <tr id="trSingleDepositBankCity" runat="server">
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
                                <td><cc1:InputMask valCap="Deposit Start Date" valFun="IsValidDateTime(Input.value);" TabIndex="48" CssClass="entry2" runat="server" ID="imDepositStartDate" Mask="nn/nn/nnnn" Width="70px"></cc1:InputMask></td>
                            </tr>
                            <tr id="trMultiDepositPanel" style="display:none;" runat="server" >
                                <td colspan="2" >
                                    <uc1:MultipleDeposit ID="MultipleDepositList" runat="server" class="partHolderBody" />
                                </td> 
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id="trInitialDepositInfo" runat="server" visible="false">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td valign="top">
            <table style="width:360;" class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Initial Deposit Info</td>
                </tr>
                <tr>
                    <td>
                        <table class="stanTblNoH" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td style="width:110; height:21">Deposit Method:</td>
                                <td>
                                    <asp:Label ID="lblInitialMethod" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width:110;">Deposit Date:</td>
                                <td>
                                    <cc1:InputMask ID="imInitialDepDate" runat="server" valCap="Initial Deposit Date" valFun="IsValidDateTime(Input.value);" CssClass="entry2" Mask="nn/nn/nnnn" Width="70px"></cc1:InputMask>
                                    &nbsp;<asp:Label ID="lblIniDepStatusMsg" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Amount:</td>
                                <td>
                                    <asp:TextBox ID="txtInitialAmt" runat="server" valCap="Deposit Amount" valFun="IsValidNumberFloat(Input.value, false, Input);" style="text-align:right;" MaxLength="10" Width="70px" CssClass="entry2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr id="trInitialRouting" runat="server"> 
                                <td>Routing Number:</td>
                                <td>
                                    <asp:TextBox ID="txtInitialRouting" runat="server" MaxLength="9" CssClass="entry2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr id="trInitialAccount" runat="server">
                                <td>Account Number:</td>
                                <td><asp:TextBox ID="txtInitialAccount" runat="server" MaxLength="30" CssClass="entry2"></asp:TextBox></td>
                            </tr>
                            <tr id="trInitialType" runat="server">
                                <td>Account Type:</td>
                                <td>
                                    <asp:DropDownList id="ddlInitialType" runat="server" class="entry2">
                                        <asp:ListItem value="C" text="Checking"></asp:ListItem>
                                        <asp:ListItem value="S" text="Savings"></asp:ListItem>
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
		                    <td valign="top" style="width:20;"><img id="Img17" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
		                    <td runat="server" id="tdErrorAccounts"></td>
	                    </tr>
                    </table>&nbsp;
                </div>
                <div id="grdAccounts" class="grid" runat="server" style="width:100%;height:250;"><input type="text" class="grdTXT uns" onkeydown="Grid_TXT_OnKeyDown(this);" onblur="Grid_TXT_OnBlur(this);" /></div><input runat="server" id="grdAccountsUpdates" type="hidden" /><input runat="server" id="grdAccountsInserts" type="hidden" /><input runat="server" id="grdAccountsDeletes" type="hidden" /><input runat="server" id="grdAccountsSelected" type="hidden" />
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
<asp:CheckBox runat="server" ID="chkCollectInsert" style="display:none;" />
<asp:CheckBox runat="server" ID="chkCollectUpdate" style="display:none;" />
<asp:TextBox runat="server" ID="txtOldPct" style="display:none" />
<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->
<asp:LinkButton runat="server" ID="lnkReturn"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkResolve"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkSaveForLater"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkSubmitVerification"></asp:LinkButton>
    <asp:LinkButton ID="lnkGenerate" runat="server" />
<asp:HiddenField ID="hdnMultideposit" runat="server" />
<asp:HiddenField ID="hdnCompanyID" runat="server" />
<asp:HiddenField ID="hdnLeadApplicantID" runat="server" />
<asp:HiddenField ID="hdnAdhocAchID" runat="server" />
<asp:HiddenField ID="hdnUse3PV" runat="server" />
<div id="dvVerifVerbal" title="Compliance Call">
    <iframe id="ifrVerifVerbal" src="" style="width: 640px; height: 360px;" frameborder="0">
    </iframe>
</div>
<div id="modalcalcbackground" class="modalCalc" >
</div>
<div id="dvCalculator" class="divCalc">
           <asp:UpdatePanel ID="updReload" runat="server" >
                <ContentTemplate>

    <table id="calculatordialog" style="font-family:Tahoma; font-size:11px;" cellspacing="0"  >
    <tr>
        <td align ="center" style="height: 25px; background-color:Gray; color:White; padding: 0; font-size: 12px">
            Calculator
        </td>
        <td align ="right" style="height: 25px; background-color:Gray; padding: 0; padding-right: 3px; "  >
            <img id="Img18" runat="server" src="~/images/16x16_close.png" align="absmiddle" border="0" onclick="HideCalc()" title="Close">
        </td>
    </tr>
    <tr>
        <td colspan="2">
                    <uc2:calculator ID="debtcalculator" runat="server" />
                
        </td>
    </tr>
    <tr>
        <td colspan="2" align="left" style="padding: 3px; vertical-align: top; height: 25px;" >
             Load calculator data from:
             <asp:Button CssClass="btnCalc" ID="btnSD" runat="server" Text="Client Intake site" TabIndex="1010" />&nbsp;
             <asp:Button CssClass="btnCalc" ID="btnCurrent" runat="server" Text="This site: Current" TabIndex="1011" />
        </td>
    </tr>
    </table></ContentTemplate> 
           </asp:UpdatePanel>
</div>
    <asp:Button runat="server" ID="hiddenTargetControlForModalPopup2" Style="display: none;" />
    <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup2" BehaviorID="programmaticModalPopupBehavior2"
        TargetControlID="hiddenTargetControlForModalPopup2" PopupControlID="programmaticPopup2"
        BackgroundCssClass="modalBackgroundChoice" DropShadow="false" CancelControlID="lnkCancel" >
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel runat="server" CssClass="modalPopupChoice" ID="programmaticPopup2" Style="display: none;
        padding: 0px">
        <asp:Panel runat="Server" ID="Panel2" Style="cursor: move; background-color: #3D3D3D;height: 30px;border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
            <div id="Div1" runat="server" onmouseover="this.style.cursor='hand';" onclick="javascript:closePopup();"
                style="height: 30px; padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51;
                text-align: right; vertical-align: middle; border-collapse: collapse;">
                <div style="float: left; color: White; padding: 5px;">
                    Signing Choice</div>
                <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="Panel3">
            <div id="dvContent" runat="server" style="z-index: 51; visibility: visible; background-color: Transparent;">
                <asp:RadioButtonList ID="rblSignChoice" runat="server" CssClass="entry2">
                    <asp:ListItem Text="EchoSign" Value="echo" />
                    <asp:ListItem Text="LexxEsign" Value="lexx" Selected="True" />
                </asp:RadioButtonList>
                <table class="entry" style="background-color:#DCDCDC">
                    <tr>
                        <td align="right">
                            <asp:LinkButton ID="lnkGo" runat="server" Text="Continue"></asp:LinkButton>
                            <asp:Literal ID="litSpac" runat="server" Text=" | "></asp:Literal>
                            <asp:LinkButton ID="lnkCancel" runat="server" Text="Cancel"></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </asp:Panel>
</asp:Content>