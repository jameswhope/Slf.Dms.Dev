<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="addMatter.aspx.vb" Inherits="clients_client_creditors_matters_addMatter"
    Title="DMP - Client - Account" ValidateRequest="false" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
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
        </style>
        <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
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

function CheckAll(intN)
{
    var i=0;
    for(;;i++)
    {
        if(document.getElementById('chk'+intN+i)==null)  
            break;
         document.getElementById('chk'+intN+i).checked=true;
    }
    
    if (intN==1)
    {
        if( document.getElementById("<%=Img5 %>")!=null)
          document.getElementById("<%=Img5 %>").style.display='block'
          
        if( document.getElementById("<%=Img4 %>")!=null)
        document.getElementById("<%=Img4 %>").style.display='none'
    }
    else if (intN==2)
    {
        if( document.getElementById("<%=Img8 %>")!=null)
          document.getElementById("<%=Img8 %>").style.display='block'
          
        if( document.getElementById("<%=Img7 %>")!=null)
        document.getElementById("<%=Img7 %>").style.display='none'
    }
       
    if(i>0)
    {
        if (intN==1)
        {
            document.getElementById("<%=hypDeleteTask.ClientID%>").disabled=false 
        }
        else if (intN==2)
        {
            document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled=false 
        }
    }
} 

function UncheckAll(intN)
{
    var i=0;
    for(;;i++)
    {
        if(document.getElementById('chk'+intN+i)==null)  
            break;
         document.getElementById('chk'+intN+i).checked=false;
    }
    
    if (intN==1)
    {
        if( document.getElementById("<%=Img5 %>")!=null)
          document.getElementById("<%=Img5 %>").style.display='none'
          
        if( document.getElementById("<%=Img4 %>")!=null)
        document.getElementById("<%=Img4 %>").style.display='block'
    }
    else if (intN==2)
    {
        if( document.getElementById("<%=Img8 %>")!=null)
          document.getElementById("<%=Img8 %>").style.display='none'
          
        if( document.getElementById("<%=Img7 %>")!=null)
        document.getElementById("<%=Img7 %>").style.display='block'
    }
    
    if (intN==1)
    {
        document.getElementById("<%=hypDeleteTask.ClientID%>").disabled=true 
    }
    else if (intN==2)
    {
        document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled=true 
    }
        
} 

