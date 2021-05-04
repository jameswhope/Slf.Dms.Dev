try {
    var windowname = '';
    try { windowname = window.top.parent.name.toLowerCase(); }
    catch (e1) {
        document.domain = "dmsi.local";
        windowname = window.top.parent.name.toLowerCase();
    }
}
catch (e) { }