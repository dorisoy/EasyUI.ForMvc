(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.timepicker.js");
    b.timeView = function (d) {
        a.extend(this, d);
        var c = this.dropDown = new b.dropDown({
            attr: this.dropDownAttr,
            effects: this.effects,
            onClick: function (f) {
                var g = f.item;
                d.onChange(g.innerText || g.textContent)
            }
        });
        c.$element.addClass("t-time-popup").css("direction", this.isRtl ? "rtl" : "")
    };
    b.timeView.prototype = {
        _ensureItems: function () {
            if (!this.dropDown.$items) {
                if (this.dates) {
                    this.dataBind(this.dates)
                } else {
                    this.bind()
                }
            }
        },
        open: function (c) {
            this._ensureItems();
            this.dropDown.open(c)
        },
        close: function () {
            this.dropDown.close()
        },
        dataBind: function (d) {
            if (!d) {
                return
            }
            var m = this.minValue;
            var l = this.maxValue;
            var c = [];
            var f = this.format;
            var g = b.datetime.format;
            var j = b.timeView.isInRange;
            var e;
            for (var h = 0, k = d.length; h < k; h++) {
                e = d[h];
                if (j(e, m, l)) {
                    c[h] = g(d[h], f)
                }
            }
            this.dropDown.dataBind(c)
        },
        bind: function () {
            var h = b.timeView.getTimeMilliseconds;
            var d = [];
            var f = this.format;
            var l = this.interval;
            var r = new b.datetime(this.minValue);
            var o = h(r);
            var n = h(this.maxValue);
            var m = l * b.datetime.msPerMinute;
            var e = b.datetime.dst() * b.datetime.msPerMinute;
            var k = e < 0;
            if (!k) {
                e = 0
            }
            var p = parseInt((b.datetime.msPerDay + e) / (l * b.datetime.msPerMinute));
            if (o != n) {
                var q = o < n ? n - o : n + b.datetime.msPerDay - o;
                p = parseInt(q / m) + 1
            }
            var c = b.datetime.add;
            var g = b.datetime.format;
            for (var j = 0; j < p; j++) {
                d[j] = g(r.toDate(), f);
                r = c(r, m, k)
            }
            if (h(r) - m - n != 0 && o != n && d[p - 1] != g(this.maxValue, f)) {
                d[p] = g(this.maxValue, f)
            }
            this.dropDown.dataBind(d)
        },
        isOpened: function () {
            return this.dropDown.isOpened()
        },
        value: function (e) {
            this._ensureItems();
            var d = this.dropDown;
            if (e === undefined) {
                return d.$items.filter(".t-state-selected").text()
            }
            var c = d.$items;
            if (!c) {
                return
            }
            c.removeClass("t-state-selected");
            if (e) {
                d.highlight(a.grep(c, function (f) {
                    return (f.innerText || f.textContent) == e
                }))
            }
        },
        navigate: function (h) {
            var i = h.keyCode || h.which;
            if (i == 38 || i == 40) {
                h.preventDefault()
            }
            this._ensureItems();
            var g = this.dropDown;
            var d = g.$items;
            var f = d.filter(".t-state-selected");
            var c = f.length == 0 || d.length == 1 ? d.first() : (i == 38) ? f.prev() : (i == 40) ? f.next() : [];
            if (c.length) {
                var j = c.text();
                g.scrollTo(c[0]);
                g.highlight(c[0]);
                if (!g.isOpened()) {
                    this.onChange(j)
                } else {
                    this.onNavigateWithOpenPopup(j)
                }
            }
        }
    };
    a.each(["min", "max"], a.proxy(function (c, d) {
        b.timeView.prototype[d] = function (f) {
            var e = d + "Value";
            if (f === undefined) {
                return this[e]
            }
            this[e] = new Date(f.value ? f.value : f);
            this.bind()
        }
    }, this));
    a.extend(b.timeView, {
        isInRange: function (j, e, d) {
            if (j === null) {
                return true
            }
            var c = b.timeView.getTimeMilliseconds;
            var h = b.datetime.msPerDay;
            var i = c(j);
            var g = c(e);
            var f = c(d);
            i = g > i ? i + h : i;
            f = g > f ? f + h : f;
            return g - f == 0 || i >= g && i <= f
        },
        getTimeMilliseconds: function (c) {
            c = c.value ? c : new b.datetime(c);
            return ((c.hours() * 60) + c.minutes()) * b.datetime.msPerMinute + c.seconds() * 1000 + c.milliseconds()
        }
    });
    b.timepicker = function (f, g) {
        a.extend(this, g);
        if (f.nodeName.toLowerCase() !== "input" && f.type.toLowerCase() !== "text") {
            throw "Target element is not a INPUT"
        }
        this.element = f;
        var c = this.$element = a(f).addClass("t-input").attr("autocomplete", "off").bind({
            keydown: a.proxy(this._keydown, this),
            focus: a.proxy(function (j) {
                if (this.openOnFocus) {
                    this._open()
                }
                this.$element.removeClass("t-state-error")
            }, this),
            blur: a.proxy(function (j) {
                this._bluring = setTimeout(a.proxy(function () {
                    if (c.val() && this.parse(c.val()) === null) {
                        this.$element.addClass("t-state-error")
                    }
                    this._update(c.val())
                }, this), 100)
            }, this)
        });
        if (!c.parent().hasClass("t-picker-wrap")) {
            c.wrap('<div class="t-widget t-timepicker"><div class="t-picker-wrap"></div></div>');
            if (g.showButton) {
                var d = new b.stringBuilder(),
					h = g.buttonTitle;
                a(d.cat('<span class="t-select">').cat('<span class="t-icon t-icon-clock" ').catIf('title="', h).catIf(h, h).cat('"></span></span>').string()).insertAfter(c)
            }
        }
        this.timeView = new b.timeView({
            dates: this.dates,
            effects: this.effects,
            dropDownAttr: this.dropDownAttr,
            format: this.format,
            interval: this.interval,
            isRtl: c.closest(".t-rtl").length,
            minValue: this.minValue,
            maxValue: this.maxValue,
            onNavigateWithOpenPopup: a.proxy(function (j) {
                this.$element.val(j)
            }, this),
            onChange: a.proxy(function (j) {
                clearTimeout(this._bluring);
                if (j != this.inputValue) {
                    this._update(j)
                }
                this._close();
                window.setTimeout(function () {
                    c.focus()
                }, 1)
            }, this)
        });
        this.inputValue = c.val();
        var i = this.selectedValue || this.inputValue;
        if (i) {
            this._value(this.parse(i))
        }
        var e = this.enabled ? a.proxy(this._togglePopup, this) : b.preventDefault;
        this.$wrapper = c.closest(".t-timepicker").find(".t-icon").bind("click", e).end();
        a(document.documentElement).bind("mousedown", a.proxy(function (k) {
            var m = this.$element.val();
            if (m != this.inputValue) {
                this._update(m)
            }
            var j = this.timeView.dropDown.$element;
            var l = j && j.parent().length > 0;
            if (!l || a.contains(this.$wrapper[0], k.target) || a.contains(j.parent()[0], k.target)) {
                return
            }
            this._close()
        }, this));
        b.bind(this, {
            open: this.onOpen,
            close: this.onClose,
            valueChange: this.onChange,
            load: this.onLoad
        })
    };
    b.timepicker.prototype = {
        _close: function () {
            var c = this.timeView.dropDown;
            if (!c.$element.is(":animated") && c.isOpened()) {
                this._trigger("close")
            }
        },
        _open: function () {
            if (!this.timeView.isOpened()) {
                this._trigger("open")
            }
        },
        _trigger: function (c) {
            if (!b.trigger(this.element, c)) {
                this[c]()
            }
        },
        _togglePopup: function () {
            if (this.timeView.isOpened()) {
                this._close()
            } else {
                this.element.focus();
                this._open()
            }
        },
        _update: function (l) {
            var i = this.minValue,
				g = this.maxValue,
				l = this.parse(l),
				k = this.selectedValue;
            if (l != null && !b.timeView.isInRange(l, i, g)) {
                var e = b.timeView.getTimeMilliseconds,
					j = e(l),
					h = Math.abs(e(i) - j),
					f = Math.abs(e(g) - j);
                l = new Date(h < f ? i : g)
            }
            var c = k ? b.datetime.format(k, this.format) : "",
				d = l ? b.datetime.format(l, this.format) : "";
            this._value(l);
            if (d != c) {
                if (b.trigger(this.element, "valueChange", {
                    previousValue: k,
                    value: l
                })) {
                    this._value(k)
                }
            }
        },
        _value: function (e) {
            var d = this.$element.val();
            var c = e === null;
            this.selectedValue = e;
            this.timeView.value(c ? null : b.datetime.format(e, this.format));
            if (!c) {
                d = b.datetime.format(e, this.format)
            }
            this.inputValue = d;
            this.$element.toggleClass("t-state-error", c && d != "").val(d)
        },
        _keydown: function (c) {
            var d = c.keyCode || c.which;
            if (c.altKey) {
                if (d == 40) {
                    this._open()
                } else {
                    if (d == 38) {
                        this._close()
                    }
                }
                return
            }
            if (!c.shiftKey && (d === 38 || d === 40)) {
                this.timeView.navigate(c);
                return
            }
            if (d == 9 || d == 13 || d == 27) {
                this._update(this.$element.val());
                this._close()
            }
        },
        enable: function () {
            this.$element.attr("disabled", false);
            this.$wrapper.removeClass("t-state-disabled").find(".t-icon").unbind("click").bind("click", a.proxy(this._togglePopup, this))
        },
        disable: function (c) {
            this.$element.attr("disabled", true);
            this.$wrapper.addClass("t-state-disabled").find(".t-icon").unbind("click").bind("click", b.preventDefault)
        },
        value: function (d) {
            if (d === undefined) {
                return this.selectedValue
            }
            var c = this.parse(d);
            c = b.timeView.isInRange(c, this.minValue, this.maxValue) ? c : null;
            if (c === null) {
                this.$element.removeClass("t-state-error").val("")
            }
            this._value(c);
            return this
        },
        parse: function (d) {
            if (d === null || d.getDate) {
                return d
            }
            var c = b.datetime.parse({
                AM: b.cultureInfo.am,
                PM: b.cultureInfo.pm,
                value: d,
                format: this.format,
                baseDate: this.selectedValue ? new b.datetime(this.selectedValue) : new b.datetime()
            });
            return c != null ? c.toDate() : null
        },
        open: function () {
            var c = this.$element;
            this.timeView.open({
                offset: c.offset(),
                outerHeight: c.outerHeight(),
                outerWidth: c.outerWidth(),
                zIndex: b.getElementZIndex(c[0])
            })
        },
        close: function () {
            this.timeView.close()
        }
    };
    a.each(["min", "max"], a.proxy(function (c, d) {
        b.timepicker.prototype[d] = function (g) {
            var f = d + "Value";
            if (g === undefined) {
                return this[f]
            }
            var e = this.parse(g);
            if (e !== null) {
                this[f] = e;
                this.timeView[d](e)
            }
        }
    }, this));
    a.fn.tTimePicker = function (c) {
        return b.create(this, {
            name: "tTimePicker",
            init: function (d, e) {
                return new b.timepicker(d, e)
            },
            options: c
        })
    };
    a.fn.tTimePicker.defaults = {
        effects: b.fx.slide.defaults(),
        minValue: new b.datetime().hours(0).minutes(0).seconds(0).toDate(),
        maxValue: new b.datetime().hours(0).minutes(0).seconds(0).toDate(),
        selectedValue: null,
        format: b.cultureInfo.shortTime,
        interval: 30,
        showButton: true,
        buttonTitle: "Open the calendar",
        enabled: true,
        openOnFocus: false
    }
})(jQuery);