<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="HydraReps.aspx.vb" Inherits="Clients_Enrollment_HydraReps" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <!--#include file="mgrtoolbar.inc"-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin: 15px; width: 500px">
                <p>
                    *Double-check that the rep's email address is correct before assigning.
                    <br />
                    **Hold Ctrl to select multiple.</p>
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                Available Users</h2>
                        </td>
                        <td>
                        </td>
                        <td>
                            <h2>
                                Self Generated Internet Reps</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="lbAvailable" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_Available" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                        <td>
                            <asp:Button ID="btnAdd" runat="server" Text=">" />
                            <br />
                            <asp:Button ID="btnRemove" runat="server" Text="<" />
                        </td>
                        <td>
                            <asp:ListBox ID="lbHydra" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_Hydra" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:SqlDataSource ID="ds_Available" runat="server" SelectCommand="select firstname+' '+lastname+' ('+emailaddress+')'[name],userid from tbluser where locked = 0 and temporary = 0 and userid not in (select userid from tblhydrareps) order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="ds_Hydra" runat="server" SelectCommand="select firstname+' '+lastname+' ('+emailaddress+')'[name],u.userid from tbluser u join tblhydrareps h on h.userid = u.userid order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <div style="margin: 15px; width: 500px">
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                Available Users</h2>
                        </td>
                        <td>
                        </td>
                        <td>
                            <h2>
                                3rd Party Internet Reps</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="lbAvailableRGR" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_AvailableRGR" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                        <td>
                            <asp:Button ID="btnAddRGR" runat="server" Text=">" />
                            <br />
                            <asp:Button ID="btnRemoveRGR" runat="server" Text="<" />
                        </td>
                        <td>
                            <asp:ListBox ID="lbRGR" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_RGR" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:SqlDataSource ID="ds_AvailableRGR" runat="server" SelectCommand="select firstname+' '+lastname+' ('+emailaddress+')'[name],userid from tbluser where locked = 0 and temporary = 0 and userid not in (select userid from tblrgrreps) order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="ds_RGR" runat="server" SelectCommand="select firstname+' '+lastname+' ('+emailaddress+')'[name],u.userid from tbluser u join tblrgrreps r on r.userid = u.userid order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <div style="margin: 15px; width: 500px">
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                Available Users</h2>
                        </td>
                        <td>
                        </td>
                        <td>
                            <h2>
                                Supervisors</h2>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="3">
                            <asp:ListBox ID="lbAvailableSup" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_AvailableSup" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                        <td>
                            <asp:Button ID="btnAddSup" runat="server" Text=">" />
                            <br />
                            <asp:Button ID="btnRemoveSup" runat="server" Text="<" />
                        </td>
                        <td valign="top">
                            <asp:ListBox ID="lbSup" runat="server" SelectionMode="Single" Rows="8" CssClass="entry2"
                                DataSourceID="ds_Sup" DataTextField="name" DataValueField="userid" Width="300px" AutoPostBack="true"></asp:ListBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><h2 id="hTeam" runat="server">
                                Rep's Team</h2></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="btnAddToTeam" runat="server" Text=">" ToolTip="Add to team" />
                            <br />
                            <asp:Button ID="btnRemoveFromTeam" runat="server" Text="<" ToolTip="Remove from team" />
                        </td>
                        <td valign="top">
                            <asp:ListBox ID="lbTeam" runat="server" SelectionMode="Multiple" Rows="8" CssClass="entry2"
                                DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:SqlDataSource ID="ds_AvailableSup" runat="server" SelectCommand="select firstname+' '+lastname[name],userid from tbluser where locked = 0 and temporary = 0 and userid not in (select userid from tblsupreps union select repid from tblsupteam) order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="ds_Sup" runat="server" SelectCommand="select firstname+' '+lastname[name],u.userid from tbluser u join tblsupreps r on r.userid = u.userid order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <div style="margin: 15px; width: 500px">
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                Available Users</h2>
                        </td>
                        <td>
                        </td>
                        <td>
                            <h2>
                                Closers</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="lbAvailReps" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_AvailReps" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                        <td>
                            <asp:Button ID="btnAddCloser" runat="server" Text=">" />
                            <br />
                            <asp:Button ID="btnRemoveCloser" runat="server" Text="<" />
                        </td>
                        <td>
                            <asp:ListBox ID="lbClosers" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_Closers" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:SqlDataSource ID="ds_AvailReps" runat="server" SelectCommand="select firstname+' '+lastname[name],userid from tbluser where locked = 0 and temporary = 0 and usergroupid <> 25 order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="ds_Closers" runat="server" SelectCommand="select firstname+' '+lastname[name],userid from tbluser where usergroupid = 25 and locked = 0 order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <div style="margin: 15px; width: 500px">
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                Available Reps</h2>
                        </td>
                        <td>
                        </td>
                        <td>
                            <h2>
                                'Test' Reps</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="lbAvailTest" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_AvailTest" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                        <td>
                            <asp:Button ID="btnAddTest" runat="server" Text=">" />
                            <br />
                            <asp:Button ID="btnRemoveTest" runat="server" Text="<" />
                        </td>
                        <td>
                            <asp:ListBox ID="lbTest" runat="server" SelectionMode="Multiple" Rows="20" CssClass="entry2"
                                DataSourceID="ds_Test" DataTextField="name" DataValueField="userid" Width="300px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:SqlDataSource ID="ds_AvailTest" runat="server" SelectCommand="select firstname+' '+lastname[name],userid from tbluser where usergroupid in (1,24,25,26,29) and locked = 0 and temporary = 0 and userid not in (select userid from tbltestreps) order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="ds_Test" runat="server" SelectCommand="select firstname+' '+lastname[name],u.userid from tbluser u join tbltestreps r on r.userid = u.userid order by [name]"
                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
