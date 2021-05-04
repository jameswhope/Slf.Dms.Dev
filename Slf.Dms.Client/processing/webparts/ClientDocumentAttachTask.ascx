<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientDocumentAttachTask.ascx.vb"
    Inherits="ClientDocumentAttachTask" %>

<script type="text/javascript">
    function cancelClick() { }
    function ReceiveServerData(arg, context) { }
    function pageLoad() {
        initDropTargets();
        initDragSources();

        TogglePannel('holder', true);
    }
    function TogglePannel(target, OnOff) {
        obj = document.getElementById(target);
        if (obj) {
            obj.style.display = (OnOff) ? 'inline' : 'none';
        }
    }
    function AddClientDragSource(obj, settlementInfo) {
        try { var clientdrag = new DragNDrop.ClientDragSourceBehavior($get(obj), settlementInfo); }
        catch (e) { }
    }
    function AddDragSource(obj, path) {
        var drag = new DragNDrop.DocumentDragSourceBehavior($get(obj), path);
    }
    function AddDropTarget(obj) {
        var dv = $get(obj);
        dv.style.backgroundColor = '#98FB98';
        dv.style.border = 'solid 1px #228B22';
        var drop = new DragNDrop.DocumentDropTargetBehavior(dv);
    }
    function initDragSources() {
        var pnl = document.getElementById('<%=fldSIFS.ClientID %>');
        try {
            var imgs = pnl.getElementsByTagName('img');
            if (imgs.length != 0) {
                for (var i = 0; i < imgs.length; i++) {
                    var imgID = imgs[i].id
                    if (imgID != '' && imgID.indexOf('img_sif') != -1) {
                        AddDragSource(imgID, imgs[i].src);
                    }
                }
            }
        }
        catch (e) { }

    }
    function initDropTargets() {

    }
    function removeItem(obj) {
        var fld = document.getElementById(obj);
        if (fld == null) {
            fld = document.getElementById('ctl00_cphBody_AttachSif1_' + obj);
        }
        try {
            var parent = fld.parentNode;
            parent.removeChild(fld)
            CallServer('removeclientdrop' + '|' + fld.id + '|' + fld.children[1].id);
        }
        catch (e) { }

    }

    function removeImg(img) {
        alert(img.src);
    }


    function removeDoc(obj) {
        try {
            var imgs = obj.getElementsByTagName('img');
            obj.removeChild(imgs[imgs.length - 1]);
        }
        catch (e) { }

    }
    function ChangeFileName(fileName) {
        var fileTypes = ".tif,.tiff,.TIFF,.TIF".split(',');

        if (!fileName) return;

        dots = fileName.split(".")
        //get the part AFTER the LAST period.
        fileType = "." + dots[dots.length - 1];

        if (fileTypes.join(".").indexOf(fileType) != -1) {
            //document.getElementById('fileName').value = fileName;
            document.getElementById('<%= divUploadError.ClientID %>').style.display = 'none';
        } else {
            //document.getElementById('fileName').value = '';
        }

        return (fileTypes.join(".").indexOf(fileType) != -1) ? true : alert("Please only upload files that end in types: \n\n" + (fileTypes.join(" .")) + "\n\nPlease select a new file and try again.");

    }

    function trim(stringToTrim) {
        return stringToTrim.replace(/^\s+|\s+$/g, "");
    }
    function closePopup() {
        var modalPopupBehavior = $find('mpeAttachBehavior');
        modalPopupBehavior.hide();
    }
    function showPopup(chkObj, settID, credAcctID) {
        if (chkObj.checked == true) {
            var hdn = document.getElementById('<%=hdnChkID.ClientID %>');
            hdn.value = chkObj.id;
            //get accounts
            PageMethods.PM_getLikeAccounts(settID, credAcctID, chkObj.id, OnRequestComplete, OnRequestError);
            var modalPopupBehavior = $find('mpeAttachBehavior');
            modalPopupBehavior.show();
        } else {
            //show div attach
            var hdn = document.getElementById('<%=hdnChkID.ClientID %>');
            var chk = document.getElementById(hdn.value);
            var tbl = findParentTBL(chk);
            var dAttach = document.getElementById('<%=divAttach.ClientID %>');
            dvs[j].parentElement.style.display = 'none';
            dvs[j].style.display = 'none';
        }
        return false;
    }
    function submitOverride() {
        //show div attach
        var hdn = document.getElementById('<%=hdnChkID.ClientID %>');
        var chk = document.getElementById(hdn.value);
        var prow = chk.parentElement.parentElement;
        var dvs = prow.parentElement.parentElement.parentElement.parentElement.getElementsByTagName('div');
        var dHdn = document.getElementById('<%= hdnOverrideAcctID.ClientID %>');

        try {
            var strOverrideReasons = '';

            var d = document.getElementById('<%= divOverride.ClientID %>');
            var rws = d.getElementsByTagName('tr');
            for (var r in rws) {
                if (rws[r].innerHTML != undefined) {
                    var tds = rws[r].getElementsByTagName('td');
                    for (var td in tds) {
                        if (tds[td].innerHTML != undefined) {
                            if (tds[td].children[0] != undefined) {
                                if (tds[td].children[0].checked == true) {
                                    strOverrideReasons += ';' + tds[td].children[0].value;
                                }
                            }
                        }
                    }
                }
            }
            dHdn.value = strOverrideReasons;
            AddDropTarget('<%=divAttach.ClientID %>');
        }
        catch (e) { alert(e.description) }
        finally {
            var modalPopupBehavior = $find('mpeAttachBehavior');
            modalPopupBehavior.hide();
            return false;
        }


    }
    function OnRequestError(error, userContext, methodName) {
        if (error != null) {
            alert(error.get_message());
        }
    }
    function OnRequestComplete(result, userContext, methodName) {
        var apObj = eval('(' + result + ')');
        var div = document.getElementById('<%=divOverride.ClientID %>');
        div.parentElement.style.display = 'block';
        var ld = document.getElementById('divLoading');
        ld.style.display = 'none';
        div.innerHTML = apObj.tableData;
    }
    function validateTextBox(realVal, newVal, controlObj) {
        if (realVal != newVal) {
            controlObj.style.backgroundColor = '#ffcccc';
            controlObj.style.border = 'solid 1px red';
            return false;
        } else {
            controlObj.style.backgroundColor = '#98FB98';
            controlObj.style.border = 'solid 1px #228B22';
            controlObj.setAttribute('readOnly', 'readonly');
            return true;
        }
    }
    function validateRadioButton(controlObj) {
        var radio = controlObj.getElementsByTagName("input");
        for (var i = 0; i < radio.length; i++) {
            if (radio[i].checked) {
                if (radio[i].value == 'NO') {
                    controlObj.style.backgroundColor = '#ffcccc';
                    controlObj.style.border = 'solid 1px red';
                    return false;
                } else {
                    controlObj.style.backgroundColor = '#98FB98';
                    controlObj.style.border = 'solid 1px #228B22';
                    controlObj.setAttribute('readOnly', 'readonly');
                    return true;
                }
            }
        }
    }
    function VerifyData(dataName) {
        var bShowOverride = false;
        var oCnt = 0;
        var bValid = true;
        var oreason = new String;
        oreason = '';
        try {
            var lblID = dataName.id;
            if (lblID.indexOf('rbl') == -1) {
                var fldName = lblID.replace('TextBox', '')
                fldName = fldName.substring(fldName.lastIndexOf('_') + 1)
                var lbl = document.getElementById(lblID.replace('TextBox', 'Label'));
                var realValue = dataName.value.replace('$', '').replace(',', '');
                var verifyValue = lbl.value.replace('$', '').replace(',', '');
                bValid = validateTextBox(realValue, verifyValue, dataName);
            } else {
                bValid = validateRadioButton(dataName);
            }

            //check other fields, if all valid show drop sif
            var fld = document.getElementById('<%=fldSifDetail.ClientID %>');
            var txts = fld.getElementsByTagName('input');
            for (var i in txts) {
                if (txts[i].value != undefined && txts[i].value != 'Verify') {
                    if (txts[i].id.indexOf('Label') == -1 && txts[i].id.indexOf('Image') == -1) {
                        var tname = txts[i].id;
                        var tval = txts[i].value;
                        if (tval == undefined) {
                            tval = ' ';
                        }
                        tname = tname.substring(tname.lastIndexOf('_') + 1);
                        tname = tname.replace('TextBox', '');
                        switch (tname) {
                            case 'SettlementAmount': case 'SettlementDueDate': case 'CreditorAccountBalance': case 'CreditorReferenceNumber':
                                if (txts[i].readOnly == false) {
                                    bValid = false;
                                    var txt = document.getElementById(txts[i].id.replace('TextBox', 'Label'));
                                    var rVal = txt.value;
                                    oreason += tname + '*' + rVal.replace('$', '').replace(',', '') + '*' + tval.replace('$', '').replace(',', '') + ',';
                                    txts[i].style.backgroundColor = '#ffcccc';
                                    txts[i].style.border = 'solid 1px red';
                                } else {
                                    oCnt += 1;
                                }
                                break;
                            case 'CreditorAccountNumberFull':
                                if (txts[i].readOnly == false) {
                                    bValid = false;
                                    var txt = document.getElementById(txts[i].id.replace('TextBox', 'Label'));
                                    var rVal = txt.value;
                                    oreason += tname + '*' + rVal.replace('$', '').replace(',', '') + '*' + tval.replace('$', '').replace(',', '') + ',';
                                    txts[i].style.backgroundColor = '#ffcccc';
                                    txts[i].style.border = 'solid 1px red';
                                    bShowOverride = true;
                                }
                                break;
                            case 'CheckPayable':
                                break;
                            case 'SpecialInstructions':
                                break;
                            default:
                                //uncomment to show new fields added
                                //alert(txts[i].id);
                                break;
                        }
                    }
                }
            }
            var rbls = dataName.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByTagName('table');
            for (var r in rbls) {
                if (rbls[r].id != undefined && rbls[r].id != '') {
                    var rname = rbls[r].id;
                    rname = rname.substring(rname.lastIndexOf('_') + 1);
                    switch (rname) {
                        case 'rblClientNameMatch': case 'rblCreditorNameMatch':
                            var radio = rbls[r].getElementsByTagName("input");
                            for (var i = 0; i < radio.length; i++) {
                                if (radio[i].checked) {
                                    if (radio[i].value == 'NO') {
                                        bValid = false;
                                        oreason += rname.replace('rbl', '') + ',';
                                        rbls[r].style.backgroundColor = '#ffcccc';
                                        rbls[r].style.border = 'solid 1px red';
                                    } else {
                                        oCnt += 1;
                                    }
                                }
                            }
                            break;
                        default: break;
                    }
                }
            }

            var vOverDivID = new String;
            if (bValid == true) {
                AddDropTarget('<%=divAttach.ClientID %>');
                var c = document.getElementById('<%=chkOverride.ClientID %>');
                c.parentElement.style.display = 'none';
            } else {
                //alert("Not all fields verified!");
                if (bShowOverride == true && oCnt == 6) {
                    var c = document.getElementById('<%=chkOverride.ClientID %>');
                    c.parentElement.style.display = 'inline-block';
                }
            }
            var o = document.getElementById('<%=OverrideReasonHidden.ClientID %>');
            var dHdn = document.getElementById('<%= hdnOverrideAcctID.ClientID %>');
            o.value = oreason.substring(0, oreason.length - 1) + dHdn.value;

        }
        catch (e) {
            dataName.style.backgroundColor = '';
            dataName.style.border = 'solid 1px black';
            alert(e.description);
        }
    }

    function findParentTBL(childObj) {
        if (childObj.parentElement.nodeName == 'TABLE') {
            return childObj.parentElement;
        } else {
            return findParentTBL(childObj.parentElement);
        }

    }
