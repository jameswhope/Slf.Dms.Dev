<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="AttyAddEdit.aspx.vb" Inherits="admin_settings_references_AttyAddEdit"
    Title="Add/Edit Attorneys" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />

    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
    <script src="<%= ResolveUrl("~/jscript/domain.js") %>" type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
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
        
        function RowHover(tr, over)
        {
            if (tr.tagName == "TR")
            {
                var tbody = tr.parentElement;
                var tbl = tbody.parentElement;
                
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
                    tr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", tr);
                }
            }
        }
        
        function RowClick(id, coName)
        {
            if (ValidateFields())
            {
                var hdnSelected = document.getElementById('<%=hdnSelectedCompanyID.ClientID %>');
                var hdnCurrent = document.getElementById('<%=hdnCurrentCompanyID.ClientID %>');
                var hdnSelectedCompanyName = document.getElementById("<%=hdnSelectedCompanyName.ClientID %>");
                
                hdnCurrent.value = hdnSelected.value;
                hdnSelected.value = id;
                hdnSelectedCompanyName.value = coName;
                GetStateLicInfo();
                HideMessage();
                               
                <%=Page.ClientScript.GetPostBackEventReference(lnkCompanyChanged, Nothing) %>;
            }
            else
            {
                ShowMessage('Please enter required fields before setting state primary information.');
            }
        }
       
        function SaveAndExit() 
        {
            if (ValidateFields())
            {           
                GetStateLicInfo();
                <%=Page.ClientScript.GetPostBackEventReference(lnkSaveAndExit, Nothing) %>;
            }
            else
            {
                if(msg=="")
                    ShowMessage('Please enter required fields.');
                else
                    ShowMessage(msg);
            }
        }
        
        function SaveAndContinue()
        {
            if (ValidateFields())
            {       
                GetStateLicInfo();    
                <%=Page.ClientScript.GetPostBackEventReference(lnkSaveAndContinue, Nothing) %>;
            }
            else
            {
                ShowMessage('Please enter required fields.');
            }
        }
       
        function RemoveAttorney()
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx") %>?f=CallRemoveAttorney&t=Remove Attorney&m=Are you sure you want to remove this attorney? Doing so will remove all settlement attorney associations, state licenses, and state primary assigments.';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Remove Attorney",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 300, scrollable: false});  
        }
        
        function CallRemoveAttorney()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRemoveAttorney, Nothing) %>;
        }
        
        function AddStateLicRow()
        { 
            var tbl = document.getElementById("<%= tblStateLic.ClientID %>");
            var hdn = document.getElementById("<%= hdnSelectedCompanyID.ClientID %>");
            var trNew = tbl.insertRow(-1);
            
            var tdDelete = trNew.insertCell(-1);
            var tdState = trNew.insertCell(-1);
            var tdStateBar = trNew.insertCell(-1);
            var tdPrimary = trNew.insertCell(-1);
                   
            // Delete Button, Delete Flag, AttyStateID
            tdDelete.className = "listItem2";
            tdDelete.innerHTML = "<a href='#' onclick='DeleteStateLicRow(this);return false;'><img src='../../../images/16x16_delete.png' border='0' align='absmiddle'/></a><input type='hidden' value='N'><input type='hidden' value='-1'>";
           
            tdState.className = "listItem2";
            tdState.insertAdjacentElement("afterBegin", GetNewStateType());
           
            tdStateBar.className = "listItem2";
            tdStateBar.innerHTML = "<input type='text' class='entry'>";
            
            tdPrimary.className = "listItem2";
            if (hdn.value > 0)
                tdPrimary.innerHTML = "<input type='checkbox' class='entry'>";
            else
                tdPrimary.innerHTML = "<input type='checkbox' class='entry' disabled='disabled'>";
        }
        
        function DeleteStateLicRow(obj)
        {
            var tbl = document.getElementById("<%= tblStateLic.ClientID %>");
            var index = obj.parentElement.parentElement.rowIndex
        
            if (tbl.rows[index].cells[0].childNodes[2].value == -1)
            {
                // user is deleting a new row, no need to flag it, just delete it
                tbl.deleteRow(index);
            }
            else
            {
                // hide record and flag for deletion
                tbl.rows[index].style.display = 'none';
                tbl.rows[index].cells[0].childNodes[1].value = 'Y';
            }   
        }
       
        //Get all the state info in this format 0.)State 1.) License 2.) Primary
        function GetStateLicInfo()
        {
            var tblStateLic = document.getElementById("<%= tblStateLic.ClientID %>");
            var lstStateLics = document.getElementById("<%= lstStateLics.ClientID %>");
            
            lstStateLics.value = "";

            for (i = 1; i < tblStateLic.rows.length; i++)
            {
                var flag = tblStateLic.rows[i].cells[0].childNodes[1];
                var ID = tblStateLic.rows[i].cells[0].childNodes[2];
                var cboState = tblStateLic.rows[i].cells[1].childNodes[0];
                var txtStateBarNum = tblStateLic.rows[i].cells[2].childNodes[0];
                var chkPrimary = tblStateLic.rows[i].cells[3].childNodes[0];

                if (lstStateLics.value.length > 0)
                {
                    lstStateLics.value += "|";
                }
                
                lstStateLics.value += flag.value + "," + ID.value + "," + cboState.options[cboState.selectedIndex].value + "," + txtStateBarNum.value + "," + chkPrimary.checked;
            }
        }     
        
        function GetNewStateType()
        {
            var ddl = document.getElementById("<%= ddlState.ClientID %>");
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
        var msg='';
        function ValidateFields()
        {
        msg="";
            var txtFirst = document.getElementById("<%= txtFirstName.ClientID() %>");
            var txtLast = document.getElementById("<%= txtLastName.ClientID() %>");
            var r = true;
            var txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID() %>");
           
            RemoveBorder(txtFirst);       
            RemoveBorder(txtLast);
            RemoveBorder(txtEmailAddress);
            
            if (trim(txtFirst.value).length == 0)  {
	            AddBorder(txtFirst);
	            r = false;
            }
            
            if (trim(txtLast.value).length == 0)  {
	            AddBorder(txtLast);
	            r = false;
	        }
	         if (trim(txtEmailAddress.value).length == 0)  {
	            AddBorder(txtEmailAddress);
	            r = false;
	        }
	        	        
	          // Email Address
	         if (txtEmailAddress.value.length > 0)
	        {
                if (!RegexValidate(txtEmailAddress.value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"))
	            {
	                msg = "The Email Address you entered is invalid.  Please enter a new value.  This is not a required field.";
	                AddBorder(txtEmailAddress);
	                 r = false;
	               // return false;
                }
            }
        	            
	        return r;
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
        
        function trim(stringToTrim) 
        {
	        return stringToTrim.replace(/^\s+|\s+$/g,"");
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="15" style="font-family: tahoma; font-size: 11px;
                width: 100%;">
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" href="~/admin/default.aspx" style="color: #666666;">
                            Admin</a>&nbsp;>&nbsp; <a id="A2" runat="server" class="lnk" href="~/admin/settings/default.aspx"
                                style="color: #666666;">Settings</a>&nbsp;>&nbsp; <a id="A3" runat="server" class="lnk"
                                    href="~/admin/settings/references/default.aspx" style="color: #666666;">References</a>&nbsp;>&nbsp;
                        <a id="A4" runat="server" class="lnk" href="~/admin/settings/attorneys.aspx"
                            style="color: #666666;">Attorneys</a>&nbsp;>&nbsp;
                        <asp:Label ID="lblTitle" runat="server" Style="color: #666666;"></asp:Label>
                    </td>
                </tr>
            </table>
            <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                cellspacing="0">
                <tr>
                    <td style="padding: 0 15 5 15">
                        <div runat="server" id="dvError" style="display: none;">
                            <table style="margin-top: 10; width: 100%; border-right: #969696 1px solid; border-top: #969696 1px solid;
                                font-size: 11px; border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                font-family: Tahoma; background-color: #ffffda" cellspacing="5" cellpadding="0"
                                border="0">
                                <tr>
                                    <td valign="top" width="16">
                                        <img id="Img1" runat="server" src="~/images/16x16_exclamationpoint.png" align="absMiddle"
                                            border="0"></td>
                                    <td runat="server" id="tdError">
                                        asdf</td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td height="20px" style="padding: 5 15 5 15; font-weight: bold; font-size: 11px" valign="bottom">
                        Attorney Information
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding: 0 15 0 15">
                        <table id="tblAttorneys" runat="server" style="table-layout: fixed; width: 100%;
                            font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="0" border="0"
                            language="javascript">
                            <tr>
                                <td class="headItem" style="width: 150; padding: 2 0 2 5">
                                    First Name</td>
                                <td class="headItem" nowrap="nowrap" style="width: 150; padding: 2 0 2 5">
                                    MI</td>
                                <td class="headItem" style="width: 150; padding: 2 0 2 5">
                                    Last Name</td>
                                <td class="headItem" style="width: 125; padding: 2 0 2 5">
                                    Phone</td>
                                <td class="headItem" style="width: 125; padding: 2 0 2 5">
                                    Fax</td>
                            </tr>
                            <tr>
                                <td valign="top" class="headItem" style="width: 150; padding-left: 5">
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="entry" MaxLength="50"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding-left: 5" valign="top">
                                    <asp:TextBox ID="txtMiddleName" runat="server" CssClass="entry" MaxLength="50"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding-left: 5" valign="top">
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="entry" MaxLength="50"></asp:TextBox></td>
                                <td class="headItem" style="width: 125; padding-left: 5" valign="top">
                                    <cc1:InputMask ID="txtPhone" runat="server" CssClass="entry" Mask="(nnn)nnn-nnnn"></cc1:InputMask></td>
                                <td class="headItem" style="width: 125; padding-left: 5" valign="top">
                                    <cc1:InputMask ID="txtFax" runat="server" CssClass="entry" Mask="(nnn)nnn-nnnn"></cc1:InputMask></td>
                            </tr>
                            <tr>
                                <td class="headItem" style="width: 150; padding: 2 0 2 5">
                                    Address 1</td>
                                <td class="headItem" style="width: 100; padding: 2 0 2 5">
                                    Address 2</td>
                                <td class="headItem" style="width: 150; padding: 2 0 2 5">
                                    City</td>
                                <td class="headItem" style="width: 50; padding: 2 0 2 5">
                                    State</td>
                                <td class="headItem" style="width: 125; padding: 2 0 2 5">
                                    Zip Code</td>
                            </tr>
                            <tr>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox CssClass="entry" runat="server" ID="txtAddress1" MaxLength="150"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox ID="txtAddress2" runat="server" CssClass="entry" MaxLength="150"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="entry" MaxLength="50"></asp:TextBox></td>
                                <td class="headItem" style="width: 125; padding: 0 0 2 5" valign="top">
                                    <asp:DropDownList ID="ddlState" runat="server" CssClass="entry">
                                    </asp:DropDownList></td>
                                <td class="headItem" style="width: 125; padding: 0 0 2 5" valign="top">
                                    <cc1:InputMask ID="txtZip" runat="server" CssClass="entry" Mask="nnnnn-nnnn"></cc1:InputMask></td>
                            </tr>
                            <tr>
                                <td class="headItem" style="padding: 2 0 2 5">
                                    Username</td>
                                <td class="headItem" style="padding: 2 0 2 5">
                                    Set Password</td>
                                <td class="headItem" style="padding: 2 0 2 5">
                                    Email Address</td>
                                <td class="headItem" style="padding: 2 0 2 5">
                                     Email Address&nbsp;2</td>
                                <td class="headItem" style="padding: 2 0 2 5">
                                     Email Address&nbsp;3</td>
                            </tr>
                            <tr>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox CssClass="entry" runat="server" ID="txtUsername" MaxLength="30"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="entry" MaxLength="20" TextMode="Password"></asp:TextBox></td>
                                <td class="headItem" style="width: 150; padding: 0 0 2 5" valign="top">
                                    <asp:TextBox ID="txtEmailAddress" runat="server" CssClass="entry" MaxLength="20" ></asp:TextBox></td>
                                <td class="headItem" style="padding: 0 0 2 5" valign="top">
                                    <asp:HiddenField ID="hdnUserID" runat="server" Value="-1" /><asp:TextBox ID="txtEmailAddress2" runat="server" CssClass="entry" MaxLength="20" ></asp:TextBox></td>
                                <td class="headItem" style="padding: 0 0 2 5" valign="top">
                                    <asp:TextBox ID="txtEmailAddress3" runat="server" CssClass="entry" MaxLength="20" ></asp:TextBox></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10; padding-right: 15">
                        <table border="0" width="100%" cellpadding="0" cellspacing="5">
                            <tr>
                                <td height="20px" style="font-weight: bold; font-size: 11px" valign="bottom">
                                    Settlement Attorneys
                                </td>
                                <td height="20px" style="font-weight: bold; font-size: 11px" valign="bottom">
                                    State Licenses
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 50%; vertical-align: top;">
                                    <table cellpadding="3" cellspacing="0" class="list" style="border-right: 1px solid #F0F0F0;
                                        width: 100%; vertical-align: top;">
                                        <thead>
                                            <tr>
                                                <!--<th align="center" style="width: 22">
                                                    <img id="Img6" runat="server" align="middle" alt="" border="0" src="~/images/16x16_icon.png" /></th>-->
                                                <th align="left" style="width: 15%">
                                                    Company</th>
                                                <th align="left" style="width: 15%">
                                                    Relation</th>
                                                <th>
                                                    &nbsp;
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:Repeater ID="rptCompany" runat="server">
                                                <ItemTemplate>
                                                    <tr id="trCompany" onmouseout="RowHover(this, false)" onmouseover="RowHover(this, true)"
                                                        onselectstart="return false;">
                                                        <!--<td align="center" onclick="javascript:RowClick(<%# DataBinder.Eval(Container.DataItem,"CompanyID")%>, '<%#DataBinder.Eval(Container.DataItem, "ShortCoName")%>');"
                                                            style="width: 22">
                                                            <asp:CheckBox ID="chkCompany" runat="server" Checked='<%#DataBinder.Eval(Container.DataItem, "IsRelated")%>' />
                                                        </td>-->
                                                        <td align="left" onclick="javascript:RowClick(<%# DataBinder.Eval(Container.DataItem,"CompanyID")%>, '<%#DataBinder.Eval(Container.DataItem, "ShortCoName")%>');">
                                                            <%#DataBinder.Eval(Container.DataItem, "ShortCoName")%>
                                                            <asp:HiddenField ID="hdnCompanyID" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"CompanyID")%>' />
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlRelation" runat="server" CssClass="entry" DataSource="<%# RelationTypes() %>"
                                                                DataTextField="Type" DataValueField="AttorneyTypeID" Width="150px">
                                                            </asp:DropDownList><asp:HiddenField ID="hdnRelation" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"Relation")%>' />
                                                        </td>
                                                        <td onclick="javascript:RowClick(<%# DataBinder.Eval(Container.DataItem,"CompanyID")%>, '<%#DataBinder.Eval(Container.DataItem, "ShortCoName")%>');">
                                                            &nbsp;</td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                </td>
                                <td style="width: 50%; vertical-align: top;">
                                    <table id="tblStateLic" runat="server" cellpadding="3" cellspacing="0" class="list"
                                        style="border-right: 1px solid #F0F0F0; width: 100%; vertical-align: top">
                                        <tr>
                                            <td align="center" class="headItem" style="width: 22;">
                                                <img id="Img2" runat="server" align="middle" alt="" border="0" src="~/images/16x16_icon.png" /></td>
                                            <td align="left" class="headItem" style="width: 30%">
                                                State</td>
                                            <td align="left" class="headItem" style="width: 30%">
                                                State Bar #</td>
                                            <td id="tdPrimaryHdr" runat="server" class="headItem" align="center">
                                                State Primary
                                                <asp:Label ID="lblPrimaryFor" runat="server" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                    <a class="lnk" href="javascript:AddStateLicRow();" style="color: rgb(51,118,171)">
                                        <img id="img5" runat="server" align="absmiddle" border="0" src="~/images/16x16_person.png"
                                            style="margin-left: 8; margin-right: 8;" />Add State License</a>
                                    <input id="lstStateLics" runat="server" type="Hidden" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="height: 15;">
                        &nbsp;</td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkSaveAndExit" runat="server" />
            <asp:LinkButton ID="lnkSaveAndContinue" runat="server" />
            <asp:LinkButton ID="lnkRemoveAttorney" runat="server" />
            <asp:LinkButton ID="lnkCompanyChanged" runat="server" />
            <asp:HiddenField ID="hdnAttorneyID" runat="server" Value="-1" />
            <asp:HiddenField ID="hdnSelectedCompanyID" runat="server" Value="-1" />
            <asp:HiddenField ID="hdnCurrentCompanyID" runat="server" Value="-1" />
            <asp:HiddenField ID="hdnSelectedCompanyName" runat="server" Value="" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
