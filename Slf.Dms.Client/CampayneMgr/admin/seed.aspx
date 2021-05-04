<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="seed.aspx.vb" Inherits="admin_seed" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        a {text-decoration:none;color:#333333;}
        a:hover {text-decoration:underline;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <div>
            <h2>
                Seed a Data Lead
            </h2>
            <table cellspacing="10">
                <tr>
                    <td valign="top"><table>
                <tr>
                    <td>
                        First:
                    </td>
                    <td>
                        <asp:TextBox ID="txtFirst" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtFirst"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Last:
                    </td>
                    <td>
                        <asp:TextBox ID="txtLast" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtLast"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Email:
                    </td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Phone:
                    </td>
                    <td>
                        <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator4" runat="server" ErrorMessage="*" ControlToValidate="txtPhone"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Zip:
                    </td>
                    <td>
                        <asp:TextBox ID="txtZip" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" ControlToValidate="txtZip"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Edu Program:
                    </td>
                    <td>
                        <asp:TextBox ID="txtProgram" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Contract:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlContract" runat="server" DataSourceID="ds_Contracts" DataTextField="contract" DataValueField="BuyerOfferXrefID" AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select -- " Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="ds_Contracts" runat="server" ConnectionString="<%$ connectionStrings:IDENTIFYLEDB %>" SelectCommandType="Text" SelectCommand="
                                select x.BuyerOfferXrefID, b.Buyer + ' - ' + x.ContractName [contract]
                                from tblBuyerOfferXref x
                                join tblBuyers b on b.BuyerID = x.BuyerID
                                join tblOffers o on o.OfferID = x.OfferID
                                join tblDeliveryMethod d on d.BuyerOfferXrefID = x.BuyerOfferXrefID
	                                and d.PostUrl like 'http%'
                                where x.Active = 1
	                                and x.CallCenter = 0
                                order by [contract]">
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>
            
                    </td>
                    <td>
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" />
                    </td>
                </tr>
            </table></td>
                    <td valign="top">      
                        <div style="padding:7px; width:400px; overflow:auto">
                            <asp:Label ID="lblResponse" runat="server"></asp:Label>
                        </div>
                    </td>
                </tr>
            </table>
            <div style="font-size:smaller">
                Note: Seeded posts are not logged.
            </div>
            <hr />
            <h2>Active Online Offers</h2>
            <asp:DataList ID="dlOffers" runat="server" RepeatColumns="2" RepeatDirection="Vertical" DataSourceID="ds_Offers" Width="800px">
                <ItemTemplate>
                    <%#Container.ItemIndex + 1%>. <a href='<%# Eval("OfferLink") %>' target="_blank"><%# Eval("offer")%></a>
                </ItemTemplate>
            </asp:DataList>
            <div style="height:15px"></div>
            <asp:SqlDataSource ID="ds_Offers" runat="server" ConnectionString="<%$ connectionStrings:IDENTIFYLEDB %>" SelectCommandType="Text" SelectCommand="
                select o.offerid, a.name + ' - ' + o.Offer [offer], o.OfferLink
                from tblOffers o
                join tblAdvertiser a on a.AdvertiserID = o.AdvertiserID
                where o.Active = 1
	                and o.CallCenter = 0
	                and o.Tag = 'Online'
	                and LEN(o.offerlink) > 1 order by [offer]"></asp:SqlDataSource>
        </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>