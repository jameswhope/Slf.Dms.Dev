<%@ Control Language="VB" AutoEventWireup="false" CodeFile="dateBarControl.ascx.vb"
    Inherits="usercontrols_dateBarControl" %>
    
<script type="text/javascript">
    $(function() {
        $("*[id$='txtDate1']").datepicker({ dateFormat: 'm/d/yy' });
        $("*[id$='txtDate2']").datepicker({ dateFormat: 'm/d/yy' });
    });
	</script>
    
    
<script language="javascript" type="text/javascript">
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
     
    </script>    


<div>
    <b class="rndBoxBlue"><b class="rndBoxBlue1"><b></b></b><b class="rndBoxBlue2"><b></b>
    </b><b class="rndBoxBlue3"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue5"></b>
    </b>
    <div class="rndBoxBluefg">
        <!-- content goes here -->
        <table style="width: 100%;" >
    <tr>
        <td>
            <asp:Label ID="lblSurveyName" runat="server" Text="Survey Name:" Font-Bold="true" Font-Size="12pt" ForeColor="white" />
            <asp:DropDownList ID="ddlSurvey" runat="server" Font-Size="12pt" AutoPostBack="True"
                DataSourceID="dsSurvey" DataTextField="description" DataValueField="surveyid">
            </asp:DropDownList>
              <asp:SqlDataSource ID="dsSurvey" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
        SelectCommand="select surveyid,description from tblsurvey union select -1,'ALL'"></asp:SqlDataSource>
             <asp:DropDownList ID="ddlSites" runat="server" Font-Size="12px" DataSourceID="dsSites"
                DataTextField="SiteName" DataValueField="SiteID">
                <asp:ListItem Text="localdreamjobs.com"></asp:ListItem>
                <asp:ListItem Text="landmyjob.com"></asp:ListItem>
                <asp:ListItem Text="joblanded.com"></asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="dsSites" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="SELECT [SiteID], [SiteName] FROM [tblSites]"></asp:SqlDataSource>
            <asp:DropDownList ID="ddlQuickPickDate" runat="server" Font-Size="12pt">
            </asp:DropDownList>
            <asp:TextBox ID="txtDate1" runat="server" Size="10" MaxLength="10" Font-Size="12pt"></asp:TextBox>&nbsp;-&nbsp;
            <asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="10" Font-Size="12pt"></asp:TextBox>
        </td>
        <td>
            <small>
                <asp:Button ID="btnExport" runat="server" Text="Export Excel" Font-Size="10pt" OnClientClick="return ExportExcel();"
                    CssClass="jqButton" Style="float: right!important" />
                <asp:Button ID="btnApply" runat="server" Text="Apply" Font-Size="10pt" CssClass="jqButton"
                    Style="float: right!important" />
            </small>
        </td>
    </tr>
</table>
    </div>
    <b class="rndBoxBlue"><b class="rndBoxBlue5"></b><b class="rndBoxBlue4"></b><b class="rndBoxBlue3">
    </b><b class="rndBoxBlue2"><b></b></b><b class="rndBoxBlue1"><b></b></b></b>
</div>

    

