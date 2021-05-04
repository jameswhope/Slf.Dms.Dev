<%@ Page Language="VB" EnableEventValidation="false" MasterPageFile="~/processing/CheckRegister/CheckRegister.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="processing_CheckRegister_default" title="Firm - Register" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ MasterType TypeName="processing_CheckRegister_CheckRegister" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <style>
        .voidTran {color:rgb(160,160,160);}
    </style>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

        var lnkDeleteConfirm = null;
        var RegisterCount = null;
        
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

        function setMouseOverColor(element) {
            element.style.cursor = 'hand';
        }

        function setMouseOutColor(element) {
            element.style.textDecoration = 'none';
        }

        function DataChecked() {
            var frm = document.forms[0];
            
            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1 && el.checked == true) {
                    return true;
                }
            }

            return false;
        }
        
        function ApplyFilter(){
            var txtStart = document.getElementById("<%=txtStartDate.ClientID %>");
            var txtEnd = document.getElementById("<%=txtEndDate.ClientID %>");
            var hdnStart = document.getElementById("<%=hdnStart.ClientID %>");
            var hdnEnd = document.getElementById("<%=hdnEnd.ClientID %>");
            
            hdnEnd.value = txtEnd.value;
            hdnStart.value = txtStart.value;
            
             <%=Page.ClientScript.GetPostBackEventReference(lnkFilter, Nothing) %>;
             
        }
        
        function ReprintCheck()
        {
            var url = '<%= ResolveUrl("~/processing/popups/ReprintCheck.aspx") %>';
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Reprint Check",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 450, width: 660, scrollable: false,
                           onClose: function (){
                                if ($(this).modaldialog("returnValue") == -1) {
                                   var wnd = $(this).modaldialog("dialogArguments");
                                   wnd.location = wnd.location.href.replace(/#/g,"");
                                } 
                              }
                           });  
           
        }
        
        function Record_DeleteConfirm()
        {
            LoadControls();

            if (parseInt(RegisterCount.value) > 0 && DataChecked() == true) {

                window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Confirmation&m=<strong>Are you sure you want to delete these transactions?</strong><br><br>All transaction associations will be deleted as well.<br><br>Any transaction that cannot be deleted will be voided.';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Confirmation",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false}); 
            }
            else {
                window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/message.aspx")%>?t=Delete Confirmation&m=<strong>Please select a transaction</strong>';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Confirmation",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 330, width: 350, scrollable: false}); 
            }
        }
        
        function LoadControls()
        {
            lnkDeleteConfirm = document.getElementById("<%=lnkDeleteConfirm.ClientID %>");
            RegisterCount = document.getElementById("<%=hdnRegister.ClientID %>");
        }

        function ShowMessage(Value) {

            var dvError = document.getElementById("<%= dvError.ClientID %>");
            var tdError = document.getElementById("<%= tdError.ClientID %>");

            dvError.style.display = "inline";
            tdError.innerHTML = Value;
        }
        function HideMessage() {
            var dvError = document.getElementById("<%= dvError.ClientID %>");
            var tdError = document.getElementById("<%= tdError.ClientID %>");

            tdError.innerHTML = "";
            dvError.style.display = "none";
        }
        
        function Record_Delete()
        {
            // postback to delete
            <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
        }
       

    </script>
    <div runat="server" id="dvError" style="display: none;">
        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                    width="100%" border="0">
            <tr>
                <td valign="top" style="width: 20;">
                    <img id="Img3" alt="" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                </td>
                <td runat="server" id="tdError">
                </td>
            </tr>
        </table>
        &nbsp;
    </div>

    <table id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="15">
    
        <tr>          
            <td valign="top">
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color:rgb(244,242,232);">
                            <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                    <td style="width:100%;">
                                        <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;width:100%;background-position:left top;font-size:11px;font-family:tahoma;" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td width="5%" class="entryFormat">
                                                    Firm:
                                                </td>
                                                <td width="95%">
                                                    &nbsp;<asp:DropDownList ID="ddlFirm" Width="200" runat="server" CssClass="entryFormat">
                                                        <asp:ListItem Text="---All---" Value="0"/>
                                                        <asp:ListItem Text="The Seidaman Law Firm" Value="1"/>
                                                        <asp:ListItem Text="The Palmer Firm, P.C." Value="2"/>
                                                        <asp:ListItem Text="Wells Fargo Accounts" Value="3"/>
                                                    </asp:DropDownList>
                                                </td>    
                                                <td nowrap="nowrap"><img id="Img9" class="entryFormat" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="nowrap"><asp:TextBox ID="txtSearch" MaxLength="7" ToolTip="Enter Check Number To Search" runat="server" /></td>
                                                <td nowrap="nowrap"><asp:LinkButton id="lnkSearch" runat="server" class="gridButton"><img id="imgSearch" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16X16_Search.png" /></asp:LinkButton></td>
                                                <td nowrap="nowrap" style="width:10;" class="entryFormat">&nbsp;</td>                                                                                          
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td><img id="Img8" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                    <td style="width:100%;">
                                        <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);width:100%;background-repeat:repeat-x;background-position:left top;font-size:11px;font-family:tahoma;color:Black" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td class="entryFormat">
                                                    From:
                                                </td>
                                                <td>
                                                    <igsch:WebDateChooser ID="txtStartDate" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                                                         Value="" Width="100px" Height="19px">
                                                        <EditStyle Font-Size="11px" Font-Names="tahoma" />
                                                        <ExpandEffects Type="Fade" />
                                                        <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                                            NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                                            PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                                            ShowFooter="False" ShowMonthDropDown="True"
                                                            ShowYearDropDown="True" ShowTitle="False" ChangeMonthToDateClicked="true">
                                                            <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                                                Font-Size="8pt">
                                                            </CalendarStyle>
                                                            <DayHeaderStyle>
                                                                <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                                            </DayHeaderStyle>
                                                            <OtherMonthDayStyle ForeColor="#ACA899" />
                                                            <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                                                BorderWidth="2px" ForeColor="Black" />
                                                            <TitleStyle BackColor="#9EBEF5" />
                                                            <TodayDayStyle BackColor="#FBE694" />
                                                        </CalendarLayout>
                                                    </igsch:WebDateChooser>                                                 
                                                </td>
                                                <td class="entryFormat">
                                                    To:
                                                </td>
                                                <td>
                                                    <igsch:WebDateChooser ID="txtEndDate" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                                                         Value="" Width="100px" Height="19px" >
                                                        <EditStyle Font-Size="11px" Font-Names="tahoma" />
                                                        <ExpandEffects Type="Fade" />
                                                        <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                                            NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                                            PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                                            ShowFooter="False" ShowMonthDropDown="True"
                                                            ShowYearDropDown="True" ShowTitle="False" >
                                                            <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                                                Font-Size="8pt">
                                                            </CalendarStyle>
                                                            <DayHeaderStyle>
                                                                <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                                            </DayHeaderStyle>
                                                            <OtherMonthDayStyle ForeColor="#ACA899" />
                                                            <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                                                BorderWidth="2px" ForeColor="Black" />
                                                            <TitleStyle BackColor="#9EBEF5" />
                                                            <TodayDayStyle BackColor="#FBE694" />
                                                        </CalendarLayout>
                                                    </igsch:WebDateChooser>                                                    
                                                </td>
                                                <td nowrap="nowrap" class="entryFormat"><img id="Img7" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="nowrap" ><asp:CheckBox AutoPostBack="true" CssClass="checkbox"  runat="server" id="chkHideBouncedVoided" text="Hide Voided"></asp:CheckBox></td>
                                                <td nowrap="nowrap" class="entryFormat"><img id="Img1" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="nowrap" class="entryFormat"><a id="lnkApplyFilter" href="javascript:ApplyFilter();" class="gridButton"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" />Apply Filter</a></td>
                                                <td nowrap="nowrap" style="width:100%;" class="entryFormat">&nbsp;</td>
                                                <td runat="server" style="display:none;" class="entryFormat" id="tdDeleteConfirm" nowrap="true"><a id="lnkDeleteConfirm" runat="server" class="gridButton" href="javascript:Record_DeleteConfirm();">Delete</a></td>
                                                <td nowrap="nowrap"><img id="Img4" class="entryFormat" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="nowrap"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img5" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                                <td nowrap="nowrap" class="entryFormat"><a id="A1" runat="server" class="gridButton" href="javascript:window.print();"><img id="Img6" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                                <td nowrap="nowrap" style="width:10;" class="entryFormat">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                         </td>
                    </tr>  
                    <tr>
                        <td>
                        &nbsp;
                        </td>
                    </tr>     
                     <tr>
                        <td>
                            <table onselectstart="return false;" style="width:100%;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                                        <div id="dvTransactions" runat="server" class="grid" style="width: 100%">
                                            <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="false"
                                                AllowPaging="True" AllowSorting="True" CssClass="datatable" CellPadding="0" BorderWidth="0px"
                                                PageSize="50" GridLines="None" >
                                                <AlternatingRowStyle BackColor="White" />
                                                <RowStyle CssClass="row" />
                                                <Columns> 
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <input type="checkbox" runat="server" id="chk_select" />
                                                            <input type="hidden" id="hdnFirmId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FirmId")%>' />
                                                            <input type="hidden" id="hdnReconciled" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "Cleared")%>' />
                                                            <input type="hidden" id="hdnVoid" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "Void")%>' />
                                                            <input type="hidden" id="hdnRequest" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "RequestedType")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="5%" />
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="5%" />
                                                     </asp:TemplateField> 
                                                     <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            &nbsp;<img id="Img11" alt="" runat="server" src="~/images/16x16_icon.png" border="0" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="imgRequest" runat="server" border="0" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="5%" />
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="5%" />
                                                     </asp:TemplateField>                                                                                                                                                                           
                                                    <asp:BoundField DataField="ProcessedDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}">
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="10%"  />
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="10%" />
                                                    </asp:BoundField>
                                                    <asp:HyperLinkField HeaderText="Firm" ControlStyle-CssClass="lnk" DataTextField="FirmName"
                                                        DataNavigateUrlFields="clientid,RegisterId" DataNavigateUrlFormatString="~/clients/client/finances/bytype/register.aspx?id={0}&rid={1}">
                                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem"   />
                                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5"  />
                                                    </asp:HyperLinkField>   
                                                    <asp:BoundField DataField="Detail" HeaderText="Description">
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="10%"/>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="10%"/>
                                                    </asp:BoundField>  
                                                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:c}">
                                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" Width="10%"/>
                                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Width="10%"/>
                                                    </asp:BoundField>              
                                                    <asp:BoundField DataField="CheckNumber" HeaderText="Check&nbsp;Number" SortExpression="CheckNumber">
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="10%"/>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="10%" />
                                                    </asp:BoundField>   
                                                    <asp:BoundField DataField="ClearedDate" HeaderText="Cleared/Voided&nbsp;Date" DataFormatString="{0:MM/dd/yyyy}" SortExpression="ClearedDate">
                                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="10%"/>
                                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="10%"/>
                                                    </asp:BoundField> 
                                                    <asp:HyperLinkField HeaderText="Client&nbsp;Details" ControlStyle-CssClass="lnk" DataTextField="ClientDetails"
                                                        DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem"   />
                                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5"  />
                                                    </asp:HyperLinkField>                            
                                                </Columns>
                                                <PagerSettings Mode="NumericFirstLast" Visible="true" />
                                                <PagerStyle CssClass="pagerstyle" />
                                            </asp:GridView>
                                        </div>
                                        <asp:Panel runat="server" ID="pnlNoEntries" Style="text-align: center; font-style: italic;
                                            padding: 10 5 5 5;">
                                            There are no entries in the Firm Register</asp:Panel>
                                        <input type="hidden" runat="server" id="hdnRegister" />
                                    </td>
                                </tr>
                            </table>    
                            <input type="hidden" runat="server" id="txtSelected" />                       
                         </td>
                    </tr>   
                    <img id="Img16" width="450" height="1" runat="server" src="~/images/spacer.gif" border="0" />                                
                </table>
            </td>
        </tr>
    </table>
             

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
   
    <asp:LinkButton runat="server" ID="lnkSave" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:HiddenField ID="hdnReason" runat="server" />
    <asp:HiddenField ID="hdnVoidDate" runat="server" />
    <asp:HiddenField ID="hdnStart" runat="server" />
    <asp:HiddenField ID="hdnEnd" runat="server" />
    <asp:LinkButton id="lnkFilter" runat="server" />
</asp:Content>