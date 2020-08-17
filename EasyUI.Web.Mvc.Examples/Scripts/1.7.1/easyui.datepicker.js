(function (a) {
    var b = a.easyui;
    b.scripts.push("easyui.datepicker.js");
    var f = null,
		d = (navigator.userAgent.search(/like\sMac\sOS\sX;.*Mobile\/\S+/) != -1),
		e = (navigator.userAgent.search(/4_1\slike\sMac\sOS\sX;.*Mobile\/\S+/) != -1);
    b.datetime.parseByToken = function (p, n) {
        if (p === null || p === "") {
            return null
        }
        n = n || new b.datetime();
        var i = null;
        var m = null;
        var o = null;
        var k = 0;
        var j = function (q) {
            var r = null;
            if (q && p.substring(k, k + q.length).toLowerCase() == q.toLowerCase()) {
                r = q
            }
            return r
        };
        var l = function () {
            var q = null;
            a.each(["days", "abbrDays", "months", "abbrMonths"], function (r, s) {
                if (q !== null) {
                    return
                }
                a.each(b.cultureInfo[s], function (t, u) {
                    if (q !== null) {
                        return
                    }
                    q = j(u)
                });
                o = s
            });
            return q
        };
        var g = function () {
            var r;
            var s = function (u, t) {
                n[t ? "date" : "month"](n[t ? "date" : "month"]() + (r != 0 ? ((r + ((r > 0 ? 1 : -1) * u)) % u) : 0) + (m ? (i == b.cultureInfo.next ? 1 : -1) * u : 0))
            };
            var q = a.inArray(m || i, b.cultureInfo[o]);
            if (o.toLowerCase().indexOf("day") > -1) {
                r = (q == 0 ? 7 : q) - n.day();
                s(7, true)
            } else {
                r = q - n.month();
                s(12, false)
            }
        };
        var h = function () {
            var r = function (t) {
                var s;
                switch (m) {
                    case "year":
                        s = t == 1 ? 1 : 0;
                        break;
                    case "month":
                        s = t == 2 ? 1 : 0;
                        break;
                    case "week":
                        s = t == 3 ? 7 : 0;
                        break;
                    case "day":
                        s = t == 3 ? 1 : 0;
                        break
                }
                return s
            };
            var q = (i == b.cultureInfo.next ? 1 : -1);
            n.year(n.year() + r(1) * q, n.month() + r(2) * q, n.date() + r(3) * q)
        };
        a.each(["today", "tomorrow", "yesterday", "next", "last"], function (q, r) {
            if (i !== null) {
                return
            }
            i = j(b.cultureInfo[r])
        });
        if (i !== null) {
            k += i.length;
            if (/[^\s\d]\s+[^\s\d]/i.test(p)) {
                k++;
                a.each(["year", "month", "week", "day"], function (q, r) {
                    if (m !== null) {
                        return
                    }
                    m = j(b.cultureInfo[r])
                });
                o = null;
                if (m === null) {
                    m = l()
                }
                if (m === null) {
                    return null
                }
            } else {
                switch (i) {
                    case b.cultureInfo.today:
                        break;
                    case b.cultureInfo.tomorrow:
                        n.date(n.date() + 1);
                        break;
                    case b.cultureInfo.yesterday:
                        n.date(n.date() - 1);
                        break;
                    default:
                        n = null;
                        break
                }
                return n
            }
        } else {
            i = l();
            if (i != null) {
                g();
                return n
            } else {
                return null
            }
        }
        if (o !== null) {
            g()
        } else {
            h()
        }
        return n
    };

    function c(g, j, i, h) {
        if (j) {
            g = new Date(j)
        }
        if (i > g) {
            g = new Date(i)
        } else {
            if (h < g) {
                g = new Date(h)
            }
        }
        return g
    }
    b.dateView = function (g) {
        a.extend(this, g);
        this.isValueChanged = false;
        this.focusedValue = c(new Date(), this.selectedValue, this.minValue, this.maxValue);
        this.$calendar = this._createSharedCalendar()
    };
    b.dateView.prototype = {
        _createSharedCalendar: function () {
            if (!f) {
                f = a(b.calendar.html(new b.datetime(this.focusedValue), this.selectedValue ? new b.datetime(this.selectedValue) : null, new b.datetime(this.minValue), new b.datetime(this.maxValue))).hide().addClass("t-popup t-datepicker-calendar").appendTo(document.body).tCalendar({
                    selectedValue: this.selectedValue,
                    minDate: this.minValue,
                    maxDate: this.maxValue
                });
                if (a.browser.msie && parseInt(a.browser.version) < 7) {
                    f.prepend('<iframe src="javascript:\'\';" style="position:absolute; width: 100%; height: 190px; border: 0; top: 0; left: 0; opacity: 0; filter:alpha(opacity=0);"></iframe>')
                }
                b.fx._wrap(f).css("display", "none");
                if (a.browser.msie && a.browser.version <= 6) {
                    a('<iframe class="t-iframe-overlay" src="javascript:false;"></iframe>').prependTo(f).height(f.height())
                }
            }
            return f
        },
        _getCalendar: function () {
            return f.data("tCalendar")
        },
        _reassignSharedCalendar: function () {
            var g = this._getCalendar();
            if (f.data("associatedDateView") != this) {
                f.stop(true, true);
                this.focusedValue = c(this.focusedValue, this.selectedValue, this.minValue, this.maxValue);
                g.minDate = this.minValue;
                g.maxDate = this.maxValue;
                g.selectedValue = this.selectedValue;
                g.goToView(0, this.focusedValue);
                g._footer(this.todayFormat);
                f.unbind("change").bind("change", a.proxy(function (h) {
                    var j = this.selectedValue;
                    var i = new b.datetime(h.date);
                    if (j !== null) {
                        i.hours(j.getHours()).minutes(j.getMinutes()).seconds(j.getSeconds()).milliseconds(j.getMilliseconds())
                    }
                    this.onChange(i.toDate())
                }, this)).unbind("navigate").bind("navigate", a.proxy(function (h) {
                    var i = this.focusedValue;
                    var j = g.viewedMonth;
                    var k = g.currentView.index;
                    i.setFullYear(j.year(), j.month(), i.getDate());
                    b.calendar.focusDate(i, k, f, h.direction)
                }, this)).data("associatedDateView", this);
                g.value(this.selectedValue);
                b.calendar.focusDate(this.focusedValue, g.currentView.index, f)
            }
        },
        open: function (j) {
            if (this.isOpened()) {
                return
            }
            this._reassignSharedCalendar();
            var i = this.isRtl;
            var g = this.$calendar;
            elementPosition = j.offset;
            elementPosition.top += j.outerHeight;
            if (d) {
                if (!document.body.scrollLeft && !e) {
                    elementPosition.left -= window.pageXOffset
                }
                if (!document.body.scrollTop && !e) {
                    elementPosition.top -= window.pageYOffset
                }
            }
            if (i) {
                elementPosition.left -= (f.outerWidth() || f.parent().outerWidth()) - j.outerWidth
            }
            b.fx._wrap(f).css(a.extend({
                position: "absolute",
                direction: i ? "rtl" : "",
                display: f.is(":visible") ? "" : "none"
            }, elementPosition));
            var h = this._getCalendar();
            var k = h.currentView.index;
            if (!f.is(":visible") && h.viewedMonth.value - this.focusedValue != 0) {
                h.goToView(k, this.focusedValue).value(this.selectedValue)
            }
            b.calendar.focusDate(this.focusedValue, h.currentView.index, f);
            b.fx._wrap(g).css("zIndex", j.zIndex).show();
            b.fx.play(this.effects, g, {
                direction: "bottom"
            })
        },
        close: function () {
            if (this.isOpened()) {
                b.fx.rewind(this.effects, this.$calendar, {
                    direction: "bottom"
                }, function () {
                    if (f) {
                        b.fx._wrap(f).hide()
                    }
                })
            }
        },
        isOpened: function () {
            return f && f.data("associatedDateView") == this && f.is(":visible")
        },
        value: function (i) {
            if (i === undefined) {
                return this.selectedValue
            }
            var h = i === null;
            var g = this._getCalendar();
            if (!h) {
                i = i.value ? new Date(i.value) : i
            }
            g.value(i);
            this.selectedValue = i;
            if (h) {
                i = new Date()
            }
            this.focusedValue = new Date(i);
            b.calendar.focusDate(i, g.currentView.index, f)
        },
        navigate: function (l) {
            if (this.isOpened() && a(".t-overlay", f).length > 0) {
                return
            }
            var m;
            var n = false;
            var g = this.$calendar;
            var i = this._getCalendar();
            var r = i.viewedMonth;
            var j = i.currentView;
            var s = j.index;
            var k = new b.datetime(this.focusedValue);
            var o = function (t, v, u) {
                if (!a(t, g).hasClass("t-state-disabled")) {
                    if ("navigateUp" == v) {
                        s += 1
                    }
                    m = u || false;
                    i[v]();
                    return true
                } else {
                    return false
                }
            };
            var p = function () {
                var t = b.calendar.findTarget(k, s, g, false)[0];
                i.navigateDown(l, t, s);
                s = s == 0 ? 0 : s - 1;
                m = true
            };
            var q = function (t, w, v) {
                var u = !v ? -1 : 1;
                if (!o(t, w, v)) {
                    return false
                }
                if (s == 0) {
                    k.addMonth(u)
                } else {
                    k.addYear(u * (s == 1 ? 1 : s == 2 ? 10 : 100))
                }
                return true
            };
            var h = b.datepicker.adjustDate;
            if (g.is(":visible") && !l.shiftKey) {
                n = true;
                switch (l.keyCode) {
                    case 37:
                        if (l.ctrlKey) {
                            if (!q(".t-nav-prev", "navigateToPast")) {
                                return
                            }
                        } else {
                            h(s, k, -1, -1);
                            if (j.navCheck(k, r, false)) {
                                if (!o(".t-nav-prev", "navigateToPast")) {
                                    return
                                }
                            }
                        }
                        break;
                    case 38:
                        if (l.ctrlKey) {
                            o(".t-nav-fast", "navigateUp")
                        } else {
                            h(s, k, -7, -4);
                            if (j.navCheck(k, r, false)) {
                                if (!o(".t-nav-prev", "navigateToPast")) {
                                    return
                                }
                            }
                        }
                        break;
                    case 39:
                        if (l.ctrlKey) {
                            if (!q(".t-nav-next", "navigateToFuture", true)) {
                                return
                            }
                        } else {
                            h(s, k, 1, 1);
                            if (j.navCheck(k, r, true)) {
                                if (!o(".t-nav-next", "navigateToFuture", true)) {
                                    return
                                }
                            }
                        }
                        break;
                    case 40:
                        if (l.ctrlKey) {
                            p()
                        } else {
                            h(s, k, 7, 4);
                            if (j.navCheck(k, r, true)) {
                                if (!o(".t-nav-next", "navigateToFuture", true)) {
                                    return
                                }
                            }
                        }
                        break;
                    case 33:
                        if (!q(".t-nav-prev", "navigateToPast")) {
                            return
                        }
                        break;
                    case 34:
                        if (!q(".t-nav-next", "navigateToFuture", true)) {
                            return
                        }
                        break;
                    case 35:
                        k = b.calendar.views[s].firstLastDay(k, false, i);
                        break;
                    case 36:
                        k = b.calendar.views[s].firstLastDay(k, true, i);
                        break;
                    case 13:
                        l.stopPropagation();
                        if (s == 0) {
                            this.onChange(this.focusedValue)
                        } else {
                            p()
                        }
                        break;
                    default:
                        n = false;
                        break
                }
            }
            if (n) {
                l.preventDefault();
                k = b.calendar.fitDateToRange(k, new b.datetime(this.minValue), new b.datetime(this.maxValue));
                b.calendar.focusDate(k.toDate(), s, g, m);
                this.focusedValue = k.toDate()
            }
        }
    };
    a.each(["min", "max"], a.proxy(function (g, h) {
        b.dateView.prototype[h] = function (j) {
            var i = h + "Value";
            if (j === undefined) {
                return this[i]
            }
            this[i] = new Date(j.value ? j.value : j);
            if (f.data("associatedDateView") === this) {
                f.data("associatedDateView", null);
                this._reassignSharedCalendar()
            }
        }
    }, this));
    b.datepicker = function (j, k) {
        a.extend(this, k);
        if (j.nodeName.toLowerCase() !== "input" && j.type.toLowerCase() !== "text") {
            throw "Target element is not a INPUT"
        }
        this.element = j;
        var g = this.$element = a(j).addClass("t-input").attr("autocomplete", "off").bind({
            keydown: a.proxy(this._keydown, this),
            focus: a.proxy(function (n) {
                if (this.openOnFocus) {
                    this._open()
                }
                this.$element.removeClass("t-state-error")
            }, this),
            blur: a.proxy(function (n) {
                this._bluring = setTimeout(a.proxy(function () {
                    if (g.val() && this.parse(g.val()) === null) {
                        this.$element.addClass("t-state-error")
                    }
                    if (!this.dateView.isOpened() && this.dateView === this.dateView.$calendar.data("associatedDateView")) {
                        this._update(g.val())
                    }
                }, this), 100)
            }, this)
        });
        if (!g.parent().hasClass("t-picker-wrap")) {
            g.wrap('<div class="t-widget t-datepicker"><div class="t-picker-wrap"></div></div>');
            if (k.showButton) {
                var h = new b.stringBuilder(),
					l = k.buttonTitle;
                a(h.cat('<span class="t-select">').cat('<span class="t-icon t-icon-calendar" ').catIf('title="', l).catIf(l, l).cat('"></span></span>').string()).insertAfter(g)
            }
        }
        this.dateView = new b.dateView({
            todayFormat: this.todayFormat,
            selectedValue: this.selectedValue,
            minValue: this.minValue,
            maxValue: this.maxValue,
            effects: this.effects,
            isRtl: g.closest(".t-rtl").length,
            onChange: a.proxy(function (n) {
                this._update(n);
                this._close()
            }, this)
        });
        this.dateView.$calendar.bind("mousedown", function (n) {
            n.preventDefault()
        }).bind("click", a.proxy(function (n) {
            n.stopPropagation();
            clearTimeout(this._bluring);
            if (this.dateView !== this.dateView.$calendar.data("associatedDateView")) {
                return
            }
            if (n.target.parentNode.className.indexOf("t-state-selected") != -1) {
                this._close()
            }
        }, this));
        this.inputValue = g.val();
        var m = this.selectedValue || this.inputValue;
        if (m) {
            this._value(this.parse(m))
        }
        var i = this.enabled ? a.proxy(this._togglePopup, this) : b.preventDefault;
        this.$wrapper = g.closest(".t-datepicker").find(".t-icon").bind("click", i).end();
        a(document.documentElement).bind("mousedown", a.proxy(function (o) {
            var p = this.$element.val();
            if (p != this.inputValue) {
                this._update(p)
            }
            if (!f) {
                return
            }
            var n = f.data("associatedDateView");
            if (!n || n != this.dateView) {
                return
            }
            if (!a.contains(this.$wrapper[0], o.target) && !a.contains(f[0], o.target)) {
                this._close()
            }
        }, this));
        b.bind(this, {
            open: this.onOpen,
            close: this.onClose,
            valueChange: this.onChange,
            load: this.onLoad
        })
    };
    b.datepicker.prototype = {
        _togglePopup: function () {
            if (this.dateView.isOpened()) {
                this._close()
            } else {
                this.element.focus();
                this._open()
            }
        },
        _close: function () {
            if (!f.is(":animated") && this.dateView.isOpened()) {
                this._trigger("close")
            }
        },
        _open: function () {
            if (!this.dateView.isOpened()) {
                this._trigger("open")
            }
        },
        _trigger: function (g) {
            if (!b.trigger(this.element, g)) {
                this[g]()
            }
        },
        _update: function (k) {
            k = this.parse(k);
            if (k != null) {
                if (k - this.minValue <= 0) {
                    k = this.minValue
                } else {
                    if (k - this.maxValue >= 0) {
                        k = this.maxValue
                    }
                }
            }
            var j = this.selectedValue,
				h = j ? b.datetime.format(j, this.format) : "",
				i = k ? b.datetime.format(k, this.format) : "";
            this._value(k);
            if (i != h) {
                var g = {
                    previousValue: j,
                    value: k,
                    previousDate: j,
                    date: k
                };
                if (b.trigger(this.element, "valueChange", g)) {
                    this._value(j)
                }
            }
        },
        _keydown: function (g) {
            var h = g.keyCode;
            if (h == 9 || (h == 13 && this.inputValue != this.$element.val())) {
                this._update(this.$element.val());
                this._close()
            } else {
                if (h == 27) {
                    this._close()
                } else {
                    if (g.altKey) {
                        if (h == 40) {
                            this._open()
                        } else {
                            if (h == 38) {
                                this._close()
                            }
                        }
                    } else {
                        this.dateView.navigate(g)
                    }
                }
            }
        },
        enable: function () {
            this.$element.attr("disabled", false);
            this.$wrapper.removeClass("t-state-disabled").find(".t-icon").unbind("click").bind("click", a.proxy(this._togglePopup, this))
        },
        disable: function (g) {
            this.$element.attr("disabled", true);
            this.$wrapper.addClass("t-state-disabled").find(".t-icon").unbind("click").bind("click", b.preventDefault)
        },
        _value: function (i) {
            var h = this.$element.val();
            var g = i === null;
            this.selectedValue = i;
            this.dateView.value(i);
            if (!g) {
                h = b.datetime.format(i, this.format)
            }
            this.inputValue = h;
            this.$element.toggleClass("t-state-error", g && h != "").val(h)
        },
        value: function (h) {
            if (h === undefined) {
                return this.selectedValue
            }
            var g = this.parse(h);
            g = b.datepicker.isInRange(g, this.minValue, this.maxValue) ? g : null;
            if (g === null) {
                this.$element.removeClass("t-state-error").val("")
            }
            this._value(g);
            return this
        },
        showPopup: function () {
            this.open()
        },
        hidePopup: function () {
            this.close()
        },
        open: function () {
            var g = this.$element;
            this.dateView.open({
                offset: g.offset(),
                outerHeight: g.outerHeight(),
                outerWidth: g.outerWidth(),
                zIndex: b.getElementZIndex(g[0])
            })
        },
        close: function () {
            this.dateView.close()
        },
        parse: function (i, g) {
            if (i === null || i.getDate) {
                return i
            }
            var h = b.datetime.parse({
                value: i,
                format: g || this.format,
                shortYearCutOff: this.shortYearCutOff
            });
            return h != null ? h.toDate() : null
        }
    };
    a.each(["min", "max"], a.proxy(function (g, h) {
        b.datepicker.prototype[h] = function (l) {
            var k = h + "Value";
            if (l === undefined) {
                return this[k]
            }
            var j = this.parse(l);
            if (j !== null) {
                var i = this[k];
                this[k] = j;
                if (this.minValue > this.maxValue) {
                    this[k] = i;
                    return
                }
                this.dateView[h](j)
            }
        }
    }, this));
    a.extend(b.datepicker, {
        adjustDate: function (j, g, h, i) {
            if (j == 0) {
                b.datetime.modify(g, b.datetime.msPerDay * h)
            } else {
                if (j == 1) {
                    g.addMonth(i)
                } else {
                    g.addYear((j == 2 ? i : 10 * i))
                }
            }
        },
        isInRange: function (g, i, h) {
            if (!g) {
                return false
            }
            return i - g <= 0 && h - g >= 0
        }
    });
    a.fn.tDatePicker = function (g) {
        return b.create(this, {
            name: "tDatePicker",
            init: function (h, i) {
                return new b.datepicker(h, i)
            },
            options: g
        })
    };
    a.fn.tDatePicker.defaults = {
        effects: b.fx.slide.defaults(),
        selectedValue: null,
        format: b.cultureInfo.shortDate,
        minValue: new Date(1899, 11, 31),
        maxValue: new Date(2100, 0, 1),
        shortYearCutOff: 30,
        showButton: true,
        buttonTitle: "Open the calendar",
        enabled: true,
        openOnFocus: false
    }
})(jQuery);