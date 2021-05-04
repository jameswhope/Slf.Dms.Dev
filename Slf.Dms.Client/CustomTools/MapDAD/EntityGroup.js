Custom.UI.EntityGroup = function(legend, name, id)
{
    this.name = name;
    this.id = id;
    this.items = new Array();
    
    this.group = document.createElement('div');
    this.group.className = 'GroupItem';
    this.group.innerText = id;
    
    legend.addGroup(this.group, name);
    
    this.legend = legend;
}

Custom.UI.EntityGroup.prototype =
{
    addItem: function(item)
    {
        if (!item.groupItem)
        {
            item.groupItem = new Array();
        }
        
        item.groupItem[item.groupItem.length] = this.group.cloneNode(true);
        item.get_element().appendChild(item.groupItem[item.groupItem.length - 1]);
                        
        if (!item._groups)
        {
            item._groups = new Array();
        }
        
        if (!this.containsItem(item))
        {
            this.items[this.items.length] = item;
            item._groups[item._groups.length] = this;
        }
    },
    
    removeItem: function(item)
    {
        if (!item.groupItem)
        {
            item.groupItem = new Array();
        }
        
        if (!item._groups)
        {
            item._groups = new Array();
        }
        
        var newItems = new Array();
        
        for (var i = 0; i < this.items.length; i++)
        {
            if (this.items[i] != item)
            {
                newItems[newItems.length] = this.items[i];
            }
        }
        
        this.items = newItems;
        
        var newGroups = new Array();
        var i;
        
        for (i = 0; i < item._groups.length; i++)
        {
            if (item._groups[i] != this)
            {
                newGroups[newGroups.length] = item._groups[i];
            }
        }
        
        item._groups = newGroups;
        
        var groupItemID = null;
        var newItemGroups = new Array();
        
        for (var h = 0; h < item.groupItem.length; h++)
        {
            if (item.groupItem[h].innerText == this.id)
            {
                groupItemID = h;
            }
            else
            {
                newItemGroups[newItemGroups.length] = item.groupItem[h];
            }
        }
        
        if (groupItemID != null)
        {
            item.get_element().removeChild(item.groupItem[groupItemID]);
            
            item.groupItem = newItemGroups;
        }
        
        if (this.items.length == 0)
        {
            var newCanvasGroups = new Array();
            
            for (var j = 0; j < canvas._groups.length; j++)
            {
                if (canvas._groups[j] != this)
                {
                    newCanvasGroups[newCanvasGroups.length] = canvas._groups[j];
                }
            }
            
            canvas._groups = newCanvasGroups;
            
            this.dispose();
        }
    },
    
    containsItem: function(item)
    {
        for (var i = 0; i < this.items.length; i++)
        {
            if (this.items[i] == item)
            {
                return true;
            }
        }
        
        return false;
    },
    
    dispose: function()
    {
        var newGroups = new Array();
        
        for (var i = 0; i < this.items.length; i++)
        {
            for (var j = 0; j < this.items[i]._groups.length; j++)
            {
                if (this.items[i]._groups[j] != this)
                {
                    newGroups[newGroups.length] = this.items[i]._groups[j];
                }
            }
            
            this.items[i]._groups = newGroups;
        }
        
        this.legend.removeGroup(this);
        
        this.name = null;
        this.id = null;
        this.items = null;
        this.group = null;
        this.legend = null;
    }
}