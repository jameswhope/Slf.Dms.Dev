DOMBounds = function(element)
{
    this.x = 0;
    this.y = 0;
    this.width = element.offsetWidth;
    this.height = element.offsetHeight;
    
	while (element)
	{
		this.x += element.offsetLeft;
		this.y += element.offsetTop;
		
		element = element.offsetParent;
	}
}


Custom.UI.PhysicalAlgorithms = function(canvas)
{
    this._canvas = canvas;
}

Custom.UI.PhysicalAlgorithms.prototype =
{
    getBounds: function(element)
    {
        return new DOMBounds(element);
    },
    
    setLocation: function(element, x, y)
    {
        element.style.position = 'absolute';
        element.style.left = x;
        element.style.top = y;
        
        if (this._canvas && (element.className == 'MapItem' || element.className == 'VerticalLine' || element.className == 'HorizontalLine'))
        {
            var Cb = this.getBounds(this._canvas.get_element());
            var Eb = this.getBounds(element);
            var t = 0;
            var l = 0;
            var b = Eb.height;
            var r = Eb.width;
            
            if (Eb.y < Cb.y)
            {
                this._canvas.indicateYL();
                t = Cb.y - Eb.y + 1;
            }
            
            if (Eb.x < Cb.x)
            {
                this._canvas.indicateXL();
                l = Cb.x - Eb.x + 1;
            }
            
            if ((Eb.y + Eb.height) > (Cb.y + Cb.height))
            {
                this._canvas.indicateYR();
                b = (Cb.y + Cb.height) - Eb.y - 1;
            }
            
            if ((Eb.x + Eb.width) > (Cb.x + Cb.width))
            {
                this._canvas.indicateXR();
                r = (Cb.x + Cb.width) - Eb.x - 1;
            }
            
            element.style.clip = 'rect(' + t + 'px, ' + r + 'px, ' + b + 'px, ' + l + 'px)';
        }
    },
    
    checkForCollision: function(parent)
    {
        var ret = true;
        
        if (parent)
        {
            var boxes = parent._canvas.getAllBoundingBoxes(parent);
            var element;
            var cmpElement;
            var parent;
            var boxMain;
            var boxMainBounds;
            var boxComp;
            var boxCompBounds;
            var boxLength = boxes.length;
            
            var prevX;
            
            while (ret)
            {
                ret = false;
                
                for (var i = 0; i < boxLength; i++)
                {
                    for (var j = 0; j < boxLength; j++)
                    {
                        boxMainBounds = this.getBounds(boxes[i]._boundingBox);
                        element = boxes[i].get_element();
                        
                        var elementBounds = this.getBounds(element);
                        
                        cmpElement = boxes[j].get_element();
                        boxCompBounds = this.getBounds(boxes[j]._boundingBox);
                        
                        if ((elementBounds.x > this.getBounds(cmpElement).x) &&
                            (boxMainBounds.y == boxCompBounds.y) &&
                            ((((boxMainBounds.x + boxMainBounds.width > boxCompBounds.x) && (boxMainBounds.x + boxMainBounds.width < boxCompBounds.x + boxCompBounds.width))
                                    || ((boxMainBounds.x > boxCompBounds.x) && (boxMainBounds.x < boxCompBounds.x + boxCompBounds.width)))
                                        || (((boxCompBounds.x + boxCompBounds.width > boxMainBounds.x) && (boxCompBounds.x + boxCompBounds.width < boxMainBounds.x + boxMainBounds.width))
                                            || ((boxCompBounds.x > boxMainBounds.x) && (boxCompBounds.x < boxMainBounds.x + boxMainBounds.width)))))
                        {
                            var children = boxes[i]._dropChildren;
                            var numChildren = children.length;
                            
                            this.setLocation(element, boxCompBounds.x + boxCompBounds.width + nodeXDistance + parseInt(((numChildren - 1) * (elementBounds.width + nodeXDistance)) / 2), elementBounds.y);
                            
                            parent = boxes[i]._dragParent;
                            
                            if (parent)
                            {
                                var parentAdd = Math.abs(this.getBounds(element).x - elementBounds.x);
                                
                                if (parentAdd > 0)
                                {
                                    ret = true;
                                    
                                    parent._childrenBoundRight = parent._childrenBoundRight + parentAdd;
                                    parent._boundingBox.style.width = this.getBounds(parent._boundingBox).width + parentAdd;
                                    
                                    parent._canvas.drawLineBetween(parent, boxes[i]);
                                    
                                    children = parent._dropChildren;
                                    
                                    var passed = false;
                                    
                                    for (c in children)
                                    {
                                        if (passed)
                                        {
                                            var child = children[c].get_element();
                                            var childBounds = this.getBounds(child);
                                            
                                            this.setLocation(child, childBounds.x + parentAdd, childBounds.y);
                                            parent._canvas.drawLineBetween(parent, children[c]);
                                            
                                            this.moveAllChildrenRec(children[c]);
                                        }
                                        
                                        if (children[c].get_element().id == element.id)
                                        {
                                            passed = true;
                                        }
                                    }
                                }
                            }
                            
                            this.moveAllChildrenRec(boxes[i]);
                        }
                    }
                }
            }
        }
    },
    
    checkForGroupCollision: function(canvas)
    {
        var ret = true;
        var groups = canvas.getAllTopLevel();
        var groupsLength = groups.length;
        var bounds;
        var cmpBounds;
        
        while (ret)
        {
            ret = false;
            
            for (var i = 0; i < groupsLength; i++)
            {
                for (var j = 0; j < groupsLength; j++)
                {
                    bounds = this.getBounds(groups[i].get_element());
                    cmpBounds = this.getBounds(groups[j].get_element());
                    
                    if ((bounds.y == cmpBounds.y) && (bounds.x >= cmpBounds.x) && (bounds.x <= cmpBounds.x + cmpBounds.width) &&
                    (groups[i].get_element().id != groups[j].get_element().id))
                    {
                        this.setLocation(groups[i].get_element(), cmpBounds.x + cmpBounds.width + nodeXDistance, bounds.y);
                    
                        ret = true;
                    }
                }
            }
        }
    },
    
    moveAllChildrenRec: function(item)
    {
        if (item.get_element())
        {
            if (item._dropChildren)
            {
                for (var i = 0; i < item._dropChildren.length; i++)
                {
                    this.relocateItem(item._dropChildren[i]);
                    this.moveAllChildrenRec(item._dropChildren[i]);
                }
            }
            else
            {
                var eLine = document.getElementById('Bounding' + item.get_element().id);
                
                if (eLine)
                {
                    document.body.removeChild(eLine);
                }
            }
        }
    },
    
    relocateItem: function(item)
    {
        if (item && item._dragParent)
        {
            var parent = item._dragParent;
            var parentBounds = this.getBounds(parent.get_element());
            var itemBounds = this.getBounds(item.get_element());
            var numChildren = parent._dropChildren.length;
            var boundingLeft;
            var boundingRight;
            var boundingWidth;
            
            boundingWidth = (itemBounds.width * numChildren) + (nodeXDistance * (numChildren - 1));
            boundingLeft = parentBounds.x - ((boundingWidth - parentBounds.width) / 2);
            boundingRight = boundingLeft + boundingWidth;
            
            parent._childrenBoundLeft = boundingLeft;
            parent._childrenBoundRight = boundingRight;
            
            var exists = true;
            
            var boundingName = 'Bounding' + parent.get_element().id;
            
            if (!parent._boundingBox)
            {
                exists = false;
                
                parent._boundingBox = document.createElement('div');
            }
            
            parent._boundingBox.id = boundingName;
            parent._boundingBox.style.position = 'absolute';
            parent._boundingBox.style.top = parentBounds.y + parentBounds.height + (nodeYDistance * 2);
            parent._boundingBox.style.left = boundingLeft;
            parent._boundingBox.style.width = boundingWidth;
            parent._boundingBox.style.height = itemBounds.height;
            //parent._boundingBox.style.border = '1px solid red';
            //parent._boundingBox.style.textAlign = 'right';
            //parent._boundingBox.style.color = 'green';
            //parent._boundingBox.innerHTML = parent.id;
            
            if (!exists)
            {
                document.body.appendChild(parent._boundingBox);
            }
            
            for (var i = 0; i < numChildren; i++)
            {
                var x = Math.round(boundingLeft + (i * (nodeXDistance + itemBounds.width)));
                var y = Math.round(parentBounds.y + parentBounds.height + (nodeYDistance * 2));
                
                this.setLocation(parent._dropChildren[i].get_element(), x, y);
                item._canvas.drawLineBetween(parent, parent._dropChildren[i]);
            }
        }
    }
}