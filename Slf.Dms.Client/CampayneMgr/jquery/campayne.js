var loadingImg = '<div id="loadingDiv" style="width:100%; text-align:center;display:block;"><div style="width:40%;padding:10px; margin-top: 20px; text-align:center;" class="ui-state-highlight ui-corner-all"><strong>Loading...</strong><br/><img src="../images/ajax-loader2.gif" alt="loading..." /></div></div>';
var loadingSpinnerImg = '<img src="../images/loader2.gif" alt="loading..." />';
function loadJQGridviewButtons() {
    $(".jqRefreshButton").button({
        icons: {
            primary: "ui-icon-refresh"
        },
        text: false
    });
    $(".jqExportButton").button({
        icons: {
            primary: "ui-icon-extlink"
        },
        text: true
    });
    $(".jqFirstButton").button({
        icons: {
            primary: "ui-icon-seek-first"
        },
        text: false
    });
    $(".jqPrevButton").button({
        icons: {
            primary: "ui-icon-seek-prev"
        },
        text: false
    });
    $(".jqNextButton").button({
        icons: {
            primary: "ui-icon-seek-next"
        },
        text: false
    });
    $(".jqLastButton").button({
        icons: {
            primary: "ui-icon-seek-end"
        },
        text: false
    });
}
function getMain(dObj) {
    if (dObj.hasOwnProperty('d')) {
        return dObj.d;
    } else {
        return dObj;
    }
}
function getGridTableData(pData, tablename, arrayArgs, serviceMethodFullPath, sortfieldname) {

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: serviceMethodFullPath,
        data: arrayArgs,
        dataType: "json",
        async: true,
        success: function (response) {
            var data = JSON.parse(getMain(response.d)).rows;
            var thegrid = $("#" + tablename);
            thegrid.clearGridData();
            for (var i = 0; i < data.length; i++) {
                thegrid.addRowData(i + 1, data[i]);
            }

            thegrid.setGridParam({ sortname: sortfieldname, sortorder: 'asc' }).trigger('reloadGrid'); 

        },
        error: function (response) {
            $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + response.responseText);
        }
    });
}
// Replaces all instances of the given substring.
String.prototype.replaceAll = function(
                                        strTarget, // The substring you want to replace
                                        strSubString // The string you want to replace in.
                                        ) {
    var strText = this;
    var intIndexOfMatch = strText.indexOf(strTarget);


    // Keep looping while an instance of the target string
    // still exists in the string.
    while (intIndexOfMatch != -1) {
        // Relace out the current instance.
        strText = strText.replace(strTarget, strSubString)


        // Get the index of any next matching substring.
        intIndexOfMatch = strText.indexOf(strTarget);
    }


    // Return the updated string with ALL the target strings
    // replaced out with the new substring.
    return (strText);
}

function showStickyToast(msgText, msgType) {
    $().toastmessage('showToast', {
        text: msgText,
        sticky: true,
        position: 'top-right',
        type: msgType,
        closeText: ''
    });

}
function showToast(msgText, msgType, bSticky) {
    $().toastmessage('showToast', {
        text: msgText,
        sticky: bSticky,
        position: 'top-right',
        type: msgType,
        closeText: ''
    });

}
function toggleChildren(elem) {
    var p = elem.parentNode.nextSibling;
    elem.innerHTML = (elem.innerHTML != '&nbsp;+&nbsp;' ? '&nbsp;+&nbsp;' : '&nbsp;-&nbsp;');
    p.style.display = (p.style.display != 'none' ? 'none' : '');
    return false;
}
       
function DisableControl(elem) {
    elem.style.borderStyle = "none";
    elem.style.backgroundColor = "Transparent";
    elem.style.fontStyle.fontColor = "Black";
    elem.readOnly = false;
}
function EnableControl(elem) {
    
    elem.style.border = "solid 1px black";
    elem.style.backgroundColor = "yellow";
    elem.style.fontStyle.fontColor = "Black";
    elem.readOnly = false;
    try {
        var prevRow = elem.parentNode.parentNode.previousSibling
        disableRowControls(prevRow);
        
        var nextRow = elem.parentNode.parentNode.nextSibling
        disableRowControls(nextRow);

        var nextCell = elem.parentNode.nextSibling;
        disableChildControls(nextCell, false);

        var prevCell = elem.parentNode.previousSibling;
        disableChildControls(prevCell, false);
    }
    catch (e) {
        $().toastmessage('showErrorToast', e.message);
    }
}

function disableRowControls(elem) {
    if (elem != null) {
        var inputs = elem.getElementsByTagName('input');
        if (inputs != null) {
            if (inputs.length > 1) {
                for (i in inputs) {
                    inputs[i].readOnly = false;
                    if (inputs[i].type == 'checkbox') {
                        inputs[i].disabled = true;
                    }
                }
            }
        }
        var sel = elem.getElementsByTagName('select');
        if (sel != null) {
            if (sel.length > 0) {
                for (i in sel) {
                    var selID = sel[i].id;
                    if (selID != undefined) {
                        if (selID.indexOf('ddlOffers') == -1) {
                            sel[i].disabled = true;
                        }
                    }
                }
            }
        }

    }
}
function disableChildControls(elem, bDisable) {
    if (elem != null) {
        if (elem.children.length > 0) {
            elem.children[0].disabled = bDisable;
        }
    }
}
function getCheckboxValue(checkvalue) {
    if (checkvalue == undefined) {
        return 'false';
    } else {
        return 'true';
    }
}
function stripHTML(htmlText) {
    var t = new Array;
    var div = document.createElement('div');
    div.innerHTML = htmlText;
    for (ctl in div.childNodes) {
        if (div.childNodes[ctl].nodeName == 'DIV') {
            var divText = '';
            if (document.all) {
                divText = div.childNodes[ctl].innerText;
            } else {
                divText = div.childNodes[ctl].textContent;
            }
            divText = divText.replaceAll('\\', '|');
            t.push(divText);
        }
    }
    var newArr = new Array(); for (k in t) if (t[k]) newArr.push(t[k])
    return newArr.join(',')
}