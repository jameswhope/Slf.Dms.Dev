<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="SchoolFormCampaigns.aspx.vb" Inherits="SchoolFormCampaigns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        
        //misc functions
        function refresh() { 
            <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
        }
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all").find(".portlet-header").addClass("ui-widget-header ui-corner-all").end().find(".portlet-content");
                LoadButtons();
                LoadDialogs();
            });
        }
      
        function doAjax(functionName, functionArrayArgs,doAsync, onSuccess, onError){
        
            var obj = null;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../service/cmService.asmx/" + functionName,
                data: functionArrayArgs,
                dataType: "json",
                async: doAsync,
                success: function (response) {
                    onSuccess(response);
                },
                error: function (response) {
                    onError(response.responseText);
                }
            });
            //return obj;
        }

    </script>
    <script type="text/javascript">
        function LoadButtons() {
            $(".jqButton").button();
            $(".jqAddButton").button({
                icons: {
                    primary: "ui-icon-plusthick"
                },
                text: true
            });
            $(".jqLoadButton").button({
                icons: {
                    primary: "ui-icon-transferthick-e-w"
                },
                text: true
            });
            $(".jqCancelButton").button({
                icons: {
                    primary: "ui-icon-closethick"
                },
                text: true
            });
            $(".jqTestButton").button({
                icons: {
                    primary: "ui-icon-lightbulb"
                },
                text: true
            });
            $(".jqDeleteButton").button({
                icons: {
                    primary: "ui-icon-trash"
                },
                text: true
            });
            $(".jqEditButton").button({
                icons: {
                    primary: "ui-icon-pencil"
                },
                text: false
            });
            $(".jqSaveButton").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: true
            });
            $(".jqViewButton").button({
                icons: {
                    primary: "ui-icon-folder-open"
                },
                text: true
            });
            $(".jqFirstButton").button({
                icons: {
                    primary: "ui-icon-seek-first"
                },
                text: false
            });
            $(".jqPrevButton").button({
                icons: {
                    primary: "ui-icon-seek-prev"
                },
                text: false
            });
            $(".jqNextButton").button({
                icons: {
                    primary: "ui-icon-seek-next"
                },
                text: false
            });
            $(".jqLastButton").button({
                icons: {
                    primary: "ui-icon-seek-end"
                },
                text: false
            });


        }
        function LoadDialogs() {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-campaign").dialog({
                autoOpen: false,
                modal: true,
                stack: true,
                height: 690,
                width: $(window).width() - 400,
                close: function () {
                    $(this).dialog('close');
                    refresh();
                }
            });
            $("#dialog-testcampaign").dialog({
                autoOpen: false,
                modal: true,
                height: 680,
                width: $(window).width() - 100,
                close: function () { }
            });
            $("#dialog-pop").dialog({
                autoOpen: false,
                modal: true,
                height: 680,
                width: 810
            });
        }
      
    </script>
    <script type="text/javascript">
        function showDialog(id) {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-campaign").html(loadingImg + '<iframe id="modalIframeCampaign" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open");
            $("#modalIframeCampaign").hide();
            $("#modalIframeCampaign").load(function () {
                $("#loadingDiv").hide();
                $("#modalIframeCampaign").show();
            });
            $("#modalIframeCampaign").attr("src", "../dialogs/schoolCampaignDialog.aspx?id=" + id);
            return false;
        }
        function ShowLeads(leadtype, schoolcampaignid) {
            var lt = String();
            lt = leadtype;

            $("#dialog-pop").dialog("option", "title", lt.toUpperCase());
            $("#dialog-pop").html(loadingImg + '<iframe id="modalIframeId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open");
            $("#modalIframeId").hide();
            $("#modalIframeId").load(function () {
                $("#loadingDiv").hide();
                $("#modalIframeId").show();
            });
            $("#modalIframeId").attr("src", "../dialogs/leadDataDialog.aspx?t=" + leadtype + "&scid=" + schoolcampaignid);
            return false;
        }
        function CloseDialog() {
            $("#dialog-campaign").dialog("close");
        }
    </script>
    <script type="text/javascript">
        //testing
        function TestCampaign() {
            $("#campaignform").html('');
            $("#dialog-testcampaign").dialog("open");
            return false;
        }

        function BuildCampaign() {
            $("#campaignform").html(loadingImg);
            var zc = $("#zipcodetest").val();
            var dArray = "{'zipcode': '" + zc + "'}";
            doAjax('BuildSchoolFormCampaign', dArray, true, function (result) {
                //success
                $("#campaignform").html(result.d);
                $("#formContainer").tabs();
            },
            function () {
                //error
                showStickyToast(result, 'showErrorToast')
                $("#campaignform").html('');
            });
            return false;
        }
  
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        School Campaigns
    </div>
    <br style="clear: both" />
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gvSchoolCampaigns" runat="server" AllowPaging="true" AllowSorting="True"
                        AutoGenerateColumns="False" DataKeyNames="SchoolCampaignID" DataSourceID="dsSchoolCampaigns"
                        Width="100%" PageSize="20" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                        BorderWidth="1px" CellPadding="1" ForeColor="Black" GridLines="Vertical">
                        <RowStyle VerticalAlign="Top" />
                        <AlternatingRowStyle BackColor="#F7F7DE" />
                        <HeaderStyle Height="30" />
                        <EmptyDataTemplate>
                            <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                No School Campaigns
                            </div>
                        </EmptyDataTemplate>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="School Campaign" SortExpression="Name">
                                <ItemTemplate>
                                    <asp:Image ID="imgSchoolCampaignActive" runat="server" ImageUrl="" />
                                    <asp:Label ID="lblSchoolCampaign" runat="server" Text='<%# eval("Name") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" Width="250px" />
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Number of Schools" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblNumForms" runat="server" Text=""></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="75" />
                                <ItemStyle HorizontalAlign="center" Width="75" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Leads Remaining" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblLeadsRemaining" runat="server" Text=""></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="75" />
                                <ItemStyle HorizontalAlign="center" Width="75" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="SchoolCampaignID" HeaderText="SchoolCampaignID" SortExpression="SchoolCampaignID"
                                Visible="false" />
                            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description"
                                Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="65" Wrap="false" />
                                <ItemStyle HorizontalAlign="center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Payout" HeaderText="Payout" SortExpression="Payout" DataFormatString="{0:C2}">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="right" Width="75" Wrap="false"/>
                                <ItemStyle HorizontalAlign="right" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Submitted" SortExpression="Submitted">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbSubmitted" runat="server" Text='<%# eval("Submitted") %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="95" Wrap="false"/>
                                <ItemStyle HorizontalAlign="center" Width="95" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Leads" SortExpression="Leads">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbLeads" runat="server" Text='<%# eval("Leads") %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="75" Wrap="false"/>
                                <ItemStyle HorizontalAlign="center" Width="75" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rejected" SortExpression="Rejected">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbRejected" runat="server" Text='<%# eval("Rejected") %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="90" Wrap="false"/>
                                <ItemStyle HorizontalAlign="center" Width="90" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Credited" SortExpression="Credited">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbCredited" runat="server" Text='<%# eval("Credited") %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="center" Width="90" Wrap="false"/>
                                <ItemStyle HorizontalAlign="center" Width="90" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="EstCommission" HeaderText="Est Comm" SortExpression="EstCommission"
                                DataFormatString="{0:c2}">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="right" Width="95" Wrap="false"/>
                                <ItemStyle HorizontalAlign="right" Width="95" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModifed" HeaderText="Last Modifed" SortExpression="LastModifed"
                                Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" Width="150" />
                                <ItemStyle HorizontalAlign="Left" Width="150" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModifedByName" HeaderText="Last Modifed By" SortExpression="LastModifedByName"
                                Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                        </Columns>
                        <PagerTemplate>
                            <div id="pager" style="background-color: #DCDCDC">
                                <table style="width: 100%">
                                    <tr>
                                        <td style="padding-left: 10px; text-align: center">
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
                                        <td align="right">
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsSchoolCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_schoolcampaign_view" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:Parameter Name="SchoolCampaignID" Type="Int32" DefaultValue="-1" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvSchoolCampaigns" EventName="PageIndexChanging" />
                </Triggers>
            </asp:UpdatePanel>
            <div style="margin: 10px; padding: 10px">
                <button class="jqAddButton" onclick="return showDialog(-1);" style="position: relative;
                    float: left;"  type="button">
                    Create School Campaign</button>
                <button class="jqTestButton" onclick="return TestCampaign();" style="position: relative;
                    float: left;" type="button">
                    Test School Campaign
                </button>
                <div style="position: relative; float: right; font-weight: bold;">
                    <asp:Label ID="lblTotal" runat="server" Text="" />
                </div>
            </div>
        </div>
    </div>
    <div id="dialog-campaign" title="School Campaign">
        <div id="loading"></div>
        ​
    </div>
    <div id="dialog-testcampaign" title="Test Form Capaign">
        <div id="divCampaign">
            <label for="zipcodetest">
                Enter Zipcode</label>
            <input type="text" id="zipcodetest" />
            <button class="jqButton" style="float: none!important; font-size: 9px;" onclick="return BuildCampaign();">
                Go</button>
            <hr style="clear: both;" />
            <div id="campaignform" />
        </div>
    </div>
    <div id="dialog-pop" title="Data" >
    
    </div>

</asp:Content>
