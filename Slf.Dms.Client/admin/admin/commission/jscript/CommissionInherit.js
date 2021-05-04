document.write('<script src="jscript/LoadCanvas.js" type="text/javascript"></script>');
document.write('<script src="jscript/SaveCanvas.js" type="text/javascript"></script>');

String.prototype.trim = function() 
{
    return this.replace(/^\s+|\s+$/g,"");
}
    
Custom.UI.MapDragItem.prototype.mouseOverHandler = function(ev)
{
    /*var filterID = 'null';
    
    if (this.filterID)
    {
        filterID = this.filterID;
    }
    
    var dash = new Custom.UI.DashboardTarget(this);
    
    dash.show(filterID);*/
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
               
        label.innerText = option.label;
        label.style.display = 'inline';
        label.style.color = '#000000';
        
        $removeHandler(this._input, 'change', this._selectName);
        title.removeChild(this._input);
        title.style.color = '#000000';
        
        this._input = null;
        CommRecSelected(this._id, option.value, option.label);
    }
    
    this._canvas.checkForCollision();
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
    
    this._canvas.checkForCollision();
}

Custom.UI.MapDragItem.prototype.selectNameBlur = function(ev)
{
    var title = document.getElementById(this.get_element().id + 'Title');
    var label = document.getElementById(this.get_element().id + 'Label');
    
    $removeHandler(this._input, 'blur', this._selectNameBlur);
    
    title.removeChild(this._input);
    label.style.display = 'inline';
    
    this._input = null;
    
    this._canvas.checkForCollision();
}

Custom.UI.MapDragItem.prototype.mouseDoubleClick = function(ev)
{
    window._event = ev;
    
    var title = document.getElementById(this.get_element().id + 'Title');
    var label = document.getElementById(this.get_element().id + 'Label');
    var pool;
    var opt;
    
    if (this._input)
    {
        return;
    }
    
    if (this._type == 'Agency')
    {
        pool = this._canvas.getAgencyPool();
    }
    else if (this._type == 'Attorney')
    {
        pool = this._canvas.getAttorneyPool();
    }
    else if (this._type == 'Processor')
    {
        pool = this._canvas.getProcessorPool();
    }
    else
    {
        pool = this._canvas.getGroupPool();
    }
    
    if (pool.length > 0)
    {
        this._input = document.createElement('select');
        this._input.id = this.get_element().id + 'Input';
        this._input.className = 'MapItemTitleInput';
        
        opt = document.createElement('option');
        opt.id = 'BlankOption';
        opt.value = 'blank';
        opt.label = '';
        opt.selected = true;
        
        this._input.appendChild(opt);
        
        for (i in pool)
        {
            opt = document.createElement('option');
            opt.id = this.get_element().id + 'Option' + pool[i][0];
            opt.value = pool[i][0];
            opt.label = pool[i][1];
            opt.selected = false;
            
            this._input.appendChild(opt);
        }
        
        this._selectName = Function.createDelegate(this, this.selectName);
        this._selectNameBlur = Function.createDelegate(this, this.selectNameBlur);
        
        $addHandler(this._input, 'change', this._selectName);
        $addHandler(this._input, 'blur', this._selectNameBlur);
        
        label.style.display = 'none';
        
        title.appendChild(this._input);
        
        this._input.focus();
        
        this._canvas.checkForCollision();
    }
}

