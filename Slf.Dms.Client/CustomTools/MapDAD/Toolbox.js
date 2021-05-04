Custom.UI.Toolbox = function(canvas, name, x, y, width, height)
{
    var exists = false;
    var element = document.getElementById(name);
    
    if (!element)
    {
        element = document.createElement('div');
    }
    
    element.id = name;
    
    if (!exists)
    {
        document.body.appendChild(element);
    }
    
    this._canvas = canvas;
    
    this._items = new Array();
    this._element = element;
    
    this.resize(x, y, width, height);
}

Custom.UI.Toolbox.prototype =
{
    setClass: function(className)
    {
        this.get_element().className = className;
    },
    
    addItem: function(name, type, x, y, cursor)
    {
        var exists = false;
        var element = document.getElementById(name);
        
        if (!element)
        {
            element = document.createElement('div');
        }
        
        element.id = name;
        element.className = 'ToolboxItem';
        element.style.backgroundImage = 'url(\'' + this._setImage(type) + '\')';
        
        if (!exists)
        {
            document.body.appendChild(element);
        }
        
        this._canvas._physicalAlgorithms.setLocation(element, x, y);
        
        var item = this.createItem(name, type, cursor);
        
        item.initialize();
        
        this._items[this._items.length] = item;
        
        return item;
    },
    
    createItem: function(name, type, cursor)
    {
        if (type == 'Recycle')
        {
            return new Custom.UI.MapRecycleTarget(this, name);
        }
        else if (type.substr(0, 6) == 'Cursor')
        {
            return new Custom.UI.ToolboxCursor(this._canvas, name, type, cursor);
        }
        else
        {
            return new Custom.UI.ToolboxItem(this, name, type);
        }
    },
    
    getItem: function(name)
    {
        for (var i = 0; i < this._items.length; i++)
        {
            if (this._items[i]._name == name)
            {
                return this._items[i];
            }
        }
        
        return null;
    },
    
    _setImage: function(type)
    {
        // Override
        
        return type;
    },
    
    removeItem: function(name)
    {
        var arr = new Array();
        
        for (i in this._items)
        {
            if (this._items[i].get_element().id != name)
            {
                arr[arr.length] = this._items[i];
            }
        }
        
        this._items = arr;
    },
    
    resize: function(x, y, width, height)
    {
        this._element.style.width = width;
        this._element.style.height = height;
    
        this._canvas._physicalAlgorithms.setLocation(this._element, x, y);
    },
    
    get_element: function()
    {
        return this._element;
    }
}