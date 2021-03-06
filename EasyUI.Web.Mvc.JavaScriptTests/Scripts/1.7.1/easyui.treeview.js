(function (a, i) {
    var b = a.easyui,
		c = a.extend,
		f = ">.t-group,>.t-animation-container>.t-group",
		h = "t-treeview",
		g;
    b.scripts.push("easyui.treeview.js");

    function d(l) {
        l.find(".t-plus").each(function () {
            var m = a(this.parentNode);
            m.parent().data("loaded", m.next(".t-group").length > 0)
        })
    }
    function k(m) {
        var q = m.find(">div"),
			n = m.find(">ul"),
			p = q.find(">.t-icon"),
			l = q.find(">.t-in"),
			o;
        if (m.hasClass("t-treeview")) {
            return
        }
        if (!q.length) {
            q = a("<div />").prependTo(m)
        }
        if (!p.length && n.length) {
            p = a("<span class='t-icon' />").prependTo(q)
        } else {
            if (!n.length || !n.children().length) {
                p.remove();
                n.remove()
            }
        }
        if (!l.length) {
            l = a("<span class='t-in' />").appendTo(q)[0];
            currentNode = q[0].nextSibling;
            l = q.find(".t-in")[0];
            while (currentNode && currentNode.nodeName.toLowerCase() != "ul") {
                o = currentNode;
                currentNode = currentNode.nextSibling;
                l.appendChild(o)
            }
        }
    }
    var e = {
        wrapperCssClass: function (l, n) {
            var o = "t-item",
				m = n.itemIndex;
            if (l.isFirstLevel && m == 0) {
                o += " t-first"
            }
            if (m == l.itemsCount - 1) {
                o += " t-last"
            }
            return o
        },
        cssClass: function (l, o) {
            var p = "",
				n = o.itemIndex,
				m = l.itemsCount - 1;
            if (l.isFirstLevel && n == 0) {
                p += "t-top "
            }
            if (n == 0 && n != m) {
                p += "t-top"
            } else {
                if (n == m) {
                    p += "t-bot"
                } else {
                    p += "t-mid"
                }
            }
            return p
        },
        toggleButtonClass: function (l) {
            var m = "t-icon";
            if (l.isExpanded !== true) {
                m += " t-plus"
            } else {
                m += " t-minus"
            }
            if (l.enabled === false) {
                m += "-disabled"
            }
            return m
        }
    };

    function j(m, l, n) {
        var p = m.find(">div"),
			o = m.find(">ul");
        if (m.hasClass("t-treeview")) {
            return
        }
        if (!n) {
            n = {
                isExpanded: !(o.css("display") == "none"),
                itemIndex: m.index(),
                enabled: !p.find(">.t-in").hasClass("t-state-disabled")
            }
        }
        if (!l) {
            l = {
                isFirstLevel: m.parent().parent().hasClass(h),
                itemsCount: m.parent().children().length
            }
        }
        m.removeClass("t-first t-last").addClass(e.wrapperCssClass(l, n));
        p.removeClass("t-top t-mid t-bot").addClass(e.cssClass(l, n));
        if (o.length) {
            p.find(">.t-icon").removeClass("t-plus t-minus t-plus-disabled t-minus-disabled").addClass(e.toggleButtonClass(n));
            o.addClass("t-group")
        }
    }
    g = b.treeview = function (n, o) {
        this.element = n;
        var l = a(n);
        a.extend(this, o);
        var m = ".t-in:not(.t-state-selected,.t-state-disabled)";
        a(".t-in.t-state-selected", n).live("mouseenter", b.preventDefault);
        l.delegate(m, "mouseenter", b.hover).delegate(m, "mouseleave", b.leave).delegate(m, "click", b.delegate(this, this.nodeSelect)).delegate("div:not(.t-state-disabled) .t-in", "dblclick", b.delegate(this, this.nodeClick)).delegate(":checkbox", "click", a.proxy(this.checkboxClick, this)).delegate(".t-plus, .t-minus", "touchend click", b.delegate(this, this.nodeClick));
        if (this.isAjax()) {
            d(l)
        }
        if (this.dragAndDrop) {
            b.bind(this, {
                nodeDragStart: this.onNodeDragStart,
                nodeDragging: this.onNodeDragging,
                nodeDragCancelled: this.onNodeDragCancelled,
                nodeDrop: this.onNodeDrop,
                nodeDropped: this.onNodeDropped
            });
            (function (u) {
                var p = a("<div class='t-drop-clue' />");
                var q;

                function s(v) {
                    if (b.trigger(u.element, "nodeDragStart", {
                        item: v.$draggable.closest(".t-item")[0]
                    })) {
                        return false
                    }
                    p.appendTo(u.element)
                }
                function r(x) {
                    var G;
                    q = a(b.eventTarget(x));
                    if (u.dragAndDrop.dropTargets && q.closest(u.dragAndDrop.dropTargets).length > 0) {
                        G = "t-add"
                    } else {
                        if (!a.contains(u.element, q[0])) {
                            G = "t-denied"
                        } else {
                            if (a.contains(x.$draggable.closest(".t-item")[0], q[0])) {
                                G = "t-denied"
                            } else {
                                G = "t-insert-middle";
                                p.css("visibility", "visible");
                                var y = q.closest(".t-top,.t-mid,.t-bot");
                                if (y.length) {
                                    var D = y.outerHeight(),
										E = y.offset().top,
										C = q.closest(".t-in"),
										w = D / (C.length > 0 ? 4 : 2),
										F = b.touchLocation(x),
										B = F.y < (E + w),
										A = (E + D - w) < F.y,
										v = C.length > 0 && !B && !A;
                                    y.siblings(".t-top,.t-mid,.t-bot").children(".t-state-hover").removeClass("t-state-hover");
                                    C.toggleClass("t-state-hover", v);
                                    p.css("visibility", v ? "hidden" : "visible");
                                    if (v) {
                                        G = "t-add"
                                    } else {
                                        var z = y.position();
                                        z.top += B ? 0 : D;
                                        p.css(z)[B ? "prependTo" : "appendTo"](q.closest(".t-item").find("> div:first"));
                                        if (B && y.hasClass("t-top")) {
                                            G = "t-insert-top"
                                        }
                                        if (A && y.hasClass("t-bot")) {
                                            G = "t-insert-bottom"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    b.trigger(u.element, "nodeDragging", {
                        pageY: x.pageY,
                        pageX: x.pageX,
                        dropTarget: q[0],
                        status: G.substring(2),
                        setStatusClass: function (H) {
                            G = H
                        },
                        item: x.$draggable.closest(".t-item")[0]
                    });
                    if (G.indexOf("t-insert") != 0) {
                        p.css("visibility", "hidden")
                    }
                    b.dragCueStatus(x.$cue, G)
                }
                function t(x) {
                    if (x.keyCode == 27) {
                        b.trigger(u.element, "nodeDragCancelled", {
                            item: x.$draggable.closest(".t-item")[0]
                        })
                    } else {
                        var w = "over",
							v, D = b.eventTarget(x);
                        if (p.css("visibility") == "visible") {
                            w = p.prevAll(".t-in").length > 0 ? "after" : "before";
                            v = p.closest(".t-item").find("> div")
                        } else {
                            if (q) {
                                v = q.closest(".t-top,.t-mid,.t-bot")
                            }
                        }
                        var z = !x.$cue.find(".t-drag-status").hasClass("t-denied"),
							y = b.trigger(u.element, "nodeDrop", {
							    isValid: z,
							    dropTarget: D,
							    destinationItem: v.parent()[0],
							    dropPosition: w,
							    item: x.$draggable.closest(".t-item")[0]
							});
                        if (!z) {
                            return false
                        }
                        if (y || !a.contains(u.element, D)) {
                            return !y
                        }
                        var C = x.$draggable.closest(".t-top,.t-mid,.t-bot");
                        var A = C.parent();
                        var B = C.closest(".t-group");
                        if (a.contains(A[0], D)) {
                            return false
                        }
                        if (A.hasClass("t-last")) {
                            A.removeClass("t-last").prev().addClass("t-last").find("> div").removeClass("t-top t-mid").addClass("t-bot")
                        }
                        if (p.css("visibility") == "visible") {
                            v.parent()[w](A)
                        } else {
                            var E = v.next(".t-group");
                            if (E.length === 0) {
                                E = a('<ul class="t-group" />').appendTo(v.parent());
                                if (!u.isAjax() || !v.find(">div >.t-icon").length) {
                                    v.prepend('<span class="t-icon t-minus" />')
                                }
                                if (u.isAjax()) {
                                    E.hide();
                                    u.nodeToggle(null, v.parent(), true);
                                    E.show()
                                }
                            }
                            E.append(A);
                            if (v.find("> .t-icon").hasClass("t-plus")) {
                                u.nodeToggle(null, v.parent(), true)
                            }
                        }
                        j(A);
                        j(A.prev());
                        j(A.next());
                        if (B.children().length === 0) {
                            B.prev("div").find(".t-plus,.t-minus").remove();
                            B.remove()
                        }
                        if (b.isTouch) {
                            v.children(".t-in").removeClass("t-state-hover")
                        }
                        b.trigger(u.element, "nodeDropped", {
                            destinationItem: v.closest(".t-item")[0],
                            dropPosition: w,
                            item: C.parent(".t-item")[0]
                        });
                        return false
                    }
                }
                new b.draggable({
                    owner: u.element,
                    selector: "div:not(.t-state-disabled) .t-in",
                    scope: u.element.id,
                    cue: function (v) {
                        return b.dragCue(b.encode(v.$draggable.text()))
                    },
                    start: s,
                    drag: r,
                    stop: t,
                    destroy: function (v) {
                        p.remove();
                        v.$cue.remove()
                    }
                })
            })(this)
        }
        b.bind(this, {
            expand: this.onExpand,
            collapse: this.onCollapse,
            select: a.proxy(function (p) {
                if (p.target == this.element && this.onSelect) {
                    a.proxy(this.onSelect, this.element)(p)
                }
            }, this),
            checked: this.onChecked,
            error: this.onError,
            load: this.onLoad,
            dataBinding: this.onDataBinding,
            dataBound: this.onDataBound
        })
    };
    g.prototype = {
        expand: function (l) {
            a(l, this.element).each(a.proxy(function (o, p) {
                var m = a(p);
                var n = m.find("> .t-group, > .t-content");
                if ((n.length > 0 && !n.is(":visible")) || (this.isAjax() && m.data("loaded") === false)) {
                    this.nodeToggle(null, m)
                }
            }, this))
        },
        collapse: function (l) {
            a(l, this.element).each(a.proxy(function (o, p) {
                var m = a(p),
					n = m.find("> .t-group, > .t-content");
                if (n.length > 0 && n.is(":visible")) {
                    this.nodeToggle(null, m)
                }
            }, this))
        },
        enable: function (l) {
            this.toggle(l, true)
        },
        disable: function (l) {
            this.toggle(l, false)
        },
        toggle: function (m, l) {
            a(m, this.element).each(a.proxy(function (p, r) {
                var n = a(r),
					q = !n.find("> .t-group, > .t-content").is(":visible");
                if (!l) {
                    this.collapse(n);
                    q = true
                }
                n.find("> div > .t-in").toggleClass("t-state-default", l).toggleClass("t-state-disabled", !l).end().find("> div > .t-icon").toggleClass("t-plus", q && l).toggleClass("t-plus-disabled", q && !l).toggleClass("t-minus", !q && l).toggleClass("t-minus-disabled", !q && !l);
                var o = n.find("> div > .t-checkbox > :checkbox");
                if (l) {
                    o.removeAttr("disabled")
                } else {
                    o.attr("disabled", "disabled")
                }
            }, this))
        },
        reload: function (l) {
            var m = this;
            a(l).each(function () {
                var n = a(this);
                n.find(".t-group").remove();
                m.ajaxRequest(n)
            })
        },
        shouldNavigate: function (m) {
            var l = a(m).closest(".t-item").find("> .t-content, > .t-group");
            var n = a(m).attr("href");
            return !((n && (n.charAt(n.length - 1) == "#" || n.indexOf("#" + this.element.id + "-") != -1)) || (l.length > 0 && l.children().length == 0))
        },
        nodeSelect: function (m, n) {
            if (!this.shouldNavigate(n)) {
                m.preventDefault()
            }
            var l = a(n);
            if (!l.hasClass(".t-state-selected") && !b.trigger(this.element, "select", {
                item: l.closest(".t-item")[0]
            })) {
                a(".t-in", this.element).removeClass("t-state-hover t-state-selected");
                l.addClass("t-state-selected")
            }
        },
        nodeToggle: function (n, l, p) {
            if (l.find(".t-minus").length == 0 && l.find(".t-plus").length == 0) {
                return
            }
            if (n != null) {
                n.preventDefault()
            }
            if (l.data("animating") || l.find("> div > .t-in").hasClass("t-state-disabled")) {
                return
            }
            l.data("animating", !p);
            var m = l.find(">.t-group, >.t-content, >.t-animation-container>.t-group, >.t-animation-container>.t-content"),
				o = !m.is(":visible");
            if (m.children().length > 0 && l.data("loaded") !== false) {
                if (!b.trigger(this.element, o ? "expand" : "collapse", {
                    item: l[0]
                })) {
                    l.find("> div > .t-icon").toggleClass("t-minus", o).toggleClass("t-plus", !o);
                    if (!p) {
                        b.fx[o ? "play" : "rewind"](this.effects, m, {
                            direction: "bottom"
                        }, function () {
                            l.data("animating", false)
                        })
                    } else {
                        m[o ? "show" : "hide"]()
                    }
                } else {
                    l.data("animating", false)
                }
            } else {
                if (o && this.isAjax() && (m.length == 0 || l.data("loaded") === false)) {
                    if (!b.trigger(this.element, o ? "expand" : "collapse", {
                        item: l[0]
                    })) {
                        this.ajaxRequest(l)
                    } else {
                        l.data("animating", false)
                    }
                }
            }
        },
        nodeClick: function (n, o) {
            var l = a(o),
				m = l.closest(".t-item");
            if (l.hasClass("t-plus-disabled") || l.hasClass("t-minus-disabled")) {
                return
            }
            this.nodeToggle(n, m)
        },
        isAjax: function () {
            return this.ajax || this.ws || this.onDataBinding
        },
        url: function (l) {
            return (this.ajax || this.ws)[l]
        },
        ajaxOptions: function (l, o) {
            var p = {
                type: "POST",
                dataType: "text",
                error: a.proxy(function (r, q) {
                    if (b.ajaxError(this.element, "error", r, q)) {
                        return
                    }
                    if (q == "parsererror") {
                        alert("Error! The requested URL did not return JSON.")
                    }
                }, this),
                success: a.proxy(function (q) {
                    q = eval("(" + q + ")");
                    q = q.d || q;
                    this.dataBind(l, q)
                }, this),
                complete: function () {
                    l.data("animating", false)
                }
            };
            p = a.extend(p, o);
            var n = this.ws ? p.data.node = {} : p.data;
            if (l.hasClass("t-item")) {
                n[this.queryString.value] = this.getItemValue(l);
                n[this.queryString.text] = this.getItemText(l);
                var m = l.find(".t-checkbox:first :checkbox");
                if (m.length) {
                    n[this.queryString.checked] = m.is(":checked")
                }
            }
            if (this.ws) {
                p.data = b.toJson(p.data);
                p.contentType = "application/json; charset=utf-8"
            }
            return p
        },
        ajaxRequest: function (l) {
            l = l || a(this.element);
            var m = {
                item: l[0]
            };
            if (b.trigger(this.element, "dataBinding", m) || (!this.ajax && !this.ws)) {
                return
            }
            l.data("loadingIconTimeout", setTimeout(function () {
                l.find("> div > .t-icon").addClass("t-loading")
            }, 100));
            a.ajax(this.ajaxOptions(l, {
                data: a.extend({}, m.data),
                url: this.url("selectUrl")
            }))
        },
        bindTo: function (l) {
            this.dataBind(this.element, l)
        },
        dataBind: function (l, m) {
            var n = this.element,
				o, s, r;
            if (arguments.length == 1) {
                m = l;
                l = this.element
            }
            l = a(l);
            if (!l.is(this.element)) {
                l = l.closest(".t-item")
            }
            o = l.find("> .t-group");
            s = l.find("> div > .t-icon");
            r = m.length > 0;
            if (m.length == 0) {
                s.remove();
                o.remove();
                b.trigger(n, "dataBound", {
                    item: l[0]
                });
                return
            } else {
                if (s.length == 0) {
                    l.find("> div").prepend('<span class="t-icon t-plus" />')
                }
            }
            var p = new b.stringBuilder(),
				u = o.length == 0,
				q = l.find('> div > .t-checkbox :input[name="' + n.id + '_checkedNodes.Index"]').val();
            if (!q && l[0] != n) {
                var v = l.parentsUntil(".t-treeview", ".t-item").andSelf().map(function (y, w) {
                    return a(w).index()
                });
                q = Array.prototype.join.call(v, ":")
            }
            var t = (u ? l.eq(0).is(".t-treeview") ? true : m[0].Expanded : false);
            g.getGroupHtml({
                data: m,
                html: p,
                isAjax: this.isAjax(),
                isFirstLevel: l.hasClass("t-treeview"),
                showLines: this.showLines,
                showCheckBoxes: this.showCheckBox,
                groupLevel: q,
                isExpanded: t,
                renderGroup: u,
                elementId: n.id
            });
            if (o.length > 0 && l.data("loaded") === false) {
                a(p.string()).prependTo(o)
            } else {
                if (o.length > 0 && l.data("loaded") !== false) {
                    o.html(p.string())
                } else {
                    if (o.length == 0) {
                        o = a(p.string()).appendTo(l)
                    }
                }
            }
            l.data("animating", false);
            b.fx.play(this.effects, o, {
                direction: "bottom"
            });
            clearTimeout(l.data("loadingIconTimeout"));
            if (l.hasClass("t-item")) {
                l.data("loaded", true).find(".t-icon:first").removeClass("t-loading").removeClass("t-plus").addClass("t-minus")
            }
            if (this.isAjax()) {
                d(l)
            }
            b.trigger(n, "dataBound", {
                item: l[0]
            })
        },
        checkboxClick: function (l) {
            var m = a(l.target),
				n = m.is(":checked");
            var o = b.trigger(this.element, "checked", {
                item: m.closest(".t-item")[0],
                checked: n
            });
            if (!o) {
                this.nodeCheck(m, n)
            } else {
                l.preventDefault()
            }
        },
        nodeCheck: function (m, l) {
            a(m, this.element).each(a.proxy(function (r, t) {
                var o = a(t).closest(".t-item"),
					n = a("> div > .t-checkbox", o),
					p = this.element.id + "_checkedNodes",
					s = n.find(':input[name="' + p + '.Index"]').val(),
					q = n.find(":checkbox");
                n.find("[type=hidden]").filter(function () {
                    return (a(this).attr("name").indexOf(p + "[" + s + "].") > -1)
                }).remove();
                q.attr("value", l ? "True" : "False");
                if (l) {
                    q.attr("checked", "checked");
                    a(g.getNodeInputsHtml(this.getItemValue(o), this.getItemText(o), p, s)).appendTo(n)
                } else {
                    q.attr("checked", false)
                }
            }, this))
        },
        getItemText: function (l) {
            return a(l).find("> div > .t-in").text()
        },
        getItemValue: function (l) {
            return a(l).find('>div>:input[name="itemValue"]').val() || this.getItemText(l)
        },
        findByText: function (l) {
            return a(this.element).find(".t-in").filter(function (n, m) {
                return a(m).text() == l
            }).closest(".t-item")
        },
        findByValue: function (l) {
            return a(this.element).find("input[name='itemValue']").filter(function (n, m) {
                return a(m).val() == l
            }).closest(".t-item")
        },
        _insertNode: function (v, r, w, m, s) {
            var x = this,
				y = m.children().length + 1,
				t = a.isArray(v),
				l = t || a.isPlainObject(v),
				n = {
				    showCheckBoxes: x.showCheckBox,
				    isFirstLevel: w.hasClass(h),
				    isExpanded: true,
				    itemsCount: y
				},
				u, q, p = new b.stringBuilder();
            if (l) {
                if (t) {
                    for (q = 0; q < v.length; q++) {
                        g.getItemHtml(c({
                            html: p,
                            itemIndex: r + q,
                            item: v[q]
                        }, n))
                    }
                } else {
                    g.getItemHtml(c({
                        html: p,
                        itemIndex: r,
                        item: v
                    }, n))
                }
                u = a(p.string())
            } else {
                u = a(v);
                if (m.children()[r - 1] == u[0]) {
                    return u
                }
                if (u.closest(".t-treeview")[0] == x.element) {
                    x.remove(u)
                }
            }
            if (!m.length) {
                var o = new b.stringBuilder();
                g.getGroupHtml(c({
                    html: o,
                    renderGroup: true
                }, n));
                m = a(o.string()).appendTo(w)
            }
            s(u, m);
            if (w.hasClass("t-item")) {
                k(w);
                j(w)
            }
            if (!l) {
                j(u)
            }
            j(u.prev());
            j(u.next());
            return u
        },
        insertAfter: function (m, n) {
            var l = n.parent();
            return this._insertNode(m, n.index() + 1, l.parent(), l, function (p, o) {
                p.insertAfter(n)
            })
        },
        insertBefore: function (m, n) {
            var l = n.parent();
            return this._insertNode(m, n.index(), l.parent(), l, function (p, o) {
                p.insertBefore(n)
            })
        },
        append: function (m, n) {
            n = a(n || this.element);
            var l = n.find(f);
            return this._insertNode(m, l.children().length, n, l, function (p, o) {
                p.appendTo(o)
            })
        },
        remove: function (m) {
            m = a(m);
            var p = this,
				n = m.parent().parent(),
				o = m.prev(),
				l = m.next();
            m.remove();
            if (n.hasClass("t-item")) {
                k(n);
                j(n)
            }
            j(o);
            j(l)
        }
    };
    a.extend(g, {
        getNodeInputsHtml: function (n, m, l, o) {
            return new b.stringBuilder().cat('<input type="hidden" value="').cat(b.encode(n)).cat('" name="' + l + "[").cat(o).cat('].Value" class="t-input">').cat('<input type="hidden" value="').cat(b.encode(m)).cat('" name="' + l + "[").cat(o).cat('].Text" class="t-input">').string()
        },
        getItemHtml: function (v) {
            var r = v.item,
				o = v.html,
				q = v.isFirstLevel,
				n = v.groupLevel,
				s = v.itemIndex,
				t = v.itemsCount,
				l = new b.stringBuilder().cat(n).catIf(":", n).cat(s).string(),
				w = function (x) {
				    var y;
				    if (typeof x != "undefined") {
				        for (y in x) {
				            o.cat(" ").cat(y).cat('="').cat(x[y]).cat('"')
				        }
				    }
				},
				p = r.HtmlAttributes || r.htmlAttributes || {};
            o.cat('<li class="t-item').catIf(" t-first", q && s == 0).catIf(" t-last", s == t - 1).cat('">').cat('<div class="').catIf("t-top ", q && s == 0).catIf("t-top", s != t - 1 && s == 0).catIf("t-mid", s != t - 1 && s != 0).catIf("t-bot", s == t - 1).catIf(" " + p["class"], p["class"]).cat('"');
            delete p["class"];
            w(p);
            o.cat(">");
            if ((v.isAjax && r.LoadOnDemand) || (r.Items && r.Items.length > 0)) {
                o.cat('<span class="t-icon').catIf(" t-plus", r.Expanded !== true).catIf(" t-minus", r.Expanded === true).catIf("-disabled", r.Enabled === false).cat('"></span>')
            }
            if (v.showCheckBoxes && r.Checkable !== false) {
                var m = v.elementId + "_checkedNodes";
                o.cat('<span class="t-checkbox">').cat('<input type="hidden" value="').cat(l).cat('" name="').cat(m).cat(".Index").cat('" class="t-input"/>').cat('<input type="checkbox" value="').cat(r.Checked === true ? "True" : "False").cat('" class="t-input').cat('" name="').cat(m).cat("[").cat(l).cat('].Checked"').catIf(' disabled="disabled"', r.Enabled === false).catIf(' checked="checked"', r.Checked).cat("/>");
                if (r.Checked) {
                    o.cat(g.getNodeInputsHtml(r.Value, r.Text, m, l))
                }
                o.cat("</span>")
            }
            var u = r.NavigateUrl || r.Url;
            o.cat(u ? '<a href="' + u + '" class="t-link ' : '<span class="').cat("t-in").catIf(" t-state-disabled", r.Enabled === false).catIf(" t-state-selected", r.Selected === true).cat('">');
            if (r.ImageUrl != null) {
                o.cat("<img");
                w(a.extend({
                    alt: "",
                    "class": "t-image",
                    src: r.ImageUrl
                }, r.ImageHtmlAttributes || r.imageHtmlAttributes || {}));
                o.cat(" />")
            }
            if (r.SpriteCssClasses != null) {
                o.cat('<span class="t-sprite ').cat(r.SpriteCssClasses).cat('"></span>')
            }
            o.catIf(r.Text, r.Encoded === false).catIf(r.Text.replace(/</g, "&lt;").replace(/>/g, "&gt;"), r.Encoded !== false).cat(u ? "</a>" : "</span>");
            if (r.Value) {
                o.cat('<input type="hidden" class="t-input" name="itemValue" value="').cat(r.Value).cat('" />')
            }
            o.cat("</div>");
            if (r.Items && r.Items.length > 0) {
                g.getGroupHtml({
                    data: r.Items,
                    html: o,
                    isAjax: v.isAjax,
                    isFirstLevel: false,
                    showCheckBoxes: v.showCheckBoxes,
                    groupLevel: l,
                    isExpanded: r.Expanded,
                    elementId: v.elementId
                })
            }
            o.cat("</li>")
        },
        getGroupHtml: function (r) {
            var l = r.data,
				n = r.html,
				t = r.showLines,
				p = r.isFirstLevel,
				s = r.renderGroup;
            if (s !== false) {
                n.cat('<ul class="t-group').catIf(" t-treeview-lines", p && (typeof t == typeof i || t)).cat('"').catIf(' style="display:none"', r.isExpanded !== true).cat(">")
            }
            if (l && l.length > 0) {
                var m = g.getItemHtml;
                for (var o = 0, q = l.length; o < q; o++) {
                    m({
                        item: l[o],
                        html: n,
                        isAjax: r.isAjax,
                        isFirstLevel: p,
                        showCheckBoxes: r.showCheckBoxes,
                        groupLevel: r.groupLevel,
                        itemIndex: o,
                        itemsCount: q,
                        elementId: r.elementId
                    })
                }
            }
            if (s !== false) {
                n.cat("</ul>")
            }
        }
    });
    a.fn.tTreeView = function (l) {
        return b.create(this, {
            name: "tTreeView",
            init: function (m, n) {
                return new g(m, n)
            },
            options: l,
            success: function (m) {
                if (m.isAjax() && a(m.element).find(".t-item").length == 0) {
                    m.ajaxRequest()
                }
            }
        })
    };
    a.fn.tTreeView.defaults = {
        effects: b.fx.property.defaults("height"),
        queryString: {
            text: "Text",
            value: "Value",
            checked: "Checked"
        }
    }
})(jQuery);