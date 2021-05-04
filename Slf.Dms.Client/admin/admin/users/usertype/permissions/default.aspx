<%@ Page Language="VB" MasterPageFile="~/admin/users/usertype/usertype.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_usertype_permissions_default" title="DMP - Admin - User Types" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder runat="server" ID="pnlBody">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
function GetValue(chkY, chkN)
{
    if (chkY.checked)
        return "1";       
    else if (chkN.checked)
        return "0";
    else
        return "";
}
function BuildPermissionsToSave()
{
    var tblFunctions = document.getElementById("tblFunctions");
    var val="";
    
    for (var i = 2; i < tblFunctions.rows.length; i++)
    {
        var row = tblFunctions.rows(i);
        var canView = GetValue(row.cells(1).childNodes(0), row.cells(1).childNodes(1));
        var canAdd = GetValue(row.cells(2).childNodes(0), row.cells(2).childNodes(1));
        var canEditOwn = GetValue(row.cells(3).childNodes(0), row.cells(3).childNodes(1));
        var canEditAll = GetValue(row.cells(4).childNodes(0), row.cells(4).childNodes(1));
        var canDeleteOwn = GetValue(row.cells(5).childNodes(0), row.cells(5).childNodes(1));
        var canDeleteAll = GetValue(row.cells(6).childNodes(0), row.cells(6).childNodes(1));
        s = row.functionid + "," + canView + "," + canAdd + "," + canEditOwn + "," + canEditAll + "," + canDeleteOwn + "," + canDeleteAll;
        if (val.length > 0)
            val += "|";
        val += s;
    }
    
    document.getElementById("<%=txtPermissionsToSave.ClientId %>").value = val;
}
function Record_Save()
{
    BuildPermissionsToSave()
    // postback to save
    <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
}
function Record_SaveAndClose()
{
    BuildPermissionsToSave()
    // postback to save and close
    <%= ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
}
function Record_ClearPermissionsConfirm()
{
    window.dialogArguments = window;
    var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_ClearPermissions&t=Clear All Permissions&m=Are you sure you want to clear all permissions for this user?';
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Clear All Permissions",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 350, width: 400, scrollable: false}); 
}
function Record_ClearPermissions()
{
    <%=ClientScript.GetPostBackEventReference(lnkClearPermissions, Nothing)%>;
}
function chkDefinedOnly_Click()
{
    <%=ClientScript.GetPostBackEventReference(chkDefinedOnly, Nothing)%>;
}

