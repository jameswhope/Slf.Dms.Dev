<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AttachSifControl.ascx.vb"
    Inherits="AttachSifControl" EnableViewState="true" %>
<style type="text/css">
    .entry
    {
        font-family: tahoma;
        font-size: 11px;
        width: 100%;
    }
    .entry2
    {
        font-family: tahoma;
        font-size: 11px;
    }
    fieldset legend
    {
        padding: 6px;
        font-weight: bold;
        font-family: Tahoma;
        font-size: 8.3pt;
    }
    .ajax__tab_default .ajax__tab_header
    {
        white-space: normal !important;
    }
    .fixedHeader th
    {
        overflow: hidden;
        position: relative;
        top: expression(this.parentNode.parentNode.parentNode.parentNode.parentNode.scrollTop-1);
        text-align: LEFT;
        table-layout: fixed;
        background-color: #3D3D3D;
        border-bottom: solid 1px #d3d3d3;
        font-weight: normal;
        color: Black;
        font-size: 11px;
        font-family: tahoma;
    }
    .fixedHeader td
    {
        font-family: tahoma;
        font-size: 8.3pt;
        text-align: LEFT;
    }
    /*CollapsiblePanel*/.collapsePanel
    {
        background-color: white;
        overflow: hidden;
    }
    .collapsePanelHeader
    {
        width: 100%;
        height: 30px;
        background-color: #4791C5;
        color: #FFF;
        vertical-align: middle;
        font-weight: bold;
    }
    .file_input_textbox
    {
        float: left;
    }
    .file_input_div
    {
        position: relative;
        width: 200px;
        height: 25px;
        overflow: hidden;
    }
    .file_input_button
    {
    }
    .file_input_hidden
    {
        font-size: 12px;
        position: absolute;
        right: 0px;
        top: 0px;
        opacity: 0;
        filter: alpha(opacity=0);
        -ms-filter: "alpha(opacity=0)";
        -khtml-opacity: 0;
        -moz-opacity: 0;
    }
    .file_input_hidden:hover
    {
        cursor: pointer;
        color: #FFFFFF;
    }
    .attachbutton
    {
        background-color: #4791C5;
        color: #3D3D3D;
        border: solid 1px #3D3D3D;
        height: 25px;
    }
    .attachbutton:hover
    {
        cursor: pointer;
        color: #FFFFFF;
    }
    /*Nice css boxes*/.info, .success, .warning, .error, .validation
    {
        border: 1px solid;
        margin: 10px 0px;
        padding: 15px 10px 15px 50px;
        background-repeat: no-repeat;
        background-position: 10px center;
    }
    .info
    {
        color: #00529B;
        background-color: #BDE5F8;
        background-image: url('../../images/info.png');
    }
    .success
    {
        color: #4F8A10;
        background-color: #DFF2BF;
        background-image: url('../../images/success.png');
    }
    .warning
    {
        color: #9F6000;
        background-color: #FEEFB3;
        background-image: url('../../images/warning.png');
    }
    .error
    {
        color: #D8000C;
        background-color: #FFBABA;
        background-image: url('../../images/error.png');
    }
    .lnk
    {
        cursor: pointer;
        color: rgb(50,112,163);
        font-family: tahoma;
        font-size: 11px;
        text-decoration: none;
    }
    .lnk:hover
    {
        text-decoration: underline;
    }
    .fakeButtonStyle
    {
        border: solid 1px #AFD4E8;
        background-color: #DFEFF7;
        color: #006699;
        cursor: pointer;
    }
    .fakeButtonStyle:hover
    {
        border: solid 1px #AFD4E8;
        background-color: #DBEDF6;
        color: #31D2FB;
        cursor: pointer;
    }
</style>

