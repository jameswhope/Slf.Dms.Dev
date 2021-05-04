<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="datamining.aspx.vb" Inherits="admin_datamining" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        div#users-contain
        {
            width: 350px;
            margin: 20px 0;
        }
        div#users-contain table
        {
            margin: 1em 0;
            border-collapse: collapse;
            width: 100%;
        }
        div#users-contain table td, div#users-contain table th
        {
            border: 1px solid #eee;
            padding: .6em 10px;
            text-align: left;
        }
        .ui-dialog .ui-state-error
        {
            padding: .3em;
        }
        .validateTips
        {
            border: 1px solid transparent;
            padding: 0.3em;
        }
        .selectedRow
        {
            background-color: #FFDAB9;
            font-weight: bold;
        }
    </style>

    <script type="text/javascript">
        var dbid = null;
        
        function pageLoad() {
            docReady();
        }

        function docReady() {

            $(document).ready(function() {
                $("input:submit").button();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .prepend("<span class='ui-icon ui-icon-minusthick'></span>")
				        .end()
			        .find(".portlet-content");
                $(".portlet-header .ui-icon").click(function() {
                    $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
                    $(this).parents(".portlet:first").find(".portlet-content").toggle();
                });
                $("#dialog:ui-dialog").dialog("destroy");
                var name = $("#name"), active = $("#active"), editbatchname = $("*[id$='txtEditBatchName']"),
			    allFields = $([]).add(name).add(active).add(editbatchname),
			    tips = $(".validateTips");
                function updateTips(t) {
                    tips
				    .text(t)
				    .addClass("ui-state-highlight");
                    setTimeout(function() {
                        tips.removeClass("ui-state-highlight", 1500);
                    }, 500);
                }
                function checkLength(o, n, min, max) {
                    if (o.val().length > max || o.val().length < min) {
                        o.addClass("ui-state-error");
                        updateTips("Length of " + n + " must be between " +
					    min + " and " + max + ".");
                        return false;
                    } else {
                        return true;
                    }
                }
                function checkRegexp(o, regexp, n) {
                    if (!(regexp.test(o.val()))) {
                        o.addClass("ui-state-error");
                        updateTips(n);
                        return false;
                    } else {
                        return true;
                    }
                }
                $("#dialog-question").dialog({
                    autoOpen: false,
                    height: 275,
                    width: 550,
                    modal: true,
                    buttons: {
                        "Save to Data Batch": function() {
                            var bValid = true;
                            allFields.removeClass("ui-state-error");
                            var dbid = $(this).data('dbid');
                            var ddl = $("*[id$='ddlQuestions']");
                            var quest = ddl[0].value;
                            if(quest != ''){
                                var dArray = "{";
                                dArray += "'dataBatchID': '" + dbid + "',";
                                dArray += "'questionQOID': '" + quest + "'";
                                dArray += "}";

                                $.ajax({
                                    type: "POST",
                                    url: "../service/cmService.asmx/InsertQuestion",
                                    data: dArray,
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    async: true,
                                    success: function(response) {
                                        refresh();
                                        $().toastmessage('showSuccessToast', response.d);
                                    },
                                    error: function(response) {
                                        alert(response.responseText);
                                    }
                                });
                                $(this).dialog("close");
                            }else{
                                alert('Nothing Selected');
                            }
                        },
                        Cancel: function() {
                            $(this).dialog("close");
                        }
                    },
                    close: function() {
                        allFields.val("").removeClass("ui-state-error");
                    }
                });
                $("#dialog-results").dialog({
                    autoOpen: false,
                    height: 475,
                    width: 750,
                    modal: true,
                    buttons: {
                        Cancel: function() {
                            $(this).dialog("close");
                    }
                },
                    close: function() {
                        allFields.val("").removeClass("ui-state-error");
                    }
                });
                $("#dialog-batch").dialog({
                    autoOpen: false,
                    height: 300,
                    width: 350,
                    modal: true,
                    buttons: {
                        "Save Batch": function() {
                        var bValid = true;
                        allFields.removeClass("ui-state-error");
                        var uid = <%=UseriD %>;
                        var bid = $(this).data('dbid');
                        var batchName = editbatchname[0].value;
                        var batchActive = $("*[id$='chkEditActive']").attr("checked");
                        if (batchActive == undefined) {
                            batchActive = 'false';
                        } else {
                            batchActive = 'true';
                        }
                        //PageMethods.PM_InsertUpdateBatch(bid,batchName, batchActive, OnRequestComplete, OnRequestError);
                        
                        var dArray = "{";
                        dArray += "'batchID': '" + bid + "',";
                        dArray += "'BatchName': '" + batchName + "',";
                        dArray += "'batchActive': '" + batchActive + "'";
                        dArray += "}";

                        $.ajax({
                            type: "POST",
                            url: "../service/cmService.asmx/InsertUpdateBatch",
                            data: dArray,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: true,
                            success: function(response) {
                                refresh();
                                $().toastmessage('showSuccessToast', response.d);
                            },
                            error: function(response) {
                                alert(response.responseText);
                            }
                        });
                        $(this).dialog("close");
                    },
                    Cancel: function() {
                        $(this).dialog("close");
                    }
                    },
                    close: function() {
                        allFields.val("").removeClass("ui-state-error");
                    }
                });
                $("#create-batch").button();
                $("*[id$='lnkAddQuestion']").button();
			    $("*[id$='lnkEdit']")
			    .button({ 
			        icons: {
                        primary: "ui-icon-pencil"
                        },
                    text: false
                })
			    .click(function() {
			        $("#dialog-batch").dialog("open");
			    });
			    $("*[id$='lnkView']").button({ 
			        icons: {
                        primary: "ui-icon-search"
                        },
                    text: false
                });
                $(".jqDeleteButton").button({ 
			        icons: {
                        primary: "ui-icon-trash"
                        },
                    text: false
                });
                $("*[id$='lnkViewQuestion']").button({ 
			        icons: {
                        primary: "ui-icon-help"
                        },
                    text: false
                });
            });
        }
        function OnRequestError(error, userContext, methodName) {
            if (error != null) {
                 $().toastmessage('showErrorToast', error.get_message());
            }
        }
        function OnRequestComplete(result, userContext, methodName) {
            refresh();
            $().toastmessage('showSuccessToast', result);

        }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }
    </script>

    <script type="text/javascript">
        var ddlSID = '<%=ddlSurvey.ClientID%>';
        var ddlQID = '<%=ddlQuestions.ClientID%>';

        function LoadQuestionsAjax() {

            var sid = $("#" + ddlSID + " > option:selected").attr('value');

            var dArray = "{";
            dArray += "'surveyID': '" + sid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetQuestionsBySurvey",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    QuestionUpdating(response.d);
                },
                error: function(response) {
                    alert(response.responseText);
                    $('#' + ddlQID + ' > option').remove();
                    SurveyNotChanged();
                }
            });
            return false;
        }

        function QuestionUpdating(items) {
            $('#' + ddlQID + ' > option').remove();
            if (items.length > 0) {
                var options = '';
                for (o in items) {
                    var DataMiningQuestion = items[o];
                    options += "<option value='" + DataMiningQuestion.QuestionOptionID + "'>" + DataMiningQuestion.QuestionText + "</option>";
                }
                $("#" + ddlQID).removeAttr('disabled').html(options);
            } else {
                SurveyNotChanged();
            }
        }
        function SurveyNotChanged() {
            $("#" + ddlQID).append("<option value='0'>(None Found)</option>");
        }
        function ShowQuestions(batchID) {

            $("#dialog-question")
                .data('dbid', batchID)
                .dialog("open");
            return false;

        }
        function ShowEditBatch(batchID, bName, active) {
            //$("#active");
            if (batchID != -1) {
                $("*[id$='txtEditBatchName']").val(bName);
                $("*[id$='chkEditActive']").attr("checked", active);
            } else {
                $("*[id$='txtEditBatchName']").val('');
                $("*[id$='chkEditActive']").removeAttr("checked");
            }

            $("#dialog-batch")
                .data('dbid', batchID)
                .dialog("open");
            return false;
        }
    </script>

    <script type="text/javascript">
        function viewData(dataBatchID) {
            var dArray = "{'dataBatchID': '" + dataBatchID + "'}";
            $.ajax({
                type: "POST",
                url: "datamining.aspx/PM_viewData",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    var d = document.getElementById('<%=results.clientid %>');
                    d.innerHTML = response.d;
                    $("#dialog-results").dialog("open");
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="upData" runat="server">
        <ContentTemplate>
            <table style="width: 100%" id="tblForm">
                <tr valign="top">
                    <td style="width: 45%;">
                        <div class="portlet">
                            <div class="portlet-header">
                                Batch
                            </div>
                            <div class="portlet-content">
                                <asp:GridView ID="gvBatch" runat="server" AllowPaging="True" AllowSorting="True"
                                    AutoGenerateColumns="False" CssClass="ui-widget-content" DataKeyNames="DataBatchID"
                                    Width="100%" DataSourceID="dsBatch" Font-Size="12px" PageSize="20">
                                    <SelectedRowStyle CssClass="selectedRow" />
                                    <Columns>
                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <small>
                                                    <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="False" Text="Edit Batch"
                                                        OnClientClick="return false;" />
                                                    <asp:LinkButton ID="lnkViewQuestion" runat="server" CausesValidation="False" CommandName="Select"
                                                        Text="View Questions" CommandArgument='<%# Bind("DataBatchID") %>' />
                                                    <asp:LinkButton ID="lnkView" runat="server" CausesValidation="False" CommandName="View"
                                                        Text="View Data" CommandArgument='<%# Bind("DataBatchID") %>' />
                                                    <asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                                        Text="Delete" CssClass="jqDeleteButton" OnClientClick="return confirm('Are you sure you want to delete this batch?');" />
                                                </small>
                                            </ItemTemplate>
                                            <HeaderStyle Width="125px" />
                                            <ItemStyle Width="125px" VerticalAlign="Top" HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="DataBatchID" HeaderText="DataBatchID" InsertVisible="False"
                                            ReadOnly="True" SortExpression="DataBatchID" Visible="False" />
                                        <asp:TemplateField HeaderText="BatchName" SortExpression="BatchName">
                                            <EditItemTemplate>
                                                <asp:TextBox ID="BatchNameTextBox" runat="server" Text='<%# Bind("BatchName") %>'
                                                    Width="85%" />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("BatchName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle VerticalAlign="Top" />
                                        </asp:TemplateField>
                                        <asp:CheckBoxField DataField="Active" HeaderText="Active" SortExpression="Active">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" />
                                        </asp:CheckBoxField>
                                    </Columns>
                                    <HeaderStyle CssClass="ui-widget-header" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsBatch" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    CancelSelectOnNullParameter="false" DeleteCommand="DELETE FROM tblDataBatch WHERE (DataBatchID = @DataBatchID)"
                                    SelectCommand="SELECT DataBatchID, BatchName, Active FROM tblDataBatch" UpdateCommand="UPDATE tblDataBatch SET BatchName = @BatchName, Active = @Active WHERE DataBatchID = @DataBatchID">
                                    <DeleteParameters>
                                        <asp:Parameter Name="DataBatchID" />
                                    </DeleteParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="BatchName" />
                                        <asp:Parameter Name="Active" />
                                        <asp:Parameter Name="DataBatchID" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>
                                <button id="create-batch" onclick="return ShowEditBatch(-1,'','False');">
                                    Create Batch</button>
                            </div>
                        </div>
                    </td>
                    <td id="tdQuestions" runat="server">
                        <div class="portlet">
                            <div class="portlet-header">
                                Batch Questions
                            </div>
                            <div class="portlet-content">
                                <asp:GridView ID="gvQuestions" runat="server" Width="100%" DataSourceID="dsQuestions"
                                    AutoGenerateColumns="False" DataKeyNames="DataBatchQuestionID" Font-Size="12px">
                                    <Columns>
                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <small>
                                                    <asp:LinkButton ID="lnkDeleteQuestion" runat="server" CausesValidation="False" CommandName="Delete"
                                                        Text="Delete Question" OnClientClick="return confirm('Are you sure you want to delete this question?');"
                                                        CssClass="jqDeleteButton" />
                                                </small>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="center" CssClass="ui-widget-header" Width="35" />
                                            <ItemStyle HorizontalAlign="center" CssClass="ui-widget-content" Width="35" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="DataBatchQuestionID" Visible="false" />
                                        <asp:BoundField DataField="QuestionText" HeaderText="Question">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                            <ItemStyle CssClass="ui-widget-content" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="QuestionAnswer" HeaderText="Answer">
                                            <HeaderStyle HorizontalAlign="center" CssClass="ui-widget-header" />
                                            <ItemStyle HorizontalAlign="center" CssClass="ui-widget-content" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ResponseCount" HeaderText="Count">
                                            <HeaderStyle HorizontalAlign="center" CssClass="ui-widget-header" Width="75" />
                                            <ItemStyle HorizontalAlign="center" CssClass="ui-widget-content" Width="75" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="stp_databatch_GetBatchQuestions" SelectCommandType="StoredProcedure"
                                    DeleteCommand="DELETE FROM tblDataBatchQuestionXRef WHERE (DataBatchQuestionID = @DataBatchQuestionID)">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="gvBatch" Name="BatchID" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                    <DeleteParameters>
                                        <asp:Parameter Name="DataBatchQuestionID" />
                                    </DeleteParameters>
                                </asp:SqlDataSource>
                                <asp:LinkButton ID="lnkAddQuestion" runat="server" CssClass="grdLnk" Text="Add New Question" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
            <div id="divProgress" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-question" title="Add Question">
        <p class="validateTips">
            All form fields are required.</p>
        <form>
        <fieldset>
            <legend>Select Survey</legend>
            <asp:DropDownList ID="ddlSurvey" runat="server" DataSourceID="dsSurvey" DataTextField="Description"
                DataValueField="SurveyID" />
            <asp:SqlDataSource ID="dsSurvey" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="select SurveyID, Description FROM tblSurvey union SELECT -1,'--Select Survey--'">
            </asp:SqlDataSource>
            <fieldset>
                <legend>Select Question</legend>
                <asp:DropDownList ID="ddlQuestions" runat="server" DataTextField="Question" DataValueField="qoid"
                    Width="100%" />
            </fieldset>
        </fieldset>
        </form>
    </div>
    <div id="dialog-results" title="Results">
        <form>
        <fieldset>
            <div id="results" runat="server">
            </div>
        </fieldset>
        </form>
    </div>
    <div id="dialog-batch" title="Edit batch">
        <p class="validateTips">
            All form fields are required.</p>
        <form>
        <fieldset>
            <label for="name">
                Batch Name</label>
            <input type="text" name="editbatchname" id="txtEditBatchName" class="text ui-widget-content ui-corner-all"
                style="width: 70%;" />
            <label for="active">
                Active</label>
            <input name="active" type="checkbox" id="chkEditActive" />
        </fieldset>
        </form>
    </div>

    <script type="text/javascript">
        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('divProgress');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('tblForm');

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
                            <EnableAction AnimationTarget="tblForm" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="tblForm" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </asp:UpdatePanelAnimationExtender>
</asp:Content>
