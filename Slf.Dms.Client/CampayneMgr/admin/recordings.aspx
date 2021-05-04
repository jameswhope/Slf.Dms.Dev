<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="recordings.aspx.vb" Inherits="admin_recordings" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $("#dialog:ui-dialog").dialog("destroy");
                $(".jqButton").button();
            });
        }

        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }

        function popup(data) {
            $("body").append('<form id="exportform" action="../Handlers/CsvExport.ashx?f=recordings" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                $("*[id$='gvLeads']").find('a').replaceWith(function(){return '=HYPERLINK("' + $(this).attr("href") + '")';});
                var csv_value = $("*[id$='gvLeads']").table2CSV({ delivery: 'value' });
                var regexp = new RegExp(/[“]/g);
                csv_value = csv_value.replace(regexp, "\"\"");
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float:left">
                <h2>Vici Recordings</h2>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" PopupButtonID="imgDate1" />&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="7"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" PopupButtonID="imgDate2" />&nbsp;&nbsp;
                            <asp:TextBox ID="txtTime1" runat="server" Size="7" MaxLength="8" Text="12:00 AM"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                ID="txtTime2" runat="server" Size="7" MaxLength="8" Text="11:59 PM"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="btnApply" runat="server" Text="Apply" Font-Size="8pt" CssClass="jqButton" />
                        </td>
                        <td>
                            <small>
                                <button id="btnExport" runat="server" class="jqButton" onclick="ExportExcel();">
                                    Export</button></small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet" style="min-height:400px">
                <div class="portlet-content">
                    <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="False" GridLines="None"
                        BorderStyle="None" RowStyle-CssClass="griditem2" AlternatingRowStyle-CssClass="griditem2 altrow" HeaderStyle-CssClass="headitem3" Width="100%"
                        ShowFooter="false" CellPadding="2">
                        <Columns>
                            <asp:BoundField HeaderText="Date" DataField="Date" />
                            <asp:BoundField HeaderText="Buyer" DataField="Buyer" /> 
                            <asp:BoundField HeaderText="Offer" DataField="Offer" />
                            <asp:BoundField HeaderText="Lead" DataField="Lead" />
                            <asp:BoundField HeaderText="Phone" DataField="Phone" />
                            <asp:BoundField HeaderText="Agent" DataField="Agent" />
                            <asp:TemplateField HeaderText="Rec. File">
                                <ItemTemplate><asp:HyperLink ImageUrl="~/images/speaker.gif" Target="_blank" NavigateUrl='<%# Eval("Rec File")%>' Visible='<%# iif(Eval("Rec File") is DBNull.value,"False","True") %>' runat="server"></asp:HyperLink></ItemTemplate>
                                <ItemStyle HorizontalAlign="Center"  />                             
                            </asp:TemplateField> 
                        </Columns> 
                        <EmptyDataTemplate>
                            <p>No live transfers available in this date/time range.</p>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
            <asp:PlaceHolder ID="phrJsRunner" runat="server"></asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>