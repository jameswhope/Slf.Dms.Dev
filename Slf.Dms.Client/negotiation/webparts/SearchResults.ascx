<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SearchResults.ascx.vb" Inherits="negotiation_webparts_SearchResults" %>

<script language="javascript" type="text/javascript">   
    function RowHover(tbl, over)
    {
//        var obj = event.srcElement;
//        
//        if (obj.tagName == "IMG")
//            obj = obj.parentElement;
//            
//        if (obj.tagName == "TD")
//        {
//            //remove hover from last tr
//            if (tbl.getAttribute("lastTr") != null)
//            {
//                var lastTr = tbl.getAttribute("lastTr");
//                if (lastTr.coldColor == null)
//                    lastTr.coldColor = "#ffffff";
//                lastTr.style.backgroundColor = lastTr.coldColor;
//            }

//            //if the mouse is over the table, set hover to current tr
//            if (over)
//            {
//                var curTr = obj.parentElement;
//                curTr.style.backgroundColor = "#e6e6e6";
//                tbl.setAttribute("lastTr", curTr);
//            }
//        }
    }
    
    function RowClick(cid, crid) {
        window.location.href = '<%=ResolveUrl("~/negotiation/clients/") %>?cid=' + cid + '&crid=' + crid;
    }
    
    function getElement(aID)
    { 
         return (document.getElementById) ? document.getElementById(aID) : getElement[aID];
    }

    function ChangePlusMinus(PlusMinusCellID)
    {
	    try
	    {
		    var PlusMinusCellObj = getElement(PlusMinusCellID);
		    var img = PlusMinusCellObj.childNodes[0];
		    if(img != null)
		    {
			    if(img.src.match(/detail_expand/) != null)
				    img.src = "images/detail_minimize.png";
			    else
				    img.src = "images/detail_expand.png";
		    }
	    }
	    catch(e)
	    {
		    alert("Error in ChangePlusMinus Method: " + e); 
		}
    }
    
    function HideShowPanel(Panel)
    {
	    try
	    {
		    var ChosenPanel = getElement(Panel);
		    if (ChosenPanel != null)
		    {
			    var currentdisplay = getElement(Panel).style.display;
			    if (currentdisplay != "block")
				    getElement(Panel).style.display = "block";
			    else
				    getElement(Panel).style.display = "none";
		    }
	    }
	    catch(e)
	    {
		    alert( "Error in HideShowPanel Method: " + e);
		}
    }
</script>

<style type="text/css">
.searchResultsRow td
{
    border-top: solid 1px #D3D3D3;
    padding-top: 6px;
}
</style>

<asp:UpdatePanel ID="updMain" UpdateMode="Conditional" runat="server">
    <ContentTemplate>
        <asp:Panel ID="pnlSearchClients" runat="server">
            <asp:GridView ID="grvResults" Width="100%" AllowSorting="True" AllowPaging="true" BorderStyle="none" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnRowDataBound="grvResults_RowDataBound" OnPageIndexChanging="grvResults_PageIndexChanging" OnSorting="grvResults_Sorting" runat="server">
                <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                <HeaderStyle CssClass="webpartgridhdrstyle" />
                <AlternatingRowStyle CssClass="webpartgridaltrowstyle searchResultsRow" />
                <RowStyle CssClass="webpartgridrowstyle searchResultsRow" />
                <Columns>
                    <asp:TemplateField ItemStyle-Width="16px" ItemStyle-VerticalAlign="top">
                        <ItemTemplate>
                            <img border="0" src="images/detail_expand.png" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="NameDisplay" HeaderText="Name" SortExpression="Name" HtmlEncode="false">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" Wrap="false" VerticalAlign="top" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AddressDisplay" HeaderText="Address" SortExpression="Address" HtmlEncode="false">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" VerticalAlign="top" Wrap="false" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ContactNumberDisplay" HeaderText="Contact Number" SortExpression="ContactNumber" HtmlEncode="false">
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
        <asp:Panel ID="pnlNoSearchClients" style="text-align:center;color:#A1A1A1;padding:5px 5px 5px 5px;" runat="server">
            No clients were found for those search terms
        </asp:Panel>

        <asp:HiddenField ID="hdnSearch" runat="server" />
        <asp:HiddenField ID="hdnDepth" runat="server" />
        <asp:HiddenField ID="hdnOrder" runat="server" />
        <asp:HiddenField ID="hdnClientID" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>