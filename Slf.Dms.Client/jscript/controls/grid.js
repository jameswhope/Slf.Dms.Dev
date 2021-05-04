function Grid_FixHeader(obj)
{
//    var tbl = obj.parentNode.parentNode.parentNode;
//    var tbd = tbl.getElementsByTagName("tbody");

//    var month = tbd[0];
//    var div = tbl.parentNode;

//    obj.style.top = (div.scrollTop) + "px";
//    obj.style.zIndex = (10000 - obj.sourceIndex);
}
function Grid_FixChecks(tbl, txtSelected)
{
    var IDs = txtSelected.value.split(",");
         
    for (var i = 0; i < IDs.length; i++)
    {
        for (var x = 0; x < tbl.rows.length; x++)
        {
      
            var tr = tbl.rows[x];
            if (tr.KeyID == IDs[i])
            {
                var img1=tr.firstChild.firstChild;
                var img2=img1.nextSibling;
                var chk=img2.nextSibling;
                img1.style.display="none";
                img2.style.display="block";
                chk.checked=true;
            }
        }
    }
}
function Grid_GetTable(obj)
{
    while (obj.tagName != null && obj.tagName.toLowerCase() != "table")
    {
        obj = obj.parentNode;
    }

    return obj;
}
function Grid_CheckOrUncheck(obj, id)
{
    var tbl = Grid_GetTable(obj);

    var txtSelected = tbl.nextSibling;
    var txtControls = txtSelected.nextSibling;

    if (obj.checked)
    {
	    Grid_AddSelectedID(id, txtSelected);
    }
    else
    {
	    Grid_RemoveSelectedID(id, txtSelected);
    }

    tbl.setAttribute("SelectedIDs", txtSelected.value);

    if (txtControls.value.length > 0)
    {
        var Controls = txtControls.value.split(",");

        for (c = 0; c < Controls.length; c++)
        {
            document.getElementById(Controls[c]).disabled = txtSelected.value.length == 0;
        }
    }
}
function Grid_AddSelectedID(id, txt)
{
    if (txt.value.length > 0)
    {
        txt.value += "," + id;
    }
    else
    {
        txt.value = id;
    }
}
function Grid_RemoveSelectedID(id, txt)
{
    var array = txt.value.split(",");

    var index = Grid_SelectedIDExists(id, array);

    if (index >= 0 && index < array.length)
    {
	    array.splice(index, 1);
    }

    txt.value = array.join(",");
}
function Grid_SelectedIDExists(id, array)
{
    for (i = 0; i < array.length; i++)
    {
	    if (array[i] == id)
		    return i;
    }

    return -1;
}
function Grid_CheckAll(obj)
{
    var tbl = Grid_GetTable(obj);

    for (c = 1; c < tbl.rows.length; c++)
    {
        if (tbl.rows[c].cells[0].childNodes[2] != null && tbl.rows[c].cells[0].childNodes[2].tagName.toLowerCase() == "input")
        {
	        var off = tbl.rows[c].cells[0].childNodes[0];
	        var on = tbl.rows[c].cells[0].childNodes[1];
	        var chk = tbl.rows[c].cells[0].childNodes[2];

            if (!chk.checked)
            {
	            off.style.display = "none";
	            on.style.display = "inline";
	            chk.checked = true;
	        }
	    }
    }
}
function Grid_UncheckAll(obj)
{
    var tbl = Grid_GetTable(obj);

    for (u = 1; u < tbl.rows.length; u++)
    {
        if (tbl.rows[u].cells[0].childNodes[2] != null && tbl.rows[u].cells[0].childNodes[2].tagName.toLowerCase() == "input")
        {
	        var off = tbl.rows[u].cells[0].childNodes(0);
	        var on = tbl.rows[u].cells[0].childNodes(1);
	        var chk = tbl.rows[u].cells[0].childNodes(2);

            if (chk.checked)
            {
	            on.style.display = "none";
	            off.style.display = "inline";
	            chk.checked = false;
	        }
	    }
    }
}
function Grid_RowHover(tbl, over)
{
    var obj = event.srcElement;
    
    if (obj.tagName.toLowerCase() != "td" && obj.parentElement.tagName.toLowerCase() == "td")
        obj = obj.parentElement;
        
    if (obj.tagName.toLowerCase() != "td" && obj.parentElement.parentElement.tagName.toLowerCase() == "td")
        obj = obj.parentElement.parentElement;
        
    if (obj.tagName.toLowerCase() == "td")
    {
        //remove hover from last tr
        if (tbl.getAttribute("lastTr") != null)
        {
            var lastTr=tbl.getAttribute("lastTr");
            var coldColor=lastTr.getAttribute("coldColor");
            if (coldColor != null)
                lastTr.style.backgroundColor = coldColor;
            else
                lastTr.style.backgroundColor = "#ffffff";
        }

        //if the mouse is over the table, set hover to current tr
        if (over)
        {
            var curTr = obj.parentElement;
            if (curTr.getAttribute("hover") != "false")
            {
                if (curTr.style.backgroundColor != null)
                {
                    curTr.setAttribute("coldColor",curTr.style.backgroundColor);
                }
                curTr.style.backgroundColor = "#f3f3f3";
                tbl.setAttribute("lastTr", curTr);
            }
        }
    }
}

function ApplyToChildren(a, color)
{
    for (var i = 0; i < a.childNodes.length; i++)
    {
        var td = a.childNodes[i];
        td.style.backgroundColor = color;
    }
}
  
function Grid_RowHover_Nested(tbl, over)
{
    var obj = event.srcElement;
    
    while (obj.tagName.toLowerCase() != "table" && obj.tagName.toLowerCase() != "td")
    {
        obj = obj.parentElement;
    }
  
    if (obj.tagName.toLowerCase() == "td" & obj.getAttribute("hover") != "false")
    {
        //remove hover from last tr
        if (tbl.getAttribute("lastTr") != null)
        {
    
            var lastTr=tbl.getAttribute("lastTr");
            var coldColor=lastTr.getAttribute("coldColor");
            if (!IsNullOrEmpty(coldColor))
                 ApplyToChildren(lastTr, coldColor);
            else
                ApplyToChildren(lastTr,  "#ffffff");
        }

        //if the mouse is over the table, set hover to current tr
      
        if (over)
        {
            var curTr = obj.parentElement.parentElement;
            if (curTr.getAttribute("hover") != "false")
            {
                
                if (!IsNullOrEmpty(curTr.style.backgroundColor))
                {
             
                    if (IsNullOrEmpty(curTr.getAttribute("coldColor")))
                    {
                        curTr.setAttribute("coldColor",curTr.style.backgroundColor);
                        
                        //set the highlighted color for this row
                        var color = new RGBColor(curTr.style.backgroundColor);
                        var r = color.r-10;
                        var g = color.g-10;
                        var b = color.b-10;
                        if (r<0) r=0;
                        if (g<0) g=0;
                        if (b<0) b=0;
                        curTr.setAttribute("hotColor", "rgb(" + r + "," + g + "," + b + ")");
                    }
                }
                
                var hotColor=curTr.getAttribute("hotColor");
                if (!IsNullOrEmpty(hotColor))
                    ApplyToChildren(curTr, hotColor);
                else
                    ApplyToChildren(curTr, "#f3f3f3");
                    
                tbl.setAttribute("lastTr", curTr);
            }
        }
    }
}
function IsNullOrEmpty(s)
{
    return s == null || s == "";
}