function modalDialog() {
    this.frame = null;
    this.dialogWindow = null;
    this.defaultOptions = {
        url: null,
        dialogArguments: null,
        height: 'auto',
        width: 'auto',
        position: 'center',
        resizable: true,
        scrollable: true,
        onClose: function() { },
        returnValue: null,
        title: ''
    };
    this.options = null;
}

modalDialog.prototype.open = function(options) {
    var $this = this;
    $this.options = $.extend({}, this.defaultOptions, options);
    $this.frame = $('<iframe id="iframeDialog" frameborder="0" />');

    $this.dialogWindow = $("<div></div>").append(this.frame).appendTo("body").dialog({
        autoOpen: true,
        modal: true,
        resizable: $this.options.resizable,
        width: $this.options.width,
        height: $this.options.height,
        position: $this.options.position,
        title: $this.options.title,
        open: function() {
            $this.frame.attr("src", $this.options.url);
            $this.frame.css("width", "100%");
            $this.frame.css("height", "100%");
            $this.frame.parent().css("padding", "0px");
        },
        close: function() {
            $this.options.onClose.call(this);
            $this.frame.attr("src", "");
            $(this).dialog('destroy').remove();
        }
    });
}

modalDialog.prototype.close = function() {
    this.dialogWindow.dialog('close');
}

modalDialog.prototype.getReturnValue = function() {
    return this.options.returnValue;
}

modalDialog.prototype.setReturnValue = function(value) {
    this.options.returnValue = value;
}

modalDialog.prototype.getDialogArguments = function() {
    return this.options.dialogArguments;
}

modalDialog.prototype.setDialogArguments = function(value) {
    this.options.dialogArguments = value;
}


