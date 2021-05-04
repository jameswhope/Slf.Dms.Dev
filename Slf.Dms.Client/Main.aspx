<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main.aspx.vb" Inherits="Main" Async="true" ValidateRequest="False" %>
<%@ Register Src="CallControlsAst/CallControlBarAst.ascx" TagName="CallControlBarAst" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lexxware</title>
    <meta http-equiv="X-UA-Compatible" content="IE=8">
    <link href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css") %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        window.name = "freepbx";
        var APP = "LWR";
        var askCallReason = 1;
        
        function GotoURL(url) {
        
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
        
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndRedirect('~/' + url);
            } else {
                f.src = url;
            }

        }

        function GetCallReason(direction, fn) {
            $.ajax({
                type: "POST",
                url: "services/AjaxService.asmx/GetCallReasons",
                data: {},
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function(jd) {
                    if (jd.d.length > 0) {
                        //Create dialog to select reason
                        $("#dvCallReasons").remove();
                        $("body").append('<div id="dvCallReasons" style="display:none;" />');
                        var dv = $("#dvCallReasons");
                        $("#dvCallReasons").append("<div id='rdReasonList' class='centerContent'/>");
                        var dv1 = $("#dvCallReasons>div");
                        var selected;
                        if (jd.d.length > 5) {
                            dv1.append('<select id="optReasons" />').addClass("ui-select");
                            $.each(jd.d, function(i, itm) {
                                $("#optReasons").append($('<option />').text(itm.Description).attr('value', itm.CallReasonId));
                            });
                            selected = "#optReasons option:selected";
                        } else {
                            $.each(jd.d, function(i, itm) {
                                dv1.append($('<input type="radio" name="rdReasons" />').attr('value', itm.CallReasonId).attr('id', 'radio' + i));
                                dv1.append($('<label style="width:100%; margin-top: 2px;"/>').attr('for', 'radio' + i).text(itm.Description), '<br />');
                                $("#radio0").attr('checked', 'checked');
                            });
                            selected = "input[name='rdReasons']:checked";
                            $("#rdReasonList").buttonset();
                        }
                        dv.dialog({
                            closeOnEscape: false,
                            open: function(event, ui) {
                                $(this).parent().children().children("a.ui-dialog-titlebar-close").remove();
                                if (direction == 1) {
                                    //Hide the Cancel button for inbound calls
                                    $(this).siblings('.ui-dialog-buttonpane').find('button').eq(1).hide();
                                }
                            },
                            autoOpen: false,
                            modal: true,
                            resizable: false,
                            title: "Select the reason for this call",
                            zIndex: 999999,
                            buttons: {
                                Ok: function() {
                                    var reasonid = $(selected).val();
                                    fn(reasonid);
                                    $(this).dialog("close");
                                },
                                Cancel: function() { $(this).dialog("close"); }
                            }
                        }).dialog("open");
                    }
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });
        }

        function MakeOutboundCall(phonenumber) {
            var calldirection = 0;
            var fn = function(reasonid) 
                     {
                        var json = { "phone": phonenumber, "reasonid": reasonid};
                       //var json = { "phone": "7603730989" };
                        $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=manualdial") %>',
                        JSON.stringify(json),
                            function(jd) {
                                var actioncode = "CLD";
                                MakeCall_NextLine(APP + actioncode + jd.callid, jd.phone, jd.callid);
                        });
                    }
                    if (phonenumber.length > 3 && askCallReason == 1) {
                        GetCallReason(calldirection,fn);
                    }
                    else if (phonenumber.length > 0) {
                        //Internal Call. ReasonId = 0
                        fn(0);
                    }
        }

        function MakeClientOutboundCall(clientid, phonenumber) {
            var calldirection = 0;
            var fn = function(reasonid) {
                    var json = { "phone": phonenumber, "clientid": clientid, "reasonid": reasonid };
                    //var json = { "phone": "7603730989", "clientid": clientid };
                    $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=clientmanualdial") %>',
                    JSON.stringify(json),
                    function(jd) {
                        var actioncode = "CLD";
                        MakeCall_NextLine(APP + actioncode + jd.callid, jd.phone, jd.callid);
                    });
                }

                if (phonenumber.length > 3 && askCallReason == 1) {
                    GetCallReason(calldirection, fn);
                }
                else if (phonenumber.length > 0) {
                    //Internal Call. ReasonId = 0
                    fn(0);
                }
          }

          function MakeLeadOutboundCall(leadid, phonenumber) {
              var json = { "phone": phonenumber, "leadid": leadid };
              //var json = { "phone": "7603730989", "leadid": leadid };
              $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=leadmanualdial") %>',
                JSON.stringify(json),
                function(jd) {
                    var actioncode = "LLD";
                    MakeCall_NextLine(APP + actioncode + jd.leadcallid, jd.phone, jd.callid);
                    GotoURL('clients/enrollment/newenrollment2.aspx?id=' + leadid + '&cmid=' + jd.leadcallid);
                });
            }

            function ClassifyIncomingCall(callid) {
                if (askCallReason == 0) return;
                
                var calldirection = 1;
                fn = function(reasonid) {
                    var json = { "CallId": callid, "ReasonId": reasonid };
                
                    $.ajax({
                        type: "POST",
                        url: "services/AjaxService.asmx/UpdateCallReason",
                        data: JSON.stringify(json),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,
                        error: function(response) {
                            alert(response.responseText);
                        }
                    });
                };
   
                GetCallReason(calldirection,fn); 
            
            }

            function Create3WayCall(phonenumber, callerid) {
                var callid = getCurrentCall().GetCallId();
                var json = { "phone": phonenumber, "callid": callid, "callerid": callerid };
                $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=createconference") %>',
                JSON.stringify(json),
                function(jd) {
                    MakeConferenceCall(jd.conferenceid);
                });
            }      
          
        function AfterPickup(phonenumber) {
            var hdnPhone = document.getElementById('<%=hdnPhoneNumber.ClientId %>');
            var btn = document.getElementById('<%=lnkAfterPickup.ClientId %>');
            hdnPhone.value = phonenumber;
            btn.click();
        }  

        function MapCallRedirect(callid, url, redirect) {
            window.top.MapCall(callid);
            if (redirect) GotoURL(url);
        }

        function lnksignout( ) {
            var btn = document.getElementById('<%=lnkSignOut.ClientId %>');
            btn.click();
        }

        function StoreSessionVar(varname, value) {
            $.get('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=storesessionvar") %>', { "sessionvarname": varname, "sessionvarvalue": value });
        }

        function SendRecordingByEmail(callid, filename) {
            var json = { "callid": callid, "filename": filename };
            $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=sendrecordingemail") %>',
            JSON.stringify(json),
                function(jd) {
                    //alert('Email sent');
                });
            }

    </script>

    <style type="text/css">
        html, body, iframe
        {
            margin: 0;
            padding: 0;
            height: 100%;
        }
        iframe
        {
            display: block;
            width: 100%;
            border: none;
        }
        #dvcallbar
        {
            color: #fff;
            font-family: Tahoma;
            font-size: 11px;
            padding: 3px;
            margin:0;
            background-color: #C0C0C0; 
        }
        .centerContent
        {
            margin-left: auto;
            margin-right: auto;
            width: 50%;   
            }
            
        .ui-select select
        {
            width: 100%;
            margin-top: 20px; 
            padding-top: 3px;
            padding-bottom: 3px;  
            padding-left: 3px;
            padding-right: 3px;  
            border: solid 1px #a6c9e2; 
            line-height: 14px; 
            }
            
        .ui-widget select
        {
            font-size: 12px;
            }
            
       .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
            float: none;
            }

        .ui-dialog .ui-dialog-buttonpane {
            text-align: center; 
            }

        .ui-dialog .ui-dialog-buttonpane .ui-button-text
        {
            width: 40px;
            }  
            
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" /> 
            <asp:ScriptReference Path="~/jquery/json2.js"  />
            <asp:ScriptReference Path="~/jquery/freepbx.js"  />          
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>

    <div id="dvcallbar">
        <uc1:CallControlBarAst ID="CallControlBar1" runat="server" />
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:HiddenField ID="hdnPhoneNumber" runat="server" />
        <asp:LinkButton ID="lnkAfterPickup" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkSignOut" runat="server"></asp:LinkButton>
    </ContentTemplate> 
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="lnkAfterPickup" EventName="Click" /> 
    </Triggers> 
    </asp:UpdatePanel>
    </form>

    <iframe id="iframe1" runat="server" scrolling="auto" height="100%" width="100%" frameborder="0" marginwidth="0" marginheight="0">
    </iframe>
    
</body>
</html>
