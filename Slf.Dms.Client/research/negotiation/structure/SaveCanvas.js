Custom.UI.SaveCanvas = function(canvas)
{
    this.entities = new Array();
    this._canvas = canvas;
}

Custom.UI.SaveCanvas.prototype =
{
    addEntity: function(id, type, name, parentID, parentType, userID, clientX, clientY, roles, groups)
    {
        this.entities[this.entities.length] = new Custom.UI.SaveEntity(id, type, name, parentID, parentType, userID, clientX, clientY, roles, groups);
    },
    
    saveAll: function()
    {
        var ret = '';
        
        this.sortChildren();
        
        for (i in this.entities)
        {
            ret += this.entities[i].toString();
        }
        
        return ret;
    },
    
    sortChildren: function()
    {
        var child;
        var bounds;
        var parentID;
        var parentType;
        var clientX;
        var clientY;
        
        for (var i = 0; i < this._canvas._dropChildren.length; i++)
        {
            child = this._canvas._dropChildren[i];
            bounds = canvas._physicalAlgorithms.getBounds(child.get_element());
            
            parentID = 'null';
            parentType = 'null';
            clientX = bounds.x;
            clientY = bounds.y;
            
            if (child._dragParent && child._dragParent != this._canvas)
            {
                parentID = child._dragParent._id;
                parentType = child._dragParent._type;
                
                clientX = 'null';
                clientY = 'null';
            }
            
            this.addEntity(child._id, child._type, child._name, parentID, parentType, child._userID, clientX, clientY, child._roles, child._groups);
        }
    }
}

Custom.UI.SaveEntity = function(id, type, name, parentID, parentType, userID, clientX, clientY, roles, groups)
{
    this.id = id;
    this.type= type;
    this.name = name;
    this.parentID = parentID;
    this.parentType = parentType;
    this.userID = userID;
    this.clientX = clientX;
    this.clientY = clientY;
    this.roles = roles;
    this.groups = groups;
}

Custom.UI.SaveEntity.prototype =
{
    toString: function()
    {
        var roles = new Array();
        var groups = new Array();
        
        for (var i = 0; i < this.roles.length; i++)
        {
            roles[roles.length] = this.roles[i].id;
        }
        
        for (var i = 0; i < this.groups.length; i++)
        {
            groups[groups.length] = this.groups[i].name;
        }
        
        return this.id + '|' + this.type + '|' + this.name + '|' + this.parentID + '|' + this.parentType + '|' + this.userID + '|' + this.clientX + '|' + this.clientY + '|' + roles.join('&') + '|' + groups.join('&') + ';';
    }
}