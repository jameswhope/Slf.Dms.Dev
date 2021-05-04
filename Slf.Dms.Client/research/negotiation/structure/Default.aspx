<%@ Page Language="VB" MasterPageFile="~/research/negotiation/negotiation.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="project_structure_Default" %>


<%@ Register src="../../../CustomTools/UserControls/Pod/WebPodControl.ascx" tagname="WebPodControl" tagprefix="uc1" %>


<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<asp:UpdatePanel ID="updSave" runat="server">
    <ContentTemplate>
        <uc1:WebPodControl ID="WebPodControl1" runat="server" />
    </ContentTemplate>
    <Triggers>
    </Triggers>
</asp:UpdatePanel>

<%--<link href="NegotiationInterface.css" type="text/css" rel="Stylesheet" />
<script type="text/javascript" language="javascript">
    var timer;
    var canvas;
    var toolbox;
    
    function HandleLoading()
    {
        Sys.WebForms.PageRequestManager.getInstance().remove_endRequest(HandleLoading);
        
        OnLoad();
    }
    
    function OnLoad()
    {
        try
        {
            var test = new ActiveXObject('MSXML2.XMLHTTP');
            var test2 = new ActiveXObject('MSXML2.DOMDocument');
        }
        catch (e)
        {
            window.location.href = '<%=ResolveUrl("~\Downloads\msxml6.msi") %>';
        }
        
        canvas = new Custom.UI.MapCanvas('MapCanvas', 65, 127, document.body.clientWidth - 65, document.body.clientHeight - 125, '<%=UserID %>');
        canvas.setClass('Canvas');
        canvas.registerUserPool(document.getElementById('<%=hdnUserPool.ClientID %>').value);
        canvas.registerRolePool(document.getElementById('<%=hdnRolePool.ClientID %>').value);
        
        toolbox = new Custom.UI.Toolbox(canvas, 'Toolbox', 0, 127, 65, document.body.clientHeight - 125);
        
        toolbox.setClass('Toolbox');
        toolbox.addItem('ToolboxGroup', 'Group', 5, 130);
        toolbox.addItem('ToolboxPerson', 'Person', 5, 195);
        toolbox.addItem('ToolboxRecycle', 'Recycle', 5, 260);
        toolbox.addItem('ToolboxCursorSelect', 'CursorSelect', 5, document.body.clientHeight - 130, 'default').selectCursor();
        toolbox.addItem('ToolboxCursorMove', 'CursorMove', 5, document.body.clientHeight - 65, 'pointer');
        LoadCanvas(canvas, document.getElementById('<%=hdnStructure.ClientID %>').value, document.getElementById('<%=hdnGroups.ClientID %>').value, document.getElementById('<%=hdnRoles.ClientID %>').value);
        
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
    }
    
    function BeginRequestHandler(sender, args)
    {
        if (args.get_postBackElement().id && args.get_postBackElement().id != '<%=lnkSave.ClientID %>' && args.get_postBackElement().id != '<%=lnkLoad.ClientID %>')
        {
            Save();
        }
    }
    
    function Save()
    {
        document.getElementById('<%=hdnNegotiation.ClientID %>').value = canvas.saveToString();
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    
    document.body.onunload = function()
    {
        Save();
    }
    
    window.onresize = function(ev)
    {
        clearTimeout(timer);
        timer = setTimeout(Resize, 100);
    }
    
    function Resize()
    {
        if (canvas && toolbox)
        {
            canvas.resize(65, 127, document.body.clientWidth - 65, document.body.clientHeight - 125);
            toolbox.resize(0, 127, 65, document.body.clientHeight - 125);
            toolbox.getItem('ToolboxCursorSelect').setLocation(5, document.body.clientHeight - 130);
            toolbox.getItem('ToolboxCursorMove').setLocation(5, document.body.clientHeight - 65);
        }
    }
</script>

<asp:ScriptManagerProxy ID="ScriptManager" runat="server">
    <Scripts>
        <asp:ScriptReference Assembly="Microsoft.Web.Preview" Name="PreviewScript.js" />
        <asp:ScriptReference Assembly="Microsoft.Web.Preview" Name="PreviewDragDrop.js" />
        <asp:ScriptReference Path="~/CustomTools/CustomTools.js" />
        <asp:ScriptReference Path="~/research/negotiation/structure/CustomToolsInherit.js" />
        <asp:ScriptReference Path="~/CustomTools/MapDAD/MapDAD.js" />
        <asp:ScriptReference Path="~/research/negotiation/structure/NegotiationInherit.js" />
    </Scripts>
</asp:ScriptManagerProxy>
<asp:UpdatePanel ID="updSave" runat="server">
    <ContentTemplate>
    <uc1:WebPodControl ID="WebPodControl1" runat="server" />
        <asp:LinkButton ID="lnkSave" runat="server" />
        <asp:LinkButton ID="lnkLoad" runat="server" />
        <asp:HiddenField ID="hdnStructure" runat="server" />
        <asp:HiddenField ID="hdnGroups" runat="server" />
        <asp:HiddenField ID="hdnRoles" runat="server" />
        <asp:HiddenField ID="hdnUserPool" runat="server" />
        <asp:HiddenField ID="hdnRolePool" runat="server" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="lnkSave" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="lnkLoad" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>

<asp:HiddenField ID="hdnNegotiation" runat="server" />
<asp:LinkButton ID="lnkDashboard" runat="server" />--%>
</asp:Content>