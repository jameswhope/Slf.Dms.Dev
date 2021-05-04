<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="groups.aspx.vb" Inherits="admin_grouping" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        div#users-contain
        {
            width: 350px;
            margin: 20px 0;
        }
        div#users-contain table
        {
            margin: 1em 0;
            border-collapse: collapse;
            width: 100%;
        }
        div#users-contain table td, div#users-contain table th
        {
            border: 1px solid #eee;
            padding: .6em 10px;
            text-align: left;
        }
        .ui-dialog .ui-state-error
        {
            padding: .3em;
        }
        .validateTips
        {
            border: 1px solid transparent;
            padding: 0.3em;
        }
    </style>
    <script type="text/javascript">
    function refresh() {
        <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
    }
    
    function pageLoad() {
        docReady();
    }

    function docReady() {
        $(document).ready(function() {
            $( "#tabs" ).tabs();
            $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			    .find(".portlet-header")
				    .addClass("ui-widget-header ui-corner-all")
				    .prepend("<span class='ui-icon ui-icon-circle-triangle-s'></span>")
				    .end()
			    .find(".portlet-content");
            $(".portlet-header .ui-icon").click(function() {
                $(this).toggleClass("ui-icon-circle-triangle-s").toggleClass("ui-icon-circle-triangle-n");
                $(this).parents(".portlet:first").find(".portlet-content").toggle();
            });
            $(".dragUser").draggable({ revert: "invalid", handle: "p", scroll: false, opacity: 0.7, helper: "clone", containment: "window" });
            $(".dragCampaign").draggable({ revert: "valid", scroll: false, opacity: 0.7, helper: "clone", containment: 'window' });
            $(".dragBatch").draggable({ revert: "valid", scroll: false, opacity: 0.7, helper: "clone", containment: 'window' });
            $(".dragOffer").draggable({ revert: "valid", scroll: false, opacity: 0.7, helper: "clone", containment: 'window' });
            $(".dropUser").droppable({
                accept: ".dragUser",
                hoverClass: "ui-state-active",
                activeClass: "ui-state-hover",
                drop: function(event, ui) {
                    $(this).find(".placeholder").remove();
                    $("<div class='dragUser'></div>").text(ui.draggable.text()).appendTo(this);
                    setTimeout(function() { ui.draggable.remove(); }, 1); // yes, even 1ms is enough
                }
            });
            $(".dropCampaign").droppable({
                accept: ".dragCampaign",
                hoverClass: "ui-state-active",
                activeClass: "ui-state-hover",
                drop: function(event, ui) {
                    $(this).find(".placeholder").remove();
                    $("<div class='dragCampaign'></div>").text(ui.draggable.text()).appendTo(this);
                }
            });
            $(".dropBatch").droppable({
                accept: ".dragBatch",
                hoverClass: "ui-state-active",
                activeClass: "ui-state-hover",
                drop: function(event, ui) {
                    $(this).find(".placeholder").remove();
                    $("<div class='dragBatch'></div>").text(ui.draggable.text()).appendTo(this);
                }
            });
            $(".dropOffer").droppable({
                accept: ".dragOffer",
                hoverClass: "ui-state-active",
                activeClass: "ui-state-hover",
                drop: function(event, ui) {
                    $(this).find(".placeholder").remove();
                    $("<div class='dragOffer'></div>").text(ui.draggable.text()).appendTo(this);
                    setTimeout(function() { ui.draggable.remove(); }, 1); // yes, even 1ms is enough
                }
            });
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-form").dialog({
                autoOpen: false,
                height: 300,
                width: 350,
                modal: true,
                close: function() {
                    allFields.val("").removeClass("ui-state-error");
                }
            });
            $("#create-group")
			    .button({ 
			        icons: {
                        primary: "ui-icon-plusthick"
                        },
                    text: true
            });
			$("*[id$='EditButton']").button();
			$(".jqButton").button();
			$(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
			$(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
			$(".jqCancelButton")
			    .button({ 
			        icons: {
                        primary: "ui-icon-circle-close"
                        },
                    text: true
                })
			    .click(function() {
			        $("#dialog-form").dialog("close");
			    });
			$("*[id$='SaveButton']")
			    .button({ 
			        icons: {
                        primary: "ui-icon-disk"
                        },
                    text: false
                })
			.click(function() {
			        return SaveGroup(this);
    	    });
			$("*[id$='DeleteButton']")
			    .button({ 
			        icons: {
                        primary: "ui-icon-trash"
                        },
                    text: false
                })
			    .click(function() {
			        return DeleteGroup(this);
			});
            $("#td-tabs").resizable();

            $("*[id$='blcampaign']").listnav({ 
                includeAll: false, 
                includeNums: true,
                includeOther: true,
                showCounts: false,
                noMatchText: 'There are no matching entries.' 
            });
            $("*[id$='blUsers']").listnav({ 
                includeAll: false,  
                includeNums: false,
                showCounts: false,
                noMatchText: 'There are no matching entries.' 
            });
            $("*[id$='blDataBatch']").listnav({ 
                includeAll: true,  
                includeNums: true,
                showCounts: false,
                includeOther: true,
                noMatchText: 'There are no matching entries.' 
            });
            $("*[id$='blOffer']").listnav({ 
                includeAll: false,  
                includeNums: false,
                showCounts: false,
                noMatchText: 'There are no matching entries.' 
            });
            $("#sortable").sortable();
        });
    }
    </script>

    <script type="text/javascript">
        function DeleteGroup(elem) {
            var conf = confirm('Are you sure you want to delete this group?');
            if (conf == true) {
                //delete
                var tbl = elem.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
                var inps = tbl.getElementsByTagName('input');
                var groupID = -1;
                //get group id
                for (var x = 0; x < inps.length; x++) {
                    if (inps[x].type == 'hidden') {
                        groupID = inps[x].value;
                        break;
                    }
                }

                var dArray = "{";
                dArray += "'groupID': '" + groupID + "'";
                dArray += "}";

                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/DeleteGroup",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        refresh();
                        $().toastmessage('showSuccessToast', response.d);
                    },
                    error: function(response) {
                        alert(response.responseText);
                    }
                });
            }
            return false;
        }
        function SaveGroup(elem) {

            var tbl = elem.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
            var inps = tbl.getElementsByTagName('input');
            var groupID = -1;
            //get group id
            for (var x = 0; x < inps.length; x++) {
                if (inps[x].type == 'hidden') {
                    groupID = inps[x].value;
                    break;
                }
            }

            var campaigns = null;
            var members = null;
            var batches = null;
            var offers = null;
            var dvs = tbl.nextSibling.getElementsByTagName('div');
            //get users & Campaigns
            for (var x = 0; x < dvs.length; x++) {
                var did = dvs[x].parentNode.id;
                if (did.indexOf('divDropCampaigns') != -1) {
                    campaigns = dvs[x].parentNode
                }
                if (did.indexOf('divDropUsers') != -1) {
                    members = dvs[x].parentNode
                }
                if (did.indexOf('divDropBatches') != -1) {
                    batches = dvs[x].parentNode
                }
                if (did.indexOf('divDropOffers') != -1) {
                    offers = dvs[x].parentNode
                }
            }
            if (members != null && campaigns != null) {
                var m = '';//members.innerHTML;
                var c = '';//campaigns.innerHTML;
                var o = '';
                if (members != null){
                    m = ExtractValues(members);
                }
                if (campaigns != null){
                    c = ExtractValues(campaigns);
                }
                if (offers != null){
                    o = ExtractValues(offers);
                }
                var b = null;
                if (batches != null) {
                    b = ExtractValues(batches);
                }
       
                //save group
                var dArray = "{";
                dArray += "'groupID': '" + groupID + "',";
                dArray += "'members': '" + m + "',";
                dArray += "'campaigns': '" + c + "',";
                dArray += "'batches': '" + b + "',";
                dArray += "'offers': '" + o + "'";
                dArray += "}";

                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/SaveGroup",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                        refresh();
                    },
                    error: function(response) {
                        alert(response.responseText);
                    }
                });
            } else {
                alert('There are no products or members assigned to this group!');
            }

            return false;
        }
        function ExtractValues(objContainer){
            var objValues = '';
            for (var ichd = 0; ichd < objContainer.children.length; ichd++) {
                var chd = objContainer.children[ichd];
                if (chd.nodeType == 1){
                    for (var nchd = 0; nchd < chd.childNodes.length; nchd++) {
                        var cdiv = chd.childNodes[nchd];
                        if (cdiv.nodeType ==3){
                            objValues += cdiv.nodeValue + ',';
                        }
                    }
                }
            }

            return objValues
        }
        function remove(elem) {
            var p = elem.parentNode;
            p.parentNode.removeChild(p)
        }
        function InsertUpdateGroup() {
            var uid = <%=UseriD %>;
            var groupid = $("#dialog-form").data('groupid');
            var groupname = $("*[id$='name']").val();

            var dArray = "{";
            dArray += "'groupid': '" + groupid + "',";
            dArray += "'groupname': '" + groupname + "',";
            dArray += "'usercreatingid': '" + uid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/InsertUpdateGroup",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    refresh();
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });
            $("#dialog-form").dialog("close");
            return false;
        }
        
        function ShowGroup(groupid, groupname) {
            $("*[id$='name']").val(groupname);
            $("#dialog-form").data('groupid', groupid);
            
            $("#dialog-form").dialog("open");

            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Users > Groups
    </div>
    
    <asp:UpdatePanel ID="upGroups" runat="server">
        <ContentTemplate>
            <div style="width: 100%" id="dragContainer">
                <table border="0" width="100%" cellpadding="0" cellspacing="0">
                    <tr valign="top">
                        <td id="td-tabs" style="padding: 5px; width: 30%;">
                            <div id="tabs">
                                <ul>
                                    <li><a href="#tabs-1">Campaigns</a></li>
                                    <li><a href="#tabs-2">Users</a></li>
                                    <li><a href="#tabs-3">Data Batch</a></li>
                                    <li><a href="#tabs-4">Offers</a></li>
                                </ul>
                                <div id="tabs-1">
                                    <div class="portlet" id="campaign-portlet">
                                        <div class="portlet-content">
                                            <div id="ctl00_ContentPlaceHolder1_blcampaign-nav">
                                            </div>
                                            <asp:BulletedList ID="blcampaign" runat="server" DisplayMode="Text" BulletStyle="Square"
                                                DataSourceID="dscampaign" DataValueField="CampaignID" DataTextField="Campaign">
                                            </asp:BulletedList>
                                            <asp:SqlDataSource ID="dscampaign" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="SELECT  CampaignID, Campaign from tblCampaigns where MediaTypeID in (51,54,56) and Active = 1" SelectCommandType="Text"/>
                                        </div>
                                    </div>
                                </div>
                                <div id="tabs-2">
                                    <div class="portlet" id="user-portlet">
                                        <div class="portlet-content">
                                            <div id="ctl00_ContentPlaceHolder1_blUsers-nav">
                                            </div>
                                            <asp:BulletedList ID="blUsers" runat="server" DisplayMode="Text" BulletStyle="Square"
                                                DataSourceID="dsUsers" DataValueField="Userid" DataTextField="user">
                                            </asp:BulletedList>
                                            <asp:SqlDataSource ID="dsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="stp_groups_getUsers"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                                <div id="tabs-3">
                                    <div class="portlet" id="Div1">
                                        <div class="portlet-content">
                                        <div id="ctl00_ContentPlaceHolder1_blDataBatch-nav">
                                            </div>
                                            <asp:BulletedList ID="blDataBatch" runat="server" DisplayMode="Text" BulletStyle="Square"
                                                DataSourceID="dsDataBatch" DataValueField="Databatchid" DataTextField="BatchName">
                                            </asp:BulletedList>
                                            <asp:SqlDataSource ID="dsDataBatch" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="select * from tblDataBatch"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                                <div id="tabs-4">
                                    <div class="portlet" id="offer-portlet">
                                        <div class="portlet-content">
                                            <div id="ctl00_ContentPlaceHolder1_blOffer-nav">
                                            </div>
                                            <asp:BulletedList ID="blOffer" runat="server" DisplayMode="Text" BulletStyle="Square"
                                                DataSourceID="dsOffers" DataValueField="OfferID" DataTextField="Offer">
                                            </asp:BulletedList>
                                            <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="select OfferID, Offer from tblOffers where CallCenter = 1 and Active = 1" SelectCommandType="Text"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                             <hr style="height: 4px;" />
                            <button id="create-group" onclick="return ShowGroup(-1,'');">
                                Create new group</button>
                        </td>
                        <td style="padding: 5px;">
                            <div id="group-portlet" class="portlet">
                                <div class="portlet-header">
                                    Groups
                                </div>
                                <div class="portlet-content">
                                    <act:Accordion ID="accGroups" runat="server" DataSourceID="dsGroups" Width="100%"
                                        AutoSize="None">
                                        <HeaderTemplate>
                                            <div style="padding: 5px;" onmouseover="this.style.cursor='hand';" onmouseout="this.style.cursor='';">
                                                <asp:HiddenField ID="hdnGroupID" runat="server" Value='<%# Eval("GroupID") %>' />
                                                <table style="width: 100%;" border="0" class="ui-widget-header">
                                                    <tr>
                                                        <td width="50px">
                                                            <asp:Label ID="Label2" runat="server" Text="Name:" Font-Bold="true" />
                                                        </td>
                                                        <td align="left">
                                                            <asp:Label ID="lblGroupName" Style="display: inline" runat="server" Text='<%# Eval("Name") %>'
                                                                ForeColor="white" />
                                                        </td>
                                                        <td style="text-align: right!important; white-space: nowrap!important;">
                                                        <small>
                                                            <asp:LinkButton CssClass="jqEditButton" ID="lnkEditGroup" runat="server" Text="Edit" />
                                                            <asp:LinkButton  ID="SaveButton" runat="server" Text="Save" />
                                                            <asp:LinkButton  ID="DeleteButton" runat="server" Text="Delete" />
                                                         </small>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </HeaderTemplate>
                                        <ContentTemplate>
                                            <table style="width: 100%" border="0">
                                                <tr valign="top">
                                                    <td>
                                                        <table style="width: 100%;">
                                                            <tr valign="top">
                                                                <td>
                                                                    <div id="port-products" class="portlet" style="float: left;">
                                                                        <div class="portlet-header" style="background-color: #FACB47;">
                                                                            Campaigns
                                                                        </div>
                                                                        <div class="portlet-content">
                                                                            <div id="divDropCampaigns" runat="server" class="dropCampaign">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div id="port-users" class="portlet" style="float: left;">
                                                                        <div class="portlet-header" style="background-color: #FACB47;">
                                                                            Users
                                                                        </div>
                                                                        <div class="portlet-content">
                                                                            <div id="divDropUsers" runat="server" class="dropUser">
                                                                                <ul>
                                                                                    <li class="placeholder">Drop Users here</li>
                                                                                </ul>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div id="port-offers" class="portlet" style="float: left; width:45%">
                                                                        <div class="portlet-header" style="background-color: #FACB47;">
                                                                            Offers
                                                                        </div>
                                                                        <div class="portlet-content">
                                                                            <div id="divDropOffers" runat="server" class="dropOffer">
                                                                                <ul>
                                                                                    <li class="placeholder">Drop Offer here</li>
                                                                                </ul>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div id="port-batches" class="portlet" style="float: left;">
                                                                        <div class="portlet-header" style="background-color: #FACB47;">
                                                                            Batch
                                                                        </div>
                                                                        <div class="portlet-content">
                                                                            <div id="divDropBatches" runat="server" class="dropBatch">
                                                                                <ul>
                                                                                    <li class="placeholder">Drop Batch here</li>
                                                                                </ul>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <hr />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0">
                                                            <tr>
                                                                <td align="right">
                                                                    <asp:HiddenField ID="hdnGroupID" runat="server" Value='<%# Eval("GroupID") %>' />
                                                                  
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        <Panes>
                                        </Panes>
                                    </act:Accordion>
                                    <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                        SelectCommand="select * from tblgroups" DeleteCommand="delete from tblgroups where groupid = @groupid"
                                        InsertCommand="INSERT INTO tblGroups(Name, Created, CreatedBy) VALUES (@Name, GETDATE(), @CreatedBy)"
                                        UpdateCommand="UPDATE tblGroups SET Name = @Name WHERE (groupID = @groupID)">
                                        <DeleteParameters>
                                            <asp:Parameter Name="groupid" />
                                        </DeleteParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="Name" />
                                            <asp:Parameter Name="groupID" />
                                        </UpdateParameters>
                                        <InsertParameters>
                                            <asp:Parameter Name="Name" />
                                            <asp:Parameter Name="CreatedBy" />
                                        </InsertParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                           
                        </td>
                    </tr>
                </table>
            </div>
            <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-form" title="Create new group">
        <p class="validateTips">
            All form fields are required.</p>
        <fieldset>
            <label for="name">
                Group Name</label>
            <input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all" />
        </fieldset>
        <hr />
        <button class="jqSaveButton" onclick="return InsertUpdateGroup()">Save</button><button class="jqCancelButton" >Cancel</button>
    </div>
    
</asp:Content>
