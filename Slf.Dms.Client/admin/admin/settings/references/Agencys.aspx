<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="Agencys.aspx.vb" Inherits="admin_settings_references_Agencys" Title="Agencys" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"   >
    </ajaxToolkit:ToolkitScriptManager>
    <style type="text/css">
       .ddlExtender 
        {
	        font-family:tahoma;
	        font-size:11px;
	        border: 1px solid #868686;
	        z-index: 1000;
	        cursor: default;
	        padding: 1px 1px 0px 1px;
        }

        .labelddlExtender
        {
            width:100%;
            height:20px; 
            padding:2px; 
            padding-right: 50px; 
            border: solid 1px rgb(51,118,171);
            font-family:tahoma;
            font-size:11px;
        }
    </style>
    <script src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>" type="text/javascript"></script>

    <script src="<%= ResolveUrl("~/jscript/validation/Display.js") %>" type="text/javascript"></script>

    <script src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>" type="text/javascript"></script>
    
    <script src="<%= ResolveUrl("~/jscript/domain.js") %>" type="text/javascript"></script>

    <script type="text/javascript">
    var cancelCommRecChange; 
    
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById('<%=dvError.ClientID %>');
	    var tdError = document.getElementById('<%=tdError.ClientID %>');

	    dvError.style.display = 'inline';
	    tdError.innerHTML = Value;
	}
	
	function HideMessage()
	{
	    var dvError = document.getElementById('<%=dvError.ClientID %>');
	    var tdError = document.getElementById('<%=tdError.ClientID %>');

	    tdError.innerHTML = '';
	    dvError.style.display = 'none';
	}
	
	function SaveAgencyOnServer()
	{
	    <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
	}
	
	function Save()
    {
        if (ValidateFields() == 0)
        {           
            var AgencyId = document.getElementById("<%= hdnAgencyId.ClientID %>").value;
            /*if (AgencyId == -1)
                ValidateDuplicateUser();
            else*/
            if ((AgencyId != -1) && HasAgencies()) 
                ValidateCircularRef(AgencyId);
            else
                SaveAgencyOnServer();
        }
        else
        {
            ShowMessage('Please enter required fields.');
        }
    }
    
    function HasAgencies()
    {
        var tblOwnedAgencies = document.getElementById("<%= tblChildAgency.ClientID %>");
        var hdnFlag;
        
        for (i = 1; i < tblOwnedAgencies.rows.length; i++)
        {
            hdnFlag = tblOwnedAgencies.rows[i].cells[2].childNodes[1];
            if (hdnFlag.value != 'Y') return true;
        }
        return false;
    }
    
    function ValidateFields()
    {
        var txtFirmName = document.getElementById("<%= txtFirmName.ClientID() %>");
        var txtShortName = document.getElementById("<%= txtShortName.ClientID() %>");
        var count = 0;
       
        RemoveBorder(txtFirmName);       
        RemoveBorder(txtShortName);
        
        if (txtFirmName.value.length == 0) 
        {
	        AddBorder(txtFirmName);
            count++;
        }
        
        if (txtShortName.value.length == 0) 
        {
	        AddBorder(txtShortName);
            count++;
        } 
        
        /*var AgencyId = document.getElementById("<%= hdnAgencyId.ClientID %>");
        var txtUserName = document.getElementById("<%= txtUserName.ClientID %>");
        if ((AgencyId.value < 0) && (txtUserName.value.length == 0))
        {
            AddBorder(txtUserName);
            count++;
        }*/
        
        // sections with required fields
        count+=ResetAddresses();
        count+=ResetPhones();
        count+=ResetBankInfo();
        count+=ResetAgents();
        ResetOwnedAgencies()
       
        
        return count;
    }
    
    function ResetAddresses()
    {
        var tblAddresses = document.getElementById("<%= tblAddresses.ClientID %>");
        var txtAddresses = document.getElementById("<%= txtAddresses.ClientID %>");
        var count = 0;
        
        txtAddresses.value = "";

        for (i = 1; i < tblAddresses.rows.length; i++)
        {
            var hdnFlag = tblAddresses.rows[i].cells[6].childNodes[1];
            if  (hdnFlag.value != 'Y')
            {
                //Address is optional, but if an address is entered then some fields become mandatory 
                var txtAddress1 = tblAddresses.rows[i].cells[1].childNodes[0];
                var txtAddress2 = tblAddresses.rows[i].cells[2].childNodes[0];
                var txtCity = tblAddresses.rows[i].cells[3].childNodes[0];
                var cboState = tblAddresses.rows[i].cells[4].childNodes[0];
                var txtZip = tblAddresses.rows[i].cells[5].childNodes[0];
                
                // reset
                RemoveBorder(txtAddress1);
                RemoveBorder(txtCity);
                RemoveBorder(cboState);
                RemoveBorder(txtZip);

                if (txtAddress1.value != null && txtAddress1.value.length > 0 && txtCity.value != null && txtCity.value.length > 0 && cboState.selectedIndex != 0 && txtZip.value != null && txtZip.value.length > 0)
                {
                    if (txtAddresses.value.length > 0)
                    {
                        txtAddresses.value += "|" + txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," +txtZip.value;
                    }
                    else
                    {
                        txtAddresses.value = txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," +txtZip.value;
                    }
                }
                 else
                {
                    if (txtAddress1.value.length == 0)
                    {
                        AddBorder(txtAddress1);
                        count++;
                    }
                    if (txtCity.value.length == 0)
                    {
                        AddBorder(txtCity);
                        count++;
                    }
                    if (cboState.selectedIndex <= 0)
                    {
                        AddBorder(cboState);
                        count++;
                    }
                    if (txtZip.value.length == 0)
                    {
                        AddBorder(txtZip);
                        count++;
                    }
                }
            } 
        }
        
        return count;
    }     
    
    function ResetPhones()
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");
        var txtPhones = document.getElementById("<%= txtPhones.ClientID %>");
        var count = 0;

        txtPhones.value = "";

        for (i = 1; i < tblPhones.rows.length; i++)
        {
            var hdnFlag = tblPhones.rows[i].cells[3].childNodes[1];
            if  (hdnFlag.value != 'Y')
                {
                var cboPhoneType = tblPhones.rows[i].cells[1].childNodes[0];
                var txtPhoneNumber = tblPhones.rows[i].cells[2].childNodes[0];
                 
                RemoveBorder(txtPhoneNumber);

                if (txtPhoneNumber.value != null && txtPhoneNumber.value.length > 0)
                {
                    if (txtPhones.value.length > 0)
                    {
                        txtPhones.value += "|" + cboPhoneType.options[cboPhoneType.selectedIndex].value + "," + txtPhoneNumber.value;
                    }
                    else
                    {
                        txtPhones.value = cboPhoneType.options[cboPhoneType.selectedIndex].value + "," + txtPhoneNumber.value;
                    }
                }
                else 
                {
                    if (txtPhoneNumber.value.length == 0)
                    {
                        AddBorder(txtPhoneNumber);
                        count++;
                    }
                }
            }
        }
        
        return count;
    }
    
    function ResetBankInfo()
    {
        var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
        var hdnBankInfo = document.getElementById("<%= hdnBankInfo.ClientID %>");
        var count = 0;
        
        hdnBankInfo.value = "";
        
        for (i = 2; i < tblBanks.rows.length; i=i+2)
        {
            var txtBankName = tblBanks.rows[i].cells[1].childNodes[0];
            var txtAddress1 = tblBanks.rows[i].cells[2].childNodes[0];
            var hdnAddressID = tblBanks.rows[i].cells[2].childNodes[1];
            var txtAddress2 = tblBanks.rows[i].cells[3].childNodes[0];
            var txtCity = tblBanks.rows[i].cells[4].childNodes[0];
            var cboState = tblBanks.rows[i].cells[5].childNodes[0];
            var txtZip = tblBanks.rows[i].cells[6].childNodes[0];
            var txtPhone = tblBanks.rows[i].cells[7].childNodes[0];
            // line 2
            var hdnFlag = tblBanks.rows[i+1].cells[0].childNodes[0];
            var hdnPhoneID = tblBanks.rows[i+1].cells[0].childNodes[1];
            var txtDisplay = tblBanks.rows[i+1].cells[1].childNodes[0];
            var txtContact = tblBanks.rows[i+1].cells[2].childNodes[0];
            var txtRouting = tblBanks.rows[i+1].cells[3].childNodes[0];
            var txtAccount = tblBanks.rows[i+1].cells[4].childNodes[0];
            var chkChecking = tblBanks.rows[i+1].cells[5].childNodes[0];
            var chkACH = tblBanks.rows[i+1].cells[6].childNodes[0];
            var txtAbbreviation = tblBanks.rows[i+1].cells[7].childNodes[0];
            var hdnID = tblBanks.rows[i+1].cells[7].childNodes[1];
            
            // reset
            RemoveBorder(txtBankName);
            RemoveBorder(txtRouting);
            RemoveBorder(txtAccount);
            RemoveBorder(txtDisplay);
            RemoveBorder(txtAbbreviation);
            
            
            if (txtBankName.value != null && txtBankName.value.length > 0 && txtRouting.value != null && txtRouting.value.length > 0 && txtAccount.value != null && txtAccount.value.length > 0 && txtDisplay.value != null && txtDisplay.value.length > 0 && txtAbbreviation.value != null && txtAbbreviation.value.length > 0)
            {
                if (hdnBankInfo.value.length > 0)
                {
                    hdnBankInfo.value += "|";
                }
                
                hdnBankInfo.value += txtBankName.value + "," + txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," + txtZip.value + "," + txtPhone.value + "," +  txtAbbreviation.value + "," + txtContact.value + "," + txtRouting.value + "," + txtAccount.value + "," + chkChecking.checked + "," + chkACH.checked + "," + hdnID.value + "," + hdnFlag.value + "," + hdnAddressID.value + "," + hdnPhoneID.value + "," + txtDisplay.value;
            }
            else if (hdnFlag.value != 'Y')
            {
                if (txtBankName.value.length == 0)
                {
                    AddBorder(txtBankName);
                    count++;
                }
                if (txtRouting.value.length == 0)
                {
                    AddBorder(txtRouting);
                    count++;
                }
                if (txtAccount.value.length == 0)
                {
                    AddBorder(txtAccount);
                    count++;
                }
                if (txtDisplay.value.length == 0)
                {
                    AddBorder(txtDisplay);
                    count++;
                }
                if (txtAbbreviation.value.length == 0)
                {
                    AddBorder(txtAbbreviation);
                    count++;
                }
            }
    }
        
        return count;
    }
    
    function ResetAgents()
    {
        var tbl = document.getElementById("<%= tblAgent.ClientID %>");
        var hdnAgents = document.getElementById("<%= hdnAgents.ClientID %>");
        var count = 0;
        
        hdnAgents.value = "";
        
        for (i = 1; i < tbl.rows.length; i++)
        {
            var txtFirst = tbl.rows[i].cells[1].childNodes[0];
            var txtLast = tbl.rows[i].cells[2].childNodes[0];
            var hdnID = tbl.rows[i].cells[3].childNodes[0];
            var hdnFlag = tbl.rows[i].cells[3].childNodes[1];
            
             // reset
            RemoveBorder(txtFirst);
            RemoveBorder(txtLast);
            
            if (txtLast.value != null && txtLast.value.length > 0 && txtFirst.value != null && txtFirst.value.length > 0)
            {
                if (hdnAgents.value.length > 0)
                {
                    hdnAgents.value += "|";
                }
                
                hdnAgents.value += hdnID.value + "," + hdnFlag.value + "," + txtFirst.value + "," + txtLast.value + ",";
            }
            else if (hdnFlag.value != 'Y')
            {
                 if (txtFirst.value.length == 0)
                {
                    AddBorder(txtFirst);
                    count++;
                }
                if (txtLast.value.length == 0)
                {
                    AddBorder(txtLast);
                    count++;
                }
            }
        }
        return count;
    }
    
    function ResetOwnedAgencies()
    {
        var tblOwnedAgencies = document.getElementById("<%= tblChildAgency.ClientID %>");
        var hdnAgencies = document.getElementById("<%= txtOwnedAgencys.ClientID %>");
        
        hdnAgencies.value = "";
        for (i = 1; i < tblOwnedAgencies.rows.length; i++)
        {
            var cboAgency = tblOwnedAgencies.rows[i].cells[1].childNodes[0];
            var hdnFlag = tblOwnedAgencies.rows[i].cells[2].childNodes[1];
            
            if (hdnFlag.value != 'Y')
            {
                if (hdnAgencies.value.length > 0)
                {
                    hdnAgencies.value += "|";
                }
                hdnAgencies.value += cboAgency.options[cboAgency.selectedIndex].value;
            }
        }
    }
    
    function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx") %>?f=Record_Delete&t=Delete Agency&m=Are you sure you want to delete this agency?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Agency",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 300, scrollable: false});  

	}
    
    function Record_Delete()
    {
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    
    function Cancel()
    {
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    
    //General functions
   function GetNada()
   {
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_empty.png") %>";

        return img;
   }  

    /*
        Agency Address functions    
    */
    
    function Record_AddAddress()
    {
        var tblAddresses = document.getElementById("<%= tblAddresses.ClientID %>");
        var trNew = tblAddresses.insertRow(-1);
        
        var tdDelete = trNew.insertCell(-1);
        var tdAddress = trNew.insertCell(-1);
        var tdAddress2 = trNew.insertCell(-1);
        var tdCity = trNew.insertCell(-1);
        var tdState = trNew.insertCell(-1);
        var tdZip = trNew.insertCell(-1);  
        var tdHdn = trNew.insertCell(-1);
           
        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeleteAddress(tblAddresses.rows.length - 1));
        
        tdAddress.className = "listItem2";
        tdAddress.insertAdjacentElement("afterBegin", GetNewAddress());
       
        tdAddress2.className = "listItem2";
        tdAddress2.insertAdjacentElement("afterBegin", GetNewAddress2());
       
        tdCity.className = "listItem2";
        tdCity.insertAdjacentElement("afterBegin", GetNewCity());
       
        tdState.className = "listItem2";
        tdState.insertAdjacentElement("afterBegin", GetNewStateType()); 
       
        tdZip.className = "listItem2";
        tdZip.insertAdjacentElement("afterBegin", GetNewZip());   
        
        tdHdn.className = "listItem2";
        tdHdn.innerHTML = "<input type='hidden' value='-1'><input type='hidden' value='N'>&nbsp;"; //AddressID, DeleteFlag
    }
    
    function Record_DeleteAddress(obj)
    {
        var tbl = document.getElementById("<%= tblAddresses.ClientID %>");
        var index = obj.parentElement.parentElement.rowIndex
        
        if (tbl.rows[index].cells[6].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tbl.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tbl.rows[index].style.display = 'none';
            tbl.rows[index].cells[6].childNodes[1].value = 'Y';
        } 
    }    
    
    function GetNewDeleteAddress(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteAddress(this);return false;};
        a.insertAdjacentElement("afterBegin", img);

        return a;
    }     
    
    function GetNewAddress()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
   function GetNewAddress2()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewCity()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewZip()
    {
      var input = document.createElement("INPUT");

        //create an input mask for the zip code
        input.type = "text"
        input.style.width = "75";
        input.className = "entry";
		input.mask = "nnnnn-nnnn";
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

        return input;
    }
   
    function GetNewStateType()
    {
        var ddlStates = document.getElementById("<%= ddlStates.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < ddlStates.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = ddlStates.options[i].innerText;
            option.value = ddlStates.options[i].value;
        }

        return select;
    }  
   
    /*
        Agency Phone Information
    */
    
    function Record_AddPhone()
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");
        var trNew = tblPhones.insertRow(-1);

        var tdDelete = trNew.insertCell(-1);
        var tdPhoneType = trNew.insertCell(-1);
        var tdPhoneNumber = trNew.insertCell(-1);
        var tdHdn = trNew.insertCell(-1);

        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeletePhone(tblPhones.rows.length - 1));

        tdPhoneType.className = "listItem2";
        tdPhoneType.insertAdjacentElement("afterBegin", GetNewPhoneType());

        tdPhoneNumber.className = "listItem2";
        tdPhoneNumber.insertAdjacentElement("afterBegin", GetNewPhoneNumber());
        
        tdHdn.className = "listItem2";
        tdHdn.innerHTML = "<input type='hidden' value='-1'><input type='hidden' value='N'>&nbsp;"; //PhoneID, DeleteFlag
    }
    
    function Record_DeletePhone(obj)
    {
        var tbl = document.getElementById("<%= tblPhones.ClientID %>");       
        var index = obj.parentElement.parentElement.rowIndex
        
        if (tbl.rows[index].cells[3].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tbl.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tbl.rows[index].style.display = 'none';
            tbl.rows[index].cells[3].childNodes[1].value = 'Y';
        } 
    }
    
    function GetNewDeletePhone(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeletePhone(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
    }
    
    function GetNewPhoneType()
    {
        var cboPhoneType = document.getElementById("<%= ddlPhoneTypes.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < cboPhoneType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboPhoneType.options[i].innerText;
            option.value = cboPhoneType.options[i].value;
        }

        return select;
    }
    
    function GetNewPhoneNumber()
    {
        var input = document.createElement("INPUT");
        input.type = "text"
        input.style.width = "85";
        input.className = "entry";
		input.mask = "(nnn) nnn-nnnn";
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

        return input;
    }

   /*
        Bank Account Functions
   */
   
   function Record_AddBanks()
   {
       var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
       var trNew = tblBanks.insertRow(-1);
        
       var tdBankDelete = trNew.insertCell(-1);
       var tdBankName = trNew.insertCell(-1);
       var tdBankAddress = trNew.insertCell(-1);
       var tdBankAddress2 = trNew.insertCell(-1);
       var tdBankCity = trNew.insertCell(-1);
       var tdBankState = trNew.insertCell(-1);
       var tdBankZip = trNew.insertCell(-1);
       var tdBankPhone = trNew.insertCell(-1);

       trNew = tblBanks.insertRow(-1);
        
       var tdFlag = trNew.insertCell(-1); 
       var tdDisplay = trNew.insertCell(-1);
       
       var tdContact = trNew.insertCell(-1);
       var tdRoutingNumber = trNew.insertCell(-1);
       var tdAccountNumber = trNew.insertCell(-1);
       var tdBankChecking = trNew.insertCell(-1);
       var tdBankACH = trNew.insertCell(-1);  
       var tdAbbreviation = trNew.insertCell(-1);

       tdBankDelete.insertAdjacentElement("afterBegin", GetNewDeleteBank(tblBanks.rows.length - 1));
       tdBankName.insertAdjacentElement("afterBegin", GetNewBName());
       tdBankAddress.innerHTML = "<input type='text' class='entry'><input type='hidden' value='-1'>";
       tdBankAddress2.insertAdjacentElement("afterBegin", GetNewBAddress2());
       tdBankCity.insertAdjacentElement("afterBegin", GetNewBCity());
       tdBankState.insertAdjacentElement("afterBegin", GetNewStateType()); 
       tdBankZip.insertAdjacentElement("afterBegin", GetNewBZip()); 
       tdBankPhone.insertAdjacentElement("afterBegin", GetNewBPhone());
       
       // line 2
   
       tdFlag.className = "listItem2"
       tdFlag.innerHTML = "<input type='hidden' value='N'><input type='hidden' value='-1'>"; // Delete Flag and CommRecPhoneID
       
       tdDisplay.className = "listItem2";
       tdDisplay.insertAdjacentElement("afterBegin", GetNewBDisplay());
       
       tdContact.className = "listItem2";
       tdContact.insertAdjacentElement("afterBegin", GetNewBContact());
       
       tdRoutingNumber.className = "listItem2";
       tdRoutingNumber.insertAdjacentElement("afterBegin", GetNewBRoutingNo());
       
       tdAccountNumber.className = "listItem2";
       tdAccountNumber.insertAdjacentElement("afterBegin", GetNewBAccountNo());
       
       tdBankChecking.className = "listItem2"; 
       tdBankChecking.insertAdjacentElement("afterBegin", GetNewCheckBox());
       
       tdBankACH.className = "listItem2"; 
       tdBankACH.insertAdjacentElement("afterBegin", GetNewCheckBox());
       
       tdAbbreviation.className = "listItem2";
       tdAbbreviation.innerHTML = "<input type='text' class='entry'/><input type='hidden' value='-1'>";

    } 
   
   function GetNewCheckBox()
   {
        var input = document.createElement("<input type='checkbox' class='entry' checked>");      
        return input; 
   } 
   
   function GetNewBACH()
   {
        var input = document.createElement("INPUT");

        input.type = "Checkbox";
        input.className = "entry";
        input.name = "checking"; 
        		
        return input; 
   } 

   function Record_DeleteBank(obj)
    {
        var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
        var index = obj.parentElement.parentElement.rowIndex;
        
        // note: bank information spans 2 rows
        if (tblBanks.rows[index+1].cells[7].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tblBanks.deleteRow(index);
            tblBanks.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tblBanks.rows[index].style.display = 'none';
            tblBanks.rows[index+1].style.display = 'none';
            tblBanks.rows[index+1].cells[0].childNodes[0].value = 'Y';
        }
    }
    
    function GetNewDeleteBank(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteBank(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
    }
      
   function GetNewBName()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
   function GetNewBContact()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
   function GetNewBAddress2()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewBCity()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewBZip()
    {
      var input = document.createElement("INPUT");

        //create an input mask for the zip code
        input.type = "text"
        input.className = "entry";
        input.mask = "nnnnn-nnnn";
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

        return input;
    }   
   
   function GetNewBPhone()
    {
        var input = document.createElement("INPUT");

        // dynamically create an input mask
        input.type = "text"
        input.style.width = "85";
        input.className = "entry";
        input.mask = "(nnn) nnn-nnnn";
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

        return input;
    }   
       

    function GetNewBAbbreviation()
    {
   
        var input = document.createElement("INPUT");
        input.type = "text"
        input.className = "entry";
        
        return input; 
    }
   
   function GetNewBDisplay()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
    
   function GetNewBRoutingNo()
    {
      var input = document.createElement("INPUT");

        //create an input mask for the zip code
        input.type = "text"
        input.className = "entry";
        input.mask = "nnnnnnnnn";
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

        return input;
    } 
   
       function GetNewBAccountNo()
       {
            var input = document.createElement("INPUT");

            input.type = "text"
            input.className = "entry";
    		
            return input; 
       }
       
       function GetNewBUploadPath()
       {
            var input = document.createElement("INPUT");

            input.type = "text"
            input.className = "entry";
    		
            return input; 
       }  
       
        function GetNewBLogin()
       {
            var input = document.createElement("INPUT");

            input.type = "text"
            input.className = "entry";
    		
            return input; 
       } 
       
       function GetNewBPassword()
       {
            var input = document.createElement("INPUT");

            input.type = "text"
            input.className = "entry";
    		
            return input; 
       }
   
   //   Agents
   
   function Record_AddAgents()
   {
        var url = '<%= ResolveUrl("~/util/pop/addagencyagent.aspx") %>';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Add Agency Agent",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 300, scrollable: false}); 
   }

    function Record_AddAgentsBack(agentid, firstName, lastName)
    {
        var tbl = document.getElementById("<%= tblAgent.ClientID %>");
        var tr = tbl.insertRow(-1);
        
        var tdDelete = tr.insertCell(-1);
        var tdFirstName = tr.insertCell(-1);
        var tdLastName = tr.insertCell(-1);
        var tdHdn = tr.insertCell(-1);
               
        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeleteAgent(tbl.rows.length - 1));
        
        var txtFirstName = GetNewEAFirstName();
        if (firstName && agentid != -1) txtFirstName.value = firstName; 
        tdFirstName.className = "listItem2";
        tdFirstName.insertAdjacentElement("afterBegin", txtFirstName);
        
        var txtLastName = GetNewEALastName();
        if (lastName && agentid != -1) txtLastName.value = lastName; 
        tdLastName.className = "listItem2";
        tdLastName.insertAdjacentElement("afterBegin", txtLastName);
       
        tdHdn.className = "listItem2";
        tdHdn.innerHTML = "<input type='hidden' value='" + agentid + "'><input type='hidden' value='N'>&nbsp;" // AgentID, DeleteFlag
    }
    
    function Record_DeleteAgent(obj)
    {
        var tbl = document.getElementById("<%= tblAgent.ClientID %>");
        var index = obj.parentElement.parentElement.rowIndex
        
        if (tbl.rows[index].cells[3].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tbl.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tbl.rows[index].style.display = 'none';
            tbl.rows[index].cells[3].childNodes[1].value = 'Y';
        }         
    }    
    
    function GetNewDeleteAgent(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteAgent(this);return false;};
        a.insertAdjacentElement("afterBegin", img);

        return a;
    }     
    
    function GetNewEAFirstName()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
      function GetNewEALastName()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
   // Owned Agency 
   
    function Record_AddChildAgency()
   {
       var tblChildAgency = document.getElementById("<%= tblChildAgency.ClientID %>");
       var tr = tblChildAgency.insertRow(-1);
        
       var tdDelete = tr.insertCell(-1);
       var tdName = tr.insertCell(-1);
       var tdHdn = tr.insertCell(-1);
       
       tdDelete.className = "listItem2";
       tdDelete.insertAdjacentElement("afterBegin", GetNewChildAgencyDelete(tblChildAgency.rows.length - 1));
        
       tdName.className = "listItem2";
       tdName.insertAdjacentElement("afterBegin", GetNewChildAgencyDDL());
        
       tdHdn.className = "listItem2";
       tdHdn.innerHTML = "<input type='hidden' value='-1'><input type='hidden' value='N'>&nbsp;" // AgencyID, DeleteFlag
   }
   
   function Record_DeleteChildAgency(obj)
   {
        var tbl = document.getElementById("<%= tblChildAgency.ClientID %>");
        var index = obj.parentElement.parentElement.rowIndex
        
        if (tbl.rows[index].cells[2].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tbl.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tbl.rows[index].style.display = 'none';
            tbl.rows[index].cells[2].childNodes[1].value = 'Y';
        }  
   } 
   
   function GetNewChildAgencyDelete(index)
   {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteChildAgency(this);return false;};
        a.insertAdjacentElement("afterBegin", img);
       
       return a; 
   }
   
   function GetNewChildAgencyDDL()
   {
        var ddl = document.getElementById("<%= ddlAgencies.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < ddl.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = ddl.options[i].innerText;
            option.value = ddl.options[i].value;
        }

        return select;
   }
   
   function Structure()
   {
        <%= ClientScript.GetPostBackEventReference(lnkStructure, Nothing) %>;
   }
   
   /*
        Change 'Is Commission Recipient' related functions
   */
   
   function HasCommRecDependencies()
   {
        var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
        var tblChildAgencies = document.getElementById("<%= tblChildAgency.ClientID %>");
        var hasDependencies = false;
        var hdnFlag;
        for (i = 2; i < tblBanks.rows.length; i=i+2)
        {
            hdnFlag = tblBanks.rows[i+1].cells[0].childNodes[0];
            if (hdnFlag.value != 'Y')
            {
                hasDependencies = true;
                break;
            }
        }
        
        if (hasDependencies == false)
        {
            hasDependencies = HasAgencies();
        }
        
        return hasDependencies;
   }      
    
   function CheckCommRec(chk)
   {    
        if (chk.checked==true)
        {
            ShowDependencyPanels('block')
        }
        else
        {
            if (HasCommRecDependencies() == true)
            {
                cancelCommRecChange = true;
                window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/confirm.aspx") %>?f=DeleteCommRecDependencies&t=Delete dependencies&m=Unchecking the -Is Commission Recipient- checkbox will cause the banking information and the owned agencies links associated with this agency to be removed. Are you sure you want to proceed?';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                                   title: "Delete dependencies",
                                   dialogArguments: window,
                                   resizable: false,
                                   scrollable: false,
                                   height: 350, width: 400, scrollable: false,
                                   onClose: function(){
                                           if (cancelCommRecChange == true) {   //Override setting
                                                chk.checked = true;
                                            } else {
                                                ShowDependencyPanels('none');
                                            }
                                        }
                                   }); 
            }
            else
            {
                ShowDependencyPanels('none');
            }
        }
    }
    
   function ShowDependencyPanels(display)
   {    
        var pnlBank = document.getElementById("<%= pnlBank.ClientID %>");
        var pnlChildAgency = document.getElementById("<%= pnlChildAgency.ClientID %>");
        pnlBank.style.display = display; 
        pnlChildAgency.style.display = display;
   }
   
   function DeleteAll_BankingInfo()
   {
        var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");

        for (i = 2; i < tblBanks.rows.length; i=i+2)
        {
            var hdnFlag = tblBanks.rows[i+1].cells[0].childNodes[0];
            var delObj = tblBanks.rows[i].cells[0].childNodes[0];
            if (hdnFlag.value != 'Y') Record_DeleteBank(delObj);
        }
   }
   
   function DeleteAll_ChildAgency()
   {
        var tblChildAgencies = document.getElementById("<%= tblChildAgency.ClientID %>");
        var hdnFlag;
        for (i = 1; i < tblChildAgencies.rows.length; i++)
        {
            var hdnFlag = tblChildAgencies.rows[i].cells[2].childNodes[1];
            var delObj = tblChildAgencies.rows[i].cells[0].childNodes[0];
            if (hdnFlag.value != 'Y') Record_DeleteChildAgency(delObj);
        }
   }
   
    function DeleteCommRecDependencies()
    {
        DeleteAll_BankingInfo();
        DeleteAll_ChildAgency();
        cancelCommRecChange = false;
    }
    
    function ValidateDuplicateUser() 
    {
        var txtUserName = document.getElementById("<%= txtUserName.ClientID %>");
        PageMethods.UserNameExists(txtUserName.value, OnValidatedDuplicateUser);
    }
    
    function OnValidatedDuplicateUser(result)
    {
        if (result != false)
            ShowMessage("Login name already exists");
        else
             SaveAgencyOnServer();
    }
    
    function ValidateCircularRef(AgencyId) 
    {
        var tblOwnedAgencies = document.getElementById("<%= tblChildAgency.ClientID %>");
        var childAgencyIds = "";
        for (i = 1; i < tblOwnedAgencies.rows.length; i++)
        {
            var cboAgency = tblOwnedAgencies.rows[i].cells[1].childNodes[0];
            var hdnFlag = tblOwnedAgencies.rows[i].cells[2].childNodes[1];
            
            if (hdnFlag.value != 'Y')
            {
                if (childAgencyIds.length > 0) 
                    {childAgencyIds += "|";}
                childAgencyIds += cboAgency.options[cboAgency.selectedIndex].value;
            }
        }
        PageMethods.GetCircularReference(AgencyId, childAgencyIds, OnValidatedCircularRef);
    }
    
    function OnValidatedCircularRef(result)
    {
        if (result.length != 0)
            ShowMessage("Owned Agency " + GetAgencyName(result) + " will create a circular reference");
        else
            SaveAgencyOnServer();
    }
    
    function GetAgencyName(value)
    {
        var ddl = document.getElementById("<%= ddlAgencies.ClientID %>");
        for (i=0; i < ddl.options.length-1; i++)
        {
            if (ddl.options[i].value == value) return ddl.options[i].text;
        }
        return "";
    }
    
    
    </script>
    
    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/default.aspx">Admin</a>&nbsp;>&nbsp;
                <a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/default.aspx">Settings</a>&nbsp;>&nbsp;
                <a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references/default.aspx">References</a>&nbsp;>&nbsp;
                <a id="A4" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references/Multi.aspx?id=8">Agency</a>&nbsp;>&nbsp;
                <asp:label id="lblTitle" runat="server" style="color: #666666;"></asp:label>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
                            <div runat="server" id="dvError" style="display: none;">
                                <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                    width="100%" border="0">
                                    <tr>
                                        <td valign="top" style="width: 20;">
                                            <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                        <td runat="server" id="tdError">
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" width="935">
                                <tr>
                                    <td valign="top" style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="5" style="margin: 0 15 15 0; float: left;
                                            font-family: Tahoma; font-size: 11px; width: 100%">
                                            <tr>
                                                <td class="headitem2" colspan="2" height="20px" style="padding: 0 0 0 5; font-weight: bold;
                                                    font-size: 11px">
                                                    Agency Information
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 0 5 0 5; width: 50%" nowrap>
                                                    Firm Name:<br />
                                                    <input type="text" class="entry" id="txtFirmName" runat="server" />
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5; width: 50%">
                                                    Import Name:<br />
                                                    <input id="txtShortName" runat="server" class="entry" type="text" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    Contact First Name:<br />
                                                    <input id="txtContactFName" runat="server" class="entry" type="text" />
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    Last Name:<br />
                                                    <input id="txtContactLName" runat="server" class="entry" type="text" />
                                                </td>
                                                <tr>
                                                    <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                        <asp:CheckBox ID="ckIsCommRec" runat="server" onclick="javascript:CheckCommRec(this);"
                                                            Style="padding: 0 5 0 5" Text="Is Commission Recipient:" TextAlign="left" />
                                                        <!--Login Name:<br />
                                                        <asp:Panel ID="pnlUser" runat="server">
                                                            <input id="txtUserName" runat="server" class="entry" type="text" visible="false"/>
                                                            <asp:HyperLink id="lnkUserId" runat="server" visible="false"></asp:HyperLink> 
                                                        </asp:Panel> -->
                                                    </td> 
                                                    <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                        Fees Paid To:<br />
                                                        <asp:Label ID="lblFeesPaidTo" runat="server" CssClass="labelddlExtender" ></asp:Label>
                                                        <asp:Label ID="lblMultiFeesPaidTo" runat="server" CssClass="labelddlExtender" Visible="false"></asp:Label> 
                                                        <ajaxToolkit:DropDownExtender runat="server" ID="DDE" TargetControlID="lblMultiFeesPaidTo" DropDownControlID="DivFeesPaidTo" ></ajaxToolkit:DropDownExtender>  
                                                            <div id="divfeespaidto" runat="server" style="display: none; background-color: white;width: 100%" class="ddlExtender"></div>  

                                                    </td>
                                                </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%" valign="top">
                                        <table border="0" cellpadding="0" cellspacing="5" style="margin: 0 15 15 0; float: left;
                                            font-family: Tahoma; font-size: 11px; width: 100%">
                                            <tr>
                                                <td class="headitem2" colspan="2" height="20px" style="padding: 0 0 0 5; font-weight: bold;
                                                    font-size: 11px">
                                                    Audit Trail
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5; width: 25%">
                                                    Created:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5; width: 75%">
                                                    <asp:Label ID="lblCreated" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    Created By:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    <asp:Label ID="lblCreatedBy" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    Last Modified:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    <asp:Label ID="lblLastModified" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    Last Modified By:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 0 5 0 5">
                                                    <asp:Label ID="lblLastModifiedBy" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--Agency Address--%>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="PnlContent" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 0;
                                                font-family: tahoma; font-size: 11px;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Agency Address Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblAddresses" runat="server" border="0" cellpadding="5" cellspacing="0"
                                                            style="margin-bottom: 10; font-family: tahoma; font-size: 11px; width: 100%;">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Street Address 1
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Street Address 2
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    City
                                                                </td>
                                                                <td class="headItem2" style="width: 55">
                                                                    State
                                                                </td>
                                                                <td class="headItem2" style="width: 75">
                                                                    Zip Code
                                                                </td>
                                                                <td class="headItem2" style="width: auto">
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddAddress();" style="color: rgb(51,118,171);">
                                                            <img id="imgAddAddress" runat="server" align="absmiddle" border="0" src="~/images/16x16_file_add.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Address</a><br />
                                                        <input id="txtAddresses" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <%--Phones--%>
                                    <td style="width: 50%" valign="top">
                                        <asp:Panel ID="pnlPhones" runat="server" CssClass="collapsePanel" Height="0px">
                                            <table border="0" cellpadding="0" cellspacing="2" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px; width: 100%;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Agency Phone Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblPhones" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px; width: 100%;">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16;">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 175">
                                                                    Phone Type</td>
                                                                <td class="headItem2" style="width: 85">
                                                                    Number</td>
                                                                <td class="headItem2" style="width: auto">
                                                                    &nbsp;</td>                                                                    
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddPhone();" style="color: rgb(51,118,171);">
                                                            <img id="imgAddPhone" runat="server" align="absmiddle" border="0" src="~/images/16x16_phone_add.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Phone</a><br />
                                                        <input id="txtPhones" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    <%--Owned Agencys--%>
                                    <td style="width: 50%" valign="top">
                                        <asp:Panel ID="pnlChildAgency" runat="server" CssClass="collapsePanel" Height="0px"
                                            Width="100%">
                                            <table border="0" cellpadding="0" cellspacing="2" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px; width: 100%;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Owned Agency(s):</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblChildAgency" runat="server" border="0" cellpadding="5" cellspacing="0"
                                                            style="margin-bottom: 10; font-family: tahoma; font-size: 11px; width: 100%;">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16;">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 250">
                                                                    Agency</td>
                                                                <td class="headItem2" style="width: auto">
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddChildAgency();" style="color: rgb(51,118,171);">
                                                            <img id="img3" runat="server" align="absmiddle" border="0" src="~/images/16x16_company.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Agency</a><br />
                                                        <input id="txtOwnedAgencys" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--Banking information--%>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnlBank" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px" Width="100%">
                                            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px;" width="100%">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Agency Banking Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblBanks" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 175">
                                                                    Bank Name
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Street Address 1
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Street Address 2
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    City
                                                                </td>
                                                                <td class="headItem2" style="width: 55">
                                                                    State
                                                                </td>
                                                                <td class="headItem2" style="width: 75">
                                                                    Zip Code
                                                                </td>
                                                                <td class="headItem2" style="width: 75">
                                                                    Phone
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 175">
                                                                    Display
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Contact
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Routing Number
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    Account Number
                                                                </td>
                                                                <td class="headItem2" style="width: 50">
                                                                    Checking?
                                                                </td>
                                                                <td class="headItem2" style="width: 75">
                                                                    ACH?
                                                                </td>
                                                                <td class="headItem2" style="width: 75">
                                                                    Abbreviation
                                                                </td>
                                                             </tr>
                                                            </td>
                                                         </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddBanks();" style="color: rgb(51,118,171);">
                                                            <img id="img2" runat="server" align="absmiddle" border="0" src="~/images/16x16_entrytype.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Bank Information</a><br />
                                                        <input id="hdnBankInfo" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--Agents--%>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnlEAtty" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px">
                                            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px;" width="100%">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Agent(s) Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblAgent" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px; width: 100%">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td align="left" class="headItem2" nowrap="nowrap" style="width: 150">
                                                                    First Name
                                                                </td>
                                                                <td class="headItem2" nowrap="nowrap" style="width: 150">
                                                                    Last Name
                                                                </td>
                                                                <td class="headItem2" style="width: auto">
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddAgents();" style="color: rgb(51,118,171);">
                                                            <img id="img5" runat="server" align="absmiddle" border="0" src="~/images/16x16_agent.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Agent</a><br />
                                                        <input id="hdnAgents" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:DropDownList ID="ddlPhoneTypes" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlStates" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlAgencies" runat="server" Style="display: none">
    </asp:DropDownList>
    <asp:DropDownList ID="ddlAccountType" runat="server" Style="display: none" />
    <asp:TextBox ID="txtStreet1" runat="server" Style="display: none" />
    <asp:TextBox ID="txtStreet2" runat="server" Style="display: none" />
    <asp:TextBox ID="txtCity" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlCity" runat="server" Style="display: none" />
    <asp:TextBox ID="txtZip" runat="server" Style="display: none" />
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
    <asp:LinkButton ID="lnkStructure" runat="server" />
    <cc1:InputMask ID="imask" runat="server" style="display: none;" /> 
    <input type="hidden" id="hdnAgencyId" runat="server" /> 
</asp:Content>
