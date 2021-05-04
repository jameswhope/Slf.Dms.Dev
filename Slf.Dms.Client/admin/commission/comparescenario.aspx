<%@ Page Title="" Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false"
    CodeFile="comparescenario.aspx.vb" Inherits="admin_commission_comparescenario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <script language="javascript">
        function RowHover(tbl, over) {
            var obj = event.srcElement;

            if (obj.tagName == "IMG")
                obj = obj.parentElement;

            if (obj.tagName == "TD") {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null) {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over) {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
    </script>
    <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
        border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <img runat="server" src="~/images/grid_top_left.png" border="0" />
            </td>
            <td style="width: 100%;">
                <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                    background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                    font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                    border="0">
                    <tr>
                        <td>
                            Scenario:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCommScen" runat="server" CssClass="entry2" DataSourceID="dsCommScen"
                                DataTextField="scenario" DataValueField="commscenid">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="dsCommScen" runat="server" SelectCommandType="Text" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                                SelectCommand="select s.commscenid,'(' + cast(s.commscenid as varchar(10)) + ') ' + '(' + cast(s.agencyid as varchar(10)) + ') ' + a.name + ' ' + convert(varchar(10),s.startdate,101) + '-' + convert(varchar(10),isnull(s.enddate,'1/1/2050'),101) + ' (' + convert(varchar(5),s.retentionfrom) + '-' + convert(varchar(5),s.retentionto) + ')' [scenario] from tblcommscen s join tblagency a on a.agencyid = s.agencyid order by s.agencyid, s.startdate, s.enddate, s.retentionfrom, s.retentionto">
                            </asp:SqlDataSource>
                        </td>
                        <td style="width: 15;">
                            &nbsp;
                        </td>
                        <td nowrap="true">
                            <asp:Button ID="btnCompare" runat="server" Text="Compare" CssClass="entry2" />
                        </td>
                        <td style="width: 100%;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div id="dScenarios" runat="server">
    </div>
</asp:Content>
