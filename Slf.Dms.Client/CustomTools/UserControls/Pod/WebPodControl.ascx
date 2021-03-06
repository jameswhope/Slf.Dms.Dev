<%@ Control Language="VB" AutoEventWireup="false" CodeFile="WebPodControl.ascx.vb"
    Inherits="CustomTools_UserControls_WebPodControl" %>
<style type="text/css">
    .headItem5
    {
        background-color: #DCDCDC;
        border-bottom: solid 1px #d3d3d3;
        font-weight: normal;
        color: Black;
        font-size: 11px;
        font-family: tahoma;
    }
    .headItem5 a
    {
        text-decoration: none;
        display: block;
        color: Black;
        font-weight: 200;
    }
    .listItem
    {
        cursor: pointer;
        border-bottom: solid 1px #d3d3d3;
    }
    .entry
    {
        font-family: tahoma;
        font-size: 11px;
        width: 100%;
    }
    .entry2
    {
        font-family: tahoma;
        font-size: 11px;
    }
</style>

<script type="text/javascript">
    function showFieldset(fldName) {
        var fld = document.getElementById(fldName);
        fld.style.display = 'inline-block'
        return false;
    }

    function hideFieldset(fldName) {
        var fld = document.getElementById(fldName);
        fld.style.display = 'none'
        return false;
    }
</script>

