<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Verification.ascx.vb"
    Inherits="CustomTools_UserControls_Verification" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<style type="text/css">
    .creditor-item
    {
        border-bottom: solid 1px #d3d3d3;
        white-space: nowrap;
        font-family: Tahoma;
        font-size: 11px;
        padding: 2;
    }
    .headItem
    {
        font-family: Tahoma;
        font-size: 11px;
        font-weight: normal;
        text-align: left;
        padding: 2;
    }
    .headItem2
    {
        font-family: Tahoma;
        font-size: 11px;
        font-weight: bold;
        text-align: left;
        background-color: #dcdcdc;
    }
</style>

<script language="javascript" type="text/javascript">
    function toggleDocument(docName, gridviewID, c, id) {
        var rowName = 'tr_' + docName;
        var gv = document.getElementById(gridviewID);
        var rows = gv.getElementsByTagName('tr');
        for (var row in rows) {
            var rowID = rows[row].id
            if (rowID != undefined) {
                if (rowID.indexOf(rowName + '_child') != -1) {
                    rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                }
                
                if (rowID == id) {
                    if (rows[row].cells[c].children[0] != undefined) {
                        var tree = rows[row].cells[c].children[0].src;
                        rows[row].cells[c].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                    }
                }    
            }
        }
    }
    
    function Unassign() {
        document.getElementById("<%=lnkUnassign.ClientID() %>").click();
    }
</script>

