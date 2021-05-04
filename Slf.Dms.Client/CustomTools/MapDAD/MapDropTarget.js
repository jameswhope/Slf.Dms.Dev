Custom.UI.MapDropTarget = function(canvas, name)
{
    var element = document.getElementById(name);
    
    if (element)
    {
        Custom.UI.MapDropTarget.initializeBase(this, [element]);
    }
    
    this._canvas = canvas;
}

Custom.UI.MapDropTarget.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (data.get_element() && (data.get_element().id + 'Drop' != this.get_element().id) && this._additionalCanDrop(dragMode, dataType, data));
    },
    
    _additionalCanDrop: function(dragMode, dataType, data)
    {
        // Override
        
        return true;
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data) && this.notChildOrSelf(data))
        {
            this._onRealDrop(dragMode, dataType, data);
            
            this._canvas.checkForCollision();
        }
        
        this.get_element().style.filter = '';
        
        this._additionalDrop(dragMode, dataType, data);
    },
    
    _onRealDrop: function(dragMode, dataType, data)
    {
        // Override
    },
    
    _additionalDrop: function(dragMode, dataType, data)
    {
        // Override
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data) && this.notChildOrSelf(data))
        {
            this.get_element().style.filter = 'progid:DXImageTransform.Microsoft.Chroma(color=\'grey\')';
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        this.get_element().style.filter = '';
    },

    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.MapDropTarget.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
        
        this._sortByDepth = Function.createDelegate(this, this.sortByDepth);
        Sys.Preview.UI.DragDropManager._getInstance()._dropTargets.sort(this._sortByDepth);
    },
    
    notChildOrSelf: function(item)
    {
        var ret = !this.containsChildrenRec(item, this._dragElement);
        
        if (item._dragParent && ret)
        {
            ret = (item._dragParent._dropElement.get_element().id != this.get_element().id);
        }
        
        if (ret)
        {
            for (i in this._dropChildren)
            {
                if (children[i].get_element().id == item.get_element().id && !this.containsChildrenRec(item, children[i]))
                {
                    return false;
                }
            }
        }
        
        return ret;
    },
    
    containsChildrenRec: function(item, child)
    {
        if (item)
        {
            var children = item._dropChildren;
            
            if (children)
            {
                for (i in children)
                {
                    if (children[i].get_element().id == child.get_element().id || this.containsChildrenRec(children[i], child))
                    {
                        return true;
                    }
                }
            }
        }
        
        return false;
    },
    
    removeItem: function()
    {
        this.dispose();
    },
    
    sortByDepth: function(x, y)
    {
        if (x == this._canvas)
        {
            return 1;
        }
        else if (y == this._canvas)
        {
            return -1;
        }
        
        return 0;
    },
    
    dispose: function()
    {
        this._additionalDispose();
        
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        Custom.UI.MapDropTarget.callBaseMethod(this, 'dispose');
    },
    
    _additionalDispose: function()
    {
        // Override
    }
}

Custom.UI.MapDropTarget.registerClass('Custom.UI.MapDropTarget',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);