Custom.UI.ScrollButton = function(element, div, type)
{
    this._div = div;
    this._type = type;
    
    this._timer = null;
    this._timerTick = 5;
    
    this._speed = 3;
    
    Custom.UI.ScrollButton.initializeBase(this, [element]);
    Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    
    this.initialize();
}

Custom.UI.ScrollButton.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (dataType == 'ListCriteriaContainer' || dataType == 'ListCriteriaItem');
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.onDragLeaveTarget(dragMode, dataType, data);
        }
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.handleOver();
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.handleOut();
        }
    },
    
    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        this._mouseClickHandler = Function.createDelegate(this, this.mouseClickHandler);
        $addHandler(this.get_element(), 'click', this._mouseClickHandler);
        
        this._mouseOutHandler = Function.createDelegate(this, this.mouseOutHandler);
        $addHandler(this.get_element(), 'mouseout', this._mouseOutHandler);
        
        this._mouseOverHandler = Function.createDelegate(this, this.mouseOverHandler);
        $addHandler(this.get_element(), 'mouseover', this._mouseOverHandler);
        
        this._scroll = Function.createDelegate(this, this.scroll);
    },
    
    mouseClickHandler: function(ev)
    {
        this.handleOut();
        
        if (this._type == 'up')
        {
            this._div.scrollTop = 0;
        }
        else
        {
            this._div.scrollTop = this._div.scrollHeight;
        }
    },
    
    mouseOutHandler: function(ev)
    {
        this.handleOut();
    },
    
    mouseOverHandler: function(ev)
    {
        this.handleOver();
    },
    
    setTick: function(ms)
    {
        this._timerTick = ms;
    },
    
    setSpeed: function(u)
    {
        this._speed = u;
    },
    
    setImageNormal: function()
    {
        this.get_element().style.backgroundImage = this.get_element().style.backgroundImage.replace(/Over.gif/, '.gif');
        this.get_element().style.borderStyle = 'outset';
    },
    
    setImageOver: function()
    {
        this.get_element().style.backgroundImage = this.get_element().style.backgroundImage.replace(/.gif/, 'Over.gif');
        this.get_element().style.borderStyle = 'inset';
    },
    
    handleOver: function()
    {
        if (this._div)
        {
            if (this._div.scrollHeight > this._div.offsetHeight && ((this._type == 'up' && this._div.scrollTop > 0) || (this._type == 'down' && (this._div.scrollHeight - this._div.scrollTop) > this._div.offsetHeight)))
            {
                this.setImageOver();
                
                this._timer = setInterval(this._scroll, this._timerTick);
            }
        }
    },
    
    handleOut: function()
    {
        this.setImageNormal();
        
        clearInterval(this._timer);
        this._timer = null;
    },
    
    scroll: function()
    {
        if (this._div)
        {
            if (this._type == 'up')
            {
                this._div.scrollTop -= this._speed;
            }
            else
            {
                this._div.scrollTop += this._speed;
            }
        }
    },
    
    dispose: function()
    {
        if (this._mouseClickHandler)
        {
            $removeHandler(this.get_element(), 'click', this._mouseClickHandler);
        }
        
        this._mouseClickHandler = null;
        
        if (this._mouseOutHandler)
        {
            $removeHandler(this.get_element(), 'mouseout', this._mouseOutHandler);
        }
        
        this._mouseOutHandler = null;
        
        if (this._mouseOverHandler)
        {
            $removeHandler(this.get_element(), 'mouseover', this._mouseOverHandler);
        }
        
        this._mouseOverHandler = null;
        
        if (this._scroll)
        {
            this._scroll = null;
        }
        
        this._div = null;
        this._type = null;
        this._timer = null;
        
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        Custom.UI.ScrollButton.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.ScrollButton.registerClass('Custom.UI.ScrollButton',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);