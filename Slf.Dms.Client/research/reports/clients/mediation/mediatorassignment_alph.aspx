<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mediatorassignment_alph.aspx.vb" Inherits="mediatorassignment_alph" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Negotiator Assignment</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript">
    function Submit()
    {
        var Error = false;
        var LastVal = "";
                
        LoadControls();
                
        //build criteria
        txtCriteria.value="";
        for (var i = 1; i < tblMediators.rows.length; i++)
        {
            var row = tblMediators.rows[i];
            var first = row.cells[0].firstChild.value;
            var second = row.cells[1].firstChild.value;
            var UserID = row.getAttribute("UserID");
            var parms = UserID + "," + first + "," + second;
            
            if (first=="" || second=="")
            {
                Error=true;
                break;
            }
            else if (i>1)
            {
                if (!(first>last && second>first))
                {
                    Error=true;
                    break;
                }
            }
            last=second;
            
            if (txtCriteria.value.length>0)
                txtCriteria.value += "|";
            txtCriteria.value += parms;
        }
        
        if (Error)
        {
            ShowMessage("A range is either missing or overlapping.  Please review to ensure that all letter ranges are covered, and that none are covered twice.");
        }
        else
        {
            <%=ClientScript.GetPostBackEventReference(lnkSubmit, Nothing) %>;
        }
    }
    function UpdateAll()
    {
        LoadControls();
        
        for (var i = 1; i < tblMediators.rows.length; i++)
        {
            UpdateClients(tblMediators.rows[i].cells[0].firstChild);
        }
    }
    function UpdateClients(txt)
    {
        LoadControls();
        
        var row = txt.parentElement.parentElement;
        var first = row.cells[0].firstChild.value;
        var second = row.cells[1].firstChild.value;
        var parms = first + "," + second + "," + chkReassign.checked;
        if (first.length==2 && second.length==2)
        {
            row.cells[2].innerHTML="&nbsp;";
            <%=ClientScript.GetCallbackEventReference(Me, "parms", "CallbackUpdate", "row", True) %>;
        }
        else
        {
            row.cells[2].innerHTML="&nbsp;";
            row.cells[3].innerHTML="&nbsp;";
            row.cells[4].innerHTML="&nbsp;";
        }
    }
    function CallbackUpdate(result, context)
    {
        var row = context;
        var parts = result.split("|");
        row.cells[2].innerHTML=parts[0];
        row.cells[3].innerHTML=parts[1];
        row.cells[4].innerHTML=parts[2];
    }
    function ConfirmUnassignSelected()
    {
        if (confirm("Are you sure you want to remove all negotiator assignments of selected clients?"))
        {  
            <%=ClientScript.GetPostBackEventReference(lnkUnassignSelected,Nothing) %>;
        }
    }
    function ConfirmUnassignAll()
    {
        if (confirm("Are you sure you want to remove all negotiator assignments?"))
        {
            <%=ClientScript.GetPostBackEventReference(lnkUnassignAll, Nothing) %>;
        }
    }
    function SelectCell(tbl)
    {
        var obj = event.srcElement;
        
        if (obj.tagName.toLowerCase() != "td" && obj.parentElement.tagName.toLowerCase() == "td")
            obj = obj.parentElement;
            
        if (obj.tagName.toLowerCase() != "td" && obj.parentElement.parentElement.tagName.toLowerCase() == "td")
            obj = obj.parentElement.parentElement;
            
        if (obj.tagName.toLowerCase() == "td" && obj.cellIndex == 5)
        {
            //remove hover from last tr
            if (tbl.getAttribute("selTd") != null)
            {
                tbl.getAttribute("selTd").style.backgroundColor = "#ffffff";
            }
            
            obj.style.backgroundColor = "#f3f3f3";
            tbl.setAttribute("selTd", obj);
        }
    }
    function SwapNodes(node1, node2)
    {
        var nextSibling = node1.nextSibling;
        var parentNode = node1.parentNode;
        node2.parentNode.replaceChild(node1, node2);
        parentNode.insertBefore(node2, nextSibling);  
    }

    function FixForced()
    {
        LoadControls();

        tblMediators.rows[1].cells[0].firstChild.disabled=true;
        tblMediators.rows[1].cells[0].firstChild.value="Aa";
        
        if (tblMediators.rows.length > 2)
        {
            tblMediators.rows[1].cells[1].firstChild.disabled=false;
            tblMediators.rows[tblMediators.rows.length - 1].cells[0].firstChild.disabled=false;    
            
            if (tblMediators.rows.length > 3)
            {
                for (var i = 2; i < tblMediators.rows.length - 1; i++)
                {
                    tblMediators.rows[i].cells[0].disabled=false;
                    tblMediators.rows[i].cells[1].disabled=false;
                }
            }
        }   
        
        tblMediators.rows[tblMediators.rows.length - 1].cells[1].firstChild.disabled=true;
        tblMediators.rows[tblMediators.rows.length - 1].cells[1].firstChild.value="Zz";
    }
    function Include()
    {
        LoadControls();
        
        if (lstMediators.selectedIndex >= 0)
        {
            var selOp = lstMediators.options[lstMediators.selectedIndex];
            var id = selOp.value;
            var text = selOp.innerHTML;
            
            //clone last item, set not disabled, and add before last item
       
            var lastTr = tblMediators.rows[tblMediators.rows.length - 1]
            var clone = lastTr.cloneNode(true);
            lastTr.insertAdjacentElement("beforeBegin", clone);
            clone.cells[1].firstChild.disabled = false;
            clone.cells[0].firstChild.value = "";
            clone.cells[1].firstChild.value = "";
            clone.cells[2].innerHTML="&nbsp;";
            clone.cells[3].innerHTML="&nbsp;";
            clone.cells[4].innerHTML="&nbsp;";
            
            clone.cells[5].click();
            clone.nextSibling.cells[5].click();
            
            //change last item to new mediator
            lastTr.cells[5].innerHTML = text;
            
            lastTr.cells[5].setAttribute("UserID", id);
            lastTr.setAttribute("UserID", id);
            
            FixForced()
        }
    }
    function Exclude()
    {
        LoadControls();
        var selTd =  tblMediators.getAttribute("selTd");
        if (selTd != null)
        {
            if (tblMediators.rows.length <= 2)
            {
                alert("You cannot remove the last negotiator.");
            }
            else
            {
                var row = selTd.parentElement;
                var nextRow = row.nextSibling;
                
                row.removeNode(true);
                tblMediators.setAttribute("selTd", nextRow);
                if (nextRow != null)
                    nextRow.cells[5].click();
                
                FixForced();
            }
        }
    }
    function MoveUp()
    {
        LoadControls();
        var selTd =  tblMediators.getAttribute("selTd");
        if (selTd != null)
        {
            var row = selTd.parentElement;
            if (row.rowIndex > 1)
            {
                var td2 = row.previousSibling.cells[5];
                SwapNodes(selTd, td2);
                selTd.parentElement.UserID=selTd.UserID;
                td2.parentElement.UserID=td2.UserID;
            }
        }
    }
    function MoveDown()
    {
        LoadControls();
        var selTd =  tblMediators.getAttribute("selTd");
        if (selTd != null)
        {
            var row = selTd.parentElement;
            if (row.rowIndex < tblMediators.rows.length-1)
            {
                var td2 = row.nextSibling.cells[5];
                SwapNodes(selTd, td2);
                selTd.parentElement.UserID=selTd.UserID;
                td2.parentElement.UserID=td2.UserID;
            }
        }
    }
    function NormalizeValue(val, idx)
    {
        if (val.length>0)
        {
            var char1 = "";
            char1 = val.substr(0,1);
                
            var char2 = "";
            if (val.length>1)
                char2 = val.substr(1,1);
            else
            {
                if (idx==0)
                    char2 = "a";
                else if (idx==1)
                    char2 = "z";
            }
                        
            return char1.toUpperCase() + char2.toLowerCase();
        }
        else
            return "";
    }
    function GetNextValue(val)
    {
        var char1 = val.substr(0,1);
        var char2 = val.substr(1,1);
        
        
        if (char2=="z" && char1 != "Z")
        {
            char1 = String.fromCharCode(char1.charCodeAt(0) + 1)
            char2 = "a";
        }
        else if (char2 != "z")
        {
            char2 = String.fromCharCode(char2.charCodeAt(0) + 1)
        }
        
        return char1.toUpperCase() + char2.toLowerCase();
    }
    function GetPrevValue(val)
    {
        var char1 = val.substr(0,1);
        var char2 = val.substr(1,1);
        
        if (char2=="a" && char1 != "A")
        {
            char1 = String.fromCharCode(char1.charCodeAt(0) - 1)
            char2 = "z";
        }
        else if (char2 != "a")
        {
            char2 = String.fromCharCode(char2.charCodeAt(0) - 1)
        }
        
        return char1.toUpperCase() + char2.toLowerCase();
    }
    function LinkValues(txt, idx)
    {
        LoadControls();

        txt.value = NormalizeValue(txt.value,idx);
        if (txt.value.length==2)
        {
            if (idx == 0)
            {
                //find prev
                var txt2 = txt.parentElement.parentElement.previousSibling.cells[1].firstChild;
                txt2.value=GetPrevValue(txt.value);
                UpdateClients(txt2);
                
            }
            else if (idx == 1)
            {
                //find next
                var txt2 = txt.parentElement.parentElement.nextSibling.cells[0].firstChild;
                txt2.value=GetNextValue(txt.value);
                UpdateClients(txt2);
            }
        }
        UpdateClients(txt);
    }
    
    var tblMediators = null;
    var lstMediators = null;
    var chkReassign = null;
    var txtCriteria = null;
    function LoadControls()
    {
        tblMediators = document.getElementById("tblMediators");
        lstMediators = document.getElementById("<%=lstMediators.ClientID %>");
        chkReassign = document.getElementById("<%=chkReassign.ClientID %>");
        txtCriteria = document.getElementById("<%=txtCriteria.ClientID %>");
    }
    
    function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
    </script>
    <style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
    </style>
