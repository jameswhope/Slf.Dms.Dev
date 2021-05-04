<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="DashboardAgencyTotal.aspx.vb" Inherits="Clients_Enrollment_DashboardAgencyTotal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet" />
    <!--#include file="mgrtoolbar.inc"-->
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css")%>" rel="stylesheet" />
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/jquery.treetable.css")%>" rel="stylesheet" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/validation/IsValid.js" />
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery.treetable.js" />
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">

        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                $("#progressbar").show();

                $("#tbtree").treetable({ expandable: true });
                $("#tbtree").removeClass("rawtb").addClass("jqtb");

            });

            if ($("#<%= hdnNoTab.ClientId%>").val() == "1") {
                $(".tabMainHolder").closest("tbody").prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest("td").css('height', '0px');
                    $(".menuTable").closest("tr").css('height', '0px');
                    $(".tabMainHolder, .tabTxtHolder").closest("tr").remove();
                    $(".menuTable").remove();
                }

                $("#progressbar").hide();
                $("#tbtree").treetable("reveal", "row2");
            }

            function Alert(message, title) {

                $("#jAlert").dialog({
                    autoOpen: false,
                    modal: true,
                    resizable: false,
                    title: title,
                    buttons: {
                        Ok: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#jAlert").empty().append('<ul><li>' + message + '</li></ul>').dialog("open");
            }


    </script>

    <style type="text/css">
        .ui-widget
        {
            font-size: 11px;
        }
        
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
        }
        .headItem
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            white-space: nowrap;
        }
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: none;
        }
        .sortHeader
        {
            background-image: url(<%= ResolveUrl("~/jquery/css/redmond/images/ui-icons_217bc0_256x240.png") %>);
            background-repeat: no-repeat;
            width: 16px;
            height: 16px;
            display: inline;
        }
        .sortHeaderAsc
        {
            background-position: 0 0;
        }
        .sortHeaderDesc
        {
            background-position: -64px 0;
        }
        .ui-dialog .ui-dialog-buttonpane
        {
            text-align: center;
            border: 0;
        }
        .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset
        {
            float: none;
        }
        #jAlert ul
        {
            list-style: none;
        }
        #jAlert li
        {
            margin: 20 0 20 0;
            padding: 3% 0 17 0;
            padding-left: 40px;
            background-image: url(<%= ResolveUrl("~/images/error.png") %>);
            background-repeat: no-repeat;
            background-position: left 0;
            font-size: 11px;
        }
        input.ui-button
        {
            filter: chroma(color=#000000);
        }
        fieldset
        {
            padding: 5px;
            width: 300px;
            white-space: nowrap;
        }
        fieldset legend
        {
            color: #777777;
        }
        fieldset input
        {
            vertical-align: middle;
        }
        #progressbar
        {
            position: absolute;
            padding: 5px; 
        }
        .rawtb { display: none; }
        .jqtb { display: block; }
        .modalPopupTracker
        {
            width: 99%;
            height: 600px;
            overflow: auto;
            padding-right: 10px; 
        }
        #dvPopup{overflow: hidden;}
    </style>
    <div id="jAlert" style="display: none;"></div>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div>
                <div id="dvFilter" style="padding: 5px; margin-left: 5px;">
                    <div>
                        <asp:Label ID="lbSource" Text="Sources:" runat="server">
                        </asp:Label>&nbsp;
                         <asp:DropDownList ID="ddlProduct" runat="server">
                         </asp:DropDownList>&nbsp;
                        <asp:Label ID="Label1" Text="Rep:" runat="server">
                        </asp:Label>&nbsp;
                         <asp:DropDownList ID="ddlRep" runat="server">
                         </asp:DropDownList>&nbsp;
                        <asp:Label ID="Label2" Text="Law Firm:" runat="server">
                        </asp:Label>&nbsp;
                         <asp:DropDownList ID="ddlCompany" runat="server">
                         </asp:DropDownList>&nbsp;
                         <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqFilterButton" />
                    </div>
                    <div id="progressbar">
                        <img src="<%=ResolveUrl("~/images/ajax-loader.gif") %>" />
                    </div>
                </div>
                <div id="dvTree" style="width: 100%; margin-right: 20px; padding-right: 20px;">
                    <asp:Literal ID="ltrTree" runat="server"></asp:Literal>
                </div>
            </div>            
            <asp:HiddenField id="hdnProducts" runat="server"/>
            <asp:HiddenField id="hdnCompanies" runat="server"/>
            <asp:HiddenField id="hdnReps" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
