<%@ Page Language="VB" AutoEventWireup="false" CodeFile="action.aspx.vb" Inherits="research_queries_clients_duplicates_action" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Research - Checks To Print</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>

<body onload="AutoSelect(document.getElementById('tblPage0'));">
<form id="frmBody" runat="server">
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    }

	function Resolve()
	{
		LoadControls();
		
		//Build resolution values
		var txtClients = document.getElementById("txtClients");
		var txtCoapps = document.getElementById("txtCoapps");
		var txtAccounts = document.getElementById("txtAccounts");
		var txtNotes = document.getElementById("txtNotes");
		var txtPhoneCalls = document.getElementById("txtPhoneCalls");
		var txtRegisters  = document.getElementById("txtRegisters");
		
		var tblClients = WizardPages[0].tBodies[0];
		var tblCoapps = WizardPages[1].tBodies[0];
		var tblAccounts = WizardPages[2].tBodies[0];
		var tblNotes = WizardPages[3].tBodies[0];
		var tblPhoneCalls = WizardPages[4].tBodies[0];
		var tblRegisters = WizardPages[5].tBodies[0];
		
		if (tblClients.getAttribute("empty") != "True")
		{
		    for (var i = 1; i < tblClients.rows.length; i++)
		    {
		        var row = tblClients.rows[i];
		        var field = row.cells[0].innerHTML;
		        var value = row.cells[row.cells.length - 1].getAttribute("value");
		        AddValue(txtClients, field + "|,|" + value);
		    }
		}
		
		if (tblCoapps.getAttribute("empty") != "True")
		{
		    for (var i = 0; i < tblCoapps.rows.length; i++)
		    {
		        var cell = tblCoapps.rows[i].cells[0];
		        var id=cell.getAttribute("id");
		        var checked = cell.firstChild.checked;
		        AddValue(txtCoapps, id + "|,|" + checked);
		    }
		}
		
		if (tblAccounts.getAttribute("empty") != "True")
		{
		    for (var i = 0; i < tblAccounts.rows.length; i++)
		    {
		        var cell = tblAccounts.rows[i].cells[0];
		        var id=cell.getAttribute("id");
		        var checked = cell.firstChild.checked;
		        AddValue(txtAccounts, id + "|,|" + checked);
		    }
		}
		
		if (tblNotes.getAttribute("empty") != "True")
		{
		    for (var i = 0; i < tblNotes.rows.length; i++)
		    {
		        var cell = tblNotes.rows[i].cells[0];
		        var id=cell.getAttribute("id");
		        var checked = cell.firstChild.checked;
		        AddValue(txtNotes, id + "|,|" + checked);
		    }
		}
		
		if (tblPhoneCalls.getAttribute("empty") != "True")
		{
		    for (var i = 0; i < tblPhoneCalls.rows.length; i++)
		    {
		        var cell = tblPhoneCalls.rows[i].cells[0];
		        var id=cell.getAttribute("id");
		        var checked = cell.firstChild.checked;
		        var PersonID = cell.children[1].value;
		        AddValue(txtPhoneCalls, id + "|,|" + checked + "|,|" + PersonID);
		    }
		}
		
		if (tblRegisters.getAttribute("empty") != "True")
		{
		    for (var i = 0; i < tblRegisters.rows.length; i++)
		    {
		        var cell = tblRegisters.rows[i].cells[0];
		        var id=cell.getAttribute("id");
		        var checked = cell.firstChild.checked;
		        AddValue(txtRegisters, id + "|,|" + checked);
		    }
		}
		<%=Page.ClientScript.GetPostBackEventReference(lnkResolve, Nothing) %>;
	}
	function AddValue(txt, val)
	{
	    if (txt.value.length > 0)
	        txt.value += "|||";
	    txt.value += val;
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
	
	var WizardPages = null;
	var tdCancel = null;
	var tdPrevious = null;
	var tdNext = null;
	var tdResolve = null;
	

	function LoadControls()
	{
		if (WizardPages == null)
		{	
			WizardPages = new Array(
				document.getElementById("tblPage0"),
				document.getElementById("tblPage1"),
				document.getElementById("tblPage2"),
				document.getElementById("tblPage3"),
				document.getElementById("tblPage4"),
				document.getElementById("tblPage5")
			);
			
			tdCancel = document.getElementById("<%=tdCancel.ClientID %>");
			tdPrevious = document.getElementById("<%=tdPrevious.ClientID %>");
			tdNext = document.getElementById("<%=tdNext.ClientID %>");
			tdResolve = document.getElementById("<%=tdResolve.ClientID %>");
		}
	}
	function CurrentPage()
	{
		LoadControls();
		for (var i = 0; i < WizardPages.length; i++)
		{
			var page = WizardPages[i];
			if (page.style.display != "none")
			{
				return i;
			}
		}
	}
	function SetPage(page)
	{
		LoadControls();
		for (var i = 0; i < WizardPages.length; i++)
		{
			if (page != i)
				WizardPages[i].style.display = "none";
			else
				WizardPages[i].style.display = "block";
		}
				
	}
	function Next()
	{
		LoadControls();
		var NextPage = CurrentPage() + 1;
		
		while (WizardPages[NextPage].getAttribute("empty") == "True")
			NextPage++;
			
		SetPageValues(NextPage);
				
		if (NextPage >= WizardPages.length - 1)
		{
			SetPage(WizardPages.length - 1);
			tdCancel.style.display = "none";
			tdPrevious.style.display = "block";
			tdNext.style.display = "none";
			tdResolve.style.display = "block";
		}
		else
		{
			SetPage(NextPage);
			tdCancel.style.display = "none";
			tdPrevious.style.display = "block";
			tdNext.style.display = "block";
			tdResolve.style.display = "none";
		}
		
	}
	function Previous()
	{
		LoadControls();
		
		var PrevPage = CurrentPage() - 1;
		
		while (WizardPages[PrevPage].getAttribute("empty") == "True")
			PrevPage--;
		
		SetPageValues(PrevPage);
		
		if (PrevPage <= 0)
		{
			SetPage(0);
			tdCancel.style.display = "block";
			tdPrevious.style.display = "none";
			tdNext.style.display = "block";
			tdResolve.style.display = "none";
		}
		else
		{
			SetPage(PrevPage);
			tdCancel.style.display = "none";
			tdPrevious.style.display = "block";
			tdNext.style.display = "block";
			tdResolve.style.display = "none";
		}
		
	}
	function AutoSelect(tbl)
	{
		if (tbl.tBodies[0].rows.length > 0)
		{
			SelRow1(tbl.tBodies[0].rows[1].cells[1]);
			
			//set to the first non-blank value, for fields which are blank
			//on the first client.
			for (var i = 1; i < tbl.tBodies[0].rows.length; i++)
				if (tbl.tBodies[0].rows[i].cells[1].innerHTML == "")
					for (var j = 1; j < tbl.tBodies[0].rows[i].cells.length; j++)
						if (tbl.tBodies[0].rows[i].cells[j].innerHTML != "")
						{
							tbl.tBodies[0].rows[i].cells[j].click();
							break;
						}
		}
	}
	function SetPageValues(page)
	{
		switch (page)
		{
			case 4:
				var tbl = WizardPages[4].tBodies[0];
				for (var i = 0; i < tbl.rows.length; i++)
				{
					var row = tbl.rows[i];
					var ddl = row.children[0].children[1];
					
					//nuke current values
					ddl.innerHTML="";
								
					var prim = document.createElement("option");
					ddl.options.add(prim);
					prim.innerText = "Primary";
					prim.value = "-1";
					var tblCoapps = WizardPages[1].tBodies[0];
					if (tblCoapps.getAttribute("empty") != "True")
					{
						//add selected coapps
						for (var j = 0; j < tblCoapps.rows.length; j++)
						{
							var rowCoapps = tblCoapps.rows[j];
							var chk = rowCoapps.children[0].children[0];
							if (chk.checked == true)
							{
						 		var co = document.createElement("option");
								ddl.options.add(co);
								var lbl = rowCoapps.children[0].children[1];
								co.innerText = lbl.innerHTML;
								co.value = rowCoapps.children[0].getAttribute("id");
							}
						}
					}
				}
				break;
		}
	}
	function SelCell1(cell)
	{
		var tr = cell.parentElement;
		for (var i = 0; i < tr.cells.length; i++)
			tr.cells[i].className = "UnSelected";
		
		cell.className = "Selected";
		tr.cells[tr.cells.length-1].innerHTML=cell.innerHTML;
		
		var value = cell.getAttribute("value");
		if (value == null) 
		    value=cell.innerHTML;
		tr.cells[tr.cells.length-1].setAttribute("value",value);
	}
	function SelRow1(cell)
	{
		var tr = cell.parentElement;
		var tbl = tr.parentElement.parentElement;
		for (var i = 1; i < tbl.tBodies[0].rows.length; i++)
			tbl.tBodies[0].rows[i].cells[cell.cellIndex].click();
	}
    </script>
   <style type="text/css">
	   td.Selected{background-color:rgb(225,225,225)}
	   td.UnSelected{background-color:white}
   </style>
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError"></td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                </td>
            </tr>
            <tr id="trPage0" runat="server">
                <td valign="top" style="padding-left:10;height:100%;">
                    <div style="height:100%;overflow:auto;">
                        <table class="list" id="tblPage0" style="table-layout:fixed;font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                            cellpadding="0" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Clients<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage0" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                        <table empty="<%=PageEmpty1%>" id="tblPage1" style="font-family: tahoma; font-size: 11px;
                            width: 100%; display: none" border="0" cellpadding="5" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Coapplicants<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage1" runat="server"></asp:Literal>
                            </tbody> 
                        </table>
                        <table empty="<%=PageEmpty2%>" id="tblPage2" style="font-family: tahoma; font-size: 11px;
                            width: 100%; display: none" border="0" cellpadding="5" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Accounts<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage2" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                        <table empty="<%=PageEmpty3%>" id="tblPage3" style="font-family: tahoma; font-size: 11px;
                            width: 100%; display: none" border="0" cellpadding="5" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Notes<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage3" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                        <table empty="<%=PageEmpty4%>" id="tblPage4" style="font-family: tahoma; font-size: 11px;
                            width: 100%; display: none" border="0" cellpadding="5" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Phone Calls<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage4" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                        <table empty="<%=PageEmpty5%>" id="tblPage5" style="font-family: tahoma; font-size: 11px;
                            width: 100%; display: none" border="0" cellpadding="5" cellspacing="0">
                            <thead>
                                <tr>
                                    <td>
                                        Registers<br />
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltrPage5" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
							<td id="tdCancel" runat="server" ><a tabindex="3" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Cancel and Close</a></td>
							<td id="tdPrevious" runat="server" style="display:none"><a tabindex="3" style="color:black" class="lnk" href="javascript:Previous();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Previous</a></td>
                            <td id="tdNext" runat="server" align="right"><a tabindex="4" style="color:black" class="lnk" href="javascript:Next();">Next<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                            <td id="tdResolve" runat="server" align="right" style="display:none"><a tabindex="4" style="color:black" class="lnk" href="javascript:Resolve();">Resolve<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <asp:LinkButton runat="server" id="lnkResolve"></asp:LinkButton>
		<cc1:InputMask runat="Server" ID="dummyIM" style="display:none"></cc1:InputMask>
		<input type="hidden" runat="server" id="txtClients" />
		<input type="hidden" runat="server" id="txtCoapps" />
		<input type="hidden" runat="server" id="txtAccounts" />
		<input type="hidden" runat="server" id="txtNotes" />
		<input type="hidden" runat="server" id="txtPhoneCalls" />
		<input type="hidden" runat="server" id="txtRegisters" />
    </form>
</body>
</html>