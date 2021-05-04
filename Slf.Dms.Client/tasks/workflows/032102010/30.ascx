<%@ Control Language="VB" AutoEventWireup="false" CodeFile="30.ascx.vb" Inherits="tasks_workflows_30" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Reference Page="~/tasks/task/resolve.aspx" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
<style type="text/css">
    .style2
    {
        width: 10%;
    }
    .box
    {
        border: 1px solid #CCCCCC;
    }
</style>

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\xptabstrip.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\rgbcolor.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\grid.js") %>"></script>

<script type="text/javascript">

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
            lnkDeleteConfirm = document.getElementById("<%= hypDeleteDoc.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= hdnCurrentDoc.ClientID %>");
        }
    }
//end


    var txtAcquired = null;
    var txtAccountNumber = null;
    var txtOriginalAmount = null;
    var txtCurrentAmount = null;
    
    var hdnCreditor = null;
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
    
    window.onload = function ()
    {
    
    }
   
    function SortPhones(obj)
    {
        document.getElementById("<%=txtSortFieldPhones.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResortPhones, Nothing) %>;
    }
     function SortNotes(obj)
    {
        document.getElementById("<%=txtSortFieldNotes.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResortNotes, Nothing) %>;
    }
    function SortEmails(obj)
    {
        document.getElementById("<%=txtSortFieldEmails.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResortEmails, Nothing) %>;
    }
    function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    
    function Record_AddMatterNote()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/note.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&t=c";
    }
    
    function Record_AddMatterPhoneCall()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/phonecall.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&t=c";
    }
    
    function Record_AddExpenses()
    {
       window.location = "<%= ResolveUrl("~/clients/client/creditors/matters/matterexpenses.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&t=c";
    }
    
    function Record_AddExpenses2()
    {
       window.location = "<%= ResolveUrl("~/clients/client/creditors/matters/matterexpenses2.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&t=c";
    }
        
    function Record_SendEmail()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/email.aspx") %>?a=am&type=matter&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&t=c";
        //attachWin = window.open('<%=ResolveUrl("~/clients/client/communication/email.aspx") %>?id=<%=ClientID %>&type=matter', 'Email', "toolbars=no,scrollbars=yes,menubar=no,height=700,width=950,left=0,top=0")
    }
    
    //This for pop up screen when adding a new tasks
    
