<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="advertiser.aspx.vb" Inherits="admin_advertiser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
    
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-advert").dialog({
                    autoOpen: false,
                    height: 595,
                    width: 810,
                    modal: true,
                    position: [300, 50],
                    stack: true,
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-upload").dialog({
                    autoOpen: false,
                    height: 500,
                    width: 520,
                    modal: true,
                    stack: true,
                    close: function() {
                        //refresh();
                        getDocuments();
                    }
                });
                $("#dialog-contact").dialog({
                    autoOpen: false,
                    height: 260,
                    width: 320,
                    modal: true,
                    stack: true,
                    close: function() {
                        getContacts();
                    }
                });
                var $tabs = $("#advertisertab").tabs({
                    select: function(e, ui) {
                        var thistab = ui.index;
                        switch (thistab) {
                            case 0:
                                break;
                            case 1:
                                getOfferData(thistab);
                                break;
                            case 2:
                                //get contacts
                                getContacts()
                            case 3:
                                //get contacts
                                getDocuments()                                
                            default:
                                break;
                        }
                    }
                });
                $(".jqButton").button();
                $(".jqSaveButton")
                    .button({
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
                 $("#uploader").pluploadQueue({        
                    // General settings,silverlight,browserplus,html5gears,        
                    runtimes: 'gears,flash,silverlight,browserplus,html5',        
                    url: '../handlers/FileUploaderHandler.ashx' ,        
                    max_file_size: '10mb',        
                    unique_names: false,         
                    // Specify what files to browse for        
                    filters: [        
                    { title: "Buyer files", extensions: "html,htm,txt,rtf,pdf" }],
                    // Flash settings        
                    flash_swf_url: '../jquery/plupload/plupload.flash.swf',         
                    // Silverlight settings        
                    silverlight_xap_url: '../jquery/plupload/plupload.silverlight.xap',   
                    // PreInit events, bound before any internal events
                    preinit : {
                        UploadFile: function(up, file) {
                            // You can override settings before the file is uploaded
                             up.settings.url = '../handlers/FileUploaderHandler.ashx?type=advertiser';
                             up.settings.multipart_params = {advertiserid : $("#dialog-advert").data('advertiserid')}
                        }
                    },
                    init: {  
                        Error: function(up, args) {
                            // Called when a error has occured
                            $().toastmessage('showErrorToast', args);
                        }
                    }    
                });
                // Client side form validation    
                /*$('form').submit(function (e) {        
                    var uploader = $('#uploader').pluploadQueue();         
                    // Validate number of uploaded files        
                    if (uploader.total.uploaded == 0) {            
                        // Files in queue upload them first            
                        if (uploader.files.length > 0) {                
                            // When all files are uploaded submit form                
                            uploader.bind('UploadProgress', function () {                    
                                if (uploader.total.uploaded == uploader.files.length)                        
                                    $('form').submit();                
                            });                 
                            uploader.start();            
                        } else {               
                            alert('You must at least upload one file.');             
                        }
                        e.preventDefault();        
                    }    
                });*/
            });
        }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
    }
    </script>
    <script type="text/javascript">
        function ShowAdvertiser(advertiserid, name, accountmanager, website, billingcycle, street, city, state, zip, country, notes, active) {
            $("*[id$='txtName']").val(name);
            $("*[id$='txtAcctMgr']").val(accountmanager);
            $("*[id$='txtWebsite']").val(website);
            $("*[id$='ddlBillingCycle']").val(billingcycle);
            $("*[id$='txtStreet']").val(street);
            $("*[id$='txtCity']").val(city);
            $("*[id$='ddlState']").val(state);
            $("*[id$='txtZip']").val(zip);
            $("*[id$='ddlCountry']").val(country);
            $("*[id$='txtNotes']").val(notes);
            
            if (active.toLowerCase() == 'true') {
                $("*[id$='chkActive']").attr('checked', true);
            } else {
                $("*[id$='chkActive']").attr('checked', false);
            }
            $("#advertisertab").tabs({ selected: 0 });
            $("#dialog-advert")
                .data('advertiserid', advertiserid)
                .dialog("open");

            if (advertiserid > 0)
                name = 'Advertiser #' + advertiserid + ' - ' + name;
                
            $("#dialog-advert").dialog("option", "title", name);
        }
        
        function SaveAdvertiser() {
            var newadvertiser = new Object();
            newadvertiser.AdvertiserID = $("#dialog-advert").data('advertiserid');
            newadvertiser.Name = $("*[id$='txtName']").val();
            newadvertiser.AccountManager = $("*[id$='txtAcctMgr']").val();
            newadvertiser.Website = $("*[id$='txtWebsite']").val();
            newadvertiser.BillingCycle = $("*[id$='ddlBillingCycle']").val();
            newadvertiser.Street = $("*[id$='txtStreet']").val();
            newadvertiser.City = $("*[id$='txtCity']").val();
            newadvertiser.State = $("*[id$='ddlState']").val();
            newadvertiser.Zip = $("*[id$='txtZip']").val();
            newadvertiser.Country = $("*[id$='ddlCountry']").val();
            newadvertiser.Notes = $("*[id$='txtNotes']").val();
            newadvertiser.Active = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
  
            var DTO = { 'newadvertiser': newadvertiser };
 
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/InsertUpdateAdvertiser",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    showStickyToast(response.responseText, 'showErrorToast')
                }
            });
            return false;
        }
        function getOfferData(tab) {
            $('#divOffersGrid').html(loadingImg);
            var aid = $("#dialog-advert").data('advertiserid');
            var dArray = "{'advertiserid': '" + aid + "'}";
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetOffers",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divOffersGrid').html(response.d);

                }
            });
            return false;
        }        
    </script>
    <script type="text/javascript">
        //documents
        function getDocuments() {
            $('#tblDocuments').html(loadingImg);
            var aid = $("#dialog-advert").data('advertiserid');

            var dArray = "{";
            dArray += "'docType': '1',";
            dArray += "'uniqueID': '" + aid + "'";
            dArray += "}";
            
            
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetDocuments",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#tblDocuments').html(response.d);
                    $('#tblDocumentsTable').dataTable( {
                        "bJQueryUI": true,
                        "bLengthChange": false,
                        "bSort": false,
                        "aaSorting": []
				    });
                }
            });
            return false;
        }

        function ShowUploadDocument() {
            var aid =  $("#dialog-advert").data('advertiserid');

            $("#dialog-upload")
                .data('AdvertiserID', aid)
                .dialog("open");
            return false;
        }
        function ViewDocument(docpath) {
            window.open(docpath);
        }
        function DeleteDocument(docid) {
            if (confirm('Are you sure you want to delete this document?')) {

                var dArray = "{";
                dArray += "'docType': '1',";
                dArray += "'uniqueID': '" + docid + "'";
                dArray += "}";
                
                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/DeleteDocument",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                        getDocuments();
                    }
                });
            }
            return false;
        }
    </script>
