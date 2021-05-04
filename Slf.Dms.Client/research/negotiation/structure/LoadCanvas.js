function LoadCanvas(canvas, loadStr, groupStr, roleStr)
{
    LoadEntities(canvas, loadStr, groupStr, roleStr);
}

function LoadEntities(canvas, entities, groupStr, roleStr)
{

    var entityList = new Array();
    var entitySplit = entities.split(';');
    var entity;
    var id;
    var type;
    var name;
    var parentID;
    var userID;
    var clientX;
    var clientY;
    var filters;
    var hasOwnFilter;
    var cBounds = canvas._physicalAlgorithms.getBounds(canvas.get_element());
    var cCenterX = cBounds.x + Math.round(cBounds.width / 2) - 100;
    var cCenterY = cBounds.y + 100;
    
    for (var i = 0; i < entitySplit.length; i++)
    {
        entity = entitySplit[i].split('|');
        
        if (entity.length == 9)
        {
            id = entity[0];
            type = entity[1];
            name = entity[2];
            parentID = entity[3];
            userID = entity[4];
            clientX = entity[5];
            clientY = entity[6];
            filters = entity[7];
            hasOwnFilter = entity[8];
            
            if (type == 'Group')
            {
                if (clientX != 'null' && clientY != 'null')
                {
                    entityList[id] = canvas.createGroupXY(id, name, clientX, clientY, false);
                }
                else
                {
                    entityList[id] = canvas.createGroupXY(id, name, cCenterX, cCenterY, false);
                }
            }
            else
            {
                if (clientX != 'null' && clientY != 'null')
                {
                    entityList[id] = canvas.createPersonXY(id, name, clientX, clientY, false);
                }
                else
                {
                    entityList[id] = canvas.createPersonXY(id, name, cCenterX, cCenterY, false);
                }
            }
            
            entityList[id]._userID = userID;
            entityList[id].filterID = filters;
            entityList[id].hasOwnFilter = hasOwnFilter;
            
            LoadGroup(canvas, groupStr, entityList[id]);
            LoadRole(canvas, roleStr, entityList[id]);
        }
    }
    
    for (var i = 0; i < entitySplit.length; i++)
    {
        entity = entitySplit[i].split('|');
        
        if (entity.length == 9)
        {
            id = entity[0];
            parentID = entity[3];
            
            if (parentID != 'null')
            {
                canvas.attachToParent(entityList[id], entityList[parentID]);
            }
        }
    }
    
    canvas.checkForGroupCollision();
    canvas.checkForCollision();
}

function LoadGroup(canvas, groupStr, item)
{
    var groups = groupStr.split(';');
    var group;
    
    for (var i = 0; i < groups.length; i++)
    {
        group = groups[i].split('|');
        
        if (group[0] == item._id)
        {
            for (var j = 1; j < group.length; j++)
            {
                canvas.addGroup(group[j]).addItem(item);
            }
        }
    }
}

function LoadRole(canvas, roleStr, item)
{
    var roles = roleStr.split(';');
    var role;
    
    for (var i = 0; i < roles.length; i++)
    {
        role = roles[i].split('|');
        
        if (role[0] == item._id)
        {
            for (var r = 0; r < canvas._roles.length; r++)
            {
                for (var j = 1; j < role.length; j++)
                {
                    if (canvas._roles[r].id == role[j])
                    {
                        canvas._roles[r].addItem(item);
                    }
                }
            }
        }
    }
}