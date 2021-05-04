<%@ Page Title="" Language="VB" MasterPageFile="~/Clients/client/client.master" AutoEventWireup="false"
	CodeFile="Default.aspx.vb" Inherits="Clients_Hardsip" EnableEventValidation="false" %>

<%@ MasterType TypeName="clients_client" %>
<%@ Register Assembly="Infragistics2.WebUI.WebHtmlEditor.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebHtmlEditor" TagPrefix="ighedit" %>
<%@ Register Assembly="Infragistics2.WebUI.WebSpellChecker.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebSpellChecker" TagPrefix="ig_spell" %>
<%@ Register src="~/customtools/usercontrols/hardshipControl.ascx" tagname="hardshipControl" tagprefix="LexxControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
	

	<script type="text/javascript">
 function Hardship_Delete(){
    <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
 }
 function Hardship_Save(){
    <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
 }
 function Hardship_Cancel(){
    <%= ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;
 }
 function ShowOtherBox(obj){
     var ddl = obj
    var txt = ddl.parentElement.children[1];
    if (obj.value==6){
        txt.style.display = 'block';
    }else{
        txt.style.display = 'none';
    }
 }
 
	</script>

	
	<asp:UpdatePanel ID="upCancel" runat="server">
		<ContentTemplate>
			<table id="tblContent" border="0" cellpadding="0" cellspacing="15" style="font-family: tahoma;
				font-size: 11px; width: 100%; height: 100%; vertical-align: top;">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" style="width: 100%; color: rgb(120,120,120);
							font-size: 11; font-family: Verdana, Arial, Helvetica">
							<tr>
								<td valign="top">
									<asp:LinkButton ID="lnkName" runat="server" CssClass="lnk" Style="color: rgb(80,80,80);
										font-family: tahoma; font-size: medium;"></asp:LinkButton>
									&nbsp; <a id="lnkNumApplicants" runat="server" class="lnk" style="font-family: verdana;
										color: rgb(80,80,80);"></a>-
									<asp:Label ID="lblCompany" runat="server" Style="color: rgb(160,80,80); font-family: tahoma;
										font-size: medium;"></asp:Label>
									<br />
									<asp:Label ID="lblAddress" runat="server"></asp:Label>
									<br />
									<asp:Label ID="lblClientDOB" runat="server"></asp:Label>
									<br />
									<asp:Label ID="lblCoAppDOB" runat="server"></asp:Label>
								</td>
								<td align="right" valign="top">
									<asp:Label ID="lblAccountNumber" runat="server" Style="color: rgb(80,80,80); font-family: tahoma;
										font-size: medium;"></asp:Label>
									<asp:Label ID="lblSSN" runat="server" Visible="false"></asp:Label>
									<asp:Label ID="lblLeadNumber" runat="server"></asp:Label>
									Status:&nbsp;
									<asp:LinkButton ID="lnkStatus" runat="server" CssClass="lnk" Style="color: rgb(50,112,163);"></asp:LinkButton>
									<asp:Label ID="lnkStatus_ro" runat="server" Visible="false"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr style='background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
					background-repeat: repeat-x;'>
					<td style="font-size: 14pt; font-family: Tahoma;">
					
					</td>
				</tr>
				<tr id="trAdminControls" runat="server">
					<td>
							<LexxControls:hardshipControl ID="hardshipControl1" runat="server" />
					</td>
				</tr>
				<tr style="height: 100%;">
					<td>
					</td>
				</tr>
			</table>
			<div id="updateHardshipProgressDiv" style="display: none; height: 40px; width: 40px">
				<asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
			</div>
		</ContentTemplate>
	</asp:UpdatePanel>
	<asp:LinkButton runat="server" ID="lnkSave" />
	<asp:LinkButton runat="server" ID="lnkCancel" />
	<asp:LinkButton runat="server" ID="lnkDelete" />
	<ajaxToolkit:UpdatePanelAnimationExtender ID="upaeCancel" BehaviorID="cancelAnimation"
		runat="server" TargetControlID="upCancel">
		<Animations>
			<OnUpdating>
				<Parallel duration="0">
					<ScriptAction Script="onUpdating();" />  
					<FadeOut minimumOpacity=".5" />
				 </Parallel>
			</OnUpdating>
			<OnUpdated>
				<Parallel duration="0">
					<FadeIn minimumOpacity=".5" />
					<ScriptAction Script="onUpdated();" /> 
				</Parallel> 
			</OnUpdated>
		</Animations>
	</ajaxToolkit:UpdatePanelAnimationExtender>



	<script type="text/javascript">
		function onUpdating() {
			// get the update progress div
			var updateProgressDiv = $get('updateHardshipProgressDiv');
			// make it visible
			updateProgressDiv.style.display = '';

			//  get the gridview element
			var gridView = $get('tblContent');

			// get the bounds of both the gridview and the progress div
			var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
			var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

			//    do the math to figure out where to position the element (the center of the gridview)
			var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
			var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

			//    set the progress element to this position
			Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
		}

		function onUpdated() {
			// get the update progress div
			var updateProgressDiv = $get('updateHardshipProgressDiv');
			// make it invisible
			updateProgressDiv.style.display = 'none';

			//			var additionalDiv = document.getElementById('ctl00_ctl00_cphBody_cphBody_fvHardship_tabsItems_tabHardInfo_AdditionalInformationLabel_tw');
			//			var hiddenAdditionalInput = document.getElementById('ctl00_ctl00_cphBody_cphBody_fvHardship_tabsItems_tabHardInfo_AdditionalInformationLabel_t_a');

			//			additionalDiv.setAttribute('content', false);
			//			additionalDiv.setAttribute('contentEditable', true);
			//			additionalDiv.setAttribute('_oldE', true);
			//			
			//			 
			//			additionalDiv.setAttribute('innerText', hiddenAdditionalInput.value);
		}

	</script>

</asp:Content>