//    function OpenPropagations()
//    {
//        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Edit Matter Task &a=m&p=<%= ResolveUrl("~/tasks/task/propagations.aspx") %>&mid=<%=MatterId%>", window, "status:off;help:off;dialogWidth:850px;dialogHeight:450px");
//    }

    function SavePropagations(Value)
    {
        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
        var lblPropagations = document.getElementById("<%= lblPropagations.ClientID %>");

        txtPropagations.value = Value;

        var NumValues = 0;

        if (Value.length > 0)
        {
            NumValues = Value.split("|").length;
        }

        if (NumValues > 0)
        {
            lblPropagations.innerText = " (" + NumValues + ")";
        }
        else
        {
            lblPropagations.innerText = "";
        }
    }
    
    function GetPropagations()
    {
        return "";//document.getElementById("<%= txtPropagations.ClientID %>").value;
    }

    function IsResolved()
    {
        var chkResolved = document.getElementById("<%= chkResolved.ClientID %>");

        return chkResolved.checked;
    }

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        // ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) 
    }
    function Record_SaveConfirm()
    {
        if (Record_RequiredExist())
        {
          Record_Display("Saving changes...");
          //ClientScript.GetPostBackEventReference(lnkSave, Nothing)  
        }
    }
    function Record_Save(IsVerified)
    {
    
     document.getElementById("<%=hdnTaskResolutionID.ClientID %>").value = cboParentTaskResolutionID.value
        document.getElementById("<%=txtResolved.ClientID %>").value = txtResolved.value
         <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
      //  chkIsVerified.checked = IsVerified;

        // postback to save
      //  Record_Display("Saving new account...");
         // ClientScript.GetPostBackEventReference(lnkSave, Nothing)
    }
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function HideMessage()
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    tdError.innerHTML = "";
	    dvError.style.display = "none";
	}
	function LoadControls()
	{
          	
	      
  
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
 
        HideMessage()
	    return true;
    }
	/*function Record_DeleteConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=Record_Delete&t=Delete Creditor Instance&m=Are you sure you want to delete this Creditor Instance?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
	}*/
	function Record_DeleteConfirm()
    {
        LoadControlsD1();
        if (!lnkDeleteConfirm.disabled)
        {
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=DeleteDocument&t=Delete Matter Document&m=Are you sure you want to delete this selection document from the matter?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
        
          //  showModalDialog("<%= ResolveUrl("~/deleteholder.aspx?f=DeleteDocument&t=Matter Document&p=selection of matter documents") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
        }
    }
    function Record_Delete()
    {
        // postback to delete
        Record_Display("Deleting account...");
       // ClientScript.GetPostBackEventReference(lnkDelete, Nothing) 
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
        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Find Creditor&p=findcreditorgroup.aspx") %>" + 
            "&creditor=" + encodeURIComponent(creditor) + 
            "&street=" + encodeURIComponent(street) + 
            "&street2=" + encodeURIComponent(street2) + 
            "&city=" + encodeURIComponent(city) + 
            "&stateid=" + encodeURIComponent(stateid) + 
            "&zipcode=" + encodeURIComponent(zipcode), 
            new Array(window, btn, "CreditorFinderReturn"), "status:off;help:off;dialogWidth:650px;dialogHeight:530px");
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
                    lastTr.style.backgroundColor = lastTr.coldColor;
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
            
            document.getElementById('<%=hdnCurrentDoc.ClientID %>').value = docRelID;
            
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
            
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value + '&temp=1';
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=matter&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
            intAttachWin = setInterval('WaitAttached()', 500);
        }
        */
        function AttachDocument()
        {
            var w = 800;
            var h = 600;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%=hdnTempMatterID.ClientID %>').value + '&temp=1';
            
            //attachWin = window.open('<%=ResolveUrl("~/util/pop/attachmatterdocument.aspx") %>?id=<%=ClientID %>&type=matter&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            //intAttachWin = setInterval('WaitAttached()', 500);
           // alert("")
            attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Attach Document&a=m&p=<%= ResolveUrl("~/util/pop/attachmatterdocument.aspx") %>&id=<%= ClientID %>&ciid=<%=CreditorInstanceId %>&type=matter&rel="+relID, window, "status:off;help:off;dialogWidth:850px;dialogHeight:450px");
            if(attachWin ==-1)
            {
               // Record_Display("Attaching the document to the matter....");
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function CreatePreJudgment()
        {
            //write code here
            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=PreJudgmentIntake&a=m&p=<%= ResolveUrl("~/clients/client/creditors/matters/prejudgment.aspx") %>&id=<%=request.querystring("id")%>", window, "status:off;help:off;dialogWidth:850px;dialogHeight:650px");
            
        }
        
        function CreateIntake()
        {
            //write code here 
//          attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Client Intake Form&a=m&p=<%= ResolveUrl("~/clients/client/creditors/matters/Intake.aspx") %>&id=<%=request.querystring("id")%>&mid=<%=request.querystring("mid")%>&aid=<%=request.querystring("aid")%>", window, "status:off;help:off;dialogWidth:950px;dialogHeight:740px");
          attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Client Intake Form&a=m&p=<%= ResolveUrl("~/clients/client/creditors/matters/Intake.aspx") %>&id=<%=ClientID %>&mid=<%=MatterId%>&aid=<%=AccountId%>", window, "status:off;help:off;dialogWidth:950px;dialogHeight:740px");
          
          if(attachWin ==-1)
          {
            Record_Display("Successfully saved and attached to matter instance.");
            <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
          }
            
        }
        
         function CreatePostJudgment()
        {
            //write code here
            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=PostJudgmentIntake&a=m&p=<%= ResolveUrl("~/clients/client/creditors/matters/postjudgment.aspx") %>&id=<%=request.querystring("id")%>", window, "status:off;help:off;dialogWidth:850px;dialogHeight:650px");
            
        }
        
        
        function WaitAttached()
        {
            if (attachWin.closed)
            {
                clearInterval(intAttachWin);
                // Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing)  
            }
        }
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                Record_Display("Deleting the attachment for the matter....");
                //Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing)
            }
        }
        function OpenScanning()
        {
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value;
            
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=matter&temp=1' + '&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
            intScanWin = setInterval('WaitScanned()', 500);
        }
        function WaitScanned()
        {
            if (scanWin.closed)
            {
                clearInterval(intScanWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function UploadDocument()
        {
            var w = 700;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%=hdnTempMatterID.ClientID %>').value;
            
            //scanWin = window.open('<%=ResolveUrl("~/util/pop/Uploadmatterdocument.aspx") %>?id=<%=ClientID %>&typeid=<%=MatterTypeId %>&ciid=<%=CreditorInstanceId %>&type=matter&temp=1' + '&rel=' + relID, 'UploadDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
            attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Upload Matter Document&a=m&p=<%= ResolveUrl("~/util/pop/Uploadmatterdocument.aspx") %>&type=matter&temp=1&id=<%=ClientID %>&rel=<%=hdnTempMatterID.value %>&ciid=<%=CreditorInstanceId %>", window, "status:off;help:off;dialogWidth:650px;dialogHeight:300px");
            if(attachWin ==-1)
            {
                //Record_Display("Successfully uploaded and attached.");
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
            
            //intScanWin = setInterval('WaitScanned()', 500);
        }
</script>

<table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" style="padding-left: 10; height: 100%;">
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
                border="0" cellpadding="0" cellspacing="10">
                <tr>
                    <td valign="top">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="3">
                                    <div runat="server" id="dvError" style="display: none;">
                                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                            width="100%" border="0">
                                            <tr>
                                                <td valign="top" style="width: 20;">
                                                    <img id="Img2" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                                </td>
                                                <td runat="server" id="tdError">
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="border-bottom: solid 1px #d1d1d1; font-family: tahoma; font-size: 11px;">
                                    <b>Task Instruction</b>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5 10 20 10;">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                        cellspacing="5">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="lblInstruction"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="entrytitlecell" style="padding-left: 10; width: 250">
                                    <a style="color: black;" href="javascript:OpenPropagations();" class="lnk">
                                        <img id="Img6" border="0" align="absmiddle" src="~/images/16x16_calendar_add.png"
                                            runat="server" style="margin-right: 5; display: none" /></a><asp:Label ForeColor="blue"
                                                Visible="false" runat="server" ID="lblPropagations"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Start Matter Task View -->
                <tr>
                    <td style="height: 100%" valign="top">
                        <asi:TabStrip runat="server" ID="tsMatterView">
                        </asi:TabStrip>
                        <div id="dvPanel0" runat="server" style="padding-top: 10; display: none">
                            <!-- put Tasks related to Matters in content page here -->
                            <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                                width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                        Tasks
                                    </td>
                                    <td style="padding-right: 7;" align="right">
                                    </td>
                                    <td align="right">
                                        <a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                            id="A1" runat="server" href="~/search.aspx"><img id="Img1" runat="server" src="~/images/16x16_find.png"
                                                border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A3" runat="server"
                                                    href="javascript:window.print();"><img id="Img3" runat="server" src="~/images/16x16_print.png"
                                                        border="0" align="absmiddle" /></a>
                                    </td>
                                </tr>
                            </table>
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td valign="top" hover="false">
                                        <div style="overflow: auto; height: 100%">
                                            <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)"
                                                class="list" onselectstart="return false;" id="Table2" style="font-size: 11px;
                                                font-family: tahoma; height: 100%" cellspacing="0" cellpadding="3" width="100%"
                                                border="0">
                                                <colgroup>
                                                    <col width="22px" align="center" />
                                                    <col width="22px" align="left" />
                                                    <col width="22px" align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                </colgroup>
                                                <thead>
                                                    <tr style="height: 20px">
                                                        <th onclick="Sort(this)" runat="server" id="Th5" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Task Type
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th6" class="headItem" style="width: 200px;
                                                            cursor: pointer">
                                                            Task Description
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th7" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Creator
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th8" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Assigned To
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th9" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Created Date
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th10" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Due Date
                                                        </th>
                                                        <th onclick="Sort(this)" runat="server" id="Th11" class="headItem" style="width: 100px;
                                                            cursor: pointer">
                                                            Resolved Date
                                                        </th>
                                                        <th class="headItem" style="width: 100px;">
                                                            Status
                                                        </th>
                                                        <th class="headItem" style="width: 100px; display: none;">
                                                            Duration
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:Repeater ID="rpTasks" runat="server">
                                                        <ItemTemplate>
                                                            <a style="background-color: <%#CType(Container.DataItem, GridTask).Color%>" href="<%# ResolveUrl("~/tasks/task/resolve.aspx?id=") + Ctype(Container.DataItem, GridTask).TaskID.ToString()%>">
                                                                <tr style="color: <%#CType(Container.DataItem, GridTask).TextColor%>; background-color: <%#CType(Container.DataItem, GridTask).Color%>">
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).TaskType%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).TaskDescription%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).CreatedBy%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).AssignedTo%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).StartDate.ToString()%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).DueDate.ToString("MMM d, yy")%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).ResolvedDate.ToString()%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true">
                                                                        <%#CType(Container.DataItem, GridTask).Status%>
                                                                    </td>
                                                                    <td class="noBorder" nowrap="true" style="display: none">
                                                                        <%#CType(Container.DataItem, GridTask).Duration%>
                                                                    </td>
                                                                    <asp:Label ID="lblTaskResolveDate" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td class="noBorder" style="display: none">
                                                                        <%-- <%#CType(Container.DataItem, GridTask).Duration%>&nbsp;&nbsp;(<%#CType(Container.DataItem, GridTask).DueDate.ToString("hh:mm tt")%><img style="margin:0 5 0 5" border="0" align="absmiddle" src="<%=ResolveURL("~/images/16x16_arrowright (thin gray).png")%>" /><%#CType(Container.DataItem, GridTask).ResolvedDate.ToString("hh:mm tt")%>)--%>
                                                                    </td>
                                                                </tr>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                            <asp:Panel runat="server" ID="pnlNoTasks" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no tasks for this matter</asp:Panel>
                                            <input type="hidden" runat="server" id="hdnTasksCount" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="dvPanel1" runat="server" style="padding-top: 10; display: none">
                            <!-- put Notes of Matter in content page here -->
                            <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                                width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                        Notes
                                    </td>
                                    <td style="padding-right: 7;" align="right">
                                    </td>
                                    <td align="right">
                                        <a class="lnk" id="A7" disabled="true" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                            id="A8" runat="server" href="~/search.aspx"><img id="Img13" runat="server" src="~/images/16x16_find.png"
                                                border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A9" runat="server"
                                                    href="javascript:window.print();"><img id="Img14" runat="server" src="~/images/16x16_print.png"
                                                        border="0" align="absmiddle" /></a>
                                    </td>
                                </tr>
                            </table>
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td valign="top" hover="false">
                                        <div style="overflow: auto; height: 100%">
                                            <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)"
                                                class="list" onselectstart="return false;" id="Table1" style="font-size: 11px;
                                                font-family: tahoma; height: 100%" cellspacing="0" cellpadding="3" width="100%"
                                                border="0">
                                                <colgroup>
                                                    <col width="22px" align="center" />
                                                    <col width="22px" align="center" />
                                                    <col width="22px" align="center" />
                                                    <col align="left" />
                                                    <col align="left" />
                                                    <col align="right" />
                                                    <col style="width: 1px" />
                                                    <col align="left" />
                                                </colgroup>
                                                <thead>
                                                    <tr style="height: 20px">
                                                        <th class="headItem" style="width: 25;" align="center">
                                                            <img id="Img17" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th class="headItem" style="width: 22;" align="center">
                                                            <img id="Img18" runat="server" src="~/images/11x16_paperclip.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th2" class="headItem" style="cursor: pointer">
                                                            Author
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th3" class="headItem" style="cursor: pointer">
                                                            User Type
                                                        </th>
                                                        <th onclick="SortNotes(this)" runat="server" id="Th4" class="headItem" style="cursor: pointer">
                                                            Date
                                                        </th>
                                                        <th class="headItem" style="width: 1px">
                                                            &nbsp;
                                                        </th>
                                                        <th class="headItem">
                                                            Related To
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:Repeater ID="rpNotes" runat="server">
                                                        <ItemTemplate>
                                                            <a style="background-color: <%#CType(Container.DataItem, GridNote).Color%>" href="<%# ResolveUrl("~/clients/client/communication/note.aspx?id=") + DataClientID.tostring() + "&nid=" + Ctype(Container.DataItem, GridNote).NoteID.ToString()+"&aid="+AccountId.tostring()+"&mid="+MatterId.tostring()+"&ciid="+CreditorInstanceId.tostring()+"&t=m"  %>">
                                                                <tr style="color: <%#CType(Container.DataItem, GridNote).TextColor%>; background-color: <%#CType(Container.DataItem, GridNote).Color%>">
                                                                    <td class="noBorder">
                                                                        <img src="<%=ResolveURL("~/images/16x16_note.png")%>" border="0" />
                                                                    </td>
                                                                    <td class="noBorder">
                                                                        <%#GetAttachmentText(Ctype(Container.DataItem, GridNote).NoteID, "note")%>
                                                                    </td>
                                                                    <td class="noBorder">
                                                                        <%#CType(Container.DataItem,GridNote).Author %>
                                                                    </td>
                                                                    <td class="noBorder">
                                                                        <%#CType(Container.DataItem, GridNote).UserType%>
                                                                    </td>
                                                                    <td class="noBorder">
                                                                        <%#CType(Container.DataItem, GridNote).NoteDate.ToString("MM/dd/yyyy")%>
                                                                    </td>
                                                                    <td rowspan="2" style="width: 1px; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                        background-repeat: repeat-y; background-position: center top;">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td rowspan="2" valign="top">
                                                                        &nbsp;<%#GetRelations(CType(Container.DataItem, GridNote).Relations)%>
                                                                    </td>
                                                                </tr>
                                                                <tr style="color: <%#CType(Container.DataItem, GridNote).BodyColor%>; background-color: <%#CType(Container.DataItem, GridNote).Color%>">
                                                                    <td colspan="3">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td colspan="3" align="left">
                                                                        <%#MakeSnippet(CType(Container.DataItem, GridNote).Value, 250)%>
                                                                    </td>
                                                                </tr>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                            <asp:Panel runat="server" ID="pnlNoNotes" Style="text-align: center; font-style: italic;
                                                padding: 10 5 5 5;">
                                                This client has no notes for this matter</asp:Panel>
                                            <input type="hidden" runat="server" id="hdnNotesCount" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="dvPanel2" runat="server" style="padding-top: 10; display: none">
                            <!-- put Phones of Matters in content page here -->
                            <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                                width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                        Phones
                                    </td>
                                    <td style="padding-right: 7;" align="right">
                                    </td>
                                    <td align="right">
                                        <a class="lnk" id="A4" disabled="true" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                            id="A5" runat="server" href="~/search.aspx"><img id="Img5" runat="server" src="~/images/16x16_find.png"
                                                border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A6" runat="server"
                                                    href="javascript:window.print();"><img id="Img7" runat="server" src="~/images/16x16_print.png"
                                                        border="0" align="absmiddle" /></a>
                                    </td>
                                </tr>
                            </table>
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <asp:PlaceHolder ID="phCommunication_default" runat="server">
                                    <tr>
                                        <td valign="top" hover="false">
                                            <div style="overflow: auto; height: 100%">
                                                <table onmouseover="Grid_RowHover_Nested(this,true)" onmouseout="Grid_RowHover_Nested(this,false)"
                                                    class="list" onselectstart="return false;" id="tblNotes" style="font-size: 11px;
                                                    font-family: tahoma; height: 100%" cellspacing="0" cellpadding="3" width="100%"
                                                    border="0">
                                                    <colgroup>
                                                        <col width="22px" align="center" />
                                                        <col width="22px" align="center" />
                                                        <col width="22px" align="center" />
                                                        <col align="left" />
                                                        <col align="left" />
                                                        <col align="left" />
                                                        <col align="center" />
                                                        <col align="left" />
                                                    </colgroup>
                                                    <thead>
                                                        <tr style="height: 20px">
                                                            <th class="headItem" style="width: 25;" align="center">
                                                                <img id="Img11" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                            </th>
                                                            <th id="Th1" class="headItem" style="width: 20px;" runat="server">
                                                                <img id="Img12" src="~/images/11x16_paperclip.png" border="0" alt="" runat="server" />
                                                            </th>
                                                            <th onclick="SortPhones(this)" runat="server" id="tdUser" class="headItem" style="cursor: pointer">
                                                                Internal
                                                            </th>
                                                            <th onclick="SortPhones(this)" runat="server" id="tdUserType" class="headItem" style="cursor: pointer">
                                                                User Type
                                                            </th>
                                                            <th onclick="SortPhones(this)" runat="server" id="tdPerson" class="headItem" style="cursor: pointer">
                                                                External
                                                            </th>
                                                            <th onclick="SortPhones(this)" runat="server" id="tdDate" class="headItem" style="cursor: pointer">
                                                                Call Date
                                                            </th>
                                                            <th onclick="SortPhones(this)" runat="server" id="tdDuration" class="headItem" style="cursor: pointer">
                                                                Duration
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <asp:Repeater ID="rpPhoneCalls" runat="server">
                                                            <ItemTemplate>
                                                                <a style="background-color: <%#CType(Container.DataItem, GridPhoneCall).Color%>"
                                                                    href="<%# ResolveUrl("~/clients/client/communication/phonecall.aspx?id=") + DataClientID.tostring() + "&pcid=" + Ctype(Container.DataItem, GridPhoneCall).PhoneCallID.ToString()+"&aid="+AccountId.tostring()+"&mid="+MatterId.tostring()+"&ciid="+CreditorInstanceId.tostring()+"&t=m"  %>">
                                                                    <tr style="color: <%#CType(Container.DataItem, GridPhoneCall).TextColor%>; background-color: <%#CType(Container.DataItem, GridPhoneCall).Color%>">
                                                                        <td class="noBorder">
                                                                            <img src="<%#ResolveURL("~/images/16x16_call" + iif(ctype(container.dataitem,gridphonecall).direction,"out","in") + ".png")%>"
                                                                                border="0" />
                                                                        </td>
                                                                        <td class="noBorder" nowrap="true" style="width: 20px;">
                                                                            <%#GetAttachmentText(CType(Container.DataItem, GridPhoneCall).PhoneCallID, "phonecall")%>
                                                                        </td>
                                                                        <td class="noBorder" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridPhoneCall).UserName%>
                                                                        </td>
                                                                        <td class="noBorder" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridPhoneCall).UserType%>
                                                                        </td>
                                                                        <td class="noBorder" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridPhoneCall).PersonName%>
                                                                        </td>
                                                                        <td class="noBorder" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridPhoneCall).CallDate.ToString("MM/dd/yyyy")%>
                                                                        </td>
                                                                        <td class="noBorder">
                                                                            <%#CType(Container.DataItem, GridPhoneCall).Duration%>&nbsp;&nbsp;(<%#CType(Container.DataItem, GridPhoneCall).CallDate.ToString("hh:mm tt")%><img
                                                                                style="margin: 0 5 0 5" border="0" align="absmiddle" src="<%=ResolveURL("~/images/16x16_arrowright (thin gray).png")%>" /><%#CType(Container.DataItem, GridPhoneCall).CallDateEnd.ToString("hh:mm tt")%>)
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="color: <%#CType(Container.DataItem, GridPhoneCall).BodyColor%>; background-color: <%#CType(Container.DataItem, GridPhoneCall).Color%>">
                                                                        <td colspan="3">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td colspan="5" align="left">
                                                                            <b>
                                                                                <%#MakeSnippet(CType(Container.DataItem, GridPhoneCall).Subject, 250)%>:</b>&nbsp;<%#MakeSnippet(CType(Container.DataItem, GridPhoneCall).Body, 250)%>
                                                                        </td>
                                                                    </tr>
                                                                </a>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </tbody>
                                                </table>
                                                <asp:Panel runat="server" ID="pnlNoCalls" Style="text-align: center; font-style: italic;
                                                    padding: 10 5 5 5;">
                                                    This client has no phone calls for this matter</asp:Panel>
                                                <input type="hidden" runat="server" id="hdnCallsCount" />
                                            </div>
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                            </table>
                        </div>
                        <div id="dvPanel3" runat="server" style="padding-top: 10; display: none">
                            <!-- put Emails of Matters in content page here -->
                            <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                                width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                        Emails
                                    </td>
                                    <td style="padding-right: 7;" align="right">
                                    </td>
                                    <td align="right">
                                        <a class="lnk" id="A10" disabled="true" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                            id="A111" runat="server" href="~/search.aspx"><img id="Img9" runat="server" src="~/images/16x16_find.png"
                                                border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A12" runat="server"
                                                    href="javascript:window.print();"><img id="Img19" runat="server" src="~/images/16x16_print.png"
                                                        border="0" align="absmiddle" /></a>
                                    </td>
                                </tr>
                            </table>
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td style="height: 100%;" valign="top">
                                        <table onselectstart="return false;" id="tblCommunication" style="table-layout: fixed;
                                            font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%"
                                            border="0">
                                            <tr>
                                                <td class="headItem" style="width: 20;" align="center">
                                                    <img id="Img10" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                </td>
                                                <td class="headItem" style="width: 15;" align="left">
                                                    <img id="Img15" runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                                </td>
                                                <td class="headItem" onclick="SortEmails(this)" runat="server" id="tdEmailDate" style="width: 75;
                                                    cursor: pointer">
                                                    Date
                                                </td>
                                                <td class="headItem" onclick="SortEmails(this)" runat="server" id="tdSentBy" style="width: 25%;
                                                    cursor: pointer">
                                                    By
                                                </td>
                                                <td onclick="SortEmails(this)" runat="server" id="tdEMailSubject" class="headItem"
                                                    style="cursor: pointer">
                                                    Message
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rpCommunication" runat="server">
                                                <ItemTemplate>
                                                    <a href="<%# ResolveUrl("~/clients/client/communication/email.aspx") + "?id=" + dataclientid.tostring() + "&eid=" + DataBinder.Eval(Container.DataItem, "FieldID").ToString()  %>">
                                                        <tr>
                                                            <td style="width: 20" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                class="listItem" nowrap="true">
                                                                <img src="<%= ResolveUrl("~/images/16x16_email_read.png") %>" border="0" />
                                                            </td>
                                                            <td style="width: 15" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                class="listItem" nowrap="true">
                                                                <%#GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                                            </td>
                                                            <td style="width: 75" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                                class="listItem" nowrap="true">
                                                                <%#DataBinder.Eval(Container.DataItem, "Emaildate", "{0:MMM d, yy}")%>
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                                nowrap="true">
                                                                <%#DataBinder.Eval(Container.DataItem, "By")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "ShortMessage")%>
                                                            </td>
                                                        </tr>
                                                    </a>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                        <asp:Panel runat="server" ID="pnlNoCommunication" Style="text-align: center; font-style: italic;
                                            padding: 10 5 5 5;">
                                            This client has no emails for this matter</asp:Panel>
                                        <input type="hidden" runat="server" id="hdnEmailCount" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <!-- End Matter Task View -->
                <tr>
                    <td class="entrytitlecell" colspan="3" style="width: 100%; padding-top: 10px">
                        <table id="tblDocuments" style="font-family: tahoma; font-size: 11px; width: 100%;"
                            border="0" cellpadding="5" cellspacing="0" runat="server">
                            <tr style="display: ">
                                <td style="background-color: #f1f1f1;">
                                    Document
                                </td>
                                <td style="background-color: #f1f1f1;" align="right">
                                    <span id="dvActions" runat="Server" style="display:none"><a style="color: rgb(51,118,171);" href="javascript:UploadDocument();" class="lnk">Upload
                                        Doc</a>&nbsp;|&nbsp;<a class="lnk" href="javascript:CreateIntake();">Client Intake Form</a>&nbsp;|&nbsp;</span><a
                                            class="lnk" href="javascript:AttachDocument();">Attach Document</a><span style="display: none">&nbsp;|&nbsp;<a
                                                class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirm();">Delete</a></span>
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
                                                    <a href="#" onclick="javascript:RowClick(this.childNodes(0), <%#CType(Container.DataItem.DocRelationID, Integer) %>);">
                                                        <tr>
                                                            <td ischeck="true" class="noBorder" style="padding-top: 7; width: 20;" valign="top"
                                                                align="center" class="listItem">
                                                                <img id="Img26" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                                    runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                                        id="Img27" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                                        style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                                        align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#CType(Container.DataItem.DocRelationID, Integer) %>);"
                                                                            style="display: none;" type="checkbox" />
                                                            </td>
                                                            <td style="width: 20px;" align="center">
                                                                <img id="Img2" runat="server" src="~/images/16x16_file_new.png" border="0" align="absmiddle" />
                                                            </td>
                                                            <td style="width: 11px;">
                                                                &nbsp;
                                                            </td>
                                                            <td align="left" style="width: 40%;">
                                                                <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\") %>');">
                                                                    <%#CType(Container.DataItem.DocumentType, String) %>
                                                                </a>
                                                            </td>
                                                            <td align="left" style="width: 100px; display: none;">
                                                                <%#CType(Container.DataItem.Origin, String) %>&nbsp;
                                                            </td>
                                                            <td align="left">
                                                                <%#CType(Container.DataItem.Received, String) %>&nbsp;
                                                            </td>
                                                            <td align="left">
                                                                <%#CType(Container.DataItem.Created, String) %>&nbsp;
                                                            </td>
                                                            <td align="left">
                                                                <%#CType(Container.DataItem.CreatedBy, String) %>&nbsp;
                                                            </td>
                                                            <td style="width: 20px;" align="right">
                                                                <%#IIf(Not CType(Container.DataItem.Existence, Boolean), "<img src=""" + ResolveUrl("~/images/16x16_no_file.png") + """ border=""0"" align=""absmiddle"" />", "&nbsp;") %>
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
            <asp:HiddenField runat="server" ID="txtResolved" />
            <asp:HiddenField runat="server" ID="hdnTaskResolutionID" />
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
            <asp:LinkButton ID="lnkShowDocs" runat="server" />
            <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
            <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortNotes" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortPhones" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkResortEmails" runat="server"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
            <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
        </td>
    </tr>
