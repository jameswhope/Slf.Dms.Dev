Type.registerNamespace('Custom.UI');

Custom.UI.CustomTools = function()
{
}

Custom.UI.CustomTools.prototype =
{
    includeCSS: function(name)
    {
        document.write('<link href="' + this.getServerRoot() + '/CustomTools/' + name + '.css" type="text/css" rel="stylesheet" />');
    },
    
    includeJS: function(name)
    {
        document.write('<script src="' + this.getServerRoot() + '/CustomTools/' + name + '.js" type="text/javascript"></script>');
    },
    
    getServerRoot: function()
    {
        return this._serverRoot;
    }
}

Custom.UI.CustomTools.registerClass('Custom.UI.CustomTools');

var customController = new Custom.UI.CustomTools();