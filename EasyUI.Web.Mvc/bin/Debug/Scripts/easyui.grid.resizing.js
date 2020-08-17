(function ($) {
    var $t = $.easyui;

    $t.scripts.push("easyui.grid.resizing.js");

    $t.resizing = {};

    $t.resizing.initialize = function (grid) {

        var $col, $indicator = $('<div class="t-grid-resize-indicator" />'),
            gridWidth, columnWidth, columnStart, indicatorWidth = 3;

        function cursor(context, value) {
            $('th, th .t-grid-filter, th .t-link', context)
                .add(document.body)
                .css('cursor', value);
        }

        function heightAboveHeader(context) {
            var top = 0;
            $('> .t-grouping-header, > .t-grid-top', context).each(function () {
                top += this.offsetHeight;
            });
            return top;
        }

        function positionResizeHandle($th) {
            var left = 0; 

            $('.t-resize-handle', grid.element).each(function () {
                left += $(this).data('th').outerWidth();
                $(this).css('left', left - indicatorWidth);
            });

            left = -grid.$tbody.closest('.t-grid-content').scrollLeft();

            $th.prevAll('th').add($th).each(function () {
                left += this.offsetWidth;
            });

            var $body = grid.scrollable ? $('.t-grid-content', grid.element) : $('tbody', grid.element);

            // using "clientWidth" and "clientHeight" to exclude the scrollbar
            var width = $body.attr(grid.scrollable ? 'clientWidth' : 'offsetWidth');

            if (left >= width) {
                $indicator.remove();
            } else {
                $indicator.css({
                    left: left,
                    top: heightAboveHeader(grid.element),
                    height: $th.outerHeight() + $body.attr(grid.scrollable ? 'clientHeight' : 'offsetHeight')
                });
                if (!$indicator.parent().length)
                    $indicator.appendTo(grid.element);
            }
        }

        function start(e) {
            var $th = e.$draggable.data('th'),
                contentTable = grid.$tbody.parent();

            if (!grid.scrollable) {
                $col = contentTable.children('colgroup').find('col:eq(' + $th.index() + ')');
            } else {
                $col = grid.$header.parent().prev().find('col:eq(' + $th.index() + ')')
                    .add(contentTable.children('colgroup').find('col:eq(' + $th.index() + ')'));
            }

            columnStart = e.pageX;
            columnWidth = $th.outerWidth();
            gridWidth = grid.$tbody.outerWidth();
        }

        function drag(e) {
            var width = columnWidth + e.pageX - columnStart;
            if (width > 10) {
                $col.css('width', width);
                if (grid.scrollable)
                    grid.$tbody.parent()
                        .add(grid.$headerWrap.find('table'))
                        .add(grid.$footer.find('table'))
                        .css('width', gridWidth + e.pageX - columnStart);

                positionResizeHandle(e.$draggable.data('th'));
            }
        }

        function stop(e) {
            $indicator.remove();
            cursor(grid.element, '');

            var $th = e.$draggable.data('th');

            var newWidth = $th.outerWidth();

            if (grid.onColumnResize && newWidth != columnWidth)
                $t.trigger(grid.element, "columnResize", {
                    column: grid.columns[grid.$columns().index($th)],
                    oldWidth: columnWidth,
                    newWidth: newWidth
                });

            return false;
        }

        function init() {
           var left = 0,
               scope = grid.element.id + '-column-resizing',
               activeHandler;
           
           var draggable = $t.draggable.get(scope);
           
           if (draggable)
               draggable._destroy();
           
           grid.$headerWrap.add(grid.element)
                           .find('> .t-resize-handle')
                           .remove();
           
           grid.$header.find('.t-header:visible').each(function() {
                left += this.offsetWidth;
                var $th = $(this);
                $('<div class="t-resize-handle" />')
                .css({
                    left: left - indicatorWidth,
                    top: grid.scrollable ? 0 : heightAboveHeader(grid.element),
                    width: indicatorWidth * 2
                })
                .appendTo(grid.scrollable ? grid.$headerWrap : grid.element)
                .data('th', $th)
                .mousedown(function() {
                    positionResizeHandle($th);
                    activeHandler = $(this);
                    cursor(grid.element, activeHandler.css('cursor'));
                });
            });
            
            $(document).mouseup(function() {                
                if(activeHandler) {
                    stop({ $draggable: activeHandler });
                    cursor(grid.element, '');
                    activeHandler = null;
                }
            });

            new $t.draggable({
                owner: grid.element,
                selector: '.t-resize-handle',
                scope: scope,
                distance: 0,
                start: start,
                drag: drag,
                stop: stop
            });
        }
        
        init();

        $(grid.element).one('mouseenter', init)
                       .bind('repaint', init);
    }
})(jQuery);
