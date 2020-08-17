(function (a, e) {
    var b = a.easyui;
    b.scripts.push("easyui.window.js");

    function d(f) {
        return f && !(/^([a-z]+:)?\/\//i).test(f)
    }
    function c(f) {
        if (a.browser.msie && a.browser.version < 7) {
            f.find(".t-resize-e,.t-resize-w").css("height", f.height()).end().find(".t-resize-n,.t-resize-s").css("width", f.width()).end().find(".t-overlay").css({
                width: f.width(),
                height: f.height()
            })
        }
    }
    b.fx.zoom = function (f) {
        this.element = f
    };
    b.fx.zoom.prototype = {
        play: function (i, g) {
            var f = this.element.show();
            var j = f.find("> .t-window-content");
            var h = {
                width: j.width(),
                height: j.height(),
                left: parseInt(f.css("left")) || 0,
                top: parseInt(f.css("top")) || 0
            };
            f.css({
                left: h.left + 20,
                top: h.top + 20
            }).animate({
                left: h.left,
                top: h.top
            }, i.openDuration);
            j.css({
                width: h.width - 40,
                height: h.height - 40
            }).animate({
                width: h.width,
                height: h.height
            }, i.openDuration, function () {
                if (g) {
                    g()
                }
            })
        },
        rewind: function (i, g) {
            var f = this.element;
            var j = f.find("> .t-window-content");
            var h = {
                width: j.width(),
                height: j.height(),
                left: parseInt(f.css("left")),
                top: parseInt(f.css("top"))
            };
            j.animate({
                width: h.width - 40,
                height: h.height - 40
            }, i.closeDuration);
            f.animate({
                left: h.left + 20,
                top: h.top + 20
            }, i.closeDuration, function () {
                f.css({
                    left: h.left,
                    top: h.top
                }).hide();
                setTimeout(function () {
                    j.css({
                        width: h.width,
                        height: h.height
                    })
                }, 0);
                if (g) {
                    g()
                }
            })
        }
    };
    b.fx.zoom.defaults = function () {
        return {
            list: [{
                name: "zoom"
            }],
            openDuration: "fast",
            closeDuration: "fast"
        }
    };
    b.window = function (g, k) {
        this.element = g;
        var f = a(g),
			i = a.extend({}, k);
        delete i.title;
        delete i.content;
        a.extend(this, i);
        if (!f.is(".t-window")) {
            f.addClass("t-widget t-window");
            b.window.create(g, k)
        }
        if (!f.is("body")) {
            var j;
            if (f.is(":visible")) {
                j = f.offset();
                f.css({
                    top: j.top,
                    left: j.left
                })
            } else {
                f.css({
                    visibility: "hidden",
                    display: ""
                });
                j = f.offset();
                f.css({
                    top: j.top,
                    left: j.left
                }).css({
                    visibility: "visible",
                    display: "none"
                })
            }
            var h = f.find("iframe").map(function (m) {
                var n = this.getAttribute("src");
                this.src = "";
                return n
            });
            f.toggleClass("t-rtl", f.closest(".t-rtl").length > 0).appendTo(document.body).find("iframe").each(function (m) {
                this.src = h[m]
            })
        }
        this.bringToTop();
        f.find(".t-window-titlebar").andSelf().bind("mousedown", a.proxy(this.bringToTop, this));
        if (this.modal && f.is(":visible")) {
            this.overlay(true).css({
                opacity: 0.5,
                zIndex: parseInt(f.css("zIndex"), 10) - 1
            })
        }
        var l = ".t-window-titlebar .t-link";
        f.delegate(l, "mouseenter", b.hover).delegate(l, "mouseleave", b.leave).delegate(l, "click", a.proxy(this.windowActionHandler, this));
        if (this.resizable) {
            f.delegate(".t-window-titlebar", "dblclick", a.proxy(this.toggleMaximization, this)).append(b.window.getResizeHandlesHtml());
            c(f);
            (function (p) {
                function n(r) {
                    var q = a(p.element);
                    p.initialCursorPosition = q.offset();
                    p.resizeDirection = /t-resize-([nesw]+)/gi.exec(r.$draggable[0].className)[1];
                    p.resizeElement = q.find("> .t-window-content");
                    p.initialSize = {
                        width: p.resizeElement.width(),
                        height: p.resizeElement.height()
                    };
                    p.outlineSize = {
                        left: p.resizeElement.outerWidth() - p.resizeElement.width() + q.outerWidth() - q.width(),
                        top: p.resizeElement.outerHeight() - p.resizeElement.height() + q.outerHeight() - q.height() + q.find("> .t-window-titlebar").outerHeight()
                    };
                    a('<div class="t-overlay" />').appendTo(p.element);
                    q.find(".t-resize-handle").not(r.$draggable).hide();
                    a(document.body).css("cursor", r.$draggable.css("cursor"))
                }
                function m(r) {
                    var q = a(p.element);
                    var s = {
                        e: function () {
                            var t = b.touchLocation(r),
								u = t.x - p.initialCursorPosition.left - p.outlineSize.left;
                            p.resizeElement.width((u < p.minWidth ? p.minWidth : (p.maxWidth && u > p.maxWidth) ? p.maxWidth : u))
                        },
                        s: function () {
                            var u = b.touchLocation(r),
								t = u.y - p.initialCursorPosition.top - p.outlineSize.top;
                            p.resizeElement.height((t < p.minHeight ? p.minHeight : (p.maxHeight && t > p.maxHeight) ? p.maxHeight : t))
                        },
                        w: function () {
                            var t = b.touchLocation(r),
								v = p.initialCursorPosition.left + p.initialSize.width;
                            q.css("left", t.x > (v - p.minWidth) ? v - p.minWidth : t.x < (v - p.maxWidth) ? v - p.maxWidth : t.x);
                            var u = v - t.x;
                            p.resizeElement.width((u < p.minWidth ? p.minWidth : (p.maxWidth && u > p.maxWidth) ? p.maxWidth : u))
                        },
                        n: function () {
                            var u = b.touchLocation(r),
								v = p.initialCursorPosition.top + p.initialSize.height;
                            q.css("top", u.y > (v - p.minHeight) ? v - p.minHeight : u.y < (v - p.maxHeight) ? v - p.maxHeight : u.y);
                            var t = v - u.y;
                            p.resizeElement.height((t < p.minHeight ? p.minHeight : (p.maxHeight && t > p.maxHeight) ? p.maxHeight : t))
                        }
                    };
                    a.each(p.resizeDirection.split(""), function () {
                        s[this]()
                    });
                    c(q);
                    if (a.browser.msie && parseInt(a.browser.version) >= 9) {
                        q[0].style.cssText = q[0].style.cssText
                    }
                    b.trigger(p.element, "resize")
                }
                function o(r) {
                    var q = a(p.element);
                    q.find(".t-overlay").remove().end().find(".t-resize-handle").not(r.$draggable).show();
                    a(document.body).css("cursor", "");
                    if (r.keyCode == 27) {
                        c(q);
                        q.css(p.initialCursorPosition);
                        p.resizeElement.css(p.initialSize)
                    }
                    return false
                }
                new b.draggable({
                    owner: p.element,
                    selector: ".t-resize-handle",
                    scope: p.element.id + "-resizing",
                    distance: 0,
                    start: n,
                    drag: m,
                    stop: o
                })
            })(this)
        }
        if (this.draggable) {
            (function (p) {
                function n(s) {
                    var q = a(p.element),
						t = b.touchLocation(s);
                    p.initialWindowPosition = q.position();
                    b.trigger(g, "dragStart");
                    p.startPosition = {
                        left: t.x - p.initialWindowPosition.left,
                        top: t.y - p.initialWindowPosition.top
                    };
                    var r = q.find(".t-window-actions");
                    if (r.length > 0) {
                        if (p.isRtl == e) {
                            p.isRtl = a(p.element).closest(".t-rtl").length > 0
                        }
                        p.minLeftPosition = r.outerWidth() + parseInt(r.css(p.isRtl ? "left" : "right"), 10) - q.outerWidth()
                    } else {
                        p.minLeftPosition = 20 - q.outerWidth()
                    }
                    a(".t-resize-handle", p.element).hide();
                    a('<div class="t-overlay" />').appendTo(p.element);
                    a(document.body).css("cursor", s.$draggable.css("cursor"))
                }
                function m(r) {
                    var s = b.touchLocation(r),
						q = {
						    left: Math.max(s.x - p.startPosition.left, p.minLeftPosition),
						    top: Math.max(s.y - p.startPosition.top, 0)
						};
                    a(p.element).css(q)
                }
                function o(q) {
                    a(p.element).find(".t-resize-handle").show().end().find(".t-overlay").remove();
                    a(document.body).css("cursor", "");
                    if (q.keyCode == 27) {
                        q.$draggable.closest(".t-window").css(p.initialWindowPosition)
                    }
                    b.trigger(g, "dragEnd");
                    return false
                }
                new b.draggable({
                    owner: p.element,
                    selector: ".t-window-titlebar",
                    scope: p.element.id + "-moving",
                    start: n,
                    drag: m,
                    stop: o
                })
            })(this)
        }
        b.bind(this, {
            open: this.onOpen,
            activated: this.onActivate,
            close: this.onClose,
            refresh: this.onRefresh,
            resize: this.onResize,
            error: this.onError,
            load: this.onLoad,
            dragStart: this.onDragStart,
            dragEnd: this.onDragEnd
        });
        a(window).resize(a.proxy(this.onDocumentResize, this));
        if (d(this.contentUrl)) {
            this.ajaxRequest()
        }
    };
    b.window.prototype = {
        overlay: function (h) {
            var g = a("body > .t-overlay"),
				f = this.element;
            if (g.length == 0) {
                g = a('<div class="t-overlay" />').toggle(h).insertBefore(f)
            } else {
                g.insertBefore(f).toggle(h)
            }
            this.positionOverlay(g);
            return g
        },
        positionOverlay: function (g) {
            var f = a(document);
            if (a.browser.msie && a.browser.version < 7) {
                g.css({
                    width: f.width() - 21,
                    height: f.height(),
                    position: "absolute"
                })
            } else {
                if ((/ipad/gi).test(navigator.appVersion)) {
                    g.css({
                        width: f.width(),
                        height: f.height(),
                        position: "absolute"
                    })
                }
            }
        },
        overlayOnClose: function (g) {
            var f = this;
            var i = a(".t-window").filter(function () {
                var o = a(this);
                return this !== f.element && o.is(":visible") && o.data("tWindow").modal
            });
            var n = f.modal && i.length == 0;
            var l = f.modal ? f.overlay(true) : a(e);
            if (n) {
                if (f.effects.list.length > 0 && f.effects.list[0].name != "toggle") {
                    l.fadeOut(f.effects.closeDuration, function () {
                        if (g) {
                            l.remove()
                        }
                    })
                } else {
                    if (g) {
                        l.remove()
                    } else {
                        l.hide()
                    }
                }
            } else {
                if (i.length > 0) {
                    var m = parseInt(a(".t-overlay").css("zIndex"), 10);
                    var h = 0;
                    var k;
                    i.each(function (p, o) {
                        var q = parseInt(a(o).css("zIndex"), 10);
                        if (q >= h) {
                            h = q;
                            k = a(o)
                        }
                    });
                    var j = k.data("tWindow");
                    j.overlay(true).css("zIndex", h - 1)
                }
            }
        },
        windowActionHandler: function (h) {
            var f = a(h.target).closest(".t-link").find(".t-icon"),
				g = this;
            a.each({
                "t-close": this.close,
                "t-maximize": this.maximize,
                "t-restore": this.restore,
                "t-refresh": this.refresh
            }, function (i, j) {
                if (f.hasClass(i)) {
                    h.preventDefault();
                    j.call(g);
                    return false
                }
            })
        },
        center: function () {
            var f = a(this.element),
				g = a(window);
            f.css({
                left: g.scrollLeft() + Math.max(0, (g.width() - f.width()) / 2),
                top: g.scrollTop() + Math.max(0, (g.height() - f.height()) / 2)
            });
            return this
        },
        title: function (g) {
            var f = a(".t-window-titlebar > .t-window-title", this.element);
            if (!g) {
                return f.text()
            }
            f.text(g);
            return this
        },
        content: function (g) {
            var f = a("> .t-window-content", this.element);
            if (!g) {
                return f.html()
            }
            f.html(g);
            return this
        },
        bringToTop: function () {
            var i = 0,
				h = this,
				g = h.element,
				f = a(".t-window");
            if (f.filter(":visible").length == 1 && a(g).is(":visible")) {
                return
            }
            f.each(function () {
                var j = a(this);
                var k = j.css("zIndex");
                if (!isNaN(k)) {
                    i = Math.max(parseInt(k, 10), i)
                }
                if (this != g && j.find(".t-window-content > iframe").length > 0) {
                    j.find(".t-window-content").append("<div class='t-overlay' />")
                }
            });
            a(g).css("zIndex", i + 2).find(".t-window-content > .t-overlay").remove();
            return h
        },
        open: function (g) {
            var f = a(this.element);
            this.bringToTop();
            if (!b.trigger(this.element, "open")) {
                if (this.modal) {
                    var h = this.overlay(false).css("zIndex", parseInt(f.css("zIndex"), 10) - 1);
                    if (this.effects.list.length > 0 && this.effects.list[0].name != "toggle") {
                        h.css("opacity", 0).show().animate({
                            opacity: 0.5
                        }, this.effects.openDuration)
                    } else {
                        h.css("opacity", 0.5).show()
                    }
                }
                if (!f.is(":visible")) {
                    b.fx.play(this.effects, f, {}, function () {
                        b.trigger(f[0], "activated")
                    })
                }
            }
            if (this.isMaximized) {
                this._documentScrollTop = a(document).scrollTop();
                a("html, body").css("overflow", "hidden")
            }
            return this
        },
        close: function () {
            var f = a(this.element);
            if (f.is(":visible")) {
                if (!b.trigger(this.element, "close")) {
                    this.overlayOnClose();
                    b.fx.rewind(this.effects, f, null, function () {
                        f.hide()
                    })
                }
            }
            if (this.isMaximized) {
                a("html, body").css("overflow", "");
                if (this._documentScrollTop && this._documentScrollTop > 0) {
                    a(document).scrollTop(this._documentScrollTop)
                }
            }
            return this
        },
        toggleMaximization: function (f) {
            if (f && a(f.target).closest(".t-link").length > 0) {
                return
            }
            this[this.isMaximized ? "restore" : "maximize"]()
        },
        restore: function () {
            if (!this.isMaximized) {
                return
            }
            a(this.element).css({
                position: "absolute",
                left: this.restorationSettings.left,
                top: this.restorationSettings.top
            }).find("> .t-window-content").css({
                width: this.restorationSettings.width,
                height: this.restorationSettings.height
            }).end().find(".t-resize-handle").show().end().find(".t-window-titlebar .t-restore").addClass("t-maximize").removeClass("t-restore");
            a("html, body").css("overflow", "");
            if (this._documentScrollTop && this._documentScrollTop > 0) {
                a(document).scrollTop(this._documentScrollTop)
            }
            this.isMaximized = false;
            b.trigger(this.element, "resize");
            return this
        },
        maximize: function (g) {
            if (this.isMaximized) {
                return
            }
            var f = a(this.element),
				h = f.find("> .t-window-content");
            this.restorationSettings = {
                left: f.position().left,
                top: f.position().top,
                width: h.width(),
                height: h.height()
            };
            f.css({
                left: 0,
                top: 0,
                position: "fixed"
            }).find(".t-resize-handle").hide().end().find(".t-window-titlebar .t-maximize").addClass("t-restore").removeClass("t-maximize");
            this._documentScrollTop = a(document).scrollTop();
            a("html, body").css("overflow", "hidden");
            this.isMaximized = true;
            this.onDocumentResize();
            return this
        },
        onDocumentResize: function () {
            if (!this.isMaximized) {
                return
            }
            var f = a(this.element),
				i = f.find("> .t-window-titlebar"),
				g = f.find("> .t-window-content"),
				h = i.is(":visible") ? i.outerHeight() : 0;
            g.css({
                width: a(window).width() - (g.outerWidth() - g.width() + f.outerWidth() - f.width()),
                height: a(window).height() - (g.outerHeight() - g.height() + f.outerHeight() - f.height() + h)
            });
            c(f);
            b.trigger(f, "resize")
        },
        refresh: function () {
            if (d(this.contentUrl)) {
                this.ajaxRequest()
            } else {
                var f = a(this.element).find("> .t-window-content > iframe")[0];
                if (f) {
                    f.src = f.src
                }
            }
            return this
        },
        ajaxRequest: function (h, f) {
            var g = setTimeout(function () {
                a(".t-refresh", this.element).addClass("t-loading")
            }, 100);
            a.ajax({
                type: "GET",
                url: h || this.contentUrl,
                dataType: "html",
                data: f || {},
                cache: false,
                error: a.proxy(function (j, i) {
                    if (b.ajaxError(this.element, "error", j, i)) {
                        return
                    }
                }, this),
                complete: function () {
                    clearTimeout(g);
                    a(".t-refresh", this.element).removeClass("t-loading")
                },
                success: a.proxy(function (i, j) {
                    a(".t-window-content", this.element).html(i);
                    b.trigger(this.element, "refresh")
                }, this)
            })
        },
        destroy: function () {
            a(this.element).remove();
            this.overlayOnClose(true)
        }
    };
    a.extend(b.window, {
        create: function () {
            var g, h, f;
            if (a.isPlainObject(arguments[0])) {
                h = arguments[0]
            } else {
                g = arguments[0];
                h = a.extend({
                    html: g.innerHTML
                }, arguments[1])
            }
            h = a.extend({
                title: "",
                html: "",
                actions: ["Close"],
                visible: true
            }, h);
            f = h.contentUrl;
            var i = new b.stringBuilder().catIf('<div class="t-widget t-window">', !g).cat('<div class="t-window-titlebar t-header">').cat('&nbsp;<span class="t-window-title">').cat(h.title).cat("</span>").cat('<div class="t-window-actions t-header">');
            a.map(h.actions, function (j) {
                i.cat('<a href="#" class="t-link">').cat('<span class="t-icon t-').cat(j.toLowerCase()).cat('">').cat(j).cat("</span></a>")
            });
            i.cat("</div></div>").cat('<div class="t-window-content t-content" style="');
            if (h.width) {
                i.cat("width:").cat(h.width).cat("px;")
            }
            if (h.height) {
                i.cat("height:").cat(h.height).cat("px;")
            }
            if (typeof (h.scrollable) != typeof (e) && h.scrollable === false) {
                i.cat("overflow:hidden;")
            }
            i.cat('">').catIf(h.html, !f || (f && d(f))).catIf('<iframe src="', f, '" title="', h.title, '" frameborder="0" style="border:0;width:100%;height:100%;">This page requires frames in order to show content</iframe>', f && !d(f)).cat("</div>").catIf("</div>", !g);
            if (g) {
                a(g).css("display", h.visible ? "" : "none").html(i.string())
            } else {
                delete h.title;
                return a(i.string()).css("display", h.visible ? "" : "none").appendTo(document.body).eq(0).tWindow(h)
            }
        },
        getResizeHandlesHtml: function () {
            var f = new b.stringBuilder();
            a.each("n e s w se sw ne nw".split(" "), function (g, h) {
                f.cat('<div class="t-resize-handle t-resize-').cat(h).catIf(" t-icon", h == "se").cat('"></div>')
            });
            return f.string()
        }
    });
    a.fn.tWindow = function (f) {
        return b.create(this, {
            name: "tWindow",
            init: function (g, h) {
                return new b.window(g, h)
            },
            success: function (h) {
                var i = h.element,
					g = a(i);
                if (g.is(":visible")) {
                    b.trigger(i, "open");
                    b.trigger(i, "activated")
                }
            },
            options: f
        })
    };
    a.fn.tWindow.defaults = {
        effects: {
            list: [{
                name: "zoom"
            }, {
                name: "property",
                properties: ["opacity"]
            }],
            openDuration: "fast",
            closeDuration: "fast"
        },
        modal: false,
        resizable: true,
        draggable: true,
        minWidth: 50,
        minHeight: 50
    }
})(jQuery);