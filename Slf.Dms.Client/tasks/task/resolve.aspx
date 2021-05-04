<%@ Page EnableEventValidation="false" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="resolve.aspx.vb" Inherits="tasks_task_resolve" title="DMP - Task" %>

 
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
 
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
                <td nowrap="true">
                    <a class="menuButton" href="javascript:Record_Save();">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save Task</a></td>
                <td class="menuSeparator" style="display:none">|</td>
                <td runat="server" id="tdMenuSaveForLater" nowrap="true" visible="false">
                    <a class="menuButton" href="javascript:Record_SaveForLater();">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save For Later</a></td>
                <td runat="server" id="tdMenuSaveForLaterSep" class="menuSeparator" visible="false">|</td>
                <td nowrap="true" style="display:none">
                    <a class="menuButton" runat="server" href="~/tasks/task/edit.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar_edit.png" />Edit Task</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" runat="server" href="~/tasks">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar.png" />Back to Calendar</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMenuResolved">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td style="display:none" ><img width="8" height="28" src="~/images/spacer.gif"/></td>
                <td nowrap="true" style="display:none"  >
                    <a class="menuButton" href="#" onclick="Record_ClearResolve();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_clear.png" />Clear Resolution</a></td>
                <td class="menuSeparator" style="display:none" >|</td>
                <td nowrap="true" style="display:none" >
                    <a class="menuButton" runat="server" href="~/tasks/new.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar_add.png" />Add New Task</a></td>
                <td class="menuSeparator" style="display:none" >|</td>
                <td nowrap="true">
                    <a class="menuButton" runat="server" href="~/tasks">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar.png" />Back to Calendar</a></td>
                <td style="width:100%;">&nbsp;</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif"/></td>
            </tr>
        </table>
    </asp:Panel>

</asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

    <style>
        .entry {font-family:tahoma;font-size:11px;width:100%;}
        .entry2 {font-family:tahoma;font-size:11px;}
    </style>

