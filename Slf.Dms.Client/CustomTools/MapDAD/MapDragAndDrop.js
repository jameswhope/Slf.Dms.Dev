var nodeXDistance = 15;
var nodeYDistance = 30;
var groupPaddingX = 5;
var groupPaddingY = 5;

customController.includeJS('ContextMenu/ContextMenu');
customController.includeJS('Dashboard/DashboardTarget');
customController.includeJS('Dashboard/DashboardItem');
customController.includeJS('MapDAD/EntityGroup');
customController.includeJS('MapDAD/EntityRole');
customController.includeJS('MapDAD/MapCanvas');
customController.includeJS('MapDAD/MapDragItem');
customController.includeJS('MapDAD/MapDropTarget');
customController.includeJS('MapDAD/MapRecycleTarget');
customController.includeJS('MapDAD/PhysicalAlgorithms');
customController.includeJS('MapDAD/ShapeHandler');
customController.includeJS('MapDAD/Toolbox');
customController.includeJS('MapDAD/ToolboxItem');

customController.includeCSS('MapDAD/css/MapDragAndDrop');
customController.includeCSS('Dashboard/css/Dashboard');
customController.includeCSS('ContextMenu/css/ContextMenu');


// Utility -----------------------------------------------------------------------------------------
function RemoveChild(parent, child)
{
    var siblings = parent._dropChildren;
    
    if ((parent.get_element().id != child.get_element().id) && siblings)
    {
        var newChildren = new Array();
        
        for (i in siblings)
        {
            if (siblings[i].get_element().id != child.get_element().id)
            {
                newChildren[newChildren.length] = siblings[i];
            }
        }
        
        parent._dropChildren = newChildren;
        
        if (parent._boundingBox && (parent._dropChildren.length == 0))
        {
            document.body.removeChild(parent._boundingBox);
            parent._boundingBox = null;
        }
    }
    
    child._dragParent = null;
}

function AddChild(parent, child)
{
    if (!parent._dropChildren)
    {
        parent._dropChildren = new Array();
    }
    
    parent._dropChildren[parent._dropChildren.length] = child;
    
    child._dragParent = parent;
}

function GetUniqueID(name)
{
    for (i = 0; (i < 10000) && document.getElementById(name + i); i++);
    
    return i;
}