//Click event for permission checks
function p_c(chk, action)
{
    if (action) //allow check
    {  
        if (chk.checked)
            chk.nextSibling.checked=false;
    }
    else //deny check
    {
        if (chk.checked)
            chk.previousSibling.checked=false;
    }
    
    if (chk.p == "own")
    {
        var chkAllY = chk.parentElement.nextSibling.childNodes(0);
        var chkAllN = chk.parentElement.nextSibling.childNodes(1);
 
        var chkY;var chkN;
        if (action){
            chkY = chk;
            chkN = chk.nextSibling;
        }else{
            chkN = chk;
            chkY = chk.previousSibling;
        }
        
        var denied = chkN.checked || (!chkY.checked && !chkN.checked);
        
        //at this point, we have the 2 checks in question
        if (denied)
        {   
            if (chkAllY.disabled == false)
            {
                chkAllY.disabled = true;
                chkAllY.checkedBefore=chkAllY.checked;
                chkAllY.checked = false;
            }
            if (chkAllN.disabled == false)
            {
                chkAllN.disabled = true;
                chkAllN.checkedBefore=chkAllN.checked;        
            }
            chkAllN.checked = chkN.checked;
        }
        else
        {
            if (chkAllY.disabled == true)
            {
                chkAllY.checked = chkAllY.checkedBefore;
                chkAllN.checked = chkAllN.checkedBefore;
                chkAllY.disabled = false;
                chkAllN.disabled = false;
            }
        }
    }
    
}
function ToggleChildren(img)
{
    
    var row = img.parentElement.parentElement;
    var qty = parseInt(row.numchildren);
    var tbl = row.parentElement;
    
    if (row.ChildrenLoaded == true)
    {
        
        if (qty > 0)
        {   
            var disp;
            if (tbl.rows(row.rowIndex + 1).style.display == "none")
            {
                img.src = img.src.replace("plus","minus");
                disp = true;
               
            }
            else
            {
                img.src = img.src.replace("minus","plus");
                disp = false;
            }
                
            // loop through the following qty children setting them to the desired display
            for (var i = row.rowIndex + 1; i < row.rowIndex + 1 + qty; i++)
            {
                if (tbl.rows.length > i)
                {
                    var r = tbl.rows(i);
                    
                    if (disp)
                    {  
                        //default to the lastDisplay for non-direct children if there is a lastDisplay
                        if (r.lastDisplay != null && !(r.parentRow == row))
                            r.style.display=r.lastDisplay;
                        else
                            r.style.display="block";
                    }
                    else
                    {                   
                        r.lastDisplay = r.style.display;
                        r.style.display="none";
                    }
                }
            }
        }
    }
    else
    {
        img.src = img.src.replace("plus","minus");
        
        var xml = new ActiveXObject("Microsoft.XMLDOM");
        xml.async = true;
        xml.onreadystatechange = function(){DisplayChildren(xml,row);};

        // send request
	    xml.load("<%= ResolveUrl("~/util/getchildfunctions_usertype.ashx?fid=") %>" + row.functionid + "&UserTypeId=<%=UserTypeId %>&definedonly=<%=chkDefinedOnly.Checked.ToString()%>");
    }
}
function nz(obj)
{
    if (isNaN(obj))
        return 0;
    return obj;
}
function DisplayChildren(xml, tr)
{

    if (xml.readyState == 4)
    {
        
        if (xml.childNodes.length == 2 && xml.childNodes[1].baseName == "functions")
        {
            var tbl = tr.parentElement;
            var functions = xml.childNodes[1];

            var count = functions.childNodes.length;

            var row = tr.parentRow;
            while (row != null)
            {
                row.numchildren = nz(parseInt(row.numchildren)) + count;
                row = row.parentRow;
            }
            
            for (var x = count-1; x >= 0 ; x--)
            {
                //the new row's function node
                var fnc = functions.childNodes[x];
        
                //get the properties
                var FunctionId = fnc.attributes.getNamedItem("FunctionId").value;
                var FunctionName = fnc.attributes.getNamedItem("FunctionName").value;
                var View = fnc.attributes.getNamedItem("View").value;
                var Add = fnc.attributes.getNamedItem("Add").value;
                var EditOwn = fnc.attributes.getNamedItem("EditOwn").value;
                var EditAll = fnc.attributes.getNamedItem("EditAll").value;
                var DeleteOwn = fnc.attributes.getNamedItem("DeleteOwn").value;
                var DeleteAll = fnc.attributes.getNamedItem("DeleteAll").value;
                var IsOperation = fnc.attributes.getNamedItem("IsOperation").value;
                var IsSystem = fnc.attributes.getNamedItem("IsSystem").value;
                var NumChildren = fnc.attributes.getNamedItem("NumChildren").value;

                //clone the parent row, and insert the new row after it
                var newTr = tr.cloneNode(true);
                tr.insertAdjacentElement("afterEnd", newTr);
                
                //set the new row's properties
                newTr.setAttribute("functionid", FunctionId);
                newTr.setAttribute("numchildren", NumChildren);
                newTr.parentRow = tr;
                
                //remove plus icon if new row has no children
                var img = newTr.cells(0).childNodes(0);
                if (NumChildren == "0")
                {
                    img.src = img.src.replace("tree_minus.bmp", "spacer.gif");
                    img.style.width="9";
                }
                //set it to a plus instead of minus icon
                else
                {
                    img.src = img.src.replace("minus", "plus");
                }
                
                //set the indention of the new row
                var padding = parseInt(tr.cells(0).style.paddingLeft);
                if (isNaN(padding))
                    padding=0;
                padding += 20;
                newTr.cells(0).style.paddingLeft = padding;
                
                
                //set the correct caption
                var html = newTr.cells(0).innerHTML;
                html = html.substring(0, html.lastIndexOf('>')+1);
                html = html + "&nbsp;" + FunctionName;
                newTr.cells(0).innerHTML = html;
                              
                //set the position of the checks                               
                SetChecks(newTr.cells(1),View);
                SetChecks(newTr.cells(2),Add);
                SetChecks(newTr.cells(3),EditOwn);
                SetChecks(newTr.cells(4),EditAll);
                SetChecks(newTr.cells(5),DeleteOwn);
                SetChecks(newTr.cells(6),DeleteAll);
                
                //set to red if is system
                if (IsSystem == "1")
                    newTr.style.color="red";
                else
                    newTr.style.color="black";
                
                //set the display of the checks
                if (IsOperation == "1")
                {
                    SetChecksDisplay(newTr.cells(2), "block");
                    SetChecksDisplay(newTr.cells(3), "block");
                    SetChecksDisplay(newTr.cells(4), "block");
                    SetChecksDisplay(newTr.cells(5), "block");
                    SetChecksDisplay(newTr.cells(6), "block");
                    SetChecksEnable(newTr.cells(3), newTr.cells(4));
                    SetChecksEnable(newTr.cells(5), newTr.cells(6));
                    //document.getElementById("<%=txtTest.ClientId %>").value=newTr.innerHTML;
                }
                else
                {
                    SetChecksDisplay(newTr.cells(2), "none");
                    SetChecksDisplay(newTr.cells(3), "none");
                    SetChecksDisplay(newTr.cells(4), "none");
                    SetChecksDisplay(newTr.cells(5), "none");
                    SetChecksDisplay(newTr.cells(6), "none");
                }
            }
            
            //set the parent tr as having children loaded
            tr.ChildrenLoaded = true;
        }
    }    
}
function SetChecksDisplay(td, display)
{
    td.childNodes(0).style.display=display;
    td.childNodes(1).style.display=display;
}

