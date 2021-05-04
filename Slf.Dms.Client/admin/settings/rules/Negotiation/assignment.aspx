<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="assignment.aspx.vb" Inherits="admin_settings_negotiation_assignment" title="DMP - Admin Settings - Rules" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript">
    function Record_Save()
    {
        if (RequiredExist())
        {
            <%=ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Record_SaveAndClose()
    {
        if (RequiredExist())
        {
            <%=ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
        }
    }
    function Record_Cancel(){<%=ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;}

    function RequiredExist()
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
            return false;
        }
        else
        {
            return true;
        }
    }
    
    function SelectCell(tbl)
    {
        var obj = event.srcElement;
        
        if (obj.tagName.toLowerCase() != "td" && obj.parentElement.tagName.toLowerCase() == "td")
            obj = obj.parentElement;
            
        if (obj.tagName.toLowerCase() != "td" && obj.parentElement.parentElement.tagName.toLowerCase() == "td")
            obj = obj.parentElement.parentElement;
            
        if (obj.tagName.toLowerCase() == "td" && obj.cellIndex == 2)
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
                        
            clone.cells[2].click();
            clone.nextSibling.cells[2].click();
            
            //change last item to new mediator
            lastTr.cells[2].innerHTML = text;
            
            lastTr.cells[2].setAttribute("UserID", id);
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
                    nextRow.cells[2].click();
                
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
                var td2 = row.previousSibling.cells[2];
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
                var td2 = row.nextSibling.cells[2];
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
                
            }
            else if (idx == 1)
            {
                //find next
                var txt2 = txt.parentElement.parentElement.nextSibling.cells[0].firstChild;
                txt2.value=GetNextValue(txt.value);
            }
        }
    }
    
    var tblMediators = null;
    var lstMediators = null;
    var txtCriteria = null;
    function LoadControls()
    {
        tblMediators = document.getElementById("tblMediators");
        lstMediators = document.getElementById("<%=lstMediators.ClientID %>");
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


<table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
    <tr>
        <td style="color: #666666;" colspan="5">
            <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/rules/">Rules</a>&nbsp;>&nbsp;Negotiation: Auto Assignment</td>
    </tr>
    <tr id="trInfoBox" runat="server">
        <td colspan="5">
            <div class="iboxDiv">
                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img id="Img3" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td>
                            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="iboxHeaderCell">INFORMATION:</td>
                                    <td class="iboxCloseCell" valign="top" align="right"><!--<asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img4" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>--></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="iboxMessageCell">
                                        When clients are automatically assigned to negotiators, the following
                                        criteria are used to determine which negotiator each client should 
                                        be assigned to.  All clients whose last names begin with letters
                                        within a negotiator's start and end range (inclusive) will be assigned
                                        to that negotiator.  A negotiator may be given several ranges if desired,
                                        but all letters must be covered, and there may be no overlap.
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr runat="server" id="dvError" style="display:none;">
        <td valign="top" colspan="5">
            <div >
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		            <tr>
			            <td valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
			            <td runat="server" id="tdError"></td>
		            </tr>
	            </table>
	        </div>
        </td>
    </tr>
    <tr>
        <td>
            <div style="height:200px;width:250px;overflow:auto;border:solid 1px gray">
                <table id="tblMediators" onclick="SelectCell(this)" class="list" style="width:100%;font-family:tahoma;font-size:11px" cellspacing="0">
                    <colgroup>
                        <col width="30" align="center"/>
                        <col width="30" align="center"/>
                        <col align="left" style="padding-left:5px"/>
                    </colgroup>
                    <thead>
                        <tr style="height:18px">
                            <th>Start</th>
                            <th>End</th>
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
        <td >
            <table>
                <tr>
                    <td nowrap="true" ><a class="gridButton" href="javascript:Include();"><img id="Img9" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_selector_prev.png" /></a></td>
                    <td nowrap="true" ><a class="gridButton" href="javascript:Exclude();"><img id="Img10" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_selector_next.png" /></a></td>
                </tr>
            </table>
        </td>
        <td align="left">
            <asp:ListBox ID="lstMediators" runat="server" Width="200" Height="202" Font-Names="tahoma" Font-Size="11px"></asp:ListBox>
        </td>
        <td style="width:100%"></td>
    </tr>
</table>

    <input type="hidden" runat="server" id="txtCriteria" />
        <asp:linkbutton id="lnkCancel" runat="server"></asp:linkbutton>
   <asp:linkbutton id="lnkSave" runat="server"></asp:linkbutton>
   <asp:linkbutton id="lnkSaveAndClose" runat="server"></asp:linkbutton>
</asp:PlaceHolder></asp:Content>