<asp:UpdatePanel ID="upPods" runat="server">
    <ContentTemplate>
        <div id="holder" style="padding: 10px;" class="entry">
            <table class="entry" border="0">
                <tr>
                    <td>
                        <div id="divMsg" runat="server" />
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="background-color: #C6DEF2; text-align: left; padding: 5px;">
                        <div class="entry">
                            <asp:LinkButton ID="lnkNewTeam" runat="server" Text="Create New Team" OnClientClick="return showFieldset('fldTeam');" />
                            <asp:LinkButton ID="lnkNewNegotiator" runat="server" Text=" | Create New Negotiator"
                                OnClientClick="return showFieldset('fldNeg');" />
                        </div>
                        <fieldset id="fldTeam" class="entry2" style="display: none; padding: 5px;">
                            <legend>Enter New Team Name:</legend>
                            <div class="entry" style="text-align: left">
                                <asp:TextBox ID="txtNewTeamName" runat="server" CssClass="entry2" Style="width: 250" />
                                <asp:LinkButton ID="lnkSaveTeam" runat="server" Text="Save" CssClass="lnk" />
                                <asp:Literal ID="litSpace" runat="server" Text=" | " />
                                <asp:LinkButton ID="lnkCancelTeam" runat="server" Text="Cancel" CssClass="lnk" OnClientClick="return hideFieldset('fldTeam');" />
                            </div>
                        </fieldset>
                        <fieldset id="fldNeg" class="entry2" style="display: none; padding: 5px;">
                            <legend>Enter New Negotiator Info:</legend>
                            <table class="entry2">
                                <tr>
                                    <td>
                                        Select User:<asp:DropDownList ID="ddlNewNegotiatorName" runat="server" CssClass="entry2"
                                            DataSourceID="dsNewNegotiatorName" DataTextField="Negotiator" DataValueField="UserID" />
                                        <asp:SqlDataSource ID="dsNewNegotiatorName" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="SELECT UserID, FirstName + ' ' + LastName AS Negotiator FROM tblUser WHERE (UserGroupID IN (4, 11, 19)) AND (Locked = 0) ORDER BY Negotiator">
                                        </asp:SqlDataSource>
                                    </td>
                                    <td>
                                        Select Team:
                                        <asp:DropDownList ID="ddlNewNegTeam" runat="server" CssClass="entry2" DataSourceID="dsNewNegTeam"
                                            DataTextField="name" DataValueField="NegotiationEntityID" />
                                        <asp:SqlDataSource ID="dsNewNegTeam" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="select NegotiationEntityID,name from tblnegotiationentity where type = 'group'">
                                        </asp:SqlDataSource>
                                    </td>
                                    <td>
                                        <div class="entry" style="text-align: right">
                                            <asp:LinkButton ID="lnkSaveNeg" runat="server" Text="Save" CssClass="lnk" />
                                            <asp:Literal ID="Literal1" runat="server" Text=" | " />
                                            <asp:LinkButton ID="lnkCancelNeg" runat="server" Text="Cancel" CssClass="lnk" OnClientClick="return hideFieldset('fldNeg');" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
                <tr valign="top">
                <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="entry2" />
                <asp:LinkButton ID="lnkSearch" runat="server" Text="Search" CssClass="lnk"/>
                <asp:Literal ID="litSpac" runat="server" Text=" | " />
                <asp:LinkButton ID="lnkResetSearch" runat="server" Text="Reset" CssClass="lnk" />
                
                </td>
                </tr>
                <tr valign="top">
                    <td>
                        <asp:GridView ID="gvNegotiators" runat="server" DataSourceID="dsNegotiators" AutoGenerateColumns="False"
                            PageSize="20" CssClass="entry" AllowPaging="True" AllowSorting="True" GridLines="None"
                            DataKeyNames="ParentNegotiationEntityID,NegotiationEntityID,IsSupervisor">
                            <Columns>
                                <asp:BoundField DataField="ParentNegotiationEntityID" HeaderText="ParentNegotiationEntityID"
                                    SortExpression="ParentNegotiationEntityID" Visible="False" />
                                <asp:TemplateField HeaderText="Actions" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                            Text="Edit" CommandArgument='<%# DataBinder.Eval(Container, "RowIndex")  %>'></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                            CommandArgument='<%# DataBinder.Eval(Container, "RowIndex")  %>' Text="Delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this negotiator?');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                            Text="Update" CommandArgument='<%# DataBinder.Eval(Container, "RowIndex")  %>' />
                                        &nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                            Text="Cancel" />
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" Width="75px" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" Width="75px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Team Name" SortExpression="ParentName">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("ParentName") %>' ToolTip="Double click row to edit quickly." />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlGroups" runat="server" DataSourceID="dsNegotiators" DataTextField="name"
                                            CssClass="entry" AppendDataBoundItems="true" DataValueField="NegotiationEntityID"
                                            SelectedValue='<%# Bind("ParentNegotiationEntityID") %>'>
                                            <asp:ListItem Text="" />
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="dsNegotiators" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="select NegotiationEntityID,name from tblnegotiationentity where type = 'group'">
                                        </asp:SqlDataSource>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="175px" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="175px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="NegotiationEntityID" HeaderText="NegotiationEntityID"
                                    InsertVisible="False" ReadOnly="True" SortExpression="NegotiationEntityID" Visible="False" />
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" ReadOnly="True">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:CheckBoxField DataField="IsSupervisor" HeaderText="Supervisor" SortExpression="IsSupervisor">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                </asp:CheckBoxField>
                                <asp:BoundField DataField="DMS Group" HeaderText="DMS Group" SortExpression="DMS Group"
                                    ReadOnly="True">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="175px" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="175px" />
                                </asp:BoundField>
                            </Columns>
                            <PagerTemplate>
                                <div id="pager" style="background-color: #DCDCDC">
                                    <table class="entry">
                                        <tr class="entry2">
                                            <td style="padding-left: 10px;">
                                                Page
                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
                                                of
                                                <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-right: 10px; text-align: right;">
                                                <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                    ID="btnFirst" />
                                                <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                    ID="btnPrevious" />
                                                -
                                                <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                    ID="btnNext" />
                                                <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                    ID="btnLast" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </PagerTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="dsNegotiators" ConnectionString="<%$ AppSettings:connectionstring %>"
                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="SELECT ng.NegotiationEntityID AS ParentNegotiationEntityID, ng.Name AS ParentName, ne.NegotiationEntityID, ne.Name, tblUserGroup.Name AS [DMS Group] , isnull(ne.IsSupervisor,0)[IsSupervisor] FROM tblNegotiationEntity AS ne left JOIN (SELECT NegotiationEntityID, Type, Name, ParentNegotiationEntityID, ParentType, UserID, ClientX, ClientY, Created, CreatedBy, LastModified, LastModifiedBy, Deleted, LastRefresh FROM tblNegotiationEntity WHERE (Type = 'group')) AS ng ON ne.ParentNegotiationEntityID = ng.NegotiationEntityID INNER JOIN tblUser ON ne.UserID = tblUser.UserID INNER JOIN tblUserGroup ON tblUser.UserGroupID = tblUserGroup.UserGroupId WHERE (ne.Type = 'Person') AND (ne.Name <> 'New Person') AND (ne.Deleted <> 1) ORDER BY ParentName, ne.Name"
                            UpdateCommand="update tblnegotiationentity set ParentNegotiationEntityID = @pID, IsSupervisor=@IsSupervisor where NegotiationEntityID= @userid"
                            DeleteCommand="update tblnegotiationentity set deleted = 1 where NegotiationEntityID= @userid">
                            <DeleteParameters>
                                <asp:Parameter Name="userid" />
                            </DeleteParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="pID" />
                                <asp:Parameter Name="userid" />
                                <asp:Parameter Name="IsSupervisor" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            <div id="divUpdatingPods" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>

<script type="text/javascript">

    function onUpdating() {
        // get the update progress div
        var updateProgressDiv = $get('divUpdatingPods');
        // make it visible
        updateProgressDiv.style.display = '';

        //  get the gridview element
        var gridView = $get('holder');

        // get the bounds of both the gridview and the progress div
        var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
        var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

        //    do the math to figure out where to position the element (the center of the gridview)
        var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
        var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

        //    set the progress element to this position
        Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
    }

    function onUpdated() {
        // get the update progress div
        var updateProgressDiv = $get('divUpdatingPods');
        // make it invisible
        updateProgressDiv.style.display = 'none';
    }
             
</script>

<ajaxToolkit:UpdatePanelAnimationExtender ID="upaePods" BehaviorID="podsanimation"
    runat="server" TargetControlID="upPods">
    <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                            
                        </Parallel> 
                    </OnUpdated>
    </Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
