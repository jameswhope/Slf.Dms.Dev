<%@ Page Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false" CodeFile="attorneys.aspx.vb" Inherits="admin_attorneys" title="DMP - Attorneys" EnableEventValidation="false"  %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

    <style>
        body
        {
            font-family: Tahoma, Arial;
            font-size: 12px;
        }
    </style>

    <script type="text/javascript" language="javascript">
        window.onload = function ()
        {
            document.getElementById('<%=hdnAttorney.ClientID %>').value = '';
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
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        
        function RowClick(tr, atty_id, rel_id, userid, first, middle, last, suffix)
        {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#f9f9f9";
            tr.style.backgroundColor = "#f4f4f4";
            
            document.getElementById('<%=hdnAttorney.ClientID %>').value = rel_id; //AttyPivotId(rel_id) is used to get Attorney data in pop
            document.getElementById('<%=hdnAttorneyID.ClientID %>').value = atty_id;
            document.getElementById('<%=hdnAttyUserID.ClientID %>').value = userid;
            document.getElementById('<%=hdnFirstName.ClientID %>').value = first;
            document.getElementById('<%=hdnMiddleName.ClientID %>').value = middle;
            document.getElementById('<%=hdnLastName.ClientID %>').value = last;
            document.getElementById('<%=hdnSuffix.ClientID %>').value = suffix;
            
            //set this as last
            tbl.lastSelTr = tr;
        }
        
        function SetSelectedValue(ddl, value)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].text == value)
                {
                    ddl[idx].selected = true;
                }
            }
        }
        
        function GetSelectedValue(ddl)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].selected == true)
                {
                    return ddl.options[idx].text;
                }
            }
            
            return '';
        }
        
        function IsSelected(ddl, value)
        {
            for (idx = 0; idx < ddl.options.length; idx++)
            {
                if (ddl.options[idx].value == value && ddl[idx].selected == true)
                {
                    return idx;
                }
            }
            
            return -1;
        }
        
        function AddAttorney()
        {
            var hdnAttorney = document.getElementById('<%=hdnAttorney.ClientID %>');
            
            if (document.getElementById('<%=ddlCompanyMain.ClientID %>').value != -1)
            {
                window.showModalDialog('<%=ResolveUrl("~/util/pop/attorney.aspx") %>?action=a&company=' + document.getElementById('<%=ddlCompanyMain.ClientID %>').value, window, 'dialogHeight:225px;dialogWidth:375px;');
            }
        }
        
        function EditAttorney()
        {
            var hdnAttorney = document.getElementById('<%=hdnAttorney.ClientID %>');
            
            if (HasValue(hdnAttorney))
            {
                window.showModalDialog('<%=ResolveUrl("~/util/pop/attorney.aspx") %>?id=' + hdnAttorney.value + '&company=' + document.getElementById('<%=ddlCompanyMain.ClientID %>').value, window, 'dialogHeight:225px;dialogWidth:375px;');
            }
        }
        
        function RemoveAttorney()
        {
            var hdnAttorney = document.getElementById('<%=hdnAttorney.ClientID %>');
            
            if (HasValue(hdnAttorney))
            {
                var name = document.getElementById('<%=hdnFirstName.ClientID %>').value + ' ' + 
                document.getElementById('<%=hdnMiddleName.ClientID %>').value + ' ' + document.getElementById('<%=hdnLastName.ClientID %>').value + ' ' + document.getElementById('<%=hdnSuffix.ClientID %>').value;
                
                showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx") %>?f=CallRemoveAttorney&t=Remove Attorney&m=Are you sure you want to remove " + name + " from the list of attorneys?", window, "status:off;help:off;dialogWidth:325px;dialogHeight:175px;");
            }
        }
        
        function CallRemoveAttorney()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRemove, Nothing) %>;
        }
        
        function HasValue(obj)
        {
            if (obj)
            {
                if (obj.value.length > 0)
                {
                    return true;
                }
            }
            
            return false;
        }
        
        function Dialog_AddAttorney(first, middle, last, suffix, companyid, relation, states, ckPrime)
        {
            document.getElementById('<%=hdnFirstName.ClientID %>').value = first;
            document.getElementById('<%=hdnMiddleName.ClientID %>').value = middle;
            document.getElementById('<%=hdnLastName.ClientID %>').value = last;
            document.getElementById('<%=hdnSuffix.ClientID %>').value = suffix;
            document.getElementById('<%=hdnCompanyID.ClientID %>').value = companyid;
            document.getElementById('<%=hdnRelations.ClientID %>').value = relation;
            document.getElementById('<%=hdnStates.ClientID %>').value = states;
            document.getElementById('<%=hdnPrimary.ClientID %>').value = ckPrime; 
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkAddAttorney, Nothing) %>;
        }
        
        function Dialog_UpdateAttorney(relationid, first, middle, last, suffix, companyid, relation, states, ckPrime)
        {
            document.getElementById('<%=hdnAttyRelationID.ClientID %>').value = relationid;
            document.getElementById('<%=hdnFirstName.ClientID %>').value = first;
            document.getElementById('<%=hdnMiddleName.ClientID %>').value = middle;
            document.getElementById('<%=hdnLastName.ClientID %>').value = last;
            document.getElementById('<%=hdnSuffix.ClientID %>').value = suffix;
            document.getElementById('<%=hdnCompanyID.ClientID %>').value = companyid;
            document.getElementById('<%=hdnRelations.ClientID %>').value = relation;
            document.getElementById('<%=hdnStates.ClientID %>').value = states;
            document.getElementById('<%=hdnPrimary.ClientID %>').value = ckPrime;
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkUpdateAttorney, Nothing) %>;
        }
        
        function ShowMessage(Value)
        {
            var dvError = document.getElementById("<%=dvError.ClientID %>");
            var tdError = document.getElementById("<%=tdError.ClientID %>");

            dvError.style.display = "inline";
            tdError.innerHTML = Value;
        }
    </script>
    
    <table style="width:100%;" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="2">
                <table style="color:#808080;width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <img id="Img3" runat="server" src="~/images/grid_top_left.png" border="0" />
                        </td>
                        <td style="width:100%;">
                            <table style="height:25;background-image:url(<%=ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;text-align:left;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="width:95px;text-align:left;">
                                        <a href="javascript:AddAttorney();" class="gridButton" visible="true" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_user_new.png" alt="" />&nbsp;Add Attorney</a>
                                    </td>
                                    <td style="width:8px;text-align:left;">|</td>
                                    <td style="width:95px;text-align:left;">
                                        <a href="javascript:EditAttorney();" class="gridButton" visible="true" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_prospect.png" alt="" />&nbsp;Edit Attorney</a>
                                    </td>
                                    <td style="width:125px;text-align:left;">
                                        <a href="javascript:RemoveAttorney();" class="gridButton" visible="true" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_personerror.png" alt="" />&nbsp;Remove Attorney</a>
                                    </td>
                                    <td style="width:50px;">&nbsp</td>
                                    <td style="width:125px;text-align:left;">
                                        <asp:DropDownList ID="ddlCompanyMain" Height="16px" Font-Size="10px" AutoPostBack="true" runat="server" />
                                    </td>
                                    <td style="width:auto;">&nbsp</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img4" runat="server" src="~/images/message.png" align="absmiddle" border="0" alt="" /></td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
            </td>
        </tr>
        <tr>
            <td style="width:100%;vertical-align:top;">
                <table class="list" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="3" style="border-right:1px solid #F0F0F0;width:100%;vertical-align:top;">
                    <thead>
                        <tr>
                            <th nowrap style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="middle" alt="" /></th>
                            <th nowrap align="left">Name</th>
                            <th nowrap align="left">States</th>
                            <th style="width:2%;">&nbsp</th>
                            <th nowrap align="left">Relation</th>
                            <th nowrap align="left">State Primary</th>
                            <th nowrap align="right">Company&nbsp;&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:repeater id="rptAttorneys" runat="server">
                            <itemtemplate>
                                <a onclick="javascript:RowClick(this.childNodes(0), <%#CType(Container.DataItem, Attorney).AttorneyID %>, <%#CType(Container.DataItem, Attorney).RelationID %>, <%#CType(Container.DataItem, Attorney).AttyUserID %>, '<%#CType(Container.DataItem, Attorney).FirstName %>', '<%#CType(Container.DataItem, Attorney).MiddleName %>', '<%#CType(Container.DataItem, Attorney).LastName %>', '<%#CType(Container.DataItem, Attorney).Suffix %>');"><tr>
                                    <td style="width:22" align="center">
                                        <img id="Img2" runat="server" src="~/images/12x12_person.png" border="0" alt="" />
                                    </td>
                                    <td nowrap align="left">
                                        <%#CType(Container.DataItem, Attorney).FirstName %> <%#CType(Container.DataItem, Attorney).MiddleName %> <%#CType(Container.DataItem, Attorney).LastName %> <%#CType(Container.DataItem, Attorney).Suffix %>
                                    </td>
                                    <td nowrap align="left">
                                        <%#CType(Container.DataItem, Attorney).States %>
                                    </td>
                                    <td style="width:2%;">
                                        &nbsp
                                    </td>
                                    <td nowrap align="left">
                                        <%#CType(Container.DataItem, Attorney).Relation %>
                                    </td>
                                   <td nowrap align="left">
                                       <%#CType(Container.DataItem, Attorney).StatePrimaryImg %>
                                   </td> 
                                    <td nowrap align="right">
                                        <%#CType(Container.DataItem, Attorney).Company %>&nbsp;&nbsp;
                                    </td>
                                </tr></a>
                            </itemtemplate>
                        </asp:repeater>
                    </tbody>
                </table>
            </td>
        </tr>
    </table>
    
    <asp:HiddenField ID="hdnAttorneyID" runat="server" />
    <asp:HiddenField ID="hdnAttyRelationID" runat="server" />
    <asp:HiddenField ID="hdnAttyUserID" runat="server" />
    <asp:HiddenField ID="hdnFirstName" runat="server" />
    <asp:HiddenField ID="hdnMiddleName" runat="server" />
    <asp:HiddenField ID="hdnLastName" runat="server" />
    <asp:HiddenField ID="hdnSuffix" runat="server" />
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnRelations" runat="server" />
    <asp:HiddenField ID="hdnStates" runat="server" />
    <asp:HiddenField ID="hdnAttorney" runat="server" />
    <asp:HiddenField ID="hdnPrimary" runat="server" /> 
    
    <asp:LinkButton ID="lnkRemove" runat="server" />
    <asp:LinkButton ID="lnkAddAttorney" runat="server" />
    <asp:LinkButton ID="lnkUpdateAttorney" runat="server" />
    <asp:LinkButton ID="lnkUpdatePrimary" runat="server" />
</asp:Content>