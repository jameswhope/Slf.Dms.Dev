<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CallVerification.aspx.vb" Inherits="CallControlsAst_CallVerification" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Call Verification</title>
    <style type="text/css" >
     body
        {
            font-family: Tahoma;
            font-size: 11px;
        }
     .formTable { border: solid 1px black; border-spacing: 0px; width: 600px; }
     .header{border: solid 1px black;  padding: 10px 10px 10px 10px; }
     .question{border: solid 1px black;  height: 200px; font-family: Tahoma; font-size: 12px; vertical-align: top; padding: 10px 10px 10px 10px; line-height:  2em; }
     .footer{border: solid 1px black; padding: 10px 10px 10px 10px;}
     .clientinfo{font-family: Tahoma; font-size: 11px; line-height:  1em; text-align: left; }
     .clientinfo th {text-align: left;}
     .dvQProgress{position:absolute; top: 10px; left: 10px; }
     .btnYesGreen{ background-color: Green; color: Yellow; font-weight:bold;} 
     .btnNoRed{ background-color: red; color: White; font-weight:bold;}     
    </style>
   
    <script type="text/javascript" >
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
            var recArgs = { "type": "verification",
                "path": path,
                "filename": filename
            };
            wnd.StartRecordingInPath(recArgs, function() { document.getElementById('<%= lnkCreateVerification.ClientId%>').click(); });
        }

        function StopRecording(finished) { 
            var wnd = window.top.parent;
            var recArgs = {
                "type": "verification",
                "personid": "<%= GetPersonId() %>", 
                "persontype": "<%= GetPersonType() %>", 
                "callid": $('#<%=hdnCallId.ClientId %>').val(),
                "referenceid": $('#<%=hdnVerificationCallId.ClientID %>').val(),
                "completed": finished};
            wnd.StopRecording(recArgs);
        }

        function CloseDialog(finished) {
            StopRecording(finished);
            window.parent.closeVerifDialog(finished);
        }
        
    </script>  
</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="~/jquery/json2.js"  />
        </Scripts> 
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="0">
    <ProgressTemplate>
        <div class="dvQProgress">
           <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
        </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
        <div style="height: 318px">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional"  >
         <ContentTemplate> 
             <table>
                <tr id="trPage0" runat="server" >
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Select Language</th></tr>
                            <tr>
                                <td class="question" align="center"  >
                                    <asp:DropDownList ID="ddlLanguage" runat="server">
                                        <asp:ListItem Text="English" Value="1"  Selected="True" />
                                        <asp:ListItem Text="Spanish" Value="2"   />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="BtnLanguage" runat="server" Text="Continue" CommandName="Continue" CommandArgument='0'  />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage1" runat="server" >
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Page 1 - Introduction</th></tr>
                            <tr>
                                <td class="question"  >
                                    <asp:Literal ID="ltrPage1" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button CssClass="btnYesGreen" ID="BtnYes1" runat="server" Text="Yes" CommandName="Continue" CommandArgument='1'  />
                                    <asp:Button CssClass="btnNoRed" ID="BtnNo1" runat="server" Text="No" CommandName="AnsweredNo" CommandArgument='1' OnClientClick="return ConfirmAnswerNo();"  />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage2" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Page 2 - Recording Consent</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage2" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button CssClass="btnYesGreen" ID="BtnYes2" runat="server" Text="Yes" CommandName="Continue" CommandArgument='2'  />
                                    <asp:Button CssClass="btnNoRed" ID="BtnNo2" runat="server" Text="No" CommandName="AnsweredNo" CommandArgument='2' OnClientClick="return ConfirmAnswerNo();" />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage3" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Page 3 - Name and SSN Verification</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage3" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button CssClass="btnYesGreen" ID="BtnYes3" runat="server" Text="Yes" CommandName="Continue" CommandArgument='3'  />
                                    <asp:Button CssClass="btnNoRed" ID="BtnNo3" runat="server" Text="No" CommandName="AnsweredNo" CommandArgument='3' OnClientClick="return ConfirmAnswerNo();" />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage4" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Page 4 - Begin Recording</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage4" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="BtnStartRecording" runat="server" Text="Continue" CommandName="Continue" CommandArgument='4'  />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage5" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Page 5 - Questionnaire</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage5" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnStartQuestions" runat="server" Text="Continue" CommandName="Continue" CommandArgument='5'  />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage6" runat="server">
                    <td> 
                         <asp:Repeater ID="rptQuestions" runat="server">
                         <ItemTemplate >
                            <table class="formTable">
                                <tr><th class="header" >Page 6 - Question <%#Container.ItemIndex + 1%> of <%=Me.rptQuestions.Items.Count%></th></tr>
                                <tr>
                                    <td id="tdQuestion" class="question" runat="server">
                                        <%#GetQuestionText(Container.DataItem("QuestionText"))%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button CssClass="btnYesGreen" ID="Button11" runat="server" Text="Yes" CommandName="Continue" CommandArgument='<%#Container.DataItem("QuestionNo")%>'  />
                                        <asp:Button CssClass="btnNoRed" ID="Button22" runat="server" Text="No" CommandName='<%#iif(Container.DataItem("FailWhenNo"),"AnsweredNo","ContinueWithNo") %>' CommandArgument='<%#Container.DataItem("QuestionNo")%>' OnClientClick='<%#iif(Container.DataItem("FailWhenNo"),"return ConfirmAnswerNo();","return true;") %>' />
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
                            <tr><th class="header" >Verification Completed Successfully</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage7" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnFinish" runat="server" Text="Finish" OnClientClick="return CloseDialog('1');"/>
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage8" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Verification Error</th></tr>
                            <tr>
                                <td class="question" style="color: Red;">
                                    <asp:Literal ID="ltrPage8" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnClose" runat="server" Text="Close" OnClientClick="return CloseDialog('');" />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage9" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Verification Aborted</th></tr>
                            <tr>
                                <td class="question" >
                                    <asp:Literal ID="ltrPage9" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnCallTransfer" runat="server" Text="Close" OnClientClick="return CloseDialog('');" />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
             </table> 
             <asp:HiddenField ID="hdnCurrentQuestion" runat="server" />
             <asp:HiddenField ID="hdnVerificationCallId" runat="server" />
             <asp:HiddenField ID="hdnCallId" runat="server" />
             <asp:HiddenField ID="hdnRecording" runat="server" />
             <asp:HiddenField ID="hdnRepExt" runat="server" />
             <asp:LinkButton ID="lnkCreateVerification" runat="server"></asp:LinkButton>
            </ContentTemplate>
         </asp:UpdatePanel> 
    </div>
    </form>
</body>
</html>
