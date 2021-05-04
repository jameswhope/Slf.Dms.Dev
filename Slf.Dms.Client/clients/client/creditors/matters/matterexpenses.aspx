<%@ Page Title="" Language="VB" MasterPageFile="~/Clients/client/client.master" AutoEventWireup="false"
    CodeFile="matterexpenses.aspx.vb" Inherits="Clients_client_creditors_matters_matterexpenses" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:PlaceHolder ID="phBody" runat="server">
        <%@ Register src="~/customtools/usercontrols/DocumentsControl.ascx" tagname="DocumentsControl"
            tagprefix="LexxControl" %>
        <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
        <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
        <link type="text/css" href="<%= ResolveUrl("~/css/demos.css")%>" rel="stylesheet" />
        <script language="javascript">
    window.onload = function ()
    {
        LoadPropagations();
    }
    
    function DeletePropagation(lnk)
    {
        if (!lnk.disabled)
        {
            if (confirm("Are you sure, Do you want to delete the selected expense entry?"))
            {
                var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");


                var txtDeleteEmpty = tblTaskPropagation.rows[lnk.parentElement.parentElement.rowIndex + 1].cells[0].childNodes[0];
                if(txtDeleteEmpty.value!="")
                {
                    var temp=document.getElementById("<%=txtDeletedIDs.ClientID%>").value  ;
                    document.getElementById("<%=txtDeletedIDs.ClientID%>").value  =temp+","+txtDeleteEmpty.value;
                }

                // delete bottom row then top
              //  tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 2);
                tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 1);
                tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex);
             
            }
        }
    }
    function ClearPropagations(lnk)
    {
        if (!lnk.disabled)
        {
            if (confirm("Are you sure, Do you want to delete all the expense entries?"))
            {
                var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

                // remove all but the first row (header)
                while (tblTaskPropagation.rows.length > 1)
                {
                    tblTaskPropagation.deleteRow(tblTaskPropagation.rows.length - 1);
                }
            }
        }
    }

    function LoadPropagations()
    {
        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
        var lnkAddPropagation = document.getElementById("<%= lnkAddPropagation.ClientID %>");
        var lnkClearPropagations = document.getElementById("<%= lnkClearPropagations.ClientID %>");

        var value = GetPropagations();

        if (value.length > 0)
        {
            var Propagations = value.split("|");
 
            for (a = 0; a < Propagations.length; a++)
            {
                var Fields = Propagations[a].split(",");

                var EntryType = Fields[0];
                var EntryTypeID = Fields[1];
                var ExpenseDate = Fields[2];
                var AttorneyName = Fields[3];
                var AttorneyID = Fields[4];
                var Description = Fields[5];
                var ExpenseID = Fields[6];
                var BillTime = Fields[7];
                var BillRate = Fields[8];
                var SubTotal = Fields[9];
                var Memo = Fields[10];
                AddPropagation(EntryType, EntryTypeID, ExpenseDate, AttorneyName, BillTime, BillRate, SubTotal, AttorneyID, Description, ExpenseID, Memo);
                
            }
            //AddPropagation("", 0, "", "", "", "", "", 0, "", 0, "");
        }
        else
        {
            //AddPropagation("", 0, "", "", "", "", "", 0, "", 0, "");
        }

    }
    function AddPropagationClick(lnk)
    {
        if (!lnk.disabled)
        {
            AddPropagation("", 0, "", "", "", "", "", 0, "", 0, "");
        }
    }
    
    function AddPropagation(EntryType, EntryTypeID, ExpenseDate, AttorneyName, BillTime, BillRate, SubTotal, AttorneyID, Description, ExpenseID, Memo)
    {
        var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

        var trNewTop = tblTaskPropagation.insertRow(-1);
        var trNewBottom = tblTaskPropagation.insertRow(-1);

        var tdDelete = trNewTop.insertCell(-1);
        var tdEntryType = trNewTop.insertCell(-1);
        var tdExpenseDate = trNewTop.insertCell(-1);
        var tdDescription = trNewTop.insertCell(-1);
        var tdShowMemo = trNewTop.insertCell(-1);
        var tdAttorneyID = trNewTop.insertCell(-1);
        var tdBillTime = trNewTop.insertCell(-1);
        var tdBillRate = trNewTop.insertCell(-1);
        var tdSubTotal = trNewTop.insertCell(-1);
        
        var tdMemoEmpty = trNewBottom.insertCell(-1);
        var tdMemoLabel = trNewBottom.insertCell(-1);
        var tdMemo = trNewBottom.insertCell(-1);
       
        var lnkDelete = GetNewDelete();
        if (ExpenseID>0)
        { 
            var txtEntryType = GetNewCell(EntryType); // GetNewTextBox(EntryType);
        }
        else
        {
            EntryTypeID=EntryTypeID+"/"
            var cboEntryType = GetNewEntryType(EntryTypeID);
        }
        var txtExpenseDate =null;
        
        if (ExpenseID>0)
        { 
            txtExpenseDate= GetNewCell(ExpenseDate);
        }
        else
        {
            txtExpenseDate= GetNewDueDateControl(ExpenseDate);
         }

        var txtDescription = null;
        if (Description != null && Description.length > 0)
        {
            txtDescription = GetNewCell(Description) //GetNewDescription(Description);
        }
        else
        {
            txtDescription = GetNewDescription("");
        }
        
         var txtShowMemo = null;
         txtShowMemo = ShowMemo();
         
        if (ExpenseID>0)
        {
           var txtAttorney = GetNewCell(AttorneyName);  //GetNewCell(AttorneyName); //GetNewTextBox(AttorneyName);
         }
        else
        {
            var cboAttorney = GetNewAttorneyID(AttorneyID);
        }
        var txtBillTime=null,txtBillRate=null,txtTotal=null
        if (ExpenseID>0)
        {
            txtBillTime =GetNewCell(BillTime);// GetNewBillTime(BillTime);
            txtBillRate =GetNewCell(BillRate);// GetNewBillRate(BillRate);
            txtTotal = GetNewCell(SubTotal);//GetNewTotal(SubTotal);
        }
        else
        {
          txtBillTime = GetNewBillTime(BillTime);
          txtBillRate = GetNewBillRate(BillRate);
          txtTotal = GetNewTotal(SubTotal);
        }
        var txtMemo = null;
        
        if (ExpenseID>0)
        {
            txtMemo = GetNewCell(Memo);
        }
        else
        {
            txtMemo = GetNewMemo(Memo);
        }
        var txtMemoEmpty = GetNewDeleteEmpty(ExpenseID);

        // insert top row of fields
        tdDelete.insertAdjacentElement("afterBegin", lnkDelete);
        if (ExpenseID>0)
        {
            tdEntryType.insertAdjacentElement("afterBegin", txtEntryType);
        }
        else
        {
            tdEntryType.insertAdjacentElement("afterBegin", cboEntryType);
        }
        tdExpenseDate.insertAdjacentElement("afterBegin", txtExpenseDate);
        addHandlers(tdExpenseDate); 
        tdDescription.insertAdjacentElement("afterBegin", txtDescription);
        tdShowMemo.insertAdjacentElement("afterBegin", txtShowMemo);
        if (ExpenseID>0)
        {
            tdAttorneyID.insertAdjacentElement("afterBegin", txtAttorney);
        }
        else
        {
            tdAttorneyID.insertAdjacentElement("afterBegin", cboAttorney);
        }
        tdBillTime.insertAdjacentElement("afterBegin", txtBillTime);
        tdBillTime.align="right";
        tdBillRate.insertAdjacentElement("afterBegin", txtBillRate);
        tdBillRate.align="right";
        tdSubTotal.insertAdjacentElement("afterBegin", txtTotal);
        tdSubTotal.align="right";
        //cboEntryType_OnChange(cboEntryType);

        // insert bottom row of fields
        tdMemoEmpty.insertAdjacentElement("afterBegin", txtMemoEmpty);
        tdMemoEmpty.className = "listItem2";
        tdMemoLabel.className = "listItem2";
        tdMemoLabel.style.paddingTop = 0;
        tdMemoLabel.align = "right";
        tdMemo.valign = "top";
        tdMemoLabel.innerHTML = "Memo:";

        tdMemo.colSpan = 6;
        tdMemo.className = "listItem2";
        tdMemo.style.paddingTop = 0;
        tdMemo.insertAdjacentElement("afterBegin", txtMemo);
         
         
        if (ExpenseID>0)
        {
          //  txtEntryType.disabled=true;
          //  txtDescription.disabled=true;
           // txtAttorney.disabled=true;
           // txtBillTime.disabled=true;
           // txtBillRate.disabled=true;
           // txtTotal.disabled=true;
            //txtMemo.disabled=true;
        }

          trNewBottom.style.display="none";
    }
    
     function  toggledisplay(lnk)
    {
    
      if (!lnk.disabled)
        {
//            if (confirm("Are you sure, Do you want to delete the selected expense entry?"))
//            {
                var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");

                // delete bottom row then top
//                tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 2);
//                tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex + 1);
//                tblTaskPropagation.deleteRow(lnk.parentElement.parentElement.rowIndex);
//                
                 var txtDeleteEmpty = tblTaskPropagation.rows[lnk.parentElement.parentElement.rowIndex + 1]//.cells[0].childNodes[0];
               
               if(txtDeleteEmpty.style.display=="none")
               {
               txtDeleteEmpty.style.display="block"
               }
               else
               {
                txtDeleteEmpty.style.display="none"
               }
               
            //}
        }
    }
    
    function ShowMemo()
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/NegotiationLegendScrollS.png") %>";

        a.href = "#";
        a.onclick = function () {toggledisplay(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
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
    
    function calcTotal(obj)
    {
        var txtBillTime = obj.parentElement.parentElement.cells[6].childNodes[0];//5
        var txtBillRate = obj.parentElement.parentElement.cells[7].childNodes[0];//6
        var txtTotal = obj.parentElement.parentElement.cells[8].childNodes[0];//7
        
        if(txtBillTime.value!="" && txtBillRate.value!="")
        txtTotal.value =(txtBillRate.value * txtBillTime.value)  
    }
    
    function GetNewBillTime(Time)
    {
        var input = document.createElement("INPUT");

        input.type = "text";
        input.className = "entry";

        if (Time != null && Time.length > 0);
        {
            input.value = Time;
        }

        input.onkeypress = function () {AllowOnlyNumbers(input);};
        input.onkeyup = function () {calcTotal(input);};
        
        return input;
    }
    
    function GetNewBillRate(Rate)
    {
        var input = document.createElement("INPUT");

        input.type = "text";
        input.className = "entry";

        if (Rate != null && Rate.length > 0);
        {
            input.value = Rate;
        }

        input.onkeypress = function () {AllowOnlyNumbers(input);};
        input.onkeyup = function () {calcTotal(input);};
        
        return input;
    }
    
    function GetNewTotal(Total)
    {
        var input = document.createElement("INPUT");

        input.type = "text";
        input.className = "entry";

        if (Total != null && Total.length > 0);
        {
            input.value = Total;
        }

        input.disabled=true;

        return input;
    }
    
   
     
    function GetNewEntryType(TaskType)
    {
        var cboEntryType = document.getElementById("<%= cboEntryType.ClientID %>");

        var select = document.createElement("SELECT");

		select.onchange = function () {cboEntryType_OnChange(this)};

        select.className = "entry";

        for (i = 0; i < cboEntryType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboEntryType.options[i].innerText;
            option.value = cboEntryType.options[i].value;

            if (TaskType != null)
            {
                var TaskTypelist = TaskType.split("/");
                //&& TaskType == cboEntryType.options[i].value
                if (TaskTypelist[0]== cboEntryType.options[i].value)
                {
                    option.selected = true;
                 }
            }
        }

        return select;
    }
   
    
    function GetNewAttorneyID(AttorneyID)
    {
       
        var cboAttorney = document.getElementById("<%= cboAttorney.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < cboAttorney.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboAttorney.options[i].innerText;
            option.value = cboAttorney.options[i].value;

            if (AttorneyID != null && AttorneyID  == cboAttorney.options[i].value)
            {
                option.selected = true;
            }
        }
        
        return select;
        
    }
    
    //code to display the calender control
	var ctrllist=""
	var dtCtrlCnt=0
    function addHandlers(root){
        $('input').filter('.datepicker').datepicker({
        //changeMonth: true,
		//changeYear: true,
		
		showAnim: 'fadeIn', showOn: 'button', buttonImage: "<%= ResolveUrl("~/tasks/task/images/calendar.gif")%>", buttonImageOnly: true
        });
    } 
    
    $(document).ready(function() 
    {
        $("#<%=lnkAddPropagation.ClientID %>").click(AddPropagationClick);
        addHandlers($(document));
    }); 
    
    function GetNewDueDateControl(Date)
    {
        var input = document.createElement("INPUT");
        input.setAttribute("id","dt"+dtCtrlCnt);
        input.type = "text";
        input.setAttribute("style:font-size","7");
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
		//input.setAttribute("style:color","red");
		input.width="50px"
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
    //End of code to display the calender control
    
    
    function GetNewDeleteEmpty(ExpenseID)
    {
        var input = document.createElement("INPUT");

		input.onkeypress = function () {onlyDigits()};

        input.type = "text";
        input.className = "entry";
        input.style.display = "none";

        if (ExpenseID != null && ExpenseID.length > 0)
        {
            input.value = ExpenseID;
        }

        return input;
    }
    
   
 
    
    function GetNewCell(strtext)
    {
         var input = document.createElement("span");
        if (strtext != null && strtext.length > 0);
        {
            //input.value = strtext;
            input.innerHTML = strtext;
        }
        return input;
    }
    
    function GetNewTextBox(strtext)
    {
        var input = document.createElement("INPUT");

        input.type = "text";
        input.className = "entry";

        if (strtext != null && strtext.length > 0);
        {
            input.value = strtext;
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
    function GetNewMemo(Memo)
    {
        //var cboEntryType = document.getElementById("<%= cboEntryType.ClientID %>");

        //var select = document.createElement("TEXTAREA");
        
        //var input = document.createElement("TEXTAREA");
         var input = document.createElement("textarea");
        input.setAttribute("name","mytextarea");
        input.setAttribute("cols","90");
        input.setAttribute("rows","4");
        //input.setAttribute("wrap","PHYSICAL");
        //document.getElementById('test').appendChild(td5);


//        input.rows="4";
//        input.type = "text";
//        input.className = "entry";

        if (Memo != null && Memo.length > 0);
        {
            input.value = Memo;
        }

        return input;
    }
    function ResetPropagations()
    {
        var tblTaskPropagation = document.getElementById("<%= tblTaskPropagation.ClientID %>");
        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");

        txtPropagations.value = "";
        for (i = 1; i < tblTaskPropagation.rows.length; i += 2)
        {
            var cboEntryType = tblTaskPropagation.rows[i].cells[1].childNodes[0]; 
            var txtExpenseDate = tblTaskPropagation.rows[i].cells[2].childNodes[0];
            var txtDescription = tblTaskPropagation.rows[i].cells[3].childNodes[0];
            var cboAttorney = tblTaskPropagation.rows[i].cells[5].childNodes[0];//4
            var txtBillTime = tblTaskPropagation.rows[i].cells[6].childNodes[0];//5
            var txtBillRate = tblTaskPropagation.rows[i].cells[7].childNodes[0];//6
            var txtTotal = tblTaskPropagation.rows[i].cells[8].childNodes[0];//7
            
            var txtDeleteEmpty = tblTaskPropagation.rows[i + 1].cells[0].childNodes[0];
            var txtMemo = tblTaskPropagation.rows[i + 1].cells[2].childNodes[0];
            if(txtDeleteEmpty.value=="") {txtDeleteEmpty.value=0};

            if (txtDeleteEmpty.value==0)
            {
                if (txtPropagations.value.length > 0)
                {
                    txtPropagations.value += "|";
                }
                
                //txtPropagations.value += cboEntryType.options[cboEntryType.selectedIndex].value + "," + cboDueType.options[cboDueType.selectedIndex].value + "," + txtExpenseDate.value + "," + txtDue.value + "," + cboAttorney.options[cboAttorney.selectedIndex].value + "," + txtDescription.value;
                txtPropagations.value += cboEntryType.options[cboEntryType.selectedIndex].value + "," + "<%=MatterId%>" + "," + txtExpenseDate.value + "," + "0" + "," + cboAttorney.options[cboAttorney.selectedIndex].value + "," + txtDescription.value + "," + txtDeleteEmpty.value + "," + txtBillTime.value + "," + txtBillRate.value + "," + txtMemo.value + "," + txtTotal.value;
            }
        }
    }
    
    function cboDueType_OnChange(obj)
    {
        var txtExpenseDate = obj.parentElement.parentElement.cells[3].childNodes[0];
        var txtDue = obj.parentElement.parentElement.cells[3].childNodes[1];

        if (obj.options[obj.selectedIndex].value == "0") //0 - On Specific Date
        {
            txtExpenseDate.style.display = "inline";
            txtDue.style.display = "none";
        }
        else //1 - Days From Now
        {
            txtExpenseDate.style.display = "none";
            txtDue.style.display = "inline";
        }
    }
        
    function cboEntryType_OnChange(obj)
    {
        var txtMatterNumber = document.getElementById("<%= txtMatterNumber.ClientID %>");
        var trTop = obj.parentElement.parentElement;
        var trBottom = trTop.nextSibling;
        
        var txtDescription = trTop.cells[3].childNodes[0];
        var txtBillTime = trTop.cells[6].childNodes[0];
        var txtBillRate = trTop.cells[7].childNodes[0];
        var txtSubTotal = trTop.cells[8].childNodes[0];
        
        var EntryType = obj.options[obj.selectedIndex].value;
        var EntryTypeList = EntryType.split("/")
        var IsFlatRate = EntryTypeList[1];
        var Rate = EntryTypeList[2];
        
        if (obj.options[obj.selectedIndex].value != "0")
        {
            txtDescription.value = txtMatterNumber.value + " - " + obj.options[obj.selectedIndex].text;
        }

        if (IsFlatRate=="True")
        {
            txtBillTime.disabled=true;
            txtBillRate.disabled=true;
            txtBillRate.value=Rate;
            txtBillTime.value="1";
            txtSubTotal.value = Rate;
            txtBillTime.style.backgroundColor = "#d8d8d8";
            txtBillRate.style.backgroundColor = "#d8d8d8";
            txtSubTotal.disabled=false; 
        }
        else if (IsFlatRate=="False")
        {
            txtBillTime.disabled=false;
            txtBillRate.disabled=false;
            txtSubTotal.disabled=true;
            txtBillTime.value="";
            txtBillRate.value="";
            txtSubTotal.value="";
            txtBillTime.style.backgroundColor = "#ffffff";
            txtBillRate.style.backgroundColor = "#ffffff";
        }

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
	function SaveMatterExpenses()
	{
	    if (RequiredExist())
	    {  
	        ResetPropagations();
 
            var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
             //alert(txtPropagations.value)
             //alert(document.getElementById("<%=txtDeletedIDs.ClientID%>").value)
             //return
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            
            //window.top.dialogArguments.SavePropagations(txtPropagations.value);
            //window.close();
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
		if(mydate<PDate)
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
        for (i = 1; i < tblTaskPropagation.rows.length; i += 2)
        {
            var cboEntryType = tblTaskPropagation.rows[i].cells[1].childNodes[0];
            var txtExpenseDate = tblTaskPropagation.rows[i].cells[2].childNodes[0];
            var txtDescription = tblTaskPropagation.rows[i].cells[3].childNodes[0];
            var cboAttorney = tblTaskPropagation.rows[i].cells[5].childNodes[0];//4
            var txtBillTime = tblTaskPropagation.rows[i].cells[6].childNodes[0];//5
            var txtBillRate = tblTaskPropagation.rows[i].cells[7].childNodes[0];//6
            var txtTotal = tblTaskPropagation.rows[i].cells[8].childNodes[0];//7
            
            var txtDeleteEmpty = tblTaskPropagation.rows[i + 1].cells[0].childNodes[0];
            var txtMemo = tblTaskPropagation.rows[i + 1].cells[2].childNodes[0];
           
           
            if (txtDeleteEmpty.value=="")
            {
                if(cboEntryType.value=="0")
                {
                    ShowMessage("Entry Type is a required field");
                    AddBorder(cboEntryType);
                    return false;
                }
            
                // Expense Date must exist and must be valid
                if (txtExpenseDate.value.length == 0)
                {
                    ShowMessage("The Expense Date is a required field");
                    AddBorder(txtExpenseDate);
                    return false;
                }
                else if (!RegexValidate(txtExpenseDate.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
                {
                    ShowMessage("The Expense Date you entered for Expense Entry " + ((i + 1) / 2) + " is invalid.  Please select a valid date.");
                    AddBorder(txtExpenseDate);
                    return false;
                }
                
                else if (!ValidateDate(txtExpenseDate.value))
                {
                    ShowMessage("The Expense Date you entered for Expense Entry " + ((i + 1) / 2) + " is invalid.  Please select a valid date.");
                    AddBorder(txtExpenseDate);
                    return false;
                }

                else
                {
                    RemoveBorder(txtExpenseDate);
                }

                //Time in Hr is required field
                if (txtBillTime.value == "") // Ad Hoc
                {
                    ShowMessage("The Bill Time is a required field");
                    AddBorder(txtBillTime);
                    return false;
                }
                
                //Time in Min is required field
                if (txtBillRate.value == "") // Ad Hoc
                {
                    ShowMessage("The Bill Rate is a required field");
                    AddBorder(txtBillRate);
                    return false;
                }
                
                if (txtTotal.value == "" && txtTotal.disabled==false) // Ad Hoc
                {
                    ShowMessage("The Sub Total is a required field");
                    AddBorder(txtTotal);
                    return false;
                }
                
                if(cboAttorney.value=="0")
                {
                    ShowMessage("Attorney is a required field");
                    AddBorder(cboAttorney);
                    return false;
                }
                
                // Description might be required
                if (txtDescription.value.length == 0)
                {
                    //ShowMessage("The Description for Propagation " + ((i + 1) / 2) + " is required because you selected an Ad Hoc task type.");
                    ShowMessage("The Description is a required field");
                    AddBorder(txtDescription);
                    return false;
                }
                else
                {
                    RemoveBorder(txtDescription);
                }
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
	
            
              var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;
    
     function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
     function Record_DeleteConfirm()
    {
        LoadControls();
        

        if (!lnkDeleteConfirm.disabled)
        {
             var url = '<%= ResolveUrl("~/delete.aspx?t=Matter Expense Entry&p=selection of Matter Expense Entry") %>';
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Matter Expense Entry",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 350, width: 400});   
        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function GetPropagations()
    {
        return document.getElementById("<%= txtPropagations.ClientID %>").value;
    }
    
    function AddExpenseEntry()
    {
    
    }
    
    function AddExpense() 
    {
         var url = '<%= ResolveUrl("~/clients/client/creditors/matters/addmatterexpense.aspx") %>?t=Add Matter Expense Entry&a=m&mid=<%=MatterId%>&aid=<%=AccountID %>&id=<%=ClientId%>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Matter Expense Entry",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: true,
                   height: 650, width: 700,
                   onClose: function(){
                        attachWin = $(this).modaldialog("returnValue");
                        if (attachWin != -1 && attachWin!=undefined){
                            window.location=window.location.href;
                        }
                     }
                   });  
        }
        
        function EditExpense(meid) {
             var url = '<%= ResolveUrl("~/clients/client/creditors/matters/addmatterexpense.aspx") %>?mid=<%=MatterId %>&aid=<%=AccountID %>&id=<%=ClientID %>&meid='+meid;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Edit Matter Expense Entry",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 650, width: 700,
                       onClose: function(){
                                    attachWin = $(this).modaldialog("returnValue");
                                }
                       });  
        }
        
        function Record_CancelAndClose()
        {
            // postback to cancel and close
            <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
        }
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

	    for (c = 1; c < table.rows.length-1; c++)
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

	    for (u = 1; u < table.rows.length-1; u++)
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
        LoadControls();

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
    function LoadControls()
    {
        if (lnkDeleteConfirm == null)
        {
            lnkDeleteConfirm = document.getElementById("<%= lnkDeleteConfirm.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= txtSelectedAccounts.ClientID %>");
        }
    }
            </script>

            <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;"
                border="0" cellpadding="15">
                <tr>
                    <td style="height: 100%;" valign="top">
                        <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%" border="0"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="color: #666666; height: 25px">
                                    <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a
                                        id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a
                                            id="lnkCommunications" runat="server" class="lnk" style="color: #666666;">Matter
                                            Instance</a>&nbsp;>&nbsp;<asp:Label ID="lblMatterExpense" runat="server" Style="color: #666666;"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img id="Img5" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                </td>
            </tr>
                            <tr>
                                <td style="font-size: 11px; color: #666666;" width="78%" valign="top">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                        cellspacing="0">
                                        <tr>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="cLEnrollHeader">
                                                Client Information
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                                    cellspacing="0" class="box">
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true" width="15%" align="right">
                                                            Client Name:
                                                        </td>
                                                        <td width="20%">
                                                            <asp:TextBox ID="lblClient" CssClass="entry2" Width="200px" runat="server" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                        <td class="entrytitlecell" nowrap="true" width="10%" align="right">
                                                            Firm:
                                                        </td>
                                                        <td width="20%">
                                                            <asp:TextBox ID="lblFirm" CssClass="entry2" Width="200px" runat="server" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                        <td class="entrytitlecell" nowrap="true" width="10%" align="right">
                                                            ClientID:
                                                        </td>
                                                        <td width="25%">
                                                            <asp:TextBox ID="lblClientID" CssClass="entry2" Width="100px" runat="server" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="cLEnrollHeader">
                                                Matter Information
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                                    cellspacing="0" class="box">
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true" width="15%" align="right">
                                                            Matter Date:
                                                        </td>
                                                        <td width="20%">
                                                            <asp:TextBox ID="txtMatterDate" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                       <div style="display:none">         <cc1:InputMask validate="IsValidDateTime(Input.value);" 
                                                           ID="InputMask1" runat="server" Mask="nn/nn/nnnn"></cc1:InputMask></div> 
                                                        </td>
                                                        <td class="entrytitlecell" nowrap="true" width="20%" align="right">
                                                            Account Number:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtAccountNumber" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" nowrap="true" align="right">
                                                            Matter Number:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtMatterNumber" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                        </td>
                                                        <td class="entrytitlecell" align="right">
                                                            Local Counsel:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtLocalCounsel" Width="200px" runat="server" ReadOnly="true" CssClass="entry"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="background-color: rgb(244,242,232);">
                                                <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                                                    border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <img id="Img4" runat="server" src="~/images/grid_top_left.png" border="0" />
                                                        </td>
                                                        <td style="width: 100%;">
                                                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                                border="0">
                                                                <tr>
                                                                    <td nowrap="true">
                                                                        <asp:DropDownList AutoPostBack="true" Visible="false" Style="font-size: 11px; font-family: tahoma;"
                                                                            runat="server" ID="ddlType">
                                                                            <asp:ListItem Value="0" Text="Summary"></asp:ListItem>
                                                                            <asp:ListItem Value="1" Text="Detail"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td nowrap="true">
                                                                        <asp:CheckBox AutoPostBack="true" Visible="false" runat="server" ID="chkHideRemoved"
                                                                            Text="Hide Removed"></asp:CheckBox>
                                                                    </td>
                                                                    <td nowrap="true">
                                                                        <asp:CheckBox AutoPostBack="true" Visible="false" runat="server" ID="chkHideSettled"
                                                                            Text="Hide Settled"></asp:CheckBox>
                                                                    </td>
                                                                    <td nowrap="true" style="width: 100%;">
                                                                        <a runat="server" id="lnkAddPropagation" style="color: black;" href="javascript:AddExpenseEntry();" class="lnk">
                                                                            <img id="Img6" border="0" align="absmiddle" src="~/images/16x16_calendar_add.png"
                                                                                runat="server" style="margin-right: 5;" />Add Line</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="#" onclick="ClearPropagations(this);return false" id="lnkClearPropagations" class="lnk" style="color: rgb(0,0,159);">Clear All</a>
                                                                    </td>
                                                                    <td runat="server" id="tdDelete" align="right">
                                                                        <a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="javascript:Record_DeleteConfirm();">
                                                                            Delete</a>
                                                                    </td>
                                                                    <td nowrap="true">
                                                                        <img id="Img1" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                                    </td>
                                                                    <td nowrap="true">
                                                                        <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                                                            <img id="Img10" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                                src="~/images/icons/xls.png" /></asp:LinkButton>
                                                                    </td>
                                                                    <td nowrap="true">
                                                                        <a id="A1" runat="server" class="gridButton" href="javascript:window.print()">
                                                                            <img id="Img11" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                                src="~/images/16x16_print.png" /></a>
                                                                    </td>
                                                                    <td nowrap="true" style="width: 10;">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <table id="tblTaskPropagation" runat="server" style="margin-bottom:10;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                                <tr>
                                                    <td class="headItem2" width="16">&nbsp;</td>
                                                    <td class="headItem2" width="150">Entry Type</td>
                                                    <td class="headItem2">Expense&nbsp;Date</td>
                                                    <td class="headItem2" width="300" >Description</td>
                                                    <td class="headItem2" width="16">&nbsp;</td>
                                                    <td class="headItem2" width="100">Attorney</td>
                                                    <td class="headItem2" align="right" width="50">Billable Time<br />(in Hrs)</td>
                                                    <td class="headItem2" align="right" width="50">Billable Rate<br />(in $)</td>
                                                    <td class="headItem2" align="right" width="50">Sub Total<br />(in $)</td>
                                                    
                                                </tr>
                                            </table>
                                            <table id="Table1" runat="server" style="margin-bottom:10;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                                <tr>
                                                    <td colspan="6">&nbsp;</td>
                                                    <td align="left"><b><b>Total (in $)</b></b></td>
                                                    <td align="right"><asp:Label ID="lblExpenseTotal" runat="server" /></td>
                                                </tr>
                                                </table>
                                                <table class="list" onselectstart="return false;" style="font-size: 11px; font-family: tahoma; display:none"
                                                    cellspacing="0" cellpadding="3" width="100%" border="0">
                                                    <colgroup>
                                                        <col align="center" style="width: 20;" />
                                                        <col align="left" style="width: 22;" />
                                                        <col align="left" style="width: 17;" />
                                                        <col align="left" />
                                                        <col align="right" />
                                                        <col align="right" />
                                                        <col align="right" />
                                                        <col align="center" id="colColor" runat="server" />
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th width="5%">
                                                                <img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);"
                                                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                                                    border="0" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);"
                                                                        style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                                                        border="0" />
                                                            </th>
                                                            <th width="20%">
                                                                Entry Type
                                                            </th>
                                                            <th width="12%">
                                                                Expense Date
                                                            </th>
                                                            <th width="23%">
                                                                Description
                                                            </th>
                                                            <th width="12%" align="left">
                                                                Attorney
                                                            </th>
                                                            <th width="8%">
                                                                Bill Rate<br />
                                                                (in $)
                                                            </th>
                                                            <th width="10%">
                                                                Billable Time<br />
                                                                (in hrs)
                                                            </th>
                                                            <th width="10%" align="right">
                                                                Sub Total
                                                                <br />
                                                                (in $)
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <asp:Repeater ID="rpMatterExpenses" runat="server">
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td style="padding-top: 7; width: 5%;" valign="top" align="center" onmouseover="RowHover(this, true);"
                                                                        onmouseout="RowHover(this, false);" class="listItem">
                                                                        <img id="Img2" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                                            runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                                                id="Img3" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                                                style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                                                align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#DataBinder.Eval(Container.DataItem, "MatterTimeExpenseId")%>);"
                                                                                    style="display: none;" type="checkbox" />
                                                                    </td>
                                                                    <a href="#" onclick="javascript:return EditExpense(<%#DataBinder.Eval(Container.DataItem, "MatterTimeExpenseId")%>)">
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "DisplayName")%>&nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "TimeExpenseDatetime", "{0:MM/dd/yyyy}")%>&nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "TimeExpenseDescription")%>&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <%#DataBinder.Eval(Container.DataItem, "AttorneyName")%>&nbsp;
                                                                        </td>
                                                                        <td align="right">
                                                                            <%#DataBinder.Eval(Container.DataItem, "BillRate")%>&nbsp;
                                                                        </td>
                                                                        <td align="right">
                                                                            <%#DataBinder.Eval(Container.DataItem, "BillableTime")%>&nbsp;
                                                                        </td>
                                                                        <td align="right">
                                                                            <input type="hidden" value='<%#DataBinder.Eval(Container.DataItem, "SubTotal")%>'
                                                                                runat="server" id="hdnST" />
                                                                            <%#DataBinder.Eval(Container.DataItem, "SubTotal")%>&nbsp;
                                                                        </td>
                                                                    </a>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                <td colspan="6">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                    <b>Total (in $)</b>
                                                                </td>
                                                                <td align="right">
                                                                    <asp:Label ID="lblTotal" runat="server"></asp:Label>
                                                                </td>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </tbody>
                                                </table>
                                                <input type="hidden" runat="server" id="txtSelectedAccounts" /><input type="hidden"
                                                    runat="server" id="txtSelectedControlsClientIDs" />
                                                <asp:Panel runat="server" ID="pnlNoAccounts" Style="text-align: center; padding: 10 5 5 5;">
                                                    This matter has no expenses</asp:Panel>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 100%">
                                    <asp:LinkButton ID="lnkReload" runat="server"></asp:LinkButton>
                                    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
            <asp:HiddenField runat="server" ID="txtPropagations" />
            <asp:HiddenField runat="server" ID="txtDeletedIDs" />
            <asp:DropDownList runat="server" ID="cboEntryType" Style="display: none;"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="cboAttorney" Style="display: none;"></asp:DropDownList>
            <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
            
    </asp:PlaceHolder>
</asp:Content>
