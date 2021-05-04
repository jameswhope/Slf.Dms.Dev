Custom.UI.EntityRole = function(id, name)
{
    this.id = id;
    this.name = name;
    this.image = null;
    this.items = new Array();
}

Custom.UI.EntityRole.prototype =
{
    addItem: function(item)
    {
        if (!item._roles)
        {
            item._roles = new Array();
        }
        
        if (!this.containsItem(item))
        {
            this.items[this.items.length] = item;
            item._roles[item._roles.length] = this;
            
            if (this.image)
            {
                item.oldImage = item.getImage();
                item.setImage(this.image);
            }
        }
    },
    
    removeItem: function(item)
    {
        if (!item._roles)
        {
            item._roles = new Array();
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
        
        var newRoles = new Array();
        
        for (var i = 0; i < item._roles.length; i++)
        {
            if (item._roles[i] != this)
            {
                newRoles[newRoles.length] = item._roles[i];
            }
        }
        
        item._roles = newRoles;
        
        if (item.oldImage)
        {
            item.setImage(item.oldImage);
            item.oldImage = null;
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
    }
}