<%@ Page Title="" Language="VB" MasterPageFile="~/negotiation/Negotiation.master"
    AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="negotiation_attach_AttachGrid"
    EnableEventValidation="false" %>

<%@ MasterType TypeName="negotiation_Negotiation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .ajax__tab_default .ajax__tab_header
        {
            white-space: normal;
        }
        .ajax__tab_default .ajax__tab_outer
        {
            display: -moz-inline-box;
            display: inline-block;
        }
        .ajax__tab_default .ajax__tab_inner
        {
            display: -moz-inline-box;
            display: inline-block;
        }
        .ajax__tab_default .ajax__tab_tab
        {
            margin-right: 4px;
            overflow: hidden;
            text-align: center;
            cursor: pointer;
            display: -moz-inline-box;
            display: inline-block;
        }
       
    </style>
    <script type="text/javascript">
        //functions used in callbacks
        function cancelClick() { }
        function ReceiveServerData(arg, context) { }
    </script>
    <script type="text/javascript">
        //javascript image zoom functions
        //called from each document panel
        function Zoom(zoomPercent, imgIdx) {
            //get tab
            var tabID = 'ctl00_ctl00_cphBody_cphBody_tabSifDocuments_SifTab' + imgIdx;
            //get label
            var lblID = tabID + '_lblZoomVal_' + imgIdx;
            var lbl = document.getElementById(lblID);
            var iZoom = lbl.innerHTML;
            //get current zoom value
            iZoom = parseFloat(iZoom) + parseFloat(zoomPercent);

            //dont allow zoom under 100 or over 200
            if (iZoom < 100) {
                iZoom = 100;
            } else if (iZoom > 200) {
                iZoom = 200;
            }
            lbl.innerHTML = iZoom;
            var imgID = tabID + '_img_sif_' + imgIdx;
            var img = document.getElementById(imgID)
            img.style.zoom = iZoom + '%';

            var txtID = tabID + '_txtZoom_' + imgIdx;
            var txt = document.getElementById(txtID);
            txt.value = iZoom;

            $find("Slider_" + imgIdx).set_Value(iZoom);
        }

        function SlideZoom(imgIdx) {
            var tabID = 'ctl00_ctl00_cphBody_cphBody_tabSifDocuments_SifTab' + imgIdx;
            var txtID = tabID + '_txtZoom_' + imgIdx;
            var txt = document.getElementById(txtID);

            var iZoom = txt.value;
            iZoom = parseFloat(iZoom);

            if (iZoom < 100) {
                iZoom = 100;
            } else if (iZoom > 200) {
                iZoom = 200;
            }
            var imgID = tabID + '_img_sif_' + imgIdx;
            var img = document.getElementById(imgID)
            img.style.zoom = iZoom + '%';
        }
    </script>

    <script type="text/javascript">
        function pageLoad() {
            initDropTargets();
            initDragSources();

            //var drop = new DragNDrop.ClientDropTargetBehavior($get('<%=gvClients.ClientID %>'));
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
            //AddDropTarget('<%=divAttach.ClientID %>');
            //        var gv = $get('<%=gvClients.ClientID %>')
            //        var divs = gv.getElementsByTagName('div');
            //        for (var i = 0; i < divs.length; i++) {
            //            if (divs[i].id != undefined) {
            //                var dID = divs[i].id;
            //                if (dID.indexOf('divAttach') != -1) {
            //                    AddDropTarget(dID);
            //                }
            //            }
            //        }
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

    <asp:ScriptManagerProxy ID="smpAttach" runat="server">
        <Scripts>
            <asp:ScriptReference Name="PreviewScript.js" Assembly="Microsoft.Web.Preview" />
            <asp:ScriptReference Name="PreviewDragDrop.js" Assembly="Microsoft.Web.Preview" />
            <asp:ScriptReference Path="AttachSIFDragNDrop.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <asp:UpdatePanel ID="upSifs" runat="server">
        <ContentTemplate>
            <div class="entry" style="position:absolute; top:5px; bottom:5px;height: expression(document.body.clientHeight - 100 + 'px');width: expression(document.body.clientWidth + 'px');">
                <div style="border: solid 1px black; text-align: center; width: 60%; margin: 0 auto;
                    display: none; padding: 10px;" id="divMsg" runat="server" class="success">
                    <asp:PlaceHolder ID="phMsg" runat="server" />
                    <asp:LinkButton ID="lnkClose" runat="server" Text="Close" OnClientClick="this.parentElement.style.display = 'none';return false;"
                        CssClass="lnk" />
                </div>
                <table style="width: 100%; height:100%; " border="0">
                    <tr valign="top" align="left">
                        <td style="width:450px;">
                            <table class="entry" border="0">
                                <tr valign="top">
                                    <td align="center">
                                        <div id="pnlTop" style="background-color: #C6DEF2">
                                            <div id="lblNoSelect" runat="server" style="display: block; text-align: center; padding: 5px;
                                                font-weight: bold;">
                                                No client selected</div>
                                            <fieldset id="fldSifDetail" runat="server" style="display: none; padding: 3px; border: none;"
                                                class="entry">
                                                <div id="pnlClientName" runat="server" style="width: 100%; font-weight: bold; font-family: Tahoma;
                                                    font-size: 12px; padding: 3px; background-color: #4791C5; color: #fff; text-align: left;">
                                                    <asp:Label ID="lblClientName" CssClass="entry2" ForeColor="white" runat="server"
                                                        Text="Client/Creditor Info" />
                                                    <asp:CheckBox ID="chkOverride" runat="server" Text="Override" AutoPostBack="false"
                                                        Style="display: none;" />
                                                </div>
                                                <table class="entry">
                                                    <tr>
                                                        <td>
                                                            <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td class="tblHdr">
                                                                        <asp:Label ID="lblClientNameMatch" runat="server" Text="Client Match?" Font-Size="10px" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:RadioButtonList ID="rblClientNameMatch" runat="server" CssClass="entry" RepeatDirection="Horizontal"
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
                                                                        <asp:TextBox ID="SettlementAmountTextBox" runat="server" CssClass="entry" Style="border: solid 1px black;
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
                                                                        <asp:TextBox ID="SettlementDueDateTextBox" runat="server" CssClass="entry" onchange="VerifyData(this);"
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
                                                                        <asp:TextBox CssClass="entry" ID="CheckPayableTextBox" runat="server" Text="" Style="border: solid 1px black"
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
                                                                        <asp:RadioButtonList ID="rblCreditorNameMatch" runat="server" CssClass="entry" RepeatDirection="Horizontal"
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
                                                                        <asp:TextBox ID="CreditorAccountBalanceTextBox" runat="server" CssClass="entry"
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
                                                                        <asp:TextBox ID="CreditorAccountNumberFullTextBox" runat="server" CssClass="entry"
                                                                            Style="border: solid 1px black" Text="" onblur="VerifyData(this);" Font-Size="10px" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="tblHdr">
                                                                        <asp:Label ID="Label6" runat="server" Text="Ref #" Font-Size="10px" />
                                                                    </td>
                                                                    <td align="left">
                                                                        <asp:TextBox ID="CreditorReferenceNumberTextBox" runat="server" CssClass="entry"
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
                                                    <tr>
                                                        <td align="right" colspan="2">
                                                            <table class="entry">
                                                                <tr>
                                                                    <td>
                                                                        <div id="dvSettlementMsg" runat="server">
                                                                        </div>
                                                                    </td>
                                                                    <td style="width: 75px;">
                                                                        <asp:Button ID="btnAttachManual" runat="server" Text="Process SIF" />
                                                                    </td>
                                                                </tr>
                                                            </table>
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
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:Panel ID="fldWaiting" runat="server" GroupingText="Waiting on Sif" Width="450px" style="position:relative;bottom:5px;">
                                <div class="entry2" style="padding-top: 3px;">
                                    
                                    <div style="padding: 3px;padding-bottom: 3px; background-color:#C6DEF2">
                                        Search:<asp:TextBox ID="txtsearch" runat="server" CssClass="entry2" Width="50%" />
                                        <asp:LinkButton ID="lnkSearch" runat="server" Text="Search" />
                                        <asp:Literal ID="litSpac3" runat="server" Text=" | " />
                                        <asp:LinkButton ID="lnkClearSearch" runat="server" Text="Clear" />
                                        </div>
                                    
                                    <div style="height: 300px; overflow-y: scroll; overflow-x: hidden;">
                                        <asp:GridView ID="gvClients" runat="server" EnableSortingAndPagingCallbacks="True"
                                            AutoGenerateColumns="False" CellPadding="4" DataSourceID="dsSearch" GridLines="None"
                                            PageSize="12" CssClass="entry2" AllowPaging="false" AllowSorting="True" DataKeyNames="SettlementID">
                                            <Columns>
                                                <asp:BoundField DataField="SettlementID" HeaderText="SettlementID" SortExpression="SettlementID"
                                                    Visible="false" />
                                                <asp:BoundField DataField="clientid" HeaderText="clientid" SortExpression="clientid"
                                                    Visible="false" />
                                                <asp:BoundField DataField="creditoraccountid" HeaderText="creditoraccountid" SortExpression="creditoraccountid"
                                                    Visible="false" />
                                                <asp:BoundField DataField="ClientAccountNumber" HeaderText="Client #" SortExpression="ClientAccountNumber">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Width="50" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Width="50" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Client Name" HeaderText="Client Name" SortExpression="Client Name">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" Width="150" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" Width="150" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Curr Creditor" SortExpression="Creditor Name">
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# string.format("{0} #{1}", eval("[Creditor Name]"),eval("CreditorAccountNumber")) %>'></asp:Label></ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Wrap="False" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="true" Width="200px" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="OriginalCreditorName" HeaderText="Orig Creditor" SortExpression="OriginalCreditorName"
                                                    Visible="False">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="creditorid" HeaderText="creditorid" SortExpression="creditorid"
                                                    Visible="false" />
                                                <asp:BoundField DataField="CreditorAccountBalance" HeaderText="Acct Bal" SortExpression="CreditorAccountBalance"
                                                    DataFormatString="{0:c2}" Visible="False">
                                                    <HeaderStyle HorizontalAlign="right" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="right" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="CreditorAccountNumber" HeaderText="CreditorAccountNumber"
                                                    SortExpression="CreditorAccountNumber" Visible="false">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="CreditorAccountNumberFull" HeaderText="Acct #" SortExpression="CreditorAccountNumberFull"
                                                    Visible="false">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="CreditorReferenceNumber" HeaderText="Ref #" SortExpression="CreditorReferenceNumber"
                                                    Visible="False">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="SettlementAmount" HeaderText="Sett Amt" SortExpression="SettlementAmount"
                                                    DataFormatString="{0:c2}" Visible="False">
                                                    <HeaderStyle HorizontalAlign="right" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="right" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="SettlementSavings" HeaderText="Sett Savings" SortExpression="SettlementSavings"
                                                    DataFormatString="{0:c2}" Visible="False">
                                                    <HeaderStyle HorizontalAlign="right" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="right" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="SettlementDueDate" HeaderText="Sett Due Date" SortExpression="SettlementDueDate"
                                                    DataFormatString="{0:d}" Visible="false">
                                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="false" />
                                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                                </asp:BoundField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="text-align: center; color: #A1A1A1; width: 100%">
                                                    You have no settlements waiting on SIFs!
                                                </div>
                                            </EmptyDataTemplate>
                                            <PagerTemplate>
                                                <table width="100%" style="background-color: #DCDCDC; height: 25px;">
                                                    <tr>
                                                        <td valign="middle" style="height: 20px; text-align: center;">
                                                            <asp:ImageButton ID="imbFirst" runat="server" ImageUrl="~/images/16x16_results_first2.png"
                                                                CommandName="Page" CommandArgument="First" />
                                                            <asp:ImageButton ID="imgPrev" runat="server" ImageUrl="~/images/16x16_results_previous2.png"
                                                                CommandName="Page" CommandArgument="Prev" />
                                                            <asp:Label ID="lblPage" runat="server" Text="Page " CssClass="entry2" />
                                                            <asp:DropDownList ID="ddlPage" AutoPostBack="true" CssClass="entry2" runat="server"
                                                                OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged" />
                                                            <asp:Label ID="CurrentPageLabel" runat="server" Text=" of " CssClass="entry2" />
                                                            <asp:ImageButton ID="imbNext" runat="server" ImageUrl="~/images/16x16_results_next2.png"
                                                                CommandName="Page" CommandArgument="Next" />
                                                            <asp:ImageButton ID="imbLast" runat="server" ImageUrl="~/images/16x16_results_last2.png"
                                                                CommandName="Page" CommandArgument="Last" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </PagerTemplate>
                                            <HeaderStyle BackColor="#3D3D3D" CssClass="fixedHeader" />
                                            <SelectedRowStyle BackColor="#ffffda" />
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="dsSearch" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            SelectCommand="stp_NegotiationsSearchGetSettlementsWaitingOnSIF" SelectCommandType="StoredProcedure"
                                            EnableCaching="false">
                                            <SelectParameters>
                                                <asp:Parameter Name="UserID" Type="Int32" />
                                                <asp:Parameter Name="SearchTerm" Type="String" DefaultValue="NULL" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                        <td >
                            <asp:Panel ID="pnlSIFDocs" runat="server" GroupingText="SIF Documents" CssClass="entry">
                                <fieldset id="fldSIFS" runat="server" visible="false">
                                    <legend>Drag document to client row - (<asp:LinkButton ID="btnResetUpload" runat="server"
                                        Text="Upload New Document" />)</legend>
                                    <asp:PlaceHolder ID="phSIFs" runat="server" />
                                </fieldset>
                                <fieldset id="fldUpload" runat="server" class="entry2">
                                    <legend>Upload TIF for Processing</legend>
                                    <table class="entry" border="0">
                                        <tr valign="top">
                                            <td style="white-space: nowrap; padding: 2px; vertical-align: middle;">
                                                <asp:FileUpload ID="filSif" runat="server" Height="25px" Width="100%" />
                                            </td>
                                            <td style="text-align: right; padding: 2px; vertical-align: middle; width: 50px;">
                                                <asp:Button ID="btnUpload" runat="server" Text="Upload" Height="25px" CssClass="entry" />
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="divUploadError" runat="server" style="display: none; font-size: 11pt;" class="warning">
                                    </div>
                                </fieldset></asp:Panel>
                        </td>
                    </tr>
                </table>
                <div id="updateSifDIV" style="display: none; height: 40px; width: 40px; text-align: center; ">
                    Processing...<br />
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnFile" runat="server" />
    <asp:HiddenField ID="hdnZoom" runat="server" />
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

    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateSifDIV');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('<%=gvClients.ClientID %>');

            // get the bounds of both the gridview and the progress div
            var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
            var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

            //    do the math to figure out where to position the element (the center of the gridview)
            var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
            var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

            //    set the progress element to this position
            Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
        }

        function onUpdated() {
            // get the update progress div
            var updateProgressDiv = $get('updateSifDIV');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeSif" BehaviorID="sifanimation"
        runat="server" TargetControlID="upSifs">
        <Animations>
            <OnUpdating>
                <Parallel duration="0">
                            <ScriptAction Script="onUpdating();" />
                            <EnableAction AnimationTarget="holder" Enabled="false" />
                            <FadeOut minimumOpacity=".5" />
                </Parallel>
             </OnUpdating>
            <OnUpdated>
                <Parallel duration="0">
                    <FadeIn minimumOpacity=".5" />
                    <ScriptAction Script="onUpdated();" />
                    <EnableAction AnimationTarget="holder" Enabled="true" />
                 </Parallel>
            </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
