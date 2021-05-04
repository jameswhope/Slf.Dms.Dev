Type.registerNamespace('DragNDrop');
///////////////////////////////////////////////////////////////////////
// ClientDragSourceBehavior class

DragNDrop.ClientDragSourceBehavior = function(element, SettlementInfo) {
    DragNDrop.ClientDragSourceBehavior.initializeBase(this, [element]);
    this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
    this._SettlementInfo = SettlementInfo;
    this._visual = null;
    this.initialize();
}

DragNDrop.ClientDragSourceBehavior.prototype =
{
    // IDragSource methods
    get_dragDataType: function() {
        return 'DragDropClient';
    },

    getDragData: function(context) {
        return this._SettlementInfo;
    },

    get_dragMode: function() {
        return Sys.Preview.UI.DragMode.Copy;
    },

    onDragStart: function() { },

    onDrag: function() { },

    onDragEnd: function(canceled) {
        if (this._visual)
            this.get_element().parentNode.removeChild(this._visual);
    },

    // Other methods
    initialize: function() {
        DragNDrop.ClientDragSourceBehavior.callBaseMethod(this, 'initialize');
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },

    mouseDownHandler: function(ev) {
        window._event = ev; // Needed internally by _DragDropManager

        this._visual = this.get_element().cloneNode(true);
        this._visual.style.opacity = '0.4';
        this._visual.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(opacity=0.4)';
        this._visual.style.zIndex = 99999;
        this.get_element().parentNode.appendChild(this._visual);
        var location = Sys.UI.DomElement.getLocation(this.get_element());
        Sys.UI.DomElement.setLocation(this._visual, location.x, location.y);

        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },

    dispose: function() {
        if (this._mouseDownHandler)
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        this._mouseDownHandler = null;
        DragNDrop.ClientDragSourceBehavior.callBaseMethod(this, 'dispose');
    }
}

DragNDrop.ClientDragSourceBehavior.registerClass
    ('DragNDrop.ClientDragSourceBehavior', Sys.UI.Behavior, Sys.Preview.UI.IDragSource);

///////////////////////////////////////////////////////////////////////
// DocumentDragSourceBehavior class

DragNDrop.DocumentDragSourceBehavior = function(element, ClientName) {
    DragNDrop.DocumentDragSourceBehavior.initializeBase(this, [element]);
    this._mouseDownHandler = Function.createDelegate(this, this.mouseDownHandler);
    this._ClientName = ClientName;
    this._visual = null;
    this.initialize();
}

DragNDrop.DocumentDragSourceBehavior.prototype =
{
    // IDragSource methods
    get_dragDataType: function() {
        return 'DragDropDocument';
    },

    getDragData: function(context) {
        return this._ClientName;
    },

    get_dragMode: function() {
        return Sys.Preview.UI.DragMode.Copy;
    },

    onDragStart: function() { },

    onDrag: function() { },

    onDragEnd: function(canceled) {
        if (this._visual)
            this.get_element().parentNode.removeChild(this._visual);
    },

    // Other methods
    initialize: function() {
        DragNDrop.DocumentDragSourceBehavior.callBaseMethod(this, 'initialize');
        $addHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
    },

    mouseDownHandler: function(ev) {
        window._event = ev; // Needed internally by _DragDropManager

        this._visual = this.get_element().cloneNode(true);
        this._visual.style.opacity = '0.4';
        this._visual.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(opacity=0.4)';
        this._visual.style.zIndex = 99999;
        this.get_element().parentNode.appendChild(this._visual);
        var location = Sys.UI.DomElement.getLocation(this.get_element());
        Sys.UI.DomElement.setLocation(this._visual, location.x, location.y);

        Sys.Preview.UI.DragDropManager.startDragDrop(this, this._visual, null);
    },

    dispose: function() {
        if (this._mouseDownHandler)
            $removeHandler(this.get_element(), 'mousedown', this._mouseDownHandler);
        this._mouseDownHandler = null;
        DragNDrop.DocumentDragSourceBehavior.callBaseMethod(this, 'dispose');
    }
}

DragNDrop.DocumentDragSourceBehavior.registerClass
    ('DragNDrop.DocumentDragSourceBehavior', Sys.UI.Behavior, Sys.Preview.UI.IDragSource);

///////////////////////////////////////////////////////////////////////
// DocumentDropTargetBehavior class

DragNDrop.DocumentDropTargetBehavior = function(element) {
    DragNDrop.DocumentDropTargetBehavior.initializeBase(this, [element]);
    this._color = null;
    this.initialize();
}

