<%@ Page ValidateRequest="false" Language="VB" AutoEventWireup="false" CodeFile="addclientrelation.aspx.vb" Inherits="util_pop_addclientrelation" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Relation</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
    </style>
    <script type="text/javascript">
        function RowClick(tr, Id, str)
        {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#f5f5f5";
            tr.style.backgroundColor = "f5f5f5";
            
            //navigate to correct CommBatchId
            //document.getElementById("<%=txtRelationID.ClientID %>").value=Id;
            window.returnValue = Id + "$" + document.getElementById("<%=ddlRelationType.ClientID %>").value + "$" + document.getElementById("<%=ddlRelationType.ClientID %>").options[document.getElementById("<%=ddlRelationType.ClientID %>").selectedIndex].text + "$" + str;
            self.close();
            
            //set this as last
            //tbl.lastSelTr = tr;
        }
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f3f3f3";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
    </script>
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 15 15;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%">
                        <tr>
                            <td>Relate To:</td>
                            <td ><asp:DropDownList runat="server" ID="ddlRelationType" style="font-family:Tahoma;font-size:11" AutoPostBack="true"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td colspan="3" valign="top" style="width:100%;height:100%" >
                                <div style="width:100%;height:100%;overflow:auto;padding: 0 0 0 0">
                                    <table class="list" onmouseover="RowHover(this,true)" onmouseout="RowHover(this,false)" 
                                        style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0">
                                        <thead>
                                            <tr>
									            <asp:literal runat="server" id="ltrHeaders"></asp:literal>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:literal runat="server" id="ltrGrid"></asp:literal>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();">
                                    <img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />
                                    Cancel and Close
                                </a>
                            </td>
                            <td align="right">
                                <asp:linkbutton runat="server" id="lnkAction" tabindex="2" style="color:black" cssclass="lnk">
                                    Add Relation 
                                    <img style="margin-left:6px;" src="<%=ResolveUrl("~/images/16x16_forward.png")%>" border="0" align="absmiddle" />
                                </asp:linkbutton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <input type="hidden" id="txtRelationID" runat="server" />
    </form>
</body>
</html>