Custom.UI.SaveCanvas = function(canvas)
{
    this.groups = new Array();
    this.nodes = new Array();
    this._canvas = canvas;
}

Custom.UI.SaveCanvas.prototype =
{
    addGroup: function(id)
    {
        this.groups[this.groups.length] = new Custom.UI.SaveGroup(id, this.groups.length);
    },
    
    addNode: function(nodeID, parentNodeID) //(commRecID, parentCommRecID, pct)
    {
        this.nodes[this.nodes.length] = new Custom.UI.SaveNode(nodeID, parentNodeID, this.nodes.length); //(commRecID, parentCommRecID, pct, this.nodes.length);
    },
    
    saveAll: function()
    {
        var ret = '';
        
        this.sortChildren();
        
        /*for (i in this.groups)
        {
            ret += this.groups[i].toString();
        }*/
        
        if(this.nodes.length > 0)
        {
            //ret += ':';
            
            for (i in this.nodes)
            {
                ret += this.nodes[i].toString();
            }
        }
        
        return ret;
    },
    
    sortChildren: function()
    {
        var child;
        var absParent;
        //var absParentID;
        //var bounds;
        var pct;
        
        for (var i = 0; i < this._canvas._dropChildren.length; i++)
        {
            child = this._canvas._dropChildren[i];
            
            if (child._type == 'Group')
            {
                //bounds = canvas._physicalAlgorithms.getBounds(child.get_element());                
                this.addGroup(child._commRecID); //, bounds.x, bounds.y
            }
            else
            {
                /*absParent = child.getAbsoluteParent();
                
                if (absParent)
                {
                    absParentID = absParent.get_element().id;
                    groupID = absParent._commRecID;
                }
                else
                {
                    absParentID = 'null';
                    groupID = -1;
                }*/
                
                //pct = document.getElementById(child.get_element().id + 'Pct');
                
                this.addNode(child._id, child._dragParent._id); //, child._commRecID, child._dragParent._commRecID, pct.value);
            }
        }
    }
}

Custom.UI.SaveGroup = function(id, len)
{
    this.id = id;
    //this.clientX = clientX;
    //this.clientY = clientY;
    this.len = len;
}

Custom.UI.SaveGroup.prototype =
{
    toString: function()
    {
        if (this.len > 0)
            return ';' + this.id;
        else
            return this.id;
    }
}

Custom.UI.SaveNode = function(nodeID, parentNodeID, len) //(commRecID, parentCommRecID, len)
{
    //this.commRecID = commRecID
    //this.parentCommRecID = parentCommRecID;
    //this.groupID = groupID;
    //this.pct = pct;
    this.nodeID = nodeID;
    this.parentNodeID = parentNodeID;
    this.len = len
}

Custom.UI.SaveNode.prototype =
{
    toString: function()
    {        
        if (this.len > 0)
            return ';' + this.nodeID + '|' + this.parentNodeID; // + '|' + this.pct;
        else
            return this.nodeID + '|' + this.parentNodeID; // + '|' + this.pct;
    }
}