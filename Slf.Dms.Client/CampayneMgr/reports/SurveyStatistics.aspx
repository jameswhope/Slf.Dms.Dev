<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="SurveyStatistics.aspx.vb" Inherits="admin_SurveyStatistics" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="../usercontrols/dateBarControl.ascx" TagName="dateBarControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
        //initial jquery stuff
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqButton").button();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			                .find(".portlet-header")
				                .addClass("ui-widget-header ui-corner-all")
				                .end()
			                .find(".portlet-content");
            });
        }
        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvSummary']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
            return false;
        }
        function popup(data) {
            $("body").append('<form id="exportform" action="../Handlers/CsvExport.ashx?f=SurveyStats" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="portlet">
        <div class="portlet-header">
            Survey Statistics
        </div>
        <div class="portlet-content">
            <asp:UpdatePanel ID="upData" runat="server">
                <ContentTemplate>
                    <div id="divForm">
                        <table style="width: 100%; padding: 10px 10px 0 0; vertical-align: middle; float: right;
                            display: block;" class="jqDateTbl">
                            <tr>
                                <td>
                                    <uc1:dateBarControl ID="dateBarControl1" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <asp:GridView ID="gvSummary" runat="server" AlternatingRowStyle-CssClass="altrow"
                            AllowPaging="false" Width="100%" ShowFooter="false" GridLines="Vertical" BorderStyle="None"
                            CellPadding="0" CellSpacing="0">
                            <EmptyDataTemplate>
                                No Data Loaded
                            </EmptyDataTemplate>
                            <AlternatingRowStyle CssClass="altrow"></AlternatingRowStyle>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="odsSummary" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="getQuestionCounts" TypeName="SurveyHelper+SurveyStatObject">
                            <SelectParameters>
                                <asp:Parameter Name="surveyID" Type="Int32" />
                                <asp:Parameter Name="fromDate" Type="String" />
                                <asp:Parameter Name="toDate" Type="String" />
                                <asp:Parameter Name="sortField" Type="String" />
                                <asp:Parameter Name="sortOrder" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:SqlDataSource ID="ds_Survey" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                            SelectCommand="stp_survey_getQuestionCount" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                
                                <asp:Parameter DbType="Int32" Name="surveyID" DefaultValue="-1" />
                                <asp:Parameter DbType="DateTime" Name="from" />
                                <asp:Parameter DbType="DateTime" Name="to" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="dsSurvey" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                            SelectCommand="select surveyid,description from tblsurvey union select -1,'ALL'">
                        </asp:SqlDataSource>
                        <div id="divProgress" style="display: none; height: 40px; width: 40px">
                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <script type="text/javascript">
        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('divProgress');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('divForm');

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
            var updateProgressDiv = $get('divProgress');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <asp:UpdatePanelAnimationExtender ID="upaeData" BehaviorID="dataanimation" runat="server"
        TargetControlID="upData">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="divForm" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="divForm" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </asp:UpdatePanelAnimationExtender>
</asp:Content>
