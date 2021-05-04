﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SettlementVerbalAuth.aspx.vb" Inherits="CallControls_SettlementVerbalAuth" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settlement Verbal Authorization</title>
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
    
        function CloseRecording(finished, recid, approved) {
            var wnd = window.dialogArguments.parent;
          
            switch (finished) {
                case '1':
                    wnd.CompleteCallRecording(recid);
                    break;
                default:
                    wnd.stopRecording();
                    break;
            }

            var ret = new Object;
            ret.isApproved = recid;
            ret.RecId = approved;

            window.returnValue = finished;
            window.top.close();
            
        }
        
        function ConfirmAnswerNo() {
            if (confirm("Are you sure the answer to the current question is NO?")) {
                return true;
            } else {
            return false;
            }
        }
        
        
    </script>  
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
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
                            <tr><th class="header" >Page 4 - Let's Begin </th></tr>
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
                                        <%#Container.DataItem.ToString%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="footer">
                                        <asp:Button CssClass="btnYesGreen" ID="Button11" runat="server" Text="Yes" CommandName="Continue" CommandArgument='<%#Container.ItemIndex+1%>'  />
                                        <asp:Button CssClass="btnNoRed" ID="Button22" runat="server" Text="No" CommandName="AnsweredNo" CommandArgument='<%#Container.ItemIndex+1%>' OnClientClick="return ConfirmAnswerNo();" />
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
                            <tr><th class="header" >Completed Successfully</th></tr>
                            <tr>
                                <td class="question">
                                    <asp:Literal ID="ltrPage7" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnFinish" runat="server" Text="ACCEPT" BackColor="#336600" 
                                        Font-Bold="True" ForeColor="Yellow" />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage8" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Error</th></tr>
                            <tr>
                                <td class="question" style="color: Red;">
                                    <asp:Literal ID="ltrPage8" runat="server"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td class="footer"> 
                                    <asp:Button ID="btnClose" runat="server" Text="Close"  />
                                </td>
                            </tr>
                        </table> 
                    </td>
                 </tr>
                 <tr id="trPage9" runat="server">
                    <td>
                        <table class="formTable">
                            <tr><th class="header" >Aborted</th></tr>
                            <tr>
                                <td class="question" >
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
             <asp:HiddenField ID="hdnSettlementCallId" runat="server" />
             <asp:HiddenField ID="hdnIsPopup" runat="server"  Value="true" />
             <asp:HiddenField ID="hdnSettlementRecordedCallId" runat="server" />
            </ContentTemplate>
         </asp:UpdatePanel> 
    </div>
    </form>
</body>
</html>
