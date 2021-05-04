<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/reports.master" AutoEventWireup="false" CodeFile="SettlementProjection.aspx.vb" Inherits="research_reports_financial_accounting_SettlementProjection" %>
<%--MasterPageFile="~/research/reports/reports.master"--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <link href='<%= ResolveUrl("~/css/default.css") %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl("~/jquery/css/jquery.multiselect.css") %>' rel="stylesheet" type="text/css" />
    <style>
      #rpttoolbar {
        padding: 4px;
        display: inline-block;
      }
      /* support: IE7 */
      *+html #rpttoolbar {
        display: inline;
      }
      .lnkView
      {
          white-space: nowrap;
      }
  </style>
    <script type="text/javascript">
         function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {

                $('#<%= ddlCompany.ClientId%>').multiselect({ selectedList: 3,
                    noneSelectedText: "Select Law Firm",
                    selectedText: "# firms selected"
                });

                $('#<%= ddlAgency.ClientId%>').multiselect({ selectedList: 3,
                    noneSelectedText: "Select Agency",
                    selectedText: "# agencies selected"
                });

                $('#<%= ddlMonths.ClientId%>').multiselect({ selectedList: 1, multiple: false, header: false, minWidth: 40 });

                $('#<%= lnkView.ClientId%>').button();

                if ($('#<%=hdnFirstLoad.ClientId %>').val() == "1") {
                    $('#<%= ddlCompany.ClientId%>').multiselect("checkAll");
                    $('#<%= ddlAgency.ClientId%>').multiselect("checkAll");
                }

                if ($('#<%=lblMsg.ClientId %>').text().length != 0) {
                    $('#<%=lblMsg.ClientId %>').closest("div").addClass("error");
                    $('#dvRptSettProj').hide();
                } else {
                    $('#<%=lblMsg.ClientId %>').closest("div").removeClass("error");
                    $('#dvRptSettProj').show();
                }

                $('#<%= ud1.clientid%>').css("height", "100%");
                $('#dvRptSettProj').css("height", "100%");

                setInterval(KeepSessionAlive, 10000);

            });
        }


        function KeepSessionAlive() {
            $.post('<%=ResolveUrl("~/KeepAlive.ashx") %>', null);
        }   
        
    
    </script> 
    <asp:ScriptManager ID="sm1" runat="server">
    </asp:ScriptManager>   
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="ud1">
        <ProgressTemplate>
            <div class="AjaxProgressMessage">
                <img id="Img2" alt="" src="~/images/ajax-loader.gif" runat="server" style="vertical-align: middle;"/><asp:Label ID="ajaxLabel"
                    name="ajaxLabel" runat="server" Text="  Loading Report..." />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="ud1" runat="server" >
        <ContentTemplate>
            <div style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%;
                padding-top: 5px; height:100%">
                <div>
                    <asp:Label ID="lblMsg" runat="server"></asp:Label>
                </div>
                <div style="overflow: auto">
                    <table style="table-layout: fixed; font-size: 11px; width: 100%; font-family: tahoma;
                        height: 100%" cellspacing="0" cellpadding="0" border="0">
                        <tbody>
                            <tr>
                                <td valign="top">
                                    <div style="display: none" id="dvError" runat="server">
                                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                            width="100%" border="0">
                                            <tbody>
                                                <tr>
                                                    <td valign="top" width="20">
                                                        <img id="Img1" src="~/images/message.png" align="absMiddle" border="0" runat="server" /></td>
                                                    <td id="tdError" runat="server">
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr >
                                <td nowrap>
                                    <div id="rpttoolbar" class="ui-widget-header ui-corner-all">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td style="white-space:nowrap;" >
                                                        Law Firm: 
                                                    </td>
                                                    <td>
                                                        <select id="ddlCompany" runat="server" multiple="" >
                                                        </select>
                                                    </td>
                                                    <td>
                                                        Agency:  
                                                    </td>
                                                    <td>
                                                        <select id="ddlAgency" runat="server" multiple="" >
                                                        </select>
                                                    </td>
                                                    <td>
                                                        Months:  
                                                    </td>
                                                    <td>
                                                       <asp:DropDownList ID="ddlMonths" runat="server" ></asp:DropDownList>
                                                    </td>
                                                    <td style="width: 100%; text-align: right; ">
                                                        <asp:LinkButton ID="lnkView" runat="server" CssClass="lnkView">View Report</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%; height: 100%" valign="top">
                                    <div id="dvRptSettProj" style="overflow: auto; width: 100%; height: 600px;">
                                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Size="8pt" Width="100%"
                                            Height="100%" Font-Names="tahoma" >
                                            <LocalReport DisplayName="rpt"></LocalReport> 
                                        </rsweb:ReportViewer>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <asp:HiddenField ID="hdnFirstLoad" runat="server"/>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click"></asp:AsyncPostBackTrigger>
        </Triggers>
    </asp:UpdatePanel>
    
</asp:Content>

