<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="campaign.aspx.vb" Inherits="pub_campaign" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
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
                $("#dialog-campaign").dialog({
                    autoOpen: false,
                    height: 465,
                    width: 600,
                    modal: true,
                    position: [300, 50],
                    stack: true,
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-generate").dialog({
                    autoOpen: false,
                    height: 650,
                    width: 750,
                    stack: true,
                    modal: true,
                    position: [300, 25],
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-subIdPickle").dialog({
                    autoOpen: false,
                    height: 465,
                    width: 600,
                    modal: true,
                    position: [315, 65],
                    close: function() {
                        refresh();
                    }
                });

                $(".jqButton").button();
                $(".jqSaveButton")
                    .button({
                        icons: {
                            primary: "ui-icon-disk"
                        },
                        text: true
                    });
                $(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
                $(".jqFirstButton").button({
                    icons: {
                        primary: "ui-icon-seek-first"
                    },
                    text: false
                });
                $(".jqPrevButton").button({
                    icons: {
                        primary: "ui-icon-seek-prev"
                    },
                    text: false
                });
                $(".jqNextButton").button({
                    icons: {
                        primary: "ui-icon-seek-next"
                    },
                    text: false
                });
                $(".jqLastButton").button({
                    icons: {
                        primary: "ui-icon-seek-end"
                    },
                    text: false
                });
                $(".jqAddButton").button({
                    icons: {
                        primary: "ui-icon-plusthick"
                    },
                    text: true
                });

                $("*[id$='btnAddSubId']").unbind("click").click(function(){
                    SubmitSubIdPickle_Price();
                    return false;            
                });

                           
            });
        }

        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }

        function ShowCampaign(campaignid, campaignname, affiliateid, mediatypeid, offerid,price,affiliatepixel,active,priority,pickle) {

            if (campaignid == -1) {
                $("*[id$='txtCampaignName']").val('');
                $("*[id$='txtPriority']").val('1');
                $("*[id$='txtAffiliatePixel']").val('');
                $("*[id$='ddlAffiliate']").val(-1);
                $("*[id$='ddlMedia']").val(-1);
                $("*[id$='ddlOffers']").val(-1);
                $("*[id$='chkActive']").attr('checked', false);
                $("*[id$='txtPrice']").val(0.00);
                $("*[id$='hdnCID']").val('');
                $("*[id$='hdnCmpNme']").val('');
                $("#hypSubIdPickle").hide();
                $("#btnGenLink").hide();

            } else {
                $("*[id$='txtCampaignName']").val(campaignname);
                $("*[id$='txtPriority']").val(priority);
                $("*[id$='txtPrice']").val(price);

                var px = affiliatepixel;
               
                $("*[id$='txtAffiliatePixel']").val(px);

                $("*[id$='ddlAffiliate']").val(affiliateid);
                $("*[id$='ddlMedia']").val(mediatypeid);
                $("*[id$='ddlOffers']").val(offerid);
                $("*[id$='txtPickle']").val(pickle);
                $("*[id$='hdnCID']").val(campaignid);
                $("*[id$='hdnCmpNme']").val(campaignname);
                $("#tbSubIdPrice").val(price);
                $("#tbSubIdPickle").val(pickle);
                $("#hypSubIdPickle").show();
                $("#btnGenLink").show();

                if (active.toLowerCase() == 'true') {
                    $("*[id$='chkActive']").attr('checked', true);
                } else {
                    $("*[id$='chkActive']").attr('checked', false);
                }
            }

            $("#dialog-campaign")
                .data('campaignid', campaignid)
                .data('campaignname', campaignname)
                .dialog("open");

            if (campaignid > 0)
                campaignname = 'Campaign #' + campaignid + ' - ' + campaignname;
                
            $("#dialog-campaign").dialog("option", "title", campaignname);
        }
        
        function SaveCampaign() {

            if ($("*[id$='ddlAffiliate']").prop("selectedIndex") > 0 && $("*[id$='ddlOffers']").prop("selectedIndex") > 0 && $("*[id$='ddlMedia']").prop("selectedIndex") > 0) {
                var cid = $("#dialog-campaign").data('campaignid');
                var newCamp = new Object();
                newCamp.CampaignID = cid;
                newCamp.Campaign = $("*[id$='txtCampaignName']").val();
                newCamp.AffiliateID = $("*[id$='ddlAffiliate']").val();
                newCamp.AffiliatePixel = $("*[id$='txtAffiliatePixel']").val();
                newCamp.MediaType = $("*[id$='ddlMedia']").val();
                newCamp.OfferID = $("*[id$='ddlOffers']").val();
                newCamp.Price = $("*[id$='txtPrice']").val();
                newCamp.Priority = $("*[id$='txtPriority']").val();
                newCamp.Active = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
                newCamp.Pickle = $("*[id$='txtPickle']").val();
                newCamp.IsDefault = true;

                var DTO = { 'currentcampaign': newCamp };

                $.ajax({
                    type: "POST",
                    url: "../service/cmService.asmx/InsertUpdateCampaign",
                    data: JSON.stringify(DTO),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function(response) {
                        $().toastmessage('showSuccessToast', response.d);
                    },
                    error: function(response) {
                        $().toastmessage('showErrorToast', response.d);
                    }
                });
            }
            else {
                $().toastmessage('showErrorToast', 'Affiliate, Offer, and Media Type are required!');
            }

            return false;
        }

        function GenerateLink() {
            var cid = $("#dialog-campaign").data('campaignid');
            var campaign = $("#dialog-campaign").data('campaignname');
            var url = 'http://idtrkr.com/?c=' + cid

            $("*[id$='lblLink']").html(url);
            $("*[id$='lblLink2']").html(url);
            $("*[id$='lblLink3']").html('http://idtrkr.com/?c=' + cid + '&test=1&u=[userid]&l=[leadid]');

            $("*[id$='lbliframe']").text('<iframe src="http://idtrkr.com/p/?c=' + cid + '" height="1" width="1" frameborder="0"></iframe>');
            $("*[id$='lbliframe2']").text('<iframe src="http://idtrkr.com/p/?c=' + cid + '&b=[buyerid]" height="1" width="1" frameborder="0"></iframe>');
            $("*[id$='lblJsPixel']").text('<script type="text/javascript" language="javascript" src="http://idtrkr.com/p.ashx?c=' + cid + '">');
            $("*[id$='lblImgPixel']").text('<img src="http://idtrkr.com/p.ashx?c=' + cid + '&t=img" width="1" height="1" border="0" />');

            $("#dialog-generate")
                .dialog("option", "title", 'Campaign Links for ' + campaign)
                .dialog("open");
        }

        function CloseCampaign() {
            $("#dialog-campaign").dialog('close')
        }

        function OpenSubIdPickle() {
            var campaignid = $("*[id$='hdnCID']").val();
            var campaignname = $("*[id$='hdnCmpNme']").val();
            $("#dialog-subIdPickle")
                    .data('campaignid', campaignid)
                    .data('campaignname', campaignname)
                     .dialog("open");

            if (campaignid > 0)
                
                campaignname = 'Campaign #' + campaignid + ' - ' + campaignname;
                
            $("#dialog-subIdPickle").dialog("option", "title", campaignname);
            getSubIDPickleData();           
        }

        function getSubIDPickleData() {
        $('#divLoadingSubId').html('<img src="../images/loader3.gif" alt="" />');

        var cid = $("#dialog-subIdPickle").data('campaignid');
        var dArray = "{'campaignid': '" + cid + "'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetSubIDPickleInfo",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $('#divCampaignIdSubIdGrid').html(response.d);
                    $('#divLoadingSubId').html('');
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });

            return false;
        }

        function SubmitSubIdPickle_Price() {
            
            var subIdObj = new Object();

            subIdObj.CampaignId = $("*[id$='hdnCID']").val();
            subIdObj.SubId = $("*[id$='tbNewSubId']").val();
            subIdObj.Pickle = $("*[id$='tbSubIdPickle']").val();
            subIdObj.Price = $("*[id$='tbSubIdPrice']").val();
            subIdObj.UserID = $("*[id$='hdnUID']").val();
            subIdObj.Active = 1;

            var DTO = { 'subId': subIdObj };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SaveSubIdPicklePrice",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            getSubIDPickleData();
        }

        function SelectAllBoxes(elem) {

            var div = document.getElementById('tblSubId');

            var chk = div.getElementsByTagName('input');
            var len = chk.length;

            for (var i = 0; i < len; i++) {
                if (chk[i].type === 'checkbox' && chk[i].checked === false) {
                    chk[i].checked = true;
                }
            }                 
        }

        function DeselectAllBoxes(elem) {

            var div = document.getElementById('tblSubId');

            var chk = div.getElementsByTagName('input');
            var len = chk.length;

            for (var i = 0; i < len; i++) {
                if (chk[i].type === 'checkbox' && chk[i].checked === true) {
                    chk[i].checked = false;
                }                
            }                 
        }

        function resetCheckboxes(elem) {

            var div = document.getElementById('tblSubId');

            var chk = div.getElementsByTagName('input');
            var len = chk.length;

            var str = '';

            for (var i = 0; i < len; i++) {
                if (chk[i].type === 'checkbox' && chk[i].checked === true) {
                    str += chk[i].value + ","
                }                
            }
            var reducedstr = str.substring(0,str.length-1);
            
            var defaultObj = new Object();
            defaultObj.Active = 0;
            defaultObj.SubId = reducedstr;
            defaultObj.CampaignId = $("*[id$='hdnCID']").val();

            var DTO = { 'subId': defaultObj };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/SetAsDefaultValue",
                data: JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            getSubIDPickleData();   

        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float:left">
                <h2>Campaigns</h2>
            </div>
            <div style="float: right; padding: 0px 0px 5px 5px">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlAffiliate1" runat="server" AppendDataBoundItems="true" style="margin-right:10px" DataSourceID="dsAffiliate" DataTextField="Affiliate"
                                DataValueField="AffiliateID">
                                <asp:ListItem Text="All Affiliates" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlMediaType1" runat="server" AppendDataBoundItems="true" style="margin-right:10px" DataSourceID="dsMedia1" DataTextField="Media"
                                DataValueField="MediaTypeID">
                                <asp:ListItem Text="All Media Types" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="dsMedia1" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="select MediaTypeID, name[Media] from tblMediaTypes order by name">
                            </asp:SqlDataSource>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlActive" runat="server" style="margin-right:10px">
                                <asp:ListItem Text="Active Only" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Show All" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                        <td style="padding-left:5px">
                            <small>
                                <input type="button" class="jqButton" onclick="return ShowCampaign(-1, 'New Campaign', -1, -1, -1,0,'','false','');" value="Create Campaign" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvCampaign" runat="server" DataSourceID="odsCampaigns" AutoGenerateColumns="False"
                        Width="100%" AllowPaging="True" AllowSorting="True" PageSize="22" DataKeyNames="CampaignID,AffiliateID,OfferID"
                        AlternatingRowStyle-CssClass="altrow" GridLines="None" CellPadding="0" CellSpacing="0">
                        <RowStyle VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="AffiliateID" HeaderText="AffiliateID" SortExpression="AffiliateID"
                                Visible="false" />
                            <asp:BoundField DataField="CampaignID" HeaderText="ID" SortExpression="CampaignID">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" Width="33px" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Campaign" SortExpression="Campaign">
                                <ItemTemplate>
                                    <asp:Image ID="imgActive" runat="server" ImageUrl="" />
                                    <asp:LinkButton ID="lnkEdit" runat="server" Text='<%# eval("Campaign") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" Wrap="false" CssClass="griditem2" Width="320px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Affiliate" HeaderText="Affiliate " SortExpression="Affiliate">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" Width="200px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="MediaTypeID" HeaderText="MediaTypeID" SortExpression="MediaTypeID"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="Offer" HeaderText="Offer" SortExpression="Offer">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" Wrap="false" CssClass="griditem2" Width="350px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="OfferID" HeaderText="OfferID" SortExpression="OfferID"
                                Visible="false" />
                            <asp:BoundField DataField="MediaType" HeaderText="Media Type" SortExpression="MediaType">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AffiliatePixel" HeaderText="AffiliatePixel" SortExpression="AffiliatePixel"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created" 
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" SortExpression="CreatedBy"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedByName" HeaderText="CreatedByName" SortExpression="CreatedByName"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModified" HeaderText="LastModified" SortExpression="LastModified"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModifiedBy" SortExpression="LastModifiedBy"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="LastModifiedByName" HeaderText="LastModifiedByName" SortExpression="LastModifiedByName"
                                Visible="false">
                            </asp:BoundField>
                            <asp:BoundField DataField="TrafficTypeID" HeaderText="TrafficTypeID" SortExpression="TrafficTypeID"
                                Visible="false">
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
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" />
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
                    <asp:ObjectDataSource ID="odsCampaigns" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="getCampaigns" TypeName="AdminHelper+CampaignObject">
                        <SelectParameters>
                            <asp:Parameter Name="sortField" Type="String" />
                            <asp:Parameter Name="sortOrder" Type="String" />
                            <asp:Parameter Name="offerid" Type="Int32" DefaultValue="0" />
                            <asp:ControlParameter Name="active" ControlID="ddlActive" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="affiliateID" ControlID="ddlAffiliate1" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="mediaTypeID" ControlID="ddlMediaType1" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-campaign" title="Campaign">
        <table style="width: 100%;">
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Campaign:
                </td>
                <td colspan="5">
                    <asp:TextBox ID="txtCampaignName" runat="server" 
                         Style="width: 98%;" />
                </td>
            </tr>
            <tr valign="top">
                <td class="tdHdr" style="width: 100px;">
                    Affiliate:
                </td>
                <td colspan="5">
                    <asp:DropDownList ID="ddlAffiliate" runat="server" DataSourceID="dsAffiliate" DataTextField="Affiliate"
                        DataValueField="AffiliateID" AppendDataBoundItems="true" >
                        <asp:ListItem Text="-- Please Select --" Value="-1" />
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsAffiliate" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT AffiliateID, Name[Affiliate] from tblAffiliate order by Affiliate">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr valign="top">
                <td class="tdHdr" style="width: 100px;">
                    Affiliate Pixel:
                </td>
                <td colspan="5">
                    <asp:TextBox ID="txtAffiliatePixel" runat="server"  TextMode="MultiLine" Rows="5" Width="98%" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Media Type:
                </td>
                <td colspan="5">
                    <asp:DropDownList ID="ddlMedia" runat="server" DataSourceID="dsMedia" DataTextField="MediaType"
                        DataValueField="MediaTypeID" AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Please Select --" Value="-1" />
                    </asp:DropDownList>
                    <asp:Image ID="Image3" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Media Type is used for reporting and to filter lead types in data contracts." />
                    <asp:SqlDataSource ID="dsMedia" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="select 
	                                        cast(m.MediaTypeID as varchar(5)) + '|' + case when t.Name is not null then CAST(t.TrafficTypeID as varchar(10)) else '-1' end [MediaTypeID],
	                                        m.Name + case when t.Name is not null then ' - ' + t.Name else '' end [MediaType]  
                                        from tblMediaTypes m
                                        left join tblTrafficTypes t on t.MediaTypeID = m.MediaTypeID
                                        order by m.Name, t.Seq, t.Name">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Offer:
                </td>
                <td colspan="5">
                    <asp:DropDownList ID="ddlOffers" runat="server" DataSourceID="dsOffers" DataTextField="Offer"
                        DataValueField="OfferID"  AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Please Select --" Value="-1" />
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT OfferID, Offer FROM tblOffers WHERE (Active = 1) ORDER BY Offer">
                    </asp:SqlDataSource>
                </td>
            </tr>
<%--            </table>
            <div class="ui-corner-all" style="background-color:#da8a0a; color:#fff; border: 1px solid #e78f08; font: 'Trebuchet MS', Tahoma, Verdana, Arial, sans-serif none bolder .8em; margin: 5px -5px; padding: 3px 5px;">
                Default Campaign Values</div>
            <table style="float:left;">--%>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Price Paid:
                </td>
                <td>
                    <asp:TextBox ID="txtPrice" runat="server" Columns="6" MaxLength="5" />
                    <asp:Image ID="imgPrice" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Price paid to Affiliate for generating this lead." />
                    <a id="hypSubIdPickle" href="javascript:OpenSubIdPickle();" style="color:#6e6e6e; text-decoration:underline; font-size:.8em;">Sub Id Breakdown</a>
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Pickle:
                </td>
                <td>
                    <asp:TextBox ID="txtPickle" runat="server" Columns="6" MaxLength="2" />
                    <asp:Image ID="Image1" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Accepted values 1-99. If you don't know, don't change this!" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Priority:
                </td>
                <td>
                    <asp:TextBox ID="txtPriority" runat="server" Columns="6" MaxLength="2" />
                    <asp:Image ID="Image2" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Not currently being used. Leave as priority 1." />
                   
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 100px;">
                    Active:
                </td>
                <td>
                    <asp:CheckBox ID="chkActive" runat="server" />
                </td>
            </tr>
        </table>
        <div class="clear"></div>
        <hr />
        <div style="text-align:right">
            <button id="btnGenLink" class="jqButton" style="float:right!Important" onclick="return GenerateLink();">Generate Link</button>
            <button class="jqSaveButton" style="float:right!Important" onclick="return SaveCampaign();">Save Campaign</button>
        </div>
    </div>
    <div id="dialog-generate" title="Generate Campaign Links">
        <table style="width: 100%" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="2">
                    <div style="font-size: 18px; font-weight: bold">
                        Unique Link</div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    Here is your link. You can copy and paste from here:
                </td>
            </tr>
            <tr>
                <td style="font-weight: bold;">
                    Unique Link :
                </td>
                <td style="background-color: #FFFFFF;">
                    <asp:Label ID="lblLink" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding:15px">
                    <div style="padding:10px; background-color: #778899">
                    <table cellpadding="0" cellspacing="0" style="color: White">
                        <tr>
                            <td colspan="2" style="font-weight: bold;">
                                Optional parameters
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &s1=
                            </td>
                            <td>
                                sub Id 1
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &s2=
                            </td>
                            <td>
                                sub Id 2
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &s3=
                            </td>
                            <td>
                                sub Id 3
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &s4=
                            </td>
                            <td>
                                sub Id 4
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &s5=
                            </td>
                            <td>
                                sub Id 5
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &seed=
                            </td>
                            <td>
                                keyword
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &adgroup=
                            </td>
                            <td>
                                ad group
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &u=
                            </td>
                            <td>
                                user id
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &l=
                            </td>
                            <td>
                                lead id (internal use, used for call center iframe offers)
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-bottom: 15px;">
                                <div>
                                    All other custom defined optional parameters (ie. prefill parameters) will be passed
                                    on to the destination url. ie. <asp:Label ID="lblLink2" runat="server" />&fname=Mike
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                Unqiue Link for Call Center iFrames:<br />
                                <asp:Label ID="lblLink3" runat="server" />
                            </td>
                        </tr>
                    </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="font-size: 18px; font-weight: bold">
                        Conversion Pixel</div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    Choose one to give to the advertiser. iFrame is preferred. You can copy and paste from here:
                </td>
            </tr>
            <tr valign="top">
                <td style="font-weight: bold; vertical-align:top">
                    iFrame:
                </td>
                <td style="background-color: #FFFFFF">
                    <asp:Label ID="lbliframe" runat="server" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr valign="top">
                <td style="font-weight: bold; vertical-align:top">
                    Image:
                </td>
                <td style="background-color: #FFFFFF">
                    <asp:Label ID="lblImgPixel" runat="server" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="font-weight: bold; vertical-align:top">
                    Javascript:
                </td>
                <td style="background-color: #FFFFFF">
                    <asp:Label ID="lblJsPixel" runat="server" />&lt;/script&gt;
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="font-weight: bold; vertical-align:top">
                    Call Center:
                </td>
                <td style="background-color: #FFFFFF">
                    <asp:Label ID="lbliframe2" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div id="dialog-subIdPickle" title="SubId - Pickles">
        <div style="margin:5px 0 12px 0;">
            <label id="Label3">SubId: </label>
            <input id="tbNewSubId" size="30"/>
            <label id="Label1">Price: </label>
            <input id="tbSubIdPrice" size="5"/>
            <label id="Label2">Pickle: </label>
            <input id="tbSubIdPickle" size="5" />
            <button id="btnAddSubId" class="jqAddButton" style="margin: 0 0 0 20px;" >Add/Modify</button>
            <div style="clear:both;"></div>
        </div>
        <div class="clear"></div>
        <div id="divLoadingSubId">
        </div>
        <div id="divCampaignIdSubIdGrid">
        </div>
        <input type="hidden" runat="server" id="hdnUID" /><br />
        <input type="hidden" runat="server" id="hdnCID" /><br />
        <input type="hidden" runat="server" id="hdnCmpNme" /><br />
    </div>
</asp:Content>