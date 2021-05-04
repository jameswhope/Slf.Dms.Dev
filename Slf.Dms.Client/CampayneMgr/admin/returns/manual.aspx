<%@ Page Title=" " Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    EnableEventValidation="false" CodeFile="manual.aspx.vb" Inherits="admin_returns" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .cssPager
        {
            background-color: #FFA12D;
        }
        .cssPager span
        {
            background-color: #4f6b72;
            font-size: 18px;
        }
    </style>
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $( ".portlet").addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .prepend("<span class='ui-icon ui-icon-minusthick'></span>")
				        .end()
			        .find(".portlet-content");

		        $(".portlet-header .ui-icon").click(function() {
			        $(this ).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
			        $(this).parents(".portlet:first").find(".portlet-content").toggle();
                     
		        });
               loadButtons();
               loadJQGridviewButtons();
                $("#<%= txtFrom.ClientID %>,#<%= txtTo.ClientID %>").datepicker({
			        showOn: "button",
			        buttonImage: '<%=resolveurl("../../images/16x16_calendar.png") %>',
			        buttonImageOnly: true
		        });

                $(".wide").css('width',$(window).width() - 370);
                $("#pageDiv").css('width',$(window).width() - 50);
                $("#gvManual").css('width',$(window).width() - 470);
                $(".column").disableSelection();

                $(window).bind('resize', function() { 
                    $(".wide").css('width',$(window).width() - 370);
                    $("#pageDiv").css('width',$(window).width() - 50);
                    $("#gvManual").css('width',$(window).width() - 470);
                 }).trigger('resize'); 
            });
        }
        function loadButtons(){
            $(".jqButton").button();
            $(".jqSearchButton")
                .button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: true
            });
            $(".jqUndoButton")
                .button({
                icons: {
                    primary: ".ui-icon-arrowreturnthick-1-w"
                },
                text: true
            });
        }
    function refresh() {
        <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
    }        
     function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtFrom.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtTo.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
    </script>
    <script type="text/javascript">


        function showTip(elem) {
            elem.children[1].style.display = "block";
        }
        function hideTip(elem) {
            elem.children[1].style.display = "none";
        }
        function checkAll(chk_SelectAll) {
            var frm = document.forms[0];
            var chkState = chk_SelectAll.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                    el.checked = chkState;
                }
            }
        }
        function showPrice(elem) {
            var bChecked = elem.checked;
            var tr = elem.parentNode.parentNode;
            var inps = tr.getElementsByTagName('input');
            var sps = tr.getElementsByTagName('span');
            var txt = null;
            var lbl = null;

            for (inFld in inps) {
                if (!!inps[inFld].id) {
                    var fldID = inps[inFld].id;
                    if (fldID.indexOf('txtPrice') > 0) {
                        txt = inps[inFld];
                    }
                }
            }
            for (inFld in sps) {
                if (!!sps[inFld].id) {
                    var fldID = sps[inFld].id;
                    if (fldID.indexOf('lblPrice') > 0) {
                        lbl = sps[inFld];
                    }
                }
            }

            if (bChecked == true) {
                txt.style.display = 'block';
                txt.value = '<%=resetValue %>';
                lbl.style.display = 'none';
            } else {
                txt.style.display = 'none';
                lbl.style.display = 'block';
                txt.value = lbl.value;
            }
        }
        function enablePrice(elem) {
            var txt = document.getElementById('<%= txtAllPrice.ClientID %>');
            if (elem.checked == true) {
                txt.disabled = false;
                txt.value = '0.00';
            } else {
                txt.disabled = true;
                txt.value = '';
            }
        }
        function CreateCSV() {

            var tst = $().toastmessage('showToast', {
                text: 'Generating file...<img src="../../images/loader3.gif" alt="Loading..."/>',
                sticky: true,
                type: 'notice'
            });

            var dArray = "{";
            dArray += "'buyerid': '" + $("#<%= ddlBuyer.ClientID %>").val() + "',";
            dArray += "'fromdate': '" + $("#<%= txtFrom.ClientID %>").val() + "',";
            dArray += "'todate': '" + $("#<%= txtTo.ClientID %>").val() + "',";
            dArray += "'searchtext': '" + $("#<%= txtFindLead.ClientID %>").val() + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "manual.aspx/CreateCSVForDownload",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('removeToast', tst);
                    $().toastmessage('showToast', {
                        text: response.d,
                        sticky: true,
                        type: 'success',
                        close: function () {
                            cleanDocs();
                        }
                    });
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
            return false;
        }

        function cleanDocs() {
            var tf = $(".downFile").attr('href');
            var dArray = "{";
            dArray += "'tempfile': '" + tf + "'";
            dArray += "}";
            $.ajax({
                type: "POST",
                url: "manual.aspx/DeleteTempFiles",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Admin > Returns > Manual
    </div>
    <br style="clear: both" />
    <asp:UpdatePanel ID="upReturns" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="portlet" id="pageDiv">
                <div class="portlet-header">
                    Returns
                </div>
                <div class="portlet-content">
                    <div style="position: relative; float: left; width: 275px;">
                        <div class="portlet">
                            <div class="portlet-header">
                                ::: Returns Criteria:
                            </div>
                            <div class="portlet-content">
                                <table style="width: 100%">
                                    <tr>
                                        <td align="right">
                                            Buyer:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuyer" runat="server" AppendDataBoundItems="True" DataSourceID="dsBuyers"
                                                DataTextField="Buyer" DataValueField="BuyerID" Width="150px" Font-Size="12px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Range:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlQuickPickDate" runat="server" Font-Size="12px" Width="150px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            From:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtFrom" runat="server" Font-Size="12px" Width="120px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            To:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtTo" runat="server" Font-Size="12px" Width="120px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="right">
                                            <hr />
                                            <asp:LinkButton CssClass="jqSearchButton" ID="lnkGetReturns" runat="server" Text="Get Leads"
                                                Style="float: right!important" />
                                            <asp:LinkButton CssClass="jqButton" ID="lnkExport" runat="server" Text="Export" Style="float: right!important"
                                                OnClientClick="return CreateCSV();" Enabled="false" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="portlet">
                            <div class="portlet-header">
                                ::: Return Lead(s) Reason:
                            </div>
                            <div class="portlet-content">
                                <table style="width: 100%">
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="ddlReturnReasons" runat="server" Font-Size="12px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <hr />
                                            <asp:LinkButton CssClass="jqButton" ID="lnkReturnLeads" runat="server" Text="Return"
                                                ToolTip="Set the Return status for the selected lead(s)." OnClientClick="return confirm('You are about to return the selected lead(s), Press [Ok] to Continue.');"
                                                Font-Size="10pt" Style="float: right!important" />
                                            <asp:LinkButton CssClass="jqButton" ID="lnkUndoReturn" runat="server" Text="Undo Return"
                                                ToolTip="Remove the return status from the selected lead(s)." Font-Size="10pt"
                                                Style="float: right!important" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="portlet">
                            <div class="portlet-header">
                                ::: Change Lead(s) Invoice Price:
                            </div>
                            <div class="portlet-content">
                                <table style="width: 100%">
                                    <tr>
                                        <td>
                                            <fieldset style="padding: 3px;">
                                                <legend>
                                                    <asp:CheckBox ID="chkAllPrice" runat="server" Text="Set Same Price For All?" onclick="enablePrice(this);" />
                                                    <img src="../../images/tooltip.gif" alt="Info" title="Checking this will enable the textbox and set all selected leads in the grid to the price entered in the textbox." />
                                                </legend>
                                                <asp:TextBox ID="txtAllPrice" runat="server" Width="98%" Enabled="false" />
                                                <ajaxtoolkit:FilteredTextBoxExtender ID="txtAllPrice_FilteredTextBoxExtender" runat="server"
                                                    Enabled="True" TargetControlID="txtAllPrice" ValidChars="0123456789.">
                                                </ajaxtoolkit:FilteredTextBoxExtender>
                                            </fieldset>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <hr />
                                            <asp:LinkButton CssClass="jqButton" ID="lnkFixPrice" runat="server" Text="Fix Price"
                                                OnClientClick="return confirm('You are about to change the invoice price for the selected lead(s), Press [Ok] to Continue.');"
                                                Font-Size="10pt" Style="float: right!important" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div style="position: relative; float: left; min-width: 50%;">
                        <div style="padding: 3px;" id="divGridHolder">
                            <div class="portlet">
                                <div class="portlet-header">
                                    <asp:Label ID="lblLeadsFound" runat="server" Text="::: Lead(s) Found" />
                                </div>
                                <div class="portlet-content">
                                    <div id="gridContainer">
                                        <div class="portlet" id="portlet_filter" runat="server" style="display: none;">
                                            <div class="portlet-header">
                                                ::: Filter Lead(s):
                                            </div>
                                            <div class="portlet-content">
                                                <table style="width: 100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td align="right">
                                                            <asp:TextBox ID="txtFindLead" runat="server" Width="99%" />
                                                        </td>
                                                        <td style="width: 200px">
                                                            <small>
                                                                <asp:LinkButton CssClass="jqSearchButton" ID="lnkFindLeads" runat="server" Text="Find Lead(s)"
                                                                    Font-Size="10pt" Style="float: right!important" />
                                                                <asp:LinkButton CssClass="jqButton" ID="lnkClearSearch" runat="server" Text="Reset"
                                                                    Font-Size="10pt" Style="float: right!important" />
                                                            </small>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        <asp:GridView ID="gvManualReturns" runat="server" DataSourceID="dsManualReturns"
                                            Width="100%" AllowPaging="true" AllowSorting="True" AutoGenerateColumns="False"
                                            DataKeyNames="SubmittedOfferID,BuyerID,leadid" PageSize="50" BorderStyle="None">
                                            <Columns>
                                                <asp:TemplateField>
                                                    <HeaderTemplate>
                                                        &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <input type="checkbox" runat="server" id="chk_select" onclick="showPrice(this);" />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" Width="25" />
                                                    <ItemStyle HorizontalAlign="Center" CssClass="ui-widget-content" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="SubmittedOfferID" HeaderText="SubmittedOfferID" InsertVisible="False"
                                                    ReadOnly="True" SortExpression="SubmittedOfferID" Visible="False" />
                                                <asp:BoundField DataField="FullName" HeaderText="FullName" SortExpression="FullName">
                                                    <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="left" />
                                                    <ItemStyle CssClass="ui-widget-content" HorizontalAlign="left" Wrap="false" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="email" HeaderText="email" SortExpression="email">
                                                    <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="left" Width="85" />
                                                    <ItemStyle CssClass="ui-widget-content" HorizontalAlign="left" Width="85" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone">
                                                    <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="85" />
                                                    <ItemStyle CssClass="ui-widget-content" HorizontalAlign="center" Width="85" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Submitted" HeaderText="Submitted" SortExpression="Submitted">
                                                    <HeaderStyle CssClass="ui-widget-header" Width="100" HorizontalAlign="center" />
                                                    <ItemStyle CssClass="ui-widget-content" Width="100" HorizontalAlign="center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Agent" HeaderText="Agent" SortExpression="Agent">
                                                    <HeaderStyle CssClass="ui-widget-header" Width="100" HorizontalAlign="left" />
                                                    <ItemStyle CssClass="ui-widget-content" Width="100" HorizontalAlign="left" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Price" SortExpression="InvoicePrice">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblPrice" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "InvoicePrice", "{0:c}")  %>' />
                                                        <asp:TextBox ID="txtPrice" runat="server" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem, "InvoicePrice", "{0:c}")  %>'
                                                            Style="display: none;" />
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Right" Width="75" />
                                                    <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Right" Width="75" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="ResultCode" HeaderText="ResultCode" SortExpression="ResultCode"
                                                    Visible="false">
                                                    <HeaderStyle CssClass="ui-widget-header" Width="150" HorizontalAlign="left" />
                                                    <ItemStyle CssClass="ui-widget-content" Width="150" HorizontalAlign="left" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="ResultDesc" HeaderText="ResultDesc" SortExpression="ResultDesc"
                                                    Visible="false">
                                                    <HeaderStyle CssClass="ui-widget-header" Width="150" HorizontalAlign="left" />
                                                    <ItemStyle CssClass="ui-widget-content" Width="150" HorizontalAlign="left" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Returned" HeaderText="Returned" SortExpression="Returned">
                                                    <HeaderStyle CssClass="ui-widget-header" Width="150" HorizontalAlign="center" />
                                                    <ItemStyle CssClass="ui-widget-content" Width="150" HorizontalAlign="center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="ReturnedReason" HeaderText="ReturnedReason" SortExpression="ReturnedReason">
                                                    <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="left" />
                                                    <ItemStyle CssClass="ui-widget-content" HorizontalAlign="left" />
                                                </asp:BoundField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div class="ui-widget">
                                                    <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
                                                        <p>
                                                            <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                                                            No Leads!</p>
                                                    </div>
                                                </div>
                                            </EmptyDataTemplate>
                                            <PagerTemplate>
                                                <div id="pager" style="background-color: #DCDCDC">
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="padding-left: 10px;">
                                                                <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                                    ID="btnFirst" CssClass="jqFirstButton" />
                                                                <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                                    ID="btnPrevious" CssClass="jqPrevButton" />
                                                                Page
                                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true" />
                                                                of
                                                                <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                                <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                                    ID="btnNext" CssClass="jqNextButton" />
                                                                <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                                    ID="btnLast" CssClass="jqLastButton" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </PagerTemplate>
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="dsManualReturns" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                            SelectCommand="stp_returns_getBuyerLeads" SelectCommandType="StoredProcedure"
                                            CancelSelectOnNullParameter="false">
                                            <SelectParameters>
                                                <asp:Parameter Name="buyerid" />
                                                <asp:Parameter Name="from" />
                                                <asp:Parameter Name="to" />
                                                <asp:Parameter Name="searchTerm" DefaultValue="" ConvertEmptyStringToNull="true" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <div id="updateDiv" style="display: none; height: 40px; width: 40px">
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader3.gif" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnFile" runat="server" />
    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
    <asp:SqlDataSource ID="dsBuyers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
        SelectCommand="SELECT distinct b.BuyerID, b.Buyer FROM tblBuyers b JOIN tblBuyerOfferXref x on x.BuyerID = b.BuyerID WHERE x.CallCenter = 1 and x.CallTransfer = 1 union SELECT -1, '--NONE--' ORDER BY Buyer">
    </asp:SqlDataSource>
    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('gridContainer');

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
            var updateProgressDiv = $get('updateDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>
    <ajaxtoolkit:UpdatePanelAnimationExtender ID="upaeReturns" BehaviorID="Returnsanimation"
        runat="server" TargetControlID="upReturns">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="gridContainer" Enabled="false" />
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="gridContainer" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxtoolkit:UpdatePanelAnimationExtender>
</asp:Content>
