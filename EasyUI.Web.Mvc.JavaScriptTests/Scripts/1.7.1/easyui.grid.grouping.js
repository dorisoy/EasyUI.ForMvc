(function (a) {
    var b = a.easyui;
    var d = 3;
    var c = 0;
    b.scripts.push("easyui.grid.grouping.js");
    b.grouping = {};

    function e(f, g) {
        return f.find("div").filter(function () {
            var h = a(this);
            if (h.children(".t-link").contents().filter(function () {
				if (a(this).text() === g) {
					return a(this)
            }
            }).length) {
                return a(this)
            }
        })
    }
    b.grouping.initialize = function (j) {
        a.extend(j, b.grouping.implementation);
        j.$groupDropCue = a('<div class="t-grouping-dropclue"/>');
        j.$groupHeader = a("> .t-grouping-header", j.element);

        function k() {
            var m = a.map(j.$groupHeader.find(".t-group-indicator"), function (o) {
                var n = a(o);
                var p = n.offset().left;
                var q = n.outerWidth();
                return {
                    left: p,
                    right: p + q,
                    width: q,
                    $group: n
                }
            });
            return {
                first: m[0],
                all: m,
                last: m[m.length - 1]
            }
        }
        function h(p) {
            var z = p.$cue.text(),
				y = b.eventTarget(p),
				v = b.touchLocation(p);
            if (!a.contains(j.element, y) || !a(y).closest(".t-grouping-header").length || (j.groupFromTitle(z) && p.$draggable.closest(".t-header").length)) {
                j.$groupDropCue.remove();
                return
            }
            var m = a(j.element),
				n = m.find("> .t-grid-toolbar"),
				A = n.outerHeight() + d,
				x = k(),
				r = m.closest(".t-rtl").length;
            if (!x.all.length) {
                var t = r ? n.width() - c : c;
                j.$groupDropCue.css({
                    top: A,
                    left: t
                }).appendTo(j.$groupHeader);
                return
            }
            var q = x.first;
            var s = x.last;
            var u = parseInt(q.$group.css("marginLeft"));
            var w = parseInt(q.$group.css("marginRight"));
            var o = a.grep(x.all, function (B) {
                return v.x >= B.left - u - w && v.x <= B.right
            })[0];
            if (!o && q) {
                if (!r && v.x < q.left) {
                    o = q
                } else {
                    if (r && v.x < s.left) {
                        o = s
                    }
                }
            }
            if (r) {
                if (o) {
                    j.$groupDropCue.css({
                        top: A,
                        left: o.$group.position().left - u + c
                    }).insertAfter(o.$group)
                } else {
                    j.$groupDropCue.css({
                        top: A,
                        left: n.width() - c
                    }).prependTo(j.$groupHeader)
                }
            } else {
                if (o) {
                    j.$groupDropCue.css({
                        top: A,
                        left: o.$group.position().left - u + c
                    }).insertBefore(o.$group)
                } else {
                    j.$groupDropCue.css({
                        top: A,
                        left: s.$group.position().left + s.$group.outerWidth() + w + c
                    }).appendTo(j.$groupHeader)
                }
            }
        }
        function f(o) {
            if (o.$draggable.hasClass("t-header")) {
                var m = j.columnFromTitle(o.$draggable.text());
                return b.dragCue(m ? m.title : "")
            } else {
                var p = a(".t-link", o.$draggable);
                var n = p.text().substr(a(".t-icon", p).text().length);
                var m = j.columnFromTitle(n);
                return b.dragCue(m ? m.title : n)
            }
        }
        function l(m) {
            var n = m.$cue.text();
            j.$groupDropCue.remove();
            if (m.$draggable.is(".t-group-indicator") && m.keyCode != 27) {
                j.unGroup(n);
                return false
            }
        }
        function g(m) {
            m.$cue.remove()
        }
        if (j.$groupHeader.length) {
            new b.draggable({
                owner: j.$header,
                selector: ".t-header:not(.t-group-cell,.t-hierarchy-cell)",
                scope: j.element.id + "-grouping",
                cue: f,
                start: function (n) {
                    var m = j.columnFromTitle(n.$draggable.text());
                    return !!m.member && m.groupable !== false
                },
                stop: l,
                drag: h,
                destroy: g
            });
            new b.draggable({
                owner: j.$groupHeader,
                selector: ".t-group-indicator",
                scope: j.element.id + "-grouping",
                cue: f,
                stop: l,
                drag: h,
                destroy: g
            });
            new b.droppable({
                owner: j.element,
                selector: ".t-grouping-header",
                scope: j.element.id + "-grouping",
                over: function (m) {
                    b.dragCueStatus(m.$cue, "t-add")
                },
                out: function (m) {
                    b.dragCueStatus(m.$cue, "t-denied")
                },
                drop: function (n) {
                    var r = n.$cue.text();
                    var o = j.groupFromTitle(r);
                    var p = a.inArray(o, j.groups);
                    var q = j.$groupHeader.find("div").index(j.$groupDropCue);
                    var m = p - q;
                    if (!o || (j.$groupDropCue.is(":visible") && m != 0 && m != -1)) {
                        j.group(r, q)
                    }
                    j.$groupDropCue.remove()
                }
            })
        }
        if (j.isAjax()) {
            j.$groupHeader.delegate(".t-button", b.isTouch ? "touchend" : "click", function (n) {
                n.preventDefault();
                var o = a(this).parent().find(".t-link");
                var m = o.text().substr(a(".t-icon", o).text().length);
                j.unGroup(m)
            }).delegate(".t-link", b.isTouch ? "touchend" : "click", function (n) {
                n.preventDefault();
                var p = a(this);
                var m = p.text().substr(a(".t-icon", p).text().length);
                var o = j.groupFromTitle(m);
                o.order = o.order == "asc" ? "desc" : "asc";
                j.group(o.title)
            })
        }
        j.$groupHeader.delegate(".t-group-indicator", "mouseenter", function () {
            j.$currentGroupItem = a(this)
        }).delegate(".t-group-indicator", "mouseleave", function () {
            j.$currentGroupItem = null
        });
        j.$tbody.delegate(".t-grouping-row .t-collapse, .t-grouping-row .t-expand", "click", b.stop(function (o) {
            o.preventDefault();
            var m = a(this),
				n = m.closest("tr");
            if (m.hasClass("t-collapse")) {
                j.collapseGroup(n)
            } else {
                j.expandGroup(n)
            }
        }));
        j.groupFromTitle = function (m) {
            return a.grep(j.groups, function (n) {
                return n.title == m
            })[0]
        };
        j.expandGroup = function (o) {
            var m = a(o);
            var n = m.find(".t-group-cell").length;
            m.nextAll("tr").each(function (q, s) {
                var p = a(s);
                var r = p.find(".t-group-cell").length;
                if (r <= n) {
                    return false
                }
                if (r == n + 1 && !p.hasClass("t-detail-row")) {
                    p.show();
                    if (p.hasClass("t-grouping-row") && p.find(".t-icon").hasClass("t-collapse")) {
                        j.expandGroup(p)
                    }
                    if (p.hasClass("t-master-row") && p.find(".t-icon").hasClass("t-minus")) {
                        p.next().show()
                    }
                }
            });
            m.find(".t-icon").addClass("t-collapse").removeClass("t-expand")
        };
        j.collapseGroup = function (p) {
            var m = a(p),
				n = m.find(".t-group-cell").length,
				o = 1;
            m.nextAll("tr").each(function () {
                var q = a(this),
					r = q.find(".t-group-cell").length;
                if (q.hasClass("t-grouping-row")) {
                    o++
                } else {
                    if (q.hasClass("t-group-footer")) {
                        o--
                    }
                }
                if (r <= n || (q.hasClass("t-group-footer") && o < 0)) {
                    return false
                }
                q.hide()
            });
            m.find(".t-icon").addClass("t-expand").removeClass("t-collapse")
        };
        j.group = function (r, q) {
            if (this.groups.length == 0 && this.isAjax()) {
                j.$groupHeader.empty()
            }
            var o = a.grep(j.groups, function (s) {
                return s.title == r
            })[0];
            if (!o) {
                var n = j.columnFromTitle(r);
                o = {
                    order: "asc",
                    member: n.member,
                    title: r
                };
                j.groups.push(o)
            }
            if (q >= 0) {
                j.groups.splice(a.inArray(o, j.groups), 1);
                j.groups.splice(q, 0, o)
            }
            j.groupBy = a.map(j.groups, function (s) {
                return s.member + "-" + s.order
            }).join("~");
            if (this.isAjax()) {
                var m = e(this.$groupHeader, r);
                if (m.length == 0) {
                    var p = new a.easyui.stringBuilder().cat('<div class="t-group-indicator">').cat('<a href="#" class="t-link"><span class="t-icon" />').cat(r).cat("</a>").cat('<a class="t-button t-button-icon t-button-bare"><span class="t-icon t-group-delete">').cat(j.localization.ungroup).cat("</span></a>").cat("</div>").string();
                    m = a(p).appendTo(this.$groupHeader)
                }
                if (this.$groupDropCue.is(":visible")) {
                    m.insertBefore(this.$groupDropCue)
                }
                m.find(".t-link .t-icon").toggleClass("t-arrow-up-small", o.order == "asc").toggleClass("t-arrow-down-small", o.order == "desc").html("(" + (o.order == "asc" ? j.localization.sortedAsc : j.localization.sortedDesc) + ")");
                this.ajaxRequest()
            } else {
                this.serverRequest()
            }
        };
        j.unGroup = function (n) {
            var m = j.groupFromTitle(n);
            j.groups.splice(a.inArray(m, j.groups), 1);
            if (j.groups.length == 0) {
                j.$groupHeader.html(j.localization.groupHint)
            }
            j.groupBy = a.map(j.groups, function (o) {
                return o.member + "-" + o.order
            }).join("~");
            if (j.isAjax()) {
                e(j.$groupHeader, n).remove();
                j.ajaxRequest()
            } else {
                j.serverRequest()
            }
        };
        j.clearHeader = function () {
            j.$groupHeader.html(j.localization.groupHint)
        };
        j.normalizeColumns = function (n) {
            var q = j.groups.length;
            var p = n - j.$tbody.parent().find(" > colgroup > col").length;
            if (p == 0) {
                return
            }
            var m = j.$tbody.parent().add(j.$headerWrap.find("table")).add(j.$footer.find("table"));
            if (a.browser.msie) {
                if (p > 0) {
                    a(new b.stringBuilder().rep('<col class="t-group-col" />', p).string()).prependTo(m.find("colgroup"));
                    a(new b.stringBuilder().rep('<th class="t-group-cell t-header">&nbsp;</th>', p).string()).insertBefore(m.find("th.t-header:first"));
                    a(new b.stringBuilder().rep('<td class="t-group-cell">&nbsp;</td>', p).string()).insertBefore(m.find("tr.t-footer-template > td:first"))
                } else {
                    m.find("th:lt(" + Math.abs(p) + "), tr.t-footer-template > td:lt(" + Math.abs(p) + ")").remove().end().find("col:lt(" + Math.abs(p) + ")").remove()
                }
                var o = [];
                var r = 0;
                a("table, .t-grid-bottom", j.element).each(function () {
                    o.push(this.parentNode)
                }).appendTo(a("<div />")).each(function () {
                    o[r++].appendChild(this)
                })
            } else {
                m.find("col.t-group-col").remove();
                a(new b.stringBuilder().rep('<col class="t-group-col" />', q).string()).prependTo(m.find("colgroup"));
                m.find("th.t-group-cell").remove();
                m.find("tr.t-footer-template > td.t-group-cell").remove();
                a(new b.stringBuilder().rep('<th class="t-group-cell t-header">&nbsp;</th>', q).string()).insertBefore(m.find("th.t-header:first"));
                a(new b.stringBuilder().rep('<td class="t-group-cell">&nbsp;</td>', q).string()).insertBefore(m.find("tr.t-footer-template > td:first"))
            }
        };

        function i(p, n) {
            var q = n,
				m, o;
            for (m = 0, o = p.length; m < o; m++) {
                if (n == p[m].Value) {
                    return p[m].Text
                }
            }
            return n
        }
        j.bindGroup = function (o, m, r, v) {
            var q = j.groups[v];
            var t = o.value;
            var n = a.grep(j.columns, function (x) {
                return q.member == x.member
            })[0],
				p;
            if (n && (n.format || n.type == "Date")) {
                p = /^\/Date\((.*?)\)\/$/.exec(t);
                if (p) {
                    t = new Date(parseInt(p[1]))
                }
                t = b.formatString(n.format || "{0:G}", t)
            }
            r.cat('<tr class="t-grouping-row">').rep('<td class="t-group-cell"></td>', v).cat('<td colspan="').cat(m - v).cat('"><p class="t-reset"><a class="t-icon t-collapse" href="#"></a>');
            if (n) {
                var w = !n.data ? t : i(n.data, t);
                r.cat(n.groupHeader(a.extend({
                    Title: q.title,
                    Key: w
                }, j._mapAggregates(o.aggregates[n.member]))))
            } else {
                r.cat(q.title + ": " + t)
            }
            r.cat("</p></td></tr>");
            if (o.hasSubgroups) {
                for (var s = 0, u = o.items.length; s < u; s++) {
                    j.bindGroup(o.items[s], m, r, v + 1)
                }
            } else {
                j.bindData(o.items, r, v + 1)
            }
            if (j.showGroupFooter) {
                r.cat('<tr class="t-group-footer">').rep('<td class="t-group-cell"></td>', j.groups.length).rep('<td class="t-hierarchy-cell"></td>', j.detail ? 1 : 0);
                a.each(j.columns, function () {
                    r.cat("<td");
                    r.catIf(' style="display:none;"', this.hidden);
                    r.cat(">");
                    if (this.groupFooter) {
                        r.cat(this.groupFooter(j._mapAggregates(o.aggregates[this.member])))
                    }
                    r.cat("</td>")
                });
                r.cat("</tr>")
            }
        }
    }
})(jQuery);