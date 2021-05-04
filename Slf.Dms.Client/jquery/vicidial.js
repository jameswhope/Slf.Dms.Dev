function MakeLeadOutboundCall(leadid, phonenumber) {
    if (leadid < 1) leadid = '';
    //var json = { "phone": phonenumber, "leadid": leadid };
    var json = { "phone": "7603730989", "leadid": leadid };
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=leadmanualdial',
                            JSON.stringify(json),
                            function(jd) {
                                window.top.parent.innerappManualDial(jd.phone, jd.leadid, jd.sourceid, jd.callerid, 1);
                            });
}


function ValidateConnectedLeadCall(leadid, sourceid, context) {
    //Vicidial
    var vicidialleadid = window.top.parent.GetCurrentViciLeadId();

    if (!vicidialleadid) return;

    var json = {};
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=getvendorleadcode&vicileadid=' + vicidialleadid,
                           JSON.stringify(json),
                           function(response) {
                               if (response == "0") {
                                   PreConnectLeadCall(vicidialleadid, leadid, sourceid, context);
                               } else {
                                   if (!window.top.parent.GetCurrentViciVendorLeadCode()) SetViciVendorLeadCode(leadid);
                               }
                           });

}

function PreConnectLeadCall(vicidialleadid, leadid, sourceid, context) {
    $("#dvConnectCall", context).append("<a id='lnkConnectCall' href='#'></a>");
    $("#lnkConnectCall", context).button({ label: "Connect Call", icons: { primary: "ui-icon-alert"} })
                               .css('width', '100px')
                               .click(function(event) {
                                   event.preventDefault();
                                   ConnectLeadCall(vicidialleadid, leadid, sourceid, context);
                               });
}

function ConnectLeadCall(vicidialleadid, leadid, sourceid, context) {
    if (leadid > 0) {
        window.top.parent.SetViciVendorLeadCode(leadid);
        var json = { "vicileadid": vicidialleadid, "leadid": leadid, "sourceid": sourceid };
        $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=connectleadcall',
            JSON.stringify(json),
            function(response) { })
            .success(function(response) {
                $("#lnkConnectCall", context).button("destroy");
                $("#dvConnectCall", context).empty();
            })
            .error(function(response) { alert("An error has occurred "); });
    }
}

function GetLeadStatusReasons(statuscode, fn) {
    var json = { "statuscode": statuscode };
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=getleadstatusreasons',
                            JSON.stringify(json),
                            function(jd) {
                                //alert(jd.statusid + ' ' + jd.reasonid + ' ' + jd.reasons);
                                if (jd.reasons.length > 0) {
                                    //Create dialog to select reason
                                    $("#dvReasons").remove();
                                    $("body").append('<div id="dvReasons" style="display:none;" />');
                                    $("#dvReasons").append('<select id="optReasons" />');
                                    $.each(jd.reasons, function(i, itm) {
                                        $("#optReasons").append($('<option />').text(itm.name).attr('value', itm.value));
                                    });
                                    $("#dvReasons").dialog({
                                        closeOnEscape: false,
                                        open: function(event, ui) { $(this).parent().children().children("a.ui-dialog-titlebar-close").remove(); },
                                        autoOpen: false,
                                        modal: true,
                                        resizable: false,
                                        title: "Select a disposition reason",
                                        buttons: {
                                            Ok: function() {
                                                var reasonid = $("#optReasons option:selected").val();
                                                fn(jd.statusid, reasonid);
                                                $(this).dialog("close");
                                            }
                                        }
                                    }).dialog("open");
                                } else {
                                    fn(jd.statusid, jd.reasonid);
                                }
                            });

}


function MakeClientOutboundCall(clientid, phonenumber) {
    //var json = { "phone": phonenumber, "clientid": clientid };
    var json = { "phone": "7603730989", "clientid": clientid };
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=clientmanualdial',
            JSON.stringify(json),
            function(jd) {
                window.top.parent.innerappManualDial(jd.phone, jd.clientid, jd.sourceid, jd.callerid, 0);
            });
}


function StartManualRecording(recArgs, postProcess) {

    window.top.parent.innerapp_SetRecordingFile(recArgs.filename);
    var startArgs = window.top.parent.innerapp_GetRecordingData();
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=startmanualrecording',
            JSON.stringify(startArgs))
            .done(function(jd) { postProcess(); })
            .fail(function(response) { alert("An error has occurred while starting the recording "); });

}

function StopManualRecording(recArgs) {
    var recData = window.top.parent.innerapp_GetRecordingData();
    var stopArgs = { "type": recArgs.type, "serverip": recData.serverip, "filename": recData.filename, "referenceid": recArgs.referenceid, "callid": recArgs.callid, "completed": recArgs.completed }
    $.getJSON(innerappsite + '/Vicidial/CallHandler.ashx?callback=?&action=stopmanualrecording',
            JSON.stringify(stopArgs))
            .done(function() {
                if (recArgs.completed == "1") {
                    alert('Recording is Done');
                }
                CleanupRecording();
            })
            .fail(function(response) {
                alert("An error has occurred while stopping the recording ");
                CleanupRecording();
            });
}

function GetCurrentCallId() {
    return window.top.parent.GetCurrentUniqueId();
}

function IsRecording() {
    var recData = window.top.parent.innerapp_GetRecordingData()
    return (recData.filename) ? 1 : 0;
}

function StartRecordingInPath(recArgs, postProcess) {
    if (GetCurrentCallId() && !IsRecording()) {
        StartManualRecording(recArgs, postProcess);
    }
}

function StopRecording(recArgs) {
    if (GetCurrentCallId() && IsRecording()) {
        StopManualRecording(recArgs);
        return;
    }
    CleanupRecording();
}

function CleanupRecording(){
    window.top.parent.innerapp_SetRecordingFile("");
}



 

 