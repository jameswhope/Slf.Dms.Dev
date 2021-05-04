<%@ Page Language="VB" AutoEventWireup="false" CodeFile="agencybatches.aspx.vb" Inherits="agencybatches" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<title></title>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

<script type="text/javascript">
    function RowClick_Batch(tr, CommBatchId)
    {
	    //navigate to correct CommBatchId
	    window.open("<%=ResolveUrl("~/research/reports/financial/commission/batchdetail.aspx") %>?company=<%=Request.QueryString("company")%>&commrecid=<%=Request.QueryString("commrecid")%>&commissionbatchids=" + CommBatchId,"winCommBatch","width=800,height=200,left=75,top=250,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes",true);
    }
</script>
</head>
<body>
									            <table style="font-family:tahoma;font-size:11px;width:100%;"  border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td valign="top" style="width:100%">
														<table style="font-family:tahoma;font-size:11px;width:100%" onmouseover="Grid_RowHover(this, true)" onmouseout="Grid_RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="1" width="100%" border="0">
																<thead>
																<tr>
																	<th class="StatHeadItem" nowrap align="left">#</th>
																	<th class="StatHeadItem" nowrap align="center">Date</th>
																	<th class="StatHeadItem" nowrap align="right">Amount</th>
																</tr>
																</thead>
																<tbody>
																    <asp:repeater id="rpBatches" runat="server">
																		<itemtemplate>
																			<tr onclick="RowClick_Batch(this.childNodes(0), <%#CType(Container.DataItem,BatchEntry).CommBatchId %>);">
																				<td style="cursor:pointer" class="StatListItem" nowrap="true">
																					<%#CType(Container.DataItem, BatchEntry).CommBatchId%>
																				</td>
																				<td style="cursor:pointer" class="StatListItem" nowrap="true" align="center">
																					<%#CType(Container.DataItem, BatchEntry).BatchDate.ToString("MMM d, yy")%>
																				</td>
																				<td style="cursor:pointer" class="StatListItem" align="right">
																					<%#CType(Container.DataItem, BatchEntry).Amount.ToString("c")%>
																				</td>
																			</tr>
																			<tr hover="false">
																				<td colspan="4" style="height:2;background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-position:bottom bottom;background-repeat:repeat-x;"><img src="~/images/spacer.gif" border="0" width="1" height="1" runat="server" /></td>
																			</tr>
																		</itemtemplate>
																	</asp:repeater>
																</tbody>
															</table>
															<asp:panel id="pnlNone" style="text-align:center;padding:20 5 5 5;" Visible="false" runat="server">You have no Batches.</asp:panel>
														</td>
													</tr>
													<tr>
														<td valign="middle" align="right" id="tdTotal" style="height:21;padding-right:2px;font-weight:bold" runat="server"></td>
													</tr>
												</table>
</body>
</html>