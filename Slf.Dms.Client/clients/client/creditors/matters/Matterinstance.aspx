<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="Matterinstance.aspx.vb" Inherits="clients_client_creditors_matters_MatterInstance"
    Title="DMP - Client - Account"  ValidateRequest="false"%>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
        background-repeat: repeat-x;">
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
                width: 100;
            }
            .grid_scroll
            {
                overflow: auto;
                height: 350px;
                border: solid 1px black;
                height: 340px;
                width: 100%;
            }
        </style>
        <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\xptabstrip.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\rgbcolor.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\grid.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

        <script type="text/javascript">

function FillDetails()
{
    var ddlLocalCounsel = document.getElementById("<%=ddlLocalCounsel.ClientID %>");
    
    var Value = ddlLocalCounsel.value;
    
    if (Value!="0" && Value!="-1")
    {
        document.getElementById("trLCDetails").style.display='block';
        
        var txtLocalCounselDetails = document.getElementById("<%=txtLocalCounselDetails.ClientID %>");
        
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
            lnkDeleteConfirm = document.getElementById("<%= hypDeleteDoc.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= hdnCurrentDoc.ClientID %>");
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
    var ddlMatterStatus = null;
    var ddlMatterSubStatus = null;
    var hdnPrevStatus = null;
    var hdnPrevSubStatus = null;
    
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
    function SortOverview(obj)
    {
        document.getElementById("<%=txtSortFieldOverview.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResortOverview, Nothing) %>;
    }
    function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    
    function Record_AddMatterNote()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/note.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&ciid=<%=CreditorInstanceId%>&t=c";
    }
    
    function Record_AddMatterPhoneCall()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/phonecall.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&ciid=<%=CreditorInstanceId%>&t=c";
    }
    
    function Record_AddExpenses()
    {
       window.location = "<%= ResolveUrl("~/clients/client/creditors/matters/matterexpenses.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&type=<%=MatterTypeId%>&ciid=<%=CreditorInstanceId%>&t=c";
    }
        
    function TaskClick(TaskID, TaskTypeId)
    {
        if (TaskTypeId == 71 || TaskTypeId == 72 || TaskTypeId == 73)                
            window.navigate('<%= ResolveUrl("~/processing/TaskSummary/default.aspx?id=") %>' + TaskID);                                
        else
            window.navigate('<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>' + TaskID);
    }
            
    function Record_SendEmail()
    {
        window.location = "<%= ResolveUrl("~/clients/client/communication/email.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&ciid=<%=CreditorInstanceId%>&t=c";
        //attachWin = window.open('<%=ResolveUrl("~/clients/client/communication/email.aspx") %>?id=<%=ClientID %>&type=matter', 'Email', "toolbars=no,scrollbars=yes,menubar=no,height=700,width=950,left=0,top=0")
    }
    
    //This for pop up screen when adding a new tasks
    function OpenPropagationsForAdd()
    {
         var url = '<%= ResolveUrl("~/tasks/task/propagations.aspx") %>?a=m&mid=<%=MatterId%>&cid=<%=ClientID%>&type=<%=MatterTypeId%>';
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
         var url = '<%= ResolveUrl("~/tasks/task/propagations.aspx") %>?a=m&mid=<%=MatterId%>&cid=<%=ClientID%>&type=<%=MatterTypeId%>';
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
        return document.getElementById("<%= txtPropagations.ClientID %>").value;
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
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_SaveConfirm()
    {
        if (Record_RequiredExist())
        {
            
          Record_Display("Saving changes...");
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Record_SaveAndClose()
    {
        if (Record_RequiredExist())
        {
            
          Record_Display("Saving changes...");
            <%= ClientScript.GetPostBackEventReference(lnkSaveClose, Nothing) %>;
        }
    }
    function Record_Save(IsVerified)
    {
        chkIsVerified.checked = IsVerified;

        // postback to save
        Record_Display("Saving new account...");
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
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
          	
	      txtAccountNumber = document.getElementById("<%=txtAccountNumber.ClientID %>");
	      txtMatterNumber = document.getElementById("<%=txtMatterNumber.ClientID %>");
	      txtMatterDate  = document.getElementById("<%=txtMatterDate.ClientID%>");
	      tblBody = document.getElementById("<%= tblBody.ClientID %>");
          tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
          ddlMatterType = document.getElementById("<%= ddlMatterType.ClientID %>");
          ddlMatterStatus = document.getElementById("<%= ddlMatterStatusCode.ClientID %>");
          ddlMatterSubStatus = document.getElementById("<%= ddlMatterSubStatusCode.ClientID %>");
          hdnPrevStatus = document.getElementById("<%= hdnPrevMatterStatus.ClientID %>");
          hdnPrevSubStatus = document.getElementById("<%= hdnPrevSubStatus.ClientID %>");
          ddlCreditors = document.getElementById("<%= ddlCreditors.ClientID %>");
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
        
        //Validation of Cancellation matter
        if(ddlMatterType.value=="4"){
            if (ddlCreditors.value != -1){
                ShowMessage("Cancellation matter cannot be assigned a creditor");
                ddlCreditors.disabled=false;
                AddBorder(ddlCreditors);
                return false;
            }        
            
        }
        
        //Validation for Settlement Matter
        if(ddlMatterType.value=="3")
        {   
            if (ddlMatterSubStatus.value != hdnPrevSubStatus.value){
            
                if (hdnPrevSubStatus.value == "71"){
                    ShowMessage("Status of an expired settlement cannot be changed");
                    ddlMatterStatus.disabled=false;
                    AddBorder(ddlMatterSubStatus);
                    return false;
                }
                
                switch(ddlMatterStatus.value){
                    case "1":
                        ShowMessage("Settlement matter cannot be changed to Open Status");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                            break;  
                    case "4":
                     if (!((hdnPrevStatus.value == "3") && (document.getElementById("<%= hdnStipulation.ClientID %>").value == "1"))){
                            ShowMessage("Settlement matter cannot be changed to Completed Status");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                        }
                        break;
                    case "2":
                        if (!(ddlMatterSubStatus.value == "70" || ddlMatterSubStatus.value == "13" || ddlMatterSubStatus.value == "79")){
                            ShowMessage("Settlement cannot be changed to this Closed status");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterSubStatus);
                            return false;
                        }
                        break;
                    case "3":
                        if (hdnPrevStatus.value == "4" || hdnPrevStatus.value == "3"){
                            ShowMessage("Completed/Pending settlement status cannot be changed");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                        }
                        if (hdnPrevSubStatus.value == "53" && ddlMatterSubStatus.value != "51"){
                            ShowMessage("This settlement can be changed to pending client approval only");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                        }
                        if (hdnPrevSubStatus.value == "61" && ddlMatterSubStatus.value != "55"){
                            ShowMessage("This settlement can be changed to pending manager approval only");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                        }
                        if (hdnPrevSubStatus.value == "69" && ddlMatterSubStatus.value != "67"){
                            ShowMessage("This settlement can be changed to pending accounting approval only");
                            ddlMatterStatus.disabled=false;
                            AddBorder(ddlMatterStatus);
                            return false;
                        }                        
                        break;                    
                }
            }
        }
            
        HideMessage();
        
        return true;           
        
    }
	function Record_DeleteConfirm()
    {
        LoadControlsD1();
        if (!lnkDeleteConfirm.disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=DeleteDocument&t=Delete Matter Document&m=Are you sure you want to delete this selection document from the matter?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Matter Document",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});         
          }
    }
    function Record_Delete()
    {
        // postback to delete
        Record_Display("Deleting account...");
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
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
                    
            window.dialogArguments =  new Array(window, btn, "CreditorFinderReturn");
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
          
            var url = '<%= ResolveUrl("~/util/pop/attachmatterdocument.aspx") %>?a=m&id=<%= ClientID %>&typeid=<%=MatterTypeId%>&type=matter&aid=<%=request.querystring("aid")%>&rel='+relID;
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
                                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
                            }
                         }
                       });  
        }
        function CreatePreJudgment()
        {
            var url = '<%= ResolveUrl("~/clients/client/creditors/matters/prejudgment.aspx") %>?a=m&id=<%=request.querystring("id")%>';
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
            //write code here
             var url = '<%= ResolveUrl("~/clients/client/creditors/matters/Intake.aspx") %>?a=m&id=<%=request.querystring("id")%>&typeid=<%=MatterTypeId%>&ciid=<%=request.querystring("ciid")%>&mid=<%=request.querystring("mid")%>&aid=<%=request.querystring("aid")%>';
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
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
            else if(attachWin==1){
                 window.location = "<%= ResolveUrl("~/clients/client/communication/email.aspx") %>?a=am&aid=<%=AccountId%>&mid=<%=MatterId%>&id=<%=ClientId%>&ciid=<%=CreditorInstanceId%>&t=c&s=i"; 
            }
        }
        
        function CreatePostJudgment()
        {
            //write code here
            var url = '<%= ResolveUrl("~/clients/client/creditors/matters/postjudgment.aspx") %>?a=m&id=<%=request.querystring("id")%>';
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
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                Record_Display("Deleting the attachment for the matter....");
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function OpenScanning()
        {
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value;
            var MatterId = document.getElementById('<%=hdnTempMatterID.ClientID %>').value;
            
            if (MatterId > 0 ){
                scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=matter' + '&rel=' + MatterId + '&addrel=account&addrelid=<%=AccountId%>', 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);

            }
            else{
                scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=matter' + '&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);

            }
            
            
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
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%=hdnTempMatterID.ClientID %>').value;
            
            var url = '<%= ResolveUrl("~/util/pop/Uploadmatterdocument.aspx") %>?a=m&type=matter&temp=1&id=<%=request.querystring("id")%>&rel=<%=hdnTempMatterID.value %>&ciid=<%=CreditorInstanceId %>&aid=<%=request.querystring("aid")%>';
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
                                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
                            }
                         }
                       });      
            
            //intScanWin = setInterval('WaitScanned()', 500);
        }
        
        function OpenPABox(settid) {
            var url = '<%= ResolveUrl("~/util/pop/PaymentArrangementInfo.aspx?sid=") %>' + settid;
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Payment Arrangement Info",
                dialogArguments: window,
                resizable: false,
                scrollable: true,
                height: 450, width: 550
            });
        return false;
        }  
        
        function OpenCheckByEmail(lid,checknumber,mid) {
                var url = '<%= ResolveUrl("~/processing/popups/ResendCheckByEmail.aspx?lid=") %>' + lid + '&cn=' + checknumber + '&mid=' + mid;
                window.dialogArguments = window;
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                    title: "Check by Email Log",
                    dialogArguments: window,
                    resizable: false,
                    scrollable: true,
                    height: 650, width: 780
                });
            return false;
        }  
    
        </script>

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
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr id="NewInfo" runat="server" style="padding-bottom: 20px" visible="false">
                            <td>
                                <div class="iboxDiv">
                                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                        <tr>
                                            <td valign="top" style="width: 16;">
                                                <img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png" />
                                            </td>
                                            <td>
                                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="iboxHeaderCell">
                                                            INFORMATION:
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="iboxMessageCell">
                                                            You are creating a new Matter, and the information has been automatically filled
                                                            out according to the current Creditor Instance. Please change the necessary information
                                                            before saving this new instance.
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
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
                                    <%--&nbsp;
                                    <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                        cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td valign="top">
                                                <asp:LinkButton CssClass="lnk" Style="color: rgb(80,80,80); font-family: tahoma;
                                                    font-size: medium;" runat="server" ID="LinkButton1"></asp:LinkButton>
                                                &nbsp; <a class="lnk" style="font-family: verdana; color: rgb(80,80,80);" runat="server"
                                                    id="A1"></a>-
                                                <asp:Label runat="server" Style="color: rgb(160,80,80); font-family: tahoma; font-size: medium;"
                                                    ID="Label1"></asp:Label>
                                                <br />
                                                <asp:Label runat="server" ID="Label2"></asp:Label>
                                            </td>
                                            <td align="right" valign="top">
                                                <asp:Label runat="server" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                                    ID="Label3"></asp:Label>
                                                <asp:Label runat="server" ID="Label4" Visible="false"></asp:Label>
                                                <asp:Label runat="server" ID="Label5"></asp:Label>
                                                Status:&nbsp;
                                                <asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server" ID="LinkButton2"></asp:LinkButton>
                                                <asp:Label runat="server" ID="Label6" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>--%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table style="margin: 0 30 30 0; float: left; font-family: tahoma; font-size: 11px;
                                    width: 300;" border="0" cellpadding="5" cellspacing="0">
                                    <!--<tr>
                                    <td style="background-color:#f1f1f1;">Creditor Account Information</td>
                                </tr> -->
                                    <!--  <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Original Due Date:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true" TabIndex="1" cssclass="entry" ID="txtOriginalDueDate" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Retainer Fee %:</td>
                                                <td><input type="text" class="entry" id="txtSetupFeePercentage" runat="server" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr> -->
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
                                                    <td class="entrytitlecell" nowrap="nowrap" align="left" >
                                                        <asp:DropDownList caption="Matter Type" TabIndex="1" CssClass="entry" runat="server"
                                                            Width="250px" ID="ddlMatterType">
                                                        </asp:DropDownList><asp:Literal ID="lblPayments" runat="server"></asp:Literal>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Matter Date:
                                                    </td>
                                                    <td>
                                                        <cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true"
                                                            TabIndex="2" Width="250px" ReadOnly="true" CssClass="entry" ID="txtMatterDate"
                                                            runat="server" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                    </td>
                                                </tr>
                                                <!--tr>
                                                <td class="entrytitlecell" nowrap="true">Create Date</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true" TabIndex="2" cssclass="entry" ID="txtAcquired" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr -->
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Account Number:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAccountNumber" ReadOnly="true" Width="250px" runat="server" CssClass="entry"
                                                            TabIndex="3"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr id="trCreditor" runat="server">
                                                    <td class="entrytitlecell">
                                                        Creditor:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Creditor" TabIndex="1" CssClass="entry" runat="server"
                                                            Width="250px" ID="ddlCreditors" AutoPostBack="true">
                                                        </asp:DropDownList>
                                                        <asp:TextBox ID="txtCreditor" ReadOnly="true" Width="250px" runat="server" CssClass="entry" TabIndex="3" Visible="false"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true" style="width: 95px">
                                                        Matter Number:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtMatterNumber" ReadOnly="true" Width="250px" runat="server" CssClass="entry"
                                                            TabIndex="4"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell">
                                                        Matter Status:
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList caption="Matter Status" TabIndex="5" CssClass="entry" runat="server"
                                                            Width="250px" ID="ddlMatterStatusCode" AutoPostBack="true" OnSelectedIndexChanged="ddlMatterStatusCode_SelectedIndexChanged">
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
                                                <tr id="trCaseNum" runat="server">
                                                    <td class="entrytitlecell">
                                                        Matter Case #:</td>
                                                    <td class="entrytitlecell">
                                                        <asp:TextBox ID="txtMatterCaseNumber" Width="250px" runat="server" CssClass="entry" TabIndex="4" />
                                                    </td>
                                                </tr>
                                                <tr id="trLocalCounsel" runat="server">
                                                    <td class="entrytitlecell">
                                                        Local Counsel:
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList caption="Local Counsel" TabIndex="6" CssClass="entry" runat="server"
                                                            Width="250px" ID="ddlLocalCounsel">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr id="trLCDetails" style="display:none">
                                                    <td class="entrytitlecell">
                                                        Local Counsel Details:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:TextBox TabIndex="8" Width="250px" runat="server" ID="txtLocalCounselDetails" Rows="5"
                                                            TextMode="MultiLine" ReadOnly=True></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" valign="top">
                                                        Classification:
                                                    </td>
                                                    <td>
                                                        <asp:ListBox ID="ddlClassification" runat="server" TabIndex="7" CssClass="entry"
                                                            Width="250px" SelectionMode="Multiple" Rows="8"></asp:ListBox>
                                                    </td>
                                                </tr>
                                                <tr id="trMessage" runat="server">
                                                    <td class="entrytitlecell" colspan="2">
                                                        Matter Description:<br />
                                                        <asp:TextBox TabIndex="8" CssClass="entry" runat="server" ID="txtMatterMemo2"
                                                            Rows="10" TextMode="MultiLine" MaxLength="1000" Columns="50" Style="width: 50em"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" style="padding-left: 10; width: 250">
                                            <a style="color: black;" href="javascript:OpenPropagationsForEdit();" class="lnk" runat="server" id="lnkEditTask">
                                                <img id="Img6" border="0" align="absmiddle" src="~/images/16x16_calendar_add.png"
                                                    runat="server" style="margin-right: 5;" />Add/Edit Tasks</a>
                                            <a style="color: black;" href="javascript:OpenPropagationsForAdd();" class="lnk" runat="server" id="lnkAddTask" visible="false">
                                                            <img id="Img16" border="0" align="absmiddle" src="~/images/16x16_calendar_add.png"
                                                                runat="server" style="margin-right: 5;" />Add Tasks</a>
                                                   <asp:Label ForeColor="blue" runat="server" ID="lblPropagations"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
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
                    <div id="dvPanel4" runat="server" style="padding-top: 10; display: none">
                        <!-- put overview of Matters in content page here -->
                        <div id="dvOverview" class="grid_scroll">
                        <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                            width: 100%;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                    Overview
                                </td>
                                <td style="padding-right: 7;" align="right">
                                </td>
                                <td align="right">
                                    <a class="lnk" id="lnkDeleteOverview" disabled="true" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
                                        runat="server" href="~/search.aspx"><img runat="server" src="~/images/16x16_find.png"
                                            border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="javascript:window.print();"><img
                                                runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle" /></a>
                                </td>
                            </tr>
                        </table>
                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td class="headItem" style="width: 20;" align="center">
                                    <img id="Img3" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                </td>
                                <td class="headItem" style="width: 15;" align="left">
                                    <img id="Img4" runat="server" src="~/images/12x16_paperclip.png" border="0" />
                                </td>
                                <td class="headItem" onclick="SortOverview(this)" runat="server" id="tdCreatedDate" style="width: 75;cursor:pointer  ">
                                    Date
                                </td>
                                <td class="headItem" onclick="SortOverview(this)" runat="server" id="tdCreatedBy" style="width: 25%;cursor:pointer ">
                                    By
                                </td>
                                <td class="headItem" onclick="SortOverview(this)"  runat="server" id="tdMessage" style="cursor:pointer ">
                                    Message
                                </td>
                                 <td class="headItem">
                                    Duration
                                </td>
                            </tr>
                            <asp:Repeater ID="rptOverview" runat="server">
                                <ItemTemplate>
                                    <a href="<%# Getpagepath(DataBinder.Eval(Container.DataItem, "type").ToString(),DataBinder.Eval(Container.DataItem, "FieldID"))%>">
                                        <tr>
                                            <td style="width: 20" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                class="listItem" nowrap="true">
                                                <img src="<%#GetImage(DataBinder.Eval(Container.DataItem, "type").ToString(),DataBinder.Eval(Container.DataItem, "direction"))%>"
                                                    border="0" />
                                            </td>
                                            <td style="width: 15" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                class="listItem" nowrap="true">
                                                <%#GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "FieldID")), DataBinder.Eval(Container.DataItem, "type").ToString())%>
                                            </td>
                                            <td style="width: 75" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                class="listItem" nowrap="true">
                                                <%#DataBinder.Eval(Container.DataItem, "Date", "{0:MMM d, yy}")%>
                                            </td>
                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                nowrap="true">
                                                <%#DataBinder.Eval(Container.DataItem, "By")%>&nbsp;
                                            </td>
                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                <%#DataBinder.Eval(Container.DataItem, "ShortMessage".Replace("-Not Available", ""))%>
                                            </td>
                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                             <%#PhoneCallDuration(DataBinder.Eval(Container.DataItem, "starttime"), DataBinder.Eval(Container.DataItem, "endtime"))%>
                                            </td>
                                        </tr>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                        </div>
                        <asp:Panel runat="server" ID="pnlNoOverview" Style="text-align: center; font-style: italic;
                                padding: 10 5 5 5;">
                                This client has no tasks or emails or notes or phone calls for this matter</asp:Panel>
                            <input type="hidden" runat="server" id="hdnOverview" />
                    </div>
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
                                        runat="server" href="~/search.aspx"><img runat="server" src="~/images/16x16_find.png"
                                            border="0" align="absmiddle" /></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A3" runat="server"
                                                href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png"
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
                                                        <a style="background-color: <%#CType(Container.DataItem, GridTask).Color%>" onclick="javascript:TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>, <%#CType(Container.DataItem, GridTask).TaskTypeID%>);">
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
                     <div id="dvPanel5" runat="server" style="padding-top: 10; display: none">
                         <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                            width: 100%;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                    Checks By Email
                                </td>
                                <td style="padding-right: 7;" align="right">
                                </td>
                                <td align="right">
                                </td>
                            </tr>
                        </table>
                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                            cellspacing="0">
                            <tr>
                                <td style="height: 100%;" valign="top">
                                    <table onselectstart="return false;" id="Table3" style="table-layout: fixed;
                                        font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%"
                                        border="0">
                                        <tr>
                                            <td class="headItem" style="width: 20;" align="center">
                                                <img id="Img28" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                            </td>
                                            <td class="headItem" runat="server" id="td1" style="width: 75;
                                                cursor: pointer">
                                                Check Number
                                            </td>
                                            <td class="headItem" runat="server" id="td6" style="width: 75;
                                                cursor: pointer">
                                                Amount
                                            </td>
                                            <td class="headItem" runat="server" id="td5" style="width: 200;
                                                cursor: pointer">
                                                Recipient
                                            </td>
                                            <td class="headItem" runat="server" id="td4" style="width: 120;
                                                cursor: pointer">
                                                Date Sent
                                            </td>
                                            <td class="headItem" runat="server" id="td2" style="width: 100;
                                                cursor: pointer">
                                                By
                                            </td>
                                            <td runat="server" id="td3" class="headItem"
                                                style="cursor: pointer">
                                                Subject
                                            </td>
                                        </tr>
                                        <asp:Repeater ID="rptChecksByEMail" runat="server">
                                            <ItemTemplate>
                                                <a href="javascript:void();" onclick="return OpenCheckByEmail('<%#DataBinder.Eval(Container.DataItem, "EmailLogId") %>','<%#DataBinder.Eval(Container.DataItem, "CheckNumber")%>',<%= MatterId%>)">
                                                    <tr>
                                                        <td style="width: 20" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                            class="listItem" nowrap="true">
                                                            <img src="<%= ResolveUrl("~/images/16x16_email_read.png") %>" border="0"/>
                                                            <asp:HiddenField ID="hdnEmailLogId" runat="server" ></asp:HiddenField>
                                                        </td>
                                                        <td style="width: 75" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                            class="listItem" nowrap="true">
                                                            <%#DataBinder.Eval(Container.DataItem, "CheckNumber")%>
                                                        </td>
                                                        <td style="width: 75" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                            class="listItem" nowrap="true">
                                                            <%#DataBinder.Eval(Container.DataItem, "CheckAmount", "{0:c}")%>
                                                        </td>
                                                         <td style="width: 200" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                            class="listItem" nowrap="true">
                                                            <%#DataBinder.Eval(Container.DataItem, "To")%>
                                                        </td>
                                                        <td style="width: 120" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                                            class="listItem" nowrap="true">
                                                            <%#DataBinder.Eval(Container.DataItem, "Sent", "{0:g}")%>
                                                        </td>
                                                        <td style="width: 100"  onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                                            nowrap="true">
                                                            <%#DataBinder.Eval(Container.DataItem, "By")%>&nbsp;
                                                        </td>
                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                            <%#DataBinder.Eval(Container.DataItem, "MailSubject")%>
                                                        </td>
                                                    </tr>
                                                </a>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </table>
                                    <asp:Panel runat="server" ID="pnlNoCBE" Style="text-align: center; font-style: italic;
                                        padding: 10 5 5 5;">
                                        This client has no checks by email for this matter</asp:Panel>
                                    <input type="hidden" runat="server" id="hdnCBEmailCount" />
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
                        <tr>
                            <td style="background-color: #f1f1f1;">
                                Document
                            </td>
                            <td style="background-color: #f1f1f1;" align="right">
                               <span id="dvActions" runat="Server" style="display:none"> <a style="color: rgb(51,118,171);" href="javascript:UploadDocument();" class="lnk">Upload
                                    Doc</a>&nbsp;|&nbsp;<a class="lnk" href="javascript:CreateIntake();">Client Intake Form</a>&nbsp;|&nbsp;</span><a
                                        class="lnk" href="javascript:AttachDocument();">Attach Document</a>&nbsp;|&nbsp;<a
                                            class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirm();">Delete</a>
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
                                                            <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\").Replace("'","\'") %>');">
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
                                                                    align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#CType(Container.DataItem.Length, Integer) %>);"
                                                                        style="display: none;" type="checkbox" />
                                                        </td>
                                                        <td style="width: 20px;" align="center">
                                                            <img id="Img2" runat="server" src="~/images/16x16_file_new.png" border="0" align="absmiddle" />
                                                        </td>
                                                        <td style="width: 11px;">
                                                            &nbsp;
                                                        </td>
                                                        <td align="left" style="width: 40%;">
                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%# BuildDirectory(CType(Container.DataItem.DirectoryName, String).Replace("\", "\\")) %><%="\\" %><%# CType(Container.DataItem.Name, String).Replace("'","\'")%>');" ><%#CType(Container.DataItem.Name, String)%></a>
                                                        </td>
                                                        <td align="left" style="width: 100px; display: none;">
                                                            <%#CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                        </td>
                                                        <td align="left">
                                                            <%#CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                        </td>
                                                        <td align="left">
                                                            <%#CType(Container.DataItem.LastWriteTime, String)%>&nbsp;
                                                        </td>
                                                        <td align="left">
                                                            <%#CType(Container.DataItem.length, String)%>&nbsp;
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
        <asp:HiddenField runat="server" ID="hdnPrevMatterStatus" />
        <asp:HiddenField runat="server" ID="hdnPrevSubStatus" />
        <asp:HiddenField runat="server" ID="hdnStipulation" />
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
        <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSaveClose"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
        <input type="hidden" runat="server" id="hdnLatestCreditorId" value="0" />
    </body>

    <script>
var vartabIndex=<%=tabIndex %>;
if(vartabIndex ==4)
document.getElementById("<%=dvPanel3.ClientID%>").style.display="block"  
else if(vartabIndex ==3)
document.getElementById("<%=dvPanel2.ClientID%>").style.display="block"  
else if(vartabIndex ==2)
document.getElementById("<%=dvPanel1.ClientID%>").style.display="block"  
else if(vartabIndex ==1)
document.getElementById("<%=dvPanel0.ClientID%>").style.display="block"  
else 
document.getElementById("<%=dvPanel4.ClientID%>").style.display="block"  

FillDetails(); 
    </script>

</asp:Content>
