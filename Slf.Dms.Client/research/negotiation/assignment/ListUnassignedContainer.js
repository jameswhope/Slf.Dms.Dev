Custom.UI.ListUnassignedContainer = function(table, name, columns, sort)
{
    this._entityID = 'unassigned';
    this.columns = columns.split(';');
    this._table = table;
    
    var container = document.createElement('div');
    
    var element = document.createElement('tbody');
    var paddingTr = document.createElement('tr');
    var paddingTd = document.createElement('td');
    paddingTd.className = 'ListEntityContainerPadding';
    paddingTr.appendChild(paddingTd);
    element.appendChild(paddingTr);
    
    var titleTr = document.createElement('tr');
    var titleTd = document.createElement('td');
    titleTd.className = 'ListUnassignedContainerElement';
    titleTd.colSpan = this.columns.length;
    titleTd.innerText = name;
    titleTr.appendChild(titleTd);
    element.appendChild(titleTr);
    
    var tr = document.createElement('tr');
    var td;
    
    for (var i = 0; i < this.columns.length; i++)
    {
        td = document.createElement('td');
        
        tr.appendChild(td);
    }
    
    element.appendChild(tr);
    container.appendChild(element);
    table.appendChild(container);
    
    Custom.UI.ListUnassignedContainer.initializeBase(this, [element]);
    
    this.initialize();
    
    this._items = new Array();
    this._dropElement = container;
    this._scrollable = table.parentNode;
    this._sort = sort;
}

Custom.UI.ListUnassignedContainer.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },

    canDrop: function(dragMode, dataType, data)
    {
        return (data && ((dataType == 'ListCriteriaContainer' && data._entity != this) || dataType == 'ListCriteriaItem') && data.get_element());
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            if (dataType == 'ListCriteriaContainer')
            {
                var parent = null;
                
                for (var i = 0; i < this._items.length; i++)
                {
                    if (this._items[i]._criteriaID == data._criteriaID)
                    {
                        parent = this._items[i];
                        
                        break;
                    }
                }
                
                if (parent && parent._criteriaID != 0)
                {
                    var temp = data._items;
                    
                    for (var i = 0; i < temp.length; i++)
                    {
                        parent.attachItem(temp[i]);
                    }
                    
                    data.dispose();
                }
                else
                {
                    this.attachItem(data);
                }
            }
            else
            {
                var parent = null;
                
                for (var i = 0; i < this._items.length; i++)
                {
                    if (this._items[i]._criteriaID == data.parentCriteriaID)
                    {
                        parent = this._items[i];
                        
                        break;
                    }
                }
                
                if (!parent)
                {
                    parent = this.addNewItem(data._parent._groupBy, data._parent._parentID, data._parent._criteriaID, data._parent._title);
                }
                
                parent.attachItem(data);
            }
            
            SetupHeaders();
        }
        
        this._table.children[0].children[1].className = '';
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this._table.children[0].children[1].className = 'UnassignedDrop';
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        this._table.children[0].children[1].className = '';
    },

    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.ListUnassignedContainer.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },
    
    updateHeaders: function()
    {
    },
    
    addNewItem: function(groupBy, parentID, criteriaID, title)
    {
        return this.addItem(new Custom.UI.ListCriteriaContainer(this, groupBy, parentID, criteriaID, title, this.columns.length));
    },
    
    addItem: function(item)
    {
        var id = this._items.length;
        
        this._items[id] = item;
        
        return this._items[id];
    },
    
    attachItem: function(item)
    {
        item.attachToParent(this);
        this.addItem(item);
    },
    
    removeItem: function(item)
    {
        var newItems = new Array();
        
        for (var i = 0; i < this._items.length; i++)
        {
            if (this._items[i] != item)
            {
                newItems[newItems.length] = this._items[i];
            }
        }
        
        this._items = newItems;
    },
    
    setLocation: function(x, y)
    {
        SetLocation(this.get_element(), x, y);
    },
    
    getLocation: function()
    {
        GetLocation(this.get_element());
    },
    
    dispose: function()
    {
        if (this.get_element())
        {
            Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
            Custom.UI.ListUnassignedContainer.callBaseMethod(this, 'dispose');
        }
    }
}

Custom.UI.ListUnassignedContainer.registerClass('Custom.UI.ListUnassignedContainer',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);