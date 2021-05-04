function PreConnectCall(leadid, context) {
    $("#dvConnectCall", context).append("<a id='lnkConnectCall' href='#'></a>");
    $("#lnkConnectCall", context).button({ label: "Connect Call", icons: { primary: "ui-icon-alert"} })
                           .css('width', '100px')
                           .click(function(event) {
                               event.preventDefault();
                               ConnectLeadCall(leadid, context);
                           });
}

function ConnectLeadCall(leadid, context) {
    var callid = window.top.parent.getCurrentCall().GetCallId();
    if (callid) {
        var json = { "leadid": leadid, "callid": callid };
        $.post('FreePBX/CallHandler.ashx?action=connectleadcall',
                    JSON.stringify(json),
                        function(jd) {
                            window.top.parent.GotoURL('clients/enrollment/newenrollment2.aspx?id=' + leadid + '&cmid=' + jd.leadcallid);
                        });
    } else {
        $("#lnkConnectCall", context).button("destroy");
        $("#dvConnectCall", context).empty();
        alert('Sorry, there is no current call to connect');
    }
}

function GetCurrentCallId() {
    return window.top.parent.getCurrentCall().GetCallId();
}

function IsRecording() {
    return window.top.parent.getCallRecordState() ? 1 : 0;
}

function StartRecordingInPath(recArgs, postProcess) {
    if (GetCurrentCallId() && !IsRecording()) {
        window.top.parent.RecordCallInPath(recArgs.path, recArgs.filename);
        postProcess();
    }
}

function StopRecording(recArgs) {
    if (GetCurrentCallId() && IsRecording()) {
        var filename = window.top.parent.getCallRecordingFile();
        window.top.parent.RecordCall();
        if (recArgs.completed) {
            StoreRecording(filename,recArgs);
            return;
        }
    }
}

function StoreRecording(filename,recArgs) {
    if (filename) {
        filename = filename + '.wav';
        recArgs.filename = filename;
        $.post('FreePBX/CallHandler.ashx?action=' + recArgs.type + 'recording',
                                JSON.stringify(recArgs))
                                .done(function() { alert('Recording is Done'); })
                                .fail(function(response) { alert("An error has occurred while stopping the recording "); });
        return;
    }
}



