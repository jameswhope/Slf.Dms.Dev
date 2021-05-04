<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="legalnotices.aspx.vb" Inherits="admin_legalnotices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var sURL = unescape(window.location.pathname);
        var ckedit = { langCode: 'en',
            width: 787,
            height: 480,
            toolbar:
						 [
							 ['Source', '-', 'Bold', 'Italic', 'Underline', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat'],
							 ['Font', 'FontSize', 'Format', 'NumberedList', 'BulletedList', '-', 'TextColor']
						 ]
        };
        var ckview = { langCode: 'en',
            width: 787,
            height: 480,
            toolbar:
						 [
							 ['Source', '-', 'Bold', 'Italic', 'Underline', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'LeftJustify', '-', 'SelectAll', 'RemoveFormat'],
							 ['Font', 'FontSize', 'Format', 'NumberedList', 'BulletedList', '-', 'TextColor']
						 ]
        };
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                $("#button-holder").buttonset();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $('.editEditor').ckeditor(ckedit);
                $('.viewEditor').ckeditor(ckview);
                loadButtons();
                loadDialogs();
            });
        }

        function loadButtons() {
            $(".jqButton").button();
            $(".jqViewButton").button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: false
            });
            $(".jqEditButton").button({
                icons: {
                    primary: "ui-icon-pencil"
                },
                text: false
            });
        }
        function loadDialogs() {
            $("#dialog:ui-dialog").dialog("destroy");

            $("#dialog-view").dialog({
                autoOpen: false,
                height: 725,
                width: 820,
                modal: true,
                //                    position: [300, 50],
                stack: true,
                buttons: {},
                close: function () {
                    refresh();
                }
            });
            $("#dialog-edit").dialog({
                autoOpen: false,
                height: 725,
                width: 820,
                modal: true,
                //                    position: [300, 50],
                stack: true,
                buttons: {},
                close: function () {
                    refresh();
                }
            });
            $("#dialog-new").dialog({
                autoOpen: false,
                height: 725,
                width: 820,
                modal: true,
                //                    position: [300, 50],
                stack: true,
                buttons: {},
                close: function () {
                    refresh();
                }
            });
        }
    </script>
    <script type="text/javascript">
        function ViewNotice(LegalNoticeId, TypeOfNotice, Name, HtmlText) {
            var nameOfNotice = 'Name: ' + Name;
            var labelNameOfNotice = document.getElementById('<%=lbViewNameOfNotice.ClientId%>');
            labelNameOfNotice.innerHTML = nameOfNotice;

            var typeOfNotice = "Type: " + TypeOfNotice;
            var labelTypeOfNotice = document.getElementById('<%=lbViewTypeOfNotice.ClientId%>');
            labelTypeOfNotice.innerHTML = typeOfNotice;

            $("*[id$='tbViewNotice']").val(HtmlText);
            $("*[id$='hdnLegalNoticeId']").val(LegalNoticeId);
            $("#dialog-view")
                .data('LegalId', LegalNoticeId)
                .dialog("open");
            return false;
        }

        function CloseNotice(ElementToClose) {
            $(ElementToClose).dialog("close");
        }

        function EditNotice(LegalNoticeId, TypeOfNotice, Name, HtmlText) {
            $("*[id$='tbEditTypeofNotice']").val(TypeOfNotice);
            $("*[id$='tbEditNameOfNotice']").val(Name);
            $("*[id$='taEditHtml']").val(HtmlText);
            $("*[id$='hdnLegalNoticeId']").val(LegalNoticeId);
            $("#dialog-edit")
                .data('LegalId', LegalNoticeId)
                .dialog("open");
            return false;
        }

        function NewNotice() {
            $("#dialog-new")
                .dialog("open");
            return false;
        }
    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="page-content">
        <div style="float: left; padding: 0 3px 6px 3px;">
            Admin > Legal Notices
        </div>
    </div>
    <br style="clear: both" />
    <asp:UpdatePanel ID="upLegalNotices" runat="server">
        <ContentTemplate>
            <div class="portlet" style="min-height: 600px;">
                <div class="portlet-header">
                    Legal Notices
                </div>
                <div class="portlet-content">
                    <asp:GridView ID="grdLegalNotices" runat="server" AutoGenerateColumns="false" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Style="margin: 0 0 10px 0;"
                        ShowFooter="false" AllowPaging="True" DataKeyNames="LegalNoticeId" CssClass="content"
                        Width="100%" HeaderStyle-CssClass="ui-widget-header" PageSize="20">
                        <Columns>
                            <asp:TemplateField ShowHeader="false" HeaderStyle-Width="25" HeaderStyle-HorizontalAlign="Center"
                                ItemStyle-Width="25" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkViewNotice" runat="server" CausesValidation="False" CommandName="View"
                                        Text="View" CssClass="jqViewButton" Font-Size="8" />&nbsp;
                                    <asp:LinkButton ID="lnkEditNotice" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit" CssClass="jqEditButton" Font-Size="8" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Name" HeaderText="Name Of Notice" InsertVisible="False"
                                ReadOnly="True" SortExpression="NoticeName" HeaderStyle-HorizontalAlign="Center"
                                HeaderStyle-Width="35" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75" />
                            <asp:BoundField DataField="TypeOfNotice" HeaderText="Notice Type" InsertVisible="False"
                                ReadOnly="True" SortExpression="NoticeType" HeaderStyle-HorizontalAlign="Center"
                                HeaderStyle-Width="35" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75" />
                            <asp:BoundField DataField="Created" HeaderText="Date Created" InsertVisible="False"
                                ReadOnly="True" SortExpression="Created" HeaderStyle-HorizontalAlign="Center"
                                HeaderStyle-Width="115" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75"
                                DataFormatString="{0:f}" />
                            <asp:BoundField DataField="LastModified" HeaderText="Date Last Modified" InsertVisible="False"
                                ReadOnly="True" SortExpression="DateModified" HeaderStyle-HorizontalAlign="Center"
                                HeaderStyle-Width="115" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75"
                                DataFormatString="{0:f}" />
                            <asp:BoundField DataField="ModifiedBy" HeaderText="Last Modified By" InsertVisible="False"
                                ReadOnly="True" SortExpression="ModifiedBy" HeaderStyle-HorizontalAlign="Center"
                                HeaderStyle-Width="50" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="75" />
                        </Columns>
                    </asp:GridView>
                    <asp:LinkButton ID="lnkNewNotice" runat="server" Text="New Notice" CssClass="jqButton" OnClientClick="javascript:NewNotice();"
                        Style="float: right;" />
                    <div style="clear: both;">
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-view" title="View Notice">
        <form>
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:Panel ID="pnlViewNotice" runat="server">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 50%; text-align: center;">
                                    <asp:Label ID="lbViewNameOfNotice" runat="server" CssClass="offer_detail_wrapper" />
                                </td>
                                <td>
                                    <asp:Label ID="lbViewTypeofNotice" runat="server" CssClass="offer_detail_wrapper"  />
                                </td>
                            </tr>
                        </table>
                        <div class="ui-widget-content">
                            <textarea name="divquestion" class="viewEditor" rows="5" cols="115" id="tbViewNotice"></textarea>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
        <asp:LinkButton ID="lnkCloseView" runat="server" Text="Close View" CssClass="jqButton"
            Style="float: right;" OnClientClick="javascript:CloseNotice(this);" />
        </form>
    </div>
    <div id="dialog-edit" title="Edit Notice">
        <form>
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:Panel ID="pnlEditNotice" runat="server">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 50%; text-align: center;">
                                    <asp:Label ID="lbEditTypeofNotice" runat="server" CssClass="offer_detail_wrapper"
                                        Text="Name:" />
                                    <asp:TextBox ID="tbEditTypeofNotice" runat="server" />
                                </td>
                                <td>
                                    <asp:Label ID="lbEditNameOfNotice" runat="server" CssClass="offer_detail_wrapper"
                                        Text="Type Of Notice:" />
                                    <asp:TextBox ID="tbEditNameOfNotice" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <div class="ui-widget-content">
                            <textarea class="editEditor" rows="5" cols="115" id="taEditHtml" runat="server"></textarea>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
        <asp:LinkButton ID="lnkSaveEdit" runat="server" Text="Save Changes" CssClass="jqButton"
            Style="float: right;" />
        <asp:LinkButton ID="lnkCancelEdit" runat="server" Text="Cancel Changes" CssClass="jqButton"
            Style="float: right;" OnClientClick="javascript:CloseNotice(this)"/>
             <asp:HiddenField ID="hdnLegalNoticeId" runat="server"  />
        </form>
    </div>
    <div id="dialog-new" title="New Notice">
        <form>
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:Panel ID="Panel1" runat="server">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 50%; text-align: center;">
                                    <asp:Label ID="lbNewNameofNotice" runat="server" CssClass="offer_detail_wrapper"
                                        Text="Name:" />
                                    <asp:TextBox ID="tbNewNameOfNotice" runat="server" />
                                </td>
                                <td>
                                    <asp:Label ID="lbNewNoticeTypes" runat="server" CssClass="offer_detail_wrapper"
                                        Text="Type Of Notice:" />
                                    <asp:DropDownList ID="ddlNoticeTypes" runat="server"></asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        <div class="ui-widget-content">
                            <textarea name="divquestion" class="editEditor" rows="5" cols="115" id="Textarea2" runat="server">Hello.</textarea>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
        <asp:LinkButton ID="LinkButton1" runat="server" Text="Save Notice" CssClass="jqButton"
            Style="float: right;" />
        <asp:LinkButton ID="LinkButton2" runat="server" Text="Cancel Notice" CssClass="jqButton"
            Style="float: right;" />
             <asp:HiddenField ID="HiddenField1" runat="server"  />
        </form>
    </div>
   
</asp:Content>
