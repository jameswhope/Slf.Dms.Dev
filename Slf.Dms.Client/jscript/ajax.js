// JScript File

function Ajax_String(url, request, async, fncReceived)
{
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    
    if (async && fncReceived != null)
    {
        xmlhttp.onreadystatechange = function()
        {
            if (xmlhttp.readyState == 4)//done
            {
                fncReceived(xmlhttp.responseText);
            }
        }
    }
    
    xmlhttp.open("POST", url, async);
    xmlhttp.setRequestHeader("content-type", "application/x-www-form-urlencoded");
    xmlhttp.send(request);
        
    if (async == false)
        return xmlhttp.responseText;
} 