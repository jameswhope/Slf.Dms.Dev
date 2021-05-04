<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="websites.aspx.vb" Inherits="admin_websites" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ckoptions = { langCode: 'en', skin: 'office2003',
            width: 450,
            height: 300,
            toolbar:
						 [
							 ['Source', '-', 'Bold', 'Italic', 'Underline','-' ,'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock','-','Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat'],
							 ['Font', 'FontSize','Format','NumberedList', 'BulletedList','-', 'TextColor']
						 ]
        };
        function refresh() { 
            <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
        }
        function pageLoad() {
            docReady();
        }
        function pullpath(webpathid) {
                var dArray = "{";
                    dArray += "'webpathid': '" + webpathid + "'";
                    dArray += "}";
                    $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/LoadWebPages",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $('#pageSort').html(response.d);
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                
                });           
        }
        function submitPath() {
            var stringDiv = "";
                $(".sortable").children().each(function(i) {
                    var li = $(this).children(1);
                    stringDiv += li.attr("id") + "," + li.attr("checked") + "&";
                });
                stringDiv = stringDiv.substring(0, stringDiv.length - 1);
                var dArray = "{";
                dArray += "'sortedList': '" + stringDiv + "'";
                dArray += "}";
                 $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/UpdatePath",
                    data:  dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                });
        }

        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all").find(".portlet-header").addClass("ui-widget-header ui-corner-all").end().find(".portlet-content");
                $('.editor').ckeditor(ckoptions);
                loadButtons();
                LoadTabs()
                loadWidgets();
                loadDialog();


            });
        }
        function loadDialog(){
            $("#dialog-website").dialog({
                autoOpen: false,
                height: 600,
                width: 750,
                modal: true,
                position: [300, 50],
                stack: true,
                buttons: {
                    "Mark as Deleted": function() {
                        DeleteWebsite();
				    },
				    "Save Website": function() {
                        SaveWebsite();
				    },
				    "Close": function() {
					    $( this ).dialog( "close" );
				    }
			    },
                close: function() {
                    refresh();
                }
            });
            $("#dialog-website").bind( "dialogopen", function(event, ui) {
                    $("#webload").html(loadingImg);
                    $("#webload").show();
                    $("#webtab").hide();

                    var wid = $("#dialog-website").data('websiteid');
                    if (wid == -1){
                        $("#webload").html('');
                        $("#webload").hide();
                        $("#webtab").show();
                        $("#<%=txtName.ClientID %>").val('');
                        $("#<%=txtDescription.ClientID %>").val('');
                        $("#<%=txtUrl.ClientID %>").val('');
                        $("#<%=ddlType.ClientID %>").val(-1);
                        $("#<%=ddlSurvey.ClientID %>").val(-1);
                        $("#<%=txtCode.ClientID %>").val('');
                        $("#divdisclosure").val('');
                    }else{
                        var dArray = "{";
                        dArray += "'websiteid': '" + wid + "'";
                        dArray += "}";
                        $.ajax({
                        type: "POST",
                        url: "../service/cmService.asmx/LoadWebsite",
                        data: dArray,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        success: function(response) {
                            $("#webload").html('');
                            $("#webload").hide();
                            $("#webtab").show();

                            var wo = eval('(' + response.d + ')');
                            $("#<%=txtName.ClientID %>").val(wo.Name);
                            $("#<%=txtDescription.ClientID %>").val(wo.Description);
                            $("#<%=txtUrl.ClientID %>").val(wo.URL);
                            $("#<%=ddlType.ClientID %>").val(wo.WebSiteTypeID);
                            $("#<%=ddlSurvey.ClientID %>").val(wo.DefaultSurveyID);
                            $("#<%=txtCode.ClientID %>").val(wo.Code);
                            $("#divdisclosure").val(wo.DisclosureText);
                        },
                        error: function(response) {
                            showStickyToast(response.responseText, 'showErrorToast')
                        }                       
                
                    });
                    }  
                    
                    var dArray2 = "{";
                        dArray2 += "'websiteid': '" + wid + "'";
                        dArray2 += "}";
                        $.ajax({
                        type: "POST",
                        url: "../service/cmService.asmx/LoadPaths",
                        data: dArray2,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        success: function(response) {
                            $('#pathMenu').html(response.d);
                        },
                        error: function(response) {
                            $().toastmessage('showErrorToast', response.d);
                        }
                
                    });           
                    
                });
        }
      function loadButtons(){
        $(".jqEditButton").button({
            icons: {
                primary: "ui-icon-pencil"
            },
            text: false
        });
        $(".jqAddButton").button({
            icons: {
                primary: "ui-icon-plusthick"
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
        $(".jqSavePathButton").button({
            icons: {
                primary: "ui-icon-disk"
            },
            text: true
        });
      }
      function loadWidgets(){
        $(".menu").menu();
        $(".sortable").sortable();
      }
      function LoadTabs(){
        $("#webtab").tabs({
            cache: false,
            ajaxOptions: {
                cache: false
            },
            selected: 0,
            fx: [{ opacity: 'toggle', duration: 'normal' },   // hide option 
            {opacity: 'toggle', duration: 'fast'}]
        });
      }
        function showDialog(websiteid){

            var editor = CKEDITOR.instances.divdisclosure;
            CKEDITOR.config.protectedSource.push(/<([\S]+)[^>]*class="preserve"[^>]*>.*<\/\1>/g);
            CKEDITOR.config.fillEmptyBlocks = false;
            CKEDITOR.config.fullPage = false;
            CKEDITOR.config.htmlEncodeOutput = true;

            var writer = editor.dataProcessor.writer;
            writer.indentationChars = '&nbsp;';                 // The character sequence to use for every indentation step.
            writer.selfClosingEnd = ' />';                  // The way to close self closing tags, like <br />.
            writer.lineBreakChars = '';                // The character sequence to be used for line breaks.
            writer.setRules('p',                            // The writing rules for the <p> tag.
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });
            writer.setRules('h1',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });
            writer.setRules('h2',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });                
            writer.setRules('h3',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                }); 
                 
            $("#dialog-website")
                .data('websiteid', websiteid)
                .dialog("open");
            return false;

        }
        function DeleteWebsite(){
            if (confirm('Are you sure you want to delete this website?')){
                var wid =  $("#dialog-website").data('websiteid');
                var dArray = "{";
                dArray += "'websiteid': '" + wid + "'";
                dArray += "}";
                 $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/DeleteWebsite",
                    data:  dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                });
            }
        }
        function SaveWebsite(){
            var editor = CKEDITOR.instances.divdisclosure;
            var questionhtml = editor.getData();

            var wo = new Object;
            wo.WebsiteID =  $("#dialog-website").data('websiteid');
            wo.Name = $("#<%=txtName.ClientID %>").val();
            wo.Description = $("#<%=txtDescription.ClientID %>").val();
            wo.URL = $("#<%=txtUrl.ClientID %>").val();
            wo.WebSiteTypeID = $("#<%=ddlType.ClientID %>").val();
            wo.DefaultSurveyID = $("#<%=ddlSurvey.ClientID %>").val();
            wo.Code = $("#<%=txtCode.ClientID %>").val();
            wo.DisclosureText = questionhtml

            if (wo.Name =='') {
                 $().toastmessage('showErrorToast', 'Website Name is Required!');
                return;
            }
            if (wo.URL =='') {
                 $().toastmessage('showErrorToast', 'Website URL is Required!');
                return;
            }
            var DTO = { 'websiteobject': wo };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SaveWebsite",
                data:  JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });

        }
    </script>
    <style type="text/css">
        .style1
        {
            text-align: right;
            width: 100px;
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float:left">
        <h2>Websites</h2>
    </div>
    <div style="float: right; padding: 0px 0px 5px 5px">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <button class="jqAddButton" onclick="return showDialog(-1)" style="float: right">
                        Add Site</button>
                </td>
            </tr>
        </table>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gvWebsites" runat="server" AllowPaging="True" AllowSorting="false"
                        AutoGenerateColumns="False" DataKeyNames="WebsiteID" DataSourceID="dsWebsites"
                        Width="100%" PageSize="22" GridLines="None" AlternatingRowStyle-CssClass="altrow">
                        <Columns>
                            <asp:BoundField DataField="WebsiteID" HeaderText="ID" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left"
                                ReadOnly="True" SortExpression="WebsiteID" ItemStyle-Width="30px" ItemStyle-CssClass="griditem2" />
                            <asp:TemplateField HeaderText="Website" SortExpression="Name">
                                <ItemTemplate>
                                    <asp:Image ID="imgActive" runat="server" ImageUrl="~/images/16-circle-green.png" />
                                    <asp:LinkButton ID="lnkSelect" runat="server" Text='<%# eval("Name") %>' style="text-decoration:underline"
                                            CommandName="Select" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="WebsiteType" HeaderText="Website Type" SortExpression="WebsiteType" ItemStyle-CssClass="griditem2">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="URL" SortExpression="URL">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlUrl" runat="server" Text='<%# Bind("URL") %>' NavigateUrl='<%# Bind("URL") %>' style="text-decoration:underline"
                                        Target="_blank" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Code" HeaderText="Code" SortExpression="Code" ItemStyle-CssClass="griditem2">
                                <HeaderStyle HorizontalAlign="center" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Survey" SortExpression="SurveyName">
                                <ItemTemplate>
                                    <asp:Label ID="lblSurvey" runat="server"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Suppressions" SortExpression="SupCnt">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlSup" runat="server" Text='<%# Bind("SupCnt") %>' style="text-decoration:underline"
                                        Target="_blank" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" />
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                No Available Websites
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
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" />
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
                    <asp:SqlDataSource ID="dsWebsites" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_websites_select" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                        <SelectParameters>
                            <asp:Parameter Name="websiteid" Type="Int32" ConvertEmptyStringToNull="true" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <div id="updateDiv" style="display: none; height: 40px; width: 40px">
                        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader3.gif" />
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvWebsites" EventName="PageIndexChanging" />
                    <asp:AsyncPostBackTrigger ControlID="btnRefresh" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
            <script type="text/javascript">

                function onUpdating() {
                    // get the update progress div
                    var updateProgressDiv = $get('updateDiv');
                    // make it visible
                    updateProgressDiv.style.display = '';

                    //  get the gridview element
                    var gridView = $get('grid-holder');

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
            <ajaxtoolkit:UpdatePanelAnimationExtender ID="upaeMain" BehaviorID="Mainanimation"
                runat="server" TargetControlID="upMain">
                <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
                </Animations>
            </ajaxtoolkit:UpdatePanelAnimationExtender>
        </div>
    </div>
    <asp:LinkButton ID="btnRefresh" runat="server" />
    <div id="dialog-website" title="Edit Website Info">
        <div id="webload">
        </div>
        <div id="webtab">
            <ul>
                <li><a href="#webtab1"><span>Info</span></a></li>
                <li><a href="#webtab2"><span>Disclosure Text</span></a></li>
                <li><a href="#webtab3"><span>Paths</span></a></li>
            </ul>
            <div id="webtab1">
                <div class="form">
                    <table style="width: 100%">
                        <tr>
                            <td class="style1">
                                Name:
                            </td>
                            <td>
                                <asp:TextBox ID="txtName" runat="server" Width="99%" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="style1">
                                Description:
                            </td>
                            <td>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Width="99%" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="style1">
                                URL:
                            </td>
                            <td>
                                <asp:TextBox ID="txtURL" runat="server" TextMode="MultiLine" Rows="3" Width="99%" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Type:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlType" runat="server" Width="99%" DataSourceID="dsTypes"
                                    DataTextField="Type" DataValueField="WebsiteTypeID" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Default Survey:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSurvey" runat="server" Width="99%" DataSourceID="dsSurveys"
                                    DataTextField="Description" DataValueField="SurveyID" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Code:
                            </td>
                            <td>
                                <asp:TextBox ID="txtCode" runat="server" Width="99%" />
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
            </div>
            <div id="webtab2">
                <div>
                    <textarea name="divdisclosure" class="editor" cols="1" rows="5" id="divdisclosure"></textarea>
                </div>
            </div>
            <div id="webtab3">
                <div>
                   <div class="form">
                    <table style="width: 100%; height:100%;" >
                        <tr>
                            <td colspan="3" style="text-align:center;">
                                <h3></h3>
                            </td>
                        </tr>
                        <tr>
                            <td width="45%">
                                <ul class="menu" id="pathMenu" style="width:100%; background-color:#fff; background-image:none;">

                                </ul>
                            </td>
                            <td width="10%"></td>
                            <td width="45%">
                                <ul class="sortable" id="pageSort" style="list-style-type: none; margin: 0; padding: 0; margin-bottom: 15px; margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; width: 95%;">

                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3"><button id="btnSavePath" class="jqSavePathButton" onclick="submitPath()" style="float: right">Save Path</button></td>
                        </tr>
                    </table>
                    <br />
                </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="dsSurveys" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
        SelectCommand="select -1[SurveyID],''[Description] union SELECT SurveyID, Description + '(' + cast(SurveyID as varchar)  +')'[Description] from tblSurvey">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsTypes" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
        SelectCommand="SELECT -1[WebsiteTypeID],''[Type] union SELECT WebsiteTypeID, Type FROM tblWebsiteTypes">
    </asp:SqlDataSource>
</asp:Content>
