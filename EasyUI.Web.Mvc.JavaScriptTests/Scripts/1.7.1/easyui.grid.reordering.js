(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.grid.reordering.js");
    b.reordering = {};
    b.reordering.initialize = function (c) {
        c.$reorderDropCue = a('<div class="t-reorder-cue"><div class="t-icon t-arrow-down"></div><div class="t-icon t-arrow-up"></div></div>');
        var d = c.$header.children("th").length - 1;
        var f = function (j, i) {
            var l = a.inArray(i, c.columns),
                m = a.grep(c.columns, function (n) {
                    return !n.hidden
                }),
                h = a.inArray(i, m),
                g = a.inArray(c.columns[j], m);
            c.columns.splice(l, 1);
            c.columns.splice(j, 0, i);
            e(c.$columns(), l, j);
            e(c.$tbody.parent().find("> colgroup > col:not(.t-group-col,.t-hierarchy-col)"), h, g);
            e(c.$headerWrap.find("table").find("> colgroup > col:not(.t-group-col,.t-hierarchy-col)"), h, g);
            var k = c.$footer.find("table");
            e(k.find("> colgroup > col:not(.t-group-col,.t-hierarchy-col)"), h, g);
            e(k.find("> tbody > tr.t-footer-template > td:not(.t-group-cell,.t-hierarchy-cell)").add(c.$footer.find("tr.t-footer-template > td:not(.t-group-cell,.t-hierarchy-cell)")), l, j);
            a.each(c.$tbody.children(), function () {
                e(a(this).find(" > td:not(.t-group-cell, .t-hierarchy-cell, .t-detail-cell)"), l, j)
            })
        };
        c.reorderColumn = f;

        function e(j, k, i) {
            var h = j.eq(k);
            var g = j.eq(i);
            h[k > i ? "insertBefore" : "insertAfter"](g)
        }
        new b.draggable({
            owner: c.$header[0],
            selector: ".t-header:not(.t-group-cell,.t-hierarchy-cell)",
            scope: c.element.id + "-reodering",
            cue: function (h) {
                var g = c.columnFromTitle(h.$draggable.text());
                return b.dragCue(g ? g.title : "")
            },
            destroy: function (g) {
                g.$cue.remove()
            }
        });
        new b.droppable({
            owner: c.$header[0],
            scope: c.element.id + "-reodering",
            selector: ".t-header:not(.t-group-cell,.t-hierarchy-cell)",
            over: function (g) {
                var h = a.trim(g.$draggable.text()) == a.trim(g.$droppable.text());
                b.dragCueStatus(g.$cue, h ? "t-denied" : "t-add");
                var i = 0;
                a("> .t-grid-top, > .t-grouping-header", c.element).each(function () {
                    i += a(this).outerHeight()
                });
                if (!h) {
                    c.$reorderDropCue.css({
                        height: g.$droppable.outerHeight(),
                        top: i,
                        left: function () {
                            return g.$droppable.position().left + ((g.$droppable.index() > g.$draggable.index()) ? g.$droppable.outerWidth() : 0)
                        }
                    }).appendTo(c.element)
                }
            },
            out: function (g) {
                c.$reorderDropCue.remove();
                b.dragCueStatus(g.$cue, "t-denied")
            },
            drop: function (h) {
                c.$reorderDropCue.remove();
                if (h.$cue.find(".t-drag-status").is(".t-add")) {
                    var g = c.columnFromTitle(a.trim(h.$draggable.text()));
                    var i = c.$columns().index(h.$droppable.closest(".t-header"));
                    b.trigger(c.element, "columnReorder", {
                        column: g,
                        oldIndex: a.inArray(g, c.columns),
                        newIndex: i
                    });
                    f(i, g);
                    b.trigger(c.element, "repaint")
                }
            }
        })
    }
})(jQuery);