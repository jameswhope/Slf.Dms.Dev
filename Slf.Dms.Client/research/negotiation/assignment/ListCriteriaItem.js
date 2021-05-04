Custom.UI.ListCriteriaItem = function(parent, criteriaStr, sqlStr)
{
    this.criteria = new Custom.UI.Criteria(criteriaStr);
    this.sqlStr = sqlStr;
    this.parentCriteriaID = parent._criteriaID;
    
    var element = document.createElement('tr');
    var td;
    
    for (var i = 0; i < this.criteria.getCriteria().length; i++)
    {
        td = document.createElement('td');
        td.innerText = this.criteria.getValue(i);
        element.appendChild(td);
    }
    
    parent._dropElement.appendChild(element);
    
    Custom.UI.ListCriteriaItem.initializeBase(this, [element]);
    
    this.initialize();
    
    this._visual = null;
    this._parent = parent;
}

Custom.UI.ListCriteriaItem.prototype =
{
    get_dragDataType: function()
    {
        return 'ListCriteriaItem';
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
        Custom.UI.ListCriteriaItem.callBaseMethod(this, 'initialize');
        
        this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },
    
    setLocation: function(x, y)
    {
        SetLocation(this.get_element(), x, y);
    },
    
    getLocation: function()
    {
        GetLocation(this.get_element());
    },
    
    attachToParent: function(parent)
    {
        if (this._parent)
        {
            this._parent.removeItem(this);
        }
        
        this._parent = parent;
        this._parent._dropElement.appendChild(this.get_element());
    },
    
    mouseDownHandler: function(ev)
    {
        window._event = ev;
        
        this._parent._container.id = 'tempDragItem';
        this.get_element().id = 'tempDragItemItem';
        
        this._visual = this._parent._entity._table.cloneNode(true);
        this._visual.id = 'ListCriteriaItemDrag';
        this._visual.children[0].className = 'ListCriteriaContainerHide';
        
        this._parent._container.id = '';
        this.get_element().id = '';
        
        for (var i = 0; i < this._visual.children.length; i++)
        {
            if (this._visual.children[i].tagName == 'DIV')
            {
                for (var j = 0; j < this._visual.children[i].children.length; j++)
                {
                    if (this._visual.children[i].children[j].id == 'tempDragItem')
                    {
                        for (var k = 0; k < this._visual.children[i].children[j].children.length; k++)
                        {
                            if (this._visual.children[i].children[j].children[k].id == 'tempDragItemItem')
                            {
                                this._visual.children[i].children[j].children[k].className = 'ListCriteriaItemShow';
                                
                                this._visual.children[i].children[j].children[k].id = '';
                            }
                            else
                            {
                                this._visual.children[i].children[j].children[k].className = 'ListCriteriaItemHide';
                            }
                        }
                        
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
        
        var location = GetBounds(this._parent._entity._table);
        SetLocation(this._visual, location.x, location.y - this._parent._entity._scrollable.scrollTop);
        
        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },
    
    dispose: function()
    {
        if (this._mouseDownHandler)
        {
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        }
        
        this._mouseDownHandler = null;
        
        if (document.getElementById('ListCriteriaItemDrag'))
        {
            document.body.removeChild(this._visual);
        }
        
        this._visual = null;
        
        Custom.UI.ListCriteriaItem.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.ListCriteriaItem.registerClass('Custom.UI.ListCriteriaItem',
    Sys.UI.Behavior, Sys.Preview.UI.IDragSource);