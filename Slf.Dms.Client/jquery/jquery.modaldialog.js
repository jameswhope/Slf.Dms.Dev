$.widget("dms.modaldialog", {

    options: {
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
    },

    _dialogWindow: {},

    _create: function() {
        var $this = this;
        var iframe = $('<iframe id="iframeDialog" frameborder="0"/>');
        if (!this.options.scrollable) {
            iframe.attr("scrolling", "no");
        }
        this._dialogWindow = this.element.append(iframe).dialog({
            autoOpen: true,
            modal: true,
            resizable: this.options.resizable,
            width: this.options.width,
            height: this.options.height,
            position: this.options.position,
            title: this.options.title,
            open: function() {
                iframe.attr("src", $this.options.url);
                iframe.css("width", "100%");
                iframe.css("height", "100%");
                iframe.parent().css("padding", "0px");
            },
            close: function() {
                $this.options.onClose.call(this);
                iframe.attr("src", "");
                $(this).dialog('destroy').remove();
                iframe = null;
            }
        });
    },

    close: function() {
        this._dialogWindow.dialog('close');
    },

    dialogArguments: function(value) {
        if (value === undefined) {
            return this.options.dialogArguments;
        } else {
            this.options.dialogArguments = value;
        }
    },

    returnValue: function(value) {
        if (value === undefined) {
            return this.options.returnValue;
        } else {
            this.options.returnValue = value;
        }
    },

    getDlgWindow: function() {
        this._dialogWindow;
    },

    destroy: function() {
        $.Widget.prototype.destroy.call(this);
    }

});

function ConfirmationModalDialog(args) {
    //args window: , title: , callback: , message:, source:
    if (!args.source && args.window.baseurl){
        args.source = args.window.baseurl + 'util/pop/confirm.aspx';
    }
    args.window.dialogArguments = args.window;
    var url = args.source + '?f=' + args.callback + '&t=' + args.title + '&m=' + args.message;
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
        title: args.title,
        dialogArguments: args.window,
        resizable: false,
        scrollable: false,
        height: 350, width: 400
    });
}


function AlertModal(args) {
    var alertdlg = $('<div/>').appendTo("body").dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        scrollable: false,
        title: args.title,
        height: args.height,
        width: args.width,
        buttons: {
            Ok: function() {
                $(this).dialog("close");
            }
        }
    });
    
    var icontype = '';
    if (args.type) {
        switch (args.type) {
            case "error":
                icontype = 'ui-icon-circle-close';
                break;
            case "info":
                icontype = 'ui-icon-info';
                break;
            case "warning":
                icontype = 'ui-icon-alert';
                break;
            case "success":
                icontype = 'ui-icon-circle-check';
                break;
            default:
                icontype = args.type;
        } 
    }
    alertdlg.empty().append('<p></p><p><span class="ui-icon ' + icontype + '" style="float:left; margin:0 7px 50px 0;"></span>' + args.message + '</p><p></p>').dialog("open");  
}

