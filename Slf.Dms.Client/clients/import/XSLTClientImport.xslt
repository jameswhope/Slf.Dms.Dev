<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes">
	
		<xsl:template match="Summary">
		<html>
			<head>
				<script type="text/javascript">
					function ShowDetails(Name)
					{
					<xsl:call-template name="Clients"/>;
					}
				</script>
					<title>Imported Clients</title>
			</head>
			<body>
				<table id="rptHeader" cols="1"  style="width:100%; font-family:Tahoma; font-size:18px; font-weight:bold" align="center">
					<tr>
						<td>
							<b>
								<u>Client Import Report</u>
							</b>
							<br/>
							<br/>
						</td>
					</tr>
				</table>
				<table width="100%" cols="2" style="font-family:Tahoma; font-size:14px; font-weight:bold">
					<tr>
						<td Width="200" style="font-family:Tahoma; font-size:14px; font-weight:bold">
							<b>Report Date:</b>
						</td>
						<td style="font-family:Tahoma; font-size:14; font-weight:normal">
							<xsl:value-of select ="//ReportDate"/>
						</td>
					</tr>
					<tr>
						<td  Width="200" style="font-family:Tahoma; font-size:14px; font-weight:bold">
							<b>Total clients processed:</b>
						</td>
						<td style="font-family:Tahoma; font-size:14; font-weight:normal">
							<xsl:value-of select ="//TotalCount"/>
						</td>
					</tr>
					<tr>
						<td Width="200" style="font-family:Tahoma; font-size:14px; font-weight:bold">
							<b>CheckSite Accounts:</b>
						</td>
						<td style="font-family:Tahoma; font-size:14; font-weight:normal">
							<xsl:value-of select ="//CkSiteCount"/>
						</td>
					</tr>
					<tr>
						<td Width="200" style="font-family:Tahoma; font-size:14px; font-weight:bold">
							<b>Upload results:</b>
						</td>
						<td style="color:red; font-weight:normal; font-family:Tahoma; font-size:14;">
							<xsl:value-of select="//Results"/>
						</td>
					</tr>
				</table>
				<table width="100%" cols="1" style="font-family:Tahoma; font-size:14px; font-weight:bold">
					<br/>
					<br/>
					<td  width="200" style="font-weight:normal; font-family:Tahoma; font-size:14;">
						Details below:
					</td>
				</table>
				<table width="100%" cols="1" style="font-family:Tahoma; font-size:12px; font-weight:normal">
					<td>
						<xsl:call-template name="Clients"/>
					</td>
				</table>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="Client" name="Clients">
		<table id="ImportList" cols="4" border="1" style="width:100%; font-family:Tahoma; font-size:16px; font-weight:bold" align="left" title="Clients Imported">
			<tr>
				<td width="80" border="2" bordercolor="blue" style="font-family:Tahoma; font-size:12">
					Import Date
				</td>
				<td width="125" border="2" bordercolor="blue" style="font-family:Tahoma; font-size:12">
					Client Name
				</td>
				<td width="100" border="2" bordercolor="blue" style="font-family:Tahoma; font-size:12">
					Banking Info
				</td>
				<td width="100" border="2" bordercolor="blue"  style="font-family:Tahoma; font-size:12">
					Deposit Method
				</td>
			</tr>
			<xsl:for-each select="Client">
				<xsl:variable name="ImportDate" select="Date_x0020_Received"/>
						<tr>
							<td width="80" style="font-family:Tahoma; font-size:12; font-weight:normal">
								<xsl:value-of select="ms:format-date($ImportDate, 'MMM dd, yyyy')"/>
							</td>
							<td width="125" style="font-family:Tahoma; font-size:12; font-weight:normal">
								<xsl:value-of select="Last_x0020_Name"/><xsl:value-of select="First_x0020_Name"/>
							</td>
							<td width="100" style="font-family:Tahoma; font-size:12; font-weight:normal">
									<xsl:value-of select="Banking_x0020_Type"></xsl:value-of>
							</td>
							<td width="100" style="font-family:Tahoma; font-size:12; font-weight:normal">
								<xsl:value-of select="Payment_x0020_Type"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:template>

</xsl:stylesheet> 

