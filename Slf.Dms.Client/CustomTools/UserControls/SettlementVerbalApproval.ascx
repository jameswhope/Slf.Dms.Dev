<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementVerbalApproval.ascx.vb"
    Inherits="CustomTools_UserControls_SettlementVerbalApproval" %>
<style type="text/css">
    .btn
    {
        padding: 3px 3px 3px 3px;
        font-family: Verdana;
        font-size: 11px;
        border-style: solid;
        border-width: 1px;
        font-weight: normal;
        width: 60px;
        cursor: pointer;
    }
    .btn_hover
    {
        padding: 3px 3px 3px 3px;
        font-family: Verdana;
        font-size: 11px;
        border-style: solid;
        border-width: 1px;
        font-weight: bold;
        width: 60px;
        cursor: hand;
    }
    .Message
    {
        text-align: center;
        font-size: 11px;
        background-color: Yellow; 
        border: solid 1px black;
        height: 20px;
        width: 100%;
        padding: 5px 5px 5px 5px;
    }
    table
    {
        font-family: Tahoma;
        font-size: 12px;
    }
    .tableDialog
    {
        font-family: Tahoma;
        font-size: 12px;
        width: 100%;
    }
</style>

<script type="text/javascript">

    function CloseRecording(finished, popup, recid, approved) {
        var wnd;
        if (popup == 'true')
            wnd = window.dialogArguments.parent;
        else
            wnd = window.top;

        switch (finished) {
            case '1':
                wnd.CompleteCallRecording(recid);
                break;
            default:
                wnd.stopRecording();
                break;
        }

        if (popup == 'true') {
            var ret = new Object;
            ret.isApproved = recid;
            ret.RecId = approved;

            window.returnValue = finished;
            window.top.close();
        }
    }
     
</script>

<div>
    <table id="tblRec" runat="server" >
        <tr>
            <td >
                <asp:Label ID="lblMessage" runat="server" Text="" CssClass=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="center"   >
                <b>Settlement Approval Call</b>
            </td>
        </tr>
        <tr>
            <td height="20px">
            </td>
        </tr>
        <tr>
            <td id="tdContent" runat="server" align="center">
                <asp:Label ID="lblQuestion1" runat="server" Text="1-Would you like to give me your verbal authorization to settle this account?"></asp:Label>
                <br />
                <br />
                <asp:RadioButton ID="rdYes" runat="server" Text="Yes = Accept" ForeColor="#006600"
                    GroupName="rdDecision" />&nbsp; &nbsp;
                <asp:RadioButton ID="rdNo" runat="server" Text="No = Reject" ForeColor="Red" GroupName="rdDecision" />
            </td>
        </tr>
        <tr>
            <td height="20px">
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit" BackColor="#336600" BorderColor="White"
                    ForeColor="Yellow" CssClass="btn" />&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" BackColor="Red" ForeColor="White"
                    CssClass="btn" />
            </td>
        </tr>
    </table>
</div>
<asp:HiddenField ID="hdnCallId" runat="server" />
<asp:HiddenField ID="hdnReferenceType" runat="server" />
<asp:HiddenField ID="hdnRefId" runat="server" />
<asp:HiddenField ID="hdnIsPopup" runat="server" />
<asp:HiddenField ID="hdnCallResolutionId" runat="server" />
<asp:HiddenField ID="hdnSettlementId" runat="server" />
<asp:HiddenField ID="hdnLanguageId" runat="server" />
