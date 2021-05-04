<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="users.aspx.vb" Inherits="admin_users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ckoptions = { langCode: 'en', skin: 'office2003',
            width: 465,
            height: 200,
            toolbar:
						 [
							 ['Source', '-', 'Bold', 'Italic', 'Underline', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat'],
							 ['Font', 'FontSize', 'Format', 'NumberedList', 'BulletedList', '-', 'TextColor']
						 ]
        };
        function ShowNotice() {
            var editor = CKEDITOR.instances.txtmsg;
            CKEDITOR.config.protectedSource.push(/<([\S]+)[^>]*class="preserve"[^>]*>.*<\/\1>/g);
            CKEDITOR.config.fillEmptyBlocks = false;
            CKEDITOR.config.fullPage = false;

            var writer = editor.dataProcessor.writer;
            writer.indentationChars = '&nbsp;';                 // The character sequence to use for every indentation step.
            writer.selfClosingEnd = ' />';                  // The way to close self closing tags, like <br />.
            writer.lineBreakChars = '';                // The character sequence to be used for line breaks.
            writer.setRules('p',                            // The writing rules for the <p> tag.
                {
                indent: false,
                breakBeforeOpen: false,
                breakAfterOpen: false,
                breakBeforeClose: false,
                breakAfterClose: false
            });
            writer.setRules('h1',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });
            writer.setRules('h2',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });
            writer.setRules('h3',
                {
                    indent: false,
                    breakBeforeOpen: false,
                    breakAfterOpen: false,
                    breakBeforeClose: false,
                    breakAfterClose: false
                });


            $("#dialog-notice").dialog("open")

        }
        function SendNotice() {

            var editor = CKEDITOR.instances.txtmsg;
            var noticehtml = editor.getData();


            var users = [];
            $("#users-list input:checked").each(function () {
                users.push(this.value);
            });

            var dArray = "{";
            dArray += "'userids': '" + users.join() + "',";
            dArray += "'type': '" + $("*[id$='ddlType']").val() + "',";
            dArray += "'msg': '" + noticehtml + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "users.aspx/SendNotice",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
            return false;

        }
        function loadUsers() {
            $("#users-list").html(loadingImg);
            $.ajax({
                type: "POST",
                url: "users.aspx/GetUsers",
                data: null,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $("#users-list").html(response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");


                $('.editor').ckeditor(ckoptions);

                $(".jqButton").button();
                $(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
                $(".jqFirstButton").button({
                    icons: {
                        primary: "ui-icon-seek-first"
                    },
                    text: false
                });
                $(".jqPrevButton").button({
                    icons: {
                        primary: "ui-icon-seek-prev"
                    },
                    text: false
                });
                $(".jqNextButton").button({
                    icons: {
                        primary: "ui-icon-seek-next"
                    },
                    text: false
                });
                $(".jqLastButton").button({
                    icons: {
                        primary: "ui-icon-seek-end"
                    },
                    text: false
                });
                $(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: false
                });
                $(".jqCancelButton").button({
                    icons: {
                        primary: "ui-icon-cancel"
                    },
                    text: false
                });
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-user").dialog({
                    autoOpen: false,
                    height: 445,
                    width: 575,
                    modal: true,
                    close: function () {
                        refresh();
                    }
                });
                $("#dialog-notice").dialog({
                    autoOpen: false,
                    height: 530,
                    width: 685,
                    modal: true,
                    open: function (event, ui) {
                        loadUsers();
                    }
                });
                $("*[id$='ddlRoles']").change(function () {
                    if ($(this).val() == 5) {
                        $("*[id$='cblWebsites']").removeAttr("disabled");
                    } else {
                        $("*[id$='cblWebsites']").attr("disabled", true);
                    }
                    loadCompanies($(this).val());
                });

            });
        }
        function ShowDialog(userid) {
            loadUser(userid)
            $("#dialog-user").data('userid', userid);
            $("#dialog-user").dialog("open")
            return false;
        }
        function CloseDialog() {
            $("#dialog-user").dialog("close")
            return false;
        }
    </script>
    <script type="text/javascript">
        function loadCompanies(roleID) {

            switch (roleID) {
                case '5': case '6': case '7':
                    var dArray = "{";
                    dArray += "'roleid': '" + roleID + "'";
                    dArray += "}";

                    $.ajax({
                        type: "POST",
                        url: "users.aspx/GetCompany",
                        data: dArray,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        success: function (response) {
                            var itms = eval('(' + response.d + ')');

                            $("*[id$='ddlCompany']").empty();
                            $("*[id$='ddlCompany']").append("<option value=''>-- Select Company --</option>");
                            for (var i = 0; i < itms.length; i++) {
                                $("*[id$='ddlCompany']").append("<option value='" + itms[i].ItemID + "'>" + itms[i].ItemName + "</option>");
                            }
                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });
                    break;
                default:
                    $("*[id$='ddlCompany']").empty();
                    $("*[id$='ddlCompany']").append("<option value=''>NA</option>");
                    break;
            }
        }
        function loadUser(userIDToLoad) {
            $("#user-table").hide()
            $("#loadingDiv").html(loadingImg);

            $("#<%=cblWebsites.ClientID %> input").each(function(){
                 $(this).attr('checked', false);
            });


            var dArray = "{";
            dArray += "'userid': '" + userIDToLoad + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "users.aspx/LoadUser",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    var u = eval('(' + response.d + ')');
                    $("*[id$='txtFirst']").val(u.FirstName);
                    $("*[id$='txtLast']").val(u.LastName);
                    $("*[id$='txtExt']").val(u.ext);
                    $("*[id$='ddlRoles']").val(u.UserTypeId);
                    loadCompanies(u.UserTypeId);

                    switch(u.UserTypeId){
                        case 5: 
                            $("#<%=cblWebsites.ClientID %> input").each(function(){
                                var chkText = $(this).parent().children("label").text();
                                for (uw in u.UserOwnedWebsites){
                                    var wval = u.UserOwnedWebsites[uw];
                                    if (chkText==wval){
                                        $(this).attr('checked', true);
                                    }
                                }
                            });
                            $("*[id$='cblWebsites']").removeAttr("disabled"); 
                            break;
                        default:
                            $("*[id$='cblWebsites']").attr("disabled", true); 
                            break;
                    }
                    
                    $("*[id$='ddlComapny']").val(u.UserTypeUniqueID);
                    if (u.GroupID == 0) {
                        $("*[id$='ddlGroups']").val('');
                    } else {
                        $("*[id$='ddlGroups']").val(u.GroupID);
                    }
                    $("*[id$='txtUserName']").val(u.UserName);

                    if (u.Active == true) {
                        $("*[id$='chkActive']").attr('checked', true);
                    } else {
                        $("*[id$='chkActive']").attr('checked', false);
                    }
                    if (u.Spanish == true) {
                        $("*[id$='chkSpanish']").attr('checked', true);
                    } else {
                        $("*[id$='chkSpanish']").attr('checked', false);
                    }
                    $("*[id$='lnkReset']").show();
                    $("#loadingDiv").html('');
                    $("#loadingDiv").hide();
                    $("#user-table").show()
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
            return false;
        }
        function validateForm(formType) {
            var bMsg = '';
            var userid = $("#dialog-user").data('userid');
            var fname = $("*[id$='txtFirst']").val();
            var lname = $("*[id$='txtLast']").val();
            var ext = $("*[id$='txtExt']").val();
            var role = $("*[id$='ddlRoles']").val();
            var company = $("*[id$='ddlCompany']").val();
            var group = $("*[id$='ddlGroups']").val();
            var active = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
            var spanish = getCheckboxValue($("*[id$='chkSpanish']").attr("checked"));
            var uname = $("*[id$='txtUserName']").val();
            var pwd = $("*[id$='txtPassword']").val();

            if (fname == '') {
                bMsg = 'First name is required!<br/>';
            }
            if (lname == '') {
                bMsg += 'Last name is required!<br/>';
            }
            if (role == '') {
                bMsg += 'A user must belong to a Role!<br/>';
            }
            switch (formType) {
                case -1:
                    if (uname == '') {
                        bMsg += 'User name is required!<br/>';
                    }
                    if (pwd == '') {
                        bMsg += 'Password is required!<br/>';
                    }
                    if (pwd.length< 5 ){
                        bMsg += 'Password must be longer than 4 characters!<br/>';
                    }
                    
                    break;
                default:
                   
                    break;
            }
            return bMsg;            
        }
        function saveUser() {
            var userid = $("#dialog-user").data('userid');
            var fname = $("*[id$='txtFirst']").val();
            var lname = $("*[id$='txtLast']").val();
            var ext = $("*[id$='txtExt']").val();
            var role = $("*[id$='ddlRoles']").val();
            var company = $("*[id$='ddlCompany']").val();
            var group = $("*[id$='ddlGroups']").val();
            var active = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
            var spanish = getCheckboxValue($("*[id$='chkSpanish']").attr("checked"));
            var uname = $("*[id$='txtUserName']").val();
            var pwd= $("*[id$='txtPassword']").val();


            var cuser = new Object;
            cuser.UserID = userid;
            cuser.FirstName = fname;
            cuser.LastName = lname;
            cuser.ext = ext;
            if (company!=''){
                cuser.UserTypeUniqueID=company;
            }
            cuser.UserName=uname;
            cuser.Password = pwd;
            cuser.Active = active;
            cuser.Spanish = spanish;

            if (role == '') {
                role = '-1';
            }
            cuser.UserTypeId = role;
            if (group == '') {
                group = '-1';
            }
            cuser.GroupID =group;

            var vMsg = validateForm(userid);
            if (vMsg != '') {
                showStickyToast(vMsg, 'error');
                return false;
            }

            var witems = new Array;
            $("#<%=cblWebsites.ClientID %> input").each(function(){
                if (this.checked) { 
                    var lbl = $(this).parent().children("label").text();
                    witems.push(lbl);
                }
            });
            cuser.UserOwnedWebsites = witems;

            var DTO = { 'currentuser': cuser };
            
            $.ajax({
                type: "POST",
                url: "users.aspx/SaveUser",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showSuccessToast', response.d);
                    refresh();
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
            return false;
        }
        function resetPwd() {
            var userid = $("#dialog-user").data('userid');
            var newpassword = $("*[id$='txtPassword']").val();

            //reset pwd
            var dArray = "{";
            dArray += "'userid': '" + userid + "',";
            dArray += "'newpassword': '" + newpassword + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "users.aspx/ResetPassword",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
            return false;
        }
        function CreateUser() {
            $("*[id$='txtFirst']").val('');
            $("*[id$='txtLast']").val('');
            $("*[id$='txtExt']").val('');
            $("*[id$='ddlRoles']").val('');
            loadCompanies(-1)
            $("*[id$='ddlComapny']").val('');
            $("*[id$='ddlGroups']").val('');
            $("*[id$='txtUserName']").attr("disabled", false); 
            $("*[id$='txtUserName']").val('');
            $("*[id$='txtPassword']").val('123456');
            $("*[id$='chkActive']").attr('checked', false);
            $("*[id$='chkSpanish']").attr('checked', false);

            $("*[id$='lnkReset']").hide();
            $("#dialog-user").data('userid', -1);
            $("#dialog-user").dialog("open")
        }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkFilterClear, Nothing) %>;
        }
    </script>
    <style type="text/css">
        .style1
        {
            width: 92px;
        }
        .style2
        {
            width: 140px;
        }
        .style3
        {
            width: 53px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Users > Users
    </div>
    <br style="clear: both" />
    <asp:UpdatePanel ID="upUsers" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-content">
                    <div id="filter-div">
                        <table style="width: 100%" class="ui-widget-header">
                            <tr>
                                <td>
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upUsers">
                                        <ProgressTemplate>
                                            <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </td>
                                <td class="style1">
                                    Search Users:
                                </td>
                                <td class="style2">
                                    <asp:TextBox ID="txtFilter" runat="server" Height="15" />
                                </td>
                                <td>
                                    <small>
                                        <asp:LinkButton ID="lnkFilter" runat="server" Text="Search" 
                                        CssClass="jqButton" />
                                        <asp:LinkButton ID="lnkFilterClear" runat="server" Text="Clear" CssClass="jqButton" />
                                    </small>
                                </td>
                                <td class="style3">
                                    Status:</td>
                                <td>
                                    <asp:RadioButtonList ID="rblUserType" runat="server" AutoPostBack="true" 
                                        RepeatDirection="Horizontal" RepeatLayout="Flow">
                                        <asp:ListItem Selected="True" Text="Active" Value="1" />
                                        <asp:ListItem Text="Inactive" Value="0" />
                                    </asp:RadioButtonList>
                                </td>
                                <td style="text-align: right">
                                    Roles:
                                    <asp:DropDownList ID="ddlRoleFilter" runat="server" DataSourceID="dsRoles" AutoPostBack="true"
                                        DataTextField="UserTypeName" DataValueField="UserTypeID" AppendDataBoundItems="true">
                                        <asp:ListItem Text="All" Value="-1" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:GridView ID="gvUsers" runat="server" AllowPaging="True" AllowSorting="True"
                        AutoGenerateColumns="False" DataKeyNames="UserId" DataSourceID="dsUsers" Width="100%"
                        GridLines="None" PageSize="15">
                        <HeaderStyle Height="30" />
                        <Columns>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <small>
                                        <asp:LinkButton ID="lnkShowDialog" runat="server" Text="Edit" CssClass="jqEditButton" />
                                    </small>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" Width="40" />
                                <ItemStyle HorizontalAlign="Center" CssClass="ui-widget-content" Width="40" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="UserId" HeaderText="UserId" InsertVisible="False" ReadOnly="True"
                                SortExpression="UserId" Visible="True">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" Width="75" />
                                <ItemStyle CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Username" HeaderText="Username" InsertVisible="False"
                                ReadOnly="True" SortExpression="Username" Visible="True">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FirstName" HeaderText="FirstName" ReadOnly="True" SortExpression="FirstName">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastName" HeaderText="LastName" ReadOnly="True" SortExpression="LastName">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="Active" HeaderText="Active" SortExpression="Active">
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" Width="50" />
                                <ItemStyle HorizontalAlign="Center" CssClass="ui-widget-content" Width="50" />
                            </asp:CheckBoxField>
                            <asp:BoundField DataField="ext" HeaderText="ext" ReadOnly="True" SortExpression="ext">
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" Width="40" />
                                <ItemStyle HorizontalAlign="Center" CssClass="ui-widget-content" Width="40" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="Spanish" HeaderText="Spanish" SortExpression="Spanish">
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" Width="60" />
                                <ItemStyle HorizontalAlign="Center" CssClass="ui-widget-content" Width="60" />
                            </asp:CheckBoxField>
                            <asp:BoundField DataField="GroupID" HeaderText="GroupID" SortExpression="GroupID"
                                Visible="False" />
                            <asp:BoundField DataField="UserTypeName" HeaderText="Role" ReadOnly="True" SortExpression="UserTypeName">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" Width="150" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" Width="150" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Company" HeaderText="Company" ReadOnly="True" SortExpression="Company">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" Width="150" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" Width="150" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Group" ReadOnly="True" SortExpression="Name">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" Width="150" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" Width="150" />
                            </asp:BoundField>
                        </Columns>
                        <PagerTemplate>
                            <div id="pager" style="background-color: #DCDCDC">
                                <table style="width: 100%">
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                ID="btnFirst" CssClass="jqFirstButton" />
                                            <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                ID="btnPrevious" CssClass="jqPrevButton" />
                                            Page
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true"
                                                OnSelectedIndexChanged="pageSelector_SelectedIndexChanged" />
                                            of
                                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                ID="btnNext" CssClass="jqNextButton" />
                                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                ID="btnLast" CssClass="jqLastButton" />
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton Text="Create New User" runat="server" ID="LinkButton1" CssClass="jqButton"
                                                OnClientClick="return CreateUser();" Style="float: right!important" />
                                            <asp:LinkButton Text="Notify User(s)" runat="server" ID="LinkButton2" CssClass="jqButton"
                                                OnClientClick="return ShowNotice();" Style="float: right!important" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT u.UserId, u.UserName, u.FirstName, u.LastName, u.Active, u.ext, u.Spanish, u.GroupID, g.Name, ut.UserTypeName, u.UserTypeUniqueID, CASE u.UserTypeId WHEN 5 THEN (SELECT tblAffiliate.Name FROM tblAffiliate WHERE AffiliateID = u.UserTypeUniqueID) WHEN 6 THEN (SELECT tblBuyers.Buyer FROM tblBuyers WHERE BuyerID = u.UserTypeUniqueID) WHEN 7 THEN (SELECT tblAdvertiser.Name FROM tblAdvertiser WHERE AdvertiserID = u.UserTypeUniqueID) END AS Company, u.FirstName + ' ' + u.LastName AS FullName FROM tblUser AS u INNER JOIN tblUserTypes AS ut ON u.UserTypeId = ut.UserTypeId LEFT OUTER JOIN tblGroups AS g ON u.GroupID = g.GroupId WHERE (ISNULL(u.Active, 0) = @active) AND (u.UserTypeId = @roleid) OR (ISNULL(u.Active, 0) = @active) AND (@roleid = - 1) ORDER BY u.FirstName"
                        UpdateCommand="UPDATE tblUser SET Active = @Active, Spanish = @Spanish WHERE (UserId = @UserId)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="rblUserType" Name="active" PropertyName="SelectedValue"
                                DefaultValue="1" />
                            <asp:ControlParameter ControlID="ddlRoleFilter" DefaultValue="-1" Name="roleid" PropertyName="SelectedValue" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Active" />
                            <asp:Parameter Name="Spanish" />
                            <asp:Parameter Name="UserId" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-user">
        <div id="loadingDiv">
        </div>
        <table id="user-table" class="ui-widget-content" style="width: 100%">
            <tr>
                <td class="tdHdr">
                    <asp:Label ID="lblFName" runat="server" Text="First Name" />
                </td>
                <td>
                    <asp:TextBox ID="txtFirst" runat="server" />
                    &nbsp;
                </td>
                <td rowspan="10" valign="top">
                    <div class="portlet" id="website-div">
                        <div class="portlet-header">
                            Websites</div>
                        <div class="portlet-content">
                            <asp:CheckBoxList ID="cblWebsites" runat="server" DataSourceID="dsWebsites" DataTextField="Name"
                                DataValueField="WebsiteID" />
                            <asp:SqlDataSource ID="dsWebsites" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="SELECT WebsiteID, Name FROM tblWebsites where type > 0"></asp:SqlDataSource>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    <asp:Label ID="lblLName" runat="server" Text="Last Name" />
                </td>
                <td>
                    <asp:TextBox ID="txtLast" runat="server" />
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    <asp:Label ID="lblExt" runat="server" Text="Ext" />
                </td>
                <td>
                    <asp:TextBox ID="txtExt" runat="server" />
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    Role
                </td>
                <td>
                    <asp:DropDownList ID="ddlRoles" runat="server" DataSourceID="dsRoles" DataTextField="UserTypeName"
                        DataValueField="UserTypeId" AppendDataBoundItems="true">
                        <asp:ListItem Text="NA" Value="" />
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsRoles" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT [UserTypeId], [UserTypeName] FROM [tblUserTypes] ORDER BY [UserTypeName]">
                    </asp:SqlDataSource>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    Company
                </td>
                <td>
                    <asp:DropDownList ID="ddlCompany" runat="server" DataSourceID="dsCompany" DataTextField="Name"
                        DataValueField="uniqueID" AppendDataBoundItems="True">
                        <asp:ListItem Text="NA" Value="" />
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsCompany" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_users_getRoleIdentity" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlRoles" Name="roleid" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    <asp:Label ID="lblGroup" runat="server" Text="Group" />
                </td>
                <td>
                    <asp:DropDownList ID="ddlGroups" runat="server" DataSourceID="dsGroups" DataTextField="Name"
                        DataValueField="GroupId" AppendDataBoundItems="true">
                        <asp:ListItem Text="NA" Value="" />
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT [GroupId], [Name] FROM [tblGroups] ORDER BY [Name]"></asp:SqlDataSource>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    &nbsp;
                </td>
                <td>
                    <asp:CheckBox ID="chkActive" runat="server" Text="Active" />
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    &nbsp;
                </td>
                <td>
                    <asp:CheckBox ID="chkSpanish" runat="server" Text="Spanish" />
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    UserName
                </td>
                <td>
                    <asp:TextBox ID="txtUserName" runat="server" Enabled="false" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr">
                    Password
                </td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" />
                    <asp:LinkButton ID="lnkReset" runat="server" Text="Reset" OnClientClick="return resetPwd();"
                        Style="color: Blue; text-decoration: underline" />
                </td>
            </tr>
            <tr>
                <td colspan="3" class="tdHdr">
                    <hr />
                    <asp:LinkButton ID="lnkSaveUser" runat="server" Text="Save" CssClass="jqButton" Style="float: right!important"
                        OnClientClick="return saveUser();" />
                    <asp:LinkButton ID="lnkCancel" runat="server" Text="Cancel" CssClass="jqButton" Style="float: right!important"
                        OnClientClick="return CloseDialog();" />
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
    <div id="dialog-notice">
        <table id="Table1" class="ui-widget-content" style="width: 100%">
            <tr>
                <td class="ui-widget-header">
                    Users
                </td>
                <td width="10px">
                    &nbsp;
                </td>
                <td class="ui-widget-header">
                    Type
                </td>
            </tr>
            <tr>
                <td style="padding: 5px; width: 250px;" rowspan="3" valign="top">
                    <div id="users-list" style="height: 350px; overflow-y: scroll; overflow-x: hidden;">
                    </div>
                </td>
                <td style="padding: 5px;" rowspan="3">
                    &nbsp;
                </td>
                <td style="padding: 5px;">
                    <asp:DropDownList ID="ddlType" runat="server" DataSourceID="dsTypes" DataTextField="TypeName"
                        DataValueField="NotificationTypeID">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsTypes" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT [NotificationTypeID], [TypeName] FROM [tblPortalNotificationTypes] ORDER BY [TypeName]">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="ui-widget-header">
                    Message
                </td>
            </tr>
            <tr>
                <td style="padding: 5px;">
                    <textarea name="txtmsg" class="editor" rows="5" id="txtmsg" style="width: 100%"></textarea>
                </td>
            </tr>
            <tr>
                <td style="padding: 5px;" colspan="3">
                    <hr />
                    <asp:LinkButton Text="Send Notification(s)" runat="server" ID="LinkButton2" CssClass="jqButton"
                        OnClientClick="return SendNotice();" Style="float: right!important" />
                    <asp:LinkButton Text="Cancel" runat="server" ID="LinkButton3" CssClass="jqButton"
                        OnClientClick="$('#dialog-notice').dialog('close'); return false;" Style="float: right!important" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
