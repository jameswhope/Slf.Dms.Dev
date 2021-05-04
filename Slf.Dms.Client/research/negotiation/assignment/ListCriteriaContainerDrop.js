Custom.UI.ListCriteriaContainerDrop = function(dragElement, element)
{
    Custom.UI.ListCriteriaContainerDrop.initializeBase(this, [element]);
    
    this.initialize();
    
    this._dragElement = dragElement;
}

Custom.UI.ListCriteriaContainerDrop.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (data && dataType == 'ListCriteriaItem' && data.get_element() && data.parentCriteriaID == this._dragElement._criteriaID &&
            data._parent != this._dragElement);
    },
    
    drop: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this._dragElement.attachItem(data);
        }
        
        this._dragElement.get_element().style.color = '#000000';
    },
    
    onDragEnterTarget: function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
            this._dragElement.get_element().style.color = '#A00000';
        }
    },
    
    onDragLeaveTarget: function(dragMode, dataType, data)
    {
        this._dragElement.get_element().style.color = '#000000';
    },
    
    onDragInTarget: function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.ListCriteriaContainerDrop.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },
    
    setLocation: function(x, y)
    {
        SetLocation(this.get_element(), x, y);
    },
    
    getLocation: function()
    {
        GetLocation(this.get_element());
    },
    
    dispose: function()
    {
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        Custom.UI.ListCriteriaContainerDrop.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.ListCriteriaContainerDrop.registerClass('Custom.UI.ListCriteriaContainerDrop',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);