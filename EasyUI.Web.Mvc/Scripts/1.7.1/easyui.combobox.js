(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.combobox.js");
    b.combobox = function (i, o) {
        if (o && o.enabled === undefined) {
            o.enabled = !a(i).is("[disabled]")
        }
        a.extend(this, o);
        var l = i.nodeName.toLowerCase() == "input" && i.type.toLowerCase() == "text";
        var k = i.nodeName.toLowerCase() == "select";
        if ((l || k) && !a(i).parent().hasClass("t-combobox")) {
            if (k && !this.data) {
                this.data = b.list.retrieveData(i)
            }
            var j = new b.list.htmlBuilder(i, "t-combobox", k);
            j.text = function (v) {
                var u = v.builder;
                u.buffer = [];
                return a(u.cat('<input class="t-input" autocomplete="off" type="text" ').catIf('value="', v.text, '" ', v.text).catIf('name="', v.name, '-input" ', v.name).cat("/>").string())
            };
            j.render();
            if (k) {
                i = i.previousSibling
            }
        }
        this.element = i;
        var r = this;
        var d = this.$element = a(i).closest("form").bind("reset", function () {
            setTimeout(function () {
                r.value(i.value)
            })
        }).end();
        this.loader = new b.list.loader(this);
        this.trigger = new b.list.trigger(this);
        var g = this.$wrapper = d.closest(".t-combobox");
        var e = this.$wrapper.find(".t-select");
        var f = this.$text = this.$wrapper.find("> .t-dropdown-wrap > .t-input").attr("autocomplete", "off").bind("paste", a.proxy(function (u) {
            setTimeout(a.proxy(function () {
                this.$element.val(u.target.value);
                p(this)
            }, this), 0)
        }, this));
        var t = function (w) {
            var u = "class",
                v = d.attr(u) || "";
            if ((w.attrName && w.attrName == u) || (w.propertyName && w.propertyName == "className")) {
                if (v != f.attr(u)) {
                    f.attr(u, v).addClass("t-input")
                }
            }
        };
        if (a.browser.msie) {
            i.attachEvent("onpropertychange", t)
        } else {
            d.bind("DOMAttrModified", t)
        }
        d.closest("form").bind("reset", a.proxy(function (u) {
            var v = this;
            window.setTimeout(function () {
                if (d.val() != "") {
                    v.value(d.val())
                } else {
                    v.highlight(0);
                    v.selectedIndex = 0
                }
            }, 1)
        }, this));
        this.filtering = new b.list.filtering(this);
        this.filtering.autoFill = function (u, y) {
            if (u.autoFill && (u.lastKeyCode != 8 && u.lastKeyCode != 46)) {
                var x = u.$text[0];
                var v = b.caretPos(x);
                var w = x.value.substring(0, v);
                var z = y.toLowerCase().indexOf(w.toLowerCase());
                if (z != -1) {
                    var A = y.substring(z + w.length);
                    x.value = w + A;
                    b.list.selection(x, v, v + A.length)
                }
            }
        };
        this.dropDown = new b.dropDown({
            attr: this.dropDownAttr,
            effects: this.effects,
            onOpen: a.proxy(function () {
                var u = this.data;
                var v = this.dropDown;
                if (u.length == 0) {
                    return
                }
                var x = this.$text.val();
                var w = this.selectedIndex;
                if (w != -1 && this.isFiltered) {
                    if (x == u[w].Text) {
                        this.filteredDataIndexes = [];
                        v.onItemCreate = null;
                        if (this.filter) {
                            v.dataBind(this.data, this.encoded)
                        }
                        this.select(v.$items[w])
                    } else {
                        this.filters[this.filter](this, this.data, x)
                    }
                    this.isFiltered = false
                }
            }, this),
            onClick: a.proxy(function (u) {
                this.select(u.item);
                this.trigger.change();
                this.trigger.close();
                f.focus()
            }, this)
        });
        this.dropDown.$element.css("direction", g.closest(".t-rtl").length ? "rtl" : "");
        this.enable = function () {
            g.removeClass("t-state-disabled");
            f.removeAttr("disabled");
            d.removeAttr("disabled");
            if (!e.data("events")) {
                e.bind("click", a.proxy(s, this))
            }
        };
        this.disable = function () {
            g.addClass("t-state-disabled");
            f.attr("disabled", "disabled");
            d.attr("disabled", "disabled");
            e.unbind("click")
        };
        this[this.enabled ? "enable" : "disable"]();
        this.fill = function (u, z, w) {
            function D(G) {
                var K = G.selectedValue || G.value();
                if (K) {
                    G.value(K);
                    return
                }
                var E = v.$items;
                var I = G.index;
                var F = E.filter(".t-state-selected");
                var J = F.length;
                var H = I != -1 && I < E.length ? E[I] : J > 0 ? F[J - 1] : null;
                if (H) {
                    G.select(H)
                } else {
                    G.selectedIndex = -1;
                    if (G.highlightFirst) {
                        G.highlight(E[0])
                    }
                }
                G._oldIndex = G.selectedIndex
            }
            var x = this.loader;
            var v = this.dropDown;
            var y = this.minChars;
            var B = this.text();
            var C = B.length;
            if (!v.$items && !x.ajaxError) {
                if ((x.isAjax() || this.onDataBinding) && C >= y) {
                    z = z || {};
                    var A = a.extend({}, z);
                    if (w) {
                        B = ""
                    }
                    A[this.queryString.text] = B;
                    x.ajaxRequest(function (E) {
                        this.dataBind(E, true);
                        D(this);
                        b.trigger(this.element, "dataBound");
                        this.trigger.change();
                        if (u) {
                            u()
                        }
                    }, {
                        data: A
                    })
                } else {
                    this.dataBind(this.data, true);
                    D(this);
                    if (u) {
                        u()
                    }
                }
            }
        };
        this.reload = function () {
            this.dropDown.$items = null;
            if (arguments.length) {
                this.fill(arguments[0], arguments[1])
            } else {
                this.fill()
            }
        };
        this.select = function (x) {
            var w = this.highlight(x);
            if (w != -1) {
                var v = this.filteredDataIndexes;
                this.selectedIndex = (v && v.length) > 0 ? v[w] : w;
                var u = this.data[this.selectedIndex];
                b.list.updateTextAndValue(this, u.Text, u.Value);
                this._textChanged = false
            }
            return w
        };
        this.text = function () {
            return this.$text.val.apply(this.$text, arguments)
        };
        this.value = function () {
            if (arguments.length) {
                var v = arguments[0];
                this.filteredDataIndexes = [];
                var u = this.select(function (w) {
                    return v == (w.Value || w.Text)
                });
                if (u == -1) {
                    this.selectedIndex = u;
                    this.$element.val(v);
                    this.text(v)
                }
                this.previousValue = this.$element.val();
                this._oldIndex = this.selectedIndex;
                this._textChanged = false
            } else {
                return this.$element.val()
            }
        };
        b.list.common.call(this);
        b.list.filters.call(this);
        b.list.initialize.call(this);
        a(document.documentElement).bind("mousedown", a.proxy(function (w) {
            var u = this.dropDown.$element;
            var x = u && u.parent().length > 0;
            if (a.contains(this.$wrapper[0], w.target) || (x && a.contains(u.parent()[0], w.target))) {
                return
            }
            if (this._textChanged) {
                this._textChanged = false;
                var v = c(this.data, this.$text.val(), this.ignoreCase);
                if (v) {
                    this.selectedIndex = v.index;
                    this.text(v.dataItem.Text);
                    this.$element.val(v.dataItem.Value || v.dataItem.Text)
                } else {
                    this.selectedIndex = -1;
                    this.$element.val(this.$text.val())
                }
            }
            this.trigger.change();
            this.trigger.close()
        }, this));
        this.$text.bind({
            keydown: a.proxy(m, this),
            keypress: a.proxy(n, this),
            focus: a.proxy(function (w) {
                if (this.openOnFocus) {
                    var x = this.trigger;
                    var v = this.dropDown;
                    if (!v.$items) {
                        this.fill(x.open)
                    } else {
                        x.open()
                    }
                }
                var u = this.$text;
                clearTimeout(this.selectTextTimeout);
                this.selectTextTimeout = window.setTimeout(function () {
                    b.list.selection(u[0], 0, u.val().length)
                }, 130)
            }, this),
            blur: a.proxy(function () {
                clearTimeout(this.selectTextTimeout)
            }, this)
        });

        function s(v) {
            var u = this.dropDown,
				w = this.trigger;
            this.loader.ajaxError = false;
            if (!u.isOpened()) {
                if (!u.$items) {
                    this.fill(w.open, {}, true)
                } else {
                    w.open()
                }
                f[0].focus()
            } else {
                w.close()
            }
        }
        function p(u) {
            clearTimeout(u.timeout);
            u.timeout = setTimeout(function () {
                u.filtering.filter(u)
            }, u.delay)
        }
        function m(z) {
            var C = this.trigger;
            var y = this.dropDown;
            var A = z.keyCode || z.which;
            this.lastKeyCode = A;
            if (z.altKey) {
                if (A == 38 || A == 40) {
                    var w = A == 38 ? C.close : C.open;
                    if (!y.$items) {
                        this.fill(w)
                    } else {
                        w()
                    }
                }
                return
            }
            if (!z.shiftKey && (A == 38 || A == 40)) {
                z.preventDefault();
                var B = a.proxy(function () {
                    var E = y.$items,
						F = E.filter(".t-state-selected:first");
                    var D = F.length == 0 || E.length == 1 || this.selectedIndex == -1 ? E.first() : (A == 38) ? F.prev() : (A == 40) ? F.next() : [];
                    if (D.length) {
                        var G = D[0];
                        this.select(G);
                        y.scrollTo(G);
                        if (!y.isOpened()) {
                            C.change()
                        }
                    }
                }, this);
                if (!y.$items) {
                    if (this.index != -1 || this.value() || this.selectedValue) {
                        B = null
                    }
                    this.fill(B);
                    return
                }
                B();
                return
            }
            if (A == 8 || A == 46 || (z.ctrlKey && A == 88)) {
                var v = this.$text;
                if (v.val() != "") {
                    p(this)
                }
                setTimeout(a.proxy(function () {
                    if (v.val() == "") {
                        this.selectedIndex = -1;
                        this.$element.val("")
                    } else {
                        this.$element.val(this.$text.val())
                    }
                    this._textChanged = false
                }, this), 0);
                return
            }
            if (A == 13) {
                if (y.isOpened()) {
                    this._textChanged = false;
                    z.preventDefault();
                    var u = y.$items.filter(".t-state-selected:first");
                    if (u.length > 0) {
                        this.select(u[0])
                    } else {
                        this.$element.val(this.$text.val())
                    }
                    C.change();
                    C.close();
                    b.list.moveToEnd(this.$text[0])
                }
                return
            }
            if (A == 27 || A == 9) {
                this._textChanged = false;
                clearTimeout(this.timeout);
                var x;
                if (this.selectedIndex !== undefined && this.selectedIndex > -1 && this.data[this.selectedIndex].Text === this.$text.val()) {
                    x = {
                        dataItem: this.data[this.selectedIndex],
                        index: this.selectedIndex
                    }
                } else {
                    x = c(this.data, this.$text.val(), this.ignoreCase)
                }
                if (x) {
                    this.selectedIndex = x.index;
                    this.text(x.dataItem.Text);
                    this.$element.val(x.dataItem.Value || x.dataItem.Text)
                } else {
                    this.selectedIndex = -1;
                    this.$element.val(this.$text.val())
                }
                C.change();
                C.close();
                if (A == 27) {
                    this.$text.blur()
                }
                return
            }
            p(this)
        }
        function n(u) {
            this._textChanged = true;
            var v = u.keyCode || u.charCode;
            if (!u.shiftKey && (v == 0 || a.inArray(v, b.list.keycodes) != -1 || u.ctrlKey)) {
                return true
            }
            setTimeout(a.proxy(function () {
                this.$element.val(this.$text.val())
            }, this), 0)
        }
        if (r.cascadeTo) {
            var h = a("#" + r.cascadeTo).attr("disabled", "disabled"),
				q = r.selectedValue;
            h.bind("load", function () {
                if (q || r.value()) {
                    r.$element.trigger("valueChange")
                }
            });
            r.$element.bind("valueChange", a.proxy(function () {
                var u = h.data("tComboBox");
                if (u) {
                    var x = [],
						v = {},
						w = r.value();
                    if (q) {
                        w = q;
                        q = ""
                    }
                    v[r.$element.attr("name")] = w;
                    if (u.loader.isAjax()) {
                        if (r.placeholder) {
                            x[0] = {
                                Text: r.placeholder,
                                Value: ""
                            }
                        }
                        u.dataBind(x)
                    }
                    u.select(0);
                    u.disable();
                    if ((r.selectedValue || r.value()) === "" && r.placeholder) {
                        u.$element.trigger("valueChange");
                        return
                    }
                    u.reload(function () {
                        var y = x[0] ? 1 : 0;
                        if (u.data[y]) {
                            u.enable()
                        } else {
                            u.value("")
                        }
                    }, v)
                }
            }, r))
        }
    };

    function c(d, h, g) {
        if (!h) {
            return
        }
        if (d) {
            for (var f = 0, j = d.length; f < j; f++) {
                var e = d[f],
					k = e.Text;
                if (g) {
                    k = k.toLowerCase();
                    h = h.toLowerCase()
                }
                if (k == h) {
                    return {
                        dataItem: e,
                        index: f
                    }
                }
            }
        }
    }
    a.fn.tComboBox = function (d) {
        return b.create(this, {
            name: "tComboBox",
            init: function (e, f) {
                return new b.combobox(e, f)
            },
            options: d
        })
    };
    a.fn.tComboBox.defaults = {
        ignoreCase: true,
        encoded: true,
        openOnFocus: false,
        effects: b.fx.slide.defaults(),
        index: -1,
        autoFill: true,
        highlightFirst: true,
        filter: 0,
        delay: 200,
        minChars: 0,
        cache: true,
        queryString: {
            text: "text"
        }
    }
})(jQuery);