</head>

    <body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;" scroll="no" onload="UpdateAll();">
        <form id="form1" runat="server">

        
            <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;table-layout:fixed">
                <tr>
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            
                                            <td nowrap="true">
                                                <asp:LinkButton class="gridButton" id="lnkReset" runat="server"><img id="Img11" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Reset</asp:LinkButton>
                                            </td>
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            <td nowrap="true"><a class="gridButton" href="#" onclick="ConfirmUnassignSelected()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" />Unassign Selected</a></td>
                                            <asp:LinkButton ID="lnkUnassignSelected" runat="server"></asp:LinkButton>
                                            
                                            <td nowrap="true"><img id="Img8" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><a class="gridButton" href="#" onclick="ConfirmUnassignAll()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" />Unassign All</a></td>
                                            
                                            <asp:LinkButton ID="lnkUnassignAll" runat="server"></asp:LinkButton>
                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="trInfoBox" runat="server">
                    <td>
                        <div class="iboxDiv" style="padding:10px 10px 10px 10px">
                            <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width:16;"><img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                    <td>
                                        <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="iboxHeaderCell">INFORMATION:</td>
                                            </tr>
                                            <tr>
                                                <td class="iboxMessageCell"><%=dt.Rows.Count %> Clients selected (<%=(dt.Select("not assignedmediator is null")).Length %> already assigned)</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div runat="server" id="dvError" style="display:none;">
                            <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
				                <tr>
					                <td valign="top" style="width:20;"><img id="Img5" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
					                <td runat="server" id="tdError"></td>
				                </tr>
			                </table>&nbsp;
			            </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:CheckBox ID="chkReassign" runat="server" Text="Reassign already assigned" Checked="true" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="height:100%">
                        <table style="font-family:tahoma;font-size:11px">
                            <tr>
                                <td>
                                    <div style="height:200px;width:350px;overflow:auto;border:solid 1px gray">
                                        <table id="tblMediators" onclick="SelectCell(this)" class="list" style="width:100%;font-family:tahoma;font-size:11px" cellspacing="0">
                                            <colgroup>
                                                <col width="30" align="center"/>
                                                <col width="30" align="center"/>
                                                <col align="center"/>
                                                <col align="center"/>
                                                <col align="right"/>
                                                <col align="left" style="padding-left:5px"/>
                                            </colgroup>
                                            <thead>
                                                <tr style="height:18px">
                                                    <th>Start</th>
                                                    <th>End</th>
                                                    <th>Clients</th>
                                                    <th>Accts</th>
                                                    <th>SDA Sum</th>
                                                    <th>Negotiator</th>
                                                </tr>
                                            </thead>
                                            <tbody id="tbMediators">
                                                <asp:Literal ID="ltrGrid" runat="server"></asp:Literal>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                                <td>
                                    <table>
                                        <tr>
                                            <td nowrap="true" style="padding-bottom:4px"><a class="gridButton" href="javascript:MoveUp();"><img id="Img7" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_arrowup (red).png" /></a></td>
                                        </tr>
                                        <tr>
                                            <td nowrap="true" style="padding-bottom:6px"><a class="gridButton" href="javascript:MoveDown();"><img id="Img6" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_arrowdown (red).png" /></a></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table>
                                        <tr>
                                            <td nowrap="true" ><a class="gridButton" href="javascript:Include();"><img id="Img9" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_selector_prev.png" /></a></td>
                                            <td nowrap="true" ><a class="gridButton" href="javascript:Exclude();"><img id="Img10" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_selector_next.png" /></a></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <asp:ListBox ID="lstMediators" runat="server" Width="200" Height="202" Font-Names="tahoma" Font-Size="11px"></asp:ListBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                        <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img3" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                                <td align="right"><a runat="server" id="lnkDelete" tabindex="2" style="color:black" class="lnk" href="javascript:Submit();">Commit Selected Assignments<img id="Img4" style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" /></a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkSubmit" runat="server"></asp:LinkButton>
            <input type="hidden" runat="server" id="txtCriteria" />
        </form>        
    </body>


</html>














