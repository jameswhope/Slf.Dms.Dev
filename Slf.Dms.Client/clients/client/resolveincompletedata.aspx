<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="resolveincompletedata.aspx.vb" Inherits="clients_client_resolveincompletedata" title="DMP - Client" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <script type="text/javascript">
        function Record_Save()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkAction, Nothing) %>;
        }
        function Record_CancelAndClose()
        {
            <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
        }
    </script>
    
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
         <tr>
            <td valign="top">
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top" style="color: #666666;">
                            <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Resolve Incomplete Data</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                    <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td valign="top" id="tdInfoValid" runat="server">
                                The validation process is halted for this client becuase of incomplete data.  
                                The following notes describe what data is missing for this client. Please
                                make sure you have resolved all issues before resubmitting the client for
                                review by Data Entry.  You must enter a comment describing the changes which
                                have occured since the last submission.
                            </td>
                            <td valign="top" id="tdInfoInvalid" runat="server" visible="false">
                                This client is not currently flagged as having incomplete data. Please
                                press Return to go back to the Client's main page.
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <asp:PlaceHolder ID="phBody" runat="server">
            <tr>
                <td style="height:75px;padding-bottom:10px">
                    <asp:TextBox runat="server" ID="txtComment" Width="100%" Height="100%" TextMode="MultiLine" Font-Size="11px" style="font-family:Tahoma "></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="background-color:#f5f5f5;padding: 5 5 5 5;">
                    <table style="font-family:tahoma;font-size:11px;width:100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>Notes History</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding: 5 5 5 5;height: 100%" valign="top" >
                    <div style="overflow:auto;height:100%">
                        <table style="font-family:tahoma;font-size:11px;width:100%" class="fixedlist" cellpadding="0" cellspacing="0">
                            <tbody>
                                <asp:repeater id="rpNotes" runat="server">
                                    <itemtemplate>
                                        <tr style="padding-top:5px;padding-bottom:5px;">
                                            <td>
                                                <%#DataBinder.Eval(Container.DataItem, "By")%>
                                                &nbsp;&nbsp;|&nbsp;&nbsp;<%#DataBinder.Eval(Container.DataItem, "Date", "{0:MM/dd/yyyy}")%><br />
                                                <span style="color:gray"><%#DataBinder.Eval(Container.DataItem, "Value")%></span>
                                            </td>
                                        </tr>
                                    </itemtemplate>
                                </asp:repeater>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
        </asp:PlaceHolder>
        <asp:LinkButton ID="lnkCancelAndClose" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkAction" runat="server"></asp:LinkButton>
    </table>

</asp:Content>