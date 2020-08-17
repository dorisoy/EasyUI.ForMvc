function LinkFormatFinder() {
    this.findSuitable = function (sourceNode) {
        return dom.parentOfType(sourceNode, ['a']);
    }
}

function LinkFormatter() {
    this.finder = new LinkFormatFinder();

    this.apply = function (range, attributes) {
        var nodes = textNodes(range);
        if (attributes.innerHTML != undefined) {
            var markers = getMarkers(range);
            var document = documentFromRange(range);
            range.deleteContents();
            var a = dom.create(document, 'a', attributes);
            range.insertNode(a);

            if (markers.length > 1) {
                dom.insertAfter(markers[markers.length - 1], a);
                dom.insertAfter(markers[1], a);
                dom[nodes.length > 0 ? 'insertBefore' : 'insertAfter'](markers[0], a);
            }
        } else {
            var formatter = new InlineFormatter([{ tags: ['a']}], attributes);
            formatter.finder = this.finder;
            formatter.apply(nodes);
        }
    }
}

function UnlinkCommand(options) {
    options.formatter = {
        toggle : function(range) {
            new InlineFormatter([{ tags: ['a']}]).remove(textNodes(range));
        }
    };
    
    Command.call(this, options);
}

function LinkCommand(options) {
    Command.call(this, options);

    var attributes;

    this.async = true;

    var formatter = new LinkFormatter();

    this.exec = function () {
        var range = this.getRange();

        var collapsed = range.collapsed;

        range = this.lockRange(true);

        var nodes = textNodes(range);

        var initialText = null;

        var self = this;

        function apply(e) {
            var href = $('#t-editor-link-url', dialog.element).val();

            if (href && href != 'http://') {
                attributes = { href: href };

                var title = $('#t-editor-link-title', dialog.element).val();
                if (title)
                    attributes.title = title;

                var text = $('#t-editor-link-text', dialog.element).val();
                if (text !== initialText)
                    attributes.innerHTML = text;

                var target = $('#t-editor-link-target', dialog.element).is(':checked');
                if (target)
                    attributes.target = '_blank';

                formatter.apply(range, attributes);
            }
            close(e);
            if (self.change)
                self.change();
        }

        function close(e) {
            e.preventDefault();
            dialog.destroy();

            windowFromDocument(documentFromRange(range)).focus();

            self.releaseRange(range);
        }

        var a = nodes.length ? formatter.finder.findSuitable(nodes[0]) : null;

        var shouldShowText = nodes.length <= 1 || (nodes.length == 2 && collapsed);

        var dialog = $t.window.create($.extend({}, this.editor.dialogOptions, {
            title: "\u63d2\u5165\u94fe\u63a5",
            html: new $.easyui.stringBuilder()
                .cat('<div class="t-editor-dialog">')
                    .cat('<ol>')
                        .cat('<li class="t-form-text-row"><label for="t-editor-link-url">\u7f51\u7edc\u5730\u5740</label><input type="text" class="t-input" id="t-editor-link-url"/></li>')
                        .catIf('<li class="t-form-text-row"><label for="t-editor-link-text">\u6587\u672c</label><input type="text" class="t-input" id="t-editor-link-text"/></li>', shouldShowText)
                        .cat('<li class="t-form-text-row"><label for="t-editor-link-title">\u63d0\u793a</label><input type="text" class="t-input" id="t-editor-link-title"/></li>')
                        .cat('<li class="t-form-checkbox-row"><input type="checkbox" id="t-editor-link-target"/><label for="t-editor-link-target">\u5728\u65b0\u7a97\u53e3\u6253\u5f00</label></li>')
                    .cat('</ol>')
                    .cat('<div class="t-button-wrapper">')
                        .cat('<button class="t-dialog-insert t-button">\u63d2\u5165</button>')
                        .cat('&nbsp;&nbsp;')
                        .cat('<button class="t-dialog-close t-button">\u5173\u95ed</button>')
                    .cat('</div>')
                .cat('</div>')
                .string(),
            onClose: close
        }))
            .hide()
            .find('.t-dialog-insert').click(apply).end()
            .find('.t-dialog-close').click(close).end()
            .find('.t-form-text-row input').keydown(function (e) {
                if (e.keyCode == 13)
                    apply(e);
                else if (e.keyCode == 27)
                    close(e);
            }).end()
            // IE < 8 returns absolute url if getAttribute is not used
            .find('#t-editor-link-url').val(a ? a.getAttribute('href', 2) : 'http://').end()
            .find('#t-editor-link-text').val(nodes.length > 0 ? (nodes.length == 1 ? nodes[0].nodeValue : nodes[0].nodeValue + nodes[1].nodeValue) : '').end()
            .find('#t-editor-link-title').val(a ? a.title : '').end()
            .find('#t-editor-link-target').attr('checked', a ? a.target == '_blank' : false).end()
            .show()
            .data('tWindow')
            .center();

        if (shouldShowText && nodes.length > 0)
            initialText = $('#t-editor-link-text', dialog.element).val();

        $('#t-editor-link-url', dialog.element).focus().select();
    },

    this.redo = function () {
        var range = this.lockRange(true);
        formatter.apply(range, attributes);
        this.releaseRange(range);
    }
}

function UnlinkTool(options){
    Tool.call(this, $.extend(options, {command:UnlinkCommand}));
    
    var finder = new InlineFormatFinder([{tags:['a']}]);

    this.init = function($ui) {
        $ui.attr('unselectable', 'on')
           .addClass('t-state-disabled');
    }
    
    this.update = function ($ui, nodes) {
        $ui.toggleClass('t-state-disabled', !finder.isFormatted(nodes))
            .removeClass('t-state-hover');
    }
}