/*sets the checks in the parent cell td
to match the permission given*/
function SetChecks(td, permission)
{
    if (permission == "0")
    {
        td.childNodes(0).checked=false;
        td.childNodes(1).checked=true;
    }
    else if (permission == "1")
    {
        td.childNodes(0).checked=true;
        td.childNodes(1).checked=false;
    }
    else
    {
        td.childNodes(0).checked=false;
        td.childNodes(1).checked=false;
    }
}

/*Set the disabled property of the All checks
based on the position of the Own checks.
-If Own is true, All checks are enabled
-If Own is false, All checks are disabled, and default to false
-If Own is not set, All checks are disabled, and default to not checked
*/
function SetChecksEnable(tdOwn, tdAll)
{
    if (tdOwn.childNodes(0).checked==true) //own is true
    {
        //all is enabled
        tdAll.childNodes(0).disabled=false;
        tdAll.childNodes(1).disabled=false;
    }
    else if (tdOwn.childNodes(1).checked==true) //own is false
    {
        //all is false and disabled
        tdAll.childNodes(0).disabled=true;
        tdAll.childNodes(1).disabled=true;
        tdAll.childNodes(1).checked=true; 
    }
    else //own is unset
    {
        //all is unset and disabled
        tdAll.childNodes(0).disabled=true;
        tdAll.childNodes(1).disabled=true;
        tdAll.childNodes(0).checked=false; 
        tdAll.childNodes(1).checked=false; 
    }
}

