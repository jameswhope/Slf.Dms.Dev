 Custom.UI.MapCanvas = function(name, x, y, width, height, currentUserID, serverRoot)
{
    this.main = document.getElementById(name);
    var exists = true;
    
    if (!this.main)
    {
        exists = false;
        
        this.main = document.createElement('div');
    }
    
    this.main.id = name;
 
    if (!exists)
    {
        document.body.appendChild(this.main);
    }
    
    var element = document.createElement('div');
    
    this.main.appendChild(element);
    
    Custom.UI.MapCanvas.initializeBase(this, [element]);
    
    this._dropChildren = new Array();
    this._shapeHandler = new Custom.UI.ShapeHandler(this);
    this._physicalAlgorithms = new Custom.UI.PhysicalAlgorithms(this);
    
    this._isGrouping = false;
    this._oldCursorX = null;
    this._oldCursorY = null;
    
    this._selected = new Array();
    
    this._canvas = this;
    this._legend = new Custom.UI.GroupLegend(this);
    this._groups = new Array();
    this._roles = new Array();
    this._colors = new Array();
    this._currentUserID = currentUserID;
    this._serverRoot = serverRoot;
    this._scrollTop = 0;
    this._scrollLeft = 0;
    this._selectType = '';
    this._tempCounter = 0;
    this._withinDistance = 5;
    
    this.buildScrollbars();
    
    this.resize(x, y, width, height);
    
    this.initialize();
}

