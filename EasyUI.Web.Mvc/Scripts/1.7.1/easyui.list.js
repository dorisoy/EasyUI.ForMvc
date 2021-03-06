(function (a) {
    var b = a.easyui;
    var e = /\s+/;
    b.scripts.push("easyui.list.js");
    b.list = {
        htmlBuilder: function (i, h, k) {
            var n, m, j = i.id,
				l = i.name,
				g = new b.stringBuilder(),
				f = a(i);
            if (k) {
                m = f.find("option:selected").text();
                n = f.val()
            } else {
                m = i.value
            }
            function o() {
                return a(['<div class="t-widget', h, 't-header"></div>'].join(" "))
            }
            this.render = function () {
                f.wrap(o()).hide();
                var p = a('<div class="t-dropdown-wrap t-state-default"></div>').insertBefore(f);
                this.text({
                    builder: g,
                    text: m,
                    id: j,
                    name: l
                }).appendTo(p);
                a('<span class="t-select"><span class="t-icon t-arrow-down">select</span></span>').appendTo(p);
                if (k) {
                    g.buffer = [];
                    a(g.cat('<input style="display:none;" type="text" ').catIf('value="', n, '" ', n).catIf('name="', l, '" ', l).cat("/>").string()).insertAfter(p)
                }
            };
            this.text = function (p) {
                return a(['<span class="t-input">', p.text || "&nbsp;", "</span>"].join(""))
            }
        },
        initialize: function () {
            this.previousValue = this.value();
            b.bind(this, {
                dataBinding: this.onDataBinding,
                dataBound: this.onDataBound,
                error: this.onError,
                open: this.onOpen,
                close: this.onClose,
                valueChange: this.onChange,
                load: this.onLoad
            })
        },
        common: function () {
            this.open = function () {
                if (!this.loader.isAjax() && (!this.data || this.data.length == 0)) {
                    return
                }
                var f = this.$wrapper || this.$element,
					g = this.dropDown,
					h = g.$element.css("z-index");
                var i = {
                    offset: f.offset(),
                    outerHeight: f.outerHeight(),
                    outerWidth: f.outerWidth(),
                    zIndex: h && h != "auto" ? h : b.getElementZIndex(f[0])
                };
                if (g.$items) {
                    g.open(i)
                } else {
                    this.fill(function () {
                        g.open(i)
                    })
                }
            };
            this.close = function () {
                this.dropDown.close()
            };
            this.dataBind = function (f, o) {
                this.data = f = (f || []);
                var k = -1,
					m = f.length,
					n = this.placeholder;
                if (n && f[0] && f[0].Text !== n) {
                    var g = [{
                        Text: n,
                        Value: ""
                    }];
                    for (var j = 0; j < m; j++) {
                        g.push(f[j])
                    }
                    this.data = f = g
                }
                for (var h = 0; h < m; h++) {
                    var l = f[h];
                    if (l) {
                        if (l.Selected) {
                            k = h
                        }
                    }
                }
                this.dropDown.dataBind(f, this.encoded);
                if (k != -1) {
                    this.index = k;
                    this.select(k)
                }
                if (!o) {
                    this.text("");
                    this.$element.val("");
                    if (this.filteredDataIndexes) {
                        this.filteredDataIndexes = null
                    }
                    this.previousValue = this.$element.val();
                    this._oldIndex = this.selectedIndex
                }
            };
            this.highlight = function (f) {
                var k = function (i) {
                    var l = i.dropDown;
                    i.close();
                    if (!l.$items) {
                        l.dataBind(i.data, i.encoded)
                    }
                    l.$items.removeClass("t-state-selected").eq(h).addClass("t-state-selected")
                };
                var h = -1;
                if (!this.data) {
                    return h
                }
                if (!isNaN(f - 0)) {
                    if (f > -1 && f < this.data.length) {
                        h = f;
                        k(this)
                    }
                } else {
                    if (a.isFunction(f)) {
                        for (var g = 0, j = this.data.length; g < j; g++) {
                            if (f(this.data[g])) {
                                h = g;
                                break
                            }
                        }
                        if (h != -1) {
                            k(this)
                        }
                    } else {
                        h = this.dropDown.highlight(f)
                    }
                }
                return h
            }
        },
        filtering: function () {
            this.filter = function (g) {
                g.isFiltered = true;
                var o = true,
					h = g.data,
					l = g.$text[0],
					s = l.value,
					t = g.trigger,
					i = g.dropDown,
					r = true;
                if (g.minChars == 0 && s.length == 0) {
                    r = false
                }
                s = this.multiple(s);
                if (g.minChars > 0 && s.length < g.minChars) {
                    return
                }
                var k = g.filter;
                if (g.loader.isAjax()) {
                    if (r && g.cache && h && h.length > 0) {
                        g.filters[k](g, h, s);
                        var j = g.filteredDataIndexes;
                        if ((j && j.length > 0) || (k == 0 && g.selectedIndex != -1)) {
                            o = false
                        }
                    }
                    if (o) {
                        var p = {};
                        p[g.queryString.text] = s;
                        g.loader.ajaxRequest(function (v) {
                            var x = g.trigger;
                            var w = g.dropDown;
                            if (v && v.length == 0) {
                                w.close();
                                w.dataBind();
                                return
                            }
                            g.data = v;
                            b.trigger(g.element, "dataBound");
                            g.filters[k](g, v, s);
                            var u = w.$items;
                            if (u.length > 0) {
                                if (!w.isOpened()) {
                                    x.open()
                                }
                                g.filtering.autoFill(g, u.first().text())
                            } else {
                                x.close()
                            }
                        }, {
                            data: p
                        })
                    }
                } else {
                    o = false;
                    g.filters[k](g, g.data, s)
                }
                if (!o) {
                    var f = i.$items;
                    if (!f) {
                        return
                    }
                    var m = f.length,
						q = g.selectedIndex;
                    var n = k == 0 ? q != -1 ? f[q].innerText || f[q].textContent : "" : f.length > 0 ? f.first().text() : "";
                    this.autoFill(g, n);
                    if (m == 0) {
                        t.close()
                    } else {
                        if (!i.isOpened()) {
                            t.open()
                        }
                    }
                }
            };
            this.multiple = function (f) {
                return f
            }
        },
        filters: function () {
            this.filters = [function f(h, j, m) {
                if (!j || j.length == 0) {
                    return
                }
                var k = h.dropDown;
                var g = k.$items;
                if (!g || g.length == 0 || h.loader.isAjax()) {
                    k.dataBind(j, h.encoded);
                    g = k.$items
                }
                for (var l = 0, o = j.length; l < o; l++) {
                    if (j[l].Text.slice(0, m.length).toLowerCase() == m.toLowerCase()) {
                        var n = g[l];
                        h.selectedIndex = l;
                        k.highlight(n);
                        k.scrollTo(n);
                        return
                    }
                }
                g.removeClass("t-state-selected");
                h.selectedIndex = -1;
                b.list.highlightFirstOnFilter(h, g)
            },
			c(false, function (g, h) {
			    return h.slice(0, g.length).toLowerCase() == g.toLowerCase()
			}), c(true, function (g, h) {
			    return h && h.toLowerCase().indexOf(g.toLowerCase()) != -1
			})]
        },
        loader: function (g) {
            this.ajaxError = false;
            this.component = g;
            this.isAjax = function () {
                return g.ajax || g.ws || g.onDataBinding
            };

            function f(h, i) {
                var j = {
                    url: (g.ajax || g.ws)["selectUrl"],
                    type: "POST",
                    data: {},
                    dataType: "text",
                    error: function (l, k) {
                        g.loader.ajaxError = true;
                        if (b.ajaxError(g.element, "error", l, k)) {
                            return
                        }
                    },
                    complete: a.proxy(function () {
                        this.hideBusy()
                    }, g.loader),
                    success: function (k, m, n) {
                        try {
                            k = eval("(" + k + ")")
                        } catch (l) {
                            if (!b.ajaxError(g.element, "error", n, "parseeror")) {
                                alert("Error! The requested URL did not return JSON.")
                            }
                            g.loader.ajaxError = true;
                            return
                        }
                        k = k.d || k;
                        if (h) {
                            h.call(g, k)
                        }
                    }
                };
                a.extend(j, i);
                if (g.ws) {
                    j.data = b.toJson(j.data);
                    j.contentType = "application/json; charset=utf-8"
                }
                return j
            }
            this.ajaxRequest = function (h, j) {
                var i = {};
                if (b.trigger(g.element, "dataBinding", i)) {
                    return
                }
                if (g.ajax || g.ws) {
                    this.showBusy();
                    a.ajax(f(h, {
                        data: a.extend({}, j ? j.data : {}, i.data)
                    }))
                } else {
                    if (h) {
                        h.call(g, g.data)
                    }
                }
            }, this.showBusy = function () {
                this.busyTimeout = setTimeout(a.proxy(function () {
                    this.component.$wrapper.find("> .t-dropdown-wrap .t-icon").addClass("t-loading")
                }, this), 100)
            }, this.hideBusy = function () {
                clearTimeout(this.busyTimeout);
                this.component.$wrapper.find("> .t-dropdown-wrap .t-icon").removeClass("t-loading")
            }
        },
        trigger: function (f) {
            this.component = f;
            this.change = function () {
                var g = f.previousValue;
                var h = f.value();
                if (g == undefined || h != g) {
                    b.trigger(f.element, "valueChange", {
                        value: h
                    });
                    f._oldIndex = f.selectedIndex
                } else {
                    if (f.selectedIndex !== f._oldIndex) {
                        b.trigger(f.element, "valueChange", {
                            value: h
                        });
                        f._oldIndex = f.selectedIndex
                    }
                }
                f.previousValue = f.value()
            };
            this.open = function () {
                var g = f.dropDown;
                if ((g.$items && g.$items.length > 0) && !g.isOpened() && !b.trigger(f.element, "open")) {
                    f.open()
                }
            };
            this.close = function () {
                var g = f.dropDown;
                if ((g.$element.is(":animated") || g.isOpened()) && !b.trigger(f.element, "close")) {
                    f.close()
                }
            }
        },
        retrieveData: function (l) {
            var j = [];
            var g = a(l).find("option");
            for (var h = 0, k = g.length; h < k; h++) {
                var f = g.eq(h);
                j[h] = {
                    Text: f.text(),
                    Value: f.val(),
                    Selected: f.is(":selected")
                }
            }
            return j
        },
        highlightFirstOnFilter: function (g, f) {
            if (g.highlightFirst) {
                f.first().addClass("t-state-selected");
                g.dropDown.scrollTo(f[0])
            }
        },
        moveToEnd: function (f) {
            if (f.createTextRange) {
                var g = f.createTextRange();
                g.moveStart("textedit", 1);
                g.select()
            }
        },
        selection: function (h, j, g) {
            try {
                if (h.createTextRange) {
                    var i = h.createTextRange();
                    i.collapse(true);
                    i.moveStart("character", j);
                    i.moveEnd("character", g - j);
                    i.select()
                } else {
                    if (h.selectionStart) {
                        h.selectionStart = j;
                        h.selectionEnd = g
                    }
                }
            } catch (f) { }
        },
        updateTextAndValue: function (f, g, i) {
            f.text(g);
            var h = i === null ? g : i;
            f.$element.val(h)
        },
        getZIndex: function (f) {
            var g = "auto";
            a(f).parents().andSelf().each(function () {
                g = a(this).css("zIndex");
                if (Number(g)) {
                    g = Number(g) + 1;
                    return false
                }
            });
            return g
        },
        keycodes: [8, 9, 13, 27, 37, 38, 39, 40, 35, 36]
    };

    function c(g, f) {
        return function (i, j, m) {
            if (!j || j.length == 0) {
                return
            }
            var k = a.map(j, function (o, n) {
                var p = o.Text;
                if (f(m, p !== undefined ? p : o)) {
                    return n
                }
            });
            var l = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + m.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", g ? "ig" : "i");
            i.filteredDataIndexes = k;
            i.selectedIndex = -1;
            i.dropDown.onItemCreate = function (n) {
                if (m) {
                    n.html = n.html.replace(l, "<strong>$1</strong>")
                }
            };
            i.dropDown.dataBind(a.map(k, function (o, n) {
                return j[o]
            }), i.encoded);
            var h = i.dropDown.$items;
            h.removeClass("t-state-selected");
            b.list.highlightFirstOnFilter(i, h)
        }
    }
    function d(g, f, k) {
        if (!g || !f) {
            return null
        }
        var l = k.length;
        k = k.toLowerCase();
        for (var h = 0, j = g.length; h < j; h++) {
            if (g[h].Text.slice(0, l).toLowerCase() == k) {
                return f[h]
            }
        }
    }
    b.dropDownList = function (k, o) {
        if (o && o.enabled === undefined) {
            o.enabled = !a(k).is("[disabled]")
        }
        a.extend(this, o);
        var l = k.nodeName.toLowerCase() == "select";
        if (l && !this.data) {
            this.data = b.list.retrieveData(k);
            new b.list.htmlBuilder(k, "t-dropdown", l).render();
            k = k.previousSibling
        }
        var i = "";
        this.element = k;
        var q = this;
        var f = this.$element = a(k).closest("form").bind("reset", function () {
            setTimeout(function () {
                q.value(k.value)
            })
        }).end();
        this.loader = new b.list.loader(this);
        this.trigger = new b.list.trigger(this);
        this.$wrapper = f.closest(".t-dropdown");
        var g = this.$text = this.$wrapper.find("> .t-dropdown-wrap > .t-input");
        if (!this.$wrapper.attr("tabIndex")) {
            this.$wrapper.attr("tabIndex", 0)
        }
        this.dropDown = new b.dropDown({
            attr: this.dropDownAttr,
            effects: this.effects,
            onClick: a.proxy(function (s) {
                this.select(s.item);
                this.trigger.change();
                this.trigger.close();
                this.$wrapper.focus()
            }, this)
        });
        this.dropDown.$element.css("direction", this.$wrapper.closest(".t-rtl").length ? "rtl" : "");
        var r = function (u) {
            var s = "class",
                t = f.attr(s);
            if ((u.attrName && u.attrName == "class") || (u.propertyName && u.propertyName == "className")) {
                var v = f.prev(".t-dropdown-wrap");
                var w = /\b(t-state-[\w]+)\b/.exec(v.attr(s));
                if (!(w && w[0])) {
                    w = ""
                } else {
                    w = w[0]
                }
                if (t != v.attr(s)) {
                    v.attr(s, t).addClass("t-dropdown-wrap " + w)
                }
            }
        };
        if (a.browser.msie) {
            k.attachEvent("onpropertychange", r)
        } else {
            f.bind("DOMAttrModified", r)
        }
        this.fill = function (s, v) {
            function w(y) {
                var B, C = y.selectedValue || y.value();
                if (C) {
                    B = function (D) {
                        return C == (D.Value || D.Text)
                    }
                } else {
                    var x = y.dropDown.$items,
						z = y.index,
						A = x.filter(".t-state-selected").length;
                    B = z != -1 && z < x.length ? z : A > 0 ? A - 1 : 0
                }
                y.select(B);
                y._oldIndex = y.selectedIndex
            }
            var t = this.dropDown,
				u = this.loader;
            if (!t.$items && !u.ajaxError) {
                if (u.isAjax()) {
                    v = v || {};
                    u.ajaxRequest(function (x) {
                        this.dataBind(x, true);
                        w(this);
                        b.trigger(this.element, "dataBound");
                        this.trigger.change();
                        if (s) {
                            s()
                        }
                    }, v)
                } else {
                    this.dataBind(this.data);
                    w(this);
                    if (s) {
                        s()
                    }
                }
            }
        };
        this.enable = function () {
            var s = this.$wrapper.removeClass("t-state-disabled");
            if (!s.data("events")) {
                this.$wrapper.removeClass("t-state-disabled").bind({
                    keydown: a.proxy(m, this),
                    keypress: a.proxy(n, this),
                    click: a.proxy(function (u) {
                        var v = this.trigger;
                        var t = this.dropDown;
                        this.$wrapper.focus();
                        if (t.isOpened()) {
                            v.close()
                        } else {
                            if (!t.$items) {
                                this.fill(v.open)
                            } else {
                                v.open()
                            }
                        }
                    }, this),
                    focus: a.proxy(function () {
                        this.$wrapper.find(".t-dropdown-wrap").addClass("t-state-focused").removeClass("t-state-default")
                    }, this),
                    blur: a.proxy(function () {
                        this.$wrapper.find(".t-dropdown-wrap").addClass("t-state-default").removeClass("t-state-focused")
                    }, this)
                })
            }
            f.removeAttr("disabled")
        };
        this.disable = function () {
            f.attr("disabled", "disabled");
            this.$wrapper.addClass("t-state-disabled").unbind()
        };
        this.reload = function () {
            this.dropDown.$items = null;
            if (arguments.length) {
                this.fill(arguments[0], arguments[1])
            } else {
                this.fill()
            }
        };
        this.select = function (t) {
            var s = this.highlight(t);
            if (s != -1) {
                this.selectedIndex = s;
                b.list.updateTextAndValue(this, this.data[s].Text, this.data[s].Value)
            }
            return s
        };
        this.text = function (s) {
            if (s !== undefined) {
                if (this.encoded) {
                    s = b.encode(s)
                }
                this.$text.html(s && s.replace(e, "") ? s : "&nbsp;")
            } else {
                return this.$text.html()
            }
        };
        this.value = function (t) {
            if (t !== undefined) {
                t = t + "";
                var s = this.select(function (u) {
                    return t === (u.Value + "")
                });
                if (s == -1) {
                    s = this.select(function (u) {
                        return t == u.Text
                    })
                }
                if (s != -1) {
                    this.previousValue = this.$element.val();
                    this._oldIndex = this.selectedIndex
                }
            } else {
                return this.$element.val()
            }
        };
        b.list.common.call(this);
        b.list.initialize.call(this);
        a(document.documentElement).bind("mousedown", a.proxy(function (t) {
            var s = this.dropDown.$element;
            var u = s && s.parent().length > 0;
            if (a.contains(this.$wrapper[0], t.target) || (u && a.contains(s.parent()[0], t.target))) {
                return
            }
            this.trigger.change();
            this.trigger.close()
        }, this));
        this[this.enabled ? "enable" : "disable"]();

        function p() {
            clearTimeout(this.timeout);
            this.timeout = setTimeout(a.proxy(function () {
                i = ""
            }, this), this.delay)
        }
        function m(x) {
            var A = this.trigger;
            var w = this.dropDown;
            var z = x.keyCode || x.which;
            if (x.altKey && (z == 38 || z == 40)) {
                var v = z == 38 ? A.close : A.open;
                if (!w.$items) {
                    this.fill(v)
                } else {
                    v()
                }
                return
            }
            if (z > 34 && z < 41) {
                x.preventDefault();
                if (!w.$items) {
                    this.fill();
                    return
                }
                var t = w.$items,
					u = a(t[this.selectedIndex]);
                var s = (z == 35) ? t.last() : (z == 36) ? t.first() : (z == 37 || z == 38) ? u.prev() : (z == 39 || z == 40) ? u.next() : [];
                if (s.length) {
                    var y = s[0];
                    this.select(y);
                    w.scrollTo(y);
                    if (!w.isOpened()) {
                        A.change()
                    }
                }
            }
            if (z == 8) {
                a.proxy(p, this)();
                x.preventDefault();
                i = i.slice(0, -1)
            }
            if (z == 9 || z == 13 || z == 27) {
                A.change();
                A.close()
            }
        }
        function n(t) {
            var s = this.dropDown;
            var u = t.keyCode || t.charCode;
            if (u == 0 || a.inArray(u, b.list.keycodes) != -1 || t.ctrlKey || t.altKey) {
                return
            }
            if (!s.$items) {
                this.fill(a.proxy(function () {
                    h(u)
                }, this));
                return
            }
            h(u)
        }
        var h = a.proxy(function h(u) {
            var s = this.dropDown;
            var v = i;
            v += String.fromCharCode(u);
            if (v) {
                var t = d(this.data, s.$items, v);
                if (t) {
                    this.select(t);
                    s.scrollTo(t)
                }
                i = v
            }
            a.proxy(p, this)()
        }, this);
        if (q.cascadeTo) {
            var j = a("#" + q.cascadeTo).attr("disabled", "disabled");
            j.bind("load", function () {
                if (q.value()) {
                    q.$element.trigger("valueChange")
                }
            });
            q.$element.bind("valueChange", a.proxy(function () {
                var t = j.data("tDropDownList");
                if (t) {
                    var u = [],
						s = {};
                    s[q.$element.attr("name")] = q.value();
                    if (t.loader.isAjax()) {
                        if (q.placeholder) {
                            u[0] = {
                                Text: q.placeholder,
                                Value: ""
                            }
                        }
                        t.dataBind(u)
                    }
                    t.select(0);
                    t.disable();
                    if (q.value() === "" && q.placeholder) {
                        t.$element.trigger("valueChange");
                        return
                    }
                    t.reload(function () {
                        var v = u[0] ? 1 : 0;
                        if (t.data[v]) {
                            t.enable()
                        }
                    }, {
                        data: s
                    })
                }
            }, q))
        }
    };
    a.fn.tDropDownList = function (f) {
        return b.create(this, {
            name: "tDropDownList",
            init: function (g, h) {
                return new b.dropDownList(g, h)
            },
            options: f
        })
    };
    a.fn.tDropDownList.defaults = {
        effects: b.fx.slide.defaults(),
        accessible: false,
        index: 0,
        delay: 500,
        encoded: true
    }
})(jQuery);