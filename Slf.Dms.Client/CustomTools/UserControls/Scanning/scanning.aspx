<%@ Page Language="VB" AutoEventWireup="false" CodeFile="scanning.aspx.vb" Inherits="CustomTools_UserControls_Scanning_scanning" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Scan Documents</title>
</head>

<body style="text-align:center;">
    <form id="form1" runat="server">
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
            /*var dvFloater = document.getElementById('dvFloater');
            dvFloater.style.width = screen.width;
            dvFloater.style.filter = 'alpha(opacity=0)';
            
            intFocus = setInterval('RegainFocus()', 50);*/
            
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
                window.focus();
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
            
            scanner.CurrentTwainDevice = useDevice;
            scanner.ShowTwainProgress = true;
            scanner.Zoom = 36;
            scanner.ScaleToGray = true;
            scanner.TwainMultiImage = true;
            scanner.Resample = true;
            scanner.UseSelection = true;
            scanner.TwainDuplexEnabled = true;
        }
        
        function ScanDocument()
        {
            if (hasScanner)
            {
                clearInterval(intFocus);
                scanner.TwainMultiImage = true;
                scanner.UseADF = true;
                scanner.TwainImagesToRead = 50;
                scanner.BlankTol = 250;
                scanner.ClearPDF();
                Pages = new Array();
                scanner.UseTwainInterface = false;
                ImageCount = 0;
                scanner.Acquire();
                CurrentImage = ImageCount;
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
            
            var ddlDocType = document.getElementById('<%=ddlDocType.ClientID %>');
            
            if (ddlDocType.value == 'SELECT')
            {
                ShowMessage('Please select a document type!');
                AddBorder(ddlDocType);
                ddlDocType.focus();
                
                return;
            }
            else
            {
                if (ddlDocType.innerHTML.indexOf('Please select a document type!') > -1)
                {
                    HideMessage();
                }
                
                RemoveBorder(ddlDocType);
            }
            
            for (i = 1; i < ImageCount + 1; i++)
            {
                scanner.ReadBinary(0, Pages[i]);
                scanner.AddToPDF(0);
            }
            
            CurrentImage = ImageCount;
            
            scanner.WritePDF('\\\\Nas02\\ScanTemp\\<%=RelationType %>_<%=RelationID %>_<%=UserID %>.pdf');
            
            HideMessage();
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
        
        function Cancel()
        {
            allowed = true;
            window.close();
        }
        
        function OnAcquire()
        {
            if (!scanner.IsBlank)
            {
                scanner.Redraw();
                ImageCount += 1;
                Pages[ImageCount] = scanner.WriteBinary(0);
            }
            
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
    
    <script language="javascript" for="csxi" event="OnAcquire">
        OnAcquire();
    </script>
    
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;vertical-align:middle;text-align:center;" border="0" cellpadding="0" cellspacing="5">
        <tr>
            <td>
                <asp:Label ID="lblNote" BorderColor="#969696" BorderStyle="solid" BorderWidth="1px" Font-Size="11px" ForeColor="red" Font-Names="Tahoma" BackColor="#ffffda" Width="100%" runat="server" />
            </td>
        </tr>
        <tr style="width:100%;height:100%;">
            <td>
                <table style="font-family:tahoma;font-size:11px;width:620px;height:100%;vertical-align:middle;text-align:center;word-wrap:normal;" border="0" cellpadding="0" cellspacing="5">
                    
                    <tr>
                        <td align="left">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:PreviousImage();"><img id="Img1" style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_selector_prev.png" align="absmiddle"/>Previous</a>
                        </td>
                        <td colspan="2">
                            Received:&nbsp;<cc1:InputMask class="entry" ID="txtDate" Mask="nn/nn/nnnn" width="65px" height="18px" runat="server" />
                        </td>
                        <td align="right">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:NextImage();">Next<img id="Img2" style="margin-left:8px;" border="0" runat="server" src="~/images/16x16_selector_next.png" align="absmiddle"/></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" nowrap="nowrap" >
                            Document Type:&nbsp;<asp:DropDownList ID="ddlDocType" Font-Names="Tahoma" Font-Size="11px" runat="server" />
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:ScanDocument();"><img id="Img7" style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_dataentrytype.png" align="absmiddle"/>Scan Document</a>
                        </td>
                        <td colspan="5">
            </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:RotateLeft();"><img id="Img3" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_rotate_left.png" align="absmiddle"/>Rotate Left</a>
                        </td>
                        <td>
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:SelectArea();"><img id="Img4" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_cross.png" align="absmiddle"/>Select Area</a>
                        </td>
                        <td>
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:Crop();"><img id="Img5" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_crop.png" align="absmiddle"/>Crop</a>
                        </td>
                        <td>
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:SaveDocument();"><img id="Img8" style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_save_new.png" align="absmiddle"/>Save Document</a>
                        </td>
                        <td align="right">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:RotateRight();">Rotate Right<img id="Img6" style="margin-left:8px;" border="0" runat="server" src="~/images/24x24_rotate_right.png" align="absmiddle"/></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <OBJECT CLASSID="clsid:5220cb21-c88d-11cf-b347-00aa00a28331"><PARAM NAME="LPKPath" VALUE="csximage.lpk"></OBJECT>
                            <OBJECT ID="csxi" CLASSID="clsid:62E57FC5-1CCD-11D7-8344-00C1261173F0" CODEBASE="csximage.cab"  width="627px" height="420px" border="1px solid black"></OBJECT>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>    
    <asp:LinkButton ID="lnkSave" runat="server" />
    </form>
</body>
</html>
