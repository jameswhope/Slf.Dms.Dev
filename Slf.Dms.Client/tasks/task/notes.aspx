<%@ Page Language="VB" AutoEventWireup="false" CodeFile="notes.aspx.vb" Inherits="tasks_task_notes" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Note</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
</head>
<body onload="LoadNotes();SetFocus('<%= txtNote.ClientID %>');">

    <script type="text/javascript">

    function AddNote(lnk)
    {
        if (!lnk.disabled)
        {
            var txtNote = document.getElementById("<%= txtNote.ClientID %>");
            var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

            if (txtNote.value.length > 0)
            {
                if (txtNotes.value.length > 0)
                {
                    txtNotes.value += "|--$--|" + txtNote.value;
                }
                else
                {
                    txtNotes.value = txtNote.value;
                }

                ResetNotes();
            }

            txtNote.value = "";
            txtNote.focus();
        }
    }
    function ClearNotes(lnk)
    {
        if (!lnk.disabled)
        {
            document.getElementById("<%= txtNotes.ClientID %>").value = "";

            ResetNotes();
        }
    }
    function DeleteNotes(lnk)
    {
        if (!lnk.disabled)
        {
            var tblNotes = document.getElementById("<%= tblNotes.ClientID %>");
            var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

            tblNotes = tblNotes.rows[0].cells[0].childNodes[0];

            var NewValue = "";

            for (i = 1; i < tblNotes.rows.length; i++)
            {
                var txtNote = tblNotes.rows[i].cells[0].childNodes[0];
                var chkNote = tblNotes.rows[i].cells[0].childNodes[1];

                if (!chkNote.checked)
                {
                    if (NewValue.length > 0)
                    {
                        NewValue += "|--$--|" + txtNote.value;
                    }
                    else
                    {
                        NewValue = txtNote.value;
                    }
                }
            }

            txtNotes.value = NewValue;

            ResetNotes();
        }
    }
    function ResetNotes(IsResolved)
    {
        var tblNotes = document.getElementById("<%= tblNotes.ClientID %>");
        var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

        if (txtNotes.value != null && txtNotes.value.length > 0)
        {
            var Notes = txtNotes.value.split("|--$--|");

            // start table
            var NewTable = "<table style=\"width:100%;font-family:tahoma;font-size:11px;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"
                + "<tr>"
                + "<td class=\"cLEnrollApplicantHeaderItem\" style=\"width:20;\" align=\"center\"><img src=\"<%= ResolveUrl("~/images/11x11_checkall.png") %>\"/></td>"
                + "<td class=\"cLEnrollApplicantHeaderItem\">Note</td>"
                + "</tr>";

            for (i = 0; i < Notes.length; i++)
            {
                var Note = Notes[i];

                if (Note.length > 150)
                {
                    Note = Note.substring(0, 150) + "..."
                }

                var chk = "";
                
                if (IsResolved)
                {
                    chk = "<input type=\"checkbox\" disabled=\"true\"/>";
                }
                else
                {
                    chk = "<input type=\"checkbox\"/>";
                }

                // add rows to table
                NewTable += "<tr>"
                    + "<td class=\"clEnrollApplicantListItem\" style=\"width:20;background-color:rgb(255,255,234);\" align=\"center\"><input type=\"hidden\" value=\"" + Note + "\"/>" + chk + "</td>"
                    + "<td class=\"clEnrollApplicantListItem\" style=\"background-color:rgb(255,255,234);\">" + Note + "</td>"
                    + "</tr>";
            }

            // finish off table
            NewTable += "</table>";

            tblNotes.rows[0].cells[0].innerHTML = NewTable;

            tblNotes.rows[0].cells[0].style.display = "inline";
            tblNotes.rows[2].cells[0].style.display = "inline";
        }
        else
        {
            tblNotes.rows[0].cells[0].style.display = "none";
            tblNotes.rows[2].cells[0].style.display = "none";
        }
    }
    function LoadNotes()
    {
        var IsResolved = window.parent.dialogArguments.IsResolved();

        var txtNote = document.getElementById("<%= txtNote.ClientID %>");
        var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");

        var lnkAddNote = document.getElementById("<%= lnkAddNote.ClientID %>");
        var lnkClearNotes = document.getElementById("<%= lnkClearNotes.ClientID %>");
        var lnkDeleteNotes = document.getElementById("<%= lnkDeleteNotes.ClientID %>");

        txtNotes.value = window.parent.dialogArguments.GetNotes();

        ResetNotes(IsResolved);

        if (IsResolved)
        {
            txtNote.disabled = true;

            lnkAddNote.disabled = true;
            lnkClearNotes.disabled = true;
            lnkDeleteNotes.disabled = true;
        }
    }
	function SaveNotes()
	{
        var txtNotes = document.getElementById("<%= txtNotes.ClientID %>");
         <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
	}
	function CloseNotes()
	{
	    window.close(); 
	}
		</script>
		
    <form id="form1" runat="server">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding-left:10;height: 100%;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr><td class="cLEnrollHeader">Notes</td></tr>
                        <tr>
                            <td>
                                <table runat="server" id="tblNotes" style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="display: none;"></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-top:5;">
                                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="padding-right:10;width:100%;"><asp:TextBox TabIndex="1" ID="txtNote" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%" MaxLength="1000"></asp:TextBox></td>
                                                    <td nowrap><a id="lnkAddNote" TabIndex="2" runat="server" class="lnk" href="#" onclick="AddNote(this);return false;"><img style="margin-right:5;" runat="server" src="~/images/16x16_note_add.png" border="0" align="absmiddle"/>Add Note</a></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="display:none;padding-top:10;">
                                            <a id="lnkClearNotes" href="#" onclick="ClearNotes(this);return false;"  runat="server" class="lnk" style="color: rgb(0,0,159);">
                                                Clear All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="lnkDeleteNotes" runat="server" href="#" onclick="DeleteNotes(this);return false;" 
                                                    class="lnk" style="color: rgb(0,0,159);">Delete Selected</a></td>
                                    </tr>
                                </table>
                                <input runat="server" id="txtNotes" type="hidden" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="3" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Cancel and Close</a></td>
                            <td align="right"><a tabindex="4" style="color:black" class="lnk" href="javascript:;" onclick="SaveNotes();return false;">Save Notes<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                      <asp:LinkButton ID="lnkSave" runat="server" ></asp:LinkButton>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>