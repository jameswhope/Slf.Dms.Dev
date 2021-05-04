<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mySignature.aspx.vb" Inherits="mySignature" %>

<html>
<head runat="server">
    <title></title>

    <script type="text/javascript">
        if (document.layers)
            document.captureEvents(Event.MOUSEOVER | Event.MOUSEOUT | Event.MOUSEDOWN)

        document.oncontextmenu = new Function("return false");

        if (self == top) {
            window.location.href = './';
        }
    </script>

    <style type="text/css">
        body
        {
            cursor: pointer;
            padding: 0;
            margin: 0;
            width: 100%;
            height: 100%;
            background-color: white;
            border: solid 1px #8DB6CD;
        }
        #pointer
        {
            position: absolute;
            background: #000;
            width: 3px;
            height: 3px;
            font-size: 1px;
            z-index: 32768;
        }
        .sigBox
        {
            border-bottom: solid 1px black;
            height: 100px;
            padding-left: 5px;
            padding-right: 5px;
            background-color: White;
        }
        .sigBox:hover
        {
            cursor: pointer;
        }
    </style>
</head>
<body onload="return window_onload()">
    <form id="form1" runat="server">
    
    <input id="l_x" name="l_x" type="hidden" runat="server" />
    <input id="l_y" name="l_y" type="hidden" runat="server" />
    <input id="l_Width" name="l_Width" type="hidden" runat="server" />
    <input id="l_Color" name="l_Color" type="hidden" runat="server" />
    <input id="l_BGColor" name="l_BGColor" type="hidden" runat="server" />
    <input id="l_File" name="l_File" type="hidden" runat="server" />
    <input id="l_CanvasW" name="l_CanvasW" type="hidden" runat="server" />
    <input id="l_CanvasH" name="l_CanvasH" type="hidden" runat="server" />
    <input id="l_SavePath" name="l_SavePath" type="hidden" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server"></asp:LinkButton>

    <script language="javascript" type="text/javascript">
        var IsValid = false;
        var w = 375;
        var file = "file1.gif";
        var msg = "Please draw your signature";

        if (getQueryVariable("w")) {
            w = getQueryVariable("w");
            msg = "Please draw your initials";
        }
        if (getQueryVariable("file")) {
            file = getQueryVariable("file") + ".png";
        }

        document.getElementById("l_Width").value = "1";
        document.getElementById("l_Color").value = "black";
        document.getElementById("l_BGColor").value = "white";
        document.getElementById("l_File").value = file;
        document.getElementById("l_CanvasW").value = w;
        document.getElementById("l_CanvasH").value = "100";
        document.getElementById("l_SavePath").value = "";
        document.bgColor = "white";

        function hasSignature() {
            with (JSD_CONTROL) {
                if (canvas.line_number > 1) {
                    return true;
                }
            }
        }

        function save() {
            var buf_x = "";
            var buf_y = "";
            var lines = 0;

            with (JSD_CONTROL) {
                lines = canvas.line_number;
                for (i = 0; i < canvas.line_number; i++) {
                    buf_x += LogX[i] + "|"
                    buf_y += LogY[i] + "|"
                }
            }
            document.getElementById("l_x").value = buf_x;
            document.getElementById("l_y").value = buf_y;

            if (lines > 1) {
                IsValid = true;
                <%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
            }
            else {
                alert(msg);
                IsValid = false;
            }

            return IsValid;
        }

        function RefreshImage() {
            alert('refreshing..');
        }

        function getQueryVariable(variable) {
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] == variable) {
                    return pair[1];
                }
            }
        } 

    </script>

    <script>

        cache_obj = new Object();
        recent_dot = 0;

        nobasi_x = 0;
        nobasi_y = 0;
        dot_num = 0;
        IE = (navigator.appName == "Microsoft Internet Explorer") ? 1 : 0;
        if (window.opera) { IE = 0 }
        var mpath = '';

        var KC = new Object();
        KC = {
            Z: 90,
            X: 88,
            Q: 81,
            A: 65,
            plus: 107,
            minus: 109
        }
        var USE_VML = 1;



        function jsd_canvas(o) {
            this.canvasObj = o.canvasObj || document.body;

            this.nowX = 0;
            this.nowY = 0;

            this.PlotX = new Array();
            this.PlotY = new Array();

            this.kitenX = 0;
            this.kitenY = 0;

            this.isIE = (navigator.appName == "Microsoft Internet Explorer") ? 1 : 0;
            this.line_number = 0;
            return this;
        }

        function jsd_brush(o) {
            this.size = o.size || 3;
            this.color = o.color || "#F00";
            return this;
        }

        function jsd_control(o) {
            this.canvas = o.canvas;
            this.brush = o.brush;
            this.nowX = 0;
            this.nowY = 0;
            this.mdown = 0;
            this.dot = document.createElement("span", "Dot");
            with (this.dot.style) {
                fontSize = "0px";
                background = document.getElementById("l_Color").value;
                position = "absolute";
                zIndex = "10000";
            }

            this.LogX = new Array();
            this.LogY = new Array();

            /* drawing a signature line */
            this.mdown = 0;
            this.set_next();
            var y = 75;

            for (var x = 10; x < (w - 10); x++) {
                this.LogX[0] += x + ",";
                this.LogY[0] += y + ",";
                this.line(x, y);
            }

            this.canvas.line_number++;
            /* end create line */

            return this;
        }


        jsd_control.prototype = {
            launch: function() {

                with (this) {
                    canvas.pointerObj = document.getElementById("pointer");
                    /* js error setBrush(brush.size,brush.color); */
                }
            },
            mousedown: function(e) {
                this.mdown = 1;
                this.LogX[this.canvas.line_number] = "";
                this.LogY[this.canvas.line_number] = "";
                this.PastX = e.pageX;
                this.PastY = e.pageY;
            },
            mouseup: function() {
                this.mdown = 0;
                this.canvas.line_number++;
                this.set_next();
            },

            set_next: function() {
                with (this.canvas) {
                    var div = document.createElement("div");
                    div.id = "l" + line_number;
                    document.body.appendChild(div);
                    
                    cache_obj[line_number] = div;
                    dot_num = 0;
                    window.status = "n" + line_number + "";
                }
            },
            logging: function() {

            },

            /* js error
            setBrush : function (Size,Color){
            with(this.canvas.pointerObj.style){
            width =  Size + "px";
            height = Size + "px";
            background = Color ;
            }
            with (this.dot.style){
            width =  Size + "px";
            height = Size + "px";
            }
            },
            */

            line: function(X, Y) {
                var xMove = X - this.PastX;
                var yMove = Y - this.PastY;
                var xDecrement = xMove < 0 ? 1 : -1;
                var yDecrement = yMove < 0 ? 1 : -1;
                var b_dot = 1;
                var count = 0;
                if (Math.abs(xMove) >= Math.abs(yMove)) {
                    for (var i = xMove; i != 0; i += xDecrement) {
                        count++;
                        if (count % b_dot == 0) {
                            PlotX[PlotX.length] = X - i;
                            PlotY[PlotY.length] = Y - Math.round(yMove * i / xMove);
                        }
                    }
                } else {
                    for (var i = yMove; i != 0; i += yDecrement) {
                        count++;
                        if (count % b_dot == 0) {
                            PlotX[PlotX.length] = X - Math.round(xMove * i / yMove);
                            PlotY[PlotY.length] = Y - i;
                        }
                    }
                }
                for (var i = 0; i < PlotX.length; i++) {
                    this.drawDot(PlotX[i], PlotY[i])
                }
                PlotX = new Array();
                PlotY = new Array();
                this.PastX = X; this.PastY = Y;
            },
            drawDot: function(x, y) {

                line_number = JSD_CONTROL.canvas.line_number;
                if (recent_dot && this.kitenY == y && !nobasi_y) {
                    recent_dot.style.width = Math.abs(this.kitenX - x) + 1 + "px";

                    if (this.kitenX > x) {
                        recent_dot.style.left = x + "px";
                    }
                    nobasi_x = 1;
                    nobasi_y = 0;
                } else if (recent_dot && this.kitenX == x && !nobasi_x) {
                    recent_dot.style.height = Math.abs(this.kitenY - y) + 1 + "px";

                    if (this.kitenY > y) {
                        recent_dot.style.top = y + "px";
                    }
                    nobasi_x = 0;
                    nobasi_y = 1;
                } else {
                    var dot = this.dot.cloneNode(true);
                    with (dot.style) {
                        left = x + "px";
                        top = y + "px";
                    }
                    recent_dot = dot;
                    cache_obj[line_number].appendChild(dot);

                    this.kitenX = x;
                    this.kitenY = y;
                    nobasi_x = 0;
                    nobasi_y = 0;
                }

                /* fix for safari */

                if (recent_dot.style.width == "")
                    recent_dot.style.width = document.getElementById("l_Width").value + "px";

                if (recent_dot.style.height == "")
                    recent_dot.style.height = document.getElementById("l_Width").value + "px";

            },
            mousemove: function(e, obj) {
                with (obj) {
                    if (USE_VML) {
                        status = canvas.line_number + ":" + nowX + "," + nowY;
                    }
                    nowX = e.pageX;
                    nowY = e.pageY;
                    if (this.mdown) {
                        this.LogX[canvas.line_number] += nowX + ",";
                        this.LogY[canvas.line_number] += nowY + ",";
                        line(nowX, nowY);
                    }
                }
                /* js error
                with(obj){
                pointerObj.style.left = nowX - (brush.size / 2) + "px";
                pointerObj.style.top  = nowY - (brush.size / 2) + "px";
                }
                */
            },
            keydown: function(e, obj) {
                var key = e.keyCode || e.which;
                var bold = function() {
                    with (obj.brush) { size++; obj.setBrush(size, color); }
                };
                var thin = function() {
                    with (obj.brush) {
                        if (size > 1) size--; obj.setBrush(size, color);
                    }
                };
                var back = function() {
                    with (obj.canvas) {
                        if (line_number > 0) {
                            line_number--;
                            var re = document.getElementById('l' + (line_number));
                            canvasObj.removeChild(re);
                            line_number--;
                            obj.mouseup();
                        }
                    }
                };
                switch (key) {
                    case KC.Z: back(); break;
                    case KC.Q: bold(); break;
                    case KC.plus: bold(); break;
                    case KC.A: thin(); break;
                    case KC.minus: thin(); break;
                }
            },
            addEvent: function(obj, type, listener) {
                if (obj.addEventListener) // Std DOM Events
                    obj.addEventListener(type, listener, false);
                else if (obj.attachEvent) // IE
                    obj.attachEvent(
				'on' + type,
				function() {
				    listener({
				        type: window.event.type,
				        keyCode: window.event.keyCode,
				        target: window.event.srcElement,
				        currentTarget: obj,
				        clientX: window.event.clientX,
				        clientY: window.event.clientY,
				        pageX: document.body.scrollLeft + window.event.clientX,
				        pageY: document.body.scrollTop + window.event.clientY,
				        shiftKey: window.event.shiftKey,
				        stopPropagation: function() { window.event.cancelBubble = true }
				    })
				}
			);
            }
        };


        if (IE && USE_VML) {
            IE_draw = new Object();
            IE_draw.prototype = {
                set_next: function() {
                    mpath = '';
                    var w = '<v:shape id="vml_line'
			+ this.canvas.line_number
			+ '" filled="false" strokecolor="' + this.brush.color + '"'
			+ ' strokeweight="' + this.brush.size + 'px" style="behavior:url(#default#VML);'
			+ ' visibility:visible;position:absolute;left:0;top:0;width:100;height:100;antialias:false;"'
			+ ' coordsize="100,100" coordorigin="0, 0" >'
			+ '<v:path v="m 0,0 l 100,100 200,50 x e"/></v:shape>';
                    var sp = document.createElement("span");
                    sp.innerHTML = w;
                    sp.id = "l" + this.canvas.line_number;
                    document.body.appendChild(sp);
                    cache_obj[this.canvas.line_number] = document.getElementById('vml_line' + this.canvas.line_number);
                },
                line: function(x, y) {
                    if (mpath) {
                        mpath += x + ',' + y + ' ';
                    } else {
                        mpath = x + ',' + y + ' l ';
                    }
                    var v = cache_obj[this.canvas.line_number];
                    v.path = 'm ' + mpath + ' ';
                    v.strokeweight = this.brush.size + "px";
                }
            };
            force_inherit(jsd_control, IE_draw);
        }

        var JSD_CONTROL = new jsd_control({
            canvas: jsd_canvas({

        }),
        brush: jsd_brush({
            size: document.getElementById("l_Width").value,
            color: "'" + document.getElementById("l_Color").value + "'"
        })
    });
    window.onload = function() {
        JSD_CONTROL.set_next();
        with (JSD_CONTROL) {
            addEvent(canvas.canvasObj, 'mousedown', function(e) { mousedown(e, JSD_CONTROL) })
            addEvent(document, 'keydown', function(e) { keydown(e, JSD_CONTROL) })
            addEvent(canvas.canvasObj, 'mouseup', function(e) { mouseup(e, JSD_CONTROL) })
            //addEvent(canvas.canvasObj,'mouseout',  function(e){mouseup(e,JSD_CONTROL)})
            addEvent(canvas.canvasObj, 'mousemove', function(e) { mousemove(e, JSD_CONTROL) })
        }
    }
    JSD_CONTROL.launch();


    function copy_properties(src, dest) {
        for (var prop in src) {
            dest[prop] = src[prop];
        }
    }

    function force_inherit(subClass, superClass) {
        copy_properties(superClass.prototype, subClass.prototype);
    }
    document.onselectstart = function() { return false; };
    </script>

    <div id="l0">
    </div>
    <asp:LinkButton ID="lnkClearAppSig" runat="server" Text="Clear" OnClick="lnkClear_Click"
        Style="padding: 5px;" Font-Size="11px" Font-Bold="True" Font-Names="Tahoma" />
    </form>
</body>
</html>
