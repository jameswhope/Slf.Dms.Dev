<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mobile_test.aspx.vb" Inherits="public_mobile_test" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>Digital Signature</title>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.0/themes/south-street/jquery-ui.css" rel="stylesheet">
<link href="../css/jquery.signature.css" rel="stylesheet">
<style>
.kbw-signature { width: 400px; height: 200px; }
</style>
<!--[if IE]>
<script src="../jscript/excanvas.js"></script>
<![endif]-->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.0/jquery-ui.min.js"></script>
<script src="../jquery/jquery.signature.min.js"></script>
<script>
$(function() {
	$('#sig').signature();
	$('#clear').click(function() {
		$('#sig').signature('clear');
	});
	$('#json').click(function() {
		alert($('#sig').signature('toJSON'));
	});
	$('#svg').click(function() {
		alert($('#sig').signature('toSVG'));
	});
});
</script>
    <style>
        body:before {
          content: "";
          display: block;
          position: fixed;
          left: 0;
          top: 0;
          width: 100%;
          height: 100%;
          z-index: -10;
          -webkit-background-size: cover;
          -moz-background-size: cover;
          -o-background-size: cover;
          background-size: cover;
        }

    </style>
</head>
<body>
<h1>Digital Signature</h1>
<%--<p>This page demonstrates the very basics of the
	<a href="http://keith-wood.name/signature.html">jQuery UI Signature plugin</a>.
	It contains the minimum requirements for using the plugin and
	can be used as the basis for your own experimentation.</p>
<p>For more detail see the <a href="http://keith-wood.name/signatureRef.html">documentation reference</a> page.</p>--%>
<p>Default signature:</p>
<div id="sig"></div>
<p style="clear: both;"><button id="clear">Clear</button> 
	<button id="json">To JSON</button> <button id="svg">To SVG</button></p>
</body>
</html>
