<%@ Page Language="VB" MasterPageFile="~/research/queries/financial/accounting/accounting.master" AutoEventWireup="false" CodeFile="disbursementaccount1.aspx.vb" Inherits="research_queries_financial_accounting_disbursementaccount1" title="DMP - Research" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">

    function printReport() {
        window.print();
    }

    function ValidateParams() {
        var date1 = document.getElementById('<%=txtBeginDate.ClientId %>');
        var date2 = document.getElementById('<%=txtEndDate.ClientId %>');
        if (date1.value.length != 0 && !IsValidDate(date1.value)) {
            alert("Invalid Start Date. Please, enter day formatted as mm/dd/yyyy");
            date1.focus();
            return false;
        }
        if (date2.value.length != 0 && !IsValidDate(date2.value)) {
            alert("Invalid End Date. Pease, enter day formatted as mm/dd/yyyy");
            date2.focus();
            return false;
        }
        return true;
    }

    function IsValidDate(Date) {
        return RegexValidate(Date, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$");
    }

    function RegexValidate(Value, Pattern) {
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0) {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else {
            return false;
        }
    }
</script>
<style>
    thead th{position:relative; top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);}
    td.l{padding-left:8;border-left:solid 1px silver;border-right:none}
    td.lr{padding-right:8;}
    td.r{padding-right:8;border-right:solid 1px silver;border-left:none}
    table tfoot tr td{background-color:white}
</style>
<ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
</ajaxToolkit:ToolkitScriptManager>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
        <div style="overflow:auto">
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                        <td nowrap="true" valign="center">
                                            Start Date:
                                            <asp:TextBox ID="txtBeginDate" runat="server" Width="70px" Height="18px" Style="font-size: 11px;
                                                font-family: tahoma;"></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtenderBegin" runat="server" TargetControlID="txtBeginDate">
                                            </ajaxToolkit:CalendarExtender>
                                        </td>
                                        <td nowrap="true" style="width: 5;">
                                            &nbsp;
                                        </td>
                                        <td nowrap="true" valign="center">
                                            End Date:
                                            <asp:TextBox ID="txtEndDate" runat="server" Width="70px" Height="18px" Style="font-size: 11px;
                                                font-family: tahoma;"></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtenderEnd" runat="server" TargetControlID="txtEndDate" >
                                            </ajaxToolkit:CalendarExtender>
                                        </td>
                                        <td nowrap="true" style="width: 5;">
                                            &nbsp;
                                        </td>
                                        <td nowrap="true">
                                            <img id="Img2" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                        </td>
                                        <td nowrap="true">
                                            <asp:LinkButton ID="lnkRequery" runat="server" class="gridButton" OnClientClick="return ValidateParams();" >
                                                <img id="Img3" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                    src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                        </td>
                                        <td nowrap="true">
                                            <img id="Img5" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                                <img id="Img1" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                    src="~/images/icons/xls.png" />&nbsp;Export</asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width: 100%;">
                                            &nbsp;
                                        </td>
                                        <td nowrap="true">
                                            <a id="A1" runat="server" class="gridButton" href="javascript:printReport()">
                                                <img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                    src="~/images/16x16_print.png" /></a>
                                        </td>
                                        <td nowrap="true" style="width: 10;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td style="padding-left: 10px; font-size: 12px; height: 30px;"><b>Disbursement Account Transfers</b></td></tr>
                <asi:QueryGrid2 ID="grdResults" runat="server" XmlSchemaFile="~/querygrids.xml"></asi:QueryGrid2>
            </table>
            </div>
        </td>
    </tr>
</table>
</body>

</asp:PlaceHolder></asp:Content>