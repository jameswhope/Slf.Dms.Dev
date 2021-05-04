<%@ Page Language="VB" AutoEventWireup="false" CodeFile="side_comms.aspx.vb" Inherits="side_comms" ViewStateEncryptionMode="Never" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Import Namespace="System.Data" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Comms</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/ajax.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js")%>"></script>
    
    <script type="text/javascript">
    function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    function RedirectTop(s)
    {
        self.location=s;
    }
    function OpenNote(noteid)
    {
        var ddl = document.getElementById("<%=ddlOpenIn.ClientID %>");
        
        if (ddl.selectedIndex == 0)
        {
            document.getElementById("<%=txtNoteID.ClientId %>").value = noteid;
            <%=Page.ClientScript.GetPostBackEventReference(lnkOpenNote, Nothing) %>;
        }
        else
        {
            var location = "<%= ResolveUrl("~/clients/client/communication/note.aspx?id=" & DataClientID & "&nid=")%>" + noteid;
            self.location = location;
            //self.top.opener.location = location;
        }
    }
    function OpenLit(id, table, date, time, staff)
    {
        var ddl = document.getElementById("<%=ddlOpenIn.ClientID %>");
        var litstring = '?id=' + id + '&table=' + table + '&date=' + date + '&time=' + time + '&staff=' + staff;
        
        if (ddl.selectedIndex == 0)
        {
            document.getElementById("<%=txtLitString.ClientId %>").value = litstring;
            <%=Page.ClientScript.GetPostBackEventReference(lnkOpenLit, Nothing) %>;
        }
        else
        {
            var location = '<%= ResolveUrl("~/clients/client/communication/litcomm.aspx") %>' + litstring;
            self.location = location;
            //self.top.opener.location = location;
        }
    }
    function OpenPhoneCall(phonecallid)
    {
        var ddl = document.getElementById("<%=ddlOpenIn.ClientID %>");
        
        if (ddl.selectedIndex == 0)
        {
            document.getElementById("<%=txtPhoneCallID.ClientId %>").value = phonecallid;
            <%=Page.ClientScript.GetPostBackEventReference(lnkOpenPhoneCall, Nothing) %>;
        }
        else
        {
            var location = "<%= ResolveUrl("~/clients/client/communication/phonecall.aspx?id=" & DataClientID & "&pcid=")%>" + phonecallid;
            self.location = location;
            //self.top.opener.location = location;
        }
    }
    function ToggleAutoSync()
    {
        var a = document.getElementById("<%=lnkAutoSync.ClientID %>");
        var url = "<%=ResolveURL("~/util/setting.ashx") %>";
        var request = "s=Comms_AutoSync&v=" ;
        
        if (a.className == "gridButton")
        {
            a.className = "gridButtonSel";
            request += String(true);
        }
        else
        {
            a.className = "gridButton";
            request += String(false);
        }
        request += "&classname=<%=Me.GetType().Name %>&uid=<%=UserID %>";
        Ajax_String(url, request, true);
    }
    function SetOpenIn(sel)
    {
        var url = "<%=ResolveURL("~/util/setting.ashx") %>";
        var request = "s=Comms_OpenIn&v=" + sel.selectedIndex;
        request += "&classname=<%=Me.GetType().Name %>&uid=<%=UserID %>";
        Ajax_String(url, request, true);
    }
    </script>
    
    <style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
    </style>