</script>

<script type="text/javascript">
    function AttachSettlementDocument() {
         <%=Page.ClientScript.GetPostBackEventReference(lnkAttach, Nothing) %>;
    }
</script>
<%--<ajaxToolkit:ToolkitScriptManager  CombineScripts="false" ID="smpAttach" runat="server">
    
</ajaxToolkit:ToolkitScriptManager>--%>
<div id="divDocuments" class="entry">
    <div id="dvSettlementMsg" runat="server">
    </div>
    <table class="entry2">
        <tr>
            <td>
                <asp:Panel ID="pnlTop" runat="server" BackColor="#C6DEF2">
                    <fieldset id="fldSifDetail" runat="server" style="display: block; padding: 3px; border: none;"
                        class="entry">
                        <asp:Panel ID="pnlClientName" runat="server" Style="width: 100%; font-weight: bold;
                            font-family: Tahoma; font-size: 12px; padding: 3px; background-color: #4791C5;
                            color: #fff; text-align: left;">
                            <asp:CheckBox ID="chkOverride" runat="server" Text="Override" AutoPostBack="false"
                                Style="display: none;" />
                        </asp:Panel>
                        <ajaxToolkit:RoundedCornersExtender ID="RoundedCornersExtender1" runat="server" TargetControlID="pnlClientName"
                            Corners="All" Radius="8" />
                        <table class="entry">
                            <tr>
                                <td>
                                    <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="lblClientNameMatch" runat="server" Text="Client Match?" Font-Size="10px" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblClientNameMatch" runat="server" CssClass="entry2" RepeatDirection="Horizontal"
                                                    onclick="VerifyData(this);" Font-Size="10px">
                                                    <asp:ListItem Text="YES" />
                                                    <asp:ListItem Selected="True" Text="NO" />
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label2" runat="server" Text="Sett Amt $" CssClass="entry2" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="SettlementAmountTextBox" runat="server" CssClass="entry2" Style="border: solid 1px black;
                                                    margin-right: 0px;" Text="" onblur="VerifyData(this);" Font-Size="10px" />
                                                <ajaxToolkit:FilteredTextBoxExtender ID="SettlementAmountTextBoxFilteredTextBoxExtender"
                                                    runat="server" TargetControlID="SettlementAmountTextBox" ValidChars=".,0123456789" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label3" runat="server" Text="Sett Due Date" CssClass="entry2" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="SettlementDueDateTextBox" runat="server" CssClass="entry2" onchange="VerifyData(this);"
                                                    Style="border: solid 1px black" Text="" Font-Size="10px" Width="75px" />
                                                <asp:ImageButton ID="Image1" runat="Server" AlternateText="Click to show calendar"
                                                    ImageAlign="AbsMiddle" ImageUrl="~/images/Calendar_scheduleHS.png" />
                                                <ajaxToolkit:CalendarExtender ID="extDueDate" runat="server" TargetControlID="SettlementDueDateTextBox"
                                                    PopupButtonID="image1" CssClass="MyCalendar" Format="MM/dd/yyyy" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label4" runat="server" Text="Payable To" CssClass="entry2" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox CssClass="entry2" ID="CheckPayableTextBox" runat="server" Text="" Style="border: solid 1px black"
                                                    onblur="VerifyData(this);" Font-Size="10px" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="lblCreditorNameMatch" runat="server" Text="Creditor Match?" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:RadioButtonList ID="rblCreditorNameMatch" runat="server" CssClass="entry2" RepeatDirection="Horizontal"
                                                    onclick="VerifyData(this);" Font-Size="10px">
                                                    <asp:ListItem Text="YES" />
                                                    <asp:ListItem Selected="True" Text="NO" />
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label7" runat="server" Text="Acct Bal $" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="CreditorAccountBalanceTextBox" runat="server" CssClass="entry2"
                                                    Style="border: solid 1px black" Text="" onblur="VerifyData(this);" Font-Size="10px" />
                                                <ajaxToolkit:FilteredTextBoxExtender ID="CreditorAccountBalanceTextBoxFilteredTextBoxExtender"
                                                    runat="server" TargetControlID="CreditorAccountBalanceTextBox" ValidChars=".,0123456789" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label5" runat="server" Text="Acct #" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="CreditorAccountNumberFullTextBox" runat="server" CssClass="entry2"
                                                    Style="border: solid 1px black" Text="" onblur="VerifyData(this);" Font-Size="10px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tblHdr">
                                                <asp:Label ID="Label6" runat="server" Text="Ref #" Font-Size="10px" />
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="CreditorReferenceNumberTextBox" runat="server" CssClass="entry2"
                                                    Font-Size="10px" Style="border: solid 1px black" Text="" onblur="VerifyData(this);" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset>
                                        <legend>Specials Instructions:</legend>
                                        <asp:TextBox ID="SpecialInstructionsTextBox" runat="server" CssClass="entry" Height="50"
                                            TextMode="MultiLine" Style="overflow-y: scroll; overflow-x: hidden;" />
                                    </fieldset>
                                </td>
                                <td>
                                    <fieldset style="padding: 3px;">
                                        <legend>Drop documents here</legend>
                                        <div id="divAttach" runat="server" style="display: block; width: 100%; height: 50px;
                                            overflow: auto; background-color: Gray; padding: 5px;" onclick="removeDoc(this);"
                                            title="Will become enabled after blind audit!">
                                        </div>
                                    </fieldset>
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="hdnOverrideAcctID" runat="server" />
                        <asp:HiddenField ID="OverrideReasonHidden" runat="server" />
                        <div style="display: none;">
                            <asp:HiddenField ID="SettlementAmountLabel" runat="server" />
                            <asp:HiddenField ID="SettlementDueDateLabel" runat="server" />
                            <asp:HiddenField ID="CreditorAccountBalanceLabel" runat="server" />
                            <asp:HiddenField ID="CreditorAccountNumberFullLabel" runat="server" />
                            <asp:HiddenField ID="CreditorReferenceNumberLabel" runat="server" />
                            <asp:HiddenField ID="OriginalCreditorNameLabel" runat="server" />
                            <asp:HiddenField ID="CreditorNameLabel" runat="server" />
                            <asp:HiddenField ID="CheckPayableLabel" runat="server" />
                        </div>
                    </fieldset>
                </asp:Panel>
                <ajaxToolkit:RoundedCornersExtender ID="pnlTop_RoundedCornersExtender" runat="server"
                    TargetControlID="pnlTop" Corners="All" Radius="8" />
            </td>
        </tr>
    </table>
    <table style="max-width: 800px">
        <tr>
            <td valign="top">
                <asp:Panel ID="pnlSIFDocs" runat="server" GroupingText="SIF Documents">
                    <fieldset id="fldSIFS" runat="server" visible="false">
                        <legend>Drag document to client row - (<asp:LinkButton ID="btnResetUpload" runat="server"
                            Text="Upload New Document" />)</legend>
                        <asp:PlaceHolder ID="phSIFs" runat="server" />
                    </fieldset>
                    <fieldset id="fldUpload" runat="server">
                        <legend>Upload TIF for Processing</legend>
                        <table border="0">
                            <tr valign="top">
                                <td style="white-space: nowrap; padding: 2px; vertical-align: middle;">
                                    <asp:FileUpload ID="filSif" runat="server" Height="25px" Width="400px" />
                                </td>
                                <td style="text-align: right; padding: 2px; vertical-align: middle; width: 50px;">
                                    <asp:Button ID="btnUpload" runat="server" Text="Upload" Height="25px" CssClass="entry" />
                                </td>
                            </tr>
                        </table>
                        <div id="divUploadError" runat="server" style="display: none; font-size: 11pt;" class="warning">
                        </div>
                    </fieldset>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <div id="updateSifDIV" style="display: none; height: 40px; width: 40px; text-align: center;">
        Processing...<br />
        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
    </div>
