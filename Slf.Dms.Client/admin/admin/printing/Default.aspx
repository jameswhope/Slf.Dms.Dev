<%@ Page Title="" Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="admin_printing_Default" EnableEventValidation="false" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<%@ Register Src="../../CustomTools/UserControls/PrintQueueControl.ascx" TagName="PrintQueueControl"
    TagPrefix="uc1" %>
<%@ MasterType TypeName="admin_admin" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .sideRollupCellBodyScan
        {
            border-bottom: rgb(112,168,209) 1px solid;
            border-left: rgb(112,168,209) 1px solid;
            border-right: rgb(112,168,209) 1px solid;
            padding-bottom: 5px;
        }
        .navCell
        {
            padding-left: 5px;
        }
        .cellHdr
        {
            background-color: #DCDCDC;
            padding: 3px;
            width: 75px;
        }
        .cellCnt
        {
            background-color: #F0E68C;
            padding: 3px;
        }
        .totHdr
        {
            width: 100%;
            background-color: #F0E68C;
            text-align: center;
            font-weight: bold;
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .totCnt
        {
            text-align: center;
            padding-top: 3px;
            padding-bottom: 3px;
        }
    </style>
    <asp:ScriptManager ID="smPrintQueue" runat="server" AsyncPostBackTimeout="9000" />
    <asp:UpdatePanel ID="upPrintQueue" runat="server">
        <ContentTemplate>
            <div style="padding: 10px;" class="entry" id="divCheckScan">
                <table class="entry" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/default.aspx">
                                Admin</a>&nbsp>&nbsp;Print Queue
                        </td>
                    </tr>
                    <tr valign="top">
                        <td>
                            <table class="entry">
                                <tr>
                                    <td>
                                        <uc1:PrintQueueControl ID="PrintQueueControl1" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="updateScanDiv" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
<asp:LinkButton ID="lnkPrintQueue" runat="server" />
    <script type="text/javascript">
        var dragapproved = false
        var z, x, y
        function move() {
            if (event.button == 1 && dragapproved) {
                z.style.pixelLeft = temp1 + event.clientX - x
                z.style.pixelTop = temp2 + event.clientY - y
                return false
            }
        }
        function drags() {
            if (!document.all)
                return
            if (event.srcElement.className == "drag") {
                dragapproved = true
                z = event.srcElement
                temp1 = z.style.pixelLeft
                temp2 = z.style.pixelTop
                x = event.clientX
                y = event.clientY
                document.onmousemove = move
            }
        }
        document.onmousedown = drags
        document.onmouseup = new Function("dragapproved=false")
        //--> 

        function sideTab_OnMouseOver(obj) {
            obj.style.color = "rgb(90,90,90)";
            obj.style.backgroundColor = "rgb(240,245,251)";
        }
        function sideTab_OnMouseOut(obj) {
            obj.style.color = "";
            obj.style.backgroundColor = "";
        }

        function ReloadPage() {
            window.location.reload();
        }

        function toggleDocument(accountNumber, gridviewID) {
            var rowName = 'tr_' + accountNumber
            var gv = document.getElementById(gridviewID);
            var rows = gv.getElementsByTagName('tr');
            for (var row in rows) {
                var rowID = rows[row].id
                if (rowID != undefined) {
                    if (rowID.indexOf(rowName + '_child') != -1) {
                        rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                    } else if (rowID.indexOf(rowName + '_parent') != -1) {
                        var tree = rows[row].cells[0].children[0].src
                        rows[row].cells[0].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                    }
                }
            }
        }

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateScanDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('divCheckScan');

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
            var updateProgressDiv = $get('updateScanDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
        
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaePrintQueue" BehaviorID="PrintQueueanimation"
        runat="server" TargetControlID="upPrintQueue">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="divPrintQueue" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="divPrintQueue" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
