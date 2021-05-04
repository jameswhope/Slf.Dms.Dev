<%@ Control Language="VB" AutoEventWireup="false" CodeFile="26.ascx.vb" Inherits="tasks_workflows_26" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Reference Page="~/tasks/task/resolve.aspx" %>
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

<script>

    var tblBody = null;
    var tblMessage = null;
 
    var txtPhone=null;
    var ddlLDocument = null;
    var txtAmmount=null;
    var txtDateClientReceivedDocument = null;
    var cmbRecType = null;

    var cmbplaintiff = null;
    var cmbAmtDispute = null;
 
    var cmbWorking = null;
    //var cmbAccount = null;
    var cmbBankAcc = null;
    var cmbAssets = null;
    var chkLegalServices = null;
    var chkLocalCounsel = null;
    var txtSDADesc = null;
    //real estate
    var cmbResidence = null;
    var txtOwnyears = null;
    var chkMarketVal = null;
    var txtMarketVal = null;
    var txtPayoff = null;
    var cmbLiens = null;
    var txtEquity = null;
    var cmbPayments = null;
    var txtTotalPeople = null;
    var cmbResidence2 = null;
    var txtOwnyears2 = null;
    var chkMarketVal2 = null;
    var txtMarketVal2 = null;
    var txtPayoff2 = null;
    var cmbLiens2 = null;
    var txtEquity2 = null;
    var cmbPayments2 = null;
    var txtTotalPeople2 = null;
    //income
    var cmbSelfEmp=null;
    var txtEmployer = null;
    var txtExpAtEmployer = null;
     var txtExpAtEmployerMonths = null;
    var txtTakeHome = null;
    var cmbPer = null;
    var cmbWage = null;
    var txtOtherIncome = null;

    //no income
    var cmbAid = null;
  
    
   //accounts
    var txtBankName = null;
    var txtSource = null;
    var txtBalance = null;
    var radAccountType =null;
   // var txtBankName2 = null;
   // var txtSource2 = null;
    //var txtBalance2 = null;
    var txtLevies1=null;
    var txtAssets=null;
    
    var cmbVerifiedBy = null;
    var cmbFeepaidtype = null;

    var dvError = null;
    var tdError = null;
        var txtGarnishmentVal=null;
        
         var txtr1=null;
    var txtr2=null;
    var txtr3=null;
    var txtr4=null;
    var chkr1=null;
    var chkr2=null;
    var chkr3=null;
    var chkr4=null;
    
    function AddressBook()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/addressbookholder.aspx") %>?id=<%=ClientID %>", window, "status:off;help:off;dialogWidth:450px;dialogHeight:350px;");
    }
    
    function SetInfo(PersonID, Number)
    {
        var txtPhoneNumber = document.getElementById("<%= txtPhone.ClientID %>");

        txtPhoneNumber.value = Number;

    }
    
    function Record_Save() {//SavePostJudgmentIntake() {
     
          document.getElementById("<%=hdnTaskResolutionID.ClientID %>").value = cboParentTaskResolutionID.value
        document.getElementById("<%=txtResolved.ClientID %>").value = txtResolved.value
        LoadControls(); 
        if (RequiredExist()) { 
  <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;

        }
    }
   function LoadControls() {
        if (ddlLDocument == null) {
           
            txtPhone=document.getElementById("<%= txtPhone.ClientID %>");
            txtAmmount=document.getElementById("<%= txtAmmount.ClientID %>");
            ddlLDocument = document.getElementById("<%= ddlLDocument.ClientID %>");
            txtDateClientReceivedDocument = document.getElementById("<%= txtDateClientReceivedDocument.ClientID %>");
            cmbRecType = document.getElementById("<%= cmbRecType.ClientID %>");

            cmbplaintiff = document.getElementById("<%= cmbplaintiff.ClientID %>");
            cmbAmtDispute = document.getElementById("<%= cmbAmtDispute.ClientID %>");
             
            cmbWorking = document.getElementById("<%= cmbWorking.ClientID %>");
            cmbBankAcc = document.getElementById("<%= cmbBankAcc.ClientID %>");
            cmbAssets = document.getElementById("<%= cmbAssets.ClientID %>");
            chkLegalServices = document.getElementById("<%= chkLegalServices.ClientID %>");
            chkLocalCounsel = document.getElementById("<%= chkLocalCounsel.ClientID %>");
            txtSDADesc = document.getElementById("<%= txtSDADesc.ClientID %>");

            //real estate
            cmbResidence = document.getElementById("<%= cmbResidence.ClientID %>");
            txtOwnyears = document.getElementById("<%= txtOwnyears.ClientID %>");
            txtMarketVal = document.getElementById("<%= txtMarketVal.ClientID %>");
            txtPayoff = document.getElementById("<%= txtPayoff.ClientID %>");
            cmbLiens = document.getElementById("<%= cmbLiens.ClientID %>");
            txtEquity = document.getElementById("<%= txtEquity.ClientID %>");
            cmbPayments = document.getElementById("<%= cmbPayments.ClientID %>");
            txtTotalPeople = document.getElementById("<%= txtTotalPeople.ClientID %>");
            cmbResidence2 = document.getElementById("<%= cmbResidence2.ClientID %>");
            txtOwnyears2 = document.getElementById("<%= txtOwnyears2.ClientID %>");
            txtMarketVal2 = document.getElementById("<%= txtMarketVal2.ClientID %>");
            txtPayoff2 = document.getElementById("<%= txtPayoff2.ClientID %>");
            cmbLiens2 = document.getElementById("<%= cmbLiens2.ClientID %>");
            txtEquity2 = document.getElementById("<%= txtEquity2.ClientID %>");
            cmbPayments2 = document.getElementById("<%= cmbPayments2.ClientID %>");
            txtTotalPeople2 = document.getElementById("<%= txtTotalPeople2.ClientID %>");

            //income
            cmbSelfEmp =  document.getElementById("<%= cmbSelfEmp.ClientID %>");
            txtEmployer = document.getElementById("<%= txtEmployer.ClientID %>");
            txtExpAtEmployer = document.getElementById("<%= txtExpAtEmployer.ClientID %>");
            txtExpAtEmployerMonths = document.getElementById("<%= txtExpAtEmployerMonths.ClientID %>");
            txtLevies1 = document.getElementById("<%= txtLevies1.ClientID %>");
            
            txtTakeHome = document.getElementById("<%= txtTakeHome.ClientID %>");
            cmbPer = document.getElementById("<%= cmbPer.ClientID %>");
            cmbWage = document.getElementById("<%= cmbWage.ClientID %>");
            txtOtherIncome = document.getElementById("<%= txtOtherIncome.ClientID %>");
            
            //no income
            cmbAid = document.getElementById("<%= cmbAid.ClientID %>");
         

            //accounts
            txtBankName = document.getElementById("<%= txtBankName.ClientID %>");
            txtSource = document.getElementById("<%= txtSource.ClientID %>");
            txtBalance = document.getElementById("<%= txtBalance.ClientID %>");
            radAccountType = document.getElementById("<%= radAccountType.ClientID %>");
            //txtBankName2 = document.getElementById("<%= txtBankName2.ClientID %>");
           // txtSource2 = document.getElementById("<%= txtSource2.ClientID %>");
            //txtBalance2 = document.getElementById("<%= txtBalance2.ClientID %>");
            
            cmbFeepaidtype = document.getElementById("<%= cmbFeepaidtype.ClientID %>");
            cmbVerifiedBy = document.getElementById("<%= cmbVerifiedBy.ClientID %>");

            txtAssets=document.getElementById("<%= txtAssets.ClientID %>");
            dvError = document.getElementById("<%= dvError.ClientID %>");
            tdError = document.getElementById("<%= tdError.ClientID %>");
            
            tblBody = document.getElementById("<%= tblBody.ClientID %>");
                txtGarnishmentVal= document.getElementById("<%= txtGarnishmentVal.ClientID %>");
                
                   txtr1=document.getElementById("<%= txtr1.ClientID %>");
            txtr2=document.getElementById("<%= txtr2.ClientID %>");
            txtr3=document.getElementById("<%= txtr3.ClientID %>");
            txtr4=document.getElementById("<%= txtr4.ClientID %>");
      
           chkr1=document.getElementById("<%= chkr1.ClientID %>");
           chkr2=document.getElementById("<%= chkr2.ClientID %>");
           chkr3=document.getElementById("<%= chkr3.ClientID %>");
           chkr4=document.getElementById("<%= chkr4.ClientID %>");
            
        }
    }

    function RequiredExist() {
    
        RemoveBorder(txtAmmount);
    
        RemoveBorder(ddlLDocument);
        RemoveBorder(txtDateClientReceivedDocument);
        RemoveBorder(cmbRecType);

        RemoveBorder(cmbplaintiff);
        RemoveBorder(cmbAmtDispute);
         
        RemoveBorder(cmbWorking);
        //RemoveBorder(cmbAccount);
        RemoveBorder(cmbBankAcc);
        RemoveBorder(cmbAssets);
        RemoveBorder(chkLegalServices);
        RemoveBorder(chkLocalCounsel);
        RemoveBorder(txtSDADesc);
        //real estate
        RemoveBorder(cmbResidence);
        RemoveBorder(txtOwnyears);
        RemoveBorder(txtMarketVal);
        RemoveBorder(txtPayoff);
        RemoveBorder(cmbLiens);
        RemoveBorder(txtEquity);
        RemoveBorder(cmbPayments);
        RemoveBorder(txtTotalPeople);
        RemoveBorder(cmbResidence2);
        RemoveBorder(txtOwnyears2);
        RemoveBorder(txtMarketVal2);
        RemoveBorder(txtPayoff2);
        RemoveBorder(cmbLiens2);
        RemoveBorder(txtEquity2);
        RemoveBorder(cmbPayments2);
        RemoveBorder(txtTotalPeople2);
        //income
        
        RemoveBorder(cmbSelfEmp);
        RemoveBorder(txtEmployer);
        RemoveBorder(txtExpAtEmployer);
        RemoveBorder(txtExpAtEmployerMonths );
        
        
        RemoveBorder(txtTakeHome);
        RemoveBorder(cmbPer);
        RemoveBorder(cmbWage);
        RemoveBorder(txtOtherIncome);

        //no income
        RemoveBorder(cmbAid);
      

        //accounts
        RemoveBorder(txtBankName);
        RemoveBorder(txtSource);
        RemoveBorder(txtBalance);
        RemoveBorder(radAccountType);
        //RemoveBorder(txtBankName2);
        //RemoveBorder(txtSource2);
        //RemoveBorder(txtBalance2);
        RemoveBorder(txtAssets);
  
        RemoveBorder(cmbVerifiedBy);
        RemoveBorder(cmbFeepaidtype);
        RemoveBorder(txtPhone);
        RemoveBorder(txtLevies1);
           //alert(document.getElementById("<%= cmbRental2.ClientID %>"))//"<%= tblBody.ClientID %>
          RemoveBorder(document.getElementById("<%= cmbRental2.ClientID %>"));
            RemoveBorder(document.getElementById("<%= txtRent2.ClientID %>"));
            
              RemoveBorder( txtGarnishmentVal);
              
               RemoveBorder( txtr1 );
              RemoveBorder( txtr2 );
              RemoveBorder( txtr3 );
              RemoveBorder( txtr4);
           
     
          if (txtPhone.value == null || txtPhone.value.length == 0) {
            ShowMessage("Primary phone is a required field");
            AddBorder(txtPhone);
            return false;
        }
 
        if (ddlLDocument.value == null || ddlLDocument.value == "") {
            ShowMessage("Litigation Document is a required field");
            AddBorder(ddlLDocument);
            return false;
        }
        /*if (!RegexValidate(txtDateClientReceivedDocument.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$")) {
            ShowMessage("The date you entered is invalid.  Please enter a new value.");
            AddBorder(txtDateClientReceivedDocument);
            return false;
        }
        else {
            RemoveBorder(txtDateClientReceivedDocument);
        }*/
        if (txtDateClientReceivedDocument.value == "") {
            ShowMessage("Date client received document is a required field");
            AddBorder(txtDateClientReceivedDocument);
            return false;
        }
        if (txtAmmount.value == null || txtAmmount.value.length == 0) {
            ShowMessage("Lawsuit amount is a required field");
            AddBorder(txtAmmount);
            return false;
        }
        if (cmbRecType.value == "") {
            ShowMessage("How documents received is a required field");
            AddBorder(cmbRecType);
            return false;
        }
        
         
         
       /* if (cmbAmtDispute.value == "") {
            ShowMessage("do you dispute amount is a required field");
            AddBorder(cmbAmtDispute);
            return false;
        }*/
        
          if (cmbResidence.value == "") {
                ShowMessage("Do you own any real estate");//Is it your residence is a required field
                AddBorder(cmbResidence);
                return false;
            }
            if (cmbResidence.value == "Yes") 
            {
                    if (txtOwnyears.value == null || txtOwnyears.value.length == 0) {
                        ShowMessage("How long have you owned it is a required field");
                        AddBorder(txtOwnyears);
                        return false;
                    } 
                    if (!document.getElementById("<%=chkMarketVal.ClientID%>").checked) 
                    {
                        if (txtMarketVal.value == null || txtMarketVal.value.length == 0) {
                            ShowMessage("Approximate fair market value is a required field");
                            AddBorder(txtMarketVal);
                            return false;
                        } 
                    }
                if (txtPayoff.value == null || txtPayoff.value.length == 0) {
                    ShowMessage("What is the payoff is a required field");
                    AddBorder(txtPayoff);
                    return false;
                }
                if (cmbLiens.value == "") {
                    ShowMessage("Any liens on property is a required field");
                    AddBorder(cmbLiens);
                    return false;
                }
                if (txtEquity.value == null || txtEquity.value.length == 0) {
                    ShowMessage("Total equity is a required field");
                    AddBorder(txtEquity);
                    return false;
                } if (cmbPayments.value.length == 0) {
                ShowMessage("House payment current is a required field");
                    AddBorder(cmbPayments);
                    return false;
                } if (txtTotalPeople.value == null || txtTotalPeople.value.length == 0) {
                ShowMessage("How many people live there is a required field");
                    AddBorder(txtTotalPeople);
                    return false;
                }
            }
            else   if (cmbResidence.value == "No")  
            {
                if(document.getElementById("<%=cmbRental1.ClientID%>").value=="")
                {
                 ShowMessage("Is this a rental property is a required field");
                 AddBorder(document.getElementById("<%=cmbRental1.ClientID%>"));
                    return false;
                }
                else if(document.getElementById("<%=cmbRental1.ClientID%>").value=="Yes")
                {
                    if(document.getElementById("<%=txtRent1.ClientID%>").value=="")
                    {
                     ShowMessage("How much is the rent is a required field");
                 AddBorder(document.getElementById("<%=txtRent1.ClientID%>"));
                    return false;
                    }
                }
            }
            
            
             if (cmbResidence.value != "") {
            

                       if (cmbResidence2.value == "") {
                            ShowMessage("Do you own additional property is a required field");
                            AddBorder(cmbResidence2);
                            return false;
                        }
                if (cmbResidence2.value == "Yes") {
                      if(document.getElementById("<%=cmbRental2.ClientID%>").value=="")
                        {
                         ShowMessage("Is this a rental property is a required field");
                         AddBorder(document.getElementById("<%=cmbRental2.ClientID%>"));
                            return false;
                        }
                        else if(document.getElementById("<%=cmbRental2.ClientID%>").value=="Yes")
                        {
                            if(document.getElementById("<%=txtRent2.ClientID%>").value=="")
                            {
                                ShowMessage("How much is the rent is a required field");
                                AddBorder(document.getElementById("<%=txtRent2.ClientID%>"));
                                return false;
                            }
                        }
                       else if(document.getElementById("<%=cmbRental2.ClientID%>").value=="No")
                       {
             
                            if (txtOwnyears2.value == null || txtOwnyears2.value.length == 0) {
                            ShowMessage("How long have you owned it is a required field");
                            AddBorder(txtOwnyears2);
                            return false;
                            } 
                        
                            if (!document.getElementById("<%=chkMarketVal2.ClientID%>").checked) 
                            {
                                if (txtMarketVal2.value == null || txtMarketVal2.value.length == 0) {
                                    ShowMessage("Approximate fair market value is a required field");
                                    AddBorder(txtMarketVal2);
                                    return false;
                                } 
                            }
            
                            if (txtPayoff2.value == null || txtPayoff2.value.length == 0) {
                                ShowMessage("What is the payoff is a required field");
                                AddBorder(txtPayoff2);
                                return false;
                            }
                            if (cmbLiens2.value == "") {
                                ShowMessage("Any liens on property is a required field");
                                AddBorder(cmbLiens2);
                                return false;
                            }
                            if (txtEquity2.value == null || txtEquity2.value.length == 0) {
                                ShowMessage("Total equity is a required field");
                                AddBorder(txtEquity2);
                                return false;
                            } if (cmbPayments2.value.length == 0) {
                                ShowMessage("Are you current on house payments is a required field");
                                AddBorder(cmbPayments2);
                                return false;
                            } if (txtTotalPeople2.value == null || txtTotalPeople2.value.length == 0) {
                                ShowMessage("How many people live there is a required field");
                                AddBorder(txtTotalPeople2);
                                return false;
                            } 
                        }
             
                }
                }
            
        
        if (cmbWorking.value == "") {
            ShowMessage("Are you working is a required field");
            AddBorder(cmbWorking);
            return false;
        }
        if (cmbWorking.value == "Yes") {

            if (cmbSelfEmp.value == "") {
                ShowMessage("Are you self employed is a required field");
                AddBorder(cmbSelfEmp);
                return false;
            }
            
            if (txtEmployer.value == null || txtEmployer.value.length == 0) {
                ShowMessage("Employer is a required field");
                AddBorder(txtEmployer);
                return false;
            }

            if ( txtExpAtEmployer.value.length == 0 && txtExpAtEmployerMonths.value.length == 0) {
                ShowMessage("length of employment is a required field");
                AddBorder(txtExpAtEmployer);
                return false;
            }
            if (txtTakeHome.value == null || txtTakeHome.value.length == 0) {
                ShowMessage("Take home pay is a required field");
                AddBorder(txtEmployer);
                return false;
            }

            if (cmbPer.value == "") {
                ShowMessage("Per is a required field");
                AddBorder(cmbPer);
                return false;
            }

            if (cmbWage.value== "") {
                ShowMessage("any wage garnishments is a required field");
                AddBorder(cmbWage);
                return false;
            }
              if(cmbWage.value=="Yes")
            {
                if(txtGarnishmentVal.value =="")
                {
                  ShowMessage("garnishments info is a required field");
                    AddBorder(txtGarnishmentVal);
                    return false;
                }
            }
            
            if (txtOtherIncome.value == null || txtOtherIncome.value.length == 0) {
                ShowMessage(" Other sources of income is a required field");
                AddBorder(txtOtherIncome);
                return false;
            }
        }
        else if (cmbWorking.value == "No") {

        if (cmbAid.value == "") {
            ShowMessage("Receiving any type of Aid is a required field");
            AddBorder(cmbAid);
            return false;
        }
         if (cmbAid.value == "Yes") 
         {
             if(chkr1.checked)
            {
                if (txtr1.value == "") {
            ShowMessage("Amount is a required field");
            AddBorder(txtr1);
            return false;
        }
            } 
            
             if(chkr2.checked)
            {
                if (txtr2.value == "") {
            ShowMessage("Amount is a required field");
            AddBorder(txtr2);
            return false;
        }
            } 
             if(chkr3.checked)
            {
                if (txtr3.value == "") {
            ShowMessage("Amount is a required field");
            AddBorder(txtr3);
            return false;
        }
            } 
             if(chkr4.checked)
            {
                if (txtr4.value == "") {
            ShowMessage("Amount is a required field");
            AddBorder(txtr4);
            return false;
        }
            } 
            
            
            
    //var len =cmbAidType.length;
  
   // var i =document.getElementById(cmbAidType).selectedIndex
//        var itemselected =0;
//        for (var i=0; i<len ; i++)
//        {
//            if(cmbAidType.options[i].selected==true)
//            {
//                itemselected =1;
//                break ;
//            }
//        }
//        if(itemselected==0)
//        {
//             ShowMessage("Aid type is a required field");
//             AddBorder(cmbAidType);
//             return false;
//        } 
            
            
            
         }
        }
        
//        if (cmbAccount.value == "") {
//            ShowMessage("Name on ant account over $500 is a required field");
//            AddBorder(cmbAccount);
//            return false;
//        }

        if (cmbBankAcc.value == "") {
            ShowMessage("Do you have bank accounts is a required field");
            AddBorder(cmbBankAcc);
            return false;
        }

        if (cmbBankAcc.value == "Yes") {
            if (txtBankName.value == null || txtBankName.value.length == 0) {
                ShowMessage(" Name of the bank is a required field");
                AddBorder(txtBankName);
                return false;
            }
            if (txtSource.value == null || txtSource.value.length == 0) {
                ShowMessage("  Source of money deposited in account is a required field");
                AddBorder(txtSource);
                return false;
            }
            if (txtBalance.value == null || txtBalance.value.length == 0) {
                ShowMessage(" Approximate balance in account is a required field");
                AddBorder(txtBalance);
                return false;
            }
           
            if(document.getElementById("ctl00_cphBody_ctl12_radAccountType_0").checked ==false && document.getElementById("ctl00_cphBody_ctl12_radAccountType_1").checked ==false && document.getElementById("ctl00_cphBody_ctl12_radAccountType_2").checked==false)
            {
                ShowMessage(" Account type is a required field");
                AddBorder(document.getElementById("ctl00_cphBody_ctl12_radAccountType_0"));
                return false;
            }
            if (txtLevies1.value == null || txtLevies1.value.length == 0) {
                ShowMessage(" Income Levies is a required field");
                AddBorder(txtLevies1);
                return false;
            }
          /*  if (txtBankName2.value == null || txtBankName2.value.length == 0) {
                ShowMessage("At what bank is a required field");
                AddBorder(txtBankName2);
                return false;
            }
            if (txtSource2.value == null || txtSource2.value.length == 0) {
                ShowMessage("  Source of money deposited in account is a required field");
                AddBorder(txtSource2);
                return false;
            }
            if (txtBalance2.value == null || txtBalance2.value.length == 0) {
                ShowMessage(" Approximate balance in account is a required field");
                AddBorder(txtBalance2);
                return false;
            }*/

           
            
        
        }
        
        
        
        if (cmbAssets.value == "") {
            ShowMessage("Do you have other assets is a required field");
            AddBorder(cmbAssets);
            return false;
        }
        if (cmbAssets.value == "Yes") {
         if (txtAssets.value == null || txtAssets.value.length == 0) {
                ShowMessage("Assets is a required field");
                AddBorder(txtAssets);
                return false;
            }
        }


        if (chkLegalServices.checked) {
            if (cmbVerifiedBy.value == "") {
            ShowMessage("Verified by is a required field");
            AddBorder(cmbVerifiedBy);
            return false;
        }
        }
        
        if (cmbplaintiff.value == "") {
            ShowMessage("Is plaintiff a collection company a required field");
            AddBorder(cmbplaintiff);
            return false;
        }
        
         if (chkLocalCounsel.checked) {
             if (cmbFeepaidtype.value == "") {
                 ShowMessage("Local counsel fees to be paid by is a required field");
                 AddBorder(cmbFeepaidtype);
                 return false;
             }
        }
        

        if (txtSDADesc.value == null || txtSDADesc.value.length == 0) {
            ShowMessage("Notes is a required field");
            AddBorder(txtSDADesc);
            return false;
        }
        HideMessage() 
        return true;
    }


    function AddBorder(obj) {
        obj.style.border = "solid 2px red";
        obj.focus();
    }
    function RemoveBorder(obj) {
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
    }


    function ShowMessage(Value) {
        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage() {
        tdError.innerHTML = "";
        dvError.style.display = "none";
    }
    function RegexValidate(Value, Pattern) {
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0) {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else {
            return false;
        }
    }


    function ShowIncome() {
        if (document.getElementById("<%=cmbWorking.ClientID%>").value == "Yes") {
            document.getElementById("<%=tabIncome.ClientID%>").style.display = "block"
            document.getElementById("<%=tabNoIncome.ClientID%>").style.display = "none"
                //document.getElementById("dvr").style.display = "none"
                 ShowAid() 
        }
        else if (document.getElementById("<%=cmbWorking.ClientID%>").value == "No") {
            document.getElementById("<%=tabIncome.ClientID%>").style.display = "none"
            document.getElementById("<%=tabNoIncome.ClientID%>").style.display = "block"
               //document.getElementById("dvr").style.display = "block"
             ShowAid() 
        }
        else {
            document.getElementById("<%=tabIncome.ClientID%>").style.display = "none"
            document.getElementById("<%=tabNoIncome.ClientID%>").style.display = "none"
                document.getElementById("dvr").style.display = "none"
        }
    }
    function ShowAid() {
        if (document.getElementById("<%=cmbAid.ClientID%>").value == "Yes") {
            document.getElementById("dvr").style.display = "block"
        }
        else {
            document.getElementById("dvr").style.display = "none"
        }
    }

   
    function ShowBankAcc() {
        if (document.getElementById("<%=cmbBankAcc.ClientID%>").value == "Yes") {
            document.getElementById("<%=tabBankAcc.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=tabBankAcc.ClientID%>").style.display = "none"
        }
    }
    function ShowVerified() {
        if (document.getElementById("<%=chkLegalServices.ClientID%>").checked) {
            document.getElementById("<%=dvVerifiedBy1.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=dvVerifiedBy1.ClientID%>").style.display = "none"
        }
    }
    function ShowLocalCouncel() {
        if (document.getElementById("<%=chkLocalCounsel.ClientID%>").checked) {
            document.getElementById("<%=dvLocalCounsel1.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=dvLocalCounsel1.ClientID%>").style.display = "none"
        }
    }
    
    function ShowAssets()
    {
     if (document.getElementById("<%=cmbAssets.ClientID%>").value == "Yes") {
            document.getElementById("<%=dvAssets.ClientID%>").style.display = "block"
            document.getElementById("<%=dvAssets1.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=dvAssets.ClientID%>").style.display = "none"
            document.getElementById("<%=dvAssets1.ClientID%>").style.display = "none"
            
        }
    }
     function ShowResidence2()
    {
     if (document.getElementById("<%=cmbResidence2.ClientID%>").value == "Yes") {
           // document.getElementById("<%=tabPro2.ClientID%>").style.display = "block"
            document.getElementById("<%=tabPro2No.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=tabPro2.ClientID%>").style.display = "none"
            document.getElementById("<%=tabPro2No.ClientID%>").style.display = "none"
            
        }
        document.getElementById("<%=cmbRental2.ClientID%>").value=""
          document.getElementById("<%=dv1p2.ClientID%>").style.display = "none"
            document.getElementById("<%=dv2p2.ClientID%>").style.display = "none"
//       if (document.getElementById("<%=cmbResidence2.ClientID%>").value == "Yes") {
//            document.getElementById("<%=tabPro2.ClientID%>").style.display = "block"
//            document.getElementById("<%=tabPro2No.ClientID%>").style.display = "none"
//        }
//        else {
//            document.getElementById("<%=tabPro2.ClientID%>").style.display = "none"
//            document.getElementById("<%=tabPro2No.ClientID%>").style.display = "block"
//            
//        }
    }
    function ShowResidence1()
    {
    
    //tabREstate
       if (document.getElementById("<%=cmbResidence.ClientID%>").value == "Yes") {
            document.getElementById("<%=tabPro1.ClientID%>").style.display = "block"
            document.getElementById("<%=tabPro1No.ClientID%>").style.display = "none"
        
            
        }
        else {
            document.getElementById("<%=tabPro1.ClientID%>").style.display = "none"
            document.getElementById("<%=tabPro1No.ClientID%>").style.display = "block" 
        }
        
          if (document.getElementById("<%=cmbResidence.ClientID%>").value != "") {
          
        //  tabREstate
        
          }else
          {
        
          }
        
    }
    function ShowRental1()
    {
    if (document.getElementById("<%=cmbRental1.ClientID%>").value == "Yes") {
            document.getElementById("<%=dv1p1.ClientID%>").style.display = "block"
            document.getElementById("<%=dv2p1.ClientID%>").style.display = "block"
        }
        else {
            document.getElementById("<%=dv1p1.ClientID%>").style.display = "none"
            document.getElementById("<%=dv2p1.ClientID%>").style.display = "none"
            
        }
    }
       function ShowRental2()
    {
    if (document.getElementById("<%=cmbRental2.ClientID%>").value == "Yes") {
            document.getElementById("<%=dv1p2.ClientID%>").style.display = "block"
            document.getElementById("<%=dv2p2.ClientID%>").style.display = "block"
            
            document.getElementById("<%=tabPro2.ClientID%>").style.display = "none"
        }
        else if (document.getElementById("<%=cmbRental2.ClientID%>").value == "No"){
            document.getElementById("<%=dv1p2.ClientID%>").style.display = "none"
            document.getElementById("<%=dv2p2.ClientID%>").style.display = "none"
            document.getElementById("<%=tabPro2.ClientID%>").style.display = "block"
            
        }  else if (document.getElementById("<%=cmbRental2.ClientID%>").value == ""){
         document.getElementById("<%=tabPro2.ClientID%>").style.display = "none"
          document.getElementById("<%=dv1p2.ClientID%>").style.display = "none"
            document.getElementById("<%=dv2p2.ClientID%>").style.display = "none"
         
        }
    }
    
    function ShowIR()
    {
         if (document.getElementById("<%=cmbAid.ClientID%>").value == "Yes") {
            document.getElementById("dvr").style.display = "block"
        }
        else {
            document.getElementById("dvr").style.display = "none"
        }
    }
    function ShowAmount(i)
    {
        if(i==1)
        {
            if(document.getElementById('<%=chkr1.ClientID %>').checked== true)
            {
                 document.getElementById("dvr1").style.display = "block"
            } 
           else  if(document.getElementById('<%=chkr1.ClientID %>').checked== false)
            {
                 document.getElementById("dvr1").style.display = "none"
            } 
        }
        else    if(i==2)
        {
            if(document.getElementById('<%=chkr2.ClientID %>').checked== true)
            {
                 document.getElementById("dvr2").style.display = "block"
            } 
           else  if(document.getElementById('<%=chkr2.ClientID %>').checked== false)
            {
                 document.getElementById("dvr2").style.display = "none"
            } 
        }
          else    if(i==3)
        {
            if(document.getElementById('<%=chkr3.ClientID %>').checked== true)
            {
                 document.getElementById("dvr3").style.display = "block"
            } 
           else  if(document.getElementById('<%=chkr3.ClientID %>').checked== false)
            {
                 document.getElementById("dvr3").style.display = "none"
            } 
        }  else    if(i==4)
        {
            if(document.getElementById('<%=chkr4.ClientID %>').checked== true)
            {
                 document.getElementById("dvr4").style.display = "block"
            } 
           else  if(document.getElementById('<%=chkr4.ClientID %>').checked== false)
            {
                 document.getElementById("dvr4").style.display = "none"
            } 
        }
    } 
</script>

<table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0"
    runat="server" id="tblBody">
    <tr>
        <td>
            <div runat="server" id="dvError" style="display: none;">
                <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                    width="100%" border="0">
                    <tr>
                        <td valign="top" width="20">
                            <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
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
        <td valign="top" style="padding-left: 10; height: 100%;">
            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                cellspacing="0">
                <tr>
                    <td colspan="2" class="cLEnrollHeader">
                        Client Intake form
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <asp:Label CssClass="entry2" Text="" ForeColor="Red" ID="lblMsg" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td height="20">
                        <b>Last Modified By:</b>
                        <asp:Label CssClass="entry2" Text="" ID="lbLastModified" runat="server"></asp:Label>
                    </td>
                    <td height="20">
                        <b>Last Modified Date:</b>
                        <asp:Label CssClass="entry2" Text="" ID="lbLastModifiedDate" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr style="display: none">
                    <td colspan="2" align="right">
                        <asp:CheckBox ID="ChkFormVeirified" runat="server" CssClass="entry2" Text="Verified" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <!-- New Design -->
                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                            cellspacing="0" class="box">
                            <tr>
                                <td class="cLEnrollHeader">
                                    1. Client Info
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="22%">
                                                Date:
                                            </td>
                                            <td width="13%">
                                                <cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true"
                                                    TabIndex="10" CssClass="entry" ID="txtDOB" runat="server" ReadOnly="true" Mask="nn/nn/nnnn"
                                                    Width="145px" Enabled="false"></cc1:InputMask>
                                            </td>
                                            <td align="right" width="15%">
                                                Firm:
                                            </td>
                                            <td align="left" width="20%">
                                                <asp:TextBox ID="txtFirm" Width="170px" runat="server" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                            <td align="right" width="13%">
                                                Client/Acct. Number:
                                            </td>
                                            <td width="17%">
                                                <asp:TextBox ID="txtAccNo" runat="server" Width="140px" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Client Name:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtClientName" runat="server" Width="145px" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                            <td align="right">
                                                Primary address1:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAddress1" runat="server" Width="170px" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                            <td align="right">
                                                City/State/Zip:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAddress2" runat="server" Width="140px" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Primary Phone:
                                            </td>
                                            <td>
                                                <cc1:InputMask CssClass="entry" Width="120px" ID="txtPhone" runat="server" Mask="(nnn) nnn-nnnn"
                                                        MaxLength="20"></cc1:InputMask> &nbsp;<a href="#" onclick="AddressBook();return false;"><img id="Img4" runat="server" src="~/images/16x16_addressbook.png" border="0" align="absmiddle" /></a>
                                            </td>
                                            <td align="right">
                                                E-Mail:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtEmail" Width="170px" runat="server" CssClass="entry" ReadOnly="True"></asp:TextBox>
                                            </td>
                                            <td align="right">
                                                Litigation Document:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlLDocument" runat="server" CssClass="entry2" Width="145px">
                                                        <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                        <asp:ListItem Text="Summons"></asp:ListItem>
                                                        <asp:ListItem Text="Pre-Judgment"></asp:ListItem>
                                                        <asp:ListItem Text="Post Judgment"></asp:ListItem>
                                                        <asp:ListItem Text="Bank Levy"></asp:ListItem>
                                                        <asp:ListItem Text="Wage Garnishment"></asp:ListItem>
                                                        <asp:ListItem Text="Property Lien"></asp:ListItem>
                                                        <asp:ListItem Text="Other"></asp:ListItem>
                                                    </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Date Client Received Document:
                                            </td>
                                            <td>
                                                <igsch:WebDateChooser ID="txtDateClientReceivedDocument" runat="server" Width="150px"
                                                    Value="" EnableAppStyling="True" StyleSetName="Nautilus">
                                                    <calendarlayout changemonthtodateclicked="True">
										</calendarlayout>
                                                </igsch:WebDateChooser>
                                            </td>
                                            <td align="right">
                                                Lawsuit amount:$
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAmmount" runat="server" Width="170px" CssClass="entry"></asp:TextBox>
                                            </td>
                                            <td align="right">
                                                How Documents Received:
                                                <div style="display: none">
                                                    Do you dispute the amount?</div>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbRecType" runat="server" CssClass="entry2" Width="180px">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Sheriff"></asp:ListItem>
                                                    <asp:ListItem Text="Personal service"></asp:ListItem>
                                                    <asp:ListItem Text="Local Authority"></asp:ListItem>
                                                    <asp:ListItem Text="By Regular Mail"></asp:ListItem>
                                                    <asp:ListItem Text="By Certified Mail"></asp:ListItem>
                                                    <asp:ListItem Text="By Process Server"></asp:ListItem>
                                                    <asp:ListItem Text="Other"></asp:ListItem>
                                                </asp:DropDownList>
                                                <div style="display: none">
                                                    <asp:DropDownList ID="cmbAmtDispute" runat="server" CssClass="entry2" Width="135px">
                                                        <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                        <asp:ListItem Text="Yes"></asp:ListItem>
                                                        <asp:ListItem Text="No"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                &nbsp;
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
                                    2. Real Estate Info
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="30%">
                                                (1) Do you own any real estate?
                                            </td>
                                            <td>
  <asp:DropDownList ID="cmbResidence" runat="server" CssClass="entry2">
                                                                <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                <asp:ListItem Text="Yes"></asp:ListItem>
                                                                <asp:ListItem Text="No"></asp:ListItem>
                                                            </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table id="tabREstate" runat="server" cellpadding="1" cellspacing="0" style="display: none"
                                        width="100%" border="0" class="box">
                                        <tr>
                                            <td valign="top" width="50%">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-family: tahoma;
                                                    font-size: 11px;">
                                                    <tr>
                                                        <td colspan="2">
                                                            <b>Property 1:</b>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td colspan="2">
                                                            <table id="tabPro1" border="0" runat="server" style="display: none; font-family: tahoma;
                                                                font-size: 11px;" width="100%">
                                                                <tr>
                                                                    <td width="60%">
                                                                        What year was property purchased?
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtOwnyears" runat="server" Width="100px" CssClass="entry"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Market value:
                                                                    </td>
                                                                    <td>
                                                                        <asp:CheckBox ID="chkMarketVal" runat="server" Text="Unknown" />
                                                                        <asp:TextBox ID="txtMarketVal" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Payoff:
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtPayoff" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Any liens on property?(Taxes Judgments, etc.)
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbLiens" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Mortgage Payment:
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtEquity" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        House payment current?
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbPayments" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        How many people live there?
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtTotalPeople" runat="server" Width="100px" CssClass="entry"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table id="tabPro1No" border="0" runat="server" style="display: none; font-family: tahoma;
                                                                font-size: 11px;" width="100%">
                                                                <tr>
                                                                    <td width="60%">
                                                                        Is this a rental property?
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbRental1" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="dv1p1" runat="server" style="display: none">
                                                                            How much is the rent?</div>
                                                                    </td>
                                                                    <td>
                                                                        <div id="dv2p1" runat="server" style="display: none">
                                                                            <asp:TextBox ID="txtRent1" runat="server" CssClass="entry2" Width="100px"></asp:TextBox>&nbsp;$
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td valign="top" width="50%">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-family: tahoma;
                                                    font-size: 11px;">
                                                    <tr>
                                                        <td colspan="2">
                                                            <b>Property 2:</b>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="60%">
                                                            Do you own additional property?
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="cmbResidence2" runat="server" CssClass="entry2">
                                                                <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                <asp:ListItem Text="Yes"></asp:ListItem>
                                                                <asp:ListItem Text="No"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <table id="tabPro2No" border="0" runat="server" style="display: none; font-family: tahoma;
                                                                font-size: 11px;" width="100%">
                                                                <tr>
                                                                    <td width="60%">
                                                                        Is second property a rental unit?
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbRental2" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="dv1p2" runat="server" style="display: none">
                                                                            Monthly income received:
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div id="dv2p2" runat="server" style="display: none">
                                                                            <asp:TextBox ID="txtRent2" runat="server" CssClass="entry2" Width="100px"> </asp:TextBox>&nbsp;$
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <table id="tabPro2" border="0" runat="server" style="font-family: tahoma; font-size: 11px;
                                                                display: none;" width="100%">
                                                                <tr>
                                                                    <td width="60%">
                                                                        What year was property purchased?
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtOwnyears2" runat="server" Width="100px" CssClass="entry"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Market value:
                                                                    </td>
                                                                    <td>
                                                                        <asp:CheckBox ID="chkMarketVal2" runat="server" Text="Unknown" />
                                                                        <asp:TextBox ID="txtMarketVal2" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Payoff:
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtPayoff2" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Any liens on property?(Taxes Judgments, etc.)
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbLiens2" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Mortgage Payment:
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtEquity2" runat="server" Width="100px" CssClass="entry"></asp:TextBox>&nbsp;$
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        House payment current?
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="cmbPayments2" runat="server" CssClass="entry2">
                                                                            <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                                                            <asp:ListItem Text="No"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        How many people live there?
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtTotalPeople2" runat="server" Width="100px" CssClass="entry"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
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
                                    3. Employment Info
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="30%%">
                                                (2) Are you employed?
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbWorking" runat="server" CssClass="entry2">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table id="tabNoIncome" runat="server" style="font-family: tahoma; font-size: 11px;
                                        display: none;" cellpadding="1" cellspacing="0" width="100%" border="0" class="box">
                                        <tr>
                                            <td width="30%">
                                                Receiving any type of Aid ?
                                            </td>
                                            <td width="12%">
                                                <asp:DropDownList ID="cmbAid" runat="server" CssClass="entry2">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                                &nbsp;
                                            </td>
                                            <td width="20%">
                                               &nbsp;
                                            </td>
                                            <td width="38%">
                                               &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div style="display: none;" id="dvr">
                                                    <table style="font-family: tahoma; font-size: 11px;" cellpadding="1" cellspacing="0"
                                                        width="100%" border="0" class="box">
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkr1" runat="server" CssClass="entry" Text="SSI" />
                                                            </td>
                                                            <td>
                                                                <div id="dvr1" style="display: none">
                                                                    Amount Received:<asp:TextBox ID="txtr1" CssClass="entry" runat="server" Width="80px"
                                                                        MaxLength="20"></asp:TextBox>&nbsp;$
                                                                </div>
                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkr2" runat="server" CssClass="entry" Text="Pension" />
                                                            </td>
                                                            <td>
                                                                <div id="dvr2" style="display: none">
                                                                    Amount Received:<asp:TextBox ID="txtr2" CssClass="entry" runat="server" Width="80px"
                                                                        MaxLength="20"></asp:TextBox>&nbsp;$
                                                                </div>
                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkr3" runat="server" CssClass="entry" Text="Unemployment" />
                                                            </td>
                                                            <td>
                                                                <div id="dvr3" style="display: none">
                                                                    Amount Received:<asp:TextBox ID="txtr3" CssClass="entry" runat="server" Width="80px"
                                                                        MaxLength="20"></asp:TextBox>&nbsp;$
                                                                </div>
                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkr4" runat="server" CssClass="entry" Text="Retirement" />
                                                            </td>
                                                            <td>
                                                                <div id="dvr4" style="display: none">
                                                                    Amount Received:<asp:TextBox ID="txtr4" CssClass="entry" runat="server" Width="80px"
                                                                        MaxLength="20"></asp:TextBox>&nbsp;$
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="tabIncome" runat="server" style="font-family: tahoma; font-size: 11px;
                                        display: none" cellpadding="1" cellspacing="0" width="100%" border="0" class="box">
                                        <tr>
                                            <td width="17%">
                                                Are you self employed?
                                            </td>
                                            <td width="8%">
                                                <asp:DropDownList ID="cmbSelfEmp" runat="server" CssClass="entry2" Width="85px">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td align="right" width="14%">
                                                Employer/Company:
                                            </td>
                                            <td width="26%">
                                                <asp:TextBox ID="txtEmployer" CssClass="entry" runat="server" Width="250px"></asp:TextBox>
                                            </td>
                                            <td align="right" width="22%">
                                                Length of employment:
                                            </td>
                                            <td width="13%">
                                                <asp:TextBox ID="txtExpAtEmployer" CssClass="entry" runat="server" Width="10px" MaxLength="2"></asp:TextBox>&nbsp;years&nbsp;<asp:TextBox
                                                    ID="txtExpAtEmployerMonths" CssClass="entry" runat="server" Width="20px" MaxLength="2"></asp:TextBox>&nbsp;months
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Take home pay:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtTakeHome" CssClass="entry" runat="server" Width="70px"></asp:TextBox>&nbsp;$
                                            </td>
                                            <td align="right">
                                                Per:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbPer" runat="server" CssClass="entry2">
                                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                    <asp:ListItem Text="Weekly"></asp:ListItem>
                                                    <asp:ListItem Text="Bi-Weekly"></asp:ListItem>
                                                    <asp:ListItem Text="Monthly"></asp:ListItem>
                                                    <asp:ListItem Text="Other"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Any wage garnishment?:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbWage" runat="server" CssClass="entry2" Width="95px">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td colspan="4">
                                                <div style="display: none" id="dvGarnishment">
                                                    <span>&nbsp;&nbsp; Enter info&nbsp;&nbsp;&nbsp;<asp:TextBox ID="txtGarnishmentVal"
                                                        CssClass="entry" runat="server" Width="260px"></asp:TextBox></span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Other sources of income:
                                            </td>
                                            <td colspan="5">
                                                <asp:TextBox ID="txtOtherIncome" CssClass="entry" runat="server" Width="260px"></asp:TextBox>&nbsp;&nbsp;***(HAVE
                                                CLIENT SEND IN PROOF OF S.S.I., DISABILITY, ETC.)***
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
                                    4. Bank Info
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="30%">
                                                (3) Is your name on any bank account?
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbBankAcc" runat="server" CssClass="entry2">
                                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table id="tabBankAcc" runat="server" style="font-family: tahoma; font-size: 11px;
                                        display: none" width="100%" border="0" cellpadding="1" cellspacing="0" class="box">
                                        <tr>
                                            <td width="50%">
                                                <table width="100%" border="0" cellpadding="1" cellspacing="0" style="font-family: tahoma;
                                                    font-size: 11px;">
                                                    <tr>
                                                        <td colspan="2">
                                                            <b>Account 1:</b>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="45%">
                                                            Name of the bank:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBankName" CssClass="entry" runat="server" Width="220px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Source of money deposited in account:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtSource" CssClass="entry" runat="server" Width="220px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Approximate balance in account:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBalance" CssClass="entry" runat="server" Width="100px"></asp:TextBox>&nbsp;$
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Account Type:
                                                        </td>
                                                        <td>
                                                            <asp:RadioButtonList ID="radAccountType" runat="server" CssClass="entry" RepeatColumns="3"
                                                                RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="1">Checking</asp:ListItem>
                                                                <asp:ListItem Value="2">Saving</asp:ListItem>
                                                                <asp:ListItem Value="3">Other</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Any current bank levies?
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtLevies1" CssClass="entry" runat="server" Width="220px" MaxLength="50"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width="100%" border="0" cellpadding="1" cellspacing="0" style="font-family: tahoma;
                                                    font-size: 11px;">
                                                    <tr>
                                                        <td colspan="2">
                                                            <b>Account 2:</b>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="45%">
                                                            Name of the bank:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBankName2" CssClass="entry" runat="server" Width="220px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Source of money deposited in account:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtSource2" CssClass="entry" runat="server" Width="220px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Approximate balance in account:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBalance2" CssClass="entry" runat="server" Width="100px"></asp:TextBox>&nbsp;$
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Account Type:
                                                        </td>
                                                        <td>
                                                            <asp:RadioButtonList ID="radAccountType2" runat="server" CssClass="entry" RepeatColumns="3"
                                                                RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="1">Checking</asp:ListItem>
                                                                <asp:ListItem Value="2">Saving</asp:ListItem>
                                                                <asp:ListItem Value="3">Other</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Any current bank levies?
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtLevies2" CssClass="entry" runat="server" Width="220px" MaxLength="50"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
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
                                    5. Assets Info
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="20%">
                                                Do you have other assets?
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbAssets" runat="server" CssClass="entry2">
                                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td valign="top">
                                                <div id="dvAssets1" runat="server" style="display: none; vertical-align: middle">
                                                    Assets:</div>
                                            </td>
                                            <td valign="top">
                                                <div id="dvAssets" runat="server" style="display: none; vertical-align: middle">
                                                    <asp:TextBox ID="txtAssets" TextMode="MultiLine" Height="40" Width="500" runat="server"
                                                        CssClass="entry2">
                                                    </asp:TextBox>
                                                </div>
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
                                    6. Verification
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="1"
                                        cellspacing="0" class="box">
                                        <tr>
                                            <td width="30%">
                                                <asp:CheckBox CssClass="entry" ID="chkLegalServices" runat="server" Text="Client declined additional legal services">
                                                </asp:CheckBox>
                                            </td>
                                            <td>
                                                <div id="dvVerifiedBy1" runat="server" style="display: none">
                                                    Verified by:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:DropDownList ID="cmbVerifiedBy" runat="server" CssClass="entry2">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="30%">
                                                Is plaintiff a collection company?
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cmbplaintiff" runat="server" CssClass="entry2" Width="150px">
                                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                                    <asp:ListItem Text="No"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox CssClass="entry" ID="chkLocalCounsel" runat="server" Text="Client sent to local counsel">
                                                </asp:CheckBox>
                                            </td>
                                            <td>
                                                <div id="dvLocalCounsel1" runat="server" style="display: none">
                                                    Local counsel fees to be paid by:&nbsp;
                                                    <asp:DropDownList ID="cmbFeepaidtype" runat="server" CssClass="entry2">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                SDA Balance:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtSDA" runat="server" Width="100px" ReadOnly="true" CssClass="entry"></asp:TextBox>&nbsp;$
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
                                    7. Notes /Hardship information 
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtSDADesc" CssClass="entry" runat="server" TextMode="MultiLine"
                                        Height="100px" Width="810px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <!-- New Design -->
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- The following controls are only on the page so that the client script (above)
        can fill these controls with values to be post backed with the form.  They have no inner 
        value so they will not be visibly displayed on the page -->
<asp:HiddenField runat="server" ID="txtNotes" />
<asp:HiddenField runat="server" ID="txtPropagations" />
<asp:HiddenField runat="server" ID="txtResolved" />
<asp:HiddenField runat="server" ID="hdnTaskResolutionID" />

<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->
<asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>

<script>

    document.getElementById("<%=txtDOB.ClientID %>").value = '<%=System.DateTime.Now.ToString("MM/dd/yyyy")%>'
    window.onload = function() {
    ShowWages();
    ShowIncome()
    ShowAmount(1)
    ShowAmount(2)
    ShowAmount(3)
    ShowAmount(4)
    }  
</script>

