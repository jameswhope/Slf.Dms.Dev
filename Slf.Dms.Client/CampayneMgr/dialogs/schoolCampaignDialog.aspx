<%@ Page Title="" Language="VB" MasterPageFile="~/dialogs/dialog.master" AutoEventWireup="false"
    CodeFile="schoolCampaignDialog.aspx.vb" Inherits="dialogs_schoolCampaignDialog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dialogHeadCnt" runat="Server">
    <script type="text/javascript">
        /*global vars*/
        var lastFieldItemSel;
        var lastFieldSel;
        var lastRuleSel;
        var lastLocationSel;
        var ckoptions = { langCode: 'en', skin: 'office2003',
            width: '98%',
            height: 300,
            toolbar:
				[
					['Source', '-', 'Bold', 'Italic', 'Underline', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat', '-', 'NumberedList', 'BulletedList', '-', 'TextColor'],
					['Font', 'FontSize', 'Format']
				]
        };
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {

                LoadButtons();
                LoadDialogs();
                LoadTabs();
                loadJQGridviewButtons();
                $('.editor').ckeditor(ckoptions);

                $("#btnTestForm").hide();
                $("#btnSaveForm").hide();
                $("#btnDeleteForm").hide();
                
                $("*[id$='ddlSchoolLocations']").change(function () {
                    if ($(this).val() == -1) {
                        $("#btnTestForm").hide();
                        $("#btnSaveForm").hide();
                        $("#btnDeleteForm").hide();
                    } else {
                        $("#btnTestForm").show();
                        $("#btnSaveForm").show();
                        $("#btnDeleteForm").show();
                    }
                    LoadForm($(this).val());
                });
            });
        }
    </script>
    <script type="text/javascript">
        function LoadButtons() {
            $(".jqButton").button();
            $(".jqAddButton").button({
                icons: {
                    primary: "ui-icon-plusthick"
                },
                text: true
            });
            $(".jqLoadButton").button({
                icons: {
                    primary: "ui-icon-transferthick-e-w"
                },
                text: true
            });
            $(".jqCancelButton").button({
                icons: {
                    primary: "ui-icon-closethick"
                },
                text: true
            });
            $(".jqTestButton").button({
                icons: {
                    primary: "ui-icon-lightbulb"
                },
                text: true
            });
            $(".jqDeleteButton").button({
                icons: {
                    primary: "ui-icon-trash"
                },
                text: true
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
                text: true
            });
            $(".jqViewButton").button({
                icons: {
                    primary: "ui-icon-folder-open"
                },
                text: true
            });

        }
        function LoadDialogs() {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-upload").dialog({
                autoOpen: false,
                height: 500,
                width: 520,
                modal: true,
                stack: true,
                position: "top"
            });
            $("#dialog-testform").dialog({
                autoOpen: false,
                modal: true,
                height: 680,
                width: 750,
                position: "top"
            });
            $("#dialog-edit").dialog({
                autoOpen: false,
                modal: true,
                height: 600,
                width: 650,
                position: 'top'
            });
        }
        function LoadTabs() {
            $("#schoolcampaigntab").tabs({
                cache: false,
                ajaxOptions: {
                    cache: false
                },
                selected: 0,
                fx: [{ opacity: 'toggle', duration: 'normal' },   // hide option 
                {opacity: 'toggle', duration: 'fast'}]
            });
            var $tabs = $("#postingtab").tabs({
                select: function (e, ui) {
                    var thistab = ui.index;
                    switch (thistab) {
                        case 0:
                            $("#fieldstable").trigger("reloadGrid");
                            break;
                        case 1:
                            $("#rulestable").trigger("reloadGrid");
                            break;
                        case 2:
                            $("#locationstable").trigger("reloadGrid");
                            break;
                        case 3:
                            $("#fielditemstable").trigger("reloadGrid");
                            break;
                        default:
                            break;
                    }
                },
                selected: 0
            });
            $("#loctab").tabs({
                cache: false,
                ajaxOptions: {
                    cache: false
                },
                selected: 0,
                fx: [{ opacity: 'toggle', duration: 'normal' },   // hide option 
                {opacity: 'toggle', duration: 'fast'}]
            });
            $("#fieldstab").tabs({
                cache: false,
                ajaxOptions: {
                    cache: false
                },
                selected: 0,
                fx: [{ opacity: 'toggle', duration: 'normal' },   // hide option 
                {opacity: 'toggle', duration: 'fast'}]
            });

        }
        function LoadFormDropdown(scoid) {
            var dArray = "{'schoolcampaignid': '" + scoid + "'}";
            doAjax('GetForms', dArray, true, function (result) {
                var obj = eval('(' + result.d + ')');
                $("*[id$='ddlSchoolLocations']").empty();
                $("*[id$='ddlSchoolLocations']").append("<option value='-1'>-- Select Form --</option>");

                for (var i = 0; i < obj.length; i++) {
                    $("*[id$='ddlSchoolLocations']").append("<option value='" + obj[i][0] + "'>" + obj[i][1] + "</option>");
                }
            },
            function (result) {
                $().toastmessage('showErrorToast', result);
            })

        }
    </script>
    <script type="text/javascript">
        function LoadSchoolForm(id) {
            $("#loaddetail").show();
            $("#loaddetail").html(loadingImg);
            $("#tbldetail").css('display', 'none');

            var dArray = "{'schoolcampaignid': '" + id + "'}";
            doAjax('GetSchoolCampaign', dArray, true, function (result) {
                var scObj = eval('(' + result.d + ')');
                $("#dialog-campaign").dialog("option", "title", scObj.Name);

                $("*[id$='txtName']").val(scObj.Name);
                $("*[id$='txtDescription']").val(scObj.Description);
                $("*[id$='ddlType']").val(scObj.Type);
                $("*[id$='txtPayout']").val(scObj.Payout);
                $("*[id$='txtSubmitted']").val(scObj.Submitted);
                $("*[id$='txtLeads']").val(scObj.Leads);
                $("*[id$='txtRejected']").val(scObj.Rejected);
                $("*[id$='txtCredited']").val(scObj.Credited);
                $("*[id$='txtEstCommission']").val(scObj.EstCommission);
                $("*[id$='ddlAcceptanceAreaRule']").val(scObj.AcceptanceAreaRule);
                $("*[id$='txtInstructions']").val(scObj.Instructions);
                $("*[id$='ddlLocationType']").val(scObj.LocationType);

                if (scObj.Status == true) {
                    $("*[id$='chkStatus']").attr('checked', true);
                } else {
                    $("*[id$='chkStatus']").attr('checked', false);
                }
                if (scObj.EnforceAcceptanceArea == true) {
                    $("*[id$='chkEnforceAcceptanceArea']").attr('checked', true);
                } else {
                    $("*[id$='chkEnforceAcceptanceArea']").attr('checked', false);
                }
                if (scObj.AcceptsAllZipCodes == true) {
                    $("*[id$='chkAcceptsAllZipCodes']").attr('checked', true);
                } else {
                    $("*[id$='chkAcceptsAllZipCodes']").attr('checked', false);
                }

                LoadFormDropdown(sco.SchoolCampaignID);

                $("*[id$='txtFormName']").val('');
                $("*[id$='txtPostUrl']").val('');
                $("*[id$='txtLeadsRemaining']").val('');
                $("*[id$='txtDailyLimit']").val('');
                $("*[id$='txtLogoUrl']").val('');
                $("*[id$='divDescrContent']").val('');

                $("#fieldstable").jqGrid("clearGridData")
                $("#rulestable").jqGrid("clearGridData")
                $("#locationstable").jqGrid("clearGridData")
                $("#loaddetail").hide();
                $("#loaddetail").html('');
                $("#tbldetail").css('display', 'block');
                $("#postingtab").css('display', 'none');
            },
            function (result) {
                $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
                $("#loaddetail").hide();
                $("#loaddetail").html('');
                $("#tbldetail").css('display', 'block');
            });

        }
      
        function DeleteSchoolCampaign() {
            if (confirm('Are you sure you want to delete this school campaign?')) {
                $().toastmessage('showWarningToast', 'Not Implemented Yet!');
            }
        }

        function SaveSchoolCampaign() {
            //InsertUpdateSchoolCampaigns
            var scoid = $("*[id$='hdnSchoolCampaignID']").val();
            var sco = new Object();
            sco.SchoolCampaignID = scoid;
            sco.Name = $("*[id$='txtName']").val();
            sco.Description = $("*[id$='txtDescription']").val();
            sco.PostUrl = $("*[id$='txtPostUrl']").val();
            sco.Type = $("*[id$='ddlType']").val();
            sco.Payout = $("*[id$='txtPayout']").val();
            sco.Status = getCheckboxValue($("*[id$='chkStatus']").attr("checked"));
            sco.Submitted = $("*[id$='txtSubmitted']").val();
            sco.MonthlyCap = $("*[id$='txtMonthlyCap']").val();
            sco.Leads = $("*[id$='txtLeads']").val();
            sco.Rejected = $("*[id$='txtRejected']").val();
            sco.Credited = $("*[id$='txtCredited']").val();
            sco.EstCommission = $("*[id$='txtEstCommission']").val();
            sco.EnforceAcceptanceArea = getCheckboxValue($("*[id$='chkEnforceAcceptanceArea']").attr("checked"));
            sco.AcceptsAllZipCodes = getCheckboxValue($("*[id$='chkAcceptsAllZipCodes']").attr("checked"));
            sco.AcceptanceAreaRule = $("*[id$='ddlAcceptanceAreaRule']").val();
            sco.Instructions = $("*[id$='txtInstructions']").val();
            sco.LocationType = $("*[id$='ddlLocationType']").val();

            var DTO = {
                'schoolcampaign': sco
            };

            doAjax('InsertUpdateSchoolCampaign', JSON.stringify(DTO), true, function (result) {
                $().toastmessage('showSuccessToast', result.d);
            },
            function (result) {
                $().toastmessage('showErrorToast', result);
            })
        }
    </script>
    <script type="text/javascript">
        /*form*/
        function DeleteFormDefinition() {
            if (confirm('This will delete all the posting information for this school, are you sure?') == true) {
                var scid = $("*[id$='ddlSchoolLocations']").val();
                if (scid == -1) {
                    $().toastmessage('showWarningToast', 'Please select a form!');
                    return;
                }
                var dArray = "{'schoolformid': '" + scid + "'}";
                doAjax('DeletePostingInformation', dArray, true, function (result) {
                    $().toastmessage('showSuccessToast', result.d);
                    $("#fieldstable").trigger("reloadGrid");
                    $("#rulestable").trigger("reloadGrid");
                    $("#locationstable").trigger("reloadGrid");
                    $("*[id$='ddlSchoolLocations']").empty();
                    $("*[id$='ddlSchoolLocations']").append("<option value='-1'>-- Select Form --</option>");
                    LoadFormDropdown($("*[id$='hdnSchoolCampaignID']").val());
                    $("#btnTestForm").hide();
                    $("#btnSaveForm").hide();
                    $("#btnDeleteForm").hide();
                    $("#postingtab").css('display', 'none');
                },
                function (result) {
                    $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
                });
            }

            return false;
        }
        //form stuff
        function LoadForm(formid) {

            $("#fieldstable").jqGrid("GridUnload")
            $("#fielditemstable").jqGrid("GridUnload")
            $("#rulestable").jqGrid("GridUnload")
            $("#locationstable").jqGrid("GridUnload")
            $("#loccurtable").jqGrid("GridUnload")
            if (formid != -1 && !!formid) {
                GetForm();
                getFields();
                getFieldItems();
                getRules();
                getLocations();
                getLocationCurriculumItems();
                getCategories()
//                $("#fieldstable").trigger("reloadGrid");
//                $("#fielditemstable").trigger("reloadGrid");
//                $("#rulestable").trigger("reloadGrid");
//                $("#locationstable").trigger("reloadGrid");
//                $("#loccurtable").trigger("reloadGrid");
                //$("#postingtab").css('display', 'block');

                var editor = CKEDITOR.instances.divDescrContent;
                CKEDITOR.config.protectedSource.push(/<([\S]+)[^>]*class="preserve"[^>]*>.*<\/\1>/g);
                CKEDITOR.config.fillEmptyBlocks = false;
                CKEDITOR.config.htmlEncodeOutput = true;
                CKEDITOR.config.fullPage = false;

                var writer = editor.dataProcessor.writer;
                writer.indentationChars = '\t';                 // The character sequence to use for every indentation step.
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

        } else {
            $("*[id$='txtFormName']").val('');
            $("*[id$='txtPostUrl']").val('http://webservices.plattformpartners.com/ILM/Default.ashx');
            $("*[id$='txtLeadsRemaining']").val('');
            $("*[id$='txtDailyLimit']").val('');
            $("*[id$='txtLogoUrl']").val('');
            $("*[id$='divDescrContent']").val('');
            $("*[id$='chkActive']").attr('checked', false);
            $("*[id$='chkMatch']").attr('checked', false);

            $("#fieldstable").jqGrid("clearGridData")
            $("#fielditemstable").jqGrid("clearGridData")
            $("#rulestable").jqGrid("clearGridData")
            $("#locationstable").jqGrid("clearGridData")
            $("#loccurtable").jqGrid("clearGridData")
            $('#itemList').html('');
            $('#itemList-nav').html('');
            $("#postingtab").css('display', 'none');
        }

    }

    function ClearFormDefinition() {
        $("*[id$='ddlSchoolLocations']").empty();
        $("*[id$='ddlSchoolLocations']").append("<option value='-1'>-- Select Form --</option>");
        $("*[id$='txtFormName']").val('');
        $("*[id$='txtPostUrl']").val('');
        $("*[id$='txtLeadsRemaining']").val('');
        $("*[id$='txtDailyLimit']").val('');
        $("*[id$='txtLogoUrl']").val('');
        $("*[id$='txtCallCtrMonthly']").val('');
        $("*[id$='txtCallCtrDaily']").val('');

        $("*[id$='divDescrContent']").val('');
        $("#fieldstable").jqGrid("clearGridData")
        $("#fielditemstable").jqGrid("clearGridData")
        $("#rulestable").jqGrid("clearGridData")
        $("#locationstable").jqGrid("clearGridData")
        $("#loccurtable").jqGrid("clearGridData")
        $('#itemList').html('');
        $('#itemList-nav').html('');
        $("*[id$='chkActive']").attr('checked', false);
        $("*[id$='chkMatch']").attr('checked', false);
        //$("#postingtab").css('display', 'none');
    }

    function GetForm() {
        $("#postingtab").css('display', 'none');
        $("#loadpost").show();
        $("#loadpost").html(loadingImg);
        var fdid = $("*[id$='ddlSchoolLocations']").val();
        var dArray = "{'schoolformid': '" + fdid + "'}";

        doAjax('GetForm', dArray, true, function (result) {
            //success
            var robj = eval('(' + result.d + ')');
            $("*[id$='txtFormName']").val(robj.Name);
            $("*[id$='txtPostUrl']").val(robj.PostURL);
            $("*[id$='txtLeadsRemaining']").val(robj.LeadsRemaining);
            $("*[id$='txtDailyLimit']").val(robj.DailyLimit);
            $("*[id$='txtLogoUrl']").val(robj.LogoURL);
            $("*[id$='divDescrContent']").val(robj.DescriptionContent);
            if (robj.Active == true) {
                $("*[id$='chkActive']").attr('checked', true);
            } else {
                $("*[id$='chkActive']").attr('checked', false);
            }
            if (robj.MatchCurriculumToDegreeType == true) {
                $("*[id$='chkMatch']").attr('checked', true);
            } else {
                $("*[id$='chkMatch']").attr('checked', false);
            }

            $("*[id$='txtCallCtrMonthly']").val(robj.CallCenterMonthlyAllocation);
            $("*[id$='txtCallCtrDaily']").val(robj.CallCenterDailyAllocation);


            $("#loadpost").hide();
            $("#postingtab").css('display', 'block');
        },
        function (result) {
            //error
            $().toastmessage('showErrorToast', result);
            $("#loadpost").hide();
            $("#postingtab").css('display', 'block');
        });
    }
    function SaveForm() {

        var fdid = $("*[id$='ddlSchoolLocations']").val();
        var formurl = $("*[id$='txtPostUrl']").val();
        var formname = $("*[id$='txtFormName']").val();
        var leadsremaining = $("*[id$='txtLeadsRemaining']").val();
        var dailylimit = $("*[id$='txtDailyLimit']").val();
        var CallCenterMonthlyAllocation = $("*[id$='txtCallCtrMonthly']").val();
        var CallCenterDailyAllocation = $("*[id$='txtCallCtrDaily']").val();

        var logourl = $("*[id$='txtLogoUrl']").val();
        var editor = CKEDITOR.instances.divDescrContent;
        var descrcontent = editor.getData();
        var bactive = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
        var bmatch = getCheckboxValue($("*[id$='chkMatch']").attr("checked"));

        if (fdid == -1) {
            $().toastmessage('showWarningToast', 'Please select a form!');
            return;
        }

        var dArray = "{";
        dArray += "'schoolformid': '" + fdid + "',";
        dArray += "'formname': '" + formname + "',";
        dArray += "'posturl': '" + formurl + "',";
        dArray += "'leadsremaining': '" + leadsremaining + "',";
        dArray += "'dailylimit': '" + dailylimit + "',";
        dArray += "'schoollogourl': '" + logourl + "',";
        dArray += "'schooldescription': '" + escape(descrcontent) + "',";
        dArray += "'bactive': '" + bactive + "',";
        dArray += "'bmatch': '" + bmatch + "',";
        dArray += "'callcentermonthlyallocation': '" + CallCenterMonthlyAllocation + "',";
        dArray += "'callcenterdailyallocation': '" + CallCenterDailyAllocation + "'";
        dArray += "}";

        doAjax('SaveForm', dArray, true, function (result) {
            //success
            $().toastmessage('showSuccessToast', result.d);
            LoadFormDropdown($("*[id$='hdnSchoolCampaignID']").val());
            $("*[id$='ddlSchoolLocations'] option:selected").text(formname);
        },
        function (result) {
            //error
            $().toastmessage('showErrorToast', result);
        });

        SaveMapping();
    }
    </script>
    <script type="text/javascript">
    //grid stuff
        //fields
        function getFields() {
            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            $("#fieldstable").setGridWidth($(window).width());

            $("#fieldstable").jqGrid({
                datatype: "local",
                jsonReader: {
                    repeatitems: false,
                    id: "id"
                },
                height: 300,
                autowidth: true,
                loadtext: "Loading...",
                colNames: ['Fld ID', 'SchoolCampaignID', 'SchoolFormID', 'Field Label', 'Field Name', 'Notes', 'Required', 'Type'],
                colModel: [
                    { name: 'FieldsObjectID', width: 50, align: 'center', hidden: true, sortable: false, editable: true, key: true, editoptions: { readonly: 'readonly'} },
                    { name: 'SchoolCampaignID', width: 10, hidden: true, sortable: false, editable: true, editoptions: { readonly: 'readonly' }, editrules: { edithidden: false} },
                    { name: 'SchoolFormID', width: 10, hidden: true, sortable: false, editable: true, editoptions: { readonly: 'readonly' }, editrules: { edithidden: false} },
                    { name: 'FieldLabel', width: 185, align: 'left', sortable: true, sorttype: 'text', editable: true, editrules: { required: true }, edittype: 'text', editoptions: { size: 30} },
                    { name: 'FieldName', width: 185, align: 'left', sortable: true, hidden: false, editable: true, editrules: { required: true, edithidden: true }, edittype: 'text', editoptions: { size: 30} },
                    { name: 'Notes', width: 200, sortable: false, hidden: true, editable: true, edittype: 'textarea', editoptions: { rows: '5', cols: '50' }, editrules: { edithidden: true} },
                    { name: 'Required', width: 75, sortable: false, align: 'center', editable: true, edittype: 'checkbox', editoptions: { value: '1:0' }, formatter: "checkbox", formatoptions: { disabled: true} },
                    { name: 'Type', width: 110, align: 'left', sortable: true, editable: true, editrules: { required: true }, edittype: 'select', editoptions: { value: 'DropDown:DropDown;Hidden:Hidden;Label:Label;PhoneNumber:PhoneNumber;Text:Text;YesCheckMark:YesCheckMark'} }
                ],
                imgpath: '<%= ResolveClientUrl("~/jquery/jqgrid/images") %>',
                caption: "Double click row to edit",
                editurl: "../handlers/gridDatahandler.ashx?t=e&d=field&scid=" + scid + '&sfid=' + fdid,
                emptyrecords: "No fields.",
                modal: true,
                pager: '#fieldstablepager',
                pgbuttons: true,
                zIndex: 1010,
                ondblClickRow: function (rowid, iRow, iCol, e) {
                    if (rowid && rowid !== lastFieldSel) {
                        jQuery(this).restoreRow(lastFieldSel);
                        lastFieldSel = rowid;
                    }
                    //form popup edit
                    jQuery(this).jqGrid('editGridRow', rowid, {
                        height: 300,
                        width: 380,
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        editData: { SchoolFormID: fdid, SchoolCampaignID: scid }
                    });
                }
                }).navGrid('#fieldstablepager',{
                    view: false,
                    del: true,
                    search: true,
                    edittitle: "Edit selected field",
                    addtitle: "Add new field",
                    deltitle: "Delete selected field",
                    viewtitle: "View selected field",
                    delfunc: function (row_id) {
                        var sr = jQuery("#fieldstable").getGridParam('selrow');
                        rowdata = jQuery("#fieldstable").getRowData(sr);
                        var foid = rowdata.FieldsObjectID;
                        jQuery("#fieldstable").jqGrid('delGridRow', row_id, {
                            reloadAfterSubmit: false,
                            modal: true,
                            closeAfterEdit: true,
                            closeAfterAdd: true,
                            clearAfterAdd: true,
                            zIndex: 1010,
                            delData: { FieldsObjectID: foid }
                        });
                    }
                });

                var dArray = "{'schoolformid': '" + fdid + "'}";
                getGridTableData(null, 'fieldstable', dArray, '../service/cmService.asmx/GetPostingFields', 'FieldsObjectID');
                                
                var gwidth = $(window).width();
                $("#fieldstable").setGridWidth(gwidth-140, true);

        }

        function getFieldItems() {
            var flditemid = '';
            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            $("#fielditemstable").setGridWidth($(window).width());

            $("#fielditemstable").jqGrid({
                datatype: "local",
                jsonReader: {
                    repeatitems: false,
                    id: "id"
                },
                height: 300,
                autowidth: true,
                colNames: ['FieldsItemID', 'Field Name', 'Name', 'Value'],
                colModel: [
                    { name: 'FieldsItemID', index: 'FieldsItemID', width: 20, hidden: true, align: 'center', sortable: false, editable: true, key: true, editoptions: { readonly: true} },
                    { name: 'FieldName', index: 'FieldName', align: 'left', sortable: true, hidden: false, editable: true, editrules: { required: true }, edittype: 'text' },
                    { name: 'AcceptedName', index: 'AcceptedName', width: 250, sortable: true, hidden: false, editable: true, edittype: 'text', editrules: { required: true} },
                    { name: 'AcceptedValue', index: 'AcceptedValue', width: 160, align: 'left', sortable: true, editable: true, edittype: 'text', editrules: { required: true} }
                ],
                imgpath: '<%= ResolveClientUrl("~/jquery/jqgrid/images") %>',
                caption: "Double click row to edit",
                editurl: "../handlers/gridDatahandler.ashx?t=e&d=fielditem&scid=" + scid + '&sfid=' + fdid,
                emptyrecords: "No fields.",
                modal: true,
                pager: '#fielditemstablepager',
                pgbuttons: true,
                zIndex: 1010,
                ondblClickRow: function (rowid, iRow, iCol, e) {
                    if (rowid && rowid !== lastFieldItemSel) {
                        jQuery(this).restoreRow(lastFieldItemSel);
                        lastFieldItemSel = rowid;
                    }
                    //form popup edit
                    jQuery(this).jqGrid('editGridRow', "new", {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010
                    });
                    jQuery(this).jqGrid('editGridRow', rowid, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        editData: { SchoolFormID: fdid, SchoolCampaignID: scid }
                    })
                },
                grouping: false,
                groupingView: {
                    groupField: ['FieldName'],
                    groupColumnShow: [true],
                    groupText: ['<b style="text-transform:uppercase;">{0}</b>'],
                    groupCollapse: true,
                    groupOrder: ['asc'],
                    groupSummary: [false],
                    groupDataSorted: true
                }
            }).navGrid('#fielditemstablepager', {
                view: false,
                del: true,
                search: true,
                edittitle: "Edit selected field item",
                addtitle: "Add new field item", 
                deltitle: "Delete selected field item" ,
                viewtitle: "View selected field item",
                delfunc: function (row_id) {
                    var sr = jQuery("#fielditemstable").getGridParam('selrow');
                    rowdata = jQuery("#fielditemstable").getRowData(sr);
                    var fldid = rowdata.FieldsItemID;
                    jQuery("#fielditemstable").jqGrid('delGridRow', row_id, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        delData: { FieldsItemID: fldid }
                    });

                }
            });

            var dArray = "{'schoolformid': '" + fdid + "'}";
            getGridTableData(null, 'fielditemstable', dArray, '../service/cmService.asmx/GetFieldItems','FieldName');

           

            var gwidth = $(window).width();
            $("#fielditemstable").setGridWidth(gwidth - 140, true);
        }
        //rules
        function getRules() {

            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            $("#rulestable").setGridWidth($(window).width());
            $("#rulestable").jqGrid({
                datatype: "local",
                jsonReader: {
                    repeatitems: false,
                    id: "validationruleid"
                },
                height: 300,
                autowidth: false,
                shrinkToFit: true,
                caption: "Double click row to edit",
                colNames: ['Rule ID', 'SchoolCampaignID', 'Rule', 'Field Name', 'ParamName', 'ParamValue'],
                colModel: [
                    { name: 'ValidationRuleID', width: 50, hidden: true, align: 'center', sortable: false, editable: true, key: true, editoptions: { disabled: 'disabled'} },
                    { name: 'SchoolCampaignID', width: 10, sortable: true, editable: true, hidden: true, editoptions: { disabled: 'disabled'} },
                    { name: 'Rule', width: 150, sortable: true, editable: true, editrules: { required: true }, edittype: 'select', editoptions: { value: 'DataType:DataType;GradYear:GradYear;RegularExpression:RegularExpression;StateZip:StateZip'} },
                    { name: 'FieldName', width: 150, sortable: true, editable: true, editrules: { required: true }, edittype: 'text', editoptions: { size: 30} },
                    { name: 'ParamName', width: 200, sortable: false, editable: true, edittype: 'text', hidden: true, editrules: { required: true, edithidden: true }, editoptions: { size: 30} },
                    { name: 'ParamValue', width: 250, sortable: false, editable: true, edittype: 'textarea', editoptions: { rows: '5', cols: '50'} }
                ],
                editurl: "../handlers/gridDatahandler.ashx?t=e&d=rule&scid=" + scid + '&sfid=' + fdid,
                modal: false,
                pager: '#rulestablepager',
                pgbuttons: true,
                zIndex: 1010,
                ondblClickRow: function (rowid, iRow, iCol, e) {
                    if (rowid && rowid !== lastFieldSel) {
                        jQuery(this).restoreRow(lastFieldSel);
                        lastFieldSel = rowid;
                    }
                    //form popup edit
                    jQuery(this).jqGrid('editGridRow', rowid, {
                        height: 300,
                        width: 380,
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        editData: { SchoolFormID: fdid, SchoolCampaignID: scid }
                    });
                }
            }).navGrid('#rulestablepager', {
                view: false,
                del: true,
                search: true,
                edittitle: "Edit selected field rule",
                addtitle: "Add new field rule",
                deltitle: "Delete selected field rule",
                viewtitle: "View selected field rule",
                delfunc: function (row_id) {
                    var sr = jQuery("#rulestable").getGridParam('selrow');
                    rowdata = jQuery("#rulestable").getRowData(sr);
                    var rid = rowdata.ValidationRuleID;
                    jQuery("#rulestable").jqGrid('delGridRow', row_id, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        delData: { ValidationRuleID: rid }
                    });
                }
            });

            var dArray = "{'schoolformid': '" + fdid + "'}";
            getGridTableData(null, 'rulestable', dArray, '../service/cmService.asmx/GetPostingRules','FieldName');

            var gwidth = $(window).width();
            $("#rulestable").setGridWidth(gwidth - 140, true);
        }

        //locations
        function getLocations() {
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            var lcid = '-1';
            $("#locationstable").setGridWidth($(window).width());
            $("#locationstable").jqGrid({
                datatype: "local",
                height: 250,
                autowidth: true,
                shrinkToFit: true,
                caption: "Double click row to edit",
                colNames: ['Loc ID', 'SchoolCampaignID', 'Active', 'Location Name', 'LocationCurriculumID', 'Zipcode Count', 'Actions'],
                colModel: [
                    { name: 'LocationID', width: 75, hidden: false, align: 'center', sortable: false, editable: true, key: true, editoptions: { size: 10, maxlength: 15 }, editrules: { integer: true} },
                    { name: 'SchoolCampaignID', width: 10, hidden: true, align: 'center', sortable: false, editable: true, key: true, editoptions: { disabled: 'disabled'} },
                    { name: 'Active', width: 60, sortable: true, align: 'center', editable: true, editrules: { required: true }, edittype: 'checkbox', editoptions: { size: 30, value: "True:False" }, formatter: 'checkbox' },
                    { name: 'LocationName', width: 250, sortable: true, align: 'left', editable: true, editrules: { required: true }, edittype: 'text', editoptions: { size: 30} },
                    { name: 'LocationCurriculumID', width: 150, hidden: true, sortable: true, editable: true, edittype: 'text', editrules: { edithidden: false} },
                    { name: 'ZipcodeCount', width: 100, sortable: true, editable: false, hidden: false, align: 'center' },
                    { name: 'Actions', width: 60, align: 'center', formatter: formatOperations }
                ],
                editurl: "../handlers/gridDatahandler.ashx?t=e&d=location&scid=" + scid + '&sfid=' + fdid,
                modal: false,
                pager: '#locationstablepager',
                pgbuttons: true,
                zIndex: 1010,
                ondblClickRow: function (rowid, iRow, iCol, e) {
                    if (rowid && rowid !== lastFieldSel) {
                        jQuery(this).restoreRow(lastFieldSel);
                        lastFieldSel = rowid;
                    }
                    var gr = $("#locationstable").jqGrid('getGridParam', 'selrow');
                    if (gr != null) {
                        lcid = $("#locationstable").jqGrid('getCell', gr, 'LocationCurriculumID');
                    }
                    //form popup edit
                    jQuery(this).jqGrid('editGridRow', rowid, {
                        height: 150,
                        width: 380,
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        editData: { SchoolFormID: fdid, SchoolCampaignID: scid, LocationCurriculumID: lcid }
                    });
                }
            }).navGrid('#locationstablepager', {
                view: false,
                del: true,
                search: true,
                edittitle: "Edit selected location",
                addtitle: "Add new location",
                deltitle: "Delete selected location",
                viewtitle: "View selected location",
                delfunc: function (row_id) {
                    var sr = jQuery("#locationstable").getGridParam('selrow');
                    rowdata = jQuery("#locationstable").getRowData(sr);
                    var lcid = rowdata.LocationCurriculumID;
                    jQuery("#locationstable").jqGrid('delGridRow', row_id, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        delData: { LocationCurriculumID: lcid }
                    });
                }
            });

            var fdid = $("*[id$='ddlSchoolLocations']").val();
            var dArray = "{'schoolformid': '" + fdid + "'}";
            getGridTableData(null, 'locationstable', dArray, '../service/cmService.asmx/GetPostingLocations','LocationName');

            var gwidth = $(window).width();
            $("#locationstable").setGridWidth(gwidth - 140, true);
        }

        function getLocationCurriculumItems() {
            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            $("#loccurtable").setGridWidth($(window).width());
            $("#loccurtable").jqGrid({
                datatype: "local",
                jsonReader: {
                    repeatitems: false,
                    id: "id"
                },
                height: 300,
                autowidth: true,
                colNames: ['LocationCurriculumID', 'LocationCurriculumItemID','LocationID', 'ItemName', 'ItemValue', 'Outcome'],
                colModel: [
                    { name: 'LocationCurriculumID', index: 'LocationCurriculumID', width: 20, hidden: true, align: 'center', sortable: false, editable: true, editoptions: { readonly: true} },
                    { name: 'LocationCurriculumItemID', index: 'LocationCurriculumItemID', width: 20, hidden: true, align: 'center', sortable: false, editable: true, key: true, editoptions: { readonly: true} },
                    { name: 'LocationID', index: 'LocationID', width: 75, align: 'center', sortable: true, hidden: false, editable: true, editrules: { required: true }, edittype: 'text' },
                    { name: 'ItemName', index: 'ItemName', width: 270, align: 'left', sortable: true, hidden: false, editable: true, editrules: { required: true }, edittype: 'text' },
                    { name: 'ItemValue', index: 'ItemValue', width: 100, sortable: true, hidden: false, editable: true, edittype: 'text', editrules: { required: true} },
                    { name: 'Outcome', index: 'Outcome', width: 120, align: 'left', sortable: true, editable: true, edittype: 'text', editrules: { required: true} }
                ],
                imgpath: '<%= ResolveClientUrl("~/jquery/jqgrid/images") %>',
                caption: "Double click row to edit",
                editurl: "../handlers/gridDatahandler.ashx?t=e&d=locationcurriculumitemid&scid=" + scid + '&sfid=' + fdid,
                emptyrecords: "No fields.",
                loadonce: false,
                modal: true,
                pager: '#loccurtablepager',
                pgbuttons: true,
                zIndex: 1010,
                ondblClickRow: function (rowid, iRow, iCol, e) {
                    if (rowid && rowid !== lastFieldItemSel) {
                        jQuery(this).restoreRow(lastFieldItemSel);
                        lastFieldItemSel = rowid;
                    }
                    var sr = jQuery("#loccurtable").getGridParam('selrow');
                    rowdata = jQuery("#loccurtable").getRowData(sr);
                    var lcid = rowdata.LocationCurriculumID;
                    var lciid = rowdata.LocationCurriculumItemID;
                    jQuery(this).jqGrid('editGridRow', rowid, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        editData: { SchoolFormID: fdid, SchoolCampaignID: scid, LocationCurriculumID: lcid }
                    })
                }
            }).navGrid('#loccurtablepager', {
                view: false,
                del: true,
                search: true,
                edittitle: "Edit selected location curriculum",
                addtitle: "Add new location curriculum",
                deltitle: "Delete selected location curriculum",
                viewtitle: "View selected location curriculum",
                delfunc: function (row_id) {
                    var sr = jQuery("#loccurtable").getGridParam('selrow');
                    rowdata = jQuery("#loccurtable").getRowData(sr);
                    var lciid = rowdata.LocationCurriculumItemID;
                    jQuery("#loccurtable").jqGrid('delGridRow', row_id, {
                        reloadAfterSubmit: false,
                        modal: true,
                        closeAfterEdit: true,
                        closeAfterAdd: true,
                        clearAfterAdd: true,
                        zIndex: 1010,
                        delData: { locationcurriculumitemid: lciid }
                    });
                }
            });

            var dArray = "{'schoolformid': '" + fdid + "'}";
            getGridTableData(null, 'loccurtable', dArray, '../service/cmService.asmx/GetLocationCurriculumItems','ItemName');

            var gwidth = $(window).width();
            $("#loccurtable").setGridWidth(gwidth - 140, true);

        }
        function formatOperations(cellvalue, options, rowObject) {
            var btn = '<small><a title="Add Zip codes to location" onclick="return LoadZipcodeFile(' + rowObject.LocationID + ');" class="jqEditButton ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only"><SPAN class="ui-button-icon-primary ui-icon ui-icon-plus"></SPAN><SPAN class=ui-button-text>Add</SPAN></a>';
            btn += '<A title="Delete Zip codes for location" onclick="return DeleteZipcodeFile(' + rowObject.LocationID + ');" class="delete jqEditButton ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only"><SPAN class="ui-button-icon-primary ui-icon ui-icon-trash"></SPAN><SPAN class=ui-button-text>Delete</SPAN></A></small>'

            return btn
        }

        function LoadZipcodeFile(locid) {
            showUploader('zipaccept', locid);
            $("#dialog-upload").dialog("open");
            return false;
        }
        function DeleteZipcodeFile(locid) {
            if (confirm('Are you sure you want to delete all zipcodes for location?')) {

                var dArray = "{'locationid': '" + locid + "'}";
                doAjax('DeleteZipcodes', dArray, true, function (result) {
                    $().toastmessage('showSuccessToast', result.d);
                    $("#locationstable").trigger("reloadGrid");
                },
                function (result) {
                    $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
                });
            }
        }
    </script>
    <script type="text/javascript">
        //upload stuff
        function showUploader(upType, uniqueid) {
            $("#uploader").pluploadQueue({
                // General settings,silverlight,browserplus,html5gears,        
                runtimes: 'gears,flash,silverlight,browserplus,html5',
                url: '../handlers/FileUploaderHandler.ashx',
                max_file_size: '15mb',
                unique_names: false,
                multi_selection: false,
                // Specify what files to browse for
                filters: [{
                    title: "Posting Instructions",
                    extensions: "xml"
                }, {
                    title: "Accepted Zipcodes",
                    extensions: "CSV"
                }],
                // Flash settings        
                flash_swf_url: '../jquery/plupload/plupload.flash.swf',
                // Silverlight settings        
                silverlight_xap_url: '../jquery/plupload/plupload.silverlight.xap',
                // PreInit events, bound before any internal events
                preinit: {
                    UploadFile: function (up, file) {
                        // You can override settings before the file is uploaded
                        up.settings.url = '../handlers/FileUploaderHandler.ashx?type=' + upType + '&uid=' + uniqueid;
                    },
                    FileUploaded: function (Up, File, Response) {
                        if ((Up.total.uploaded + 1) == Up.files.length) {
                            $().toastmessage('showSuccessToast', 'Upload Successful!');
                            $("#fieldstable").trigger("reloadGrid");
                            $("#rulestable").trigger("reloadGrid");
                            $("#locationstable").trigger("reloadGrid");
                            CloseUpload();
                        }
                    }
                },
                init: {
                    Error: function (up, args) {
                        // Called when a error has occured
                        $().toastmessage('showErrorToast', args);
                    },
                    FilesAdded: function (up, files) {
                        plupload.each(files, function (file) {
                            if (up.files.length > 1) {
                                up.removeFile(file);
                                alert('You can upload 1 posting file at a time, sorry.');
                            }
                        });
                        if (up.files.length >= 1) {
                            $('#pickfiles').hide('slow');
                        }
                    },
                    FilesRemoved: function (up, files) {
                        if (up.files.length < 1) {
                            $('#pickfiles').fadeIn('slow');
                        }
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
                            if (uploader.total.uploaded == uploader.files.length) {
                                $('form').submit();
                            }
                        });
                        uploader.start();
                    } else {
                        alert('You must at least upload one file.');
                    }
                    e.preventDefault();
                }
            });
        }

        function ShowUploadDocument() {
            var scid = $("*[id$='hdnSchoolCampaignID']").val();
            showUploader('schoolcampaign', scid);
            $("#dialog-upload").data('schoolcampaignid', scid).dialog("open");
            return false;
        }

        function CloseUpload() {
            LoadFormDropdown($("*[id$='hdnSchoolCampaignID']").val());
            $("#dialog-upload").dialog("close");
        }
    
        //testing
        function TestForm() {
            $("#divForm").html(loadingImg);
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            if (fdid == -1) {
                $().toastmessage('showWarningToast', 'Please select a form!');
                return;
            }
            var dArray = "{'schoolformid': '" + fdid + "'}";
            doAjax('BuildSchoolForm', dArray, true, function (result) {
                //success
                $("#divForm").html(result.d);
                $("#dialog-testform").dialog("open");
            },
            function (result) {
                //error
                showStickyToast(result, 'showErrorToast')
            });
            return false;
        }
        //category mapping
        function getCategories() {
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            var dArray = "{'schoolformid': '" + fdid + "'}";

            doAjax('LoadCategoryData', dArray, true, function (result) {
                //success
                var robj = eval('(' + result.d + ')');
                BuildMapping(robj.CurriculumItems, robj.CurriculumCategories);
            },
            function (result) {
                //error
                $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
            });

        }
        function BuildMapping(items, categories) {
            $("#curriculum").html(loadingImg);

            $("#accordion").html(categories);

            $(".dropCategory").droppable({
                accept: ".dragCurriculum",
                hoverClass: "ui-state-active",
                activeClass: "ui-state-hover",
                drop: function (event, ui) {
                    var ph = $(this).find(".placeholder");
                    ph.css('display', 'block');
                    var droppedItem = ui.draggable.children();
                    $("<li style='margin-left:5px;' class='dragCurriculum' type='circle' id='" + droppedItem.context.id + "'></li>").text(ui.draggable.text()).appendTo(ph);
                    setTimeout(function () { ui.draggable.remove(); }, 1); // yes, even 1ms is enough
                }
            });
            $("#accordion").accordion("destroy");
            $("#accordion").accordion({
                fillSpace: true,
                active: 0,
                collapsible: true,
                //                autoHeight: true,
                clearStyle: true,
                animated: 'bounceslide',
                icons: false
            });
            $("#curriculum").html(items);
            $(".dragCurriculum").draggable({ revert: "invalid", cursor: "pointer", scroll: false, stack: ".dragCurriculum", opacity: 0.7, helper: "clone" });
        }
        function SaveMapping() {
            var fdid = $("*[id$='ddlSchoolLocations']").val();
            if (fdid == -1) {
                $().toastmessage('showWarningToast', 'Please select a form!');
                return;
            }
            $('#accordion li').each(function (index, el) {
                var itmID = el.id;
                var catID = el.parentNode.parentNode.id;

                var dArray = "{";
                dArray += "'categoryid': '" + catID + "',";
                dArray += "'itemid': '" + itmID + "'";
                dArray += "}";

                doAjax('SaveCategoryData', dArray, true, function (result) {
                    if (result.d != '') {
                        //error
                        $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
                    }
                });
            });
            $().toastmessage('showSuccessToast', 'Mapping saved successfully!');
            getCategories();
            return false;
        }
        function removeMe(elem, itmid) {
            var p = elem.parentNode;
            var pp = p.parentNode;
            pp.removeChild(p);
            var dArray = "{'itemid': '" + itmid + "'}";
            doAjax('DeleteCategoryData', dArray, true, function (result) {
                //success
                getCategories(null);
            },
            function (result) {
                //error
                $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
            });
            return false;
        }
        function AddSelectedToGroup() {
            var active = $("#accordion").accordion("option", "active");
            var grpHdrText = $("#accordion h3").eq(active).text();

            var itms = [];
            $("#curriculum input[type=checkbox]").each(function () {
                if ($(this)[0].checked) {
                    var cid = $(this)[0].id;
                    cid = cid.replace('chk_', '');
                    itms.push(cid);
                }
            });

            var dArray = "{";
            dArray += "'groupName': '" + grpHdrText + "',";
            dArray += "'curriculumIDs': '" + itms.join(",") + "'";
            dArray += "}";

            doAjax('SaveCurriculumToGroup', dArray, true, function (result) {
                //success
                getCategories();
            },
            function (result) {
                //error
                $().toastmessage('showErrorToast', 'An error has occured retrieving data! - ' + result);
            });
        }
    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphDialogBody" runat="Server">
    <div id="schoolcampaigntab">
        <ul>
            <li><a href="#btab0"><span>Details</span></a></li>
            <li><a href="#btab1"><span>Posting Instructions</span></a></li>
        </ul>
        <div id="btab0">
            <div id="loaddetail">
            </div>
            <table style="width: 100%;" border="0" id="tbldetail" cellpadding="0" cellspacing="0">
                <tr valign="top">
                    <td>
                        <table style="width:100%;">
                            <tr valign="top">
                                <td>
                                    <asp:Label ID="lblName" runat="server" Text="Name:" Font-Bold="True" ForeColor="#990000" />
                                    <asp:TextBox ID="txtName" runat="server" Width="98%" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="Description:" />
                                    <asp:TextBox ID="txtDescription" runat="server" Rows="10" TextMode="MultiLine" Width="98%"
                                        ToolTip="Enter a description for school.  Only seen in CampayneMgr." />
                                </td>
                            </tr>
                            <tr valign="top">
                                <td>
                                    <asp:Label ID="Label13" runat="server" Text="Instructions:" />
                                    <asp:TextBox ID="txtInstructions" runat="server" Rows="5" TextMode="MultiLine" Width="98%"
                                        ToolTip="Enter any instructions from Plattform." />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width:50%;padding:5px;">
                        <fieldset>
                            <legend>Campaign Settings</legend>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label2" runat="server" Text="Transmission Type:" Font-Bold="True"
                                            ForeColor="#990000" />
                                    </td>
                                    <td valign="top">
                                        <asp:DropDownList ID="ddlType" runat="server" Width="150px">
                                            <asp:ListItem Text="Post" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label19" runat="server" Text="Location Type" Font-Bold="True" ForeColor="#990000" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlLocationType" runat="server" Width="150px">
                                            <asp:ListItem>Online</asp:ListItem>
                                            <asp:ListItem>Campus</asp:ListItem>
                                            <asp:ListItem Value="OnlineAndCampus">Online &amp; Campus</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label20" runat="server" Text="Active:" Font-Bold="True" ForeColor="#990000" />
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkStatus" runat="server" Font-Bold="True" ForeColor="#990000"
                                            TextAlign="Left" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label21" runat="server" Text="Enforce Acceptance Area:" Font-Bold="True"
                                            ForeColor="#990000" />
                                    </td>
                                    <td valign="middle">
                                        <asp:CheckBox ID="chkEnforceAcceptanceArea" runat="server" Font-Bold="True" ForeColor="#990000"
                                            TextAlign="Left" />
                                        <asp:Image ID="imgAcceptAll" runat="server" ImageUrl="../images/tooltip.gif" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label22" runat="server" Text="Accepts All Zip Codes:" Font-Bold="True"
                                            ForeColor="#990000" />
                                    </td>
                                    <td valign="middle">
                                        <asp:CheckBox ID="chkAcceptsAllZipCodes" runat="server" Font-Bold="True" ForeColor="#990000"
                                            TextAlign="Left" />
                                        <asp:Image ID="imgEnforce" runat="server" ImageUrl="../images/tooltip.gif" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label12" runat="server" Text="Acceptance Area Rule:" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAcceptanceAreaRule" runat="server">
                                            <asp:ListItem Text="Location and Program" />
                                            <asp:ListItem Text="LocationOnly" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label3" runat="server" Text="Payout:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPayout" runat="server" Width="150" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label9" runat="server" Text="Est Commission:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEstCommission" runat="server" Width="150" ReadOnly="true" Enabled="false" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <fieldset style="padding:5px;">
                            <legend>Statistics</legend>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label5" runat="server" Text="Submitted:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSubmitted" runat="server" Width="75" ReadOnly="true" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label6" runat="server" Text="Leads:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtLeads" runat="server" Width="75" ReadOnly="true" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label7" runat="server" Text="Rejected:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtRejected" runat="server" Width="75" ReadOnly="true" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <asp:Label ID="Label8" runat="server" Text="Credited:" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCredited" runat="server" Width="75" ReadOnly="true" Enabled="false" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
             
                <tr>
                    <td colspan="2">
                        <hr />
                        <div class="buttonHolder">
                            <button class="jqSaveButton" onclick="return SaveSchoolCampaign();" style="float: right!important;
                                font-size: 11px;">
                                Save School</button>
                            <button class="jqDeleteButton" onclick="return DeleteSchoolCampaign();" style="float: right!important;
                                font-size: 11px;">
                                Delete School</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="btab1">
            <div style="vertical-align: middle;">
                <asp:DropDownList ID="ddlSchoolLocations" runat="server" Width="100%" Style="float: right!important" />
                 <br style="clear: both;" />
            <div id="formbuttons" >
                <small>
                    <button id="btnTestForm" class="jqTestButton" onclick="return TestForm();" style="float: right!important;" type="button">
                        Test Form</button>
                    <button id="btnSaveForm" class="jqSaveButton" onclick="return SaveForm();return false;" style="float: right!important" type="button" >
                        Save Form
                    </button>
                    <button id="btnShowUpload" class="jqLoadButton" onclick="return ShowUploadDocument();"
                        style="float: right!important" type="button">
                        Add Form</button>
                    <button id="btnDeleteForm" class="jqDeleteButton" onclick="return DeleteFormDefinition();"
                        style="float: right!important" type="button">
                        Delete Form
                    </button>
                </small>
            </div>
            </div>
            <br style="clear: both;" />
            <div style="min-height: 400px">
                <div id="loadpost">
                </div>
                <div id="postingtab" style="display: none;">
                    <ul>
                        <li><a href="#ptab1"><span>General</span></a></li>
                        <li><a href="#ptab2"><span>Description</span></a></li>
                        <li><a href="#ptab3"><span>Fields</span></a></li>
                        <li><a href="#ptab4"><span>Validation Rules</span></a></li>
                        <li><a href="#ptab5"><span>Locations</span></a></li>
                        <li><a href="#ptab6"><span>Mapping</span></a></li>
                        
                    </ul>
                    <div id="ptab1">
                        <table style="width: 100%" border="0">
                            <tr valign="top">
                                <td>
                                    <asp:Label ID="Label15" runat="server" Text="Form Name:" />
                                </td>
                                <td rowspan="6" style="width:300px;">
                                    <fieldset>
                                        <legend style="font-weight: bold;">Settings</legend>
                                        <table cellpadding="0" cellspacing="0" class="ui-accordion">
                                            <tr>
                                                <td class="tdHdr">
                                                    <asp:Label ID="Label10" runat="server" Text="Active:" Font-Bold="true" />
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="chkActive" runat="server" ToolTip="If checked the school will be removed from the rotation." />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    <asp:Label ID="Label11" runat="server" Text="Match Program to Degree:" Font-Bold="true" />
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="chkMatch" runat="server" ToolTip="Enabling this ensures that a school offers a degree in the selected program by filtering the programs by degree types." />
                                                </td>
                                            </tr>
                                        </table>
                                        <hr />
                                        <fieldset>
                                            <legend style="font-weight: bold;">Online Allocations</legend>
                                            <table cellpadding="0" cellspacing="0" class="ui-accordion">
                                                <tr>
                                                    <td class="tdHdr">
                                                        <asp:Label ID="Label16" runat="server" Text="Leads Remaining:" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtLeadsRemaining" runat="server" Width="100px" ToolTip="Total leads left to sell.  When 0, this form will get removed from rotation." />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        <asp:Label ID="Label4" runat="server" Text="Daily Limit:" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtDailyLimit" runat="server" Width="100px" ToolTip="Daily limit of leads to sell, when reached the school will get removed from rotation for the day." />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                        <fieldset>
                                            <legend style="font-weight: bold;">Call Center Allocations</legend>
                                            <table cellpadding="0" cellspacing="0" class="ui-accordion">
                                                <tr>
                                                    <td class="tdHdr">
                                                        <asp:Label ID="Label18" runat="server" Text="Monthly Allocation:" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCallCtrMonthly" runat="server" Width="100px" ToolTip="" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdHdr">
                                                        <asp:Label ID="Label23" runat="server" Text="Daily Allocation:" />
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCallCtrDaily" runat="server" Width="100px" ToolTip="Daily limit of leads to sell, when reached the school will get removed from rotation for the day." />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </fieldset>
                                 
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtFormName" runat="server" Width="98%" ToolTip="If left as default the school name will be used when displaying the form." />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">
                                    <asp:Label ID="Label14" runat="server" Text="Post URL:" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtPostUrl" runat="server" Width="98%" Rows="2" TextMode="MultiLine"
                                        ToolTip="URL to post data. ** DO NOT END WITH ? **" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">
                                    <asp:Label ID="Label17" runat="server" Text="Logo URL:" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtLogoUrl" runat="server" Width="98%" Rows="2" TextMode="MultiLine"
                                        ToolTip="URL to school logo to use in tab headers" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" class="ui-accordion">
                                        <tr valign="top">
                                            <td style="padding: 5px;">
                                                &nbsp;</td>
                                            <td style="padding: 5px;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px;">
                                                
                                            </td>
                                            <td style="padding: 5px;">
                                                
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <div id="ptab2">
                        <textarea name="divDescrContent" cols="1" class="editor" rows="5" id="divDescrContent"></textarea>
                    </div>
                    <div id="ptab3">
                        <div style="text-align: center;">
                            <div id="fieldstab">
                                <ul>
                                    <li><a href="#fldtab1"><span>Fields Info</span></a></li>
                                    <li><a href="#fldtab2"><span>Field Items</span></a></li>
                                </ul>
                                <div id="fldtab1">
                                <div style="text-align: center;">
                                    <table id="fieldstable" cellpadding="0" cellspacing="0">
                                    </table>
                                    <div id="fieldstablepager"></div> 
                                    
                                    </div>
                                </div>
                                <div id="fldtab2">
                                    <div style="text-align: center;">
                                        <table id="fielditemstable" cellpadding="0" cellspacing="0">
                                        </table>
                                        <div id="fielditemstablepager">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            
                        </div>
                    </div>
                    <div id="ptab4">
                        <div style="text-align: center;">
                            <table id="rulestable" cellpadding="0" cellspacing="0">
                            </table>
                            <div id="rulestablepager"></div> 
                            
                        </div>
                    </div>
                    <div id="ptab5">
                        <div style="text-align: center;">
                            <div id="loctab">
                                <ul>
                                    <li><a href="#loctab1"><span>Location Info</span></a></li>
                                    <li><a href="#loctab2"><span>Locations Curriculum</span></a></li>
                                </ul>
                                <div id="loctab1">
                                    <table id="locationstable" cellpadding="0" cellspacing="0">
                                    </table>
                                    <div id="locationstablepager"></div> 
                                    
                                </div>
                                <div id="loctab2">
                                    <table id="loccurtable" cellpadding="0" cellspacing="0">
                                    </table>
                                     <div id="loccurtablepager"></div> 
                                </div>
                            </div>

                           
                        </div>
                    </div>
                    <div id="ptab6">
                        <table style="width: 100%">
                            <tr>
                                <td class="ui-widget-header" style="width: 300px;">
                                    Curriculum Items
                                </td>
                                <td class="ui-widget-header">
                                    Categories
                                </td>
                            </tr>
                            <tr valign="top">
                                <td class="ui-widget-content" style="width: 300px; height: 300px;">
                                    <div id="Div1" style="height: 350px; overflow-y: scroll; overflow-x: hidden; position: relative;">
                                        <div id="curriculum">
                                            add curriculum
                                        </div>
                                    </div>
                                </td>
                                <td class="ui-widget-content">
                                    <div id="accordion">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <button id="btnAddSelectedCurriculum" class="jqAddButton" onclick="return AddSelectedToGroup();"
                                        style="float: right!important;">
                                        Add Selected to Category</button>
                                </td>
                            </tr>
                        </table>
                        <small></small>
                    </div>
                    
                </div>
            </div>
           
        </div>
    </div>
    <div id="dialog-upload" title="Upload Document(s)">
        <div id="uploader">
            <p>
                You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
        </div>
    </div>
    <div id="dialog-edit" title="Edit">
        <div id="divFormEdit" />
    </div>
    <div id="dialog-testform" title="Test Form">
        <div id="divForm" />
    </div>
    <asp:HiddenField ID="hdnSchoolCampaignID" runat="server" />
</asp:Content>
