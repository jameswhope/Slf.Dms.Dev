<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="settlementatty.aspx.vb" Inherits="admin_settings_references_settlementatty" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:ScriptManager ID="ScriptManager2" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>

    <script src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>" type="text/javascript"></script>

    <script src="<%= ResolveUrl("~/jscript/validation/Display.js") %>" type="text/javascript"></script>

    <script src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>" type="text/javascript"></script>

    <script type="text/javascript">        
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
	
	function Save()
    {
        if (ValidateFields() == 0)
            ValidateDuplicateUser();
        else
            ShowMessage('Please enter required fields.');
    }
    
    function ValidateFields()
    {
        var txtFirmName = document.getElementById("<%= txtFirmName.ClientID() %>");
        var txtShortName = document.getElementById("<%= txtShortName.ClientID() %>");
        var txtContactFName = document.getElementById("<%= txtContactFName.ClientID() %>");
        var txtContactLName = document.getElementById("<%= txtContactLName.ClientID() %>"); 
        var txtUserName = document.getElementById("<%= txtUserName.ClientID %>");
        var CompanyID = document.getElementById("<%= hdnCompanyID.ClientID %>");  
        var count = 0;
       
        RemoveBorder(txtFirmName);       
        RemoveBorder(txtShortName);
        RemoveBorder(txtContactFName);
        RemoveBorder(txtContactLName);
        
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
        
        if (txtContactFName.value.length == 0) 
        {
	        AddBorder(txtContactFName);
            count++;
        }
        
        if (txtContactLName.value.length == 0)
        {
	        AddBorder(txtContactLName);
            count++;
        }
       
        if ((CompanyID.value < 0) && (txtUserName.value.length == 0))
        {
            AddBorder(txtUserName);
            count++;
        } 
        
        // sections with required fields
        count+=ResetAddresses();
        count+=ResetPhones();
        count+=ResetBankInfo();
        
        //ResetStateBars();
        ResetFTPInfo();
        ResetAttorneys();
        
        return count;
    }
   
   function ValidateDuplicateUser() 
    {
        var txtUserName = document.getElementById("<%=txtUserName.ClientID %>");
        
        if (txtUserName)
            PageMethods.UserNameExists(txtUserName.value, OnValidatedDuplicateUser); // only when adding a new SA
        else
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    
    function OnValidatedDuplicateUser(exists)
    {
        if (exists)
            ShowMessage("Login name already exists");
        else
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    } 
    
    function ResetAddresses()
    {
        var tblAddresses = document.getElementById("<%= tblAddresses.ClientID %>");
        var txtAddresses = document.getElementById("<%= txtAddresses.ClientID %>");
        var count = 0;
        
        txtAddresses.value = "";

        for (i = 1; i < tblAddresses.rows.length; i++)
        {
            var cboAddressType = tblAddresses.rows[i].cells[1].childNodes[0];
            var txtAddress1 = tblAddresses.rows[i].cells[2].childNodes[0];
            var txtAddress2 = tblAddresses.rows[i].cells[3].childNodes[0];
            var txtCity = tblAddresses.rows[i].cells[4].childNodes[0];
            var cboState = tblAddresses.rows[i].cells[5].childNodes[0];
            var txtZip = tblAddresses.rows[i].cells[6].childNodes[0];
            
            // reset
            RemoveBorder(txtAddress1);
            RemoveBorder(txtCity);
            RemoveBorder(txtZip);

            if (txtAddress1.value != null && txtAddress1.value.length > 0 && txtCity.value != null && txtCity.value.length > 0 && txtZip.value != null && txtZip.value.length > 0)
            {
                if (txtAddresses.value.length > 0)
                {
                    txtAddresses.value += "|" + cboAddressType.options[cboAddressType.selectedIndex].value + "," + txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," +txtZip.value;
                }
                else
                {
                    txtAddresses.value = cboAddressType.options[cboAddressType.selectedIndex].value + "," + txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," +txtZip.value;
                }
            }
            else if (cboAddressType.disabled)
            {
                // This is a required address type
                if (txtAddress1.value == null || txtAddress1.value.length == 0)
                    AddBorder(txtAddress1);
                    
                if (txtCity.value == null || txtCity.value.length == 0)
                    AddBorder(txtCity);                    
                    
                if (txtZip.value == null || txtZip.value.length == 0)
                    AddBorder(txtZip);                    
                
                count++;
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
            else if (cboPhoneType.disabled)
            {
                // This is a required phone type
                AddBorder(txtPhoneNumber);
                count++;
            }
        }
        
        return count;
    }
    
    /*function ResetStateBars()
    {
        var tblStateBar = document.getElementById("<%= tblStateBar.ClientID %>");
        var txtStateBars = document.getElementById("<%= txtStateBars.ClientID %>");

        txtStateBars.value = "";

        for (i = 1; i < tblStateBar.rows.length; i++)
        {
            var cboState = tblStateBar.rows[i].cells[1].childNodes[0];
            var txtStateBarNum = tblStateBar.rows[i].cells[2].childNodes[0];

            if (txtStateBarNum.value != null && txtStateBarNum.value.length > 0)
            {
                if (txtStateBars.value.length > 0)
                {
                    txtStateBars.value += "|" + cboState.options[cboState.selectedIndex].value + "," + txtStateBarNum.value;
                }
                else
                {
                    txtStateBars.value = cboState.options[cboState.selectedIndex].value + "," + txtStateBarNum.value;
                }
            }
        }
    }*/

    function ResetBankInfo()
    {
        var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
        var hdnBankInfo = document.getElementById("<%= hdnBankInfo.ClientID %>");
        var count = 0;
        
        hdnBankInfo.value = ""; // reset
        
        if (tblBanks) // if table is null, user does not have perm to update bank info, section will be skipped
        {
            for (i=0; i < tblBanks.rows.length; i=i+2)
            {   
                var cboAcctType = tblBanks.rows[i].cells[1].childNodes[2];
                var txtAddress1 = tblBanks.rows[i].cells[2].childNodes[2];
                var hdnAddressID = tblBanks.rows[i].cells[2].childNodes[3];
                var txtAddress2 = tblBanks.rows[i].cells[3].childNodes[2];
                var txtCity = tblBanks.rows[i].cells[4].childNodes[2];
                var cboState = tblBanks.rows[i].cells[5].childNodes[2];
                var txtZip = tblBanks.rows[i].cells[6].childNodes[2];
                var txtPhone = tblBanks.rows[i].cells[7].childNodes[2];
                // line 2
                var hdnFlag = tblBanks.rows[i+1].cells[0].childNodes[0];
                var hdnPhoneID = tblBanks.rows[i+1].cells[0].childNodes[1];
                var txtBankName = tblBanks.rows[i+1].cells[1].childNodes[2];
                var txtContact = tblBanks.rows[i+1].cells[2].childNodes[2];
                var txtRouting = tblBanks.rows[i+1].cells[3].childNodes[2];
                var txtAccount = tblBanks.rows[i+1].cells[4].childNodes[2];
                var chkChecking = tblBanks.rows[i+1].cells[5].childNodes[2];
                var chkACH = tblBanks.rows[i+1].cells[6].childNodes[2];
                var hdnID = tblBanks.rows[i+1].cells[7].childNodes[0];
                
                // reset
                RemoveBorder(txtBankName);
                RemoveBorder(txtRouting);
                RemoveBorder(txtAccount);

                if (txtBankName.value != null && txtBankName.value.length > 0 && txtRouting.value != null && txtRouting.value.length > 0 && txtAccount.value != null && txtAccount.value.length > 0)
                {
                    if (hdnBankInfo.value.length > 0)
                    {
                        hdnBankInfo.value += "|";
                    }
                    
                    hdnBankInfo.value += txtBankName.value + "," + txtAddress1.value + "," + txtAddress2.value + "," + txtCity.value + "," + cboState.options[cboState.selectedIndex].value + "," + txtZip.value + "," + txtPhone.value + "," + cboAcctType.options[cboAcctType.selectedIndex].value + "," + txtContact.value + "," + txtRouting.value + "," + txtAccount.value + "," + chkChecking.checked + "," + chkACH.checked + "," + hdnID.value + "," + hdnFlag.value + "," + hdnAddressID.value + "," + hdnPhoneID.value;
                }
                else if (cboAcctType.disabled)
                {
                    // This is a required bank account type, flag required fields
                    if (txtBankName.value == null || txtBankName.value.length == 0)
                        AddBorder(txtBankName);
                        
                    if (txtRouting.value == null || txtRouting.value.length == 0)
                        AddBorder(txtRouting);
                        
                    if (txtAccount.value == null || txtAccount.value.length == 0)
                        AddBorder(txtAccount);
                    
                    count++;
                }
            }
        }
        
        return count;
    }
    
    function ResetFTPInfo()
    {
        var tblFTP = document.getElementById("<%= tblFTP.ClientID %>");
        var hdnFTPInfo = document.getElementById("<%= hdnFTPInfo.ClientID %>");
        
        hdnFTPInfo.value = ""; // reset
        
        if (tblFTP) // if table is null, user does not have perm to update ftp info, section will be skipped
        {   
            for (i=0; i < tblFTP.rows.length; i=i+2)
            {
                var txtServer = tblFTP.rows[i].cells[1].childNodes[2];
                var txtLogin = tblFTP.rows[i].cells[2].childNodes[2];
                var txtPwd = tblFTP.rows[i].cells[3].childNodes[2];
                var txtFolder = tblFTP.rows[i].cells[4].childNodes[2];
                var txtPort = tblFTP.rows[i].cells[5].childNodes[2];
                // line 2
                var hdnID = tblFTP.rows[i+1].cells[0].childNodes[0];
                var hdnFlag = tblFTP.rows[i+1].cells[0].childNodes[1];
                var txtPassphrase = tblFTP.rows[i+1].cells[1].childNodes[2];
                var txtPublicKey = tblFTP.rows[i+1].cells[2].childNodes[2];
                var txtPrivateKey = tblFTP.rows[i+1].cells[3].childNodes[2];
                var txtFileLoc = tblFTP.rows[i+1].cells[4].childNodes[2];
                var txtLogPath = tblFTP.rows[i+1].cells[5].childNodes[2];

                if (txtServer.value != null && txtServer.value.length > 0)
                {
                    if (hdnFTPInfo.value.length > 0)
                    {
                        hdnFTPInfo.value += "|";
                    }
                    
                    hdnFTPInfo.value += txtServer.value + "," + txtLogin.value + "," + txtPwd.value + "," + txtFolder.value + "," + txtPort.value + "," + txtPassphrase.value + "," + txtPublicKey.value + "," + txtPrivateKey.value + "," + txtFileLoc.value + "," + txtLogPath.value + "," + hdnID.value + "," + hdnFlag.value;
                }
            }
        }
    }
    
    function ResetAttorneys()
    {
        var tblEAtty = document.getElementById("<%= tblEAtty.ClientID %>");
        var hdnAttorneys = document.getElementById("<%= hdnAttorneys.ClientID %>");
        
        hdnAttorneys.value = "";
        
        for (i = 1; i < tblEAtty.rows.length; i++)
        {
            var txtFirst = tblEAtty.rows[i].cells[1].childNodes[0];
            var txtMI = tblEAtty.rows[i].cells[2].childNodes[0];
            var txtLast = tblEAtty.rows[i].cells[3].childNodes[0];
            var cboState = tblEAtty.rows[i].cells[4].childNodes[0];
            var txtStateBar = tblEAtty.rows[i].cells[5].childNodes[0];  
            var chkPrimary = tblEAtty.rows[i].cells[6].childNodes[0];  
            var hdnID = tblEAtty.rows[i].cells[7].childNodes[0];
            var hdnFlag = tblEAtty.rows[i].cells[7].childNodes[1];
            
            if (txtLast.value != null && txtLast.value.length > 0)
            {
                if (hdnAttorneys.value.length > 0)
                {
                    hdnAttorneys.value += "|";
                }
                
                hdnAttorneys.value += hdnID.value + "," + hdnFlag.value + "," + txtFirst.value + "," + txtLast.value + "," + txtMI.value + "," + cboState.options[cboState.selectedIndex].value + "," + txtStateBar.value + "," + chkPrimary.checked;
            }
        }
    }
    
    function Delete()
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
        Attorney Address functions    
    */
    
    function Record_AddAddress()
    {
        var tblAddresses = document.getElementById("<%= tblAddresses.ClientID %>");
        var trNew = tblAddresses.insertRow(-1);
        
        var tdDelete = trNew.insertCell(-1);
        var tdAddressType = trNew.insertCell(-1);
        var tdAddress = trNew.insertCell(-1);
        var tdAddress2 = trNew.insertCell(-1);
        var tdCity = trNew.insertCell(-1);
        var tdState = trNew.insertCell(-1);
        var tdZip = trNew.insertCell(-1);  
           
        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeleteAddress(tblAddresses.rows.length - 1));
        
        tdAddressType.className = "listItem2";
        tdAddressType.insertAdjacentElement("afterBegin", GetNewAddressType());
        
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
    }
    
    function Record_DeleteAddress(obj)
    {
        var tbl = document.getElementById("<%= tblAddresses.ClientID %>");

        tbl.deleteRow(obj.parentElement.parentElement.rowIndex);
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
       
    function GetNewAddressType()
    {
        var ddlAddressType = document.getElementById("<%= ddlAddressTypes.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        //select.style.width = 100;
        
        for (i = 0; i < ddlAddressType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = ddlAddressType.options[i].innerText;
            option.value = ddlAddressType.options[i].value;
        }

        return select; 
    } 
   
    function GetNewStateType(state)
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
            
            if (ddlStates.options[i].innerText == state)
            {
                option.setAttribute('selected','selected');
            }
        }

        return select;
    }  
    
    /*
        Attorney Phone Information
    */
    
    function Record_AddPhone()
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");
        var trNew = tblPhones.insertRow(-1);

        var tdDelete = trNew.insertCell(-1);
        var tdPhoneType = trNew.insertCell(-1);
        var tdPhoneNumber = trNew.insertCell(-1);

        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeletePhone(tblPhones.rows.length - 1));

        tdPhoneType.className = "listItem2";
        tdPhoneType.insertAdjacentElement("afterBegin", GetNewPhoneType());

        tdPhoneNumber.className = "listItem2";
        tdPhoneNumber.insertAdjacentElement("afterBegin", GetNewPhoneNumber());
    }
    
    function Record_DeletePhone(obj)
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");

        tblPhones.deleteRow(obj.parentElement.parentElement.rowIndex)
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
        State Bar Functions
   */
   
   function Record_AddStateBar()
   {
       var tblStateBar = document.getElementById("<%= tblStateBar.ClientID %>");
       var trNew = tblStateBar.insertRow(-1);
        
       var tdBarDelete = trNew.insertCell(-1);
       var tdBarState = trNew.insertCell(-1);
       var tdBarNumber = trNew.insertCell(-1);
       
       tdBarDelete.className = "listItem2";
       tdBarDelete.insertAdjacentElement("afterBegin", GetNewDeleteBar(tblStateBar.rows.length - 1));
        
       tdBarState.className = "listItem2";
       tdBarState.insertAdjacentElement("afterBegin", GetNewBarState());
        
       tdBarNumber.className = "listItem2";
       tdBarNumber.innerHTML = "<input type='text' class='entry' style='width: 175'>";
   }
   
   function Record_DeleteBar(obj)
   {
       var tblStateBar = document.getElementById("<%= tblStateBar.ClientID %>");

       tblStateBar.deleteRow(obj.parentElement.parentElement.rowIndex);
   } 
   
   function GetNewDeleteBar(index)
   {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteBar(this);return false;};
        a.insertAdjacentElement("afterBegin", img);
       
       return a; 
   }
   
   function GetNewBarState()
   {
        var ddl = document.getElementById("<%= ddlStates.ClientID %>");
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
    
   /*
        Bank Account Functions
   */
   
   function Record_AddBanks()
   {
       var tblBanks = document.getElementById("<%= tblBanks.ClientID %>");
       var trNew = tblBanks.insertRow(-1);
        
       var tdBankDelete = trNew.insertCell(-1);
       var tdAccountType = trNew.insertCell(-1);
       var tdBankAddress = trNew.insertCell(-1);
       var tdBankAddress2 = trNew.insertCell(-1);
       var tdBankCity = trNew.insertCell(-1);
       var tdBankState = trNew.insertCell(-1);
       var tdBankZip = trNew.insertCell(-1);
       var tdBankPhone = trNew.insertCell(-1);
        
       var trNew = tblBanks.insertRow(-1); 
        
       var tdFlag = trNew.insertCell(-1); 
       var tdBankName = trNew.insertCell(-1);
       var tdContact = trNew.insertCell(-1);
       var tdRoutingNumber = trNew.insertCell(-1);
       var tdAccountNumber = trNew.insertCell(-1);
       var tdBankChecking = trNew.insertCell(-1);
       var tdBankACH = trNew.insertCell(-1);  
       var tdID = trNew.insertCell(-1);    
       
       if (isEven(tblBanks.rows.length / 2))
            bgColor = '#e6e6e6';
       else
            bgColor = '#ffffff';
        
       tdBankDelete.setAttribute('bgColor',bgColor);
       tdBankDelete.insertAdjacentElement("afterBegin", GetNewDeleteBank(tblBanks.rows.length - 1));
       
       tdAccountType.setAttribute('bgColor',bgColor);
       tdAccountType.innerHTML = "Account Type<br />";
       tdAccountType.insertAdjacentElement("beforeEnd", GetNewBAccountType());       
       
       tdBankAddress.setAttribute('bgColor',bgColor);
       tdBankAddress.innerHTML = "Street Address 1<br /><input type='text' class='entry'><input type='hidden' value='-1'>";
       
       tdBankAddress2.setAttribute('bgColor',bgColor);
       tdBankAddress2.innerHTML = "Street Address 2<br /><input type='text' class='entry'>";
       
       tdBankCity.setAttribute('bgColor',bgColor);
       tdBankCity.innerHTML = "City:<br /><input type='text' class='entry'>";
       
       tdBankState.setAttribute('bgColor',bgColor);
       tdBankState.innerHTML = 'State<br />';
       tdBankState.insertAdjacentElement("beforeEnd", GetNewStateType()); 
       
       tdBankZip.setAttribute('bgColor',bgColor);
       tdBankZip.innerHTML = 'Zip Code<br />';
       tdBankZip.insertAdjacentElement("beforeEnd", GetNewBZip()); 
       
       tdBankPhone.setAttribute('bgColor',bgColor);
       tdBankPhone.innerHTML = 'Phone<br />';
       tdBankPhone.insertAdjacentElement("beforeEnd", GetNewBPhone());
       
       // line 2
       tdFlag.setAttribute('bgColor',bgColor);
       tdFlag.className = "listItem2"
       tdFlag.innerHTML = "<input type='hidden' value='N'><input type='hidden' value='-1'>"; // Delete Flag and CommRecPhoneID
       
       tdBankName.setAttribute('bgColor',bgColor);
       tdBankName.className = "listItem2";
       tdBankName.innerHTML = "Bank Name<br /><input type='text' class='entry'>";
       
       tdContact.setAttribute('bgColor',bgColor);
       tdContact.className = "listItem2";
       tdContact.innerHTML = "Contact<br /><input type='text' class='entry'>";
       
       tdRoutingNumber.setAttribute('bgColor',bgColor);
       tdRoutingNumber.className = "listItem2";
       tdRoutingNumber.innerHTML = 'Routing Number<br />';
       tdRoutingNumber.insertAdjacentElement("beforeEnd", GetNewBRoutingNo(''));
       
       tdAccountNumber.setAttribute('bgColor',bgColor);
       tdAccountNumber.className = "listItem2";
       tdAccountNumber.innerHTML = 'Account Number<br />';
       tdAccountNumber.insertAdjacentElement("beforeEnd", GetNewBAccountNo(''));
       
       tdBankChecking.setAttribute('bgColor',bgColor);
       tdBankChecking.className = "listItem2"; 
       tdBankChecking.innerHTML = "Checking:<br /><input type='checkbox' class='entry' checked>"; 
       
       tdBankACH.setAttribute('bgColor',bgColor);
       tdBankACH.className = "listItem2"; 
       tdBankACH.innerHTML = "ACH:<br /><input type='checkbox' class='entry' checked>"; 
       
       tdID.setAttribute('bgColor',bgColor);
       tdID.className = "listItem2"
       tdID.innerHTML = "<input type='hidden' value='-1'>&nbsp;";    
    } 
    
    function isEven(x)
    {
        return (x%2)?false:true; 
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
       
    function GetNewBAccountType()
    {
        var ddlAccountType = document.getElementById("<%= ddlAccountType.ClientID %>");
        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < ddlAccountType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = ddlAccountType.options[i].innerText;
            option.value = ddlAccountType.options[i].value;
        }

        return select; 
    } 
   
   function GetNewBRoutingNo(value)
    {
      var input = document.createElement("INPUT");

        input.value = value;
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
   
       function GetNewBAccountNo(value)
       {
            var input = document.createElement("INPUT");

            input.value = value;
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
       
       //   FTP Information  

      function Record_AddFTP()
      {
       var tblFTP = document.getElementById("<%= tblFTP.ClientID %>");
       var trNew = tblFTP.insertRow(-1);
        
       var tdFTPDelete = trNew.insertCell(-1);
       var tdFTPServer = trNew.insertCell(-1);
       var tdFTPLogin = trNew.insertCell(-1);
       var tdFTPPassword = trNew.insertCell(-1);
       var tdFTPFolder = trNew.insertCell(-1);
       var tdFTPPort = trNew.insertCell(-1);
              
       var trNew = tblFTP.insertRow(-1);
       
       var tdNada = trNew.insertCell(-1);
       var tdPassphrase = trNew.insertCell(-1); 
       var tdPublicKeyRing = trNew.insertCell(-1);
       var tdPrivateKeyRing = trNew.insertCell(-1); 
       var tdFileLocation = trNew.insertCell(-1);
       var tdLogPath = trNew.insertCell(-1);

       tdFTPDelete.insertAdjacentElement("afterBegin", GetNewDeleteFTP(tblFTP.rows.length - 1));
       tdFTPServer.innerHTML = "<input type='text' class='entry'>";
       tdFTPLogin.insertAdjacentElement("afterBegin", GetNewFTPLogin());
       tdFTPPassword.insertAdjacentElement("afterBegin", GetNewFTPPassword());
       tdFTPFolder.insertAdjacentElement("afterBegin", GetNewFTPFolder());
       tdFTPPort.insertAdjacentElement("afterBegin", GetNewFTPPort());
       
       // line 2
       tdNada.className = "listItem2"
       tdNada.innerHTML = "<input type='hidden' value='-1'><input type='hidden' value='N'>&nbsp;"; //NachaRootID and Delete Flag
       
       tdPassphrase.className = "listItem2";
       tdPassphrase.insertAdjacentElement("afterBegin", GetNewPassphrase()); 
       
       tdPublicKeyRing.className = "listItem2";
       tdPublicKeyRing.insertAdjacentElement("afterBegin", GetNewPublicKeyRing());
        
       tdPrivateKeyRing.className = "listItem2";
       tdPrivateKeyRing.insertAdjacentElement("afterBegin", GetNewPrivateKeyRing());
       
       tdFileLocation.className = "listItem2";
       tdFileLocation.insertAdjacentElement("afterBegin", GetNewFileLocation());
       
       tdLogPath.className = "listItem2";
       tdLogPath.insertAdjacentElement("afterBegin", GetNewLogPath());
    } 
   
   function Record_DeleteFTP(obj)
    {
        var tblFTP = document.getElementById("<%= tblFTP.ClientID %>");       
        var index = obj.parentElement.parentElement.rowIndex;
        
        // note: FTP information spans 2 rows
        if (tblFTP.rows[index+1].cells[0].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tblFTP.deleteRow(index);
            tblFTP.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tblFTP.rows[index].style.display = 'none';
            tblFTP.rows[index+1].style.display = 'none';
            tblFTP.rows[index+1].cells[0].childNodes[1].value = 'Y';
        }        
    }
    
    function GetNewDeleteFTP(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteFTP(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
    }
   
   function GetNewFTPLogin()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewFTPPassword()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    }
   
   function GetNewFTPFolder()
    {
   
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewPassphrase()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
    } 
   
   function GetNewFTPPort()
    {
      var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";

        return input;
    }   
   
   function GetNewPublicKeyRing()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";

        return input;
    } 
    
    function GetNewDeleteFTP(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteFTP(this);return false;};
        a.insertAdjacentElement("afterBegin", img);

        return a;
    }    
       
    function GetNewPrivateKeyRing()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";

        return input;
    } 
   
   function GetNewFileLocation()
    {
      var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";

        return input;
    } 
   
   function GetNewLogPath()
   {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";
		
        return input; 
   }
   
   //   Employed Attorneys

    function Record_AddEAttorneys()
    {
        var wnd;
        var left=20;
        var top=20; 

        if (screen) {
            left = (screen.width / 2) - (350 / 2)
            top = (screen.height / 2) - (150 / 2)
        }
        
        wnd=window.open("<%= ResolveUrl("~/util/pop/addattorney.aspx")%>", '', 'width=350,height=170,scrollbars=no,resizable=no,status=no,left='+left+',top='+top);
        wnd.focus();
    }
    
    function AddEAttorney(id,first,mi,last,state,bar)
    {
        var tblEAtty = document.getElementById("<%= tblEAtty.ClientID %>");
        var trNew = tblEAtty.insertRow(-1);
        
        var tdDelete = trNew.insertCell(-1);
        var tdFirstName = trNew.insertCell(-1);
        var tdMiddleName = trNew.insertCell(-1);
        var tdLastName = trNew.insertCell(-1);
        var tdState = trNew.insertCell(-1);
        var tdStateBar = trNew.insertCell(-1);
        var tdPrimary = trNew.insertCell(-1);
        var tdID = trNew.insertCell(-1);
               
        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDeleteEA(tblEAtty.rows.length - 1));
        
        tdFirstName.className = "listItem2";
        tdFirstName.innerHTML = "<input type='text' class='entry' value='"+first+"'>";
        
        tdMiddleName.className = "listItem2";
        tdMiddleName.innerHTML = "<input type='text' class='entry' value='"+mi+"'>";
       
        tdLastName.className = "listItem2";
        tdLastName.innerHTML = "<input type='text' class='entry' value='"+last+"'>";
        
        tdState.className = "listItem2";
        tdState.insertAdjacentElement("afterBegin", GetNewStateType(state));
        
        tdStateBar.className = "listItem2";
        tdStateBar.innerHTML = "<input type='text' class='entry' value='"+bar+"'>";
        
        tdPrimary.className = "listItem2";
        tdPrimary.innerHTML = "<input type='checkbox' class='entry'>";

        tdID.className = "listItem2";
        tdID.innerHTML = "<input type='hidden' value='"+id+"'><input type='hidden' value='N'>&nbsp;"; // AttorneyID, Delete Flag
    }
    
    function Record_DeleteEA(obj)
    {
        var tblEAtty = document.getElementById("<%= tblEAtty.ClientID %>");
        var index = obj.parentElement.parentElement.rowIndex
        
        if (tblEAtty.rows[index].cells[7].childNodes[0].value == -1)
        {
            // user is deleting a new row, no need to flag it, just delete it
            tblEAtty.deleteRow(index);
        }
        else
        {
            // hide record and flag for deletion
            tblEAtty.rows[index].style.display = 'none';
            tblEAtty.rows[index].cells[7].childNodes[1].value = 'Y';
        }         
    }    
    
    function GetNewDeleteEA(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeleteEA(this);return false;};
        a.insertAdjacentElement("afterBegin", img);

        return a;
    }     
    
    function GetAcctInput(value)
    {
        var input = document.createElement("input");

        input.type = "text"
        input.className = "entry";
        input.setAttribute('maxlength', 9);
        input.value = value;
		
        return input; 
    }
    
    function ShowBankFields()
    {
        var tblBanks = document.getElementById("<%=tblBanks.ClientID %>");
        
        for (i=0; i < tblBanks.rows.length; i=i+2)
        {
            var routing = tblBanks.rows[i+1].cells[3].childNodes[2].value;
            var account = tblBanks.rows[i+1].cells[4].childNodes[2].value;
            
            tblBanks.rows[i+1].cells[3].removeChild(tblBanks.rows[i+1].cells[3].childNodes[2]);
            tblBanks.rows[i+1].cells[4].removeChild(tblBanks.rows[i+1].cells[4].childNodes[2]);
            
            tblBanks.rows[i+1].cells[3].insertAdjacentElement("beforeEnd", GetAcctInput(routing));
            tblBanks.rows[i+1].cells[4].insertAdjacentElement("beforeEnd", GetAcctInput(account));
        }
    }
    
    function ShowFTPFields()
    {
        var tblFTP = document.getElementById("<%= tblFTP.ClientID %>");

        for (i=0; i < tblFTP.rows.length; i=i+2)
        {
            var server = tblFTP.rows[i].cells[1].childNodes[2].value;
            var username = tblFTP.rows[i].cells[2].childNodes[2].value;
            var password = tblFTP.rows[i].cells[3].childNodes[2].value;
            var folder = tblFTP.rows[i].cells[4].childNodes[2].value;
            var port = tblFTP.rows[i].cells[5].childNodes[2].value;
            // line 2
            var passphrase = tblFTP.rows[i+1].cells[1].childNodes[2].value;
            var publickey = tblFTP.rows[i+1].cells[2].childNodes[2].value;
            var privatekey = tblFTP.rows[i+1].cells[3].childNodes[2].value;
            var fileloc = tblFTP.rows[i+1].cells[4].childNodes[2].value;
            var logpath = tblFTP.rows[i+1].cells[5].childNodes[2].value;
            
            tblFTP.rows[i].cells[1].removeChild(tblFTP.rows[i].cells[1].childNodes[2]);
            tblFTP.rows[i].cells[2].removeChild(tblFTP.rows[i].cells[2].childNodes[2]);
            tblFTP.rows[i].cells[3].removeChild(tblFTP.rows[i].cells[3].childNodes[2]);
            tblFTP.rows[i].cells[4].removeChild(tblFTP.rows[i].cells[4].childNodes[2]);
            tblFTP.rows[i].cells[5].removeChild(tblFTP.rows[i].cells[5].childNodes[2]);
                        
            tblFTP.rows[i].cells[1].insertAdjacentElement("beforeEnd", CreateInput(server,175));
            tblFTP.rows[i].cells[2].insertAdjacentElement("beforeEnd", CreateInput(username,190)); 
            tblFTP.rows[i].cells[3].insertAdjacentElement("beforeEnd", CreateInput(password,190));
            tblFTP.rows[i].cells[4].insertAdjacentElement("beforeEnd", CreateInput(folder,190));
            tblFTP.rows[i].cells[5].insertAdjacentElement("beforeEnd", CreateInput(port,190));
            
            // line 2
            tblFTP.rows[i+1].cells[1].removeChild(tblFTP.rows[i+1].cells[1].childNodes[2]);
            tblFTP.rows[i+1].cells[2].removeChild(tblFTP.rows[i+1].cells[2].childNodes[2]);
            tblFTP.rows[i+1].cells[3].removeChild(tblFTP.rows[i+1].cells[3].childNodes[2]);
            tblFTP.rows[i+1].cells[4].removeChild(tblFTP.rows[i+1].cells[4].childNodes[2]);
            tblFTP.rows[i+1].cells[5].removeChild(tblFTP.rows[i+1].cells[5].childNodes[2]);
            
            tblFTP.rows[i+1].cells[1].insertAdjacentElement("beforeEnd", CreateInput(passphrase,175)); 
            tblFTP.rows[i+1].cells[2].insertAdjacentElement("beforeEnd", CreateInput(publickey,190)); 
            tblFTP.rows[i+1].cells[3].insertAdjacentElement("beforeEnd", CreateInput(privatekey,190)); 
            tblFTP.rows[i+1].cells[4].insertAdjacentElement("beforeEnd", CreateInput(fileloc,190)); 
            tblFTP.rows[i+1].cells[5].insertAdjacentElement("beforeEnd", CreateInput(logpath,190)); 
        }
    }
    
    function CreateInput(value,width)
    {
        var input = document.createElement("input");

        input.type = "text";
        input.className = "entry";
        input.value = value;
        input.style.width = width;
    	
        return input; 
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a class="lnk" runat="server" href="~/admin/default.aspx" style="color: #666666;">Admin</a>&nbsp;>&nbsp;
                <a runat="server" class="lnk" href="~/admin/settings/default.aspx" style="color: #666666;">Settings</a>&nbsp;>&nbsp;
                <a runat="server" class="lnk" href="~/admin/settings/references/default.aspx" style="color: #666666;">
                    References</a>&nbsp;>&nbsp; <a class="lnk" href="multi.aspx?id=10"
                        style="color: #666666;">Settlement Attorney</a>&nbsp;>&nbsp;
                <asp:Label ID="lblTitle" runat="server" Style="color: #666666;"></asp:Label>
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
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="top" style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" style="float: left;
                                            font-family: Tahoma; font-size: 11px; width: 100%">
                                            <tr>
                                                <td class="headitem2" colspan="2" height="20px" style="padding: 0 0 0 5; font-weight: bold;
                                                    font-size: 11px">
                                                    Settlement Attorney Information
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 5 5 0 5; width: 50%" nowrap>
                                                    Firm Name:<br />
                                                    <input type="text" class="entry" id="txtFirmName" runat="server" />
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5; width: 50%">
                                                    Short Name:<br />
                                                    <input id="txtShortName" runat="server" class="entry" type="text" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    Contact First Name:<br />
                                                    <input id="txtContactFName" runat="server" class="entry" type="text" />
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    Last Name:<br />
                                                    <input id="txtContactLName" runat="server" class="entry" type="text" />
                                                </td>
                                                <tr>
                                                    <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                        <asp:Label ID="lblSig" runat="server" CssClass="srefEntry" Text="Signature:"></asp:Label>&nbsp;<br />
                                                        <asp:FileUpload ID="SigUpload" runat="server" CssClass="entry" />
                                                    </td>
                                                    <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                        Web site:<br />
                                                        <asp:TextBox ID="txtWebsite" CssClass="entry" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                        Login Name:&nbsp;<asp:HyperLink ID="lnkUserId" runat="server" Visible="false"></asp:HyperLink>
                                                        <br />
                                                        <input id="txtUserName" runat="server" class="entry" type="text" visible="false" />
                                                    </td>
                                                    <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                        </table>
                                    </td>
                                    <td style="width: 10"></td>
                                    <td style="width: auto" valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" style="float: left;
                                            font-family: Tahoma; font-size: 11px; width: 100%">
                                            <tr>
                                                <td class="headitem2" colspan="2" height="20px" style="padding: 0 0 0 5; font-weight: bold;
                                                    font-size: 11px">
                                                    Audit Trail
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5; width: 25%">
                                                    Created:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5; width: 75%">
                                                    <asp:Label ID="lblCreated" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    Created By:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    <asp:Label ID="lblCreatedBy" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    Last Modified:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    <asp:Label ID="lblLastModified" runat="server" CssClass="srefEntry">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
                                                    Last Modified By:
                                                </td>
                                                <td nowrap="nowrap" style="padding: 5 5 0 5">
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
                    <%--Employed Attorneys--%>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnlEAtty" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px">
                                            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px;" width="100%">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Employed Attorneys:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblEAtty" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px; width: 100%">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td align="left" class="headItem2" nowrap="nowrap" style="width: 150">
                                                                    First Name
                                                                </td>
                                                                <td align="left" class="headItem2" nowrap="nowrap" style="width: 30">
                                                                    MI
                                                                </td>
                                                                <td class="headItem2" nowrap="nowrap" style="width: 150">
                                                                    Last Name
                                                                </td>
                                                                <td class="headItem2" style="width: 50">
                                                                    State
                                                                </td>
                                                                <td class="headItem2" style="width: 150">
                                                                    State Bar #
                                                                </td>
                                                                <td class="headItem2" style="width: 50" align="center">
                                                                    Principle
                                                                </td>
                                                                <td class="headItem2" style="width: auto">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddEAttorneys();" style="color: rgb(51,118,171);">
                                                            <img id="img5" runat="server" align="absmiddle" border="0" src="~/images/16x16_person.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Employed Attorney</a><br />
                                                        <input id="hdnAttorneys" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--Attorney Address--%>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="PnlContent" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 15;
                                                font-family: tahoma; font-size: 11px;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Address Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblAddresses" runat="server" border="0" cellpadding="5" cellspacing="0"
                                                            style="margin-bottom: 10; font-family: tahoma; font-size: 11px; width: 100%;">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16">
                                                                    &nbsp;</td>
                                                                <td class="headItem2">
                                                                    Address Type
                                                                </td>
                                                                <td class="headItem2">
                                                                    Street Address 1
                                                                </td>
                                                                <td class="headItem2">
                                                                    Street Address 2
                                                                </td>
                                                                <td class="headItem2" style="width: 100">
                                                                    City
                                                                </td>
                                                                <td class="headItem2" style="width: 50">
                                                                    State
                                                                </td>
                                                                <td class="headItem2" style="width: 100">
                                                                    Zip Code
                                                                </td>
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
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <%--Phones--%>
                                    <td>
                                        <asp:Panel ID="pnlPhones" runat="server" CssClass="collapsePanel" Height="0px">
                                            <table border="0" cellpadding="0" cellspacing="2" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px; width: 100%;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        Phone Information:</td>
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
                                                                <td class="headItem2">
                                                                    Number</td>
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
                                    <%--State Bar Information Starts here--%>
                                    <!--<td style="width: 50%" valign="top">
                                        <asp:Panel ID="pnlBarContent" runat="server" CssClass="collapsePanel" Height="0px"
                                            Width="100%">
                                            <table border="0" cellpadding="0" cellspacing="2" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px; width: 100%;">
                                                <tr>
                                                    <td style="line-height: 24px; font-weight: bold">
                                                        State Bar Information:</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblStateBar" runat="server" border="0" cellpadding="5" cellspacing="0"
                                                            style="margin-bottom: 10; font-family: tahoma; font-size: 11px; width: 100%;">
                                                            <tr>
                                                                <td class="headItem2" style="width: 16;">
                                                                    &nbsp;</td>
                                                                <td class="headItem2" style="width: 50">
                                                                    State</td>
                                                                <td class="headItem2">
                                                                    State Bar Number</td>
                                                            </tr>
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddStateBar();" style="color: rgb(51,118,171);">
                                                            <img id="img3" runat="server" align="absmiddle" border="0" src="~/images/16x16_scale.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add State Bar Number(s)</a><br />
                                                        <input id="txtStateBars" runat="server" type="hidden" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>-->
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--Banking information--%>
                    <tr id="rowBanking" runat="server">
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnlBank" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px" Width="100%">
                                            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px;" width="100%">
                                                <tr>
                                                    <td style="line-height: 24px;">
                                                        <strong>Banking Information:</strong>&nbsp;&nbsp;<a id="aShowBankingFields" runat="server" href="javascript:ShowBankFields();" class="lnk" visible="false"><u>Show Fields</u></a></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblBanks" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px">
                                                        </table>
                                                        <a class="lnk" href="javascript:Record_AddBanks();" style="color: rgb(51,118,171);">
                                                            <img id="img2" runat="server" align="absmiddle" border="0" src="~/images/16x16_entrytype.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add Bank Information</a><br />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--FTP Information--%>
                    <tr id="rowFTP" runat="server">
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" class="srefTable" width="100%">
                                <tr>
                                    <td>
                                        <asp:Panel ID="pnlFTPContent" runat="server" CssClass="collapsePanel" Font-Names="Tahoma"
                                            Font-Size="11px" Width="100%">
                                            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 15; font-family: tahoma;
                                                font-size: 11px;" width="100%">
                                                <tr>
                                                    <td style="line-height: 24px;">
                                                        <strong>FTP Information:</strong>&nbsp;&nbsp;<a id="aShowFTPFields" runat="server" class="lnk" href="javascript:ShowFTPFields();" visible="false"><u>Show
                                                            Fields</u></a></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table id="tblFTP" runat="server" border="0" cellpadding="5" cellspacing="0" style="margin-bottom: 10;
                                                            font-family: tahoma; font-size: 11px">
                                                        </table>
                                                        <!--<a class="lnk" href="javascript:Record_AddFTP();" style="color: rgb(51,118,171);">
                                                            <img id="img4" runat="server" align="absmiddle" border="0" src="~/images/16x16_trust.png"
                                                                style="margin-left: 8; margin-right: 8;" />Add FTP Information</a><br />-->
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
    <asp:DropDownList ID="ddlAddressTypes" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlStates" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlAccountType" runat="server" Style="display: none" />
    <asp:TextBox ID="txtStreet1" runat="server" Style="display: none" />
    <asp:TextBox ID="txtStreet2" runat="server" Style="display: none" />
    <asp:TextBox ID="txtCity" runat="server" Style="display: none" />
    <asp:DropDownList ID="ddlCity" runat="server" Style="display: none" />
    <asp:TextBox ID="txtZip" runat="server" Style="display: none" />
    <asp:HiddenField ID="hdnAttornies" runat="server" />
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
    <asp:LinkButton ID="lnkGetAssocAttys" runat="server" />
    <asp:LinkButton ID="lnkGetAttyList" runat="server" />
    <input type="hidden" id="hdnCompanyID" runat="server" />
    <input id="hdnBankInfo" runat="server" type="hidden" />
    <input id="hdnFTPInfo" runat="server" type="hidden" />
</asp:Content>