DragNDrop.DocumentDropTargetBehavior.prototype =
{
    // IDropTarget methods
    get_dropTargetElement: function() {
        return this.get_element();
    },

    canDrop: function(dragMode, dataType, data) {
        return (dataType == 'DragDropDocument' && data);
    },

    drop: function(dragMode, dataType, data) {
        if (dataType == 'DragDropDocument' && data) {
            var img = document.createElement('img');
            img.src = data;
            //img.setAttribute('id', 'SIF_' + Math.floor(Math.random() * 100));
            img.setAttribute('border', 1);
            img.setAttribute('height', '25');
            img.setAttribute('width', '25');

            var PayableTo;
            var OverrideReason;
            var instructions = 'None';

            var dvs = this.get_element().parentElement.parentElement.getElementsByTagName('div')
            for (var d in dvs) {
                if (dvs[d].id != undefined) {
                    var dname = dvs[d].id;
                    dname = dname.substring(dname.lastIndexOf('_') + 1);
                    switch (dname) {
                        case 'divAttach':
                            dvs[d].appendChild(img)
                            break;
                        case 'OverrideReasonHidden':
                            OverrideReason = dvs[d].innerHTML;
                            break;
                        default:
                            break;
                    }
                }
            }

            var payTo = this.get_element().parentElement.parentElement.getElementsByTagName('input');
            for (var i in payTo) {
                if (payTo[i].id != undefined) {
                    var iname = payTo[i].id;
                    iname = iname.substring(iname.lastIndexOf('_') + 1);
                    switch (iname) {
                        case 'CheckPayableTextBox':
                            PayableTo = payTo[i].value;
                            break;
                        case 'SpecialInstructionsTextBox':
                            instructions = payTo[i].value;
                            break;
                        default:
                            break;
                    }
                }
            }
            //this.get_element().appendChild(img);
            CallServer('adddocdrop' + '|' + this.get_element().getAttribute('rowID') + '|' + data + '|' + instructions + '|' + PayableTo + '|' + OverrideReason);
        }
    },

    onDragEnterTarget: function(dragMode, dataType, data) {
        // Highlight the drop zone by changing its background
        // color to light gray
        if (dataType == 'DragDropDocument' && data) {
            this._color = this.get_element().parentElement.parentElement.style.backgroundColor;
            this.get_element().parentElement.parentElement.style.backgroundColor = '#E0E0E0';
        }
    },

    onDragLeaveTarget: function(dragMode, dataType, data) {
        // Unhighlight the drop zone by restoring its original
        // background color
        if (dataType == 'DragDropDocument' && data) {
            this.get_element().parentElement.parentElement.style.backgroundColor = this._color;
        }
    },

    onDragInTarget: function(dragMode, dataType, data) { },

    // Other methods
    initialize: function() {
        DragNDrop.DocumentDropTargetBehavior.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },

    dispose: function() {
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        DragNDrop.DocumentDropTargetBehavior.callBaseMethod(this, 'dispose');
    }
}

DragNDrop.DocumentDropTargetBehavior.registerClass
    ('DragNDrop.DocumentDropTargetBehavior', Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);

///////////////////////////////////////////////////////////////////////
// ClientDropTargetBehavior class

DragNDrop.ClientDropTargetBehavior = function(element) {
    DragNDrop.ClientDropTargetBehavior.initializeBase(this, [element]);
    this._color = null;
    this.initialize();
}

DragNDrop.ClientDropTargetBehavior.prototype =
{
    // IDropTarget methods
    get_dropTargetElement: function() {
        return this.get_element();
    },

    canDrop: function(dragMode, dataType, data) {
        return (dataType == 'DragDropClient' && data);
    },

    drop: function(dragMode, dataType, data) {
        if (dataType == 'DragDropClient' && data) {
            //data layout
            //this._SettlementID + '|' + this._SettlementClientID + '|' + this._SettlementCreditorAccountID + '|' +
            //this._SettlementCreditorID + '|' + this._SettlementClientAccountNumber + '|' + this._SettlementClientName;
            var settInfo = data.split('|');
            //check if drop zone is there already
            var Check = this.get_element()
            var divCheck = Check.getElementsByTagName('fieldset');
            var bAdd = true;
            for (i = 0; i < divCheck.length; i++) {
                var dID = divCheck.item(i).id
                var idx = dID.lastIndexOf('_')
                var itemKey = dID.substring(idx + 1);
                if (itemKey == settInfo[0]) {
                    alert('Already added!');
                    bAdd = false;
                }
            }
            if (bAdd == true) {
                var fld = document.createElement('fieldset');
                fld.setAttribute('id', 'item_' + settInfo[0]);
                var lgd = document.createElement('legend');
                var txt = document.createTextNode(settInfo[4] + ' - ' + settInfo[5]);
                lgd.appendChild(txt);
                lgd.innerHTML += " <a href=\'javascript:removeItem(\"item_" + settInfo[0] + "\");\'>(Remove)</a>";
                fld.appendChild(lgd);
                var dropDiv = document.createElement('div');
                dropDiv.setAttribute('id', 'divClientDrop_' + settInfo[0] + '_' + settInfo[1]);
                dropDiv.setAttribute('runat', 'server');
                var divtxt = document.createTextNode('Drop SIF Here');
                dropDiv.appendChild(divtxt);
                var br = document.createElement('br');
                dropDiv.appendChild(br);
                fld.appendChild(dropDiv);
                this.get_element().appendChild(fld);
                var drop = new DragNDrop.DocumentDropTargetBehavior(dropDiv);
                CallServer('addclientdrop' + '|' + this.get_element().parentElement.id + '|' + data);
            }
        }
    },

    onDragEnterTarget: function(dragMode, dataType, data) {
        // Highlight the drop zone by changing its background
        // color to light gray
        if (dataType == 'DragDropClient' && data) {
            this._color = this.get_element().style.backgroundColor;
            this.get_element().style.backgroundColor = '#E0E0E0';
        }
    },

    onDragLeaveTarget: function(dragMode, dataType, data) {
        // Unhighlight the drop zone by restoring its original
        // background color
        if (dataType == 'DragDropClient' && data) {
            this.get_element().style.backgroundColor = this._color;
        }
    },

    onDragInTarget: function(dragMode, dataType, data) { },

    // Other methods
    initialize: function() {
        DragNDrop.ClientDropTargetBehavior.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
    },

    dispose: function() {
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        DragNDrop.ClientDropTargetBehavior.callBaseMethod(this, 'dispose');
    }
}

DragNDrop.ClientDropTargetBehavior.registerClass
    ('DragNDrop.ClientDropTargetBehavior', Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);

///////////////////////////////////////////////////////////////////////
// Script registration

Sys.Application.notifyScriptLoaded();
