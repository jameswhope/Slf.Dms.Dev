Custom.UI.MapDragItem = function(canvas, name, type)
{
    var dragElement = document.getElementById(name);
    var dropElement = document.getElementById(name + 'Drop');
    
    if (dragElement)
    {
        Custom.UI.MapDragItem.initializeBase(this, [dragElement]);
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        this._contextMenuHandler = Function.createDelegate(this, this.contextMenuHandler);
        this._contextCreateGroup = Function.createDelegate(this, this.contextCreateGroup);
        this._mouseOverHandler = Function.createDelegate(this, this.mouseOverHandler);
        
        this._visual = null;
    }
    
    if (dropElement)
    {
        var initDrop = new Custom.UI.MapDropTarget(canvas, dropElement.id);
        
        initDrop.initialize();
        initDrop._dragElement = this;
        this._dropElement = initDrop;
    }
    
    this._type = type;
    this._dropChildren = null;
    this._canvas = canvas;
    this._userID = null;
    this._isSelected = false;
    this._groups = new Array();
    this._roles = new Array();
    this._name = null;
    this.groupItem = new Array();
    
    this._id = 'Temp' + canvas._tempCounter;
    canvas._tempCounter++;
}

Custom.UI.MapDragItem.prototype =
{
    get_dragDataType: function()
    {
        return 'MapDragDrop' + this._type;
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
            if (this.get_element().parentNode)
            {
                this.get_element().parentNode.removeChild(this._visual);
                this._visual = null;
            }
        }
    },
    
    select: function()
    {
        this._canvas.addToSelected(this);
        this._isSelected = true;
        
        this.get_element().style.backgroundColor = '#E5E5E5';
    },
    
    deselect: function()
    {
        if (this.get_element())
        {
            this._canvas.removeFromSelected(this);
            
            this._isSelected = false;
            
            this.get_element().style.backgroundColor = '';
        }
    },
    
    addChild: function(child)
    {
        this._dropChildren[this._dropChildren.length] = child;
        
        child._dragParent = this;
    },
    
    removeChild: function(child)
    {
        var newChildren = new Array();
        
        for (i in this._dropChildren)
        {
            if (this._dropChildren != child)
            {
                newChildren[newChildren.length] = this._dropChildren[i];
            }
        }
        
        this._dropChildren = newChildren;
        
        child._dragParent = null;
    },
    
    getAbsoluteParent: function()
    {
        return this._canvas.getAbsoluteParent(this);
    },
    
    setLocation: function(x, y)
    {
        this._canvas._physicalAlgorithms.setLocation(this.get_element(), x, y);
        //this._canvas.checkForCollision();
    },
    
    setLocationOffset: function(dx, dy)
    {
        var bounds = this._canvas._physicalAlgorithms.getBounds(this.get_element());
        
        this.setLocation(bounds.x + dx, bounds.y + dy);
    },
    
    setImage: function(path)
    {
        if (this._dropElement)
        {
            this._dropElement.get_element().style.backgroundImage = "url('" + path + "')";
        }
    },
    
    getImage: function()
    {
        if (this._dropElement)
        {
            return this._dropElement.get_element().style.backgroundImage;
        }
        
        return null;
    },
    
    initialize: function()
    {
        Custom.UI.MapDragItem.callBaseMethod(this, 'initialize');
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        $addHandler(this.get_element(), 'contextmenu', this._contextMenuHandler);
        $addHandler(this.get_element(), 'mouseover', this._mouseOverHandler);
        
        this._additionalInitialize();
    },
    
    _additionalInitialize: function()
    {
        // Override
    },
    
    mouseOverHandler: function(ev)
    {
        var dash = new Custom.UI.DashboardTarget(this);
        dash.show(this.get_element().id);
        
        this._dash = dash;
    },
    
    contextDelete: function(ev)
    {
        var canvas = this._canvas;
        var selected = canvas.getAllSelected();
        
        for (i in selected)
        {
            selected[i].removeItem();
        }
        
        canvas.checkForCollision();
        
        canvas.clearAllSelections();
    },
    
    contextCreateGroup: function(ev)
    {
        window._event = ev;
        
        var canvas = this._canvas;
        var selected = canvas.getAllSelected();
        var groupName = document.getElementById(this.get_element().id + 'ContextGroupName').value;
        
        for (i in selected)
        {
            this._canvas.addGroup(groupName).addItem(selected[i]);
        }
        
        if (this._menu)
        {
            this._menu.killAll();
        }
        
        canvas.clearAllSelections();
        
        return false;
    },
    
    contextAddToGroup: function(ev)
    {
        var selected = this._canvas.getAllSelected();
        
        for (i in selected)
        {
            ev.args[0].addItem(selected[i]);
        }
        
        this._canvas.clearAllSelections();
    },
    
    contextRemoveFromGroup: function(ev)
    {
        var selected = this._canvas.getAllSelected();
        
        for (i in selected)
        {
            ev.args[0].removeItem(selected[i]);
        }
        
        this._canvas.clearAllSelections();
    },
    
    isInGroup: function(groupName)
    {
        for (var i = 0; i < this._groups.length; i++)
        {
            if (this._groups[i].name == groupName)
            {
                return true;
            }
        }
        
        return false;
    },
    
    contextAddToRole: function(ev)
    {
        var selected = this._canvas.getAllSelected();
        
        for (i in selected)
        {
            ev.args[0].addItem(selected[i]);
        }
        
        this._canvas.clearAllSelections();
    },
    
    contextRemoveFromRole: function(ev)
    {
        var selected = this._canvas.getAllSelected();
        
        for (i in selected)
        {
            ev.args[0].removeItem(selected[i]);
        }
        
        this._canvas.clearAllSelections();
    },
    
    isInRole: function(roleName)
    {
        for (var i = 0; i < this._roles.length; i++)
        {
            if (this._roles[i].name == roleName)
            {
                return true;
            }
        }
        
        return false;
    },
    
    contextMenuHandler: function(ev)
    {
        window._event = ev;
        
        if (!this._isSelected)
        {
            this._canvas.clearAllSelections();
            this.select();
        }
        
        var context = new Custom.UI.ContextSet();
        context.addOption('Delete', this.contextDelete, this);
        var createGroup = context.addOption('Create Group', null, this);
        
        var groupForm = document.createElement('form');
        groupForm.style.height = '10px';
        var groupName = document.createElement('input');
        groupName.id = this.get_element().id + 'ContextGroupName';
        groupName.type = 'text';
        groupForm.appendChild(groupName);
        groupForm.defaultbutton = groupName.id;
        $addHandler(groupForm, 'submit', this._contextCreateGroup);
        createGroup.addOption(groupForm, null, this, true);
        
        if (this._canvas._groups.length - this._groups.length > 0)
        {
            var addToGroup = context.addOption('Add To Group', null, this);
            var addOption;
            
            for (var i = 0; i < this._canvas._groups.length; i++)
            {
                if (!this.isInGroup(this._canvas._groups[i].name))
                {
                    addOption = addToGroup.addOption(this._canvas._groups[i].name, this.contextAddToGroup, this);
                    addOption.addArg(this._canvas._groups[i]);
                }
            }
        }
        
        if (this._groups.length > 0)
        {
            var removeGroupOption;
            var removeFromGroup = context.addOption('Remove From Group', null, this);
            
            for (var i = 0; i < this._groups.length; i++)
            {
                removeGroupOption = removeFromGroup.addOption(this._groups[i].name, this.contextRemoveFromGroup, this);
                removeGroupOption.addArg(this._groups[i]);
            }
        }
        
        if (this._canvas._roles.length - this._roles.length > 0)
        {
            var addToRole = context.addOption('Add To Role', null, this);
            var addRoleOption;
            
            for (var i = 0; i < this._canvas._roles.length; i++)
            {
                if (!this.isInRole(this._canvas._roles[i].name))
                {
                    addRoleOption = addToRole.addOption(this._canvas._roles[i].name, this.contextAddToRole, this);
                    addRoleOption.addArg(this._canvas._roles[i]);
                }
            }
        }
        
        if (this._roles.length > 0)
        {
            var removeRoleOption;
            var removeFromRole = context.addOption('Remove From Role', null, this);
            
            for (var i = 0; i < this._roles.length; i++)
            {
                removeRoleOption = removeFromRole.addOption(this._roles[i].name, this.contextRemoveFromRole, this);
                removeRoleOption.addArg(this._roles[i]);
            }
        }
        
        context = this._additionalContext(context);
        
        this._menu = new Custom.UI.ContextMenu(context, ev.clientX, ev.clientY, null);
        
        return false;
    },
    
    _additionalContext: function(context)
    {
        // Override
        
        return context;
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        if (ev.button == 0)
        {
            if (this._dash)
            {
                this._dash.dispose();
            }
            
            if (ev.ctrlKey)
            {
                if (this._isSelected)
                {
                    this.deselect();
                }
                else
                {
                    this.select();
                }
            }
            
            if (ev.rawEvent.srcElement != this._input)
            {
                var location = this._canvas._physicalAlgorithms.getBounds(this.get_element());
                
                this._visual = this.get_element().cloneNode(true);
                this._visual.style.opacity = '0.4';
	            this._visual.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(opacity=0.4)';
	            this._visual.style.zIndex = 9999;
                this.get_element().parentNode.appendChild(this._visual);
                this._canvas._physicalAlgorithms.setLocation(this._visual, location.x, location.y);
                
                this._visual.style.clip = 'rect(0px, ' + location.width + 'px, ' + location.height + 'px, 0px)';
                
                Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
            }
        }
        
        this._additionalMouseDown(ev);
    },
    
    _additionalMouseDown: function(ev)
    {
        // Override
    },
    
    removeItem: function()
    {
        var element = this.get_element();
        
        if (element)
        {
            this.deselect();
            
            var groupLength = this._groups.length;
            
            for (var i = 0; i < groupLength; i++)
            {
                this._groups[0].removeItem(this);
            }
            
            if (this._dropChildren)
            {
                var temp = this._dropChildren;
                
                for (i in temp)
                {
                    temp[i].removeItem();
                }
            }
            
            if (this._dragParent)
            {
                RemoveChild(this._dragParent, this);
            }
            
            if (this._dropElement)
            {
                this._dropElement.removeItem();
            }
            
            this._canvas.removeChild(this);
            
            this.dispose();
            
            document.body.removeChild(element);
            
            if (document.getElementById(element.id + 'VLineP'))
            {
                document.body.removeChild(document.getElementById(element.id + 'VLineP'));
                document.body.removeChild(document.getElementById(element.id + 'HLineC'));
                document.body.removeChild(document.getElementById(element.id + 'VLineC'));
            }
        }
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        this._mouseDownHandler = null;
        
        this._additionalDispose();
        
        Custom.UI.MapDragItem.callBaseMethod(this, 'dispose');
    },
    
    _additionalDispose: function()
    {
        // Override
    }
}

Custom.UI.MapDragItem.registerClass('Custom.UI.MapDragItem',
    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);