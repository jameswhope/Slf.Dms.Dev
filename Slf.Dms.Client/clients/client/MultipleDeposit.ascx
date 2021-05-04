<%@ Control Language="VB" AutoEventWireup="false" CodeFile="MultipleDeposit.ascx.vb" Inherits="Clients_client_MultipleDeposit" %>
<link href="../../css/default.css" rel="stylesheet" type="text/css" />
<script src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/jscript/validation/Display.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>" type="text/javascript"></script>
<style>
    
    .multidep
    {
        font-family: Tahoma;
        font-size: 11px;
        padding: 2px 3px 2px 0;
    }
    
    .dropdownMonth
    {
        font-family: Tahoma;
        font-size: 11px;
    }
    
    .multidepAmount
    {
        font-family: Tahoma;
        font-size: 11px;
        text-align: right;
    }
    
    
</style>
<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
</asp:ScriptManagerProxy>

    <table>
        <tr>
            <td>
                <asp:LinkButton ID="lnkAddDeposit" runat="server" CssClass="multidep" OnClientClick="Add_Row(); return false;" >Add a scheduled deposit</asp:LinkButton>
                <span class="multidep">&nbsp;(up to <%=hdnMaxDeposit.Value%> entries)</span>
            </td>
        </tr> 
        <tr>
            <td><div id="dvMTD">
                <table id="tblDepositDetails" class="sideRollupTable" cellspacing="0" cellpadding="2px">
                    <thead style="background-color: #BFDDF2; padding: 0px;"   >
                        <tr>
                            <td></td>
                            <td style="display: none;">Frequency</td>
                            <td>Day</td>
                            <td>Amount</td>
                            <td>Method</td>
                         </tr>
                    </thead> 
                    <tbody>
                        <asp:Repeater id="rpt" runat="server">
                            <ItemTemplate>
                                <tr id="depositRow" runat="server">
                                    <td>
                                        <asp:ImageButton ID="imgRemoveDeposit" runat="server" ImageUrl="~/images/16x16_delete.png" OnClientClick="return Delete_Row(this);" ToolTip ="Remove deposit"    />
                                    </td>
                                    <td style="display: none;">
                                        <asp:DropDownList ID="ddlFreq" runat="server" CssClass="multidep"  Width="56px" onchange="ChangeDDLSourceList(this);RebindDepositList();" >
                                            <asp:ListItem Value="0">month</asp:ListItem>
                                            <asp:ListItem Value="1">week</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlWhen" runat="server" CssClass="dropdownMonth" onchange="RebindDepositList();"> 
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAmount" runat="server" CssClass="multidepAmount" Width="50px" Text='<%#DataBinder.Eval(Container.DataItem, "FormattedAmount")%>' onkeydown="return singleDot(this, event);" onblur="FormatAmount(this);" onchange="RebindDepositList();"></asp:TextBox>
                                        <asp:HiddenField ID="hdnClientDepositId" runat="server"  Value='<%#DataBinder.Eval(Container.DataItem, "ClientDepositId")%>' />
                                        <asp:HiddenField ID="hdnHasRule" runat="server"  Value='<%#iif(DataBinder.Eval(Container.DataItem, "HasRule"),"1","0")%>' />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAccBankId" runat="server" CssClass="dropdownMonth" onchange="RebindDepositList();">
                                        </asp:DropDownList>
                                    </td> 
                                </tr>
                            </ItemTemplate>  
                        </asp:Repeater>
                    </tbody> 
                </table> 
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <hr />
                <asp:UpdatePanel ID="UpdateAccs" runat="server" ChildrenAsTriggers="true" >
                <ContentTemplate>
                    <asp:LinkButton cssclass="multidep" ID="lnkShowBankAcc" runat="server" OnClientClick="return ShowBanking();" >Show Banking Information</asp:LinkButton>
                    <table id="tableBanking" style="display: none;" runat="server" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr id="trEditBankAcc" style="display: none;" runat="server" >
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="multidep"  nowrap="nowrap">
                                            Accounts:
                                        </td>
                                        <td class="multidep"  nowrap="nowrap">
                                            <asp:LinkButton ID="lnkAccSave" runat="server" OnClientClick="return SaveBankAcc();" >Save</asp:LinkButton>
                                            <asp:LinkButton ID="lnkAccCancel" runat="server" OnClientClick="return CancelBankAcc();">Cancel</asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep"  nowrap="nowrap" style="background-color:#e3eff9">
                                            Routing:
                                        </td>
                                        <td class="multidep"  nowrap="nowrap" style="background-color:#e3eff9">
                                            <asp:HiddenField ID="hdnBankAccountId" runat="server" />
                                            <asp:TextBox width="100px" cssclass="multidep" ID="txtAccRouting" runat="server" MaxLength="9" onkeydown="return digitOnly(this, event);"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep"  nowrap="nowrap" style="background-color:#e3eff9">
                                            Account:
                                        </td>
                                        <td class="multidep"  nowrap="nowrap" style="background-color:#e3eff9">
                                            <asp:TextBox width="100px" cssclass="multidep" ID="txtAccNumber" runat="server" onkeydown="return digitOnly(this, event);"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep"  nowrap="nowrap" style="background-color:#e3eff9" colspan="2">
                                            <asp:RadioButton  ID="rdChecking" runat="server" GroupName="AccType" ToolTip="Checking"/>Checking
                                            <asp:RadioButton   ID="rdSaving" runat="server" GroupName="AccType" ToolTip="Savings"/>Savings
                                        </td>
                                    </tr> 
                                </table> 
                            </td>
                        </tr>
                        <tr id="trDisplayBankAcc" style="display: block;" runat="server">
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                         <td class="multidep" nowrap="nowrap">
                                            Accounts:
                                         </td>
                                         <td class="multidep" nowrap="nowrap">
                                            <asp:DropDownList CssClass="multidep" ID="ddlBankAccountInfo" runat="server" Height="16px">
                                                <asp:ListItem>Select One Account</asp:ListItem>
                                                <asp:ListItem>S ****6789</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:LinkButton ID="lnkAccAdd" runat="server" OnClientClick="return AddBankAcc();">Add</asp:LinkButton>
                                            <asp:LinkButton ID="lnkAccEdit" runat="server" OnClientClick="return EditBankAcc();">Edit</asp:LinkButton>
                                            <asp:LinkButton ID="lnkAccDelete" runat="server" OnClientClick="return DeleteBankAcc();">Delete</asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            Routing:
                                        </td>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            <asp:Label cssclass="multidep" ID="lblAccRouting" runat="server" Text="343434343" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            Account:
                                        </td>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            <asp:Label cssclass="multidep" ID="lblAccNumber" runat="server" Text="34132432434" ></asp:Label>&nbsp;
                                            <asp:Label cssclass="multidep" ID="lblAccType" runat="server" Text="Checking" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            Bank Name:
                                        </td>
                                        <td class="multidep" nowrap="nowrap" style="background-color:#e3eff9">
                                            <asp:Label cssclass="multidep" ID="lblAccBankName" runat="server" Text="This is a sample bank's Name" ></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                 </ContentTemplate>
                </asp:UpdatePanel>
                
            </td>
        </tr>
        <tr id="trSave" runat="server" Visible="false">
            <td>
                <asp:LinkButton ID="lnkSaveDeposits" runat="server" CssClass="multidep"  OnClientClick="SaveList();"  >Save</asp:LinkButton>
                <asp:LinkButton ID="lnkCancelDeposits" runat="server" CssClass="multidep" >Cancel</asp:LinkButton>
            </td>
        </tr> 
    </table> 
