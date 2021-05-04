<%@ Page Language="VB" AutoEventWireup="false" CodeFile="negotiationfield.aspx.vb"
    Inherits="util_pop_negotiationfield" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DMP - Negotiation Field Lookup</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
     <!--
        function AddToCriteria()
        {
          var indx;
          var Obj;
          var idvalue;
          var criteriaToBind = '';
          var txtCntrlVal='';
          var txtControlId = '<%= txtCriteriaInputId.ClientID %>';
          var txtCriteriaInputId = document.getElementById(txtControlId);
          var inputtag = document.getElementsByTagName("INPUT");
          txtCntrlVal = txtCriteriaInputId.value;
          
          for (indx = 0; indx < inputtag.length; indx++)
          {
           idvalue = inputtag[indx].id;
           Obj = document.getElementById(idvalue);
           if (Obj.type == 'checkbox') 
           {                        
             if ((Obj.checked == true) && (idvalue != 'chkAll'))
             {
               if (criteriaToBind != '') { criteriaToBind = criteriaToBind + '|';}
               criteriaToBind  = criteriaToBind + inputtag[indx].value;
             }
           }                                  
          }
          
          window.parent.dialogArguments.SetInfo(txtCntrlVal,criteriaToBind);
          window.close();
          return false;
        }  
        
        function CheckUncheckAll(myval)
        {
          var Obj;
          var idvalue;         
          var inputtag = document.getElementsByTagName("INPUT");         
          for (indx = 0; indx < inputtag.length; indx++)
          {
            idvalue = inputtag[indx].id;
            Obj = document.getElementById(idvalue);
            if (Obj.type == 'checkbox') 
            {                        
             if (myval.checked == true)
             {
                Obj.checked = true;
             }
             else
             {
               Obj.checked = false;
             }
            }                                  
          }        
        }                   

        function CheckUncheckMe(myval)
        {
        
          var Obj;
          var idvalue;
          var blnAllselected = true;
          var inputtag = document.getElementsByTagName("INPUT");         
          if (myval.checked == false)
          {
            AllSelected(false);
          }
          else
          {
            for (indx = 0; indx < inputtag.length; indx++)
            {
             idvalue = inputtag[indx].id;
             Obj = document.getElementById(idvalue);
             if (Obj.type == 'checkbox')
             {   
                if(Obj.checked == false)
                {
                  blnAllselected = false;
                  break;
                }                
             }            
            }
            AllSelected(blnAllselected)
          }                                  
        }                   
        
        function AllSelected(myval)
        {
            var Obj;
            Obj = document.getElementById("chkAll");
            Obj.checked = myval;
        }

    // -->
    </script>
    
