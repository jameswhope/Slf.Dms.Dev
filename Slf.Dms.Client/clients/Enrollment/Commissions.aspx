<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Commissions.aspx.vb" Inherits="Clients_Enrollment_Commissions" Title="Comissions" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
        <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" alt="" />
            </td>
            <td style="height: 28px">
                <a id="A1" runat="server" class="menuButton" href="Default.aspx">
                    <img id="Img2" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_web_home.png" atl=" " />Enrollment</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;">
                <a id="A2" runat="server" class="menuButton" href="NewEnrollment.aspx">
                    <img id="Img3" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_person_add.png" />New Applicant</a>
            </td>
<%--            <td class="menuSeparator">
                |
            </td>
            <td style="height: 28px; white-space:nowrap;">
                <a id="A3" runat="server" class="menuButton">
                    <img id="Img4" runat="server" align="middle" border="0" class="menuButtonImage" src="~/images/16x16_Save.png" />Save Scenario</a>
            </td>--%>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../../FormMgr/FormMgr.css" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 175px; background-color: rgb(214,231,243); padding: 20px;" valign="top">
                        <div class="TaskBox">
                            <h6>
                                <span style="color:Gray; width: 152px;">Employee Group</span></h6>
                            <div class="box">
                                <asp:dropdownlist ID="ddlGroup" runat="server" CssClass="entry2" TabIndex="1">
                                    <asp:ListItem Text="--Select Employee Group--"></asp:ListItem>
                                    <asp:ListItem Text="All Groups"></asp:ListItem>
                                </asp:dropdownlist>
                            </div>
                        </div>
                        <br />
                        <div class="TaskBox">
                            <h6>
                                <span style="color:Gray">Employees</span></h6>
                            <div class="box">
                                <asp:DropDownList ID="ddlUsers" runat="server" CssClass="entry2" TabIndex="3" Width="155px">
                                    <asp:ListItem Text="--Select Employee--"></asp:ListItem>
                                    <asp:ListItem Text="All Employees"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <br />
                        <div class="TaskBox">
                            <h6>
                                <span style="color:Gray">Source</span></h6>
                            <div class="box">
                                <asp:DropDownList ID="ddlSource" runat="server" CssClass="entry2" AutoPostBack="true"
                                    TabIndex="6" Width="155px">
                                        <asp:ListItem Text="--Select Source--"></asp:ListItem>
                                        <asp:ListItem Text="--All Sources--"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <br />
                        <div class="TaskBox">
                            <h6>
                                <span style="color:Gray">Market</span></h6>
                            <div class="box">
                                <asp:DropDownList ID="ddlMarket" runat="server" CssClass="entry2" AutoPostBack="true"
                                    TabIndex="6" Width="155px">
                                        <asp:ListItem Text="--Select Market--"></asp:ListItem>
                                        <asp:ListItem Text="--All Markets--"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <br />
                        <div class="TaskBox">
                            <h6>
                                <span style="color:Gray">Commission Scenario</span></h6>
                            <div class="box">
                                <asp:dropdownlist ID="ddlScenario" runat="server" CssClass="entry2" TabIndex="7" AutoPostBack="true" Width="155px">
                                    <asp:ListItem Text="--Select Scenario--"></asp:ListItem>
                                    <asp:ListItem Text="--Add Scenario--"></asp:ListItem>
                                </asp:dropdownlist>
                            </div>
                        </div>
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <h2 id="hScenario" runat="server">
                                Commission Scenario(s)</h2>
                            <div class="box">
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            <asp:Label ID="lblScenario" runat="server" CssClass="entry2"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="5" CssClass="entry2" DataKeyNames="LeadPhoneListID"
                                                Width="100%">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Scenario(s)"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:dropdownlist ID="ddlScenarios" runat="server" CssClass="entry2" 
                                                                Width="100px"></asp:dropdownlist>
                                                         </ItemTemplate>
                                                     </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Source(s)"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:dropdownlist ID="ddlSources" runat="server" CssClass="entry2" 
                                                                Width="100px"></asp:dropdownlist>
                                                         </ItemTemplate>
                                                     </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Market(s)"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:dropdownlist ID="ddlMarkets" runat="server" CssClass="entry2" 
                                                                Width="100px"></asp:dropdownlist>
                                                         </ItemTemplate>
                                                     </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Group(s)"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:dropdownlist ID="ddlGroups" runat="server" CssClass="entry2" 
                                                                Width="100px"></asp:dropdownlist>
                                                         </ItemTemplate>
                                                     </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Employee(s)"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:dropdownlist ID="ddlEmployees" runat="server" CssClass="entry2" 
                                                                Width="100px"></asp:dropdownlist>
                                                         </ItemTemplate>
                                                     </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="%"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="ckPct" runat="server" CssClass="entry2" 
                                                                Width="15px"></asp:CheckBox>
                                                         </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="$" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="ckMoney" runat="server" 
                                                                CssClass="entry2" Width="15px"></asp:CheckBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Minimum" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtMinumum" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Maximum" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtMaximum" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:ButtonField ButtonType="Image" CommandName="Remove" ShowHeader="false" ImageUrl="~/images/16x16_delete.png" HeaderStyle-CssClass="headerbg" />
                                                </Columns>
                                            </asp:GridView>
                                    </tr>
                                    <tr>
                                            <td>
                                                <a id="lnkAddScenario" runat="server" class="lnk" href="javascript:AddBanks();">
                                                <img id="Img5" style="margin-right: 5;" src="~/images/16x16_trust.png" runat="server"
                                                border="0" align="middle" />Add Commission Scenario</a>
                                            </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