<asp:UpdateProgress ID="UpdateProgressAccs" runat="server" DisplayAfter="50" AssociatedUpdatePanelID="UpdateAccs" >
<ProgressTemplate>
    <div style="font-family: Tahoma; font-size: 11px; text-align: right; width: 100%; color: Navy;">
        Wait while updating bank account info ...
    </div>
</ProgressTemplate> 
</asp:UpdateProgress>
<asp:HiddenField ID="hdnMaxDeposit" runat="server" Value="4" />
<asp:HiddenField ID="hdnAllowWeeklyDep" runat="server" Value="False" />
<asp:HiddenField ID="hdnDepositList" runat="server" />
<asp:HiddenField ID="hdnClientId" runat="server" Value="0" />
<asp:HiddenField ID="hdnDepositFloor" runat="server" Value="0" />
<asp:HiddenField ID="hdnPerAcctFee" runat="server" Value="0" />
<asp:HiddenField ID="hdnServiceFeeCap" runat="server" Value="0" />
<asp:HiddenField ID="hdnFloorValidation" runat="server" Value="2" />
<asp:DropDownList ID="ddlMonth" runat="server" style="display:none;" CssClass="dropdownMonth" onchange="RebindDepositList();"> 
</asp:DropDownList>
<asp:DropDownList ID="ddlWeek" runat="server" style="display:none;" CssClass="dropdownMonth" onchange="RebindDepositList();"> 
</asp:DropDownList>

