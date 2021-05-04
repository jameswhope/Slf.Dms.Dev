Custom.UI.MapCanvasScrollbar = function(canvas, axis, direction, element)
{
    Custom.UI.MapCanvasScrollbar.initializeBase(this, [element]);
    
    this._canvas = canvas;
    this._scrollInterval = 25;
    this._scrollSpeed = 10;
    this._startTimeout = 500;
    
    element.className = 'MapCanvasScrollbar';
    element.style.visibility = 'hidden';
    
    if (axis == 'x')
    {
        if (direction > 0)
        {
            element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(Opacity=0, FinishOpacity=100, Style=1, StartX=0,  FinishX=100, StartY=0, FinishY=0)';
        }
        else
        {
            element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(Opacity=100, FinishOpacity=0, Style=1, StartX=0,  FinishX=100, StartY=0, FinishY=0)';
        }
    }
    else
    {
        if (direction > 0)
        {
            element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(Opacity=0, FinishOpacity=100, Style=1, StartX=0,  FinishX=0, StartY=0, FinishY=100)';
        }
        else
        {
            element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(Opacity=100, FinishOpacity=0, Style=1, StartX=0,  FinishX=0, StartY=0, FinishY=100)';
        }
    }
    
    this._axis = axis;
    this._direction = direction;
    
    this._startTimer = null;
    this._timer = null;
    
    this.initialize();
}

Custom.UI.MapCanvasScrollbar.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (this._canvas.canDrop(dragMode, dataType, data) && this._additionalCanDrop(dragMode, dataType, data));
    },
    
    _additionalCanDrop: function(dragMode, dataType, data)
    {
        // Override
        
        return true;
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this._canvas.drop(dragMode, dataType, data);
        }
        
        this.killTimer();
        
        if (this._startTimer)
        {
            clearInterval(this._startTimer);
            
            this._startTimer = null;
        }
        
        this.get_element().style.visibility = 'hidden';
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            if (!this._timer)
            {
                this._startTimer = setTimeout(this._startIncrement, this._startTimeout);
            }
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        this.get_element().style.visibility = 'hidden';
        
        this.killTimer();
        
        if (this._startTimer)
        {
            clearInterval(this._startTimer);
            
            this._startTimer = null;
        }
    },

    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.MapCanvasScrollbar.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
        
        this._incrementDirection = Function.createDelegate(this, this.incrementDirection);
        this._startIncrement = Function.createDelegate(this, this.startIncrement);
    },
    
    startIncrement: function()
    {
        clearTimeout(this._startTimer);
        
        this._startTimer = null;
        
        this.get_element().style.visibility = 'visible';
        
        this._timer = setInterval(this._incrementDirection, this._scrollInterval);
    },
    
    incrementDirection: function()
    {
        var increment = this._scrollSpeed * this._direction;
        var dx = 0;
        var dy = 0;
        
        if (this._axis == 'x')
        {
            dx = increment;
        }
        else
        {
            dy = increment;
        }
        
        this._canvas.scrollOffset(dx, dy);
    },
    
    killTimer: function()
    {
        if (this._timer)
        {
            clearInterval(this._timer);
            
            this._timer = null;
        }
    },
    
    dispose: function()
    {
        this._additionalDispose();
        
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        Custom.UI.MapCanvasScrollbar.callBaseMethod(this, 'dispose');
        
        this.killTimer();
        
        if (this._startTimer)
        {
            clearInterval(this._startTimer);
            
            this._startTimer = null;
        }
        
        this._incrementDirection = null;
        this._startIncrement = null;
    },
    
    _additionalDispose: function()
    {
        // Override
    }
}

Custom.UI.MapCanvasScrollbar.registerClass('Custom.UI.MapCanvasScrollbar',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);