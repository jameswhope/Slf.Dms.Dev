<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Test.aspx.vb" Inherits="CallControlsAst_Test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test</title>
    <script type="text/javascript" >
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $('#<%= btnTest.ClientId %>').click(function() {
                    ConnectLeadCall();
                }
                );
            });
        }
    
        function link3PV() {
            var json = { "clientid": "104963", "callid": "1224", "verificationid": "10171", "filename": "verif_1224_78d86ed2-0457-454d-b9f9-69de8c2829a3.wav" };
            $.post('<%= ResolveUrl("~/FreePBX/CallHandler.ashx?action=verificationrecording") %>',
                                JSON.stringify(json),
                                    function(jd) {
                                        alert('Recording is Done');
                                    });
                                }

      function VicidialMakeLeadCall() {
            var json = { "phone": "7603730989", "leadid": "1" };
            /*$.post('<%= ResolveUrl("~/Vicidial/CallHandler.ashx?action=leadmanualdial") %>',
                JSON.stringify(json),
                function(jd) {
                    alert(jd.callerid);
                });*/

            $.getJSON('<%= ResolveUrl("~/Vicidial/CallHandler.ashx?action=leadmanualdial&callback=?") %>',
                JSON.stringify(json),
                function(jd) {
                    alert(jd.callerid);
                }).error(function(data) {
                    alert(JSON.stringify(data));
                });
            }

            function ConnectLeadCall() {
                var leadid = "1";
                if (leadid > 0) {
                    var json = { "vicileadid": "1", "leadid": leadid };
                    $.getJSON('<%= ResolveUrl("~/Vicidial/CallHandler.ashx?callback=?&action=connectleadcall") %>',
            JSON.stringify(json),
            function(response) {
                alert("OK");
            })
            .success(function() {
                $("#lnkConnectCall", $(this)).button("destroy");
                $("#dvConnectCall", $(this)).empty();
            })
            .error(function() { alert("An error has occurred "); });
                }
            }

        
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" ScriptMode="Release" />
            <asp:ScriptReference Path="~/jquery/json2.js"  />
        </Scripts> 
    </ajaxToolkit:ToolkitScriptManager>
    <div>
        <asp:Button ID="btnTest" runat="server" Text="Test!" />
    </div>
    </form>
</body>
</html>
