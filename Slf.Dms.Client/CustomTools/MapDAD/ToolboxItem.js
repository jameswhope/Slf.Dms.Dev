Custom.UI.ToolboxItem = function(toolbox, name, type)
{
    var dragElement = document.getElementById(name);
    
    if (dragElement)
    {
        Custom.UI.ToolboxItem.initializeBase(this, [dragElement]);
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        
        this._type = type;
        
        this._toolbox = toolbox;
        this._name = name;
    }
}

Custom.UI.ToolboxItem.prototype =
{
    get_dragDataType: function()
    {
        return 'ToolboxItem' + this._type;
    },

    getDragData: function(context)
    {
        return this;
    },

    get_dragMode: function()
    {
        return Sys.Preview.UI.DragMode.Copy;
    },

    onDragStart: function()
    {
    },

    onDrag: function()
    {
    },
    
    setLocation: function(x, y)
    {
        this._toolbox._canvas._physicalAlgorithms.setLocation(this.get_element(), x, y);
    },

    onDragEnd: function(canceled)
    {
        if (this._visual)
        {
            this.get_element().parentNode.removeChild(this._visual);
        }
    },
    
    initialize: function()
    {
        Custom.UI.ToolboxItem.callBaseMethod(this, 'initialize');
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },

    mouseDownHandler: function(ev)
    {
        window._event = ev;

        this._visual = this.get_element().cloneNode(true);
        this._visual.style.opacity = '0.4';
        this._visual.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(opacity=0.4)';
        this._visual.style.zIndex = 99999;
        this.get_element().parentNode.appendChild(this._visual);
        var location = this._toolbox._canvas._physicalAlgorithms.getBounds(this.get_element());
        this._toolbox._canvas._physicalAlgorithms.setLocation(this._visual, location.x, location.y);

        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },

    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        this._mouseDownHandler = null;
        Custom.UI.ToolboxItem.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.ToolboxItem.registerClass('Custom.UI.ToolboxItem',
    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);