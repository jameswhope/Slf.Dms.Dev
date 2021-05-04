<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="SurveyManager.aspx.vb" Inherits="admin_SurveyManager" EnableEventValidation="false"
    ValidateRequest="false" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .modalBackgroundTracker
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupTracker
        {
            background-color: #fff;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            width: 65%;
        }
        .style1
        {
            height: 28px;
        }
        .tdHdr
        {
            width: 150px;
        }
        .grdLnk
        {
            color: #4791C5 !important;
        }
        .grdLnk:hover
        {
            color: #E08B05 !important;
        }
    </style>
    <script type="text/javascript">
        //misc funcs
        function AddToList(elem) {
            //var ddl = $("*[id$='lstOptions']");
            var newoption = $("*[id$='txtAddOption']").val();
            //ddl.append("<option value='-1'>" + newoption + "</option>")

            $("*[id$='lstOptions']").append(
                $('<option></option>').val(-1).html(newoption)
            );

            $("*[id$='ddlBranchResponse']").append(
                $('<option></option>').val(newoption).html(newoption)
            );

            $().toastmessage('showSuccessToast', 'Item Added!');

            $("*[id$='txtAddOption']").val("");

            return false;
        }
        function RemoveFromList(elem) {

            var dval = $("*[id$='lstOptions']").val();
            $("*[id$='lstOptions'] option[value='" + dval + "']").remove();
            $("*[id$='ddlBranchResponse'] option[value='" + dval + "']").remove();

            var dArray = "{";
            dArray += "'optionid': '" + dval + "'";
            dArray += "}";
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/DeleteQuestionOption",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $("*[id$='txtAddOption']").val('')
                    $().toastmessage('showSuccessToast', response.d);
                }
            });
            return false;
        }
        function FillTextbox(elem) {
            var p = elem.parentNode;
            var txts = p.getElementsByTagName('input');
            var txt = null;
            for (i = 0; i <= txts.length; i++) {
                if (txts[i].type = 'text') {
                    txt = txts[i]
                    break;
                }
            }
            for (i = 0; i < elem.length; i++) {
                if (elem.options[i].selected) {
                    var key = elem.options[i].text;
                    txt.value = key;
                    break;
                }
            }
            return false;
        }
    </script>
    <script type="text/javascript">
        var sURL = unescape(window.location.pathname);
        var ckoptions = { langCode: 'en', skin: 'office2003',
            width: 450,
            height: 240,
            toolbar:
						 [
							 ['Source', '-', 'Bold', 'Italic', 'Underline','-' ,'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock','-','Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat'],
							 ['Font', 'FontSize','Format','NumberedList', 'BulletedList','-', 'TextColor']
						 ]
        };
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $("#button-holder").buttonset();
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
                $('.editor').ckeditor(ckoptions);
                loadButtons();
                loadDialogs();
                $("#questiontabs").tabs();

            });
        }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }
        function loadDialogs(){
          $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-survey").dialog({
                    autoOpen: false,
                    height: 475,
                    width: 820,
                    modal: true,
//                    position: [300, 50],
                    stack: true,
                    buttons: {},
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-question").dialog({
                    autoOpen: false,
                    height: 575,
                    width: 550,
                    modal: true,
                    position: [300, 50],
                    stack: true,
                    buttons: {
                        "Save Question":function(){
                            SaveQuestion();
                        }
                    },
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-test").dialog({
                    autoOpen: false,
                    height: 475,
                    width: 800,
                    modal: true,
                    position: [300, 50],
                    stack: true
                });

        }
        function loadButtons(){
                $("input:submit").button();
                $(".jqButton").button();
                $("*[id$='btnSaveQuestion']").button();
                $(".jqViewButton").button({
                    icons: {
                        primary: "ui-icon-search"
                    },
                    text: false
                });
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
                    text: false
                });
                $(".jqDeleteButton").button({
                    icons: {
                        primary: "ui-icon-trash"
                    },
                    text: false
                });
        }
    </script>
    <script type="text/javascript">
        //question js

        function ShowQuestion(surveyid, questionid, questionhtml, questionplain, responsetype, responseitems, branchurl, branchresponse, offer, popunderurl, popupurl, active) {
            if (questionid != -1) {
                $("*[id$='divquestion']").val(questionhtml);
                $("*[id$='txtQuestionPlainText']").val(questionplain);
                $("*[id$='ddlType']").val(responsetype);
                $("*[id$='txtBranchUrl']").val(branchurl);
                $("*[id$='txtBranchResponse']").val(branchresponse);
                $("*[id$='ddlOffer']").val(offer);
                $("*[id$='txtPopunder']").val(popunderurl);
                $("*[id$='txtPopup']").val(popupurl);
                $("*[id$='lstOptions']").html("");
                $("*[id$='ddlBranchResponse']").html("");
                $("*[id$='ddlBranchResponse']").append(
                    $('<option></option>').val("").html("")
                );
                if (responseitems != "") {
                    var itms = responseitems.split("|");
                    for (var i in itms) {
                        var itm = itms[i].split(":");
                        $("*[id$='lstOptions']").append(
                            $('<option></option>').val(itm[0]).html(itm[1])
                        );

                        if (itm[1] == branchresponse) {
                            $("*[id$='ddlBranchResponse']").append(
                                $("<option selected='selected'></option>").val(itm[1]).html(itm[1])
                            );
                        } else {
                            $("*[id$='ddlBranchResponse']").append(
                                $('<option></option>').val(itm[1]).html(itm[1])
                            );
                        }
                    }
                }
                $("*[id$='ddlBranchResponse']").val(branchresponse);

                if (active.toLowerCase() == 'true') {
                    $("*[id$='chkActive']").attr('checked', true);
                } else {
                    $("*[id$='chkActive']").attr('checked', false);
                }

            } else {
                $("*[id$='divquestion']").val('');
                $("*[id$='txtBranchUrl']").val('');
                $("*[id$='txtBranchResponse']").val('');
                $("*[id$='txtPopunder']").val('');
                $("*[id$='txtPopup']").val('');
                var ddl = $("*[id$='lstOptions']");
                ddl.html("");
            }
            var editor = CKEDITOR.instances.divquestion;
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
            $("#dialog-question")
                .data('SurveyID', surveyid)
                .data('QuestionID', questionid)
                .dialog("open");
            return false;
        }
        function SaveQuestion() {
            $("#loading").html(loadingImg);
            $("#loading").show();
            $("#question-holder").hide();

            var sid = $("#dialog-question").data('SurveyID');
            var qid = $("#dialog-question").data('QuestionID');

            var editor = CKEDITOR.instances.divquestion;
            var questionhtml = editor.getData();
            var questionplain = $("*[id$='txtQuestionPlainText']").val();
            var responseitems = '';
            $("*[id$='lstOptions'] option").each(function (option) {
                responseitems += $(this).val() + ':' + $(this).text() + '|';
            })
            var responsetype = $("*[id$='ddlType']").val();
            var branchurl = $("*[id$='txtBranchUrl']").val();
            var branchresponse = $("*[id$='ddlBranchResponse']").val(); ;
            var offer = $("*[id$='ddlOffer']").val();
            if (offer == null) {
                offer = '-1';
            }
            var popunderurl = $("*[id$='txtPopunder']").val();
            var popupurl = $("*[id$='txtPopup']").val();

            var active = $("*[id$='chkActive']").attr("checked");
            if (active == undefined) {
                active = 'false';
            } else {
                active = 'true';
            }

            var dArray = "{";
            dArray += "'surveyID': '" + sid + "',";
            dArray += "'questionid': '" + qid + "',";
            dArray += "'questionhtml': '" + questionhtml + "',";
            dArray += "'questionplain': '" + questionplain + "',";
            dArray += "'responsetype': '" + responsetype + "',";
            dArray += "'branchresponse': '" + branchresponse + "',";
            dArray += "'branchurl': '" + branchurl + "',";
            dArray += "'popupurl': '" + popupurl + "',";
            dArray += "'popunderurl': '" + popunderurl + "',";
            dArray += "'offerid': '" + offer + "',";
            dArray += "'options': '" + responseitems + "',";
            dArray += "'active': '" + active + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SaveQuestion",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $("#loading").hide();
                    $("#question-holder").show();
                    $().toastmessage('showSuccessToast', response.d);
                    refresh();
                },
                error: function (response) {
                    $().toastmessage('showErrorToast', response.responseText);
                }
            });
        }
        function ShowQuestionAJAX(surveyid,questionid) {
            if (questionid != -1) {
                var dArray = "{";
                dArray += "'questionid': '" + questionid + "'";
                dArray += "}";

                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/LoadQuestion",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        var qobj = eval('(' + response.d + ')');
                        $("*[id$='divquestion']").val(qobj[0].Question);
                        $("*[id$='txtQuestionPlainText']").val(qobj[0].QuestionPlainText);
                        $("*[id$='ddlType']").val(qobj[0].QuestionType);
                        $("*[id$='txtBranchUrl']").val(qobj[0].QuestionBranchUrl);
                        $("*[id$='txtBranchResponse']").val(qobj[0].QuestionBranchResponse);
                        $("*[id$='ddlOffer']").val(qobj[0].QuestionOfferID);
                        $("*[id$='txtPopunder']").val(qobj[0].QuestionPopUnderUrl);
                        $("*[id$='txtPopup']").val(qobj[0].QuestionPopUpUrl);
                        $("*[id$='lstOptions']").html("");
                        $("*[id$='ddlBranchResponse']").html("");
                        $("*[id$='ddlBranchResponse']").append(
                            $('<option></option>').val("").html("")
                        );

                        if (!!qobj[0].Options) {
                            var itms = qobj[0].Options.split("|");
                            for (var i in itms) {
                                if (itms[i] != '') {
                                    var itm = itms[i].split(":");
                                    $("*[id$='lstOptions']").append(
                                        $('<option></option>').val(itm[0]).html(itm[1])
                                    );

                                    if (itm[1] == qobj[0].QuestionBranchResponse) {
                                        $("*[id$='ddlBranchResponse']").append(
                                            $("<option selected='selected'></option>").val(itm[1]).html(itm[1])
                                        );
                                    } else {
                                        $("*[id$='ddlBranchResponse']").append(
                                            $('<option></option>').val(itm[1]).html(itm[1])
                                        );
                                    }

                                }
                            }
                        }
                        $("*[id$='ddlBranchResponse']").val(qobj[0].QuestionBranchResponse);
                        if (qobj[0].Active == true) {
                            $("*[id$='chkActive']").attr('checked', true);
                        } else {
                            $("*[id$='chkActive']").attr('checked', false);
                        }

                        $("#dialog-question")
                            .data('SurveyID', surveyid)
                            .data('QuestionID', questionid)
                            .dialog("open");

                    }
                });
            } else {
                $("*[id$='divquestion']").val('');
                $("*[id$='txtBranchUrl']").val('');
                $("*[id$='txtBranchResponse']").val('');
                $("*[id$='txtPopunder']").val('');
                $("*[id$='txtPopup']").val('');
                var ddl = $("*[id$='lstOptions']");
                ddl.html("");
            }
        }
    </script>
    <script type="text/javascript">
        //survey js
        var fixToast = null;

        function CheckSurvey(surveyid) {
            var dArray = "{";
            dArray += "'surveyid': '" + surveyid + "'";
            dArray += "}";
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/CheckSurvey",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    var mtext = response.d;
                    var mtype = 'success';
                    var bshowfix = false;
                    if (mtext.indexOf('WARNING') > 1) {
                        mtype = 'warning';
                    }
                    if (mtext.indexOf('ERROR') > 1) {
                        mtype = 'error';
                        bshowfix = true;
                    }
                    $().toastmessage('showToast', {
                        text: mtext,
                        sticky: true,
                        position: 'top-right',
                        type: mtype
                    });
                    if(bshowfix==true){
                        fixToast = $().toastmessage('showToast', {
                                        text: '<a href="#" style="color:#FFF0A5; cursor:pointer;" onclick="FixSeqError(' + surveyid + ');">Click to Fix Sequence Error?</a>',
                                        sticky: true,
                                        position: 'top-right',
                                        type: 'notice'
                                    });
                    }
                },
                error: function (response) {
                    $().toastmessage('showErrorToast', response.responseText);
                }
            });
        }
        function FixSeqError(surveyid) {
            $().toastmessage('removeToast', fixToast);
            var dArray = "{";
            dArray += "'surveyid': '" + surveyid + "',";
            dArray += "'fixtype': 'questionseq'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/FixSurvey",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showToast', {
                        text: response.d,
                        sticky: true,
                        position: 'top-right',
                        type: 'success'
                    });
                }
            });

        }
        function TestSurvey(surveyid) {

            var testurl = 'http://landmyjob.com/jp/1/?s=' + surveyid
            $("#dialog-test").html(loadingImg + '<iframe id="modalIframeId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open");
            $("#modalIframeId").hide();
            $("#modalIframeId").load(function () {
                $("#loadingDiv").hide();
                $("#modalIframeId").show();
            });
            $("#modalIframeId").attr("src", testurl);

            $("#dialog-test")
                .data('SurveyID', surveyid)
                .dialog("open");
            return false;
        }

        function ShowSurveyEdit(surveyID, surveyDescription, questionseq, finishtext) {
            if (surveyID != -1) {
                $("*[id$='txtSurveyDesc']").val(surveyDescription);
                $("*[id$='txtStartingQuestionSeq']").val(questionseq);
                $("*[id$='txtFinishedText']").val(finishtext);
            } else {
                $("*[id$='btnCopySurvey']").attr('disabled', 'disabled');
                $("*[id$='btnDeleteSurvey']").attr('disabled', 'disabled');
            }
            $("#dialog-survey")
                .data('SurveyID', surveyID)
                .dialog("open");
            return false;
        }
        function SaveSurvey() {
            var sid = $("#dialog-survey").data('SurveyID');
            var desc = $("*[id$='txtSurveyDesc']").val();
            var seq = $("*[id$='txtStartingQuestionSeq']").val();
            var fin = $("*[id$='txtFinishedText']").val();

            var dArray = "{";
            dArray += "'surveyID': '" + sid + "',";
            dArray += "'surveyDesc': '" + desc + "',";
            dArray += "'startingseq': '" + seq + "',";
            dArray += "'finishtext': '" + fin + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SaveSurvey",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showSuccessToast', response.d);
                }
            });
        }
        function CopySurvey() {
            var sid = $("#dialog-survey").data('SurveyID');
            var dArray = "{";
            dArray += "'surveyID': '" + sid + "'";
            dArray += "}";
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/CopySurvey",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showSuccessToast', response.d);
                }
            });
        }
        function DeleteSurvey() {
            var sid = $("#dialog-survey").data('SurveyID');
            if (confirm('Are you sure you want to delete this Survey?')) {
                var dArray = "{";
                dArray += "'surveyID': '" + sid + "'";
                dArray += "}";
                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/DeleteSurvey",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        $().toastmessage('showSuccessToast', response.d);
                    }
                });
            }
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-content" style="min-height: 600px;">
        <div style="float: left; padding: 0px 3px 3px 3px">
            Admin > Survey Mgr
        </div>
        <br style="clear: both" />
        <asp:UpdatePanel ID="upsurvey" runat="server">
            <ContentTemplate>
                <table style="width: 100%;">
                    <tr valign="top">
                        <td style="width: 40%;">
                            <div class="portlet">
                                <div class="portlet-header">
                                    Survey
                                </div>
                                <div class="portlet-content">
                                    <asp:GridView ID="gvSurvey" runat="server" AutoGenerateColumns="False" GridLines="None"
                                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" DataSourceID="dsSurvey"
                                        ShowFooter="false" AllowPaging="True" DataKeyNames="SurveyID" CssClass="content"
                                        Width="100%" HeaderStyle-CssClass="ui-widget-header" PageSize="20">
                                        <SelectedRowStyle  CssClass="ui-state-highlight" />
                                        <Columns>
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemTemplate>
                                                    <small>
                                                        <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Select"
                                                            Text="View Questions" CommandArgument='<%#eval("surveyID") %>' CssClass="jqViewButton"
                                                            Font-Size="8" />
                                                        &nbsp;<asp:LinkButton ID="lnkEditSurvey" runat="server" CausesValidation="False"
                                                            Font-Size="8" CommandName="Edit" Text="Edit Survey" CssClass="jqEditButton" />
                                                    </small>
                                                </ItemTemplate>
                                                <HeaderStyle Width="75px" HorizontalAlign="Center" />
                                                <ItemStyle Width="75px" HorizontalAlign="Center" />
                                                <FooterStyle />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="SurveyID" HeaderText="Survey #" InsertVisible="False"
                                                ReadOnly="True" SortExpression="SurveyID">
                                                <HeaderStyle HorizontalAlign="Center" Width="75px" />
                                                <ItemStyle HorizontalAlign="Center" Width="75px" />
                                                <FooterStyle />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Description") %>' Width="100%"
                                                        TextMode="MultiLine" />
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                                </ItemTemplate>
                                                <FooterStyle />
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <ItemStyle HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="StartingQuestionID" SortExpression="StartingQuestionID"
                                                Visible="False">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("StartingQuestionID") %>'></asp:TextBox>
                                                    <asp:FilteredTextBoxExtender ID="TextBox3_FilteredTextBoxExtender" runat="server"
                                                        Enabled="True" TargetControlID="TextBox3">
                                                    </asp:FilteredTextBoxExtender>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("StartingQuestionID") %>'></asp:Label>
                                                </ItemTemplate>
                                                <FooterStyle />
                                                <HeaderStyle />
                                                <ItemStyle />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="FinishedText" SortExpression="FinishedText" Visible="False">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("FinishedText") %>' Width="100%"
                                                        TextMode="MultiLine" />
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("FinishedText") %>'></asp:Label>
                                                </ItemTemplate>
                                                <FooterStyle />
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <ItemStyle HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No Surveys
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsSurvey" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                        SelectCommand="SELECT [SurveyID], [Description], isnull([StartingQuestionID],0)[StartingQuestionID], [FinishedText] FROM [tblSurvey]">
                                    </asp:SqlDataSource>
                                    <hr />
                                    <div style="padding: 5px; text-align: center; width: 100%;">
                                        <asp:Button ID="btnCreateSurvey" runat="server" Text="Create New Survey" OnClientClick="return ShowSurveyEdit('-1','','');" />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="portlet">
                                <div class="portlet-header">
                                    Survey Questions
                                </div>
                                <div class="portlet-content">
                                    <div class="rl">
                                        <asp:ReorderList ID="rlQuestions" runat="server" AllowReorder="false" DataSourceID="dsQuestions"
                                            PostBackOnReorder="true" DataKeyField="QuestionID" SortOrderField="QuestionSeq"
                                            ItemInsertLocation="End" Width="100%">
                                            <ItemTemplate>
                                                <div style="padding: 1px;">
                                                    <table style="font-family: Tahoma; font-size: 10pt; width: 100%;" cellpadding="0"
                                                        cellspacing="0">
                                                        <tr>
                                                            <td style="text-align: left; width: 75px;">
                                                                <b>Seq #:</b>
                                                                <asp:HiddenField ID="hdnQID" runat="server" Value='<%#eval("questionid") %>' />
                                                                <asp:Label ID="Label3" runat="server" Text='<%#eval("QuestionSeq") %>' />
                                                            </td>
                                                            <td style="text-align: left;">
                                                                <b>Question:</b>
                                                                <asp:Label ID="lblQuestion" runat="server" Text='<%#eval("QuestionPlainText") %>' />
                                                            </td>
                                                            <td style="text-align: right; width: 50px;">
                                                                <small>
                                                                    <asp:LinkButton ID="lnkSelect" runat="server" Text="Edit" CssClass="jqEditButton" />
                                                                </small>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </ItemTemplate>
                                            <DragHandleTemplate>
                                                <div class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-2-n-s" visible="<%# ShowDragHandle %>"
                                                    style="height: 18px; width: 18px; border: solid 1px black; background-color: #FFA12D;
                                                    cursor: pointer; text-align: center;">
                                                    <span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
                                                </div>
                                            </DragHandleTemplate>
                                            <ReorderTemplate>
                                                <div style="width: 100%; height: 15px; border: dotted 2px black;">
                                                    &nbsp;
                                                </div>
                                            </ReorderTemplate>
                                            <EmptyListTemplate>
                                                <div style="padding: 0px 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
                                                    <p>
                                                        <span style="margin-right: 0.3em; float: left;" class="ui-icon ui-icon-info"></span>
                                                        <strong>Warning!</strong> No Survey selected!</p>
                                                </div>
                                            </EmptyListTemplate>
                                        </asp:ReorderList>
                                        <asp:SqlDataSource ID="dsQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                            SelectCommand="SELECT QuestionID, NextQuestionID, Question, QuestionType, QuestionBranchUrl, QuestionBranchResponse, QuestionOfferID, QuestionPopUnderUrl, QuestionPopUpUrl, QuestionSeq, QuestionPlainText, SurveyID, active FROM tblQuestion WHERE (SurveyID = @SurveyID) order by case when isnull(QuestionSeq,0) = 0 then 99999 else QuestionSeq end"
                                            UpdateCommand="UPDATE tblQuestion SET QuestionSeq = @QuestionSeq WHERE (QuestionID = @questionid)">
                                            <UpdateParameters>
                                                <asp:Parameter Name="QuestionSeq" />
                                                <asp:Parameter Name="questionid" />
                                            </UpdateParameters>
                                            <SelectParameters>
                                                <asp:QueryStringParameter Name="SurveyID" QueryStringField="s" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <div id="updateDiv" style="display: none; height: 40px; width: 40px">
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/Images/loading.gif" />
                                        </div>
                                    </div>
                                    <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                        SelectCommand="select offerid, offer from tbloffers union select -1,'none'">
                                    </asp:SqlDataSource>
                                    <div id="divMsg" runat="server">
                                    </div>
                                    <hr />
                                    <div style="padding: 5px; text-align: center;" id="button-holder">
                                        <asp:Button ID="btnCreateQuestion" runat="server" Text="Create Question" Style="display: none;
                                            float: right;" />
                                        <asp:Button ID="btnTestSurvey" runat="server" Text="Test Survey" Style="display: none;
                                            float: right;" />
                                        <asp:Button ID="btnCheck" runat="server" Text="Run Error Check" Style="display: none;
                                            float: right;" />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="dialog-test" title="Test Survey">
    </div>
    <div id="dialog-survey" title="Survey">
        <form>
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:Panel ID="pnlCreateSurvey" runat="server" GroupingText="Create Survey:" Style="display: block;">
                        <table style="width: 100%">
                            <tr>
                                <td class="tdHdr">
                                    Description
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSurveyDesc" runat="server" TextMode="MultiLine" Width="100%" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr">
                                    Starting Question Seq
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStartingQuestionSeq" runat="server" TextMode="SingleLine" Width="100px" />
                                    <asp:NumericUpDownExtender ID="txtStartingQuestionSeq_NumericUpDownExtender" runat="server"
                                        Enabled="True" Maximum="20" Minimum="0" RefValues="" ServiceDownMethod="" ServiceDownPath=""
                                        ServiceUpMethod="" Tag="" TargetButtonDownID="" TargetButtonUpID="" TargetControlID="txtStartingQuestionSeq"
                                        Width="100">
                                    </asp:NumericUpDownExtender>
                                    <asp:FilteredTextBoxExtender ID="txtStartingQuestionSeq_FilteredTextBoxExtender"
                                        runat="server" Enabled="True" FilterType="Numbers" TargetControlID="txtStartingQuestionSeq">
                                    </asp:FilteredTextBoxExtender>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr">
                                    Finished Text
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFinishedText" runat="server" TextMode="MultiLine" Width="100%" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <button class="jqButton" id="btnSaveSurvey" onclick="return SaveSurvey();">
                        Save</button>
                    <button class="jqButton" id="btnCopySurvey" onclick="return CopySurvey();">
                        Copy</button>
                </td>
            </tr>
        </table>
        </form>
    </div>
    <div id="dialog-question" title="Survey">
        <form>
        <div id="loading">
        </div>
        <div id="question-holder">
            <div id="questiontabs">
                <ul>
                    <li><a href="#tabs-1">Question Info</a></li>
                    <li><a href="#tabs-2">Question HTML</a></li>
                    <li><a href="#tabs-3">Question Actions</a></li>
                </ul>
                <div id="tabs-1">
                    <div class="ui-widget">
                        <div class="ui-widget-header">
                            Question Info</div>
                        <div class="ui-widget-content">
                            <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="right">
                                        Offer:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlOffer" runat="server" DataSourceID="dsOffers" DataTextField="offer"
                                            DataValueField="offerid" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        Active:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="ui-widget">
                        <div class="ui-widget-header" title="Descriptive question text if different from question">
                            Question Plain Text
                        </div>
                        <div class="ui-widget-content" style="padding: 5px;">
                            <asp:TextBox ID="txtQuestionPlainText" runat="server" Rows="4" TextMode="MultiLine"
                                Width="99%" />
                        </div>
                    </div>
                    <div class="ui-widget">
                        <div class="ui-widget-header">
                            Question Answer Type</div>
                        <div class="ui-widget-content">
                            <table style="width: 100%">
                                <tr valign="top">
                                    <td align="right">
                                        Type:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlType" runat="server" Style="width: 99%;">
                                            <asp:ListItem Text="radio" />
                                            <asp:ListItem Text="label" />
                                            <asp:ListItem Text="checkbox" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr valign="top">
                                    <td align="right">
                                        Items:
                                    </td>
                                    <td>
                                        <asp:ListBox ID="lstOptions" runat="server" onclick="return FillTextbox(this);" Style="width: 99%;">
                                        </asp:ListBox>
                                        <asp:TextBox ID="txtAddOption" runat="server" TextMode="SingleLine" Width="180px" />
                                        <small>
                                            <button id="lnkAddOption" onclick="return AddToList(this);" class="jqAddButton">
                                                Add</button>
                                            <button id="lnkRemoveOption" onclick="return RemoveFromList(this);" class="jqDeleteButton">
                                                Remove
                                            </button>
                                        </small>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="tabs-2">
                    <div class="ui-widget">
                        <div class="ui-widget-header" title="View source to see HTML code">
                            Question HTML
                        </div>
                        <div class="ui-widget-content">
                            <textarea name="divquestion" class="editor" rows="5" id="divquestion"></textarea>
                        </div>
                    </div>
                </div>
                <div id="tabs-3">
                    <div class="ui-widget">
                        <div class="ui-widget-header">
                            Branch</div>
                        <div class="ui-widget-content">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        URL:
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtBranchUrl" runat="server" TextMode="MultiLine" Width="99%" Rows="2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Question Trigger Answer
                                        <img src="../images/tooltip.gif" alt="You can select a question answer to trigger the branch redirect." />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="ddlBranchResponse" runat="server" Width="99%" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="ui-widget">
                        <div class="ui-widget-header">
                            Pop</div>
                        <div class="ui-widget-content">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        Pop up URL:
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtPopup" runat="server" TextMode="MultiLine" Width="99%" Rows="2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Pop under URL:
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtPopunder" runat="server" TextMode="MultiLine" Width="99%" Rows="2" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </form>
    </div>
</asp:Content>
