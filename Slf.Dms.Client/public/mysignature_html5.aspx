<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>LexxEsign</title>
    <style type="text/css">
        #container
        {
            position: relative;
        }
        #imageView
        {
            border: 1px solid #000;
        }
        #imageTemp
        {
            position: absolute;
            top: 1px;
            left: 1px;
        }
        </style>

    <script type="text/javascript">

        // Keep everything in anonymous function, called on window load.
        if (window.addEventListener) {
            window.addEventListener('load', function() {
                var canvas, context, tool;
                var lastpoint = null;

                function init() {
                    // Find the canvas element.
                    canvas = document.getElementById('imageView');
                    if (!canvas) {
                        alert('Error: I cannot find the canvas element!');
                        return;
                    }

                    if (!canvas.getContext) {
                        alert('Error: no canvas.getContext!');
                        return;
                    }

                    // Get the 2D canvas context.
                    context = canvas.getContext('2d');
                    if (!context) {
                        alert('Error: failed to getContext!');
                        return;
                    }

                    // Pencil tool instance.
                    tool = new tool_pencil();

                    // Attach the mousedown, mousemove and mouseup event listeners.
                    canvas.addEventListener('mousedown', ev_canvas, false);
                    canvas.addEventListener('mousemove', ev_canvas, false);
                    canvas.addEventListener('mouseup', ev_canvas, false);
                    //Added for touch surfaces
                    canvas.addEventListener("touchmove", draw, false);
                    canvas.addEventListener("touchend", end, false);

                    var query = window.location.search.substring(1);
                    var parms = query.split('&');
                    canvas.width = parms[2].replace('w=', '');

                }

                // This painting tool works like a drawing pencil which tracks the mouse 
                // movements.
                function tool_pencil() {
                    var tool = this;
                    this.started = false;

                    // This is called when you start holding down the mouse button.
                    // This starts the pencil drawing.
                    this.mousedown = function(ev) {
                        context.beginPath();
                        context.moveTo(ev._x, ev._y);
                        tool.started = true;
                    };

                    // This function is called every time you move the mouse. Obviously, it only 
                    // draws if the tool.started state is set to true (when you are holding down 
                    // the mouse button).
                    this.mousemove = function(ev) {
                        if (tool.started) {
                            context.lineTo(ev._x, ev._y);
                            context.stroke();
                        }
                    };

                    // This is called when you release the mouse button.
                    this.mouseup = function(ev) {
                        if (tool.started) {
                            tool.mousemove(ev);
                            tool.started = false;
                        }
                    };
                }

                function draw(e) {
                    e.preventDefault();
                    //for (var i = 0; i < e.touches.length; i++) {
                    //    var id = e.touches[i].identifier;
                    //    if (lastpoint[id]){
                    //        context.beginPath();
                    //        context.moveTo(lastpoint[id].x, lastpoint[id].y);
                    //        context.lineTo(e.touches[i].pageX, e.touches[i].pageY);
                    //        context.stroke();
                    //    }
                    //    lastpoint = { x: e.touches[i].pageX, y: e.touches[i].pageY };
                    //}                    
                    if (lastpoint != null) {
                        context.beginPath();
                        context.moveTo(lastpoint.x, lastpoint.y);
                        context.lineTo(e.touches[0].pageX, e.touches[0].pageY);
                        context.stroke();
                    }
                    lastpoint = { x: e.touches[0].pageX, y: e.touches[0].pageY };
                }

                function end(e) {
                    e.preventDefault();
                    lastpoint = null;
                }

                // The general-purpose event handler. This function just determines the mouse 
                // position relative to the canvas element.
                function ev_canvas(ev) {
                    if (ev.layerX || ev.layerX == 0) { // Firefox
                        ev._x = ev.layerX;
                        ev._y = ev.layerY;
                    } else if (ev.offsetX || ev.offsetX == 0) { // Opera
                        ev._x = ev.offsetX;
                        ev._y = ev.offsetY;
                    }

                    // Call the event handler of the tool.
                    var func = tool[ev.type];
                    if (func) {
                        func(ev);
                    }
                }

                init();

            }, false);
        }
        function EraseCanvas() {
            var canvas = document.getElementById('imageView');
            canvas.width = canvas.width;
        }
        function ajaxRequest() {
            var activexmodes = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"] //activeX versions to check for in IE
            if (window.ActiveXObject) { //Test for support for ActiveXObject in IE first (as XMLHttpRequest in IE7 is broken)
                for (var i = 0; i < activexmodes.length; i++) {
                    try {
                        return new ActiveXObject(activexmodes[i])
                    }
                    catch (e) {
                        //suppress error
                    }
                }
            }
            else if (window.XMLHttpRequest) // if Mozilla, Safari etc
                return new XMLHttpRequest()
            else
                return false
        }
       
        function save() {
            var query = window.location.search.substring(1);
            var parms = query.split('&');

            var canvas = document.getElementById('imageView');
            var dataURL = canvas.toDataURL("image/png");
            //dataURL = dataURL.replace('data:image/png;base64,', '');
            
            var objHTTP = new ajaxRequest;

            try {
                var postUrl = 'SaveHTML5CanvasHandler.ashx';
                var params = parms[1] + '&data=' + encodeURIComponent(dataURL.replace(/^data:image\/(png|jpg);base64,/, ""));
                objHTTP.open("POST", postUrl, false);
                objHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                objHTTP.send(params);
            }
            catch (serr) {
                alert('The following error occurred: ' + serr);
            }

            //var oImgElement = document.createElement("img");
            //oImgElement.src = strSource;
            //return oImgElement;
            //window.open(dataURL);
            //return dataURL.replace(/^data:image\/(png|jpg);base64,/, "");

        }
        function hasSignature() {
            var canvas = document.getElementById('imageView');
            var dataURL = canvas.toDataURL("image/png");
            if (dataURL.length == 834) {
                alert('no sig')
                return false;
            } else if (dataURL.length == 430) {
                alert('no init')
                return false;
            } else {
                return true;
            }

        }
        // vim:set spell spl=en fo=wan1croql tw=80 ts=2 sw=2 sts=2 sta et ai cin fenc=utf-8 ff=unix:
    </script>

</head>
<body>
    <div id="container">
        <canvas id="imageView" width="100%" height="65px" runat="server">
            <p>
                Unfortunately, your browser is currently unsupported by our web application. We
                are sorry for the inconvenience. Please use one of the supported browsers listed
                below, or draw the image you want using an offline tool.</p>
            <p>
                Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">
                    Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">
                        Konqueror</a>.</p>
        </canvas>
        <br />
        <button onclick="javascript:EraseCanvas()" value="Erase" name="Erase">
            Erase</button>
    </div>
</body>
</html>
