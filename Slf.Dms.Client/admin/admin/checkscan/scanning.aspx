<%@ Page Language="VB" AutoEventWireup="true" CodeFile="scanning.aspx.vb" Inherits="check_scanning"
    Title="DMP - Check Scanning" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<script type="text/javascript" language="javascript">
        var scanner;
        var hasScanner;
        var Pages = new Array();
        var ImageCount;
        var CurrentImage;
        var intFocus;
        var curURL;
        var allowed;
        
        window.onload = function ()
        {
           
            if (document.getElementById('<%=lblNote.ClientID %>').innerText.length == 0)
            {
                HideMessage();
            }
            
            Initialization();
            
            window.resizable = false;
            
            curURL = window.location.href;
            allowed = false;
            
            document.getElementsByTagName('form')[0].onsubmit = function ()
            {
                allowed = true;
            }
        }
        
        window.onunload = function ()
        {
            if (allowed == false)
            {
                window.location.href = curURL;
            }
        }
        
        function RegainFocus()
        {
            if (!document.hasFocus())
            {
                
            }
        }
        
        function Initialization()
        {
            var useDevice = -1;
            
            pages = new Array();
            
            scanner = document.getElementById('csxi');
            ImageCount = 0;
            
            for (var i = 0; i < scanner.TwainDeviceCount && useDevice < 0; i++)
            {
                if (scanner.TwainDeviceName(i).indexOf('Xerox DocuMate 152') == 0)
                {
                    useDevice = i;
                }
            }
            
            if (useDevice == -1)
            {
                hasScanner = false;
                ShowMessage('Could not locate scanner!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a style="color:rgb(51,118,171);" class="lnk" href="javascript:Initialization();">Locate Scanner</a>');
                return;
            }
            else
            {
                if (document.getElementById('<%=lblNote.ClientID %>').innerHTML.indexOf('Could not locate scanner!') > -1)
                {
                    HideMessage();
                }
                
                hasScanner = true;
            }
            

            scanner.attachEvent('onAcquire', OnAcquire);
            scanner.TwainUnits = 0;
            scanner.TwainResolution = 200;
            scanner.CurrentTwainDevice = useDevice;
            scanner.ShowTwainProgress = true;
            scanner.Zoom = 36;
            scanner.TwainPixelType  = 1; 
            scanner.ScaleToGray = true;
            scanner.TwainMultiImage = true;
            scanner.Resample = true;
            scanner.UseSelection = true;
            scanner.TwainDuplexEnabled = true;
            scanner.UseTwainInterface = false;
            scanner.UseADF = true;
        }
        
        function ScanDocument()
        {
            if (hasScanner)
            {
                scanner.TwainImagesToRead = 50;
                scanner.BlankTol = 1;
                scanner.cleartif();
                scanner.TwainMultiImage = true;
                Pages = new Array();
                ImageCount = 0;
                CurrentImage = ImageCount;
                scanner.Acquire();
                
            }
        }
        
        function NextImage()
        {
            if (CurrentImage < ImageCount)
            {
                CurrentImage += 1;
                scanner.ReadBinary(0, Pages[CurrentImage]);
                scanner.Redraw();
            }
        }
        
        function PreviousImage()
        {
            if (CurrentImage > 1)
            {
                CurrentImage -= 1;
                scanner.ReadBinary(0, Pages[CurrentImage]);
                scanner.Redraw();
            }
        }
        
        function RotateLeft()
        {
            scanner.Rotate(90);
            Pages[CurrentImage] = scanner.WriteBinary(0);
        }

        function RotateRight()
        {
            scanner.Rotate(270);
            Pages[CurrentImage] = scanner.WriteBinary(0);
        }
        
        function SelectArea()
        {
            scanner.MouseSelectRectangle();
            Pages[CurrentImage] = scanner.WriteBinary(0);
        }
        
        function Crop()
        {
            scanner.CropToSelection();
            Pages[CurrentImage] = scanner.WriteBinary(0);
        }
        
        function SaveDocument()
        {
            if (hasScanner == false)
            {
                ShowMessage('Please connect a valid scanner...');
                return;
            }
            
            if (ImageCount <= 0)
            {
                ShowMessage('No scans available!');
                return;
            }
            
            var txtDate = document.getElementById('<%=txtDate.ClientID %>');
            var today = new Date();
            var received = new Date();
            
            received.setFullYear(txtDate.value.substring(6, 10), txtDate.value.substring(0, 2) - 1, txtDate.value.substring(3, 5));
            
            if (!IsDate(txtDate.value) || received > today)
            {
                ShowMessage('Invalid received date!');
                AddBorder(txtDate);
                txtDate.focus();
                
                return;
            }
            else
            {
                if (document.getElementById('<%=lblNote.ClientID %>').innerHTML.indexOf('Invalid received date!') > -1)
                {
                    HideMessage();
                }
                
                RemoveBorder(txtDate);
            }
            
            for (i = 1; i < ImageCount + 1; i++)
            {
                scanner.ReadBinary(0, Pages[i]);
                scanner.AddToTIF(0);
            }
            
            CurrentImage = ImageCount;
            
            scanner.WriteTIF('<%= UserScanFolder %>\\<%=UserScanFile %>.tif');
            
            HideMessage();
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            
            CloseDocument();
	     
        }
         function CloseDocument(){
		     window.parent.ClosePopup();
	    }
        
        function Cancel()
        {
            allowed = true;
            window.close();
        }
        
        function OnAcquire()
        {
                scanner.Redraw();
                ImageCount += 1;
                Pages[ImageCount] = scanner.WriteBinary(0);
           
            intFocus = setInterval('RegainFocus()', 50);
        }
        
        function ShowMessage(Value)
	    {
	        var lblNote = document.getElementById('<%=lblNote.ClientID %>');

	        lblNote.style.visibility = 'visible';
	        lblNote.innerHTML = Value;
	    }
	    
	    function HideMessage()
	    {
	        var lblNote = document.getElementById('<%=lblNote.ClientID %>');

	        lblNote.innerHTML = '';
	        lblNote.style.visibility = 'hidden';
	    }

        function IsDate(dateStr)
        {
            var datePat = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
            var matchArray = dateStr.match(datePat);

            if (matchArray == null)
            {
                return false;
            }

            month = matchArray[1];
            day = matchArray[3];
            year = matchArray[5];

            if (month < 1 || month > 12)
            {
                return false;
            }

            if (day < 1 || day > 31)
            {
                return false;
            }

            if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31)
            {
                return false;
            }

            if (month == 2)
            {
                var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
                if (day > 29 || (day == 29 && !isleap))
                {
                    return false;
                }
            }
            
            return true;
        }
        
        function AddBorder(obj)
	    {
            obj.style.border = "solid 2px red";
            obj.focus();
	    }
	    
	    function RemoveBorder(obj)
	    {
            obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
	    }
    </script>
    <title>Scan Checks</title>