<body>

    <script type="text/javascript">

    function TaskInfoOpen(img)
    {
        img.style.display = "none";
        img.previousSibling.style.display = "";
 
        img.parentNode.parentNode.previousSibling.style.display = "";
    }
    function TaskInfoClose(img)
    {
        img.style.display = "none";
        img.nextSibling.style.display = "";

        img.parentNode.parentNode.previousSibling.style.display = "none";
    }
    function IsResolved()
    {
        var chkResolved = document.getElementById("<%= chkResolved.ClientID %>");

        return chkResolved.checked;
    }
    function Record_ClearResolve()
    {
        // postback to clear
        <%= Page.ClientScript.GetPostBackEventReference(lnkClear, Nothing) %>;
    }
    function Record_Save()
    {
        if (confirm("Are you sure, Do you want to save the task?"))
        {
            <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Record_SaveForLater()
    {
    }
    function OpenNotes()
    {
         var url = '<%= ResolveUrl("~/tasks/task/notes.aspx?id=") %><%= TaskID%>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Notes",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: true,
                   height: 450, width: 400,
                   onClose: function(){
                                window.location=window.location; 
                            }
                   });   
        
    }
    function SaveNotes(Value)
    {
        var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");
        var lblNotes = document.getElementById("<%= lblNotes.ClientID %>");

        txtNotes.value = Value;

        var NumValues = 0;

        if (Value.length > 0)
        {
            NumValues = Value.split("|--$--|").length;
        }

        if (NumValues > 0)
        {
            lblNotes.innerText = " (" + NumValues + ")";
        }
        else
        {
            lblNotes.innerText = "";
        }
    }
    function GetNotes()
    {
        return document.getElementById("<%= txtNotes.ClientID %>").value;
    }
    function OpenPropagations()
    {
    
         var url = '<%= ResolveUrl("~/tasks/task/propagations.aspx") %>?t=Follow up Task&id=<%=TaskID %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Follow up Task",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 650, width: 700,
                   onClose: function (){
                               afterOpenPropagations($(this).modaldialog("returnValue"));
                            }
                   });   
    }
    
    function afterOpenPropagations(r)
    {
        if(r==1)
        {
            window.location=window.location;
        }
        else if(r==2)
        {
            window.location = "<%= ResolveUrl("~/default.aspx") %>";
        } 
        else if(r==3)
        {
            OpenMatterInstance();
        }
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
        }
        else
        {
            lblPropagations.innerText = "";
        }
    }
    function GetPropagations()
    {
        return "";//document.getElementById("<%= txtPropagations.ClientID %>").value;
    }

    </script>

    <asp:panel runat="server" ID="pnlBodyDefault">
        <table style="width:100%;height:100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top">
                    <table style="width:100%;height:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td runat="server" id="tdTaskInfo" valign="top" style="width:230;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="cLEnrollHeader">Task Information</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 10 10 0 10;">
                                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                                cellspacing="0" border="0">
                                                <tr>
                                                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Status</td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5 10 20 10;">
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td nowrap="true" style="width: 55">Current:</td>
                                                                <td><asp:label runat="server" ID="lblStatusCurrent"></asp:label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 55">Created:</td>
                                                                <td><asp:label runat="server" ID="lblCreated"></asp:label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 55">Due:</td>
                                                                <td><asp:label runat="server" ID="lblDue"></asp:label></td>
                                                            </tr>
                                                            <tr id="trResolved" runat="server">
                                                                <td>Resolved:</td>
                                                                <td><asp:Label runat="server" id="lblResolvedDate"></asp:Label></td>
                                                            </tr>
                                                            <tr id="trResolution" runat="server">
                                                                <td>Resolution:</td>
                                                                <td><asp:Label runat="server" ID="lblTaskResolutionName"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trResolutionHeader">
                                                    <td style="border-bottom:solid 1px #d1d1d1;color:#a1a1a1;">Resolution</td>
                                                </tr>
                                                <tr runat="server" id="trResolutionBody">
                                                    <td style="padding:5 10 20 10;">
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td>Resolved:</td>
                                                                <td><cc1:InputMask Mask="nn/nn/nnnn nn:nn aa" ReadOnly="true" CssClass="entry" runat="server" ID="txtResolved"></cc1:InputMask><asp:Label runat="server" id="Label1"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Task Is:</td>
                                                                <td><asp:DropDownList CssClass="entry" runat="server" ID="cboTaskResolutionID"></asp:DropDownList><asp:Label runat="server" ID="Label2"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr id="trClients" runat="server">
                                                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Affected Clients</td>
                                                </tr>
                                                <tr id="trClientsList" runat="server">
                                                    <td style="padding: 5 10 20 10;">
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Repeater runat="server" ID="rpClients">
                                                                        <ItemTemplate>
                                                                            <a runat="server" class="lnk" id="lnkClientID"><img style="margin-right:8px;" runat="server" src="~/images/16x16_person.png" border="0" align="absmiddle"/><%#DataBinder.Eval(Container.DataItem, "PrimaryPersonName")%></a>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td style="border-bottom: solid 1px #d1d1d1; color: #a1a1a1">Description</td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5 10 20 10;">
                                                        <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td><asp:label runat="server" ID="lblDescription"></asp:label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="cLEnrollSplitter" style="width:40;" valign="top" align="center"><div style="padding:6 0 7 0;background-color:white;"><img title="Hide Task Info" id="imgTaskInfoClose" style="cursor:pointer;" onclick="javascript:TaskInfoClose(this);" align="absmiddle" runat="server" src="~/images/16x16_arrowleft_clear.png" /><img title="View Task Info" id="imgTaskInfoOpen" onclick="javascript:TaskInfoOpen(this);" style="cursor:pointer;display:none;" align="absmiddle" runat="server" src="~/images/16x16_arrowright_clear.png" /></div><br /><img runat="server" width="40" height="1" src="~/images/spacer.gif" /></td>
                            <td valign="top">
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
                                <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                                <tr style="background-color:#f1f1f1;">
                                                    <td class="cLEnrollHeader"><asp:Label runat="server" ID="lblType"></asp:Label></td>
                                                    <td style="padding-right:10;" align="right">  
                                                    <span id="spnMatterInstance" runat="server" visible="true" >  
                                                    <a style="color:black;" class="lnk" href="javascript:OpenMatterInstance();"><img id="Img4" border="0" align="absmiddle" src="~/images/matter.jpg" runat="server" style="margin-right:5;"/>Matter Instance</a>&nbsp;&nbsp;&nbsp;</span>
                                                     <span id="spnMatterRoadMap" runat="server" visible="false" >  <a style="color:black;" class="lnk" href="javascript:OpenMatterRoadmap();"><img id="Img3" border="0" align="absmiddle" src="~/images/16x16_flowchart.png" runat="server" style="margin-right:5;"/>Matter Roadmap</a>&nbsp;&nbsp;&nbsp;</span> <span id="spnPhoneCalls" runat="server" visible="false" >  <a style="color:black;" class="lnk" href="javascript:OpenPhoneCalls();"><img id="Img2" border="0" align="absmiddle" src="~/images/p_call.png" runat="server" style="margin-right:5;"/>Add a Phone Call</a>&nbsp;&nbsp;&nbsp;</span> <span id="spnMatterNotes" runat="server" visible="false" > <a style="color:black;" class="lnk" href="javascript:OpenMatterNotes();"><img id="Img1" border="0" align="absmiddle" src="~/images/16x16_note.png" runat="server" style="margin-right:5;"/>Add Matter Notes</a>&nbsp;&nbsp;&nbsp;</span>  <a style="color:black;" class="lnk" href="javascript:OpenNotes();"><img border="0" align="absmiddle" src="~/images/16x16_note.png" runat="server" style="margin-right:5;"/>Task Notes</a><asp:Label runat="server" ForeColor="blue" ID="lblNotes"></asp:Label>&nbsp;&nbsp;&nbsp;<a style="color:black;" href="javascript:OpenPropagations();" class="lnk"><img border="0" align="absmiddle" src="~/images/16x16_calendar_add.png" runat="server" style="margin-right:5;"/>Resolve & Followup</a><asp:Label ForeColor="blue" runat="server" ID="lblPropagations"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><asp:PlaceHolder runat="server" id="phWorkflow"></asp:PlaceHolder><asp:panel runat="server" id="pnlNoWorkflow" style="text-align:center;color:#a1a1a1;padding: 0 5 5 5;">There is no workflow section for this task.</asp:Panel></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:panel>
    <asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" align="center">
                </td>
            </tr>
        </table>
    </asp:Panel>

    <!-- The following controls are only on the page so that the client script (above)
            can fill these controls with values to be post backed with the form.  They have no inner 
            value so they will not be visibly displayed on the page -->

    <asp:CheckBox runat="server" id="chkResolved" style="display:none;" />
    <asp:DropDownList runat="server" id="cboTaskType" style="display:none;"></asp:DropDownList>
    <asp:HiddenField runat="server" ID="txtNotes" />
    <asp:HiddenField runat="server" ID="txtPropagations" />

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have no inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClear"></asp:LinkButton>

</body>

 <script>

     var dvError = null;
     var tdError = null;
     var cboParentTaskResolutionID = null;
     var txtResolved = null;
     dvError = document.getElementById("<%= dvError.ClientID %>");
     tdError = document.getElementById("<%= tdError.ClientID %>");
     cboParentTaskResolutionID = document.getElementById("<%= cboTaskResolutionID.ClientID %>");
     txtResolved = document.getElementById("<%= txtResolved.ClientID %>");
     //       
       
 </script> 
</asp:Content>