<script type="text/javascript">
    function pageLoad() {
        initDropTargets();
        initDragSources();
        var drop = new DragNDrop.ClientDropTargetBehavior($get('<%=gvClients.ClientID %>'));
    }
    function AddClientDragSource(obj, settlementInfo) {
        try { var clientdrag = new DragNDrop.ClientDragSourceBehavior($get(obj), settlementInfo); }
        catch (e) { }
    }
    function AddDragSource(obj, path) {
        var drag = new DragNDrop.DocumentDragSourceBehavior($get(obj), path);
    }
    function AddDropTarget(obj) {
        var drop = new DragNDrop.DocumentDropTargetBehavior($get(obj));
    }
    function initDragSources() {
        var imgs = document.getElementsByTagName('img');
        
        if (imgs.length != 2) {
            for (var i = 0; i < imgs.length; i++) {
                var imgID = imgs[i].id
                if (imgID != '' && imgID.indexOf('img_sif') != -1) {
                    AddDragSource(imgID, imgs[i].src);
                }
            }
        }

    }
    function initDropTargets() {

        var gv = $get('<%=gvClients.ClientID %>')
        var divs = gv.getElementsByTagName('div');
        for (var i = 0; i < divs.length; i++) {
            var dID = divs[i].id;
            if (dID != '' && dID.indexOf('divAttach') != -1) {
                AddDropTarget(dID);
            }
        }
    }
    function removeItem(obj) {
        var fld = document.getElementById(obj);
        if (fld == null) {
            fld = document.getElementById('ctl00_cphBody_AttachSif1_' + obj);
        }
        try {
            var parent = fld.parentNode;
            parent.removeChild(fld)
            CallServer('removeclientdrop' + '|' + fld.id + '|' + fld.children[1].id);
        }
        catch (e) { }

    }

    function removeImg(img) {
        alert(img.src);
    }


    function removeDoc(obj) {
        try {
            var imgs = obj.getElementsByTagName('img');
            obj.removeChild(imgs[imgs.length - 1]);
        }
        catch (e) { }

    }
    function ChangeFileName(fileName) {
        var fileTypes = ".tif,.tiff,.TIFF,.TIF".split(',');

        if (!fileName) return;

        dots = fileName.split(".")
        //get the part AFTER the LAST period.
        fileType = "." + dots[dots.length - 1];

        if (fileTypes.join(".").indexOf(fileType) != -1) {
            document.getElementById('fileName').value = fileName;
            document.getElementById('<%= divUploadError.ClientID %>').style.display = 'none';
        } else {
            document.getElementById('fileName').value = '';
        }

        return (fileTypes.join(".").indexOf(fileType) != -1) ? true : alert("Please only upload files that end in types: \n\n" + (fileTypes.join(" .")) + "\n\nPlease select a new file and try again.");

    }
    function VerifyData(dataName) {

        try {
            var lblID = dataName.id;
            if (lblID.indexOf('rbl') == -1) {
                var fldName = lblID.replace('TextBox', '')
                fldName = fldName.substring(fldName.lastIndexOf('_') + 1)
                var lbl = document.getElementById(lblID.replace('TextBox', 'Label'));
                var realValue = dataName.value.replace('$', '').replace(',', '');
                var verifyValue = lbl.innerText.replace('$', '').replace(',', '');

                if (realValue != verifyValue) {
                    dataName.style.backgroundColor = '#ffcccc';
                    dataName.style.border = 'solid 1px red';
                } else {
                    dataName.style.backgroundColor = '#98FB98';
                    dataName.style.border = 'solid 1px #228B22';
                    dataName.setAttribute('readOnly', 'readonly');
                }
            } else {
                var radio = dataName.getElementsByTagName("input");
                var label = dataName.getElementsByTagName("label");
                for (var i = 0; i < radio.length; i++) {
                    if (radio[i].checked) {
                        if (radio[i].value == 'NO') {
                            dataName.style.backgroundColor = '#ffcccc';
                            dataName.style.border = 'solid 1px red';
                        } else {
                            dataName.style.backgroundColor = '#98FB98';
                            dataName.style.border = 'solid 1px #228B22';
                        }
                    }
                }
            }
            //check other fields, if all valid show drop sif
            var bValid = true;
            var txts = dataName.parentElement.parentElement.parentElement.getElementsByTagName('input');
            var vBtnID = new String;
            
            for (var i in txts) {
                if (txts[i].value != undefined && txts[i].value != 'Verify') {
                    if (txts[i].id.indexOf('Label') == -1 && txts[i].id.indexOf('Image') == -1) {
                        var tname = txts[i].id;
                        var tval = txts[i].value;
                        tname = tname.substring(tname.lastIndexOf('_') + 1);
                        tname = tname.replace('TextBox', '');
                        switch (tname) {
                            case 'SettlementAmount': case 'SettlementDueDate': case 'CreditorAccountBalance': case 'CreditorReferenceNumber':
                                if (txts[i].readOnly == false) {
                                    bValid = false
                                }
                                break;
                            case 'CreditorAccountNumberFull':
                                break;
                            case 'CheckPayable':
//                                if (tval == '') {
//                                    bValid = false;
//                                } else {
//                                    txts[i].style.backgroundColor = '#98FB98';
//                                    txts[i].style.border = 'solid 1px #228B22';
//                                    txts[i].setAttribute('readOnly', 'readonly');
//                                }
                                break;
                            default:
                                alert(txts[i].id);
                                break;
                        }
                    }
                }
            }
            var rbls = dataName.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByTagName('table');
            for (var r in rbls) {
                if (rbls[r].id != undefined && rbls[r].id != '') {
                    var rname = rbls[r].id;
                    rname = rname.substring(rname.lastIndexOf('_') + 1);
                    if (rname == 'rblClientNameMatch' || rname == 'rblCreditorNameMatch') {
                        var rbl = document.getElementById(rbls[r].id);
                        var radio = rbl.getElementsByTagName("input");
                        var label = rbl.getElementsByTagName("label");
                        for (var i = 0; i < radio.length; i++) {
                            if (radio[i].checked) {
                                if (radio[i].value == 'NO') {
                                    bValid = false;
                                }
                            }
                        }
                    }
                }
            }

            var vtxts = dataName.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByTagName('input');
            for (var j in vtxts) {
                if (vtxts[j].value == 'Verify') {
                    vBtnID = vtxts[j].id;
                }            
            }
            if (bValid == true && vBtnID !='') {
                var b = document.getElementById(vBtnID);
                b.style.display = 'none';
                b.previousSibling.style.display = 'block';
            } else {
                //alert("Not all fields verified!");
            }

        }
        catch (e) {
            dataName.style.backgroundColor = '';
            dataName.style.border = 'solid 1px black';
            alert(e.description);
        }
    }
    function trim(stringToTrim) {
        return stringToTrim.replace(/^\s+|\s+$/g, "");
    }

