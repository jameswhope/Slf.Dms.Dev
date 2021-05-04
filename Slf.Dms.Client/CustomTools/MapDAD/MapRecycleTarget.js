Custom.UI.MapRecycleTarget = function(toolbox, name)
{
    var element = document.getElementById(name);
    
    if (element)
    {
        Custom.UI.MapRecycleTarget.initializeBase(this, [element]);
    }
    
    this._toolbox = toolbox;
}
    
Custom.UI.MapRecycleTarget.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return this._additionalCanDrop(dragMode, dataType, data);
    },
    
    _additionalCanDrop: function(dragMode, dataType, data)
    {
        return true;
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            var canvas = data._canvas;
            
            if (item._dragParent)
            {
                RemoveChild(item._dragParent, data);
            }
            
            if (data._visual)
            {
                if (data._visual.parentElement)
                {
                    data.get_element().parentNode.removeChild(data._visual);
                }
                data._visual = null;
            }
            
            if (data._isSelected)
            {
                var selects = data._canvas.getAllSelected();
                
                for (i in selects)
                {
                    selects[i].removeItem();
                }
            }
            else
            {
                data.removeItem();
            }
            
            if (canvas)
            {
                canvas.checkForCollision();
            }
        }
        
        if (this.get_element())
        {
            this.get_element().style.filter = '';
        }
        
        this._additionalDrop(dragMode, dataType, data);
    },
    
    _additionalDrop: function(dragMode, dataType, data)
    {
        // Override
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.get_element().style.filter = 'progid:DXImageTransform.Microsoft.Chroma(color=\'blue\')';
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.get_element().style.filter = '';
        }
    },
    
    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        
        Custom.UI.MapRecycleTarget.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },
    
    dispose: function()
    {
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        Custom.UI.MapRecycleTarget.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.MapRecycleTarget.registerClass('Custom.UI.MapRecycleTarget',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);