<%@ Page Language="VB" AutoEventWireup="false" CodeFile="progress.aspx.vb" Inherits="util_upload_progress" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >

<html>
	<head>
		<style type="text/css">
			body, div { font-family:tahoma;font-size:11px; }
			#statusMessage { color:blue }
			#progressDisplay {display:none}
			#uploadSuccess {display:none}
			#uploadErrored {display:none}
			#progressDisplayTable {display:none;font-size:100%;color:#666666;}
			#progressContainer
			{
				border:solid 1px rgb(51,118,171); /* #008000; */
				height:15px;
				width:100%;
			}

			#progressBar
			{
				background-color: rgb(214,231,243); /* #00aa00; */
				margin:1px;
				height:13px;
			}			
		</style>		
		<script type="text/javascript">
			var STATUS_INITIALIZING = 0;
			var STATUS_UPLOADING = 1;
			var STATUS_COMPLETE = 2;
			
			var currentUploadStatus;
			
			var progressDisplayTable;
			var updateStatus;
			var uploadSize;
			var uploadRemainingSize;
			var uploadTime;
			var uploadRemainingTime;
			var progressBar;
			
			var doc;
			var progressContainerWidth;

            function QueryString(key)
            {
                var tmp = unescape(window.top.location.search.substring(1));
                var i = tmp.toUpperCase().indexOf(key.toUpperCase() + "=");

                if (i >= 0)
                {
	                tmp = tmp.substring(key.length + i + 1);
	                i = tmp.indexOf("&");

	                return (tmp = tmp.substring(0, (i >= 0) ? i : tmp.length));
                }

                return("");
            }
			function startUpload()
			{
				document.uploadComplete = false;
				document.uploadId = QueryString("uploadId");
				currentUploadStatus = STATUS_INITIALIZING;
				
				progressDisplayTable = document.getElementById("progressDisplayTable");
				updateStatus = document.getElementById("uploadStatus");
				updateStatus = document.getElementById("uploadStatus");
				uploadSize = document.getElementById("uploadSize");
				uploadRemainingSize = document.getElementById("uploadRemainingSize");			
				uploadTime = document.getElementById("uploadTime");			
				uploadRemainingTime = document.getElementById("uploadRemainingTime");			
				progressBar = document.getElementById("progressBar");

				var progressDisplay = document.getElementById("progressDisplay");
				progressDisplay.style.display = "block";

				var progressContainer = document.getElementById("progressContainer");
				progressContainerWidth = progressContainer.offsetWidth;
				
				// Clear the displays
				uploadSize.innerHTML = "";
				uploadRemainingSize.innerHTML = "";
				uploadTime.innerHTML = "";
				uploadRemainingTime.innerHTML = "";
				progressBar.style.width = 0;

				uploadStatus.innerHTML = "Initializing";

				//doc = Sarissa.getDomDocument();
				//doc.async = false;

	            doc = new ActiveXObject("Microsoft.XMLDOM");
	            doc.async = false;

				progressUpdate();
			}

			function progressUpdate()
			{
		        doc.load("<%= ResolveUrl("~/util/upload/uploadprogress.ashx?uploadId=") %>" + document.uploadId);

				var isError = false;
		        var el = doc.getElementsByTagName("uploadStatus")[0];

		        if (el != null && el.attributes.length > 0)
				{
					var state = el.attributes.getNamedItem("state").value;

					if (state == "ReceivingData")
					{
						uploadSize.innerHTML = el.attributes.getNamedItem("contentLengthText").value;

						uploadRemainingSize.innerHTML = el.attributes.getNamedItem("transferredLengthText").value;

						uploadTime.innerHTML = el.attributes.getNamedItem("elapsedTimeText").value;

						uploadRemainingTime.innerHTML = el.attributes.getNamedItem("remainingTimeText").value;

						var positionRaw = el.attributes.getNamedItem("positionRaw").value;
						var contentLengthRaw = el.attributes.getNamedItem("contentLengthRaw").value;

						progressBar.style.width = (positionRaw / contentLengthRaw) * progressContainer.offsetWidth;

						if (currentUploadStatus == STATUS_INITIALIZING)
						{
							uploadStatus.innerHTML = "In progress";
							progressDisplayTable.style.display = "block";
							
							currentUploadStatus = STATUS_UPLOADING;
						}
					}
					else
					{
						var uploadError = document.getElementById("uploadError");
						
						switch (state)
						{
							case "Error":
								uploadError.innerHTML = "Error uploading file.";
								
								//break;
							case "ErrorMaxRequestLengthExceeded":
								uploadError.innerHTML = "Error uploading file. Maximum request length exceeded.";
							
								uploadError.style.display = "block";
																
								isError = true;
								//break;
						}

						document.uploadComplete = true;
					}
				}

				if (document.uploadComplete)
				{
					if (!isError)
					{
						var uploadSuccess = document.getElementById("uploadSuccess");
						uploadSuccess.style.display = "block";
					}
						
					var progressDisplay = document.getElementById("progressDisplay");
					progressDisplay.style.display = "none";
					
					currentUploadStatus = STATUS_COMPLETE;
				}

				if (currentUploadStatus != STATUS_COMPLETE)
					window.setTimeout("progressUpdate()", 1000);
			}
		</script>
		
	</head>
	<body onload="startUpload();">
		<form name="Form1" method="post" action="progress.aspx" id="Form1">
			<div id="progressDisplay">
				<div style="display:none;">Upload status: <i id="uploadStatus">Initializing</i></div>
				<table id="progressDisplayTable" border="0" cellpadding="1" width="100%">
					<tr>
						<td>
							<div id="progressContainer"><div id="progressBar"></div></div>
						</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:5;">Size:&nbsp;<span id="uploadRemainingSize"></span>&nbsp;/&nbsp;<span id="uploadSize"></span></td>
					</tr>
					<tr>
						<td align="center">Time:&nbsp;<span id="uploadTime"></span>&nbsp;/&nbsp;<span id="uploadRemainingTime"></span></td>
					</tr>
				</table>
			</div>
			<div id="uploadError">
				
			</div>
			<div id="uploadSuccess" style="text-align:center;">
				The upload has completed successfully.
			</div>
		</form>
	</body>
</html>