document.write('<script src="LoadCanvas.js" type="text/javascript"></script>');
document.write('<script src="SaveCanvas.js" type="text/javascript"></script>');

Custom.UI.MapDragItem.prototype.mouseOverHandler = function(ev)
{
    if (this._input == null)
    {
        var filterID = 'null';
        
        if (this.filterID)
        {
            filterID = this.filterID;
        }
        
        var dash = new Custom.UI.DashboardTarget(this);
        
        dash.show(filterID);
    }
}

Custom.UI.MapDragItem.prototype.selectName = function(ev)
{
    window._event = ev;
    
    var option = this._input.options[this._input.selectedIndex];
    
    if (option.value != 'blank')
    {
        var main = document.getElementById(this._input.id.replace(/Input/, ''));
        var title = document.getElementById(main.id + 'Title');
        var label = document.getElementById(main.id + 'Label');
        
        this._userID = option.value;
        label.innerText = option.label;
        this._name = label.innerText;
        label.style.display = 'inline';
        
        $removeHandler(this._input, 'change', this._selectName);
        title.removeChild(this._input);
        
        this._input = null;
    }
}

Custom.UI.MapDragItem.prototype.inputName = function(ev)
{
    window._event = ev;
    
    var main = document.getElementById(this._input.id.replace(/Input/, ''));
    var title = document.getElementById(main.id + 'Title');
    var label = document.getElementById(main.id + 'Label');
    
    if (this._input.value.length > 0)
    {
        label.innerHTML = this._input.value;
        this._name = this._input.value;
    }
    
    $removeHandler(this._input, 'blur', this._inputName);
    
    title.removeChild(this._input);
    
    label.style.display = 'inline';
    
    this._input = null;
    
    //this._canvas.checkForCollision();
}

Custom.UI.MapDragItem.prototype.selectNameBlur = function(ev)
{
    var title = document.getElementById(this.get_element().id + 'Title');
    var label = document.getElementById(this.get_element().id + 'Label');
    
    $removeHandler(this._input, 'blur', this._selectNameBlur);
    
    title.removeChild(this._input);
    label.style.display = 'inline';
    
    this._input = null;
    
    //this._canvas.checkForCollision();
}

Custom.UI.MapDragItem.prototype.mouseDoubleClick = function(ev)
{
    window._event = ev;
    
    var title = document.getElementById(this.get_element().id + 'Title');
    var label = document.getElementById(this.get_element().id + 'Label');
    
    if (this._input)
    {
        return;
    }
    
    if ((this._type == 'Person'))
    {
        if (!this._userID)
        {
            this._input = document.createElement('select');
            
            this._input.id = this.get_element().id + 'Input';
            this._input.className = 'MapItemTitleInput';
            
            var userPool = this._canvas.getUserPool();
            var user;
            
            user = document.createElement('option');
            user.id = 'BlankOption';
            user.value = 'blank';
            user.label = '';
            user.selected = true;
            
            this._input.appendChild(user);
            
            for (i in userPool)
            {
                user = document.createElement('option');
                user.id = this.get_element().id + 'Option' + userPool[i][0];
                user.value = userPool[i][0];
                user.label = userPool[i][1];
                user.selected = false;
                
                this._input.appendChild(user);
            }
            
            this._selectName = Function.createDelegate(this, this.selectName);
            this._selectNameBlur = Function.createDelegate(this, this.selectNameBlur);
            
            $addHandler(this._input, 'change', this._selectName);
            $addHandler(this._input, 'blur', this._selectNameBlur);
            
            label.style.display = 'none';
            
            title.appendChild(this._input);
            
            this._input.focus();
        }
    }
    else
    {
        this._input = document.createElement('input');
        
        this._input.id = this.get_element().id + 'Input';
        this._input.className = 'MapItemTitleInput';
        
        this._inputName = Function.createDelegate(this, this.inputName);
        
        $addHandler(this._input, 'blur', this._inputName);
        
        label.style.display = 'none';
        
        title.appendChild(this._input);
        
        this._input.focus();
    }
    
    //this._canvas.checkForCollision();
}

Custom.UI.MapDragItem.prototype._additionalInitialize = function()
{
    this._mouseDoubleClick = Function.createDelegate(this, this.mouseDoubleClick);
    $addHandler(this.get_element(), 'dblclick', this._mouseDoubleClick);
}

Custom.UI.MapDragItem.prototype._additionalDispose = function()
{
    if (this._mouseDoubleClick)
    {
        $removeHandler(this.get_element(), 'dblclick', this._mouseDoubleClick);
    }

    this._mouseDoubleClick = null;
}

Custom.UI.MapDragItem.prototype.goToSubCriteria = function()
{
    window.location.href = 'url(../../../master/?entityid=' + this.get_id();
}

Custom.UI.MapDragItem.prototype._additionalContext = function(context)
{
    if (this.get_id().indexOf('Temp') == -1 && this.hasOwnFilter == 'True')
    {
        context.addOption('Add Sub-Criteria', this.goToSubCriteria, this);
    }
    
    return context;
}

Custom.UI.MapDropTarget.prototype._onRealDrop = function(dragMode, dataType, data)
{
    var id = data;
    
    if (dataType == 'ToolboxItemPerson')
    {
        id = this._canvas.createPerson(GetUniqueID('Person'), 'New Person', this, true);
    }
    else if (dataType == 'ToolboxItemGroup')
    {
        id = this._canvas.createGroup(GetUniqueID('Group'), 'New Group', this, true);
    }
    
    id.deselect();
    
    this._canvas.attachToParent(id, this._dragElement);
}