</div>
<asp:LinkButton ID="lnkAttach" runat="server" />
<asp:Button ID="btnDummy" runat="server" Style="display: none;" />
<ajaxToolkit:ModalPopupExtender ID="mpeAttach" BehaviorID="mpeAttachBehavior" runat="server"
    BackgroundCssClass="PickerModalBackground" PopupControlID="pnlAttachPop" PopupDragHandleControlID="pnlDrag"
    TargetControlID="btnDummy" Y="50">
</ajaxToolkit:ModalPopupExtender>
<asp:Panel ID="pnlAttachPop" runat="server" CssClass="PickerModalPopup" Style="display: none">
    <asp:Panel ID="pnlDrag" runat="server" Style="display: block;" CssClass="PanelDragHeader">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr class="headerstyle">
                <td align="left" style="padding-left: 10px;">
                    <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Override Audit" />
                </td>
                <td align="right" style="padding-right: 5px;">
                    <asp:ImageButton ID="imgClose" runat="server" OnClientClick="closePopup();return false;"
                        ImageUrl="~/images/16x16_close.png" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlDueDate" runat="server" Style="text-align: left; display: block;
        vertical-align: top;" CssClass="entry2">
        <div class="entry2" style="padding: 10px; padding-right: 15px;">
            <div id="divAcceptMsg" runat="server" style="display: none;" />
            <div id="divLoading" style="display: block; text-align: center;" class="entry">
                Loading...<br />
                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
            <fieldset id="fldOverride" class="entry" style="display: none;">
                <legend>Select account match: </legend>
                <div id="divOverride" runat="server" style="height: 250px; overflow-y: scroll; overflow-x: hidden;">
                </div>
            </fieldset>
            <br />
            <asp:HiddenField ID="hdnChkID" runat="server" />
        </div>
        <table class="entry" border="0" style="background-color: #DCDCDC; border-top: solid 1px #3D3D3D;">
            <tr valign="middle">
                <td>
                    <div class="entry" style="text-align: right; padding-right: 3px; height: 25px; vertical-align: middle;">
                        <asp:Button ID="lnkContinue" runat="server" Text="Override" OnClientClick="return submitOverride();"
                            CssClass="fakeButtonStyle" />
                        <asp:Button ID="lnkCancel" runat="server" Text="Cancel" OnClientClick="closePopup();return false;"
                            CssClass="fakeButtonStyle" />
                    </div>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlSettAcceptForm" Style="display: none; text-align: center;" runat="server"
        Width="100%">
        <iframe id="rptFrame" runat="server" src="" style="width: 100%; height: 400px"></iframe>
    </asp:Panel>
</asp:Panel>
<asp:HiddenField ID="hdnFile" runat="server" />
