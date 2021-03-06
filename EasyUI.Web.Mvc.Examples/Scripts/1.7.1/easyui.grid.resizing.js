(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.grid.resizing.js");
    b.resizing = {};
    b.resizing.initialize = function (i) {
        var c, d = a('<div class="t-grid-resize-indicator" />'),
			j, f, e, l = 3;

        function g(q, r) {
            a("th, th .t-grid-filter, th .t-link", q).add(document.body).css("cursor", r)
        }
        function k(q) {
            var r = 0;
            a("> .t-grouping-header, > .t-grid-top", q).each(function () {
                r += this.offsetHeight
            });
            return r
        }
        function n(r) {
            var s = 0;
            a(".t-resize-handle", i.element).each(function () {
                s += a(this).data("th").outerWidth();
                a(this).css("left", s - l)
            });
            s = -i.$tbody.closest(".t-grid-content").scrollLeft();
            r.prevAll("th").add(r).each(function () {
                s += this.offsetWidth
            });
            var q = i.scrollable ? a(".t-grid-content", i.element) : a("tbody", i.element);
            var t = q.attr(i.scrollable ? "clientWidth" : "offsetWidth");
            if (s >= t) {
                d.remove()
            } else {
                d.css({
                    left: s,
                    top: k(i.element),
                    height: r.outerHeight() + q.attr(i.scrollable ? "clientHeight" : "offsetHeight")
                });
                if (!d.parent().length) {
                    d.appendTo(i.element)
                }
            }
        }
        function o(s) {
            var q = s.$draggable.data("th"),
				t = a.inArray(q[0], q.parent().children(":visible")),
				r = i.$tbody.parent();
            if (!i.scrollable) {
                c = r.children("colgroup").find("col:eq(" + t + ")")
            } else {
                c = i.$header.parent().prev().find("col:eq(" + t + ")").add(r.children("colgroup").find("col:eq(" + t + ")")).add(i.$footerWrap.find(">table>colgroup>col:eq(" + t + ")"))
            }
            e = s.pageX;
            f = q.outerWidth();
            j = i.$tbody.outerWidth()
        }
        function h(q) {
            q.$draggable.dragCalled = true;
            var r = f + q.pageX - e;
            if (r > 10) {
                c.css("width", r);
                if (i.scrollable) {
                    i.$tbody.parent().add(i.$headerWrap.find("table")).add(i.$footer.find("table")).css("width", j + q.pageX - e)
                }
                n(q.$draggable.data("th"))
            }
        }
        function p(r) {
            d.remove();
            g(i.element, "");
            if (r.$draggable.dragCalled) {
                var q = r.$draggable.data("th");
                var s = q.outerWidth();
                if (i.onColumnResize && s != f) {
                    b.trigger(i.element, "columnResize", {
                        column: i.columns[i.$columns().index(q)],
                        oldWidth: f,
                        newWidth: s
                    })
                }
            }
            return false
        }
        function m(s) {
            var t = 0,
				u = i.element.id + "-column-resizing",
				q;
            if (s && s.type === "mouseenter") {
                a(i.element).unbind("mouseenter", m)
            }
            var r = b.draggable.get(u);
            if (r) {
                r.destroy()
            }
            i.$headerWrap.add(i.element).find("> .t-resize-handle").remove();
            i.$header.find(".t-header:visible").each(function () {
                t += this.offsetWidth;
                var v = a(this);
                a('<div class="t-resize-handle" />').css({
                    left: t - l,
                    top: i.scrollable ? 0 : k(i.element),
                    width: l * 2
                }).appendTo(i.scrollable ? i.$headerWrap : i.element).data("th", v).mousedown(function () {
                    n(v);
                    q = a(this);
                    g(i.element, q.css("cursor"))
                })
            });
            a(document).mouseup(function () {
                if (q) {
                    p({
                        $draggable: q
                    });
                    q = null
                }
            });
            new b.draggable({
                owner: i.element,
                selector: ".t-resize-handle",
                scope: u,
                distance: 0,
                start: o,
                drag: h,
                stop: p
            })
        }
        m();
        a(i.element).one("mouseenter", m).bind("repaint", m)
    }
})(jQuery);