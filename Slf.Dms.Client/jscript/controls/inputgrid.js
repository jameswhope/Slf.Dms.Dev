
window.document.onkeydown = Grid_WinKeyDown;

var Grid_LastSelected = null;

function Grid_WinKeyDown()
{
    if (window.event.keyCode == 46)
    {
        if (Grid_LastSelected != null)
        {
            Grid_DeleteSelected(Grid_LastSelected);
        }
    }
}
function Grid_AddBorder(obj)
{
    obj.style.border = "solid 2px red";
    obj.focus();
}
function Grid_RemoveBorder(obj)
{
    obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
}
function Grid_TrimString(value)
{
    value = value.replace( /^\s+/g, "");   // strip leading
    return value.replace( /\s+$/g, "");    // strip trailing
}
function Grid_SelectFullValue(obj)
{
    if (obj.createTextRange)
    {
	    var Range = obj.createTextRange();

	    Range.moveStart("character", 0);
	    Range.moveEnd('character', obj.value.length);
	    Range.select();
    }
    else if (obj.setSelectionRange)
    {
	    obj.focus();
	    obj.setSelectionRange(0, obj.value.length);
    }
}
function Grid_GetSelectPosStart(obj)
{
	if (obj.createTextRange)
	{
		selectedRange = document.selection.createRange().duplicate();
		selectedRange.moveEnd("character", obj.value.length);
		pos = obj.value.lastIndexOf(selectedRange.text);
		if (selectedRange.text == "")
			pos = obj.value.length;
		return pos;
	}
	else
	{
		return obj.selectionStart;
	}
}
function Grid_GetSelectPosEnd(obj)
{
	if (obj.createTextRange)
	{
		selectedRange = document.selection.createRange().duplicate();
		selectedRange.moveStart("character", -obj.value.length);
		pos = selectedRange.text.length;
		return pos;
	}
	else
	{
		return obj.selectionEnd;
	}
}
function Grid_StopEvent(event)
{
	if (document.all)				//IE
	{
		event.returnValue = false;
	}
	else if (event.preventDefault)	//DOM 2 compliant
	{
		event.preventDefault();
	}
}
function Grid_TXT_OnBlur(txt)
{
    if (txt.getAttribute("ignore") != null)
    {
        txt.removeAttribute("ignore");
    }
    else
    {
        if (Grid_TXT_Save(txt, false))
        {
            // hide txt
            txt.className = "grdTXT uns";
        }
    }
}
function Grid_DDL_OnBlur(ddl)
{
    if (ddl.getAttribute("ignore") != null)
    {
        ddl.removeAttribute("ignore");
    }
    else
    {
        if (Grid_DDL_Save(ddl, false))
        {
            // hide ddl
            ddl.className = "grdDDL uns";
        }
    }
}
function Grid_CTL_Save(obj)
{
    if (obj.tagName.toLowerCase() == "input")
    {
        return Grid_TXT_Save(obj);
    }
    else if (obj.tagName.toLowerCase() == "select")
    {
        return Grid_DDL_Save(obj);
    }
}
function Grid_TXT_Save(txt)
{
    var td = txt.getAttribute("row");
    var tr = td.parentNode;
    var key = tr.getAttribute("key");

    var tbl = tr.parentNode.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    var valBox = tbl.getAttribute("valBox");
    var valBoxId = tbl.getAttribute("valBoxId");
    var valLabId = tbl.getAttribute("valLabId");

    // ----------------------
    // the below javascript is commented out to turn off realtime validation
    // ----------------------

//    var useVal = col.getAttribute("useVal");
//    var valFun = col.getAttribute("valFun");
//    var valMsg = col.getAttribute("valMsg");

//    if (useVal != null && useVal.toLowerCase() == "true")
//    {
//        useVal = true;
//    }
//    else
//    {
//        useVal = false;
//    }

//    if (valBox != null && valBox.toLowerCase() == "true")
//    {
//        valBox = true;
//    }
//    else
//    {
//        valBox = false;
//    }

    var useVal = false;

    // if validation not needed OR is needed and does validate OR text is empty
    if (txt.value.length == 0 || !useVal || valFun.length == 0 || (useVal && eval(valFun + "(\"" + txt.value + "\")")))
    {
        txt.value = Grid_TrimString(txt.value);

        // check if on new record
        if (key == "*" && txt.value.length > 0)
        {
            // create additional new record below
            Grid_CreateNewRecord(tbl);
        }

        // write the text value to the label
        if (txt.value.length == 0)
        {
            td.childNodes[0].innerHTML = "&nbsp;";
        }
        else
        {
            td.childNodes[0].innerHTML = txt.value;
        }

        // cleanup new record
        if (key == "*" && txt.value.length > 0)
        {
            Grid_UpgradeNewRecord(td);
            Grid_SaveUpdate(td, txt.value, true);
        }
        else
        {
            Grid_SaveUpdate(td, txt.value, (tr.getAttribute("justinserted") != null));
        }

        // remove validation chrome
        Grid_RemoveBorder(txt);

        if (valBox)
        {
            document.getElementById(valBoxId).style.display = "none";
        }

        return true;
    }
    else // did not validate
    {
        //add validation chrome
        Grid_AddBorder(txt);

        if (valBox)
        {
            var div = document.getElementById(valBoxId);
            var lab = document.getElementById(valLabId);

            lab.innerHTML = valMsg;
            div.style.display = "inline";
        }

        return false;
    }
}
function Grid_DDL_Save(ddl)
{
    var td = ddl.getAttribute("row");
    var tr = td.parentNode;
    var key = tr.getAttribute("key");

    var tbl = tr.parentNode.parentNode;

    var WasChange = false;

    // check if on new record
    if (key == "*" && ddl.selectedIndex != -1) // on new record and something was entered
    {
        // create additional new record below
        Grid_CreateNewRecord(tbl);
    }

    // write the selected value to the div
    if (ddl.value != td.childNodes[1].innerHTML)
    {
        if (ddl.selectedIndex != -1)
        {
            var opt = ddl.options[ddl.selectedIndex];

            if (Grid_TrimString(opt.text).length > 0)
            {
                td.childNodes[0].innerHTML = opt.text;
            }
            else
            {
                td.childNodes[0].innerHTML = "&nbsp;";
            }

            //td.childNodes[1].innerHTML = ddl.selectedIndex;
            td.childNodes[1].innerHTML = opt.value;
        }
        else
        {
            td.childNodes[0].innerHTML = "&nbsp;";
            td.childNodes[1].innerHTML = "";
        }

        WasChange = true;
    }

    // cleanup new record
    if (key == "*")
    {
        if (ddl.selectedIndex != -1)
        {
            Grid_UpgradeNewRecord(td);

            if (ddl.selectedIndex != -1)
            {
                Grid_SaveUpdate(td, ddl.options[ddl.selectedIndex].value, true);
            }
            else
            {
                Grid_SaveUpdate(td, "", true);
            }
        }
    }
    else
    {
        if (WasChange)
        {
            var newRec = (tr.getAttribute("justinserted") != null);

            if (ddl.selectedIndex != -1)
            {
                Grid_SaveUpdate(td, ddl.options[ddl.selectedIndex].value, newRec);
            }
            else
            {
                Grid_SaveUpdate(td, "", newRec);
            }
        }
    }

    return true;
}
function Grid_UpgradeNewRecord(td)
{
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;

    // get number of rows and add one
    var hiNum = (tbl.rows.length - 4) + 1;  // three less for header, expansion, and new record rows

    // set the new record row header to that
    tr.cells[0].childNodes[0].innerHTML = hiNum;

    // add a "justinserted" attribute to the row
    tr.setAttribute("justinserted", "true");

    // get and iterate new number list
    var newIndex = tbl.getAttribute("newIndex");

    if (newIndex != null)
    {
        newIndex = (parseInt(newIndex) + 1);
    }
    else
    {
        newIndex = 0
    }

    tbl.setAttribute("newIndex", newIndex);

    // change the row key to new number
    tr.setAttribute("key", newIndex);
}
function Grid_SaveUpdate(td, value, newRec)
{
    var txt = null;
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;
    var grd = tbl.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    var fld = col.getAttribute("fieldName");
    var typ = col.getAttribute("fieldType");
    var key = tr.getAttribute("key");

    if (newRec)
    {
        txt = grd.nextSibling.nextSibling; // use insert-only textbox
    }
    else
    {
        txt = grd.nextSibling; // use updates-only textbox
    }

    if (txt.value.length > 0)
    {
        var updates = txt.value.split("<-$$->");

        var index = Grid_UpdatedExists(updates, key, fld);
 
	    if (index >= 0 && index < updates.length)
	    {
		    updates.splice(index, 1);

            if (updates.length > 0)
            {
                txt.value = updates.join("<-$$->") + "<-$$->" + key + ":" + fld + ":" + typ + ":" + value;
            }
            else
            {
                txt.value = key + ":" + fld + ":" + typ + ":" + value;
            }
	    }
	    else
	    {
            txt.value += "<-$$->" + key + ":" + fld + ":" + typ + ":" + value;
	    }
    }
    else
    {
        txt.value = key + ":" + fld + ":" + typ + ":" + value;
    }
}
function Grid_UpdatedExists(array, key, fld)
{
    if (array.length > 0)
    {
        for (u = 0; u < array.length; u++)
        {
            var parts = array[u].split(":");

            var partsKey = parts[0];
            var partsFld = parts[1];

            if (partsKey == key && partsFld == fld)
            {
                return u
            }
        }
    }

    return -1;
}
function Grid_AddDeleted(grd, value)
{
    var txt = grd.nextSibling.nextSibling.nextSibling;

    if (txt.value.length > 0)
    {
        txt.value += "," + value;
    }
    else
    {
        txt.value = value;
    }
}
function Grid_CreateNewRecord(tbl)
{
    var curTr = tbl.rows[tbl.rows.length - 2];
    var newTr = curTr.cloneNode(true);              // clone last "new" row and it's children

    // insert the new record clone
    curTr.insertAdjacentElement("AfterEnd", newTr);
}
function Grid_TXT_OnKeyDown(txt)
{
    Grid_MoveControl(window.event, txt);
}
function Grid_DDL_OnKeyDown(ddl)
{
    Grid_MoveControl(window.event, ddl);
}
function Grid_MoveControl(e, obj)
{
    var KillPropagation = false;

    if (e.keyCode == 9) // hit TAB
    {
        if (e.shiftKey) // move backwards
        {
            KillPropagation = Grid_TD_MoveLeft(obj, obj.getAttribute("row"), true);
        }
        else // move forward
        {
            KillPropagation = Grid_TD_MoveRight(obj, obj.getAttribute("row"), true);
        }
    }
    else if (e.keyCode == 37) // hit LEFT
    {
        KillPropagation = Grid_TD_MoveLeftArrow(obj, obj.getAttribute("row"), true);
    }
    else if (e.keyCode == 38) // hit UP
    {
        KillPropagation = Grid_TD_MoveUpArrow(obj, obj.getAttribute("row"), true);
    }
    else if (e.keyCode == 39) // hit RIGHT
    {
        KillPropagation = Grid_TD_MoveRightArrow(obj, obj.getAttribute("row"), true);
    }
    else if (e.keyCode == 40) // hit DOWN
    {
        KillPropagation = Grid_TD_MoveDownArrow(obj, obj.getAttribute("row"), true);
    }
    else if (e.keyCode == 13) // hit ENTER
    {
        KillPropagation = Grid_TD_MoveEnter(obj, obj.getAttribute("row"), true);
    }
    else if (e.keyCode == 27) // hit ESC
    {
        KillPropagation = Grid_TD_MoveESC(obj, obj.getAttribute("row"), false);
    }

    if (KillPropagation)
    {
        Grid_StopEvent(e);

        return false;
    }
}
function Grid_TD_MoveEnter(obj, td, SaveFirst)
{
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;

    // force the object to save and do associations
    if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj, false))) // try to save
    {
        if (tr.rowIndex < (tbl.rows.length - 2))
        {
            Grid_TD_OnFocus(tbl.rows[tr.rowIndex + 1].cells[td.cellIndex], true);
        }
    }

    return false;
}
function Grid_TD_MoveESC(obj, td, SaveFirst)
{
    var tbl = td.parentNode.parentNode.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    // drop validation if there
    var valBox = tbl.getAttribute("valBox");
    var valBoxId = tbl.getAttribute("valBoxId");

    if (valBox != null && valBox.toLowerCase() == "true")
    {
        valBox = true;
    }
    else
    {
        valBox = false;
    }

    if (valBox)
    {
        document.getElementById(valBoxId).style.display = "none";
    }

    obj.setAttribute("ignore", "true"); // restrict the onblur event from running for one time

    Grid_RemoveBorder(obj);
    obj.className = "grd" + col.getAttribute("mode").toUpperCase() + " uns";
    obj.blur();

    return Grid_TD_MoveRight(obj, obj.getAttribute("row"), SaveFirst);
}
function Grid_TD_MoveRight(obj, td, SaveFirst)
{
    var oTd = td;
    var oTr = td.parentNode;
    var tbl = oTr.parentNode.parentNode;

    var nexTd = null;
    var found = false;

    for (r = oTr.rowIndex; r < tbl.rows.length; r++) // loop through rows starting at current
    {
        var cTr = tbl.rows[r];

        var c = 1;

        if (r == oTr.rowIndex) // starting at current cell
        {
            // assign c to current cellindex + 1
            c = oTd.cellIndex + 1;
        }

        for (c; c < cTr.cells.length; c++) // loop through cells
        {
            // check row markings
            var cTd = cTr.cells[c];

            if (cTd.getAttribute("onclick") != null)
            {
                nexTd = cTd;
                found = true;
                break;
            }
        }

        if (found)
        {
            break;
        }
    }

    if (found)
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj))) // try to save
        {
            Grid_TD_OnFocus(nexTd, true);
        }

        return true;
    }
    else
    {
        return false;
    }
}
function Grid_TD_MoveRightArrow(obj, td, SaveFirst)
{
    // only move right if caret is at last position in current textbox (if obj is - in fact - a textbox)
    if (obj.tagName.toLowerCase() != "input" || (obj.tagName.toLowerCase() == "input" && Grid_GetSelectPosStart(obj) == obj.value.length))
    {
        return Grid_TD_MoveRight(obj, td, SaveFirst);
    }

    return false;
}
function Grid_TD_MoveLeft(obj, td, SaveFirst)
{
    var oTd = td;
    var oTr = td.parentNode;
    var tbl = oTr.parentNode.parentNode;

    var preTd = null;
    var found = false;

    for (r = oTr.rowIndex; r > 0; r--) // loop through rows starting at current
    {
        var cTr = tbl.rows[r];

        var c = (cTr.cells.length - 1);

        if (r == oTr.rowIndex) // starting at current cell
        {
            // assign c to current cellindex - 1
            c = oTd.cellIndex - 1;
        }

        for (c; c > 0; c--) // loop through cells
        {
            // check row markings
            var cTd = cTr.cells[c];

            if (cTd.getAttribute("onclick") != null)
            {
                preTd = cTd;
                found = true;
                break;
            }
        }

        if (found)
        {
            break;
        }
    }

    if (found)
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj))) // try to save
        {
            Grid_TD_OnFocus(preTd, true);
        }

        return true;
    }
    else
    {
        return false;
    }
}
function Grid_TD_MoveLeftArrow(obj, td, SaveFirst)
{
    // only move right if caret is at last position in current textbox (if obj is - in fact - a textbox)
    if (obj.tagName.toLowerCase() != "input" || (obj.tagName.toLowerCase() == "input" && Grid_GetSelectPosStart(obj) == 0))
    {
        return Grid_TD_MoveLeft(obj, td, SaveFirst);
    }

    return false;
}
function Grid_TD_MoveUpArrow(obj, td, SaveFirst)
{
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;

    if (obj.tagName.toLowerCase() != "select" && tr.rowIndex > 1)
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj, false))) // try to save
        {
            Grid_TD_OnFocus(tbl.rows[tr.rowIndex - 1].cells[td.cellIndex], true);
        }

        return true;
    }

    return false;
}
function Grid_TD_MoveDownArrow(obj, td, SaveFirst)
{
    var tr = td.parentNode;
    var tbl = tr.parentNode.parentNode;

    if (obj.tagName.toLowerCase() != "select" && tr.rowIndex < (tbl.rows.length - 2))
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj, false))) // try to save
        {
            Grid_TD_OnFocus(tbl.rows[tr.rowIndex + 1].cells[td.cellIndex], true);
        }

        return true;
    }

    return false;
}
function Grid_TD_OnClick(td)
{
    // check to see if a field locked for invalid entry
    var tbl = td.parentNode.parentNode.parentNode;

    var valBox = tbl.getAttribute("valBox");
    var valBoxId = tbl.getAttribute("valBoxId");

    if (valBox != null && valBox.toLowerCase() == "true")
    {
        valBox = true;
    }
    else
    {
        valBox = false;
    }

    if (!valBox || document.getElementById(valBoxId).style.display != "inline")
    {
        Grid_TD_OnFocus(td, true);
    }
}
function Grid_TD_OnFocus(td, CheckLeft, AddErrorMarkings)
{
    var tbl = td.parentNode.parentNode.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    Grid_LoadControls(tbl);
    Grid_RH_ClearSelected(tbl);

    var controls = tbl.getAttribute("controls");
    var controlIndex = parseInt(col.getAttribute("control"));

    if (col.getAttribute("mode").toLowerCase() == "im")
    {
        
    }
    else if (col.getAttribute("mode").toLowerCase() == "ddl")
    {
        Grid_PlaceDDL(controls[controlIndex], td, CheckLeft);
    }
    else // txt
    {
        Grid_PlaceTXT(controls[controlIndex], td, CheckLeft);
    }

    if (AddErrorMarkings)
    {
        Grid_AddBorder(controls[controlIndex]);
    }
}
function Grid_PlaceDDL(ddl, td, CheckLeft)
{
    // mark ddl with current td for blur reference
    ddl.setAttribute("row", td);

    Grid_DDL_Select(ddl, td.childNodes[1].innerHTML);

    ddl.style.top = td.offsetTop;
    ddl.style.left = td.offsetLeft;
    ddl.style.width = td.offsetWidth;
    ddl.style.height = td.offsetHeight;

    if (ddl.className != "grdDDL sel")
    {
        ddl.className = "grdDDL sel";
    }

    if (CheckLeft) // navigation needs to check for left scroll offset
    {
        ddl.style.left = td.offsetLeft - 30;
        ddl.focus();
        ddl.style.left = td.offsetLeft;
    }
    else
    {
        ddl.focus();
    }
}
function Grid_PlaceTXT(txt, td, CheckLeft)
{
    // get previous td (where ddl was)
    var preTd = txt.getAttribute("row");

    // mark txt with current td for blur reference
    txt.setAttribute("row", td);

    txt.value = Grid_TrimString(td.childNodes[0].innerText);

    txt.style.top = td.offsetTop;
    txt.style.left = td.offsetLeft;
    txt.style.width = td.offsetWidth;
    txt.style.height = td.offsetHeight;

    if (txt.className != "grdTXT sel")
    {
        txt.className = "grdTXT sel";
    }

    if (CheckLeft) // navigation needs to check for left scroll offset
    {
        txt.style.left = td.offsetLeft - 30;
        txt.focus();
        Grid_SelectFullValue(txt);
        txt.style.left = td.offsetLeft;
    }
    else
    {
        txt.focus();
        Grid_SelectFullValue(txt);
    }
}
function Grid_RH_OnClick(th)
{
    var tr = th.parentNode;

    if (tr.getAttribute("key") != "*") // cannot select the new record
    {
        var tbl = tr.parentNode.parentNode;
        var sel = tbl.getAttribute("selRows");

        if (sel != null)
        {
            var sels = new String(sel).split(",");

            if (window.event.ctrlKey) // WAS holding down ctrl key
            {
                if (tr.getAttribute("selected") != null) // IS selected
                {
                    Grid_RH_Unselect(tr);
                }
                else
                {
                    Grid_RH_Select(tr);
                }
            }
            else // was NOT holding ctrl key
            {
                Grid_RH_ClearSelected(tbl);

                Grid_RH_Select(tr);
            }
        }
        else
        {
            Grid_RH_Select(tr);
        }

        Grid_RH_StoreSelected(tbl);
    }
}
function Grid_DeleteSelected(grd)
{
    var tbl = grd.childNodes[0];
    var txt = grd.nextSibling.nextSibling.nextSibling.nextSibling;
    var sel = tbl.getAttribute("selRows");

    txt.value = "";

    if (sel != null)
    {
        var sels = new String(sel).split(",");

        // sort it first descending
        Grid_SortArray(sels, Grid_DESC);

        for (s = 0; s < sels.length; s++)
        {
            var trIndex = parseInt(sels[s]);

            var tr = tbl.rows[trIndex];
            var key = tr.getAttribute("key");
            var jin = tr.getAttribute("justinserted");

            if (jin == null)
            {
                Grid_AddDeleted(grd, key);
            }

            Grid_DeleteUpdate(tr, key, (jin != null));
            
            tbl.deleteRow(trIndex);
        }
    }

    tbl.removeAttribute("selRows");

    Grid_RenumberRows(tbl);
    CanResolve(tbl);
}
function Grid_RenumberRows(tbl)
{
    for (t = 1; t < tbl.rows.length - 2; t++)
    {
        tbl.rows[t].cells[0].childNodes[0].innerHTML = t;
    }
}
function Grid_DeleteUpdate(tr, key, newRec)
{
    var tbl = tr.parentNode.parentNode;
    var grd = tbl.parentNode;

    var txt = null;

    if (newRec)
    {
        txt = grd.nextSibling.nextSibling;
    }
    else
    {
        txt = grd.nextSibling;
    }

    if (txt.value.length > 0)
    {
        var newUpdates = new Array();

        var updates = txt.value.split("<-$$->");

        for (g = 0; g < updates.length; g++)
        {
            var parts = updates[g].split(":");

            var partKey = parts[0];

            if (partKey != key) // not match, so keep it
            {
                newUpdates[newUpdates.length] = updates[g];
            }
        }

        txt.value = newUpdates.join("<-$$->");
    }
}
function Grid_RH_StoreSelected(tbl)
{
    var grd = tbl.parentNode;
    var txt = grd.nextSibling.nextSibling.nextSibling.nextSibling;
    var sel = tbl.getAttribute("selRows");

    Grid_LastSelected = grd;

    txt.value = "";

    if (sel != null)
    {
        var sels = new String(sel).split(",");

        for (s = 0; s < sels.length; s++)
        {
            var trIndex = parseInt(sels[s]);
            var tr = tbl.rows[trIndex];

            if (txt.value.length > 0)
            {
                txt.value += "," + tr.getAttribute("key");
            }
            else
            {
                txt.value = tr.getAttribute("key");
            }
        }
    }
}
function Grid_RH_ClearSelected(tbl)
{
    var sel = tbl.getAttribute("selRows");

    if (sel != null)
    {
        var sels = new String(sel).split(",");

        for (s = 0; s < sels.length; s++)
        {
            var trIndex = parseInt(sels[s]);
            var tr = tbl.rows[trIndex];

            var th = tr.cells[0];

            // remove selected flag
            tr.removeAttribute("selected");

            // turn it off
            th.style.cssText = "";
            tr.style.cssText = "";
        }

        tbl.removeAttribute("selRows");
    }

    Grid_RH_StoreSelected(tbl)
}
function Grid_RH_Unselect(tr)
{
    var th = tr.cells[0];

    var tbl = tr.parentNode.parentNode;
    var sel = tbl.getAttribute("selRows");

    // remove selected flag
    tr.removeAttribute("selected");

    // turn it off
    th.style.cssText = "";
    tr.style.cssText = "";

    if (sel != null)
    {
        var sels = new String(sel).split(",");

	    var index = Grid_StringExists(tr.rowIndex, sels);

	    if (index >= 0 && index < sels.length)
	    {
		    sels.splice(index, 1);
	    }

        if (sels.length > 0)
        {
            tbl.setAttribute("selRows", sels.join(","));
        }
        else
        {
            tbl.removeAttribute("selRows");
        }
    }
}
function Grid_RH_Select(tr)
{
    var th = tr.cells[0];

    var tbl = tr.parentNode.parentNode;
    var sel = tbl.getAttribute("selRows");

    // remove selected flag
    tr.setAttribute("selected", "true");

    // turn it off
    th.style.cssText = "background-color:rgb(222,223,216);border-top:solid 1px rgb(214,210,194);border-left:solid 1px rgb(214,210,194);border-bottom:solid 1px rgb(250,249,244);";
    tr.style.cssText = "background-color:rgb(182,202,234);";

    if (sel != null)
    {
        sel += "," + tr.rowIndex;
    }
    else
    {
        sel = tr.rowIndex;
    }

    tbl.setAttribute("selRows", sel);
}
function Grid_LoadControls(tbl)
{
    if (tbl.getAttribute("controls") == null)
    {
        var controls = new Array();

        var control = tbl.nextSibling;

        while (control != null)
        {
            controls[controls.length] = control;

            control = control.nextSibling;
        }

        tbl.setAttribute("controls", controls);
    }
}
function Grid_DDL_Select(ddl, value)
{
    var o = 0;

    var found = false;

    for (o = 0; o < ddl.options.length; o++)
    {
        if (ddl.options[o].value == value)
        {
            ddl.selectedIndex = o;
            found = true;
            break;
        }
    }

    if (!found)
    {
        ddl.selectedIndex = -1;
    }
}
function Grid_FixHeader(obj)
{
    var tbl = obj.parentNode.parentNode.parentNode;
    var tbd = tbl.getElementsByTagName("tbody");

    var month = tbd[0];
    var div = tbl.parentNode;

    obj.style.top = (div.scrollTop) + "px";
    obj.style.zIndex = (10000 - obj.sourceIndex);
}

