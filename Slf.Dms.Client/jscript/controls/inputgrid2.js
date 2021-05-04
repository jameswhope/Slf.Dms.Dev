
window.document.onkeydown = Grid_WinKeyDown;

var Grid_LastSelected = null;
var Grid_AjaxURL = null;

function Grid_SelectionExists(tbl)
{
    for (var y = 1; y <= tbl.rows.length - 3; y++)
    {
        var row = tbl.rows[y];
        if (row.getAttribute("selected") != null)
        {
            return true;
        }
    }
    return false;
}
function Grid_GetSelectedStr(tbl)
{
    var result = "";
    for (var y = 1; y <= tbl.rows.length - 3; y++)
    {
        var row = tbl.rows[y];
        if (row.getAttribute("selected") != null)
        {
            if (result.length > 0)
                result += ",";
            result += y;
        }
    }
    return result;
}
function Grid_Validate(tbl, selectedOnly)
{
    //if no rows selected, force all rows to be validated
    if (!Grid_SelectionExists(tbl))
        selectedOnly = false;
        
    for (var y = 1; y <= tbl.rows.length - 3; y++)
    {
        var row = tbl.rows[y];
        for (var x = 1; x <= row.cells.length - 1; x++)
        {
            if (selectedOnly != true || row.getAttribute("selected") != null)
            {
                var cell = row.cells[x];
                var error = cell.getAttribute("error");
                if (error != null && error.length > 1)
                    return false;
            }
        }
    }
    return true;
}
function Grid_TableClick(tbl)
{
    var td = event.srcElement;
    
    if (td.tagName.toLowerCase() == "div")
        td = td.parentElement;
        
    if (td.tagName.toLowerCase() == "div")
        td = td.parentElement;
    
    if (td.tagName.toLowerCase() == "td")
    {
        if(td.cellIndex == 0)
        {
            Grid_RH_OnClick(td);
            Grid_RemoveError(tbl);
        }
        else
            Grid_TD_OnClick(td);
    }
    else if (td.tagName.toLowerCase() == "th")
    {
        if (td.getAttribute("SelectAll") == "1")
        {
            Grid_RH_SelectAll(tbl);
        }
        else
        {
            Grid_RH_OnClick(td);
        }
        Grid_RemoveError(tbl);
    }
}

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
function Grid_RemoveBorder(obj)
{
    obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 1px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 1px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 1px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 1px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 1px solid/g, '');
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
function Grid_CTL_Save(obj)
{
    if (obj.tagName.toLowerCase() == "input")
    {
        return Grid_TXT_Save(obj);
    }
}
function Grid_TXT_Save(txt)
{
    var td = txt.getAttribute("row");
    var tr = td.parentNode;
    var key = tr.cells[0].childNodes[0].innerHTML;

    var tbl = tr.parentNode.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    var WasChange = false;

    txt.value = Grid_TrimString(txt.value);

    // check if on new record
    if (key == "*" && txt.value.length > 0)
    {
        // create additional new record below
        Grid_CreateNewRecord(tbl);
    }

    // write the text value to the label
    if (txt.value.length == 0 && td.childNodes[0].innerHTML == "&nbsp;")
    {
        WasChange = false;
    }
    else
    {
        if (txt.value != td.childNodes[0].innerHTML)
        {
            if (txt.value.length == 0)
            {
                td.childNodes[0].innerHTML = "&nbsp;";
            }
            else
            {
                td.childNodes[0].innerHTML = txt.value;
            }

            WasChange = true;
        }
    }

    // cleanup new record
    if (key == "*" && txt.value.length > 0)
    {
        Grid_UpgradeNewRecord(td);
        Grid_SaveUpdate(td, txt.value, true);
    }
    else
    {
        if (WasChange)
        {
            Grid_SaveUpdate(td, txt.value, (tr.getAttribute("justinserted") != null));
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
}

function toString(o)
{
    if (o == true)
        return "1";
    else if (o == false)
        return "0";
}

function Grid_SaveUpdate(td, value, newRec)
{
    // Grid_AjaxURL must be set in calling page
    if (Grid_AjaxURL != null)
    {
        var Row = td.parentElement.rowIndex;
        var Col = td.cellIndex;
                
        var xml = new ActiveXObject("Microsoft.XMLHTTP");
        var request = "newRec=" + toString(newRec) + "&Row=" + Row + "&Col=" + Col + "&value=" + encodeURIComponent(value);
        xml.open("POST", Grid_AjaxURL, true);
        xml.setRequestHeader("content-type", "application/x-www-form-urlencoded");
        xml.send(request);
    
        xml.onreadystatechange = function()
        {
            if (xml.readyState == 4)
            {
                var result = xml.responseText;
                
                //if there is a validation error
                if (result != "1")
                {
                    td.setAttribute("error", result);
                    td.style.border = "solid 1px red";
                }
                else
                {
                    //no validation error
                    Grid_RemoveBorder(td);
                    td.removeAttribute("error");
                }
            }
        };    
    }
}
function Grid_SaveDelete(rows)
{
    // Grid_AjaxURL must be set in calling page
    if (Grid_AjaxURL != null)
    {
        var strRows = "";
        for (var i = 0; i < rows.length; i++)
        {
            if (i != 0)
                strRows += ",";
            strRows += rows[i];
        }
                
        var xml = new ActiveXObject("Microsoft.XMLHTTP");
        var request = "rows=" + strRows;
        xml.open("POST", Grid_AjaxURL, true);
        xml.setRequestHeader("content-type", "application/x-www-form-urlencoded");
        xml.send(request);
    }
}

function Grid_CreateNewRecord(tbl)
{
    var curTr = tbl.rows[tbl.rows.length - 2];
    var newTr = curTr.cloneNode(true);              // clone last "new" row and it's children
    
    // insert the new record clone
    curTr.insertAdjacentElement("AfterEnd", newTr);
    
    // set red border for required cells
    for (var i = 1; i < newTr.cells.length - 1; i++)
    {
        var cell = curTr.cells[i];
        var error = cell.getAttribute("error");
        if (error != null && error.length > 1)
            cell.style.border="red 1px solid";
    }
}
function Grid_TXT_OnKeyDown(txt)
{
    Grid_MoveControl(window.event, txt);
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

    var nextTd = null;
    var found = false;
    
    if (td.cellIndex < oTr.cells.length - 1)
    {
        nextTd=oTd.nextSibling;
        found = true;
    }
    else if (oTr.rowIndex < tbl.rows.length - 2)
    {
        nextTd = tbl.rows[oTr.rowIndex + 1].cells[1];
        found = true;
    }

    if (found)
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj))) // try to save
        {
            Grid_TD_OnFocus(nextTd, true);
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

    var prevTd = null;
    var found = false;

    if (td.cellIndex > 1)
    {
        prevTd = oTd.previousSibling;
        found = true;
    }
    else if (oTr.rowIndex > 1)
    {
        prevTd = tbl.rows[oTr.rowIndex - 1].cells[oTr.cells.length - 1];
        found = true;
    }

    if (found)
    {
        if (!SaveFirst || (SaveFirst && Grid_CTL_Save(obj))) // try to save
        {
            Grid_TD_OnFocus(prevTd, true);
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
            Grid_TD_OnFocus(tbl.rows[tr.rowIndex - 1].cells[td.cellIndex], true, true);
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
            Grid_TD_OnFocus(tbl.rows[tr.rowIndex + 1].cells[td.cellIndex], false);
        }

        return true;
    }

    return false;
}
function Grid_TD_OnClick(td)
{
    Grid_TD_OnFocus(td, true);
}
function Grid_TD_OnFocus(td, CheckLeft, CheckTop)
{
    var tbl = td.parentNode.parentNode.parentNode;
    var col = tbl.rows[0].cells[td.cellIndex];

    Grid_LoadControls(tbl);
    Grid_RH_ClearSelected(tbl);

    var controls = tbl.getAttribute("controls");

    Grid_PlaceTXT(controls[0], td, CheckLeft, CheckTop);
    
    //set error text if there is an error
    var error = td.getAttribute("error");
    if (error != null)
        Grid_ShowError(tbl, error);
    else
        Grid_RemoveError(tbl);
}
function Grid_RemoveError(tbl)
{
    var controls = tbl.parentElement.nextSibling.nextSibling.innerHTML.split(";");
    document.getElementById(controls[0]).innerHTML="";
    
    if (controls.length > 1)
        document.getElementById(controls[1]).style.display = "none";
    if (controls.length > 2)
        document.getElementById(controls[2]).style.display = "block";
}
function Grid_ShowError(tbl, s)
{
    var controls = tbl.parentElement.nextSibling.nextSibling.innerHTML.split(";");
    document.getElementById(controls[0]).innerHTML = s;
    
    if (controls.length > 1)
        document.getElementById(controls[1]).style.display = "block";
    if (controls.length > 2)
        document.getElementById(controls[2]).style.display = "none";
}
function Grid_PlaceTXT(txt, td, CheckLeft, CheckTop)
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
        txt.style.left = td.offsetLeft;
    }

    if (CheckTop) // navigation needs to check for top scroll offset
    {    
        txt.style.top = td.offsetTop - 20;
        txt.focus();
        txt.style.top = td.offsetTop;
    }
    txt.focus();
    Grid_SelectFullValue(txt);
}
function Grid_RH_SelectAll(tbl)
{
    for (var i = 1; i < tbl.rows.length - 2; i++)
    {
        Grid_RH_OnClick(tbl.rows[i].cells[0], true);
    }
}
function Grid_RH_OnClick(th, multiSelect)
{
    if (th.colSpan == 1)
    {
        var tr = th.parentNode;
        
        if (tr.cells[0].childNodes[0].innerHTML != "*") // cannot select the new record
        {
            var tbl = tr.parentNode.parentNode;
            var sel = tbl.getAttribute("selRows");

            if (sel != null)
            {
                var sels = new String(sel).split(",");

                if (window.event.ctrlKey || multiSelect == true) // WAS holding down ctrl key
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

            Grid_LastSelected = tbl.parentNode;
        }
    }
}
function Grid_DeleteSelected(grd)
{
    var tbl = grd.childNodes[0];
    var sel = tbl.getAttribute("selRows");

    if (sel != null)
    {
        var sels = new String(sel).split(",");

        // sort it first descending
        Grid_SortArray(sels, Grid_DESC);

        // delete rows from the server table
        Grid_SaveDelete(sels);

        for (s = 0; s < sels.length; s++)
        {
            var trIndex = parseInt(sels[s]);

            tbl.deleteRow(trIndex);
        }
    }

    tbl.removeAttribute("selRows");

    Grid_RenumberRows(tbl);
}
function Grid_RenumberRows(tbl)
{
    for (t = 1; t < tbl.rows.length - 2; t++)
    {
        tbl.rows[t].cells[0].childNodes[0].innerHTML = t;
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

    // set selected flag
    tr.setAttribute("selected", "true");

    // turn it on
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
//function Grid_FixHeader(obj)
//{
//    var tbl = obj.parentNode.parentNode.parentNode;
//    var tbd = tbl.getElementsByTagName("tbody");

//    var month = tbd[0];
//    var div = tbl.parentNode;

//    obj.style.top = (div.scrollTop) + "px";
//    obj.style.zIndex = (10000 - obj.sourceIndex);
//}

//function Grid_FixColumn(obj)
//{
//    var tbl = obj.parentNode.parentNode.parentNode;
//    var tbd = tbl.getElementsByTagName("tbody");

//    var month = tbd[0];
//    var div = tbl.parentNode;

//    obj.style.left = (div.scrollLeft) + "px";
//    obj.style.zIndex = (10000 - obj.sourceIndex );
//}
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