<script type="text/javascript">
    //contacts
    function getContacts() {
        $('#contactHolder').html(loadingImg);
        var aid = $("#dialog-advert").data('advertiserid');

        var dArray = "{";
        dArray += "'conType': '2',";
        dArray += "'uniqueID': '" + aid + "'";
        dArray += "}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetContacts",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#contactHolder').html(response.d);
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });
        return false;
    }
    function AddContact() {
        var aid = $("#dialog-advert").data('advertiserid');
        $("*[id$='txtPhone']").mask("(999) 999-9999");
        $("#dialog-contact")
                .data('advertiserid', aid)
                .data('contactid', -1)
                .dialog("open");
        return false;
    }
    function SaveContact() {
        var cid = $("#dialog-contact").data('contactid');
        var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

        var fname = $("*[id$='txtFullName']").val();
        var email = $("*[id$='txtEmail']").val();
        var pnumber = $("*[id$='txtPhone']").val();

        if (fname == '') {
            alert('Contact name is required!');
            return;
        }

        if (email == '' && pnumber == '') {
            alert('Either an email or phone are required!');
            return;
        }
        if (email != '') {
            if (!emailReg.test(email)) {
                alert('Enter a valid email address.');
                return;
            }
        }

        var newcontact = new Object();
        newcontact.ParentID = $("#dialog-advert").data('advertiserid');
        newcontact.contactID = cid;
        newcontact.FullName = $("*[id$='txtFullName']").val();
        newcontact.Email = $("*[id$='txtEmail']").val();
        newcontact.Phone = $("*[id$='txtPhone']").val();
        newcontact.Notes = $("*[id$='txtContactNotes']").val();

        var DTO = { 'newcontact': newcontact };

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/InsertUpdateAffiliateContact",
            data: JSON.stringify(DTO),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $().toastmessage('showSuccessToast', response.d);
                getContacts();
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });
        $("#dialog-contact").dialog("close");
    }
    function ExportContacts() {
        alert('Not implemented yet');
        return false;
    }
    function EditContact(contactid, fullname, email, phone, notes) {
        var aid = $("#dialog-advert").data('advertiserid');

        $("*[id$='txtFullName']").val(fullname);
        $("*[id$='txtEmail']").val(email);
        $("*[id$='txtPhone']").val(phone);
        $("*[id$='txtContactNotes']").val(notes);

        $("*[id$='txtPhone']").mask("(999) 999-9999");
        $("#dialog-contact")
                .data('advertiserid', aid)
                .data('contactid', contactid)
                .dialog("open");
        return false;


    }
    function DeleteContact(contactid) {
        var dArray = "{";
        dArray += "'conType': '2',";
        dArray += "'uniqueID': '" + contactid + "'";
        dArray += "}";

        if (confirm('Are you sure you want to delete this contact?')) {
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/DeleteContact",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                    getContacts();
                },
                error: function(response) {
                    showStickyToast(response.responseText, 'showErrorToast');
                }
            });
        }

        return false;
    }
    </script>    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="float:left">
        <h2>Advertisers</h2>
    </div>
    <asp:UpdatePanel ID="upAdvertiser" runat="server">
    <ContentTemplate>
    <div style="float: right; padding: 0px 0px 5px 5px">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upAdvertiser">
                        <ProgressTemplate>
                            <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </td>
                <td>
                    <small>
                        <input type="submit" class="jqButton" onclick="return ShowAdvertiser(-1, 'New Advertiser', '', '', '', '', '', '', '', 'USA', '', 'false');" value="Create Advertiser" />
                    </small>
                </td>
            </tr>
        </table>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
                    <asp:GridView ID="gvAdvertisers" runat="server" DataSourceID="odsAdvertisers" AutoGenerateColumns="False"
                        Width="100%" AllowPaging="True" AllowSorting="True" PageSize="22" DataKeyNames="AdvertiserID"
                        AlternatingRowStyle-CssClass="altrow" CellPadding="0" CellSpacing="0" GridLines="None">
                        <RowStyle VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="AdvertiserID" HeaderText="ID" SortExpression="AdvertiserID">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" Width="30px" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="30px"/>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Advertiser" SortExpression="Name">
                                <ItemTemplate>
                                    <asp:Image ID="imgActive" runat="server" ImageUrl="" />
                                    <asp:LinkButton ID="lnkEdit" runat="server" Text='<%# eval("Name") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="320px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="AccountManager" HeaderText="Acct Mgr" SortExpression="AccountManager">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="180px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="BillingCycle" HeaderText="Billing Cycle" SortExpression="BillingCycle" >
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" Width="150px"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="150px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Notes" HeaderText="Notes" SortExpression="Notes" Visible="false" >
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" Width="150px"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Street" HeaderText="Street" SortExpression="Street" Visible="false" >
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="State" HeaderText="State" SortExpression="State" Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Zip" HeaderText="Zip" SortExpression="Zip" Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Website" HeaderText="Website" SortExpression="Website" >
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created" Visible="false" >
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
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
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" />
                                            of
                                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                ID="btnNext" CssClass="jqNextButton" />
                                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                ID="btnLast" CssClass="jqLastButton" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    
                       <asp:ObjectDataSource ID="odsAdvertisers" runat="server" 
                        SelectMethod="getAdvertisers" TypeName="AdminHelper+AdvertiserObject"
                        OldValuesParameterFormatString="original_{0}">
                        <SelectParameters>
                            <asp:Parameter Name="sortField" Direction="Input" Type="String" />
                            <asp:Parameter Name="sortOrder" Direction="Input" Type="String" />
                            <asp:Parameter Name="advertiserID" Direction="Input" Type="Int32" DefaultValue="-1" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
        </div>
    </div>
    </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-advert" title="Advertiser">
        <div id="advertisertab">
            <ul>
                <li><a href="#btab0"><span>Advertiser</span></a></li>
                <li><a href="#btab1"><span>Offers</span></a></li>
                <li><a href="#btab2"><span>Contacts</span></a></li>
                <li><a href="#btab3"><span>Documents</span></a></li>
            </ul>
            <div id="btab0">
                <table style="width: 100%">
                    <tr>
                        <td class="tdHdr">
                            Name:
                        </td>
                        <td>
                            <asp:TextBox ID="txtName" runat="server" Width="98%" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Acct Mgr:
                        </td>
                        <td>
                            <asp:DropDownList ID="txtAcctMgr" runat="server" Width="98%" DataSourceID="dsManagers" DataTextField="Name"
                                DataValueField="UserID"/>
                             <asp:SqlDataSource ID="dsManagers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="select UserId, FirstName + ' ' + LastName[Name] from tbluser where UserTypeId in(1,2) ORDER BY LastName"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Website
                        </td>
                        <td>
                            <asp:TextBox ID="txtWebsite" runat="server" Width="98%" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Billing Cycle:
                        </td>
                        <td>
                             <asp:DropDownList ID="ddlBillingCycle" runat="server" Width="98%" >
                             <asp:ListItem Text="Weekly" />
                             <asp:ListItem Text="Bi-Weekly" />
                             <asp:ListItem Text="Monthly" />
                             <asp:ListItem Text="Bi-Monthly" />
                             </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Street
                        </td>
                        <td>
                            <asp:TextBox ID="txtStreet" runat="server" Width="98%" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            City
                        </td>
                        <td>
                            <asp:TextBox ID="txtCity" runat="server" Width="98%" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            State
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlState" runat="server" DataSourceID="dsStates" DataTextField="StateCode"
                                DataValueField="StateCode" />
                            <asp:SqlDataSource ID="dsStates" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="SELECT [StateCode] FROM [tblStates] ORDER BY [StateCode]"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Zip
                        </td>
                        <td>
                            <asp:TextBox ID="txtZip" runat="server" Width="98%" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Country
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCountry" runat="server">
                                <asp:ListItem Text="" />
                                <asp:ListItem Text="USA" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Notes
                        </td>
                        <td>
                            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="4" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdHdr">
                            Active
                        </td>
                        <td>
                            <asp:CheckBox ID="chkActive" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="btab1">
            <div>
                        <b class="rndBoxBlue"><b class="rndBoxBlue1"><b></b></b><b class="rndBoxBlue2"><b></b>
                        </b><b class="rndBoxBlue3"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue5"></b>
                        </b>
                        <div class="rndBoxBluefg">
                            <div id="divOffersGrid" style="height: 350px; overflow-x: hidden; overflow-y: scroll;">
                            </div>
                        </div>
                        <b class="rndBoxBlue"><b class="rndBoxBlue5"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue3">
                        </b><b class="rndBoxBlue2"><b></b></b><b class="rndBoxBlue1"><b></b></b></b>
                    </div>
            </div>
             <div id="btab2">
              <div style="width: 100%; text-align: center; display: block; padding: 3px; background-color: #013F87">
                    <small>
                        <button id="btnExportContact" runat="server" class="jqButton" style="float: right!important"
                            onclick="return ExportContacts();">
                            Export</button>
                        <button id="btnAddContact" runat="server" class="jqButton" style="float: right!important"
                            onclick="return AddContact();">
                            Add Contact</button>
                    </small>
                </div>
                <div id="contactHolder" style="padding: 5px;">
                </div>
             </div>
             <div id="btab3">
              <div>
                    <p style="font-weight:bold;">
                        Documents</p>
                    <span>The Documents area allows you to upload relevant materials for a contract or a
                        buyer whether it is an Insertion Order, Terms and Conditions, Marketing Guidelines
                        or an Addendum. Putting them all here will give all of your internal users one place
                        to pull up paper work and it is highly recommended to simplify the Deal Flow process.
                        You can upload documents using the Document Upload wizard which will walk you through
                        the process of adding the documents to the appropriate buyer or contract. </span>
                </div>
                <div style="width: 100%; text-align: center; display: block; padding: 3px; background-color: #013F87">
                    <small>
                        <asp:Button ID="btnUploadDoc" runat="server" Text="Upload Document" CssClass="jqButton"
                            Style="float: right!important" OnClientClick="return ShowUploadDocument();" />
                    </small>
                </div>
                <div style="clear: left;" />
                <div id="tblDocuments">
                </div>
             </div>
        </div>
        <hr />
        <div style="text-align: right;">
            <button id="btnSaveAdvertiser" class="jqSaveButton" onclick="return SaveAdvertiser();">
                Save Advertiser
            </button>
        </div>
    </div>
    <div id="dialog-upload" title="Upload Document(s)">
        <input id="btnReset" type="button" value="New Upload" class="jqButton"/>
        <div id="uploader">
            <p>
                You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
        </div>
    
    </div>
    <div id="dialog-contact" title="Affiliate Contact">
        <table style="width: 100%;">
            <tr>
                <td class="tdHdr" width="65">
                    Full Name
                </td>
                <td>
                    <asp:TextBox ID="txtFullName" runat="server" Width="200px" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" width="65">
                    Email
                </td>
                <td>
                    <asp:TextBox ID="txtEmail" runat="server" Width="200px" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" width="65">
                    Phone
                </td>
                <td>
                    <asp:TextBox ID="txtPhone" runat="server" Width="100px" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" width="65">
                    Notes
                </td>
                <td>
                    <asp:TextBox ID="txtContactNotes" runat="server" Width="200px" TextMode="MultiLine" Rows="2" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <hr />
                    <button class="jqButton" id="btnSaveContact" onclick="return SaveContact();" style="float: right!important">
                        Save Contact</button>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>