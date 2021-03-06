<%@ Page Language="VB" AutoEventWireup="false" CodeFile="propagations.aspx.vb" Inherits="tasks_task_propagations" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Task Propagation</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
	<script type="text/javascript" src="<%= ResolveUrl("~/")%>jquery/plugins/ui.datepicker.js"></script>
	<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
	<link type="text/css" href="<%= ResolveUrl("~/")%>css/demos.css" rel="stylesheet" />
</head>
<body onload="LoadPropagations();">

    <script type="text/javascript">
    
     if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
    function DeletePropagation(lnk)
    {
        if (!lnk.disabled)
        {
            var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

            // delete bottom row then top
             tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 2);
            tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 1);
            tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex);
        }
    }
    function ClearPropagations(lnk)
    {
        if (!lnk.disabled)
        {
            var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

            // remove all but the first row (header)
            while (tblTaskPropagation.rows.length > 1)
            {
                tblTaskPropagation.deleteRow(tblTaskPropagation.rows.length - 1);
            }
        }
    }

    function LoadPropagations()
    {
        var IsResolved;
        if (window.parent.currentModalDialog) {
            IsResolved = window.parent.currentModalDialog.modaldialog("dialogArguments").IsResolved();}
        else {
            IsResolved = window.top.dialogArguments.IsResolved();
        }

        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");

        var lnkAddPropagation = document.getElementById("<%= lnkAddPropagation.ClientID %>");
        var lnkClearPropagations = document.getElementById("<%= lnkClearPropagations.ClientID %>");

        var value;
        if (window.parent.currentModalDialog) {
            value = window.parent.currentModalDialog.modaldialog("dialogArguments").GetPropagations();}
        else {
            value = window.top.dialogArguments.GetPropagations();
        }

        if (value.length > 0)
        {
            var Propagations = value.split("|");
            
            for (a = 0; a < Propagations.length; a++)
            {
                var Fields = Propagations[a].split(",");

                var AssignedTo = Fields[0];
                var DueType = Fields[1];
                var Date = Fields[2];
                var Due = Fields[3];
                var TaskType = Fields[4];
                var Description = Fields[5];
                var TaskID = Fields[6];
//                var DueHr = Fields[7];
//                var DueMin = Fields[8];
//                var DueZone = Fields[9];
                var TimeBlock = Fields[12];
                var CanEdit = Fields[13];
                  var Reason= "";//Fields[14];

//                AddPropagation(IsResolved, AssignedTo, DueType, Date, Due, DueHr, DueMin, DueZone, TaskType, Description, TaskID);
                AddPropagation(IsResolved, AssignedTo, DueType, Date, Due, "", "", "6", TaskType, Description, TaskID, TimeBlock, CanEdit, Reason);
                
            }
            AddPropagation(false, 0, 0, "", "", "", "", "6", 0, "", 0, "", true, "");
        }
        else
        {
            AddPropagation(false, 0, 0, "", "", "", "", "6", 0, "", 0, "", true, "");
        }

        if (IsResolved)
        {
            lnkAddPropagation.disabled = true;
            lnkClearPropagations.disabled = true;
        }
    }
    function AddPropagationClick(lnk)
    {
        if (!lnk.disabled)
        {
            AddPropagation(false, 0, 0, "", "", "", "", "6", 0, "", 0, "", true, "");
        }
    }
    
    function AddPropagation(IsResolved, AssignedTo, DueType, Date, Due, DueHr, DueMin, DueZone, TaskType, Description, TaskID, TimeBlock, CanEdit, Reason)
    {
        var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

        var AssignedToGroup= <%= AssignedToGroup %>;

        var trNewTop = tblTaskPropagation.insertRow(-1);
        var trNewBottom = tblTaskPropagation.insertRow(-1);
        var trReasonRow = tblTaskPropagation.insertRow(-1);

        var tdDelete = trNewTop.insertCell(-1);
        var tdAssignedTo = trNewTop.insertCell(-1);
        //var tdDueType = trNewTop.insertCell(-1);
        var tdDue = trNewTop.insertCell(-1);
        var tdTimeBlock = trNewTop.insertCell(-1);
//        var tdDueHr = trNewTop.insertCell(-1);
//        var tdDueMin = trNewTop.insertCell(-1);
//        var tdDueZone = trNewTop.insertCell(-1);
        var tdTaskType = trNewTop.insertCell(-1);
 
        var tdDeleteEmpty = trNewBottom.insertCell(-1);
        var tdDescriptionLabel = trNewBottom.insertCell(-1);
        var tdDescription = trNewBottom.insertCell(-1);

        var tdReasonEmpty = trReasonRow.insertCell(-1);
        var tdReasonLabel = trReasonRow.insertCell(-1);
        var tdReason = trReasonRow.insertCell(-1);

        var lnkDelete = GetNewDelete();
        var cboAssignedTo = null;
        if (AssignedTo>0)
        {
            cboAssignedTo = GetNewAssignedTo(AssignedTo);
        }
        else
        {
            cboAssignedTo = GetNewAssignedTo(AssignedToGroup);
        }    
        //var cboDueType = GetNewDueType(DueType);
        //var txtDue = GetNewDue(Due);
        //var txtDueDate = GetNewDueDate(Date);
        var txtDueDate = GetNewDueDateControl(Date,CanEdit,TaskID);
//        var cboDueHr = GetNewDueHr(DueHr);
//        var cboDueMin = GetNewDueMin(DueMin);
//        var cboDueZone = GetNewDueZone(DueZone);
        var cboTimeBlock = GetTimeBlock(TimeBlock,TaskID);
        var txtDeleteEmpty = GetNewDeleteEmpty(TaskID);
        var cboTaskType = GetNewTaskType(TaskType);
        var txtDescription = null;

        if (Description != null && Description.length > 0)
        {
            txtDescription = GetNewDescription(Description);
        }
        else
        {
            txtDescription = GetNewDescription("");
        }

        var txtReasonEmpty = GetNewReasonEmpty(Date+TimeBlock);
        var txtReason = null;

        if (Reason != null && Reason.length > 0)
        {
            txtReason = GetNewReason(Reason);
        }
        else
        {
            txtReason = GetNewReason("");
        }
        
        // insert top row of fields
        tdDelete.insertAdjacentElement("afterBegin", lnkDelete);

        tdAssignedTo.insertAdjacentElement("afterBegin", cboAssignedTo);

        //tdDueType.insertAdjacentElement("afterBegin", cboDueType);

        //tdDue.insertAdjacentElement("afterBegin", txtDue);
        tdDue.insertAdjacentElement("afterBegin", txtDueDate);
        addHandlers(tdDue); 
//        tdDueHr.insertAdjacentElement("afterBegin", cboDueHr);
//        tdDueMin.insertAdjacentElement("afterBegin", cboDueMin);
//        tdDueZone.insertAdjacentElement("afterBegin", cboDueZone);
        tdTimeBlock.insertAdjacentElement("afterBegin", cboTimeBlock);
        tdTaskType.insertAdjacentElement("afterBegin", cboTaskType);
        
        //cboDueType_OnChange(cboDueType);
        cboTaskType_OnChange(cboTaskType);

        // insert bottom row of fields
        
        tdDeleteEmpty.insertAdjacentElement("afterBegin", txtDeleteEmpty);
        
        tdReasonEmpty.insertAdjacentElement("afterBegin", txtReasonEmpty);
//        tdDeleteEmpty.className = "listItem2";
//        tdDeleteEmpty.style.paddingTop = 0;
//        tdDeleteEmpty.innerHTML = "&nbsp;";

        tdDescriptionLabel.className = "listItem2";
        tdDescriptionLabel.style.paddingTop = 0;
        tdDescriptionLabel.align = "right";
        tdDescriptionLabel.innerHTML = "Description:";
        
        tdReasonLabel.className = "listItem2";
        tdReasonLabel.style.paddingTop = 0;
        tdReasonLabel.align = "right";
        tdReasonLabel.innerHTML = "Reason:";

        tdDescription.colSpan = 5;
        tdDescription.className = "listItem2";
        tdDescription.style.paddingTop = 0;
        tdDescription.insertAdjacentElement("afterBegin", txtDescription);
        
        tdReason.colSpan = 5;
        tdReason.className = "listItem2";
        tdReason.style.paddingTop = 0;
        tdReason.insertAdjacentElement("afterBegin", txtReason);

        lnkDelete.disabled = IsResolved;
        cboAssignedTo.disabled = IsResolved;
        //cboDueType.disabled = IsResolved;
        //txtDue.disabled = IsResolved;
        txtDueDate.disabled = IsResolved;
//        cboDueHr.disabled = IsResolved;
//        cboDueMin.disabled = IsResolved;
//        cboDueZone.disabled = IsResolved;
        cboTimeBlock.disabled = IsResolved;
        cboTaskType.disabled = IsResolved;
        txtDescription.disabled = IsResolved;
        txtDeleteEmpty.disabled = IsResolved;
        txtReasonEmpty.disabled = IsResolved;
        txtReason.disabled = IsResolved;

        if (CanEdit=="False")
        {
            cboAssignedTo.disabled = true;
            //cboTimeBlock.disabled = true;
            cboTaskType.disabled = true;
            txtDescription.disabled = true;
            //txtDueDate.disabled = true;
        }
       
        if(Reason=="")
        {
         trReasonRow.style.display="none";
        }
        
        
    }
    
    function GetNewDelete()
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {DeletePropagation(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
    }
    
    function GetNewDueHr(Hr)
    {
        var cboDueHr = document.getElementById("<%= cboDueHr.ClientID %>");
    
        var select = document.createElement("SELECT");

        select.className = "entry";

		//select.onchange = function () {cboDueType_OnChange(this)};

        var option = document.createElement("OPTION");

        select.options.add(option);
        option.innerText = "Hr";
        option.value = "";
        if (Hr != null && Hr == "")
        {
            option.selected = true;
        }

        for (var i=0; i<24; i++)
        {
            option = document.createElement("OPTION");
            select.options.add(option);
            option.innerText = i;
            option.value = i;
            if (Hr != null && Hr == option.value)
            {
                option.selected = true;
            }
        }
        
        return select;
    }
    
    function GetNewDueMin(Min)
    {
        var cboDueMin = document.getElementById("<%= cboDueMin.ClientID %>");
    
        var select = document.createElement("SELECT");

        select.className = "entry";

		//select.onchange = function () {cboDueType_OnChange(this)};

        var option = document.createElement("OPTION");

        select.options.add(option);
        option.innerText = "Min";
        option.value = "";
        if (Min != null && Min == "")
        {        
            option.selected = true;
        }
        
        for (var i=0; i<60; i+=5)
        {
            option = document.createElement("OPTION");
            select.options.add(option);
            option.innerText = i;
            option.value = i;
            if (Min != null && Min == option.value)
            {
                option.selected = true;
            }
        }
        
        return select;
    }
    
    function GetTimeBlock(TimeBlock,TaskID)
    {   
        var cboTimeBlock = document.getElementById("<%= cboTimeBlock.ClientID %>");
    
        var select = document.createElement("SELECT");
        
        if (TaskID>0)
        {
            select.onchange = function () {cboTimeBlock_OnChange(this)};
        }

        select.className = "entry";

        var option = document.createElement("OPTION");
        select.options.add(option);
        option.innerText = "TimeBlock";
        option.value = "";
        if (TimeBlock != null && TimeBlock == "")
        {
            option.selected = true;
        }

        var option = document.createElement("OPTION");
        select.options.add(option);
        option.innerText = "8-11 AM";
        option.value = "1";
        if (TimeBlock != null && TimeBlock == "8-11 AM")
        {        
            option.selected = true;
        }
        
        var option = document.createElement("OPTION");
        select.options.add(option);
        option.innerText = "11 AM-2 PM";
        option.value = "2";
        if (TimeBlock != null && TimeBlock == "11 AM-2 PM")
        {        
            option.selected = true;
        }
        
        var option = document.createElement("OPTION");
        select.options.add(option);
        option.innerText = "2-5 PM";
        option.value = "3";
        if (TimeBlock != null && TimeBlock == "2-5 PM")
        {        
            option.selected = true;
        }
        
        
        var option = document.createElement("OPTION");
        select.options.add(option);
        option.innerText = "Not Available";
        option.value = "4";
        if (TimeBlock != null && TimeBlock == "Not Available")
        {        
            option.selected = true;
        }
        
        return select;
    }
    
    function GetNewDueZone(Zone)
    {
    
        var cboDueZone = document.getElementById("<%= cboDueZone.ClientID %>");

        var select = document.createElement("SELECT");

        select.className = "entry";

        for (i = 0; i < cboDueZone.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboDueZone.options[i].innerText;
            option.value = cboDueZone.options[i].value;

            if (Zone != null && Zone == cboDueZone.options[i].value)
            {
                option.selected = true;
            }
        }

        return select;
        
    }
    
    function GetNewTaskType(TaskType)
    {
        var cboTaskType = document.getElementById("<%= cboTaskType.ClientID %>");

        var select = document.createElement("SELECT");

		select.onchange = function () {cboTaskType_OnChange(this)};

        select.className = "entry";

        for (i = 0; i < cboTaskType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboTaskType.options[i].innerText;
            option.value = cboTaskType.options[i].value;

            if (TaskType != null && TaskType == cboTaskType.options[i].value)
            {
                option.selected = true;
            }
        }

        return select;
    }
    function GetNewDueType(DueType)
    {
        var select = document.createElement("SELECT");

        select.className = "entry";

		select.onchange = function () {cboDueType_OnChange(this)};

        var option = document.createElement("OPTION");

        select.options.add(option);
        option.innerText = "Date";
        option.value = "0";

        if (DueType != null && DueType == "0")
        {
            option.selected = true;
        }

        option = document.createElement("OPTION");

        select.options.add(option);
        option.innerText = "Days";
        option.value = "1";

        if (DueType != null && DueType == "1")
        {
            option.selected = true;
        }

        return select;
    }

    
    function GetNewAssignedTo(AssignedTo)
    {
        var action = document.getElementById("<=pTitle %>");
        var action1 = '<%=ptitle %>';
        
        
//        if (action1 == "Add Matter Task " || action1 == "Edit Matter Task ")
//        {
            var cboAssignedTo = document.getElementById("<%= cboAssignedTo.ClientID %>");
            var select = document.createElement("SELECT");

            select.className = "entry";
            
            
            for (i = 0; i < cboAssignedTo.options.length; i++)
            {
                var option = document.createElement("OPTION");

                select.options.add(option);
                option.innerText = cboAssignedTo.options[i].innerText;
                option.value = cboAssignedTo.options[i].value;
                
                if (isNaN(AssignedTo))
                {
                    if (AssignedTo != null && AssignedTo  == cboAssignedTo.options[i].innerText)
                    {
                        option.selected = true;
                    }
                }
                else
                {
                    if (AssignedTo != null && AssignedTo  == cboAssignedTo.options[i].value)
                    {
                        option.selected = true;
                    }
                }
                
            }
            
            return select;
//        }
//        else
//        {
//            var select = document.createElement("SELECT");

//            select.className = "entry";

//            var option = document.createElement("OPTION");

//            select.options.add(option);
//            option.innerText = "Original";
//            option.value = "0";

//            if (AssignedTo != null && AssignedTo == "0")
//            {
//                option.selected = true;
//            }

//            option = document.createElement("OPTION");

//            select.options.add(option);
//            option.innerText = "Resolver";
//            option.value = "1";

//            if (AssignedTo != null && AssignedTo == "1")
//            {
//                option.selected = true;
//            }
//            return select;
//        }
    }
    //code to display the calender control
	var ctrllist=""
	var dtCtrlCnt=0
    function addHandlers(root){
        $('input').filter('.datepicker').datepicker({
        //changeMonth: true,
		//changeYear: true,
		showAnim: 'fadeIn', showOn: 'button', buttonImage: 'images/calendar.gif', buttonImageOnly: true
        });
    } 
    
    $(document).ready(function() 
    {
        $("#<%=lnkAddPropagation.ClientID %>").click(AddPropagationClick);
        addHandlers($(document));
    }); 
    
    function GetNewDueDateControl(DueDate, CanEdit, TaskID)
    {
        var input = document.createElement("INPUT");
        input.setAttribute("id","dt"+dtCtrlCnt);
        input.type = "text";
        input.setAttribute("style:font-size","7");
        //if (CanEdit=="True" || CanEdit==true)
            input.className = "datepicker";      
           
        dtCtrlCnt=dtCtrlCnt+1;   
        
        input.mask = "nn/nn/nnnn";
	    input.maskDisplay="_";
	    input.maskAlpha = "a";
	    input.maskNumeric="n";
	    input.maskAlphaNumeric="x";
	    input.RegexPattern = "";
	    input.OnRegexMatch = "";
	    input.OnRegexNoMatch = "";
	    input.OnWrongKeyPressed = "";
        input.oncut = function () 
        {
            ASI_InputMask_OnCut(this);
            if (TaskID>0){txtDate_OnChange(this);} 
        };
        input.onblur = function () {ASI_InputMask_LostFocus(this)};
        input.oninput = function () {ASI_InputMask_OnInput(event, this);
            if (TaskID>0){txtDate_OnChange(this);} };
        input.onpaste = function () {ASI_InputMask_OnPaste(this);
            if (TaskID>0){txtDate_OnChange(this);} };
        input.onfocus = function () {ASI_InputMask_GotFocus(this)};
        input.onclick = function () {ASI_InputMask_OnClick(event, this)};
        input.onkeydown = function () {ASI_InputMask_KeyDown(event, this);
            if (TaskID>0){txtDate_OnChange(this);} };
        input.onkeypress = function () {ASI_InputMask_KeyPress(event, this);
            if (TaskID>0){txtDate_OnChange(this);} };
        input.onchange = function () {if (TaskID>0){txtDate_OnChange(this);} };
		
        var today1 = new Date();
	    var mydate1 = parseInt(today1.getUTCMonth()+1,10)+'/'+parseInt(today1.getUTCDate(),10)+'/'+parseInt(today1.getUTCFullYear(),10)
		
        if (DueDate != null && DueDate.length > 0)
        {
            input.value = DueDate;
        }
        else
        {
            input.value = mydate1;
        }
        return input;
    }
    //End of code to display the calender control
    
    function GetNewDueDate(Date)
    {
        var input = document.createElement("INPUT");

        // dynamically create an input mask
        input.type = "text"
        input.className = "entry";
		input.mask = "nn/nn/nnnn";
		input.maskDisplay="_";
		input.maskAlpha = "a";
		input.maskNumeric="n";
		input.maskAlphaNumeric="x";
		input.RegexPattern = "";
		input.OnRegexMatch = "";
		input.OnRegexNoMatch = "";
		input.OnWrongKeyPressed = "";
		input.oncut = function () {ASI_InputMask_OnCut(this)};
		input.onblur = function () {ASI_InputMask_LostFocus(this)};
		input.oninput = function () {ASI_InputMask_OnInput(event, this)};
		input.onpaste = function () {ASI_InputMask_OnPaste(this)};
		input.onfocus = function () {ASI_InputMask_GotFocus(this)};
		input.onclick = function () {ASI_InputMask_OnClick(event, this)};
		input.onkeydown = function () {ASI_InputMask_KeyDown(event, this)};
		input.onkeypress = function () {ASI_InputMask_KeyPress(event, this)};

        if (Date != null && Date.length > 0)
        {
            input.value = Date;
        }

        return input;
    }
    function GetNewDue(Due)
    {
        var input = document.createElement("INPUT");

		input.onkeypress = function () {onlyDigits()};

        input.type = "text";
        input.className = "entry";
        input.style.display = "none";

        if (Due != null && Due.length > 0)
        {
            input.value = Due;
        }

        return input;
    }
    function GetNewDeleteEmpty(TaskID)
    {
        var input = document.createElement("INPUT");

		input.onkeypress = function () {onlyDigits()};

        input.type = "text";
        input.className = "entry";
        input.style.display = "none";

        if (TaskID != null && TaskID.length > 0)
        {
            input.value = TaskID;
        }

        return input;
    }
    
    function GetNewReasonEmpty(OldVal)
    {
        var input = document.createElement("INPUT");

		input.onkeypress = function () {onlyDigits()};

        input.type = "text";
        input.className = "entry";
        input.style.display = "none";

        if (OldVal != null && OldVal.length > 0)
        {
            input.value = OldVal;
        }

        return input;
    }
    
    function GetNewReason(Reason)
    {
        var input = document.createElement("textarea");
        input.setAttribute("name","mytextarea");
        input.setAttribute("cols","50");
        input.setAttribute("rows","2");
        input.className = "entry";
        
        if (Reason != null && Reason.length > 0);
        {
            input.value = Reason;
        }

        return input;
    }
    function GetNewDescription(Description)
    {
        var input = document.createElement("INPUT");

        input.type = "text";
        input.className = "entry";
        if (Description != null && Description.length > 0);
        {
            input.value = Description;
        }

        return input;
    }
    
    function ResetPropagations()
    {
        var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");
        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");

        txtPropagations.value = "";

        for (i = 1; i < tblTaskPropagation.rows.length; i += 3)
        {
            var cboAssignedTo = tblTaskPropagation.rows[i].cells[1].childNodes[0];
            var txtDueDate = tblTaskPropagation.rows[i].cells[2].childNodes[0];
//            var cboDueHr = tblTaskPropagation.rows[i].cells[3].childNodes[0];
//            var cboDueMin = tblTaskPropagation.rows[i].cells[4].childNodes[0];
//            var cboDueZone = tblTaskPropagation.rows[i].cells[5].childNodes[0];
//            var cboTaskType = tblTaskPropagation.rows[i].cells[6].childNodes[0];
            var cboTimeBlock = tblTaskPropagation.rows[i].cells[3].childNodes[0];
            var cboTaskType = tblTaskPropagation.rows[i].cells[4].childNodes[0];
            var txtDescription = tblTaskPropagation.rows[i + 1].cells[2].childNodes[0];
            var txtEmptyDelete = tblTaskPropagation.rows[i + 1].cells[0].childNodes[0];

            var txtReasonEmpty = tblTaskPropagation.rows[i + 2].cells[0].childNodes[0];
            var txtReason = tblTaskPropagation.rows[i + 2].cells[2].childNodes[0];
            
            var strReason="";
            
             
            
            if (txtEmptyDelete.value!=0)
            {
                if (txtDueDate.value+cboTimeBlock.options[cboTimeBlock.selectedIndex].text!=txtReasonEmpty.value)//txtDueDate.value+cboTimeBlock.value!=txtReasonEmpty.value)
                {
                    strReason=txtReason.value
                }
            }

            if (txtPropagations.value.length > 0)
            {
                txtPropagations.value += "|";
            }
            
            if(txtEmptyDelete.value=="") {txtEmptyDelete.value=0};
//            txtPropagations.value += cboAssignedTo.options[cboAssignedTo.selectedIndex].value + "," + "0" + "," + txtDueDate.value + "," + "0" + "," + cboTaskType.options[cboTaskType.selectedIndex].value + "," + txtDescription.value + "," + txtEmptyDelete.value + "," + cboDueHr.options[cboDueHr.selectedIndex].value + "," + cboDueMin.options[cboDueMin.selectedIndex].value + "," + cboDueZone.options[cboDueZone.selectedIndex].value;
            txtPropagations.value += cboAssignedTo.options[cboAssignedTo.selectedIndex].value + "," + "0" + "," + txtDueDate.value + "," + "0" + "," + cboTaskType.options[cboTaskType.selectedIndex].value + "," + txtDescription.value.replace(/,/g,'[cm]') + "," + txtEmptyDelete.value + "," + "" + "," + "" + "," + "" + "," + cboAssignedTo.options[cboAssignedTo.selectedIndex].text + "," + cboTaskType.options[cboTaskType.selectedIndex].text + "," + cboTimeBlock.options[cboTimeBlock.selectedIndex].text + "," + "" + "," +strReason;   
        }
    }
    
    function cboDueType_OnChange(obj)
    {
        var txtDueDate = obj.parentElement.parentElement.cells[3].childNodes[0];
        var txtDue = obj.parentElement.parentElement.cells[3].childNodes[1];

        if (obj.options[obj.selectedIndex].value == "0") //0 - On Specific Date
        {
            txtDueDate.style.display = "inline";
            txtDue.style.display = "none";
        }
        else //1 - Days From Now
        {
            txtDueDate.style.display = "none";
            txtDue.style.display = "inline";
        }
    }
    
    function txtDate_OnChange(obj)
    {
        var trTop = obj.parentElement.parentElement;
        var trBottom = trTop.nextSibling;
        var trReason = trTop.nextSibling.nextSibling;

        trReason.style.display = "inline";
    }
    
    
    function cboTimeBlock_OnChange(obj)
    {
        var trTop = obj.parentElement.parentElement;
        var trBottom = trTop.nextSibling;
        var trReason = trTop.nextSibling.nextSibling;

        trReason.style.display = "inline";
    }
    
    function cboTaskType_OnChange(obj)
    {
        var trTop = obj.parentElement.parentElement;
        var trBottom = trTop.nextSibling;

        Row_RemoveStyle(trTop);
        trBottom.style.display = "inline";

//        if (obj.options[obj.selectedIndex].value == "0") // 0 - Ad Hoc
//        {
//            Row_RemoveStyle(trTop);

//            trBottom.style.display = "inline";
//        }
//        else
//        {
//            trBottom.style.display = "none";

//            Row_SetStyle(trTop, "listItem2");
//        }
    }
    function Row_SetStyle(tr, className)
    {
        for (i = 0; i < tr.cells.length; i++)
        {
            var td = tr.cells[i];

            td.className = className;
        }
    }
    function Row_RemoveStyle(tr)
    {
        for (i = 0; i < tr.cells.length; i++)
        {
            var td = tr.cells[i];

            td.className = null;
        }
    }
	function SavePropagations()
	{
	    if (RequiredExist())
	    {   
	        ResetPropagations();

            if('<%=TaskID %>'=='0'&& '<%=MatterId %>'=='0')
            {
                var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
                if (window.parent.currentModalDialog) {
                    window.parent.currentModalDialog.modaldialog("dialogArguments").SavePropagations(txtPropagations.value);
                } else {
                     window.top.dialogArguments.SavePropagations(txtPropagations.value);
                }
                window.close();
            }
            else 
            {
            //save propogations here
                <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            }
	    }
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

	function ValidateDate(DueDate)
	{
	    var today = new Date();
	    var mydate = new Date(parseInt(today.getUTCMonth()+1,10)+'/'+parseInt(today.getUTCDate(),10)+'/'+parseInt(today.getUTCFullYear(),10));
	    var splitdate = DueDate.split("/");
	    var PDate = new Date(parseInt(splitdate[0],10)+'/'+parseInt(splitdate[1],10)+'/'+parseInt(splitdate[2],10));
		if(mydate>PDate)
		{
			return false;
		}
        else
        {
            return true;
        }	    
	}
	
	function RequiredExist()
	{
        // Propagations
        var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");
         for (i = 1; i < tblTaskPropagation.rows.length; i += 3)
        {
            var cboAssignedTo = tblTaskPropagation.rows[i].cells[1].childNodes[0];
            var txtDueDate = tblTaskPropagation.rows[i].cells[2].childNodes[0];
//            var cboDueHr = tblTaskPropagation.rows[i].cells[3].childNodes[0];
//            var cboDueMin = tblTaskPropagation.rows[i].cells[4].childNodes[0];
//            var cboDueZone = tblTaskPropagation.rows[i].cells[5].childNodes[0];
//            var cboTaskType = tblTaskPropagation.rows[i].cells[6].childNodes[0];
            var cboTimeBlock = tblTaskPropagation.rows[i].cells[3].childNodes[0];
            var cboTaskType = tblTaskPropagation.rows[i].cells[4].childNodes[0];
            var txtDeleteEmpty = tblTaskPropagation.rows[i + 1].cells[0].childNodes[0];
            var txtDescription = tblTaskPropagation.rows[i + 1].cells[2].childNodes[0];
            
            var txtReasonEmpty = tblTaskPropagation.rows[i + 2].cells[0].childNodes[0];
            var txtReason = tblTaskPropagation.rows[i + 2].cells[2].childNodes[0];
            
            
            if (txtDeleteEmpty.value!=0)
            {
                if (txtDueDate.value+cboTimeBlock.options[cboTimeBlock.selectedIndex].text!=txtReasonEmpty.value)
                {
                    if (txtReason.value=="")
                    {
                        ShowMessage("Reason for editing Due date or Time block is a required field");
                        //AddBorder(txtReason);
                        return false;
                    }
                    else
                    {
                        //RemoveBorder(txtReason);
                    }
                }
            }
            
            
            // Due Date must exist and must be valid
            if (txtDueDate.value.length == 0)
            {
                ShowMessage("The Due Date is a required field");
                AddBorder(txtDueDate);
                return false;
            }
            else if (txtDeleteEmpty.value==0 && !RegexValidate(txtDueDate.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
            {
                ShowMessage("The Due Date you entered for Propagation " + ((i + 1) / 2) + " is invalid.  Please select a valid date.");
                AddBorder(txtDueDate);
                return false;
            }
            else if (txtDeleteEmpty.value==0 && !ValidateDate(txtDueDate.value))
            {
                ShowMessage("The Due Date you entered for Propagation " + ((i + 1) / 2) + " is invalid.  Please select a valid date.");
                AddBorder(txtDueDate);
                return false;
            }
            else
            {
                RemoveBorder(txtDueDate);
            }

           
           //Time Block is required field
            if (cboTimeBlock.options[cboTimeBlock.selectedIndex].value == "") 
            {
                ShowMessage("The Time Block is a required field");
                AddBorder(cboTimeBlock);
                return false;
            }

        
            if (cboTaskType.options[cboTaskType.selectedIndex].value == 0) // Ad Hoc
            {
                // Days Due must exist and must be valid
	            if (txtDescription.value.length == 0)
	            {
	                ShowMessage("The Description for Propagation " + ((i + 1) / 2) + " is required because you selected an Ad Hoc task type.");
	                AddBorder(txtDescription);
	                return false;
	            }
                else
                {
                    RemoveBorder(txtDescription);
                }
            }
            else
            {
                RemoveBorder(txtDescription);
            }
        }
      

        HideMessage()
	    return true;
	}
	
	function AddBorder(obj)
	{
        obj.style.border = "solid 2px red";
        obj.focus();
	}
	function RemoveBorder(obj)
	{
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
	}
	function RegexValidate(Value, Pattern)
	{
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0)
        {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else
        {
            return false;
        }
	}
	
	function ReturnStatus(status){
	    if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", status);
        } else {
            window.returnValue=status;
        }
	    self.close();
	}

	</script>

    <form id="form1" runat="server">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-left:10;height:100%;">
                    <div style="height:100%;overflow:auto;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr><td id="ptitle" class="cLEnrollHeader"><%=pTitle%></td></tr>
                        <tr>
                            <td style="height:100%;" valign="top">
                                <table runat="server" id="tblPropagation" style="width:100%;font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <table id="tblTaskPropagation" runat="server" style="margin-bottom:10;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                                <tr>
                                                    <td class="headItem2" style="width:2%;">&nbsp;</td>
                                                    <td class="headItem2" style="width:28%;">Assigned To</td>
                                                    <td class="headItem2" style="width:20%;">Due Date</td>
                                                    <td class="headItem2" style="width:20%;">Time Block</td>
                                                    <%--<td class="headItem2" style="width:45;">Due Time in (Hr)</td>
                                                    <td class="headItem2" style="width:45;">Due Time in (Min)</td>
                                                    <td class="headItem2" style="width:150;">Time Zone</td>--%>
                                                    <td class="headItem2" style="width:30%;">Task Type</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left:5;">
                                            <a runat="server" id="lnkAddPropagation" href="#"  class="lnk" style="color: rgb(0,0,159);">Add New Task</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="#" onclick="ClearPropagations(this);return false" id="lnkClearPropagations" class="lnk" style="color: rgb(0,0,159);">Clear All</a>
                                         </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table></div>
                </td>
            </tr>
            <tr>
            <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="3" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Cancel and Close</a></td>
                            <td align="right"><a tabindex="4" style="color:black" class="lnk" href="javascript:SavePropagations();">Save Tasks <img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

    <!-- The following controls are only on the page so that the client script (above)
            can fill these controls with values to be post backed with the form.  They have no inner 
            value so they will not be visibly displayed on the page -->
    <asp:DropDownList runat="server" id="cboTimeBlock" style="display:none;"></asp:DropDownList>        
    <asp:DropDownList runat="server" id="cboDueHr" style="display:none;"></asp:DropDownList>
    <asp:DropDownList runat="server" id="cboDueZone" style="display:none;"></asp:DropDownList>
    <asp:DropDownList runat="server" id="cboDueMin" style="display:none;"></asp:DropDownList>
    <asp:DropDownList runat="server" id="cboTaskType" style="display:none;"></asp:DropDownList>
    <asp:DropDownList runat="server" ID="cboAssignedTo" style="display:none;"></asp:DropDownList>
    <input runat="server" id="txtPropagations" type="hidden" />
<asp:LinkButton ID="lnkSave" runat="server" ></asp:LinkButton>
    <!-- The following input mask control is only on the page so that the associated jscript will
            be rendered.  This is necessary so that dynamically-created input masks are valid. -->

    <cc1:inputmask style="display:none;" runat="server" id="txtInputMask"></cc1:inputmask>

    </form>
</body>
<!-- Script Added to insert a add task line automatically when the form opens -->
</html>