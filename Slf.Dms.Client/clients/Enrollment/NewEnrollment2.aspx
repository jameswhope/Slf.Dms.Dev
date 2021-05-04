<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="NewEnrollment2.aspx.vb" Inherits="Clients_Enrollment_NewEnrollment2" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebToolbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<%@ Register src="../../CustomTools/UserControls/CalculatorModelControl.ascx" tagname="CalculatorModelControl" tagprefix="uc1" %>
<%@ Register src="../../CustomTools/UserControls/CalculatorModelControl2.ascx" tagname="CalculatorModelControl" tagprefix="uc2" %>
<%@ Register assembly="System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="System.Web.UI" tagprefix="cc2" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td nowrap="nowrap" id="tdSave" runat="server" style="padding-left: 5px;">
                    <igtbar:UltraWebToolbar ID="uwToolBar" runat="server">
                        <HoverStyle Cursor="Hand">
                        </HoverStyle>
                        <DefaultStyle Cursor="Hand">
                        </DefaultStyle>
                        <ButtonStyle Cursor="Hand">
                        </ButtonStyle>
                        <LabelStyle Cursor="Hand" />
                        <Items>
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_back.png"
                                SelectedImage="" Text="Home" Tag="back" DefaultStyle-CssClass="enrollmentMenuButton"
                                HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="50px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_web_home.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="50px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_person_add.png"
                                SelectedImage="" Text="New Applicant" Tag="new" DefaultStyle-CssClass="enrollmentMenuButton"
                                HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="95px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_person_add.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBCustom Width="100px">
                                <asp:Panel>
                                    <span class="enrollmentMenuButton" onclick="Save();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                        onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                        text-align: center; white-space:nowrap">
                                        <img align="absmiddle" style="margin: 0px;" src="../../images/16x16_save.png" alt="" />
                                        Save Applicant </span>
                                </asp:Panel>
                            </igtbar:TBCustom>
                            <igtbar:TBSeparator />
                            <igtbar:TBCustom Width="95px">
                                <asp:Panel>
                                    <span class="enrollmentMenuButton" onclick="Save(1);return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                        onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                        text-align: center; white-space:nowrap">
                                        <img align="absmiddle"  style="margin: 0px;" src="../../images/16x16_save_close.png" alt="" />
                                            Save & Close
                                    </span>
                                </asp:Panel>
                            </igtbar:TBCustom>
                            <igtbar:TBSeparator />
                            <igtbar:TBCustom ID="TBCustom1" runat="server" Key="Custom8" Width="100px">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="tblOptions" runat="server">
                                        <tr>
                                            <td  class="enrollmentMenuButton" onclick="generateLSA();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img align="absmiddle"  style="margin: 0px;" src="../../images/16x16_form_setup.png" alt="" />
                                                   Generate LSA
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <obo:Flyout ID="oboOptions" runat="server" AttachTo="tblOptions" Align="LEFT" Position="BOTTOM_CENTER"
                                    OpenTime="100" >
                                    <div class="entry2" style="background-color: #D6E7F3; width:150px;">
                                        <script language="javascript" type="text/javascript">
                                            function ClearLSAOptions() {
                                                var rdoLst = document.getElementsByName('ctl00$cphMenu$oboOptions$LSAOptions');
                                                for (var i = 0; i < rdoLst.length; i++) {
                                                    if (rdoLst[i].checked) document.getElementById(rdoLst[i].id).checked = false;
                                                }
                                            }
                                        </script>
                                        <table class="entry">
                                            <tr>
                                                <td style="background-color:#3376AB; height:25px; color:White; padding:2px; text-align:center;" >
                                                    LSA Options
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:CheckBox ID="chkElectronicLSA" runat="server" Text="Generate e-LSA" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:CheckBox ID="chkFormLetter" runat="server" Text="Add'l Cover Letter" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:RadioButton ID="chkVoidedCheck" runat="server" Text="Include Voided Check" GroupName="LSAOptions" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:RadioButton ID="chkOnlyScheduleA" runat="server" Text="Only Schedule A" GroupName="LSAOptions" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:RadioButton ID="chkOnlyVoidedCheck" runat="server" Text="Only Voided Check" GroupName="LSAOptions" />
                                                </td>
                                            </tr>
                                           <tr>
                                                <td>
                                                    <asp:RadioButton ID="chkOnlyTruthInServicesCheck" runat="server" Text="Only Truth In Services" GroupName="LSAOptions" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <a href="javascript:ClearLSAOptions();">Clear</a>
                                                </td>
                                            </tr>
                                        </table>
                            </div>
                                </obo:Flyout>
                            </igtbar:TBCustom>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="~/images/16x16_form_setup.png" HoverImage="" Image="~/images/16x16_form_setup.png"
                                SelectedImage="" Tag="generate" Text="Print Form" DefaultStyle-CssClass="enrollmentMenuButton"
                                HoverStyle-CssClass="enrollmentMenuButtonHover">
                                <Images>
                                    <DisabledImage Url="~/images/16x16_print.png" />
                                    <DefaultImage Url="~/images/16x16_print.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="80px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton Image="~/images/16x16_download.png" Text="Get Signed Docs" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="110px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_download.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="110px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <%--<igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="~/images/16x16_email_send.png" HoverImage="" Image="~/images/16x16_email_send.png"
                                SelectedImage="" Key="verificationemail" Tag="verificationemail" Text="Send Verification Email" DefaultStyle-CssClass="enrollmentMenuButton"
                                HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="135px" Visible="true">
                                <Images>
                                    <DisabledImage Url="~/images/16x16_email_send.png" />
                                    <DefaultImage Url="~/images/16x16_email_send.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="135px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>--%>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="~/images/16x16_file_remove.png" HoverImage="" Image="~/images/16x16_file_remove.png"
                                SelectedImage="" Key="switch" Tag="switch" Text="Switch Model" DefaultStyle-CssClass="enrollmentMenuButton"
                                HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="150px" Visible="False">
                                <Images>
                                    <DisabledImage Url="~/images/16x16_file_remove.png" />
                                    <DefaultImage Url="~/images/16x16_file_remove.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>  
                            <igtbar:TBCustom ID="tabAttachFile" runat="server" Key="Custom8" Width="75px" Visible="false">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table1" runat="server">
                                        <tr>
                                            <td  class="enrollmentMenuButton" onclick="attachFile();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img align="absmiddle"  style="margin: 0px;" src="~/images/11x16_paperclip.png" runat="server" alt="" />
                                                   Attach File
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>     
                            <igtbar:TBCustom ID="tab3PV" runat="server" Key="Custom8" Width="50px" Visible="false">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table2" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td id="tdVerificationCall" class="enrollmentMenuButton" onclick="do3PV();" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img id="Img2" align="absmiddle"  style="margin: 0px;" src="~/images/16x16_callout.png" runat="server" alt="" />
                                                   3PV
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>
                            <%--CHOLT 7/24/2020--%>
                            <igtbar:TBCustom ID="tabPrivicaUser" runat="server" Key="Custom8" Width="75px" Visible="true">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table6" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td id="privicaUser" class="enrollmentMenuButton" onclick="CreatePrivUser()" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                            <img id="Img4" align="absmiddle"  style="margin: 0px;" src="~/images/16x16_file_help.png" runat="server" alt="" />
                                                   PrivicaQA
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>
                            <%--CHOLT 9/15/2020--%>
                            <igtbar:TBCustom ID="tabPivicaSendVerification" runat="server" Key="Custom8" Width="100px" Visible="true">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table5" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td id="privicaSendVerification" class="enrollmentMenuButton" onclick="sendPrivFile();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                            <img id="Img6" align="absmiddle"  style="margin: 0px;" src="~/images/16x16_check.png" runat="server" alt="" />
                                                   ID's to Privica
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>
                            <%--CHOLT 9/15/2020--%>
                            <igtbar:TBCustom ID="TBCustom2" runat="server" Key="Custom8" Width="130px" Visible="true">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table7" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td id="privicaReSendCredEmail" class="enrollmentMenuButton" onclick="resendPrivEmail()" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                            <img id="Img7" align="absmiddle"  style="margin: 0px;" src="~/images/16x16_cancel3.png" runat="server" alt="" />
                                                   Re-send Privica Email
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>
                            <%--CHOLT 11/17/2020--%>
                            <igtbar:TBCustom ID="TBCustom3" runat="server" Key="Custom8" Width="170px" Visible="true">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table8" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td id="privicaSendBankVerification" class="enrollmentMenuButton" onclick="sendPrivBankVerification()" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                            <img id="Img3" align="absmiddle"  style="margin: 0px;" src="~/images/16x16_cancel3.png" runat="server" alt="" />
                                                   Send Privica Bank Verification
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel> 
                            </igtbar:TBCustom>
                            <igtbar:TBCustom ID="tabGenericPackage" runat="server" Key="Custom8" Width="110px">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table3" runat="server">
                                        <tr>
                                        <td>
                                                |
                                            </td>
                                            <td  class="enrollmentMenuButton" onclick="generateEPackage();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img align="absmiddle"  style="margin: 0px;" src="../../images/16x16_email_send.png" alt="" />
                                                   Email E-Package
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </igtbar:TBCustom>
                            <igtbar:TBCustom ID="tabCustomPackage" runat="server" Key="Custom8" Width="120px">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table4" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td class="enrollmentMenuButton" onclick="generateLeadPackage();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img align="absmiddle"  style="margin: 0px;" src="../../images/16x16_email_send.png" alt="" />
                                                   Email Lead Package
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </igtbar:TBCustom>                                               
                            <%--<igtbar:TBCustom ID="tabGlobalClients" runat="server" Key="Custom8" Width="90px">
                                <asp:Panel>
                                    <table cellpadding="0" cellspacing="0" width="100%" id="Table5" runat="server">
                                        <tr>
                                            <td>
                                                |
                                            </td>
                                            <td class="enrollmentMenuButton" onclick="redirectGlobalClients();return false;" onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                                            onmouseout="this.className='enrollmentMenuButton';" style="width: 100%; vertical-align: middle;
                                            text-align: center; white-space:nowrap">
                                                <img align="absmiddle"  style="margin: 0px;" src="../../images/16x16_people.png" alt="" />
                                                   Global Clients
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </igtbar:TBCustom>              --%>                                          
                        </Items>
                    </igtbar:UltraWebToolbar>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="smEnroll" runat="server" >
    </ajaxToolkit:ToolkitScriptManager>
     
    <style type="text/css">
        .graytxt {
             color:#999999;
             font-family:tahoma;
             font-size:11px;
             width:100%;
        }

        .window h2, .window h3{
            background-color:azure;
        }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        window.onload = function () {
            addIncomeTotal();
        };

        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode != 46 && charCode > 31
                && (charCode < 48 || charCode > 57))
                return false;

            return true;
        }

        var closinrecording = false;

        function do3PV() {
            window.location='3pv.aspx?id=' + getQueryValue('id');
            //alert("The call controls bar is not present.");
        }

        function dialog(message, yesCallback, noCallback) {
            $('.title').html(message);
            var dialog = $('#modal_dialog').dialog();
            modal_dialog.style.visibility = 'visible';
            $('#btnYes').click(function() {
                dialog.dialog('close');
                yesCallback();
            });
            $('#btnNo').click(function() {
                dialog.dialog('close');
                noCallback();
            });
        }

        function getConfirmation() {
            dialog("<b>Verbal Proof of Authorization Presentation Script</b> <br> <br> <span style='color:red;'><b>[Instructions]</b> <br/><br/>Before reading the following script to your client, please start your third party recording device. Speak clearly and allow your client time to think about their response. <br/><br/>More instructions will follow the script below, <b>read carefully</b>.<br/><br/><b>[Start Recording] <br/> [Script Start – Read this to client]</b> </span><br/><br/>"+ $("#<%=txtFirstName.Clientid %>").val() +" "+ $("#<%=txtLastName.Clientid %>").val() +", I am required to inform you that this call is being recorded. In order to pull your credit report, I am required to record and save your authorization to pull your credit report. I would like to start by verifying your information. <br/><br/>Please state your full name: <br/><br/>Please state your full address including city, state, and zip code. <br/><br/>Please state the last four digits of your social security number <br/><br/>Thank you<br/><br/>The credit report that we will obtain will be a soft pull, which will not affect your credit report. The credit report will only be used for the permissible purpose of conducting a financial counseling session. Your credit report will not be used for any lending decision, the extension of credit, or employment purposes and will not be shared with anyone else. <br/><br/>Do you give us permission to obtain your credit report for the permissible purpose of conducting a financial counseling session?  <br/><br/><span style='color:red;'> <b>[Script End – Stop reading to client and follow instructions]<br/> [Stop Recording] </b> <br/><br/><b>[Instructions]</b><br/><br/>Your client has now answered that they “Accept” or “Refuse”. Please end the recording and deposit the file into the <b><i>“Credit Report Authorization”</i></b> folder on your desktop. <br/><br/>Now select the client’s choice using the clickable buttons below. </span><br/><br/>", function() {Confirm_Agreement_Load()}, function() {   });
        }


        function Confirm_Agreement_Load()
        {
            document.body.style.cursor = 'wait';
            <%= ClientScript.GetPostBackEventReference(lnkCreditReport, Nothing) %>;
        }

        function doVerificationCall(){
            if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                $('#dvVerifVerbal').dialog("open");
            } else {
                alert("Call controls not present.");
            }
           return false;
        }
        
        function attachFile() {
            var hdn = '';
            var url = '<%= ResolveUrl("~/util/pop/attachleaddoc.aspx?t=Attach File&leadId=") %>' + getQueryValue('id');
            window.dialogArguments = new Array(window, hdn, "attachFileReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Attach File",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 350, width: 500
            });
        }

        function sendPrivFile() {
            var hdn = '';
            var url = '<%= ResolveUrl("~/util/pop/sendiddoc.aspx?t=Send ID Document&leadId=") %>' + getQueryValue('id');
                    window.dialogArguments = new Array(window, hdn, "attachFileReturn");
                    currentModalDialog = $('<div/>').appendTo("body").modaldialog({
                        url: url,
                        title: "Send File",
                        dialogArguments: window,
                        resizable: false,
                        scrollable: false,
                        height: 350, width: 500
                    });
                }

        function attachFileReturn() {
            document.getElementById("<%= btnDocsRefresh.ClientID() %>").click();
        }
		
        function generateEPackage() {
            var validateEPackage = '<%= ValidateEPackage() %>'
            if (validateEPackage === '') {document.getElementById("<%=lnkEmailEPackage.ClientID() %>").click();}
            else {alert(validateEPackage);}
            
        }
        function generateLeadPackage() {            
            var validateLeadPackage = '<%= ValidateLeadPackage() %>'
            if (validateLeadPackage === '') {document.getElementById("<%=lnkEmailLeadPackage.ClientID() %>").click();}
            else {alert(validateLeadPackage);}
            
        }
        function redirectGlobalClients() {
            window.location = "http://service.lexxiom.com/globaltransfer.aspx"
        }

        function pageLoad(){
        
            $(document).ready(function () {
                
                var ssntxt = $(".txtSSN");
                checkSSN(ssntxt.val());
                
                ssntxt.focusout(
                    function(event){
                    event.preventDefault();
                    checkSSN($(this).val());
                });

                var Phonetxt = $(".txtPhone");
                
                Phonetxt.focusout(
                    function(event){
                    event.preventDefault();
                    checkPhone($(this).val());
                });
                
                $("#<%=txtFName.ClientID %>").focusout(function (event){
                     event.preventDefault();
                    $("#<%=txtFirstName.clientid %>").val($(this).val());
                                           });
                                           
                $("#<%=txtMName.ClientID %>").focusout(function (event){
                    event.preventDefault();
                    $("#<%=txtMiddleName.clientid %>").val($(this).val());
                                           });
                                        
                $("#<%=txtLName.ClientID %>").focusout(function (event){
                    event.preventDefault();
                    $("#<%=txtLastName.clientid %>").val($(this).val());});               
               
                /*btnSplitName.tooltip({ content: "Click button to update Primary Names",
                                             position: {my: "top", at: "bottom+15"} });*/
                                             
                if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx'))
                {
                    $("#dvVerifVerbal").dialog({width: "670", height: "400 !important",
                                    closeOnEscape: false,
                                    autoOpen: false,
                                    modal: true,
                                    resizable: false,
                                    open: function(event, ui) {
                                        $("#ifrVerifVerbal").attr("src", '<%= ResolveUrl("~/CallControlsAst/CallVerification.aspx?leadid=")%>' + getQueryValue('id') + '&rand=' + Math.floor(Math.random() * 99999)); 
                                        },
                                    close: function(){ 
                                        if (!closinrecording){
                                            $("#ifrVerifVerbal").get(0).contentWindow.StopRecording('');
                                        }
                                        $("#ifrVerifVerbal").attr("src","");
                                        closinrecording = false;
                                        }});
               
                    $('#<%= tdVerificationCall.ClientId%>').removeAttr('onclick')
                       .unbind('click')
                       .click(function(){
                            doVerificationCall();
                   });
                } else {
                    $("#dvVerifVerbal").hide();
                }                             
                                             
                if (window.top.parent.name.toLowerCase() == 'freepbx')
                {   
                    //FreePBX
                    var callid = window.top.parent.getCurrentCall().GetCallId();
                    var leadcallid = $('#<%=hdnCIDDialerCallMadeId.ClientID %>').val();
                    var leadid = "<%= GetLeadId() %>";
                    if (callid && !leadcallid){
                        window.top.parent.PreConnectCall(leadid, $(this));
                    }
                    
                   $('#<%= tdVerificationCall.ClientId%>').removeAttr('onclick')
                       .unbind('click')
                       .click(function(){
                            doVerificationCall();
                   });
                }   
                
                if (window.top.parent.name.toLowerCase() == 'vicidial_window')
                {
                    $('#tbAppointments').hide();
                    //ViciDial
                    var leadid = "<%= GetLeadId() %>";
                    if (leadid && leadid > 0) {
                        window.top.parent.ValidateConnectedLeadCall(leadid, "<%= VicidialGlobals.ViciLeadSource.ToUpper %>", $(this)); 
                    }                
                }    
                
                //$("#mnuCreditReport").menu({position: {my:'left top',at:'left bottom+3'}});  
                
                $("#mnuCreditReport li").first().hover(
                function(){$(this).children("ul").show();}, 
                function(){$(this).children("ul").hide();});   

            });
            
        }
        
        function closeVerifDialog(approved){
            if ((window.top.parent.name.toLowerCase() == 'vicidial_window') || (window.top.parent.name.toLowerCase() == 'freepbx')){
                if (!closinrecording) {
                    closinrecording = true;
                    $("#dvVerifVerbal").dialog("close");
                    SaveAndNoEndPage();
                 }
             }
        }

        function checkPhone(Phone){
            clientExistsByPhone(Phone);
        }

        function clientExistsByPhone(Phone){
             var LeadPhone = Phone.replace(/[^0-9]/g,'');
             if (LeadPhone.length > 0){
                 var dArray = "{'Phone': '" + Phone + "', 'LeadId': '<%= GetLeadID() %>', 'UserId': '<%= GetUserID() %>'}";

                $.ajax({
                    type: "POST",
                    url: '<%= ResolveURL("~/services/ajaxservice.asmx/IsDuplicatePhone")%>',
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        duplicatePhoneWarning(response.d);
                        if (response.d === "1") {
                            doPhonenDuplicationPopUp(Phone, <%= GetLeadID() %>);
                        }
                    },
                    error: function (response) {
                       alert(response.responseText);
                    }
                });
             }  else  {
                duplicatePhoneWarning("0");
             }
        }
        
        
        function duplicatePhoneWarning(isDup){
            var lbl = $("#lblPhone");
            var td = lbl.closest("td");
            $("span.dupphone").remove(); // ????
            if (isDup == "1") {              
                td.append("<span class='badge dupphone' title='Duplicate. The " + lbl.text().replace(/:/g,"") + " is already present on a existing client'>Dup</span>");
                $("span.dupphone").tooltip({position: {my: "top", at: "bottom+15"}});
            }        
        }

        function doPhonenDuplicationPopUp(Phone, LeadId){
            var url = '<%= ResolveUrl("~/util/pop/findDuplicatePhone.aspx")%>?phone=' + Phone + '&lid=' + LeadId;
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Find Duplicate Leads",
                dialogArguments: window,
                resizable: false,
                scrollable: true,
                height: 650, width: 900,
                onClose: function(){
                    var results = $(this).modaldialog("returnValue");
                    if (results != undefined){
                        window.location = results;
                    }                    
                }
            });
        }
        
        function checkSSN(SSN){
            toggleSSNLabel(SSN);
            clientExists(SSN);
        }
        
        function toggleSSNLabel(SSN){
            if (SSN.length > 0){
                if (SSN.substring(0,1) == "9"){
                    $("#lblSSN").text("ITIN:");
                } else {
                    $("#lblSSN").text("SSN:");
                } 
            }
        }
        
        function clientExists(SSN){
             SSN = SSN.replace(/ /gi,"").replace(/-/gi,"").replace(/_/gi,"");
             if (SSN.length > 0){
                 var dArray = "{'SSN': '" + SSN + "', 'LeadId': '<%= GetLeadID() %>'}";

                $.ajax({
                    type: "POST",
                    url: '<%= ResolveURL("~/services/ajaxservice.asmx/IsDuplicateSSN")%>',
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        duplicateSSNWarning(response.d);
                    },
                    error: function (response) {
                       alert(response.responseText);
                    }
                });
             }  else  {
                duplicateSSNWarning("0");
             }
        }
        
        
        function duplicateSSNWarning(isDup){
            var lbl = $("#lblSSN");
            var td = lbl.closest("td");
            $("span.dupssn").remove();
            if (isDup == "1") {              
                td.append("<span class='badge dupssn' title='Duplicate. The " + lbl.text().replace(/:/g,"") + " is already present on a existing client'>Dup</span>");
                $("span.dupssn").tooltip({position: {my: "top", at: "bottom+15"}});
            }        
        }
        
        function splitLeadName(fullname){
             if (fullname.length > 0){
                 var dArray = "{'Fullname': '" + fullname + "'}";

                $.ajax({
                    type: "POST",
                    url: '<%= ResolveURL("~/services/ajaxservice.asmx/SplitLeadName")%>',
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        $("#<%=txtFName.clientid %>").val(response.d.FullName);
                        $("#<%=txtFirstName.clientid %>").val(response.d.FirstName);
                        $("#<%=txtLastName.clientid %>").val(response.d.LastName);
                    },
                    error: function (response) {
                       alert(response.responseText);
                    }
                });
             }  
        }
        
        function Save(close)
        {
            var ddl = document.getElementById('<%=ddlStatus.ClientID %>');
            var clientId = document.getElementById('<%=hdnClientID.ClientID %>').value;
            var status = ddl.options[ddl.selectedIndex].text;
            var btn;
            
            if (close) {
                btn = document.getElementById('<%=lnkSaveAndClose.ClientID %>');
            }
            else {
                btn = document.getElementById('<%=lnkSave.ClientID %>');
            }
            
            if (status == 'In Process') {
                if (confirm('Confirmation needed: In Process will transfer this lead to Verification. Click OK to confirm, Cancel to select a different status.')) {
                    btn.click();
                }
            }
            else if (status == 'No Sale' && clientId > 0) {
                if (confirm('Confirmation Needed: No Sale will cancel this client in Lexxware. Click OK to confirm, Cancel to select a different status.')) {
                    btn.click();
                }
            }
            else {
                btn.click();
            }
        }
        
        function SaveAndNoEndPage()
        {
            var btn = document.getElementById('<%=btnSaveAndNoEndPage.ClientID %>');
            btn.click();
        }
        
        function SaveAndLoadPickup(CallIdKey,RemoteAddress)
        {
            var btn = document.getElementById('<%=btnSaveAndNoEndPage.ClientID %>');
            document.getElementById('<%=hdnCallIdKey.ClientID %>').value = CallIdKey;
            document.getElementById('<%=hdnAni.ClientID %>').value = RemoteAddress;
            btn.click();
        }
        
        function SaveAndRedirect(url)
        {
            document.getElementById('<%=hdnRedirectTo.ClientID %>').value = url;
            var btn = document.getElementById('<%=lnkSaveAndRedirect.ClientID %>');
            btn.click();
        }
        
        var EstimatedEndAmount = 0;
    	
        function FindCreditor(creditor,street,street2,city,stateid,zipcode)
        {
            var hdn = document.getElementById('<%=hdnCreditorInfo.ClientID %>');
            var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx")%>?creditor=' + creditor + '&street=' + escape(street) + '&street2=' + escape(street2) + '&city=' + city + '&stateid=' + stateid + '&zipcode=' + zipcode;
            window.dialogArguments =  new Array(window, hdn, "CreditorFinderReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 700, width: 650
            });    
        }
        function FindForCreditor(creditor,street,street2,city,stateid,zipcode)
        {
            var hdn = document.getElementById('<%=hdnForCreditorInfo.ClientID %>');
            var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx")%>?creditor=' + creditor + '&street=' + escape(street) + '&street2=' + escape(street2) + '&city=' + city + '&stateid=' + stateid + '&zipcode=' + zipcode;
            window.dialogArguments =  new Array(window, hdn, "ForCreditorFinderReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 700, width: 650
            });            
        }
        function CreditorFinderReturn(hdn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
        {
            hdn.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
            <%= ClientScript.GetPostBackEventReference(btnCreditorRefresh, Nothing) %>;
        }   
        function ForCreditorFinderReturn(hdn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
        {
            hdn.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
            <%= ClientScript.GetPostBackEventReference(btnForCreditorRefresh, Nothing) %>;
        }      
        function AddCreditors()
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = '-1';
            FindCreditor('','','','',-1,'');
        }
        function AddForCreditor(creditorInstanceID)
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = creditorInstanceID;
            FindForCreditor('','','','',-1,'');
        }
        function EditCreditor(creditorInstanceID,creditor,street,street2,city,stateid,zipcode)
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = creditorInstanceID;
            FindCreditor(creditor,street,street2,city,stateid,zipcode);
        }
        function EditForCreditor(creditorInstanceID,creditor,street,street2,city,stateid,zipcode)
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = creditorInstanceID;
            FindForCreditor(creditor,street,street2,city,stateid,zipcode);
        }
        function RemoveCreditor(id)
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = id;
                    document.getElementById("<%=btnRemoveCreditor.ClientID() %>").click();

        }        
        
        function AddBanks()
        {
            if (!document.getElementById("<%= lnkAddBanks.ClientID() %>").disabled){
                var url = 'addbank.aspx?id=' + getQueryValue('id') + '&md=' + Math.floor(Math.random()*99999);
                OpenBanks( url, "Add Banking Information");
            }
        }
        function EditBank(bankID)
        {
            var url = 'addbank.aspx?bID=' + bankID  + '&md=' + Math.floor(Math.random()*99999);
            OpenBanks( url, "Edit Banking Information");
        }
        
        function OpenBanks( url, title){
                window.dialogArguments = window;
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: title,
                    dialogArguments: window,
                    resizable: false,
                    scrollable: false,
                    height: 700, width: 500,
                    onClose: function(){
                        document.getElementById("<%= btnBankRefresh.ClientID() %>").click();
                    }
                }); 
        }
        
        function RemoveBank(id)
        {
            document.getElementById("<%=hdnLeadBankID.ClientID %>").value = id;
            document.getElementById("<%=btnRemoveBank.ClientID() %>").click();
        }        
        
        function AddCoApps()
        {
            if (!document.getElementById("<%= lnkAddCoApps.ClientID() %>").disabled){
                var url = '<%= ResolveUrl("addcoap.aspx") %>?id=' + getQueryValue('id') + '&md=' + Math.floor(Math.random()*99999);
                OpenCoApps(url, "Add Co-Applicant");
            }
        }
        function EditCoApp(coappID)
        {
            var url = '<%= ResolveUrl("addcoap.aspx") %>?cID=' + coappID  + '&md=' + Math.floor(Math.random()*99999);
            OpenCoApps(url, "Edit Co-Applicant");
        }
        
        function OpenCoApps( url, title){
                window.dialogArguments = window;
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: title,
                    dialogArguments: window,
                    resizable: false,
                    scrollable: false,
                    height: 700, width: 400,
                    onClose: function(){
                        document.getElementById("<%= btnCoAppRefresh.ClientID() %>").click();
                    }
                }); 
        }
        function RemoveCoApp(id)
        {
            document.getElementById("<%=hdnLeadCoApplicantID.ClientID %>").value = id;
            document.getElementById("<%=btnRemoveCoApp.ClientID() %>").click();
        }        
        
        function AddNotes()
        {
            if (!document.getElementById("<%= lnkAddNotes.ClientID() %>").disabled){
                var url = '<%= ResolveUrl("~/Clients/Enrollment/addnote.aspx") %>?id=' + getQueryValue('id')  + '&md=' + Math.floor(Math.random()*99999);
                OpenNotes(url, "Add Note");
            }
        }
        function EditNote(noteID)
        {
            var url = '<%= ResolveUrl("~/Clients/Enrollment/addnote.aspx") %>?nID=' + noteID + '&md=' + Math.floor(Math.random() * 99999);
             OpenNotes(url, "Edit Note");
        }
        
        function OpenNotes( url, title){
                window.dialogArguments = window;
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: title,
                    dialogArguments: window,
                    resizable: false,
                    scrollable: false,
                    height: 700, width: 400,
                    onClose: function(){
                        document.getElementById("<%= btnNotesRefresh.ClientID() %>").click();
                    }
                }); 
        }
        
        function getQueryValue( name ) {    
            var regex = new RegExp( "[\?&]"+name+"=([^&#]*)" );
            var results = regex.exec( window.location.href );    
            if( results == null){
                return "";    
            }else        {
                return results[1];
            }
        }
        
        function MonthsToYears(Value){
            return Math.floor(Value / 12) + " yrs " + Math.round(Value % 12) + " mo";
        }

        function ddlLeadSource_onchange(ddl)
        {
            var source = ddl.options[ddl.selectedIndex].text;
            
            if (source == 'Paper Lead' || source == 'Radio' || source == 'TV')
                document.getElementById('<%=trPaperLeadCode.ClientID %>').style.display = '';
            else
                document.getElementById('<%=trPaperLeadCode.ClientID %>').style.display = 'none';
        }
        
        function ddlHardship_onchange(ddl)
        {
            var source = ddl.options[ddl.selectedIndex].text;
            
            if (source == 'Other')
                document.getElementById('<%=trHardshipOther.ClientID %>').style.display = '';
            else
                document.getElementById('<%=trHardshipOther.ClientID %>').style.display = 'none';
        } 
        
        function generateLSA() {
            document.getElementById("<%=lnkGenerate.ClientID() %>").click();
        }
        
         function calluser(phonenumber, leadid) {
            window.top.parent.MakeLeadOutboundCall(leadid, phonenumber);
        }
        
        function disconnectleadcall(){
            window.top.parent.Hangup();
            SaveAndNoEndPage();
        }
        
        function singleDot(txt, e) {
            var digits = '0123456789';
            var cmds = 'acxvz';
            if ((e.shiftKey == true) ||
                    (txt.value.indexOf('.') != -1 && (e.keyCode == 190 || e.keyCode == 110)) ||
                    (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
                return false;
            else
                return true;
        }
        
        function IsSpecialKey(keyCode) {
            if (keyCode == 190 || keyCode == 110 || keyCode == 8 || keyCode == 9 || keyCode == 13 || keyCode == 45 || keyCode == 46 || (keyCode > 16 && keyCode < 21) || (keyCode > 34 && keyCode < 41) || (keyCode > 95 && keyCode < 106))
                return true;
            else
                return false;
        }
        
        function FormatAmount(txt)
        {
            txt.value = FormatNumber(parseFloat(txt.value), false, 2);
        }
         
        function closePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
        }
        
        function closeAppPopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior2');
            modalPopupBehavior.hide();
        }
        
        function AddAppointment(leadId)
        {
            if (!document.getElementById("<%= lnkAddAppointment.ClientID() %>").disabled){
                var url = '<%= ResolveUrl("addappointment.aspx")%>?aid=-1&lid=' + getQueryValue('id') + '&md=' + Math.floor(Math.random()*99999);
                OpenAppointment(url, "Add Appointment");
            }
        }
        function EditAppointment(appointmentid)
        {
            var url = '<%= ResolveUrl("addappointment.aspx")%>?aid=' + appointmentid  + '&md=' + Math.floor(Math.random()*99999);
            OpenAppointment(url, "Edit Appointment");
        }
        
        function OpenAppointment( url, title){
                window.dialogArguments = window;
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: title,
                    dialogArguments: window,
                    resizable: false,
                    scrollable: false,
                    height: 650, width: 350,
                    onClose: function(){
                        document.getElementById("<%= btnAppointmentRefresh.ClientID() %>").click();
                    }
                }); 
        }
        
        function RemoveAppointment(AppointmentID)
        {
            if (confirm("Are you sure you want to cancel this appointment?"))
            { 
                document.getElementById("<%=hdnAppointmentID.ClientID %>").value = AppointmentID;
                document.getElementById("<%=btnRemoveAppointment.ClientID() %>").click();
                document.getElementById("<%= btnAppointmentRefresh.ClientID() %>").click();
            } 
        }   
        
        function leaddisconnect(resultid)
        {
            var updstatus = document.getElementById('<%=hdnLeadAutoUpdateStatus.ClientID %>');
            updstatus.value = '1';
            if (resultid == 5 || resultid == 6){
                if (!confirm("Do you want to change status to bad lead?") ){
                    updstatus.value = '0';
                }
            }
            document.getElementById('<%=hdnLeadDisconnectType.ClientID %>').value =  resultid;
            var btn = document.getElementById('<%=lnkLeadDisconnectType.ClientID %>');
            btn.click();
        }
        
        function MakeAppointmentCall()
        {
            var CallMadeId = document.getElementById('<%=hdnCIDDialerCallMadeId.ClientID %>').value;
            if (CallMadeId > 0) {
                closeAppPopup();
                parent.make_call_ciddialer(CallMadeId);
            }
        }
        
        function SetLeadDisposition(dispocode) {
            window.top.parent.GetLeadStatusReasons(dispocode, 
                    function(statusid, reasonid){
                        $("#<%=hdnViciLeadDispoStatus.ClientId%>").val(statusid);
                        $("#<%=hdnViciLeadDispoReason.ClientId%>").val(reasonid);
                        //$("#<%=lnkViciLeadDisposition.ClientId%>").click();
                        var btn = document.getElementById('<%=lnkViciLeadDisposition.ClientID %>');
                        btn.click();
                    });
        }
        /*CHOLT 7/24/2020*/
        function CreatePrivUser() { 
            document.body.style.cursor = 'wait';
            document.getElementById("<%=lnkPrivicaQA.ClientID()%>").click();
        }

        /*CHOLT 10/5/2020*/
        function privicaQASubmitCursor() {
            document.body.style.cursor = 'wait';
        }

        /*CHOLT 9/24/2020*/
        function resendPrivEmail() { 
            document.body.style.cursor = 'wait';
            document.getElementById("<%=lnkPrivicaResendEmail.ClientID()%>").click();
        }

        /*CHOLT 11/17/2020*/
        function sendPrivBankVerification() {
            document.body.style.cursor = 'wait';
            document.getElementById("<%=lnkPrivicaSendBankVerification.ClientID()%>").click();
        }

        function privCounter() {
            var minute = 4;
            var sec = 59;
            var id = setInterval(function () {
                document.getElementById("privTime").innerHTML = minute + " : " + sec;
                sec--;
                if (sec == 00) {
                    minute--;                    
                    if (minute == 0 && sec == 00) {
                        clearInterval(id);
                        document.getElementById("privTime").innerHTML = "Time is up! Please submit ID's Instead.";                        
                    }
                    else {
                        sec = 59;
                    }
                }
            }, 1000);
        }

        function addIncomeTotal() {
            document.getElementById('<%= txtIncome.ClientID %>').value = 0;
            var num1 = document.getElementById('<%= txtWorkIncome.ClientID %>').value;
            num1 = parseFloat(num1.replace(/\,/g, ''));
            var num2 = document.getElementById('<%= txtSSIncome.ClientID %>').value;
            num2 = parseFloat(num2.replace(/\,/g, ''));
            var num3 = document.getElementById('<%= txtDisability.ClientID %>').value;
            num3 = parseFloat(num3.replace(/\,/g, ''));
            var num4 = document.getElementById('<%= txtSavChecking.ClientID %>').value;
            num4 = parseFloat(num4.replace(/\,/g, ''));
            var num5 = document.getElementById('<%= txt401K.ClientID %>').value;
            num5 = parseFloat(num5.replace(/\,/g, ''));
            var num6 = document.getElementById('<%= txtRetirePen.ClientID %>').value;
            num6 = parseFloat(num6.replace(/\,/g, ''));
            var num7 = document.getElementById('<%= txtUnemployment.ClientID %>').value;
            num7 = parseFloat(num7.replace(/\,/g, ''));
            var num8 = document.getElementById('<%= txtSelfEmployed.ClientID %>').value;
            num8 = parseFloat(num8.replace(/\,/g, ''));
            var num9 = document.getElementById('<%= txtOtherAssets.ClientID %>').value;
            num9 = parseFloat(num9.replace(/\,/g, ''));
            var num10 = document.getElementById('<%= txtOtherDebts.ClientID %>').value;
            num10 = parseFloat(num10.replace(/\,/g, ''));
            var num11 = document.getElementById('<%= txtHomePrinciple.ClientID %>').value;
            num11 = parseFloat(num11.replace(/\,/g, ''));
            var num12 = document.getElementById('<%= txtHomeValue.ClientID %>').value;
            num12 = parseFloat(num12.replace(/\,/g, ''));
            

            var total = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10 + num11 + num12;
            document.getElementById('<%= txtIncome.ClientID %>').value = parseFloat(total).toFixed(2);
        }

    </script>
        <div id='modal_dialog' style="visibility:hidden;">
            <div class='title'>
            </div>
        <input type='button' value='I AGREE' id='btnYes' />
        <input type='button' value='I REFUSE' id='btnNo' />
    </div>
    <%--CHOLT 7/24/2020 --%>
    <div id="privicaQApop" visible="False" runat="server" style="position:absolute; z-index:3; height:250px; width:350px; background-color:#e3e3e3; text-align:left; margin-left:550px; margin-right:auto; margin-top:150px; margin-bottom:auto; border:solid; border-width:thin;">
        <div style="border-bottom: medium; background-color: #a3d3ff; width: 350px; border-bottom: solid; border-width:thin;">Privica QA</div>    
        <div>Time remaining: <span id="privTime"></span> </div>
        <br />
        <label id="PrivQ1" for="PrivQ1Answers" runat="server"></label>
        <br />
            <select id="PrivQ1Answers" name="PrivQ1A">
              <option value="0" id="PrivQ1A0" runat="server"></option>
              <option value="1" id="PrivQ1A1" runat="server"></option>
              <option value="2" id="PrivQ1A2" runat="server"></option>
              <option value="3" id="PrivQ1A3" runat="server"></option>
              <option value="4" id="PrivQ1A4" runat="server"></option>
              <option value="5" id="PrivQ1A5" runat="server"></option>
            </select>
        <br />
        <label id="PrivQ2" for="PrivQ2Answers" runat="server"></label>
        <br />
            <select id="PrivQ2Answers" name="PrivQ2A">
              <option value="0" id="PrivQ2A0" runat="server"></option>
              <option value="1" id="PrivQ2A1" runat="server"></option>
              <option value="2" id="PrivQ2A2" runat="server"></option>
              <option value="3" id="PrivQ2A3" runat="server"></option>
              <option value="4" id="PrivQ2A4" runat="server"></option>
              <option value="5" id="PrivQ2A5" runat="server"></option>
            </select>
        <br />
        <label id="PrivQ3" for="PrivQ3Answers" runat="server"></label>
        <br />
            <select id="PrivQ3Answers" name="PrivQ3A">
              <option value="0" id="PrivQ3A0" runat="server"></option>
              <option value="1" id="PrivQ3A1" runat="server"></option>
              <option value="2" id="PrivQ3A2" runat="server"></option>
              <option value="3" id="PrivQ3A3" runat="server"></option>
              <option value="4" id="PrivQ3A4" runat="server"></option>
              <option value="5" id="PrivQ3A5" runat="server"></option>
            </select>
        <br />
        <label id="PrivQ4" for="PrivQ4Answers" runat="server"></label>
        <br />
            <select id="PrivQ4Answers" name="PrivQ4A">
              <option value="0" id="PrivQ4A0" runat="server"></option>
              <option value="1" id="PrivQ4A1" runat="server"></option>
              <option value="2" id="PrivQ4A2" runat="server"></option>
              <option value="3" id="PrivQ4A3" runat="server"></option>
              <option value="4" id="PrivQ4A4" runat="server"></option>
              <option value="5" id="PrivQ4A5" runat="server"></option>
            </select>
        <br />
        <label id="PrivQ5" for="PrivQ5Answers" runat="server"></label>
        <br />
            <select id="PrivQ5Answers" name="PrivQ5A">
              <option value="0" id="PrivQ5A0" runat="server"></option>
              <option value="1" id="PrivQ5A1" runat="server"></option>
              <option value="2" id="PrivQ5A2" runat="server"></option>
              <option value="3" id="PrivQ5A3" runat="server"></option>
              <option value="4" id="PrivQ5A4" runat="server"></option>
              <option value="5" id="PrivQ5A5" runat="server"></option>
            </select>
        <br />
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:LinkButton id="PrivQASubmit" OnClientClick="privicaQASubmitCursor(); return true;" runat="server">Submit</asp:LinkButton>
    </div>
    <div style="text-align: center;">
        <div id="divMsg" runat="server" style="display: none; background-color: #FFFF99;
            border: thin solid #FF0000; font-family: tahoma; font-size: 11px; font-weight: bold;
            width: 40%;">
        </div>
    </div>
    <table runat="server" id="tblBody" class="enrollment_body">
        <tr>
            <td>
                <igmisc:WebGroupBox ID="wgbVerification" runat="server" Text="Verification Submitted" TitleAlignment="Left" Visible="false">
                    <Template>
                        <div>
                            <table>
                                <tr>
                                    <td style="font-size: 15px; text-align:right">
                                        Access Number:
                                    </td>
                                    <td id="tdAccessNum" runat="server" style="font-size: 15px; font-weight: bold; color: Green;" nowrap="nowrap">
                                        888-888-8888
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Image id="ImgMakeCall3PV" runat="server" ImageUrl="~/images/phone2.png" ToolTip ="Call" style="cursor:hand"/> 
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-size: 15px; padding-top:3px; text-align:right">
                                        Verification Code:
                                    </td>
                                    <td id="tdPVN" runat="server" style="font-size: 15px; font-weight: bold; color: Green; padding-top:3px;" nowrap="nowrap">
                                        12345
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Image id="ImgDialVerification" runat="server" ImageUrl="~/images/p_dialpad.png" ToolTip ="Dial Code" style="cursor:hand"/> 
                                        <asp:Image id="ImgAddClient" runat="server" ImageUrl="~/images/16x16_phone_add.png" ToolTip ="Join Client" style="cursor:hand"/> 
                                        <asp:Image id="ImgDialStar" runat="server" ImageUrl="~/images/16x16_selector_next.png" ToolTip ="Dial *" style="cursor:hand"/> 
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-size: 15px; text-align:right" nowrap="nowrap">
                                        Confirmation #:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtVerConfNum" runat="server" Font-Size="15px" ForeColor="Green" Font-Bold="true" Width="110px" BorderStyle="Solid"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </Template>
                </igmisc:WebGroupBox>
                <asp:Label ID="lblKeyword" runat="server" Style="color: Blue"></asp:Label>
            </td>
            <td>
            
            </td>
            <td style="text-align: right">
                <asp:Label ID="lblLastSave" runat="server" Style="color: #666666;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table width="100%">
                    <tr>
                        <td valign="top">
                            <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                DataSourceID="ds_leaddocuments">
                                <Columns>
                                    <asp:BoundField DataField="DocumentName" HeaderText="LSA Document"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="Submitted" HeaderText="Submitted" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="SubmittedBy" HeaderText="Submitted By" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="SignatoryEmail" HeaderText="Sent To" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:TemplateField>
                                        <HeaderStyle CssClass="DocHeader" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="DocItem" />
                                        <HeaderTemplate>
                                            Current Status
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#SetCurrentStatus(Eval("DocumentId"), Eval("CurrentStatus"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Completed" HeaderText="Completed" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="ds_leaddocuments" runat="server" SelectCommand="stp_enrollment_leaddocuments_griddisplay"
                                SelectCommandType="StoredProcedure" ConnectionString="<%$ AppSettings:connectionstring %>">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="LeadApplicantID" DbType="Int32" QueryStringField="id" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br/>
                            <!--Second Grid-->
                            <asp:GridView ID="gvAllDocuments" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                DataSourceID="ds_leaddocuments2">
                                <Columns>
                                    <asp:BoundField DataField="DocumentName" HeaderText="Documents" ItemStyle-ForeColor="#000"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="Submitted" HeaderText="Submitted" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" ItemStyle-ForeColor="#000" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="SubmittedBy" HeaderText="Submitted By" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" ItemStyle-ForeColor="#000" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:TemplateField>
                                        <HeaderStyle CssClass="DocHeader" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="DocItem" ForeColor="#000" />
                                        <HeaderTemplate>
                                            File
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#ViewDocument(Eval("documentid"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:BoundField DataField="Completed" HeaderText="Completed" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />--%>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="ds_leaddocuments2" runat="server" SelectCommand="stp_enrollment_leaddocuments_griddisplay2"
                                SelectCommandType="StoredProcedure" ConnectionString="<%$ AppSettings:connectionstring %>">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="LeadApplicantID" DbType="Int32" QueryStringField="id" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                        <td valign="top" align="right">
                            <asp:GridView ID="gvVerification" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                DataSourceID="ds_leadverification" Visible="false">
                                <Columns>
                                    <asp:BoundField DataField="StartDate" HeaderText="3PV Submitted" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="DocHeader" ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="SubmittedBy" HeaderText="Submitted By" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" HeaderStyle-HorizontalAlign="Left" />
                                    <asp:BoundField DataField="Completed" HeaderText="Completed" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Recording" HeaderText="Recording" HeaderStyle-CssClass="DocHeader"
                                        ItemStyle-CssClass="DocItem" ItemStyle-HorizontalAlign="Center" />
                                    <asp:TemplateField HeaderText="Doc" HeaderStyle-CssClass="DocHeader">
                                        <ItemTemplate>
                                            <a id="aRecDoc" href="#" title="Click to view" runat="server" target="_blank" >
                                                <img id="imgRecDoc" runat="server" style="border-width: 0px;" />
                                            </a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Rec" HeaderStyle-CssClass="DocHeader">
                                        <ItemTemplate>
                                            <a id="aRecFile" href="#" runat="server" target="_blank">
                                                <img id="ImgRec" runat="server" style="border-width: 0px;" />
                                            </a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="DocHeader">3PV not found.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="ds_leadverification" runat="server" SelectCommand="select StartDate, u.FirstName + ' ' + u.LastName [SubmittedBy], case when Completed = 1 then 'Y' else 'N' end [Completed], case when RecordedCallPath is not null then 'Y' else 'N' end [Recording], RecordedCallPath, DocumentPath, RecCallIdKey
                                                                                                        from tblVerificationCall v
                                                                                                        join tblUser u on u.UserID = v.ExecutedBy
                                                                                                        where LeadApplicantID = @LeadApplicantID
                                                                                                        order by StartDate desc"
                                SelectCommandType="Text" ConnectionString="<%$ AppSettings:connectionstring %>">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="LeadApplicantID" DbType="Int32" QueryStringField="id" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
         	<td></td>
         	<td>
                <div id="dvConnectCall"></div>
            </td>
            <td nowrap="nowrap" id="tdDialerResults" runat="server" style="padding-left: 5px;">
                <div id="dvCIDResults" runat="server" style="display:inline;background-color: Silver; border: solid 1px grey; padding: 1px 1px 1px 1px; ">
                    <asp:Repeater ID="rptCIDDailerResults" runat="server">
                        <ItemTemplate>
                            <img src="<%# ResolveUrl(DataBinder.Eval(Container.DataItem, "ImgIconPath")) %>"
                                alt="<%#DataBinder.Eval(Container.DataItem, "Result")%>" title="<%#DataBinder.Eval(Container.DataItem, "Description")%>"
                                style="cursor: hand; padding-left: 3px; padding-bottom: 2px; padding-top: 3px; padding-right: 2px;" onmouseout="this.style.background = '';" onmouseover="this.style.background = 'gray';"  onclick="leaddisconnect('<%#DataBinder.Eval(Container.DataItem, "LeadResultTypeId")%>');" />
                        </ItemTemplate>
                        <SeparatorTemplate>
                            &nbsp;
                        </SeparatorTemplate>
                    </asp:Repeater>
                    <asp:HiddenField ID="hdnLeadDisconnectType" runat="server" />
                    <asp:HiddenField ID="hdnLeadAutoUpdateStatus" runat="server" />
                    <asp:LinkButton ID="lnkLeadDisconnectType" runat="server"></asp:LinkButton>
                    <asp:HiddenField ID="hdnViciLeadDispoStatus" runat="server" />
                    <asp:HiddenField ID="hdnViciLeadDispoReason" runat="server" />
                    <asp:LinkButton ID="lnkViciLeadDisposition" runat="server"></asp:LinkButton>
                  </div>
             </td>
        </tr>
        <tr><td colspan="4" style="background-color:red; color:white; text-align:center;"><h2>Fitzgerald Law Corporation</h2></td></tr>
        <tr>
            <td valign="top">
                <table class="window">
                    <tr>
                        <td colspan="2">
                            <h2>
                                Lead
                            </h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Source
                        </td>
                        <td align="right">
                            <asp:Label ID="lblLeadSrc" runat="server" TabIndex="2"></asp:Label>
                        </td>
                    </tr>
                     <tr>
                        <td>
                            Campaign
                        </td>
                        <td align="right">
                            <asp:Label ID="lbCampaignSrc" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">First Name</font>
                        </td>
                        <td align="right">
                            <asp:TextBox TabIndex="1" CssClass="entry" runat="server" ID="txtFName" Width="150px"
                                BackColor="Gold" reqSave="True" valCap="Lead Name" />
                            <%--<div id="btnSplitName" style="width: 16px; height: 16px; padding: 0px 0px 0px 0px; display: inline" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Middle Name
                        </td>
                        <td align="right">
                            <asp:TextBox TabIndex="1" CssClass="entry" runat="server" ID="txtMName" Width="150px"
                                BackColor="Gold" reqSave="True" valCap="Lead Name" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">Last Name</font>
                        </td>
                        <td align="right">
                            <asp:TextBox TabIndex="1" CssClass="entry" runat="server" ID="txtLName" Width="150px"
                                BackColor="Gold" reqSave="True" valCap="Lead Name" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">Phone</font>
                        </td>
                        <td align="right">
                            <igtxt:WebMaskEdit TabIndex="2" ID="txtPhone" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold"
                                ReadOnly="False" CssClass="txtPhone">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                            </igtxt:WebMaskEdit>
                            <img id="ImgMakeCall" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtPhone.ClientId%>').value, '<%= GetLeadId()%>');" style="cursor:hand" /> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">Zip Code</font>
                        </td>
                        <td align="right">
                            <asp:TextBox TabIndex="3" reqSave="True" valCap="Lead phone number" valFun="IsZipCode"
                                CssClass="entry" runat="server" ID="txtSZip" Width="150px" BackColor="Gold" AutoPostBack="true"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table class="window">
                    <tr>
                        <td colspan="3">
                            <h2>
                                Hardship Info</h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Occupation
                        </td>
                        <td>                            
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" ID="txtOccupation" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td height="20">
                            <font color="red">Behind</font>
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlBehind" runat="server" CssClass="entry" TabIndex="4" Width="150px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Concerns
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlConcerns" runat="server" CssClass="entry" TabIndex="5" Width="150px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">Hardship</font>
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlHardship" runat="server" CssClass="entry" TabIndex="6" Width="150px"
                                onchange="javascript:ddlHardship_onchange(this);">
                                <asp:ListItem Text=""></asp:ListItem>
                                <asp:ListItem Text="Divorce"></asp:ListItem>
                                <asp:ListItem Text="Death of spouse"></asp:ListItem>
                                <asp:ListItem Text="Loss of job"></asp:ListItem>
                                <asp:ListItem Text="Unable to keep up"></asp:ListItem>
                                <asp:ListItem Text="Raised Int/Mthly pymt"></asp:ListItem>
                                <asp:ListItem Text="Cut in hours"></asp:ListItem>
                                <asp:ListItem Text="Medical Hardship"></asp:ListItem>
                                <asp:ListItem Text="Other"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trHardshipOther" runat="server" style="display: none">
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" ID="txtHardshipOther" Width="150px"
                                TabIndex="6" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Own/Rent
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlOwnRent" runat="server" CssClass="entry" TabIndex="7" Width="150px">
                                <asp:ListItem Text=""></asp:ListItem>
                                <asp:ListItem Text="Own"></asp:ListItem>
                                <asp:ListItem Text="Rent"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Num of Kids In House
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtKids" Width="150px"
                                TabIndex="8" Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Num of Grand Kids in House
                        </td>
                        <td>                            
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtGrandKids" Width="150px"
                                TabIndex="8" Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Owe on home
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" runat="server" ID="txtHomePrinciple" Width="150px"
                                TabIndex="8" Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Home Value
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtHomeValue" Width="150px" TabIndex="8"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Ret/401K
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txt401K" Width="150px" TabIndex="8"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Sav/Checking
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtSavChecking" Width="150px" TabIndex="9"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Other Assets
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtOtherAssets" Width="150px" TabIndex="10"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Other Debts
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtOtherDebts" Width="150px" TabIndex="11"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Work Income
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtWorkIncome" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Disability Income
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtDisability" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Social Security Income
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtSSIncome" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Retirement/Pension
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtRetirePen" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unempolyment Income
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtUnemployment" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>  
                    <tr>
                        <td>
                            Self Empolyed Income
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onfocusout="javascript:return addIncomeTotal()" onkeypress="return isNumberKey(event)" ID="txtSelfEmployed" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="red">Total Monthly Income</font>
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" ReadOnly="true" runat="server" ID="txtIncome" Width="150px" TabIndex="12"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <%--<tr>
                        <td colspan="3">
                        <fieldset>
                        <legend style="color:Red">Income Type (Check Applicable)</legend>
                            <asp:CheckBoxList ID="cblHardshipIncome" runat="server" CssClass="entry2" RepeatDirection="Horizontal"
                                RepeatColumns="2" RepeatLayout="Table" />
                                </fieldset>
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="3" style="height: 25px">
                            <b>How much is spent a month on:</b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            a. Groceries
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtGroceries" Width="150px" TabIndex="13"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            b. Car Ins.
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtCarIns" Width="150px" TabIndex="14"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            c. Health Ins.
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtHealthIns" Width="150px" TabIndex="15"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            d. Utilities
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtUtilities" Width="150px" TabIndex="16"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            e. Phone/Cell
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtPhoneBill" Width="150px" TabIndex="17"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            f. Home Ins.
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtHomeIns" Width="150px" TabIndex="18"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            g. Car Pymts
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtCarPymt" Width="150px" TabIndex="19"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            h. Auto Fuel
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtAutoFuel" Width="150px" TabIndex="20"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            i. Dining Out
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtDiningOut" Width="150px" TabIndex="21"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            j. Entertainment
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtEntertainment" Width="150px"
                                TabIndex="22" Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            k. House/Rent
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtHousePymt" Width="150px" TabIndex="22"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            l. Other
                        </td>
                        <td>
                            $
                        </td>
                        <td>
                            <asp:TextBox CssClass="entry" runat="server" onkeypress="return isNumberKey(event)" ID="txtOtherMthly" Width="150px" TabIndex="22"
                                Style="text-align: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Debt-to-Income
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:Label ID="lblDebtToIncome" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                <span style="float: left">Notes</span> <a id="lnkAddNotes" runat="server" class="lnk"
                                    href="javascript:AddNotes();">
                                    <img id="Img5" style="margin-right: 5;" src="~/images/16x16_Note.png" runat="server"
                                        border="0" align="absmiddle" />Add Notes</a></h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Quick Note:<br />
                            <asp:TextBox ID="txtQuickNote" runat="server" BorderStyle="Solid" Font-Names="Tahoma"
                                Font-Size="11px" Height="50px" HorizontalAlign="Justify" Width="99%" TextMode="MultiLine"></asp:TextBox>
                            <igtbl:UltraWebGrid ID="wGrdNotes" runat="server" DataSourceID="dsNotes" Browser="Xml"
                                DataKeyField="LeadNoteID">
                                <Bands>
                                    <igtbl:UltraGridBand RowSelectors="No" DataKeyField="LeadNoteID" AllowSorting="No">
                                        <Columns>
                                            <igtbl:UltraGridColumn Width="50px" BaseColumnName="NoteType" DataType="System.String"
                                                Hidden="True">
                                                <Header Caption="Type">
                                                </Header>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Width="50px" BaseColumnName="Created" DataType="System.DateTime"
                                                Format="MM/dd/yy hh:mm:ss"> <%--cholt--%>
                                                <Header Caption="Date">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle Width="50px" VerticalAlign="Top">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Width="190px" BaseColumnName="Value" Type="HyperLink" CellMultiline="Yes">
                                                <Header Caption="Notes">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle Wrap="True" Height="20px">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn DataType="System.Int32" HTMLEncodeContent="True" Hidden="True"
                                                BaseColumnName="LeadApplicantID">
                                                <Header Caption="LeadApplicatantNo">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn DataType="System.Int32" HTMLEncodeContent="True" Hidden="True"
                                                BaseColumnName="LeadNoteID">
                                                <Header Caption="LeadNoteID">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                        </Columns>
                                        <RowStyle TextOverflow="Ellipsis" />
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" Version="4.00" AllowSortingDefault="Yes"
                                    AutoGenerateColumns="False" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                    BorderCollapseDefault="Collapse" RowSelectorsDefault="No">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <Pager AllowPaging="false">
                                    </Pager>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" ColorBottom="LightGray" StyleBottom="Solid"
                                            WidthBottom="1px" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsNotes" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getNotes"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="applicantID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
            <td valign="top">
                <table class="window">
                    <tr>
                        <td>
                            <h3>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <b>Creditors</b>
                                        </td>
                                        <td align="right" style="white-space:nowrap;">
                                            <a id="lnkAddCreditors" runat="server" class="lnk" href="javascript:AddCreditors();">
                                                <img style="margin-right: 5;" src="~/images/16x16_trust.png" runat="server" border="0"
                                                    align="absmiddle" />Add Creditor</a>
                                            <span id="spanCredSep" runat="server" visible="false">&nbsp;|&nbsp;</span>
                                            <asp:LinkButton ID="lnkCreditReport" runat="server" CssClass="lnk" Visible="True"  href="javascript:getConfirmation();">
                                                <img style="margin-right:5px;" src="~/images/16x16_creditcardplus.png" runat="server" border="0"
                                                    align="absmiddle" />Get Credit Report
                                            </asp:LinkButton>
                                            <a id="aImportCreditors" runat="server" class="lnk" visible="false" href="#">
                                                <img style="margin-right: 5;" src="~/images/16x16_creditcardarrow.png" runat="server"
                                                    border="0" align="absmiddle" />Import Creditors </a>
                                            <span id="spanCredSep2" runat="server" visible="false">&nbsp;|&nbsp;</span>  
                                       </td>     
                                       <td id="tdReport" runat="server" style="white-space: nowrap; width: 100px;" >
                                            <asp:Literal ID="aViewReport" runat="server"></asp:Literal>
                                       </td>     
                                    </tr>
                                </table>
                            </h3>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <igtbl:UltraWebGrid ID="wGrdCreditors" runat="server" Browser="Xml" DataSourceID="dsCreditors"
                                DataKeyField="LeadCreditorInstance">
                                <Bands>
                                    <igtbl:UltraGridBand RowSelectors="No" AllowSorting="No" AllowDelete="No" AllowUpdate="No"
                                        DataKeyField="LeadCreditorInstance" BaseTableName="tblLeadCreditorInstance">
                                        <Columns>
                                            <igtbl:TemplatedColumn Width="16px">
                                                <CellTemplate>
                                                    <a href='javascript:RemoveCreditor(<%#DataBinder.Eval(Container.DataItem, "LeadCreditorInstance")%>);'
                                                        title="Remove Creditor">
                                                        <img runat="server" src="~/images/16x16_delete.png" style="border-style: none" /></a>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:UltraGridColumn Width="190px" BaseColumnName="Creditor">
                                                <Header Caption="Current Creditor">
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle Wrap="True">
                                                </CellStyle>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:TemplatedColumn Width="125px">
                                                <Header Caption="Account #">
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellTemplate>
                                                    <asp:TextBox ID="txtAccountNo" runat="server" CssClass="creditortxt" Text='<%# Bind("AccountNumber") %>'
                                                        TabIndex="99"></asp:TextBox>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:TemplatedColumn Width="70px" BaseColumnName="Balance">
                                                <Header Caption="Balance">
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellTemplate>
                                                    <asp:TextBox ID="txtBalance" runat="server" CssClass="creditortxt" Text='<%# Bind("Balance", "{0:N0}") %>'
                                                        Style="text-align: right" TabIndex="99"></asp:TextBox>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadCreditorInstance" DataType="System.Int32">
                                                <Header Caption="LeadCreditorInstance">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:TemplatedColumn Width="45px" BaseColumnName="IntRate">
                                                <Header Caption="APR">
                                                </Header>
                                                <CellTemplate>
                                                    <asp:TextBox ID="txtIntRate" runat="server" CssClass="creditortxt" Text='<%# Bind("IntRate", "{0:N2}") %>'
                                                        Style="text-align: right" TabIndex="99"></asp:TextBox>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:TemplatedColumn Width="75px" BaseColumnName="MinPayment">
                                                <Header Caption="Min Pymt">
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellTemplate>
                                                    <asp:TextBox ID="txtMinPayment" runat="server" CssClass="creditortxt" Text='<%# Bind("MinPayment", "{0:N0}") %>'
                                                        Style="text-align: right" TabIndex="99"></asp:TextBox>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="Street">
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="Street2">
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="City">
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="StateID">
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="ZipCode">
                                            </igtbl:UltraGridColumn>
                                        </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AllowSortingDefault="Yes"
                                    AutoGenerateColumns="False" HeaderClickActionDefault="SortSingle" AllowDeleteDefault="No"
                                    BorderCollapseDefault="Collapse">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsCreditors" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getCreditors"
                                SelectCommandType="StoredProcedure" DeleteCommand="stp_enrollment_deleteCreditor"
                                DeleteCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="applicantID" Type="Int32" />
                                </SelectParameters>
                                <DeleteParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Name="creditorInstanceID" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table class="window2" id="tblCalc">
                            <tr>
                                <td>
                                    <h2>
                                        <span style="float: left">Settlement Estimate Calculator</span> <span style="float: right">
                                        </span>
                                   </h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <uc2:CalculatorModelControl ID="CalculatorModelControl1" runat="server" HideAcctPanel="false"  />
                                </td>
                            </tr>
                        </table>
                        <div id="updateCalcModelDiv" style="display: none; height: 40px; width: 40px">
                            <img id="imgLoading" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                            <font style="font-weight: normal">Calculating..</font>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeCalcModel" BehaviorID="CalcModelanimation"
                    runat="server" TargetControlID="updatePanel1">
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
                </ajaxToolkit:UpdatePanelAnimationExtender>


                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                <font color="#3CB371">Banking Information</font></h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a id="lnkAddBanks" runat="server" class="lnk" href="javascript:AddBanks();">
                                <img style="margin-right: 5;" src="~/images/16x16_scale.png" runat="server" border="0"
                                    align="absmiddle" />Add Banking Information</a>
                                                
                            <igtbl:UltraWebGrid ID="wGrdBanking" runat="server" Browser="Xml" DataKeyField="leadbankid"
                                DataSourceID="dsBanks">
                                <Bands>
                                    <igtbl:UltraGridBand DataKeyField="leadbankid" RowSelectors="No" AllowAdd="No" AllowDelete="No"
                                        AllowUpdate="No" AllowSorting="No">
                                        <Columns>
                                            <igtbl:TemplatedColumn Width="16px">
                                                <CellTemplate>
                                                    <a href='javascript:RemoveBank(<%#DataBinder.Eval(Container.DataItem, "LeadBankID")%>);'
                                                        title="Remove Bank">
                                                        <img runat="server" src="~/images/16x16_delete.png" style="border-style: none" /></a>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:UltraGridColumn Width="189px" BaseColumnName="BankName">
                                                <Header Caption="Bank">
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Width="85px" BaseColumnName="RoutingNumber">
                                                <Header Caption="Routing #">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <CellStyle HorizontalAlign="Center">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="AccountNumber" Width="85px">
                                                <Header Caption="Account #">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <CellStyle HorizontalAlign="Center">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Checking" Key="Checking" DataType="System.Boolean">
                                                <Header Caption="Check/Save">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadBankID" DataType="System.Int32">
                                                <Header Caption="LeadBankID">
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                        </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AutoGenerateColumns="False"
                                    AllowSortingDefault="Yes" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                    BorderCollapseDefault="Collapse">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <Pager AllowPaging="false">
                                    </Pager>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsBanks" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getBanks"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="applicantID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
                <table class="window">
                    <tr>
                        <td>
                            <h3>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <b>Email Communication</b>
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="btnSendFollowup" runat="server" Visible="false">
                                                <img style="margin-right: 5;" src="~/images/16x16_email.png" runat="server"
                                                    border="0" align="absmiddle" /><asp:Label ID="lblFollowup" runat="server" Text="Send Follow Up"></asp:Label></asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </h3> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="gvLeadEmails" runat="server" AutoGenerateColumns="false" DataSourceID="ds_LeadEmails" BorderWidth="0" BorderStyle="None">
                                <Columns>
                                    <asp:BoundField DataField="type" HeaderText="Type" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" ItemStyle-Width="65px" />
                                    <asp:BoundField DataField="datesent" HeaderText="Sent" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="dateread" HeaderText="Read" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" DataFormatString="{0:d}" ItemStyle-Width="55px" />
                                    <asp:BoundField DataField="dateunsubscribed" HeaderText="Unsubscribed" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="unsubscribereason" HeaderText="Reason" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col2" ItemStyle-Width="162px" />
                                </Columns>
                                <EmptyDataTemplate>
                                    None
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="ds_LeadEmails" runat="server" SelectCommandType="StoredProcedure" SelectCommand="stp_enrollment_getEmails" ConnectionString="<%$ AppSettings:connectionstring %>">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="LeadApplicantID" QueryStringField="id" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
            <td valign="top">
                <table class="window">
                    <tr>
                        <td colspan="2">
                            <h2>
                                Primary (<img id="imgVer" runat="server" src="~/images/16x16_blue_check_dis.png" align="middle" style="margin-top:-3px" alt="" title="Verification not complete" />)
                            </h2>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">Prefix:</font>
                        </td>
                        <td>
                            <asp:DropDownList TabIndex="23" CssClass="entry2" runat="server" ID="ddlPrefix">
                                <asp:ListItem Text=""></asp:ListItem>
                                <asp:ListItem Text="Mr."></asp:ListItem>
                                <asp:ListItem Text="Ms."></asp:ListItem>
                                <asp:ListItem Text="Mrs."></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">FirstName:</font>
                        </td>
                        <td>
                            <asp:TextBox TabIndex="23" CssClass="entry" runat="server" ID="txtFirstName" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            MiddleName:
                        </td>
                        <td>
                            <asp:TextBox TabIndex="23" CssClass="entry" runat="server" ID="txtMiddleName" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">LastName:</font>
                        </td>
                        <td>
                            <asp:TextBox TabIndex="24" CssClass="entry" runat="server" ID="txtLastName" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">Address:</font>
                        </td>
                        <td>
                            <asp:TextBox TabIndex="25" CssClass="entry" runat="server" ID="txtAddress" Width="150px"
                                BackColor="Gold"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">City:</font>
                        </td>
                        <td>
                            <asp:TextBox TabIndex="26" CssClass="entry" runat="server" ID="txtCity" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">State/Zip:</font>
                        </td>
                        <td>
                            <asp:DropDownList TabIndex="27" CssClass="entry" runat="server" ID="cboStateID" Width="50px">
                            </asp:DropDownList>
                            <asp:TextBox CssClass="entry" runat="server" TabIndex="27" ID="txtZip" Width="97px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371"><label id="lblHomePhone">Home Ph:</label></font>
                        </td>
                        <td>
                            <igtxt:WebMaskEdit TabIndex="28" ID="txtHomePhone" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                <ButtonsAppearance>
                                    <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonStyle>
                                    <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonDisabledStyle>
                                </ButtonsAppearance>
                            </igtxt:WebMaskEdit>
                            <img id="ImgMakeCallH" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtHomePhone.ClientId%>').value, '<%= GetLeadId()%>');" style="cursor:hand" /> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Business Ph:
                        </td>
                        <td>
                            <igtxt:WebMaskEdit TabIndex="29" ID="txtBusPhone" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                <ButtonsAppearance>
                                    <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonStyle>
                                    <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonDisabledStyle>
                                </ButtonsAppearance>
                            </igtxt:WebMaskEdit>
                            <img id="ImgMakeCallB" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtBusPhone.ClientId%>').value, '<%= GetLeadId()%>');" style="cursor:hand" /> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Cell Ph:
                        </td>
                        <td>
                            <igtxt:WebMaskEdit TabIndex="30" ID="txtCellPhone" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                <ButtonsAppearance>
                                    <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonStyle>
                                    <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonDisabledStyle>
                                </ButtonsAppearance>
                            </igtxt:WebMaskEdit>
                            <img id="ImgMakeCallC" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtCellPhone.ClientId%>').value, '<%= GetLeadId()%>');" style="cursor:hand" /> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Fax Number:
                        </td>
                        <td>
                            <igtxt:WebMaskEdit TabIndex="31" ID="txtFaxNo" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="150px" InputMask="(###) ###-####" BackColor="Gold">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                <ButtonsAppearance>
                                    <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonStyle>
                                    <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonDisabledStyle>
                                </ButtonsAppearance>
                            </igtxt:WebMaskEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371"><label id="lblSSN">SSN:</label></font>
                        </td>
                        <td>
                            <igtxt:WebMaskEdit TabIndex="32" ID="txtSSN" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Height="20px" Width="150px" InputMask="###-##-####" BackColor="Gold" CssClass="txtSSN" >
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                <ButtonsAppearance>
                                    <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonStyle>
                                    <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                    </ButtonDisabledStyle>
                                </ButtonsAppearance>
                            </igtxt:WebMaskEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#3CB371">DOB:</font>
                        </td>
                        <td>
                            <igtxt:WebDateTimeEdit TabIndex="33" ID="txtDOB" runat="server" BackColor="#FFCC00"
                                DataMode="DateOrDBNull" Font-Names="Tahoma" Font-Size="8pt" Height="20px" Width="150px">
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                            </igtxt:WebDateTimeEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Email Address:
                        </td>
                        <td>
                            <asp:TextBox TabIndex="34" CssClass="entry" runat="server" ID="txtEmailAddress" Width="150px"
                                BackColor="Gold"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table class="window">
                    <tr>
                        <td>
                            <h3>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <b>Co-Applicants</b>
                                        </td>
                                        <td align="right">
                                            <a id="lnkAddCoApps" runat="server" class="lnk" href="javascript:AddCoApps();">
                                                <img style="margin-right: 5;" src="~/images/16x16_Person_add.png" runat="server"
                                                    border="0" align="absmiddle" />Add Co-Applicant</a>
                                        </td>
                                    </tr>
                                </table>
                            </h3>    
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <igtbl:UltraWebGrid ID="wGrdCoApp" runat="server" Browser="Xml" DataKeyField="LeadCoApplicantID"
                                DataSourceID="dsCoApp">
                                <Bands>
                                    <igtbl:UltraGridBand DataKeyField="LeadCoApplicantID" RowSelectors="No">
                                        <Columns>
                                            <igtbl:TemplatedColumn Width="16px">
                                                <CellTemplate>
                                                    <a href='javascript:RemoveCoApp(<%#DataBinder.Eval(Container.DataItem, "LeadCoApplicantID")%>);'
                                                        title="Remove Co-Applicant">
                                                        <img runat="server" src="~/images/16x16_delete.png" style="border-style: none" /></a>
                                                </CellTemplate>
                                            </igtbl:TemplatedColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Full Name" Width="128px">
                                                <Header Caption="Co-applicant">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <CellButtonStyle HorizontalAlign="Left">
                                                </CellButtonStyle>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle HorizontalAlign="Left">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Type="CheckBox" BaseColumnName="AuthorizationPower" DataType="System.Boolean"
                                                AllowUpdate="No">
                                                <Header Caption="Can Authorize">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <CellButtonStyle HorizontalAlign="Center">
                                                </CellButtonStyle>
                                                <CellStyle HorizontalAlign="Center">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadCoApplicantID" DataType="System.Int32">
                                                <Header Caption="LeadCoApplicantID">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                        </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AllowSortingDefault="No"
                                    AutoGenerateColumns="False" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                    AllowDeleteDefault="No" AllowUpdateDefault="No" BorderCollapseDefault="Collapse">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsCoApp" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getCoApps"
                                SelectCommandType="StoredProcedure" DeleteCommand="stp_enrollment_deleteCoApp"
                                DeleteCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="applicantID" Type="Int32" />
                                </SelectParameters>
                                <DeleteParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Name="coAppID" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <table class="window">
                            <tr>
                                <td colspan="2">
                                    <h2>
                                        Setup</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="red">Source:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlLeadSource" runat="server" CssClass="entry" TabIndex="35"
                                        Width="150px" onchange="javascript:ddlLeadSource_onchange(this);">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trPaperLeadCode" runat="server" style="display: none">
                                <td>
                                    Code:
                                </td>
                                <td>
                                    <asp:TextBox CssClass="entry" runat="server" ID="txtPaperLeadCode" Width="150px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr id="trVendor" runat="server" style="display: none">
                                <td>
                                    <font color="red">Vendor:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlVendor" runat="server" CssClass="entry" Width="150px" TabIndex="36" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trProduct" runat="server">
                                <td>
                                    <font color="red">Product Code:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlProduct" runat="server" CssClass="entry" Width="150px" TabIndex="36" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="red">Law Firm:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="entry" Width="150px" TabIndex="36">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="#3CB371">Language:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="entry" Width="150px"
                                        TabIndex="37">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Delivery:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlDelivery" runat="server" CssClass="entry" Width="150px"
                                        TabIndex="38">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr style='display:none;' >
                                <td>
                                    First Appointment:
                                </td>
                                <td>
                                    <igtxt:WebDateTimeEdit TabIndex="39" ID="FirstAppDate" runat="server" BackColor="#FFFFFF"
                                        DataMode="DateOrDBNull" Font-Names="Tahoma" Font-Size="8pt" Height="20px" Width="150px">
                                        <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                            StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                            WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                    </igtxt:WebDateTimeEdit>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Time Zone:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="entry" Width="150px"
                                        AutoPostBack="true" TabIndex="40">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr  style='display:none;'>
                                <td>
                                    Time (For Lead):
                                </td>
                                <td>
                                    <igtxt:WebDateTimeEdit ID="FirstAppLeadTime" runat="server" EditModeFormat="hh:mm tt"
                                        Font-Names="Tahoma" Font-Size="8pt" Height="21px" Width="55px" AutoPostBack="true"
                                        TabIndex="41">
                                    </igtxt:WebDateTimeEdit>
                                    (Local)
                                    <igtxt:WebDateTimeEdit ID="FirstAppTime" runat="server" EditModeFormat="hh:mm tt"
                                        Height="21px" Font-Names="Tahoma" Font-Size="8pt" Width="55px" AutoPostBack="true"
                                        TabIndex="42">
                                    </igtxt:WebDateTimeEdit>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="red">Assigned To:</font>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlAssignTo" runat="server" CssClass="entry" Width="150px"
                                        TabIndex="43">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trCloser" runat="server" visible="false">
                                <td>
                                    Closer:
                                </td>
                                <td style="background-color:#9BCD9B">
                                    <asp:DropDownList ID="ddlCloser" runat="server" CssClass="entry" Width="150px"
                                        TabIndex="44">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Status:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="entry" Width="150px" TabIndex="44" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trReasons" runat="server" visible="false">
                                <td>
                                    Reason:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlReasons" runat="server" CssClass="entry" Width="150px" TabIndex="45" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trReasonOther" runat="server" visible="false">
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtReasonOther" runat="server" CssClass="entry" MaxLength="100"></asp:TextBox>
                                    <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server" TargetControlID="txtReasonOther" WatermarkCssClass="graytxt" WatermarkText="Please explain">
                                    </ajaxToolkit:TextBoxWatermarkExtender>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="#3CB371">First Deposit:</font>
                                </td>
                                <td>
                                    <igtxt:WebDateTimeEdit TabIndex="48" ID="txtFirstDepositDate" runat="server" BackColor="#FFFFFF"
                                        DataMode="DateOrDBNull" Font-Names="Tahoma" Font-Size="8pt" Height="20px" Width="150px">
                                        <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                            StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                            WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                    </igtxt:WebDateTimeEdit>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="#3CB371">Deposit Day:</font>
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="entry" runat="server" ID="ddlDepositDay" Width="150px"
                                        TabIndex="49">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font color="#3CB371">E-Statement:</font>
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="entry" runat="server" ID="ddlEStatement" Width="150px" TabIndex="50">
                                        <asp:ListItem Value="True">Yes</asp:ListItem>
                                        <asp:ListItem Value="False">No</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <table id="tbAppointments" class="window">
                    <tr>
                        <td>
                            <h3>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <b>Appointments</b>
                                        </td>
                                        <td align="right">
                                            <a id="lnkAddAppointment" runat="server" class="lnk" href="javascript:AddAppointment();">
                                                <img id="Img1" style="margin-right: 5;" src="~/images/16x16_worksheet.png" runat="server"
                                                    border="0" align="absmiddle" />Add Appointment</a>
                                        </td>
                                    </tr>
                                </table>
                            </h3>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <igtbl:UltraWebGrid ID="uwgAppointments" runat="server" Browser="Xml" DataKeyField="AppointmentID"
                                DataSourceID="dsAppointments">
                                <Bands>
                                    <igtbl:UltraGridBand DataKeyField="AppointmentID" RowSelectors="No">
                                        <Columns>
                                            <igtbl:UltraGridColumn BaseColumnName="AppointmentId" Width="16px">
                                                <Header Caption="">
                                                    <RowLayoutColumnInfo OriginX="0" />
                                                </Header>
                                                <CellButtonStyle HorizontalAlign="Left">
                                                </CellButtonStyle>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle HorizontalAlign="Left">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="0" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="AppointmentDate" Width="128px">
                                                <Header Caption="When (local time)">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <CellButtonStyle HorizontalAlign="Left">
                                                </CellButtonStyle>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle HorizontalAlign="Left">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="StatusName" Width="128px">
                                                <Header Caption="Status">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <CellButtonStyle HorizontalAlign="Left">
                                                </CellButtonStyle>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle HorizontalAlign="Left">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="AppointmentID" DataType="System.Int32">
                                                <Header Caption="AppointmentID">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn Hidden="True" BaseColumnName="AppointmentStatusID" DataType="System.Int32">
                                                <Header Caption="AppointmentStatusID">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                        </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="uwgAppointments" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AllowSortingDefault="No"
                                    AutoGenerateColumns="False" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                    AllowDeleteDefault="No" AllowUpdateDefault="No" BorderCollapseDefault="Collapse">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsAppointments" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommand="stp_Dialer_GetAppointmentsForLead"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="LeadApplicantId" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <%--Add Popup--%>
    <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none;" />
    <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
        TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
        BackgroundCssClass="modalBackgroundChoice" DropShadow="false" CancelControlID="lnkCancel" >
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel runat="server" CssClass="modalPopupChoice" ID="programmaticPopup" Style="display: none;
        padding: 0px">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;height: 30px;border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
            <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';" onclick="javascript:closePopup();"
                style="height: 30px; padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51;
                text-align: right; vertical-align: middle; border-collapse: collapse;">
                <div style="float: left; color: White; padding: 5px;">
                    Signing Choice</div>
                <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlRpt">
            <div id="dvContent" runat="server" style="z-index: 51; visibility: visible; background-color: Transparent;">
                <asp:RadioButtonList ID="rblSignChoice" runat="server" CssClass="entry2" >
                    <asp:ListItem Text="LexxSign" Value="lexx" />
                    <asp:ListItem Text="EchoSign" Value="echo" Enabled="false" />
                </asp:RadioButtonList>
                <table class="entry" style="background-color:#DCDCDC">
                    <tr>
                        <td align="right">
                            <asp:LinkButton ID="lnkGo" runat="server" Text="Continue" />
                      <asp:Literal ID="litSpac" runat="server" Text=" | " />
                            <asp:LinkButton ID="lnkCancel" runat="server" Text="Cancel" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </asp:Panel>
    <%--End Popup--%>
    <%--Add Appointment Call Popup--%>
        <asp:Button runat="server" ID="btnHiddenAppointmentCall" Style="display: none;" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="AppointmentCallPopup" BehaviorID="programmaticModalPopupBehavior2"
            TargetControlID="btnHiddenAppointmentCall" PopupControlID="pnlAppointmentCallPopup"
            BackgroundCssClass="modalBackgroundChoice" DropShadow="false" CancelControlID="lnkCancelAppCall">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel runat="server" CssClass="modalPopupChoice" ID="pnlAppointmentCallPopup" Style="display: none;
        padding: 0px">
        <asp:Panel runat="Server" ID="pnlAppCallHdr" style="background-color: #3D3D3D;height: 30px; border: solid 1px Gray; color: Black; text-align: center;" >
            <div id="dvAppCallHeader"  style="height: 30px; padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51; text-align: center; vertical-align: middle; border-collapse: collapse;">
                <div style="color: White; padding: 5px;">
                    Appointment Call
                </div>
                <asp:Image ID="ImgCloseAppointmentPopup" runat="server" ImageUrl="~/images/16x16_close.png" onclick="javascript:closeAppPopup();" style="cursor: hand;" Visible="False" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlAppCall">
            <div id="dvAppCallContent" runat="server" style="z-index: 51; visibility: visible; background-color: Transparent;">
                <table class="entry" style="background-color: #DCDCDC" cellpadding="5px" >
                    <tr>
                        <td nowrap="nowrap" >Phone Number:</td>
                        <td nowrap="nowrap">
                            <asp:Label ID="lblleadPhoneNumberAppointment" runat="server" ></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">Date and Time:<br />(for lead)</td>
                        <td nowrap="nowrap" valign="top">
                            <asp:Label ID="lblleadDTAppointment" runat="server" ></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">Date and Time:<br />(local)</td>
                        <td nowrap="nowrap" valign="top"  >
                            <asp:Label ID="lblleadDTAppointmentLocal" runat="server" ></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">Created By:</td>
                        <td nowrap="nowrap" valign="top"  >
                            <asp:Label ID="lblleadAppointmentby" runat="server" ></asp:Label>
                        </td>
                    </tr>
                    <tr>
                         <td>Note:</td>
                         <td>
                            <asp:Label ID="lblLeadNoteAppointment" runat="server" ></asp:Label>
                        </td> 
                    </tr>
                    <tr>
                        <td colspan="2" align="center" nowrap="nowrap" >
                            <a href="javascript: void();" style="border: solid 0px #000000; text-decoration:none; padding: 3px 3px 3px 3px;" onmouseover="this.style.color='#ffffff';this.style.backgroundColor='#3399ff';this.style.border='solid 1px #3D3D3D';" onmouseout="this.style.color='';this.style.backgroundColor='';this.style.border='';" onclick="MakeAppointmentCall()"; >
                                 <img src='<%=ResolveUrl("~/images/phone2.png") %>'  alt="" title="Make Call" style="border: none;" ></img>
                                 &nbsp;<span style="vertical-align: top;" >MAKE CALL NOW!</span>
                            </a> 
                            <asp:LinkButton ID="lnkCancelAppCall" runat="server" Text="Cancel" style="text-decoration:none; display:none;" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </asp:Panel>
    <%--End Appointment Call Popup--%>
    <asp:LinkButton ID="btnDocsRefresh" runat="server" />
    <asp:LinkButton ID="btnNotesRefresh" runat="server" />
    <asp:LinkButton ID="btnBankRefresh" runat="server" />
    <asp:LinkButton ID="btnCoAppRefresh" runat="server" />
    <asp:LinkButton ID="btnRemoveCoApp" runat="server" />
    <asp:LinkButton ID="btnRemoveBank" runat="server" />
    <asp:LinkButton ID="btnRemoveCreditor" runat="server" />
    <asp:LinkButton ID="btnCreditorRefresh" runat="server" />
    <asp:LinkButton ID="btnForCreditorRefresh" runat="server" />
    <asp:LinkButton ID="btnSaveAndNoEndPage" runat="server" />
    <asp:HiddenField ID="hdnCallIdKey" runat="server" />
    <asp:HiddenField ID="hdnLeadApplicantID" runat="server" />
    <asp:HiddenField ID="hdnLeadCoApplicantID" runat="server" />
    <asp:HiddenField ID="hdnLeadBankID" runat="server" />
    <asp:HiddenField ID="hdnLeadCreditorInstance" runat="server" />
    <asp:HiddenField ID="hdnCallId" runat="server" />
    <asp:HiddenField ID="hdnDnis" runat="server" />
    <asp:HiddenField ID="hdnAni" runat="server" />
    <asp:HiddenField ID="hdnProductId" runat="server" />
    <asp:HiddenField ID="hdnCreditorInfo" runat="server" />
    <asp:HiddenField ID="hdnForCreditorInfo" runat="server" />
    <asp:HiddenField ID="hdnClientID" runat="server" Value="0" />
    <asp:LinkButton ID="lnkGenerate" runat="server" />
    <asp:LinkButton ID="lnkEmailEPackage" runat="server" />
    <asp:LinkButton ID="lnkPrivicaQA" runat="server" />
    <asp:LinkButton ID="lnkPrivicaResendEmail" runat="server" /> <%--CHOLT 9/24/2020--%>
    <asp:LinkButton ID="lnkPrivicaSendBankVerification" runat="server" /> <%--CHOLT 11/17/2020--%>
    <asp:LinkButton ID="lnkEmailLeadPackage" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkSaveAndClose" runat="server" />
    <asp:LinkButton ID="lnkSaveAndRedirect" runat="server" />
    <asp:HiddenField ID="hdnRedirectTo" runat="server" />
    <asp:LinkButton ID="btnAppointmentRefresh" runat="server" />
    <asp:LinkButton ID="btnRemoveAppointment" runat="server" />
    <asp:HiddenField ID="hdnAppointmentId" runat="server" />
    <asp:HiddenField ID="hdnCIDDialerCallMadeId" runat="server" />
    <asp:HiddenField ID="hdnCallAppointmentId" runat="server" />
    <asp:HiddenField ID="hdnProcessingPattern" runat="server" />
    <div id="dvVerifVerbal" title="Compliance Call">
        <iframe id="ifrVerifVerbal" src="" style="width: 640px; height: 360px;" frameborder="0">
        </iframe>
    </div>
    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateCalcModelDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('tblCalc');

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
            var updateProgressDiv = $get('updateCalcModelDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>
</asp:Content>