function checkStatus(j,intN)
{
   var i=0,k=0;
    for(;;i++)
    {
        if(document.getElementById('chk'+intN+i)==null)  
            break;
        if(document.getElementById('chk'+intN+i).checked==true)
        k=1;
    }
    if(k==0)
    {
        if (intN==1)
        {
            document.getElementById("<%=hypDeleteTask.ClientID%>").disabled=true 
        }
        else if (intN==2)
        {
            document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled=true 
        }
    }
    else
    {
        if (intN==1)
        {
            document.getElementById("<%=hypDeleteTask.ClientID%>").disabled=false 
        }
        else if (intN==2)
        {
            document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled=false 
        }    
    }
}


    var txtOriginalDueDate = null;
    var txtSetupFeePercentage = null;
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
    var txtMatterMemo2 = null;
    var ddlClassification = null;
    var ddlMatterType = null;
    var ddlMatterSubStatus = null;
    var ddlMatterStatus = null;
    
    window.onload = function ()
    {

    }

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_SaveConfirm()
    {
        
        //if the required record exits  
        if (Record_RequiredExist())
        {
            
          Record_Display("Saving Matter instance...");
          <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
         
        }
    }
    
    function Record_SaveAndClose()
    {
        
        //if the required record exits  
        if (Record_RequiredExist())
        {
            
          Record_Display("Saving Matter instance...");
          <%= ClientScript.GetPostBackEventReference(lnkSaveCose, Nothing) %>;
         
        }
    }
    
    
    function Record_Save(IsVerified)
    {
        chkIsVerified.checked = IsVerified;

        // postback to save
        Record_Display("Saving new account...");
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    
    //This for pop up screen when adding a new tasks
    
    function OpenPropagations()
    {
        var url = '<%= ResolveUrl("~/tasks/task/propagations.aspx") %>?t=Add Matter Task &type=<%= MatterTypeId %>&gid=<%= AssignedToGroup %>&a=m';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Matter Task",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 650, width: 700});   
    }
    
    //This is for the pop up screen to add phone calls
    function OpenPhoneCalls()
    {
        var url = '<%= ResolveUrl("~/util/pop/matterphonecall.aspx") %>?t=Add Phone Call&id=<%= ClientId %>&a=m';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Phone Call",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 650, width: 700});   
    }
    
    function SavePhoneNote(Value)
    {
        var txtPhoneNote = document.getElementById("<%= txtPhoneNote.ClientID %>");

        txtPhoneNote.value = Value;
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
            PopulateTasks(Value);
        }
        else
        {
            lblPropagations.innerText = "";
        }
        
        
    }
    
    function PopulateTasks(strTasks)
    {
        var intN =1;
        var text="<table cellpadding='0' border='0' cellspacing='0'>"
        
        var Tasks = strTasks.split("|"); 
        for(i=0;i<Tasks.length;i++)
        {
            if(Tasks[i]!="")
            {    
                var Task = Tasks[i];
                var files = Task.split(",");
                
                text =text +"<tr style='width:100%;font-family:tahoma;font-size:11px;'>"
                text =text +"<td style='width: 25px;display: none;' ><input type='checkbox'"
                if(document.getElementById("chk"+intN+i)!=null)
                {
                    if(document.getElementById("chk"+intN+i).checked)
                    {
                         text =text +" checked='true' "
                    }
                }
                text =text +" onClick='javascript:checkStatus("+i+","+intN+")' id='chk"+intN+i+"' /> </td>"
                text =text +"<td align='left' style='width: 150px;height:20px;'>"+files[10]  +"&nbsp;</td>"

                text =text +"<td align='left' style='width: 100px;height:20px;'>"+files[2]  +"&nbsp;</td>"
                text =text +"<td align='left' style='width: 260px;height:20px;'>"+files[11]  +"&nbsp;</td>"
              
                text =text +"<td align='left' style='width: 280px;height:20px;'>"+ files[5] +"&nbsp;</td>"
                text =text +"</tr>"
                    
            }
        }
        text=text +"</table>"
        document.getElementById("dvTasks").innerHTML=text ;  
    }
    
    function GetPropagations()
    {
        return document.getElementById("<%= txtPropagations.ClientID %>").value;
    }
    
    function GetPhoneNote()
    {
        return document.getElementById("<%= txtPhoneNote.ClientID %>").value;
    }
    
    function IsResolved()
    {
        var chkResolved = document.getElementById("<%= chkResolved.ClientID %>");

        return chkResolved.checked;
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
         // alert("Load Controls");   	
	      txtAccountNumber = document.getElementById("<%=txtAccountNumber.ClientID %>");
	      txtMatterNumber = document.getElementById("<%=txtMatterNumber.ClientID %>");
	      txtMatterDate  = document.getElementById("<%=txtMatterDate.ClientID%>");
	      tblBody = document.getElementById("<%= tblBody.ClientID %>");
          tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
          txtMatterMemo2 = document.getElementById("<%= txtMatterMemo2.ClientID %>");
          ddlClassification = document.getElementById("<%= ddlClassification.ClientID %>");
          ddlMatterType = document.getElementById("<%= ddlMatterType.ClientID %>");
          ddlMatterStatus = document.getElementById("<%= ddlMatterStatusCode.ClientID %>");
          ddlMatterSubStatus = document.getElementById("<%= ddlMatterSubStatusCode.ClientID %>");
        //alert("finished load controls");  

	}
	
	//verified required records for creating a new matter exist 
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
            AddBorder(ddlMatterType);
            return false;
        }
        
        if(ddlMatterStatus.value=="")
        {
            ShowMessage("Matter status is a required field");
            AddBorder(ddlMatterStatus);
            return false;
        }
        
         if(ddlMatterSubStatus.value=="")
        {
            ShowMessage("Matter sub status is a required field");
            AddBorder(ddlMatterSubStatus);
            return false;
        }

//        if(ddlClassification.value=="")
//        {
//            ShowMessage("Classification is a required field");
//            AddBorder(ddlClassification);
//            return false;
//        }
        
