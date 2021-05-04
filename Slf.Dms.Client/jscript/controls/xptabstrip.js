var pagename = ''
var XPTabStrip_Panes = new Array();

function XPTabStrip_OnMouseOver(tbl)
{
    var tabControl = tbl.parentElement.parentElement.parentElement.parentElement;
    var txtSelected = tabControl.nextSibling;

    if (tbl.index != txtSelected.value)
    {
        XPTabStrip_SetStyle(tbl.rows[0].cells[0], "tabXPCellTopLeftHover");
        XPTabStrip_SetStyle(tbl.rows[0].cells[1], "tabXPCellTopHover");
        XPTabStrip_SetStyle(tbl.rows[0].cells[2], "tabXPCellTopRightHover");

        XPTabStrip_SetStyle(tbl.rows[1].cells[0], "tabXPCellMidLeftHover");
        XPTabStrip_SetStyle(tbl.rows[1].cells[1], "tabXPCellMidHover");
        XPTabStrip_SetStyle(tbl.rows[1].cells[2], "tabXPCellMidRightHover");
    }

    window.event.cancelBubble = true;
    window.event.returnValue = false;

    return false;
}
function XPTabStrip_OnMouseOut(tbl)
{
    var tabControl = tbl.parentElement.parentElement.parentElement.parentElement;
    var txtSelected = tabControl.nextSibling;
    
    if (tbl.index != txtSelected.value)
    {
        XPTabStrip_SetStyle(tbl.rows[0].cells[0], "tabXPCellTopLeftUns");
        XPTabStrip_SetStyle(tbl.rows[0].cells[1], "tabXPCellTopUns");
        XPTabStrip_SetStyle(tbl.rows[0].cells[2], "tabXPCellTopRightUns");

        XPTabStrip_SetStyle(tbl.rows[1].cells[0], "tabXPCellMidLeftUns");
        XPTabStrip_SetStyle(tbl.rows[1].cells[1], "tabXPCellMidUns");
        XPTabStrip_SetStyle(tbl.rows[1].cells[2], "tabXPCellMidRightUns");
    }

    window.event.cancelBubble = true;
    window.event.returnValue = false;

    return false;
}
function XPTabStrip_LoadPanes(tabControl)
{
    if (XPTabStrip_Panes.length == 0)
    {
        for (i = 1; i < (tabControl.rows[0].cells.length - 1); i++)
        {
            var tbl = tabControl.rows[0].cells[i].childNodes[0];

            XPTabStrip_Panes[XPTabStrip_Panes.length] = document.getElementById(tbl.getAttribute("page"));
        }
    }
}
function XPTabStrip_OnClick(tbl)
{
    var curTd = tbl.parentElement;
    var tabControl = tbl.parentElement.parentElement.parentElement.parentElement;
    var redirect = tbl.getAttribute("redirect");
    var tblindex = tbl.index;
    if (redirect != null) // suppose to redirect
    {
        window.navigate(redirect);
    }
    else
    {
        var txtSelected = tabControl.nextSibling;

        XPTabStrip_LoadPanes(tabControl);

        // flip current body row off
        tabControl.rows[parseInt(txtSelected.value) + 1].style.display = "none";

        // flip all panels off
        for (var i = 0; i < XPTabStrip_Panes.length; i++)
        {
            XPTabStrip_Panes[i].style.display = "none";
        }

        txtSelected.value = tbl.index;

        // flip selected body row on
        tabControl.rows[parseInt(tbl.index) + 1].style.display = "inline";

        // flip selected panel on
        XPTabStrip_Panes[parseInt(txtSelected.value)].style.display = "inline";

        for (i = 0; i < tabControl.rows[0].cells.length; i++)
        {
            var td = tabControl.rows[0].cells[i];

            if (td.istab == "true")
            {
                var tbl = td.childNodes[0];

                if (i == curTd.cellIndex) // just selected
                {
                    XPTabStrip_SetStyle(td, "tabXPHolderSel");
                    XPTabStrip_SetStyle(tbl, "tabXPHolderTableSel");

                    XPTabStrip_SetStyle(tbl.rows[0].cells[0], "tabXPCellTopLeftSel");
                    XPTabStrip_SetStyle(tbl.rows[0].cells[1], "tabXPCellTopSel");
                    XPTabStrip_SetStyle(tbl.rows[0].cells[2], "tabXPCellTopRightSel");

                    XPTabStrip_SetStyle(tbl.rows[1].cells[0], "tabXPCellMidLeftSel");
                    XPTabStrip_SetStyle(tbl.rows[1].cells[1], "tabXPCellMidSel");
                    XPTabStrip_SetStyle(tbl.rows[1].cells[2], "tabXPCellMidRightSel");
                }
                else // not selected
                {
                    XPTabStrip_SetStyle(td, "tabXPHolderUns");
                    XPTabStrip_SetStyle(tbl, "tabXPHolderTableUns");

                    XPTabStrip_SetStyle(tbl.rows[0].cells[0], "tabXPCellTopLeftUns");
                    XPTabStrip_SetStyle(tbl.rows[0].cells[1], "tabXPCellTopUns");
                    XPTabStrip_SetStyle(tbl.rows[0].cells[2], "tabXPCellTopRightUns");

                    XPTabStrip_SetStyle(tbl.rows[1].cells[0], "tabXPCellMidLeftUns");
                    XPTabStrip_SetStyle(tbl.rows[1].cells[1], "tabXPCellMidUns");
                    XPTabStrip_SetStyle(tbl.rows[1].cells[2], "tabXPCellMidRightUns");
                }
            }
        }
    }
    if (pagename == 'accounts') {
        if (document.getElementById('ctl00_ctl00_cphBody_cphBody_tr1') != null && document.getElementById('ctl00_ctl00_cphBody_cphBody_tr2') != null) {

            if (tblindex == 3) {
               
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr3').style.display = "inline";
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr1').style.display = "block";
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr2').style.display = "none";
            }else 
            if (tblindex == 0) {
               
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr3').style.display = "inline";
            
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr1').style.display = "none";
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr2').style.display = "inline";
            }
            else {
                
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr1').style.display = "none";
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr2').style.display = "none";
                document.getElementById('ctl00_ctl00_cphBody_cphBody_tr3').style.display = "none";
            }
        }
    }
}
function XPTabStrip_SetStyle(el, className)
{
    if (el.className != className)
    {
        el.className = className;
    }
}