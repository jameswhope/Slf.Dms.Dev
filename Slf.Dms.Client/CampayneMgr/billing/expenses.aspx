<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="expenses.aspx.vb" Inherits="billing_expenses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function pageLoad() {
        docReady();
    }
    function docReady() {
        $(document).ready(function () {
            loadPortlets();
            loadButtons();

        });
    }
    
</script>
<script type="text/javascript">
    //utils
    function loadPortlets(){
     $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
    }
    function loadButtons(){
     $(".jqButton").button();
            $(".jqAddButton").button({
                icons: {
                    primary: "ui-icon-plusthick"
                },
                text: false
            });
            $(".jqDeleteButton").button({
                icons: {
                    primary: "ui-icon-trash"
                },
                text: false
            });
            $(".jqEditButton").button({
                icons: {
                    primary: "ui-icon-pencil"
                },
                text: false
            });
            $(".jqSaveButton").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: false
            });
            $(".jqSaveButtonWithText").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: true
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
    }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <div style="float: left">
        <h2>
            Expenses</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <div id="dMsg" runat="server"></div>
                    <a href="Default.aspx" class="jqButton">Back to List</a>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />

                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>

