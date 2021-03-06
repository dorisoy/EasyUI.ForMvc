(function (a) {
    var b = a.easyui,
		i = 7,
		h = /^\d+px$/i,
		g = /^\d+(\.\d+)?%$/i;
    b.scripts.push("easyui.splitter.js");

    function d(j) {
        return g.test(j)
    }
    function e(j) {
        return h.test(j)
    }
    function c(j) {
        return !d(j) && !e(j)
    }
    b.splitter = function (l, n) {
        this.element = l;
        var j = this.$element = a(l),
			q = this;
        a.extend(this, n);
        var o = this.orientation.toLowerCase() != "vertical" ? "horizontal" : "vertical",
			p = this.panes;
        this.orientation = o;
        b.bind(this, {
            load: this.onLoad,
            expand: this.onExpand,
            collapse: this.onCollapse,
            contentLoad: this.onContentLoad,
            resize: function (s) {
                s.stopPropagation();
                q.resize.call(q, s);
                if (a.isFunction(q.onResize)) {
                    q.onResize.call(l, s)
                }
            }
        });
        a(window).resize(function () {
            j.trigger("resize")
        });
        var r = ".t-splitbar-draggable-" + o,
			m = ".t-splitbar .t-icon:not(.t-resize-handle)";
        var k = function (s) {
            return function (v) {
                var u = a(v.target),
                    t;
                if (u.closest(".t-splitter")[0] != l) {
                    return
                }
                if (u.is(".t-" + s + "-prev")) {
                    t = u.parent().prev()
                } else {
                    t = u.parent().next()
                }
                if (!b.trigger(l, s, {
                    pane: t[0]
                })) {
                    q[s](t[0])
                }
            }
        };
        j.addClass("t-widget").addClass("t-splitter").children().addClass("t-pane").each(a.proxy(function (t, u) {
            var s = a(u);
            s.data("pane", p ? p[t] : {}).toggleClass("t-scrollable", p ? p[t].scrollable !== false : true);
            this.ajaxRequest(s)
        }, this)).end().trigger("resize").delegate(r, "mouseenter", function () {
            a(this).addClass("t-splitbar-" + o + "-hover")
        }).delegate(r, "mouseleave", function () {
            a(this).removeClass("t-splitbar-" + o + "-hover")
        }).delegate(m, "mouseenter", b.hover).delegate(m, "mouseleave", b.leave).delegate(".t-splitbar .t-collapse-next, .t-splitbar .t-collapse-prev", "click", k("collapse")).delegate(".t-splitbar .t-expand-next, .t-splitbar .t-expand-prev", "click", k("expand")).delegate(".t-splitbar", "dblclick", function (u) {
            var s = a(u.target),
				v = function (x, w) {
				    if (!b.trigger(l, x, {
				        pane: w[0]
				    })) {
				        q[x](w[0])
				    }
				};
            if (s.closest(".t-splitter")[0] != l) {
                return
            }
            var t = s.children(".t-icon:not(.t-resize-handle)");
            if (t.length !== 1) {
                return
            }
            if (t.is(".t-collapse-prev")) {
                v("collapse", s.prev())
            } else {
                if (t.is(".t-collapse-next")) {
                    v("collapse", s.next())
                } else {
                    if (t.is(".t-expand-prev")) {
                        v("expand", s.prev())
                    } else {
                        if (t.is(".t-expand-next")) {
                            v("expand", s.next())
                        }
                    }
                }
            }
        }).children(".t-pane").children(".t-splitter").trigger("resize").end().end().parent().closest(".t-splitter").bind("resize", function () {
            j.trigger("resize")
        });
        this.resizing = new b.splitter.PaneResizing(this)
    };

    function f(j, k) {
        return function (l, n) {
            var m = a(l).data("pane");
            if (arguments.length == 1) {
                return m[j]
            }
            m[j] = n;
            if (k) {
                this.$element.trigger("resize")
            }
        }
    }
    b.splitter.prototype = {
        toggle: function (p, k) {
            var p = a(p),
				r = p.prev(".t-splitbar"),
				n = p.next(".t-splitbar"),
				q = p.data("pane"),
				s = p.prevAll(".t-pane:first").data("pane"),
				m = p.nextAll(".t-pane:first").data("pane"),
				o = this.orientation,
				l = "t-splitbar-" + o + "-hover",
				j = "t-splitbar-draggable-" + o;
            if (arguments.length == 1) {
                k = q.collapsed === undefined ? false : q.collapsed
            }
            r.find(".t-collapse-prev").toggle(k).end().find(".t-collapse-next").toggle(!k);
            r.toggleClass(j, k && q.resizable !== false && (!s || s.resizable !== false)).removeClass(l).find(k ? ".t-expand-next" : ".t-collapse-next").toggleClass("t-expand-next", !k).toggleClass("t-collapse-next", k);
            n.find(".t-collapse-next").toggle(k).end().find(".t-collapse-prev").toggle(!k);
            n.toggleClass(j, k && q.resizable !== false && (!m || m.resizable !== false)).removeClass(l).find(k ? ".t-expand-prev" : ".t-collapse-prev").toggleClass("t-expand-prev", !k).toggleClass("t-collapse-prev", k);
            q.collapsed = !k;
            this.$element.trigger("resize")
        },
        collapse: function (j) {
            this.toggle(j, false)
        },
        expand: function (j) {
            this.toggle(j, true)
        },
        size: f("size", true),
        minSize: f("minSize"),
        maxSize: f("maxSize"),
        ajaxOptions: function (j, k) {
            var l = this;
            return a.extend({
                type: "POST",
                dataType: "html",
                success: function (m) {
                    j.html(m);
                    b.trigger(l.element, "contentLoad", {
                        pane: j[0]
                    })
                }
            }, k)
        },
        ajaxRequest: function (l, n, k) {
            var j = a(l),
				m = j.data("pane");
            if (n || m.contentUrl) {
                j.append("<span class='t-icon t-loading t-pane-loading' />");
                a.ajax(this.ajaxOptions(j, {
                    url: n || m.contentUrl,
                    data: k || {}
                }))
            }
        },
        resize: function () {
            var j = this.$element,
				t = j.children(":not(.t-splitbar):not(.t-ghost-splitbar)"),
				q = this.orientation == "horizontal",
				B = j.children(".t-splitbar").length,
				z = q ? "width" : "height",
				D = j[z]();
            if (B === 0) {
                B = t.length - 1;
                for (var p = 0; p < B; p++) {
                    var k = t.eq(p),
						v = k.data("pane"),
						s = k.next().data("pane");
                    if (!s) {
                        continue
                    }
                    var r = (v.resizable !== false) && (s.resizable !== false),
						A = new b.stringBuilder();
                    A.catIconIf = function (F, E) {
                        if (E) {
                            this.cat("<div class='t-icon ").cat(F).cat("' />")
                        }
                        return this
                    };
                    A.cat("<div class='t-splitbar t-state-default t-splitbar-").cat(this.orientation).catIf(" t-splitbar-draggable-", this.orientation, r && !v.collapsed && !s.collapsed).cat("'>").catIconIf("t-collapse-prev", v.collapsible && !v.collapsed).catIconIf("t-expand-prev", v.collapsible && v.collapsed).catIconIf("t-resize-handle", r).catIconIf("t-collapse-next", s.collapsible && !s.collapsed).catIconIf("t-expand-next", s.collapsible && s.collapsed).cat("</div>");
                    k.after(A.string())
                }
            }
            D -= i * B;
            var x = 0,
				w = 0,
				m = a();
            t.css({
                position: "absolute",
                top: 0
            })[z](function () {
                var E = a(this).data("pane"),
					F;
                if (!E.collapsed && E.size && E.size.indexOf("NaN") != -1) {
                    return false
                } else {
                    if (E.collapsed) {
                        F = 0
                    } else {
                        if (c(E.size)) {
                            m = m.add(this);
                            return
                        } else {
                            F = parseInt(E.size, 10);
                            if (d(E.size)) {
                                F = Math.floor(F * D / 100)
                            }
                        }
                    }
                    w++;
                    x += F;
                    return F
                }
            });
            D -= x;
            var n = m.length,
				o = Math.floor(D / n);
            m.slice(0, n - 1).css(z, o).end().eq(n - 1).css(z, D - (n - 1) * o);
            var C = 0,
				l = q ? "height" : "width",
				u = q ? "left" : "top",
				y = q ? "offsetWidth" : "offsetHeight";
            j.children().css(l, j[l]()).each(function (F, E) {
                E.style[u] = Math.floor(C) + "px";
                C += E[y]
            })
        }
    };
    b.splitter.PaneResizing = function (j) {
        this.owner = j;
        new b.draggable({
            distance: 0,
            owner: j.element,
            selector: ".t-splitbar-draggable-horizontal, .t-splitbar-draggable-vertical",
            scope: j.element.id,
            start: a.proxy(this.start, this),
            drag: a.proxy(this.drag, this),
            stop: a.proxy(this.stop, this)
        })
    };
    b.splitter.PaneResizing.prototype = {
        start: function (k) {
            if (b.isTouch) {
                k.stopImmediatePropagation()
            }
            var z = k.$draggable,
				t = z.prev(),
				q = z.next(),
				u = t.data("pane"),
				r = q.data("pane"),
				l = this.owner.orientation === "horizontal",
				y = l ? "width" : "height",
				x = l ? "offsetWidth" : "offsetHeight",
				j = l ? "height" : "width",
				m = b.touchLocation(k);
            this.positioningProperty = l ? "left" : "top";
            this.mousePositioningProperty = l ? "x" : "y";
            this.previousPane = t;
            this.nextPane = q;
            this.initialSplitBarPosition = parseInt(z[0].style[this.positioningProperty]);
            this.initialMousePosition = m[this.mousePositioningProperty];
            this.ghostSplitBar = a("<div class='t-ghost-splitbar t-ghost-splitbar-" + this.owner.orientation + " t-state-default' />").css(j, k.$draggable[j]()).css(this.positioningProperty, this.initialSplitBarPosition).appendTo(this.owner.$element);
            var s = parseInt(t[0].style[this.positioningProperty]),
				n = parseInt(q[0].style[this.positioningProperty]) + q[0][x] - i,
				B = this.owner.$element.css(y),
				A = function (D) {
				    var C = parseInt(D, 10);
				    return (e(D) ? C : (B * C) / 100) || 0
				},
				w = A(u.minSize),
				v = A(u.maxSize) || n - s,
				p = A(r.minSize),
				o = A(r.maxSize) || n - s;
            this.maxSize = Math.min(n - p, s + v);
            this.minSize = Math.max(s + w, n - o);
            a(document.body).css("cursor", z.css("cursor"))
        },
        drag: function (j) {
            if (b.isTouch) {
                j.stopImmediatePropagation()
            }
            var k = b.touchLocation(j),
				l = Math.min(this.maxSize, Math.max(this.minSize, this.initialSplitBarPosition + (k[this.mousePositioningProperty] - this.initialMousePosition)));
            this.ghostSplitBar.toggleClass("t-restricted-size-" + this.owner.orientation, l == this.maxSize || l == this.minSize)[0].style[this.positioningProperty] = l + "px"
        },
        stop: function (j) {
            if (b.isTouch) {
                j.stopImmediatePropagation()
            }
            if (j.keyCode !== 27) {
                var l = parseInt(this.ghostSplitBar[0].style[this.positioningProperty]),
					m = this.owner.orientation === "horizontal",
					t = m ? "width" : "height",
					s = m ? "offsetWidth" : "offsetHeight",
					p = this.previousPane.data("pane"),
					n = this.nextPane.data("pane"),
					q = l - parseInt(this.previousPane[0].style[this.positioningProperty]),
					o = parseInt(this.nextPane[0].style[this.positioningProperty]) + this.nextPane[0][s] - l - i,
					u = this.owner.$element[t](),
					r = !b.isTouch || (b.isTouch && !isNaN(q) && !isNaN(o));
                u -= i * this.owner.$element.children(".t-splitbar").length;
                var k = this.owner.$element.children(".t-pane").filter(function () {
                    return c(a(this).data("pane").size)
                }).length;
                if (!c(p.size) || k > 1) {
                    if (c(p.size)) {
                        k--
                    }
                    p.size = q + "px"
                }
                if (!c(n.size) || k > 1) {
                    n.size = o + "px"
                }
            }
            this.ghostSplitBar.remove();
            if (j.keyCode !== 27 && r) {
                this.owner.$element.trigger("resize")
            }
            a(document.body).css("cursor", "");
            return false
        }
    };
    a.fn.tSplitter = function (j) {
        return b.create(this, {
            name: "tSplitter",
            init: function (k, l) {
                return new b.splitter(k, l)
            },
            options: j
        })
    };
    a.fn.tSplitter.defaults = {
        orientation: "horizontal"
    }
})(jQuery);