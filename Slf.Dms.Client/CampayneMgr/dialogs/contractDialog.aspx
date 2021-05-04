<%@ Page Title="" Language="VB" MasterPageFile="~/dialogs/dialog.master" AutoEventWireup="false"
    CodeFile="contractDialog.aspx.vb" Inherits="dialogs_contractDialog" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="dialogHeadCnt" runat="Server">
    <style type="text/css">
        .ui-tabs-nav li
        {
            margin-top: 0.6em;
            font-size: 80%;
        }
        .ui-tabs-nav li.ui-tabs-selected
        {
            margin-top: 0em;
            font-size: 100%;
        }
    </style>
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
        var filterCols;
        var sURL = unescape(window.location.pathname);
        
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
                loadTabs();
                loadJQGridviewButtons();
                loadButtons();
                getTrickleAmount();
                loadSlider();
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-upload").dialog({
                    autoOpen: false,
                    height: 500,
                    width: 520,
                    modal: true,
                    stack: true
                });

                // UPLOADER CAUSES SCRIPT DELAYS IN IE8 AND DOES NOT WORK IN FF
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
                    uploader.refresh();
                });
                $.ajax({
                    type: "POST",
                    url: "contractDialog.aspx/GetDeliveryMethodFields",
                    data: "{}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        filterCols = $.parseJSON(r.d);
                    },
                    error: function (r) {
                        $().toastmessage('showErrorToast', r.responseText);
                    }
                });


            });
        }


    </script>
    <script type="text/javascript">
        //initial jquery stuff
 
        function checkAll(chk_SelectAll) {
            var frm = document.forms[0];
            var chkState = chk_SelectAll.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                    el.checked = chkState;
                }
            }
        }
        function createFilterDDL(FieldID, PostFieldID) {
            var ddl = '<SELECT disabled ';
            ddl += 'id="cboPostFilterFld_' + PostFieldID + '" ';
            ddl += 'Style="width:100%;border: none; background-color: Transparent; color: Black;" ';

            $.each(filterCols, function () {
                $.each(this, function (i, item) {
                    var bSelected = '';
                    if (FieldID == item.FieldID) {
                        bSelected = 'selected';
                    } else {
                        bSelected = '';
                    }
                    ddl += '<OPTION ' + bSelected + ' value=' + item.FieldID + '>' + item.DisplayText + '</OPTION>';
                });
            });
            if (FieldID < 2) {
                ddl += "<OPTION selected value='1'></OPTION>";
            }
            ddl += '</SELECT>';
            return ddl

        }
        function createTextBox(txtVal, fieldID) {
            var txtString = '<input  ';
            txtString += 'id="txtPostFilterParam_' + fieldID + '" ';
            txtString += 'onclick="EnableControl(this);" onblur="DisableControl(this);" Style="width:300px;border: none; background-color: Transparent; color: Black;" ';
            txtString += 'value="' + txtVal + '"/>';
            return txtString;
        }
        function getFilterType() {
            var str = "";
            $("#<%=filterType.clientID %> option:selected").each(function () {
                str += $(this).text();
            });
            switch (str) {
                case 'ZipCode':
                    $(".filterzipcode").show();
                    $(".filterstate").hide();
                    $(".filtercolumns").hide();
                    break;
                case 'State':
                    $(".filterstate").show();
                    $(".filterzipcode").hide();
                    $(".filtercolumns").hide();
                    break;
                case 'Columns':
                    $(".filtercolumns").show();
                    $(".filterstate").hide();
                    $(".filterzipcode").hide();
                    break;
                default:
                    $(".filterstate").hide();
                    $(".filterzipcode").hide();
                    $(".filtercolumns").hide();
                    break;
            }
        }
        function loadTabs() {
            $("#history").tabs();

            $("#postcontent").tabs({ selected: 0 });
            loadPostFields();

            var $tabs = $("#content").tabs({
                select: function (e, ui) {
                    var thistab = ui.index;
                    switch (thistab) {
                        case 1:
                            $("#tab1").html(getSchedule(thistab));
                            break;
                        case 2:
                            $("#tab2").html(getFilters(thistab));
                            break;
                        case 5:
                            getDeliveryMethod(thistab);
                            break;
                        case 7:
                            getHistory(thistab);
                            break;
                        default:
                            break;
                    }
                }
            });
        }
        function loadButtons() {
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
            $(".jqSaveButton").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: true
            });
            $(".jqSaveButtonNoText").button({
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
            $(".jqHelpButton").button({
                icons: {
                    primary: "ui-icon-help"
                },
                text: true
            });
        }

        function getTrickleAmount(){
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getTrickleAmount",
                data: "{'BuyerOfferXrefID': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $("#lbTrickle").html(response.d);
                    $("#sdrTrickle").slider("option", "value", [response.d])
                }
            });
        }

        function loadSlider() {
            $("#sdrTrickle").slider({
                //range: "max",
                min: 0,
                max: 100,
                step: 1,
                value: $("#lbTrickle").html(),
                slide: function( event, ui ) {
                    $( "#lbTrickle").html( ui.value );
                }
            });
            $("#lbTrickle").html($("#sdrTrickle").slider("value"));
        }

    </script>
    <script type="text/javascript">
        //loading  contract code
        function getHistory(thistab) {
            $('#divHistoryGrid').html(loadingImg);
            $('#divReturnsGrid').html(loadingImg);
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getHistory",
                data: "{'BuyerOfferXrefID': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divHistoryGrid').html(response.d);
                }
            });
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getReturns",
                data: "{'BuyerOfferXrefID': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divReturnsGrid').html(response.d);
                }
            });
        }
        function getFilters(thistab) {
            $('#divFilterGrid').html(loadingImg);
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getFilters",
                data: "{'BuyerOfferXrefID': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divFilterGrid').html(response.d);
                }
            });
        }
        function getSchedule(thistab) {
            $('#divDeliverySchedGrid').html(loadingImg);
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getDeliverySchedule",
                data: "{'boxid': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divDeliverySchedGrid').html(response.d);
                }
            });
        }
        function getDeliveryMethod(thistab) {
            LoadTemplates();
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getDeliveryMethod",
                data: "{'boxid': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    var dmObj = eval('(' + response.d + ')');
                    $("*[id$='txtPostURL']").val(dmObj.PostUrl);
                    $("*[id$='txtResponseSuccessText']").val(dmObj.ResponseSuccessText);
                    $("*[id$='txtIDXML']").val(dmObj.ResponseResultID_XML);
                    $("*[id$='txtCodeXML']").val(dmObj.ResponseResultCode_XML);
                    $("*[id$='txtErrorXML']").val(dmObj.ResponseResultError_XML);
                    $("*[id$='ddlResponseType']").val(dmObj.ResponseType);

                    var tblPost = $("*[id$='tblPostFldsBody']");
                    buildPostTable(tblPost, dmObj.PostFields);
                }
            });
        }
        function LoadTemplates() {
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetTemplates",
                data: null,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    //$('#divContractsGrid').html(response.d);
                    var obj = eval('(' + response.d + ')');
                    for (ob in obj) {
                        $("*[id$='ddlTemplateList']").append("<option value='" + obj[ob].TemplateID + "'>" + obj[ob].TemplateName + "</option>")
                    }
                },
                error: function(response) {
                    alert(response);
                }
            });
        }
        function buildPostTable(tbl, PostFields) {
            tbl.find('tbody').empty();
            for (p in PostFields) {
                var chk = '<input type="checkbox" disabled="disabled" '
                chk += 'id="chk_' + PostFields[p].Postfieldid + '"';
                if (PostFields[p].Query == true) {
                    chk += 'checked="checked"'
                }
                chk += ' />'
                var editFld = '<small><button ID="btnSavePostField_' + PostFields[p].Postfieldid + '" style="cursor:pointer;" class="ui-state-default ui-corner-all"  onclick="return AddRemovePostField(this,';
                editFld += "'update'," + PostFields[p].Postfieldid + ");"
                editFld += '"><span class="ui-icon ui-icon-disk"></span</button></small>';
                editFld += '<small><button ID="btnDeletePostField_' + PostFields[p].Postfieldid + '" style="cursor:pointer;" class="ui-state-default ui-corner-all" onclick="return AddRemovePostField(this,';
                editFld += "'delete'," + PostFields[p].Postfieldid + ");"
                editFld += '"><span class="ui-icon ui-icon-trash"></span</button></small>';

                var row = "<tr height='20px'>";
                row += "<td class='ui-widget-content' style='width:56px!important; text-align:center;'>" + chk + "</td>";
                row += "<td class='ui-widget-content' style='width:150px!important;'>" + createTextBox(PostFields[p].Parameter, PostFields[p].Postfieldid); +"</td>";
                row += "<td class='ui-widget-content' >" + createFilterDDL(PostFields[p].FieldID, PostFields[p].Postfieldid) + "</td>";
                row += "<td class='ui-widget-content' >" + editFld + "</td>"
                row += "</tr>"
                tbl.find('tbody').append(row);
            }
            tbl.find('tbody').css({
                "overflow-y": "scroll",
                "overflow-x": "hidden",
                "height": "100px"
            });
        }
        function showHelpMsg(msgtext){
            showToast(msgtext, 'info', true);
            return false;
        }

        function loadPostFields() {
            $('#divTestPostFields').html(loadingImg);
            var bxid = <%=ContractID %>;
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/getTestPostFields",
                data: "{'boxid': '" + bxid + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divTestPostFields').html(response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', bxid);
                }
            });
        }

        function sendTestPost2() {
            var fields = $("#divTestPostFields :input");
            var qs = '';

            for (i = 0; i <= fields.length - 1; i++) {
                if (i == 0) {
                    qs = fields[i].getAttribute('parameter') + '=' + escape(fields[i].value);
                }
                else {
                    qs += '&' + fields[i].getAttribute('parameter') + '=' + escape(fields[i].value);
                }
            }

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/sendTestPost2",
                data: "{ 'boxid':'" + <%=ContractID %> + "','queryString':'" + qs + "' }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $("#txtTestResults").val(response.d);
                },
                error: function(response) {
                    showStickyToast(response.d, 'showErrorToast');
                }
            });

            return false;
        }

        function sendTestPost() {
            var bxid = <%=ContractID %>;

            var dArray = "{";
            dArray += "'boxid': '" + bxid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/sendTestPost",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    showStickyToast(response.d, 'showSuccessToast')
                },
                error: function(response) {
                    showStickyToast(response.d, 'showErrorToast')
                }
            });

            return false;
        }
        function createPoster() {
            var bxid = <%=ContractID %>;
            var tid = $("*[id$='ddlTemplateList']").val()
            var dArray = "{";
            dArray += "'templateid': '" + tid + "',";
            dArray += "'boxid': '" + bxid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/createFromTemplate",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    getDeliveryMethod(3);
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    showStickyToast(response.d, 'showErrorToast');
                }
            });

            return false;
        }
    </script>
    <script type="text/javascript">
        //save scripts
        function savePostUrl() {
            var bxid = <%=ContractID %>;
            var postU = $("*[id$='txtPostURL']").val();

            var dArray = "{";
            dArray += "'boxid': '" + bxid + "',";
            dArray += "'postURL': '" + postU + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/savePostURL",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                }
            });

            return false;
        }
        function DeleteContract() {
            var bxid = <%=ContractID %>;
            var dArray = "{";
            dArray += "'contractid': '" + bxid + "'";
            dArray += "}";
            if (confirm('Are you sure you want to delete this contract?')) {
                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/DeleteContract",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                });
            }
        }
        function SaveContractInfo() {
            var currentcontract = new Object();
            currentcontract.AgedMinutes = $("*[id$='ddlAgedMinutes']").val();
            currentcontract.BuyerOfferXrefID = <%=ContractID %>;
            currentcontract.BuyerID = <%=BuyerID %>; 
            currentcontract.ContractName = $("*[id$='txtContractName']").val(); 
            currentcontract.ServicePhoneNumber = $("*[id$='txtServiceTelNum']").val(); 
            currentcontract.DailyCap = $("*[id$='txtDailyCap']").val(); 
            currentcontract.Instructions = $("*[id$='txtInstructions']").val(); ;
            currentcontract.InvoicePrice = $("*[id$='txtInvoicePrice']").val();
            currentcontract.Price = $("*[id$='txtPrice']").val();
            currentcontract.Priority = $("*[id$='ddlPriority']").val();
            currentcontract.OfferID = $("*[id$='ddlOffers']").val();
            currentcontract.Exclusive = getCheckboxValue($("*[id$='chkExclusive']").attr("checked"));
            currentcontract.Active = getCheckboxValue($("*[id$='chkContractActive']").attr("checked"));
            currentcontract.Weight = $("*[id$='txtWeight']").val();
            currentcontract.DupAttempt = $("*[id$='ddlDupAttempt']").val();
            currentcontract.DataSQL = $("*[id$='ddlDataSql']").val();
            currentcontract.DoCakePost = false; // Obsolete
            currentcontract.Throttle = getCheckboxValue($("*[id$='chkthrottle']").attr("checked"));
            currentcontract.CallCenter = getCheckboxValue($("*[id$='chkCallCenter']").attr("checked"));
            currentcontract.DataTransfer = getCheckboxValue($("*[id$='chkDataTransfer']").attr("checked"));
            currentcontract.CallTransfer = getCheckboxValue($("*[id$='chkCallTransfer']").attr("checked"));
            //currentcontract.MinutesBackForLeads = $("*[id$='ddlDaysBack']").val();
            currentcontract.RealTimeMinutes = $("*[id$='ddlRealTimeMinutes']").val();
            currentcontract.Trickle = $("*[id$='sdrTrickle']").slider("option","value");
            currentcontract.DataSortField = $("*[id$='ddlSortField']").val();
            currentcontract.DataSortDir = $("*[id$='ddlSortDir']").val();
            currentcontract.ContractTypeID = $("*[id$='ddlContractType']").val();
            currentcontract.PointValue = $("*[id$='txtPointValue']").val();
            currentcontract.WebsiteTypeID = $("*[id$='ddlWebsiteType']").val();
            currentcontract.NoScrub = getCheckboxValue($("*[id$='chkNoScrub']").attr("checked"));
            currentcontract.ExcludeDNC = getCheckboxValue($("*[id$='rdoExcludeDNC']").attr("checked"));
            currentcontract.WirelessOnly = getCheckboxValue($("*[id$='rdoWirelessOnly']").attr("checked"));
            currentcontract.LandlineOnly = getCheckboxValue($("*[id$='rdoLandlineOnly']").attr("checked"));

            var DTO = { 'currentcontract': currentcontract };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/saveContractInfo",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            return false;
        }

        function SaveTrafficTypes() {
            var bxid = <%=ContractID %>;
            var types = '';
                        
            $("*[id$='chkTrafficTypes'] :checked").each(function() {
                types += $('label[for=' + this.id + ']').html() + ',';
            })

            if (types == '') {
                types = 'Any';
            }

            var jsn = "{'BuyerOfferXrefID': '" + bxid + "', 'TrafficTypes': '" + types + "'}";

            $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/SaveTrafficTypes",
                    data: jsn,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', 'Traffic Types saved.');
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                });

            return false;
        }

        function AddRemoveDeliverySchedule(elem, action) {
            var actionType = '';
            switch (action) {
                case 'a':
                    actionType = 'Add';
                    break;
                case 'd':
                    actionType = 'Delete';
                    break;
                case 's':
                    actionType = 'Save';
                    break;
            }

            if (confirm('Are you sure you want to ' + actionType + ' this schedule?')) {
                var bxid = <%=ContractID %>;
                var bid = <%=BuyerID %>;
                var dArray = "{";
                dArray += "'buyerid': '" + bid + "',";
                dArray += "'boxid': '" + bxid + "',";
                dArray += "'action': '" + action + "',";
                if (action == 's') {
                    //serialize object to json
                    var tblRow = elem.parentNode.parentNode.parentNode.parentNode.parentNode;
                    if (tblRow != null) {
                        var tbl = tblRow.getElementsByTagName('table');
                        if (tbl != null) {
                            var dataRows = new Array(6);
                            var tr = tbl[0].getElementsByTagName('tr');
                            for (i = 0; i <= tr.length - 1; i++) {
                                var td = tr[i].getElementsByTagName('td');
                                if (td != null) {
                                    if (td.length > 2) {
                                        var txtW = td[0].children[0]
                                        var txtF = td[1].children[0]
                                        var txtT = td[2].children[0]
                                        var data = { weekday: txtW.value, fromHour: txtF.value, toHour: txtT.value };

                                        dataRows[i] = data
                                    }
                                }
                            }
                        }
                    }
                    var jsonData = Sys.Serialization.JavaScriptSerializer.serialize(dataRows);
                    dArray += "'rowData': '" + jsonData + "'";
                } else {
                    dArray += "'rowData': null";
                }
                dArray += "}";

                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/UpdateInsertDeliverySchedule",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                        getSchedule(1);
                    }
                });
            }

            return false;
        }
        function AddRemoveResponse() {
            var bxid = <%=ContractID %>;
            var ResponseSuccessText = $("*[id$='txtResponseSuccessText']").val();
            var ResponseResultID_XML = $("*[id$='txtIDXML']").val();
            var ResponseResultCode_XML = $("*[id$='txtCodeXML']").val();
            var ResponseResultError_XML = $("*[id$='txtErrorXML']").val();
            var ResponseType = $("*[id$='ddlResponseType']").val();
            
            var dArray = "{";
            dArray += "'boxid': '" + bxid + "',"
            dArray += "'successText': '" + ResponseSuccessText + "',"
            dArray += "'idXML': '" + ResponseResultID_XML + "',"
            dArray += "'codeXML': '" + ResponseResultCode_XML + "',"
            dArray += "'errorXML': '" + ResponseResultError_XML + "',"
            dArray += "'responseType': '" + ResponseType + "'"
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/saveResponseInfo",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            return false;
        }
        function AddRemovePostField(elem, actionType, fldID) {
            var bxid = <%=ContractID %>;

            if (actionType == 'delete') {
                var bContinue = confirm('Press [OK] to ' + actionType + ' this field!')
                if (bContinue != true) {
                    return false;
                }
            }

            var tr = elem.parentNode.parentNode.parentNode;
            var txt = tr.getElementsByTagName('input');
            var query, param, field;

            for (i in txt) {
                switch (txt[i].type) {
                    case 'checkbox':
                        query = txt[i];
                        break;
                    case 'text':
                        param = txt[i];
                        break;
                    default:
                        break;
                }
            }
            var sel = tr.getElementsByTagName('select');
            field = sel[0];

            var dArray = "{";
            dArray += "'action': '" + actionType + "',";
            dArray += "'boxid': '" + bxid + "',";
            dArray += "'postFldid': '" + fldID + "',";
            dArray += "'postQuery': '" + query.checked + "',";
            dArray += "'postParam': '" + param.value + "',";
            dArray += "'postField': '" + field.value + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/savePostField",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                    getDeliveryMethod(3);
                    query.checked = false;
                    param.value = '';
                    field.value = '';
                }
            });

            loadPostFields();

            return false;
        }
        function UpdateInsertFilter(elem, actionType) {
            var bxid = <%=ContractID %>;
            var filterType = $("*[id$='ddlFilterClause']").val();
            var filterValue = $("*[id$='ddlFilterValue']").val();

            if (actionType=='d'){
                var ft = elem.parentElement.parentElement.parentElement.children[0].innerHTML;
                if (!!ft){
                    filterType = ft;
                }
                var ep = elem.parentElement.parentElement.parentElement.children[1].innerHTML;
                if (!!ep){
                    filterValue = ep;
                }
            }

            var dArray = "{";
            dArray += "'boxid': '" + bxid + "',";
            dArray += "'action': '" + actionType + "',";
            dArray += "'filterType': '" + filterType + "',";
            dArray += "'filterVal': '" + filterValue + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/UpdateInsertFilter",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                    getFilters(2);
                }
            });

            return false;
        }

        function GetDataQueries() {
            var offerid = $("*[id$='ddlOffers']").val()
            var dArray = "{'OfferID': '" + offerid + "'}";

            $.ajax({         
                type: "POST",         
                url: "../service/cmService.asmx/GetDataQueries",         
                data: dArray,         
                contentType: "application/json; charset=utf-8",         
                dataType: "json",  
                async: true,       
                success: function(response) {             
                    $("*[id$='ddlDataSql']").get(0).options.length = 0;             
                    
                    $.each(response.d, function(index, item) {                 
                        $("*[id$='ddlDataSql']").get(0).options[$("*[id$='ddlDataSql']").get(0).options.length] = new Option(item[0], item[1]);             
                    });         
                },         
                error: function(response) {    
                    $().toastmessage('showErrorToast', response.responseText);
                }     
            });
        }

        function SaveQuestions() {
            var bxid = <%=ContractID %>
            var q = '';

            $("*[id$='chkQuestions'] :checked").each(function() {
                q += $('label[for=' + this.id + ']').html() + '|';
            });

            $.ajax({
                type: "POST",
                url: "contractDialog.aspx/SaveQuestions",
                data: "{BuyerOfferXrefID:'" + bxid + "', Questions:'" + q + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(r) {
                    $().toastmessage('showSuccessToast', 'Questions saved.');
                },
                error: function(r) {
                    $().toastmessage('showErrorToast', r.responseText);
                }
            });

            return false;
        }
    </script>
    <script type="text/javascript">
        function SaveWebsites() {
            var types = new Array;
            
            $("#divWebsites input[type=checkbox]:checked").each(function() {
                types.push($('label[for=' + this.id + ']').html());
            });

            var websiteids = types.join(',');

            var jsn = "{'contractid': '" + <%=ContractID %> + "', 'websitetypeid': '" + $("*[id$='ddlWebsiteType']").val() + "', 'websiteids': '" + websiteids + "', 'userid': '" + <%=UserID %> + "'}";
            
            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SaveContractWebsites",
                data: jsn,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.responseText);
                }
            });
        }

        function GetWebsites() {
            var dArray = "{'WebSiteTypeID': '" + $("*[id$='ddlWebsiteType']").val() + "'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetWebsitesByType",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {                    
                    $("#divWebsites").html("");
                    $('#divWebsites').append("<input id=CheckBox1 type=checkbox value=-1 checked /><label for=CheckBox1>All</label><br />");

                    $.each(response.d, function(index, item) {     
                        var html = "<input id=CheckBox" + item[0] + " type=checkbox value=" + item[0] + " /><label for=CheckBox" + item[0] + ">" + item[1] + "</label><br />";
                        $('#divWebsites').append(html);
                    });   
                },
                failure: function (response) {
                    $().toastmessage('showErrorToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.responseText);
                }
            });
        }

        function clear() {
            $("*[id$='rdoExcludeDNC']").attr("checked", false);
            $("*[id$='rdoWirelessOnly']").attr("checked", false);
            $("*[id$='rdoLandlineOnly']").attr("checked", false);
        }

        function closeUpload(){
            $("#dialog-upload").dialog("close");
            getFilters();
             $().toastmessage('showSuccessToast', 'Zipcodes Uploaded!');
            return false;
        } 
                  
        function ShowUploadDocument() {
            var bid = <%=contractid %>;
            
            $("#dialog-upload")
                .data('BuyerOfferXrefID', bid)
                .dialog("open");
            return false;
        }
    </script>
    <style type="text/css">
    .ui-slider-horizontal .ui-slider-handle {
      margin-left:-0.6em;
      top:-0.3em;
    }
    .ui-slider .ui-slider-handle {
      cursor:default;
      height:1.2em;
      position:absolute;
      width:1.2em;
      z-index:2;
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphDialogBody" runat="Server">
    <div id="content">
        <ul>
            <li><a href="#tab0"><span>Home</span></a></li>
            <li><a href="#tab1"><span>Schedule</span></a></li>
            <li><a href="#tab2"><span>Filters</span></a></li>
            <li><a href="#tab5"><span>Traffic&nbsp;Types</span></a></li>
            <li><a href="#tab6"><span>Questions</span></a></li>
            <li><a href="#tab3"><span>Delivery&nbsp;Method</span></a></li>
            <li><a href="#tab4"><span>History</span></a></li>
            <li><a href="#tabWeb"><span>Websites</span></a></li>
        </ul>
        <div id="tab0">
            <div>
                <b class="rndBoxBlue"><b class="rndBoxBlue1"><b></b></b><b class="rndBoxBlue2"><b></b>
                </b><b class="rndBoxBlue3"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue5"></b>
                </b>
                <div class="rndBoxBluefg">
                    <!-- content goes here -->
                    <table style="width: 100%; color: White;" border="0">
                        <tr valign="top">
                            <td style="width: 50%;">
                                <table style="width: 100%;" border="0">
                                    <tr title="Click cell to edit">
                                        <td class="tdHdr">
                                            Contract Name:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtContractName" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black; width: 98%;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Contract Type:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:DropDownList ID="ddlContractType" runat="server" DataSourceID="dsContractType"
                                                DataTextField="ContractType" DataValueField="ContractTypeID" Width="250px" />
                                            <asp:SqlDataSource ID="dsContractType" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="select ContractTypeID,ContractType from tblcontracttypes order BY ContractType">
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Transfer #:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtServiceTelNum" runat="server" onclick="EnableControl(this);"
                                                onblur="DisableControl(this);" Style="border: none; background-color: Transparent;
                                                color: Black;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Daily Cap:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtDailyCap" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black;" />
                                            <asp:FilteredTextBoxExtender ID="txtDailyCap_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" FilterType="Numbers" TargetControlID="txtDailyCap">
                                            </asp:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Invoice Price:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtInvoicePrice" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black;" />
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" Enabled="True"
                                                TargetControlID="txtInvoicePrice" ValidChars="0123456789.">
                                            </asp:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            RPT Price:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtPrice" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black;" />
                                            <asp:FilteredTextBoxExtender ID="txtPrice_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" TargetControlID="txtPrice" ValidChars="0123456789.">
                                            </asp:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Points:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtPointValue" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Weight:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:TextBox ID="txtWeight" runat="server" onclick="EnableControl(this);" onblur="DisableControl(this);"
                                                Style="border: none; background-color: Transparent; color: Black;" />
                                            <asp:FilteredTextBoxExtender ID="txtWeight_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" FilterType="Numbers" TargetControlID="txtWeight">
                                            </asp:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Priority:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:DropDownList ID="ddlPriority" runat="server" Width="250px">
                                                <asp:ListItem Value="1" Text="Tier 1"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tier 2"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tier 3"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Offer:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:DropDownList ID="ddlOffers" runat="server" DataTextField="Offer" DataValueField="OfferID"
                                                Width="250px" onchange="GetDataQueries()">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdHdr">
                                            Dup Period:
                                        </td>
                                        <td class="tdCnt">
                                            <asp:DropDownList ID="ddlDupAttempt" runat="server" Width="250px">
                                                <asp:ListItem Value="7" Text="7 Days"></asp:ListItem>
                                                <asp:ListItem Value="14" Text="14 Days"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30 Days"></asp:ListItem>
                                                <asp:ListItem Value="60" Text="60 Days"></asp:ListItem>
                                                <asp:ListItem Value="90" Text="90 Days"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table style="width: 100%">
                                                <tr>
                                                    <td class="tdHdr">
                                                        Exclusive:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkExclusive" runat="server" />
                                                        <asp:Image ID="Image3" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Removes a successful lead from the dialer and sets the lead status to Transferred" />
                                                    </td>
                                                    <td class="tdHdr">
                                                        Active:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkContractActive" runat="server" />
                                                        <asp:Image ID="Image6" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Activate contract" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        Call Center:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkCallCenter" runat="server" />
                                                        <asp:Image ID="imgCallCtr" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Is this contract to be used in the Call Center?" />
                                                    </td>
                                                    <td class="tdHdr">
                                                        Throttle:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkthrottle" runat="server" />
                                                        <asp:Image ID="Image1" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Adds a short delay between data transfers" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        Live Transfer:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkCallTransfer" runat="server" />
                                                        <asp:Image ID="imgCallTrans" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Check this option if this contract is for a Live Transfer" />
                                                    </td>
                                                    <td class="tdHdr">
                                                        Data Transfer:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkDataTransfer" runat="server" />
                                                        <asp:Image ID="imgDataTrans" runat="server" ImageUrl="../images/tooltip.gif" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        Exclude DNC:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="rdoExcludeDNC" runat="server" />
                                                        <asp:Image ID="Image5" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Check this option to exclude Do Not Call phone numbers. All wireless numbers are DNC." />
                                                    </td>
                                                    <td class="tdHdr">
                                                        No Scrub:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:CheckBox ID="chkNoScrub" runat="server" />
                                                        <asp:Image ID="Image2" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Check this option to flag all posts as valid regardless of buyer's response" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        Wireless Only:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:RadioButton ID="rdoWirelessOnly" runat="server" GroupName="DNC" />
                                                        <asp:Image ID="Image4" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Check this option to only include Wireless phone numbers." />
                                                    </td>
                                                    <td class="tdHdr">
                                                    </td>
                                                    <td class="tdCnt">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        Landline Only:
                                                    </td>
                                                    <td class="tdCnt">
                                                        <asp:RadioButton ID="rdoLandlineOnly" runat="server" GroupName="DNC" />
                                                        <asp:Image ID="Image7" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Check this option to only include Landline phone numbers." />
                                                        <img src="../images/16x16_clear.png" title="Clear radio button selections" onclick="clear()" />
                                                    </td>
                                                    <td class="tdHdr">
                                                    </td>
                                                    <td class="tdCnt">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="border-left: inset 1px black">
                                <div style="padding: 2px 15px;">
                                    <div>
                                        Notes:</div>
                                    <div>
                                        <asp:TextBox ID="txtInstructions" runat="server" TextMode="MultiLine" Width="98%"
                                            Rows="10" />
                                    </div>
                                </div>
                                <div style="padding: 2px 15px;">
                                    <div>
                                        Data Leads:</div>
                                    <div>
                                        <asp:DropDownList ID="ddlDataSql" runat="server" Width="98%" DataTextField="Name"
                                            DataValueField="StoredProc">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <table style="padding: 2px 15px; width:95%;">
                                    <tr>
                                        <td style="width:300px;">
                                            <div style="padding: 2px 10px;">
                                                <div>
                                                    Real-Time Leads:</div>
                                                <div>
                                                    <!-- values represent minutes back -->
                                                    <asp:DropDownList ID="ddlRealTimeMinutes" runat="server" Width="98%">
                                                        <asp:ListItem Value="-15" Text="15 Minutes"></asp:ListItem>
                                                        <asp:ListItem Value="-30" Text="30 Minutes"></asp:ListItem>
                                                        <asp:ListItem Value="-60" Text="60 Minutes"></asp:ListItem>
                                                        <asp:ListItem Value="-120" Text="2 Hours"></asp:ListItem>
                                                        <asp:ListItem Value="-240" Text="4 Hours"></asp:ListItem>
                                                        <asp:ListItem Value="-360" Text="6 Hours"></asp:ListItem>
                                                        <asp:ListItem Value="-480" Text="8 Hours"></asp:ListItem>
                                                        <asp:ListItem Value="-720" Text="12 Hours"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="width:300px;">
                                            <div style="padding: 2px 10px;">
                                                <div>
                                                    Aged Leads:</div>
                                                <div>
                                                    <!-- values represent minutes back -->
                                                    <asp:DropDownList ID="ddlAgedMinutes" runat="server" Width="98%">
                                                        <asp:ListItem Value="-1440" Text="1 Day"></asp:ListItem>
                                                        <asp:ListItem Value="-2880" Text="2 Days"></asp:ListItem>
                                                        <asp:ListItem Value="-4320" Text="3 Days"></asp:ListItem>
                                                        <asp:ListItem Value="-5760" Text="4 Days"></asp:ListItem>
                                                        <asp:ListItem Value="-7200" Text="5 Days"></asp:ListItem>
                                                        <asp:ListItem Value="-8640" Text="6 Days"></asp:ListItem>
                                                        <asp:ListItem Value="-10080" Text="7 Days"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </td>
                            </tr> </table>
                                <div style="padding: 2px 15px;">
                                    Percentage of Badazzling:&nbsp;<label id="lbTrickle"></label>%
                                </div>
                                <div style="padding:2px 20px; width:90%;">
                                    <div id="sdrTrickle"></div>
                                </div>
                                <div style="padding: 2px 15px;">
                                    <div>
                                        Data Sort Field:
                                        <asp:DropDownList ID="ddlSortField" runat="server" Width="98%">
                                            <asp:ListItem Text="None" Value="-1" />
                                            <asp:ListItem Text="Created" />
                                        </asp:DropDownList>
                                        Data Sort Direction:
                                        <asp:DropDownList ID="ddlSortDir" runat="server" Width="98%">
                                            <asp:ListItem Text="None" Value="-1" />
                                            <asp:ListItem Text="Ascending" Value="ASC" />
                                            <asp:ListItem Text="Descending" Value="DESC" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right">
                                <button id="btnSaveContractInfo" onclick="return SaveContractInfo();" class="jqSaveButton"
                                    style="position: relative; float: right;">
                                    Save</button>
                            </td>
                        </tr>
                    </table>
                </div>
                <b class="rndBoxBlue"><b class="rndBoxBlue5"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue3">
                </b><b class="rndBoxBlue2"><b></b></b><b class="rndBoxBlue1"><b></b></b></b>
            </div>
        </div>
        <div id="tab1">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" style="margin-top: 5px; padding: 0 .7em;">
                    <h3>
                        Delivery Schedule</h3>
                    <p>
                        Buyers delivery schedules are determined by preset daily defaults. These defaults
                        are used when the buying schedule for the day is created at each night at midnight.
                        For example, if a buyer has a default set on Monday from 6:00 AM to 8:00 PM, each
                        Monday at Midnight (12:00 AM) that buyer will be added to the buying schedule to
                        receive leads during that time frame.</p>
                </div>
            </div>
            <br />
            <table style="width: 100%;">
                <tr>
                    <td>
                        <div class="buttonHolder">
                            <small>
                                <button id="btnAdd" class="jqAddButton" onclick="return AddRemoveDeliverySchedule(this,'a');"
                                    style="position: relative; float: left;">
                                    Add
                                </button>
                            </small><small>
                                <button id="btnRemove" runat="server" class="jqDeleteButton" onclick="return AddRemoveDeliverySchedule(this,'d');"
                                    style="position: relative; float: left;">
                                    Remove</button>
                            </small><small>
                                <button id="btnSave" runat="server" class="jqSaveButtonNoText" onclick="return AddRemoveDeliverySchedule(this,'s');"
                                    style="position: relative; float: left;">
                                    Save changes</button>
                            </small>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="divDeliverySchedGrid" style="width: 100%; height: 200px;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="tab2">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" style="margin-top: 5px; padding: 0 .7em;">
                    <h3>
                        Filters</h3>
                    <p>
                        Active Filters: State.</p>
                </div>
            </div>
            <div style="clear: both; height: 10px">
            </div>
            <div class="ui-widget">
                <div class="ui-widget-header">
                    Filters</div>
                <div class="ui-widget-content" style="padding: 10px!important">
                    <table style="width: 100%">
                        <tr valign="top">
                            <td style="width: 50%;">
                                <table id="filtertable" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="filtertablepager"></div> 
                                <div id="divFilterGrid" style="width: 100%; height: 300px; overflow-y: scroll; overflow-x: hidden;">
                                </div>
                            </td>
                            <td>
                                <fieldset>
                                <legend>Filter Type</legend>
                                <asp:DropDownList ID="filterType" runat="server" CssClass="filter-type" onchange="getFilterType();" >
                                <asp:ListItem Text="NONE" Value="" />
                                <asp:ListItem Text="State" />
                                <asp:ListItem Text="ZipCode"  />
                                <asp:ListItem Text="Columns"  />
                                </asp:DropDownList>
                                </fieldset>
                                <fieldset class="filterstate" style="display:none">
                                    <legend>Create New State Filter</legend>
                                    <table id="tblFilters" style="width: 100%">
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlFilterClause" runat="server">
                                                    <asp:ListItem Text="Does Not Contain State" />
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlFilterValue" runat="server" DataSourceID="dsStates" DataTextField="StateName"
                                                    DataValueField="StateCode">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="dsStates" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                    SelectCommand="SELECT [StateCode], [StateName] FROM [tblStates] where statename <> 'unknown'">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td>
                                                <small>
                                                    <button id="btnSaveFilter" onclick="return UpdateInsertFilter(this,'a');" class="jqAddButton">
                                                        Add</button>
                                                </small>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                <fieldset class="filterzipcode" style="display: none">
                                    <legend>Upload New Zipcode Filter</legend>
                                    
                                                <small>
                                                    <asp:Button ID="btnUploadDoc" runat="server" Text="Upload Document" CssClass="jqButton"
                                                         OnClientClick="return ShowUploadDocument();" />
                                                </small>
                                          
                                </fieldset>
                                <fieldset class="filtercolumns" style="display:none">
                                    <legend>Create New Column Filter</legend>
                                    <table id="tblFilterColumns" style="width: 100%">
                                        <tr>                                            
                                            <td>
                                                <asp:DropDownList ID="ddlFilterColumn" runat="server" DataSourceID="dsColumn" DataTextField="ColumnName"
                                                    DataValueField="ColumnName">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="dsColumn" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                    SelectCommand="select COLUMN_NAME ColumnName, DATA_TYPE Type from information_schema.columns where table_name in (select c.dataTable from tblBuyerOfferXref xref join tblOffers o on o.OfferID = xref.OfferID join tblVertical v on v.VerticalID = o.VerticalID join tblCategory c on c.CategoryID = v.CategoryID where xref.BuyerOfferXrefID = 469)">
                                                </asp:SqlDataSource>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlFilterOperators" runat="server">
                                                    <asp:ListItem Text="Equal To" />
                                                    <asp:ListItem Text="Not Equal To" />
                                                    <asp:ListItem Text="Greater Than" />
                                                    <asp:ListItem Text="Less Than" />
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="tbFilterValue" class="" runat="server" ></asp:TextBox>                                                
                                            </td>
                                            <td>
                                                <small>
                                                    <button id="btnInsertColumn" onclick="return UpdateInsertFilter(this,'a');" class="jqAddButton">
                                                        Add</button>
                                                </small>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="tab5">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" style="margin-top: 5px; padding: 0 .7em;">
                    <h3>
                        Traffic Types</h3>
                    <p>
                        Choose which type(s) of traffic this buyer can receive. Traffic types are set at
                        the Campaign level.</p>
                </div>
            </div>
            <br />
            <div class="buttonHolder">
                <small>
                    <button id="btnSaveTrafficTypes" runat="server" class="jqSaveButtonNoText" onclick="return SaveTrafficTypes();"
                        style="position: relative; float: left;">
                        Save</button>
                </small>
            </div>
            <div style="clear: both; height: 5px">
            </div>
            <div style="background-color: #fff; border: 1px solid #cccccc">
                <asp:CheckBoxList ID="chkTrafficTypes" runat="server" RepeatColumns="2" RepeatDirection="Vertical"
                    DataTextField="Name" DataValueField="TrafficTypeID" DataSourceID="ds_TrafficTypes"
                    Width="50%">
                </asp:CheckBoxList>
            </div>
            <asp:SqlDataSource ID="ds_TrafficTypes" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="select TrafficTypeID, Name from tblTrafficTypes order by Seq, Name"
                SelectCommandType="Text"></asp:SqlDataSource>
        </div>
        <div id="tab6">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" style="margin-top: 5px; padding: 0 .7em;">
                    <h3>
                        Questions</h3>
                    <p>
                        Filter leads by specific question(s)/response(s). Be sure to also select a Data
                        Leads source on the Home tab. Below is a list of active survey questions and responses.
                        Actual question text may vary by survey.</p>
                </div>
            </div>
            <br />
            <div class="buttonHolder">
                <small>
                    <button id="Button1" runat="server" class="jqSaveButtonNoText" onclick="return SaveQuestions();"
                        style="position: relative; float: left;">
                        Save</button>
                </small>
            </div>
            <div style="clear: both; height: 5px">
            </div>
            <div style="background-color: #fff; border: 1px solid #cccccc; height: 360px; overflow: auto">
                <asp:CheckBoxList ID="chkQuestions" runat="server" RepeatColumns="1" RepeatDirection="Vertical"
                    DataTextField="Question" DataSourceID="ds_Questions" Width="100%">
                </asp:CheckBoxList>
            </div>
            <asp:SqlDataSource ID="ds_Questions" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="
                        select distinct q.QuestionPlainText + ' - ' + o.OptionText [Question]
                        from tblQuestion q
                        join tblOptions o on o.QuestionID = q.QuestionID
                        join tblSurvey s on s.SurveyID = q.SurveyID
	                        and s.Active = 1
                        where q.Active = 1	
                        order by [Question]" SelectCommandType="Text"></asp:SqlDataSource>
        </div>
        <div id="tab3">
            
            <div class="ui-widget">
                <div class="ui-widget-header">
                    Post URL
                </div>
                <div class="ui-widget-content">
                    <table style="width: 100%;">
                        <tr>
                            <td style="padding: 3px;">
                                <asp:TextBox ID="txtPostURL" runat="server" Width="100%" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <small>
                                    <button id="btnSavePostURL" class="jqSaveButton" onclick="return savePostUrl();"
                                        style="float: right!important">
                                        Save Post Url</button></small> 
                                <small>
                                    <button id="Button3" class="jqHelpButton" onclick="return showHelpMsg('<div class=\'ui-widget\'><div class=\'ui-state-highlight ui-corner-all\' style=\'margin-top: 5px; padding: 0 .7em;\'><h3>    Delivery Method</h3> <p style=\'font-size:11px;\'>Setup the buyer\'s posting instructions here. Parameter is what the buyer wants our Field passed in as. To hard-code a value enter it in the Parameter as [parameter]=[value] format (ie. someid=12345). For FTP - username, password, and passivemode (optional) are reserved parameter names. These must be defined for an FTP delivery method.  The Query option is used for unique cases where the buyer is not getting the data posted.  To send an XML post add a Parameter and set the field to XMLRoot.</p></div></div>');"
                                        style="float: right!important" type="button">
                                        Help</button>
                                </small>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="clear: both; height: 8px">
            </div>
            <div id="postcontent">
                <ul>
                    <li><a href="#tabpost0"><span>Post Fields</span></a></li>
                    <li><a href="#tabpost1"><span>Responses</span></a></li>
                    <li><a href="#tabpost2"><span>Test</span></a></li>
                </ul>
                <div id="tabpost0">
                    <div style="overflow-y: scroll; overflow-x: hidden; height: 250px;">
                        <table id="tblPostFldsBody" style="width: 100%;" cellpadding="0" cellspacing="0"
                            class="ui-widget-content">
                            <thead>
                                <tr>
                                    <th style="width: 55px;" class="ui-widget-header">
                                        Query
                                    </th>
                                    <th class="ui-widget-header">
                                        Parameter
                                    </th>
                                    <th class="ui-widget-header">
                                        Field
                                    </th>
                                    <th class="ui-widget-header">
                                        &nbsp;
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                    <table style="width: 100%;" cellpadding="0" cellspacing="0" class="ui-widget-content">
                        <tr style="border-top: solid 1px #000" title="Add new post field">
                            <th style="width: 56px; border-top: solid 1px #000" class="ui-widget-header">
                                <asp:CheckBox ID="chkPostQuery" runat="server" />
                            </th>
                            <th align="left" style="border-top: solid 1px #000" class="ui-widget-header">
                                <asp:TextBox ID="txtPostParameter" runat="server" Width="280px" />
                            </th>
                            <th align="left" style="border-top: solid 1px #000; width: 172px" class="ui-widget-header">
                                <asp:DropDownList ID="ddlPostField" runat="server" DataSourceID="ds_Fields" DataTextField="DisplayText" DataValueField="FieldID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="ds_Fields" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>" SelectCommandType="Text" SelectCommand="select FieldID, DisplayText from tblDeliveryMethodFields order by DisplayText"></asp:SqlDataSource>
                            </th>
                            <th style="border-top: solid 1px #000; width: 65px" class="ui-widget-header">
                                <small>
                                    <button id="btnAddPostField" class="jqAddButton" onclick="return AddRemovePostField(this,'insert',1);">
                                        Add Postfield</button>
                                </small>
                            </th>
                        </tr>
                    </table>
                </div>
                <div id="tabpost1">
                    <fieldset>
                        <table style="width: 100%" border="0">
                            <tr>
                                <td class="tdHdr" width="150px">
                                    Response Type:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlResponseType" runat="server">
                                        <asp:ListItem Text="XML" />
                                        <asp:ListItem Text="TEXT" Value="Text" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr" width="150px">
                                    Success Text:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtResponseSuccessText" runat="server" Width="98%" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr" width="150px">
                                    ID XML Node:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtIDXML" runat="server" Width="98%" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr" width="150px">
                                    Result Code XML Node:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCodeXML" runat="server" Width="98%" />
                                </td>
                            </tr>
                            <tr>
                                <td class="tdHdr" width="150px">
                                    Error XML Node:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtErrorXML" runat="server" Width="98%" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <small>
                                        <button id="btnSaveResponse" class="jqSaveButton" onclick="return AddRemoveResponse();">
                                            Save Response</button>
                                    </small>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
                <div id="tabpost2">
                    <div id="divTestPostFields" style="width:40%; float:left; height: 330px; overflow-y:auto">
                    </div>
                    <div style="width:60%; float:right">
                        Test Post Results:<br />
                        <textarea id="txtTestResults" cols="40" rows="15" style="width:100%"></textarea>
                    </div>
                    <div style="clear:both"></div>
                    <hr />
                    <small>
                        <button id="Button2" class="jqButton" onclick="return sendTestPost2();" type="button"
                            style="float: right">
                            Submit</button></small>
                    <div style="clear:both"></div>
                </div>
            </div>
            
        </div>
        <div id="tab4">
            <div id="history">
                <ul>
                    <li><a href="#tabhistory"><span>Accepted</span></a></li>
                    <li><a href="#tabreturns"><span>Returned</span></a></li>
                </ul>
                <div id="tabhistory">
                    <div id="divHistoryGrid" style="height: 400px; overflow-x: hidden; overflow-y: scroll;">
                    </div>
                </div>
                <div id="tabreturns">
                    <div id="divReturnsGrid" style="height: 400px; overflow-x: hidden; overflow-y: scroll;">
                        add returns data
                    </div>
                </div>
            </div>
        </div>
        <div id="tabWeb">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" style="margin-top: 5px; padding: 0 .7em;">
                    <h3>
                        Websites</h3>
                    <p>
                        Choose which website(s) this contract can receive leads from.</p>
                </div>
            </div>
            <br />
            <div class="buttonHolder">
                    <table>
                        <tr>
                            <td>
                                Website Type:
                                <asp:DropDownList ID="ddlWebsiteType" runat="server" DataSourceID="dsWebsiteType"
                                    DataTextField="type" DataValueField="websitetypeid" Width="130px" onchange="GetWebsites()" AppendDataBoundItems="true">
                                    <asp:ListItem Text="--Not set--" Value="-1"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="dsWebsiteType" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="select websitetypeid,type from tblWebsitetypes ORDER BY type">
                                </asp:SqlDataSource>
                            </td>
                            <td>
                                <small><button id="btnSaveWebsites" type="button" class="jqSaveButtonNoText" style="float: right!important"
                                    onclick="return SaveWebsites();">
                                    Save</button></small>
                            </td>
                        </tr>
                    </table>
            </div>
            <div style="clear: both; height: 5px">
            </div>
            <div id="divWebsites" style="background-color: #fff; border: 1px solid #cccccc; padding:5px">
                <asp:CheckBoxList ID="chkWebsites" runat="server" RepeatColumns="1" RepeatDirection="Vertical"
                    DataTextField="Name" DataValueField="WebsiteID"
                    Width="50%" AppendDataBoundItems="true">
                    <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                </asp:CheckBoxList>
            </div>
        </div>
    </div>
    <div id="dialog-upload" title="Upload Document(s)">
        <input id="btnReset" type="button" value="New Upload" class="jqButton" /><br/>
        <div id="uploader">
            <p>
                You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
        </div>
    </div>
</asp:Content>