<%@ Page Language="VB" AutoEventWireup="true" CodeFile="scanning.aspx.vb" Inherits="processing_popups_scanning" title="Scan Document" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Scan Checks</title>
<style>
/*Ajax toolkit */
.MyCalendar .ajax__calendar_header {height:20px;width:100%;background-color:#b0c4de}
.MyCalendar .ajax__calendar_today {cursor:pointer;padding-top:3px; background-color:#b0c4de}


.MyCalendar .ajax__calendar_container {border:1px solid #646464;background-color: white;color: black; z-index:9999}
.MyCalendar .ajax__calendar_other .ajax__calendar_day,.MyCalendar .ajax__calendar_other .ajax__calendar_year {color: gray;}
.MyCalendar .ajax__calendar_hover .ajax__calendar_day,.MyCalendar .ajax__calendar_hover .ajax__calendar_month,.MyCalendar .ajax__calendar_hover .ajax__calendar_year{color: black;}
.MyCalendar .ajax__calendar_active .ajax__calendar_day,.MyCalendar .ajax__calendar_active .ajax__calendar_month,.MyCalendar .ajax__calendar_active .ajax__calendar_year {color: black;font-weight:bold;background-color:#b0c4de;}

</style>
<base target="_self" /> 
</head>
<body style="text-align:center;">

    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="smScanning" runat="server" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript"> 
    
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
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
                //window.location.href = curURL;
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
            
            scanner.attachEvent('onAcquire', OnAcquire);
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
                scanner.AddToPDF(0);
            }
            
            CurrentImage = ImageCount;
            
            scanner.WritePDF('<%= UserScanFolder %>\\<%=UserScanFile %>.pdf');
            
            HideMessage();
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            
        }
        
        function Cancel()
        {
            allowed = true;
            window.close();
        }
        
        function CloseStipulation()
        {
            allowed = true;
            if (window.parent.currentModalDialog) {
                window.parent.currentModalDialog.modaldialog("returnValue", -1);
             } else {
                window.returnValue ="-1";
             }
            window.close();
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
	    
	    function calendarShown(sender, args)
        {
            document.getElementById("csxi").style.visibility = "hidden";
        }
        
        function calendarHidden(sender, args)
        {
            document.getElementById("csxi").style.visibility = "";
        }
    </script>
    
    <script language="javascript" for="csxi" event="OnAcquire">
        OnAcquire();
    </script>
    
<%--    <div id="dvFloater" style="position:absolute;left:0px;top:0px;width:100%;height:10px;background-color:black;moz-opacity:0;z-index:999;"></div>--%>
    
    <table style="font-family:tahoma;font-size:11px;width:100%; height:100%;vertical-align:middle;text-align:center;" 
        border="0" cellpadding="0" cellspacing="5">
        <tr>
            <td>
                <asp:Label ID="lblNote" BorderColor="#969696" BorderStyle="solid" BorderWidth="1px" Font-Size="11px" ForeColor="red" Font-Names="Tahoma" BackColor="#ffffda" Width="100%" runat="server" />
            </td>
        </tr>
        <tr style="width:100%;height:100%;">
            <td  align="center">
                <table style="font-family:tahoma;font-size:11px;width:620px;height:100%;vertical-align:middle;text-align:center;word-wrap:normal;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td align="left">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:PreviousImage();"><img style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_selector_prev.png" align="absmiddle"/>Previous</a>
                        </td>
                        <td colspan="2">
                            Received:&nbsp;
                            <asp:TextBox class="entry" ID="txtDate" Width="65px" Height="18px" runat="server"  />
                            <asp:ImageButton runat="Server" ID="Image1" ImageUrl="~/images/Calendar_scheduleHS.png"
                                AlternateText="Click to show calendar" ImageAlign="AbsMiddle" />
                            <ajaxToolkit:CalendarExtender ID="extDueDate" runat="server" TargetControlID="txtDate"
                                PopupButtonID="image1" CssClass="MyCalendar" OnClientShown="calendarShown" OnClientHidden="calendarHidden" />
                            
                        </td>
                        <td align="right">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:NextImage();">Next<img style="margin-left:8px;" border="0" runat="server" src="~/images/16x16_selector_next.png" align="absmiddle"/></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:RotateLeft();"><img id="Img1" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_rotate_left.png" align="absmiddle"/>Rotate Left</a>
                        </td>
                        <td>
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:SelectArea();"><img id="Img2" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_cross.png" align="absmiddle"/>Select Area</a>
                        </td>
                        <td>
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:Crop();"><img id="Img3" style="margin-right:8px;" border="0" runat="server" src="~/images/24x24_crop.png" align="absmiddle"/>Crop</a>
                        </td>
                        <td align="right">
                            <a style="color:rgb(51,118,171);" class="lnk" href="javascript:RotateRight();">Rotate Right<img id="Img4" style="margin-left:8px;" border="0" runat="server" src="~/images/24x24_rotate_right.png" align="absmiddle"/></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <object classid="clsid:5220cb21-c88d-11cf-b347-00aa00a28331">
                            <param name="LPKPath" value='<%= resolveurl("~/clients/client/csximage.lpk") %>'/>
                            </object>
                            <object ID="csxi" classid="clsid:62E57FC5-1CCD-11D7-8344-00C1261173F0" 
                                codebase='<%= resolveurl("~/clients/client/csXImage.cab") %>'  width="627px" 
                                height="350px" border="1px solid black"></object>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        <td>
        <a style="color:rgb(51,118,171);" class="lnk" href="javascript:ScanDocument();"><img style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_dataentrytype.png" align="absmiddle"/>Scan Document</a>
        <a style="color:rgb(51,118,171);" class="lnk" href="javascript:SaveDocument();"><img style="margin-right:8px;" border="0" runat="server" src="~/images/16x16_save_new.png" align="absmiddle"/>Save Document</a>
        </td>
        </tr>
    </table>    
    <asp:LinkButton ID="lnkSave" runat="server" />
</form>
</body>
</html>