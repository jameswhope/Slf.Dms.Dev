<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SettlementVerbalAuth.aspx.vb"
    Inherits="CallControlsAst_SettlementVerbalAuth" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settlement Verbal Authorization</title>
    <style type="text/css">
        body
        {
            font-family: Tahoma;
            font-size: 11px;
        }
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
        
        .pmtContainer {
            width: 100%;
        }

        .pmtTable {
            width: 100%;
            height: 125px;
            overflow: auto;
            margin-left: auto;
            margin-right: auto;
            text-align: center;

        }
        
        .pmtrow {
            float: none;  
            width: 180px;
            border: .5px dotted #808080; 
            text-align: left;
            display: inline-block;
            padding: 0 0 0 0;
            margin: 0 0 0 0;
            background-color: #e7eff8;
        }

       
        .pmtposition {
            display: inline-block;
            text-align: right;
            width: 20px;
            padding-right: 5px;
            font-weight: bold;
         }

        .pmtamount {
            display: inline-block;
            text-align:right;
            width:70px;
            padding-right: 5px;
         }

        .pmtdate {
            display: inline-block;
            text-align:left;
            width: 61px;
            padding-left: 5px;
         }
    </style>

    <script type="text/javascript">
        try {
            var windowname = '';
            try { windowname = window.top.parent.name.toLowerCase(); }
            catch (e1) {
                document.domain = "dmsi.local";
                windowname = window.top.parent.name.toLowerCase(); 
            } 
          }
        catch (e) { }

        function ConfirmAnswerNo() {
            if (confirm("Are you sure the answer to the current question is NO?")) {
                return true;
            } else {
                return false;
            }
        }

        function pageLoad() {
            $(document).ready(function() {
                SetCallVars();
            });
        }

        function SetCallVars() {
            var wnd = window.top.parent;
            var callid = wnd.GetCurrentCallId();
            var isrecording = wnd.IsRecording();
            $('#<%=hdnCallId.ClientId %>').val(callid);
            $('#<%=hdnRecording.ClientId %>').val(isrecording);
        }

        function StartRecordingInPath(path, filename) {
            var wnd = window.top.parent;
            var recArgs = { "type": "settlement",
                "path": path,
                "filename": filename
            };
            wnd.StartRecordingInPath(recArgs, function() { document.getElementById('<%= lnkCreateRecording.ClientId%>').click(); });
        }

        function StopRecording(recid, approved) { 
            var wnd = window.top.parent;
            var recArgs = { "type": "settlement",
                "referenceid": $('#<%=hdnSettlementRecordedCallId.ClientId %>').val(),
                "clientid": $('#<%=hdnClientId.ClientId %>').val(),
                "matterid": "<%= GetSettMatterId() %>",
                "callid": $('#<%=hdnCallId.ClientId %>').val(),
                "recordingid": recid,
                "completed": approved
            };
            wnd.StopRecording(recArgs);
        }

        function CloseRecording(recid, approved) {
            StopRecording(recid, approved);
            window.parent.closeSettDialog(approved);
        }
        
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="~/jquery/json2.js" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="0">
        <ProgressTemplate>
            <div class="dvQProgress">
                <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div style="height: 318px">
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
                                        Page 4 - Let's Begin
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
                                                <%#Container.DataItem.ToString%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="footer">
                                                <asp:Button CssClass="btnYesGreen" ID="Button11" runat="server" Text="Yes" CommandName="Continue"
                                                    CommandArgument='<%#Container.ItemIndex+1%>' />
                                                <asp:Button CssClass="btnNoRed" ID="Button22" runat="server" Text="No" CommandName="AnsweredNo"
                                                    CommandArgument='<%#Container.ItemIndex+1%>' OnClientClick="return ConfirmAnswerNo();" />
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
                                        Completed Successfully
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage7" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="btnFinish" runat="server" Text="ACCEPT" BackColor="#336600" Font-Bold="True"
                                            ForeColor="Yellow" />
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
                                        Error
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question" style="color: Red;">
                                        <asp:Literal ID="ltrPage8" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="btnClose" runat="server" Text="Close" />
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
                                        Aborted
                                    </th>
                                </tr>
                                <tr>
                                    <td class="question">
                                        <asp:Literal ID="ltrPage9" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button ID="btnAborted" runat="server" Text="Close" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:HiddenField ID="hdnCurrentQuestion" runat="server" />
                <asp:HiddenField ID="hdnClientId" runat="server" />
                <asp:HiddenField ID="hdnMatterId" runat="server" />
                <asp:HiddenField ID="hdnCallId" runat="server" />
                <asp:HiddenField ID="hdnRecording" runat="server" />
                <asp:HiddenField ID="hdnIsPopup" runat="server" Value="true" />
                <asp:HiddenField ID="hdnSettlementRecordedCallId" runat="server" />
                <asp:LinkButton ID="lnkCreateRecording" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>
