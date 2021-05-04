﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SearchResults.aspx.vb" Inherits="CallControls_SearchResults" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search Results - Select the Client for this call</title>

    <script language="javascript" type="text/javascript">
        function RowHover(tbl, over) {
            var obj = event.srcElement;

            if (obj.tagName == "IMG")
                obj = obj.parentElement;

            if (obj.tagName == "TD") {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null) {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over) {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#e6e6e6";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }

        function SelectClient(clientid) {
            document.getElementById('<%=hdnClientId.ClientID %>').value = clientid;
            <%=Page.ClientScript.GetPostBackEventReference(lnkClientSelected, Nothing) %>;
            return false;
        }  

       function CloseDialog(clientid) {
            window.returnValue = clientid;
            window.close();
            return false;
        }  
     
    </script>

    <style type="text/css">
        .searchResultsRow td
        {
            border-top: solid 1px #D3D3D3;
            padding-top: 6px;
        }
    </style>
</head>
<body>
    
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="updMain" UpdateMode="Conditional" runat="server">
        <ContentTemplate>
            <asp:Panel ID="pnlSearchClients" runat="server">
                <asp:GridView ID="grvResults" Width="100%" AllowSorting="True" AllowPaging="true"
                    BorderStyle="none" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333"
                    GridLines="None" OnRowDataBound="grvResults_RowDataBound"
                    runat="server" Font-Names="Tahoma" Font-Size="11px">
                    <SelectedRowStyle CssClass="" />
                    <HeaderStyle CssClass="" />
                    <AlternatingRowStyle CssClass="" />
                    <RowStyle CssClass="" />
                    <Columns>
                        <asp:BoundField DataField="ClientId" Visible="false" />
                        <asp:BoundField DataField="NameDisplay" HeaderText="Name" HtmlEncode="false">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" Wrap="false" VerticalAlign="top" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AddressDisplay" HeaderText="Address" 
                            HtmlEncode="false">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="top" Wrap="false" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ContactNumberDisplay" HeaderText="Contact Number" 
                            HtmlEncode="false">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="top" Wrap="false" />
                        </asp:BoundField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Assignments
                    </EmptyDataTemplate>
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="20" />
                </asp:GridView>
            </asp:Panel>
            <asp:Panel ID="pnlNoSearchClients" Style="text-align: center; color: #A1A1A1; padding: 5px 5px 5px 5px;"
                runat="server">
                No clients were found for those search terms
            </asp:Panel>
            <asp:HiddenField ID="hdnSearch" runat="server" />
            <asp:HiddenField ID="hdnClientID" runat="server" />
            <asp:LinkButton ID="lnkClientSelected" runat="server"></asp:LinkButton>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