Custom.UI.MapCanvas.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (((dataType == 'ToolboxItemGroup') || (dataType == 'MapDragDropGroup')) && isWithinDistance(data));
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.resetIndicators();
            
            var bounds = this._physicalAlgorithms.getBounds(data._visual);
            var cmpBounds;
            
            if (!data._isSelected)
            {
                for (i in this._dropChildren)
                {
                    if (this._dropChildren[i].get_element().id != data.get_element().id)
                    {
                        cmpBounds = this._physicalAlgorithms.getBounds(this._dropChildren[i].get_element());
                        
                        if ((bounds.y > cmpBounds.y && bounds.y < cmpBounds.y + cmpBounds.width) ||
                            (bounds.y < cmpBounds.y && bounds.y + bounds.width > cmpBounds.y))
                        {
                            bounds.y = cmpBounds.y;
                            break;
                        }
                    }
                }
            }
            
            this._onRealDrop(bounds, dragMode, dataType, data);
        }
        
        this._additionalDrop(bounds, dragMode, dataType, data);
    },
    
    isWithinDistance: function(item)
    {
        if (item._visual)
        {
            var bounds = this._physicalAlgorithms.getBounds(item.get_element());
            var vBounds = this._physicalAlgorithms.getBounds(item._visual);
            
            if (Math.abs(bounds.x - vBounds.x) > this._withinDistance || Math.abs(bounds.y - vBounds.y) > this._withinDistance)
            {
                return true;
            }
        }
        
        return false;
    },
    
    _additionalDrop: function(bounds, dragMode, dataType, data)
    {
        // Override
    },
    
    _onRealDrop: function(bounds, dragMode, dataType, data)
    {
        // Override
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
    },
    
    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    resize: function(x, y, width, height)
    {
        this.main.style.left = x;
        this.main.style.top = y;
        this.main.style.width = width;
        this.main.style.height = height;
        this.main.style.zIndex = 0;
        this.main.style.position = 'absolute';
        
        this.get_element().style.width = width;
        this.get_element().style.height = height;
        this.get_element().style.position = 'relative';
        
        var pB = this._physicalAlgorithms.getBounds(this.get_element());
        var xl = this._scrollBarXL.get_element();
        var xr = this._scrollBarXR.get_element();
        var yl = this._scrollBarYL.get_element();
        var yr = this._scrollBarYR.get_element();
        
        this._physicalAlgorithms.setLocation(xl, pB.x + 1, pB.y + 1);
        xl.style.height = pB.height - 2;
        xl.style.width = '25px';
        
        this._physicalAlgorithms.setLocation(xr, pB.x + pB.width - 26, pB.y + 1);
        xr.style.height = pB.height - 2;
        xr.style.width = '25px';
        
        this._physicalAlgorithms.setLocation(yl, pB.x + 1, pB.y + 1);
        yl.style.width = pB.width - 2;
        yl.style.height = '25px';
        
        this._physicalAlgorithms.setLocation(yr, pB.x + 1, pB.y + pB.height - 26);
        yr.style.width = pB.width - 2;
        yr.style.height = '25px';
        
        this._legend.resize();
        
        this.checkForCollision();
    },
    
    addGroup: function(name)
    {
        var group = this.getGroup(name);
        
        if (!group)
        {
            var id = this._groups.length;
            
            this._groups[id] = new Custom.UI.EntityGroup(this._legend, name, id);
            group = this._groups[id];
        }
        
        return group;
    },
    
    hideLegend: function()
    {
        this._legend.element.style.visibility = 'hidden';
    },
    
    showLegend: function()
    {
        this._legend.element.style.visibility = 'visible';
    },
    
    removeGroup: function(group)
    {
        var newGroups = new Array();
        
        for (var i = 0; i < this._groups.length; i++)
        {
            if (this._groups[i] != group)
            {
                newGroups[newGroups.length] = this._groups[i];
            }
        }
        
        this._groups = newGroups;
        
        group.dispose();
    },
    
    getGroup: function(name)
    {
        for (var i = 0; i < this._groups.length; i++)
        {
            if (this._groups[i].name == name)
            {
                return this._groups[i];
            }
        }
        
        return null;
    },
    
    addChild: function(child)
    {
        this._dropChildren[this._dropChildren.length] = child;
    },
    
    removeChild: function(child)
    {
        var newChildren = new Array();
        
        for (i in this._dropChildren)
        {
            if (this._dropChildren[i].get_element().id != child.get_element().id)
            {
                newChildren[newChildren.length] = this._dropChildren[i];
            }
        }
        
        this._dropChildren = newChildren;
        
        child._canvas = null;
        child._dragParent = null;
    },
    
    getAllChildComponentsRec: function(parent)
    {
        var ret = new Array();
        var deeper;
        
        ret[0] = parent;
        
        for (i in parent._dropChildren)
        {
            deeper = this.getAllChildComponentsRec(parent._dropChildren[i]);
            
            for (j in deeper)
            {
                ret[ret.length] = deeper[j];
            }
        }
        
        return ret;
    },
    
    getAllBoundingBoxes: function(parent)
    {
        var ret = new Array();
        var elements = this.getAllChildComponentsRec(parent);
        
        for (i in elements)
        {
            if (elements[i]._boundingBox)
            {
                ret[ret.length] = elements[i];
            }
        }
        
        return ret.sort(this.orderByX);
    },
    
    getAllTopLevel: function()
    {
        var ret = new Array();
        var elements = this.getAllChildComponentsRec(this);
        
        for (i in elements)
        {
            if (!elements[i]._dragParent && elements[i].get_element().id != this.get_element().id)
            {
                ret[ret.length] = elements[i];
            }
        }
        
        return ret.sort(this.orderByX);
    },
    
    orderByX: function(a, b)
    {
        var aE = a.get_element();
        var bE = b.get_element();
        var aB;
        var bB;
        
        if (!aE)
        {
            aE = a._boundingBox.id;
        }
        
        if (!bE)
        {
            bE = b._boundingBox.id;
        }
        
        aB = a._canvas._physicalAlgorithms.getBounds(aE);
        bB = b._canvas._physicalAlgorithms.getBounds(bE);
        
        if (aB.x > bB.x)
        {
            return 1;
        }
        
        return -1;
    },
    
    getAllSelected: function()
    {
        return this._selected;
    },
    
    getAllChildrenWithin: function(x1, y1, x2, y2)
    {
        var bounds;
        var children = new Array();
        
        for (i in this._dropChildren)
        {
            bounds = this._physicalAlgorithms.getBounds(this._dropChildren[i].get_element());
            
            if ((bounds.x > x1) && (bounds.x + bounds.width < x2) &&
                (bounds.y > y1) && (bounds.y + bounds.height < y2))
            {
                children[children.length] = this._dropChildren[i];
            }
        }
        
        return children;
    },
    
    removeFromSelected: function(child)
    {
        var newSelected = new Array();
        
        for (i in this._selected)
        {
            if (this._selected[i].get_element().id != child.get_element().id)
            {
                newSelected[newSelected.length] = this._selected[i];
            }
        }
        
        this._selected = newSelected;
    },
    
    clearAllSelections: function()
    {
        var tempArray = this._selected;
        
        for (i in tempArray)
        {
            if (tempArray[i].get_element())
            {
                tempArray[i].deselect();
            }
        }
        
        this._selected = new Array();
        tempArray = null;
    },
    
    setUnselected: function(child)
    {
        child.deselect();
    },
    
    setSelected: function(child)
    {
        child.select();
    },
    
    setAllSelected: function(children)
    {
        for (i in children)
        {
            this.setSelected(children[i]);
        }
    },
    
    isSelected: function(child)
    {
        return child._isSelected;
    },
    
    setClass: function(name)
    {
        this.get_element().className = name;
    },
    
    addToSelected: function(child)
    {
        if (!this.isSelected(child))
        {
            this._selected[this._selected.length] = child;
        }
    },
    
    scrollOffset: function(dx, dy)
    {
        var cBounds = this._physicalAlgorithms.getBounds(this.get_element());
        
        var goX = false;
        var goY = false;
        var bounds;
        var boxBounds;
        var element;
        var parent;
        
        this.resetIndicators();
        
        for (var i = 0; i < this._dropChildren.length; i++)
        {
            bounds = this._physicalAlgorithms.getBounds(this._dropChildren[i].get_element());
            
            if ((dx < 0 && bounds.x + bounds.width + dx > cBounds.x) || (dx > 0 && bounds.x + dx < cBounds.x + cBounds.width))
            {
                goX = true;
            }
            
            if ((dy < 0 && bounds.y + bounds.height + dy > cBounds.y) || (dy > 0 && bounds.y + dy < cBounds.y + cBounds.height))
            {
                goY = true;
            }
            
            if ((goX && goY) || (goX && dy == 0) || (goY && dx == 0))
            {
                break;
            }
        }
        
        if (goX)
        {
            this._scrollLeft += dx;
        }
        
        if (goY)
        {
            this._scrollTop += dy;
        }
        
        for (var i = 0; i < this._dropChildren.length; i++)
        {
            element = this._dropChildren[i].get_element();
            bounds = this._physicalAlgorithms.getBounds(element);
            parent = this._dropChildren[i]._dragParent;
            
            if (goX && goY)
            {
                this._physicalAlgorithms.setLocation(element, bounds.x + dx, bounds.y + dy);
            }
            else
            {
                if (goX)
                {
                    this._physicalAlgorithms.setLocation(element, bounds.x + dx, bounds.y);
                }
                
                if (goY)
                {
                    this._physicalAlgorithms.setLocation(element, bounds.x, bounds.y + dy);
                }
            }
            
            if (parent)
            {
                parent._canvas.drawLineBetween(parent, this._dropChildren[i]);
                
                boxBounds = this._physicalAlgorithms.getBounds(parent._boundingBox);
                
                if (goX && goY)
                {
                    this._physicalAlgorithms.setLocation(parent._boundingBox, boxBounds.x + dx, boxBounds.y + dy);
                }
                else
                {
                    if (goX)
                    {
                        this._physicalAlgorithms.setLocation(parent._boundingBox, boxBounds.x + dx, boxBounds.y);
                    }
                    
                    if (goY)
                    {
                        this._physicalAlgorithms.setLocation(parent._boundingBox, boxBounds.x, boxBounds.y + dy);
                    }
                }
            }
        }
    },
    
    buildScrollbars: function()
    {
        var xl = document.createElement('div');
        var xr = document.createElement('div');
        var yl = document.createElement('div');
        var yr = document.createElement('div');
        
        xl.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationScrollW.png')";
        xl.style.backgroundPosition = 'center';
	    xl.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(xl);
        
        xr.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationScrollE.png')";
        xr.style.backgroundPosition = 'center';
	    xr.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(xr);
        
        yl.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationScrollN.png')";
        yl.style.backgroundPosition = 'center';
	    yl.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(yl);
        
        yr.style.backgroundImage = "url('" + customController.getServerRoot() + "/images/NegotiationScrollS.png')";
        yr.style.backgroundPosition = 'center';
	    yr.style.backgroundRepeat = 'no-repeat';
        document.body.appendChild(yr);
        
        this._scrollBarXL = new Custom.UI.MapCanvasScrollbar(this, 'x', -1, xl);
        this._scrollBarXR = new Custom.UI.MapCanvasScrollbar(this, 'x', 1, xr);
        this._scrollBarYL = new Custom.UI.MapCanvasScrollbar(this, 'y', -1, yl);
        this._scrollBarYR = new Custom.UI.MapCanvasScrollbar(this, 'y', 1, yr);
    },
    
    resetIndicators: function()
    {
        this._legend.resetIndicators();
    },
    
    indicateXL: function()
    {
        this._legend.indicateXL();
    },
    
    indicateXR: function()
    {
        this._legend.indicateXR();
    },
    
    indicateYL: function()
    {
        this._legend.indicateYL();
    },
    
    indicateYR: function()
    {
        this._legend.indicateYR();
    },
    
    initialize: function()
    {
        Custom.UI.MapCanvas.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
        
        this._contextMenuHandler = Function.createDelegate(this, this.contextMenuHandler);
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        this._mouseMoveHandler = Function.createDelegate(this, this.mouseMoveHandler);
        this._mouseUpHandler = Function.createDelegate(this, this.mouseUpHandler);
        
        $addHandler(document, 'contextmenu', this._contextMenuHandler);
        $addHandler(document, 'mousedown', this._mouseDownHandler);
        $addHandler(document, 'mousemove', this._mouseMoveHandler);
        $addHandler(document, 'mouseup', this._mouseUpHandler);
    },
    
    contextMenuHandler: function(ev)
    {
        window._event = ev;
        
        return false;
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        if (ev.target.className == 'Canvas')
        {
            this._oldCursorX = ev.clientX;
            this._oldCursorY = ev.clientY;
            this._isGrouping = true;
        }
        
        return false;
    },
    
    mouseMoveHandler: function(ev)
    {
        window._event = ev;
        
        if (ev.target.className == 'Canvas' || ev.target.id == 'MapCanvasGroupingBox')
        {
            if (this._selectType == 'CursorSelect')
            {
                var bounds;
                
                if (this.get_element())
                {
                    bounds = this._physicalAlgorithms.getBounds(this.get_element());
                }
                
                if (this._isGrouping && (this._oldCursorX > 0) && (this._oldCursorY > 0) &&
                    (this._oldCursorX > bounds.x) && (this._oldCursorX < bounds.x + bounds.width) &&
                    (this._oldCursorY > bounds.y) && (this._oldCursorY < bounds.y + bounds.height) &&
                    (ev.clientX > bounds.x) && (ev.clientX < bounds.x + bounds.width) &&
                    (ev.clientY > bounds.y) && (ev.clientY < bounds.y + bounds.height))
                {
                    this._drawnBox = this._shapeHandler.drawBox(this.get_element().id + 'GroupingBox', this._oldCursorX, this._oldCursorY, ev.clientX, ev.clientY);
                }
            }
            else
            {
                if (this._isGrouping)
                {
                    this.scrollOffset(ev.clientX - this._oldCursorX, ev.clientY - this._oldCursorY);
                    
                    this._oldCursorX = ev.clientX;
                    this._oldCursorY = ev.clientY;
                }
            }
        }
        
        return false;
    },
    
    mouseUpHandler: function(ev)
    {
        window._event = ev;
        
        if ((ev.target.className == 'Canvas' || ev.target.id == 'MapCanvasGroupingBox') && !ev.ctrlKey)
        {
            this.clearAllSelections();
        }
        
        if (this._selectType == 'CursorSelect')
        {
            if (this._drawnBox)
            {
                var bounds = this._physicalAlgorithms.getBounds(this._drawnBox);
                document.body.removeChild(this._drawnBox);
                this._drawnBox = null;
                
                this.setAllSelected(this.getAllChildrenWithin(bounds.x, bounds.y, bounds.x + bounds.width, bounds.y + bounds.height));
            }
        }
        
        this._isGrouping = false;
        this._oldCursorX = null;
        this._oldCursorY = null;
        
        return false;
    },
    
    createMapItem: function(id, title, type, parent, isNew)
    {
        // Override
    },
    
    createNewItem: function(canvas, name, type)
    {
        return new Custom.UI.MapDragItem(canvas, name, type);
    },
    
    attachToParent: function(child, newParent)
    {
        var parent = child._dragParent;
        
        if (parent)
        {
            RemoveChild(parent, child);
        }
        
        AddChild(newParent, child);
        this._physicalAlgorithms.relocateItem(child);
    },
    
    checkForCollision: function()
    {
        this._physicalAlgorithms.moveAllChildrenRec(this);
        this._physicalAlgorithms.checkForCollision(this);
    },
    
    checkForGroupCollision: function()
    {
        this._physicalAlgorithms.checkForGroupCollision(this);
    },
    
    drawLineBetween: function(parent, child)
    {
        this._shapeHandler.drawLineBetween(parent, child);
    },
    
    getAbsoluteParent: function(item)
    {
        if (item)
        {
            var parent = item._dragParent;
            
            while (parent)
            {
                item = parent;
                parent = item._dragParent;
            }
        }
        
        return item;
    },
    
    getRolePool: function()
    {
        return this._roles;
    },
    
    registerRolePool: function(pool)
    {
        if (pool)
        {
            this._roles = new Array();
            
            var roles = pool.split(';');
            var role;
            var current;
            
            for (var i = 0; i < roles.length; i++)
            {
                role = roles[i].split('|');
                current = this._roles.length;
                
                if (role[1])
                {
                    this._roles[current] = new Custom.UI.EntityRole(role[0], role[1]);
                    
                    if (role.length > 2)
                    {
                        this._roles[current].image = role[2];
                    }
                }
            }
        }
    },
    
    saveToString: function()
    {
        var save = new Custom.UI.SaveCanvas(canvas);
        
        return save.saveAll();
    },
    
    dispose: function()
    {
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        
        if (this._mouseDownHandler)
        {
            $removeHandler(document, 'mousedown', this._mouseDownHandler);
        }
        
        if (this._mouseOverHandler)
        {
            $removeHandler(document, 'mousemove', this._mouseMoveHandler);
        }
        
        if (this._mouseUpHandler)
        {
            $removeHandler(document, 'mouseup', this._mouseUpHandler);
        }
        
        this._mouseDownHandler = null;
        this._mouseMoveHandler = null;
        this._mouseUpHandler = null;
        
        this._additionalDispose();
        
        Custom.UI.MapCanvas.callBaseMethod(this, 'dispose');
    },
    
    _additionalDispose: function()
    {
        // Override
    }
}

Custom.UI.MapCanvas.registerClass('Custom.UI.MapCanvas',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);