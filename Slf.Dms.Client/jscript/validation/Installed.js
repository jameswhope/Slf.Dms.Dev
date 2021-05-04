
var InstallAcrobat = new Object();

InstallAcrobat.Installed = false;
InstallAcrobat.Version = '0.0';

if (navigator.plugins && navigator.plugins.length)
{
    for (x = 0; x < navigator.plugins.length; x++)
    {
        if (navigator.plugins[x].description.indexOf('Adobe Acrobat') != -1)
        {
            InstallAcrobat.Version = parseFloat(navigator.plugins[x].description.split('Version ')[1]);

            if (InstallAcrobat.Version.toString().length == 1)
            {
                InstallAcrobat.Version += '.0';
            }

            InstallAcrobat.Installed = true;
            break;
        }
    }
}
else if (window.ActiveXObject)
{
    for (x = 2; x < 10; x++)
    {
        try
        {
            oAcro = eval("new ActiveXObject('PDF.PdfCtrl." + x + "');");

            if (oAcro)
            {
                InstallAcrobat.Installed = true;
                InstallAcrobat.Version = x + '.0';
            }
        }
        catch(e)
        {
        }
    }

    try
    {
        oAcro4 = new ActiveXObject('PDF.PdfCtrl.1');

        if (oAcro4)
        {
            InstallAcrobat.Installed = true;
            InstallAcrobat.Version = '4.0';
        }
    }
    catch(e)
    {
    }

    try
    {
        oAcro7 = new ActiveXObject('AcroPDF.PDF.1');

        if (oAcro7)
        {
            InstallAcrobat.Installed = true;
            InstallAcrobat.Version = '7.0';
        }
    }
    catch(e)
    {
    }
}