<%@ Page Language="VB" AutoEventWireup="false" CodeFile="coverPage.aspx.vb" Inherits="Clients_Enrollment_creditpackage_coverPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #container{padding:20px 30px; text-align:center;}
        h2{font-size: 35px;}
        h3{font-size: 28px;}
        h4{font-size: 24px;}
        .client{text-decoration:underline;}
        p{margin-top: 300px;font-size: 12px;}
        img{margin:30px 0px 40px 0px;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="container">
        <h2>
            THOMAS KERNS MCKNIGHT, LLP</h2>
        <img src="http://service.lexxiom.com/images/Logos/tkmLogo.jpg" alt="Thomas Kerns McKnight Logo" />
        <h3>
            PERSONALIZED DEBT REVIEW</h3>
        <h4>
            PREPARED EXCLUSIVELY FOR:</h4>
        <h4 class="client">
            <asp:label ID="clientsname" runat="server" /></h4>
            <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
        <p>
            *DISCLAIMER:The information enclosed within this documnet is for educational purposes
            only and does not constitute legal advice. It is only as accurate and comprehensive
            as the information propvided by you upon consultation with representatives of Thomas
            Kerns McKnight, LLP. etc.</p>
    </div>
    </form>
</body>
</html>