</head>
<body style="text-align: center;">

    

    
    <form id="form1" runat="server">
        <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%; vertical-align: middle;
        text-align: center; word-wrap: normal;" border="0" cellpadding="0" cellspacing="5">
        <tr valign="top">
            <td align="left" rowspan="3" style="width: 175px">
                <table border="0" width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height: 30px; background-color: #4791C5; color: #fff; font-weight: bold;
                            font-family: Tahoma; font-size: 14px;padding-left:5px;">
                            Received
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <cc1:InputMask class="entry" ID="txtDate" Mask="nn/nn/nnnn" Width="100px" Height="18px"
                                runat="server" />
                        </td>
                    </tr>
                         <tr>
                        <td style="height: 30px; background-color: #4791C5; color: #fff; font-weight: bold;
                            font-family: Tahoma; font-size: 14px; padding-left:5px;">
                            Actions
                        </td>
                    </tr>
                    <tr>
                        <td onclick="javascript:ScanDocument();" style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk" >
                                <img id="Img7" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_printing.png"
                                    align="absmiddle" />Scan Document</span>
                        </td>
                    </tr>
                    <tr>
                        <td onclick="javascript:SaveDocument();" style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            border-bottom: solid 1px #4791C5; padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk" >
                                <img id="Img8" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_Save.png"
                                    align="absmiddle" />Save Scan</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 30px; background-color: #4791C5; color: #fff; font-weight: bold;
                            font-family: Tahoma; font-size: 14px;padding-left:5px;">
                            Tools
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk" >
                                <img id="Img6" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_rotate_right.png"
                                    align="absmiddle" />Rotate Right</span>
                        </td>
                    </tr>
                    <tr>
                        <td onclick="javascript:RotateLeft();" style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk" >
                                <img id="Img3" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_rotate_left.png"
                                    align="absmiddle" />Rotate Left</span>
                        </td>
                    </tr>
                    <tr>
                        <td onclick="javascript:SelectArea();" style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk" >
                                <img id="Img4" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_cross.png"
                                    align="absmiddle" />Select Area</span>
                        </td>
                    </tr>
                    <tr>
                        <td onclick="javascript:Crop();" style="text-align: left; border-left: solid 1px #4791C5; border-right: solid 1px #4791C5;
                            border-bottom: solid 1px #4791C5; padding: 3px;" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <span style="color: rgb(51,118,171);" class="lnk">
                                <img id="Img5" style="margin-right: 8px;" border="0" runat="server" src="~/images/24x24_crop.png"
                                    align="absmiddle" />Crop</span>
                        </td>
                    </tr>
               
                </table>
            </td>
            <td>
                <asp:Label ID="lblNote" BorderColor="#969696" BorderStyle="solid" BorderWidth="1px"
                    Font-Size="11px" ForeColor="red" Font-Names="Tahoma" BackColor="#ffffda" Width="100%"
                    runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td onclick="return PreviousImage();" style="width:50%;" align="left" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <a style="color: rgb(51,118,171);" class="lnk" href="javascript:PreviousImage();" >
                                <img id="Img1" style="margin-right: 8px;" border="0" runat="server" src="~/images/16x16_selector_prev.png"
                                    align="absmiddle" />Previous</a>
                        </td>
                        <td onclick="return NextImage();" align="right" onmouseover="this.style.backgroundColor = '#C6DEF2';this.style.cursor='pointer'"
                            onmouseout="this.style.backgroundColor = '';this.style.cursor=''">
                            <a style="color: rgb(51,118,171);" class="lnk" href="javascript:NextImage();">Next<img
                                id="Img2" style="margin-left: 8px;" border="0" runat="server" src="~/images/16x16_selector_next.png"
                                align="absmiddle" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="vertical-align: top;">
            <td>
                <object classid="clsid:5220cb21-c88d-11cf-b347-00aa00a28331">
                    <param name="LPKPath" value="~/Clients/client/csximage.lpk"/>
                </object>
                <object id="csxi" classid="clsid:62E57FC5-1CCD-11D7-8344-00C1261173F0" codebase="~/Clients/client/csXImage.cab"
                    width="100%" height="420px" border="1px solid black">
                </object>
            </td>
        </tr>
    </table>
        <asp:LinkButton ID="lnkSave" runat="server" />
    </form>
</body>
</html>
