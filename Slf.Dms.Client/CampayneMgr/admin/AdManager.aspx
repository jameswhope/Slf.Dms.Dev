<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="AdManager.aspx.vb" Inherits="admin_AdManager" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
        var sURL = unescape(window.location.pathname);
    
        function pageLoad() {
            docReady();
        }

        function docReady() {

            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $("#dialog:ui-dialog").dialog("destroy");
                var name = adactive = $("*[id$='Adactive']"), AdDescription = $("*[id$='AdDescription']"),
			    allFields = $([]).add(adactive).add(AdDescription),
			    tips = $(".validateTips");
                function updateTips(t) {
                    tips
				    .text(t)
				    .addClass("ui-state-highlight");
                    setTimeout(function() {
                        tips.removeClass("ui-state-highlight", 1500);
                    }, 500);
                }
                function checkLength(o, n, min, max) {
                    if (o.val().length > max || o.val().length < min) {
                        o.addClass("ui-state-error");
                        updateTips("Length of " + n + " must be between " +
					    min + " and " + max + ".");
                        return false;
                    } else {
                        return true;
                    }
                }
                function checkRegexp(o, regexp, n) {
                    if (!(regexp.test(o.val()))) {
                        o.addClass("ui-state-error");
                        updateTips(n);
                        return false;
                    } else {
                        return true;
                    }
                }
                $("#dialog-ad").dialog({
                    autoOpen: false,
                    height: 300,
                    width: 450,
                    modal: true,
                    buttons: {
                        "Save Ad": function() {
                            var bValid = true;
                            allFields.removeClass("ui-state-error");
                            var adid = $(this).data('adid');
                            var addesc = AdDescription[0].value;
                            var adtype = $("*[id$='ddlAdType']").val();
                            var adactive = $("*[id$='adactive']").attr("checked");
                            
                            var dArray = "{";
                            dArray += "'adID': '" + adid + "',";
                            dArray += "'adDescription': '" + addesc + "',";
                            dArray += "'adType': '" + adtype + "',";
                            dArray += "'adActive': '" + adactive + "'";
                            dArray += "}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/InsertUpdateAd",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true,
                                success: function(response) {
                                    $().toastmessage('showSuccessToast', response.d);
                                    refresh();
                                },
                                error: function(response) {
                                    alert(response.responseText);
                                }
                            });
                            $(this).dialog("close");
                        },
                        "Delete Ad": function() {
                            if (confirm('Are you sure you want to delete this ad?')) {
                                var adid = $(this).data('adid');
                                
                                var dArray = "{";
                                dArray += "'adID': '" + adid + "',";
                                dArray += "}";

                                $.ajax({
                                    type: "POST",
                                    url: "../service/cmService.asmx/DeleteAd",
                                    data: dArray,
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    async: true,
                                    success: function(response) {
                                        $().toastmessage('showSuccessToast', response.d);
                                        refresh();
                                    },
                                    error: function(response) {
                                        alert(response.responseText);
                                    }
                                });
                                $(this).dialog("close");
                            }
                        },
                        Cancel: function() {
                            $(this).dialog("close");
                        }
                    },
                    close: function() {
                        allFields.val("").removeClass("ui-state-error");
                    }
                });
                $("#dialog-offer").dialog({
                    autoOpen: false,
                    height: 360,
                    width: 600,
                    modal: true,
                    buttons: {
                        "Save Offer": function() {
                            var adid = $(this).data('adid');
                            var adofferid = $(this).data('adofferid');
                            var offerdesc = $("*[id$='offerdesc']").val();
                            var offerredirecturl = $("*[id$='offerredirect']").val();
                            var offerweight = $("*[id$='offerweight']").val();
                            var offeractive = $("*[id$='offeractive']").attr("checked");
                            if (offeractive == undefined) {
                                offeractive = 'false';
                            } else {
                                offeractive = 'true';
                            }
                                                        
                            var dArray = "{";
                            dArray += "'adID': '" + adid + "',";
                            dArray += "'adOfferID': '" + adofferid + "',";
                            dArray += "'offerDescription': '" + offerdesc + "',";
                            dArray += "'offerredirecturl': '" + offerredirecturl + "',";
                            dArray += "'offerweight': '" + offerweight + "',";
                            dArray += "'offerActive': '" + offeractive + "'";
                            dArray += "}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/InsertUpdateAdOffer",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true,
                                success: function(response) {
                                    $().toastmessage('showSuccessToast', response.d);
                                    refresh();
                                },
                                error: function(response) {
                                    alert(response.responseText);
                                }
                            });
                            
                            $(this).dialog("close");
                        },
                        "Delete Offer": function() {
                            if (confirm('Are you sure you want to delete this offer?')) {
                                var adofferid = $(this).data('adofferid');
                                
                                var dArray = "{";
                                dArray += "'adOfferID': '" + adofferid + "'";
                                dArray += "}";

                                $.ajax({
                                    type: "POST",
                                    url: "../service/cmService.asmx/DeleteOffer",
                                    data: dArray,
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    async: true,
                                    success: function(response) {
                                        $().toastmessage('showSuccessToast', response.d);
                                        refresh();
                                    },
                                    error: function(response) {
                                        alert(response.responseText);
                                    }
                                });
                                $(this).dialog("close");
                            }
                        },
                        Cancel: function() {
                            $(this).dialog("close");
                        }
                    },
                    close: function() {
                        allFields.val("").removeClass("ui-state-error");
                    }
                });
                $("*[id$='btnCreate']").button();
                $("*[id$='btnCreateOffer']").button();
                $(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
                $(".jqShowButton").button({
                    icons: {
                        primary: "ui-icon-extlink"
                    },
                    text: false
                });
                $(".jqViewButton").button({
                    icons: {
                        primary: "ui-icon-search"
                    },
                    text: false
                });
                loadJQGridviewButtons();
            });
        }
        function showAd(AdID, actionType, adDesc, adtype ,active) {
            if (AdID != 0) {
                $("*[id$='AdDescription']").val(adDesc);
                $("*[id$='adactive']").attr("checked", active);
                $("*[id$='ddlAdType']").val(adtype);
            } else {
                $("*[id$='AdDescription']").val('');
                $("*[id$='adactive']").attr("checked", "false");
            }
            
            $("#dialog-ad")
            .data('adid', AdID)
            .dialog("open");
            return false;
        }
        function showOffer(AdID, actionType, AdOfferID, offerDesc, redirectUrl, weight, active) {
            $("*[id$='offerdesc']").val(offerDesc);
            $("*[id$='offerredirect']").val(redirectUrl);
            $("*[id$='offerweight']").val(weight);
            var chkActive = $("*[id$='offeractive']");
            if (active == "True") {
                chkActive.attr("checked", active);
            } else {
                chkActive.removeAttr('checked');
            }
            $("#dialog-offer")
            .data('adid', AdID)
            .data('adofferid', AdOfferID)
            .dialog("open");
            return false;
        }
        function toggleChildren(elem) {
            var sp = elem.children[0];
            sp.className = (sp.className != 'ui-icon ui-icon-circle-minus' ? 'ui-icon ui-icon-circle-minus' : 'ui-icon ui-icon-circle-plus');

            var p = elem.parentNode.parentNode.nextSibling;
            p.style.display = (p.style.display != 'none' ? 'none' : '');

            return false;
        }
        function OnRequestError(error, userContext, methodName) {
            if (error != null) {
                $().toastmessage('showErrorToast', error.get_message());
            }
        }
        function OnRequestComplete(result, userContext, methodName) {
            $().toastmessage('showSuccessToast', result);
            refresh();
        }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
            //window.location.replace(sURL);
        }
        function TestAd(adid){
            var adURL = 'http://www.idtrkr.com/r/Default.aspx?a=' + adid;
            window.open(adURL);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<div style="float: left; padding: 0px 3px 3px 3px">
        Admin > Ad Manager
    </div>
    <br style="clear:both" />
    <div class="pnlContent" style="min-height: 500px;">
        <div class="portlet">
            <div class="portlet-header">
                Ad Manager
            </div>
            <div class="portlet-content">
                <asp:UpdatePanel ID="upMain" runat="server">
                    <ContentTemplate>
                        <table style="width: 100%">
                            <tr valign="top">
                                <td style="width: 40%;">
                                    <div class="portlet">
                                        <div class="portlet-header">
                                            Ads</div>
                                        <div class="portlet-content">
                                            <asp:GridView ID="gvAds" runat="server" DataSourceID="dsAds" AllowPaging="True" PageSize="20"
                                                AllowSorting="True" AutoGenerateColumns="False" CssClass="ui-widget-content"
                                                DataKeyNames="AdID" PagerSettings-Mode="NumericFirstLast" PagerSettings-Position="Bottom"
                                                Width="100%">
                                                <SelectedRowStyle CssClass="selectedRow" />
                                                <PagerSettings Mode="NumericFirstLast" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <small>
                                                                <asp:LinkButton ID="lnkView" runat="server" CausesValidation="False" CommandName="Select"
                                                                    Text="View Offers" CssClass="jqViewButton" Font-Size="8px" CommandArgument='<%#eval("AdID") %>'></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkEditAd" runat="server" Text="Edit Ad" Font-Size="8px" CssClass="jqEditButton" />
                                                            </small>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header"/>
                                                        <ItemStyle HorizontalAlign="Center" Wrap="false" Width="55px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="AdID" HeaderText="ID" SortExpression="AdID" Visible="false">
                                                        <HeaderStyle HorizontalAlign="Center" Width="30px" CssClass="ui-widget-header"/>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Description" SortExpression="AdDescription">
                                                        <ItemTemplate>
                                                            <asp:Image ID="imgAdActive" runat="server" ImageUrl="" />
                                                            <asp:Label ID="lblAdDesc" runat="server" Text='<%# eval("AdDescription") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                                        <ItemStyle  HorizontalAlign="Left" Wrap="false"/>
                                                    </asp:TemplateField>
                                                   
                                                    <asp:BoundField DataField="adtypeid" HeaderText="adtypeid" SortExpression="adtypeid"
                                                        Visible="false">
                                                        <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header"/>
                                                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="adtype" HeaderText="Type" SortExpression="adtype">
                                                        <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header"/>
                                                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Created" HeaderText="Created" DataFormatString="{0:d}"
                                                        SortExpression="Created">
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header"/>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                </Columns>
                                                 <PagerTemplate>
                                                    <div id="pager" style="background-color: #DCDCDC">
                                                        <table style="width: 100%">
                                                            <tr>
                                                                <td style="padding-left: 10px;">
                                                                    <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                                        ID="btnFirst" CssClass="jqFirstButton" />
                                                                    <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                                        ID="btnPrevious" CssClass="jqPrevButton" />
                                                                    Page
                                                                    <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true" />
                                                                    of
                                                                    <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                                    <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                                        ID="btnNext" CssClass="jqNextButton" />
                                                                    <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                                        ID="btnLast" CssClass="jqLastButton" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </PagerTemplate>
                                            </asp:GridView>
                                            <asp:SqlDataSource ID="dsAds" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                CancelSelectOnNullParameter="False" SelectCommand="select AdID,AdDescription,a.Created,Active,a.adtypeid,at.adtype from tblad a WITH(NOLOCK) inner JOIN tbladtypes at WITH(NOLOCK) ON a.adtypeid = at.adtypeid order by AdDescription">
                                            </asp:SqlDataSource>
                                            <br />
                                            <asp:Button ID="btnCreate" runat="server" OnClientClick="return showAd(0,'a','','');"
                                                Text="Create New Ad" />
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="portlet">
                                        <div class="portlet-header">
                                            Ad Offer(s)</div>
                                        <div class="portlet-content">
                                            <asp:GridView ID="gvOffers" runat="server" DataSourceID="dsOffers" AutoGenerateColumns="False"
                                                CssClass="ui-widget-content" Width="100%">
                                                <HeaderStyle CssClass="portlet-header" />
                                                <RowStyle BackColor="#fdf5ce" VerticalAlign="Top" />
                                                <EmptyDataTemplate>
                                                    <div class="ui-widget">
                                                        <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
                                                            <p>
                                                                <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                                                                No offers exist for Ad!</p>
                                                        </div>
                                                    </div>
                                                </EmptyDataTemplate>
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <small>
                                                                <asp:LinkButton ID="lnkEditOffer" runat="server" Text="Edit Offer" Font-Size="8px" CssClass="jqEditButton" />
                                                            </small>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" BackColor="#fdf5ce" Wrap="false" Width="25px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="AdOfferID" HeaderText="AdOfferID" InsertVisible="False"
                                                        ReadOnly="True" SortExpression="AdOfferID" Visible="false" />
                                                    <asp:BoundField DataField="AdID" HeaderText="AdID" SortExpression="AdID" Visible="false" />
                                                      <asp:TemplateField HeaderText="Description" SortExpression="OfferDescription">
                                                        <ItemTemplate>
                                                            <asp:Image ID="imgOfferActive" runat="server" ImageUrl="" />
                                                            <asp:Label ID="lblOfferDesc" runat="server" Text='<%# eval("OfferDescription") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                                        <ItemStyle  HorizontalAlign="Left" Wrap="false" />
                                                    </asp:TemplateField>
                                                   
                                                    <asp:BoundField DataField="OfferRedirectUrl" HeaderText="Redirect Url" SortExpression="OfferRedirectUrl">
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                                        DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75px" />
                                                    <asp:BoundField DataField="Weight" HeaderText="WT/SEQ" SortExpression="Weight" ItemStyle-HorizontalAlign="Center"
                                                        ItemStyle-Width="50px" />
                                                </Columns>
                                            </asp:GridView>
                                            <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                CancelSelectOnNullParameter="False" SelectCommand="SELECT AdOfferID, AdID, OfferDescription, OfferRedirectUrl, Created, Active, Weight FROM tblAdOffer WHERE (AdID = @adid)">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="gvAds" Name="adid" PropertyName="SelectedValue" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                            <br />
                                            <div id="divSampleLink" runat="server" style="display:none;padding:10px; margin:10px" class="ui-state-highlight ui-corner-all"></div>
                                            <asp:Button ID="btnCreateOffer" runat="server" Style="display: none;" Text="Create New Offer" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div id="dialog-ad" title="Ad">
        <p class="validateTips">
            All form fields are required.</p>
        <form>
        <fieldset>
            <table style="width: 400px;">
                <tr valign="top">
                    <td style="width: 100px;" align="right">
                        Description:
                    </td>
                    <td>
                        <asp:TextBox runat="server" name="AdDescription" ID="AdDescription" CssClass="text ui-widget-content ui-corner-all"
                            Style="width: 100%;" TextMode="MultiLine" Rows="3" />
                    </td>
                </tr>
                <tr valign="top">
                    <td align="right">
                        Type:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlAdType" runat="server" DataSourceID="dsAdType" DataTextField="AdType"
                            DataValueField="AdTypeID">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="dsAdType" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                            SelectCommand="SELECT * from tbladtypes"></asp:SqlDataSource>
                    </td>
                </tr>
                <tr valign="top">
                    <td align="right">
                        Active:
                    </td>
                    <td>
                        <input name="adactive" type="checkbox" id="adactive" />
                    </td>
                </tr>
            </table>
        </fieldset>
        </form>
    </div>
    <div id="dialog-offer" title="Offer">
        <p class="validateTips">
            All form fields are required.</p>
        <form>
        <fieldset>
            <table>
                <tr>
                    <td align="right">
                        Description:
                    </td>
                    <td style="padding: 3px;">
                        <input type="text" name="offerdesc" id="offerdesc" class="text ui-widget-content ui-corner-all" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Redirect Url:
                    </td>
                    <td>
                        <asp:TextBox runat="server" name="offerredirect" ID="offerredirect" CssClass="text ui-widget-content ui-corner-all"
                            Style="width: 400px;" TextMode="MultiLine" Rows="3" />
                        
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Weight/Sequence:
                    </td>
                    <td>
                        <input type="text" name="offerweight" id="offerweight" class="text ui-widget-content ui-corner-all" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Active:
                    </td>
                    <td>
                        <input name="active" type="checkbox" id="offeractive" />
                    </td>
                </tr>
            </table>
        </fieldset>
        </form>
    </div>
</asp:Content>
