(function (a) {
    var b = a.easyui;
    b.scripts = b.scripts || [];
    b.scripts.push("easyui.datetimepicker.js");

    function c(f, e) {
        var d = new b.stringBuilder();
        return d.cat('<span class="t-icon t-icon-').cat(f).cat('" ').catIf('title="', e).catIf(e, e).cat('"></span>').string()
    }
    b.datetimepicker = function (e, f) {
        a.extend(this, f);
        if (e.nodeName.toLowerCase() !== "input" && e.type.toLowerCase() !== "text") {
            throw "Target element is not a INPUT"
        }
        this.element = e;
        var d = this.$element = a(e).addClass("t-input").attr("autocomplete", "off").bind({
            keydown: a.proxy(this._keydown, this),
            focus: a.proxy(function (i) {
                this.$element.removeClass("t-state-error")
            }, this),
            blur: a.proxy(function (i) {
                this._bluring = setTimeout(a.proxy(function () {
                    if (d.val() && this.parse(d.val()) === null) {
                        this.$element.addClass("t-state-error")
                    }
                    if (!this.dateView.isOpened() && this.dateView === this.dateView.$calendar.data("associatedDateView")) {
                        this._update(d.val())
                    }
                }, this), 100)
            }, this)
        });
        if (!d.parent().hasClass("t-picker-wrap")) {
            d.wrap('<div class="t-widget t-datetimepicker"><div class="t-picker-wrap"></div></div>');
            if (f.showCalendarButton || f.showTimeButton) {
                a(new b.stringBuilder().cat('<span class="t-select">').catIf(c("calendar", f.calendarButtonTitle), f.showCalendarButton).cat(c("clock", f.timeButtonTitle), f.showTimeButton).cat("</span>").string()).insertAfter(d)
            }
        }
        this.$wrapper = d.closest(".t-datetimepicker").find(".t-icon-clock").bind("click", this.enabled ? a.proxy(this._toggleTimeView, this) : b.preventDefault).end().find(".t-icon-calendar").bind("click", this.enabled ? a.proxy(this._toggleDateView, this) : b.preventDefault).end();
        this.timeView = new b.timeView({
            dates: this.dates,
            effects: this.effects,
            dropDownAttr: this.dropDownAttr,
            format: this.timeFormat,
            interval: this.interval,
            isRtl: d.closest(".t-rtl").length,
            minValue: this.startTimeValue,
            maxValue: this.endTimeValue,
            onNavigateWithOpenPopup: a.proxy(function (j) {
                var i = this.parse(j, this.timeFormat);
                this.$element.val(b.datetime.format(i, this.format))
            }, this),
            onChange: a.proxy(function (i) {
                clearTimeout(this._bluring);
                this._update(this.parse(i, this.timeFormat));
                this._close("time");
                window.setTimeout(function () {
                    d.focus()
                }, 1)
            }, this)
        });
        this.dateView = new b.dateView({
            todayFormat: this.todayFormat,
            selectedValue: this.selectedValue,
            minValue: this.minValue,
            maxValue: this.maxValue,
            effects: this.effects,
            isRtl: d.closest(".t-rtl").length,
            onChange: a.proxy(function (i) {
                this._update(i);
                this._close("date")
            }, this)
        });
        this.dateView.$calendar.bind("click", a.proxy(function (i) {
            i.stopPropagation();
            clearTimeout(this._bluring);
            if (this.dateView !== this.dateView.$calendar.data("associatedDateView")) {
                return
            }
            if (i.target.parentNode.className.indexOf("t-state-selected") != -1) {
                this._close("date")
            }
            window.setTimeout(function () {
                d.focus()
            }, 1)
        }, this));
        this.inputValue = d.val();
        var h = this.selectedValue || this.inputValue;
        if (h) {
            var g = this.parse(h);
            this.dateView.selectedValue = g;
            this._value(this.parse(h))
        }
        a(document.documentElement).bind("mousedown", a.proxy(function (l) {
            var o = this.$element.val();
            if (o != this.inputValue) {
                this._update(o)
            }
            var i = this.dateView.$calendar;
            if (!i) {
                return
            }
            var j = this.timeView.dropDown.$element;
            var m = j && j.parent().length > 0;
            var k = i.data("associatedDateView");
            var n = l.target;
            if (a.contains(this.$wrapper[0], n) || (k && k == this.dateView && a.contains(i[0], n)) || (m && a.contains(j.parent()[0], n))) {
                return
            }
            this._close("date");
            this._close("time")
        }, this));
        b.bind(this, {
            open: this.onOpen,
            close: this.onClose,
            valueChange: this.onChange,
            load: this.onLoad
        })
    };
    b.datetimepicker.prototype = {
        _update: function (h) {
            h = this.parse(h);
            if (h != null) {
                if (h - this.minValue <= 0) {
                    h = this.minValue
                } else {
                    if (h - this.maxValue >= 0) {
                        h = this.maxValue
                    }
                }
            }
            var g = this.selectedValue,
				e = g ? b.datetime.format(g, this.format) : "",
				f = h ? b.datetime.format(h, this.format) : "";
            this._value(h);
            if (f != e) {
                var d = {
                    previousValue: g,
                    value: h
                };
                if (b.trigger(this.element, "valueChange", d)) {
                    this._value(g)
                }
            }
        },
        _value: function (f) {
            var e = this.$element.val();
            var d = f === null;
            this.selectedValue = f;
            this.timeView.value(d ? null : b.datetime.format(f, this.timeFormat));
            this.dateView.value(f);
            if (!d) {
                e = b.datetime.format(f, this.format)
            }
            this.inputValue = e;
            this.$element.toggleClass("t-state-error", d && e != "").val(e)
        },
        _open: function (d) {
            if (!this[d == "time" ? "timeView" : "dateView"].isOpened()) {
                this._trigger(d, "open")
            }
        },
        _close: function (f) {
            var d = this.dateView;
            var e = this.timeView.dropDown;
            if ((f == "time" && !e.$element.is(":animated") && e.isOpened()) || (!d.$calendar.is(":animated") && d.isOpened())) {
                this._trigger(f, "close")
            }
        },
        _trigger: function (e, d) {
            if (!b.trigger(this.element, d, {
                popup: e
            })) {
                this[d](e)
            }
        },
        _keydown: function (d) {
            var g = d.keyCode,
				f = this.dateView.isOpened();
            if (g == 9 || g == 27 || (g == 13 && this.inputValue != this.$element.val())) {
                this._update(this.$element.val());
                this._close("date");
                this._close("time");
                return
            }
            if (d.altKey) {
                if (g == 40) {
                    this._close(f ? "date" : "time");
                    this._open(f ? "time" : "date")
                } else {
                    if (g == 38) {
                        this._close(f ? "date" : "time")
                    }
                }
                return
            }
            if (f) {
                this.dateView.navigate(d);
                return
            }
            if (this.timeView.isOpened() && (g === 38 || g === 40)) {
                this.timeView.navigate(d);
                return
            }
        },
        _toggleDateView: function () {
            if (this.dateView.isOpened()) {
                this._close("date")
            } else {
                this.element.focus();
                this._open("date");
                this._close("time")
            }
        },
        _toggleTimeView: function () {
            if (this.timeView.isOpened()) {
                this._close("time")
            } else {
                this.element.focus();
                this._open("time");
                this._close("date")
            }
        },
        enable: function () {
            this.$element.attr("disabled", false);
            this.$wrapper.removeClass("t-state-disabled").find(".t-icon-clock").unbind("click").bind("click", a.proxy(this._toggleTimeView, this)).end().find(".t-icon-calendar").unbind("click").bind("click", a.proxy(this._toggleDateView, this))
        },
        disable: function (d) {
            this.$element.attr("disabled", true);
            this.$wrapper.addClass("t-state-disabled").find(".t-icon").unbind("click").bind("click", b.preventDefault)
        },
        open: function (e) {
            var d = this.$element;
            var f = {
                offset: d.offset(),
                outerHeight: d.outerHeight(),
                outerWidth: d.outerWidth(),
                zIndex: b.getElementZIndex(d[0])
            };
            this[e == "time" ? "timeView" : "dateView"].open(f)
        },
        close: function (d) {
            this[d == "time" ? "timeView" : "dateView"].close()
        },
        value: function (e) {
            if (e === undefined) {
                return this.selectedValue
            }
            var d = this.parse(e);
            d = b.datepicker.isInRange(d, this.minValue, this.maxValue) ? d : null;
            if (d === null) {
                this.$element.removeClass("t-state-error").val("")
            }
            this._value(d);
            return this
        },
        parse: function (f, d) {
            if (f === null || f.getDate) {
                return f
            }
            d = d || this.format;
            var e = b.datetime.parse({
                AM: b.cultureInfo.am,
                PM: b.cultureInfo.pm,
                value: f,
                format: d,
                baseDate: this.selectedValue ? new b.datetime(this.selectedValue) : new b.datetime()
            });
            return e != null ? e.toDate() : null
        }
    };
    a.each(["min", "max"], a.proxy(function (d, e) {
        b.datetimepicker.prototype[e] = function (i) {
            var h = e + "Value";
            if (i === undefined) {
                return this[h]
            }
            var g = this.parse(i);
            if (g !== null) {
                var f = this[h];
                this[h] = g;
                if (this.minValue > this.maxValue) {
                    this[h] = f;
                    return
                }
                this.dateView[e](g)
            }
        }
    }, this));
    a.each(["startTime", "endTime"], a.proxy(function (d, e) {
        b.datetimepicker.prototype[e] = function (h) {
            var g = e + "Value";
            if (h === undefined) {
                return this[g]
            }
            var f = this.parse(h, b.cultureInfo.shortTime);
            if (f !== null) {
                this[g] = f;
                e == "startTime" ? this.timeView.min(f) : this.timeView.max(f)
            }
        }
    }, this));
    a.fn.tDateTimePicker = function (d) {
        a.fn.tDateTimePicker.defaults.timeFormat = b.cultureInfo.shortTime;
        return b.create(this, {
            name: "tDateTimePicker",
            init: function (e, f) {
                return new b.datetimepicker(e, f)
            },
            options: d
        })
    };
    a.fn.tDateTimePicker.defaults = {
        effects: b.fx.slide.defaults(),
        selectedValue: null,
        format: b.cultureInfo.generalDateTime,
        focusedDate: new b.datetime(),
        minValue: new Date(1899, 11, 31),
        maxValue: new Date(2100, 0, 1),
        startTimeValue: new b.datetime().hours(0).minutes(0).seconds(0).toDate(),
        endTimeValue: new b.datetime().hours(0).minutes(0).seconds(0).toDate(),
        calendarButtonTitle: "Open the calendar",
        timeButtonTitle: "Open the time view",
        showCalendarButton: true,
        showTimeButton: true,
        shortYearCutOff: 30,
        enabled: true,
        interval: 30
    }
})(jQuery);