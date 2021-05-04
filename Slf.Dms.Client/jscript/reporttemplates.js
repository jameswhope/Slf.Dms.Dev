
//fire control validators to valide report argument required field validators
//do not show popup if all are not valid
function ValidateReportArguments(ReportArguments) {
    var bValid = new Boolean();
    bValid = true;

    var rptArray = new Array();
    rptArray = ReportArguments.split(",");

    for (v in Page_Validators) {
        var targetCtl = new String();
        targetCtl = Page_Validators[v].outerHTML;
        var intStart = targetCtl.indexOf('controltovalidate="') + 19;
        var intLen = targetCtl.indexOf('"', intStart + 1) - intStart;
        targetCtl = targetCtl.substr(intStart, intLen);

        intStart = targetCtl.lastIndexOf("_");
        targetCtl = targetCtl.substr(intStart + 1);

        if (ArrayContains(rptArray,targetCtl) == true) {
            ValidatorValidate(Page_Validators[v])
            if (!Page_Validators[v].isvalid) {
                bValid = false
                break;
            } else {
                bValid = true
                ReportArguments = ReportArguments.replace(targetCtl, "");
                ArrayRemove(rptArray, targetCtl);
            }
        }
    }

    //bValid = true;

    if (bValid == true) {
        Page_IsValid = true;
    } else {
        Page_IsValid = false;
    }

    return bValid
}

//get the selected creditor instance ids
//from listbox
function getSelectedCreditors(listOfCreditors) {
    var credids = new String();
    var CredIDs = '';
    //get all options for select box
    for (i = 0; i < listOfCreditors.length; i++) {
        if (listOfCreditors.options[i].selected == true) {
            //add to param list if selected
            CredIDs += listOfCreditors.options[i].value + ',';
        }
    }
    CredIDs = CredIDs.substring(0, CredIDs.length - 1);

    return CredIDs
}
//format argument string
//remove clientid 
//replace comma with underscore
function formatArguments(argText) {
    var argNew = new String();
    if (argText.indexOf(',') != -1) {
        argNew = argText.replace("ClientID,", "");
    } else {
        argNew = argText.replace("ClientID", "");
    }
    //some argument values have commas in them
    //leave those commas
    var args = argNew.split(",");
    argNew = ""
    for (a in args) {
        argNew += args[a] + '_';
    }
    argNew = argNew.substring(0, argNew.length - 1);
    return argNew;
}
//extract the value from the control
//used on the row iteration to get value fo argument
function getParamValue(paramControl) {
    var ctlValue = new String();

    switch (paramControl.tagName) {
        case "INPUT":
            ctlValue = paramControl.value;
            break;
        case "TEXTAREA":
            ctlValue = paramControl.value;
            break;
        case "SELECT":
            ctlValue = extractSelectedFromLST(paramControl);
            break;
        case "TABLE":
            ctlValue = extractSelectedFromRBLTable(paramControl);
            break;
    }

    return ctlValue
}

//loop thru report argument table
//replacing argument text with argument value
function extractArguments(argumentRows, argumentText) {
    //store argument string
    var argText = new String();
    argText = argumentText;

    //loop thru argument table extracting values
    for (row in argumentRows) {
        var rowCells = argumentRows[row].cells;
        for (cell in rowCells) {
            if (rowCells[cell].id != undefined) {
                //do we have controls?
                var m = rowCells[cell].children;
                if (m.length > 0) { 
                    //yes, we have argument values
                    for (i = 0; i < m.length; i++) {
                        //extract argument name from control id
                        var ArgName = extractArgumentName(m.item(i).id);
                        if (ArgName != '' && ArgName.indexOf('ctl') == -1) {
                            argText = argText.replace(ArgName, getParamValue(m.item(i)));
                            break;
                        }
                    }
                }
            }
        }
    }
    return argText;
}
//get argument name from control id
function extractArgumentName(argumentControlID) {
    var ArgumentName = argumentControlID;
    last = ArgumentName.lastIndexOf("_")
    ArgumentName = ArgumentName.substring(last + 1)
    return ArgumentName

}
//get selected value from listbox
function extractSelectedFromLST(listControlObject) {
    var CredIDs = '';
    //get all options for select box
    for (i = 0; i < listControlObject.length; i++) {
        if (listControlObject.options[i].selected == true) {
            //add to param list if selected
            CredIDs += listControlObject.options[i].value + ',';
        }
    }
    CredIDs = CredIDs.substring(0, CredIDs.length - 1);
    if (CredIDs.replace(/^\s+|\s+$/g, '').length < 1 ) {
        CredIDs = 0;
    }
    return CredIDs
}
//get selected value from radiobuttonlist
function extractSelectedFromRBLTable(tblToCheck) {
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
                        //custom formatting specific to field
                        if (tblID.indexOf('MissingInfoReasonCode') > -1) {
                            SelectedIDs += StripCodeFromName(cInput.id) + ',';
                        } else if (tblID.indexOf('ReturnedReason') > -1){
                        SelectedIDs += cInput.nextSibling.firstChild.nodeValue + ',';
                    } else if (tblID.indexOf('ReasonID') > -1) {
                        SelectedIDs += cInput.nextSibling.firstChild.nodeValue + ',';
                        } else if (tblID.indexOf('ClientAcctList') > -1) {
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
//expand accordion pane onmouseover
function AddMouseOverToAccordion(accControl) {
    for (paneIdx = 0; paneIdx < accControl.AccordionBehavior.get_Count(); paneIdx++) {
        $addHandler(accControl.AccordionBehavior.get_Pane(paneIdx).header, "mouseover", accControl.AccordionBehavior._headerClickHandler);
    }
}
//check all checkboxes in gridview
function GridCheckAll(chk_SelectAll, gridviewName) {
    //check all gridview checkboxes
    var chkState = chk_SelectAll.checked;
    var TargetBaseControl = document.getElementById(gridviewName);
    var TargetChildControl = "chk_select";
    var Inputs = TargetBaseControl.getElementsByTagName("input");
    for (var iCount = 0; iCount < Inputs.length; ++iCount) {
        if (Inputs[iCount].type == 'checkbox' && Inputs[iCount].id.indexOf(TargetChildControl, 0) >= 0 && Inputs[iCount].parentElement.disabled != true) {
            Inputs[iCount].click();
            Inputs[iCount].checked = chkState;
        } else {
            Inputs[iCount].checked = false;
        }
    }
}
//only allow numbers in textbox
function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        alert('Please enter only numeric text (ie. 0123456789)!');
        return false;
    } else {
        return true;
    }
}
function isAlphaNumeric(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 65 || charCode > 90) && (charCode < 97 || charCode > 122)) {
        alert('Please enter only alphanumeric text (ie. A-Z, a-z, 0123456789)!');
        return false;
    } else {
        return true;
    }
}

function StripCodeFromName(TextToStrip) {
    var intLast = TextToStrip.lastIndexOf('_');
    var strCode = TextToStrip.substring(intLast + 1);
    return strCode;
}
//prototypes
function ArrayContains(arrayToCheck, objText) {
    var i = arrayToCheck.length;
    while (i--) {
        if (arrayToCheck[i] === objText) {
            return true;
        }
    }
    return false;
}
function ArrayRemove(arrayName, arrayElement) {
    for (var i = 0; i < arrayName.length; i++) {
        if (arrayName[i] == arrayElement)
            arrayName.splice(i, 1);
    }
}
