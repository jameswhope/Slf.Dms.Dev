<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GlobalTransfer.aspx.vb"
    Inherits="GlobalTransfer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Global Trust Transfer</title>
    <script type="text/javascript" src="jquery/jquery-1.7.2.min.js"></script>
    <script type="text/javascript">


        $(document).ready(function () {

            $('#lblPrintDocument').click(function () {
                generateGlobalPrint();
            });

            $('#lblEmailDocument').click(function () {
                generateGlobalEmail();
            });            

            $('#lblAddNote').click(function () {
                $('#tblMessage').show();
            });

            $('#lblCancelMessage').click(function () {
                $('#tblMessage').hide();
                $('#txtMessage').html("");
            });

            $('#lblSaveMessage').click(function () {
                saveNote();

            });

            $('#lblUploadDocument').click(function () {
                attachFile();
            });

            $('#lblSaveVerification').click(function () {
                VerifyClient();
            });

            $('#imgloading').hide();

        });

        function VerifyClient() {
            $('#imgloading').show();
            var clientid = $("*[id$='lblclient']").text();

            if ($("*[id$='ckVerified']").is(':checked')) {

                var dArray = "{'ClientID': '" + clientid + "'}";

                $.ajax({
                    type: "POST",
                    url: '<%= ResolveURL("services/ajaxservice.asmx/VerifyClient")%>',
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        window.location.reload();
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });            
            }            
        }

        function RowClick(PersonId) {
            $('#imgloading').show();
            var dArray = "{'PersonID': '" + PersonId + "'}";

            $.ajax({
                type: "POST",
                url: '<%= ResolveURL("services/ajaxservice.asmx/LoadClient")%>',
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    var obj = eval('(' + response.d + ')');
                    $("*[id$='lblFirstName']").text(obj[0][1]);
                    $("*[id$='lblLastName']").text(obj[1][1]);
                    $("*[id$='lblAddress']").text(obj[2][1]);
                    $("*[id$='lblCity']").text(obj[3][1]);
                    $("*[id$='lblState']").text(obj[4][1]);
                    $("*[id$='lblZipCode']").text(obj[5][1]);
                    $("*[id$='lblEmails']").text(obj[6][1]);
                    $("*[id$='lblPhones']").text(obj[7][1]);
                    $("*[id$='lblLanguage']").text(obj[8][1]);
                    $("*[id$='lblClient']").text(obj[9][1]);
                    getNotes(obj[9][1]);
                    $('#imgloading').hide();
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function setAllCookies() {
            setCookie('firstname', $("*[id$='lblFirstName']").text(), 7);
            setCookie('lastname', $("*[id$='lblLastName']").text(), 7);
            setCookie('address', $("*[id$='lblAddress']").text(), 7);
            setCookie('city', $("*[id$='lblCity']").text(), 7);
            setCookie('state', $("*[id$='lblState']").text(), 7);
            setCookie('zipcode', $("*[id$='lblZipCode']").text(), 7);
            setCookie('phone', $("*[id$='lblPhones']").text(), 7);
            setCookie('email', $("*[id$='lblEmails']").text(), 7);
            setCookie('language', $("*[id$='lblLanguage']").text(), 7);
            setCookie('clientid', $("*[id$='lblClient']").text(), 7);
        }

        function generateGlobalPrint() {
            $('#imgloading').show();
            setAllCookies();
            document.getElementById("<%=lnkPrint.ClientID() %>").click();

        }

        function generateGlobalEmail() {
            $('#imgloading').show();
            setAllCookies();
            document.getElementById("<%=lnkEmail.ClientID() %>").click();
        }

        function attachFile() {
            var hdn = '';
            showModalDialog("util/pop/holder.aspx?t=Attach File&p=attachglobaldoc.aspx&leadId=" + "<%=lblClient.Text() %>", new Array(window, hdn, "attachFileReturn"), "status:on;help:off;dialogWidth:450px;dialogHeight:150px");
        }

        function loadUser(PersonId) {
            RowClick(PersonId);
        }
        
        function saveNote() {
            saveNotes();
        }

        function saveNotes() {
            $('#imgloading').show();
            var message = $("*[id$='txtMessage']").val();
            var clientid = $("*[id$='lblclient']").text();

            var dArray = "{'Value': '" + message + "',";
            dArray += "'UserID': '1265',";
            dArray += "'ClientID': '" + client + "'}";

            $.ajax({
                type: "POST",
                url: '<%= ResolveURL("services/ajaxservice.asmx/InsertNote")%>',
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#txtMessage').html("");
                    getNotes(clientid);
                    $('#tblMessage').hide();
                    $('#imgloading').hide();
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function getNotes(clientid) {
            var dArray = "{'ClientId': '" + clientid + "'}";

            $.ajax({
                type: "POST",
                url: '<%= ResolveURL("services/ajaxservice.asmx/GetNotes")%>',
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#tblNotes').html(response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function setCookie(c_name, value, exdays) {
            var exdate = new Date();
            exdate.setDate(exdate.getDate() + exdays);
            var c_value = escape(value) + ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
            document.cookie = c_name + "=" + c_value;
        }

        function getCookie(c_name) {
            var i, x, y, ARRcookies = document.cookie.split(";");
            for (i = 0; i < ARRcookies.length; i++) {
                x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
                y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
                x = x.replace(/^\s+|\s+$/g, "");
                if (x == c_name) {
                    return unescape(y);
                }
            }
        }

    </script>
    <style type="text/css">
        body
        {
            background-color: #e6e6e6;
        }
        img
        {
            vertical-align: bottom;
            padding: 0px 5px 0px 0px;
        }
        .buttons
        {
        }
        .buttons:hover
        {
            cursor: pointer;
            background-color: #fff;
        }
        .side_row
        {
            background-color: #ffffff;
            border-top: 1px solid #999999;
        }
        .side_row:hover, .side_row_alternate:hover
        {
            background-color: #E2FFFF;
            border-top: 1px solid #999999;
            cursor: pointer;
        }
        .side_row_alternate
        {
            background-color: #f6f6f6;
            border-top: 1px solid #999999;
        }
        .headitem{background-color:rgb(220,220,220);}
        .griditem1{width:150px;}
        .griditem2{width:450px;}
        .starthidden{
            display:none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="font-family: tahoma; font-size: 11px; width: 350px; height: 600px;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                    cellspacing="0">
                    <tr>
                        <td style="background-color: #f3f3f3; padding: 5px;">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                cellspacing="0" border="0">
                                <tr>
                                    <td style="color: rgb(50,112,163);">
                                        Clients That Have Not Verified&nbsp;<span id="lblCount" runat="server"></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" runat="server" id="tdSidebar" style="background-color: rgb(214,231,243);">
                            <table style="font-size: 11px; font-family: tahoma; border: 1px solid #999999" cellspacing="0"
                                cellpadding="3" width="100%" border="0">
                                <tr style="background-color: rgb(220,220,220);">
                                    <td class="headItem">
                                        Acct #
                                    </td>
                                    <td class="headItem">
                                        First Name
                                    </td>
                                    <td class="headItem">
                                        Last Name
                                    </td>
                                    <td class="headItem">
                                        Language
                                    </td>
                                </tr>
                                <asp:Repeater ID="rpClients" runat="server">
                                    <ItemTemplate>
                                        <tr class="side_row" onclick='javascript:loadUser(<%#DataBinder.Eval(Container.DataItem, "PersonId")%>)'>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "AccountNumber")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "LastName")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "Language")%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <tr class="side_row_alternate" onclick='javascript:loadUser(<%#DataBinder.Eval(Container.DataItem, "PersonId")%>)'>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "AccountNumber")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "LastName")%>
                                            </td>
                                            <td style="padding-top: 6;" valign="top">
                                                <%#DataBinder.Eval(Container.DataItem, "Language")%>
                                            </td>
                                        </tr>
                                    </AlternatingItemTemplate>
                                </asp:Repeater>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="vertical-align: top; padding-top: 35px;">
                <table>
                <tr id="imgloading"><td><img src="images/loading.gif" alt="loading" /></td></tr>
                    <tr>
                        <td style="background-color: #d6d6d6; border-bottom: 1px solid #000000;" colspan="2"
                            width="100%">
                            <p id="lblPrintDocument" class="buttons" style="display: inline;">
                                <img src="images/16x16_printing.png" />&nbsp;Print Document&nbsp;</p>
                            |
                            <p id="lblEmailDocument" class="buttons" style="display: inline;">
                                <img src="images/16x16_email.png" />&nbsp;Send Document&nbsp;</p>
                            |
                            <p id="lblUploadDocument" class="buttons" style="display: inline;">
                                <img src="images/11x16_paperclip.png" />&nbsp;Upload Document&nbsp;</p>
                            |
                            <p id="lblAddNote" class="buttons" style="display: inline;">
                                <img src="images/16x16_add.png" />&nbsp;Add Note&nbsp;</p>
                            |
                            <p id="lblSaveVerification" class="buttons" style="display: inline;">
                                <img src="images/13x13_check_hot.png" />&nbsp;Save Verification</p>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; padding-top: 20px; padding-right: 100px; font-size: 11px; width:300px;">
                            <p>
                                First Name:
                                <asp:Label ID="lblFirstName" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                Last Name:
                                <asp:Label ID="lblLastName" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                Address:
                                <asp:Label ID="lblAddress" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                City:
                                <asp:Label ID="lblCity" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                State:
                                <asp:Label ID="lblState" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                ZipCode:
                                <asp:Label ID="lblZipCode" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                        </td>
                        <td style="vertical-align: top; padding-top: 20px; font-size: 11px; width:300px;">
                            <p>
                                Email:
                                <asp:Label ID="lblEmails" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;">No Email Provided</asp:Label></p>
                            <p>
                                Phones:
                                <asp:Label ID="lblPhones" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;">No Phone Number Provided</asp:Label></p>
                            <p>
                                Language:
                                <asp:Label ID="lblLanguage" runat="server" Style="font-size: 16px; font-weight: normal;
                                    font-variant: small-caps;"></asp:Label></p>
                            <p>
                                Verified:
                                <asp:Checkbox ID="ckVerified" runat="server"></asp:Checkbox></p>
                            <asp:Label ID="lblClient" runat="server" Text="" Visible="True" Style="font-size: 16px;
                                font-weight: normal; font-variant: small-caps; color:#e6e6e6;"></asp:Label>                            
                        </td>
                    </tr>
                </table>
                <table id="tblMessage" class="starthidden">
                    <tr id="trMessage" runat="server">
                        <td class="entrytitlecell" colspan="2" style="padding-top:20px;">
                            Message:<br />
                            <asp:TextBox runat="server" ID="txtMessage" Rows="10" TextMode="MultiLine" MaxLength="5000"
                                Columns="50" Style="width: 50em"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p id="lblSaveMessage" class="buttons" style="display: inline;">
                                <img src="images/16x16_add.png" />&nbsp;Save & Close&nbsp;</p>
                            |
                            <p id="lblCancelMessage" class="buttons" style="display: inline;">
                                <img src="images/16x16_delete.png" />&nbsp;Cancel & Close</p>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <br />
                <br />
                <table>
                    <tr>
                        <td style="background-color: #d6d6d6; border-bottom: 1px solid #000000;">
                            <asp:Label ID="Label2" runat="server"><img src="images/16x16_doc.png" />&nbsp;Notes</asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; padding-top: 20px; padding-right: 100px; font-size: 11px;">
                            <div id="tblNotes"></div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkPrint" runat="server" />
    <asp:LinkButton ID="lnkEmail" runat="server" />
    <asp:LinkButton ID="lnkNote" runat="server" />
    <asp:LinkButton ID="lnkDocsAttach" runat="server" />
    </form>
</body>
</html>