Custom.UI.MapDragItem.prototype._additionalMouseDown = function()
{
    if (!this._isSelected)
    {
        this._canvas.clearAllSelections();
        this.select();
        DragItemClicked(this._id, this._title);
    }
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

// **************************** End Custom.UI.MapDragItem ****************************


Custom.UI.MapDropTarget.prototype._onRealDrop = function(dragMode, dataType, data)
{
    var node = data;
    var id;
    var type;
    var title;
    
    if (dataType == 'ToolboxItemAgency')
        type = 'Agency';
    else if (dataType == 'ToolboxItemAttorney')
        type = 'Attorney';
    else if (dataType == 'ToolboxItemProcessor')
        type = 'Processor';
    
    if (type)
    {
        id = type + GetUniqueID(type);
        title = id;
        node = this._canvas.createNode(id, title, type, this, true, 0);
    }
    
    this._canvas.attachToParent(node, this._dragElement);
    
    // add the new node to the session
    DragItemDropped(node._id, node._dragParent._id, node._type);

    // select the new node
    this._canvas.clearAllSelections();
    node.select();
}

Custom.UI.MapDropTarget.prototype._additionalCanDrop = function(dragMode, dataType, data)
{
    return ((dataType == 'MapDragDropAttorney') || (dataType == 'ToolboxItemAttorney') || (dataType == 'MapDragDropAgency') || (dataType == 'ToolboxItemAgency') || (dataType == 'MapDragDropProcessor') || (dataType == 'ToolboxItemProcessor'));
}

// **************************** End Custom.UI.MapDropTarget ****************************


Custom.UI.MapCanvas.prototype.getProcessorPool = function()
{
    var arr = new Array();
    
    if (this._processorPool)
    {
        arr = this.buildOptions(this._processorPool.value);
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.getAgencyPool = function()
{
    var arr = new Array();
    
    if (this._agencyPool)
    {
        arr = this.buildOptions(this._agencyPool.value);
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.getAttorneyPool = function()
{
    var arr = new Array();
    
    if (this._attorneyPool)
    {
        arr = this.buildOptions(this._attorneyPool.value);
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.getGroupPool = function()
{
    var arr = new Array();
    
    if (this._groupPool)
    {
        arr = this.buildOptions(this._groupPool.value);
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.registerProcessorPool = function(pool)
{ 
    if (pool)
    {
        if (pool.value)
        {
            this._processorPool = pool;
        }
        else
        {
            var element = document.createElement('input');
            element.id = 'MapProcessorPool' + GetUniqueID('MapProcessorPool');
            element.value = pool;
            
            document.appendChild(element);
            
            this._processorPool = element;
        }
    }
}

Custom.UI.MapCanvas.prototype.registerAgencyPool = function(pool)
{ 
    if (pool)
    {
        if (pool.value)
        {
            this._agencyPool = pool;
        }
        else
        {
            var element = document.createElement('input');
            element.id = 'MapAgencyPool' + GetUniqueID('MapAgencyPool');
            element.value = pool;
            
            document.appendChild(element);
            
            this._agencyPool = element;
        }
    }
}

Custom.UI.MapCanvas.prototype.registerAttorneyPool = function(pool)
{ 
    if (pool)
    {
        if (pool.value)
        {
            this._attorneyPool = pool;
        }
        else
        {
            var element = document.createElement('input');
            element.id = 'MapAttorneyPool' + GetUniqueID('MapAttorneyPool');
            element.value = pool;
            
            document.appendChild(element);
            
            this._attorneyPool = element;
        }
    }
}

Custom.UI.MapCanvas.prototype.registerGroupPool = function(pool)
{
    if (pool)
    {
        if (pool.value)
        {
            this._groupPool = pool;
        }
        else
        {
            var element = document.createElement('input');
            element.id = 'MapGroupPool' + GetUniqueID('MapGroupPool');
            element.value = pool;
            
            document.appendChild(element);
            
            this._groupPool = element;
        }
    }
}

Custom.UI.MapCanvas.prototype.showMapItemTitleDDL = function(show)
{
    this._showMapItemTitleDDL = show;
}

Custom.UI.MapCanvas.prototype.buildOptions = function(pool)
{
    var arr = new Array();
    var poolSplit = pool.split(';');
    
    for (i in poolSplit)
    {
        if (poolSplit[i].length > 0)
        {
            arr[arr.length] = poolSplit[i].split('|');
        }
    }
    
    return arr;
}

Custom.UI.MapCanvas.prototype.createMapItem = function(id, title, type, parent, isNew, commRecID)
{
    // ie. id = Attorney0
    var element = document.createElement('div');
    element.id = id;
    element.className = 'MapItem';
    
    var titleItem = document.createElement('div');
    titleItem.id = id + 'Title';
    titleItem.style.height = "23";
    titleItem.style.overflow = "visible";
    titleItem.style.textalign = "center";
    titleItem.style.float = "left";
    if ((this._showMapItemTitleDDL) && (commRecID == -1))
    {
        titleItem.style.color = 'red';
    }
    
    var titleLabel = document.createElement('div');
    titleLabel.id = id + 'Label';
    titleLabel.innerHTML = title;
    titleLabel.style.overflow = 'visible';
    titleLabel.style.width = '100%';
    if (isNew)
    {
        titleLabel.style.color = 'green';
    }
    titleItem.appendChild(titleLabel);
    
    element.appendChild(titleItem);
    
    var elementDrop = document.createElement('div');
    elementDrop.id = id + 'Drop';
    elementDrop.className = 'MapItemDrop';
    elementDrop.style.backgroundImage = "url('../../images/Fee" + type + "Icon.png')";
    element.appendChild(elementDrop);
       
    document.body.appendChild(element);
    
    var item;
    
    item = this.createNewItem(canvas, id, type);
    item._id = id;
    item._title = title;
    item.initialize();
    
    if (parent)
    {
        this.attachToParent(item, parent);
    }
    
    this.addChild(item);
    
    return item;
}

Custom.UI.MapCanvas.prototype.createGroup = function(id, title, x, y, isNew)
{
    var item = this.createMapItem(id, title, 'Group', null, isNew, 0);
    this._physicalAlgorithms.setLocation(item.get_element(), x, y, null);
    
    return item;
}

Custom.UI.MapCanvas.prototype.createNode = function(id, title, type, parent, isNew, commRecID)
{
    return this.createMapItem(id, title, type, parent, isNew, commRecID);
}

Custom.UI.MapCanvas.prototype._onRealDrop = function(bounds, dragMode, dataType, data)
{
    if (dataType == 'ToolboxItemGroup')
    {
        var groupExists;
        var group;
        
        for (i=0;i<this._dropChildren.length;i++)
        {
            if (this._dropChildren[i]._type == 'Group')
            {
                groupExists = true;
            }
        }
        
        // only allow 1 group node
        if (!groupExists)
        {
            group = this.createGroup('Group'+GetUniqueID('Group'), 'Master Account', bounds.x, bounds.y, true);
            // add the new node to the session
            DragItemDropped(group._id, '', group._type);            
        }
    }
    else
    {
        var oldBounds = this._physicalAlgorithms.getBounds(data.get_element());
        var dx = bounds.x - oldBounds.x;
        var dy = bounds.y - oldBounds.y;
        
        if (data._isSelected)
        {
            for (i in this._selected)
            {
                if (!this._selected[i]._dragParent && (this._selected[i].get_element().id != data.get_element().id))
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

// **************************** End Custom.UI.MapCanvas ****************************


Custom.UI.MapRecycleTarget.prototype._additionalCanDrop = function(dragMode, dataType, data)
{
    return ((dataType == 'MapDragDropGroup') || (dataType == 'MapDragDropAgency') || (dataType == 'MapDragDropAttorney') || (dataType == 'MapDragDropProcessor'));
}

Custom.UI.MapRecycleTarget.prototype._additionalDrop = function(dragMode, dataType, data)
{
    DragItemDeleted();
}

// **************************** End Custom.UI.MapRecycleTarget ****************************


Custom.UI.Toolbox.prototype._setImage = function(type)
{
    return '../../images/Fee' + type + 'Icon.png';
}

// **************************** End Custom.UI.Toolbox ****************************


Custom.UI.DashboardTarget.prototype._additionalItemComplete = function(parStr)
{
    this.makeHttpRequest(this._item._canvas._currentUserID, 'NegotiationInterface', parStr);
}

// **************************** End Custom.UI.DashboardTarget ****************************