</script>
<style>
.lia {border-bottom: solid 1px #d3d3d3}
.lib {border-bottom: solid 1px #d3d3d3;background-color:f6f6f6}
</style>
<table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="15" cellpadding="0" border="0">
    <tr>
        <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">User Types</a>&nbsp;>&nbsp;<a id="lnkUser" runat="server" style="color: #666666;" class="lnk"></a>&nbsp;>&nbsp;Permissions</td>
    </tr>
    <tr>
        <td>
            <div class="iboxDiv">
                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td>
                            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="iboxHeaderCell">INFORMATION:</td>
                                </tr>
                                <tr>
                                    <td class="iboxMessageCell">System-level permissions are shown in <font color="red">red</font>.  These should never be changed, except by a system administrator.</td>
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
            <table style="background-color:#f1f1f1;font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                <tr>
                    
                    <td nowrap>Permissions<!--<input type="checkbox" id="chkDefinedOnly" runat="server" name="chkDefinedOnly" onclick="chkDefinedOnly_Click();"/><label for="<%=chkDefinedOnly.ClientId %>"">Defined Only</label>--></td>
                    <td width="100%"></td>
                    <td nowrap align="right"><a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                </tr>
            </table>
            <table id="tblFunctions" onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" width="100%" border="0">
                <tr>
                    <td class="headItem" style="width:40%;height:20;padding-left:12" rowspan="2">
                        <table  style="font-size:11px;font-family:tahoma;" cellpadding="0">
                        <tr><td>
                        <img src="<%=ResolveUrl("~/images/16x16_icon.png") %>" />
                        </td><td>Function</td><td><img style="margin-left:5;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td></tr>
                        </table>
                    </td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;View&nbsp;</td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;Add&nbsp;</td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;Edit Own&nbsp;</td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;Edit All&nbsp;</td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;Delete Own&nbsp;</td>
                    <td class="headItem" align="center" nowrap="true" style="width:10%">&nbsp;Delete All&nbsp;</td>
                </tr>
                <tr>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                    <td class="headItem" align="center" nowrap="true"><img src="<%=ResolveUrl("~/images/16x16_check.png") %>" />&nbsp;&nbsp;<img src="<%=ResolveUrl("~/images/16x16_delete.png") %>" /></td>
                </tr>
                <asp:repeater id="rpPermissions" runat="server">
                    <itemtemplate>
                        <tr functionid="<%#DataBinder.Eval(Container.DataItem, "Id") %>" numchildren="<%#CType(Container.DataItem, GridPermission).Children.Count %>" <%#IIf(CType(Container.DataItem, GridPermission).IsSystem,"style=""color:red""","") %>>
                            <td class="lia" valign="middle" nowrap="true">
                                <img style="margin-bottom:2" src="<%#IIf(CType(Container.DataItem, GridPermission).Children.Count > 0, ResolveUrl("~/images/tree_plus.bmp") & """ onclick=""ToggleChildren(this);", ResolveUrl("~/images/spacer.png") & """ style=""width:9")%>" />
                                <img runat="server" src="~/images/16x16_properties.png" />
                                <%#DataBinder.Eval(Container.DataItem, "Name")%>
                            </td><td align="center" class="lib" nowrap="nowrap">
                                <input onclick="p_c(this,true)" type="checkbox" 
                                <%# GetBoolString(CType(Container.DataItem, GridPermission).View, "checked")%> 
                                /><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(CType(Container.DataItem, GridPermission).View, True, "checked")%> />
                            </td><td align="center" class="lia" nowrap="nowrap">
                                <input onclick="p_c(this,true)"  type="checkbox" 
                                <%# GetBoolString(CType(Container.DataItem, GridPermission).Add, "checked")%> 
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> 
                                /><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "Add"), True, "checked")%> 
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> />
                            </td><td align="center" class="lib" nowrap="true">
                                <input onclick="p_c(this,true)"  type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditOwn"), "checked")%> p="own" 
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> 
                                /><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditOwn"), True, "checked")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %>  p="own"/>
                             </td><td align="center" class="lia" nowrap="true">
                                <input onclick="p_c(this,true)"  type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditAll"), "checked")%> p="all" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditOwn"), True, True, "disabled")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> 
                                /><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditAll"), True, "checked")%> p="all" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "EditOwn"), True, True, "disabled")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> />
                            </td><td align="center" class="lib" nowrap="true">
                                <input onclick="p_c(this,true)"  type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteOwn"), "checked")%> 
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> 
                                p="own"/><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteOwn"), True, "checked")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %>  p="own"/>
                            </td><td align="center" class="lia" nowrap="true">
                                <input onclick="p_c(this,true)"  type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteAll"), "checked")%> p="all" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteOwn"), True, True, "disabled")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> 
                                /><input onclick="p_c(this,false)" type="checkbox" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteAll"), True, "checked")%> p="all" 
                                <%# GetBoolString(DataBinder.Eval(Container.DataItem, "DeleteOwn"), True, True, "disabled")%>
                                <%#IIf(Not CType(Container.DataItem, GridPermission).IsOperation,"style=""display:none""","") %> />
                            </td>
                        </tr>
                    </itemtemplate>
                </asp:repeater>
            </table>
            <asp:panel runat="server" id="pnlNone" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">This user type has no defined permissions</asp:panel>
            <br />
            <!--<textarea type="text" runat="server" id="txtTest" style="width:600;height:200" ></textarea>-->
        </td>
    </tr>
</table>
<asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkSaveAndClose"></asp:LinkButton>
<asp:LinkButton runat="server" ID="lnkClearPermissions"></asp:LinkButton>
<input type="hidden" runat="server" id="txtPermissionsToSave" />
</asp:PlaceHolder></asp:Content>