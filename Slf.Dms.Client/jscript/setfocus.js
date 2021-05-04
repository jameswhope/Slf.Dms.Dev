function SetFocus(c)
{
	if (document.getElementById(c) != null) {
		try {
			document.getElementById("\"" + c + "\"").focus();
		}
		catch (err) {
			// do nothing
		}
	}
}