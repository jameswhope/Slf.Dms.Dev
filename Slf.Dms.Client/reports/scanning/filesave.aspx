<%@ language="vbscript" %>
<%
  'Set Upload = Server.CreateObject("csASPUpload.Process")
  Dim Upload
  Upload = Server.CreateObject("csASPUploadTrial.Process")
%>
<html>
<head>
    <title>Saving file</title>
</head>

<body>
<%
  'OverwriteMode = 2 renames the file ~1, ~2 etc if name already exists

  Upload.OverwriteMode = 2
  Upload.FileSave(Upload.CurrentDir & Upload.FileName(0), 0)

%>
</body>
</html>