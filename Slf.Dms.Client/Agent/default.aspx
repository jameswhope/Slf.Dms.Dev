<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="_Agent_Default" title="Agent Interface" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Agent Interface</title>
    </head>
    <body style="vertical-align:middle;text-align:center;margin:0px;">
    <form id="theForm" action="" runat="server">
    <atlas:ScriptManager id="smgMain" runat="server" enablepartialrendering="true" />
        <div style="position:absolute;width:100%;height:100%;left:0px;top:0px;">
        <table style="border:solid 1px black;width:550px;height:94%;text-align:left;vertical-align:middle;margin-top:17px;margin-bottom:10px;">
                <tr style="height:25px;">
                    <td style="width:80px;" align="left"><cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn" width="100%" height="18px" /></td>
                    <td>&nbsp;:&nbsp;</td>
                    <td style="width:80px;" align="left"><cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn" width="100%" height="18px" /></td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td style="width:125px;"><asp:DropDownList id="ddlCompany" accesskey="1" runat="server" style="font-family:tahoma;font-size:10px;width:100%;height:18px;" /></td>
                    <td>&nbsp;&nbsp;<asp:DropDownList id="ddlCommRec" runat="server" style="font-family:tahoma;font-size:11px;width:100px;" /></td>
                    <td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>
                    <td><asp:Button ID="btnRequery" Text="Requery" runat="server" /></td>
                    <td style="width:125px;">&nbsp;</td>
                </tr>
                <tr style="height:100%;">
                    <td colspan="9" style="text-align:center;vertical-align:top;width:500px;height:100%;">
                        <atlas:UpdatePanel ID="uplBatches" runat="server" enableviewstate="true" rendermode="inline" mode="conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblError" runat="server" />
                                <table id="tblNone" visible="false" runat="server">
                                    <tr>
                                        <td>
                                            Sorry, there are no batches available for the
                                            specified criteria...
                                        </td>
                                    </tr>
                                </table>
                                
                                <table id="tblHeaders" width="100%" visible="false" runat="server">
                                    <tr>
                                        <td style="width:7%"></td>
                                        <td style="width:23%;">Batch</td>
                                        <td style="width:60%;">Date</td>
                                        <td style="width:10%;text-align:right;">Total</td>
                                    </tr>
                                </table>
                                
                                <asp:TreeView ID="trvBatches" Width="100%" Height="100%" Visible="false" ShowLines="true" ShowExpandCollapse="true" ExpandDepth="0" CollapseImageToolTip="" ExpandImageToolTip="" runat="server" />
                            </ContentTemplate>
                            
                            <Triggers>
                                <atlas:ControlEventTrigger ControlID="btnRequery" EventName="Click" />
                            </Triggers>
                        </atlas:UpdatePanel>
                    </td>
                </tr>
        </table>
        </div>
        
        <atlas:UpdateProgress ID="pro" runat="server">
            <ProgressTemplate>
                <table style="position:relative;width:100%;height:100%;vertical-align:middle;text-align:center;margin:0px;overflow:auto;">
                    <tr>
                        <td>
                            <img src="<%=ResolveUrl("~/images/agentloading.gif") %>" alt="" />
                            <br />
                            <asp:Label ID="lblProgress" runat="server" Text="Please Wait..." Font-Names="arial" Font-Size="10px" BackColor="white" />
                        </td>
                    </tr>
                </table>
            </ProgressTemplate>
        </atlas:UpdateProgress>
    </form>
    </body>
</html>