<div id="divVerification" runat="server" style="padding: 0 0 15 0">
    <asi:TabStrip runat="server" ID="tsVerification">
    </asi:TabStrip>
    <div id="tabNewClientIntake" runat="server" style="display: none">
        <div style="padding: 5 0 0 0; overflow: auto; height: 210px;">
            <asp:GridView ID="gvNewClientIntake" runat="server" AutoGenerateColumns="false" CellPadding="5"
                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                DataSourceID="ds_NewClientIntake" DataKeyNames="clientid">
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                            <img id="imgTree" runat="server" src="~/images/16x16_icon.png" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTree" runat="server" src="~/images/16x16_person.png" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Transferred" DataField="statuscreated" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="Account#" DataField="accountnumber" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Client" DataField="client" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="160px" />
                    <asp:TemplateField HeaderText="LPV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LPVImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="3PV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("VerImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="LSA" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LSAImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Language" DataField="language" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Attorney" DataField="company" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                </Columns>
                <EmptyDataTemplate>
                    <span class="entry2">There are no pending cases from the Client Intake department.</span>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
    <div id="tabMyClientIntake" runat="server" style="display: none">
        <div style="padding: 5 0 0 0; overflow: auto; height: 210px;">
            <asp:GridView ID="gvMyClientIntake" runat="server" AutoGenerateColumns="false" CellPadding="5"
                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                DataSourceID="ds_MyClientIntake" DataKeyNames="clientid">
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                            <img id="imgTree" runat="server" src="~/images/16x16_icon.png" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTree" runat="server" src="~/images/16x16_person.png" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Transferred" DataField="statuscreated" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="Account#" DataField="accountnumber" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Client" DataField="client" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="160px" />
                    <asp:TemplateField HeaderText="LPV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LPVImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="3PV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("VerImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="LSA" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LSAImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Language" DataField="language" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Attorney" DataField="company" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                </Columns>
                <EmptyDataTemplate>
                    <span class="entry2">You have no pending cases from the Client Intake department.</span>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
    <div id="tabAssignedClientIntake" runat="server" style="display: none">
        <div style="padding: 5 0 0 0; overflow: auto; height: 210px;">
            <asp:GridView ID="gvAssignedClientIntake" runat="server" AutoGenerateColumns="false"
                CellPadding="5" Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None"
                Visible="true" DataSourceID="ds_AssignedClientIntake" DataKeyNames="clientid,userid">
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                            <a href="javascript:Unassign();" title="Unassign selected clients">
                                <img runat="server" src="~/images/16x16_undo.png" border="0" /></a>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkUnassign" runat="server" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Transferred" DataField="statuscreated" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="Account#" DataField="accountnumber" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Client" DataField="client" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="160px" />
                    <asp:TemplateField HeaderText="LPV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LPVImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="3PV" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("VerImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="LSA" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="creditor-item"
                        ItemStyle-Width="30px">
                        <ItemTemplate>
                            <%#SetImg(Eval("LSAImg"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Language" DataField="language" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="65px" />
                    <asp:BoundField HeaderText="Attorney" DataField="company" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                    <asp:BoundField HeaderText="Assigned To" DataField="assignedto" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                    <asp:BoundField HeaderText="Days" DataField="daysassigned" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                </Columns>
                <EmptyDataTemplate>
                    <span class="entry2">There are no assigned CID clients.</span>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
    <div id="tabTransferHistory" runat="server" style="display: none">
        <div style="padding: 5 0 0 0; overflow: auto; height: 210px;">
            <asp:GridView ID="gvTransferHistory" runat="server" AutoGenerateColumns="false" CellPadding="5"
                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                DataSourceID="ds_TransferHistory">
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                            <img runat="server" src="~/images/16x16_icon.png" alt="" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeDate" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Transferred" DataField="transferred" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" DataFormatString="{0:d}" ItemStyle-Width="80px" />
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeCompany" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="" DataField="company" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="80px" />
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeRep" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="" DataField="rep" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="" DataField="client" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="210px" />
                    <asp:BoundField HeaderText="Clients" DataField="clients" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
    <div id="tabVerificationHistory" runat="server" style="display: none">
        <div style="padding: 5 0 0 0; overflow: auto; height: 210px;">
            <asp:GridView ID="gvVerificationHistory" runat="server" AutoGenerateColumns="false" CellPadding="5"
                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                DataSourceID="ds_VerificationHistory">
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                            <img id="Img1" runat="server" src="~/images/16x16_icon.png" alt="" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeDate" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Completed" DataField="completed" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" DataFormatString="{0:d}" ItemStyle-Width="80px" />
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeCompany" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="" DataField="company" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="80px" />
                    <asp:TemplateField ItemStyle-Width="16px">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="imgTreeRep" runat="server" src="~/images/tree_plus.bmp" alt="" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem" />
                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="" DataField="rep" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                    <asp:BoundField HeaderText="" DataField="client" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" ItemStyle-Width="210px" />
                    <asp:BoundField HeaderText="Clients" DataField="clients" ItemStyle-CssClass="creditor-item"
                        HeaderStyle-CssClass="headItem" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>
<asp:LinkButton ID="lnkUnassign" runat="server"></asp:LinkButton>
<asp:SqlDataSource ID="ds_NewClientIntake" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand="stp_GetTransferredClients">
</asp:SqlDataSource>
<asp:SqlDataSource ID="ds_MyClientIntake" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand="stp_GetTransferredClients">
    <SelectParameters>
        <asp:Parameter Name="UserID" DbType="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="ds_AssignedClientIntake" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand="stp_GetAssignedClients"></asp:SqlDataSource>
<asp:SqlDataSource ID="ds_TransferHistory" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand="stp_TransferHistory"></asp:SqlDataSource>
<asp:SqlDataSource ID="ds_VerificationHistory" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand="stp_VerificationHistory"></asp:SqlDataSource>

<script language="javascript" type="text/javascript">
    var vartabIndex=<%=tabIndex %>;
    if(vartabIndex == 4)
        document.getElementById("<%=tabVerificationHistory.ClientID%>").style.display="block";
    else if(vartabIndex == 3)
        document.getElementById("<%=tabTransferHistory.ClientID%>").style.display="block";
    else if(vartabIndex == 2)
        document.getElementById("<%=tabAssignedClientIntake.ClientID%>").style.display="block";    
    else if(vartabIndex == 0)
        document.getElementById("<%=tabNewClientIntake.ClientID%>").style.display="block";
</script>

