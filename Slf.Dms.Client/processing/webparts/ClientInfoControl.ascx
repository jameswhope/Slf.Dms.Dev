<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientInfoControl.ascx.vb"
    Inherits="negotiation_webparts_ClientInfoControl" %>
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">

function OpenPhoneCalls()
{
    var url = '<%= ResolveUrl("~/util/pop/matterphonecall.aspx") %>?t=Add Phone Call&id=<%= DataclientId %>&a=m&type=3';
    window.dialogArguments = window;
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
        title: "Add Phone Call",
        dialogArguments: window,
        resizable: false,
        scrollable: false,
        height: 720, width: 700
    });   

}
function GetPhoneNote() {
    return document.getElementById("<%= txtPhoneNote.ClientID %>").value;
}

function SavePhoneNote(Value) {
    var txtPhoneNote = document.getElementById("<%= txtPhoneNote.ClientID %>");
    var lnkSaveNote = document.getElementById("<%= lnkSavePhoneNote.ClientID %>");
  
    txtPhoneNote.value = Value;

    lnkSaveNote.click();    
}
</script>
<asp:UpdatePanel ID="upClient" runat="server">
    <ContentTemplate>
        <div id="divClient" runat="server" style="margin-left:10px; margin-top:5px;" >
            <table class="entry2" cellpadding="0" cellspacing="0" width="250px">
                <tr>
                    <td align="left" colspan="2">
                        <a ID="lnkClientName" runat="server" class="lnk" style="font-family:Tahoma; font-size:12px" href="#" ></a><br />
                        <asp:Label ID="lblSettAtty" runat="server" CssClass="entry2"></asp:Label>
                        <hr />
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        <a class="lnk" href="<%=ResolveUrl("~/clients/client/finances/ach/achrule.aspx")%>?id=<%=DataclientID%>&a=a">
                        <img id="imgRule" runat="server" src="~/images/16x16_tools.png" border="0" align="absmiddle" />
                            Add ACH Rule</a>
                    </td>
                    <td>
                        <a class="lnk" href="<%=ResolveUrl("~/clients/client/finances/ach/adhocach.aspx")%>?id=<%=DataclientID%>&a=a">
                        <img id="imgACH" runat="server" src="~/images/16x16_tools.png" border="0" align="left" />
                            Add Additional ACH</a>
                    </td>
                </tr>
                <tr>
                    <td align="left" class="entryFormat">
                        <asp:Label ID="lblClientStreet" CssClass="entryFormat" runat="server" Text="" /><br />
                        <asp:Label ID="lblClientCity" CssClass="entryFormat" runat="server" Text="" />,&nbsp;
                        <asp:Label ID="stateabbreviationLabel" CssClass="entryFormat" runat="server" Text="" />
                        &nbsp;
                        <asp:Label ID="lblZipCode" CssClass="entryFormat" runat="server" Text="" /><br />
                        <asp:LinkButton ID="lnkPhone" class="lnk" runat="server" ></asp:LinkButton><asp:Label style="font-family:Tahoma; font-size:11px" ID="lblExtn" runat="server"></asp:Label> <br />   
                        SSN: <asp:Label CssClass="entryFormat" ID="SSNLabel" runat="server" Text=""></asp:Label><br />
                        DOB: <asp:Label CssClass="entryFormat" ID="lblDOB" runat="server" Text=""></asp:Label><br />
                        Age: <asp:Label CssClass="entryFormat" ID="lblClientAge" runat="server" Text=""></asp:Label><br />
                    </td>
                    <td style="vertical-align: top">
                        <asp:Image ID="Img1" ImageUrl="~/images/16x16_greenball_small.png" runat="server"
                            Style="vertical-align: middle;" />
                        <asp:Label ID="lblClientStatus" CssClass="entryFormat" runat="server" Text="" />
                    </td>
                </tr>
                <tr id="coAppRow1" runat="server">
                    <td align="left" nowrap="nowrap" colspan="2" class="entryFormat">
                        <asp:Label ID="lblCoAppHdr" CssClass="entryFormat" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Co-Applicant:"></asp:Label>
                        <a ID="lnkCoAppName" runat="server" style="font-family:Tahoma; font-size:11px" Font-Size="11pt" Font-Names="tahoma" href="#" ></a><br />                          
                        SSN:<asp:Label CssClass="entryFormat" ID="lblCoAppSSN" runat="server" Text=""></asp:Label><br />
                        Age:<asp:Label CssClass="entryFormat" ID="lblCoAppAge" runat="server" Text=""></asp:Label><br />
                        State:<asp:Label CssClass="entryFormat" ID="lblCoAppState" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <tr style="height: 65px; vertical-align: bottom;">
                    <td colspan="2">
                        <asp:Panel ID="pnlHardShip" CssClass="entryFormat" runat="server" BackColor="#E3E3F0" Height="50px" Style="padding: 3px;"
                            Width="95%">
                            <asp:Label ID="Label5" runat="server" CssClass="entryFormat" Text="Hardships:"></asp:Label>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:HiddenField runat="server" ID="txtPhoneNote" />
<asp:LinkButton runat="server" ID="lnkSavePhoneNote" />