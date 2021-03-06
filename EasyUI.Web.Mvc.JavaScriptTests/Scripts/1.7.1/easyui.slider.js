(function (a) {
    var b = a.easyui,
		k = b.isTouch ? "touchstart" : "mousedown",
		m = 3;
    b.scripts.push("easyui.slider.js");
    b.slider = function (q, r) {
        r = r || {};
        var p = a(q);
        q.type = "text";
        this.element = q;
        r.val = n(p.val() || n(r.val));
        r.distance = r.maxValue - r.minValue;
        a.extend(this, r);
        r.position = this.orientation == "horizontal" ? "left" : "bottom";
        r.size = this.orientation == "horizontal" ? "width" : "height";
        r.outerSize = this.orientation == "horizontal" ? "outerWidth" : "outerHeight";
        r.orientation = this.orientation;
        d(q, r);
        this.wrapper = p.closest(".t-slider");
        this.trackDiv = this.wrapper.find(".t-slider-track");
        b.slider.setTrackDivWidth(this.wrapper, r);
        this.maxSelection = this.trackDiv[r.size]();
        var u = this.maxSelection / ((this.maxValue - this.minValue) / this.smallStep);
        var s = b.slider.calculateItemsWidth(this.wrapper, r, Math.floor(this.distance / this.smallStep));
        if (r.tickPlacement != "none" && u >= 2) {
            this.trackDiv.before(e(r));
            b.slider.setItemsWidth(this.wrapper, this.trackDiv, s, r);
            b.slider.setItemsTitle(this.wrapper, r);
            b.slider.setItemsLargeTick(this.wrapper, r)
        }
        b.slider.calculateSteps.call(this, s);
        var t = {
            element: q,
            dragHandle: this.wrapper.find(".t-draghandle"),
            orientation: r.orientation,
            size: r.size,
            outerSize: r.outerSize,
            position: r.position,
            owner: this
        };
        this._setValueInRange(r.val);
        this[r.enabled ? "enable" : "disable"]();
        new b.slider.Selection(t);
        this._drag = new b.slider.Drag(t);
        this.keyMap = {
            37: h(r.smallStep),
            40: h(r.smallStep),
            39: j(r.smallStep),
            38: j(r.smallStep),
            35: o(r.maxValue),
            36: o(r.minValue),
            33: j(r.largeStep),
            34: h(r.largeStep)
        };
        b.bind(this, {
            slide: this.onSlide,
            change: this.onChange,
            load: this.onLoad
        })
    };
    a.extend(b.slider, {
        setTrackDivWidth: function (s, p) {
            var q = s.find(".t-slider-track");
            var r = n(q.css(p.position)) * 2;
            q[p.size]((s[p.size]() - 2) - r)
        },
        setItemsWidth: function (y, x, v, u) {
            var s = Math.floor(u.distance / u.smallStep),
				r = y.find(".t-tick"),
				w = 0,
				t = x[u.size](),
				p = a.extend([], v);
            if (u.orientation == "horizontal") {
                for (var q = 0; q < r.length - 2; q++) {
                    a(r[q + 1])[u.size](p[q])
                }
            } else {
                p = p.reverse();
                for (var q = 2; q < r.length; q++) {
                    a(r[q - 1])[u.size](p[q])
                }
            }
            if (u.orientation == "horizontal") {
                a(r[0]).addClass("t-first")[u.size](p[s]);
                a(r[r.length - 1]).addClass("t-last")[u.size](p[s - 1])
            } else {
                a(r[r.length - 1]).addClass("t-first")[u.size](p[0]);
                a(r[0]).addClass("t-last")[u.size](p[1])
            }
            if (u.distance % u.smallStep != 0 && u.orientation == "vertical") {
                for (var q = 0; q < p.length; q++) {
                    w += v[q]
                }
                y.find(".t-slider-items").css("padding-top", 29 + (t - w))
            }
        },
        setItemsTitle: function (t, r) {
            var q = t.find(".t-tick"),
				s = r.minValue;
            if (r.orientation == "horizontal") {
                for (var p = 0; p < q.length; p++) {
                    a(q[p]).attr("title", b.formatString(r.tooltip.format || "{0}", n(s)));
                    s += r.smallStep
                }
            } else {
                for (var p = q.length - 1; p >= 0; p--) {
                    a(q[p]).attr("title", b.formatString(r.tooltip.format || "{0}", n(s)));
                    s += r.smallStep
                }
            }
        },
        setItemsLargeTick: function (u, s) {
            if ((1000 * s.largeStep) % (1000 * s.smallStep) == 0) {
                var r = u.find(".t-tick"),
					q = {},
					t = n(s.largeStep / s.smallStep);
                if (s.orientation == "horizontal") {
                    for (var p = 0; p < r.length; p = n(p + t)) {
                        q = a(r[p]);
                        q.addClass("t-tick-large").html(a("<span class='t-label'></span>").html(q.attr("title")))
                    }
                } else {
                    for (var p = r.length - 1; p >= 0; p = n(p - t)) {
                        q = a(r[p]);
                        q.addClass("t-tick-large").html(a("<span class='t-label'></span>").html(q.attr("title")));
                        if (p != 0 && p != r.length - 1) {
                            q.css("line-height", q[s.size]() + "px")
                        }
                    }
                }
            }
        },
        calculateItemsWidth: function (w, s, q) {
            var v = parseFloat(w.find(".t-slider-track").css(s.size)) + 1,
				t = v / s.distance;
            if ((s.distance / s.smallStep) - Math.floor(s.distance / s.smallStep) > 0) {
                v -= ((s.distance % s.smallStep) * t)
            }
            var r = v / q,
				u = [];
            for (var p = 0; p < q - 1; p++) {
                u[p] = r
            }
            u[q - 1] = u[q] = r / 2;
            return this.roundWidths(u)
        },
        roundWidths: function (q) {
            var p = 0;
            for (i = 0; i < q.length; i++) {
                p += (q[i] - Math.floor(q[i]));
                q[i] = Math.floor(q[i])
            }
            p = Math.round(p);
            return this.addAdditionalSize(p, q)
        },
        addAdditionalSize: function (p, r) {
            if (p == 0) {
                return r
            }
            var s = parseFloat(r.length - 1) / parseFloat(p == 1 ? p : p - 1);
            for (var q = 0; q < p; q++) {
                r[parseInt(Math.round(s * q))] += 1
            }
            return r
        },
        getValueFromPosition: function (s, p, t) {
            var v = Math.max(t.smallStep * (t.maxSelection / t.distance), 0),
				u = 0,
				q = (v / 2);
            if (t.orientation == "horizontal") {
                u = s - p.startPoint
            } else {
                u = p.startPoint - s
            }
            if (t.maxSelection - ((parseInt(t.maxSelection % v) - 3) / 2) < u) {
                return t.maxValue
            }
            for (var r = 0; r < t._pixelStepsArray.length; r++) {
                if (Math.abs(t._pixelStepsArray[r] - u) - 1 <= q) {
                    return n(t._valuesArray[r])
                }
            }
        },
        getDragableArea: function (t, p, s) {
            var q = t.offset().left,
				r = t.offset().top;
            return {
                startPoint: s == "horizontal" ? q : r + p,
                endPoint: s == "horizontal" ? q + p : r
            }
        },
        calculateSteps: function (s) {
            var u = this,
				v = u.minValue,
				t = 0,
				q = Math.ceil(u.distance / u.smallStep),
				p = 1;
            q += (u.distance / u.smallStep) % 1 == 0 ? 1 : 0;
            s.splice(0, 0, s.pop() * 2);
            s.splice(q, 1, s.pop() * 2);
            u._pixelStepsArray = [t];
            u._valuesArray = [v];
            if (q == 0) {
                return
            }
            while (p < q) {
                t += (s[p - 1] + s[p]) / 2;
                u._pixelStepsArray[p] = t;
                u._valuesArray[p] = v += u.smallStep;
                p++
            }
            var r = u.distance % u.smallStep == 0 ? q - 1 : q;
            u._pixelStepsArray[r] = u.maxSelection;
            u._valuesArray[r] = u.maxValue
        }
    });

    function j(p) {
        return function (q) {
            return q + p
        }
    }
    function h(p) {
        return function (q) {
            return q - p
        }
    }
    function o(p) {
        return function () {
            return p
        }
    }
    function l(p) {
        return p.toString().replace(".", b.cultureInfo.numericdecimalseparator)
    }
    function n(q) {
        q = (q + "").replace(b.cultureInfo.numericdecimalseparator, ".");
        q = parseFloat(q, 10);
        var p = Math.pow(10, m || 0);
        return Math.round(q * p) / p
    }
    b.slider.prototype = {
        enable: function () {
            this.wrapper.removeAttr("disabled").removeClass("t-state-disabled").addClass("t-state-default");
            var p = a.proxy(function (s) {
                if (a(s.target).hasClass("t-draghandle")) {
                    return
                }
                this._drag.start(s)
            }, this);
            this.wrapper.find(".t-tick").bind(k, p).end().find(".t-slider-track").bind(k, p);
            var r = a.proxy(function (s) {
                this._setValueInRange(this._nextValueByIndex(this._valueIndex + (s * 1)))
            }, this);
            if (this.showButtons) {
                var q = a.proxy(function (s, t) {
                    if (s.which == 1) {
                        r(t);
                        this.timeout = setTimeout(a.proxy(function () {
                            this.timer = setInterval(function () {
                                r(t)
                            }, 60)
                        }, this), 200)
                    }
                }, this);
                this.wrapper.find(".t-button").unbind("mousedown").unbind("mouseup").bind("mouseup", a.proxy(function (s) {
                    this._clearTimer()
                }, this)).unbind("mouseover").bind("mouseover", function (s) {
                    a(s.currentTarget).addClass("t-state-hover")
                }).unbind("mouseout").bind("mouseout", a.proxy(function (s) {
                    a(s.currentTarget).removeClass("t-state-hover");
                    this._clearTimer()
                }, this)).eq(0).bind("mousedown", a.proxy(function (s) {
                    q(s, 1);
                    s.preventDefault()
                }, this)).end().eq(1).bind("mousedown", a.proxy(function (s) {
                    q(s, -1);
                    s.preventDefault()
                }, this))
            }
            this.wrapper.find(".t-draghandle").bind({
                keydown: a.proxy(this._keydown, this)
            });
            this.enabled = true
        },
        disable: function () {
            this.wrapper.attr("disabled", "disabled").removeClass("t-state-default").addClass("t-state-disabled");
            var p = b.preventDefault;
            this.wrapper.find(".t-button").unbind("mousedown").bind("mousedown", p).unbind("mouseup").bind("mouseup", p).unbind("mouseleave").bind("mouseleave", p).unbind("mouseover").bind("mouseover", p);
            this.wrapper.find(".t-tick").unbind(k).end().find(".t-slider-track").unbind(k);
            this.wrapper.find(".t-draghandle").unbind("keydown").bind("keydown", p);
            this.enabled = false
        },
        _nextValueByIndex: function (q) {
            var p = this._valuesArray.length;
            return this._valuesArray[Math.max(0, Math.min(q, p - 1))]
        },
        _update: function (q) {
            var p = this.value() != q;
            this.value(q);
            if (p) {
                b.trigger(this.element, "change", {
                    value: this.val
                })
            }
        },
        value: function (p) {
            p = n(p);
            if (isNaN(p)) {
                return this.val
            }
            if (p >= this.minValue && p <= this.maxValue) {
                if (this.val != p) {
                    a(this.element).attr("value", l(n(p)));
                    this.val = p;
                    this.refresh()
                }
            }
        },
        refresh: function () {
            b.trigger(this.element, "t:moveSelection", {
                value: this.val
            })
        },
        _clearTimer: function (p) {
            clearTimeout(this.timeout);
            clearInterval(this.timer)
        },
        _keydown: function (p) {
            if (p.keyCode in this.keyMap) {
                this._setValueInRange(this.keyMap[p.keyCode](this.val));
                p.preventDefault()
            }
        },
        _setValueInRange: function (p) {
            p = n(p);
            if (isNaN(p)) {
                this._update(this.minValue);
                return
            }
            p = Math.max(p, this.minValue);
            p = Math.min(p, this.maxValue);
            this._update(p)
        }
    };
    b.slider.Selection = function (s) {
        var p = a(s.element),
			t = s.owner;

        function r(z) {
            var y = z - t.minValue,
				v = t._valueIndex = Math.ceil(n(y / t.smallStep)),
				w = t._pixelStepsArray[v],
				x = t.trackDiv.find(".t-slider-selection"),
				u = parseInt(s.dragHandle[s.outerSize]() / 2, 10) + 1;
            x[s.size](w);
            s.dragHandle.css(s.position, w - u)
        }
        r(t.val);
        var q = function (u) {
            r(n(u.value))
        };
        p.bind({
            change: q,
            slide: q,
            "t:moveSelection": q
        })
    };
    b.slider.Drag = function (p) {
        p.dragHandleSize = p.dragHandle[p.outerSize]();
        a.extend(this, p);
        this.draggable = new b.draggable({
            distance: 0,
            owner: p.dragHandle,
            scope: p.element.id.replace("[", "").replace("]", ""),
            start: a.proxy(this._start, this),
            drag: a.proxy(this.drag, this),
            stop: a.proxy(this.stop, this)
        })
    };
    b.slider.Drag.prototype = {
        start: function (p) {
            var q = b.touchLocation(p);
            this.draggable._startDrag(p.currentTarget, q);
            this.draggable._start(p);
            this.draggable._drag(p)
        },
        _start: function (p) {
            if (!this.owner.enabled) {
                return false
            }
            a(this.element).unbind("mouseover");
            this.val = n(a(this.element).val());
            this.dragableArea = b.slider.getDragableArea(this.owner.trackDiv, this.owner.maxSelection, this.orientation);
            this.step = Math.max(this.owner.smallStep * (this.owner.maxSelection / this.owner.distance), 0);
            this.selectionStart = this.owner.selectionStart;
            this.selectionEnd = this.owner.selectionEnd;
            this.oldVal = this.val;
            this.format = this.owner.tooltip.format || "{0}";
            if (this.type) {
                this.owner._setZIndex(this.type)
            }
            if (this.owner.tooltip.enabled) {
                this.tooltipDiv = a("<div class='t-widget t-tooltip'></div>").appendTo(document.body);
                if (this.type) {
                    var r = b.formatString(this.format, this.selectionStart),
						q = b.formatString(this.format, this.selectionEnd);
                    this.tooltipDiv.html(r + " - " + q)
                } else {
                    var s = "t-callout-";
                    if (this.orientation == "horizontal") {
                        if (this.owner.tickPlacement == "topLeft") {
                            s += "n"
                        } else {
                            s += "s"
                        }
                    } else {
                        if (this.owner.tickPlacement == "topLeft") {
                            s += "w"
                        } else {
                            s += "e"
                        }
                    }
                    this.tooltipInnerDiv = "<div class='t-callout " + s + "'></div>";
                    this.tooltipDiv.html(b.formatString(this.owner.tooltip.format || "{0}", this.val) + this.tooltipInnerDiv)
                }
                this.moveTooltip()
            }
        },
        drag: function (p) {
            var s = b.touchLocation(p);
            if (this.orientation == "horizontal") {
                this.val = this.horizontalDrag(s.x)
            } else {
                this.val = this.verticalDrag(s.y)
            }
            if (this.oldVal != this.val) {
                this.oldVal = this.val;
                if (this.type) {
                    if (this.type == "firstHandle") {
                        if (this.val < this.selectionEnd) {
                            this.selectionStart = this.val
                        } else {
                            this.selectionStart = this.selectionEnd = this.val
                        }
                    } else {
                        if (this.val > this.selectionStart) {
                            this.selectionEnd = this.val
                        } else {
                            this.selectionStart = this.selectionEnd = this.val
                        }
                    }
                    b.trigger(this.element, "slide", {
                        values: [this.selectionStart, this.selectionEnd]
                    });
                    if (this.owner.tooltip.enabled) {
                        var r = b.formatString(this.format, this.selectionStart),
							q = b.formatString(this.format, this.selectionEnd);
                        this.tooltipDiv.html(r + " - " + q)
                    }
                } else {
                    b.trigger(this.element, "slide", {
                        value: this.val
                    });
                    if (this.owner.tooltip.enabled) {
                        this.tooltipDiv.html(b.formatString(this.format, this.val) + this.tooltipInnerDiv)
                    }
                }
                if (this.owner.tooltip.enabled) {
                    this.moveTooltip()
                }
            }
        },
        stop: function (p) {
            if (b.isTouch) {
                p.preventDefault()
            }
            if (p.keyCode == 27) {
                this.owner.refresh()
            } else {
                if (this.type) {
                    this.owner._update(this.selectionStart, this.selectionEnd)
                } else {
                    this.owner._update(this.val)
                }
            }
            if (this.owner.tooltip.enabled) {
                this.tooltipDiv.remove()
            }
            a(this.element).bind("mouseover");
            return false
        },
        moveTooltip: function () {
            var w = this,
				x = 0,
				t = 0,
				u = 4,
				p = w.tooltipDiv.find(".t-callout");
            if (w.type) {
                var r = w.owner.wrapper.find(".t-draghandle"),
					s = r.eq(0).offset(),
					v = r.eq(1).offset();
                if (w.orientation == "horizontal") {
                    x = v.top;
                    t = s.left + ((v.left - s.left) / 2)
                } else {
                    x = s.top + ((v.top - s.top) / 2);
                    t = v.left
                }
            } else {
                var q = w.dragHandle.offset();
                x = q.top;
                t = q.left
            }
            if (w.orientation == "horizontal") {
                t -= Math.round((w.tooltipDiv.outerWidth() - w.dragHandle[w.outerSize]()) / 2);
                x -= w.tooltipDiv.outerHeight() + p.height() + u
            } else {
                x -= Math.round((w.tooltipDiv.outerHeight() - w.dragHandle[w.outerSize]()) / 2);
                t -= w.tooltipDiv.outerWidth() + p.width() + u
            }
            w.tooltipDiv.css({
                top: x,
                left: t
            })
        },
        horizontalDrag: function (q) {
            var p = 0;
            if (this.dragableArea.startPoint < q && q < this.dragableArea.endPoint) {
                p = b.slider.getValueFromPosition(q, this.dragableArea, this.owner)
            } else {
                if (q >= this.dragableArea.endPoint) {
                    p = this.owner.maxValue
                } else {
                    p = this.owner.minValue
                }
            }
            return p
        },
        verticalDrag: function (q) {
            var p = 0;
            if (this.dragableArea.startPoint > q && q > this.dragableArea.endPoint) {
                p = b.slider.getValueFromPosition(q, this.dragableArea, this.owner)
            } else {
                if (q <= this.dragableArea.endPoint) {
                    p = this.owner.maxValue
                } else {
                    p = this.owner.minValue
                }
            }
            return p
        }
    };

    function g(r, q) {
        var p = a(q),
			s = r.orientation == "horizontal" ? " t-slider-horizontal" : " t-slider-vertical",
			u;
        if (r.tickPlacement == "bottomRight") {
            u = " t-slider-bottomright"
        } else {
            if (r.tickPlacement == "topLeft") {
                u = " t-slider-topleft"
            }
        }
        var t = r.style ? r.style : p.attr("style");
        return new b.stringBuilder().cat("<div class='t-widget t-slider").cat(s).catIf(" ", p.attr("class"), p.attr("class")).cat("'").catIf(" style='", t, "'", t).cat(">").cat("<div class='t-slider-wrap").catIf(" t-slider-buttons", r.showButtons).catIf(u, u).cat("'></div></div>").string()
    }
    function c(r, s) {
        var p, q = r.orientation == "horizontal";
        if (s == "increase") {
            p = q ? "t-arrow-next" : "t-arrow-up"
        } else {
            p = q ? "t-arrow-prev" : "t-arrow-down"
        }
        return new b.stringBuilder().cat("<a ").cat("class='t-button ").cat("t-button-" + s).cat("'><span class='t-icon ").cat(p).cat("' title='").cat(r[s + "ButtonTitle"]).cat("'>").cat(r[s + "ButtonTitle"]).cat("</span></a>").string()
    }
    function e(p) {
        return new b.stringBuilder().cat("<ul class='t-reset t-slider-items'>").rep("<li class='t-tick'>&nbsp;</li>", (Math.floor((p.distance / p.smallStep).toFixed(3), 10) + 1)).cat("</ul>").string()
    }
    function f(p) {
        var q = p.is("input") ? 1 : 2;
        return new b.stringBuilder().cat("<div class='t-slider-track'>").cat("<div class='t-slider-selection'></div>").cat("<a href='javascript:void(0)' class='t-draghandle' title='Drag'>Drag</a>").catIf("<a href='javascript:void(0)' class='t-draghandle t-draghandle1' title='Drag'>Drag</a>", q > 1).cat("</div>").string()
    }
    function d(q, s) {
        var p = a(q),
			r = p.find("input");
        if (r.length == 2) {
            r.eq(0).val(l(s.selectionStart));
            r.eq(1).val(l(s.selectionEnd))
        } else {
            p.val(l(s.val))
        }
        p.wrap(g(s, q)).hide();
        if (s.showButtons) {
            p.before(c(s, "increase")).before(c(s, "decrease"))
        }
        p.before(f(p))
    }
    a.fn.tSlider = function (p) {
        return b.create(this, {
            name: "tSlider",
            init: function (q, r) {
                return new b.slider(q, r)
            },
            options: p
        })
    };
    a.fn.tSlider.defaults = {
        enabled: true,
        minValue: 0,
        maxValue: 10,
        smallStep: 1,
        largeStep: 5,
        showButtons: true,
        increaseButtonTitle: "Increase",
        decreaseButtonTitle: "Decrease",
        orientation: "horizontal",
        tickPlacement: "both",
        tooltip: {
            enabled: true,
            format: "{0}"
        }
    };
    b.rangeSlider = function (q, t) {
        var p = a(q),
			r = a(q).find("input");
        t = t || {};
        r[0].type = "text";
        r[1].type = "text";
        t.selectionStart = n(r.eq(0).val() || t.selectionStart);
        t.selectionEnd = n(r.eq(1).val() || t.selectionEnd);
        this.values(t.selectionStart, t.selectionEnd);
        this.element = q;
        t.distance = t.maxValue - t.minValue;
        a.extend(this, t);
        t.position = this.orientation == "horizontal" ? "left" : "bottom";
        t.size = this.orientation == "horizontal" ? "width" : "height";
        t.outerSize = this.orientation == "horizontal" ? "outerWidth" : "outerHeight";
        d(q, t);
        this.wrapper = p.closest(".t-slider");
        this.trackDiv = this.wrapper.find(".t-slider-track");
        b.slider.setTrackDivWidth(this.wrapper, t);
        this.maxSelection = this.trackDiv[t.size]();
        var w = this.maxSelection / ((this.maxValue - this.minValue) / this.smallStep);
        var u = b.slider.calculateItemsWidth(this.wrapper, t, Math.floor(this.distance / this.smallStep));
        if (t.tickPlacement != "none" && w >= 2) {
            this.trackDiv.before(e(t));
            b.slider.setItemsWidth(this.wrapper, this.trackDiv, u, t);
            b.slider.setItemsTitle(this.wrapper, t);
            b.slider.setItemsLargeTick(this.wrapper, t)
        }
        b.slider.calculateSteps.call(this, u);
        this._correctValues(this.selectionStart, this.selectionEnd);
        var s = {
            element: q,
            type: "firstHandle",
            dragHandle: this.wrapper.find(".t-draghandle:first"),
            orientation: t.orientation,
            size: t.size,
            outerSize: t.outerSize,
            position: t.position,
            owner: this
        };
        this._firstHandleDrag = new b.slider.Drag(s);
        new b.rangeSlider.Selection(s);
        var v = {
            element: q,
            type: "lastHandle",
            outerSize: t.outerSize,
            dragHandle: this.wrapper.find(".t-draghandle:last"),
            orientation: t.orientation,
            size: t.size,
            position: t.position,
            owner: this
        };
        this._lastHandleDrag = new b.slider.Drag(v);
        this[t.enabled ? "enable" : "disable"]();
        this.keyMap = {
            37: h(t.smallStep),
            40: h(t.smallStep),
            39: j(t.smallStep),
            38: j(t.smallStep),
            35: o(t.maxValue),
            36: o(t.minValue),
            33: j(t.largeStep),
            34: h(t.largeStep)
        };
        b.bind(this, {
            slide: this.onSlide,
            change: this.onChange,
            load: this.onLoad
        })
    };
    b.rangeSlider.prototype = {
        enable: function () {
            this.wrapper.removeAttr("disabled").removeClass("t-state-disabled").addClass("t-state-default");
            var p = a.proxy(function (r) {
                if (a(r.target).hasClass("t-draghandle")) {
                    return
                }
                var s = b.touchLocation(r),
					t = this.orientation == "horizontal" ? s.x : s.y,
					q = b.slider.getDragableArea(this.trackDiv, this.maxSelection, this.orientation),
					u = b.slider.getValueFromPosition(t, q, this);
                if (u < this.selectionStart) {
                    this._firstHandleDrag.start(r)
                } else {
                    if (u > this.selectionEnd) {
                        this._lastHandleDrag.start(r)
                    } else {
                        if (u - this.selectionStart <= this.selectionEnd - u) {
                            this._firstHandleDrag.start(r)
                        } else {
                            this._lastHandleDrag.start(r)
                        }
                    }
                }
            }, this);
            this.wrapper.find(".t-tick").bind(k, p).end().find(".t-slider-track").bind(k, p);
            this.wrapper.find(".t-draghandle").eq(0).bind({
                keydown: a.proxy(function (q) {
                    this._keydown(q, true)
                }, this)
            }).end().eq(1).bind({
                keydown: a.proxy(function (q) {
                    this._keydown(q, false)
                }, this)
            });
            this.enabled = true
        },
        disable: function () {
            this.wrapper.attr("disabled", "disabled").removeClass("t-state-default").addClass("t-state-disabled");
            this.wrapper.find(".t-tick").unbind(k).end().find(".t-slider-track").unbind(k);
            this.wrapper.find(".t-draghandle").unbind("keydown").bind("keydown", b.preventDefault);
            this.enabled = false
        },
        _keydown: function (p, q) {
            var s = this.selectionStart,
				r = this.selectionEnd;
            if (p.keyCode in this.keyMap) {
                if (q) {
                    s = this.keyMap[p.keyCode](s);
                    if (s > r) {
                        r = s
                    }
                } else {
                    r = this.keyMap[p.keyCode](r);
                    if (r < s) {
                        s = r
                    }
                }
                this._setValueInRange(s, r);
                p.preventDefault()
            }
        },
        _update: function (r, q) {
            var s = this.values();
            var p = s[0] != r || s[1] != q;
            this.values(r, q);
            if (p) {
                b.trigger(this.element, "change", {
                    values: [r, q]
                })
            }
        },
        values: function (q, p) {
            var r = [this.selectionStart, this.selectionEnd];
            q = n(q);
            if (isNaN(q)) {
                return r
            }
            p = n(p);
            if (isNaN(p)) {
                return r
            }
            if (q >= this.minValue && q <= this.maxValue && p >= this.minValue && p <= this.maxValue && q <= p) {
                if (this.selectionStart != q || this.selectionEnd != p) {
                    a(this.element).find("input").eq(0).attr("value", l(n(q))).end().eq(1).attr("value", l(n(p)));
                    this.selectionStart = q;
                    this.selectionEnd = p;
                    this.refresh()
                }
            }
        },
        refresh: function () {
            b.trigger(this.element, "t:moveSelection", {
                values: [this.selectionStart, this.selectionEnd]
            });
            if (this.selectionStart == this.maxValue && this.selectionEnd == this.maxValue) {
                this._setZIndex("firstHandle")
            }
        },
        _setValueInRange: function (q, p) {
            q = Math.max(q, this.minValue);
            q = Math.min(q, this.maxValue);
            p = Math.max(p, this.minValue);
            p = Math.min(p, this.maxValue);
            if (this.selectionStart == this.maxValue && this.selectionEnd == this.maxValue) {
                this._setZIndex("firstHandle")
            }
            this._update(q, p)
        },
        _correctValues: function (q, p) {
            if (q >= p) {
                this._setValueInRange(p, q)
            } else {
                this._setValueInRange(q, p)
            }
        },
        _setZIndex: function (s) {
            var p = this.wrapper.find(".t-draghandle"),
				q = p.eq(0),
				r = p.eq(1),
				t = "z-index";
            if (s == "firstHandle") {
                q.css(t, "1");
                r.css(t, "")
            } else {
                q.css(t, "");
                r.css(t, "1")
            }
        }
    };
    b.rangeSlider.Selection = function (s) {
        var t = s.owner;

        function r(C) {
            var B = C[0] - t.minValue,
				y = C[1] - t.minValue,
				A = Math.ceil(n(B / t.smallStep)),
				x = Math.ceil(n(y / t.smallStep)),
				z = t._pixelStepsArray[A],
				w = t._pixelStepsArray[x],
				u = t.wrapper.find(".t-draghandle"),
				v = parseInt(u.eq(0)[s.outerSize]() / 2, 10) + 1;
            u.eq(0).css(s.position, z - v).end().eq(1).css(s.position, w - v);
            q(z, w)
        }
        function q(y, w) {
            var u = 0,
				x = 0,
				v = t.trackDiv.find(".t-slider-selection");
            u = Math.abs(y - w);
            x = y < w ? y : w;
            v[s.size](u);
            v.css(s.position, x - 1)
        }
        r(t.values());
        var p = function (u) {
            r(u.values)
        };
        a(t.element).bind({
            change: p,
            slide: p,
            "t:moveSelection": p
        })
    };
    a.fn.tRangeSlider = function (p) {
        return b.create(this, {
            name: "tRangeSlider",
            init: function (q, r) {
                return new b.rangeSlider(q, r)
            },
            options: p
        })
    };
    a.fn.tRangeSlider.defaults = {
        enabled: true,
        minValue: 0,
        maxValue: 10,
        smallStep: 1,
        largeStep: 5,
        selectionStart: 0,
        selectionEnd: 10,
        orientation: "horizontal",
        tickPlacement: "both",
        tooltip: {
            enabled: true,
            format: "{0}"
        }
    }
})(jQuery);