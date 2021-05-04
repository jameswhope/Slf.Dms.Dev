<%@ Page Title=" " Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="returns.aspx.vb" Inherits="admin_returns" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .cssPager
        {
            background-color: #FFA12D;
        }
        .cssPager span
        {
            background-color: #4f6b72;
            font-size: 18px;
        }
        .GridView tbody tr:hover, .GridView tbody tr:hover td, .GridView tbody tr.hover, .GridView tbody tr.hover td
        {
            background: #A7CCDF;
            color: #333;
        }
    </style>

    <script type="text/javascript">
        var loadingImg = '<img src="../../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqButton").button();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $(".jqSaveButton")
                    .button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
                $(".leadClass").each(function () { 
                    var lblNameObj = this;
                    var bid = getBuyerID();
                    var leadid = this.innerHTML;
                    
                    if (leadid !='LEAD NOT FOUND'){
                    
                        $("#" + lblNameObj.id).parent().parent().find('tdReturnDate').html(loadingImg);
                    
                        var dArray = "{";
                        dArray += "'buyerid': '" + bid + "',";
                        dArray += "'leadid': '" + leadid + "'";
                        dArray += "}";
                        
                        $.ajax({
                            type: "POST",
                            url: "../../service/cmService.asmx/FindReturn",
                            data: dArray,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: true,
                            success: function(response) {
                                $("#" + lblNameObj.id).parent().parent().find('.tdReturnDate').html(response.d) 
                                //alert(response.d);
                            },
                            error: function(response) {
                                alert(response.responseText);
                            }
                        });
                    }
                });
            });
        }
        function processGrid(undo) {
        
            $('#pnlProcess').html(loadingImg);
           
            var bid = getBuyerID();
            var fname =  $("#<%= hdnFile.ClientID %>").val();
            
            var leadData = '';
            
            $("*[id$='gvReturns'] tr").each(function() {
                var tr = $(this);
                if (tr.find('input:checkbox').attr("checked")) {
                    var lval = tr.find('input:hidden').attr("value");
                    leadData += lval + '|'
                }
            });
            
            var dArray = "{";
            dArray += "'returnfilepath': '" + escape(fname) + "',";
            dArray += "'buyerid': '" + bid + "',";
            dArray += "'leaddatastring': '" + leadData + "',";
            dArray += "'bundo': '" + undo + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "../../service/cmService.asmx/ProcessReturns",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showToast', {
                        text     : response.d,
                        sticky   : true,
                        type     : 'notice'
                    });
                   
                    refresh();
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });
            
            return false;
        }
    function refresh() {
        <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
    }        
    </script>

    <script type="text/javascript">
        function checkAll(chk_SelectAll) {
            var frm = document.forms[0];
            var chkState = chk_SelectAll.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                    el.checked = chkState;
                }
            }
        }
    </script>

    <script type="text/javascript">
        function getBuyerID() {
            var rval = null;
            var rblSelectedValue = $("#<%= rblBuyer.ClientID %> input:checked");
            try {
                rval = rblSelectedValue[0].value;
            }
            catch (err) {
                rval = -1;
            }
            return rval;
        }
        function CheckFileName() {
            var fname = $("#<%= fuReturns.ClientID %>").val();
            if (fname == '') {
                $().toastmessage('showWarningToast', 'Please select a file for this buyer to upload!');
                return false;
            } else {
                return true;
            }
        }
        function showTip(elem) {
            elem.children[1].style.display = "block";
        }
        function hideTip(elem) {
            elem.children[1].style.display = "none";
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <div style="float: left; padding: 0px 3px 3px 3px">
        Admin > Returns > Upload
        
    </div>
    <br style="clear:both" />

    <div class="portlet">
        <div class="portlet-header">
            ::: Returns - Upload Process
        </div>
        <div class="portlet-content">
            <asp:UpdatePanel ID="upReturns" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel GroupingText="Step 1 - Select Buyer" ID="pnlBuyer" runat="server" Style="margin: 5px;">
                        <asp:RadioButtonList ID="rblBuyer" runat="server" Width="100%" RepeatLayout="Table"
                            AutoPostBack="true">
                        </asp:RadioButtonList>
                        <div class="ui-widget">
                            <div id="divColumnOrder" runat="server" style="margin-top: 20px; padding: 0 .7em;"
                                class="ui-state-highlight ui-corner-all">
                                <p>
                                    Nothing Selected</p>
                            </div>
                        </div>
                    </asp:Panel>
                    <div style="clear: both;" />
                    <asp:Panel GroupingText="Step 2 - Select File to Upload" ID="pnlUpload" runat="server"
                        Style="margin: 5px; padding: 5px; display: none; text-align: left;">
                        <asp:FileUpload ID="fuReturns" runat="server" ForeColor="#993399" CssClass="jqButton"
                            Width="85%" />
                        <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click"
                            Font-Size="11px" CssClass="jqButton" OnClientClick="return CheckFileName();" />
                        <div style="clear: both; padding: 3px;" />
                        <div class="ui-widget">
                            <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
                                <p>
                                    <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                                    <strong>Select a file to upload from the selected buyer.(The file column order must
                                        match the columns for the buyer.)</strong></p>
                            </div>
                        </div>
                    </asp:Panel>
                    <div style="clear: both;" />
                    <div>
                        <asp:Panel GroupingText="Step 3 - Process Returns" ID="pnlProcess" runat="server"
                            Style="margin: 5px;">
                            <asp:GridView ID="gvReturns" runat="server" OnPageIndexChanging="PageIndexChanging"
                                AllowPaging="true" BackColor="White" BorderColor="#999999" BorderStyle="None"
                                AllowSorting="true" BorderWidth="1px" CellPadding="2" GridLines="Vertical" Width="100%"
                                PageSize="15" PagerSettings-Mode="NumericFirstLast">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" runat="server" id="chk_select" />
                                            <asp:HiddenField ID="hdnLeadID" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="20px" />
                                        <ItemStyle Width="20px" />
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <AlternatingRowStyle BackColor="#DCDCDC" />
                                <FooterStyle CssClass="footeritem" BackColor="#CCCCCC" ForeColor="Black" />
                                <PagerStyle CssClass="cssPager" BackColor="DarkGray" />
                                <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                                <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                            </asp:GridView>
                            <div style="clear: both" />
                            <div style="padding: 5px; margin: 5px">
                                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="jqButton" />
                                <asp:Button ID="lnkProcess" runat="server" Text="Process Selected Return(s)" CssClass="jqButton"
                                    Style="float: right!important" OnClientClick="return processGrid(0);" />
                                <asp:Button ID="lnkUndo" runat="server" Text="Undo Selected Return(s)" CssClass="jqButton"
                                    Style="float: right!important" OnClientClick="return processGrid(1);" />
                            </div>
                            <div id="updateDiv" style="display: none; height: 40px; width: 40px">
                                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/Images/loading.gif" />
                            </div>
                        </asp:Panel>
                    </div>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnUpload" />
                </Triggers>
            </asp:UpdatePanel>

            <script type="text/javascript">

                function onUpdating() {
                    // get the update progress div
                    var updateProgressDiv = $get('updateDiv');
                    // make it visible
                    updateProgressDiv.style.display = '';

                    //  get the gridview element
                    var gridView = $get('<%=gvReturns.ClientID %>');

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
                    var updateProgressDiv = $get('updateDiv');
                    // make it invisible
                    updateProgressDiv.style.display = 'none';
                }
             
            </script>

            <ajaxtoolkit:UpdatePanelAnimationExtender ID="upaeReturns" BehaviorID="Returnsanimation"
                runat="server" TargetControlID="upReturns">
                <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="pnlProcess" Enabled="false" />
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="pnlProcess" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
                </Animations>
            </ajaxtoolkit:UpdatePanelAnimationExtender>
        </div>
    </div>
    <asp:HiddenField ID="hdnFile" runat="server" />
</asp:Content>
