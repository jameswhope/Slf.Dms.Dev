<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="true"
    CodeFile="default_old.aspx.vb" Inherits="clients_client_reports_Default" Title="DMP - Client - Reports" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:ScriptManager ID="smReports" runat="server" />

    <script type="text/javascript">
    //report javascript 
    //report template parameter stuff
    function GetParameters(ReportChk) {
        var chkName = ReportChk.id;
        var intPlace = chkName.lastIndexOf("_");
        var RptName = chkName.substring(intPlace + 1);

        if (ReportChk.checked == true) {
            //loop thru array of available reports and args
            ShowParameter(RptName, true);
        } else {
            ShowParameter(RptName, false);
        }
        ClearMsg();

    }
    function ShowParameter(ReportName, bShow) {
        for (x in ReportArgsArray) {
            intSplit = ReportArgsArray[x].indexOf("|");
            var argVars = ReportArgsArray[x];
            var cName = argVars.substring(0, intSplit);
            if (cName == ReportName) {
                var ReportInfoArray = argVars.split('|');
                var strArgs = ReportInfoArray[1];
                if (strArgs.indexOf(",") > -1) {
                    var aArgs = new Array();
                    aArgs = strArgs.split(",");
                    for (cntl in aArgs) {
                        var strArg = aArgs[cntl];
                        var cellArgs = document.getElementById("ctl00_ctl00_cphBody_cphBody_tbl_arg_" + strArg);
                        if (cellArgs != null) {
                            switch (bShow) {
                                case true:
                                    //shows the argument table
                                    cellArgs.style.display = '';
                                    break;
                                case false:
                                    cellArgs.style.display = 'none';
                                    RemoveField(strArg);
                                    break;
                                default:
                            }
                        }
                    }
                }
            }
        }
    }
    //onblur function to check requried fields
    function onBlurCheck() {
        try {
            //get the parameters table
            var paramCollection = GetDirtyParameters();
            var oldControl = window.event.srcElement;
            if (oldControl.value != "") {
                var oldControlID = oldControl.id
                var intPlace = oldControlID.lastIndexOf("_");
                var oldControlName = oldControlID.substring(intPlace + 1);

                RemoveField(oldControlName);
            }
        } catch (e) { }
    }

    function RemoveField(fldName) {
        try {

            var NoteDiv = document.getElementById("divMsg");
            if (NoteDiv != undefined) {
                var noteHTML = NoteDiv.innerHTML;
                var removeText = "";
                if (fldName.indexOf("CreditorInstanceIDsCommaSeparated") != -1) {
                    removeText += "<LI>" + "Select a Creditor" + "</LI>";
                } else {
                    removeText += "<LI>" + trim(InsertSpaceAfterCap(fldName)) + "</LI>";
                }

                noteHTML = noteHTML.replace(removeText, "");
                NoteDiv.innerHTML = noteHTML

                var cntName = 'ctl00_ctl00_cphBody_cphBody_tbl_arg_' + fldName;
                var aCntl = document.getElementById(cntName);
                aCntl.className = '';
            }
            ClearMsg();
        } catch (e) { }
    }
    function AddField(fldName) {
        try {
            var NoteDiv = document.getElementById("divMsg");
            var noteText = NoteDiv.innerHTML;

            var cntName = 'ctl00_ctl00_cphBody_cphBody_tbl_arg_' + fldName;
            var aCntl = document.getElementById(cntName);
            aCntl.className = 'RequiredFieldTable';

            var newFld = fldName;
            if (newFld == "CreditorInstanceIDsCommaSeparated") {
                newFld = "Select a Creditor"
            }

            if (noteText.indexOf(newFld) != -1) {
                return
            } else {
                noteText += "<LI>" + InsertSpaceAfterCap(newFld) + "</LI>";
                noteText = noteText.replace("The following fields are required:", "");
                noteText = noteText.replace("<UL>", "");
                noteText = noteText.replace("</UL>", "");
                NoteDiv.innerHTML = "The following fields are required:<UL>" + noteText + "</UL>";
            }

        } catch (e) { }
    }
    function GetDirtyParameters() {
        //get the parameters table
        var paramCell = document.getElementById("<%=cellArguments.ClientID %>").getElementsByTagName('TABLE');
        var pTbls;

        //create dictionary object
        var pCollection = new ActiveXObject("Scripting.Dictionary");

        //loop thru all checkboxes
        for (pTbls in paramCell) {
            if (paramCell[pTbls].id != undefined) {
                //get argument tables
                var aName = paramCell[pTbls].id;
                if (aName.indexOf('tbl_arg') > -1) {
                    //get argument values
                    var aRows = document.getElementById(aName).rows;
                    var row;
                    for (row in aRows) {
                        var rCells = aRows[row].cells;
                        var cell;
                        for (cell in rCells) {
                            if (rCells[cell].id != undefined) {
                                var RptName = rCells[cell].id;
                                var last = RptName.lastIndexOf("cphBody");
                                RptName = RptName.substring(last + 8);
                                last = RptName.indexOf("_");
                                RptName = RptName.substring(0, last);
                                //get dom element children
                                var m = rCells[cell].children;
                                if (m.length > 0) {
                                    for (i = 0; i < m.length; i++) {
                                        //extract argument name from control id
                                        var ArgName = m.item(i).id;
                                        last = ArgName.lastIndexOf("_")
                                        ArgName = ArgName.substring(last + 1)
                                        //get argument value based on type of control
                                        switch (m.item(i).tagName) {
                                            case "INPUT":
                                                if (pCollection.Exists(ArgName) != true) {
                                                    if (m.item(i).value != '') {
                                                        pCollection.add(ArgName, m.item(i).value);
                                                    } else {
                                                        pCollection.add(ArgName, '');
                                                    }
                                                } else {
                                                    pCollection.Item(ArgName) = m.item(i).value;
                                                }
                                                break;
                                            case "SELECT":

                                                var x = m.item(i);
                                                var CredIDs = '';
                                                //get all options for select box
                                                for (i = 0; i < x.length; i++) {
                                                    if (x.options[i].selected == true) {
                                                        //add to param list if selected
                                                        CredIDs += x.options[i].value + ',';
                                                    }
                                                }
                                                if (pCollection.Exists(ArgName) != true) {
                                                    CredIDs = CredIDs.substring(0, CredIDs.length - 1);
                                                    pCollection.add(ArgName, CredIDs);
                                                }
                                                break;
                                            case "TABLE":
                                                var intCodeSelected = GetTableSelected(m.item(i));
                                                if (intCodeSelected != undefined) {
                                                    if (pCollection.Exists(ArgName) != true) {
                                                        pCollection.add(ArgName, intCodeSelected);
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return pCollection

    }
    function GetTableSelected(tblToCheck) {

        //returns the selected value from a table of radio buttions (radionbuttonlist)
        var theTable = tblToCheck;
        var SelectedIDs = '';
        for (var z = 0; z < theTable.tBodies.length; z++) {
            for (var x = 0; x < theTable.tBodies[z].rows.length; x++) {
                var tRow = theTable.tBodies[z].rows[x].cells[0];
                var rChild = tRow.children
                if (rChild.length > 0) {
                    for (iChild = 0; iChild < rChild.length; iChild++) {
                        var cInput = rChild[iChild];
                        if (cInput.checked == true) {
                            var tblID = theTable.id;
                            
                            if (tblID.indexOf('MissingInfoReasonCode') > -1){
                                SelectedIDs += StripCodeFromName(cInput.id) + ',';
                            } else if (tblID.indexOf('ReturnedReason') > -1){
                                SelectedIDs += cInput.nextSibling.firstChild.nodeValue + ',';
                            } else {
                                SelectedIDs += cInput.value + ',';
                            }
                        }
                    }
                }
            }
        }
        SelectedIDs = SelectedIDs.substring(0, SelectedIDs.length - 1)
        return SelectedIDs
    }
    function CheckForRequiredFields(sReportName, DirtyParameterCollection) {
        var sMissing = false
        try {
            for (x in ReportArgsArray) {
                //get report arguments
                var ReportInfo = ReportArgsArray[x].split('|')
                var RequiredFields = ReportInfo[2]
                var cName = ReportInfo[0]
                if (cName == sReportName) {
                    if (RequiredFields != undefined) {
                        var rFlds = RequiredFields.split(',');
                        for (var f in rFlds) {
                            if (DirtyParameterCollection.Exists(rFlds[f]) == true) {
                                if (DirtyParameterCollection(rFlds[f]) == "") {
                                    AddField(rFlds[f]);
                                    sMissing = true
                                } else {
                                    RemoveField(rFlds[f]);
                                }
                            }
                        }
                    }
                }
            }
            return sMissing
        } catch (e) {
            return false
        }

    }
    function BuildReportArguments(sReportName, DirtyParameterCollection) {
        var strReports = ""
        for (x in ReportArgsArray) {
            //get report arguments
            var ReportInfo = ReportArgsArray[x].split('|')
            var cName = ReportInfo[0];

            if (cName == sReportName) {
                var strArgs = ReportInfo[1];
                if (strArgs.indexOf(",") > -1) {
                    var aArgs = new Array();
                    aArgs = strArgs.split(",");
                    for (cntl in aArgs) {
                        var strArg = aArgs[cntl];
                        //check arguments collection for argument
                        if (DirtyParameterCollection.Exists(strArg) == true) {
                            //if creditor argument split if more than one
                            if (strArg.indexOf("CreditorInst") > -1) {
                                if (DirtyParameterCollection(strArg).indexOf(",") > -1) {
                                    var creds = DirtyParameterCollection(strArg).split(",");
                                    var c;
                                    var strCredRpt = '';
                                    strReports = strReports.substring(0, strReports.length - sReportName.length);
                                    for (c in creds) {
                                        strCredRpt += sReportName + '_' + creds[c] + '|';
                                    }
                                    strCredRpt = strCredRpt.substring(0, strCredRpt.length - 1);

                                    //remove 1st report name
                                    var firstCred = strCredRpt.indexOf("_");
                                    strReports += strCredRpt.substr(firstCred, strCredRpt.length - firstCred);
                                } else {
                                    strReports += '_' + DirtyParameterCollection(strArg);
                                }

                            } else {
                                //add argument to report string
                                strReports += '_' + DirtyParameterCollection(strArg);
                            }
                        }
                    }
                }
            }
        }

        return strReports
    }

    // javascript for report template interface
    //10.16.07.UG
    function PrintSelected() {
        //get the parameters table
        
        var paramCollection = GetDirtyParameters();

        var bMissigRequiredFields = false;

        //get the checked reports
        var chkObjs = document.getElementsByTagName("INPUT");
        var strReports = '';
        var chk;
        for (chk in chkObjs) {
            if (chkObjs[chk].type == 'checkbox') {

                if (chkObjs[chk].id != undefined) {
                    if (chkObjs[chk].checked == true) {
                        //extract the report name from checkbox id
                        var controlName = chkObjs[chk].id;
                        if (controlName.indexOf("lst") == -1) {
                            var intLast = controlName.lastIndexOf('_');
                            var rName = controlName.substring(intLast + 1);
                            if (rName.length > 1) {
                                strReports += rName
                            }

                            //check for required fields
                            bMissigRequiredFields += CheckForRequiredFields(rName, paramCollection);

                            //get report arguments

                            strReports += BuildReportArguments(rName, paramCollection) + '|';
                        }
                    }
                }
            }
        }

        strReports = strReports.substring(0, strReports.length - 1)
        if (strReports == "") {
            alert("Please choose a report.");
            return;
        }
        if (bMissigRequiredFields == false) {
            var NoteDiv = document.getElementById("divMsg");
            NoteDiv.style.display = 'none';
            ViewReport(escape(strReports));
        } else {
            var NoteDiv = document.getElementById("divMsg");
            NoteDiv.style.display = '';
            NoteDiv.className = 'warning';
        }
    }
    
     function ViewReport(reports)
        {
            var strQuery = "";
            strQuery = '?id=' + <%=DataClientID.ToString() %> + '&reports=' + reports;

            var reportQuery = '?clientid=' + <%=DataClientID.ToString() %> + '&reports=' + reports + '&user=' + <%=UserID.ToString() %>;
            
            var rptFrame = document.getElementById("<%=frmReport.ClientID %>");
            rptFrame.src = 'report.aspx' + reportQuery;
            
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.show();
        }
       function CloseReport(){
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
       }
     function ShowTable(tblName, imgPicture){
        //function for collapsing tables
        try{
        // filter:progid:DXImageTransform.Microsoft.Slide(slideStyle='PUSH', bands=3)
        
            var tblRow = document.getElementById('ctl00_ctl00_cphBody_cphBody_' + tblName);
                
            if (tblRow.style.display == 'none'){
                tblRow.style.display = '';
                imgPicture.src =  "../../../images/collapse.png"; 
            }else{
                tblRow.style.display = 'none';
                imgPicture.src =  "../../../images/expand.png";
            }
        }catch(e){}
    }
    function SetSentDate(chk){
        //get the next cell child which is a textbox
        try{
            var txt = chk.parentElement.parentElement.parentElement.children[1].children[0];
            if(chk.checked){
                txt.value = GetCurrentDate();
            }else{
                txt.value = "";
            }        
        }catch(e){}
     }
    function CheckAll(GroupCheckBox){
        var theTable = GroupCheckBox.parentElement.parentElement.parentElement.nextSibling.firstChild.children[0].children[0];
        var chks = theTable.getElementsByTagName('input');
        
        for (var i in chks){
            var chk = chks[i];
            if (chk.id != undefined){
                if (chk.checked == true){
                    chk.checked = false;
                    SetSentDate(chk);
                    GetParameters(chk);
                }else{
                    chk.checked = true;
                    SetSentDate(chk);
                    GetParameters(chk);
                    bSomeThingChecked = true;
                }
            }
        }
    }  
    </script>

    <script type="text/javascript">
        function trim(stringToTrim) {
            return stringToTrim.replace(/^\s+|\s+$/g, "");
        }
        function ltrim(stringToTrim) {
            return stringToTrim.replace(/^\s+/, "");
        }
        function rtrim(stringToTrim) {
            return stringToTrim.replace(/\s+$/, "");
        }

        function ClearMsg() {
            try {

                var NoteDiv = document.getElementById("divMsg");
                if (NoteDiv != undefined) {
                    var noteHTML = NoteDiv.innerHTML;

                    if (noteHTML.indexOf("<UL></UL>") != -1) {
                        NoteDiv.innerHTML = "";
                        NoteDiv.style.display = 'none';
                    }
                }
            } catch (e) { }
        }

        function StripCodeFromName(TextToStrip) {
            var intLast = TextToStrip.lastIndexOf('_');
            var strCode = TextToStrip.substring(intLast + 1);
            return strCode;
        }

        function InsertSpaceAfterCap(strToChange) {

            var sChars = strToChange.split("");
            var strNew = "";
            for (var c in sChars) {
                if (Asc(sChars[c]) >= 65 && Asc(sChars[c]) <= 95) {
                    strNew += ' ' + sChars[c];
                } else {
                    strNew += sChars[c];
                }
            }
            return strNew;
        }
        function Asc(String) {
            return String.charCodeAt(0);
        }


        function GetCurrentDate() {
            var date = new Date();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            var hour = date.getHours();
            var min = date.getMinutes();
            var ext = 'AM';

            if (month < 10) {
                month = '0' + month;
            }

            if (day < 10) {
                day = '0' + day;
            }

            if (hour > 12) {
                hour = date.getHours() - 12;
                ext = 'PM';
            }

            if (hour < 10) {
                hour = '0' + hour;
            }

            if (min < 10) {
                min = '0' + min;
            }

            return month + '/' + day + '/' + date.getFullYear() + ' ' + hour + ':' + min + ' ' + ext;
        }
       
    </script>

    <div id="dvNote">
    </div>
    <div id="dvDuplicate" style="position: absolute; width: 200px; height: 100px; background-color: white;
        text-align: center; z-index: 99; visibility: hidden;">
        <table style="width: 400px; height: auto; background-color: white; text-align: center;
            opacity: 1; mozopacity: 1; filter: alpha(opacity=100);">
            <tr>
                <td>
                    This report already exists for the specified user. Would
                    <br />
                    you like to see the original?
                </td>
            </tr>
            <tr>
                <td align="left">
                    <a id="hypDupYes">Yes</a>
                </td>
                <td align="right">
                    <a id="hypDupNo">No</a>
                </td>
            </tr>
        </table>
    </div>
    <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr style="height: auto;">
            <td valign="top">
                <asp:Table ID="tblMain" runat="server" Height="200px" Width="100%">
                    <asp:TableRow ID="rowObjects" runat="server">
                        <asp:TableCell Width="50%" ID="cellReports" runat="server" VerticalAlign="Top">
                    
                        </asp:TableCell>
                        <asp:TableCell ID="cellArguments" runat="server" VerticalAlign="Top">
                        
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell ColumnSpan="2">
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </td>
        </tr>
    </table>
    <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
        TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
        BackgroundCssClass="modalBackgroundNeg" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel runat="server" CssClass="modalPopupNeg" ID="programmaticPopup" Style="display: none;
        width: 725px; padding: 10px">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #DDDDDD;
            border: solid 1px Gray; color: Black; text-align: center; width: 725px">
            <div id="dvCloseMenu" runat="server" style="width: 100%; height: 25px; background-color: white;
                z-index: 51;width: 725px">
                <a id="hideModalPopupViaClientButton" onclick="CloseReport()" href="#">Close</a>
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlRpt">
            <div id="dvReport" runat="server" style="width: 725px; height: 550px; z-index: 51;
                visibility: visible; background-color: Transparent;">
                <iframe id="frmReport" runat="server" src="report.aspx" style="width: 100%; height: 95%;"
                    frameborder="0" />
            </div>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
