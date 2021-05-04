<%@ Page Title=" " Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="validate.aspx.vb" Inherits="admin_returns" %>

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
        .column
        {
            width: 300px;
            float: left;
            padding-bottom: 10px;
        }
        .wide
        {
            width: 65%;
        }
        
        .ui-sortable-placeholder
        {
            border: 1px dotted black;
            visibility: visible !important;
            height: 50px !important;
        }
        .ui-sortable-placeholder *
        {
            visibility: hidden;
        }
    </style>
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqButton").button();
                $( ".column" ).sortable({
			        connectWith: ".column"
		        });
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

                $(".jqSaveButton")
                    .button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
                $(".wide").css('width',$(window).width() - 400);
                $("#<%= txtFrom.ClientID %>,#<%= txtTo.ClientID %>").datepicker({
			        showOn: "button",
			        buttonImage: '<%=resolveurl("../../images/16x16_calendar.png") %>',
			        buttonImageOnly: true
		        });
                
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
         function popup(data) {
            $("body").append('<form id="exportform" action="../../Handlers/CsvExport.ashx?f=returnvalidate" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvValidate']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Admin > Returns > Validate
    </div>
    <br style="clear:both" />
    <asp:UpdatePanel ID="upReturns" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    ::: Validate Returns
                </div>
                <div class="portlet-content">
                    <div class="column">
                        <div class="portlet">
                            <div class="portlet-header">
                                ::: Select Submitted Range</div>
                            <div class="portlet-content">
                                <table style="width: 100%">
                                    <tr>
                                    <td align="right">Range:</td>
                                        <td>
                                            <asp:DropDownList ID="ddlQuickPickDate" runat="server" Font-Size="12pt">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="right">From:</td>
                                        <td>
                                            <asp:TextBox ID="txtFrom" runat="server" Font-Size="12pt" />
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="right">To:</td>
                                        <td>
                                            <asp:TextBox ID="txtTo" runat="server" Font-Size="12pt" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td  align="right" colspan="2">
                                        <hr />

                                            <asp:LinkButton CssClass="jqButton" ID="lnkGetCounts" runat="server" Text="Load" style="float:right!important"
                                                Font-Size="10pt" />
                                                <asp:LinkButton CssClass="jqButton" ID="lnkExport" runat="server" Text="Export Excel" style="float:right!important"
                                                Font-Size="10pt" OnClientClick="ExportExcel();" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="wide column">
                        <div class="portlet">
                            <div class="portlet-header">
                                ::: Return(s)
                            </div>
                            <div class="portlet-content">
                                <div id="divGridHolder">
                                <asp:GridView ID="gvValidate" runat="server" DataSourceID="dsValidate" Width="100%"
                                    AllowSorting="True" AutoGenerateColumns="False" PageSize="20" CssClass="GridView" ShowFooter="true">
                                    <HeaderStyle Height="30" />
                                    <FooterStyle HorizontalAlign="Center" Font-Bold="true" Height="25"  />
                                    <EmptyDataTemplate>
                                        <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                            No Leads Found
                                        </div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="BuyerID" HeaderText="BuyerID" SortExpression="BuyerID"
                                            Visible="False"></asp:BoundField>
                                        <asp:BoundField DataField="Buyer" HeaderText="Buyer" SortExpression="Buyer">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                            <ItemStyle CssClass="ui-widget-content" />
                                            <FooterStyle BackColor="Transparent" BorderStyle="None" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AccountManager" HeaderText="Acct Mgr" SortExpression="AccountManager">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header"/>
                                            <ItemStyle CssClass="ui-widget-content" />
                                            <FooterStyle BackColor="Transparent" BorderStyle="None"/>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" Visible="true" DataFormatString="{0:c2}">
                                            <HeaderStyle HorizontalAlign="Right" CssClass="ui-widget-header"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" SortExpression="Revenue" Visible="true" DataFormatString="{0:c2}">
                                            <HeaderStyle HorizontalAlign="Right" CssClass="ui-widget-header"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="total" HeaderText="Total" SortExpression="total" Visible="true">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Right"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="valid" HeaderText="Valid" SortExpression="valid">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Right"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="returned" HeaderText="Returned" SortExpression="returned">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Right"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>
                                    <asp:BoundField DataField="PctValid" HeaderText="% Valid" ReadOnly="True" SortExpression="PctValid"
                                            DataFormatString="{0:p2}">
                                            <HeaderStyle HorizontalAlign="Right" CssClass="ui-widget-header"/>
                                            <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
                                            <FooterStyle HorizontalAlign="Right" BackColor="ControlDark" />
                                        </asp:BoundField>                                       
                                       
                                    </Columns>
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsValidate" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="stp_returns_getValidateCounts" SelectCommandType="StoredProcedure" >
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="txtFrom" Name="from" PropertyName="Text" />
                                        <asp:ControlParameter ControlID="txtTo" Name="to" PropertyName="Text" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div id="updateDiv" style="display: none; height: 40px; width: 40px">
                                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/Images/loader3.gif" />
                                </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
        </ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('divGridHolder');

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
                            <EnableAction AnimationTarget="returnTabs" Enabled="false" />
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="returnTabs" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxtoolkit:UpdatePanelAnimationExtender>
</asp:Content>
