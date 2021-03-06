(function (a) {
    var b = a.easyui,
		c = {
		    single: 0,
		    multi: 1
		};
    b.scripts.push("easyui.panelbar.js");
    a.extend(b, {
        panelbar: function (g, h) {
            this.element = g;
            a.extend(this, h);
            var e = a(g),
				d = e.find("li.t-state-active > .t-content"),
				f = ".t-item:not(.t-state-disabled) > .t-link";
            e.delegate(f, "click", a.proxy(this._click, this)).delegate(f, "mouseenter", b.hover).delegate(f, "mouseleave", b.leave).delegate(".t-item.t-state-disabled > .t-link", "click", b.preventDefault);
            b.bind(this, {
                expand: this.onExpand,
                collapse: this.onCollapse,
                select: a.proxy(function (i) {
                    if (i.target == this.element && this.onSelect) {
                        a.proxy(this.onSelect, this.element)(i)
                    }
                }, this),
                error: this.onError,
                load: this.onLoad
            });
            if (this.contentUrls) {
                e.find("> .t-item").each(a.proxy(function (i, j) {
                    a(j).find(".t-link").data("ContentUrl", this.contentUrls[i])
                }, this))
            }
            if (d.length > 0 && d.is(":empty")) {
                this.expand(d.parent())
            }
        }
    });
    b.panelbar.prototype = {
        expand: function (d) {
            a(d).each(a.proxy(function (f, g) {
                var e = a(g);
                if (!e.hasClass(".t-state-disabled") && e.find("> .t-group, > .t-content").length > 0) {
                    if (this.expandMode == c.single && this._collapseAllExpanded(e)) {
                        return
                    }
                    this._toggleItem(e, false, null)
                }
            }, this))
        },
        collapse: function (d) {
            a(d).each(a.proxy(function (f, g) {
                var e = a(g);
                if (!e.hasClass(".t-state-disabled") && e.find("> .t-group, > .t-content").is(":visible")) {
                    this._toggleItem(e, true, null)
                }
            }, this))
        },
        toggle: function (e, d) {
            a(e).each(function () {
                a(this).toggleClass("t-state-default", d).toggleClass("t-state-disabled", !d)
            })
        },
        enable: function (d) {
            this.toggle(d, true)
        },
        disable: function (d) {
            this.toggle(d, false)
        },
        _click: function (i) {
            var g = a(i.target),
				j = this.element;
            if (g.closest(".t-widget")[0] != j) {
                return
            }
            var f = g.closest(".t-link"),
				d = f.closest(".t-item");
            a(".t-state-selected", j).removeClass("t-state-selected");
            f.addClass("t-state-selected");
            if (b.trigger(j, "select", {
                item: d[0]
            })) {
                i.preventDefault()
            }
            var h = d.find("> .t-content, > .t-group"),
				k = f.attr("href"),
				l = f.data("ContentUrl") || (k && (k.charAt(k.length - 1) == "#" || k.indexOf("#" + j.id + "-") != -1));
            if (l || h.length > 0) {
                i.preventDefault()
            } else {
                return
            }
            if (this.expandMode == c.single) {
                if (this._collapseAllExpanded(d)) {
                    return
                }
            }
            if (h.length != 0) {
                var m = h.is(":visible");
                if (!b.trigger(j, !m ? "expand" : "collapse", {
                    item: d[0]
                })) {
                    this._toggleItem(d, m, i)
                }
            }
        },
        _toggleItem: function (f, i, h) {
            var g = f.find("> .t-group");
            if (g.length) {
                this._toggleGroup(g, i);
                if (h != null) {
                    h.preventDefault()
                }
            } else {
                var j = f.parent().children().index(f),
					d = f.find("> .t-content");
                if (d.length) {
                    if (h != null) {
                        h.preventDefault()
                    }
                    if (!d.is(":empty")) {
                        this._toggleGroup(d, i)
                    } else {
                        this._ajaxRequest(f, d, i)
                    }
                }
            }
        },
        _toggleGroup: function (d, e) {
            if (d.is(":visible") != e || d.data("animating")) {
                return
            }
            d.data("animating", true).parent().toggleClass("t-state-default", e).toggleClass("t-state-active", !e).find("> .t-link > .t-icon").toggleClass("t-arrow-up", !e).toggleClass("t-panelbar-collapse", !e).toggleClass("t-arrow-down", e).toggleClass("t-panelbar-expand", e);
            b.fx[!e ? "play" : "rewind"](this.effects, d, null, function () {
                d.data("animating", false)
            })
        },
        _collapseAllExpanded: function (d) {
            if (d.find("> .t-link").hasClass("t-header")) {
                if (d.find("> .t-content, > .t-group").is(":visible") || d.find("> .t-content, > .t-group").length == 0) {
                    return true
                } else {
                    a(this.element).children().find("> .t-content, > .t-group").filter(function () {
                        return a(this).is(":visible")
                    }).each(a.proxy(function (f, e) {
                        this._toggleGroup(a(e), true)
                    }, this))
                }
            }
        },
        _ajaxRequest: function (d, f, h) {
            var j = d.find(".t-panelbar-collapse, .t-panelbar-expand"),
				e = d.find(".t-link"),
				i = setTimeout(function () {
				    j.addClass("t-loading")
				}, 100),
				g = {};
            a.ajax({
                type: "GET",
                cache: false,
                url: e.data("ContentUrl") || e.attr("href"),
                dataType: "html",
                data: g,
                error: a.proxy(function (l, k) {
                    if (b.ajaxError(this.element, "error", l, k)) {
                        return
                    }
                }, this),
                complete: function () {
                    clearTimeout(i);
                    j.removeClass("t-loading")
                },
                success: a.proxy(function (k, l) {
                    f.html(k);
                    this._toggleGroup(f, h)
                }, this)
            })
        }
    };
    a.fn.tPanelBar = function (d) {
        return b.create(this, {
            name: "tPanelBar",
            init: function (e, f) {
                return new b.panelbar(e, f)
            },
            options: d
        })
    };
    a.fn.tPanelBar.defaults = {
        effects: b.fx.property.defaults("height")
    }
})(jQuery);