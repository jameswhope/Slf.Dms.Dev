Custom.UI.DashboardTarget = function(item)
{
    var element = document.createElement('div');
    element.id = 'Dashboard';
    element.className = 'DashboardTarget';
    element.style.visibility = 'hidden';
    element.style.zIndex = 9999;
    
    document.body.appendChild(element);
    
    Custom.UI.DashboardTarget.initializeBase(this, [element]);
    
    this._item = item;
    
    this._physicalAlgorithms = new Custom.UI.PhysicalAlgorithms();
    this._interval = 750;
    this._children = new Array();
    this.maxRequestRetries = 3;
    this._httpRequest_retries = 0;
    
    this.initialize();
}

Custom.UI.DashboardTarget.prototype =
{
    get_dropTargetElement: function()
    {
        return this.get_element();
    },
    
    canDrop: function(dragMode, dataType, data)
    {
        return (dataType == 'DashboardItem');
    },
    
    drop : function(dragMode, dataType, data)
    {
        if (this.canDrop(dragMode, dataType, data))
        {
        }
    },
    
    onDragEnterTarget : function(dragMode, dataType, data)
    {
    },
    
    onDragLeaveTarget : function(dragMode, dataType, data)
    {
    },

    onDragInTarget : function(dragMode, dataType, data)
    {
    },
    
    initialize: function()
    {
        Custom.UI.DashboardTarget.callBaseMethod(this, 'initialize');
        Sys.Preview.UI.DragDropManager.registerDropTarget(this);
        
        this._type = this._item.get_dragDataType();
        
        this._elementBlur = Function.createDelegate(this, this.elementBlur);
        
        $addHandler(this.get_element(), 'blur', this._elementBlur);
    },
    
    elementBlur: function(ev)
    {
        this.dispose();
    },
    
    show: function(id)
    {
        var params = new Array();
        
        params[0] = new Array();
        params[0][0] = "id";
        params[0][1] = id;
        
        this.baseShow(params);
    },
    
    baseShow: function(params)
    {
        var parStr;
        
        if (params[0])
        {
            for (var i = 0; i < params.length; i++)
            {
                params[i] = params[i].join('|');
            }
            
            parStr = params.join(';');
        }
        else
        {
            parStr = params;
        }
        
        this._parStr = parStr;
        
        this._breakWait = Function.createDelegate(this, this.breakWait);
        
        $addHandler(this._item.get_element(), 'mouseout', this._breakWait);
        
        this._waitItemComplete = Function.createDelegate(this, this.waitItemComplete);
        
        this.timer = setTimeout(this._waitItemComplete, this._interval);
    },
    
    breakWait: function(ev)
    {
        window._event = ev;
        
        if (this.timer)
        {
            clearTimeout(this.timer);
            this.timer = null;
            this._parStr = null;
        }
        
        $removeHandler(this._item.get_element(), 'mouseout', this._breakWait);
        this._breakWait = null;
        
        this._waitItemComplete = null;
    },
    
    waitItemComplete: function()
    {
        var parStr = this._parStr;
        
        clearTimeout(this.timer);
        this.timer = null;
        this._parStr = null;
        
        var bounds = this._item._canvas._physicalAlgorithms.getBounds(this._item.get_element());
        
        this._item._canvas._physicalAlgorithms.setLocation(this.get_element(), parseInt(bounds.x + (bounds.width / 2)), parseInt(bounds.y + (bounds.height / 2)));
        
        this.get_element().style.backgroundImage = 'url(\'' + customController.getServerRoot() + '/images/loading.gif\')';
        
        this.get_element().style.visibility = 'visible';
        this.get_element().innerHTML = '&nbsp;';
        this.get_element().focus();
        
        this._additionalItemComplete(parStr);
        
        this._waitItemComplete = null;
    },
    
    _additionalItemComplete: function(parStr)
    {
        this.makeHttpRequest(-1, 'Generic', parStr);
    },
    
    addItem: function(item)
    {
        this._children[this._children.length] = item;
    },
    
    removeItem: function(item)
    {
        var newChildren = new Array();
        
        for (var i = 0; i < this._children.length; i++)
        {
            if (this._children[i] != item)
            {
                newChildren[newChildren.length] = this._children[i];
            }
        }
        
        item.dispose();
    },
    
    clearAllitems: function()
    {
        for (var i = 0; i < this._children.length; i++)
        {
            this._children[i].dispose();
        }
        
        this._children = null;
    },
    
    parseDashboardItem: function(item)
    {
        var child;
        var html;
        var x;
        var y;
        var width;
        var height;
        
        for (var i = 0; i < item.childNodes.length; i++)
        {
            child = item.childNodes[i];
            
            if (child.nodeName == 'XML')
            {
                html = child.firstChild.xml;
            }
            
            if (child.nodeName == 'ClientX')
            {
                x = child.text;
            }
            
            if (child.nodeName == 'ClientY')
            {
                y = child.text;
            }
            
            if (child.nodeName == 'ClientWidth')
            {
                width = child.text;
            }
            
            if (child.nodeName == 'ClientHeight')
            {
                height = child.text;
            }
        }
        
        this.addItem(new Custom.UI.DashboardItem(this, html, x, y, width, height));
    },
    
    parseMainXML: function(xml)
    {
        var child;
        
        for (var i = 0; i < xml.childNodes.length; i++)
        {
            child = xml.childNodes[i];
            
            if (child.nodeName == 'GetDashboardResult')
            {
                for (var j = 0; j < child.childNodes.length; j++)
                {
                    this.parseDashboardItem(child.childNodes[j]);
                }
            }
            else if (child.childNodes.length > 0)
            {
                this.parseMainXML(child);
            }
        }
    },
    
    processXML: function()
    {
        if (this._httpRequest)
        {
            if (this._httpRequest.readyState == 4 && this.get_element())
            {
                switch (this._httpRequest.status)
                {
                    case 200:
                        if (this.get_element())
                        {
                            this.get_element().style.backgroundImage = '';
                            this.get_element().innerHTML = '';
                            
                            var objXmlDoc = new ActiveXObject(this._getXmlDomName());
                            objXmlDoc.loadXML(this._httpRequest.responseText);
                            
                            this.parseMainXML(objXmlDoc);
                        }
                        
                        break;
                    case 12029:
                    case 12030:
                    case 12031:
                    case 12152:
                    case 12159:
                        if (this._httpRequest_retries < this.maxRequestRetries)
                        {
                            this._httpRequest = null;
                            this._httpRequest_retries++;
                            this.makeHttpRequest(this._httpRequest_userID, this._httpRequest_scenario, this._httpRequest_params);
                        }
                        else
                        {
                            this.get_element().style.backgroundImage = 'url(\'' + customController.getServerRoot() + '/images/message.png\')';
                            this.get_element().innerText = 'Request Timeout!';
                        }
                        break;
                    default:
                        this.get_element().style.backgroundImage = 'url(\'' + customController.getServerRoot() + '/images/message.png\')';
                        this.get_element().innerHTML = this._httpRequest.responseText;
                        break;
                }
                
                this._httpRequest = null;
                this._httpRequest_userID = null;
                this._httpRequest_scenario = null;
                this._httpRequest_params = null;
            }
        }
    },
    
    _getXmlDomName: function()
    {
        return 'MSXML2.DOMDocument';
    },
    
    makeHttpRequest: function(userID, scenario, params)
    {
        this._httpRequest_userID = userID;
        this._httpRequest_scenario = scenario;
        this._httpRequest_params = params;
        
        this._httpRequest = new ActiveXObject(this._getXmlHttpName());
        
        if (!this._httpRequest)
        {
            return false;
        }
        
        this._processXML = Function.createDelegate(this, this.processXML);
        
        this._httpRequest.onreadystatechange = this._processXML;
        
        var strEnvelope = '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" ' +
                    '   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
                    '   xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
                    '<soap:Body>' +
                    '    <GetDashboard xmlns="http://www.lexxiom.com/Dashboard/">' +
                    '      <userID>' + userID + '</userID>' +
                    '      <scenario>' + scenario + '</scenario>' +
                    '      <params>' + params + '</params>' +
                    '    </GetDashboard>' +
                    '  </soap:Body>' +
                    '</soap:Envelope>';
        
        this._httpRequest.open('POST', '' + customController.getServerRoot() + '/CustomTools/Dashboard/Dashboard.asmx', true);
        this._httpRequest.setRequestHeader('Content-Type', 'text/xml; charset=utf-8');
        this._httpRequest.setRequestHeader('SOAPAction', 'http://www.lexxiom.com/Dashboard/GetDashboard');
        this._httpRequest.send(strEnvelope);
    },
    
    _getXmlHttpName: function()
    {
        return 'MSXML2.XMLHTTP';
    },
    
    dispose: function()
    {
        this.clearAllitems();
        
        if (this._elementBlur)
        {
            $removeHandler(this.get_element(), 'blur', this._elementBlur);
            this._elementBlur = null;
        }
        
        if (this._processXML)
        {
            this._processXML = null;
        }
        
        this._httpRequest = null;
        this._httpRequest_userID = null;
        this._httpRequest_scenario = null;
        this._httpRequest_params = null;
        this._httpRequest_retries = null;
        this.maxRequestRetries = null;
        
        if (this.timer)
        {
            clearTimeout(this.timer);
        }
        
        if (this._breakWait && this._item.get_element())
        {
            $removeHandler(this._item.get_element(), 'mouseout', this._breakWait);
            this._breakWait = null;
        }
        
        this._item = null;
        this._children = null;
        this.timer = null;
        this._parStr = null;
        
        this._waitItemComplete = null;
        
        Sys.Preview.UI.DragDropManager.unregisterDropTarget(this);
        
        document.body.removeChild(this.get_element());
        
        Custom.UI.DashboardTarget.callBaseMethod(this, 'dispose');
    }
}

Custom.UI.DashboardTarget.registerClass('Custom.UI.DashboardTarget',
    Sys.UI.Behavior, Sys.Preview.UI.IDropTarget);