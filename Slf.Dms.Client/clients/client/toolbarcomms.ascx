<%@ Control Language="VB" AutoEventWireup="false" CodeFile="toolbarcomms.ascx.vb" Inherits="clients_client_toolbarcomms" %>
<td nowrap="true">
    <a class="menuButton" href="javascript:Comms(true);">
        <img id="Img1" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_comms.png" />
        Communications&nbsp;(<asp:Literal ID="ltrCommCount" runat="server"></asp:Literal>)
    </a>
</td>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/ajax.js")%>"></script>
<script type="text/javascript">
    try {
        var windowname = '';
        try { windowname = window.top.parent.name.toLowerCase(); }
        catch (e1) {
            document.domain = "dmsi.local";
            windowname = window.top.parent.name.toLowerCase();
        }
        }
        catch (e) { }
        
    function GetCurrentPageName() {
            var str=window.parent.location.href;
            name=str.match(/\w+\.aspx/);
            return name.toLowerCase()
    }
    function SetCommWindowOpen(bOpen)
    {
        var url = "<%=ResolveUrl("~/util/setting.ashx") %>";
        var request = "s=Comms_IsOpen&v=" + String(bOpen);
        Ajax_String(url, request, true);
    }
    function CommWindowPos()
    {
        var TargetWidth = 300;
        var ScreenWidth = window.screen.availWidth;
        var ScreenHeight = window.screen.availHeight;

        var result = "";
        result += "width=" + TargetWidth;
        result += ",height=" + ScreenHeight;
        result += ",left=" + (ScreenWidth - TargetWidth);
        result += ",top=0";
        
        return result;
    }
    function Comms(force)
    {
        var p = GetCurrentPageName();
        
        if (force)
        {
            
            if (p =='main3.aspx' ) {
                try{
                    this.parent.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/side_commsholder.aspx?ClientID=" & DataClientID() & "&RelationTypeID=" & EntityRelationTypeID & "&RelationID=" & EntityRelationID & "&EntityName=" & EntityName) %>");
                }
                catch(e){
                    this.parent.parent.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/side_commsholder.aspx?ClientID=" & DataClientID() & "&RelationTypeID=" & EntityRelationTypeID & "&RelationID=" & EntityRelationID & "&EntityName=" & EntityName) %>");
                }  
            } else if (p == 'vicimain.aspx') {
                this.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/side_commsholder.aspx?ClientID=" & DataClientID() & "&RelationTypeID=" & EntityRelationTypeID & "&RelationID=" & EntityRelationID & "&EntityName=" & EntityName) %>");
            } else{
                SetCommWindowOpen(true);
                var ChildWindow = window.open("<%=ResolveUrl("~/clients/client/communication/side_commsholder.aspx?ClientID=" & DataClientID() & "&RelationTypeID=" & EntityRelationTypeID & "&RelationID=" & EntityRelationID & "&EntityName=" & EntityName) %>", "winComms", CommWindowPos() + ",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes",true);
                ResizeWindow(ChildWindow);
                ChildWindow = null;
                //window.parent.openComms();
            }
        } else {
            var url = "<%=ResolveUrl("~/util/setting.ashx") %>";
            var request = "s=Comms_IsOpen";
            Ajax_String(url, request, true, 
            function(strBool){
                strBool=strBool.toLowerCase();
                if (strBool=="true")
                {
                    if (p =='main3.aspx') {
                        try{
                            this.parent.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/") %>" + Session("Comms_LastPage") + ".aspx?<%=AutoSyncQS %>");
                        }
                        catch(e){
                            this.parent.parent.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/") %>" + Session("Comms_LastPage") + ".aspx?<%=AutoSyncQS %>");
                        }
                    }
                    else if (p == 'vicimain.aspx') {
                            this.parent.LoadSideCommPage("<%=ResolveUrl("~/clients/client/communication/") %>" + Session("Comms_LastPage") + ".aspx?<%=AutoSyncQS %>");
                    } 
                    else{
                        SetCommWindowOpen(true);
                        window.open("<%=ResolveUrl("~/clients/client/communication/") %>" + Session("Comms_LastPage") + ".aspx?<%=AutoSyncQS %>", "winComms", CommWindowPos() + ",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes",true);                
                    }
                }    
            });
        }
    }
    function RestorePosition(value)
    {
        var ExtraWidth = 2;
        var ScreenWidth = MainWindow().screen.availWidth;
        MainWindow().Width = MainWindow().document.body.offsetWidth + 6;
    
        var resizeBy = 300;
        if (MainWindow().screenLeft + MainWindow().Width + resizeBy + ExtraWidth > ScreenWidth)
        {
            resizeBy = ScreenWidth - MainWindow().Width - MainWindow().screenLeft + ExtraWidth;
        }
        
        MainWindow().resizeBy(resizeBy, 0);
        
    }
    function SavePosition()
    {
        //removed because actual top and height could not be determined
        /*var left = MainWindow().screenLeft;
        var top = MainWindow().screenTop;
        var width = MainWindow().document.body.offsetWidth;
        var height = MainWindow().document.body.offsetHeight;
    
        var url = "<%=ResolveURL("~/util/setting.ashx") %>";
        var request = "s=MainWindow_Position&v=" + left + "," + top + "," + width + "," + height;
        Ajax_String(url, request, true);*/
    }
    function MainWindow(){return self.top.window;}
    function ResizeWindow(ChildWindow)
    {
        SavePosition();
        
        var ExtraWidth = 2;
        
        var TargetWidth = 300;
        var ScreenWidth = MainWindow().screen.availWidth;
        var ScreenHeight = MainWindow().screen.availHeight;
        
        ChildWindow.moveTo(ScreenWidth - TargetWidth, 0);
        ChildWindow.resizeTo(TargetWidth, ScreenHeight);
                
        MainWindow().Width = MainWindow().document.body.offsetWidth + 6;
        MainWindow().Height = MainWindow().document.body.offsetHeight + 6;
        
        if (MainWindow().Width > ScreenWidth - TargetWidth - ExtraWidth)
        {
            MainWindow().resizeBy( - MainWindow().Width + (ScreenWidth - TargetWidth) - ExtraWidth, 0);
        }
        
        MainWindow().Width = MainWindow().document.body.offsetWidth + 6;
                
        if (MainWindow().screenLeft + MainWindow().Width + ExtraWidth > ChildWindow.screenLeft)
        {
            MainWindow().moveBy( - (MainWindow().screenLeft + MainWindow().Width - ChildWindow.screenLeft + ExtraWidth), 0);
        }
    }
</script>
