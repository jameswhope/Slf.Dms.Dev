DOMBounds = function(element)
{
    this.x = 0;
    this.y = 0;
    this.width = element.offsetWidth;
    this.height = element.offsetHeight;
    
	while (element)
	{
		this.x += element.offsetLeft;
		this.y += element.offsetTop;
		
		element = element.offsetParent;
	}
}

function GetBounds(element)
{
    return new DOMBounds(element);
    
}

function SetLocation(element, x, y)
{
    element.style.position = 'absolute';
    element.style.left = x;
    element.style.top = y;
}