<script type="text/javascript">
    function ChangeDDLSourceList(ddl) {
        var cellNode = ddl.parentNode.parentNode.childNodes[2];
        var ddlWhen = cellNode.firstChild;
        var ddlTemp;
        if (ddl.options[ddl.selectedIndex].value == 1)
            ddlTemp = document.getElementById("<%=ddlWeek.ClientId %>").cloneNode(true); 
        else
            ddlTemp = document.getElementById("<%=ddlMonth.ClientId %>").cloneNode(true);

        ddlTemp.setAttribute("id", "ddlWhen");
        ddlTemp.style.display = 'block';
        cellNode.replaceChild(ddlTemp, ddlWhen);  
    }    
    
    function Add_Row() {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var maxDeps = document.getElementById('<%=hdnMaxDeposit.ClientId%>').value;
        if (rowParentNode.childNodes.length <= maxDeps) {
            var newRow = rowParentNode.childNodes[0].cloneNode(true);
            newRow.style.display = 'block';
            rowParentNode.appendChild(newRow);
            RebindDepositList();
            }
        else {
            alert("Maximum deposit limit reached!"); 
        }
    }
    function Delete_Row(imgElem) {
        var row = imgElem.parentElement.parentNode;
        var rule = row.childNodes[3].children[2];
        var deletethis = true;
        if (rule.value != "0") deletethis = confirm('This deposit day has active or future rules. They will become disabled if you delete this record. Do you want to continue?');
        if (deletethis) {
            row.parentNode.removeChild(row);
            RebindDepositList();
            return true;
        } else { 
            return false;
        }
    }
    
    function RebindDepositList() {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var hdnList = document.getElementById("<%=hdnDepositList.ClientId%>"); 
        var ddlWhen;
        var txtAmount;
        var rowid;
        var sep = '';
        var ddlBank;
        var i;
        hdnList.value = '';
        for (i = 1; i < rowParentNode.childNodes.length; i++) { 
            ddlWhen = rowParentNode.childNodes[i].childNodes[2].firstChild;
            txtAmount = rowParentNode.childNodes[i].childNodes[3].firstChild;
            rowid = rowParentNode.childNodes[i].childNodes[3].children[1];
            ddlBank = rowParentNode.childNodes[i].childNodes[4].firstChild;
            hdnList.value = hdnList.value + sep + ddlWhen.options[ddlWhen.selectedIndex].value + "|" + txtAmount.value + "|" + rowid.value + "|" + "0" + "|" + ddlBank.options[ddlBank.selectedIndex].value;
            sep = ';';
        }
    }
    function RemoveAllDeposits() {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        while (rowParentNode.childNodes[1]) {
            rowParentNode.removeChild(rowParentNode.childNodes[1]);
        }
        RebindDepositList();
    }
    function SaveList() {
        RebindDepositList();
        if (!validateDuplicateDays()) {
            alert('There are duplicate deposit days.');
            return false;
        } else {
            return true;
        }
        /*
        if (!validateDateSpace()) {
            alert('The interval between deposits must be at least 7 days.');
            return false; 
        }
        else { 
            return true;
        }*/
    }

    function singleDot(txt, e) {
        var digits = '0123456789';
        var cmds = 'acxvz';
        if ((e.shiftKey == true) ||
                (txt.value.indexOf('.') != -1 && (e.keyCode == 190 || e.keyCode == 110)) ||
                (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
            return false;
        else
            return true;
    }

    function digitOnly(txt, e) {
        var digits = '0123456789';
        if ((e.shiftKey == true) || (e.keyCode==190) || (e.keyCode == 110) || (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
            return false;
        else
            return true;
    }

    function IsSpecialKey(keyCode) {
        if (keyCode == 190 || keyCode == 110 || keyCode == 8 || keyCode == 9 || keyCode == 13 || keyCode == 45 || keyCode == 46 || (keyCode > 16 && keyCode < 21) || (keyCode > 34 && keyCode < 41) || (keyCode > 95 && keyCode < 106))
            return true;
        else
            return false;
    }
    function FormatAmount(txt)
    {
        txt.value = FormatNumber(parseFloat(txt.value), true, 2);
    }
    function ValidateDepositList(totalDebt,acctsToSettle) 
    {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var hdnList = document.getElementById("<%=hdnDepositList.ClientId%>");
        var msg = '';
        var totalDeposit = 0;
        var depositFloor = 0;
        var perAcctFee = parseFloat(document.getElementById("<%=hdnPerAcctFee.ClientId %>").value);
        var serviceFeeCap = parseFloat(document.getElementById("<%=hdnServiceFeeCap.ClientId %>").value);
        var monthlyFee;
        
        // perAcctFee will be greater than zero if this client uses the deposit floor policy that began in 2010 for CID clients only
        if (perAcctFee > 0) {
            // totalDebt gets passed in from Underwriting page, when avail calc depositFloor based on this amount
            if (totalDebt) {
                monthlyFee = perAcctFee * acctsToSettle;
                if (monthlyFee > serviceFeeCap) {
                    monthlyFee = serviceFeeCap;
                }
                if ((totalDebt * 0.01) > (monthlyFee * 2)) {
                    depositFloor = Math.round(totalDebt * 0.01);
                }
                else {
                    depositFloor = Math.round(monthlyFee * 2);
                }
                if (depositFloor < 30) {
                    depositFloor = 30;
                }
            }
            else {
                depositFloor = Math.round(document.getElementById("<%=hdnDepositFloor.ClientId %>").value);
            }
        }
        
        if (rowParentNode.childNodes.length < 2)  
            msg = "At least a scheduled deposit entry is required.";
        else {
            for (i = 1; i < rowParentNode.childNodes.length; i++) {
                txtAmount = rowParentNode.childNodes[i].childNodes[3].firstChild;
                if (txtAmount.value == 0) {
                    msg = "The deposit amount must be greater than zero.";
                    break;
                }
                else {
                    totalDeposit = totalDeposit + parseFloat(txtAmount.value.replace(/,/g, ''));
                }
            }
            if (msg == '') {
                 if (!validateDuplicateDays()) msg = 'There are duplicate deposit days';
            }
           //if (msg == '') {
           //     if (!validateDateSpace()) msg = 'The interval between deposit days must be at least 7 days';
           //}
        }

        // if this client is using the new calculator model, the total deposit must be greater than the floor amount
        var result = CurrencyFormatted(depositFloor)
        if ((totalDeposit < depositFloor) && (depositFloor != 0)) {
            if (document.getElementById("<%=hdnFloorValidation.ClientId %>").value == 2){
                msg += ' Total deposit amount for this client must be at least $' + result + '.'; }
            else {
                if (document.getElementById("<%=hdnFloorValidation.ClientId%>").value == 1) {
                    alert('Warning: The total deposit amount for this client should be at least $' + result + '. The changes will be saved anyway.');
                }
            }
        }
        
        return msg;
    }
    function GetMultiDepositReadOnlyInfo() {
        var htmlcode = '<span style="font-family: Tahoma; font-size: 11px; padding-top: 5px; display: block; height: 24px;">Schedule:</span><table style="font-family: Tahoma; font-size: 11px;" cellspacing="0"><thead style="background-color: #D8D8D8;"><tr><th style="width: 20px;">&nbsp;</th><th align="left" style="font-weight: normal; height: 20px; width: 100px">When</th><th align="right" style="font-weight: normal;padding-right: 10px; width: 60px;">Amount</th></tr></thead><tbody>{0}</tbody></table>';
        var htmlbody = '';
        var htmlrow = '<tr><td style="height: 24px; width: 20px;border-bottom: dotted 1px gray;">{0}:</td><td style="width: 120px;border-bottom: dotted 1px gray;">{1}</td><td align="right" style="width: 60px;border-bottom: dotted 1px gray; padding-right: 10px;">${2}</td></tr>';
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var hdnList = document.getElementById("<%=hdnDepositList.ClientId%>");
        var ddlWhen;
        var txtAmount;
        var i;
        for (i = 1; i < rowParentNode.childNodes.length; i++) {
            ddlWhen = rowParentNode.childNodes[i].childNodes[2].firstChild;
            txtAmount = rowParentNode.childNodes[i].childNodes[3].firstChild;
            htmlbody = htmlbody + htmlrow.replace(/\{0\}/gi, i).replace(/\{1\}/gi,ddlWhen.options[ddlWhen.selectedIndex].text).replace(/\{2\}/gi,txtAmount.value) ;
        }
        return htmlcode.replace(/\{0\}/gi, htmlbody);
    }
    function GetMTD() {
        return document.getElementById('dvMTD').innerHTML;
    }
    function RestoreMTD(image) {
        document.getElementById('dvMTD').innerHTML = image;
        RebindDepositList();
    }
    
    function EditBankAcc() {
        ShowEditMode();
        document.getElementById('<%=txtAccNumber.ClientId %>').setAttribute('readOnly', 'true');
        document.getElementById('<%=txtAccRouting.ClientId %>').setAttribute('readOnly', 'true');
        selectBankAcc();
        return false;
    }

    function IsValidBankInfo() {
        var accnumber =  document.getElementById('<%=txtAccNumber.ClientId %>');
        var routing = document.getElementById('<%=txtAccRouting.ClientId %>');
        var checking = document.getElementById('<%=rdChecking.ClientId %>');
        var saving = document.getElementById('<%=rdSaving.ClientId %>');
        //routing not empty. must have 9 chars. only digists
        if (!RegexValidate(routing.value, "^\\d{9}$")){
            alert('The Routing Number is invalid. It must contain 9 digits.');
            return false;
        }
        //account number not empty. only digits
        if (!RegexValidate(accnumber.value, "^\\d+$")) {
            alert('The Account Number is invalid. It must contain digits only.');
            return false;
        }
        //checking or saving
        if (!checking.checked && !saving.checked) {
            alert('Select the account type Checking or Savings');
            return false;
        }
        return true;
    
    }
    
    function SaveBankAcc() {
        var bankid = document.getElementById('<%=hdnBankAccountId.ClientId %>').value;
        if (!IsValidBankInfo()) return false;
        //ShowDisplayMode();
        return true;
    }

    function DeleteBankAcc() {
        var lnk = document.getElementById('<%=lnkAccDelete.ClientId %>');
        //if (lnk.getAttribute("disabled")) return false;
        var bankid = document.getElementById('<%=hdnBankAccountId.ClientId %>').value;
        if (!canDeleteBank(bankid)) {
            alert('Cannot delete this bank account because is in use');
            return false;
        }
        else
            return true;
    }
    
    function AddBankAcc() {
        ShowEditMode()
        document.getElementById('<%=hdnBankAccountId.ClientId %>').value = "0";
        document.getElementById('<%=txtAccNumber.ClientId %>').value = "";
        document.getElementById('<%=txtAccRouting.ClientId %>').value = "";
        document.getElementById('<%=rdChecking.ClientId %>').checked = true;
        document.getElementById('<%=rdSaving.ClientId %>').checked = false;
        document.getElementById('<%=txtAccNumber.ClientId %>').setAttribute('readOnly', '');
        document.getElementById('<%=txtAccRouting.ClientId %>').setAttribute('readOnly', '');
        return false;
    }
    
    function CancelBankAcc() {
        ShowDisplayMode();
        selectBankAcc();
        return false;
    }
    
    function ShowEditMode() {
        var trEditAcc = document.getElementById('<%=trEditBankAcc.ClientId %>');
        var trDisplayAcc = document.getElementById('<%=trDisplayBankAcc.ClientId %>');
        trEditAcc.style.display = 'block';
        trDisplayAcc.style.display = 'none'; 
    }
    
    function ShowDisplayMode() {
        var trEditAcc = document.getElementById('<%=trEditBankAcc.ClientId %>');
        var trDisplayAcc = document.getElementById('<%=trDisplayBankAcc.ClientId %>');
        trEditAcc.style.display = 'none';
        trDisplayAcc.style.display = 'block';
    }

    function ShowBanking() {
        var lnk = document.getElementById('<%= lnkShowBankAcc.ClientId%>');
        var tbl = document.getElementById("<%= tableBanking.ClientId%>");
        if (tbl.style.display == 'none') {
            tbl.style.display = 'block';
            lnk.innerText = 'Hide Banking Information'; 
        }
        else {
            tbl.style.display = 'none';
            lnk.innerText = 'Show Banking Information';
        }
        return false;
    }

    function selectBankAcc() {
        var ddl = document.getElementById('<%=ddlBankAccountInfo.ClientId %>');
        if (ddl.options.length == 0) return; 
        var ddlvalue = ddl.options[ddl.selectedIndex].value;
        var arrvalue = ddlvalue.split('|');
        document.getElementById('<%=hdnBankAccountId.ClientId %>').value = arrvalue[0];
        document.getElementById('<%=lblAccNumber.ClientId %>').innerText = arrvalue[1];
        document.getElementById('<%=txtAccNumber.ClientId %>').value = arrvalue[1];
        document.getElementById('<%=lblAccRouting.ClientId %>').innerText = arrvalue[2];
        document.getElementById('<%=txtAccRouting.ClientId %>').value = arrvalue[2];
        document.getElementById('<%=lblAccType.ClientId %>').innerText = "(" + ((arrvalue[3] == "S") ? "Savings" : "Checking") + ")";
        document.getElementById('<%=rdChecking.ClientId %>').checked = (arrvalue[3] == "C");
        document.getElementById('<%=rdSaving.ClientId %>').checked = (arrvalue[3] == "S");
        document.getElementById('<%=lblAccBankName.ClientId %>').innerText = arrvalue[4].substring(0,23);
        //document.getElementById('<%=lnkAccDelete.ClientId %>').disabled = (arrvalue[5] != 0); 
    }

    function reloadBanks(bankid, description) {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var i;
        var j;
        var assigned = false;
        var elemOption;
        var ddlBank;
        for (i = 0; i < rowParentNode.childNodes.length; i++) {
            ddlBank = rowParentNode.childNodes[i].childNodes[4].firstChild;
            assigned = false;
            for (j = 0; j < ddlBank.options.length; j++) {
                elemOption = ddlBank.options[j];
                if (elemOption.value == bankid) {
                    elemOption.innerHTML = description;
                    elemOption.text = description;
                    assigned = true;
                    //break;
                }
                
            }
            if (!assigned) {
                elemOption = document.createElement('<option>');
                ddlBank.options.add(elemOption, ddlBank.options.length-1);
                elemOption.innerText = description;
                elemOption.value = bankid; 
            }
        }
    }

    function removeBank(bankid) {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var i;
        var j;
        var ddlBank;
        for (i = 0; i < rowParentNode.childNodes.length; i++) {
            ddlBank = rowParentNode.childNodes[i].childNodes[4].firstChild;
            for (j = 0; j < ddlBank.options.length; j++) {
                if (ddlBank.options[j].value == bankid) {
                    ddlBank.remove(j);
                }
            }
        }
    }

    function canDeleteBank(bankid) {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var i;
        var ddlBank;
        for (i = 1; i < rowParentNode.childNodes.length; i++) {
            ddlBank = rowParentNode.childNodes[i].childNodes[4].firstChild;
            if (ddlBank.options[ddlBank.selectedIndex].value == bankid) return false;
        }
        return true;
    }

    function validateDateSpace() {
        var dayspace = 7;
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var ddlWhen;
       
        var i;
        if (rowParentNode.childNodes.length > 2) {
            var days = new Array(rowParentNode.childNodes.length - 1);
            for (i = 1; i < rowParentNode.childNodes.length; i++) {
                ddlWhen = rowParentNode.childNodes[i].childNodes[2].firstChild;
                days[i-1] = ddlWhen.options[ddlWhen.selectedIndex].value.split("_")[2];
            }
            days.sort(sortNumber);
            var lastdate = new Date(2009, 6, days[days.length - 1]); 
            var thisdate;
            for (i = 0; i < days.length; i++) {
                thisdate = new Date(2009, 7, days[i]);
                if (getDiffDays(lastdate, thisdate) < dayspace) return false;
                lastdate = thisdate;
            }
        }
        return true;
    }
    
    function sortNumber(a, b) {
        return a - b;
    }

    function getDiffDays(d1, d2) {
        return Math.ceil((d2.getTime() - d1.getTime()) / (60*60*24*1000));
    }

    function validateDuplicateDays() {
        var rowParentNode = document.getElementById('tblDepositDetails').childNodes[1];
        var ddlWhen;

        var i;
        if (rowParentNode.childNodes.length > 2) {
            var days = new Array(rowParentNode.childNodes.length - 1);
            for (i = 1; i < rowParentNode.childNodes.length; i++) {
                ddlWhen = rowParentNode.childNodes[i].childNodes[2].firstChild;
                days[i - 1] = ddlWhen.options[ddlWhen.selectedIndex].value.split("_")[2];
            }
            days.sort(sortNumber);
            var lastday = 0;
            for (i = 0; i < days.length; i++) {
                if (lastday == days[i]) return false;
                lastday = days[i];
            }
        }
        return true;
    }

    function CurrencyFormatted(amount) {
        var i = parseFloat(amount);
        if (isNaN(i)) { i = 0.00; }
        var minus = '';
        if (i < 0) { minus = '-'; }
        i = Math.abs(i);
        i = parseInt((i + .005) * 100);
        i = i / 100;
        s = new String(i);
        if (s.indexOf('.') < 0) { s += '.00'; }
        if (s.indexOf('.') == (s.length - 2)) { s += '0'; }
        s = minus + s;
        return s;
    }


    
</script> 