<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mySignatureTyped.aspx.vb" Inherits="public_mySignatureTyped" %>

<html>
<head id="Head1" runat="server">
    <title></title>

    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=La Belle Aurore" />
    <script type="text/javascript">
        if (document.layers)
            document.captureEvents(Event.MOUSEOVER | Event.MOUSEOUT | Event.MOUSEDOWN)

        document.oncontextmenu = new Function("return false");

        if (self == top) {
            window.location.href = './';
        }
    </script>

    <style type="text/css">
        body
        {
            cursor: pointer;
            padding: 0;
            margin: 0;
            width: 100%;
            height: 100%;
            background-color: white;
            border: solid 1px #8DB6CD;
        }
        #pointer
        {
            position: absolute;
            background: #000;
            width: 3px;
            height: 3px;
            font-size: 1px;
            z-index: 32768;
        }
        .sigBox
        {
            border-bottom: solid 1px black;
            height: 100px;
            padding-left: 5px;
            padding-right: 5px;
            background-color: White;
        }
        .sigBox:hover
        {
            cursor: pointer;
        }
        #tbSignature, #tbInitial
        {
            font-family: 'La Belle Aurore', serif;
            font-size: 36px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    
    <input id="l_x" name="l_x" type="hidden" runat="server" /> <!-- -->
    <input id="l_y" name="l_y" type="hidden" runat="server" /> <!-- -->
    <input id="l_Width" name="l_Width" type="hidden" runat="server" /> <!-- Hard Coded (1)-->
    <input id="l_Color" name="l_Color" type="hidden" runat="server" /> <!-- Hard Coded (Black)-->
    <input id="l_BGColor" name="l_BGColor" type="hidden" runat="server" /> <!-- Hard Coded (White)-->
    <input id="l_File" name="l_File" type="hidden" runat="server" /> <!-- -->
    <input id="l_CanvasW" name="l_CanvasW" type="hidden" runat="server" /> <!-- -->
    <input id="l_CanvasH" name="l_CanvasH" type="hidden" runat="server" /> <!-- Hard Coded (100) -->
    <input id="l_SavePath" name="l_SavePath" type="hidden" runat="server" /> <!-- -->
    <asp:TextBox ID="tbSignature" runat="server"></asp:TextBox>
    <asp:LinkButton ID="lnkSave" runat="server"></asp:LinkButton>

    <script language="javascript" type="text/javascript">
        var IsValid = false;
        var w = 375;
        var file = "file1.gif";
        var msg = "Please type in your signature";

        if (getQueryVariable("w")) {
            w = getQueryVariable("w");
            msg = "Please type your initials";
        }
        if (getQueryVariable("file")) {
            file = getQueryVariable("file") + ".png";
        }

        document.getElementById("l_Width").value = "1";
        document.getElementById("l_Color").value = "black";
        document.getElementById("l_BGColor").value = "white";
        document.getElementById("l_File").value = file;
        document.getElementById("l_CanvasW").value = w;
        document.getElementById("l_CanvasH").value = "100";
        document.getElementById("l_SavePath").value = "";
        document.bgColor = "white";

        function hasSignature() {            
                return true;
        }

        function save() {
            var buf_x = "";
            var buf_y = "";
            var lines = 0;

            if (true) {
                IsValid = true;
                <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            }
            else {
                alert(msg);
                IsValid = false;
            }

            return IsValid;
        }

        function RefreshImage() {
            alert('refreshing..');
        }

        function getQueryVariable(variable) {
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] == variable) {
                    return pair[1];
                }
            }
        } 

    </script>

    <div id="l0">
    </div>
    <asp:LinkButton ID="lnkClearAppSig" runat="server" Text="Clear" OnClick="lnkClear_Click"
        Style="padding: 5px;" Font-Size="11px" Font-Bold="True" Font-Names="Tahoma" />
    </form>
</body>
</html>

