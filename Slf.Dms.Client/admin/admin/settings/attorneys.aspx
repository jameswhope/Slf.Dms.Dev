<%@ Page AutoEventWireup="false" CodeFile="attorneys.aspx.vb" EnableEventValidation="false"
    Inherits="admin_settings_attorneys" Language="VB" MasterPageFile="~/admin/settings/settings.master"
    Title="DMP - Attorneys" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <script type="text/javascript" language="javascript">
        function RowHover(tr, over)
        {
            if (tr.tagName == "TR")
            {
                var tbody = tr.parentElement;
                var tbl = tbody.parentElement;
                
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
                    tr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", tr);
                }
            }
        }
        
        function RowClick(atty_id)
        {           
            window.location.href = 'references/attyaddedit.aspx?id='+atty_id;
        }
        
        function Save()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
        
        function EditStatePrimaries()
        {
            var ddl = document.getElementById('<%=ddlCompanyMain.ClientID %>');
            var id = ddl.options[ddl.selectedIndex].value;
            
            window.location.href = 'stateprimaries.aspx?id='+id;
        }
        
        /*function CheckAll()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkCheckAll, Nothing) %>;
        }*/
        
        function CopyRelationships()
        {
            var wnd;
            var left=20;
            var top=20; 
            var width=350;
            var height=190;
            var ddl = document.getElementById('<%=ddlCompanyMain.ClientID %>');
            var id = ddl.options[ddl.selectedIndex].value

            if (screen) {
                left = (screen.width / 2) - (width / 2)
                top = (screen.height / 2) - (height / 2)
            }
            
            wnd=window.open("<%=ResolveUrl("~/util/pop/copyattyrel.aspx")%>?id="+id, '', 'width='+width+',height='+height+',scrollbars=no,resizable=no,status=no,left='+left+',top='+top);
            wnd.focus();
        }
        
        function CopyRelationships_Back(id)
        {
            document.getElementById('<%=hdnCompanyID.ClientID %>').value = id;
            <%=Page.ClientScript.GetPostBackEventReference(lnkReload, Nothing) %>;
        }
        
         function Create_Sample()
        {
        //7.17.09.ug.add sample letter function
            <%=Page.ClientScript.GetPostBackEventReference(lnkCreateSample, Nothing) %>;
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="15" style="font-family: tahoma; font-size: 11px;
                width: 100%;">
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" href="~/admin/default.aspx" style="color: #666666;">
                            Admin</a>&nbsp;>&nbsp; <a id="A4" runat="server" class="lnk" href="~/admin/settings/default.aspx"
                                style="color: #666666;">Settings</a>&nbsp;>&nbsp; <a id="A5" runat="server" class="lnk"
                                    href="~/admin/settings/references/default.aspx" style="color: #666666;">References</a>&nbsp;>&nbsp;
                        Attorneys
                    </td>
                    <td align="right">
                        Search: <asp:TextBox ID="txtSearch" runat="server" CssClass="entry2" MaxLength="30" Width="150"></asp:TextBox>
                        <asp:LinkButton ID="lnkSearch" runat="server">
                            <img id="Img6" runat="server" align="absmiddle" border="0" src="~/images/16x16_arrowright_clear.png"
                                style="padding-left: 5;" title="Search" /></asp:LinkButton>
                    </td>
                </tr>
                <tr id="trInfoBox" runat="server" visible="false">
                    <td style="padding: 5px" colspan="2">
                        <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                            <tr>
                                <td style="width: 16;" valign="top">
                                    <img id="Img4" runat="server" border="0" src="~/images/16x16_note3.png" /></td>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblInfoBox" runat="server"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100%; vertical-align: top;" colspan="2">
                        <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                            width: 100%;">
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                    <table border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                        width: 100%;">
                                        <tr>
                                            <td style="color: rgb(50,112,163);">
                                                Attorneys</td>
                                            <td align="right">
                                                Settlement Attorney:&nbsp;
                                                <asp:DropDownList ID="ddlCompanyMain" runat="server" AutoPostBack="true" Font-Size="10px"
                                                    Height="16px">
                                                </asp:DropDownList>&nbsp;&nbsp;|&nbsp;&nbsp; 
                                                <a class="lnk" href="references/attyaddedit.aspx">
                                                    <img id="Img1" runat="server" align="absmiddle" border="0" src="~/images/16x16_user_new.png" />
                                                    Add New Attorney</a>&nbsp;&nbsp;|&nbsp;&nbsp; <a class="lnk" href="javascript:CopyRelationships();">
                                                        <img runat="server" align="absmiddle" border="0" src="~/images/16x16_users.png" />
                                                        Copy Relationships</a>&nbsp;&nbsp;|&nbsp;&nbsp; <a class="lnk" href="javascript:EditStatePrimaries();">
                                                        <img id="Img3" runat="server" align="absmiddle" border="0" src="~/images/16x16_agent.png" />
                                                        State Primaries</a>&nbsp;&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table class="list" cellspacing="0" cellpadding="3" style="border-right: 1px solid #F0F0F0;
                            width: 100%; vertical-align: top;">
                            <thead>
                                <tr>
                                    <!--<th align="center" style="width: 22;">
                                        <img runat="server" src="~/images/11x11_checkall.png" border="0" align="middle" alt=""></th>-->
                                    <th style="width: 22;" align="center">
                                        <img runat="server" src="~/images/16x16_icon.png" border="0" align="middle" alt="" /></th>
                                    <th align="left" style="width: 20%">
                                        Name</th>
                                    <!--<th align="center" style="width: 15%">
                                        <span style="width: 20;">
                                            <img id="imgCheckAll" runat="server" alt="Check All" border="0" onclick="CheckAll();"
                                                src="~/images/11x11_checkall.png" style="cursor: pointer;" />
                                        </span>Associated<asp:LinkButton ID="lnkCheckAll" runat="server"></asp:LinkButton></th>-->
                                    <th align="left" style="width: 10%">
                                        Relation</th>
                                    <th style="width: auto">
                                        &nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptAttorneys" runat="server">
                                    <ItemTemplate>
                                        <tr onmouseout="RowHover(this, false)" onmouseover="RowHover(this, true)" onselectstart="return false;">
                                            <!--<td align="center">
                                                <input id="chkAttorney" type="checkbox" class="entry2" />-->
                                            </td>
                                            <td align="center" onclick="javascript:RowClick(<%#CType(Container.DataItem, Attorney).AttorneyID %>);">
                                                <img id="Img2" runat="server" alt="" border="0" src="~/images/12x12_person.png" title="<%#CType(Container.DataItem, Attorney).AttorneyID %>" />
                                            </td>
                                            <td align="left" nowrap="nowrap" onclick="javascript:RowClick(<%#CType(Container.DataItem, Attorney).AttorneyID %>);">
                                                <%#CType(Container.DataItem, Attorney).FullName%>
                                            </td>
                                            <!--<td align="center">
                                                <asp:CheckBox ID="chkAssociated" runat="server" Checked="<%#CType(Container.DataItem, Attorney).Associated %>"
                                                    Enabled="true" /></td>-->
                                            <td nowrap align="left">
                                                <asp:DropDownList ID="ddlRelation" runat="server" CssClass="entry" DataSource="<%# RelationTypes() %>"
                                                    DataTextField="Type" DataValueField="AttorneyTypeID" Width="100px">
                                                </asp:DropDownList>
                                            </td>
                                            <td onclick="javascript:RowClick(<%#CType(Container.DataItem, Attorney).AttorneyID %>);">
                                                <asp:HiddenField ID="hdnAttorneyID" runat="server" Value="<%#CType(Container.DataItem, Attorney).AttorneyID %>" />
                                                <asp:HiddenField ID="hdnRelation" runat="server" Value="<%#CType(Container.DataItem, Attorney).Relation %>" />
                                                &nbsp;</td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkSave" runat="server" />
            <asp:LinkButton ID="lnkCreateSample" runat="server" />
            <asp:LinkButton ID="lnkReload" runat="server" />
            <asp:HiddenField ID="hdnCompanyID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