Custom.UI.MapDropTarget.prototype._additionalCanDrop = function(dragMode, dataType, data)
{
    return ((dataType == 'MapDragDropPerson') || (dataType == 'MapDragDropGroup') || (dataType == 'ToolboxItemPerson') || (dataType == 'ToolboxItemGroup'));
}

Custom.UI.MapCanvas.prototype.getUserPool = function()
{
    var arr = new Array();
    
    if (this._userPool)
    {
        arr = this.buildUserOptions(this._userPool.value);
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.registerUserPool = function(pool)
{
    if (pool)
    {
        if (pool.value)
        {
            this._userPool = pool;
        }
        else
        {
            var element = document.createElement('input');
            element.id = 'MapUserPool' + GetUniqueID('MapUserPool');
            element.value = pool;
            
            document.appendChild(element);
            
            this._userPool = element;
        }
    }
}

Custom.UI.MapCanvas.prototype.buildUserOptions = function(users)
{
    var arr = new Array();
    var userSplit = users.split(';');
    
    for (i in userSplit)
    {
        if (userSplit[i].length > 0)
        {
            arr[arr.length] = userSplit[i].split('|');
        }
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.createMapItem = function(id, title, type, parent, isNew)
{
    var name = type + id;
    var element = document.createElement('div');
    element.id = name;
    element.className = 'MapItem';
    
    var titleItem = document.createElement('div');
    titleItem.id = name + 'Title';
    titleItem.className = 'MapItemTitle';
    
    var titleLabel = document.createElement('div');
    titleLabel.id = name + 'Label';
    titleLabel.innerHTML = title;
    titleLabel.style.overflow = 'visible';
    titleLabel.style.width = '100%';
    titleItem.appendChild(titleLabel);
    
    element.appendChild(titleItem);
    
    var elementDrop = document.createElement('div');
    elementDrop.id = name + 'Drop';
    elementDrop.className = 'MapItemDrop';
    elementDrop.style.backgroundImage = "url('../../../images/Negotiation" + type + "Icon.png')";
    element.appendChild(elementDrop);
    
    document.body.appendChild(element);
    
    var item;
    
    item = this.createNewItem(canvas, name, type);
    item._name = title;
    
    item.initialize();
    
    if (!isNew)
    {
        item._id = id;
    }
    
    if (parent)
    {
        this.attachToParent(item, parent);
    }
    
    this.addChild(item);
    
    return item;
}

Custom.UI.MapCanvas.prototype.createGroup = function(id, title, parent, isNew)
{
    return this.createMapItem(id, title, 'Group', parent, isNew);
}

Custom.UI.MapCanvas.prototype.createGroupXY = function(id, title, x, y, isNew)
{
    var item = this.createMapItem(id, title, 'Group', null, isNew);
    this._physicalAlgorithms.setLocation(item.get_element(), x, y);
    
    return item;
}

Custom.UI.MapCanvas.prototype.createPerson = function(id, title, parent, isNew)
{
    return this.createMapItem(id, title, 'Person', parent, isNew);
}

Custom.UI.MapCanvas.prototype.createPersonXY = function(id, title, x, y, isNew)
{
    var item = this.createMapItem(id, title, 'Person', null, isNew);
    this._physicalAlgorithms.setLocation(item.get_element(), x, y);
    
    return item;
    
}

Custom.UI.MapCanvas.prototype._onRealDrop = function(bounds, dragMode, dataType, data)
{
    if (dataType == 'ToolboxItemGroup')
    {
        this.createGroupXY(GetUniqueID('Group'), 'New POD', bounds.x, bounds.y, true);
    }
    else if (dataType == 'ToolboxItemPerson')
    {
        this.createPersonXY(GetUniqueID('Person'), 'New Person', bounds.x, bounds.y, true);
    }
    else
    {
        if (data._dragParent)
        {
            RemoveChild(data._dragParent, data);
        }
        
        var oldBounds = this._physicalAlgorithms.getBounds(data.get_element());
        var dx = bounds.x - oldBounds.x;
        var dy = bounds.y - oldBounds.y;
        
        if (data._isSelected)
        {
            for (i in this._selected)
            {
                if (!this._selected[i]._dragParent)
                {
                    this._selected[i].setLocationOffset(dx, dy);
                }
            }
        }
        else
        {
            data.setLocation(bounds.x, bounds.y);
        }
    }
    
    this.checkForCollision();
    this.checkForGroupCollision();
}

Custom.UI.MapCanvas.prototype.canDrop = function(dragMode, dataType, data)
{
    return (((dataType == 'ToolboxItemGroup') || (dataType == 'ToolboxItemPerson') || (dataType == 'MapDragDropGroup') || (dataType == 'MapDragDropPerson')) && this.isWithinDistance(data));
}

Custom.UI.MapRecycleTarget.prototype._additionalCanDrop = function(dragMode, dataType, data)
{
    return ((dataType == 'MapDragDropPerson') || (dataType == 'MapDragDropGroup'));
}

Custom.UI.Toolbox.prototype._setImage = function(type)
{
    return '../../../images/Negotiation' + type + 'Icon.png';
}

Custom.UI.DashboardTarget.prototype._additionalItemComplete = function(parStr)
{
    this.makeHttpRequest(this._item._canvas._currentUserID, 'NegotiationInterface', parStr);
}