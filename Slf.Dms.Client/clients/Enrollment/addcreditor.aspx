<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addcreditor.aspx.vb" Inherits="Enrollment_addcreditor" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebCombo" TagPrefix="igcmbo" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Creditor</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">

    <script type="text/javascript">
	function txtZipCode_OnBlur(obj)
	{
		var txtCity = document.all("txtCity");
		var cboStateID = document.all("cboStateID");

		if (obj.value.length > 0)
		{
		    var zipXml = new ActiveXObject("Microsoft.XMLDOM");

		    zipXml.async = false;

			zipXml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

			var address = zipXml.getElementsByTagName("address")[0];

			if (address != null && address.attributes.length > 0)
			{
				if (address.attributes.getNamedItem("city") != null)
				{
					txtCity.value = address.attributes.getNamedItem("city").value;
				}

				if (cboStateID != null)
				{
					if (address.attributes.getNamedItem("stateabbreviation") != null) {
						for (i = 0; i < cboStateID.options.length; i++) {
							if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
								cboStateID.selectedIndex = i;
						}
					}
				}
			}
			else
			{
			    txtCity.value = "";
			    cboStateID.selectedIndex = 0;
			}
		}
		else
		{
		    txtCity.value = "";
		    cboStateID.selectedIndex = 0;
		}
	}
    </script>

    <form id="form1" runat="server" style="height: 100%;">
    <asp:Panel runat="server" ID="pnlMain" Style="width: 100%; height: 100%;">
        <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img id="Img1" runat="server" src="~/images/message.png" align="absMiddle" border="0">
                                </td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top: 15; height: 100%;">
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td>
                                Existing Creditors:
                            </td>
                            <td>
                                <igcmbo:WebCombo ID="cboCreditor" runat="server" BackColor="White" BorderColor="#7F9DB9"
                                    BorderStyle="Solid" BorderWidth="1px" ComboTypeAhead="None" DataSourceID="dsCreditor"
                                    Editable="false" EnableXmlHTTP="True" Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black"
                                    Height="20px" HideDropDowns="False" SelBackColor="49, 106, 197" SelForeColor="White"
                                    Version="3.00">
                                    <Columns>
                                        <igtbl:UltraGridColumn BaseColumnName="Name" IsBound="True" Key="Name">
                                            <Header Caption="Name">
                                            </Header>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="Street" IsBound="True" Key="Street">
                                            <Header Caption="Street">
                                                <RowLayoutColumnInfo OriginX="1" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="1" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="Street2" IsBound="True" Key="Street2">
                                            <Header Caption="Street2">
                                                <RowLayoutColumnInfo OriginX="2" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="2" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="City" IsBound="True" Key="City">
                                            <Header Caption="City">
                                                <RowLayoutColumnInfo OriginX="3" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="3" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="Abbreviation" IsBound="True" Key="Abbreviation">
                                            <Header Caption="Abbreviation">
                                                <RowLayoutColumnInfo OriginX="4" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="4" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="StateID" IsBound="True" Key="StateID" DataType="System.Int32">
                                            <Header Caption="StateID">
                                                <RowLayoutColumnInfo OriginX="5" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="5" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="ZipCode" IsBound="True" Key="ZipCode">
                                            <Header Caption="ZipCode">
                                                <RowLayoutColumnInfo OriginX="6" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="6" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                        <igtbl:UltraGridColumn BaseColumnName="CreditorID" IsBound="True" Key="CreditorID"
                                            DataType="System.Int32">
                                            <Header Caption="CreditorID">
                                                <RowLayoutColumnInfo OriginX="7" />
                                            </Header>
                                            <Footer>
                                                <RowLayoutColumnInfo OriginX="7" />
                                            </Footer>
                                        </igtbl:UltraGridColumn>
                                    </Columns>
                                    <ExpandEffects ShadowColor="LightGray" />
                                    <DropDownLayout BaseTableName="" BorderCollapse="Collapse" RowHeightDefault="20px"
                                        Version="3.00" XmlLoadOnDemandType="Accumulative" RowSelectors="No">
                                        <FrameStyle BorderStyle="Solid" BorderWidth="1px" BorderColor="#7F9DB9" Cursor="Default" Height="130px" Width="325px">
                                        </FrameStyle>
                                        <HeaderStyle BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White" Font-Names="Tahoma" Font-Size="11px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </HeaderStyle>
                                        <Pager>
                                            <ComboStyle Font-Names="Tahoma" Font-Size="8pt" Font-Strikeout="True">
                                            </ComboStyle>
                                        </Pager>
                                        <RowStyle BackColor="White" Font-Names="Tahoma" Font-Size="11px">
                                            <Padding Left="3px" Right="3px" />
                                            <BorderDetails WidthLeft="0px" WidthTop="0px" ColorBottom="LightGray" StyleBottom="Solid" WidthBottom="1px" />
                                        </RowStyle>
                                        <SelectedRowStyle BackColor="#316AC5" ForeColor="White" />
                                    </DropDownLayout>
                                </igcmbo:WebCombo>
                                <asp:SqlDataSource ID="dsCreditor" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                                    
                                    SelectCommand="SELECT tblCreditor.Name, tblCreditor.Street, tblCreditor.Street2, tblCreditor.City, tblState.Abbreviation, tblCreditor.StateID, tblCreditor.ZipCode, tblCreditor.CreditorID FROM tblCreditor INNER JOIN tblState ON tblCreditor.StateID = tblState.StateID WHERE (tblCreditor.Validated = @Validated) ORDER BY tblCreditor.Name">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="True" Name="Validated" Type="Boolean" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 90px">
                                Creditor:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="2" Font-Names="tahoma" Font-Size="11px" runat="server"
                                    ID="txtName" Width="100%"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtName"
                                    Display="Dynamic" ErrorMessage="Creditor name is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Street:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="3" ID="txtStreet" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Street 2:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="4" ID="txtStreet2" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                City, State Zip:
                            </td>
                            <td style="width: 200px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td>
                                            <asp:TextBox TabIndex="6" ID="txtCity" runat="server" Font-Names="tahoma" Font-Size="11px"
                                                Width="100%"></asp:TextBox>
                                        </td>
                                        <td style="width: 40px; padding-right: 7px; padding-left: 7px;">
                                            <asp:DropDownList TabIndex="7" ID="cboStateID" runat="server" Font-Names="Tahoma"
                                                Font-Size="11px" Width="100%">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 45px">
                                            <asp:TextBox MaxLength="50" TabIndex="5" ID="txtZipCode" runat="server" Font-Names="tahoma"
                                                Font-Size="11px" Width="100%"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 90px">
                                Phone:
                            </td>
                            <td style="width: 95px">
                                <cc1:InputMask ID="txtPhoneNumber1" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="8" Width="100%"></cc1:InputMask>
                            </td>
                            <td style="width: 55px">
                                <asp:TextBox ID="txtPhoneExtension1" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="9" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 90px">
                                Account #:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="10" Font-Names="tahoma" Font-Size="11px" runat="server"
                                    ID="AccountNumber"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Balance Due:
                            </td>
                            <td style="width: 200px">
                                <igtxt:WebCurrencyEdit ID="CurrentBalance" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    TabIndex="11">
                                </igtxt:WebCurrencyEdit>
                                <br />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="CurrentBalance"
                                    ErrorMessage="Balance is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                    padding-right: 10px;" valign="top">
                    <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                        cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <a tabindex="16" style="color: black" class="lnk" href="javascript:window.close();">
                                    <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                        border="0" align="absMiddle" />Cancel and Close</a>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="lnkAddCreditor" runat="server" Text="Add Creditor" />
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absMiddle" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    </asp:UpdatePanel>
    </form>
</body>
</html>
