Custom.UI.ListEntityContainer = function(entityID, hasChildren, table, criteriaStr, sort, aggHeaderStr)
{
    this._type = 'Custom.UI.ListEntityContainer';
    this._entityID = entityID;
    this.criteria = new Custom.UI.Criteria(criteriaStr);
    this.aggHeaders = new Custom.UI.Criteria(aggHeaderStr);
    this._table = table;
    
    var container = document.createElement('div');
    
    var element = document.createElement('tbody');
    element.className = 'ListEntityContainer';
    
    var paddingTr = document.createElement('tr');
    var paddingTd = document.createElement('td');
    paddingTd.className = 'ListEntityContainerPadding';
    paddingTr.appendChild(paddingTd);
    element.appendChild(paddingTr);
    
    var tr = document.createElement('tr');
    var e;
    
    for (var i = 0; i < this.criteria.getCriteria().length; i++)
    {
        this.criteria.args[i]._element = document.createElement('td');
        
        e = this.criteria.args[i]._element;
        
        this.criteria.args[i]._element.className = 'ListEntityContainerElement';
        
        if (this.criteria.getColumn(i) == 'Entity' && hasChildren)
        {
            e = document.createElement('a');
            e.href = 'javascript:AssignByEntity(' + entityID + ')';
            e.className = 'ListEntityContainerName';
            this.criteria.args[i]._element.appendChild(e);
        }
        
        if (this.criteria.getValue(i).indexOf('<') == -1)
        {
            e.innerText = this.criteria.getValue(i);
        }
        else
        {
            e.innerText = '0';
        }
        
        this.criteria.args[i]._element.style.backgroundColor = '#F0F0F0';
        
        tr.appendChild(this.criteria.args[i]._element);
    }
    
    element.appendChild(tr);
    container.appendChild(element);
    table.appendChild(container);
    
    Custom.UI.ListEntityContainer.initializeBase(this, [element]);
    
    this.initialize();
    
    this._items = new Array();
    this._dropElement = container;
    this._scrollable = table.parentNode;
    this._sort = sort;
    this._hasChildren = hasChildren;
    
    this.updateHeaders();
}

Custom.UI.ListEntityContainer.prototype =
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
        
        this.get_element().style.color = '#000000';
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this.get_element().style.color = '#A00000';
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        this.get_element().style.color = '#000000';
    },

    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.ListEntityContainer.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },
    
    updateHeaders: function()
    {
        var value;
        var count;
        var index;
        var splitStr;
        var tag;
        var format;
        
        for (var i = 0; i < this.criteria.getCriteria().length; i++)
        {
            index = this.criteria.getValue(i).indexOf('<');
            
            if (index >= 0)
            {
                splitStr = this.criteria.getValue(i).split(':');
                
                tag = splitStr[0];
                format = 'd';
                
                if (splitStr.length > 1)
                {
                    switch (new String(splitStr[1]).toLowerCase())
                    {
                        case 'c':
                        case 'd':
                        case 'n':
                        case 'p':
                            format = splitStr[1];
                        default:
                            break;
                    }
                }
                
                switch (tag)
                {
                    case '<sum>':
                        value = parseFloat(Math.round(this.getColumnSum(this.criteria.getColumn(i)) * 100) / 100);
                        break;
                    default:
                        value = this.getColumnCount(this.criteria.getColumn(i));
                        break;
                }
                
                this.criteria.args[i]._element.innerText = this.formatStr(value, format);
            }
        }
    },
    
    getColumnSum: function(column)
    {
        var criteria;
        var sum = this.parseReal(this.aggHeaders.getValueByColumn(column));
        
        for (var i = 0; i < this._items.length; i++)
        {
            for (var j = 0; j < this._items[i]._items.length; j++)
            {
                criteria = this._items[i]._items[j].criteria;
                
                for (var k = 0; k < criteria.getCriteria().length; k++)
                {
                    if (criteria.getColumn(k) == column)
                    {
                        sum += this.parseReal(criteria.getValue(k));
                        
                        break;
                    }
                }
            }
        }
        
        return sum;
    },
    
    getColumnCount: function(column)
    {
        var count = this.parseReal(this.aggHeaders.getValueByColumn(column));
        
        if (count == null)
        {
            count = 0;
        }
        
        for (var i = 0; i < this._items.length; i++)
        {
            for (var j = 0; j < this._items[i]._items.length; j++)
            {
                count++;
            }
        }
        
        return count;
    },
    
    formatStr: function(str, format)
    {
        var num = new Number(str);
        
        return num.localeFormat(format);
    },
    
    parseReal: function(str)
    {
        var ret = '';
        var charCode;
        
        for (var i = 0; i < str.length; i++)
        {
            charCode = str.charCodeAt(i);
            
            if ((charCode > 47 && charCode < 58) || (charCode == 46))
            {
                ret += str.charAt(i);
            }
        }
        
        return parseFloat(ret);
    },
    
    addNewItem: function(groupBy, parentID, criteriaID, title)
    {
        return this.addItem(new Custom.UI.ListCriteriaContainer(this, groupBy, parentID, criteriaID, title, this.criteria.getCriteria().length));
    },
    
    addItem: function(item)
    {
        var id = this._items.length;
        
        this._items[id] = item;
        
        this.updateHeaders();
        
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
        
        this.updateHeaders();
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
            Custom.UI.ListEntityContainer.callBaseMethod(this, 'dispose');
        }
    }
}

Custom.UI.ListEntityContainer.registerClass('Custom.UI.ListEntityContainer',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);