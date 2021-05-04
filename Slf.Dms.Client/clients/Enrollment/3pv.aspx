<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="3pv.aspx.vb" Inherits="Clients_Enrollment_3pv" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
   <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable">
            <tr>
                <td>
                    <img id="Img3" width="8" height="28" src="~/images/spacer.gif" runat="server" />
                </td>
                <td nowrap="nowrap">
                    <a id="aBack" class="menuButton" href="#" runat="server">
                        <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Back</a>
                </td>
                <td style="width: 100%;">
                    &nbsp;
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="0">
        <ProgressTemplate>
            <div class="dvQProgress">
                <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle"
                    alt="loading" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div style="height: 318px">
    <asp:ScriptManager runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <table>
                    <tr id="trPage0" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Select Language
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question" align="center">
                                        <asp:DropDownList ID="ddlLanguage" runat="server">
                                            <asp:ListItem Text="English" Value="1" Selected="True" />
                                            <asp:ListItem Text="Spanish" Value="2" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="BtnLanguage" runat="server" Text="Continue" CommandName="Continue"
                                            CommandArgument='0' />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage1" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Page 1 - Introduction
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage1" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button CssClass="btnYesGreen" ID="BtnYes1" runat="server" Text="Yes" CommandName="Continue"
                                            CommandArgument='1' />
                                        <asp:Button CssClass="btnNoRed" ID="BtnNo1" runat="server" Text="No" CommandName="AnsweredNo"
                                            CommandArgument='1' OnClientClick="return ConfirmAnswerNo();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage2" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Page 2 - Recording Consent
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage2" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button CssClass="btnYesGreen" ID="BtnYes2" runat="server" Text="Yes" CommandName="Continue"
                                            CommandArgument='2' />
                                        <asp:Button CssClass="btnNoRed" ID="BtnNo2" runat="server" Text="No" CommandName="AnsweredNo"
                                            CommandArgument='2' OnClientClick="return ConfirmAnswerNo();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage3" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Page 3 - Name and SSN Verification
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage3" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button CssClass="btnYesGreen" ID="BtnYes3" runat="server" Text="Yes" CommandName="Continue"
                                            CommandArgument='3' />
                                        <asp:Button CssClass="btnNoRed" ID="BtnNo3" runat="server" Text="No" CommandName="AnsweredNo"
                                            CommandArgument='3' OnClientClick="return ConfirmAnswerNo();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage4" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Page 4 - Begin Recording
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage4" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="BtnStartRecording" runat="server" Text="Continue" CommandName="Continue"
                                            CommandArgument='4' />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage5" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Page 5 - Questionnaire
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage5" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="btnStartQuestions" runat="server" Text="Continue" CommandName="Continue"
                                            CommandArgument='5' />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage6" runat="server">
                        <td>
                            <asp:Repeater ID="rptQuestions" runat="server">
                                <ItemTemplate>
                                    <table class="formTable">
                                        <tr>
                                            <th class="header">
                                                Page 6 - Question
                                                <%#Container.ItemIndex + 1%>
                                                of
                                                <%=Me.rptQuestions.Items.Count%>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td id="tdQuestion" class="question" runat="server">
                                                <%#GetQuestionText(Container.DataItem("QuestionText"))%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="footer">
                                                <asp:Button CssClass="btnYesGreen" ID="Button11" runat="server" Text="Yes" CommandName="Continue"
                                                    CommandArgument='<%#Container.DataItem("QuestionNo")%>' />
                                                <asp:Button CssClass="btnNoRed" ID="Button22" runat="server" Text="No" CommandName='<%#iif(Container.DataItem("FailWhenNo"),"AnsweredNo","ContinueWithNo") %>' 
                                                    CommandArgument='<%#Container.DataItem("QuestionNo")%>' OnClientClick='<%#iif(Container.DataItem("FailWhenNo"),"return ConfirmAnswerNo();","return true;") %>' />
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                    <tr id="trPage7" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Verification Completed Successfully
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage7" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="btnFinish" runat="server" Text="Finish" OnClientClick="alert ('Reminder: Please upload recording.');" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage8" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Verification Error
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question" style="color: Red;">
                                        <asp:Literal ID="ltrPage8" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <%--<asp:Button ID="btnClose" runat="server" Text="Close" OnClientClick="return CloseDialog('0');" />--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trPage9" runat="server">
                        <td>
                            <table class="formTable">
                                <tr>
                                    <th class="header">
                                        Verification Aborted
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage9" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <%--<asp:Button ID="btnCallTransfer" runat="server" Text="Close" OnClientClick="return CloseDialog('2');" />--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table style="width:600px; background-color:#4791c5; height:50px;margin-left:5px;">
                    <tr>
                        <td onclick="attachFile();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap"><a style="color:#fff">Click here to upload the recorded call and verification</a></td>
                    </tr>
                </table>
                <div id="attachStatus" style="padding:5px; color:Blue"></div>
                <asp:HiddenField ID="hdnCurrentQuestion" runat="server" />
                <asp:HiddenField ID="hdnVerificationCallId" runat="server" />
                <asp:HiddenField ID="hdnRepExt" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
    
        function attachFile() {
            var hdn = '';
            var url = '<%= ResolveUrl("~/util/pop/attachleaddoc.aspx?t=Attach File&docType=345&leadId=") %>' + getQueryValue('id');
            window.dialogArguments = new Array(window, hdn, "attachFileReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Attach File",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 350, width: 500
            });
        
        }

        function attachFileReturn() {
            document.getElementById('attachStatus').innerHTML = 'Recording uploaded!';
        }

        function getQueryValue(name) {
            var regex = new RegExp("[\?&]" + name + "=([^&#]*)");
            var results = regex.exec(window.location.href);
            if (results == null) {
                return "";
            } else {
                return results[1];
            }
        }
    
    </script>
    <style type="text/css">
        .formTable
        {
            border: solid 1px black;
            border-spacing: 0px;
            width: 600px;
        }
        .header
        {
            border: solid 1px black;
            padding: 10px 10px 10px 10px;
        }
        .question
        {
            border: solid 1px black;
            height: 200px;
            font-family: Tahoma;
            font-size: 12px;
            vertical-align: top;
            padding: 10px 10px 10px 10px;
            line-height: 2em;
        }
        .footer
        {
            border: solid 1px black;
            padding: 10px 10px 10px 10px;
        }
        .clientinfo
        {
            font-family: Tahoma;
            font-size: 11px;
            line-height: 1em;
            text-align: left;
        }
        .clientinfo th
        {
            text-align: left;
        }
        .dvQProgress
        {
            position: absolute;
            top: 10px;
            left: 10px;
        }
        .btnYesGreen
        {
            background-color: Green;
            color: Yellow;
            font-weight: bold;
        }
        .btnNoRed
        {
            background-color: red;
            color: White;
            font-weight: bold;
        }
    </style>
    <script type="text/javascript">
        function ConfirmAnswerNo() {
            if (confirm("Are you sure the answer to the current question is NO?")) {
                return true;
            } else {
                return false;
            }
        }
    </script>
</asp:Content>
