<%@ Page Language="VB" AutoEventWireup="false" CodeFile="matterroadmap.aspx.vb" Inherits="clients_client_matters_matterroadmap"%>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Matter Roadmap</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>   
    <script type="text/javascript">
    window.baseurl = "<%= ResolveUrl("~/")%>";
    
     if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
     }
     
//////////////////////////////////////////////////////////SETTING STYLE//////////////////////////////////////////////////////////////////////////////////////
function RowHover(td, on){
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
}
    
/////////////////////////////////////////////////////CHECK SELECTED DATE IS VALID AND IN RANGE/////////////////////////////////////////////////////////////////
//        function DateComare(date1Str,date2Str){
//       
//        var date1  = new Date(date1Str);
//        var date2  = new Date(date2Str);
//        var imDate = document.getElementById("<%=imDate.ClientId %>");
//        var strDate = imDate.value;
//        var ddlNewClientStatusId = document.getElementById("<%=ddlNewClientStatusId.ClientId %>");
//        var selectedCata = ddlNewClientStatusId.value;
//    if (date1 >= date2)
//    { 
//    <%= Page.ClientScript.GetPostBackEventReference(lnkChangeStatus, Nothing)%>;
//    }
// 
//    else if (date1 < date2 ||strDate.length==0 )
//    {
//      AddBorder(imDate)
//       ShowMessageBody("Please enter a valid date within 90 days from today");
//    }
//}
//commented out above and replaced with below per Corwin Tanner making proposals and not implementing in dev
function DateComare(date1Str)
{
    var date1  = new Date(date1Str);
    var date2  = new Date();
    var imDate = document.getElementById("<%=imDate.ClientId %>");
    var strDate = imDate.value;
    var ddlNewClientStatusId = document.getElementById("<%=ddlNewClientStatusId.ClientId %>");
    var selectedCata = ddlNewClientStatusId.value;
    var days = Math.round((date1 - date2) / (1000 * 60 * 60 * 24));
    
    if (days <= 90 && days >= 0)
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkChangeStatus, Nothing)%>;
    }
 
    else if (days > 90 || days < 0 || strDate.length == 0)
    {
        AddBorder(imDate);
        ShowMessageBody("Please enter a valid date within 90 days from today");
    }
}


//////////////////////////////////////////CAPTURES ENTERED DATE/////////////////////////////////////////////////////////////////////////////////////////////////      
//function ChangeStatus(){
//        var imDate = document.getElementById("<%=imDate.ClientId %>");
//        var theDate =new Date();      
//        var compareDate = (theDate.getMonth()-2 + "/" + theDate.getDate()+ "/" + theDate.getFullYear());
//        var strDate = imDate.value;        
//        DateComare(strDate,compareDate);              
//}
//commented out above and replaced with below per Corwin Tanner making proposals and not implementing in dev
    function ChangeStatus()
    {
        DateComare(document.getElementById("<%=imDate.ClientId %>").value);
    }
     
       
//////////////////////////////////////////DISPLAYED ERROR MESSAGE//////////////////////////////////////////////////////////////////////////////////////////////////////   
function ShowMessageBody(value){   
        var tdError = document.getElementById("tdError");
        var trError = document.getElementById("trError");
        
        tdError.innerHTML=value;
        trError.style.display="inline";
}
//////////////////////////////////////////CREATE INTERFACE FOR DELETING  ACTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////   

function DeleteConfirm(RoadmapId){
        document.getElementById("<%=txtRoadmapId.ClientId %>").value=RoadmapId;
        ConfirmationModalDialog({window: window, 
                                 title: "Delete Roadmap", 
                                 callback: "Delete", 
                                 message: "Are you sure you want to delete this roadmap?"});     
}


    function Delete(){
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
}

////////////////////////////////////////////////////////MAIN////////////////////////////////////////////////////////////////////////////////////////
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td>
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="bottom">
                                        <asp:Label Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                            runat="server" ID="lblName"></asp:Label>&nbsp;<a class="lnk" style="font-family: verdana;
                                                color: rgb(80,80,80);" runat="server" id="lnkNumApplicants"></a><br />
                                        <asp:Label runat="server" ID="lblAddress"></asp:Label>
                                    </td>
                                    <td align="right" valign="bottom">
                                        <asp:Label runat="server" ID="lblSSN"></asp:Label><br />
                                        Status:&nbsp;<asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server"
                                            ID="lnkStatus"></asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
                        background-repeat: repeat-x;">
                        <td>
                            <img alt="image" id="Img1" height="30" width="1" runat="server" src="~/images/spacer.gif" />
                        </td>
                    </tr>
                    <tr id="trError" style="display: none;">
                        <td style="padding-left: 20;">
                            <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                font-family: Tahoma; background-color: #ffffda; width: 100%" cellspacing="5"
                                cellpadding="0" border="0">
                                <tr>
                                    <td valign="top" style="width: 20;">
                                        <img id="Img2" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle"
                                            border="0">
                                    </td>
                                    <td id="tdError">
                                    </td>
                                </tr>
                            </table>
                            &nbsp;<br />
                        </td>
                    </tr>
                    <tr>
                        <!--   <td>
                        <asp:Label ID="lblNote" runat="server" />
                            Change Status: <asp:DropDownList runat="server" id="ddlNewClientStatusId" style="font-size:11px;font-family:tahoma" AccessKey="1"></asp:dropdownlist>
                            as of: <cc1:InputMask valCap="Date" valFun="IsValidDateTime(Input.value);" CssClass="entry" runat="server" ID="imDate" Mask="nn/nn/nnnn nn:nn aa" Width="115px"></cc1:InputMask>
                            <asp:checkbox text="As Root" id="chkAsRoot" runat="server" checked="true"></asp:checkbox>&nbsp;&nbsp;
                            <a class="lnk" href="javascript:ChangeStatus();"><img id="Img3" style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_save.png" align="absmiddle" />Change</a>
                        </td> 
                        -->
                        <td>
                            <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="bottom">
                                        <asp:Label Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                            runat="server" ID="lblMatterNumber"></asp:Label>&nbsp;<a class="lnk" style="font-family: verdana;
                                                color: rgb(80,80,80);" runat="server" id="A1"></a><br />
                                        <asp:Label runat="server" ID="lblMatterMemo"></asp:Label>
                                    </td>
                                    <td align="right" valign="bottom">
                                        <asp:Label ID="lblClientInfo" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
                                    background-repeat: repeat-x;">
                                    <td colspan="2">
                                        <img id="Img4" height="30" width="1" runat="server" src="~/images/spacer.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 100%;" valign="top">
                            <asp:Panel runat="server" ID="pnlRoadmap">
                                <asp:Literal ID="lblMatterAudits" runat="server"></asp:Literal>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkChangeStatus" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkDelete" runat="server"></asp:LinkButton>
    <input type="hidden" id="txtRoadmapId" runat="server" />
</form>
</body>
</html>