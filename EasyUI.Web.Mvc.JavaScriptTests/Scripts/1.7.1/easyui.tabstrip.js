(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.tabstrip.js");
    b.tabstrip = function (e, g) {
        this.element = e;
        var d = a(e);
        this.$contentElements = d.find("> .t-content");
        a.extend(this, g);
        if (this.contentUrls) {
            d.find(".t-tabstrip-items > .t-item").each(a.proxy(function (i, j) {
                a(j).find(".t-link").data("ContentUrl", this.contentUrls[i])
            }, this))
        }
        var f = ".t-tabstrip-items > .t-item:not(.t-state-disabled)";
        d.delegate(f, "mouseenter", b.hover).delegate(f, "mouseleave", b.leave).delegate(f, g.activateEvent, b.delegate(this, this._click)).delegate(".t-tabstrip-items > .t-state-disabled .t-link", "click", b.preventDefault);
        b.bind(this, {
            select: a.proxy(function (i) {
                if (i.target == this.element && this.onSelect) {
                    a.proxy(this.onSelect, this.element)(i)
                }
            }, this),
            contentLoad: this.onContentLoad,
            error: this.onError,
            load: this.onLoad
        });
        var h = d.find("li.t-state-active"),
			c = a(this.getContentElement(h.parent().children().index(h)));
        if (c.length > 0 && c[0].childNodes.length == 0) {
            this.activateTab(h.eq(0))
        }
    };
    a.extend(b.tabstrip.prototype, {
        select: function (c) {
            a(c).each(a.proxy(function (e, f) {
                var d = a(f);
                if (d.is(".t-state-disabled,.t-state-active")) {
                    return
                }
                this.activateTab(d)
            }, this))
        },
        enable: function (c) {
            a(c).addClass("t-state-default").removeClass("t-state-disabled")
        },
        disable: function (c) {
            a(c).removeClass("t-state-default").removeClass("t-state-active").addClass("t-state-disabled")
        },
        reload: function (c) {
            var d = this;
            a(c).each(function () {
                var e = a(this),
					f = e.find(".t-link").data("ContentUrl");
                if (f) {
                    d.ajaxRequest(e, a(d.getContentElement(e.index())), null, f)
                }
            })
        },
        _click: function (g, h) {
            var d = a(h),
				f = d.find(".t-link"),
				i = f.attr("href"),
				c = a(this.getContentElement(d.index()));
            if (d.is(".t-state-disabled,.t-state-active")) {
                g.preventDefault();
                return
            }
            if (b.trigger(this.element, "select", {
                item: d[0],
                contentElement: c[0]
            })) {
                g.preventDefault()
            } else {
                var j = f.data("ContentUrl") || (i && (i.charAt(i.length - 1) == "#" || i.indexOf("#" + this.element.id + "-") != -1));
                if (!i || j || (c.length > 0 && c[0].childNodes.length == 0)) {
                    g.preventDefault()
                } else {
                    return
                }
                if (this.activateTab(d)) {
                    g.preventDefault()
                }
            }
        },
        activateTab: function (e) {
            var h = e.parent().children().removeClass("t-state-active").addClass("t-state-default").index(e);
            e.removeClass("t-state-default").addClass("t-state-active");
            var d = this.$contentElements;
            if (d.length == 0) {
                return false
            }
            var f = d.filter(".t-state-active");
            var c = a(this.getContentElement(h));
            var j = this;
            if (c.length == 0) {
                f.removeClass("t-state-active");
                b.fx.rewind(j.effects, f, {});
                return false
            }
            var g = c.is(":empty"),
				i = function () {
				    c.addClass("t-state-active");
				    b.fx.play(j.effects, c, {})
				};
            f.removeClass("t-state-active").stop(false, true);
            b.fx.rewind(j.effects, f, {}, function () {
                if (e.hasClass("t-state-active")) {
                    if (!g) {
                        i()
                    } else {
                        j.ajaxRequest(e, c, function () {
                            if (e.hasClass("t-state-active")) {
                                i()
                            }
                        })
                    }
                }
            });
            return true
        },
        getSelectedTabIndex: function () {
            return a(this.element).find("> ul > li.t-state-active").index()
        },
        getContentElement: function (f) {
            if (isNaN(f - 0)) {
                return
            }
            var c = this.$contentElements,
				e = new RegExp("-" + (f + 1) + "$");
            for (var d = 0, g = c.length; d < g; d++) {
                if (e.test(c[d].id)) {
                    return c[d]
                }
            }
        },
        ajaxRequest: function (d, c, f, j) {
            if (d.find(".t-loading").length) {
                return
            }
            var e = d.find(".t-link"),
				g = {},
				i = null,
				h = setTimeout(function () {
				    i = a('<span class="t-icon t-loading"></span>').prependTo(e)
				}, 100);
            a.ajax({
                type: "GET",
                cache: false,
                url: j || e.data("ContentUrl") || e.attr("href"),
                dataType: "html",
                data: g,
                error: a.proxy(function (l, k) {
                    if (b.ajaxError(this.element, "error", l, k)) {
                        return
                    }
                }, this),
                complete: function () {
                    clearTimeout(h);
                    if (i !== null) {
                        i.remove()
                    }
                },
                success: a.proxy(function (k, l) {
                    c.html(k);
                    if (f) {
                        f.call(this, c)
                    }
                    b.trigger(this.element, "contentLoad", {
                        item: d[0],
                        contentElement: c[0]
                    })
                }, this)
            })
        }
    });
    a.fn.tTabStrip = function (c) {
        return b.create(this, {
            name: "tTabStrip",
            init: function (d, e) {
                return new b.tabstrip(d, e)
            },
            options: c
        })
    };
    a.fn.tTabStrip.defaults = {
        activateEvent: "click",
        effects: b.fx.toggle.defaults()
    }
})(jQuery);