//        if (txtMatterMemo2.value.length == 0)
//        {
//            ShowMessage("The Matter Description field is required.");
//            AddBorder(txtMatterMemo2);
//            return false;
//        }
        
        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Creditor Instance&m=Are you sure you want to delete this Creditor Instance?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Creditor Instance",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400}); 
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
        
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%=hdnTempMatterID.ClientID %>').value + '&temp=1';
            
             var url = '<%= ResolveUrl("~/util/pop/attachnewmatterdocument.aspx") %>?id=<%=ClientID %>&type=matter&rel=' + relID + '&r=' + Math.random();
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Attach Document",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 700,
                       onClose: function(){
                            attachWin = $(this).modaldialog("returnValue");
                            afterAttach();
                         }
                       });      
        }
        
        function afterAttach(){
            if(attachWin!=null && attachWin!="")
            {
                var val =attachWin.split("$"); 
                document.getElementById("<%=hdnAttachments.ClientID %>").value = document.getElementById("<%=hdnAttachments.ClientID %>").value + val[0]+";"; 
                document.getElementById("<%=hdnAttachmentsText.ClientID %>").value = document.getElementById("<%=hdnAttachmentsText.ClientID %>").value + val[1]+";"; 
                document.getElementById("<%=hdnReceivedDate.ClientID %>").value = document.getElementById("<%=hdnReceivedDate.ClientID %>").value + val[2]+";"; 
                document.getElementById("<%=hdnCreatedDate.ClientID %>").value = document.getElementById("<%=hdnCreatedDate.ClientID %>").value + val[3]+";"; 
                document.getElementById("<%=hdnCreatedBy.ClientID %>").value = document.getElementById("<%=hdnCreatedBy.ClientID %>").value + val[4]+";"; 

                var filestype=document.getElementById("<%=hdnAttachments.ClientID %>").value.split(";")
                var files=document.getElementById("<%=hdnAttachmentsText.ClientID %>").value.split(";")
                var files1=document.getElementById("<%=hdnReceivedDate.ClientID %>").value.split(";")
                var files2=document.getElementById("<%=hdnCreatedDate.ClientID %>").value.split(";")
                var files3=document.getElementById("<%=hdnCreatedBy.ClientID %>").value.split(";")
      
                var text="<table cellpadding='0' cellspacing='0' border='0'>"
                var intN =2;
                for(i=0;i<files.length;i++)
                {
                    if(files[i]!="")
                    {
                        text =text +"<tr style='width:100%;font-family:tahoma;font-size:11px;'>"
                        text =text +"<td align='center' style='width: 25px;height=20px;'><input type='checkbox'"
                        if(document.getElementById("chk"+intN+i)!=null)
                        {
                            if(document.getElementById("chk"+intN+i).checked)
                            {
                                text =text +" checked='true' "
                            }
                        }
                        text =text +" onClick='javascript:checkStatus("+i+","+intN+")' id='chk"+intN+i+"' /> </td>"
                        text =text +"<td align='left' style='width: 260px;height=20px;'> <a href='#' class='lnk'>"+files[i]  +"</a>&nbsp;</td>"
                        text =text +"<td align='left' style='width: 170px;height=20px;'>"+"&nbsp;</td>"
                        text =text +"<td align='left' style='width: 170px;height=20px;'>"+files2[i]  +"&nbsp;</td>"

                        text =text +"<td align='left' style='width: 190px;height=20px;'>"+ "&nbsp;</td>"
                        text =text +"</tr>"
                    } 
                } 
                text=text +"</table>"
                document.getElementById("dvDocs").innerHTML=text ;  
            }
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
            if( document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled==false)
            if( confirm("Are you sure, do you want to delete the selected document?"))
            {
                var intN =2;
                if( document.getElementById("<%=hypDeleteDoc.ClientID%>").disabled==false )
                {
                    var i=0;
                    var strindex='';
                    for(;;i++)
                    {
                        if(document.getElementById('chk'+intN+i)==null)  
                            break;
                        if(document.getElementById('chk'+intN+i).checked==true)
                        {
                            strindex =strindex+(i)+',';//changed here
                        }
                    }
                    
                    BuildNewlist(strindex,document.getElementById("<%=hdnAttachments.ClientID %>"))
                    BuildNewlist(strindex,document.getElementById("<%=hdnAttachmentsText.ClientID %>"))
                    BuildNewlist(strindex,document.getElementById("<%=hdnReceivedDate.ClientID %>"))
                    BuildNewlist(strindex,document.getElementById("<%=hdnCreatedDate.ClientID %>"))
                    BuildNewlist(strindex,document.getElementById("<%=hdnCreatedBy.ClientID %>"))
                       
                    if(strindex!='')
                    {
                        var filestype=document.getElementById("<%=hdnAttachments.ClientID %>").value.split(";")
                        var files=document.getElementById("<%=hdnAttachmentsText.ClientID %>").value.split(";")
                        var files1=document.getElementById("<%=hdnReceivedDate.ClientID %>").value.split(";")
                        var files2=document.getElementById("<%=hdnCreatedDate.ClientID %>").value.split(";")
                        var files3=document.getElementById("<%=hdnCreatedBy.ClientID %>").value.split(";")
                        var text="<table cellpadding='0' border='0' cellspacing='0'>"
                        for(i=0;i<files.length;i++)
                        {
                            if(files[i]!="")
                            {
                                text =text +"<tr style='width:100%;font-family:tahoma;font-size:11px;'>"
                                text =text +"<td align='center' style='width: 25px;height=20px;'><input type='checkbox' onClick='javascript:checkStatus("+i+","+intN+")' id='chk"+intN+i+"' /> </td>"
                             /*  if(filestype[i]=="0")
                                text =text +"<td align='left' style='width: 260px;height=20px;'> <a href='#' class='lnk'>"+files1[i]  +"</a>&nbsp;</td>"
                               else*/
                                text =text +"<td align='left' style='width: 260px;height=20px;'> <a href='#' class='lnk'>"+files[i]  +"</a>&nbsp;</td>"

                               // text =text +"<td align='left' style='width: 170px;height=20px;'>"+files1[i]  +"&nbsp;</td>"
                                 text =text +"<td align='left' style='width: 170px;height=20px;'>"+"&nbsp;</td>"
                                text =text +"<td align='left' style='width: 170px;height=20px;'>"+files2[i]  +"&nbsp;</td>"

                                text =text +"<td align='left' style='width: 190px;height=20px;'>"  +"&nbsp;</td>"
                                text =text +"</tr>"
                            } 
                        } 
                        text=text +"</table>"
                        document.getElementById("dvDocs").innerHTML=text ;  
                    } 
                    checkStatus(0,intN);
                }
            }
        }
        
        
        function BuildNewlist(strindex,obj)
        {
            if(strindex!='')
            {
                var listids = obj.value.split(";")
                 
                var newlist='';
                for(k=listids.length-2;k>=0;k--)
                {
               
                    if(checkExists(strindex,k)==true)
                    {
                    // alert(strindex+' if '+k)
                    }
                    else
                    {
                    // alert(strindex+' else '+k)
                        newlist = newlist+listids[k]+";";
                    }
                }  
                var newolist=''
                var newulist=newlist.split(";")
                for(var l=newulist.length-1;l>=0;l--)
                {
                    if(newulist[l]!='')
                   newolist=newolist+newulist[l]+";"
                }
                 obj.value= newolist
                //alert(newlist)
            }
        }
        function checkExists(strval,index)
        {
            var strvals =strval.split(',')
            for(var i=0;i<strvals.length;i++)
            {
                if(strvals[i]=='')
                    return false ;
                if(strvals[i]==index)
                return true; 
            }   
            return false;  
        }
        
        
        function OpenScanning()
        {
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value;
            
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=account&temp=1' + '&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
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
        </script>

        <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
            border="0" cellpadding="0" cellspacing="15">
            <tr>
                <td style="color: #666666; font-size: 13px;">
                    <a id="lnkClient" runat="server" class="lnk" style="font-size: 11px; color: #666666;">
                    </a>&nbsp;>&nbsp;<a id="lnkAccounts" runat="server" class="lnk" style="font-size: 11px;
                        color: #666666;">Accounts</a>&nbsp;>&nbsp;Add New Matter
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr id="NewInfo" runat="server" style="padding-bottom: 20px" visible="true">
                            <td>
                                <div class="iboxDiv">
                                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                        <tr>
                                            <td valign="top" style="width: 16;">
                                                <img alt="" id="Img1" runat="server" border="0" src="~/images/16x16_note3.png" />
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
                                                            out according to the current MatterType. Please change the necessary information
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
                                                <img alt="" id="Img22" runat="server" src="~/images/message.png" align="absmiddle"
                                                    border="0">
                                            </td>
                                            <td runat="server" id="tdError">
                                            </td>
                                        </tr>
                                    </table>
                                    &nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
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
                                                        <asp:DropDownList caption="Matter Type" TabIndex="1" CssClass="entry" runat="server" Width="250px"
                                                            ID="ddlMatterType"  AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Matter Date:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <cc1:InputMask validate="IsValidDateTime(Input.value);" Width="250px" caption="Acquired" required="true"
                                                            TabIndex="2" CssClass="entry" ReadOnly="true" ID="txtMatterDate" runat="server" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Account Number:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:TextBox ID="txtAccountNumber" ReadOnly="true" Width="250px" runat="server" CssClass="entry" TabIndex="3"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <!-- 2.10.2010 -->
                                                <tr id="trCreditor" runat="server" style="display:inline;">
                                                    <td class="entrytitlecell">
                                                        Creditor:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Creditor" TabIndex="4" CssClass="entry" runat="server" Width="250px"
                                                            ID="ddlCreditors" AutoPostBack="true" >
                                                        </asp:DropDownList>
                                                        <asp:TextBox ID="txtCreditor" ReadOnly="true" Width="250px" runat="server" CssClass="entry" TabIndex="3" Visible="false"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <!-- 2.11.2010 -->
                                                 <tr id="trAssignedToGroup" runat="server" style="display:inline;">
                                                    <td class="entrytitlecell" >
                                                        Assigned To Group:
                                                    </td>
                                                     <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Group" TabIndex="5" CssClass="entry" runat="server" Width="250px"
                                                            ID="ddlAssignedToGroups" AutoPostBack="true" OnSelectedIndexChanged="ddlAssignedToGroups_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true" style="width: 95px">
                                                        Matter Number:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:TextBox ID="txtMatterNumber" ReadOnly="true" Width="250px" runat="server" CssClass="entry" TabIndex="7"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell">
                                                        Matter Status:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Matter Status" TabIndex="8" CssClass="entry" runat="server" Width="250px" 
                                                            ID="ddlMatterStatusCode" AutoPostBack="true" OnSelectedIndexChanged="ddlMatterStatusCode_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell">
                                                        Matter Sub Status:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Matter Sub Status" TabIndex="8" CssClass="entry" runat="server" Width="250px" 
                                                            ID="ddlMatterSubStatusCode">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr id="trLocalCounsel" runat="server">
                                                    <td class="entrytitlecell">
                                                        Local Counsel:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:DropDownList caption="Local Counsel" TabIndex="9" CssClass="entry" runat="server" Width="250px"
                                                            ID="ddlLocalCounsel">
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
                                                <tr id="trClassifications" runat="server" style="display:inline;">
                                                    <td class="entrytitlecell" valign="top">
                                                        Classification:
                                                    </td>
                                                    <td class="entrytitlecell">
                                                        <asp:ListBox ID="ddlClassification" runat="server" TabIndex="10" CssClass="entry" Width="250px"
                                                            SelectionMode="Multiple"></asp:ListBox>
                                                    </td>
                                                </tr>
                                                <!--
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" style="width:95px">Matter Memo:</td>
                                                <td ><input type="text" class="entry" id="txtMatterMemo"  runat="server" TabIndex="7" /></td>
                                            </tr>
                                            -->
                                                <tr id="trMessage" runat="server">
                                                    <td class="entrytitlecell" colspan="2">
                                                        Matter Description:<br />
                                                        <asp:TextBox TabIndex="8" CssClass="entry" runat="server" ID="txtMatterMemo2" Rows="10"
                                                            TextMode="MultiLine" MaxLength="1000" Columns="50" Style="width: 50em"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table style="margin: 0 20 20 0; font-family: tahoma; font-size: 11px; width: 300;"
                                                border="0" cellpadding="0" cellspacing="5">
                                                <tr>
                                                    <td class="entrytitlecell" style="padding-left: 10; width: 250">
                                                        <a style="color: black;" href="javascript:OpenPropagations();" class="lnk">
                                                            <img id="Img6" border="0" align="absmiddle" src="~/images/16x16_calendar_add.png"
                                                                runat="server" style="margin-right: 5;" />Add Tasks</a><asp:Label ForeColor="blue"
                                                                    runat="server" ID="lblPropagations"></asp:Label>
                                                    </td>
                                                    <td class="entrytitlecell" style="padding-left: 10; width: 250">
                                                        <a style="color: black;" href="javascript:OpenPhoneCalls();" class="lnk">
                                                            <img id="Img9" border="0" align="absmiddle" src="~/images/16x16_phone_add.png"
                                                                runat="server" style="margin-right: 5;" />Add Phone Note</a><asp:Label ForeColor="blue"
                                                                    runat="server" ID="lblPhoneCalls"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <!-- put space here -->
                                <img alt="" id="Img3" height="1" width="30" runat="server" src="~/images/spacer.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="entrytitlecell" colspan="3" style="width: 100%; padding-top: 10px">
                    <table id="Table1" style="font-family: tahoma; font-size: 11px; width: 100%;"
                        border="0" cellpadding="5" cellspacing="0" runat="server">
                        <tr>
                            <td style="background-color: #f1f1f1;">
                                Tasks
                            </td>
                            <td style="background-color: #f1f1f1;" align="right">
                                <a class="lnk" id="hypDeleteTask" disabled="true" runat="server" href="#">Delete</a>
                            </td>
                        </tr>
                        <tr id="tr1" runat="server">
                            <td colspan="2">
                                <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list"
                                    style="font-family: tahoma; font-size: 11px; width: 100%;" cellspacing="0" cellpadding="3">
                                    <thead>
                                        <tr>
                                            <th style="width: 25px;" align="center" style="display: none;">
                                                <img id="Img7" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(1);"
                                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                    border="0" /><img id="Img8" runat="server" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(1);"
                                                        style="cursor: pointer; display: none;" title="Uncheck All" src="~/images/11x11_uncheckall.png"
                                                        border="0" />
                                            </th>
                                            <th align="left" style="width: 150px;">
                                                Assigned To
                                            </th>
                                            <th align="left" style="width: 100px;">
                                                Due Date
                                            </th>
                                            <th align="left" style="width: 260px;">
                                                Task Type
                                            </th>
                                            <th align="left" style="width: 280px;">
                                                Description
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="5">
                                                <div id="dvTasks">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="entrytitlecell" colspan="3" style="width: 100%; padding-top: 10px">
                    <table id="tblDocuments" style="font-family: tahoma; font-size: 11px; width: 100%;"
                        border="0" cellpadding="5" cellspacing="0" runat="server">
                        <tr>
                            <td style="background-color: #f1f1f1;">
                                Document
                            </td>
                            <td style="background-color: #f1f1f1;" align="right">
                                <a class="lnk" href="javascript:AttachDocument();">Attach Document</a>&nbsp;|&nbsp;<a
                                    class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:DeleteDocument();">Delete</a>
                            </td>
                        </tr>
                        <tr id="tr2" runat="server">
                            <td colspan="2">
                                <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list"
                                    style="font-family: tahoma; font-size: 11px; width: 100%;" cellspacing="0" cellpadding="3">
                                    <thead>
                                        <tr>
                                            <th style="width: 25px;" align="center">
                                                <img id="Img4" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(2);"
                                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                    border="0" /><img id="Img5" runat="server" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(2);"
                                                        style="cursor: pointer; display: none;" title="Uncheck All" src="~/images/11x11_uncheckall.png"
                                                        border="0" />
                                            </th>
                                            <th align="left" style="width: 260px;">
                                                Document Name
                                            </th>
                                            <th align="left" style="width: 170px;">
                                                Received
                                            </th>
                                            <th align="left" style="width: 170px;">
                                                Created
                                            </th>
                                            <th align="left" style="width: 190px;">
                                                Created By
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="5">
                                                <div id="dvDocs">
                                                </div>
                                            </td>
                                        </tr>
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
                    <img id="Img2" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" />
                </td>
            </tr>
        </table>
        <asp:DropDownList runat="server" ID="cboTaskType" Style="display: none;">
        </asp:DropDownList>
        <asp:DropDownList runat="server" ID="cboAssigneeList" Style="display: none;">
        </asp:DropDownList>
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
        <asp:HiddenField runat="server" ID="txtPhoneNote" />
        <asp:HiddenField runat="server" ID="txtAttachDoc" />
        <asp:LinkButton ID="lnkShowDocs" runat="server" />
        <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
        <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSaveCose"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
        <input type="hidden" runat="server" id="hdnAttachments" value="" />
        <input type="hidden" runat="server" id="hdnAttachmentsText" value="" />
        <input type="hidden" runat="server" id="hdnReceivedDate" value="" />
        <input type="hidden" runat="server" id="hdnCreatedDate" value="" />
        <input type="hidden" runat="server" id="hdnCreatedBy" value="" />
        <input type="hidden" runat="server" id="hdnLatestCreditorId" value="0" />
    </body>
</asp:Content>
