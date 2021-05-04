<%@ Page Language="VB" AutoEventWireup="false" CodeFile="matterpop.aspx.vb" Inherits="report_matterpop"
    ValidateRequest="false" EnableEventValidation="false" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Matter</title>
    <link href="../../css/default.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .entry
        {
            font-family: tahoma;
            font-size: 11px;
            width: 100%;
        }
        .entrycell
        {
        }
        .entrytitlecell
        {
            width: 100px;
        }
    </style>
    <link href='<%# ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\controls\xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\controls\grid.js") %>"></script>
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%#  ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%# ResolveUrl("~/jscript/domain.js") %>"></script>    
    <script type="text/javascript">
     window.baseurl = "<%# ResolveUrl("~/")%>";

function FillDetails()
{
    var ddlLocalCounsel = document.getElementById('tcMatter_tbMatter_ddlLocalCounsel');//document.getElementById('<%# ddlLocalCounsel.ClientID %>');
    
    var Value = ddlLocalCounsel.value;
    
    if (Value!="0" && Value!="-1")
    {
        document.getElementById("trLCDetails").style.display='block';
        
        var txtLocalCounselDetails = document.getElementById('tcMatter_tbMatter_txtLocalCounselDetails'); //document.getElementById("<%# txtLocalCounselDetails.ClientID %>");
        
        var Details = Value.split("#");
     
        txtLocalCounselDetails.value = Details[1].replace(/<br>/g,'\n');
    }
    else
    {
        document.getElementById("trLCDetails").style.display='none';
    }
}

//for checkall and uncheckall functionality
   var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;
    
 function ClearArray()
    {
	    ids = null;
	    ids = new Array();
    }
     function StringExists(string, array)
    {
	    for (i = 0; i < array.length; i++)
	    {
		    if (array[i] == string)
			    return i;
	    }

	    return -1;
    }
    function CheckAll(obj)
    {
        ClearArray();

	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (c = 1; c <= table.rows.length-1; c++)
	    {
	     
		    var off = table.rows[c].cells[0].childNodes(0);
		    var on = table.rows[c].cells[0].childNodes(1);
		    var chk = table.rows[c].cells[0].childNodes(2);

		    off.style.display = "none";
		    on.style.display = "inline";
		    chk.checked = true;
	    }
    }
    function UncheckAll(obj)
    {
	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (u = 1; u <= table.rows.length-1; u++)
	    {
	   
		    var off = table.rows[u].cells[0].childNodes(0);
		    var on = table.rows[u].cells[0].childNodes(1);
		    var chk = table.rows[u].cells[0].childNodes(2);

		    on.style.display = "none";
		    off.style.display = "inline";
		    chk.checked = false;
	    }
    }
    
      function AddOrDrop(obj, id)
        {
	    if (obj.checked)
	    {
		    AddString(id, ids);
	    }
	    else
	    {
		    RemoveString(id, ids);
	    }

        UpdateSelected();
    }
    function AddString(string, array)
    {
	    array[array.length] = string;
    }
    function RemoveString(string, array)
    {
	    var index = StringExists(string, array);

	    if (index >= 0 && index < array.length)
	    {
		    array.splice(index, 1);
	    }

	    return array;
    }
    
   
    
     function UpdateSelected()
    {
        LoadControlsD1();
 
        txtSelected.value = ids.join(",");

        if (txtSelected.value.length > 0)
        {
            lnkDeleteConfirm.disabled = false;
        }
        else
        {
            lnkDeleteConfirm.disabled = true;
        }
    }
    function LoadControlsD1()
    {
        if (lnkDeleteConfirm == null)
        {
            lnkDeleteConfirm = document.getElementById("<%#  hypDeleteDoc.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%#  hdnCurrentDoc.ClientID %>");
        }
    }