</head>

    <body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;">
        <form id="form1" runat="server">        
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="background-color:rgb(244,242,232);" >
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td nowrap="true">
                                                 <asp:LinkButton ID="lnkAddNote" runat="server" class="gridButton">
                                                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_note_add.png" />
                                                    Add Note
                                                </asp:LinkButton>
                                            </td>
                                            <td nowrap="true">
                                                 <asp:LinkButton ID="lnkAddPhoneCall" runat="server" class="gridButton">
                                                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_phone_add.png" />
                                                    Add Call
                                                </asp:LinkButton>
                                            </td>
                                            <td nowrap="true" style="width:100%;height:25">&nbsp;</td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><a id="lnkAutoSync" runat="server" class="gridButton" href="javascript:ToggleAutoSync();">Auto Sync</a></td>
                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                <tr id="trInfoBox" runat="server" >
                    <td style="padding:5px">
                        <div class="iboxDiv">
                            <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width:16;"><img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                    <td>
                                        <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="iboxHeaderCell">Comms for <%=ClientName %></td>
                                            </tr>
                                            
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left:10px; padding-bottom:10px">
                        <asp:RadioButtonList ID="rblMode" runat="server" style="font-family:Tahoma;font-size:11px" RepeatLayout="flow" AutoPostBack="true">
                            <asp:ListItem Text="All Comms" Value="0" Selected="true"></asp:ListItem>
                            <asp:ListItem Text="Comms specific to " Value="1"></asp:ListItem>
                            <asp:ListItem Text="Comms specific to " Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                        <br />
                        <div style="padding-left:20px" id="dvEntityLable" runat="server">
                            <font style="font-weight:bold" id="dvEntityType" runat="server"></font>&nbsp;<span id="dvEntityName" runat="server"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 100%" valign="top" >
                        <div style="overflow:auto;height:100%">
                            <table style="font-family:tahoma;font-size:11px;width:100%;table-layout:fixed" class="list" onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)" cellpadding="0" cellspacing="0">
                                <colgroup>
                                    <col style="width:22;padding-left:5px"/>
                                    <col style="width:5px"/>
                                    <col />
                                    <col />
                                    <col style="padding-right:5px;width:60px" align="right"/>
                                </colgroup>
                                <thead>
                                    <tr style="height:20px">
                                        <th nowrap class="headItem" style="width:22;" align="center"><img id="Img3" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                        <th></th>
                                        <th onclick="Sort(this)" runat="server" id="tdCreatedBy" nowrap class="headItem" align="left" style="cursor:pointer">User</th>
                                        <th onclick="Sort(this)" runat="server" id="tdPerson" nowrap class="headItem" align="left" style="cursor:pointer">Person</th>
                                        <th onclick="Sort(this)" runat="server" id="tdDate" align="right" style="padding-right:5px;cursor:pointer">Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Literal ID="ltrGrid" runat="server"></asp:Literal>
                                    <asp:repeater id="rpNotes" runat="server" Visible="false">
                                        <itemtemplate>
                                            <a style="background-color:<%#CType(Container.DataItem, DataRow)("color")%>" href="javascript:OpenNote('<%#CType(Container.DataItem,DataRow)("PK")%>');">
                                                <tr style="color:<%#CType(Container.DataItem, DataRow)("textcolor")%>;padding-top:5px;padding-bottom:5px;background-color:<%#CType(Container.DataItem, DataRow)("color")%>">
                                                    <td class="noBorder" valign="top" ><img id="Img2" runat="server" border="0" src="~/images/16x16_note.png"/></td>
                                                    <td class="noBorder" >&nbsp;</td>
                                                    <td class="noBorder"><%#CType(Container.DataItem, DataRow)("By")%></td>
                                                    <td class="noBorder">&nbsp;</td>
                                                    <td class="noBorder"><%#LocalHelper.GetDateString(CType(Container.DataItem, DataRow)("StartTime"))%></td>
                                                </tr>
                                                <tr style="color:<%#CType(Container.DataItem, DataRow)("bodycolor")%>;background-color:<%#CType(Container.DataItem, DataRow)("color")%>">
		                                            <td colspan="2">&nbsp;</td>
		                                            <td colspan="3" align="left" >
                                                        <%#MakeSnippet(CType(Container.DataItem,DataRow)("Value"), 150)%>
                                                    </td>
                                                </tr>
                                            </a>
                                        </itemtemplate>
                                    </asp:repeater>
                                    <asp:repeater id="rpPhoneCalls" runat="server" visible="false">
                                        <itemtemplate>
                                            <a style="background-color:<%#Ctype(Container.DataItem,DataRow)("color")%>" href="javascript:OpenPhoneCall('<%#CType(Container.DataItem, DataRow)("PK")%>');" >
                                                <tr style="color:<%#CType(Container.DataItem, DataRow)("textcolor")%>;background-color:<%#CType(Container.DataItem,DataRow)("color")%>">
	                                                <td style="padding-top:5px" class="noBorder"><img src="<%#ResolveURL("~/images/16x16_call" + iif(ctype(container.dataitem,datarow)("direction")=true,"out","in") + ".png")%>" border="0"/></td>
	                                                <td class="noBorder"></td>
                                                    <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, DataRow)("by")%></td>
                                                    <td class="noBorder" nowrap="true"><%#CType(Container.DataItem, DataRow)("person")%></td>
                                                    <td class="noBorder" nowrap="true"><%#LocalHelper.GetDateString(CType(Container.DataItem, DataRow)("StartTime"))%></td>
		                                        </tr>
		                                        <tr style="color:<%#CType(Container.DataItem, DataRow)("bodycolor")%>;background-color:<%#CType(Container.DataItem, DataRow)("color")%>">
		                                            <td colspan="2">&nbsp;</td>
		                                            <td colspan="3" align="left" >
		                                                <b><%#MakeSnippet(CType(Container.DataItem, DataRow)("Subject"), 250)%>:</b>&nbsp;<%#MakeSnippet(CType(Container.DataItem, DataRow)("Value"), 150)%>
		                                            </td>
		                                        </tr>
                                            </a>
                                        </itemtemplate>
                                    </asp:repeater>
                                    <asp:repeater id="rpLitigation" runat="server" Visible="false">
                                        <itemtemplate>
                                            <a style="background-color:<%#CType(Container.DataItem, DataRow)("color")%>" href="javascript:OpenLit(<%#DataClientID %>, '<%#CType(Container.DataItem, DataRow)("CommTable") %>', '<%#CType(Container.DataItem, DataRow)("CommDate") %>', '<%#CType(Container.DataItem, DataRow)("CommTime") %>', '<%#CType(Container.DataItem, DataRow)("Staff") %>');">
                                                <tr style="color:<%#CType(Container.DataItem, DataRow)("textcolor")%>;padding-top:5px;padding-bottom:5px;background-color:<%#CType(Container.DataItem, DataRow)("color")%>">
                                                    <td class="noBorder" valign="top" ><img id="Img2" border="0" src="<%#GetImage(CType(Container.DataItem, DataRow)("LitType")) %>"/></td>
                                                    <td class="noBorder" >&nbsp;</td>
                                                    <td class="noBorder"><%#CType(Container.DataItem, DataRow)("By")%></td>
                                                    <td class="noBorder">&nbsp;</td>
                                                    <td class="noBorder"><%#LocalHelper.GetDateString(CType(Container.DataItem, DataRow)("StartTime"))%></td>
                                                </tr>
                                                <tr style="color:<%#CType(Container.DataItem, DataRow)("bodycolor")%>;background-color:<%#CType(Container.DataItem, DataRow)("color")%>">
		                                            <td colspan="2">&nbsp;</td>
		                                            <td colspan="3" align="left" >
                                                        <%#MakeSnippet(CType(Container.DataItem,DataRow)("Value"), 150)%>
                                                    </td>
                                                </tr>
                                            </a>
                                        </itemtemplate>
                                    </asp:repeater>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="background-color:rgb(244,242,232);" >
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width:100%;">
                                    <table class="grid" style="border-top:solid 1px rgb(200,200,200);height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="padding-left:5px;" nowrap="true">
                                                Open comms in:&nbsp;</td>
                                            <td style="width:100%">
                                                <asp:DropDownList ID="ddlOpenIn" runat="server" style="font-family:Tahoma;font-size:11px" onchange="SetOpenIn(this);">
                                                    <asp:ListItem Text="This window" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Main window" Value="1"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkResort" runat="server" />
            <asp:LinkButton ID="lnkOpenNote" runat="server" />
            <asp:LinkButton ID="lnkOpenPhoneCall" runat="server" />
            <asp:LinkButton ID="lnkOpenLit" runat="server" />
            
            <input type="hidden" id="txtNoteID" runat="server" />
            <input type="hidden" id="txtPhoneCallID" runat="server" />
            <input type="hidden" id="txtLitString" runat="server" />
            <input type="hidden" runat="server" id="txtSortField" />
        </form>
    </body>
</html>