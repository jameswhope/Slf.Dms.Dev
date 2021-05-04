<%@ Page Language="VB" AutoEventWireup="false" CodeFile="reasonsTree.aspx.vb" 
Inherits="Clients_client_reasonsTree" title="Reason TreeSelections" MasterPageFile="~/clients/client/client.master" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="server">

    <script type="text/javascript" >
        var curURL;
        var allowed;
        
        function SaveReasons()
        {
            allowed = true;
            <%=Page.ClientScript.GetPostBackEventReference(lnkSaveReasons, Nothing) %>;
        }
        function Cancel()
        {
            allowed = true;
            <%=Page.ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;
        }
        function OnOtherChange(obj)
        {
            var lblOthers = document.getElementById('<%=hdnOthers.ClientID %>');
            
            if (lblOthers.value == 'undefined' || lblOthers.value == null)
            {
                lblOthers.value = '';
            }
            
            lblOthers.value += obj.id + ',' + obj.value + ';';
        }
        function BodyOnLoad()
        {
            var lblOthers = document.getElementById('<%=hdnOthers.ClientID %>');
            
            if (lblOthers.value == 'undefined' || lblOthers.value == null)
            {
                lblOthers.value = '';
                return;
            }

            if (lblOthers.value)
            {
                var pairs = lblOthers.value.split(';');
                var key;
                var obj;
                
                for (i = 0; i < pairs.length; i++)
                {
                    key = pairs[i].split(',');
                    obj = document.getElementById(key[0]);
                    
                    if (obj)
                    {
                        obj.value = key[1];
                    }
                }
            }
//            curURL = window.location.href;
//            allowed = false;

            document.getElementsByTagName('form')[0].onsubmit = function ()
            {
                allowed = true;
            }

//            var dvFloater = document.getElementById('dvFloater');
//            dvFloater.style.width = screen.width;
//            dvFloater.style.filter = 'alpha(opacity=0)';
        }
        
        window.onunload = function ()
        {
//            if (allowed == false)
//            {
//                window.location.href = curURL;
//            }
        }
    </script>
    
    <body onload="javascript:BodyOnLoad();" style="overflow:hidden;" scroll="no">
        <%--<div id="dvFloater" style="position:absolute;left:0px;top:0px;width:100%;height:100px;background-color:black;moz-opacity:0;z-index:999;"></div>--%>
        <asp:Label ID="lblNote" Width="100%" ForeColor="red" Font-Size="10" Font-Names="Tahoma" BorderColor="black" BorderWidth="1" BackColor="#ffffda" runat="server" Visible="false" /><br />
        <asp:TreeView ID="trvReasons" Height="243px" Width="171px" ShowLines="true" ShowExpandCollapse="true" ShowCheckBoxes="Leaf" ExpandDepth="0" ForeColor="black" Font-Size="12px" Font-Names="Tahoma" OnTreeNodeExpanded="trvReasons_OnTreeNodeExpanded" runat="server" />
        <input type="hidden" id="hdnOthers" runat="server" />
        <asp:LinkButton ID="lnkSaveReasons" runat="server" />
        <asp:LinkButton ID="lnkCancel" runat="server" />
    </body>
</asp:Content>