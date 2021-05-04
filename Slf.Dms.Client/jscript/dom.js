
function AddHandler(eventSource, eventName, handlerName, eventParent)
{
    // TODO: factor into the event function so multiple parents are possible
    //if (eventParent != null)
    //      eventSource.parent = eventParent;
    // IMPL: AddHandler(txtTransDate2, "keypress", "OnKeyPress");

    var eventHandler = function(e) {eventSource[handlerName](e, eventParent);};

    if (eventSource.addEventListener)
    {
          eventSource.addEventListener(eventName, eventHandler, false);
    }
    else if (eventSource.attachEvent)
    { 
          eventSource.attachEvent("on" + eventName, eventHandler);
    }
    else
    {
          var originalHandler = eventSource["on" + eventName];

          if (originalHandler)
          {
                eventHandler = function(e) {originalHandler(e); eventSource[handlerName](e, eventParent);};
          }

          eventSource["on" + eventName] = eventHandler;
    }
}