<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mobile_esign.aspx.vb" Inherits="public_mobile_esign" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register assembly="JSChecker" namespace="JSChecker" tagprefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>E-Sign</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        h1
        {
            font-family: Arial;
            font-size: 20px;
            color: #A9A9A9;
        }
        h2
        {
            font-family: Arial;
            font-size: 14px;
            background: url('../images/menuback.png') repeat-x;
            font-weight: normal;
            padding: 5px;
            margin: 0;
        }
        #mainWrapper
        {
            width: 95%;
            background-color: #fff;
            padding: 10px;
            margin: 0 auto;
        }
        #pdfWrapper
        {
            padding: 2px;
            width: 95%;
            margin-bottom: 5px;
            height: 100%;
        }
        .signatures
        {
            display: table-row;
            margin: 0 0 50px 0;
        }
        .signature
        {
            display: table-cell;
            background-color: #B9D3EE;
            padding: 10px;
            font-family: Arial;
            font-size: 12px;
        }
        .initial
        {
            display: table-cell;
            background-color: #B9D3EE;
            width: 120px;
            padding: 10px;
            font-family: Arial;
            font-size: 12px;
        }
        .divider
        {
            height: 10px;
        }
        #myInitials
        {
            background-color: #B9D3EE;
            width: 120px;
            padding: 10px;
            font-family: Arial;
            font-size: 12px;
            position: relative;
            margin-bottom: 10px;
        }
        #clickWrapper
        {
            clear: both;
            padding: 10px 5px 5px 5px;
            border-top: solid 3px #666666;
        }
        .instructions
        {
            border: solid 1px #B9D3EE;
            background-color: #EDEDED;
            font-family: Arial;
            font-size: 12px;
            color: #333333;
            margin: 0 0 5px 0;
        }
        .instructions li
        {
            line-height: 20px;
        }
        .done
        {
            border: solid 1px #B9D3EE;
            background-color: #EDEDED;
            font-family: Arial;
            font-size: 12px;
            color: #333333;
            margin: 0 0 5px 0;
            padding: 10px 20px 20px 20px;
        }
        .done h1
        {
            color: Black;
        }
        #divEmail
        {
            font-weight: bold;
            padding: 10px 20px 0 20px;
        }
        .html, .body
        {
            margin: 0 0 1px;
            padding: 0;
            height: 100%;
            background-color: #F2F2F2;
            border: none;
        }
        .a
        {
            font-family: Tahoma;
            font-size: 11pt;
        }
        .modalBackgroundSign
        {
            background-color: #808080;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupSign
        {
            background-color: #F5FAFD;
            border-width: 1px;
            border-style: ridge;
            border-color: Gray;
            padding: 0px;
            width: 535px;
        }
        .sigBox
        {
            background-color: #FFFF00;
            text-align: left;
            border: solid 2px red;
            padding: 2px;
            border-collapse: collapse;
            color: #4791C5;
            cursor: pointer;
        }
        #confirmBox
        {
            position: absolute;
            top: 50%;
            left: 40%;
            width: 400px;
            z-index: 1;
            visibility: hidden;
            color: white;
            text-align: center;
            font-family: tahoma;
            font-size: 11px;
        }
        .popupMenu
        {
            position: absolute;
            visibility: hidden;
            background-color: Transparent;
            opacity: .9;
            filter: alpha(opacity=90);
            padding: 3px;
        }
        .popupHover
        {
            cursor: pointer;
            text-decoration: underline;
            color: Blue;
        }
        .style1
        {
            width: 418px;
        }
    </style>

    <script type="text/javascript">
    
        // start save signature image
        function save() {
            var iSig = $get('iSignature');
            var iIni = $get('iInitials');
            var iCoSig = $get('iCoSignature');
            var iCoIni = $get('iCoInitials');
            var bNeedInit = '<%=_documentNeedsInitials %>';
            if (bNeedInit == 'True'){
                if (iCoSig) {
                    if (!iCoSig.contentWindow.hasSignature() || !iCoIni.contentWindow.hasSignature()) {
                        alert('Co-Applicant, please draw your signatures.');
                        return;
                    }
                }
                if (iSig.contentWindow.hasSignature() && iIni.contentWindow.hasSignature()) {
                    // save the signatures
                    iSig.contentWindow.save();
                    iIni.contentWindow.save();
                    if (iCoSig) {
                        iCoSig.contentWindow.save();
                        iCoIni.contentWindow.save();
                    }
                    // create the signed doc, email the client, etc
                    <%=Page.ClientScript.GetPostBackEventReference(lnkSign, Nothing) %>;
                }
                else {
                    alert('Please draw your signatures.');
                }
            } else {
                if (iCoSig) {
                    if (!iCoSig.contentWindow.hasSignature()) {
                        alert('Co-Applicant, please draw your signatures.');
                        return;
                    }
                }
                if (iSig.contentWindow.hasSignature()) {
                    // save the signatures
                    iSig.contentWindow.save();
                    if (iCoSig) {
                        iCoSig.contentWindow.save();
                    }
                    // create the signed doc, email the client, etc
                    <%=Page.ClientScript.GetPostBackEventReference(lnkSign, Nothing) %>;
                }
                else {
                    alert('Please draw your signatures.');
                }
            }
        }
        function signDocument() {
            // create the signed doc, email the client, etc
            <%=Page.ClientScript.GetPostBackEventReference(lnkSign, Nothing) %>;
        }

        function saveNoSign() {
            var iSig = $get('iSignature');
            var iIni = $get('iInitials');
            var iCoSig = $get('iCoSignature');
            var iCoIni = $get('iCoInitials');
            var bNeedInit = '<%=_documentNeedsInitials %>';

            if (bNeedInit == 'True'){
                if (iCoSig) {
                    if (!iCoSig.contentWindow.hasSignature() || !iCoIni.contentWindow.hasSignature()) {
                        alert('Co-Applicant, please draw your signatures.');
                        return;
                    }
                }
                if (iSig.contentWindow.hasSignature() && iIni.contentWindow.hasSignature()) {
                    // save the signatures
                    iSig.contentWindow.save();
                    iIni.contentWindow.save();
                    if (iCoSig) {
                        iCoSig.contentWindow.save();
                        iCoIni.contentWindow.save();
                    }
                    // apply sig to document
                    //load current sig info
                    var hdnA = $get('<%=hdnASig.ClientID %>')
                    var sigInfo = hdnA.value.split(';');   //ContainerID;ImageDocNumber;ImagePageNumber;SignatureType;ImagePath
                    var h = addSignatureImage(sigInfo[0], sigInfo[1], sigInfo[2], sigInfo[3], sigInfo[4]);
                }
                else {
                    alert('Please draw your signatures.');
                }
            } else {
                if (iCoSig) {
                    if (!iCoSig.contentWindow.hasSignature()) {
                        alert('Co-Applicant, please draw your signatures.');
                        return;
                    }
                }
                if (iSig.contentWindow.hasSignature()) {
                    // save the signatures
                    iSig.contentWindow.save();
                    if (iCoSig) {
                        iCoSig.contentWindow.save();
                    }
                    // apply sig to document
                    //load current sig info
                    var hdnA = $get('<%=hdnASig.ClientID %>')
                    var sigInfo = hdnA.value.split(';');   //ContainerID;ImageDocNumber;ImagePageNumber;SignatureType;ImagePath
                    var h = addSignatureImage(sigInfo[0], sigInfo[1], sigInfo[2], sigInfo[3], sigInfo[4]);
                }
                else {
                    alert('Please draw your signatures.');
                }
            }
        }
        // end save signature image

        // start page events
        function LoadPage(docNum, pageNum) {
            //find hidden control to store current doc and page num
            var hdn = $get('<%=hdnPage.ClientID %>')
            hdn.value = docNum + '|' + pageNum;
            //postback to load page from doc dictionary
            <%=Page.ClientScript.GetPostBackEventReference(lnkLoadPage, Nothing) %>;
        }
        function ApplySignature(divContainer, docNum, pageNum, sigType, imgSrcPath) {
            IsSignatureFileThere(imgSrcPath, divContainer.id, docNum, pageNum, sigType);
        }
        function MouseOver(obj) {
            obj.style.cursor = 'hand';
            obj.style.textDecoration = 'none';
        }
        function MouseOut(obj) {
            obj.style.cursor = '';
            obj.style.textDecoration = 'none';
        }
        function OnRequestComplete(result, userContext, methodName) {
            var signImage = eval('(' + result + ')');
            //store current saved sig info
            var hdnA = $get('<%=hdnASig.ClientID  %>');
            hdnA.value = signImage.ImageContainerID + ';' + signImage.ImageDocNumber + ';';
            hdnA.value += signImage.ImagePageNumber + ';' + signImage.SignatureType + ';' + signImage.ImagePath;

            if (signImage.ImageExists == true) {

                myConfirm(signImage.LegalMessage, "Yes", "No", function(answer) { (answer ? addSignatureImage(signImage.ImageContainerID, signImage.ImageDocNumber, signImage.ImagePageNumber, signImage.SignatureType, signImage.ImagePath) : "false"); });

            } else {
                var modalPopupBehavior = $find('programmaticModalPopupBehavior');
                var showInit = '<%=_documentNeedsInitials %>';
                var ci = document.getElementById('divClientInitial');
                var coi = document.getElementById('divCoClientInitial');
                if (showInit == 'True'){
                    ci.style.display='block';
                    if (!!coi){
                        coi.style.display='block';
                    }
                }else{
                    ci.style.display='none';
                    if (!!coi){
                        coi.style.display='none';
                    }
                }
                modalPopupBehavior.show();
            }
        }
       
        function addSignatureImage(ContainerID, ImageDocNumber, ImagePageNumber, SignatureType, ImagePath) {
            //remove all controls from div
            var divContainer = $get(ContainerID);
            var child;
            while (child = divContainer.firstChild) {
                divContainer.removeChild(child);
            }
            divContainer.className = '';

            //add to applied sig list
            var hdnS = $get('<%=hdnAppliedSignatures.ClientID %>')
            hdnS.value += '|' + ImageDocNumber + ';' + ImagePageNumber + '/' + SignatureType;

            //update current page info
            var hdnP = $get('<%=hdnPage.ClientID %>')
            hdnP.value = ImageDocNumber + '|' + ImagePageNumber;

            //create sig image in div
            var img = document.createElement("img");
            img.setAttribute('src', ImagePath);
            
            var hdnSigCnt = document.getElementById('<%=hdnSignCount.ClientID %>');
            var hdnInitCnt = document.getElementById('<%=hdnInitCount.ClientID %>');
            
            switch (SignatureType) {
                case 'signature': case 'DS1': case 'DS2':
                    img.setAttribute('width', 300);
                    img.setAttribute('height', 100);
                    hdnSigCnt.value -=1;
                    signNav.splice(0,1);
                    break;
                case 'intials': case 'DI1': case 'DI2':
                    hdnInitCnt.value -=1;
                    initNav.splice(0,1);
                    break;
                default:
            }
            if (hdnSigCnt.value == 0 && hdnInitCnt.value == 0){
                alert('Perfect! You have signed in all locations!\n\n Press the [Click to e-Sign] button to complete.');
            }
            var dInfo = document.getElementById('<%=divInfo.ClientID %>');
            var infoMSG = 'You need to <a href="#" onclick="jumpToFirst(1);">sign in ' + hdnSigCnt.value + ' location(s)</a> and <a href="#" onclick="jumpToFirst(2);">initial in ' + hdnInitCnt.value + ' location(s)</a>.';
            dInfo.innerHTML = infoMSG;
            
                        
            divContainer.appendChild(img)
            //try to change image to signed
            //got here from links no treeview node to change
            var iImgID = "imgSign_" + ImageDocNumber + '_' + ImagePageNumber;
            var iImg = document.getElementById(iImgID);
            var nSrc = iImg.src;
            nSrc = nSrc.replace('sign-here', 'signed');
            iImg.src = nSrc;
            return divContainer.parentElement.parentElement.parentElement.parentElement.innerHTML;
        }

        function OnRequestError(error, userContext, methodName) {
            if (error != null) {
                alert(error.get_message());
            }
        }
        function IsSignatureFileThere(filePath, containerID, docNum, pageNum, sigType) {
            PageMethods.PM_ServerFileExists(filePath, containerID, docNum, pageNum, sigType, OnRequestComplete, OnRequestError);
        }
        // end page events
    </script>

    <script type="text/javascript">
        function RetrieveScreenSize() {
            var height = window.screen.height
            var width = window.screen.width

            document.getElementById("hdnScreenHeight").value = height;
            document.getElementById("hdnScreenWidth").value = width;
        }
        
    </script>

    <script language="javascript" type="text/javascript">
        var answerFunction;
        function myConfirm(text, button1, button2, answerFunc) {
            var box = document.getElementById("confirmBox");
            box.getElementsByTagName("p")[0].firstChild.nodeValue = text;
            var button = box.getElementsByTagName("input");
            button[0].value = button1;
            button[1].value = button2;
            answerFunction = answerFunc;
            box.style.visibility = "visible";
        }
        function answer(response) {
            document.getElementById("confirmBox").style.visibility = "hidden";
            answerFunction(response);
        }

        function closePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
        }
        function GotoSignature(docNum, pageNum, sigLocation) {
            //function to go to sigs in pages
            LoadPage(docNum, pageNum);
        }
        function jumpToFirst(signType) {
            var docCnt = 0;
            var pageCnt = 0;
            try {
                switch (signType) {
                    case 1:
                        var sig = signNav[0];
                        var sigArray = sig.split('|');
                        docCnt = sigArray[0];
                        pageCnt = sigArray[1];
                        GotoSignature(docCnt, pageCnt, 'DS1');
                        break;
                    case 2:
                        var init = initNav[0];
                        var initArray = init.split('|');
                        docCnt = initArray[0];
                        pageCnt = initArray[1];
                        GotoSignature(docCnt, pageCnt, 'DI1');
                        break;
                    default:
                }
            }
            catch (e) {
                alert('There was a problem moving to signature/initial!');
            }

        }
        function pageLoad() {

            var ph = document.getElementById('<%= phContent.ClientID %>');
            try {
                ph.childNodes[0].childNodes[0].focus();
            }
            catch (e) { }


        }
    </script>

    <script type="text/javascript">
        if (typeof HTMLElement != 'undefined' && !HTMLElement.prototype.click)
            HTMLElement.prototype.click = function () {
                var evt = this.ownerDocument.createEvent('MouseEvents');
                evt.initMouseEvent('click', true, true, this.ownerDocument.defaultView, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
                this.dispatchEvent(evt);
            }

    </script>

</head>
<body onload="RetrieveScreenSize()">
    <form id="form1" runat="server">
    
   
    
     <cc1:JSCheck ID="JSCheck1" runat="server">
    </cc1:JSCheck>
    <ajaxToolkit:ToolkitScriptManager ID="smEsign" runat="server" EnablePageMethods="true" />
    <div id="pageContent" runat="server" style="display: none">
        <div id="header" style="border-bottom: solid 1px black;">
            <h1 id="hTitle" runat="server">
                Law Firm Compliance</h1>
        </div>
        <table style="width: 100%;" border="0">
            
            <tr valign="top">
                <td class="style1">
                    <h2 id="hDocName" runat="server">
                        Legal Documents</h2>
                    <div id="divInstructions" runat="server" class="instructions">
                        <div id="divEmail" runat="server">
                            You are signing as
                            <asp:Label ID="lblLeadName" runat="server"></asp:Label>
                            (<asp:Label ID="lblLeadEmail" runat="server"></asp:Label>)
                        </div>
                        <hr />
                        <table style="width: 100%">
                            <tr valign="bottom">
                                <td>
                                    <ol>
                                        <li>Review the document</li>
                                        <li>Use the signature pad(s) to sign the document.<br />
                                            <div id="divInfo" runat="server">
                                            </div>
                                            Note: Signatures will be applied to each page requiring a signature. </li>
                                        <li>Click the button at the bottom to e-Sign.</li>
                                        <li>Click <a id="hpStandard" runat="server">here</a> to use the sign version.</li>
                                    </ol>
                                </td>
                                <td>
                                    <table style="width: 100%;">
                                        <tr valign="top">
                                            <td align="center">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divDone" runat="server" class="done" visible="false">
                        <h1>
                            <img id="Img1" src="~/images/24x24_check.gif" runat="server" align="absmiddle" alt="" />
                            You're Done!</h1>
                        <asp:Label ID="lblDoneMsg" runat="server"></asp:Label>
                    </div>
                    <div id="divNotFound" runat="server" class="done" visible="false">
                        <h1>
                            <img id="Img2" src="~/images/24x24_error.png" runat="server" align="absmiddle" alt="" />
                            Document not found</h1>
                    </div>
                    <table border="0" style="width: 100%;" id="trDocuments" runat="server">
                        <tr>
                            <td style="width: 100%; text-align: left;">
                                <h2>
                                    Documents</h2>
                            </td>
                        </tr>
                        <tr>
                            <td class="instructions">
                                <asp:TreeView ID="tvDocuments" runat="server" ImageSet="Custom" Height="300px" NodeWrap="True"
                                    Width="100%" Font-Names="Tahoma" Font-Size="9px" EnableTheming="true" EnableClientScript="true"
                                    Style="overflow: auto">
                                    <ParentNodeStyle Font-Bold="true" BorderStyle="None" />
                                    <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
                                    <SelectedNodeStyle Font-Underline="True" HorizontalPadding="0px" VerticalPadding="0px"
                                        ForeColor="#5555DD" BorderStyle="None" />
                                    <Nodes>
                                    </Nodes>
                                    <RootNodeStyle BorderStyle="None" />
                                    <NodeStyle Font-Names="Tahoma" Font-Size="11px" ForeColor="Black" HorizontalPadding="5px"
                                        NodeSpacing="0px" VerticalPadding="0px" BorderStyle="None" />
                                    <LeafNodeStyle BorderStyle="None" />
                                </asp:TreeView>
                            </td>
                        </tr>
                    </table>
                </td>
                <td id="tdDocuments" runat="server" rowspan="2" align="center" style="background-color: Gray;
                    height: 100%">
                    <div id="pdfWrapper">
                        <table id="tblDocuments" runat="server" style="display: block;">
                            <tr valign="top">
                                <td align="left" valign="top">
                                    <asp:UpdatePanel ID="upDocument" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                        <ContentTemplate>
                                            <div id="phContent" runat="server" style="width: 100%; padding: 3px; height: 100%;" />
                                            <div id="confirmBox">
                                                <table style="width: 100%; height: 100%" cellpadding="0" cellspacing="0" class="warning">
                                                    <tr>
                                                        <td style="text-align: right; font-weight: bold;">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding: 5px;">
                                                            <p>
                                                                Message</p>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input type="button" onclick="answer(true)" value="Ok" style="width: 50px;" />
                                                            <input type="button" onclick="answer(false)" value="Cancel" style="width: 50px;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div id="updateContentDiv" style="display: none; height: 40px; width: 40px">
                                                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                                            </div>
                                            <asp:HiddenField ID="hdnSignCount" runat="server" />
                                            <asp:HiddenField ID="hdnInitCount" runat="server" />
                                            <asp:LinkButton ID="lnkLoadPage" runat="server" />
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="tvDocuments" EventName="SelectedNodeChanged" />
                                            <asp:AsyncPostBackTrigger ControlID="lnkLoadPage" EventName="Click" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                        <iframe id="iPDF" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                            frameborder="0" style="width: 850px; height: 450px; display: none;" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="clickWrapper" runat="server">
                        <img alt="Click to e-Sign" src="../images/clicktoesign.png" onclick="javascript:signDocument();"
                            style="cursor: pointer" />
                    </div>
                </td>
            </tr>
        </table>
        
    <%--Add Popup--%>
    <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none;" />
    <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
        TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
        BackgroundCssClass="modalBackgroundSign" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle"
        CancelControlID="hideModalPopupViaServer">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel runat="server" CssClass="modalPopupSign" ID="programmaticPopup" Style="display: none;
        padding: 0px">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;
            height: 30px
                        border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
            <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';" onclick="javascript:closePopup();"
                style="height: 30px; padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51;
                text-align: right; vertical-align: middle; border-collapse: collapse;">
                <div style="float: left; color: White; padding: 5px;">
                    Type in your signature in each box below.</div>
                <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlRpt">
            <div id="dvReport" runat="server" style="z-index: 51; visibility: visible; background-color: Transparent;">
                <div id="sigWrapper" runat="server">
                    <div class="signatures">
                        <div class="signature">
                            <div>
                                Please type your signature:</div>
                            <iframe id="iSignature" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="375px" height="100px"></iframe>
                        </div>
                        <div id="divClientInitial" class="initial">
                            <div>
                                Please initial:</div>
                            <iframe id="iInitials" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="120px" height="100px"></iframe>
                        </div>
                    </div>
                    <div class="divider">
                    </div>
                    <div id="divCoApp" runat="server" class="signatures">
                        <div class="signature">
                            <div>
                                Co-Applicant, please type your signature:</div>
                            <iframe id="iCoSignature" runat="server" marginheight="0" marginwidth="0" src=""
                                scrolling="no" frameborder="0" width="375px" height="100px"></iframe>
                        </div>
                        <div id="divCoClientInitial" class="initial">
                            <div>
                                Please initials:</div>
                            <iframe id="iCoInitials" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="120px" height="100px"></iframe>
                        </div>
                    </div>
                    <div class="divider">
                    </div>
                </div>
                <div id="btnWrapper" style="text-align: right; padding-bottom: 5px; vertical-align: middle;
                    background-color: #DCDCDC; padding: 3px;">
                    <div style="float: left; text-align: center; padding-left: 5px;">
                        <asp:Panel CssClass="popupMenu" ID="PopupMenu" runat="server">
                            <div class="info">
                                By providing your signature and initials electronically, you can then place them
                                in the document where required. We do not store a copy of your signature, which
                                only appears on the documents you are signing or initialing.
                            </div>
                        </asp:Panel>
                        <asp:Label ID="lnkInfo" runat="server" Text="Information About Electronic Signatures"
                            ForeColor="Blue" Font-Underline="true" Font-Names="tahoma" Font-Size="11px" />
                        <ajaxToolkit:HoverMenuExtender ID="hme2" runat="Server" HoverCssClass="popupHover"
                            PopupControlID="PopupMenu" PopupPosition="Top" TargetControlID="lnkInfo" PopDelay="25" />
                    </div>
                    <asp:LinkButton runat="server" Font-Size="11px" Font-Bold="True" ID="lnkApply" Text="Apply"
                        OnClientClick="saveNoSign();" Style="padding: 5px; color: white; background-color: Green;
                        border: solid 1px black; text-decoration: none; text-align: center;" Width="75px"
                        Font-Names="Tahoma" />
                    <asp:LinkButton runat="server" Font-Size="11px" Font-Bold="True" ID="hideModalPopupViaServer"
                        Text="Cancel" Style="padding: 5px;" Font-Names="Tahoma" />
                </div>
            </div>
        </asp:Panel>
    </asp:Panel>
    <%--<asp:Panel runat="server" CssClass="modalPopupSign" ID="programmaticPopup" Style="display: none;
        padding: 0px">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;
            height: 30px
                        border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
            <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';" onclick="javascript:closePopup();"
                style="height: 30px; padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51;
                text-align: right; vertical-align: middle; border-collapse: collapse;">
                <div style="float: left; color: White; padding: 5px;">
                    Draw your signature with the mouse in each box below.</div>
                <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" />
            </div>
        </asp:Panel>
        <asp:Panel runat="Server" ID="pnlRpt">
            <div id="dvReport" runat="server" style="z-index: 51; visibility: visible; background-color: Transparent;">
                <div id="sigWrapper" runat="server">
                    <div class="signatures">
                        <div class="signature">
                            <div>
                                Please draw your signature:</div>
                            <iframe id="iSignature" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="375px" height="100px"></iframe>
                        </div>
                        <div id="divClientInitial" class="initial">
                            <div>
                                Initials:</div>
                            <iframe id="iInitials" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="120px" height="100px"></iframe>
                        </div>
                    </div>
                    <div class="divider">
                    </div>
                    <div id="divCoApp" runat="server" class="signatures">
                        <div class="signature">
                            <div>
                                Co-Applicant, please draw your signature:</div>
                            <iframe id="iCoSignature" runat="server" marginheight="0" marginwidth="0" src=""
                                scrolling="no" frameborder="0" width="375px" height="100px"></iframe>
                        </div>
                        <div id="divCoClientInitial" class="initial">
                            <div>
                                Initials:</div>
                            <iframe id="iCoInitials" runat="server" marginheight="0" marginwidth="0" src="" scrolling="no"
                                frameborder="0" width="120px" height="100px"></iframe>
                        </div>
                    </div>
                    <div class="divider">
                    </div>
                </div>
                <div id="btnWrapper" style="text-align: right; padding-bottom: 5px; vertical-align: middle;
                    background-color: #DCDCDC; padding: 3px;">
                    <div style="float: left; text-align: center; padding-left: 5px;">
                        <asp:Panel CssClass="popupMenu" ID="PopupMenu" runat="server">
                            <div class="info">
                                By providing your signature and initials electronically, you can then place them
                                in the document where required. We do not store a copy of your signature, which
                                only appears on the documents you are signing or initialing.
                            </div>
                        </asp:Panel>
                        <asp:Label ID="lnkInfo" runat="server" Text="Information About Electronic Signatures"
                            ForeColor="Blue" Font-Underline="true" Font-Names="tahoma" Font-Size="11px" />
                        <ajaxToolkit:HoverMenuExtender ID="hme2" runat="Server" HoverCssClass="popupHover"
                            PopupControlID="PopupMenu" PopupPosition="Top" TargetControlID="lnkInfo" PopDelay="25" />
                    </div>
                    <asp:LinkButton runat="server" Font-Size="11px" Font-Bold="True" ID="lnkApply" Text="Apply"
                        OnClientClick="saveNoSign();" Style="padding: 5px; color: white; background-color: Green;
                        border: solid 1px black; text-decoration: none; text-align: center;" Width="75px"
                        Font-Names="Tahoma" />
                    <asp:LinkButton runat="server" Font-Size="11px" Font-Bold="True" ID="hideModalPopupViaServer"
                        Text="Cancel" Style="padding: 5px;" Font-Names="Tahoma" />
                </div>
            </div>
        </asp:Panel>
    </asp:Panel>--%>
    <%--End Popup--%>
    <asp:LinkButton ID="lnkSign" runat="server" />
    <asp:LinkButton ID="lnkLoad" runat="server" />
    <asp:PlaceHolder ID="phgrids" runat="server" />
    <asp:HiddenField ID="hdnPage" runat="server" />
    <asp:HiddenField ID="hdnScreenHeight" runat="server" />
    <asp:HiddenField ID="hdnScreenWidth" runat="server" />
    <asp:HiddenField ID="hdnAppliedSignatures" runat="server" />
    <asp:HiddenField ID="hdnASig" runat="server" />

    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateContentDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('phContent');

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
            var updateProgressDiv = $get('updateContentDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeDocument" BehaviorID="Documentanimation"
        runat="server" TargetControlID="upDocument">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="phContent" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="phContent" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
    </div>
    <div id="pageNoJS" runat="server" style="display: none;">
        <table style="width: 100%;" border="0">
            <tr>
                <td colspan="2" style="border-bottom: solid 1px black;">
                    <h1 id="h1" runat="server">
                        Law Firm Compliance</h1>
                </td>
            </tr>
            <tr>
                <td style="color: Red; text-align: center; font-size: x-large; padding-bottom: 20px;">
                    Please enable JavaScript to view this page.
                </td>
            </tr>
            <tr>
                <td style="border-bottom: solid 1px black; text-align: center;">
                    <b>If you have disabled JavaScript, you must re-enable JavaScript to use this page.
                        To enable JavaScript</b>
                    <br />
                    <ul style="text-align: left;">
                        <li>Internet Explorer 6</li>
                        <ol>
                            <li>On the Tools menu, click Internet Options. </li>
                            <li>Click the Security tab. </li>
                            <li>Click Custom Level. </li>
                            <li>Scroll to Scripting. Under Active scripting, click Enable. </li>
                            <li>Click OK twice. </li>
                        </ol>
                        <li>Netscape 6</li>
                        <ol>
                            <li>On the Edit menu, click Preferences. </li>
                            <li>Click Advanced. </li>
                            <li>Select the Enable JavaScript for Navigator check box. </li>
                            <li>Click OK. </li>
                        </ol>
                        <li>FireFox</li>
                        <ol>
                            <li>Click Tools </li>
                            <li>Click Options. </li>
                            <li>Click Content </li>
                            <li>Keep the Checkbox checked of Enable JavaScirpt. </li>
                            <li>Click OK </li>
                        </ol>
                    </ul>
                </td>
            </tr>
            <tr>
                <td style="color: Red; text-align: center;" align="center">
                    <div style="text-align: center;">
                        <b>Are you using a browser that doesn't support JavaScript?</b>
                        <br />
                        If your browser does not support JavaScript, you can upgrade to a newer browser,
                        such as <a href="http://windows.microsoft.com/en-US/internet-explorer/products/ie-9/home?os=win7&arch=b&browser=ie">
                            Microsoft&reg; Internet Explorer 8</a>.
                        <br />
                    </div>
                </td>
            </tr>
        </table>
    </div>
    
    </form>
</body>
</html>