</table>

<script>
var vartabIndex=<%=tabIndex %>;
if(vartabIndex ==3)
document.getElementById("<%=dvPanel3.ClientID%>").style.display="block"  
else if(vartabIndex ==2)
document.getElementById("<%=dvPanel2.ClientID%>").style.display="block"  
else if(vartabIndex ==1)
document.getElementById("<%=dvPanel1.ClientID%>").style.display="block"  
else 
document.getElementById("<%=dvPanel0.ClientID%>").style.display="block"  


function OpenMatterNotes()
{
    attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Add New Note for a Matter&a=m&p=<%= ResolveUrl("~/util/pop/addmatternote.aspx") %>&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>", window, "status:off;help:off;dialogWidth:650px;dialogHeight:340px");

  if(attachWin =="-1")
  {
     
     window.location=window.location.href.replace("#","");
       
  }
}
function OpenPhoneCalls()
{
  attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Add New phone call for a Matter&a=m&p=<%= ResolveUrl("~/util/pop/addphonecall.aspx") %>&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>", window, "status:off;help:off;dialogWidth:950px;dialogHeight:540px");
  if(attachWin == "-1")
  {
    
     window.location=window.location.href.replace("#","");
  }
}

function OpenMatterRoadmap()
{
    attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Matter Road Map&a=m&p=<%= ResolveUrl("~/util/pop/matterroadmap.aspx") %>&a=m&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>", window, "status:off;help:off;dialogWidth:900px;dialogHeight:500px");
}

function OpenMatterInstance()
{
    //attachWin =  showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx") %>?t=Matter Road Map&a=m&p=<%= ResolveUrl("~/util/pop/matterroadmap.aspx") %>&a=m&id=<%=ClientID%>&mid=<%=MatterId%>&aid=<%=AccountId%>", window, "status:off;help:off;dialogWidth:800px;dialogHeight:500px");
    window.location = "<%= ResolveUrl("~/clients/client/creditors/matters/matterinstance.aspx") %>?aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&type=<%=MatterTypeId%>&ciid=<%=CreditorInstanceId%>";
}

</script>

