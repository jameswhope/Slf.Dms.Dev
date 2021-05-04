<%@ Page Language="VB" AutoEventWireup="false" CodeFile="report.aspx.vb" Inherits="clients_client_reports_Report" title="DMP - Client - Reports" %>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title></title>
        <script type="text/javascript">
            function OpenDocument(path) {
                window.open(path);
            }
        </script>
    </head>
    
	<body style="background-color:#000000;opacity:.7;MozOpacity:.7;filter:alpha(opacity=70);overflow:hidden;" onload="arv_ControlLoaded()">
	    <form id="ActiveXExport" method="post" runat="server" />
	    <object id="arv" codebase="arview2.cab#version=2.4.1.1283" height="100%" width="100%" classid="clsid:8569D715-FF88-44BA-8D1D-AD3E59543DDE" viewastext>
	        <param name="_ExtentX" value="26141" />
	        <param name="_ExtentY" value="11959" />
        </object>        

        <script type="text/javascript">

        function arv_ControlLoaded() {
            document.getElementById("arv").DataPath = "viewer.ashx";
            document.getElementById("arv").Zoom = 75;
        }

        function arv_ToolbarClick(Tool) {
            If(Tool.Caption === "&Print...") 
                location.href = "/pdfexport.ashx";
            
        }

        </script>

<%--        <script type="text/javascript" for="arv" event="ControlLoaded">

            return arv_ControlLoaded();

        </script>--%>
        <%--<script type="text/vbscript">
            Sub arv_ControlLoaded()
                arv.DataPath = "viewer.ashx"
                arv.Zoom = 75
                
            End Sub
            
            Sub arv_ToolbarClick(Tool)
                If Tool.Caption = "&Print..." Then
                    'arv.PrintReport(False)
                    Location.HREF = "pdfexport.ashx"
                End If
            End Sub
        </script>--%>
	</body>
</html>