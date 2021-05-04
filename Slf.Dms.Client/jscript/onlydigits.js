var isIE = document.all ? true : false;
var isNS = document.layers ? true : false;

function onlyDigits(e)
{
	var ret = true;

	if (isIE) {
		if (window.event.keyCode < 46 || window.event.keyCode > 57) {
			window.event.keyCode = 0;
			ret = false;
		}
	}
	if (isNS) {
		if (e.which < 46 || e.which > 57) {
			e.which = 0;
			ret = false;
		}
	}

	return (ret);
}

if (isNS) {
	document.captureEvents(Event.KEYPRESS);
}