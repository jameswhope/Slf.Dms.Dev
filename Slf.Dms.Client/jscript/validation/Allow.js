
var BrowserIsIE = document.all ? true : false;
var BrowserIsNetscape = document.layers ? true : false;

if (BrowserIsNetscape)
{
	document.captureEvents(Event.KEYPRESS);
}

function AllowAllButLetters(e)
{
	var ret = true;

	if (BrowserIsIE)
	{
		if (window.event.keyCode >= 65 && window.event.keyCode <= 122)
		{
			window.event.keyCode = 0;
			ret = false;
		}
	}

	if (BrowserIsNetscape)
	{
		if (e.which >= 65 && e.which <= 122)
		{
			e.which = 0;
			ret = false;
		}
	}

	return (ret);
}

function AllowOnlyNumbers(e)
{
	var ret = true;

	if (BrowserIsIE)
	{
		if (window.event.keyCode < 46 || window.event.keyCode > 57)
		{
			window.event.keyCode = 0;
			ret = false;
		}
	}

	if (BrowserIsNetscape)
	{
		if (e.which < 46 || e.which > 57)
		{
			e.which = 0;
			ret = false;
		}
	}

	return (ret);
}

function AllowOnlyNumbersStrict(e)
{
	var ret = true;

	if (BrowserIsIE)
	{
		if (window.event.keyCode < 48 || window.event.keyCode > 57)
		{
			window.event.keyCode = 0;
			ret = false;
		}
	}

	if (BrowserIsNetscape)
	{
		if (e.which < 48 || e.which > 57)
		{
			e.which = 0;
			ret = false;
		}
	}

	return (ret);
}

function AllowOnlyLetters(e)
{
	var ret = true;

	if (BrowserIsIE)
	{
		if (window.event.keyCode < 65 || window.event.keyCode > 122)
		{
			window.event.keyCode = 0;
			ret = false;
		}
	}

	if (BrowserIsNetscape)
	{
		if (e.which < 65 || e.which > 122)
		{
			e.which = 0;
			ret = false;
		}
	}

	return (ret);
}
