customController.includeCSS('ContextMenu/css/ContextMenu');

Custom.UI.ContextMenu = function(context, x, y, parent)
{
    if (parent)
    {
        this._parent = parent;
    }
    else
    {
        this._parent = null;
    }
    
    this._context = context;
    this._options = new Array();
    this._subMenu = null;
    
    this._menu = document.createElement('div');
    this._menu.style.position = 'absolute';
    this._menu.style.left = x;
    this._menu.style.top = y;
    this._menu.style.zIndex = 9998;
    
    this._optionMouseEnter = Function.createDelegate(this, this.optionMouseEnter);
    
    this._menu.appendChild(this.buildContext(this._context.options));
    
    document.body.appendChild(this._menu);
    
    this._onMenuBlur = Function.createDelegate(this, this.onMenuBlur);
    $addHandler(this._menu, 'blur', this._onMenuBlur);
    
    this._menu.focus();
    
    this._physicalAlgorithms = new Custom.UI.PhysicalAlgorithms();
}

Custom.UI.ContextMenu.prototype =
{
    onMenuBlur: function(ev)
    {
        if (!this.isInAny(ev.clientX, ev.clientY))
        {
            this.killAll();
        }
        
        if (!this._subMenu)
        {
            if (this.isInThis(ev.clientX, ev.clientY))
            {
                if (this._context.options.length > 1 && !this._context.options[0].isElement)
                {
                    this._menu.focus();
                }
            }
            else
            {
                this.dispose();
            }
        }
    },
    
    getTopParent: function()
    {
        var parent = this;
        
        while (parent._parent)
        {
            parent = parent._parent;
        }
        
        return parent;
    },
    
    isInAny: function(x, y)
    {
        return this.isInAnyRec(this.getTopParent(), x, y);
    },
    
    isInAnyRec: function(item, x, y)
    {
        if (item._subMenu)
        {
            return this.isInThis(x, y) || this.isInAnyRec(item._subMenu, x, y);
        }
        
        return this.isInThis(x, y);
    },
    
    isInThis: function(x, y)
    {
        if (this._menu)
        {
            var bounds = this._physicalAlgorithms.getBounds(this._menu);
            
            return (x >= bounds.x && x <= bounds.x + bounds.width &&
                    y >= bounds.y && y <= bounds.y + bounds.height);
        }
        
        return false;
    },
    
    buildContext: function(options)
    {
        var optionTd;
        var addTd;
        var optionTr;
        var del = null;
        
        var optionMain = document.createElement('table');
        optionMain.className = 'ContextMenu';
        optionMain.cellspacing = '0';
        optionMain.cellpadding = '0';
        optionMain.border = '0';
        
        var head = document.createElement('thead');
        var headtr = document.createElement('tr');
        var headth1 = document.createElement('th');
        headtr.appendChild(headth1);
        var headth2 = document.createElement('th');
        headth2.style.width = '12px';
        headtr.appendChild(headth2);
        head.appendChild(headtr);
        optionMain.appendChild(head);
        
        var body = document.createElement('tbody');
        
        for (var i = 0; i < options.length; i++)
        {
            optionTr = document.createElement('tr');
            optionTd = document.createElement('td');
            optionTd.className = 'ContextMenuOption';
            
            if (options[i].isElement)
            {
                optionTd.appendChild(options[i].name);
            }
            else
            {
                optionTd.innerText = options[i].name;
            }
            
            optionTr.setAttribute('event_id', i);
            
            if (options[i].children.length == 0 && options[i].reference)
            {
                del = Function.createDelegate(this, this.genericHandler);
                
                $addHandler(optionTr, 'click', del);
            }
            
            $addHandler(optionTr, 'mouseenter', this._optionMouseEnter);
            $addHandler(optionTr, 'mouseleave', this.optionMouseLeave);
            
            this._options[i] = new Array();
            this._options[i][0] = optionTr;
            this._options[i][1] = del;
            
            optionTr.appendChild(optionTd);
            
            addTd = document.createElement('td');
            
            if (options[i].children.length > 0)
            {
                addTd.innerText = ">";
            }
            
            optionTr.appendChild(addTd);
            body.appendChild(optionTr);
        }
        
        optionMain.appendChild(body);
        
        return optionMain;
    },
    
    getEventArgs: function(option)
    {
        var eventArgs = new Custom.UI.ContextEventArgs();
        eventArgs.args = option.args;
        eventArgs.contextMenu = this.getTopParent();
        
        return eventArgs;
    },
    
    genericHandler: function(ev)
    {
        var target = ev.target;
        
        if (target.tagName == 'TD')
        {
            target = target.parentElement;
        }
        
        var option = this._context.options[target.getAttribute('event_id')];
        
        option.reference(this.getEventArgs(option));
        
        this.killAll();
    },
    
    optionMouseEnter: function(ev)
    {
        window._event = ev;
        
        ev.target.style.backgroundColor = '#0000F0';
        ev.target.style.color = '#FFFFFF';
        
        if (this._subMenu)
        {
            this._subMenu.dispose();
            this._subMenu = null;
        }
        
        if (this._context.options[ev.target.getAttribute('event_id')].children.length > 0)
        {
            var bounds = this._physicalAlgorithms.getBounds(ev.target);
            var context = new Custom.UI.ContextSet();
            context.options = this._context.options[ev.target.getAttribute('event_id')].children;
            this._subMenu = new Custom.UI.ContextMenu(context, bounds.x + bounds.width, bounds.y, this);
        }
    },
    
    optionMouseLeave: function(ev)
    {
        window._event = ev;
        
        this.style.backgroundColor = '';
        this.style.color = '';
    },
    
    killAll: function()
    {
        var parent = this;
        
        while (parent._parent)
        {
            parent = parent._parent;
        }
        
        parent.dispose();
    },
    
    dispose: function()
    {
        if (this._menu)
        {
            if (this._context)
            {
                this._context.dispose();
            }
            
            for (var i = 0; i < this._options.length; i++)
            {
                if (this._optionMouseEnter)
                {
                    $removeHandler(this._options[i][0], 'mouseenter', this._optionMouseEnter);
                }
                
                if (this.optionMouseLeave)
                {
                    $removeHandler(this._options[i][0], 'mouseleave', this.optionMouseLeave);
                }
            }
            
            if (this._onMenuBlur)
            {
                $removeHandler(this._menu, 'blur', this._onMenuBlur);
                
                this._onMenuBlur = null;
            }
            
            this.optionMouseEnter = null;
            this.optionMouseLeave = null;
            this.genericHandler = null;
            
            document.body.removeChild(this._menu);
            this._menu = null;
            
            if (this._subMenu)
            {
                this._subMenu.dispose();
            }
            
            this._subMenu = null;
            
            if (this._parent)
            {
                if (this._parent._menu)
                {
                    this._parent._menu.focus();
                }
            }
            
            this._parent = null;
        }
    }
}


