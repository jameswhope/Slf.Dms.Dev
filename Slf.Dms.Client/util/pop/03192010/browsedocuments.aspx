<%@ Page Language="VB" AutoEventWireup="false" CodeFile="browsedocuments.aspx.vb"
    Inherits="util_pop_browsedocuments" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Browse Documents</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" language="javascript">
        function OnFileClick(name, text) {
            return false;
            window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachments").value = window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachments").value + name + ";"
            window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachmentstext").value = window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachmentstext").value + text + ";"
            self.close();

        }
        function AttachSelected() {
            //get all check boxes whose name like chk_folder_
            //for each folder checkbox check the related files check box name like chk_file_ _
            var name = "";
            var text = "";
            var frm = document.forms[0];
            var i = 0;
            for (; i < frm.elements.length; i++) {
                if (frm.elements[i].type == "checkbox") {
                    if (frm.elements[i].id.indexOf('chk_folder_') >= 0) {
                        //if (frm.elements[i].checked) {
                        var fid = frm.elements[i].id.replace('chk_folder_', '') 
                        for (var j = 1; ; j++) {
                            if (document.getElementById("chk_file_" + fid + "_" + j) != null) {
                                if (document.getElementById("chk_file_" + fid + "_" + j).checked) {
                               //     alert(document.getElementById("chk_file_" + fid + "_" + j))
                                    var temp = document.getElementById("chk_file_" + fid + "_" + j).value.split("$")
                                    name = name + temp[0] + ";";  //document.getElementById("chk_file_" + fid + "_" + j).value + ";";
                                    text = text + temp[1] + ";";  
                                }
                            }
                            else {
                                break; 
                            }
                        } 
                        // }
                    }
                }
            }
            window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachments").value = name
            window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachmentstext").value = text  
            
            self.close();
 }

        function checkAll(fid) {
            // alert(document.getElementById("chk_file_2_3").value) 
            for (var i = 1; ; i++) {
                if (document.getElementById("chk_file_" + fid + "_" + i) != null) {
                    if (document.getElementById("chk_folder_" + fid).checked) {
                        document.getElementById("chk_file_" + fid + "_" + i).checked = true;
                    }
                    else {
                        document.getElementById("chk_file_" + fid + "_" + i).checked = false;
                    }
                } else {
                    break;
                }
            }
        }
        function OnLoad() {
            if (document.getElementById('<%=hdnDocument.ClientID %>').value.length > 0) {
                window.close();
            }

            if (document.body.offsetWidth < 594 || document.body.offsetHeight < 423) {
                window.resizeTo(600, 500);
            }
        }
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; overflow: auto;" onload="javascript:OnLoad();">
    <form id="Form1" runat="server" action="">
    <table style="width: 100%; height: 100%;">
    <tr>
            <td align="center" id="tdUpDir" runat="server">
                <a href="#" class="lnk" onclick="javascript:return AttachSelected()">Attach Selected</a>
            </td>
        </tr>
        <tr>
            <td>
                <table style="font-family: tahoma; font-size: 11px; width: 100%; background-color: #d0d0d0;">
                    <tr>
                        <td style="width: 20px;" align="center">
                            <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                        </td>
                        <td style="width: 11px;">
                            &nbsp;
                        </td>
                        <td align="left" style="width: 260px;">
                            Document Name
                        </td>
                        <td align="left" style="width: 120px;">
                            Received
                        </td>
                        <td align="left" style="width: 120px;">
                            Created
                        </td>
                        <td align="left">
                            Created By
                        </td>
                        <td style="width: 20px;" align="right">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="width: 100%; vertical-align: top;">
            <td colspan="2" style="width: 100%;">
                <asp:TreeView ID="trvFiles" ExpandDepth="FullyExpand" ShowLines="false" Font-Names="Tahoma"
                    Font-Size="11px" ForeColor="#000000" Width="100%" ShowExpandCollapse="true" CollapseImageUrl="~/images/16x16_empty.png"
                    ExpandImageUrl="~/images/16x16_empty.png" NodeIndent="0" runat="server">
                    <NodeStyle Width="100%" />
                    <HoverNodeStyle BackColor="#d1d1d1" />
                </asp:TreeView>
            </td>
        </tr>
        <tr>
            <td align="center" id="tdDir" runat="server">
                <a href="#" class="lnk" onclick="javascript:return AttachSelected()">Attach Selected</a>
            </td>
        </tr>
        <tr>
            <td id="tdNoDir" style="font-weight: bold; color: #A03535;" runat="server">
                This client does not have a directory!
            </td>
        </tr>
    </table>
    <input id="hdnDocument" type="hidden" runat="server" />
    <asp:LinkButton ID="lnkDocSelected" runat="server" />
    </form>
    <script>
        window.onload = function() {
        var selecteditems = window.opener.document.getElementById("ctl00_ctl00_cphBody_cphBody_txtAttachments").value
            //   alert(selecteditems)
            var formcontrols = document.getElementsByTagName("input");
            for (var i = 0; i < formcontrols.length; i++) {
                if (formcontrols[i].type == "checkbox") {
                    if (formcontrols[i].getAttribute("value") != "on") {

                        var pdffilename = formcontrols[i].getAttribute("value");
                        var pdffileindex = pdffilename.lastIndexOf("/")
                        pdffilename = pdffilename.substring(pdffileindex + 1)//.replace("$", "")
                        //  alert(selecteditems.indexOf(pdffilename))
                        pdffilename = pdffilename.substring(0, pdffilename.lastIndexOf("$"))
                        if (selecteditems.indexOf(pdffilename) > -1) {
                            formcontrols[i].checked = true
                        }
                    }
                }
            }
        }   
    </script>
</body>
</html>
