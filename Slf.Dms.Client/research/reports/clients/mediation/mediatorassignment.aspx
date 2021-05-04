<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mediatorassignment.aspx.vb" Inherits="mediatorassignment" %>
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
        <%=ClientScript.GetPostBackEventReference(lnkSubmit, Nothing) %>;
    }
    function Disable(o)
    {
        LoadControls();
    
        if (opEqualize.checked)
        {
            chkDontReassign.disabled=false;
            if (chkDontReassign.checked)
            {
                opSmallestFirst.disabled=false;
                opEvenly.disabled=false;
            }
            else
            {
                opSmallestFirst.disabled=true;
                opEvenly.disabled=true;
            }
        }
        else
        {
            chkDontReassign.disabled=true;
            opSmallestFirst.disabled=true;
            opEvenly.disabled=true;
        }
    }
    function GetAllControls(str)
    {
        var controls = new Array();
        if (str != null && str.length > 0)
        {
            var controlIDs = str.split(",");
            for (var i = 0; i < controlIDs.length; i++)
            {
                var o = document.getElementById(controlIDs[i]);
                controls.push(o);
            }
        }
        return controls;
    }
    function RefreshPlanned()
    {
        var parms = ""
        
        LoadControls();
        
        if (opEqualize.checked == true)
        {
            parms += "0,";
            parms += chkDontReassign.checked;
            if(chkDontReassign.checked==true)
            {
                if (opSmallestFirst.checked)
                    parms += ",0";
                else       
                    parms += ",1";
            }
        }
        else
            parms += "1";
            
        parms+="|";
            
        var tbPlanned = document.getElementById("tbPlanned");
        for (var i=0; i<tbPlanned.rows.length; i++)
        {
            var tr=tbPlanned.rows[i];
            if (i != 0)
                parms+=","
            parms+=tr.getAttribute("UserID");
            parms+=",";
            parms+=tr.cells[0].firstChild.checked;
            parms+=",";
            parms+=tr.cells[1].firstChild.checked;
        }
        
	    <%=ClientScript.GetCallbackEventReference(Me, "parms", "CallbackUpdate", "null", True) %>;
    }
    function CallbackUpdate(result, context)
    {
        var parts = result.split("|")
        
        for (var i = 0; i < parts.length; i+=3)
        {
            var UserID = parts[i];
            var Add = parseInt(parts[i+1]);
            var Remove = parseInt(parts[i+2]);
            var tr = GetUserRow(UserID);
            var Has = parseInt(tr.cells[3].innerHTML);
            var Final = Has+Add-Remove;
            
            tr.cells[5].innerHTML=Add;
            tr.cells[6].innerHTML=Remove;
            tr.cells[7].innerHTML=Final;
        }
        
        var tbPlanned = document.getElementById("tbPlanned");
        var trPlanned = document.getElementById("trPlanned");
        for (var i = 3; i<=7; i++)
        {
            if (i!=4)
            {
                var total = 0;
                for (var j=0; j<tbPlanned.rows.length; j++)
                {   
                    total+=parseInt(tbPlanned.rows[j].cells[i].innerHTML);
                }
                trPlanned.cells[i].innerHTML=total;
            }
        }
    }
    function GetUserRow(UserID)
    {
        var tbPlanned = document.getElementById("tbPlanned");
        for (var i=0; i<tbPlanned.rows.length; i++)
        {
            var tr=tbPlanned.rows[i];
            if(tr.getAttribute("UserID")==UserID)
            {
                return tr;
            }
        }
        
            
        return null;
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
    
    var opEqualize = null;
    var chkDontReassign = null;
    var opSmallestFirst = null;
    var opEvenly = null;
    var opIncrement = null;
    function LoadControls()
    {
        opEqualize = document.getElementById("<%=opEqualize.ClientID %>");
        chkDontReassign = document.getElementById("<%= chkDontReassign.ClientID%>");
        opSmallestFirst = document.getElementById("<%= opSmallestFirst.ClientID%>");
        opEvenly = document.getElementById("<%= opEvenly.ClientID%>");
        opIncrement = document.getElementById("<%= opIncrement.ClientID%>");
    }
    </script>
    <!--<style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
    </style>-->
</head>

    <body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;" onload="RefreshPlanned();" scroll="no">
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
                                                <a class="gridButton" href="#" onclick="RefreshPlanned()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Recalculate</a>
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
                        <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;table-layout:fixed">
                            <tr>
                                <td>
                                    <input type="radio" runat="server" id="opEqualize" name="opMethod" checked="True"
                                        onclick="Disable(this);" /><label for="<%=opEqualize.ClientID %>">Equalize</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 30px">
                                    <input type="checkbox" runat="server" id="chkDontReassign" onclick="Disable(this);" checked="true"/><label
                                        for="<%=chkDontReassign.ClientID %>">Don't reassign to make exact</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 60px">
                                    <input type="radio" runat="server" id="opSmallestFirst" name="opRessignMethod" checked="True" /><label
                                        for="<%=opSmallestFirst.ClientID %>">Assign to smallest first</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 60px">
                                    <input type="radio" runat="server" id="opEvenly" name="opRessignMethod" /><label
                                        for="<%=opEvenly.ClientID %>">Add evenly to all but largest</label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="radio" runat="server" id="opIncrement" name="opMethod" onclick="Disable(this);" /><label
                                        for="<%=opIncrement.ClientID %>">Increment</label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="height:100%">
                        <table class="list" style="width:100%;font-family:tahoma;font-size:11px" cellspacing="0">
                            <colgroup>
                                <col width="30" align="center"/>
                                <col width="30" align="center"/>
                                <col align="left"/>
                                <col align="center"/>
                                <col />
                                <col align="center"/>
                                <col align="center"/>
                                <col align="center"/>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="5" style="background-color:white"></th>
                                    <th colspan="3"style="background-color:rgb(240,240,240)">Planned Assignments</th>
                                </tr>
                                <tr>
                                    <th>A</th>
                                    <th>R</th>
                                    <th>Negotiator</th>
                                    <th>Has</th>
                                    <th></th>
                                    <th>Add</th>
                                    <th>Remove</th>
                                    <th>Final</th>
                                </tr>
                            </thead>
                            <tbody id="tbPlanned">
                                <asp:Literal ID="ltrPlannedGrid" runat="server"></asp:Literal>
                            </tbody>
                            <tfoot>
                                <tr id="trPlanned">
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </tfoot>
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
        </form>        
    </body>


</html>













