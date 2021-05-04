Custom.UI.ToolboxCursor = function(canvas, name, type, cursor)
{
    var element = document.getElementById(name);
    
    if (element)
    {
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        
        this._element = element;
        this._type = type;
        this._cursor = cursor;
        this._canvas = canvas;
        this._name = name;
    }
}

Custom.UI.ToolboxCursor.prototype =
{
    get_element: function()
    {
        return this._element;
    },
    
    setLocation: function(x, y)
    {
        this._canvas._physicalAlgorithms.setLocation(this.get_element(), x, y);
    },
    
    initialize: function()
    {
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },

    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        this.selectCursor();
    },
    
    selectCursor: function()
    {
        this._canvas.get_element().style.cursor = this._cursor;
        this._canvas._selectType = this._type;
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        this._mouseDownHandler = null;
    }
}

Custom.UI.ToolboxCursor.registerClass('Custom.UI.ToolboxCursor',
    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);