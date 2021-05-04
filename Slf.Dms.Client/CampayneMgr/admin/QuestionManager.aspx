<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="QuestionManager.aspx.vb" Inherits="admin_QuestionManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
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
        function LoadDialogs() {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-question").dialog({
                autoOpen: false,
                modal: true,
                height: 350,
                width: 400
            });
        }
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
        function ShowDialog(qid) {
            if (qid == -1) {
                //new question
                $("*[id$='txtQuestion']").val('');
            } else {
                //load question
                var dArray = "{";
                dArray += "'corequestionid': '" + qid + "'";
                dArray += "}";

                doAjax('GetCoreQuestion', dArray, true, function (result) {
                    //success
                    $("*[id$='txtQuestion']").val(result.d);
                },
                function (result) {
                    //error
                    $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
                });

            }

            $("#dialog-question").data('uniqueid', qid).dialog('open');
            return false;
        }
        function doAjax(functionName, functionArrayArgs, doAsync, onSuccess, onError) {

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Admin > Question Manager
    </div>
    <br style="clear: both" />
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gvQuestions" runat="server" AllowPaging="True" AllowSorting="True"
                        AutoGenerateColumns="False" DataKeyNames="CoreQuestionID" DataSourceID="dsQuestions"
                        Width="100%" PageSize="15" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
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
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditQuestion" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit" CssClass="jqEditButton" Font-Size="11px"></asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update"
                                        Text="Update"></asp:LinkButton>
                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                                        Text="Cancel"></asp:LinkButton>
                                </EditItemTemplate>
                                <HeaderStyle Width="30px" />
                                <ItemStyle Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="CoreQuestionID" HeaderText="CoreQuestionID" SortExpression="CoreQuestionID"
                                Visible="False" InsertVisible="False" ReadOnly="True" />
                            <asp:BoundField DataField="QuestionText" HeaderText="QuestionText" SortExpression="QuestionText">
                            </asp:BoundField>
                            <%-- <asp:BoundField DataField="Created" HeaderText="Created" 
                                SortExpression="Created">
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" 
                                SortExpression="CreatedBy" Visible="False">
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedByName" HeaderText="Created By" 
                                SortExpression="CreatedByName" ReadOnly="True">
                            </asp:BoundField>--%>
                            <asp:BoundField DataField="LastModified" HeaderText="LastModified" SortExpression="LastModified">
                                <HeaderStyle Width="150px" />
                                <ItemStyle Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModified" SortExpression="LastModifiedBy"
                                Visible="False"></asp:BoundField>
                            <asp:BoundField DataField="LastModifiedByName" HeaderText="Last Modified By" ReadOnly="True"
                                SortExpression="LastModifiedByName">
                                <HeaderStyle Width="150px" />
                                <ItemStyle Width="150px" />
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
                    <asp:SqlDataSource ID="dsQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        InsertCommand="INSERT INTO tblQuestionsCore(QuestionText, Created, CreatedBy, LastModified, LastModifiedBy) VALUES (@QuestionText, GETDATE(), @UserID, GETDATE(), @UserID)"
                        SelectCommand="SELECT tblQuestionsCore.CoreQuestionID, tblQuestionsCore.QuestionText, tblQuestionsCore.Created, tblQuestionsCore.CreatedBy, cu.FirstName + ' ' + cu.LastName AS CreatedByName, tblQuestionsCore.LastModified, tblQuestionsCore.LastModifiedBy, mu.FirstName + ' ' + mu.LastName AS LastModifiedByName FROM tblQuestionsCore LEFT OUTER JOIN tblUser AS mu ON tblQuestionsCore.LastModifiedBy = mu.UserId LEFT OUTER JOIN tblUser AS cu ON tblQuestionsCore.CreatedBy = cu.UserId"
                        UpdateCommand="UPDATE tblQuestionsCore SET QuestionText = @QuestionText, LastModified = GETDATE(), LastModifiedBy = @LastModifiedBy WHERE (CoreQuestionID = @corequestionid)">
                        <InsertParameters>
                            <asp:Parameter Name="QuestionText" />
                            <asp:Parameter Name="UserID" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="QuestionText" />
                            <asp:Parameter Name="LastModifiedBy" />
                            <asp:Parameter Name="corequestionid" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvQuestions" EventName="PageIndexChanging" />
                </Triggers>
            </asp:UpdatePanel>
            <div style="margin: 10px; padding: 10px">
                <button class="jqAddButton" onclick="return ShowDialog(-1);" style="position: relative;
                    float: left;">
                    Create New Question</button>
            </div>
        </div>
    </div>
    <div id="dialog-question" title="Question">
       
        <fieldset style="padding:15px;">
        <asp:TextBox ID="txtQuestion" TextMode="MultiLine" runat="server" Rows="5" Width="100%" />
        <hr />
        <asp:Button ID="btnSave" runat="server" CssClass="jqSaveButton" Text="Save Question" style="float:right!important" />
        </fieldset>
    </div>
</asp:Content>
