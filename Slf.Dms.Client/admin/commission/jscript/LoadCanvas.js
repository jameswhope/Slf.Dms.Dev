var GroupList;
var NodeList;

function Dispose(canvas)
{
    // canvas should only have one group and should be the first item, but we'll loop
    // through all items anyway and check
    if (canvas)
    {
        for(i=0;i<canvas._dropChildren.length;i++)
        {
            if(canvas._dropChildren[i]._type == 'Group')
            {
                Custom.UI.MapRecycleTarget.prototype.drop(1,'MapDragDropGroup',canvas._dropChildren[i]);
            }
        }
    }
}

function LoadCanvas(canvas, struct, podX)
{
    var strSplit = struct.split(':');
    
    Dispose(canvas);
    
    GroupList = new Array();
    NodeList = new Array();
        
    LoadGroups(canvas, strSplit[0], podX);
    if(strSplit.length == 2) 
    {
        LoadNodes(canvas, strSplit[1]);
    }

    GroupList = null;
    NodeList = null;
}

function LoadGroups(canvas, pods, podX)
{
    var podSplit = pods.split(';');
    var pod;
    var id;
    var title;
    
    for (var i = 0; i < podSplit.length; i++)
    {
        pod = podSplit[i].split('|');
        
        id = pod[0];
        title = pod[1];
        
        GroupList[id] = canvas.createGroup(id, title, podX, 150, false);
        GroupList[id].filterID = id; //filterID;
    }
}

function LoadNodes(canvas, nodes)
{
    var nodeSplit = nodes.split(';');
    var col;
    var id;
    var parentID;
    var type;
    var title;    
    var parentType;
    var commRecID;
    
    for (var i = 0; i < nodeSplit.length; i++)
    {
        col = nodeSplit[i].split('|');
        
        id = col[0];
        parentID = col[1];
        type = col[2];
        parentType = col[3]; // Group or Node
        commRecID = col[4];
        title = col[5]; // Commrec display name
        
        NodeList[id] = canvas.createNode(id, title, type, null, false, commRecID);
        NodeList[id].filterID = 0; //filterID;
        
        if (parentType == 'Group')
        {
            canvas.attachToParent(NodeList[id], GroupList[parentID]);
        }
        else // Node
        {
            canvas.attachToParent(NodeList[id], NodeList[parentID]);
        }
    }
    
    canvas.checkForCollision();
}