Custom.UI.ListCriteriaContainer = function(entity, groupBy, parentID, criteriaID, title, columnCount)
{
    var container = document.createElement('tbody');
    container.className = 'ListCriteriaContainer';
    
    var dragElement = document.createElement('tr');
    var dragElementTd = document.createElement('td');
    dragElementTd.colSpan = columnCount;
    dragElementTd.className = 'ListCriteriaContainerDrag';
    
    this._toggleImg = document.createElement('img');
    this._toggleImg.src = '../../../images/tree_plus.bmp';
    this._toggleImg.className = 'ListCriteriaContainerToggle';
    dragElementTd.appendChild(this._toggleImg);
    
    this._checkBox = document.createElement('input');
    this._checkBox.type = 'checkbox';
    this._checkBox.className = 'ListCriteriaContainerCheckbox';
    dragElementTd.appendChild(this._checkBox);
    
    var dragText = document.createElement('span');
    dragText.innerText = title;
    dragElementTd.appendChild(dragText);
    
    dragElement.appendChild(dragElementTd);
    container.appendChild(dragElement);
    
    entity._dropElement.appendChild(container);
    
    Custom.UI.ListCriteriaContainer.initializeBase(this, [dragText]);
    
    this.initialize();
    
    this._dropZone = new Custom.UI.ListCriteriaContainerDrop(this, container);
    
    this._dropElement = container;
    
    this._container = container;
    this._visual = null;
    this._items = new Array();
    this._parent = entity._dropElement;
    this._parentID = parentID;
    this._criteriaID = criteriaID;
    this._entity = entity;
    this._title = title;
    this._expanded = false;
    this._sort = entity._sort;
    this._groupBy = groupBy;
}

Custom.UI.ListCriteriaContainer.prototype =
{
    get_dragDataType: function()
    {
        return 'ListCriteriaContainer';
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
            document.body.removeChild(this._visual);
            this._visual = null;
        }
    },
    
    initialize: function()
    {
        Custom.UI.ListCriteriaContainer.callBaseMethod(this, 'initialize');
        
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        
        this._toggleContainer = Function.createDelegate(this, this.toggleContainer);
        $addHandler(this._toggleImg, 'mousedown', this._toggleContainer);
        
        this._sortBy = Function.createDelegate(this, this.sortBy);
    },
    
    setLocation: function(x, y)
    {
        SetLocation(this._container, x, y);
    },
    
    getLocation: function()
    {
        GetLocation(this._container);
    },
    
    addNewItem: function(criteriaStr, sqlStr)
    {
        this.addItem(new Custom.UI.ListCriteriaItem(this, criteriaStr, sqlStr));
    },
    
    addItem: function(item)
    {
        if (!this._expanded)
        {
            item.get_element().style.display = 'none';
        }
        else
        {
            item.get_element().style.display = 'block';
        }
        
        this._items[this._items.length] = item;
        
        this._entity.updateHeaders();
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
        
        if (this._items.length == 0)
        {
            this._entity.removeItem(this);
            
            this.dispose();
            this._dropZone.dispose();
            this._container.parentNode.removeChild(this._container);
        }
        
        this._entity.updateHeaders();
    },
    
    attachItem: function(item)
    {
        item.attachToParent(this);
        this.addItem(item);
        
        this.sortItems();
    },
    
    attachToParent: function(parent)
    {
        if (this._parent)
        {
            this._entity.removeItem(this);
        }
        
        this._entity = parent;
        this._entity._dropElement.appendChild(this._container);
        this._parent = this._entity._dropElement;
        
        for (var i = 0 ; i < this._items.length; i++)
        {
            this._dropElement.appendChild(this._items[i].get_element());
        }
    },
    
    sortItems: function()
    {
        this._items.sort(this._sortBy);
        
        for (var i = 0; i < this._items.length; i++)
        {
            this._dropElement.appendChild(this._items[i].get_element());
        }
    },
    
    sortBy: function(a, b)
    {
        var av = a.criteria.getValueByColumn(this._sort);
        var bv = b.criteria.getValueByColumn(this._sort);
        
        if (Number.parseLocale(av) && Number.parseLocale(bv))
        {
            return this.compareNumerically(av, bv);
        }
        
        return this.compareAlphabetically(av, bv);
    },
    
    compareAlphabetically: function(a, b)
    {
        var idx;
        
        if (a == b)
        {
            return 0;
        }
        
        for (idx = 0; a.charAt(idx) == b.charAt(idx) && idx < a.length && idx < b.length; idx++);
        
        return a.charCodeAt(idx) - b.charCodeAt(idx);
    },
    
    compareNumerically: function(a, b)
    {
        return Number.parseLocale(a) - Number.parseLocale(b);
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        this._container.id = 'tempDragItem';
        
        this._visual = this._entity._table.cloneNode(true);
        this._visual.id = 'ListCriteriaDrag';
        this._visual.children[0].className = 'ListCriteriaContainerHide';
        
        this._container.id = '';
        
        for (var i = 0; i < this._visual.children.length; i++)
        {
            if (this._visual.children[i].tagName == 'DIV')
            {
                for (var j = 0; j < this._visual.children[i].children.length; j++)
                {
                    if (this._visual.children[i].children[j].id == 'tempDragItem')
                    {
                        this._visual.children[i].children[j].className += ' ListCriteriaContainerShow';
                        
                        this._visual.children[i].children[j].id = '';
                    }
                    else
                    {
                        this._visual.children[i].children[j].className += ' ListCriteriaContainerHide';
                    }
                }
            }
        }
        
        document.body.appendChild(this._visual);
        
        var location = GetBounds(this._entity._table);
        SetLocation(this._visual, location.x, location.y - this._entity._scrollable.scrollTop);
        
        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },
    
    toggleContainer: function(ev)
    {
        window._event = ev;
        
        if (this._expanded)
        {
            this._toggleImg.src = '../../../images/tree_plus.bmp';
            
            for (var i = 0; i < this._items.length; i++)
            {
                this._items[i].get_element().style.display = 'none';
            }
            
            this._expanded = false;
        }
        else
        {
            this._toggleImg.src = '../../../images/tree_minus.bmp';
            
            for (var i = 0; i < this._items.length; i++)
            {
                this._items[i].get_element().style.display = 'block';
            }
            
            this._expanded = true;
        }
        
        SetupHeaders();
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        this._mouseDownHandler = null;
        
        if (this._toggleContainer)
        {
            $removeHandler(this._toggleImg, 'mousedown', this._toggleContainer);
        }
        
        this._toggleContainer = null;
        
        if (document.getElementById('ListCriteriaDrag'))
        {
            document.body.removeChild(document.getElementById('ListCriteriaDrag'));
        }
        
        this._visual = null;
        
        this._sortBy = null;
        
        Custom.UI.ListCriteriaContainer.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.ListCriteriaContainer.registerClass('Custom.UI.ListCriteriaContainer',
    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);