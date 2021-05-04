<%@ Page Title="" Language="VB" MasterPageFile="~/dialogs/dialog.master" AutoEventWireup="false" 
CodeFile="buyerDialog.aspx.vb" Inherits="dialogs_buyerDialog" EnableEventValidation="false"%>

<asp:Content ID="Content1" ContentPlaceHolderID="dialogHeadCnt" Runat="Server">
<style type="text/css">
#tblBuyerDocuments_previous,#tblBuyerDocuments_next{
padding-left:3px; 
padding-right:3px;
}
#tblBuyerDocuments_next{
padding-left:3px; 
padding-right:3px;
}
</style>
    <script type="text/javascript">
        //initial jquery stuff
        var chart1; // globally available
        var sURL = unescape(window.location.pathname);
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
                    height: 220,
                    width: 320,
                    modal: true,
                    stack: true,
                    close: function() {
                        getContacts();
                    }
                });
                var $tabs = $("#buyerTab").tabs({
                    select: function(e, ui) {
                        var thistab = ui.index;
                        switch (thistab) {
                            case 1:
                                //get contacts
                                getContacts()
                                break;
                            case 2:
                                getContractData(thistab);
                                break;
                            case 3:
                                //get documents
                                getDocuments();
                                break;
                            default:
                                break;
                        }
                    }
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
                             up.settings.url = '../handlers/FileUploaderHandler.ashx?type=buyer';
                             up.settings.multipart_params = {buyerid : '<%=buyerid %>'}
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
                $('form').submit(function (e) {        
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
                });
                //tweak to reset the interface for new file upload, the core API didn't provide this functionality    
                $('#btnReset').click(function () {        
                    var uploader = $('#uploader').pluploadQueue();         
                    //clear files object        
                    uploader.files.length = 0;         
                    $('div.plupload_buttons').css('display', 'block');        
                    $('span.plupload_upload_status').html('');        
                    $('span.plupload_upload_status').css('display', 'none');        
                    $('a.plupload_start').addClass('plupload_disabled');        
                    //resetting the flash container css property        
                    $('.flash').css({            
                        position: 'absolute', top: '292px',            
                        background: 'none repeat scroll 0% 0% transparent',            
                        width: '77px',            
                        height: '22px',            
                        left: '16px'        
                    });        
                    //clear the upload list        
                    $('#uploader_filelist li').each(function (idx, val) {            
                        $(val).remove();        
                    });    
                
                });
                var options = {
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'column'
                    },
                    title: { text: 'Leads Bought' },
                    xAxis: { categories: [] },
                    //['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'] },
                    yAxis: { title: { text: 'Leads'} },
                    series: []
                };
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    data: "{'buyerid': '" + <%=buyerid %> + "'}",
                    contentType: "application/json; charset=utf-8",
                    url: "../service/cmService.asmx/getBuyerLeadsBoughtChartData",
                    success: function(response) {
                        var obj = eval('(' + response.d + ')');
                        for (ob in obj) {
                            var series = { data: [] };
                            if (obj[ob].SeriesName != null) {
                                series.name = obj[ob].SeriesName;
                                var odata = obj[ob].SeriesData.split(',');
                                for (od in odata) {
                                    var cdata = odata[od].split('=');
                                    options.xAxis.categories.push(cdata[0]);
                                    series.data.push(parseFloat(cdata[1]));
                                }
                            }
                            options.series.push(series);
                        }
                        chart = new Highcharts.Chart(options);
                    },
                    cache: false,
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(errorThrown);
                    }
                });
                $("#buyerTab").tabs({ selected: 0 });
                $("#buyerTab div.ui-tabs-panel").css('height', "510px");
                $("#buyerinfotab").tabs({ selected: 0 });
                $("#buyerinfotab div.ui-tabs-panel").css('height', "150px");
                $(".jqButton").button();
                $(".jqAddButton").button({
                    icons: {
                        primary: "ui-icon-plusthick"
                    },
                    text: false
                });
                $(".jqDeleteButton").button({
                    icons: {
                        primary: "ui-icon-trash"
                    },
                    text: false
                });
                $(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
                $(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: false
                });
                $(".jqSaveButtonWithText").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
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
            });
        }

    </script>

    <script type="text/javascript">
        //buyer scripts
        function SaveBuyer() {

            var newbuyer = new Object();
            newbuyer.BuyerID = <%=buyerid %>;
            newbuyer.Buyer = $("*[id$='txtBuyerName']").val();
            newbuyer.BuyerCode = $("*[id$='txtBuyercode']").val();
            newbuyer.Active = getCheckboxValue($("*[id$='chkBuyerActive']").attr("checked"));
            newbuyer.BillingCycle = $("*[id$='ddlBillingCycle']").val();
            newbuyer.AccountManager = $("*[id$='txtAcctMgr']").val();
            newbuyer.Address = $("*[id$='txtAddress']").val();
            newbuyer.City = $("*[id$='txtCity']").val();
            newbuyer.State = $("*[id$='ddlState']").val();
            newbuyer.Zip = $("*[id$='txtZip']").val();
            newbuyer.Country = $("*[id$='ddlCountry']").val();
            newbuyer.Notes = $("*[id$='txtBuyerNotes']").val();

            var DTO = { 'newbuyer': newbuyer };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/InsertUpdateBuyer",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    showStickyToast(response.d, 'showSuccessToast')
                },
                error: function(response) {
                    showStickyToast(response.responseText, 'showErrorToast')
                }
            });
            return false;
        }
    </script>

    <script type="text/javascript">
        //contracts
        function getContractData(tab) {
            $('#divContractsGrid').html(loadingImg);
            var bid = <%=buyerid %>;
            if (bid !=-1){
                var dArray = "{'buyerid': '" + bid + "'}";
                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/getContracts",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $('#divContractsGrid').html(response.d);
                    },
                    fail: function(response) {
                        $().toastmessage('showErrorToast', response.responseText);
                    }
                });
            }else{
                $('#divContractsGrid').html('<div class="ui-widget"><div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"><p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>No Contracts!</p></div></div>');
            }
            
            return false;
        }
        function createContract() {
            var bid = <%=buyerid %>;
            var dArray = "{'buyerid': '" + bid + "'}";
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/createContract",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                    getContractData(1);
                }
            });
            return false;
        }
        
    </script>

    <script type="text/javascript">
        //contacts
        function getContacts() {
            $('#contactHolder').html(loadingImg);
            var bid = <%=buyerid %>;

            var dArray = "{";
            dArray += "'conType': '0',";
            dArray += "'uniqueID': '" + bid + "'";
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
            var bid = <%=buyerid %>;
            $("*[id$='txtPhone']").mask("(999) 999-9999");
            $("#dialog-contact")
                .data('buyerid', bid)
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
            newcontact.ParentID = <%=buyerid %>;
            newcontact.contactID= cid;
            newcontact.FullName = $("*[id$='txtFullName']").val();
            newcontact.Email = $("*[id$='txtEmail']").val();
            newcontact.Phone = $("*[id$='txtPhone']").val();
            newcontact.Notes = $("*[id$='txtNotes']").val();
            newcontact.Billing = $('#<%=chkBilling.ClientID%>').is(':checked'); 

            var DTO = { 'newcontact': newcontact };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/InsertUpdateBuyerContact",
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
        function EditContact(contactid, fullname,email,phone,notes, billing) {
            var bid = <%=buyerid %>;
            
            $("*[id$='txtFullName']").val(fullname);
            $("*[id$='txtEmail']").val(email);
            $("*[id$='txtPhone']").val(phone);
            $("*[id$='txtNotes']").val(notes);
            var bChecked = false;
            if (billing == 'true') {
                bChecked = true;
            }
            $("*[id$='chkBilling']").attr('checked', bChecked);
            
            $("*[id$='txtPhone']").mask("(999) 999-9999");
            $("#dialog-contact")
                .data('buyerid', bid)
                .data('contactid', contactid)
                .dialog("open");
            return false;
        }
        function DeleteContact(contactid) {
            var dArray = "{'contactid': '" + contactid + "'}";
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

    <script type="text/javascript">
        //documents
        function getDocuments() {
            $('#tblDocuments').html(loadingImg);
            var bid = <%=buyerid %>;

            var dArray = "{";
            dArray += "'docType': '0',";
            dArray += "'uniqueID': '" + bid + "'";
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
                    $('#tblDocumentTable').dataTable( {
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
            var bid = <%=buyerid %>;
            $("*[id$='hdnBuyerID']").val(bid)
            
            $("#dialog-upload")
                .data('buyerid', bid)
                .dialog("open");
            return false;
        }
        function ViewDocument(docpath) {
            window.open(docpath);
        }
        function DeleteDocument(docid) {
            if (confirm('Are you sure you want to delete this document?')) {

                var dArray = "{";
                dArray += "'docType': '0',";
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

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="cphDialogBody" runat="Server">
    <div id="buyerTab">
        <ul>
            <li><a href="#tab-0"><span>Home</span></a></li>
            <li><a href="#tab-1"><span>Contacts</span></a></li>
            <li><a href="#tab-2"><span>Contracts</span></a></li>
            <li><a href="#tab-3"><span>Documents</span></a></li>
        </ul>
        <div id="tab-0">
            <table style="width: 100%">
                <tr valign="top">
                    <td colspan="2">
                        <table style="width: 100%">
                            <tr valign="top">
                                <td style="width: 45%;">
                                    <div style="padding: 10px;">
                                        <table style="width: 100%">
                                            <tr>
                                                <td style="padding: 15px;">
                                                    <asp:Label ID="lblBuyerName" runat="server" Font-Bold="true" Font-Size="20px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="ui-state-highlight ui-corner-all" style="position: relative; float: left;
                                                        width: 35%; padding: 10px">
                                                        Current Credit:
                                                        <asp:Label ID="lblCurrentCredit" runat="server" Style="position: relative; float: right;"
                                                            Text="$0.00" Font-Bold="true" Font-Size="12pt" />
                                                    </div>
                                                    <div class="ui-state-highlight ui-corner-all" style="position: relative; float: left;
                                                        width: 35%; padding: 10px">
                                                        Owed Returns
                                                        <asp:Label ID="lblOwedReturns" runat="server" Style="position: relative; float: right;"
                                                            Text="$0.00" Font-Bold="true" Font-Size="12pt" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <td>
                                    <div id="buyerinfotab">
                                        <ul>
                                            <li><a href="#tabInfo"><span>Info</span></a></li>
                                            <li><a href="#tabAddress"><span>Address</span></a></li>
                                            <li><a href="#tabMisc"><span>Miscellaneous</span></a></li>
                                        </ul>
                                        <div id="tabInfo">
                                            <div style="padding: 5px;">
                                                <table style="width: 100%">
                                                    <tr valign="middle">
                                                        <td class="tdHdr" style="width: 75px!important">
                                                            Name:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBuyerName" runat="server" Width="90%" />
                                                        </td>
                                                    </tr>
                                                    <tr valign="middle">
                                                        <td align="right" style="width: 75px!important">
                                                            Code:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBuyercode" runat="server" Width="90%" />
                                                        </td>
                                                    </tr>
                                                    <tr valign="middle">
                                                        <td align="right" style="width: 75px!important">
                                                            Billing Cycle:
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlBillingCycle" runat="server">
                                                                <asp:ListItem Text="" />
                                                                <asp:ListItem Text="Weekly" />
                                                                <asp:ListItem Text="Bi-Monthly" />
                                                                <asp:ListItem Text="Monthly" />
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr valign="middle">
                                                        <td class="tdHdr" style="width: 75px!important">
                                                            Acct Mgr:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtAcctMgr" runat="server" Width="90%" />
                                                        </td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td align="right" style="width: 75px!important">
                                                            Active:
                                                        </td>
                                                        <td>
                                                            <asp:CheckBox ID="chkBuyerActive" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        <div id="tabAddress">
                                            <table style="width: 100%;">
                                                <tr valign="middle">
                                                    <td align="right">
                                                        Address:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddress" runat="server" Width="90%" />
                                                    </td>
                                                </tr>
                                                <tr valign="middle">
                                                    <td align="right">
                                                        City:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCity" runat="server" Width="90%" />
                                                    </td>
                                                </tr>
                                                <tr valign="middle">
                                                    <td align="right">
                                                        State:
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlState" runat="server" DataSourceID="dsStates" DataTextField="StateCode"
                                                            DataValueField="StateCode" />
                                                        <asp:SqlDataSource ID="dsStates" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                            SelectCommand="SELECT [StateCode] FROM [tblStates] ORDER BY [StateCode]"></asp:SqlDataSource>
                                                    </td>
                                                </tr>
                                                <tr valign="middle">
                                                    <td align="right">
                                                        Zip:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtZip" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr valign="middle">
                                                    <td align="right">
                                                        Country:
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlCountry" runat="server">
                                                            <asp:ListItem Text="" />
                                                            <asp:ListItem Text="United States" Value="US" />
                                                            <asp:ListItem Text="Mexico" Value="MX" />
                                                            <asp:ListItem Text="Canada" Value="CA" />
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="tabMisc">
                                            <div style="padding: 5px;">
                                                Notes:
                                                <br />
                                                <asp:TextBox ID="txtBuyerNotes" runat="server" TextMode="MultiLine" Rows="6" Width="100%" />
                                            </div>
                                        </div>
                                        <small>
                                            <button id="btnSaveBuyer" runat="server" class="jqSaveButtonWithText" style="float: right!important"
                                                onclick="return SaveBuyer();">
                                                Save Info</button>
                                        </small>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr valign="top">
                    <td colspan="2" style="height: 250px">
                        <div id="container" style="width: 715px; height: 250px">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="tab-1">
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
        <div id="tab-2">
            <div style="width: 100%; text-align: center; display: block; padding: 3px; background-color: #013F87">
                <small>
                    <button id="btnCreateContract" runat="server" class="jqButton" style="float: right!important"
                        onclick="return createContract();">
                        Add Contract</button>
                </small>
            </div>
            <div>
                <div id="divContractsGrid" style="width: 100%;">
                </div>
            </div>
        </div>
        <div id="tab-3">
            <div>
                <p style="font-weight: bold;">
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
    <div id="dialog-contact" title="Buyer Contact">
        <form>
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
                    <asp:TextBox ID="txtNotes" runat="server" Width="200px" TextMode="MultiLine" Rows="2" />
                </td>
            </tr>
             <tr>
                <td class="tdHdr" width="65">
                    Billing Contact
                </td>
                <td>
                    <asp:CheckBox ID="chkBilling" runat="server" />
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
        </form>
    </div>
    <div id="dialog-upload" title="Upload Document(s)">
        <input id="btnReset" type="button" value="New Upload" class="jqButton" />
        <div id="uploader">
            <p>
                You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
        </div>
    </div>
</asp:Content>