//end



    var txtOriginalDueDate = null;
    var txtSetupFeePercentage = null;
    var txtAcquired = null;
    var txtAccountNumber = null;
    var txtOriginalAmount = null;
    var txtCurrentAmount = null;
    
    var txtCreditor = null;
    
    var chkIsVerified = null;
    var chkAddFee = null;
    var txtAddFee = null;
    var chkRetainerFee = null;
    var txtRetainerFee = null;

    var tblBody = null;
    var tblMessage = null;
    var txtAccountId = null;
    
    var txtMatterNumber = null;
    var txtMatterDate = null;
    var ddlMatterType = null;
    
    window.onload = function ()
    {
    
    }
   
    function SortPhones(obj)
    {
        document.getElementById("<%# txtSortFieldPhones.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%# Page.ClientScript.GetPostBackEventReference(lnkResortPhones, Nothing) %>;
    }
     function SortNotes(obj)
    {
        document.getElementById("<%# txtSortFieldNotes.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%# Page.ClientScript.GetPostBackEventReference(lnkResortNotes, Nothing) %>;
    }
    function SortEmails(obj)
    {
        document.getElementById("<%# txtSortFieldEmails.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%# Page.ClientScript.GetPostBackEventReference(lnkResortEmails, Nothing) %>;
    }
    function SortOverview(obj)
    {
        document.getElementById("<%# txtSortFieldOverview.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%# Page.ClientScript.GetPostBackEventReference(lnkResortOverview, Nothing) %>;
    }
    function Sort(obj)
    {
        document.getElementById("<%# txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%# Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    
    function Record_AddMatterNote()
    {
        window.location = "<%#  ResolveUrl("~/clients/client/communication/note.aspx") %>?a=am&aid=<%# AccountId%>&mid=<%# MatterId%>&id=<%# ClientId%>&ciid=<%# CreditorInstanceId%>&t=c";
    }
    
    function Record_AddMatterPhoneCall()
    {
        window.location = "<%#  ResolveUrl("~/clients/client/communication/phonecall.aspx") %>?a=am&aid=<%# AccountId%>&mid=<%# MatterId%>&id=<%# ClientId%>&ciid=<%# CreditorInstanceId%>&t=c";
    }
    
    function Record_AddExpenses()
    {
       window.location = "<%#  ResolveUrl("~/clients/client/creditors/matters/matterexpenses.aspx") %>?a=am&aid=<%# AccountId%>&mid=<%# MatterId%>&id=<%# ClientId%>&type=<%# MatterTypeId%>&ciid=<%# CreditorInstanceId%>&t=c";
    }
        
    function TaskClick(TaskID)
    {
        window.navigate("<%#  ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);
    }
            
    function Record_SendEmail()
    {
        window.location = "<%#  ResolveUrl("~/clients/client/communication/email.aspx") %>?a=am&aid=<%# AccountId%>&mid=<%# MatterId%>&id=<%# ClientId%>&ciid=<%# CreditorInstanceId%>&t=c";
        //attachWin = window.open('<%# ResolveUrl("~/clients/client/communication/email.aspx") %>?id=<%# ClientID %>&type=matter', 'Email', "toolbars=no,scrollbars=yes,menubar=no,height=700,width=950,left=0,top=0")
    }
    
    //This for pop up screen when adding a new tasks
    function OpenPropagationsForAdd()
    {
        var url = '<%# ResolveUrl("~/tasks/task/propagations.aspx") %>?a=m&mid=<%#MatterId%>&cid=<%#ClientID%>&type=<%#MatterTypeId%>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Matter Task",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 550, width: 700,
                   onClose: function(){
                        if ($(this).modaldialog("returnValue") == 1) {
                           var wnd = $(this).modaldialog("dialogArguments");
                           wnd.location = wnd.location;
                        } 
                   }});     
    }
    
    function OpenPropagationsForEdit()
    {
        var url = '<%# ResolveUrl("~/tasks/task/propagations.aspx") %>?a=m&mid=<%#MatterId%>&cid=<%#ClientID%>&type=<%#MatterTypeId%>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Edit Matter Task",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 550, width: 700,
                   onClose: function(){
                        if ($(this).modaldialog("returnValue") == 1) {
                           var wnd = $(this).modaldialog("dialogArguments");
                           wnd.location = wnd.location;
                        } 
                   }});     
    }

 
    
    function GetPropagations()
    {
        return document.getElementById("<%#  txtPropagations.ClientID %>").value;
    }

    function IsResolved()
    {
        var chkResolved = document.getElementById("<%#  chkResolved.ClientID %>");

        return chkResolved.checked;
    }
   
    function Record_SaveConfirm()
    {
        if (Record_RequiredExist())
        {
            
          Record_Display("Saving changes...");
            <%#  ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
   
    function Record_Save(IsVerified)
    {
        chkIsVerified.checked = IsVerified;

        // postback to save
        Record_Display("Saving new account...");
        <%#  ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
   
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%#  dvError.ClientID %>");
	    var tdError = document.getElementById("<%#  tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function HideMessage()
	{
	    var dvError = document.getElementById("<%#  dvError.ClientID %>");
	    var tdError = document.getElementById("<%#  tdError.ClientID %>");

	    tdError.innerHTML = "";
	    dvError.style.display = "none";
	}
	function LoadControls()
	{
          	
	      txtAccountNumber = document.getElementById("<%# txtAccountNumber.ClientID %>");
	      txtMatterNumber = document.getElementById("<%# txtMatterNumber.ClientID %>");
	      txtMatterDate  = document.getElementById("<%# txtMatterDate.ClientID%>");
	      tblBody = document.getElementById("<%#  tblBody.ClientID %>");
          tblMessage = document.getElementById("<%#  tblMessage.ClientID %>");
          ddlMatterType = document.getElementById("<%#  ddlMatterType.ClientID %>");
  
	}

	//verified required record exist 
    function Record_RequiredExist()
    {
        LoadControls();

        if (!IsValidDateTime(txtMatterDate.value))
        {
            ShowMessage("Invalid Matter date.  The Matter Date field is required.");
            AddBorder(txtMatterDate);
            return false;
        }
        if(ddlMatterType.value=="0")
        {
            ShowMessage("Matter Type is a required field");
            ddlMatterType.disabled=false;
            AddBorder(ddlMatterType);
            return false;
        }
        
        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
    {
        LoadControlsD1();
        if (!lnkDeleteConfirm.disabled)
        {
            ConfirmationModalDialog({window: window, 
                                 title: "Delete Matter Document", 
                                 callback: "DeleteDocument", 
                                 message: "Are you sure you want to delete this selection document from the matter?"});        
         }
    }
    function Record_Delete()
    {
        // postback to delete
        Record_Display("Deleting account...");
        <%#  ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
   
    function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
    {
        btn.nextSibling.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;0

        btn.creditorid=creditorid;
        btn.creditor=name;
        btn.street=street;
        btn.street2=street2;
        btn.city=city;
        btn.stateid=stateid;
        btn.statename=statename;
        btn.stateabbreviation=stateabbreviation;
        btn.zipcode=zipcode;
        btn.creditorgroupid=creditorgroupid;
        btn.validated=validated;

        btn.parentElement.previousSibling.firstChild.innerHTML=name;
    }

    function FindCreditor(btn)
    {
        var creditor = btn.creditor;
        var street = btn.street;
        var street2 = btn.street2;
        var city = btn.city;
        var stateid = btn.stateid;
        var zipcode = btn.zipcode;

        if (creditor==null)creditor="";
        if (street==null)street="";
        if (street2==null)street2="";
        if (city==null)city="";
        if (stateid==null)stateid="";
        if (zipcode==null)zipcode="";

        // open the find window
        var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>' + 
                    'creditor=' + encodeURIComponent(creditor) + 
                    '&street=' + encodeURIComponent(street) + 
                    '&street2=' + encodeURIComponent(street2) + 
                    '&city=' + encodeURIComponent(city) + 
                    '&stateid=' + encodeURIComponent(stateid) + 
                    '&zipcode=' + encodeURIComponent(zipcode);
                    
        window.dialogArguments = new Array(window, btn, "CreditorFinderReturn");
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
            dialogArguments: window,
            resizable: false,
            scrollable: false,
            height: 700, width: 650
        });   
    }
    
    function Record_Display(Message)
    {
        LoadControls();

        tblBody.style.display = "none";
        tblMessage.style.display = "inline";
        tblMessage.rows[0].cells[0].innerHTML = Message;
    }
    </script>

    <script type="text/javascript" language="javascript">
        var attachWin;
        var intAttachWin;
        
        var scanWin;
        var intScanWin;
        
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                        
                    obj.parentElement.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        function RowClick(tr, docRelID)
        {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#ededed";
            tr.style.backgroundColor = "#f0f0f0";
            
            document.getElementById('<%# hdnCurrentDoc.ClientID %>').value = docRelID;
            
            //set this as last
            tbl.lastSelTr = tr;
        }
        /*
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%# hdnTempAccountID.ClientID %>').value + '&temp=1';
            
            attachWin = window.open('<%# ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%# ClientID %>&type=matter&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
            intAttachWin = setInterval('WaitAttached()', 500);
        }
        */
        function AttachDocument()
        {
            var w = 800;
            var h = 600;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%# hdnTempMatterID.ClientID %>').value + '&temp=1';
            var url = '<%# ResolveUrl("~/util/pop/attachmatterdocument.aspx") %>?a=m&id=<%# ClientID %>&typeid=<%#MatterTypeId%>&type=matter&aid=<%#request.querystring("aid")%>&rel='+relID;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Attach Document",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 700,
                       onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                            if (attachWin == -1) {
                                Record_Display("Attaching the document to the matter....");
                                <%#Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
                            }
                         }
                       });  
        }
        function CreatePreJudgment()
        {
            //write code here
            var url = '<%# ResolveUrl("~/clients/client/creditors/matters/prejudgment.aspx") %>?a=m&id=<%#request.querystring("id")%>';
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "PreJudgment Intake",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 700
                       });   
            
        }
        
        function CreateIntake()
        {
             var url = '<%# ResolveUrl("~/clients/client/creditors/matters/Intake.aspx") %>?a=m&id=<%#request.querystring("id")%>&typeid=<%#MatterTypeId%>&ciid=<%#request.querystring("ciid")%>&mid=<%#request.querystring("mid")%>&aid=<%#request.querystring("aid")%>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Client Intake Form",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 870,
                       onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                            postCreateIntake();
                         }
                       });     
        }
        
         function postCreateIntake(){
            if(attachWin ==-1){
                Record_Display("Successfully saved and attached to matter instance.");
                <%#Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
            else if(attachWin==1){
                 window.location = "<%# ResolveUrl("~/clients/client/communication/email.aspx") %>?a=am&aid=<%#AccountId%>&mid=<%#MatterId%>&id=<%#ClientId%>&ciid=<%#CreditorInstanceId%>&t=c&s=i"; 
            }
        }
        
        function CreatePostJudgment()
        {
            //write code here
            var url = '<%# ResolveUrl("~/clients/client/creditors/matters/postjudgment.aspx") %>?a=m&id=<%#request.querystring("id")%>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "PostJudgment Intake",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 700
                       });      
            
        }
        
        
        function WaitAttached()
        {
            if (attachWin.closed)
            {
                clearInterval(intAttachWin);
                <%# Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function DeleteDocument()
        {
            if (document.getElementById('<%# hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                Record_Display("Deleting the attachment for the matter....");
                <%# Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function OpenScanning()
        {
            var relID = document.getElementById('<%# hdnTempAccountID.ClientID %>').value;
            
            scanWin = window.open('<%# ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%# ClientID %>&type=matter&temp=1' + '&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
            intScanWin = setInterval('WaitScanned()', 500);
        }
        function WaitScanned()
        {
            if (scanWin.closed)
            {
                clearInterval(intScanWin);
                <%# Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function UploadDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
             var relID = document.getElementById('<%# hdnTempMatterID.ClientID %>').value;
             var url = '<%# ResolveUrl("~/util/pop/Uploadmatterdocument.aspx") %>?a=m&type=matter&temp=1&id=<%#request.querystring("id")%>&rel=<%#hdnTempMatterID.value %>&ciid=<%#CreditorInstanceId %>&aid=<%#request.querystring("aid")%>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Upload Matter Document",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 350, width: 700,
                       onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                            if(attachWin ==-1)
                            {
                                Record_Display("Successfully uploaded and attached to matter instance.");
                                <%#Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
                            }
                         }
                       });      
        }
        function CloseParentLoading(){
            window.parent.FrameLoaded();
        }
    </script>

</head>
<body >
    <form id="formMatterPop" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="smMatter" runat="server" />
    <asp:UpdatePanel ID="upPopHolder" runat="server">
        <ContentTemplate>
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
                border="0" cellpadding="0" cellspacing="15">
                <tr>
                    <td style="color: #666666; font-size: 13px;">
                        <a id="lnkClient" runat="server" class="lnk" style="font-size: 11px; color: #666666;">
                        </a>&nbsp;>&nbsp;<a id="lnkAccounts" runat="server" class="lnk" style="font-size: 11px;
                            color: #666666;">Accounts</a>&nbsp;>&nbsp;<a id="lnkPerson" runat="server" class="lnk"
                                style="font-size: 11px; color: #666666;"></a>&nbsp;>&nbsp;Matter Instance
                    </td>
                </tr>
                <tr id="trError" runat="server" style="display: none;">
                    <td valign="top">
                        <div>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div runat="server" id="dvError" style="display: none;">
                                            <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                                width="100%" border="0">
                                                <tr>
                                                    <td valign="top" style="width: 20;">
                                                        <img id="imgMsg" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                                    </td>
                                                    <td runat="server" id="tdError">
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <ajaxToolkit:TabContainer ID="tcMatter" runat="server" CssClass="tabContainer" Height="450px">
                            <ajaxToolkit:TabPanel ID="tbMatter" runat="server">
                                <HeaderTemplate>
                                    Matter
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <table style="margin: 0 30 30 0; float: left; font-family: tahoma; font-size: 11px;
                                        width: 300;" border="0" cellpadding="5" cellspacing="0">
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="background-color: #f1f1f1;">
                                                Matter Instance Information
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                                    cellspacing="5">
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Matter Type:
                                                        </td>
                                                        <td class="entrytitlecell">
                                                            <asp:DropDownList caption="Matter Type" TabIndex="1" CssClass="entry" runat="server"
                                                                Width="250px" ID="ddlMatterType">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true">
                                                            Matter Date:
                                                        </td>
                                                        <td>
                                                            <cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true"
                                                                TabIndex="2" Width="250px" ReadOnly="True" CssClass="entry" ID="txtMatterDate"
                                                                runat="server" Mask="nn/nn/nnnn" OnRegexMatch="" OnRegexNoMatch="" OnWrongKeyPressed=""
                                                                RegexPattern=""></cc1:InputMask>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true">
                                                            Account Number:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtAccountNumber" ReadOnly="True" Width="250px" runat="server" CssClass="entry"
                                                                TabIndex="3"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr id="trCreditor" runat="server">
                                                        <td class="entrytitlecell" runat="server">
                                                            Creditor:
                                                        </td>
                                                        <td class="entrytitlecell" runat="server">
                                                            <asp:DropDownList caption="Creditor" TabIndex="1" CssClass="entry" runat="server"
                                                                Width="250px" ID="ddlCreditors" AutoPostBack="True">
                                                            </asp:DropDownList>
                                                            <asp:TextBox ID="txtCreditor" ReadOnly="True" Width="250px" runat="server" CssClass="entry"
                                                                TabIndex="3" Visible="False"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true" style="width: 95px">
                                                            Matter Number:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtMatterNumber" ReadOnly="True" Width="250px" runat="server" CssClass="entry"
                                                                TabIndex="4"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Matter Status:
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList caption="Matter Status" TabIndex="5" CssClass="entry" runat="server"
                                                                Width="250px" ID="ddlMatterStatusCode" AutoPostBack="True" OnSelectedIndexChanged="ddlMatterStatusCode_SelectedIndexChanged">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Matter Sub Status:
                                                        </td>
                                                        <td class="entrytitlecell">
                                                            <asp:DropDownList caption="Matter Sub Status" TabIndex="8" CssClass="entry" runat="server"
                                                                Width="250px" ID="ddlMatterSubStatusCode">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr id="trLocalCounsel" runat="server">
                                                        <td class="entrytitlecell" runat="server">
                                                            Local Counsel:
                                                        </td>
                                                        <td runat="server">
                                                            <asp:DropDownList caption="Local Counsel" TabIndex="6" CssClass="entry" runat="server"
                                                                Width="250px" ID="ddlLocalCounsel">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr id="trLCDetails" style="display: none">
                                                        <td class="entrytitlecell">
                                                            Local Counsel Details:
                                                        </td>
                                                        <td class="entrytitlecell">
                                                            <asp:TextBox TabIndex="8" Width="250px" runat="server" ID="txtLocalCounselDetails"
                                                                Rows="5" TextMode="MultiLine" ReadOnly="True"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" valign="top">
                                                            Classification:
                                                        </td>
                                                        <td>
                                                            <asp:ListBox ID="ddlClassification" runat="server" TabIndex="7" CssClass="entry"
                                                                Width="250px" SelectionMode="Multiple"></asp:ListBox>
                                                        </td>
                                                    </tr>
                                                    <tr id="trMessage" runat="server">
                                                        <td class="entrytitlecell" colspan="2" runat="server">
                                                            Matter Description:<br />
                                                            <asp:TextBox TabIndex="8" CssClass="entry" runat="server" ID="txtMatterMemo2" Rows="7"
                                                                TextMode="MultiLine" MaxLength="1000" Columns="50" Style="width: 50em"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbOverview" runat="server" Width="100">
                                <HeaderTemplate>
                                    <asp:Label ID="lblOverview" runat="server" Text="Overview" />
                                    <asp:Label ID="lblOverviewCnt" runat="server" ForeColor="blue" />
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <!-- put overview of Matters in content page here -->
                                    <asp:GridView ID="gvOverview" runat="server" AutoGenerateColumns="false" DataSourceID="dsOverview"
                                        AllowSorting="true" AllowPaging="true" CssClass="entry" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <img id="imgIcon" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <img src="<%# GetImage(DataBinder.Eval(Container.DataItem, "type").ToString(),DataBinder.Eval(Container.DataItem, "direction"))%>"
                                                        border="0" />
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" />
                                                <ItemStyle CssClass="listItem" />
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <img id="imgPaperClip" runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" />
                                                <ItemStyle CssClass="listItem" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="date" SortExpression="date" HeaderText="Date" DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="by" SortExpression="by" HeaderText="By" HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    Message
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "ShortMessage".Replace("-Not Available", ""))%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    Duration
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# PhoneCallDuration(DataBinder.Eval(Container.DataItem, "starttime"), DataBinder.Eval(Container.DataItem, "endtime"))%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <asp:Panel runat="server" ID="pnlNoOverview" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no tasks or emails or notes or phone calls for this matter</asp:Panel>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsOverview" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetOverviewForMatter"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="10" Name="ReturnTop" Type="Int32" />
                                            <asp:Parameter DefaultValue="" Name="MatterID" Type="Int32" />
                                            <asp:Parameter DefaultValue="" Name="OrderBy" Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <input type="hidden" runat="server" id="hdnOverview" />
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbTasks" runat="server">
                                <HeaderTemplate>
                                    <asp:Label ID="lblTasks" runat="server" Text="Tasks" />
                                    <asp:Label ID="lblTasksCnt" runat="server" ForeColor="blue" />
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <!-- put Tasks related to Matters in content page here -->
                                    <asp:GridView ID="gvTasks" runat="server" AutoGenerateColumns="false" DataSourceID="dsTasks"
                                        AllowSorting="true" AllowPaging="true" CssClass="entry" GridLines="None">
                                        <Columns>
                                            <asp:BoundField DataField="tasktype" SortExpression="tasktype" HeaderText="Task Type"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="description" SortExpression="description" HeaderText="Task Description"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="createdby" SortExpression="createdby" HeaderText="Task Creator"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="assignedto" SortExpression="assignedto" HeaderText="Assigned To"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="createddate" SortExpression="createddate" HeaderText="Created Date"
                                                HtmlEncode="false" DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="duedate" SortExpression="duedate" HeaderText="Due Date"
                                                HtmlEncode="false" DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="resolved" SortExpression="resolved" HeaderText="Resolved Date"
                                                HtmlEncode="false" DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="TaskResolutionId" SortExpression="TaskResolutionId" HeaderText="Status"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <asp:Panel runat="server" ID="pnlNoTasks" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no tasks for this matter</asp:Panel>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsTasks" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetMattertasks2"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="" Name="MatterID" Type="Int32" />
                                            <asp:Parameter DefaultValue="" Name="OrderBy" Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <input type="hidden" runat="server" id="hdnTasksCount" />
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbNotes" runat="server">
                                <HeaderTemplate>
                                    <asp:Label ID="lblNotes" runat="server" Text="Notes" />
                                    <asp:Label ID="lblNotesCnt" runat="server" ForeColor="blue" />
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <asp:GridView ID="gvNotes" runat="server" AutoGenerateColumns="true" DataSourceID="dsNotes"
                                        AllowSorting="true" AllowPaging="true" CssClass="entry" GridLines="None">
                                        <Columns>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <asp:Panel runat="server" ID="pnlNoOverview" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no notes for this matter</asp:Panel>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsNotes" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetMatterPopNotes"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="" Name="MatterID" Type="Int32" />
                                            <asp:Parameter DefaultValue="" Name="OrderBy" Type="String" ConvertEmptyStringToNull="true" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbPhones" runat="server">
                                <HeaderTemplate>
                                    <asp:Label ID="lblPhones" runat="server" Text="Phones" />
                                    <asp:Label ID="lblPhonesCnt" runat="server" ForeColor="blue" />
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <!-- put Phones of Matters in content page here -->
                                    <asp:GridView ID="gvPhone" runat="server" AutoGenerateColumns="false" DataSourceID="dsPhone"
                                        AllowSorting="true" AllowPaging="true" CssClass="entry" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <img id="imgIcon" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <img src="<%# GetImage(DataBinder.Eval(Container.DataItem, "type").ToString(),DataBinder.Eval(Container.DataItem, "direction"))%>"
                                                        border="0" />
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" />
                                                <ItemStyle CssClass="listItem" />
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <img id="imgPaperClip" runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" />
                                                <ItemStyle CssClass="listItem" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="date" SortExpression="date" HeaderText="Date" DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="by" SortExpression="by" HeaderText="By" HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    Message
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# GetAttachmentText(CType(Container.DataItem, GridPhoneCall).PhoneCallID, "phonecall")%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="UserName" SortExpression="UserName" HeaderText="UserName"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="UserType" SortExpression="UserType" HeaderText="UserType"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="PersonName" SortExpression="PersonName" HeaderText="PersonName"
                                                HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CallDate" SortExpression="CallDate" HeaderText="CallDate"
                                                HtmlEncode="false" DataFormatString="{0:MM/dd/yyyy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    Message
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# CType(Container.DataItem, GridPhoneCall).Duration%>&nbsp;&nbsp;(<%# CType(Container.DataItem, GridPhoneCall).CallDate.ToString("hh:mm tt")%><img
                                                        style="margin: 0 5 0 5" border="0" align="absmiddle" src="<%# ResolveURL("~/images/16x16_arrowright (thin gray).png")%>" /><%# CType(Container.DataItem, GridPhoneCall).CallDateEnd.ToString("hh:mm tt")%>)
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <asp:Panel runat="server" ID="pnlNoOverview" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no phone calls for this matter</asp:Panel>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsPhone" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetMatterPhoneCalls"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="" Name="MatterID" Type="Int32" />
                                            <asp:Parameter DefaultValue="" Name="OrderBy" Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbEmails" runat="server">
                                <HeaderTemplate>
                                    <asp:Label ID="lblEmails" runat="server" Text="Emails" />
                                    <asp:Label ID="lblEmailsCnt" runat="server" ForeColor="blue" />
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <!-- put Emails of Matters in content page here -->
                                    <asp:GridView ID="gvEmails" runat="server" AutoGenerateColumns="false" DataSourceID="dsEmails"
                                        AllowSorting="true" AllowPaging="true" CssClass="entry" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <img id="imgPaperClip" runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" />
                                                <ItemStyle CssClass="listItem" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="emaildate" SortExpression="emaildate" HeaderText="Date"
                                                DataFormatString="{0:MMM dd,yy}">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="by" SortExpression="by" HeaderText="By" HtmlEncode="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:BoundField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    Message
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "ShortMessage")%>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <asp:Panel runat="server" ID="pnlNoOverview" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no emails for this matter</asp:Panel>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsEmails" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetMatterEMails"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="" Name="MatterID" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="tbDocuments" runat="server">
                                <HeaderTemplate>
                                    Documents</HeaderTemplate>
                                <ContentTemplate>
                                    <table class="entry">
                                        <tr>
                                            <td class="entrytitlecell" colspan="3" style="width: 100%; padding-top: 10px">
                                                <table id="tblDocuments" style="font-family: tahoma; font-size: 11px; width: 100%;"
                                                    border="0" cellpadding="5" cellspacing="0" runat="server">
                                                    <tr>
                                                        <td style="background-color: #f1f1f1;">
                                                            Document
                                                        </td>
                                                        <td style="background-color: #f1f1f1; display: none;" align="right">
                                                            </a> <span id="dvActions" runat="Server" style="display: none"><a style="color: rgb(51,118,171);"
                                                                href="javascript:UploadDocument();" class="lnk">Upload Doc</a>&nbsp;|&nbsp;<a class="lnk"
                                                                    href="javascript:CreateIntake();">Client Intake Form</a>&nbsp;|&nbsp;</span><a class="lnk"
                                                                        href="javascript:AttachDocument();">Attach Document</a>&nbsp;|&nbsp;<a class="lnk"
                                                                            id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirm();">Delete</a>
                                                        </td>
                                                    </tr>
                                                    <tr id="tr2" runat="server">
                                                        <td colspan="2">
                                                            <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list"
                                                                style="font-family: tahoma; font-size: 11px; width: 100%;" cellspacing="0" cellpadding="3">
                                                                <thead>
                                                                    <tr>
                                                                        <th align="center" style="width: 20;" class="headItem">
                                                                            <img id="Img22" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);"
                                                                                style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                                                border="0" /><img id="Img23" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);"
                                                                                    style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                                                                    border="0" />
                                                                        </th>
                                                                        <th style="width: 20px;" align="center">
                                                                            <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                        </th>
                                                                        <th style="width: 11px;">
                                                                            &nbsp;
                                                                        </th>
                                                                        <th align="left" style="width: 40%;">
                                                                            Document Name
                                                                        </th>
                                                                        <th align="left" style="width: 100px; display: none;">
                                                                            Origin
                                                                        </th>
                                                                        <th align="left">
                                                                            Received
                                                                        </th>
                                                                        <th align="left">
                                                                            Created
                                                                        </th>
                                                                        <th align="left">
                                                                            Created By
                                                                        </th>
                                                                        <th style="width: 20px;" align="right">
                                                                        </th>
                                                                        <th align="right" style="width: 10px;">
                                                                            &nbsp;
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <asp:Repeater runat="server" ID="rpDocuments">
                                                                        <ItemTemplate>
                                                                            <a href="#" onclick="javascript:RowClick(this.childNodes(0), <%# CType(Container.DataItem.DocRelationID, Integer) %>);">
                                                                                <tr>
                                                                                    <td ischeck="true" class="noBorder" style="padding-top: 7; width: 20;" valign="top"
                                                                                        align="center" class="listItem">
                                                                                        <img id="Img26" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                                                            runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                                                                id="Img27" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                                                                style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                                                                align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%# CType(Container.DataItem.DocRelationID, Integer) %>);"
                                                                                                    style="display: none;" type="checkbox" />
                                                                                    </td>
                                                                                    <td style="width: 20px;" align="center">
                                                                                        <img id="imgFileNew" runat="server" src="~/images/16x16_file_new.png" border="0"
                                                                                            align="absmiddle" />
                                                                                    </td>
                                                                                    <td style="width: 11px;">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td align="left" style="width: 40%;">
                                                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%# CType(Container.DataItem.DocumentPath, String).Replace("\", "\\").Replace("'","\'") %>');">
                                                                                            <%# CType(Container.DataItem.DocumentType, String) %>
                                                                                        </a>
                                                                                    </td>
                                                                                    <td align="left" style="width: 100px; display: none;">
                                                                                        <%# CType(Container.DataItem.Origin, String) %>&nbsp;
                                                                                    </td>
                                                                                    <td align="left">
                                                                                        <%# CType(Container.DataItem.Received, String) %>&nbsp;
                                                                                    </td>
                                                                                    <td align="left">
                                                                                        <%# CType(Container.DataItem.Created, String) %>&nbsp;
                                                                                    </td>
                                                                                    <td align="left">
                                                                                        <%# CType(Container.DataItem.CreatedBy, String) %>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 20px;" align="right">
                                                                                        <%# IIf(Not CType(Container.DataItem.Existence, Boolean), "<img src=""" + ResolveUrl("~/images/16x16_no_file.png") + """ border=""0"" align=""absmiddle"" />", "&nbsp;") %>
                                                                                    </td>
                                                                                    <td align="right" style="width: 10px;">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                </tr>
                                                                            </a>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <!-- Start Listing Legacy Document -->
                                        <tr>
                                            <td class="entrytitlecell" colspan="3" style="width: 100%; padding-top: 10px">
                                                <table id="tblLegacyDocuments" style="font-family: tahoma; font-size: 11px; width: 100%;"
                                                    border="0" cellpadding="5" cellspacing="0" runat="server">
                                                    <tr>
                                                        <td style="background-color: #f1f1f1;">
                                                            Legacy Documents
                                                        </td>
                                                        <td style="background-color: #f1f1f1;" align="right">
                                                        </td>
                                                    </tr>
                                                    <tr id="tr1" runat="server">
                                                        <td colspan="2">
                                                            <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list"
                                                                style="font-family: tahoma; font-size: 11px; width: 100%;" cellspacing="0" cellpadding="3">
                                                                <thead>
                                                                    <tr>
                                                                        <th align="center" style="width: 20;" class="headItem">
                                                                            <img id="Img20" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);"
                                                                                style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                                                border="0" /><img id="Img24" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);"
                                                                                    style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                                                                    border="0" />
                                                                        </th>
                                                                        <th style="width: 20px;" align="center">
                                                                            <img id="Img25" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                                        </th>
                                                                        <th style="width: 11px;">
                                                                            &nbsp;
                                                                        </th>
                                                                        <th align="left" style="width: 40%;">
                                                                            Document Name
                                                                        </th>
                                                                        <th align="left" style="width: 100px; display: none;">
                                                                            Origin
                                                                        </th>
                                                                        <th align="left">
                                                                            Received
                                                                        </th>
                                                                        <th align="left">
                                                                            Created
                                                                        </th>
                                                                        <th align="left">
                                                                            File Size
                                                                        </th>
                                                                        <th style="width: 20px;" align="right">
                                                                        </th>
                                                                        <th align="right" style="width: 10px;">
                                                                            &nbsp;
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <asp:Repeater runat="server" ID="rpLegacyDocs">
                                                                        <ItemTemplate>
                                                                            <tr>
                                                                                <td ischeck="true" class="noBorder" style="padding-top: 7; width: 20;" valign="top"
                                                                                    align="center" class="listItem">
                                                                                    <img id="Img26" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                                                        runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                                                            id="Img27" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                                                            style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                                                            align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%# CType(Container.DataItem.Length, Integer) %>);"
                                                                                                style="display: none;" type="checkbox" />
                                                                                </td>
                                                                                <td style="width: 20px;" align="center">
                                                                                    <img id="imgFileNew" runat="server" src="~/images/16x16_file_new.png" border="0"
                                                                                        align="absmiddle" />
                                                                                </td>
                                                                                <td style="width: 11px;">
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td align="left" style="width: 40%;">
                                                                                    <a href="#" class="lnk" onclick="javascript:window.open('<%# CType(Container.DataItem.DirectoryName, String).Replace("\", "\\") %><%# "\\" %><%# CType(Container.DataItem.Name, String)%>');">
                                                                                        <%# CType(Container.DataItem.Name, String)%>
                                                                                    </a>
                                                                                </td>
                                                                                <td align="left" style="width: 100px; display: none;">
                                                                                    <%# CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                                                </td>
                                                                                <td align="left">
                                                                                    <%# CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                                                </td>
                                                                                <td align="left">
                                                                                    <%# CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                                                </td>
                                                                                <td align="left">
                                                                                    <%# CType(Container.DataItem.length, String)%>&nbsp;
                                                                                </td>
                                                                                <td style="width: 20px;" align="right">
                                                                                </td>
                                                                                <td align="right" style="width: 10px;">
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            </a>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <!-- End Listing Legacy Document -->
                                    </table>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                        </ajaxToolkit:TabContainer>
                    </td>
                </tr>
                <tr align="left">
                    <td>
                        <table class="entry">
                            <tr>
                                <td>
                                    <asp:LinkButton ID="lnkSaveMatter" runat="server" Text="Save Matter" CssClass="lnk" />
                                    <asp:Literal ID="litSpace" runat="server" Text=" | " />
                                    <asp:LinkButton ID="lnkResolveMatter" runat="server" Text="Resolve Matter" CssClass="lnk" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table runat="server" id="tblMessage" style="color: #666666; display: none; font-family: tahoma;
                font-size: 13px;" border="0" cellpadding="0" cellspacing="15">
                <tr>
                    <td>
                    </td>
                    <td>
                        <img id="Img21" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" />
                    </td>
                </tr>
            </table>
            <div id="updatePopHolderDiv" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkSaveMatter" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updatePopHolderDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('tblPopHolder');

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
            var updateProgressDiv = $get('tblPopHolder');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaePopHolder" BehaviorID="PopHolderanimation"
        runat="server" TargetControlID="upPopHolder">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="tblPopHolder" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="tblPopHolder" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <input id="hdnCurrentDoc" type="hidden" runat="server" />
    <input id="hdnTempAccountID" type="hidden" runat="server" />
    <input id="hdnTempMatterID" type="hidden" runat="server" />
    <asp:CheckBox runat="server" ID="chkIsVerified" Style="display: none;"></asp:CheckBox>
    <asp:CheckBox runat="server" ID="chkAddFee" Style="display: none;"></asp:CheckBox>
    <asp:CheckBox runat="server" ID="chkRetainerFee" Style="display: none;"></asp:CheckBox>
    <asp:CheckBox runat="server" ID="chkResolved" Style="display: none;" />
    <asp:HiddenField runat="server" ID="txtAddFee"></asp:HiddenField>
    <asp:HiddenField runat="server" ID="txtRetainerFee"></asp:HiddenField>
    <asp:HiddenField runat="server" ID="txtPropagations" />
    <input type="hidden" runat="server" id="txtSortField" />
    <input type="hidden" runat="server" id="txtSortFieldNotes" />
    <input type="hidden" runat="server" id="txtSortFieldPhones" />
    <input type="hidden" runat="server" id="txtSortFieldEmails" />
    <input type="hidden" runat="server" id="txtSortFieldOverview" />
    <asp:LinkButton ID="lnkShowDocs" runat="server" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkResortNotes" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkResortPhones" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkResortEmails" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkResortOverview" runat="server"></asp:LinkButton>
    <%--<asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>--%>
    <asp:LinkButton runat="server" ID="lnkSave" />
    <asp:LinkButton runat="server" ID="lnkSaveClose" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <input type="hidden" runat="server" id="hdnLatestCreditorId" value="0" />
    </form>
</body>
</html>