</head>
<body onload="SetFocus('<%= txtSearchval.ClientID() %>');Requery();">
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>
<script language=javascript type="text/javascript">

        var xml = new ActiveXObject("Microsoft.XMLDOM");
        var txtSearchval = null;
        var txtFieldName = null;
        var txtCompareType = null;
        var ProgressDisp = null;
        
        xml.async = true;
        xml.onreadystatechange = Display;
                
        function LoadControls()
        {
            if (txtSearchval == null)
            {
                txtSearchval = document.getElementById("<%= txtSearchval.ClientID() %>");
                txtFieldName = document.getElementById("<%= txtFieldName.ClientID() %>");
                txtCompareType = document.getElementById("<%= txtCompareType.ClientID() %>");
                ProgressDisp = document.getElementById("<%= spnProgress.ClientID() %>");                
            }
        }

        
        function Requery()
        {
            LoadControls();
            ProgressDisp.style.visibility = "hidden";
            if (txtSearchval.value.length > 1)
            {
            ProgressDisp.style.visibility = "visible";
	        xml.load("<%= ResolveUrl("~/util/negotiationField.ashx?SearchText=") %>" + txtSearchval.value
	            + "&FieldName=" + txtFieldName.value + "&compareType=" + txtCompareType.value);
            }
            else
            {
                InitializeDisplay();    
            }
        }
        
        function InitializeDisplay()
        {
                var rCount = '<%= lblCount.ClientID %>';
                var lCountShow = document.getElementById(rCount);
                lCountShow.innerText = "";
                while (tblNegotiationLookup.rows.length > 0)
                {
                    tblNegotiationLookup.deleteRow(0);
                }                
        }
        
        
        function Display()
        {
            var rCount = '<%= lblCount.ClientID %>';
            if (xml.readyState == 4)
            {     
                LoadControls();                
                //remove all current rows except for first two
                InitializeDisplay();
                
                if (xml.childNodes.length == 2 && xml.childNodes[1].baseName == "negotiationfield")
                {
                    var fields = xml.childNodes[1];   
                    var lCountShow = document.getElementById(rCount);
                    lCountShow.innerText = "found: (" + fields.childNodes.length + ")";
                    ProgressDisp.style.visibility = "hidden";
                    for (x = 0; x < fields.childNodes.length; x++)
                    {
                        var field = fields.childNodes[x];
                        var fieldvalue = field.attributes.getNamedItem("Description").value;
                        // First row to toggle Select/Deselect All
                        if (x == 0) 
                        {
                          var tr0 = tblNegotiationLookup.insertRow(-1);                        
                          tr0.setAttribute("tr0" + x, fieldvalue);
                          var tdCheck0 = tr0.insertCell(-1);                                                
                          var tdName0 = tr0.insertCell(-1);                          
                          var sCheck0 = "<INPUT TYPE = 'CheckBox' id='chkAll' value='All' OnClick='CheckUncheckAll(this);' />";                          
                          tdCheck0.innerHTML = sCheck0;
                          tdCheck0.width = "20px";
                          tdCheck0.className = "listItem5";
                          tdName0.innerHTML = "Select/Deselect All";
                          tdName0.className = "listItem5";
                        }
                        
                        var tr = tblNegotiationLookup.insertRow(-1);                        
                        tr.setAttribute(x, fieldvalue);
                        
                        var tdCheck = tr.insertCell(-1);
                        var tdName = tr.insertCell(-1);
                        var chkId = "chk" + x;
                        var sCheck = "<INPUT TYPE = 'CheckBox' id='" + chkId + "' value='" + fieldvalue + "' OnClick='CheckUncheckMe(this);' />";
                        tdCheck.innerHTML = sCheck;
                        tdCheck.width = "20px";
                        tdCheck.className = "listItem5";
                        tdName.innerHTML = fieldvalue;
                        tdName.className = "listItem5";
                    }
                }
            }
        }        
</script>

    <form id="form1" runat="server">
                <table style="margin-left: 7; font-family: tahoma; font-size: 11px; width: 100%;"
                    border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                cellspacing="0" border="0">
                                <tr>
                                    <td style="color: rgb(50,112,163);">
                                        <asp:Label ID="lblHeader" CssClass="lnk" runat="server"></asp:Label></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                            <table border="0" style="font-family: tahoma; font-size: 11px; width: 600px;background-color: #f3f3f3;" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td style="color: rgb(50,112,163);"><asp:TextBox ID="txtSearchval" runat="server" Width="150px"></asp:TextBox>&nbsp;<span style="width:50px" id="spnProgress" runat="server"><img src="../../images/loading.gif" /></span></td>                                    
                                    <td align="left" width="150px"><asp:Label ID="lblCount" Font-Bold="true" Font-Italic="true" Style="font-family: Tahoma; font-size: 11" runat="server"></asp:Label></td>
                                    <td style="color: rgb(50,112,163);">
                                        <asp:Label ID="lblMsg" Style="font-family: Tahoma; font-size: 11" ForeColor="red" runat="server" Width="250px"></asp:Label>
                                    </td>
                                </tr>
                                <tr><td style="color: rgb(50,112,163);" colspan=3><asp:TextBox ID="txtcurrent" Style="font-family: Tahoma; font-size: 9" BorderStyle=none BackColor=transparent ReadOnly="true" runat="server" Width="600px"></asp:TextBox></td></tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <div id="Div1" style="overflow: auto; height: 445px;">
                                <table border = "0" id="tblNegotiationLookup" runat="server" style="font-size:11px;font-family:tahoma;width:100%" cellspacing="0" cellpadding="3">
                                </table>                                                        
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                            padding-right: 10px;">
                            <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                                cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <a tabindex="1" style="color: black" class="lnk" href="javascript:window.close();">
                                            <img id="Img1" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                                border="0" align="absmiddle" />
                                            Cancel and Close </a>
                                    </td>
                                    <td align="right">
                                        <input type="hidden" id="txtFieldName" runat="server" /><input type="hidden" id="txtCompareType" runat="server" /><input type="hidden" id="txtSelectedvalues" runat="server" /><input type="hidden"
                                            id="txtCriteriaInputId" runat="server" />
                                        <a href="javascript:AddToCriteria();" tabindex="3" style="color: black" class="lnk">
                                            Add to Criteria Builder
                                            <img style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png" border="0"
                                                align="absmiddle" />
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
    </form>
</body>
</html>
