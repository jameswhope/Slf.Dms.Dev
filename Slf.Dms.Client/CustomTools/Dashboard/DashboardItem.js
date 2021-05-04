Custom.UI.DashboardItem = function(parent, elementHTML, clientX, clientY, clientWidth, clientHeight)
{
    if (!parent.get_element())
    {
        this.dispose();
        return;
    }
    
    var element = document.createElement('div');
    
    element.innerHTML = elementHTML;
    
    if (clientWidth != 'null')
    {
        element.style.width = clientWidth;
    }
    
    if (clientHeight != 'null')
    {
        element.style.height = clientHeight;
    }
    
    element.className = 'DashboardItem';
    
    this._element = element;
    parent.get_element().appendChild(element);
    
    //Custom.UI.DashboardItem.initializeBase(this, [element]);
    //this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
    
    this._parent = parent;
    
    this.initialize();
}

Custom.UI.DashboardItem.prototype =
{
    get_element: function()
    {
        return this._element;
    },
    
    get_dragDataType: function()
    {
        return 'DashboardItem';
    },

    getDragData: function(context)
    {
        return this;
    },

    get_dragMode: function()
    {
        return Sys.Preview.UI.DragMode.Move;
    },

    onDragStart: function()
    {
    },

    onDrag: function()
    {
    },

    onDragEnd: function(canceled)
    {
        if (this._visual && this.get_element())
        {
            document.body.removeChild(this._visual);
            this._visual = null;
        }
    },
    
    initialize: function()
    {
        //Custom.UI.DashboardItem.callBaseMethod(this, 'initialize');
        //$addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        this._visual = this.get_element().cloneNode(true);
        this._visual.style.opacity = '0.4';
        this._visual.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(opacity=0.4)';
        this._visual.style.zIndex = 9999;
        document.body.appendChild(this._visual);
        
        var location = this._parent._physicalAlgorithms.getBounds(this.get_element());
        
        this._parent._physicalAlgorithms.setLocation(this._visual, location.x, location.y);

        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            //$removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        //Custom.UI.DashboardItem.callBaseMethod(this, 'dispose');
        
        if (this._parent.get_element())
        {
            this._parent.get_element().removeChild(this.get_element());
        }
    }
}

//Custom.UI.DashboardItem.registerClass('Custom.UI.DashboardItem',
//    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);