Custom.UI.ContextSet = function()
{
    this.options = new Array();
}

Custom.UI.ContextSet.prototype =
{
    addOption: function(name, reference, object, isElement)
    {
        var id = this.options.length;
        this.options[id] = new Custom.UI.ContextOption(name, reference, object, isElement);
        
        return this.options[id];
    },
    
    dispose: function()
    {
        this.options = null;
    }
}


Custom.UI.ContextOption = function(name, reference, object, isElement)
{
    this.children = new Array();
    
    if (isElement)
    {
        this.isElement = isElement;
    }
    else
    {
        this.isElement = false;
    }
    
    this.name = name;
    
    if (reference)
    {
        if (object)
        {
            this.reference = Function.createDelegate(object, reference);
        }
        else
        {
            this.reference = reference;
        }
    }
    
    this.args = new Array();
}

Custom.UI.ContextOption.prototype =
{
    addOption: function(name, reference, object, isElement)
    {
        var id = this.children.length;
        
        this.children[id] = new Custom.UI.ContextOption(name, reference, object, isElement);
        
        return this.children[id];
    },
    
    addArgs: function(args)
    {
        this.args = args;
    },
    
    addArg: function(arg)
    {
        this.args[this.args.length] = arg;
    },
    
    dispose: function()
    {
        for (var i = 0; i < this.children; i++)
        {
            this.children[i].dispose();
        }
        
        this.children = null;
        this.name = null;
        this.reference = null;
    }
}


Custom.UI.ContextEventArgs = function()
{
    this.args = new Array();
    this.contextMenu = null;
}

Custom.UI.ContextEventArgs.prototype =
{
}