Custom.UI.ShapeHandler = function(canvas)
{
    this._physicalAlgorithms = new Custom.UI.PhysicalAlgorithms(canvas);
}

Custom.UI.ShapeHandler.prototype =
{
    drawLineBetween: function(parentItem, childItem)
    {
        var parent = parentItem.get_element();
        var child = childItem.get_element();
        var pB = this._physicalAlgorithms.getBounds(parent);
        var cB = this._physicalAlgorithms.getBounds(child);
        
        var VPy1 = pB.y + pB.height - 18;
        var VPy2 = VPy1 + nodeYDistance;
        var VPx = pB.x + (pB.width / 2);
        
        var HCx1 = VPx;
        var HCx2 = cB.x + (cB.width / 2);
        var HCy = VPy2;
        
        var VCy1 = HCy;
        var VCy2 = cB.y;
        var VCx = HCx2;
        
        this.drawVerticalLine(child.id + 'VLineP', VPy1, VPy2, VPx);
        this.drawHorizontalLine(child.id + 'HLineC', HCx1, HCx2, HCy);
        this.drawVerticalLine(child.id + 'VLineC', VCy1, VCy2, VCx);
    },
    
    drawHorizontalLine: function(name, x1, x2, y)
    {
        if (x1 > x2)
        {
            var tempX = x1;
            x1 = x2;
            x2 = tempX;
        }
        
        var line = document.getElementById(name);
        var exists = true;
        
        if (!line)
        {
            exists = false;
            
            line = document.createElement('div');
        }
        
        line.id = name;
        line.className = 'HorizontalLine';
        line.style.width = x2 - x1;
        
        if (!exists)
        {
            document.body.appendChild(line);
        }
        
        this._physicalAlgorithms.setLocation(line, x1, y);
    },
    
    drawVerticalLine: function(name, y1, y2, x)
    {
        if (y1 > y2)
        {
            var tempY = y1;
            y1 = y2;
            y2 = tempY;
        }
        
        var line = document.getElementById(name);
        var exists = true;
        
        if (!line)
        {
            exists = false;
            
            line = document.createElement('div');
        }
        
        line.id = name;
        line.className = 'VerticalLine';
        line.style.height = y2 - y1;
        
        if (!exists)
        {
            document.body.appendChild(line);
        }
        
        this._physicalAlgorithms.setLocation(line, x, y1);
    },
    
    drawBox: function(name, x1, y1, x2, y2)
    {
        var temp;
        
        if (x1 > x2)
        {
            temp = x1;
            x1 = x2;
            x2 = temp;
        }
        
        if (y1 > y2)
        {
            temp = y1;
            y1 = y2;
            y2 = temp;
        }
        
        var exists = true;
        var element = document.getElementById(name);
        
        if (!element)
        {
            exists = false;
            
            element = document.createElement('div');
        }
        
        element.id = name;
        element.style.border = '1px dashed black';
        element.style.height = y2 - y1;
        element.style.width = x2 - x1;
        element.zIndex = 9000;
        
        if (!exists)
        {
            document.body.appendChild(element);
        }
        
        this._physicalAlgorithms.setLocation(element, x1, y1);
        
        return element;
    },
    
    drawGroup: function(name, title, x1, y1, x2, y2)
    {
        var temp;
        
        if (x1 > x2)
        {
            temp = x1;
            x1 = x2;
            x2 = temp;
        }
        
        if (y1 > y2)
        {
            temp = y1;
            y1 = y2;
            y2 = temp;
        }
        
        var exists = true;
        var element = document.getElementById(name);
        
        if (!element)
        {
            exists = false;
            
            element = document.createElement('div');
        }
        
        element.id = name;
        element.style.border = '1px solid red';
        element.style.height = y2 - y1;
        element.style.width = x2 - x1;
        element.zIndex = 9000;
        
        if (!exists)
        {
            document.body.appendChild(element);
        }
        
        this._physicalAlgorithms.setLocation(element, x1, y1);
        
        return element;
    }
}