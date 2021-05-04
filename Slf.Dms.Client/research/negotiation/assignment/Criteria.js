Type.registerNamespace('Custom.UI');

// Criterium
Custom.UI.Criterium = function(column, value)
{
    this.column = column;
    this.value = value;
}

Custom.UI.Criterium.prototype =
{

}

Custom.UI.Criterium.registerClass('Custom.UI.Criterium');


// Criteria
Custom.UI.Criteria = function(argStr)
{
    this.args = this.parseArgs(argStr);
}

Custom.UI.Criteria.prototype =
{
    parseArgs: function(argStr)
    {
        var args = new Array();
        var pairs = argStr.split(';');
        var pair;
        
        for (var i = 0; i < pairs.length; i++)
        {
            pair = pairs[i].split('|');
            args[args.length] = new Custom.UI.Criterium(pair[0], pair[1]);
        }
        
        return args;
    },
    
    getColumn: function(index)
    {
        return this.args[index].column;
    },
    
    getValue: function(index)
    {
        return this.args[index].value;
    },
    
    getValueByColumn: function(column)
    {
        for (var i = 0; i < this.args.length; i++)
        {
            if (this.args[i].column == column)
            {
                return this.args[i].value;
            }
        }
        
        return null;
    },
    
    getCriteria: function()
    {
        return this.args;
    }
}

Custom.UI.Criteria.registerClass('Custom.UI.Criteria');