</script>

<script type="text/javascript">
    function cancelClick() { }
    function ReceiveServerData(arg, context) { }
</script>

<asp:ScriptManagerProxy ID="smpAttach" runat="server">
    <Scripts>
        <asp:ScriptReference Name="PreviewScript.js" Assembly="Microsoft.Web.Preview" />
        <asp:ScriptReference Name="PreviewDragDrop.js" Assembly="Microsoft.Web.Preview" />
        <asp:ScriptReference Path="AttachSIFDragNDrop.js" />
    </Scripts>
</asp:ScriptManagerProxy>
<div id="divStatus" runat="server" style="width: 95%; display: none; padding: 25px;">
    <div style="border: solid 1px black; text-align: center; width: 60%; margin: 0 auto;
        padding: 10px;" id="divMsg" runat="server" class="success">
        <asp:PlaceHolder ID="phMsg" runat="server" />
        <asp:LinkButton ID="lnkClose" runat="server" Text="Close" Font-Names="Tahoma" Font-Size="12pt" />
    </div>
</div>
<asp:UpdatePanel ID="upAttach" runat="server">
    <ContentTemplate>
        <table style="width: 100%; display: block; height: 100%" border="0" id="tblAttach"
            runat="server">
            <tr>
                <td style="vertical-align: top; padding: 10px; width: 50%;">
                    <div id="divClientSearch" runat="server" visible="false" class="entry">
                        <asp:Panel ID="Panel2" runat="server" Height="30px" Style="width: 100%; height: 30px;
                            background-color: #4791C5; color: #FFF; vertical-align: middle; font-weight: bold;">
                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                <div style="float: left; color: White;">
                                    <asp:Label ID="lblHeader" runat="server" ForeColor="White" Font-Names="tahoma" />
                                </div>
                                <div style="float: right; vertical-align: middle;">
                                    <asp:ImageButton ID="Image1" runat="server" ImageUrl="~/images/expand.png" />
                                </div>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="Panel1" runat="server" Height="0" Style="width: 100%; background-color: white;
                            overflow: hidden;" CssClass="entry">
                            <br />
                            <table class="entry" cellpadding="0" cellspacing="0" style="height: 60px; width: 100%;
                                border-bottom: solid 1px white;">
                                <tr>
                                    <td style="padding-left: 5px; background-color: #3D3D3D; color: White; border-bottom: solid 1px white;">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="entry" Width="100%" />
                                    </td>
                                    <td align="right" style="width: 100px; padding-right: 40px; background-color: #3D3D3D;
                                        color: White; border-bottom: solid 1px white;">
                                        <asp:LinkButton ID="lnkSearch" runat="server" Text="Search" />
                                        <asp:Literal ID="litSpace" runat="server" Text=" | " />
                                        <asp:LinkButton ID="lnkClear" runat="server" Text="Clear" />
                                    </td>
                                </tr>
                            </table>
                            <div style="overflow-y:scroll; overflow-x:hidden; height:500px;">
                            <asp:GridView ID="gvClients" runat="server" AllowPaging="false" AllowSorting="false"
                                EnableSortingAndPagingCallbacks="true" AutoGenerateColumns="False" CellPadding="4"
                                DataSourceID="dsSearch" ForeColor="#333333" GridLines="none" DataKeyNames="SettlementID,ClientID,CreditorAccountID,creditorid,ClientAccountNumber"
                                PageSize="5" EnableViewState="true" CssClass="entry" 
                                HeaderStyle-BackColor="#3D3D3D" HeaderStyle-ForeColor="White" Style="width: 100%"
                                ShowHeader="true">
                                <AlternatingRowStyle BackColor="#DADAFA" />
                                <Columns>
                                    <asp:BoundField DataField="SettlementID" HeaderText="SettlementID" SortExpression="SettlementID"
                                        Visible="False" />
                                    <asp:BoundField DataField="ClientID" HeaderText="ClientID" SortExpression="ClientID"
                                        Visible="False" />
                                    <asp:BoundField DataField="CreditorAccountID" HeaderText="CreditorAccountID" SortExpression="CreditorAccountID"
                                        Visible="False" />
                                    <asp:BoundField DataField="creditorid" HeaderText="creditorid" SortExpression="creditorid"
                                        Visible="False" />
                                    <asp:BoundField DataField="ClientAccountNumber" HeaderText="SDA #" SortExpression="ClientAccountNumber"
                                        Visible="False">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" ForeColor="White" Wrap="false"
                                            Width="50" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" Width="50" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Client Name" HeaderStyle-HorizontalAlign="Left" HeaderText="Client Name"
                                        SortExpression="Client Name" Visible="False">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" ForeColor="White" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Settlement Info" HeaderStyle-HorizontalAlign="Left"
                                        SortExpression="Creditor Name">
                                        <ItemTemplate>
                                            
                                            <div class="entry2" style="padding-right: 20px; padding-left: 5px;">
                                                        <fieldset style="display: inline-block; padding: 3px;">
                                                            <legend>
                                                                <asp:Label ID="Label10" Style="font-size: 12px;" runat="server" Text='<%#String.Format("{0} ({1})", Container.DataItem("Client Name"),Container.DataItem("ClientAccountNumber"))%>' />
                                                                <asp:Literal ID="litspac" runat="server" Text=" / " />
                                                                <asp:Label ID="lblCredName" Style="font-size: 12px;" runat="server" Text='<%#String.Format("{0} #{1}", Container.DataItem("Creditor Name"),Container.DataItem("CreditorAccountNumber"))%>' />
                                                                <asp:CheckBox ID="chkOverride" runat="server" Text="Override" AutoPostBack="true"
                                                                    Style="display: none;" />
                                                            </legend>
                                                            <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblClientName" runat="server" Text="Client Name Match?" CssClass="entry2" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="lblClientName0" runat="server" Text="Sett Amt" CssClass="entry2" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="lblClientName1" runat="server" Text="Creditor Acct Bal" CssClass="entry2" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:RadioButtonList ID="rblClientNameMatch" runat="server" CssClass="entry2" onclick="VerifyData(this);"
                                                                            RepeatDirection="Horizontal">
                                                                            <asp:ListItem Text="YES" />
                                                                            <asp:ListItem Selected="True" Text="NO" />
                                                                        </asp:RadioButtonList>
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="SettlementAmountTextBox" runat="server" CssClass="entry2" onblur="VerifyData(this);"
                                                                            Style="border: solid 1px black" Text="" />
                                                                        <ajaxToolkit:FilteredTextBoxExtender ID="SettlementAmountTextBoxFilteredTextBoxExtender"
                                                                            runat="server" TargetControlID="SettlementAmountTextBox" ValidChars="$.,0123456789" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="CreditorAccountBalanceTextBox" runat="server" CssClass="entry2"
                                                                            onblur="VerifyData(this);" Style="border: solid 1px black" Text="" />
                                                                        <ajaxToolkit:FilteredTextBoxExtender ID="CreditorAccountBalanceTextBoxFilteredTextBoxExtender"
                                                                            runat="server" TargetControlID="CreditorAccountBalanceTextBox" ValidChars="$.,0123456789" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label3" runat="server" Text="Creditor Name Match?" CssClass="entry2" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="lblSettDueDate" runat="server" Text="Sett Due Date" CssClass="entry2" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="lblClientName3" runat="server" Text="Creditor Acct #" CssClass="entry2" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:RadioButtonList ID="rblCreditorNameMatch" runat="server" CssClass="entry2" RepeatDirection="Horizontal" onclick="VerifyData(this);">
                                                                            <asp:ListItem Text="YES" />
                                                                            <asp:ListItem Selected="True" Text="NO" />
                                                                        </asp:RadioButtonList>
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="SettlementDueDateTextBox" runat="server" CssClass="entry2" onblur="VerifyData(this);"
                                                                            onchange="VerifyData(this);" Style="border: solid 1px black" Text="" />
                                                                        <asp:ImageButton ID="Image1" runat="Server" AlternateText="Click to show calendar"
                                                                            ImageAlign="AbsMiddle" ImageUrl="~/images/Calendar_scheduleHS.png" />
                                                                                <ajaxToolkit:CalendarExtender ID="extDueDate" runat="server" TargetControlID="SettlementDueDateTextBox"
                                                                    PopupButtonID="image1" CssClass="MyCalendar" Format="MM/dd/yyyy" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="CreditorAccountNumberFullTextBox" runat="server" CssClass="entry2"
                                                                            onblur="VerifyData(this);" Style="border: solid 1px black" Text="" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="Label4" runat="server" Text="Check Payable To" CssClass="entry2" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="lblClientName4" runat="server" Text="Creditor Ref #" CssClass="entry2" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                    <td>
                                                                          <asp:TextBox CssClass="entry2" ID="CheckPayableTextBox" runat="server"
                                                                Text=""  Style="border: solid 1px black" />
                                                                    </td>
                                                                    <td>
                                                                        <asp:TextBox ID="CreditorReferenceNumberTextBox" runat="server" CssClass="entry2"
                                                                            onblur="VerifyData(this);" Style="border: solid 1px black" Text="" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </fieldset>
                                                        
                                                    </div>
                                            <div style="display: none;">
                                                <asp:Label CssClass="entry2" ID="SettlementAmountLabel" runat="server" Text='<%#bind("SettlementAmount","{0:C}") %>' />
                                                <asp:Label CssClass="entry2" ID="SettlementDueDateLabel" runat="server" Text='<%#bind("SettlementDueDate","{0:MM/dd/yyyy}") %>' />
                                                <asp:Label CssClass="entry2" ID="CreditorAccountBalanceLabel" runat="server" Text='<%#bind("CreditorAccountBalance","{0:C}") %>' />
                                                <asp:Label CssClass="entry2" ID="CreditorAccountNumberFullLabel" runat="server" Text='<%#bind("CreditorAccountNumberFull") %>' />
                                                <asp:Label CssClass="entry2" ID="CreditorReferenceNumberLabel" runat="server" Text='<%#bind("CreditorReferenceNumber") %>' />
                                                <asp:Label CssClass="entry2" ID="OriginalCreditorNameLabel" runat="server" Text='<%#String.Format("{0}", Container.DataItem("OriginalCreditorName"))%>' />
                                                <asp:Label CssClass="entry2" ID="CreditorNameLabel" runat="server" Text='<%#String.Format("{0}", Container.DataItem("Creditor Name"))%>' />
                                                <asp:Label CssClass="entry2" ID="CheckPayableLabel" runat="server" Text="Dont Validate" />
                                            </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" CssClass="fixedHeader" ForeColor="White" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Drop SIF Here" HeaderStyle-ForeColor="White">
                                        <ItemTemplate>
                                            <div id="divAttach" runat="server" style="display: none; width: 100px; height: 85px;
                                                overflow: auto; background-color: Gray;" onclick="removeDoc(this);" name='<%#eval("settlementid") %>'>
                                            </div>
                                            <asp:Button ID="btnVerify" runat="server" Text="Verify" CssClass="fakeButtonStyle"
                                                Style="display: none;" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" CssClass="fixedHeader" ForeColor="White" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Height="100%" />
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="text-align: center; color: #A1A1A1; width: 100%">
                                        You have no settlements waiting on SIFs!
                                    </div>
                                </EmptyDataTemplate>
                                <PagerTemplate>
                                    <table width="100%" style="background-color: #DCDCDC; height: 25px;">
                                        <tr>
                                            <td valign="middle" style="height: 20px; text-align: center;">
                                                <asp:ImageButton ID="imbFirst" runat="server" ImageUrl="~/images/16x16_results_first2.png"
                                                    CommandName="Page" CommandArgument="First" />
                                                <asp:ImageButton ID="imgPrev" runat="server" ImageUrl="~/images/16x16_results_previous2.png"
                                                    CommandName="Page" CommandArgument="Prev" />
                                                <asp:Label ID="lblPage" runat="server" Text="Page " CssClass="entry2" />
                                                <asp:DropDownList ID="ddlPage" AutoPostBack="true" CssClass="entry2" runat="server"
                                                    OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged" />
                                                <asp:Label ID="CurrentPageLabel" runat="server" Text=" of " CssClass="entry2" />
                                                <asp:ImageButton ID="imbNext" runat="server" ImageUrl="~/images/16x16_results_next2.png"
                                                    CommandName="Page" CommandArgument="Next" />
                                                <asp:ImageButton ID="imbLast" runat="server" ImageUrl="~/images/16x16_results_last2.png"
                                                    CommandName="Page" CommandArgument="Last" />
                                            </td>
                                        </tr>
                                    </table>
                                </PagerTemplate>
                                <HeaderStyle BackColor="#3D3D3D" CssClass="fixedHeader" ForeColor="White" />
                            </asp:GridView>
                            
                            <asp:SqlDataSource ID="dsSearch" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                SelectCommand="stp_NegotiationsSearchGetSettlementsWaitingOnSIF" SelectCommandType="StoredProcedure"
                                EnableCaching="false">
                                <SelectParameters>
                                    <asp:Parameter Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="SearchTerm" Type="String" DefaultValue="NULL" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            </div>
                        </asp:Panel>
                        <ajaxToolkit:CollapsiblePanelExtender ID="cpeDemo" runat="Server" TargetControlID="Panel1"
                            ExpandControlID="Panel2" CollapseControlID="Panel2" Collapsed="False" ImageControlID="Image1"
                            ExpandedText="(Hide Details...)" CollapsedText="(Show Details...)" ExpandedImage="~/images/collapse.png"
                            CollapsedImage="~/images/expand.png" SuppressPostBack="true" />
                    </div>
                </td>
                <td style="vertical-align: top; padding: 10px; width: 50%;">
                    <asp:Panel ID="pnlActionHdr" runat="server" Style="width: 100%; height: 30px; background-color: #4791C5;
                        color: #FFF; vertical-align: middle; font-weight: bold;" Height="30px">
                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                            <div style="float: left; color: White;">
                                <asp:Label ID="Label1" runat="server" ForeColor="White" Font-Names="tahoma" Text="Actions" />
                            </div>
                            <div style="float: right; vertical-align: middle;">
                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/expand.png" />
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlActionCnt" runat="server" Height="0" Style="padding: 15px; background-color: white;
                        overflow: hidden;">
                        <asp:Button ID="btnAttach" runat="server" Text="Process Attached SIFs" CssClass="attachbutton"
                            OnClientClick="return confirm('Are you sure you want to attach these SIF\'s?');"
                            Style="background-color: #4791C5; color: #3D3D3D; border: solid 1px #3D3D3D;
                            height: 25px;" onmouseover="this.style.cursor='pointer';this.style.color='#FFFFFF';"
                            onmouseout="this.style.backgroundcolor='#4791C5';this.style.color='#3D3D3D';this.style.border='solid 1px #3D3D3D'" />
                    </asp:Panel>
                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="Server"
                        TargetControlID="pnlActionCnt" ExpandControlID="pnlActionHdr" CollapseControlID="pnlActionHdr"
                        Collapsed="False" ImageControlID="ImageButton1" ExpandedText="(Hide Details...)"
                        CollapsedText="(Show Details...)" ExpandedImage="~/images/collapse.png" CollapsedImage="~/images/expand.png"
                        SuppressPostBack="true" />
                    <asp:Panel ID="pnlDocumentHdr" runat="server" Style="width: 100%; height: 30px; background-color: #4791C5;
                        color: #FFF; vertical-align: middle; font-weight: bold;" Height="30px">
                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                            <div style="float: left; color: White;">
                                <asp:Label ID="Label2" runat="server" ForeColor="White" Font-Names="tahoma" Text="Documents" />
                            </div>
                            <div style="float: right; vertical-align: middle;">
                                <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/expand.png" />
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlDocumentCnt" runat="server" Style="background-color: white; overflow: hidden;"
                        Height="0">
                        <fieldset id="fldSIFS" runat="server" visible="false">
                            <legend>Drag document to client row</legend>
                            <asp:PlaceHolder ID="phSIFs" runat="server" />
                        </fieldset>
                        <fieldset id="fldUpload" runat="server">
                            <legend>Upload TIF for Processing</legend>
                            <table style="width: 100%;" border="0">
                                <tr valign="top">
                                    <td style="white-space: nowrap;">
                                        <input type="text" id="fileName" readonly="readonly" style="height: 20px;width: 80%;float: left; font-size:12px; ">
                                        <div style="position: relative; width: 100px; height: 25px; overflow: hidden;">
                                            <input type="button" value="Browse Files" style="width: 100px; position: absolute;
                                                top: 0px; background-color: #4791C5; color: #3D3D3D; border: solid 1px #3D3D3D;
                                                height: 25px;" />
                                            <input id="filSIF" runat="server" accept="image/tiff, image/tiff-fx" type="file"
                                                class="file_input_hidden" onchange="ChangeFileName(this.value);" />
                                        </div>
                                    </td>
                                    <td style="width: 125px;">
                                        <asp:Button ID="btnUpload" runat="server" Text="Upload SIF" Style="width: 99%; background-color: #4791C5;
                                            color: #3D3D3D; border: solid 1px #3D3D3D; height: 25px;" onmouseover="this.style.cursor='pointer';this.style.color='#FFFFFF';"
                                            onmouseout="this.style.backgroundcolor='#4791C5';this.style.color='#3D3D3D';this.style.border='solid 1px #3D3D3D'" />
                                    </td>
                                </tr>
                            </table>
                            <div id="divUploadError" runat="server" style="display: none; font-size: 11pt;" class="warning">
                            </div>
                        </fieldset></asp:Panel>
                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="Server"
                        TargetControlID="pnlDocumentCnt" ExpandControlID="pnlDocumentHdr" CollapseControlID="pnlDocumentHdr"
                        Collapsed="False" ImageControlID="ImageButton2" ExpandedText="(Hide Details...)"
                        CollapsedText="(Show Details...)" ExpandedImage="~/images/collapse.png" CollapsedImage="~/images/expand.png"
                        SuppressPostBack="true" />
                </td>
            </tr>
        </table>
        <div id="updateAttachSifDiv" style="display: none; height: 40px; width: 40px">
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="btnUpload" />
        <%--<asp:PostBackTrigger ControlID="gvClients" />--%>
        <asp:AsyncPostBackTrigger ControlID="gvClients" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvClients" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="lnkSearch" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="lnkClear" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
<asp:HiddenField ID="hdnFile" runat="server" />

<script type="text/javascript">

    function onUpdating() {
        // get the update progress div
        var updateProgressDiv = $get('updateAttachSifDiv');
        // make it visible
        updateProgressDiv.style.display = '';

        //  get the gridview element
        var gridView = $get('<%=tblAttach.ClientID %>');

        // get the bounds of both the gridview and the progress div
        var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
        var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

        //    do the math to figure out where to position the element (the center of the gridview)
        var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
        var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

        //    set the progress element to this position
        Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
    }

    function onUpdated() {
        // get the update progress div
        var updateProgressDiv = $get('updateAttachSifDiv');
        // make it invisible
        updateProgressDiv.style.display = 'none';
    }
             
</script>

<ajaxToolkit:UpdatePanelAnimationExtender ID="upaeAttachSif" BehaviorID="attachsifanimation"
    runat="server" TargetControlID="upAttach">
    <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="gvClients" Enabled="false" />
                            <EnableAction AnimationTarget="btnAttach" Enabled="false" />
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                            <EnableAction AnimationTarget="gvClients" Enabled="true" />
                            <EnableAction AnimationTarget="btnAttach" Enabled="true" />
                        </Parallel> 
                    </OnUpdated>
    </Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