function Grid_FixColumn(obj)
{
    var tbl = obj.parentNode.parentNode.parentNode;
    var tbd = tbl.getElementsByTagName("tbody");

    var month = tbd[0];
    var div = tbl.parentNode;

    obj.style.left = (div.scrollLeft) + "px";
    obj.style.zIndex = (10000 - obj.sourceIndex );
}
function Grid_StringExists(string, array)
{
    for (i = 0; i < array.length; i++)
    {
	    if (array[i] == string)
		    return i;
    }

    return -1;
}
function Grid_SortArray(array, direction)
{
    return array.sort(direction);
}
function Grid_ASC(a, b)
{
    return a - b;
}
function Grid_DESC(a, b)
{
    return b - a;
}
function Grid_Validate(grd)
{
    var tbl = grd.childNodes[0];

    var txtUpdates = grd.nextSibling;
    var txtInserts = grd.nextSibling.nextSibling;

    // validate the updates
    if (txtUpdates.value.length > 0)
    {
        var updates = txtUpdates.value.split("<-$$->");

        if (updates.length > 0)
        {
            for (u = 0; u < updates.length; u++)
            {
                var update = updates[u];

                if (update.length > 0)
                {
                    var parts = update.split(":");

                    var key = parts[0];
                    var fld = parts[1];
                    var typ = parts[2];
                    var val = update.substring(key.length + fld.length + typ.length + 3);

                    // only return false to stop everything if it does not validate
                    if (!Grid_ValidateUpdate(grd, key, fld, typ, val))
                    {
                        return false;
                    }
                }
            }
        }
    }

    // validate the inserts
    if (txtInserts.value.length > 0)
    {
        var inserts = txtInserts.value.split("<-$$->");

        if (inserts.length > 0)
        {
            // prepare second array of unique rows to check required fields on
            var insertRows = new Array();

            for (k = 0; k < inserts.length; k++)
            {
                var insert = inserts[k];

                if (insert.length > 0)
                {
                    var parts = insert.split(":");

                    var key = parts[0];
                    var fld = parts[1];
                    var typ = parts[2];
                    var val = insert.substring(key.length + fld.length + typ.length + 3);

                    // if this key has not been added to the unique array, do so
                    var index = Grid_StringExists(key, insertRows);

                    if (!(index >= 0 && index < insertRows.length)) // not found, so add
                    {
                        insertRows[insertRows.length] = key;
                    }

                    // only return false to stop everything if it does not validate
                    if (!Grid_ValidateUpdate(grd, key, fld, typ, val))
                    {
                        return false;
                    }
                }
            }

            // validate all isReq field in each inserted row
            if (insertRows.length > 0)
            {
                for (l = 0; l < insertRows.length; l++)
                {
                    var key = insertRows[l];

                    if (!Grid_ValidateInsertRow(grd, key))
                    {
                        return false;
                    }
                }
            }
        }
    }

    return true;
}
function Grid_ValidateInsertRow(grd, key)
{
    var tr = Grid_GetRowToValidate(grd, key);

    if (tr != null)
    {
        var tbl = grd.childNodes[0];

        // only validate if it's required; the validateupdate function will handle any value validations
        for (c = 1; c < tr.cells.length; c++)
        {
            var td = tr.cells[c];
            var col = tbl.rows[0].cells[c];
            var val = Grid_TrimString(td.childNodes[0].innerText);

            var isReq = col.getAttribute("isReq");
            var mode = col.getAttribute("mode");

            var valBox = tbl.getAttribute("valBox");
            var valBoxId = tbl.getAttribute("valBoxId");
            var valLabId = tbl.getAttribute("valLabId");

            if (isReq != null && isReq.toLowerCase() == "true")
            {
                isReq = true;
            }
            else
            {
                isReq = false;
            }

            if (valBox != null && valBox.toLowerCase() == "true")
            {
                valBox = true;
            }
            else
            {
                valBox = false;
            }

            // check if the field is required
            if (isReq && val.length == 0)
            {
                Grid_TD_OnFocus(td, true, true);

                if (valBox)
                {
                    var div = document.getElementById(valBoxId);
                    var lab = document.getElementById(valLabId);

                    lab.innerHTML = "The " + col.innerText + " is required.  You cannot insert a new record without this field.";
                    div.style.display = "inline";
                }

                return false;
            }
        }
    }

    return true;
}
function Grid_ValidateUpdate(grd, key, fld, typ, val)
{
    var td = Grid_GetCellToValidate(grd, key, fld);

    if (td != null)
    {
        var tbl = grd.childNodes[0];
        var col = tbl.rows[0].cells[td.cellIndex];

        var isReq = col.getAttribute("isReq");

        var valBox = tbl.getAttribute("valBox");
        var valBoxId = tbl.getAttribute("valBoxId");
        var valLabId = tbl.getAttribute("valLabId");

        var useVal = col.getAttribute("useVal");
        var valFun = col.getAttribute("valFun");
        var valMsg = col.getAttribute("valMsg");

        if (isReq != null && isReq.toLowerCase() == "true")
        {
            isReq = true;
        }
        else
        {
            isReq = false;
        }

        if (valBox != null && valBox.toLowerCase() == "true")
        {
            valBox = true;
        }
        else
        {
            valBox = false;
        }

        if (useVal != null && useVal.toLowerCase() == "true")
        {
            useVal = true;
        }
        else
        {
            useVal = false;
        }

        // check if the field is required first
        if (isReq && val.length == 0)
        {
            Grid_TD_OnFocus(td, true, true);

            if (valBox)
            {
                var div = document.getElementById(valBoxId);
                var lab = document.getElementById(valLabId);

                lab.innerHTML = "The " + col.innerText + " is required.  You cannot make an update to a field in this column with an empty value.";
                div.style.display = "inline";
            }

            return false;
        }
        else // not required OR is required and value exists
        {
            // if validation needed AND does not validate
            if (val.length > 0 && useVal && !eval(valFun + "(\"" + val + "\")"))
            {
                Grid_TD_OnFocus(td, true, true);

                if (valBox)
                {
                    var div = document.getElementById(valBoxId);
                    var lab = document.getElementById(valLabId);

                    lab.innerHTML = "The " + col.innerText + " value is invalid.  Please enter a different value.";
                    div.style.display = "inline";
                }

                return false;
            }
        }
    }

    return true;
}
function Grid_GetCellToValidate(grd, key, fld)
{
    var r = 0;
    var c = 0;

    var FoundRow = false;
    var FoundCell = false;

    var tbl = grd.childNodes[0];

    // search for row
    for (r = 1; r < tbl.rows.length - 1; r++)
    {
        var tr = tbl.rows[r];

        if (tr.getAttribute("key") != null && parseInt(tr.getAttribute("key")) == parseInt(key))
        {
            FoundRow = true;
            break;
        }
    }

    // search for cell
    for (c = 1; c < tbl.rows[0].cells.length; c++)
    {
        var td = tbl.rows[0].cells[c];

        if (td.getAttribute("fieldName") != null && td.getAttribute("fieldName") == fld)
        {
            FoundCell = true;
            break;
        }
    }

    if (FoundRow && FoundCell)
    {
        return tbl.rows[r].cells[c];
    }
    else
    {
        return null;
    }
}
function Grid_GetRowToValidate(grd, key)
{
    var r = 0;

    var FoundRow = false;

    var tbl = grd.childNodes[0];

    // search for row
    for (r = 1; r < tbl.rows.length - 1; r++)
    {
        var tr = tbl.rows[r];

        if (tr.getAttribute("key") != null && parseInt(tr.getAttribute("key")) == parseInt(key))
        {
            FoundRow = true;
            break;
        }
    }

    if (FoundRow)
    {
        return tbl.rows[r];
    }
    else
    {
        return null;
    }
}