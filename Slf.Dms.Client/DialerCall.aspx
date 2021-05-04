<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="DialerCall.aspx.vb" Inherits="DialerCall" EnableEventValidation="false"%>
<%@ Register src="~/CustomTools/UserControls/DialerCallX.ascx" tagname="DialerCallX" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
<ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" >
    <uc1:DialerCallX ID="DialerCallX1" runat="server" />
</ajaxToolkit:ToolkitScriptManager>
    
</asp:Content>


