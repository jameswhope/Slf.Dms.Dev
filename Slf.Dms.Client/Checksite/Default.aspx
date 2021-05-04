<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="ChecksiteQueryViewer._Default" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.Misc" tagprefix="igmisc" %>

<%@ Register Assembly="Infragistics2.Web.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.Web.UI.LayoutControls" tagprefix="ig" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebNavigator.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebNavigator" tagprefix="ignav" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <style type="text/css">
        #Select1
        {
            width: 405px;
        }
        .style6
        {
            width: 105px;
            height: 69px;
        }
        .style7
        {
            width: 422px;
            height: 69px;
        }
        .style8
        {
            font: normal normal bold 100% serif;
            height: 69px;
        }
        .style9
        {
            width: 137px;
        }
        .BoxHeader
        {
            font-family: Tahoma;
            color: #000000;
            font-size: 12px;
            vertical-align: middle;
            background-color: #99BFFF;
            padding-left: 10px;
        }
        .BoxTable
        {
            margin: 0px;
            border: 1px solid #000080;
            font-family: Tahoma;
            font-size: 12px;
            padding: 0px;
            background-color: #E0E7FE ;
           
        }
        .propvalue
        {
            font-family: Tahoma;
            font-size: 11px;
            color: #800000;
        }
        .divToolTip
        {
            border: 1px solid dimgray;
            position: absolute;
            background-color: #FFFFFF;
            padding 3px;
        }
    </style>
    <script type="text/javascript"> 
         /*Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function(sender, args) {
            if (args.get_postBackElement().id == '<%= Button1.ClientID %>') {
                $find('<%= UpdateProgress1.ClientID %>').get_element().style.display = 'block';
            }
        });*/  
        function showImage(image, imgpath, ev) {
            var divImg = document.getElementById("divTip");
            var imgTip = document.getElementById("imgTip");
            imgTip.src = imgpath;
            divImg.style.visibility = "visible";
            divImg.style.left = ev.clientX + 5;
            divImg.style.top = ev.clientY + 5;
         }
        function hideImage(image) {
            var divImg = document.getElementById("divTip");
            divImg.style.visibility = "hidden";
        }
       

    </script> 
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout ="360000">
    </asp:ScriptManager>
    <div style="width: 100%; height: 100%">
    
        <table style="width: 90%; height: 100%;">
            <tr>
                <td>
                    <table style="width: 100%;" class="BoxTable" cellpadding="8" cellspacing="0">
                        <tr>
                            <td  colspan="3"class="BoxHeader">
                            
                                Checksite Query Viewer</td>
                        </tr>
                        <tr>
                            <td class="style6">
                                Select Query:</td>
                            <td class="style7">
                                <asp:DropDownList ID="ddlMethods" runat="server" Height="31px" Width="405px" 
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td class="style8">
                                <asp:Button ID="Button1" runat="server" Text="Execute" BorderStyle="Solid" 
                                    Font-Names="Tahoma" Font-Size="11px" BorderWidth="1px" 
                                    Height="26px" Width="74px" BorderColor="#000066" Font-Bold="False"  />
                            </td>
                        </tr>
                        </table>
                </td>
            </tr>
            <tr id="trParameters" runat="server">
                <td>
                    <br />
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional"  >
                    <ContentTemplate>
                    <table id="tblParameters" style="width:100%;" class="BoxTable" cellpadding="8" cellspacing="0" runat="server" enableviewstate="true">
                        <tr>
                            <td colspan="2" class="BoxHeader" >
                                                                Parameters: </td>
                        </tr>
                        <tr >
                            <td class="style9">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlMethods" EventName="SelectedIndexChanged" /> 
                    </Triggers> 
                    </asp:UpdatePanel>
                    
                    </td>
            </tr>
            <tr>
                <td>
                <br/>
                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" 
                        AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="0" DynamicLayout="True">
                    <ProgressTemplate>
                    <div style="visibility:visible"   >
                        <img src="<%=ResolveUrl("~/ig_res/Default/images/bigloading.gif") %>" alt="" /> Getting Results ...
                    </div>
                    </ProgressTemplate> 
                    </asp:UpdateProgress>
                    <table style="width:100%;" class="BoxTable" cellpadding="8" cellspacing="0">
                        <tr>
                            <td class="BoxHeader">
                                Results</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional"  >
                                <ContentTemplate>
                                <ignav:UltraWebTree ID="UltraWebTree1" runat="server" 
                                        FileUrl="" HoverClass="" Indentation="20" TargetFrame="" 
                                        TargetUrl="" WebTreeTarget="ClassicTree" Width="100%" DefaultImage="" 
                                        HiliteClass="">
                                    <NodeEditStyle Font-Names="Microsoft Sans Serif" Font-Size="9pt">
                                    </NodeEditStyle>
                                    <Images>
                                        <ExpandImage Url="ig_treePlus.gif" />
                                        <CollapseImage Url="ig_treeMinus.gif" />
                                    </Images>
                                    <SelectedNodeStyle BackColor="Navy" BorderStyle="Solid" BorderWidth="1px" 
                                        Cursor="Default" ForeColor="White">
                                    <Padding Bottom="1px" Left="2px" Right="2px" Top="1px" />
                                    </SelectedNodeStyle>
                                </ignav:UltraWebTree>
                                </ContentTemplate> 
                                <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="ddlMethods" EventName="SelectedIndexChanged" /> 
                                <asp:AsyncPostBackTrigger ControlID ="Button1" EventName="Click" /> 
                                </Triggers> 
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div id="divTip" class="divToolTip" style="visibility: hidden; position:absolute;">
        <img id="imgTip" src="" />
    </div>
    </form>
</body>
</html>
