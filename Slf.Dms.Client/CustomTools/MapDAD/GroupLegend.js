Custom.UI.GroupLegend = function(canvas)
{
    this._drag = false;
    
    this.element = document.createElement('div');
    this.element.className = 'GroupLegend';
    
    this.header = document.createElement('div');
    this.element.appendChild(this.header);
    
    var div = document.createElement('div');
    div.className = 'GroupLegendHolder';
    this.table = document.createElement('table');
    this.body = document.createElement('tbody');
    
    this.table.appendChild(this.body);
    div.appendChild(this.table);
    this.element.appendChild(div);
    
    document.body.appendChild(this.element);
    
    this.items = new Array();
    
    this.setHeaderText('Legend');
    this.setHeaderClass('GroupLegendHeader');
    
    this._canvas = canvas;
    this._oldX = null;
    this._oldY = null;
    
    this.buildIndicators();
    
    this.resize();
    
    this.initialize();
}

Custom.UI.GroupLegend.prototype =
{
    onDragStart: function()
    {
        this._drag = true;
        
        this._oldX = null;
        this._oldY = null;
        
        this._mouseMoveHandler = Function.createDelegate(this, this.mouseMoveHandler);
        $addHandler(document, 'mousemove', this._mouseMoveHandler);
    },
    
    onDrag: function(deltaX, deltaY)
    {
        var Cb = this._canvas._physicalAlgorithms.getBounds(this._canvas.get_element());
        var Eb = this._canvas._physicalAlgorithms.getBounds(this.element);
        var x = Eb.x + deltaX;
        var y = Eb.y + deltaY;
        
        if (x < Cb.x || (x + Eb.width) > (Cb.x + Cb.width))
        {
            x = Eb.x;
        }
        
        if (y < Cb.y || (y + Eb.height) > (Cb.y + Cb.height))
        {
            y = Eb.y;
        }
        
        this.element.style.left = x;
        this.element.style.top = y;
        
        this.moveIndicators();
    },
    
    onDragEnd: function(canceled)
    {
        this._drag = false;
        
        if (this._mouseMoveHandler)
        {
            $removeHandler(document, 'mousemove', this._mouseMoveHandler);
            this._mouseMoveHandler = null;
            
            this.moveIndicators();
        }
    },
    
    initialize: function()
    {
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        this._mouseUpHandler = Function.createDelegate(this, this.mouseUpHandler);
        
        $addHandler(this.header, 'mousedown', this._mouseDownHandler);
        $addHandler(document, 'mouseup', this._mouseUpHandler);
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        this.onDragStart();
    },
    
    mouseUpHandler: function(ev)
    {
        window._event = ev;
        
        this.onDragEnd();
    },
    
    mouseMoveHandler: function(ev)
    {
        window._event = ev;
        
        if (this._drag)
        {
            if (this._oldX != null && this._oldY != null)
            {
                this.onDrag(ev.clientX - this._oldX, ev.clientY - this._oldY);
            }
            
            this._oldX = ev.clientX;
            this._oldY = ev.clientY;
        }
    },
    
    addGroup: function(item, name)
    {
        if (!this.containsGroup(item))
        {
            var entryTr = document.createElement('tr');
            var entryTd1 = document.createElement('td');
            entryTd1.appendChild(item);
            var entryTd2 = document.createElement('td');
            entryTd2.innerText = name;
            entryTr.appendChild(entryTd1);
            entryTr.appendChild(entryTd2);
            
            this.body.appendChild(entryTr);
            
            this.items[this.items.length] = entryTr;
        }
    },
    
    removeGroup: function(item)
    {
        for (var i = 0; i < this.items.length; i++)
        {
            if (this.items[i].children[0].children[0] == item.group)
            {
                this.body.removeChild(this.items[i]);
            }
        }
        
        var newItems = new Array();
        
        for (var i = 0; i < this.items.length; i++)
        {
            if (this.items[i].children[0].children[0] != item.group)
            {
                newItems[newItems.length] = this.items[i];
            }
        }
        
        this.items = newItems;
    },
    
    containsGroup: function(item)
    {
        for (var i = 0; i < this.items.length; i++)
        {
            if (this.items[i].children[0].children[0] == item.group)
            {
                return true;
            }
        }
        
        return false;
    },
    
    setHeaderText: function(text)
    {
        this._headerText = text;
        this.header.innerText = this._headerText;
    },
    
    setHeaderClass: function(className)
    {
        this._headerClass = className;
        this.header.className = this._headerClass;
    },
    
    resize: function()
    {
        var bounds = this._canvas._physicalAlgorithms.getBounds(this._canvas.get_element());
        this.element.style.top = bounds.y;
        this.element.style.left = (bounds.x + bounds.width) - this._canvas._physicalAlgorithms.getBounds(this.element).width;
        
        this.moveIndicators();
    },
    
    resetIndicators: function()
    {
        this._indicatorXL.style.visibility = 'hidden';
        this._indicatorXR.style.visibility = 'hidden';
        this._indicatorYL.style.visibility = 'hidden';
        this._indicatorYR.style.visibility = 'hidden';
    },
    
    indicateXL: function()
    {
        this._indicatorXL.style.visibility = 'visible';
    },
    
    indicateXR: function()
    {
        this._indicatorXR.style.visibility = 'visible';
    },
    
    indicateYL: function()
    {
        this._indicatorYL.style.visibility = 'visible';
    },
    
    indicateYR: function()
    {
        this._indicatorYR.style.visibility = 'visible';
    },
    
    moveIndicators: function()
    {
        var pB = this._canvas._physicalAlgorithms.getBounds(this.element);
        var xl = this._indicatorXL;
        var xr = this._indicatorXR;
        var yl = this._indicatorYL;
        var yr = this._indicatorYR;
        
        this._canvas._physicalAlgorithms.setLocation(xl, pB.x + 1, pB.y + 7);
        xl.style.height = pB.height - 2;
        xl.style.width = '8px';
        
        this._canvas._physicalAlgorithms.setLocation(xr, pB.x + pB.width - 13, pB.y + 7);
        xr.style.height = pB.height - 2;
        xr.style.width = '8px';
        
        this._canvas._physicalAlgorithms.setLocation(yl, pB.x + 1, pB.y + 19);
        yl.style.width = pB.width - 2;
        yl.style.height = '8px';
        
        this._canvas._physicalAlgorithms.setLocation(yr, pB.x + 1, pB.y + pB.height - 16);
        yr.style.width = pB.width - 2;
        yr.style.height = '8px';
    },
    
    buildIndicators: function()
    {
        var xl = document.createElement('div');
        var xr = document.createElement('div');
        var yl = document.createElement('div');
        var yr = document.createElement('div');
        
        xl.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationLegendScrollW.png')";
        xl.style.backgroundPosition = 'center';
	    xl.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(xl);
        
        xr.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationLegendScrollE.png')";
        xr.style.backgroundPosition = 'center';
	    xr.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(xr);
        
        yl.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationLegendScrollN.png')";
        yl.style.backgroundPosition = 'center';
	    yl.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(yl);
        
        yr.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationLegendScrollS.png')";
        yr.style.backgroundPosition = 'center';
	    yr.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(yr);
        
        this._indicatorXL = xl;
        this._indicatorXR = xr;
        this._indicatorYL = yl;
        this._indicatorYR = yr;
        
        this.resetIndicators();
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.header, 'mousedown', this._mouseDownHandler);
            $removeHandler(document, 'mouseup', this._mouseUpHandler);
        }
        
        this._mouseDownHandler = null;
        this._mouseUpHandler = null;
    }
}