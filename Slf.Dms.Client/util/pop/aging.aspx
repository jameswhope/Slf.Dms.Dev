<%@ Page Language="VB" AutoEventWireup="false" CodeFile="aging.aspx.vb" Inherits="util_pop_aging" %>

<%@ Register assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebGrid" tagprefix="igtbl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">
    <title>Add/Update Aging Days</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
    </head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
   <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager> 
                <td style="padding-left: 15px; height: 100%; width: 100%" valign="top">
                    <table border="0" cellpadding="0" cellspacing="7"
                        style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;">
                        <tr>
                            <td colspan="4" width="100%">
                                You can modify/delete existing or add new aging days by clicking the 
                                Add/Update button below. To delete a row just select that row and hit delete on 
                                your keyboard.<br />
                                <br />
                                For example: If you select 30 days on your Lead Assignment page, then the Lead Assignment page 
                                will only show those clients created within the past 30 days that meet all your 
                                other criteria.<br />
                                <br />
                                </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="4" width="100%">
                                <igtbl:UltraWebGrid ID="grdAging" runat="server">
                                    <bands>
                                        <igtbl:UltraGridBand>
                                            <addnewrow view="NotSet" visible="NotSet">
                                            </addnewrow>
                                        </igtbl:UltraGridBand>
                                    </bands>
                                    <displaylayout 
                                        allowdeletedefault="Yes" 
                                        allowupdatedefault="Yes" bordercollapsedefault="Separate" name="grdAging" 
                                        rowheightdefault="20px" rowselectorsdefault="No" 
                                        tablelayout="Fixed" version="4.00" 
                                        viewtype="Flat" allowaddnewdefault="Yes">
                                        <framestyle 
                                            borderstyle="Solid" borderwidth="1px" font-names="Verdana" 
                                            font-size="8pt">
                                        </framestyle>
                                        <pager AllowPaging="False" ChangeLinksColor="True" PageSize="6">
                                            <PagerStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                                                widthtop="1px" />
                                            </PagerStyle>
                                        </pager>
                                        <editcellstyledefault borderstyle="None" borderwidth="0px" Cursor="Text">
                                        </editcellstyledefault>
                                        <footerstyledefault backcolor="LightGray" borderstyle="Solid" borderwidth="1px">
                                            <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                                                widthtop="1px" />
                                        </footerstyledefault>
                                        <headerstyledefault backcolor="LightGray" borderstyle="Solid">
                                            <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                                                widthtop="1px" />
                                        </headerstyledefault>
                                        <rowstyledefault backcolor="White" bordercolor="Gray" borderstyle="Solid" 
                                            borderwidth="1px" font-names="Verdana" font-size="8pt" Cursor="Text">
                                            <padding left="3px" />
                                            <borderdetails colorleft="White" colortop="White" />
                                        </rowstyledefault>
                                        <groupbybox>
                                            <boxstyle backcolor="ActiveBorder" bordercolor="Window">
                                            </boxstyle>
                                        </groupbybox>
                                        <addnewbox hidden="False" Prompt="" View="Compact" Location="Bottom">
                                            <ButtonStyle Cursor="Hand" BackgroundImage="" 
                                                Height="6px" Width="8px">
                                            </ButtonStyle>
                                            <boxstyle backcolor="White" borderstyle="Solid" 
                                                borderwidth="1px" Cursor="Default">
                                                <borderdetails colorleft="White" colortop="White" widthleft="1px" 
                                                    widthtop="1px"  />
                                            </boxstyle>
                                        </addnewbox>
                                        <activationobject bordercolor="" borderwidth="">
                                        </activationobject>
                                        <RowExpAreaStyleDefault Cursor="Text">
                                        </RowExpAreaStyleDefault>
                                        <AddNewRowDefault Visible="Yes">
                                            <RowStyle Cursor="Text" />
                                        </AddNewRowDefault>
                                        <filteroptionsdefault>
                                            <filterdropdownstyle backcolor="White" bordercolor="Silver" borderstyle="Solid" 
                                                borderwidth="1px" customrules="overflow:auto;" 
                                                font-names="Verdana,Arial,Helvetica,sans-serif" font-size="11px" 
                                                height="300px">
                                                <padding left="2px" />
                                            </filterdropdownstyle>
                                            <filterhighlightrowstyle backcolor="#151C55" forecolor="White">
                                            </filterhighlightrowstyle>
                                        </filteroptionsdefault>
                                    </displaylayout>
                                </igtbl:UltraWebGrid>
                            </td>
                        </tr>
                    </table>
                </td>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:78%; font-family:tahoma;font-size:11px;width:100%;" 
                        border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="middle"/>Cancel and Close</a></td>
                        </tr>
                    </table>
                </td>
           </tr>
    </form>
</body>
</html>
