(function (a) {
    var b = a.easyui,
		m = function () { },
		e = {},
		g = {},
		c = {},
		i = {
		    owner: [null]
		},
		l = b.isTouch ? "touchend" : "mouseup",
		j = b.isTouch ? "touchstart" : "mousedown",
		k = b.isTouch ? "touchmove" : "mousemove",
		f = {
		    scope: "default",
		    drop: m,
		    over: m,
		    out: m,
		    owner: document.body
		},
		d = {
		    distance: 5,
		    cursorAt: {
		        left: 10,
		        top: b.isTouch ? -40 / b.zoomLevel() : 10
		    },
		    scope: "default",
		    start: m,
		    drag: m,
		    stop: m,
		    destroy: m,
		    owner: document.body,
		    cue: function () {
		        return a("<span />")
		    }
		};
    b.scripts.push("easyui.draganddrop.js");

    function n(p) {
        var q = 0,
			o;
        for (o in p) {
            p.hasOwnProperty(o) && q++
        }
        return q
    }
    function h(o, q) {
        var p = {
            owner: [null]
        };
        a.each(q, function () {
            var s = this,
				r = s.owner;
            if (r && a.contains(r, o)) {
                p = a.extend(p, s);
                p.selector && (p.owner = a(o).closest(p.selector)[0]);
                return false
            }
        });
        return p
    }
    b.droppable = function (o) {
        a.extend(this, f, o);
        a(this.owner).delegate(this.selector, "mouseenter", a.proxy(this._over, this)).delegate(this.selector, l, a.proxy(this._drop, this)).delegate(this.selector, "mouseleave", a.proxy(this._out, this));
        if (!(this.scope in g)) {
            g[this.scope] = [this]
        } else {
            g[this.scope].push(this)
        }
    };
    b.droppable.prototype = {
        _over: function (o) {
            this._raise(o, this.over)
        },
        _out: function (o) {
            this._raise(o, this.out)
        },
        _drop: function (o) {
            this._raise(o, a.proxy(function (p) {
                this.drop(p);
                p.destroy(p)
            }, this))
        },
        _raise: function (q, o) {
            var p = e[this.scope],
				r = a(b.eventCurrentTarget(q)).closest(this.selector);
            if (p) {
                o(a.extend(q, p, {
                    $droppable: r
                }))
            }
        }
    };
    b.dragCue = function (o) {
        return a('<div class="t-header t-drag-clue" />').html(o).prepend('<span class="t-icon t-drag-status t-denied" />').appendTo(document.body)
    };
    b.dragCueStatus = function (o, p) {
        o.find(".t-drag-status").attr("class", "t-icon t-drag-status").addClass(p)
    };
    b.draggable = function (o) {
        a.extend(this, d, o);
        a(this.owner).delegate(this.selector, j, a.proxy(this._wait, this)).delegate(this.selector, "dragstart", b.preventDefault);
        this._startProxy = a.proxy(this._start, this);
        this._destroyProxy = a.proxy(this._destroy, this);
        this._stopProxy = a.proxy(this._stop, this);
        this._dragProxy = a.proxy(this._drag, this)
    };
    b.draggable.get = function (o) {
        return e[o]
    };
    b.draggable.prototype = {
        _raise: function (q, o) {
            var p = e[this.scope];
            if (p) {
                return o(a.extend(q, p))
            }
        },
        _startDrag: function (q, p) {
            q = a(q);
            this.$target = q;
            if (p) {
                this._startPosition = p
            } else {
                var o = q.offset();
                this._startPosition = {
                    x: o.left,
                    y: o.top
                }
            }
            a(document).bind(k + "." + this.scope, this._startProxy).bind(l + "." + this.scope, this._destroyProxy)
        },
        _wait: function (o) {
            if (b.isTouch) {
                o.stopImmediatePropagation()
            }
            this._startDrag(o.currentTarget, b.touchLocation(o));
            a(document.documentElement).trigger(j, o);
            if (!b.isTouch) {
                return false
            }
        },
        _start: function (q) {
            var r = b.touchLocation(q),
				s = this._startPosition.x - r.x,
				t = this._startPosition.y - r.y;
            var p = Math.sqrt((s * s) + (t * t));
            if (p >= this.distance) {
                if (b.isTouch) {
                    q.stopImmediatePropagation();
                    q.preventDefault()
                }
                var o = c[this.selector];
                if (!o) {
                    o = c[this.selector] = this.cue({
                        $draggable: this.$target
                    })
                }
                a(document).unbind("." + this.scope).bind(k + "." + this.scope, this._dragProxy).bind(l + "." + this.scope, this._stopProxy).bind("keydown." + this.scope, this._stopProxy).bind("selectstart." + this.scope, false);
                e[this.scope] = {
                    $cue: o.css({
                        position: "absolute",
                        left: r.x + this.cursorAt.left,
                        top: r.y + this.cursorAt.top
                    }),
                    $draggable: this.$target,
                    destroy: this._destroyProxy
                };
                if (this._raise(q, this.start) === false) {
                    this._destroy(q)
                }
            }
        },
        _drag: function (r) {
            if (b.isTouch) {
                r.stopImmediatePropagation()
            }
            var u = b.touchLocation(r);
            if (b.isTouch && n(g)) {
                var q = b.eventTarget(r);
                if (q) {
                    var p = g[this.scope],
						v = h(q, p),
						s = v.owner,
						t = i.owner,
						o = t != s;
                    if (o) {
                        if (t != null && "_out" in i) {
                            i._out(r)
                        }
                        if (s && a.contains(s, q) && "_over" in v) {
                            v._over(r)
                        }
                        i = v
                    }
                }
            }
            this._raise(r, this.drag);
            e[this.scope].$cue.css({
                left: u.x + this.cursorAt.left,
                top: u.y + this.cursorAt.top
            })
        },
        _stop: function (r) {
            if (b.isTouch) {
                r.stopImmediatePropagation()
            }
            if (r.type == l || r.keyCode == 27) {
                a(document).unbind("." + this.scope)
            }
            if (b.isTouch && n(g)) {
                var q = b.eventTarget(r);
                if (q) {
                    var p = g[this.scope],
						s = h(q, p);
                    if (s.owner && "_drop" in s) {
                        i = {
                            owner: [null]
                        };
                        s._drop(r)
                    }
                }
            }
            if (this._raise(r, this.stop) === false) {
                this._destroy(r)
            } else {
                var o = e[this.scope];
                if (o) {
                    o.$cue.animate(o.$draggable.offset(), "fast", this._destroyProxy)
                }
            }
        },
        _destroy: function (o) {
            a(document).unbind("." + this.scope);
            this._raise(o, this.destroy);
            e[this.scope] = null;
            c[this.selector] = null
        }
    }
})(jQuery);