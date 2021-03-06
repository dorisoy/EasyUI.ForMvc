(function (a, bY) {
    var al = document,
		b = a.easyui,
		R = b.Class,
		b8 = b.Component,
		ad = b.DataSource,
		z = b.template,
		av = function () {
		    return b.formatString.apply(b, arguments)
		},
		aY = a.map,
		aB = a.grep,
		am = a.each,
		a6 = a.noop,
		aZ = Math,
		a7 = a6,
		bp = a.proxy,
		az = b.getter,
		ap = a.extend,
		ae = b.deepExtend,
		bX = b.trigger,
		ab = "dataBinding";
    var bN = function (ck) {
        var ch = "d",
            cl = false,
            Y = "var o,e=jQuery.easyui.htmlEncode;",
            X = /\${([^}]*)}/g,
            cj, ci, cg;
        if (a.isFunction(ck)) {
            if (ck.length === 2) {
                return function (cm) {
                    return ck(a, {
                        data: cm
                    }).join("")
                }
            }
            return ck
        }
        Y += cl ? "with(" + ch + "){" : "";
        Y += "o=";
        cj = ck.replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t").replace(X, "#=e($1)#").replace(/\\#/g, "__SHARP__").split("#");
        for (cg = 0; cg < cj.length; cg++) {
            ci = cj[cg];
            if (cg % 2 === 0) {
                Y += "'" + ci.split("'").join("\\'") + "'"
            } else {
                if (ci.charAt(0) === "=") {
                    Y += "+(" + ci.substring(1) + ")+"
                } else {
                    Y += ";" + ci + ";o+="
                }
            }
        }
        Y += cl ? ";}" : ";";
        Y += "return o;";
        Y = Y.replace(/__SHARP__/g, "#");
        return new Function(ch, Y)
    };
    var c = "above",
		d = 10,
		k = "area",
		y = 1,
		q = "bar",
		r = 0.8,
		s = 1.5,
		t = 0.4,
		A = "below",
		B = "#000",
		C = "bottom",
		M = "center",
		N = "change",
		Q = "circle",
		T = "click",
		U = "clip",
		Z = "column",
		aa = 3,
		ac = "dataBound",
		af = "12px sans-serif",
		ag = 400,
		ah = 6,
		ai = 600,
		ak = aZ.PI / 180,
		at = "fadeIn",
		bn = "pointer",
		aA = "glass",
		aC = "height",
		aE = "horizontal",
		aF = "k",
		aI = 600,
		aK = "insideBase",
		aL = "insideEnd",
		aM = "interpolate",
		aQ = "left",
		aS = "line",
		aT = 8,
		aU = "linear",
		a0 = Number.MAX_VALUE,
		a2 = -Number.MAX_VALUE,
		a3 = "mousemove.tracking",
		a4 = "mouseover",
		a5 = "none",
		a9 = "object",
		ba = "onMinorTicks",
		bc = "outside",
		aJ = "inside",
		bd = "outsideEnd",
		bb = "_outline",
		be = "pie",
		bf = 70,
		bo = "primary",
		bq = "radial",
		bs = "right",
		bx = "roundedBevel",
		by = "scatter",
		bz = "scatterLine",
		bD = "seriesClick",
		bJ = "square",
		bM = "swing",
		bV = "top",
		bS = 150,
		bT = 5,
		bU = 100,
		bW = "triangle",
		bZ = "undefined",
		b2 = "vertical",
		b4 = "verticalLine",
		b3 = "verticalArea",
		b9 = "width",
		b7 = "#fff",
		ca = "x",
		cd = "y",
		ce = "zero",
		cf = 0.2;
    var G = [q, Z, aS, b4, k, b3],
		cb = [by, bz];
    var O = b8.extend({
        init: function (cg, ck) {
            var X = this,
				ch, cj, Y = (ck || {}).dataSource,
				ci;
            b8.fn.init.call(X, cg);
            ch = ae({}, X.options, ck);
            ci = ch.theme;
            cj = ci ? O.themes[ci] || O.themes[ci.toLowerCase()] : {};
            h(ch, cj);
            X.options = ae({}, cj, ch);
            i(X.options);
            X.bind(X.events, X.options);
            a(cg).addClass("k-chart");
            X.dataSource = ad.create(Y).bind(N, bp(X._onDataChanged, X));
            if (Y && ch.autoBind) {
                X.dataSource.fetch()
            }
            X._redraw();
            X._attachEvents();
            a7(X)
        },
        events: [ac, bD],
        items: function () {
            return a()
        },
        options: {
            name: "Chart",
            chartArea: {},
            title: {
                visible: true
            },
            legend: {
                visible: true
            },
            valueAxis: {
                type: "Numeric"
            },
            categoryAxis: {
                categories: []
            },
            autoBind: true,
            seriesDefaults: {
                type: Z,
                data: [],
                groupNameTemplate: "#= group.value #: #= series.name #",
                bar: {
                    gap: s,
                    spacing: t
                },
                column: {
                    gap: s,
                    spacing: t
                },
                line: {
                    width: 4
                },
                labels: {}
            },
            series: [],
            tooltip: {
                visible: false
            },
            transitions: true
        },
        refresh: function () {
            var X = this;
            h(X.options);
            if (X.dataSource) {
                X.dataSource.read()
            } else {
                X._redraw()
            }
        },
        redraw: function () {
            var X = this;
            h(X.options);
            X._redraw()
        },
        _redraw: function () {
            var X = this,
				ch = X.options,
				Y = X.element,
				cg = X._model = X._getModel(),
				ci = X._plotArea = cg._plotArea,
				ck = X._supportsSVG() ? O.SVGView : O.VMLView,
				cj = X._view = ck.fromModel(cg);
            Y.css("position", "relative");
            X._viewElement = cj.renderTo(Y[0]);
            X._tooltip = new bR(Y, ch.tooltip);
            X._highlight = new aD(cj, X._viewElement)
        },
        svg: function () {
            var X = this._getModel(),
				Y = O.SVGView.fromModel(X);
            return Y.render()
        },
        _getModel: function () {
            var X = this,
				ch = X.options,
				Y = X.element,
				cg = new bu(ae({
				    width: Y.width() || ai,
				    height: Y.height() || ag,
				    transitions: ch.transitions
				}, ch.chartArea)),
				ci;
            if (ch.title && ch.title.visible && ch.title.text) {
                cg.append(new bQ(ch.title))
            }
            ci = cg._plotArea = X._createPlotArea();
            if (ch.legend.visible) {
                cg.append(new aR(ci.options.legend))
            }
            cg.append(ci);
            cg.reflow();
            return cg
        },
        _createPlotArea: function () {
            var Y = this,
				cj = Y.options,
				cm = cj.series,
				ch, ci = cm.length,
				cg, X = [],
				cn = [],
				ck = [],
				cl;
            for (ch = 0; ch < ci; ch++) {
                cg = cm[ch];
                if (aG(cg.type, G)) {
                    X.push(cg)
                } else {
                    if (aG(cg.type, cb)) {
                        cn.push(cg)
                    } else {
                        if (cg.type === be) {
                            ck.push(cg)
                        }
                    }
                }
            }
            if (ck.length > 0) {
                cl = new bj(ck, cj)
            } else {
                if (cn.length > 0) {
                    cl = new cc(cn, cj)
                } else {
                    cl = new I(X, cj)
                }
            }
            return cl
        },
        _supportsSVG: bL,
        _attachEvents: function () {
            var X = this,
				Y = X.element;
            Y.bind(T, bp(X._click, X));
            Y.bind(a4, bp(X._mouseOver, X))
        },
        _getPoint: function (ch) {
            var X = this,
				cj = X._model,
				cg = X._eventCoordinates(ch),
				cl = ch.target.id,
				Y = cj.idMap[cl],
				ci = cj.idMapMetadata[cl],
				ck;
            if (Y) {
                if (Y.getNearestPoint && ci) {
                    ck = Y.getNearestPoint(cg.x, cg.y, ci.seriesIx)
                } else {
                    ck = Y
                }
            }
            return ck
        },
        _eventCoordinates: function (X) {
            var Y = this.element,
				cg = Y.offset(),
				ch = parseInt(Y.css("paddingLeft"), 10),
				ci = parseInt(Y.css("paddingTop"), 10),
				cj = a(window);
            return {
                x: X.clientX - cg.left - ch + cj.scrollLeft(),
                y: X.clientY - cg.top - ci + cj.scrollTop()
            }
        },
        _click: function (Y) {
            var X = this,
				cg = X._getPoint(Y);
            if (cg) {
                X.trigger(bD, {
                    value: cg.value,
                    category: cg.category,
                    series: cg.series,
                    dataItem: cg.dataItem,
                    element: a(Y.target)
                })
            }
        },
        _mouseOver: function (Y) {
            var X = this,
				ci = X._tooltip,
				cg = X._highlight,
				cj, ch;
            if (!cg || cg.element === Y.target) {
                return
            }
            ch = X._getPoint(Y);
            if (ch) {
                X._activePoint = ch;
                cj = ae({}, X.options.tooltip, ch.options.tooltip);
                if (cj.visible) {
                    ci.show(ch)
                }
                cg.show(ch);
                a(al.body).bind(a3, bp(X._mouseMove, X))
            }
        },
        _mouseMove: function (cg) {
            var X = this,
				cl = X._tooltip,
				ch = X._highlight,
				Y = X._eventCoordinates(cg),
				cj = X._activePoint,
				cm, ci, ck;
            if (X._plotArea.box.containsPoint(Y.x, Y.y)) {
                if (cj && (cj.series.type === aS || cj.series.type === k)) {
                    ci = cj.owner;
                    ck = ci.getNearestPoint(Y.x, Y.y, cj.seriesIx);
                    if (ck && ck != cj) {
                        X._activePoint = ck;
                        cm = ae({}, X.options.tooltip, cj.options.tooltip);
                        if (cm.visible) {
                            cl.show(ck)
                        }
                        ch.show(ck)
                    }
                }
            } else {
                a(al.body).unbind(a3);
                delete X._activePoint;
                cl.hide();
                ch.hide()
            }
        },
        _onDataChanged: function () {
            var X = this,
				cj = X.options,
				ck = cj.series,
				cl, cm = ck.length,
				cg = X.dataSource.view(),
				ch = (X.dataSource.group() || []).length > 0,
				ci = [],
				Y;
            for (cl = 0; cl < cm; cl++) {
                Y = ck[cl];
                if (Y.field || (Y.xField && Y.yField)) {
                    Y.data = [];
                    Y.dataItems = cg;
                    if (ch) {
                        [].push.apply(ci, X._createGroupedSeries(Y, cg))
                    }
                }
            } [].push.apply(ck, ci);
            i(X.options);
            X._bindSeries();
            X._bindCategories(ch ? cg[0].items : cg);
            X.trigger(ac);
            X._redraw()
        },
        _createGroupedSeries: function (cl, X) {
            var cj = [],
				ck, ch, ci, Y = X.length,
				cg = X[0],
				cm;
            if (cl.groupNameTemplate) {
                ck = z(cl.groupNameTemplate)
            }
            for (ci = 1; ci < Y; ci++) {
                cm = ae({}, cl);
                cm.color = bY;
                cj.push(cm);
                ch = X[ci];
                cm.dataItems = ch.items;
                if (ck) {
                    cm.name = ck({
                        series: cm,
                        group: ch
                    })
                }
            }
            cl.dataItems = cg.items;
            if (ck) {
                cl.name = ck({
                    series: cl,
                    group: cg
                })
            }
            return cj
        },
        _bindSeries: function () {
            var X = this,
				ck = X.options.series,
				cm = ck.length,
				cl, Y, cg, ch, ci, cj, cn;
            for (cl = 0; cl < cm; cl++) {
                Y = ck[cl];
                cg = Y.dataItems || [];
                ci = cg.length;
                for (ch = 0; ch < ci; ch++) {
                    cj = cg[ch];
                    if (Y.field) {
                        cn = aw(Y.field, cj)
                    } else {
                        if (Y.xField && Y.yField) {
                            cn = [aw(Y.xField, cj), aw(Y.yField, cj)]
                        } else {
                            cn = bY
                        }
                    }
                    if (aj(cn)) {
                        if (ch === 0) {
                            Y.data = [cn];
                            Y.dataItems = [cj]
                        } else {
                            Y.data.push(cn);
                            Y.dataItems.push(cj)
                        }
                    }
                }
            }
        },
        _bindCategories: function (X) {
            var cg = this.options.categoryAxis,
				ch, Y, ci = X.length;
            if (cg.field) {
                for (ch = 0; ch < ci; ch++) {
                    Y = aw(cg.field, X[ch]);
                    if (ch === 0) {
                        cg.categories = [Y]
                    } else {
                        cg.categories.push(Y)
                    }
                }
            }
        }
    });
    var bm = R.extend({
        init: function (Y, cg) {
            var X = this;
            X.x = bw(Y, aa);
            X.y = bw(cg, aa)
        }
    });
    var D = R.extend({
        init: function (Y, ch, cg, ci) {
            var X = this;
            X.x1 = Y || 0;
            X.x2 = cg || 0;
            X.y1 = ch || 0;
            X.y2 = ci || 0
        },
        width: function () {
            return this.x2 - this.x1
        },
        height: function () {
            return this.y2 - this.y1
        },
        translate: function (Y, cg) {
            var X = this;
            X.x1 += Y;
            X.x2 += Y;
            X.y1 += cg;
            X.y2 += cg;
            return X
        },
        move: function (ch, ci) {
            var X = this,
				Y = X.height(),
				cg = X.width();
            X.x1 = ch;
            X.y1 = ci;
            X.x2 = X.x1 + cg;
            X.y2 = X.y1 + Y;
            return X
        },
        wrap: function (Y) {
            var X = this;
            X.x1 = aZ.min(X.x1, Y.x1);
            X.y1 = aZ.min(X.y1, Y.y1);
            X.x2 = aZ.max(X.x2, Y.x2);
            X.y2 = aZ.max(X.y2, Y.y2);
            return X
        },
        snapTo: function (cg, X) {
            var Y = this;
            if (X == ca || !X) {
                Y.x1 = cg.x1;
                Y.x2 = cg.x2
            }
            if (X == cd || !X) {
                Y.y1 = cg.y1;
                Y.y2 = cg.y2
            }
            return Y
        },
        alignTo: function (cj, cg) {
            var Y = this,
				ch = Y.height(),
				ck = Y.width(),
				X = cg == bV || cg == C ? cd : ca,
				ci = X == cd ? ch : ck;
            if (cg == bV || cg == aQ) {
                Y[X + 1] = cj[X + 1] - ci
            } else {
                Y[X + 1] = cj[X + 2]
            }
            Y.x2 = Y.x1 + ck;
            Y.y2 = Y.y1 + ch;
            return Y
        },
        shrink: function (cg, Y) {
            var X = this;
            X.x2 -= cg;
            X.y2 -= Y;
            return X
        },
        expand: function (Y, X) {
            this.shrink(-Y, -X);
            return this
        },
        pad: function (Y) {
            var X = this,
				cg = ay(Y);
            X.x1 -= cg.left;
            X.x2 += cg.right;
            X.y1 -= cg.top;
            X.y2 += cg.bottom;
            return X
        },
        unpad: function (Y) {
            var X = this,
				cg = ay(Y);
            cg.left = -cg.left;
            cg.top = -cg.top;
            cg.right = -cg.right;
            cg.bottom = -cg.bottom;
            return X.pad(cg)
        },
        clone: function () {
            var X = this;
            return new D(X.x1, X.y1, X.x2, X.y2)
        },
        center: function () {
            var X = this;
            return {
                x: X.x1 + X.width() / 2,
                y: X.y1 + X.height() / 2
            }
        },
        containsPoint: function (Y, cg) {
            var X = this;
            return Y >= X.x1 && Y <= X.x2 && cg >= X.y1 && cg <= X.y2
        },
        points: function () {
            var X = this;
            return [new bm(X.x1, X.y1), new bm(X.x2, X.y1), new bm(X.x2, X.y2), new bm(X.x1, X.y2)]
        }
    });
    var bt = R.extend({
        init: function (Y, cg, ch, cj, X) {
            var ci = this;
            ci.c = Y;
            ci.ir = cg;
            ci.r = ch;
            ci.startAngle = cj;
            ci.angle = X
        },
        clone: function () {
            var X = this;
            return new bt(X.c, X.ir, X.r, X.startAngle, X.angle)
        },
        middle: function () {
            return this.startAngle + this.angle / 2
        },
        radius: function (Y, X) {
            var cg = this;
            if (X) {
                cg.ir = Y
            } else {
                cg.r = Y
            }
            return cg
        },
        point: function (X, ch) {
            var ck = this,
				ci = X * ak,
				Y = aZ.cos(ci),
				cg = aZ.sin(ci),
				cj = ch ? ck.ir : ck.r,
				cl = ck.c.x - (Y * cj),
				cm = ck.c.y - (cg * cj);
            return new bm(cl, cm)
        },
        getBBox: function () {
            var cj = this,
				ck = cj.startAngle,
				Y = ck + cj.angle,
				cl = a0,
				cm = a2,
				cn = a0,
				co = a2,
				ci, X, ch;

            function cg(cq, cr, cp) {
                return (cq >= ck && cq <= Y)
            }
            X = aB([ck, Y, 0, 90, 180, 270], cg);
            for (ch = 0; ch < X.length; ch++) {
                ci = cj.point(X[ch]);
                cl = aZ.min(cl, ci.x);
                cn = aZ.min(cn, ci.y);
                cm = aZ.max(cm, ci.x);
                co = aZ.max(co, ci.y)
            }
            return new D(cl, cn, cm, co)
        }
    });
    var bC = bt.extend({
        init: function (Y, cg, ch, X) {
            bt.fn.init.call(this, Y, 0, cg, ch, X)
        },
        expand: function (X) {
            this.r += X;
            return this
        },
        clone: function () {
            var X = this;
            return new bC(X.c, X.r, X.startAngle, X.angle)
        },
        radius: function (X) {
            return bt.fn.radius.call(this, X)
        },
        point: function (X) {
            return bt.fn.point.call(this, X)
        }
    });
    var P = R.extend({
        init: function (Y) {
            var X = this;
            X.children = [];
            X.options = ae({}, X.options, Y)
        },
        reflow: function (cj) {
            var ch = this,
				Y = ch.children,
				X, ci, cg;
            for (ci = 0; ci < Y.length; ci++) {
                cg = Y[ci];
                cg.reflow(cj);
                X = X ? X.wrap(cg.box) : cg.box.clone()
            }
            ch.box = X
        },
        getViewElements: function (ci) {
            var cg = this,
				cj = [],
				X = cg.children,
				Y = X.length;
            for (var ch = 0; ch < Y; ch++) {
                cj.push.apply(cj, X[ch].getViewElements(ci))
            }
            return cj
        },
        registerId: function (Y, cg) {
            var X = this,
				ch;
            ch = X.getRoot();
            if (ch) {
                ch.idMap[Y] = X;
                if (cg) {
                    ch.idMapMetadata[Y] = cg
                }
            }
        },
        translateChildren: function (cg, ch) {
            var ci = this,
				X = ci.children,
				Y = X.length,
				cj;
            for (cj = 0; cj < Y; cj++) {
                X[cj].box.translate(cg, ch)
            }
        },
        append: function () {
            var X = this,
				Y, cg = arguments.length;
            f(X.children, arguments);
            for (Y = 0; Y < cg; Y++) {
                arguments[Y].parent = X
            }
        },
        getRoot: function () {
            var X = this,
				Y = X.parent;
            return Y ? Y.getRoot() : null
        }
    });
    var bu = P.extend({
        init: function (X) {
            var Y = this;
            Y.idMap = {};
            Y.idMapMetadata = {};
            P.fn.init.call(Y, X)
        },
        options: {
            width: ai,
            height: ag,
            background: b7,
            border: {
                color: B,
                width: 0
            },
            margin: ay(5),
            zIndex: -1
        },
        reflow: function () {
            var ci = this,
				ch = ci.options,
				X = ci.children,
				Y = new D(0, 0, ch.width, ch.height);
            ci.box = Y.unpad(ch.margin);
            for (var cg = 0; cg < X.length; cg++) {
                X[cg].reflow(Y);
                Y = E(Y, X[cg].box)
            }
        },
        getViewElements: function (cj) {
            var ci = this,
				ch = ci.options,
				X = ch.border || {},
				Y = ci.box.clone().pad(ch.margin).unpad(X.width),
				cg = [cj.createRect(Y, {
				    stroke: X.width ? X.color : "",
				    strokeWidth: X.width,
				    dashType: X.dashType,
				    fill: ch.background,
				    zIndex: ch.zIndex
				})];
            return cg.concat(P.fn.getViewElements.call(ci, cj))
        },
        getRoot: function () {
            return this
        }
    });
    var F = P.extend({
        init: function (X) {
            P.fn.init.call(this, X)
        },
        options: {
            align: aQ,
            vAlign: bV,
            margin: {},
            padding: {},
            border: {
                color: B,
                width: 0
            },
            background: "",
            width: 0,
            height: 0,
            visible: true
        },
        reflow: function (cn) {
            var cj = this,
				cg, ci, cl = cj.options,
				ch = cj.children,
				ck = ay(cl.margin),
				cm = ay(cl.padding),
				X = cl.border,
				Y = X.width;
            P.fn.reflow.call(cj, cn);
            if (ch.length === 0) {
                cg = cj.box = new D(0, 0, cl.width, cl.height)
            } else {
                cg = cj.box
            }
            ci = cj.contentBox = cg.clone();
            cg.pad(cm).pad(Y).pad(ck);
            cj.align(cn, ca, cl.align);
            cj.align(cn, cd, cl.vAlign);
            cj.paddingBox = cg.clone().unpad(ck).unpad(Y);
            cj.translateChildren(cg.x1 - ci.x1 + ck.left + Y + cm.left, cg.y1 - ci.y1 + ck.top + Y + cm.top)
        },
        align: function (cm, Y, X) {
            var cj = this,
				cg = cj.box,
				ch = Y + 1,
				ci = Y + 2,
				cl = Y === ca ? b9 : aC,
				ck = cg[cl]();
            if (aG(X, [aQ, bV])) {
                cg[ch] = cm[ch];
                cg[ci] = cg[ch] + ck
            } else {
                if (aG(X, [bs, C])) {
                    cg[ci] = cm[ci];
                    cg[ch] = cg[ci] - ck
                } else {
                    if (X == M) {
                        cg[ch] = cm[ch] + (cm[cl]() - ck) / 2;
                        cg[ci] = cg[ch] + ck
                    }
                }
            }
        },
        hasBox: function () {
            var X = this.options;
            return X.border.width || X.background
        },
        getViewElements: function (cj, ci) {
            var Y = this,
				ch = Y.options;
            if (!ch.visible) {
                return []
            }
            var X = ch.border || {},
				cg = [];
            if (Y.hasBox()) {
                cg.push(cj.createRect(Y.paddingBox, ae({
                    id: ch.id,
                    stroke: X.width ? X.color : "",
                    strokeWidth: X.width,
                    dashType: X.dashType,
                    strokeOpacity: ch.opacity,
                    fill: ch.background,
                    fillOpacity: ch.opacity,
                    animation: ch.animation,
                    zIndex: ch.zIndex
                }, ci)))
            }
            return cg.concat(P.fn.getViewElements.call(Y, cj))
        }
    });
    var bO = P.extend({
        init: function (X, Y) {
            var cg = this;
            P.fn.init.call(cg, Y);
            cg.content = X;
            cg.reflow(new D())
        },
        options: {
            font: af,
            color: B,
            align: aQ,
            vAlign: ""
        },
        reflow: function (ch) {
            var ci = this,
				Y = ci.options,
				cg = Y.size = a1(ci.content, {
				    font: Y.font
				}, Y.rotation);
            ci.baseline = cg.baseline;
            if (Y.align == aQ) {
                ci.box = new D(ch.x1, ch.y1, ch.x1 + cg.width, ch.y1 + cg.height)
            } else {
                if (Y.align == bs) {
                    ci.box = new D(ch.x2 - cg.width, ch.y1, ch.x2, ch.y1 + cg.height)
                } else {
                    if (Y.align == M) {
                        var X = (ch.width() - cg.width) / 2;
                        ci.box = new D(bw(ch.x1 + X, aa), ch.y1, bw(ch.x2 - X, aa), ch.y1 + cg.height)
                    }
                }
            }
            if (Y.vAlign == M) {
                var X = (ch.height() - cg.height) / 2;
                ci.box = new D(ci.box.x1, ch.y1 + X, ci.box.x2, ch.y2 - X)
            } else {
                if (Y.vAlign == C) {
                    ci.box = new D(ci.box.x1, ch.y2 - cg.height, ci.box.x2, ch.y2)
                } else {
                    if (Y.vAlign == bV) {
                        ci.box = new D(ci.box.x1, ch.y1, ci.box.x2, ch.y1 + cg.height)
                    }
                }
            }
        },
        getViewElements: function (cg) {
            var Y = this,
				X = Y.options;
            P.fn.getViewElements.call(this, cg);
            return [cg.createText(Y.content, ae({}, X, {
                x: Y.box.x1,
                y: Y.box.y1,
                baseline: Y.baseline
            }))]
        }
    });
    var bP = F.extend({
        init: function (X, Y) {
            var ch = this,
				cg;
            F.fn.init.call(ch, Y);
            Y = ch.options;
            if (!Y.template) {
                X = Y.format ? av(Y.format, X) : X
            }
            cg = new bO(X, ae({}, Y, {
                align: aQ,
                vAlign: bV
            }));
            ch.append(cg);
            if (ch.hasBox()) {
                cg.options.id = b0()
            }
            ch.reflow(new D())
        }
    });
    var x = P.extend({
        init: function (Y, cg) {
            var X = this;
            P.fn.init.call(X, cg);
            X.append(new bP(Y, X.options))
        },
        options: {
            position: bd,
            margin: ay(3),
            padding: ay(4),
            color: B,
            background: "",
            border: {
                width: 1,
                color: ""
            },
            aboveAxis: true,
            isVertical: false,
            animation: {
                type: at,
                delay: aI
            },
            zIndex: 1
        },
        reflow: function (ck) {
            var Y = this,
				ci = Y.options,
				ch = ci.isVertical,
				X = ci.aboveAxis,
				cl = Y.children[0],
				cg = cl.box,
				cj = cl.options.padding;
            cl.options.align = ch ? M : aQ;
            cl.options.vAlign = ch ? bV : M;
            if (ci.position == aL) {
                if (ch) {
                    cl.options.vAlign = bV;
                    if (!X && cg.height() < ck.height()) {
                        cl.options.vAlign = C
                    }
                } else {
                    cl.options.align = X ? bs : aQ
                }
            } else {
                if (ci.position == M) {
                    cl.options.vAlign = M;
                    cl.options.align = M
                } else {
                    if (ci.position == aK) {
                        if (ch) {
                            cl.options.vAlign = X ? C : bV
                        } else {
                            cl.options.align = X ? aQ : bs
                        }
                    } else {
                        if (ci.position == bd) {
                            if (ch) {
                                if (X) {
                                    ck = new D(ck.x1, ck.y1 - cg.height(), ck.x2, ck.y1)
                                } else {
                                    ck = new D(ck.x1, ck.y2, ck.x2, ck.y2 + cg.height())
                                }
                            } else {
                                cl.options.align = M;
                                if (X) {
                                    ck = new D(ck.x2 + cg.width(), ck.y1, ck.x2, ck.y2)
                                } else {
                                    ck = new D(ck.x1 - cg.width(), ck.y1, ck.x1, ck.y2)
                                }
                            }
                        }
                    }
                }
            }
            if (ch) {
                cj.left = cj.right = (ck.width() - cl.contentBox.width()) / 2
            } else {
                cj.top = cj.bottom = (ck.height() - cl.contentBox.height()) / 2
            }
            cl.reflow(ck)
        }
    });
    var bQ = P.extend({
        init: function (X) {
            var Y = this;
            P.fn.init.call(Y, X);
            Y.append(new bP(Y.options.text, ae({}, Y.options, {
                vAlign: Y.options.position
            })))
        },
        options: {
            text: "",
            color: B,
            position: bV,
            align: M,
            margin: ay(5),
            padding: ay(5)
        },
        reflow: function (X) {
            var Y = this;
            P.fn.reflow.call(Y, X);
            Y.box.snapTo(X, ca)
        }
    });
    var aR = P.extend({
        init: function (Y) {
            var X = this;
            P.fn.init.call(X, Y);
            X.createLabels()
        },
        options: {
            position: bs,
            items: [],
            labels: {},
            offsetX: 0,
            offsetY: 0,
            margin: ay(10),
            padding: ay(5),
            border: {
                color: B,
                width: 0
            },
            background: "",
            zIndex: 1
        },
        createLabels: function () {
            var ci = this,
				cg = ci.options.items,
				X = cg.length,
				ch, cj, Y;
            for (Y = 0; Y < X; Y++) {
                cj = cg[Y].name;
                ch = new bO(cj, ci.options.labels);
                ci.append(ch)
            }
        },
        reflow: function (ch) {
            var Y = this,
				cg = Y.options,
				X = Y.children.length;
            if (X === 0) {
                Y.box = ch.clone();
                return
            }
            if (cg.position == "custom") {
                Y.customLayout(ch);
                return
            }
            if (cg.position == bV || cg.position == C) {
                Y.horizontalLayout(ch)
            } else {
                Y.verticalLayout(ch)
            }
        },
        getViewElements: function (ct) {
            var co = this,
				cg = co.children,
				cr = co.options,
				cl = cr.items,
				ci = cl.length,
				cq = co.markerSize(),
				cj = ct.createGroup({
				    zIndex: cr.zIndex
				}),
				X = cr.border || {},
				cs, cp, cn, ch, cm, Y, ck;
            f(cj.children, P.fn.getViewElements.call(co, ct));
            for (ck = 0; ck < ci; ck++) {
                ch = cl[ck].color;
                cm = cg[ck];
                cp = new D();
                Y = cm.box;
                cn = cn ? cn.wrap(Y) : Y.clone();
                cp.x1 = Y.x1 - cq * 2;
                cp.x2 = cp.x1 + cq;
                if (cr.position == bV || cr.position == C) {
                    cp.y1 = Y.y1 + cq / 2
                } else {
                    cp.y1 = Y.y1 + (Y.height() - cq) / 2
                }
                cp.y2 = cp.y1 + cq;
                cj.children.push(ct.createRect(cp, {
                    fill: ch,
                    stroke: ch
                }))
            }
            if (cg.length > 0) {
                cs = ay(cr.padding);
                cs.left += cq * 2;
                cn.pad(cs);
                cj.children.unshift(ct.createRect(cn, {
                    stroke: X.width ? X.color : "",
                    strokeWidth: X.width,
                    dashType: X.dashType,
                    fill: cr.background
                }))
            }
            return [cj]
        },
        verticalLayout: function (cq) {
            var ck = this,
				cp = ck.options,
				X = ck.children,
				Y = X.length,
				ci = X[0].box.clone(),
				cn, co, cl = ay(cp.margin),
				cm = ck.markerSize() * 2,
				ch, cg;
            for (cg = 1; cg < Y; cg++) {
                ch = ck.children[cg];
                ch.box.alignTo(ck.children[cg - 1].box, C);
                ci.wrap(ch.box)
            }
            if (cp.position == aQ) {
                cn = cq.x1 + cm + cl.left;
                co = (cq.y2 - ci.height()) / 2;
                ci.x2 += cm + cl.left + cl.right
            } else {
                cn = cq.x2 - ci.width() - cl.right;
                co = (cq.y2 - ci.height()) / 2;
                ci.translate(cn, co);
                ci.x1 -= cm + cl.left
            }
            ck.translateChildren(cn + cp.offsetX, co + cp.offsetY);
            var cj = ci.width();
            ci.x1 = aZ.max(cq.x1, ci.x1);
            ci.x2 = ci.x1 + cj;
            ci.y1 = cq.y1;
            ci.y2 = cq.y2;
            ck.box = ci
        },
        horizontalLayout: function (cs) {
            var cl = this,
				cq = cl.options,
				cg = cl.children,
				ch = cg.length,
				X = cg[0].box.clone(),
				cn = cl.markerSize() * 3,
				co, cp, cm = ay(cq.margin),
				Y = cg[0].box.width() + cn,
				cr = cs.width(),
				cj, ck = 0,
				ci;
            for (ci = 1; ci < ch; ci++) {
                cj = cg[ci];
                Y += cj.box.width() + cn;
                if (Y > cr - cn) {
                    cj.box = new D(X.x1, X.y2, X.x1 + cj.box.width(), X.y2 + cj.box.height());
                    Y = cj.box.width() + cn;
                    ck = cj.box.y1
                } else {
                    cj.box.alignTo(cg[ci - 1].box, bs);
                    cj.box.y2 = ck + cj.box.height();
                    cj.box.y1 = ck;
                    cj.box.translate(cn, 0)
                }
                X.wrap(cj.box)
            }
            co = (cs.width() - X.width() + cn) / 2;
            if (cq.position === bV) {
                cp = cs.y1 + cm.top;
                X.y2 = cs.y1 + X.height() + cm.top + cm.bottom;
                X.y1 = cs.y1
            } else {
                cp = cs.y2 - X.height() - cm.bottom;
                X.y1 = cs.y2 - X.height() - cm.top - cm.bottom;
                X.y2 = cs.y2
            }
            cl.translateChildren(co + cq.offsetX, cp + cq.offsetY);
            X.x1 = cs.x1;
            X.x2 = cs.x2;
            cl.box = X
        },
        customLayout: function (cl) {
            var ci = this,
				ck = ci.options,
				X = ci.children,
				Y = X.length,
				ch = X[0].box.clone(),
				cj = ci.markerSize() * 2,
				cg;
            for (cg = 1; cg < Y; cg++) {
                ch = ci.children[cg].box;
                ch.alignTo(ci.children[cg - 1].box, C);
                ch.wrap(ch)
            }
            ci.translateChildren(ck.offsetX + cj, ck.offsetY);
            ci.box = cl
        },
        markerSize: function () {
            var Y = this,
				X = Y.children;
            if (X.length > 0) {
                return X[0].box.height() / 2
            } else {
                return 0
            }
        }
    });
    var n = P.extend({
        init: function (Y) {
            var X = this;
            P.fn.init.call(X, Y);
            if (!X.options.visible) {
                X.options = ae({}, X.options, {
                    labels: {
                        visible: false
                    },
                    line: {
                        visible: false
                    },
                    margin: 0,
                    majorTickSize: 0,
                    minorTickSize: 0
                })
            }
            X.createLabels();
            X.createTitle()
        },
        options: {
            labels: {
                visible: true,
                rotation: 0,
                mirror: false,
                step: 1
            },
            line: {
                width: 1,
                color: B,
                visible: true
            },
            title: {
                visible: true,
                position: M
            },
            majorTickType: bc,
            majorTickSize: 4,
            minorTickType: a5,
            minorTickSize: 3,
            axisCrossingValue: 0,
            minorGridLines: {
                visible: false,
                width: 1,
                color: B
            },
            margin: 5,
            visible: true
        },
        createLabels: function () {
            var Y = this,
				cl = Y.options,
				X = cl.isVertical ? bs : M,
				ci = ae({}, cl.labels, {
				    align: X,
				    zIndex: cl.zIndex
				}),
				cm = ci.step;
            Y.labels = [];
            if (ci.visible) {
                var cj = Y.getLabelsCount(),
					ck, ch, cg;
                for (cg = 0; cg < cj; cg += cm) {
                    ck = Y.getLabelText(cg);
                    if (ci.template) {
                        labelTemplate = z(ci.template);
                        ck = labelTemplate({
                            value: ck
                        })
                    }
                    ch = new bP(ck, ci);
                    Y.append(ch);
                    Y.labels.push(ch)
                }
            }
        },
        getLabelsCount: a6,
        getLabelText: a6,
        lineBox: function () {
            var X = this,
				ck = X.options,
				ch = X.box,
				ci = ck.isVertical,
				cj = ck.labels.mirror,
				Y = cj ? ch.x1 : ch.x2,
				cg = cj ? ch.y2 : ch.y1;
            if (ci) {
                return new D(Y, ch.y1, Y, ch.y2)
            }
            return new D(ch.x1, cg, ch.x2, cg)
        },
        createTitle: function () {
            var X = this,
				Y = X.options,
				ch = ae({
				    rotation: Y.isVertical ? -90 : 0,
				    text: "",
				    zIndex: 1
				}, Y.title),
				cg;
            if (ch.visible && ch.text) {
                cg = new bP(ch.text, ch);
                X.append(cg);
                X.title = cg
            }
        },
        renderTicks: function (ck) {
            var X = this,
				ci = X.options,
				ch = ci.labels.mirror,
				Y = X.lineBox(),
				cg = X.getMajorTickPositions(),
				cj = [];
            if (ci.majorTickType.toLowerCase() === bc) {
                cj = cj.concat(aY(cg, function (cl) {
                    return {
                        pos: cl,
                        size: ci.majorTickSize,
                        width: ci.line.width,
                        color: ci.line.color
                    }
                }))
            }
            if (ci.minorTickType.toLowerCase() === bc) {
                cj = cj.concat(aY(X.getMinorTickPositions(), function (cl) {
                    if (ci.majorTickType.toLowerCase() !== a5) {
                        if (!aG(cl, cg)) {
                            return {
                                pos: cl,
                                size: ci.minorTickSize,
                                width: ci.line.width,
                                color: ci.line.color
                            }
                        }
                    } else {
                        return {
                            pos: cl,
                            size: ci.minorTickSize,
                            width: ci.line.width,
                            color: ci.line.color
                        }
                    }
                }))
            }
            return aY(cj, function (cl) {
                var cm = ch ? Y.x2 : Y.x2 - cl.size,
					cn = ch ? Y.y1 - cl.size : Y.y1;
                if (ci.isVertical) {
                    return ck.createLine(cm, cl.pos, cm + cl.size, cl.pos, {
                        strokeWidth: cl.width,
                        stroke: cl.color
                    })
                } else {
                    return ck.createLine(cl.pos, cn, cl.pos, cn + cl.size, {
                        strokeWidth: cl.width,
                        stroke: cl.color
                    })
                }
            })
        },
        getActualTickSize: function () {
            var X = this,
				Y = X.options,
				cg = 0;
            if (Y.majorTickType != a5 && Y.minorTickType != a5) {
                cg = aZ.max(Y.majorTickSize, Y.minorTickSize)
            } else {
                if (Y.majorTickType != a5) {
                    cg = Y.majorTickSize
                } else {
                    if (Y.minorTickType != a5) {
                        cg = Y.minorTickSize
                    }
                }
            }
            return cg
        },
        renderPlotBands: function (co) {
            var X = this,
				ch = X.options,
				cj = ch.plotBands || [],
				cg = ch.isVertical,
				ck = [],
				ci = X.parent,
				cl, cm, Y, cn;
            if (cj.length) {
                ck = aY(cj, function (cp) {
                    Y = aj(cp.from) ? cp.from : a2;
                    cn = aj(cp.to) ? cp.to : a0;
                    cp.from = aZ.min(Y, cn);
                    cp.to = aZ.max(Y, cn);
                    cl = cg ? ci.axisX.lineBox() : ci.axisX.getSlot(cp.from, cp.to);
                    cm = cg ? ci.axisY.getSlot(cp.from, cp.to) : ci.axisY.lineBox();
                    return co.createRect(new D(cl.x1, cm.y1, cl.x2, cm.y2), {
                        fill: cp.color,
                        fillOpacity: cp.opacity,
                        zIndex: -1
                    })
                })
            }
            return ck
        },
        reflowAxis: function (Y, co) {
            var X = this,
				cn = X.options,
				ci = cn.isVertical,
				ck = X.labels,
				cg = ck.length,
				cp = X.getActualTickSize() + cn.margin,
				cl = 0,
				cm = 0,
				cq = X.title,
				cj, ch;
            for (ch = 0; ch < cg; ch++) {
                cj = ck[ch];
                cl = aZ.max(cl, cj.box.height());
                cm = aZ.max(cm, cj.box.width())
            }
            if (cq) {
                if (ci) {
                    cm += cq.box.width()
                } else {
                    cl += cq.box.height()
                }
            }
            if (ci) {
                X.box = new D(Y.x1, Y.y1, Y.x1 + cm + cp, Y.y2)
            } else {
                X.box = new D(Y.x1, Y.y1, Y.x2, Y.y1 + cl + cp)
            }
            X.arrangeTitle();
            X.arrangeLabels(cm, cl, co)
        },
        arrangeLabels: function (ct, cs, cy) {
            var X = this,
				cx = X.options,
				co = cx.labels.step,
				cm = X.labels,
				ch = cx.isVertical,
				cr = X.lineBox(),
				cv = cx.labels.mirror,
				cA = X.getMajorTickPositions(),
				cB = X.getActualTickSize(),
				ck = X.getActualTickSize() + cx.margin,
				cj, cq, cg;
            for (cg = 0; cg < cm.length; cg++) {
                var ci = cm[cg],
					cz = co * cg,
					cn = ch ? ci.box.height() : ci.box.width(),
					cl = cA[cz] - (cn / 2),
					Y, cw, cu, cp;
                if (ch) {
                    if (cy == ba) {
                        Y = cA[cz];
                        cw = cA[cz + 1];
                        cu = Y + (cw - Y) / 2;
                        cl = cu - (cn / 2)
                    }
                    cp = cr.x2;
                    if (cv) {
                        cp += ck
                    } else {
                        cp -= ck + ci.box.width()
                    }
                    cj = ci.box.move(cp, cl)
                } else {
                    if (cy == ba) {
                        Y = cA[cz];
                        cw = cA[cz + 1]
                    } else {
                        Y = cl;
                        cw = cl + cn
                    }
                    cq = cr.y1;
                    if (cv) {
                        cq -= ck + ci.box.height()
                    } else {
                        cq += ck
                    }
                    cj = new D(Y, cq, cw, cq + ci.box.height())
                }
                ci.reflow(cj)
            }
        },
        arrangeTitle: function () {
            var X = this,
				ch = X.options,
				cg = ch.labels.mirror,
				Y = ch.isVertical,
				ci = X.title;
            if (ci) {
                if (Y) {
                    ci.options.align = cg ? bs : aQ;
                    ci.options.vAlign = ci.options.position
                } else {
                    ci.options.align = ci.options.position;
                    ci.options.vAlign = cg ? bV : C
                }
                ci.reflow(X.box)
            }
        }
    });
    var a8 = n.extend({
        init: function (ck, cj, ci) {
            var X = this,
				Y = X.initDefaults(ck, cj, ci),
				ch, cg;
            n.fn.init.call(X, Y)
        },
        options: {
            min: 0,
            max: 1,
            isVertical: true,
            majorGridLines: {
                visible: true,
                width: 1,
                color: B
            },
            zIndex: 1
        },
        initDefaults: function (cl, ck, cj) {
            var ch = this,
				Y = ch.autoAxisMin(cl, ck),
				X = ch.autoAxisMax(cl, ck),
				ci = m(Y, X),
				cg = {
				    majorUnit: ci
				},
				cm;
            if (Y < 0) {
                Y -= ci
            }
            if (X > 0) {
                X += ci
            }
            cg.min = au(Y, ci);
            cg.max = L(X, ci);
            if (cj) {
                cm = aj(cj.min) || aj(cj.max);
                if (cm) {
                    if (cj.min === cj.max) {
                        if (cj.min > 0) {
                            cj.min = 0
                        } else {
                            cj.max = 1
                        }
                    }
                }
                if (cj.majorUnit) {
                    cg.min = au(cg.min, cj.majorUnit);
                    cg.max = L(cg.max, cj.majorUnit)
                } else {
                    if (cm) {
                        cj = ae(cg, cj);
                        cg.majorUnit = m(cj.min, cj.max)
                    }
                }
            }
            return ae(cg, cj)
        },
        range: function () {
            var X = this.options;
            return {
                min: X.min,
                max: X.max
            }
        },
        reflow: function (X) {
            this.reflowAxis(X)
        },
        getViewElements: function (ck) {
            var X = this,
				cj = X.options,
				cg = cj.line,
				Y = P.fn.getViewElements.call(X, ck),
				ch = X.lineBox(),
				ci;
            if (cg.width > 0 && cg.visible) {
                ci = {
                    strokeWidth: cg.width,
                    stroke: cg.color,
                    dashType: cg.dashType,
                    zIndex: cj.zIndex
                };
                if (cj.isVertical) {
                    Y.push(ck.createLine(ch.x1, ch.y1, ch.x1, ch.y2, ci))
                } else {
                    Y.push(ck.createLine(ch.x1, ch.y1, ch.x2, ch.y1, ci))
                }
                f(Y, X.renderTicks(ck));
                f(Y, X.renderPlotBands(ck))
            }
            return Y
        },
        autoAxisMax: function (ch, cg) {
            if (ch == 0 && cg == 0) {
                return 1
            }
            var X;
            if (ch <= 0 && cg <= 0) {
                cg = ch == cg ? 0 : cg;
                var Y = aZ.abs((cg - ch) / cg);
                if (Y > cf) {
                    return 0
                }
                X = cg - ((ch - cg) / 2)
            } else {
                ch = ch == cg ? 0 : ch;
                X = cg
            }
            return X
        },
        autoAxisMin: function (ch, cg) {
            if (ch == 0 && cg == 0) {
                return 0
            }
            var X;
            if (ch >= 0 && cg >= 0) {
                ch = ch == cg ? 0 : ch;
                var Y = (cg - ch) / cg;
                if (Y > cf) {
                    return 0
                }
                X = ch - ((cg - ch) / 2)
            } else {
                cg = ch == cg ? 0 : cg;
                X = ch
            }
            return X
        },
        getDivisions: function (cg) {
            var X = this.options,
				Y = X.max - X.min;
            return aZ.floor(bw(Y / cg, aa)) + 1
        },
        getTickPositions: function (ct) {
            var X = this,
				cl = X.options,
				ci = cl.isVertical,
				cp = cl.reverse,
				cj = X.lineBox(),
				ck = ci ? cj.height() : cj.width(),
				co = cl.max - cl.min,
				cq = ck / co,
				cs = ct * cq,
				cg = X.getDivisions(ct),
				Y = (ci ? -1 : 1) * (cp ? -1 : 1),
				cr = Y === 1 ? 1 : 2,
				cm = cj[(ci ? cd : ca) + cr],
				cn = [],
				ch;
            for (ch = 0; ch < cg; ch++) {
                cn.push(bw(cm, aa));
                cm = cm + cs * Y
            }
            return cn
        },
        getMajorTickPositions: function () {
            var X = this;
            return X.getTickPositions(X.options.majorUnit)
        },
        getMinorTickPositions: function () {
            var X = this;
            return X.getTickPositions(X.options.majorUnit / 5)
        },
        lineBox: function () {
            var X = this,
				ck = X.options,
				ch = ck.isVertical,
				cj = ch ? "height" : "width",
				ci = X.labels,
				Y = n.fn.lineBox.call(X),
				cl = 0,
				cg = 0;
            if (ci.length > 1) {
                cl = ci[0].box[cj]() / 2;
                cg = aP(ci).box[cj]() / 2
            }
            if (ch) {
                return new D(Y.x1, Y.y1 + cl, Y.x1, Y.y2 - cg)
            } else {
                return new D(Y.x1 + cl, Y.y1, Y.x2 - cg, Y.y1)
            }
        },
        getSlot: function (X, cg) {
            var Y = this,
				cm = Y.options,
				cp = cm.reverse,
				ci = cm.isVertical,
				cs = ci ? cd : ca,
				cj = Y.lineBox(),
				cl = cj[cs + (cp ? 2 : 1)],
				ck = ci ? cj.height() : cj.width(),
				ch = cp ? -1 : 1,
				cr = ch * (ck / (cm.max - cm.min)),
				X = aj(X) ? X : cm.axisCrossingValue,
				cg = aj(cg) ? cg : cm.axisCrossingValue,
				X = aZ.max(aZ.min(X, cm.max), cm.min),
				cg = aZ.max(aZ.min(cg, cm.max), cm.min),
				cn, co, cq = new D(cj.x1, cj.y1, cj.x1, cj.y1);
            if (ci) {
                cn = cm.max - aZ.max(X, cg);
                co = cm.max - aZ.min(X, cg)
            } else {
                cn = aZ.min(X, cg) - cm.min;
                co = aZ.max(X, cg) - cm.min
            }
            cq[cs + 1] = cl + cr * (cp ? co : cn);
            cq[cs + 2] = cl + cr * (cp ? cn : co);
            return cq
        },
        getLabelsCount: function () {
            return this.getDivisions(this.options.majorUnit)
        },
        getLabelText: function (X) {
            var Y = this.options;
            return bw(Y.min + (X * Y.majorUnit), ah)
        }
    });
    var K = n.extend({
        options: {
            categories: [],
            isVertical: false,
            majorGridLines: {
                visible: false,
                width: 1,
                color: B
            },
            zIndex: 1
        },
        range: function () {
            return {
                min: 0,
                max: this.options.categories.length
            }
        },
        reflow: function (X) {
            this.reflowAxis(X, ba)
        },
        getViewElements: function (ck) {
            var X = this,
				cj = X.options,
				cg = cj.line,
				ch = X.lineBox(),
				Y = P.fn.getViewElements.call(X, ck),
				ci;
            if (cg.width > 0 && cg.visible) {
                ci = {
                    strokeWidth: cg.width,
                    stroke: cg.color,
                    dashType: cg.dashType,
                    zIndex: cg.zIndex
                };
                Y.push(ck.createLine(ch.x1, ch.y1, ch.x2, ch.y2, ci));
                f(Y, X.renderTicks(ck));
                f(Y, X.renderPlotBands(ck))
            }
            return Y
        },
        getTickPositions: function (ch) {
            var X = this,
				ci = X.options,
				cg = ci.isVertical,
				cl = cg ? X.box.height() : X.box.width(),
				cm = cl / ch,
				cj = cg ? X.box.y1 : X.box.x1,
				ck = [],
				Y;
            for (Y = 0; Y < ch; Y++) {
                ck.push(bw(cj, aa));
                cj += cm
            }
            ck.push(cg ? X.box.y2 : X.box.x2);
            return ci.reverse ? ck.reverse() : ck
        },
        getMajorTickPositions: function () {
            var X = this;
            return X.getTickPositions(X.options.categories.length)
        },
        getMinorTickPositions: function () {
            var X = this;
            return X.getTickPositions(X.options.categories.length * 2)
        },
        getSlot: function (cg, cs) {
            var X = this,
				ck = X.options,
				cn = ck.reverse,
				ch = ck.isVertical,
				ci = X.lineBox(),
				co = ch ? ci.height() : ci.width(),
				Y = aZ.max(1, ck.categories.length),
				cg = aZ.min(aZ.max(0, cg), Y),
				cs = aj(cs) ? cs : cg,
				cs = aZ.max(aZ.min(Y, cs), cg),
				ct = ch ? cd : ca,
				cj = ci[ct + (cn ? 2 : 1)],
				cr = (cn ? -1 : 1) * (co / Y),
				cl = cj + (cg * cr),
				cm = cl + cr,
				cq = cs - cg,
				cp = new D(ci.x1, ci.y1, ci.x1, ci.y1);
            if (cq > 0 || (cg == cs && Y == cg)) {
                cm = cl + (cq * cr)
            }
            cp[ct + 1] = cn ? cm : cl;
            cp[ct + 2] = cn ? cl : cm;
            return cp
        },
        getLabelsCount: function () {
            return this.options.categories.length
        },
        getLabelText: function (X) {
            var Y = this.options;
            return aj(Y.categories[X]) ? Y.categories[X] : ""
        }
    });
    var V = P.extend({
        init: function (Y) {
            var X = this;
            P.fn.init.call(X, Y)
        },
        options: {
            isVertical: false,
            gap: 0,
            spacing: 0
        },
        reflow: function (Y) {
            var ci = this,
				cn = ci.options,
				cm = cn.isVertical,
				X = cm ? cd : ca,
				ch = ci.children,
				ck = cn.gap,
				cr = cn.spacing,
				cj = ch.length,
				cp = cj + ck + (cr * (cj - 1)),
				cq = (cm ? Y.height() : Y.width()) / cp,
				co = Y[X + 1] + cq * (ck / 2),
				cg, cl;
            for (cl = 0; cl < cj; cl++) {
                cg = (ch[cl].box || Y).clone();
                cg[X + 1] = co;
                cg[X + 2] = co + cq;
                ch[cl].reflow(cg);
                if (cl < cj - 1) {
                    co += (cq * cr)
                }
                co += cq
            }
        }
    });
    var bK = P.extend({
        init: function (X) {
            var Y = this;
            P.fn.init.call(Y, X)
        },
        options: {
            isVertical: true,
            isReversed: false
        },
        reflow: function (cr) {
            var cn = this,
				cl = cn.options,
				ck = cl.isVertical,
				cm = ck ? ca : cd,
				co = ck ? cd : ca,
				cp = cr[co + 2],
				cg = cn.children,
				X = cn.box = new D(),
				ch = cg.length,
				cq, cj;
            if (cl.isReversed) {
                cq = ck ? C : aQ
            } else {
                cq = ck ? bV : bs
            }
            for (cj = 0; cj < ch; cj++) {
                var ci = cg[cj],
					Y = ci.box.clone();
                Y.snapTo(cr, cm);
                if (ci.options) {
                    ci.options.stackBase = cp
                }
                if (cj == 0) {
                    X = cn.box = Y.clone()
                } else {
                    Y.alignTo(cg[cj - 1].box, cq)
                }
                ci.reflow(Y);
                X.wrap(Y)
            }
        }
    });
    var p = P.extend({
        init: function (cg, Y) {
            var X = this;
            X.value = cg;
            X.options.id = b0();
            P.fn.init.call(X, Y)
        },
        options: {
            color: b7,
            border: {
                width: 1
            },
            isVertical: true,
            overlay: {
                gradient: aA
            },
            aboveAxis: true,
            labels: {
                visible: false
            },
            animation: {
                type: q
            },
            opacity: 1
        },
        render: function () {
            var X = this,
				cj = X.value,
				ci = X.options,
				Y = ci.labels,
				ch = cj,
				cg;
            if (X._rendered) {
                return
            } else {
                X._rendered = true
            }
            if (Y.visible && cj) {
                if (Y.template) {
                    cg = z(Y.template);
                    ch = cg({
                        dataItem: X.dataItem,
                        category: X.category,
                        value: X.value,
                        series: X.series
                    })
                }
                X.append(new x(ch, ae({
                    isVertical: ci.isVertical,
                    id: b0()
                }, ci.labels)))
            }
        },
        reflow: function (ci) {
            this.render();
            var X = this,
				ch = X.options,
				Y = X.children,
				cg = Y[0];
            X.box = ci;
            if (cg) {
                cg.options.aboveAxis = ch.aboveAxis;
                cg.reflow(ci)
            }
        },
        getViewElements: function (cm) {
            var X = this,
				ck = X.options,
				ci = ck.isVertical,
				Y = ck.border.width > 0 ? {
				    stroke: X.getBorderColor(),
				    strokeWidth: ck.border.width,
				    dashType: ck.border.dashType
				} : {},
				cg = X.box,
				cl = ae({
				    id: ck.id,
				    fill: ck.color,
				    fillOpacity: ck.opacity,
				    strokeOpacity: ck.opacity,
				    isVertical: ck.isVertical,
				    aboveAxis: ck.aboveAxis,
				    stackBase: ck.stackBase,
				    animation: ck.animation
				}, Y),
				ch = [],
				cj = X.children[0];
            if (ck.overlay) {
                cl.overlay = ae({
                    rotation: ci ? 0 : 90
                }, ck.overlay)
            }
            ch.push(cm.createRect(cg, cl));
            f(ch, P.fn.getViewElements.call(X, cm));
            X.registerId(ck.id);
            if (cj) {
                X.registerId(cj.options.id)
            }
            return ch
        },
        getOutlineElement: function (ci, cg) {
            var X = this,
				Y = X.box,
				ch = X.options.id + bb;
            X.registerId(ch);
            cg = ae({}, cg, {
                id: ch
            });
            return ci.createRect(Y, cg)
        },
        getBorderColor: function () {
            var X = this,
				ch = X.options,
				cg = ch.color,
				Y = ch.border.color;
            if (!aj(Y)) {
                Y = new W(cg).brightness(r).toHex()
            }
            return Y
        },
        tooltipAnchor: function (ck, cj) {
            var Y = this,
				ci = Y.options,
				cg = Y.box,
				ch = ci.isVertical,
				X = ci.aboveAxis,
				cl, cm;
            if (ch) {
                cl = cg.x2 + bT;
                cm = X ? cg.y1 : cg.y2 - cj
            } else {
                if (ci.isStacked) {
                    cl = cg.x2 - ck;
                    cm = cg.y1 - cj - bT
                } else {
                    cl = cg.x2 + bT;
                    cm = cg.y1
                }
            }
            return new bm(cl, cm)
        },
        formatPointValue: function (X) {
            var Y = this;
            return Y.owner.formatPointValue(Y.value, X)
        }
    });
    var H = P.extend({
        init: function (cg, Y) {
            var X = this;
            P.fn.init.call(X, Y);
            X.plotArea = cg;
            X.valueAxisRanges = {};
            X.points = [];
            X.categoryPoints = [];
            X.seriesPoints = [];
            X.render()
        },
        options: {
            series: [],
            invertAxes: false,
            isStacked: false
        },
        render: function () {
            var X = this;
            X.traverseDataPoints(bp(X.addValue, X))
        },
        addValue: function (cm, X, Y, cj, ck) {
            var ch = this,
				ci, cg = ch.categoryPoints[Y],
				cl = ch.seriesPoints[ck];
            if (!cg) {
                ch.categoryPoints[Y] = cg = []
            }
            if (!cl) {
                ch.seriesPoints[ck] = cl = []
            }
            ch.updateRange(cm, Y, cj);
            ci = ch.createPoint(cm, X, Y, cj, ck);
            if (ci) {
                ci.category = X;
                ci.series = cj;
                ci.seriesIx = ck;
                ci.owner = ch;
                ci.dataItem = cj.dataItems ? cj.dataItems[Y] : {
                    value: cm
                }
            }
            ch.points.push(ci);
            cl.push(ci);
            cg.push(ci)
        },
        updateRange: function (cj, cg, ci) {
            var ch = this,
				X = ci.axis || bo,
				Y = ch.valueAxisRanges[X];
            if (aj(cj)) {
                Y = ch.valueAxisRanges[X] = Y || {
                    min: a0,
                    max: a2
                };
                Y.min = aZ.min(Y.min, cj);
                Y.max = aZ.max(Y.max, cj)
            }
        },
        seriesValueAxis: function (X) {
            return this.plotArea.namedValueAxes[(X || {}).axis || bo]
        },
        reflow: function (co) {
            var ch = this,
				ck = ch.options,
				cj = ck.invertAxes,
				cl = ch.plotArea,
				cn = 0,
				cg = ch.categorySlots = [],
				ci = ch.points,
				Y = cl.categoryAxis,
				cp, X, cm;
            ch.traverseDataPoints(function (cy, cr, cs, cu) {
                cp = ch.seriesValueAxis(cu);
                X = cp.options.axisCrossingValue;
                cm = ci[cn++];
                if (cm && cm.plotValue) {
                    cy = cm.plotValue
                }
                var ct = Y.getSlot(cs),
					cz = cp.getSlot(cy),
					cw = cj ? cz : ct,
					cx = cj ? ct : cz,
					cv = new D(cw.x1, cx.y1, cw.x2, cx.y2),
					cq = cp.options.reverse ? cy < X : cy >= X;
                if (cm) {
                    cm.options.aboveAxis = cq;
                    cm.reflow(cv)
                }
                if (!cg[cs]) {
                    cg[cs] = ct
                }
            });
            ch.reflowCategories(cg);
            ch.box = co
        },
        reflowCategories: function () { },
        traverseDataPoints: function (X) {
            var ch = this,
				cl = ch.options,
				cm = cl.series,
				Y = ch.plotArea.options.categoryAxis.categories || [],
				ci = J(cm),
				cg, cn, co, cj, ck;
            for (cg = 0; cg < ci; cg++) {
                for (cn = 0; cn < cm.length; cn++) {
                    cj = Y[cg];
                    ck = cm[cn];
                    co = ck.data[cg];
                    X(co, cj, cg, ck, cn)
                }
            }
        },
        formatPointValue: function (Y, X) {
            return av(X, Y)
        }
    });
    var w = H.extend({
        init: function (cg, Y) {
            var X = this;
            X._categoryTotalsPos = [];
            X._categoryTotalsNeg = [];
            H.fn.init.call(X, cg, Y)
        },
        render: function () {
            var X = this;
            H.fn.render.apply(X);
            X.computeAxisRanges()
        },
        createPoint: function (cs, cg, ch, cp, cq) {
            var Y = this,
				cn = Y.options,
				ci = Y.children,
				ck = Y.options.isStacked,
				cl = ae({}, cp.labels);
            if (ck) {
                if (cl.position == bd) {
                    cl.position = aL
                }
            }
            var X = new p(cs, ae({}, {
                isVertical: !cn.invertAxes,
                overlay: cp.overlay,
                labels: cl,
                isStacked: ck
            }, cp));
            var cj = ci[ch];
            if (!cj) {
                cj = new V({
                    isVertical: cn.invertAxes,
                    gap: cn.gap,
                    spacing: cn.spacing
                });
                Y.append(cj)
            }
            if (ck) {
                var cr = cj.children[0],
					co, cm;
                if (!cr) {
                    cr = new P();
                    cj.append(cr);
                    co = new bK({
                        isVertical: !cn.invertAxes
                    });
                    cm = new bK({
                        isVertical: !cn.invertAxes,
                        isReversed: true
                    });
                    cr.append(co, cm)
                } else {
                    co = cr.children[0];
                    cm = cr.children[1]
                }
                if (cs > 0) {
                    co.append(X)
                } else {
                    cm.append(X)
                }
            } else {
                cj.append(X)
            }
            return X
        },
        updateRange: function (ck, X, ch) {
            var Y = this,
				cg = Y.options.isStacked,
				cj = Y._categoryTotalsPos,
				ci = Y._categoryTotalsNeg;
            if (aj(ck)) {
                if (cg) {
                    aH(ck > 0 ? cj : ci, X, ck)
                } else {
                    H.fn.updateRange.apply(Y, arguments)
                }
            }
        },
        computeAxisRanges: function () {
            var Y = this,
				cg = Y.options.isStacked,
				X;
            if (cg) {
                X = Y.options.series[0].axis || bo;
                Y.valueAxisRanges[X] = {
                    min: bH(Y._categoryTotalsNeg.concat(0)),
                    max: bG(Y._categoryTotalsPos.concat(0))
                }
            }
        },
        seriesValueAxis: function (cg) {
            var X = this,
				Y = X.options;
            return H.fn.seriesValueAxis.call(X, Y.isStacked ? X.options.series[0] : cg)
        },
        reflowCategories: function (X) {
            var Y = this,
				cg = Y.children,
				ch = cg.length,
				ci;
            for (ci = 0; ci < ch; ci++) {
                cg[ci].reflow(X[ci])
            }
        }
    });
    var bE = F.extend({
        init: function (Y) {
            var X = this;
            F.fn.init.call(X, Y)
        },
        options: {
            type: bJ,
            align: M,
            vAlign: M
        },
        getViewElements: function (cl, cj) {
            var ch = this,
				ci = ch.options,
				ck = ci.type,
				X = ch.paddingBox,
				Y = F.fn.getViewElements.call(ch, cl, cj)[0],
				cg = X.width() / 2;
            if (!Y) {
                return []
            }
            if (ck === bW) {
                Y = cl.createPolyline([new bm(X.x1 + cg, X.y1), new bm(X.x1, X.y2), new bm(X.x2, X.y2)], true, Y.options)
            } else {
                if (ck === Q) {
                    Y = cl.createCircle([bw(X.x1 + cg, aa), bw(X.y1 + X.height() / 2, aa)], cg, Y.options)
                }
            }
            return [Y]
        }
    });
    var aX = P.extend({
        init: function (cg, X) {
            var Y = this;
            Y.value = cg;
            b6.fn.init.call(Y, X)
        },
        options: {
            aboveAxis: true,
            isVertical: true,
            markers: {
                visible: true,
                background: b7,
                size: aT,
                type: Q,
                border: {
                    width: 2
                },
                opacity: 1
            },
            labels: {
                visible: false,
                position: c,
                margin: ay(3),
                padding: ay(4),
                animation: {
                    type: at,
                    delay: aI
                }
            }
        },
        render: function () {
            var cl = this,
				ck = cl.options,
				cj = ck.markers,
				X = ck.labels,
				ch = cj.background,
				ci = ae({}, cj.border),
				cg = cl.value;
            if (cl._rendered) {
                return
            } else {
                cl._rendered = true
            }
            if (!aj(ci.color)) {
                ci.color = new W(ch).brightness(r).toHex()
            }
            cl.marker = new bE({
                id: b0(),
                visible: cj.visible,
                type: cj.type,
                width: cj.size,
                height: cj.size,
                background: ch,
                border: ci,
                opacity: cj.opacity
            });
            cl.append(cl.marker);
            if (X.visible) {
                if (X.template) {
                    var Y = z(X.template);
                    cg = Y({
                        dataItem: cl.dataItem,
                        category: cl.category,
                        value: cl.value,
                        series: cl.series
                    })
                } else {
                    if (X.format) {
                        cg = cl.formatPointValue(X.format)
                    }
                }
                cl.label = new bP(cg, ae({
                    id: b0(),
                    align: M,
                    vAlign: M,
                    margin: {
                        left: 5,
                        right: 5
                    }
                }, X, {
                    format: ""
                }));
                cl.append(cl.label)
            }
        },
        markerBox: function () {
            return this.marker.box
        },
        reflow: function (cj) {
            var ci = this,
				ch = ci.options,
				cg = ch.isVertical,
				X = ch.aboveAxis,
				Y;
            ci.render();
            ci.box = cj;
            Y = cj.clone();
            if (cg) {
                if (X) {
                    Y.y1 -= Y.height()
                } else {
                    Y.y2 += Y.height()
                }
            } else {
                if (X) {
                    Y.x1 += Y.width()
                } else {
                    Y.x2 -= Y.width()
                }
            }
            ci.marker.reflow(Y);
            ci.reflowLabel(Y)
        },
        reflowLabel: function (X) {
            var cj = this,
				ci = cj.options,
				ch = cj.marker,
				cg = cj.label,
				Y = ci.labels.position;
            if (cg) {
                Y = Y === c ? bV : Y;
                Y = Y === A ? C : Y;
                cg.reflow(X);
                cg.box.alignTo(ch.box, Y);
                cg.reflow(cg.box)
            }
        },
        getViewElements: function (ch) {
            var X = this,
				cg = X.marker,
				Y = X.label;
            X.registerId(cg.options.id);
            if (Y) {
                X.registerId(Y.options.id)
            }
            return P.fn.getViewElements.call(X, ch)
        },
        getOutlineElement: function (ci, cg) {
            var X = this,
				Y = X.marker,
				ch = X.marker.options.id + bb;
            X.registerId(ch);
            cg = ae({}, cg, {
                id: ch
            });
            return Y.getViewElements(ci, ae(cg, {
                fill: Y.options.border.color,
                fillOpacity: 1,
                strokeOpacity: 0
            }))[0]
        },
        tooltipAnchor: function (ci, ch) {
            var cg = this,
				Y = cg.marker.box,
				X = cg.options.aboveAxis;
            return new bm(Y.x2 + bT, X ? Y.y1 - ch : Y.y2)
        },
        formatPointValue: function (X) {
            var Y = this;
            return Y.owner.formatPointValue(Y.value, X)
        }
    });
    var aW = {
        splitSegments: function (cr) {
            var X = this,
				cj = X.options,
				cn = cj.series,
				cq = X.seriesPoints,
				Y, cp, co = cq.length,
				cg, ch, ck, cm, cl, ci = [];
            for (cp = 0; cp < co; cp++) {
                cg = cq[cp];
                cl = cg.length;
                Y = cn[cp];
                ch = [];
                for (cm = 0; cm < cl; cm++) {
                    ck = cg[cm];
                    if (ck) {
                        pointCenter = ck.markerBox().center();
                        ch.push(new bm(pointCenter.x, pointCenter.y))
                    } else {
                        if (Y.missingValues !== aM) {
                            if (ch.length > 1) {
                                ci.push(X.createSegment(b0(), cr, ch, Y, cp))
                            }
                            ch = []
                        }
                    }
                }
                if (ch.length > 1) {
                    ci.push(X.createSegment(b0(), cr, ch, Y, cp))
                }
            }
            return ci
        },
        createSegment: function (X, ci, Y, cg, ch) {
            this.registerId(X, {
                seriesIx: ch
            });
            return ci.createPolyline(Y, false, {
                id: X,
                stroke: cg.color,
                strokeWidth: cg.width,
                strokeOpacity: cg.opacity,
                fill: "",
                dashType: cg.dashType
            })
        },
        getNearestPoint: function (cr, cs, cq) {
            var Y = this,
				ci = Y.options.invertAxes,
				X = ci ? cd : ca,
				cp = ci ? cs : cr,
				cn = Y.seriesPoints[cq],
				ck = a0,
				co = cn.length,
				cg, cl, cm, cj, ch;
            for (ch = 0; ch < co; ch++) {
                cg = cn[ch];
                if (cg && aj(cg.value) && cg.value !== null) {
                    cl = cg.box;
                    cm = aZ.abs(cl.center()[X] - cp);
                    if (cm < ck) {
                        cj = cg;
                        ck = cm
                    }
                }
            }
            return cj
        }
    };
    var aV = H.extend({
        init: function (cg, Y) {
            var X = this;
            X._stackAxisRange = {
                min: a0,
                max: a2
            };
            X._categoryTotals = [];
            H.fn.init.call(X, cg, Y)
        },
        render: function () {
            var X = this;
            H.fn.render.apply(X);
            X.computeAxisRanges()
        },
        createPoint: function (cp, X, Y, cm, cn) {
            var ch = this,
				cj = ch.options,
				ci = cj.isStacked,
				cg = ch.categoryPoints[Y],
				co, ck = 0;
            if (!aj(cp) || cp === null) {
                if (ci || cm.missingValues === ce) {
                    cp = 0
                } else {
                    return null
                }
            }
            var cl = new aX(cp, ae({
                isVertical: !cj.invertAxes,
                markers: {
                    border: {
                        color: cm.color
                    }
                }
            }, cm));
            if (ci) {
                co = aP(cg);
                if (co) {
                    ck = co.plotValue
                }
                cl.plotValue = cp + ck
            }
            ch.append(cl);
            return cl
        },
        updateRange: function (ck, X, ch) {
            var Y = this,
				cg = Y.options.isStacked,
				ci = Y._stackAxisRange,
				cj = Y._categoryTotals;
            if (aj(ck)) {
                if (cg) {
                    aH(cj, X, ck);
                    ci.min = aZ.min(ci.min, bH(cj));
                    ci.max = aZ.max(ci.max, bG(cj))
                } else {
                    H.fn.updateRange.apply(Y, arguments)
                }
            }
        },
        computeAxisRanges: function () {
            var Y = this,
				cg = Y.options.isStacked,
				X, ch = Y._categoryTotals;
            if (cg) {
                X = Y.options.series[0].axis || bo;
                Y.valueAxisRanges[X] = Y._stackAxisRange
            }
        },
        getViewElements: function (ci) {
            var X = this,
				Y = H.fn.getViewElements.call(X, ci),
				cg = ci.createGroup({
				    animation: {
				        type: U
				    }
				}),
				ch = X.splitSegments(ci);
            cg.children = ch.concat(Y);
            return [cg]
        }
    });
    ae(aV.fn, aW);
    var l = aV.extend({
        splitSegments: function (cu) {
            var Y = this,
				cp = Y.options,
				cs = Y.plotArea,
				cj = Y.options.invertAxes,
				cr = aV.fn.splitSegments.call(Y, cu),
				cn = [],
				X = cs.categoryAxis.lineBox(),
				cg = cj ? X.x1 : X.y1,
				cq, co = cr.length,
				ct = 0,
				cm, ch, ck, cl, ci;
            for (ci = 0; ci < co; ci++) {
                line = cr[ci].clone();
                cm = line.points;
                cl = line.options;
                ct = cl.seriesIx;
                if (cl.stack && ct != 0) {
                    if (ct > 0) {
                        cq = cr[ci - 1].clone().points.reverse();
                        line.points = cm.concat(cq)
                    }
                } else {
                    if (cm.length > 1) {
                        ch = cm[0];
                        ck = aP(cm);
                        if (cj) {
                            cm.unshift(new bm(cg, ch.y));
                            cm.push(new bm(cg, ck.y))
                        } else {
                            cm.unshift(new bm(ch.x, cg));
                            cm.push(new bm(ck.x, cg))
                        }
                    }
                }
                cn.push(line)
            }
            return cn
        },
        createSegment: function (Y, cj, cg, ch, ci) {
            var X = ae({}, {
                color: ch.color,
                opacity: ch.opacity
            }, ch.line);
            this.registerId(Y, {
                seriesIx: ci
            });
            return cj.createPolyline(cg, true, {
                id: Y,
                stroke: X.color,
                strokeWidth: X.width,
                strokeOpacity: X.opacity,
                dashType: X.dashType,
                fillOpacity: ch.opacity,
                fill: ch.color,
                seriesIx: ci,
                stack: ch.stack
            })
        }
    });
    var bA = P.extend({
        init: function (cg, Y) {
            var X = this;
            P.fn.init.call(X, Y);
            X.plotArea = cg;
            X.xAxisRanges = {};
            X.yAxisRanges = {};
            X.points = [];
            X.seriesPoints = [];
            X.render()
        },
        options: {
            series: [],
            tooltip: {
                format: "{0}, {1}"
            },
            labels: {
                format: "{0}, {1}"
            }
        },
        render: function () {
            var X = this;
            X.traverseDataPoints(bp(X.addValue, X))
        },
        addValue: function (cj, Y) {
            var X = this,
				cg, ch = Y.seriesIx,
				ci = X.seriesPoints[ch];
            X.updateRange(cj, Y.series);
            cg = X.createPoint(cj, Y.series, ch);
            if (cg) {
                ap(cg, Y)
            }
            X.points.push(cg);
            ci.push(cg)
        },
        updateRange: function (cg, Y) {
            var X = this,
				ch = cg.x,
				ck = cg.y,
				ci = Y.xAxis || bo,
				cl = Y.yAxis || bo,
				cj = X.xAxisRanges[ci],
				cm = X.yAxisRanges[cl];
            if (aj(ch) && ch !== null) {
                cj = X.xAxisRanges[ci] = cj || {
                    min: a0,
                    max: a2
                };
                cj.min = aZ.min(cj.min, ch);
                cj.max = aZ.max(cj.max, ch)
            }
            if (aj(ck) && ck !== null) {
                cm = X.yAxisRanges[cl] = cm || {
                    min: a0,
                    max: a2
                };
                cm.min = aZ.min(cm.min, ck);
                cm.max = aZ.max(cm.max, ck)
            }
        },
        createPoint: function (ci, cg, ch) {
            var X = this,
				Y, cj = ci.x,
				ck = ci.y;
            if (!aj(cj) || cj === null || !aj(ck) || ck === null) {
                return null
            }
            Y = new aX(ci, ae({
                markers: {
                    border: {
                        color: cg.color
                    },
                    opacity: cg.opacity
                },
                tooltip: {
                    format: X.options.tooltip.format
                },
                labels: {
                    format: X.options.labels.format
                }
            }, cg));
            X.append(Y);
            return Y
        },
        seriesAxes: function (Y) {
            var X = this.plotArea,
				cg = Y.xAxis || bo,
				ch = Y.yAxis || bo;
            return {
                x: X.namedXAxes[cg],
                y: X.namedYAxes[ch]
            }
        },
        reflow: function (ck) {
            var X = this,
				cg = X.plotArea,
				Y = X.points,
				ci = 0,
				ch, cj;
            X.traverseDataPoints(function (cp, cl) {
                ch = Y[ci++];
                cj = X.seriesAxes(cl.series);
                var cn = cj.x.getSlot(cp.x, cp.x),
					co = cj.y.getSlot(cp.y, cp.y),
					cm = new D(cn.x1, co.y1, cn.x2, co.y2);
                if (ch) {
                    ch.reflow(cm)
                }
            });
            X.box = ck
        },
        getViewElements: function (ch) {
            var X = this,
				Y = P.fn.getViewElements.call(X, ch),
				cg = ch.createGroup({
				    animation: {
				        type: U
				    }
				});
            cg.children = Y;
            return [cg]
        },
        traverseDataPoints: function (X) {
            var Y = this,
				cj = Y.options,
				cm = cj.series,
				co = Y.seriesPoints,
				cl = 0,
				cn, cg, ch, ci, cp, ck;
            for (cn = 0; cn < cm.length; cn++) {
                cg = cm[cn];
                ch = co[cn];
                if (!ch) {
                    co[cn] = []
                }
                for (cl = 0; cl < cg.data.length; cl++) {
                    ck = cg.data[cl] || [];
                    ci = cg.dataItems;
                    cp = {
                        x: ck[0],
                        y: ck[1]
                    };
                    X(cp, {
                        pointIx: cl,
                        series: cg,
                        seriesIx: cn,
                        dataItem: ci ? ci[cl] : cp,
                        owner: Y
                    })
                }
            }
        },
        formatPointValue: function (Y, X) {
            return av(X, Y.x, Y.y)
        }
    });
    var bB = bA.extend({
        getViewElements: function (ci) {
            var X = this,
				Y = bA.fn.getViewElements.call(X, ci),
				cg = ci.createGroup({
				    animation: {
				        type: U
				    }
				}),
				ch = X.splitSegments(ci);
            cg.children = ch.concat(Y);
            return [cg]
        }
    });
    ae(bB.fn, aW);
    var bk = P.extend({
        init: function (ch, Y, X) {
            var cg = this;
            cg.value = ch;
            cg.sector = Y;
            P.fn.init.call(cg, X)
        },
        options: {
            color: b7,
            overlay: {
                gradient: bx
            },
            border: {
                width: 0.5
            },
            labels: {
                visible: false,
                distance: 35,
                font: af,
                margin: ay(0.5),
                align: Q,
                zIndex: 1,
                position: bd
            },
            animation: {
                type: be
            },
            highlight: {
                visible: true,
                border: {
                    width: 1
                }
            }
        },
        render: function () {
            var ci = this,
				ch = ci.options,
				X = ch.labels,
				cg = ci.value,
				Y;
            if (ci._rendered) {
                return
            } else {
                ci._rendered = true
            }
            if (X.template) {
                Y = z(X.template);
                cg = Y({
                    dataItem: ci.dataItem,
                    category: ci.category,
                    value: ci.value,
                    series: ci.series,
                    percentage: ci.percentage
                })
            }
            if (X.visible && ci.value) {
                ci.label = new bP(cg, ae({}, X, {
                    id: b0(),
                    align: M,
                    vAlign: "",
                    animation: {
                        type: at,
                        delay: ci.categoryIx * bf
                    }
                }));
                ci.append(ci.label);
                ci.registerId(ci.label.options.id)
            }
        },
        reflow: function (Y) {
            var X = this;
            X.render();
            X.box = Y;
            Y.clone();
            X.reflowLabel()
        },
        reflowLabel: function () {
            var cn = this,
				cm = cn.sector.clone(),
				cl = cn.options,
				Y = cn.label,
				ci = cl.labels,
				ch = ci.distance,
				ck, co, X = cm.middle(),
				cj, cg;
            if (Y) {
                cg = Y.box.height();
                cj = Y.box.width();
                if (ci.position == M) {
                    cm.r = aZ.abs((cm.r - cg) / 2) + cg;
                    ck = cm.point(X);
                    Y.reflow(new D(ck.x, ck.y - cg / 2, ck.x, ck.y))
                } else {
                    if (ci.position == aL) {
                        cm.r = cm.r - cg / 2;
                        ck = cm.point(X);
                        Y.reflow(new D(ck.x, ck.y - cg / 2, ck.x, ck.y))
                    } else {
                        ck = cm.clone().expand(ch).point(X);
                        if (ck.x >= cm.c.x) {
                            co = ck.x + cj;
                            Y.orientation = bs
                        } else {
                            co = ck.x - cj;
                            Y.orientation = aQ
                        }
                        Y.reflow(new D(co, ck.y - cg, ck.x, ck.y))
                    }
                }
            }
        },
        getViewElements: function (cl) {
            var ck = this,
				cj = ck.sector,
				ch = ck.options,
				Y = ch.border || {},
				X = Y.width > 0 ? {
				    stroke: Y.color,
				    strokeWidth: Y.width,
				    dashType: Y.dashType
				} : {},
				cg = [],
				ci = ch.overlay;
            if (ci) {
                ci = ae({}, ch.overlay, {
                    r: cj.r,
                    cx: cj.c.x,
                    cy: cj.c.y
                })
            }
            if (ck.value !== 0) {
                cg.push(cl.createSector(cj, ae({
                    id: ch.id,
                    fill: ch.color,
                    overlay: ci,
                    fillOpacity: ch.opacity,
                    strokeOpacity: ch.opacity,
                    animation: ae(ch.animation, {
                        delay: ck.categoryIx * bf
                    })
                }, X)))
            }
            f(cg, P.fn.getViewElements.call(ck, cl));
            return cg
        },
        getOutlineElement: function (ck, ch) {
            var cj = this,
				cg = cj.options.highlight || {},
				X = cg.border || {},
				ci = cj.options.id + bb,
				Y;
            cj.registerId(ci);
            ch = ae({}, ch, {
                id: ci
            });
            if (cj.value) {
                Y = ck.createSector(cj.sector, ae({}, ch, {
                    fill: cg.color,
                    fillOpacity: cg.opacity,
                    strokeOpacity: X.opacity,
                    strokeWidth: X.width,
                    stroke: X.color
                }))
            }
            return Y
        },
        tooltipAnchor: function (cj, ci) {
            var ck = cj / 2,
				X = ci / 2,
				Y = aZ.sqrt((ck * ck) + (X * X)),
				cg = this.sector.clone().expand(Y + bT),
				ch = cg.point(cg.middle());
            return new bm(ch.x - ck, ch.y - X)
        },
        formatPointValue: function (X) {
            var Y = this;
            return Y.owner.formatPointValue(Y.value, X)
        }
    });
    var bi = P.extend({
        init: function (cg, Y) {
            var X = this;
            P.fn.init.call(X, Y);
            X.plotArea = cg;
            X.segments = [];
            X.seriesPoints = [];
            X.render()
        },
        options: {
            startAngle: 90,
            padding: 60,
            connectors: {
                width: 1,
                color: "#939393",
                padding: 4
            }
        },
        render: function () {
            var X = this;
            X.traverseDataPoints(bp(X.addValue, X))
        },
        traverseDataPoints: function (cg) {
            var ch = this,
				cr = ch.options,
				ci = ch.plotArea.options.seriesColors || [],
				cu = cr.startAngle,
				cj = ci.length,
				cs = cr.series,
				co, cl, cm, ck, ct, X, cn, Y, cw, cp, cv, cq;
            for (ct = 0; ct < cs.length; ct++) {
                cm = cs[ct];
                co = cm.dataItems;
                cn = cm.data;
                cv = ch.pointsTotal(cn);
                Y = 360 / cv;
                for (cq = 0; cq < cn.length; cq++) {
                    ck = ch.pointData(cm, cq);
                    cw = ck.value;
                    X = bw(cw * Y, ah);
                    cl = ck.category;
                    cp = cn.length != 1 && !!ck.explode;
                    cm.color = ck.color ? ck.color : ci[cq % cj];
                    cg(cw, new bC(null, 0, cu, X), {
                        owner: ch,
                        category: cl,
                        categoryIx: cq,
                        series: cm,
                        seriesIx: ct,
                        dataItem: co ? co[cq] : {
                            value: ck
                        },
                        percentage: cw / cv,
                        explode: cp,
                        currentData: ck
                    });
                    cu += X
                }
            }
        },
        addValue: function (ci, cg, Y) {
            var X = this,
				ch;
            ch = new bk(ci, cg, Y.series);
            ch.options.id = b0();
            ap(ch, Y);
            X.append(ch);
            X.segments.push(ch)
        },
        pointValue: function (X) {
            return aj(X.value) ? X.value : X
        },
        pointData: function (ch, cg) {
            var X = this,
				Y = ch.data[cg];
            return {
                value: X.pointValue(Y),
                category: X.pointGetter(ch, cg, "category"),
                color: X.pointGetter(ch, cg, "color"),
                explode: X.pointGetter(ch, cg, "explode")
            }
        },
        pointGetter: function (ch, Y, cg) {
            var cj = ch[cg + "Field"],
				X = ch.data[Y],
				ci = X[cg];
            if (cj && ch.dataItems) {
                return aw(cj, ch.dataItems[Y])
            } else {
                return aj(ci) ? ci : ""
            }
        },
        pointsTotal: function (Y) {
            var X = this,
				ch = Y.length,
				ci = 0,
				cg;
            for (cg = 0; cg < ch; cg++) {
                ci += X.pointValue(Y[cg])
            }
            return ci
        },
        reflow: function (cv) {
            var cg = this,
				co = cg.options,
				X = cv.clone(),
				cl = aZ.min(X.width(), X.height()),
				cu = 5,
				cp = co.padding > cl / 2 - cu ? cl / 2 - cu : co.padding,
				cm = new D(X.x1, X.y1, X.x1 + cl, X.y1 + cl),
				cn = cm.center(),
				Y = X.center(),
				ct = cg.segments,
				ch = ct.length,
				ck = [],
				cq = [],
				cj, cs, cr, ci;
            cm.translate(Y.x - cn.x, Y.y - cn.y);
            for (ci = 0; ci < ch; ci++) {
                cs = ct[ci];
                cr = cs.sector;
                cr.r = cl / 2 - cp;
                cr.c = new bm(cr.r + cm.x1 + cp, cr.r + cm.y1 + cp);
                if (cs.explode) {
                    cr.c = cr.clone().radius(cr.r * 0.15).point(cr.middle())
                }
                cs.reflow(cm);
                cj = cs.label;
                if (cj) {
                    if (cj.options.position === bd) {
                        if (cj.orientation === bs) {
                            cq.push(cj)
                        } else {
                            ck.push(cj)
                        }
                    }
                }
            }
            if (ck.length > 0) {
                ck.sort(cg.labelComparator(true));
                cg.leftLabelsReflow(ck)
            }
            if (cq.length > 0) {
                cq.sort(cg.labelComparator(false));
                cg.rightLabelsReflow(cq)
            }
            cg.box = cm
        },
        leftLabelsReflow: function (cg) {
            var X = this,
				Y = X.distanceBetweenLabels(cg);
            X.distributeLabels(Y, cg)
        },
        rightLabelsReflow: function (cg) {
            var X = this,
				Y = X.distanceBetweenLabels(cg);
            X.distributeLabels(Y, cg)
        },
        distanceBetweenLabels: function (ck) {
            var X = this,
				co = X.segments[0],
				cn = co.sector,
				ci = ck[0].box,
				cm, Y = ck.length - 1,
				ch = [],
				cg, cl = cn.r + co.options.labels.distance,
				cj;
            cg = bw(ci.y1 - (cn.c.y - cl - ci.height() - ci.height() / 2));
            ch.push(cg);
            for (cj = 0; cj < Y; cj++) {
                ci = ck[cj].box;
                cm = ck[cj + 1].box;
                cg = bw(cm.y1 - ci.y2);
                ch.push(cg)
            }
            cg = bw(cn.c.y + cl - ck[Y].box.y2 - ck[Y].box.height() / 2);
            ch.push(cg);
            return ch
        },
        distributeLabels: function (cg, ci) {
            var X = this,
				Y = cg.length,
				ck, cj, cl, ch;
            for (ch = 0; ch < Y; ch++) {
                cj = cl = ch;
                ck = -cg[ch];
                while (ck > 0 && (cj >= 0 || cl < Y)) {
                    ck = X._takeDistance(cg, ch, --cj, ck);
                    ck = X._takeDistance(cg, ch, ++cl, ck)
                }
            }
            X.reflowLabels(cg, ci)
        },
        _takeDistance: function (ch, Y, ci, X) {
            if (ch[ci] > 0) {
                var cg = aZ.min(ch[ci], X);
                X -= cg;
                ch[ci] -= cg;
                ch[Y] += cg
            }
            return X
        },
        reflowLabels: function (ci, cn) {
            var ch = this,
				cr = ch.segments,
				cq = cr[0],
				cp = cq.sector,
				co = cn.length,
				cm = cq.options.labels,
				cl = cm.distance,
				cg = cp.c.y - (cp.r + cl) - cn[0].box.height(),
				ck, Y, X, cj;
            ci[0] += 2;
            for (cj = 0; cj < co; cj++) {
                ck = cn[cj];
                cg += ci[cj];
                X = ck.box;
                Y = ch.hAlignLabel(X.x2, cp.clone().expand(cl), cg, cg + X.height(), ck.orientation == bs);
                if (ck.orientation == bs) {
                    if (cm.align !== Q) {
                        Y = cp.r + cp.c.x + cl
                    }
                    ck.reflow(new D(Y + X.width(), cg, Y, cg))
                } else {
                    if (cm.align !== Q) {
                        Y = cp.c.x - cp.r - cl
                    }
                    ck.reflow(new D(Y - X.width(), cg, Y, cg))
                }
                cg += X.height()
            }
        },
        getViewElements: function (cA) {
            var ch = this,
				cr = ch.options,
				cj = cr.connectors,
				cv = ch.segments,
				ci, ct, ck = cv.length,
				cx = 4,
				X, cp = [],
				cs, cu, cw, co, cn;
            for (cn = 0; cn < ck; cn++) {
                cu = cv[cn];
                ct = cu.sector;
                X = ct.middle();
                co = cu.label;
                cw = {
                    seriesId: cu.seriesIx
                };
                if (co) {
                    cs = [];
                    if (co.options.position === bd && cu.value !== 0) {
                        var Y = co.box,
							cg = ct.c,
							cz = ct.point(X),
							cq = new bm(Y.x1, Y.center().y),
							cy, cm, cl;
                        cz = ct.clone().expand(cj.padding).point(X);
                        cs.push(cz);
                        if (co.orientation == bs) {
                            cm = new bm(Y.x1 - cj.padding, Y.center().y);
                            cl = aO(cg, cz, cq, cm);
                            cq = new bm(cm.x - cx, cm.y);
                            cl = cl || cq;
                            cl.x = aZ.min(cl.x, cq.x);
                            if (ch.pointInCircle(cl, ct.c, ct.r + cx) || cl.x < ct.c.x) {
                                cy = ct.c.x + ct.r + cx;
                                if (cu.options.labels.align !== Z) {
                                    if (cy < cq.x) {
                                        cs.push(new bm(cy, cz.y))
                                    } else {
                                        cs.push(new bm(cz.x + cx * 2, cz.y))
                                    }
                                } else {
                                    cs.push(new bm(cy, cz.y))
                                }
                                cs.push(new bm(cq.x, cm.y))
                            } else {
                                cl.y = cm.y;
                                cs.push(cl)
                            }
                        } else {
                            cm = new bm(Y.x2 + cj.padding, Y.center().y);
                            cl = aO(cg, cz, cq, cm);
                            cq = new bm(cm.x + cx, cm.y);
                            cl = cl || cq;
                            cl.x = aZ.max(cl.x, cq.x);
                            if (ch.pointInCircle(cl, ct.c, ct.r + cx) || cl.x > ct.c.x) {
                                cy = ct.c.x - ct.r - cx;
                                if (cu.options.labels.align !== Z) {
                                    if (cy > cq.x) {
                                        cs.push(new bm(cy, cz.y))
                                    } else {
                                        cs.push(new bm(cz.x - cx * 2, cz.y))
                                    }
                                } else {
                                    cs.push(new bm(cy, cz.y))
                                }
                                cs.push(new bm(cq.x, cm.y))
                            } else {
                                cl.y = cm.y;
                                cs.push(cl)
                            }
                        }
                        cs.push(cm);
                        ci = cA.createPolyline(cs, false, {
                            id: b0(),
                            stroke: cj.color,
                            strokeWidth: cj.width,
                            animation: {
                                type: at,
                                delay: cu.categoryIx * bf
                            }
                        });
                        cp.push(ci);
                        cu.registerId(ci.options.id, cw)
                    }
                    cu.registerId(co.options.id, cw)
                }
                cu.registerId(cu.options.id, cw)
            }
            f(cp, P.fn.getViewElements.call(ch, cA));
            return cp
        },
        labelComparator: function (X) {
            X = (X) ? -1 : 1;
            return function (Y, cg) {
                Y = (Y.parent.sector.middle() + 270) % 360;
                cg = (cg.parent.sector.middle() + 270) % 360;
                return (Y - cg) * X
            }
        },
        hAlignLabel: function (ch, cj, cl, cm, cg) {
            var X = cj.c.x,
				Y = cj.c.y,
				ci = cj.r,
				ck = aZ.min(aZ.abs(Y - cl), aZ.abs(Y - cm));
            if (ck > ci) {
                return ch
            } else {
                return X + aZ.sqrt((ci * ci) - (ck * ck)) * (cg ? 1 : -1)
            }
        },
        pointInCircle: function (Y, X, cg) {
            return bI(X.x - Y.x) + bI(X.y - Y.y) < bI(cg)
        },
        formatPointValue: function (Y, X) {
            return av(X, Y)
        }
    });
    var bl = P.extend({
        init: function (cg, X) {
            var Y = this;
            P.fn.init.call(Y, X);
            Y.series = cg;
            Y.charts = [];
            Y.options.legend.items = [];
            Y.axes = [];
            Y.render()
        },
        options: {
            series: [],
            plotArea: {
                margin: {}
            },
            background: "",
            border: {
                color: B,
                width: 0
            },
            legend: {}
        },
        appendChart: function (X) {
            var Y = this;
            Y.charts.push(X);
            Y.addToLegend(X);
            Y.append(X)
        },
        addToLegend: function (X) {
            var ci = X.options.series,
				Y = ci.length,
				cg = [],
				ch;
            for (ch = 0; ch < Y; ch++) {
                cg.push({
                    name: ci[ch].name || "",
                    color: ci[ch].color
                })
            }
            f(this.options.legend.items, cg)
        },
        reflow: function (ch) {
            var cg = this,
				Y = cg.options.plotArea,
				X = ay(Y.margin);
            cg.box = ch.clone();
            cg.box.unpad(X);
            if (cg.axes.length > 0) {
                cg.reflowAxes();
                cg.box = cg.axisBox()
            }
            cg.reflowCharts()
        },
        axisCrossingValues: function (X, Y) {
            var cj = X.options,
				cg = [].concat(cj.axisCrossingValue),
				ck = Y.length - cg.length,
				ch = cg[0] || 0,
				ci;
            for (ci = 0; ci < ck; ci++) {
                cg.push(ch)
            }
            return cg
        },
        alignAxisTo: function (X, ci, Y, cj) {
            var cg = X.getSlot(Y, Y),
				ch = X.options.reverse ? 2 : 1,
				cl = ci.getSlot(cj, cj),
				ck = ci.options.reverse ? 2 : 1;
            X.reflow(X.box.translate(cl[ca + ck] - cg[ca + ch], cl[cd + ck] - cg[cd + ch]))
        },
        alignAxes: function (co, cr) {
            var cj = this,
				cm = co[0],
				cp = cr[0],
				cn = cj.axisCrossingValues(cm, cr),
				cq = cj.axisCrossingValues(cp, co),
				ci, ck, cl, cg, X, Y, ch;
            for (ch = 0; ch < cr.length; ch++) {
                X = cr[ch];
                cj.alignAxisTo(X, cm, cq[ch], cn[ch]);
                if (X.lineBox().x1 === cm.lineBox().x1) {
                    if (ci) {
                        X.reflow(X.box.alignTo(ci.box, aQ).translate(-X.options.margin, 0))
                    }
                    ci = X
                }
                if (X.lineBox().x2 === cm.lineBox().x2) {
                    if (!X._mirrored) {
                        X.options.labels.mirror = !X.options.labels.mirror;
                        X._mirrored = true
                    }
                    cj.alignAxisTo(X, cm, cq[ch], cn[ch]);
                    if (ck) {
                        X.reflow(X.box.alignTo(ck.box, bs).translate(X.options.margin, 0))
                    }
                    ck = X
                }
            }
            for (ch = 0; ch < co.length; ch++) {
                X = co[ch];
                cj.alignAxisTo(X, cp, cn[ch], cq[ch]);
                if (X.lineBox().y1 === cp.lineBox().y1) {
                    if (!X._mirrored) {
                        X.options.labels.mirror = !X.options.labels.mirror;
                        X._mirrored = true
                    }
                    cj.alignAxisTo(X, cp, cn[ch], cq[ch]);
                    if (cl) {
                        X.reflow(X.box.alignTo(cl.box, bV).translate(0, -X.options.margin))
                    }
                    cl = X
                }
                if (X.lineBox().y2 === cp.lineBox().y2) {
                    if (cg) {
                        X.reflow(X.box.alignTo(cg.box, C).translate(0, X.options.margin))
                    }
                    cg = X
                }
            }
        },
        axisBox: function () {
            var ci = this,
				X = ci.axes,
				Y = X[0].box.clone(),
				cg, ch = X.length;
            for (cg = 1; cg < ch; cg++) {
                Y.wrap(X[cg].box)
            }
            return Y
        },
        shrinkAxes: function () {
            var cn = this,
				cg = cn.box,
				Y = cn.axisBox(),
				cm = Y.height() - cg.height(),
				cl = Y.width() - cg.width(),
				X = cn.axes,
				ch, cj, ci, ck = X.length;
            for (ci = 0; ci < ck; ci++) {
                ch = X[ci];
                cj = ch.options.isVertical;
                ch.reflow(ch.box.shrink(cj ? 0 : cl, cj ? cm : 0))
            }
        },
        shrinkAdditionalAxes: function (cp, cr) {
            var cn = this,
				Y = cn.axes,
				co = cp[0],
				cq = cr[0],
				X = co.lineBox().clone().wrap(cq.lineBox()),
				cl, cm, cg, ci, ck, ch, cj = Y.length;
            for (ch = 0; ch < cj; ch++) {
                cg = Y[ch];
                ci = cg.options.isVertical;
                ck = cg.lineBox();
                cl = aZ.max(0, ck.x2 - X.x2) + aZ.max(0, X.x1 - ck.x1);
                cm = aZ.max(0, ck.y2 - X.y2) + aZ.max(0, X.y1 - ck.y1);
                cg.reflow(cg.box.shrink(ci ? 0 : cl, ci ? cm : 0))
            }
        },
        fitAxes: function () {
            var cm = this,
				X = cm.axes,
				cg = cm.box,
				Y = cm.axisBox(),
				ck = cg.x1 - Y.x1,
				cl = cg.y1 - Y.y1,
				ch, ci, cj = X.length;
            for (ci = 0; ci < cj; ci++) {
                ch = X[ci];
                ch.reflow(ch.box.translate(ck, cl))
            }
        },
        reflowAxes: function () {
            var ch = this,
				X = ch.axes,
				ci = aB(X, (function (ck) {
				    return !ck.options.isVertical
				})),
				cj = aB(X, (function (ck) {
				    return ck.options.isVertical
				})),
				Y, cg = X.length;
            for (Y = 0; Y < cg; Y++) {
                X[Y].reflow(ch.box)
            }
            ch.alignAxes(ci, cj);
            ch.shrinkAdditionalAxes(ci, cj);
            ch.alignAxes(ci, cj);
            ch.shrinkAxes();
            ch.alignAxes(ci, cj);
            ch.fitAxes()
        },
        reflowCharts: function () {
            var ci = this,
				Y = ci.charts,
				cg = Y.length,
				X = ci.box,
				ch;
            for (ch = 0; ch < cg; ch++) {
                Y[ch].reflow(X)
            }
            ci.box = X
        },
        renderGridLines: function (cq, X, cp) {
            var cn = X.options,
				ci = cn.isVertical,
				Y = X.getSlot(cn.axisCrossingValue),
				co = bw(Y[ci ? "y1" : "x1"]),
				cj = cp.lineBox(),
				cl = cj[ci ? "x1" : "y1"],
				ck = cj[ci ? "x2" : "y2"],
				cm = X.getMajorTickPositions(),
				ch = [],
				cg = function (cs, cr) {
				    return {
				        pos: cs,
				        options: cr
				    }
				};
            if (cn.majorGridLines.visible) {
                ch = aY(cm, function (cr) {
                    return cg(cr, cn.majorGridLines)
                })
            }
            if (cn.minorGridLines.visible) {
                ch = ch.concat(aY(X.getMinorTickPositions(), function (cr) {
                    if (cn.majorGridLines.visible) {
                        if (!aG(cr, cm)) {
                            return cg(cr, cn.minorGridLines)
                        }
                    } else {
                        return cg(cr, cn.minorGridLines)
                    }
                }))
            }
            return aY(ch, function (cs) {
                var cr = {
                    strokeWidth: cs.options.width,
                    stroke: cs.options.color,
                    dashType: cs.options.dashType
                },
					ct = bw(cs.pos);
                if (co === ct && cp.options.line.visible) {
                    return null
                }
                if (ci) {
                    return cq.createLine(cl, ct, ck, ct, cr)
                } else {
                    return cq.createLine(ct, cl, ct, ck, cr)
                }
            })
        },
        getViewElements: function (cn) {
            var cm = this,
				cl = cm.options.plotArea,
				Y = cm.axisY,
				X = cm.axisX,
				ck = Y ? cm.renderGridLines(cn, Y, X) : [],
				cj = X ? cm.renderGridLines(cn, X, Y) : [],
				ch = P.fn.getViewElements.call(cm, cn),
				cg = cl.border || {},
				ci = [cn.createRect(cm.box, {
				    fill: cl.background,
				    zIndex: -1
				}), cn.createRect(cm.box, {
				    stroke: cg.width ? cg.color : "",
				    strokeWidth: cg.width,
				    fill: "",
				    zIndex: 0,
				    dashType: cg.dashType
				})];
            return [].concat(ck, cj, ch, ci)
        }
    });
    var I = bl.extend({
        init: function (ch, Y) {
            var cg = this,
				X = ae({}, cg.options, Y);
            cg.namedValueAxes = {};
            cg.valueAxisRangeTracker = new o(X.valueAxis);
            if (ch.length > 0) {
                cg.invertAxes = aG(ch[0].type, [q, b4, b3])
            }
            bl.fn.init.call(cg, ch, Y)
        },
        options: {
            categoryAxis: {
                categories: []
            },
            valueAxis: {}
        },
        render: function () {
            var X = this,
				Y = X.series;
            X.createAreaChart(aB(Y, function (cg) {
                return aG(cg.type, [k, b3])
            }));
            X.createBarChart(aB(Y, function (cg) {
                return aG(cg.type, [q, Z])
            }));
            X.createLineChart(aB(Y, function (cg) {
                return aG(cg.type, [aS, b4])
            }));
            X.createAxes()
        },
        appendChart: function (cg) {
            var ci = this,
				ch = ci.options,
				cj = cg.options.series,
				X = ch.categoryAxis.categories,
				Y = aZ.max(0, J(cj) - X.length);
            f(X, new Array(Y));
            ci.valueAxisRangeTracker.update(cg.valueAxisRanges);
            bl.fn.appendChart.call(ci, cg)
        },
        createBarChart: function (ci) {
            if (ci.length === 0) {
                return
            }
            var ch = this,
				cg = ch.options,
				Y = ci[0],
				X = new w(ch, {
				    series: ci,
				    invertAxes: ch.invertAxes,
				    isStacked: Y.stack,
				    gap: Y.gap,
				    spacing: Y.spacing
				});
            ch.appendChart(X)
        },
        createLineChart: function (ci) {
            if (ci.length === 0) {
                return
            }
            var ch = this,
				cg = ch.options,
				X = ci[0],
				Y = new aV(ch, {
				    invertAxes: ch.invertAxes,
				    isStacked: X.stack,
				    series: ci
				});
            ch.appendChart(Y)
        },
        createAreaChart: function (ci) {
            if (ci.length === 0) {
                return
            }
            var ch = this,
				cg = ch.options,
				Y = ci[0],
				X = new l(ch, {
				    invertAxes: ch.invertAxes,
				    isStacked: Y.stack,
				    series: ci
				});
            ch.appendChart(X)
        },
        createAxes: function () {
            var cl = this,
				ck = cl.options,
				cn, ci = cl.invertAxes,
				cg = ck.categoryAxis.categories.length,
				ch = new K(ae({
				    isVertical: ci,
				    axisCrossingValue: ci ? cg : 0
				}, ck.categoryAxis)),
				X, Y, cj = cl.namedValueAxes,
				co = [].concat(ck.valueAxis),
				cm;
            am(co, function () {
                Y = this.name || bo;
                cn = cl.valueAxisRangeTracker.query(Y);
                X = cj[Y] = new a8(cn.min, cn.max, ae({
                    isVertical: !ci
                }, this));
                cl.axes.push(X);
                cl.append(X)
            });
            cm = cj[bo] || cl.axes[0];
            cl.axisX = ci ? cm : ch;
            cl.axisY = ci ? ch : cm;
            cl.categoryAxis = ch;
            cl.axes.push(ch);
            cl.append(cl.categoryAxis)
        }
    });
    var o = R.extend({
        init: function (X) {
            var Y = this;
            Y.axisRanges = {}, Y.axisOptions = [].concat(X), Y.defaultRange = {
                min: 0,
                max: 1
            }
        },
        update: function (ci) {
            var cn = this,
				ch = cn.axisRanges,
				cg = cn.axisOptions,
				cm, cj, ck, X, Y, cl = cg.length;
            if (!ci) {
                return
            }
            for (ck = 0; ck < cl; ck++) {
                X = cg[ck];
                Y = X.name || bo;
                cm = ch[Y];
                cj = ci[Y];
                if (cj) {
                    ch[Y] = cm = cm || {
                        min: a0,
                        max: a2
                    };
                    cm.min = aZ.min(cm.min, cj.min);
                    cm.max = aZ.max(cm.max, cj.max)
                }
            }
        },
        query: function (X) {
            var Y = this;
            return Y.axisRanges[X] || ae({}, Y.defaultRange)
        }
    });
    var cc = bl.extend({
        init: function (ch, Y) {
            var cg = this,
				X = ae({}, cg.options, Y);
            cg.namedXAxes = {};
            cg.namedYAxes = {};
            cg.xAxisRangeTracker = new o(X.xAxis);
            cg.yAxisRangeTracker = new o(X.yAxis);
            bl.fn.init.call(cg, ch, Y)
        },
        options: {
            xAxis: {},
            yAxis: {}
        },
        render: function () {
            var X = this,
				Y = X.series;
            X.createScatterChart(aB(Y, function (cg) {
                return cg.type === by
            }));
            X.createScatterLineChart(aB(Y, function (cg) {
                return cg.type === bz
            }));
            X.createAxes()
        },
        appendChart: function (X) {
            var Y = this;
            Y.xAxisRangeTracker.update(X.xAxisRanges);
            Y.yAxisRangeTracker.update(X.yAxisRanges);
            bl.fn.appendChart.call(Y, X)
        },
        createScatterChart: function (Y) {
            var X = this;
            if (Y.length > 0) {
                X.appendChart(new bA(X, {
                    series: Y
                }))
            }
        },
        createScatterLineChart: function (Y) {
            var X = this;
            if (Y.length > 0) {
                X.appendChart(new bB(X, {
                    series: Y
                }))
            }
        },
        createXYAxis: function (cj, ch) {
            var ck = this,
				Y = cj.name || bo,
				ci = ch ? ck.namedYAxes : ck.namedXAxes,
				cg = ch ? ck.yAxisRanges : ck.xAxisRanges,
				cm = ch ? ck.yAxisRangeTracker : ck.xAxisRangeTracker,
				cl = cm.query(Y),
				cj = ae({}, cj, {
				    isVertical: ch
				}),
				X = new a8(cl.min, cl.max, cj);
            ci[Y] = X;
            ck.append(X);
            ck.axes.push(X)
        },
        createAxes: function () {
            var Y = this,
				X = Y.options,
				cg = [].concat(X.xAxis),
				ch = [].concat(X.yAxis);
            am(cg, function () {
                Y.createXYAxis(this, false)
            });
            am(ch, function () {
                Y.createXYAxis(this, true)
            });
            Y.axisX = Y.namedXAxes.primary || Y.namedXAxes[cg[0].name];
            Y.axisY = Y.namedYAxes.primary || Y.namedYAxes[ch[0].name]
        }
    });
    var bj = bl.extend({
        render: function () {
            var X = this,
				Y = X.series;
            X.createPieChart(Y)
        },
        createPieChart: function (ch) {
            var cg = this,
				X = ch[0],
				Y = new bi(cg, {
				    series: ch,
				    padding: X.padding,
				    startAngle: X.startAngle,
				    connectors: X.connectors
				});
            cg.appendChart(Y)
        },
        addToLegend: function (X) {
            var ci = this,
				ch = ci.options,
				cj = X.segments,
				Y = cj.length,
				cg;
            for (cg = 0; cg < Y; cg++) {
                ch.legend.items.push({
                    name: cj[cg].category,
                    color: cj[cg].options.color
                })
            }
        }
    });
    var b6 = R.extend({
        init: function (Y) {
            var X = this;
            X.children = [];
            X.options = ae({}, X.options, Y)
        },
        render: function () {
            return this.template(this)
        },
        renderContent: function () {
            var Y = this,
				ch = "",
				ci = Y.sortChildren(),
				X = ci.length,
				cg;
            for (cg = 0; cg < X; cg++) {
                ch += ci[cg].render()
            }
            return ch
        },
        sortChildren: function () {
            var Y = this,
				X = Y.children,
				ch, cg;
            for (cg = 0, ch = X.length; cg < ch; cg++) {
                X[cg]._childIndex = cg
            }
            return X.slice(0).sort(Y.compareChildren)
        },
        refresh: a.noop,
        compareChildren: function (X, cg) {
            var Y = X.options.zIndex || 0,
				ch = cg.options.zIndex || 0;
            if (Y !== ch) {
                return Y - ch
            }
            return X._childIndex - cg._childIndex
        },
        renderAttr: function (X, Y) {
            return aj(Y) ? " " + X + "='" + Y + "' " : ""
        }
    });
    var b5 = b6.extend({
        init: function (X) {
            var Y = this;
            b6.fn.init.call(Y, X);
            Y.definitions = {};
            Y.decorators = [];
            Y.animations = []
        },
        renderDefinitions: function () {
            var Y = this.definitions,
				X, cg = "";
            for (X in Y) {
                if (Y.hasOwnProperty(X)) {
                    cg += Y[X].render()
                }
            }
            return cg
        },
        decorate: function (cg) {
            var Y = this.decorators,
				ch, ci = Y.length,
				X;
            for (ch = 0; ch < ci; ch++) {
                X = Y[ch];
                this._decorateChildren(X, cg);
                cg = X.decorate.call(X, cg)
            }
            return cg
        },
        _decorateChildren: function (Y, cg) {
            var cj = this,
				X = cg.children,
				ch, ci = X.length;
            for (ch = 0; ch < ci; ch++) {
                cj._decorateChildren(Y, X[ch]);
                X[ch] = Y.decorate.call(Y, X[ch])
            }
        },
        setupAnimations: function () {
            var X = this.animations,
				cg, Y = X.length;
            for (cg = 0; cg < Y; cg++) {
                X[cg].setup()
            }
        },
        playAnimations: function () {
            var X;
            while (X = this.animations.shift()) {
                X.play()
            }
        },
        buildGradient: function (ch) {
            var cj = this,
				X = cj._gradientCache,
				cg, ci, Y;
            if (!X) {
                X = cj._gradientCache = []
            }
            if (ch) {
                cg = ax(ch);
                ci = X[cg];
                Y = O.Gradients[ch.gradient];
                if (!ci && Y) {
                    ci = ae({
                        id: b0()
                    }, Y, ch);
                    X[cg] = ci
                }
            }
            return ci
        }
    });

    function bL() {
        return al.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1")
    }
    var an = R.extend({
        init: function (Y, cg) {
            var X = this;
            X.options = ae({}, X.options, cg);
            X.element = Y
        },
        options: {
            duration: aI,
            easing: bM
        },
        play: function () {
            var X = this,
				cm = X.options,
				ck = X.element,
				Y = cm.delay || 0,
				co = +new Date() + Y,
				ch = cm.duration,
				cl = co + ch,
				cg = al.getElementById(ck.options.id),
				ci = a.easing[cm.easing],
				cq, cp, cn, cj;
            setTimeout(function () {
                var cr = function () {
                    cq = +new Date();
                    cp = aZ.min(cq - co, ch);
                    cn = cp / ch;
                    cj = ci(cn, cp, 0, 1, ch);
                    X.step(cj);
                    ck.refresh(cg);
                    if (cq < cl) {
                        br(cr, cg)
                    }
                };
                cr()
            }, Y)
        },
        setup: a6,
        step: a6
    });
    var aq = an.extend({
        options: {
            duration: 200,
            easing: aU
        },
        setup: function () {
            var X = this,
				Y = X.element.options;
            X.targetFillOpacity = Y.fillOpacity;
            X.targetStrokeOpacity = Y.strokeOpacity;
            Y.fillOpacity = Y.strokeOpacity = 0
        },
        step: function (cg) {
            var X = this,
				Y = X.element.options;
            Y.fillOpacity = cg * X.targetFillOpacity;
            Y.strokeOpacity = cg * X.targetStrokeOpacity
        }
    });
    var ao = an.extend({
        options: {
            size: 0,
            easing: aU
        },
        setup: function () {
            var X = this.element.points;
            X[1].x = X[2].x = X[0].x
        },
        step: function (cg) {
            var X = this.options,
				ch = aN(0, X.size, cg),
				Y = this.element.points;
            Y[1].x = Y[2].x = Y[0].x + ch
        }
    });
    var br = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame ||
	function (X, Y) {
	    setTimeout(X, d)
	};
    var u = an.extend({
        options: {
            easing: bM
        },
        setup: function () {
            var Y = this,
				ch = Y.element,
				ck = ch.points,
				cj = ch.options,
				cg = cj.isVertical ? cd : ca,
				cl = cj.stackBase,
				X = cj.aboveAxis,
				cm, ci = Y.endState = {
				    top: ck[0].y,
				    right: ck[1].x,
				    bottom: ck[3].y,
				    left: ck[0].x
				};
            if (cg === cd) {
                cm = aj(cl) ? cl : ci[X ? C : bV]
            } else {
                cm = aj(cl) ? cl : ci[X ? aQ : bs]
            }
            Y.startPosition = cm;
            b1(ck, cg, cm)
        },
        step: function (ci) {
            var X = this,
				cj = X.startPosition,
				cg = X.endState,
				Y = X.element,
				ch = Y.points;
            if (Y.options.isVertical) {
                ch[0].y = ch[1].y = aN(cj, cg.top, ci);
                ch[2].y = ch[3].y = aN(cj, cg.bottom, ci)
            } else {
                ch[0].x = ch[3].x = aN(cj, cg.left, ci);
                ch[1].x = ch[2].x = aN(cj, cg.right, ci)
            }
        }
    });
    var bg = an.extend({
        options: {
            easing: "easeOutElastic",
            duration: aI
        },
        setup: function () {
            var X = this.element.config;
            this.endRadius = X.r;
            X.r = 0
        },
        step: function (Y) {
            var X = this.endRadius,
				cg = this.element.config;
            cg.r = aN(0, X, Y)
        }
    });

    function e(X, Y) {
        return R.extend({
            init: function (cg) {
                this.view = cg
            },
            decorate: function (ci) {
                var ch = this,
					cj = ch.view,
					cg = ci.options.animation;
                if (cg && cg.type === X && cj.options.transitions) {
                    cj.animations.push(new Y(ci, cg))
                }
                return ci
            }
        })
    }
    var v = e(q, u),
		bh = e(be, bg),
		ar = e(at, aq);
    var aD = R.extend({
        init: function (cg, ch, Y) {
            var X = this;
            X.options = ae({}, X.options, Y);
            X.view = cg;
            X.viewElement = ch
        },
        options: {
            fill: b7,
            fillOpacity: 0.2,
            stroke: b7,
            strokeWidth: 1,
            strokeOpacity: 0.2
        },
        show: function (ch) {
            var Y = this,
				ci = Y.view,
				cj = Y.viewElement,
				cg, X;
            Y.hide();
            if (ch.getOutlineElement) {
                cg = ch.getOutlineElement(ci, Y.options);
                if (cg) {
                    X = ci.renderElement(cg);
                    cj.appendChild(X);
                    Y.element = X;
                    Y.visible = true
                }
            }
        },
        hide: function () {
            var Y = this,
				X = Y.element;
            if (X) {
                if (X.parentNode) {
                    X.parentNode.removeChild(X)
                }
                delete Y.element;
                Y.visible = false
            }
        }
    });
    var bR = R.extend({
        init: function (X, Y) {
            var cg = this;
            cg.options = ae({}, cg.options, Y);
            Y = cg.options;
            cg.chartElement = X;
            cg.chartPadding = {
                top: parseInt(X.css("paddingTop"), 10),
                left: parseInt(X.css("paddingLeft"), 10)
            };
            cg.template = bR.template;
            if (!cg.template) {
                cg.template = bR.template = bN("<div style='display:none; position: absolute; font: #= d.font #;border-radius: 4px; -moz-border-radius: 4px; -webkit-border-radius: 4px;border: #= d.border.width #px solid;opacity: #= d.opacity #; filter: alpha(opacity=#= d.opacity * 100 #);padding: 2px 6px; white-space: nowrap; z-index: 1000;'></div>")
            }
            cg.element = a(cg.template(cg.options)).appendTo(X)
        },
        options: {
            background: B,
            color: b7,
            border: {
                width: 3
            },
            opacity: 1,
            animation: {
                duration: bS
            }
        },
        show: function (X) {
            var Y = this;
            Y.point = X;
            Y.showTimeout = setTimeout(bp(Y._show, Y), bU)
        },
        _show: function () {
            var cm = this,
				ck = cm.point,
				ch = cm.element,
				cj = cm.options,
				Y = cm.chartPadding,
				X, cl, cg, cn, co, ci;
            if (!ck) {
                return
            }
            cg = ck.value.toString();
            cn = ae({}, cm.options, ck.options.tooltip);
            if (cn.template) {
                cl = z(cn.template);
                cg = cl({
                    value: ck.value,
                    category: ck.category,
                    series: ck.series,
                    dataItem: ck.dataItem,
                    percentage: ck.percentage
                })
            } else {
                if (cn.format) {
                    cg = ck.formatPointValue(cn.format)
                }
            }
            ch.html(cg);
            X = ck.tooltipAnchor(ch.outerWidth(), ch.outerHeight());
            co = bw(X.y + Y.top) + "px";
            ci = bw(X.x + Y.left) + "px";
            if (!cm.visible) {
                cm.element.css({
                    top: co,
                    left: ci
                })
            }
            cm.element.css({
                backgroundColor: cn.background,
                borderColor: cn.border.color || ck.options.color,
                color: cn.color,
                opacity: cn.opacity,
                borderWidth: cn.border.width
            }).stop(true, true).show().animate({
                left: ci,
                top: co
            }, cj.animation.duration);
            cm.visible = true
        },
        hide: function () {
            var X = this;
            clearTimeout(X.showTimeout);
            if (X.visible) {
                X.element.fadeOut();
                X.point = null;
                X.visible = false
            }
        }
    });

    function L(Y, X) {
        return bw(aZ.ceil(Y / X) * X, ah)
    }
    function au(Y, X) {
        return bw(aZ.floor(Y / X) * X, ah)
    }
    function bw(cg, Y) {
        var X = aZ.pow(10, Y || 0);
        return aZ.round(cg * X) / X
    }
    function a1(ct, cq, co) {
        var cr = ax(cq),
			cg = ct + cr + co,
			Y = a1.cache[cg];
        if (Y) {
            return Y
        }
        var ck = a1.measureBox,
			X = a1.baselineMarker.cloneNode(false);
        if (!ck) {
            ck = a1.measureBox = a("<div style='position: absolute; top: -4000px; left: -4000px;line-height: normal; visibility: hidden;' />").appendTo(al.body)[0]
        }
        for (var cs in cq) {
            ck.style[cs] = cq[cs]
        }
        ck.innerHTML = ct;
        ck.appendChild(X);
        var cp = {
            width: ck.offsetWidth - y,
            height: ck.offsetHeight,
            baseline: X.offsetTop + y
        };
        if (co) {
            var cu = cp.width,
				cj = cp.height,
				ch = cu / 2,
				ci = cj / 2,
				cl = bv(0, 0, ch, ci, co),
				cm = bv(cu, 0, ch, ci, co),
				cn = bv(cu, cj, ch, ci, co);
            r4 = bv(0, cj, ch, ci, co);
            cp.normalWidth = cu;
            cp.normalHeight = cj;
            cp.width = aZ.max(cl.x, cm.x, cn.x, r4.x) - aZ.min(cl.x, cm.x, cn.x, r4.x);
            cp.height = aZ.max(cl.y, cm.y, cn.y, r4.y) - aZ.min(cl.y, cm.y, cn.y, r4.y)
        }
        a1.cache[cg] = cp;
        return cp
    }
    a1.cache = {};
    a1.baselineMarker = a("<div style='display: inline-block; vertical-align: baseline;width: " + y + "px; height: " + y + "px;zoom: 1; *display: inline; overflow: hidden;' />")[0];

    function ax(cg) {
        var X = [];
        for (var Y in cg) {
            X.push(Y + cg[Y])
        }
        return X.sort().join(" ")
    }
    function bv(ci, cj, Y, cg, X) {
        var ch = X * ak;
        return {
            x: Y + (ci - Y) * aZ.cos(ch) + (cj - cg) * aZ.sin(ch),
            y: cg - (ci - Y) * aZ.sin(ch) + (cj - cg) * aZ.cos(ch)
        }
    }
    function E(cm, co) {
        if (cm.x1 == co.x1 && cm.y1 == co.y1 && cm.x2 == co.x2 && cm.y2 == co.y2) {
            return co
        }
        var X = aZ.min(cm.x1, co.x1),
			Y = aZ.max(cm.x1, co.x1),
			cg = aZ.min(cm.x2, co.x2),
			ch = aZ.max(cm.x2, co.x2),
			ci = aZ.min(cm.y1, co.y1),
			cj = aZ.max(cm.y1, co.y1),
			ck = aZ.min(cm.y2, co.y2),
			cl = aZ.max(cm.y2, co.y2),
			cn = [];
        cn[0] = new D(Y, ci, cg, cj);
        cn[1] = new D(X, cj, Y, ck);
        cn[2] = new D(cg, cj, ch, ck);
        cn[3] = new D(Y, ck, cg, cl);
        if (cm.x1 == X && cm.y1 == ci || co.x1 == X && co.y1 == ci) {
            cn[4] = new D(X, ci, Y, cj);
            cn[5] = new D(cg, ck, ch, cl)
        } else {
            cn[4] = new D(cg, ci, ch, cj);
            cn[5] = new D(X, ck, Y, cl)
        }
        return a.grep(cn, function (cp) {
            return cp.height() > 0 && cp.width() > 0
        })[0]
    }
    function bH(X) {
        return bF(X).min
    }
    function bG(X) {
        return bF(X).max
    }
    function bF(X) {
        var ci = a0,
			ch = a2,
			Y, cg = X.length,
			cj;
        for (Y = 0; Y < cg; Y++) {
            cj = X[Y];
            if (aj(cj)) {
                ci = aZ.min(ci, cj);
                ch = aZ.max(ch, cj)
            }
        }
        return {
            min: ci,
            max: ch
        }
    }
    function ay(Y) {
        var X = {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0
        };
        if (typeof (Y) === "number") {
            X[bV] = X[bs] = X[C] = X[aQ] = Y
        } else {
            X[bV] = Y[bV] || 0;
            X[bs] = Y[bs] || 0;
            X[C] = Y[C] || 0;
            X[aQ] = Y[aQ] || 0
        }
        return X
    }
    function aG(Y, X) {
        return a.inArray(Y, X) != -1
    }
    function aP(X) {
        return X[X.length - 1]
    }
    function aO(X, Y, cg, ch) {
        var ci, cl = (ch.x - cg.x) * (X.y - cg.y) - (ch.y - cg.y) * (X.x - cg.x),
			cj = (ch.y - cg.y) * (Y.x - X.x) - (ch.x - cg.x) * (Y.y - X.y),
			ck;
        if (cj != 0) {
            ck = (cl / cj);
            ci = new bm(X.x + ck * (Y.x - X.x), X.y + ck * (Y.y - X.y))
        }
        return ci
    }
    function f(X, Y) {
        [].push.apply(X, Y)
    }
    function aN(cg, X, Y) {
        return bw(cg + (X - cg) * Y, aa)
    }
    function j(ch, cm) {
        var ci = ch.series,
			cg, ck = ci.length,
			cl, cj = ch.seriesDefaults,
			X = ae({}, ch.seriesDefaults),
			cn = cm ? ae({}, cm.seriesDefaults) : {},
			Y = ae({}, cn);
        S(X);
        S(Y);
        for (cg = 0; cg < ck; cg++) {
            cl = ci[cg].type || ch.seriesDefaults.type;
            ci[cg] = ae({}, Y, cn[cl], {
                tooltip: ch.tooltip
            }, X, cj[cl], ci[cg])
        }
    }
    function S(X) {
        delete X.bar;
        delete X.column;
        delete X.line;
        delete X.verticalLine;
        delete X.pie;
        delete X.area;
        delete X.verticalArea;
        delete X.scatter;
        delete X.scatterLine
    }
    function i(cg) {
        var ch = cg.series,
			Y, ci = ch.length,
			X = cg.seriesColors || [];
        for (Y = 0; Y < ci; Y++) {
            ch[Y].color = ch[Y].color || X[Y % X.length]
        }
    }
    function g(X, cg) {
        var Y = ae({}, (cg || {}).axisDefaults);
        am(["category", "value", "x", "y"], function () {
            var ci = this + "Axis",
				ch = [].concat(X[ci]);
            ch = a.map(ch, function (ck) {
                var cj = (ck || {}).color;
                return ae({}, Y, Y[ci], X.axisDefaults, {
                    line: {
                        color: cj
                    },
                    labels: {
                        color: cj
                    },
                    title: {
                        color: cj
                    }
                }, ck)
            });
            X[ci] = ch.length > 1 ? ch : ch[0]
        })
    }
    function h(X, Y) {
        g(X, Y);
        j(X, Y)
    }
    function aH(Y, X, cg) {
        Y[X] = (Y[X] || 0) + cg
    }
    function aj(X) {
        return typeof X !== bZ
    }
    var b0 = (function () {
        var X = 1;
        return function () {
            X = ((X >>> 1) ^ (-(X & 1) & 3489660929)) >>> 0;
            return aF + X.toString(16)
        }
    })();
    var W = function (cl) {
        var Y = this,
            cg = W.formats,
            ck, cj, ci, ch, X;
        if (arguments.length === 1) {
            cl = Y.resolveColor(cl);
            for (ch = 0; ch < cg.length; ch++) {
                ck = cg[ch].re;
                cj = cg[ch].process;
                ci = ck.exec(cl);
                if (ci) {
                    X = cj(ci);
                    Y.r = X[0];
                    Y.g = X[1];
                    Y.b = X[2]
                }
            }
        } else {
            Y.r = arguments[0];
            Y.g = arguments[1];
            Y.b = arguments[2]
        }
        Y.r = Y.normalizeByte(Y.r);
        Y.g = Y.normalizeByte(Y.g);
        Y.b = Y.normalizeByte(Y.b)
    };
    W.prototype = {
        toHex: function () {
            var Y = this,
				ch = Y.padDigit,
				ci = Y.r.toString(16),
				cg = Y.g.toString(16),
				X = Y.b.toString(16);
            return "#" + ch(ci) + ch(cg) + ch(X)
        },
        resolveColor: function (X) {
            X = X || B;
            if (X.charAt(0) == "#") {
                X = X.substr(1, 6)
            }
            X = X.replace(/ /g, "");
            X = X.toLowerCase();
            X = W.namedColors[X] || X;
            return X
        },
        normalizeByte: function (X) {
            return (X < 0 || isNaN(X)) ? 0 : ((X > 255) ? 255 : X)
        },
        padDigit: function (X) {
            return (X.length === 1) ? "0" + X : X
        },
        brightness: function (cg) {
            var X = this,
				Y = aZ.round;
            X.r = Y(X.normalizeByte(X.r * cg));
            X.g = Y(X.normalizeByte(X.g * cg));
            X.b = Y(X.normalizeByte(X.b * cg));
            return X
        }
    };
    W.formats = [{
        re: /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/,
        process: function (X) {
            return [parseInt(X[1], 10), parseInt(X[2], 10), parseInt(X[3], 10)]
        }
    }, {
        re: /^(\w{2})(\w{2})(\w{2})$/,
        process: function (X) {
            return [parseInt(X[1], 16), parseInt(X[2], 16), parseInt(X[3], 16)]
        }
    }, {
        re: /^(\w{1})(\w{1})(\w{1})$/,
        process: function (X) {
            return [parseInt(X[1] + X[1], 16), parseInt(X[2] + X[2], 16), parseInt(X[3] + X[3], 16)]
        }
    }];
    W.namedColors = {
        aqua: "00ffff",
        azure: "f0ffff",
        beige: "f5f5dc",
        black: "000000",
        blue: "0000ff",
        brown: "a52a2a",
        coral: "ff7f50",
        cyan: "00ffff",
        darkblue: "00008b",
        darkcyan: "008b8b",
        darkgray: "a9a9a9",
        darkgreen: "006400",
        darkorange: "ff8c00",
        darkred: "8b0000",
        dimgray: "696969",
        fuchsia: "ff00ff",
        gold: "ffd700",
        goldenrod: "daa520",
        gray: "808080",
        green: "008000",
        greenyellow: "adff2f",
        indigo: "4b0082",
        ivory: "fffff0",
        khaki: "f0e68c",
        lightblue: "add8e6",
        lightgrey: "d3d3d3",
        lightgreen: "90ee90",
        lightpink: "ffb6c1",
        lightyellow: "ffffe0",
        lime: "00ff00",
        limegreen: "32cd32",
        linen: "faf0e6",
        magenta: "ff00ff",
        maroon: "800000",
        mediumblue: "0000cd",
        navy: "000080",
        olive: "808000",
        orange: "ffa500",
        orangered: "ff4500",
        orchid: "da70d6",
        pink: "ffc0cb",
        plum: "dda0dd",
        purple: "800080",
        red: "ff0000",
        royalblue: "4169e1",
        salmon: "fa8072",
        silver: "c0c0c0",
        skyblue: "87ceeb",
        slateblue: "6a5acd",
        slategray: "708090",
        snow: "fffafa",
        steelblue: "4682b4",
        tan: "d2b48c",
        teal: "008080",
        tomato: "ff6347",
        turquoise: "40e0d0",
        violet: "ee82ee",
        wheat: "f5deb3",
        white: "ffffff",
        whitesmoke: "f5f5f5",
        yellow: "ffff00",
        yellowgreen: "9acd32"
    };
    O.Gradients = {
        glass: {
            type: aU,
            rotation: 0,
            stops: [{
                offset: 0,
                color: b7,
                opacity: 0
            }, {
                offset: 0.1,
                color: b7,
                opacity: 0
            }, {
                offset: 0.25,
                color: b7,
                opacity: 0.3
            }, {
                offset: 0.92,
                color: b7,
                opacity: 0
            }, {
                offset: 1,
                color: b7,
                opacity: 0
            }]
        },
        sharpBevel: {
            type: bq,
            stops: [{
                offset: 0,
                color: b7,
                opacity: 0.55
            }, {
                offset: 0.65,
                color: b7,
                opacity: 0
            }, {
                offset: 0.95,
                color: b7,
                opacity: 0
            }, {
                offset: 0.95,
                color: b7,
                opacity: 0.25
            }]
        },
        roundedBevel: {
            type: bq,
            stops: [{
                offset: 0.33,
                color: b7,
                opacity: 0.06
            }, {
                offset: 0.83,
                color: b7,
                opacity: 0.2
            }, {
                offset: 0.95,
                color: b7,
                opacity: 0
            }]
        }
    };

    function b1(X, ch, ci) {
        var Y, cg = X.length;
        for (Y = 0; Y < cg; Y++) {
            X[Y][ch] = ci
        }
    }
    function J(cg) {
        var ch = cg.length,
			X = 0,
			Y;
        for (Y = 0; Y < ch; Y++) {
            X = aZ.max(X, cg[Y].data.length)
        }
        return X
    }
    function bI(X) {
        return X * X
    }
    ap(a.easing, {
        easeOutElastic: function (ci, Y, ch, cg) {
            var ck = 1.70158,
				cj = 0,
				X = cg;
            if (ci === 0) {
                return ch
            }
            if (ci === 1) {
                return ch + cg
            }
            if (!cj) {
                cj = 0.5
            }
            if (X < aZ.abs(cg)) {
                X = cg;
                ck = cj / 4
            } else {
                ck = cj / (2 * aZ.PI) * aZ.asin(cg / X)
            }
            return X * aZ.pow(2, -10 * ci) * aZ.sin((ci * 1 - ck) * (1.1 * aZ.PI) / cj) + cg + ch
        }
    });

    function aw(X, cg) {
        if (cg === null) {
            return null
        }
        var Y = aw.cache[X] = aw.cache[X] || az(X, true);
        return Y(cg)
    }
    function m(cg, Y) {
        var X = Y - cg;
        if (X == 0) {
            if (Y == 0) {
                return 0.1
            }
            X = aZ.abs(Y)
        }
        var ci = aZ.pow(10, aZ.floor(aZ.log(X) / aZ.log(10))),
			ch = bw((X / ci), ah),
			cj = 1;
        if (ch < 1.904762) {
            cj = 0.2
        } else {
            if (ch < 4.761904) {
                cj = 0.5
            } else {
                if (ch < 9.523809) {
                    cj = 1
                } else {
                    cj = 2
                }
            }
        }
        return bw(ci * cj, ah)
    }
    aw.cache = {};
    b.scripts.push("easyui.chart.js");
    b.chart = function (ch, ci) {
        var cj = this,
			X, Y, cg = {};
        cj.element = ch;
        b.bind(cj.element, {
            load: ci.onLoad,
            error: ci.onError,
            dataBinding: ci.onDataBinding
        });
        ae(ci, {
            dataBound: ci.onDataBound,
            seriesClick: ci.onSeriesClick
        });
        cj._chart = X = new O(ch, ap({
            autoBind: false
        }, ci));
        Y = X.dataSource;
        if (Y) {
            Y.bind("error", function (cn, cm, cl) {
                var ck = bX(ch, "error", {
                    XMLHttpRequest: cn
                });
                if (!ck) {
                    alert("Error! Data binding failed. Unexpected server response - see console.")
                }
            });
            a(cj.element).bind("load", function () {
                if (!bX(ch, ab, cg)) {
                    X.dataSource.query(cg.data || {})
                }
            })
        }
        cj.options = X.options
    };
    b.chart.prototype = {
        rebind: function (X) {
            this._ajaxRequest(X)
        },
        refresh: function () {
            var Y = this,
				X = Y._chart;
            X.options = Y.options;
            h(X.options);
            X._redraw()
        },
        _ajaxRequest: function (X) {
            var Y = {};
            if (!bX(this.element, ab, Y)) {
                this._chart.dataSource.read(ap(Y.data || {}, X))
            }
        },
        refresh: function () {
            var Y = this,
				X = Y._chart;
            X.options = Y.options;
            X.refresh()
        },
        svg: function () {
            return this._chart.svg()
        }
    };
    a.fn.tChart = function (X) {
        return b.create(this, {
            name: "tChart",
            init: function (Y, cg) {
                return new b.chart(Y, cg)
            },
            options: X
        })
    };
    a.fn.tChart.defaults = {};
    b.chart.Chart = O;
    ae(O, {
        COORD_PRECISION: aa,
        CLIP: U,
        DEFAULT_WIDTH: ai,
        DEFAULT_HEIGHT: ag,
        DEFAULT_FONT: af,
        defined: aj,
        template: bN,
        rotatePoint: bv,
        round: bw,
        supportsSVG: bL,
        uniqueId: b0,
        Box2D: D,
        Point2D: bm,
        Sector: bC,
        Text: bO,
        BarLabel: x,
        ChartElement: P,
        RootElement: bu,
        BoxElement: F,
        TextBox: bP,
        NumericAxis: a8,
        CategoryAxis: K,
        Bar: p,
        BarChart: w,
        ShapeElement: bE,
        LinePoint: aX,
        LineChart: aV,
        AreaChart: l,
        ClusterLayout: V,
        StackLayout: bK,
        Title: bQ,
        Legend: aR,
        CategoricalPlotArea: I,
        PiePlotArea: bj,
        XYPlotArea: cc,
        Tooltip: bR,
        Highlight: aD,
        PieSegment: bk,
        PieChart: bi,
        ViewElement: b6,
        ScatterChart: bA,
        ScatterLineChart: bB,
        ViewBase: b5,
        deepExtend: ae,
        Color: W,
        measureText: a1,
        ExpandAnimation: ao,
        BarAnimation: u,
        BarAnimationDecorator: v,
        PieAnimation: bg,
        PieAnimationDecorator: bh,
        FadeAnimation: aq,
        FadeAnimationDecorator: ar,
        categoriesCount: J
    })
})(jQuery);
(function () {
    var a = jQuery,
		b = a.easyui,
		g = b.Class,
		f = b.chart.Chart,
		d = f.BarAnimationDecorator,
		t = f.PieAnimationDecorator,
		q = f.FadeAnimationDecorator,
		e = f.Box2D,
		u = f.Point2D,
		p = f.ExpandAnimation,
		T = f.ViewBase,
		U = f.ViewElement,
		j = f.deepExtend,
		n = f.defined,
		P = f.template,
		S = f.uniqueId,
		y = f.round,
		o = document,
		r = Math;
    var h = f.CLIP,
		i = f.COORD_PRECISION,
		m = f.DEFAULT_WIDTH,
		l = f.DEFAULT_HEIGHT,
		k = f.DEFAULT_FONT,
		s = "none",
		v = "radial",
		z = "square",
		B = "http://www.w3.org/2000/svg",
		A = {
		    dot: [1.5, 3.5],
		    dash: [4, 3.5],
		    longdash: [8, 3.5],
		    dashdot: [3.5, 3.5, 1.5, 3.5],
		    longdashdot: [8, 3.5, 1.5, 3.5],
		    longdashdotdot: [8, 3.5, 1.5, 3.5, 1.5, 3.5]
		},
		Q = "transparent",
		R = "undefined";
    var O = T.extend({
        init: function (V) {
            var W = this;
            T.fn.init.call(W, V);
            W.decorators.push(new J(W), new F(W), new d(W), new t(W), new D(W), new q(W));
            W.template = O.template;
            if (!W.template) {
                W.template = O.template = P("<svg xmlns='" + B + "' version='1.1' width='#= d.options.width #px' height='#= d.options.height #px' style='position: relative; display: block;'>#= d.renderDefinitions() ##= d.renderContent() #</svg>")
            }
        },
        options: {
            width: m,
            height: l,
            idPrefix: ""
        },
        renderTo: function (V) {
            var W = this,
				X;
            W.setupAnimations();
            w(V, W.render());
            X = V.firstChild;
            W.alignToScreen(X);
            W.playAnimations();
            return X
        },
        renderDefinitions: function () {
            var W = this,
				V = T.fn.renderDefinitions.call(W);
            return V.length > 0 ? "<defs>" + V + "</defs>" : ""
        },
        renderElement: function (W) {
            var V = o.createElement("div"),
				W;
            w(V, "<svg xmlns='" + B + "' version='1.1'>" + W.render() + "</svg>");
            W = V.firstChild.firstChild;
            return W
        },
        createGroup: function (V) {
            return this.decorate(new G(V))
        },
        createText: function (V, W) {
            return this.decorate(new N(V, W))
        },
        createRect: function (V, W) {
            return this.decorate(new H(V.points(), true, W))
        },
        createLine: function (W, Y, X, Z, V) {
            return this.decorate(new H([new u(W, Y), new u(X, Z)], false, V))
        },
        createPolyline: function (X, V, W) {
            return this.decorate(new H(X, V, W))
        },
        createCircle: function (V, X, W) {
            return this.decorate(new C(V, X, W))
        },
        createSector: function (W, V) {
            return this.decorate(new M(W, V))
        },
        createGradient: function (V) {
            if (V.type === v) {
                return new L(V)
            } else {
                return new I(V)
            }
        },
        alignToScreen: function (X) {
            try {
                var V = X.getScreenCTM ? X.getScreenCTM() : null
            } catch (W) { }
            if (V) {
                var Y = -V.e % 1,
					aa = -V.f % 1,
					Z = X.style;
                if (Y !== 0 || aa !== 0) {
                    Z.left = Y + "px";
                    Z.top = aa + "px"
                }
            }
        }
    });
    O.fromModel = function (V) {
        var W = new O(V.options);
        [].push.apply(W.children, V.getViewElements(W));
        return W
    };
    var N = U.extend({
        init: function (V, W) {
            var X = this;
            U.fn.init.call(X, W);
            X.content = V;
            X.template = N.template;
            if (!X.template) {
                X.template = N.template = P("<text #= d.renderAttr(\"id\", d.options.id) # x='#= Math.round(d.options.x) #' y='#= Math.round(d.options.y + d.options.baseline) #' fill-opacity='#= d.options.fillOpacity #' #= d.options.rotation ? d.renderRotation() : '' # style='font: #= d.options.font #' fill='#= d.options.color #'>#= d.content #</text>")
            }
        },
        options: {
            x: 0,
            y: 0,
            baseline: 0,
            font: k,
            size: {
                width: 0,
                height: 0
            },
            fillOpacity: 1
        },
        refresh: function (V) {
            var W = this.options;
            a(V).attr({
                "fill-opacity": W.fillOpacity
            })
        },
        clone: function () {
            var V = this;
            return new N(V.content, j({}, V.options))
        },
        renderRotation: function () {
            var ad = this,
				Z = ad.options,
				ac = Z.size,
				V = y(Z.x + ac.normalWidth / 2, i),
				W = y(Z.y + ac.normalHeight / 2, i),
				aa = y(Z.x + ac.width / 2, i),
				ab = y(Z.y + ac.height / 2, i),
				X = y(aa - V, i),
				Y = y(ab - W, i);
            return "transform='translate(" + X + "," + Y + ") rotate(" + Z.rotation + "," + V + "," + W + ")'"
        }
    });
    var K = U.extend({
        init: function (V) {
            var W = this;
            U.fn.init.call(W, V);
            W.template = K.template;
            if (!W.template) {
                W.template = K.template = P("<path #= d.renderAttr(\"id\", d.options.id) #d='#= d.renderPoints() #' #= d.renderAttr(\"stroke\", d.options.stroke) # #= d.renderAttr(\"stroke-width\", d.options.strokeWidth) ##= d.renderDashType() # stroke-linecap='#= d.renderLinecap() #' stroke-linejoin='round' fill-opacity='#= d.options.fillOpacity #' stroke-opacity='#= d.options.strokeOpacity #' fill='#= d.renderFill() #'></path>")
            }
        },
        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        },
        refresh: function (V) {
            var W = this.options;
            a(V).attr({
                d: this.renderPoints(),
                "fill-opacity": W.fillOpacity,
                "stroke-opacity": W.strokeOpacity
            })
        },
        clone: function () {
            var V = this;
            return new K(j({}, V.options))
        },
        renderPoints: function () { },
        renderDashType: function () {
            var W = this,
				V = W.options;
            return x(V.dashType, V.strokeWidth)
        },
        renderLinecap: function () {
            var V = this.options.dashType;
            return (V && V != "solid") ? "butt" : "square"
        },
        renderFill: function () {
            var V = this.options.fill;
            if (V && V !== Q) {
                return V
            }
            return s
        }
    });
    var H = K.extend({
        init: function (Y, V, X) {
            var W = this;
            K.fn.init.call(W, X);
            W.points = Y;
            W.closed = V
        },
        renderPoints: function () {
            var Y = this,
				Z = Y.points,
				X, V = Z.length,
				W = Z[0],
				aa = "M" + Y._print(W);
            for (X = 1; X < V; X++) {
                aa += " " + Y._print(Z[X])
            }
            if (Y.closed) {
                aa += " z"
            }
            return aa
        },
        clone: function () {
            var V = this;
            return new H(j([], V.points), V.closed, j({}, V.options))
        },
        _print: function (X) {
            var W = this,
				Z = W.options.strokeWidth,
				Y = Z && Z % 2 !== 0,
				V = Y ? c : r.round;
            return V(X.x) + " " + V(X.y)
        }
    });
    var M = K.extend({
        init: function (V, W) {
            var X = this;
            K.fn.init.call(X, W);
            X.pathTemplate = M.pathTemplate;
            if (!X.pathTemplate) {
                X.pathTemplate = M.pathTemplate = P("M #= d.firstPoint.x # #= d.firstPoint.y # A#= d.r # #= d.r # 0 #= d.isReflexAngle ? '1' : '0' #,1 #= d.secondPoint.x # #= d.secondPoint.y # L #= d.cx # #= d.cy # z")
            }
            X.config = V || {}
        },
        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1,
            strokeLineCap: z
        },
        clone: function () {
            var V = this;
            return new M(j({}, V.config), j({}, V.options))
        },
        renderPoints: function () {
            var ad = this,
				V = ad.config,
				ae = V.startAngle,
				Y = V.angle + ae,
				Y = (Y - ae) == 360 ? Y - 0.001 : Y,
				aa = (Y - ae) > 180,
				ab = r.max(V.r, 0),
				W = V.c.x,
				X = V.c.y,
				Z = V.point(ae),
				ac = V.point(Y);
            return ad.pathTemplate({
                firstPoint: Z,
                secondPoint: ac,
                isReflexAngle: aa,
                r: ab,
                cx: W,
                cy: X
            })
        }
    });
    var C = U.extend({
        init: function (V, Y, X) {
            var W = this;
            U.fn.init.call(W, X);
            W.center = V;
            W.radius = Y;
            W.template = C.template;
            if (!W.template) {
                W.template = C.template = P("<circle #= d.renderAttr(\"id\", d.options.id) # cx='#= d.center[0] #' cy='#= d.center[1] #' r='#= d.radius #' #= d.renderAttr(\"stroke\", d.options.stroke) # #= d.renderAttr(\"stroke-width\", d.options.strokeWidth) #fill-opacity='#= d.options.fillOpacity #' stroke-opacity='#= d.options.strokeOpacity #'  fill='#= d.options.fill || \"none\" #'></circle>")
            }
        },
        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        }
    });
    var G = U.extend({
        init: function (W) {
            var V = this;
            U.fn.init.call(V, W);
            V.template = G.template;
            if (!V.template) {
                V.template = G.template = P('<g#= d.renderAttr("id", d.options.id) ##= d.renderAttr("clip-path", d.options.clipPath) #>#= d.renderContent() #</g>')
            }
        }
    });
    var E = U.extend({
        init: function (W) {
            var V = this;
            U.fn.init.call(V, W);
            V.template = E.template;
            if (!V.template) {
                V.template = E.template = P('<clipPath#= d.renderAttr("id", d.options.id) #>#= d.renderContent() #</clipPath>')
            }
        }
    });
    var I = U.extend({
        init: function (W) {
            var V = this;
            U.fn.init.call(V, W);
            V.template = I.template;
            V.stopTemplate = I.stopTemplate;
            if (!V.template) {
                V.template = I.template = P("<linearGradient id='#= d.options.id #' gradientTransform='rotate(#= d.options.rotation #)'> #= d.renderStops() #</linearGradient>");
                V.stopTemplate = I.stopTemplate = P("<stop offset='#= Math.round(d.offset * 100) #%' style='stop-color:#= d.color #;stop-opacity:#= d.opacity #' />")
            }
        },
        options: {
            id: "",
            rotation: 0
        },
        renderStops: function () {
            var W = this,
				aa = W.options.stops,
				ab = W.stopTemplate,
				X, Y = aa.length,
				V, Z = "";
            for (X = 0; X < Y; X++) {
                V = aa[X];
                Z += ab(V)
            }
            return Z
        }
    });
    var L = U.extend({
        init: function (W) {
            var V = this;
            U.fn.init.call(V, W);
            V.template = L.template;
            V.stopTemplate = L.stopTemplate;
            if (!V.template) {
                V.template = L.template = P("<radialGradient id='#= d.options.id #' cx='#= d.options.cx #' cy='#= d.options.cy #' fx='#= d.options.cx #' fy='#= d.options.cy #' r='#= d.options.r #' gradientUnits='userSpaceOnUse'>#= d.renderStops() #</radialGradient>");
                V.stopTemplate = L.stopTemplate = P("<stop offset='#= Math.round(d.offset * 100) #%' style='stop-color:#= d.color #;stop-opacity:#= d.opacity #' />")
            }
        },
        options: {
            id: "",
            rotation: 0
        },
        renderStops: function () {
            var W = this,
				aa = W.options.stops,
				ab = W.stopTemplate,
				Y = aa.length,
				V, Z = "",
				X;
            for (X = 0; X < Y; X++) {
                V = aa[X];
                Z += ab(V)
            }
            return Z
        }
    });

    function J(V) {
        this.view = V
    }
    J.prototype = {
        decorate: function (W) {
            var V = this,
				ab = V.view,
				Z = W.options,
				Y = Z.id,
				X, aa;
            if (Z.overlay) {
                W.options.id = S();
                X = ab.createGroup();
                aa = W.clone();
                X.children.push(W, aa);
                aa.options.id = Y;
                aa.options.fill = Z.overlay;
                return X
            } else {
                return W
            }
        }
    };

    function F(V) {
        this.view = V
    }
    F.prototype = {
        decorate: function (W) {
            var V = this,
				X = W.options;
            X.fill = V.getPaint(X.fill);
            return W
        },
        getPaint: function (ab) {
            var W = this,
				ac = W.view,
				V = W.baseUrl(),
				X = ac.definitions,
				Z, aa, Y;
            if (ab && n(ab.gradient)) {
                Z = ac.buildGradient(ab);
                if (Z) {
                    aa = Z.id;
                    Y = X[aa];
                    if (!Y) {
                        Y = ac.createGradient(Z);
                        X[aa] = Y
                    }
                    return "url(" + V + "#" + Y.options.id + ")"
                } else {
                    return s
                }
            } else {
                return ab
            }
        },
        baseUrl: function () {
            var V = o.getElementsByTagName("base")[0],
				W = "",
				Y = o.location.href,
				X = Y.indexOf("#");
            if (V && !a.browser.msie) {
                if (X !== -1) {
                    Y = Y.substring(0, X)
                }
                W = Y
            }
            return W
        }
    };
    var D = g.extend({
        init: function (V) {
            this.view = V;
            this.clipId = S()
        },
        decorate: function (ab) {
            var Z = this,
				ad = Z.view,
				W = Z.clipId,
				ac = ad.options,
				V = ab.options.animation,
				aa = ad.definitions,
				X = aa[W],
				Y;
            if (V && V.type === h && ac.transitions) {
                if (!X) {
                    X = new E({
                        id: W
                    });
                    Y = ad.createRect(new e(0, 0, ac.width, ac.height), {
                        id: S()
                    });
                    X.children.push(Y);
                    aa[W] = X;
                    ad.animations.push(new p(Y, {
                        size: ac.width
                    }))
                }
                ab.options.clipPath = "url(#" + W + ")"
            }
            return ab
        }
    });

    function c(V) {
        return r.round(V) + 0.5
    }
    function x(V, Z) {
        var Y = [],
			V = V ? V.toLowerCase() : null,
			W, X;
        if (V && V != "solid" && Z) {
            W = A[V];
            for (X = 0; X < W.length; X++) {
                Y.push(W[X] * Z)
            }
            return "stroke-dasharray='" + Y.join(" ") + "' "
        }
        return ""
    }
    function w(V, W) {
        V.innerHTML = W
    } (function () {
        var X = "<svg xmlns='" + B + "'></svg>",
			W = o.createElement("div"),
			V = typeof DOMParser != R;
        W.innerHTML = X;
        if (V && W.firstChild.namespaceURI != B) {
            w = function (Z, ac) {
                var ab = new DOMParser(),
					Y = ab.parseFromString(ac, "text/xml"),
					aa = o.adoptNode(Y.documentElement);
                Z.innerHTML = "";
                Z.appendChild(aa)
            }
        }
    })();
    j(f, {
        SVGView: O,
        SVGText: N,
        SVGPath: K,
        SVGLine: H,
        SVGSector: M,
        SVGCircle: C,
        SVGGroup: G,
        SVGClipPath: E,
        SVGLinearGradient: I,
        SVGRadialGradient: L,
        SVGOverlayDecorator: J,
        SVGGradientDecorator: F,
        SVGClipAnimationDecorator: D
    })
})(jQuery);
(function () {
    var a = jQuery,
		b = a.easyui,
		j = b.Class,
		i = b.chart.Chart,
		l = i.Color,
		h = i.Box2D,
		x = i.Point2D,
		c = i.BarAnimationDecorator,
		w = i.PieAnimationDecorator,
		s = i.FadeAnimationDecorator,
		r = i.ExpandAnimation,
		F = i.ViewBase,
		G = i.ViewElement,
		m = i.deepExtend,
		C = i.template,
		E = i.uniqueId,
		z = i.rotatePoint,
		A = i.round,
		B = i.supportsSVG,
		q = document,
		u = Math;
    var d = "#000",
		k = i.CLIP,
		p = i.DEFAULT_WIDTH,
		o = i.DEFAULT_HEIGHT,
		n = i.DEFAULT_FONT,
		v = "object",
		y = "radial",
		D = "transparent";
    var V = F.extend({
        init: function (W) {
            var X = this;
            F.fn.init.call(X, W);
            X.decorators.push(new P(X), new L(X), new c(X), new w(X), new I(X));
            if (!t()) {
                X.decorators.push(new s(X))
            }
            X.template = V.template;
            if (!X.template) {
                X.template = V.template = C("<div style='width:#= d.options.width #px; height:#= d.options.height #px; position: relative;'>#= d.renderContent() #</div>")
            }
        },
        options: {
            width: p,
            height: o
        },
        renderTo: function (W) {
            var X = this;
            if (q.namespaces) {
                q.namespaces.add("kvml", "urn:schemas-microsoft-com:vml", "#default#VML")
            }
            X.setupAnimations();
            W.innerHTML = X.render();
            X.playAnimations();
            return W.firstChild
        },
        renderElement: function (X) {
            var W = q.createElement("div"),
				X;
            W.style.display = "none";
            q.body.appendChild(W);
            W.innerHTML = X.render();
            X = W.firstChild;
            q.body.removeChild(W);
            return X
        },
        createText: function (W, X) {
            return this.decorate((X && X.rotation) ? new R(W, X) : new U(W, X))
        },
        createRect: function (W, X) {
            return this.decorate(new N(W.points(), true, X))
        },
        createLine: function (X, Z, Y, aa, W) {
            return this.decorate(new N([new x(X, Z), new x(Y, aa)], false, W))
        },
        createPolyline: function (Y, W, X) {
            return this.decorate(new N(Y, W, X))
        },
        createCircle: function (W, Y, X) {
            return this.decorate(new H(W, Y, X))
        },
        createSector: function (X, W) {
            return this.decorate(new S(X, W))
        },
        createGroup: function (W) {
            return this.decorate(new M(W))
        },
        createGradient: function (W) {
            return new O(W)
        }
    });
    V.fromModel = function (W) {
        var X = new V(W.options);
        [].push.apply(X.children, W.getViewElements(X));
        return X
    };
    var U = G.extend({
        init: function (W, X) {
            var Y = this;
            G.fn.init.call(Y, X);
            Y.content = W;
            Y.template = U.template;
            if (!Y.template) {
                Y.template = U.template = C("<kvml:textbox #= d.renderAttr(\"id\", d.options.id) # style='position: absolute; left: #= d.options.x #px; top: #= d.options.y #px; font: #= d.options.font #; color: #= d.options.color #; visibility: #= d.renderVisibility() #; white-space: nowrap;'>#= d.content #</kvml:textbox>")
            }
        },
        options: {
            x: 0,
            y: 0,
            font: n,
            color: d,
            fillOpacity: 1
        },
        refresh: function (W) {
            a(W).css("visibility", this.renderVisibility())
        },
        clone: function () {
            var W = this;
            return new U(W.content, m({}, W.options))
        },
        renderVisibility: function () {
            return this.options.fillOpacity > 0 ? "visible" : "hidden"
        }
    });
    var R = G.extend({
        init: function (W, X) {
            var Y = this;
            G.fn.init.call(Y, X);
            Y.content = W;
            Y.template = R.template;
            if (!Y.template) {
                Y.template = R.template = C("<kvml:shape #= d.renderAttr(\"id\", d.options.id) # style='position: absolute; top: 0px; left: 0px; width: 1px; height: 1px;' stroked='false' coordsize='1,1'>#= d.renderPath() #<kvml:fill color='#= d.options.color #' /><kvml:textpath on='true' style='font: #= d.options.font #;' fitpath='false' string='#= d.content #' /></kvml:shape>")
            }
        },
        options: {
            x: 0,
            y: 0,
            font: n,
            color: d,
            size: {
                width: 0,
                height: 0
            }
        },
        renderPath: function () {
            var ad = this,
				aa = ad.options,
				ae = aa.size.width,
				Z = aa.size.height,
				X = aa.x + ae / 2,
				Y = aa.y + Z / 2,
				W = -aa.rotation,
				ab = z(aa.x, Y, X, Y, W),
				ac = z(aa.x + ae, Y, X, Y, W);
            return "<kvml:path textpathok='true' v='m " + A(ab.x) + "," + A(ab.y) + " l " + A(ac.x) + "," + A(ac.y) + "' />"
        }
    });
    var T = G.extend({
        init: function (W) {
            var X = this;
            G.fn.init.call(X, W);
            X.template = T.template;
            if (!X.template) {
                X.template = T.template = C('<kvml:stroke on=\'#= !!d.options.stroke #\' #= d.renderAttr("color", d.options.stroke) ##= d.renderAttr("weight", d.options.strokeWidth) ##= d.renderAttr("dashstyle", d.options.dashType) ##= d.renderAttr("opacity", d.options.strokeOpacity) # />')
            }
        }
    });
    var K = G.extend({
        init: function (W) {
            var X = this;
            G.fn.init.call(X, W);
            X.template = K.template;
            if (!X.template) {
                X.template = K.template = C('<kvml:fill on=\'#= d.isEnabled() #\' #= d.renderAttr("color", d.options.fill) ##= d.renderAttr("weight", d.options.fillWidth) ##= d.renderAttr("opacity", d.options.fillOpacity) # />')
            }
        },
        isEnabled: function () {
            var W = this.options.fill;
            return !!W && W.toLowerCase() !== D
        }
    });
    var Q = G.extend({
        init: function (W) {
            var X = this;
            G.fn.init.call(X, W);
            X.template = Q.template;
            if (!X.template) {
                X.template = Q.template = C("<kvml:shape #= d.renderAttr(\"id\", d.options.id) # style='position:absolute; width:1px; height:1px;' coordorigin='0 0' coordsize='1 1'><kvml:path v='#= d.renderPoints() # e' />#= d.fill.render() + d.stroke.render() #</kvml:shape>")
            }
            X.stroke = new T(X.options);
            X.fill = new K(X.options)
        },
        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        },
        render: function () {
            var W = this;
            W.fill.options.fillOpacity = W.options.fillOpacity;
            W.stroke.options.strokeOpacity = W.options.strokeOpacity;
            return G.fn.render.call(W)
        },
        renderPoints: function () { },
        refresh: function (W) {
            var ab = this,
				Z = ab.options,
				Y = a(W),
				aa = Y[0].parentNode;
            if (aa) {
                Y.find("path")[0].v = this.renderPoints();
                try {
                    Y.find("fill")[0].opacity = Z.fillOpacity;
                    Y.find("stroke")[0].opacity = Z.strokeOpacity
                } catch (X) { }
                aa.style.cssText = aa.style.cssText
            }
        }
    });
    var N = Q.extend({
        init: function (Z, W, Y) {
            var X = this;
            Q.fn.init.call(X, Y);
            X.points = Z;
            X.closed = W
        },
        renderPoints: function () {
            var Y = this,
				Z = Y.points,
				X, W = Z.length,
				aa = "m " + Y._print(Z[0]);
            if (W > 1) {
                aa += " l ";
                for (X = 1; X < W; X++) {
                    aa += Y._print(Z[X]);
                    if (X < W - 1) {
                        aa += ", "
                    }
                }
            }
            if (Y.closed) {
                aa += " x"
            }
            return aa
        },
        clone: function () {
            var W = this;
            return new N(m([], W.points), W.closed, m({}, W.options))
        },
        _print: function (W) {
            return u.round(W.x) + "," + u.round(W.y)
        }
    });
    var S = Q.extend({
        init: function (W, X) {
            var Y = this;
            Q.fn.init.call(Y, X);
            Y.pathTemplate = S.pathTemplate;
            if (!Y.pathTemplate) {
                Y.pathTemplate = S.pathTemplate = C("M #= d.cx # #= d.cy # AE #= d.cx # #= d.cy # #= d.r # #= d.r # #= d.sa # #= d.a # X E")
            }
            Y.config = W
        },
        renderPoints: function () {
            var ac = this,
				X = ac.config,
				aa = u.max(A(X.r), 0),
				Y = A(X.c.x),
				Z = A(X.c.y),
				ab = -A((X.startAngle + 180) * 65535),
				W = -A(X.angle * 65536);
            return ac.pathTemplate({
                r: aa,
                cx: Y,
                cy: Z,
                sa: ab,
                a: W
            })
        },
        clone: function () {
            var W = this;
            return new S(m({}, W.config), m({}, W.options))
        }
    });
    var H = G.extend({
        init: function (W, Z, Y) {
            var X = this;
            G.fn.init.call(X, Y);
            X.center = W;
            X.radius = Z;
            X.template = H.template;
            if (!X.template) {
                X.template = H.template = C("<kvml:oval #= d.renderAttr(\"id\", d.options.id) # style='position:absolute; width:#= d.radius * 2 #px; height:#= d.radius * 2 #px; top:#= d.center[1] - d.radius #px; left:#= d.center[0] - d.radius #px;'>#= d.fill.render() + d.stroke.render() #</kvml:oval>")
            }
            X.stroke = new T(X.options);
            X.fill = new K(X.options)
        },
        options: {
            fill: ""
        }
    });
    var M = G.extend({
        init: function (X) {
            var W = this;
            G.fn.init.call(W, X);
            W.template = M.template;
            if (!W.template) {
                W.template = M.template = C("<div #= d.renderAttr(\"id\", d.options.id) #style='position: absolute; white-space: nowrap;'>#= d.renderContent() #</div>")
            }
        }
    });
    var J = G.extend({
        init: function (W, Y) {
            var X = this;
            G.fn.init.call(X, Y);
            X.template = J.template;
            X.clipTemplate = J.clipTemplate;
            if (!X.template) {
                X.template = J.template = C("<div #= d.renderAttr(\"id\", d.options.id) #style='position:absolute; width:#= d.box.width() #px; height:#= d.box.height() #px; top:#= d.box.y1 #px; left:#= d.box.x1 #px; clip:#= d._renderClip() #;' >#= d.renderContent() #</div>");
                X.clipTemplate = J.clipTemplate = C("rect(#= d.points[0].y #px #= d.points[1].x #px #= d.points[2].y #px #= d.points[0].x #px)")
            }
            X.box = W;
            X.points = W.points()
        },
        clone: function () {
            var W = this;
            return new J(W.box, m({}, W.options))
        },
        refresh: function (W) {
            W.style.clip = this._renderClip()
        },
        _renderClip: function () {
            return this.clipTemplate(this)
        }
    });
    var O = G.extend({
        init: function (X) {
            var W = this;
            G.fn.init.call(W, X);
            W.template = O.template;
            if (!W.template) {
                W.template = O.template = C("<kvml:fill type='gradient' angle='#= 270 - d.options.rotation #' colors='#= d.renderColors() #' opacity='#= d.options.opacity #' />")
            }
        },
        options: {
            rotation: 0,
            opacity: 1
        },
        renderColors: function () {
            var X = this,
				aa = X.options,
				ad = aa.stops,
				W, Y, Z = ad.length,
				ab = [],
				ac = u.round;
            for (Y = 0; Y < Z; Y++) {
                W = ad[Y];
                ab.push(ac(W.offset * 100) + "% " + W.color)
            }
            return ab.join(",")
        }
    });

    function P(W) {
        this.view = W
    }
    P.prototype = {
        decorate: function (W) {
            var X = W.options,
				Z = this.view,
				Y;
            if (X.overlay) {
                Y = Z.buildGradient(m({}, X.overlay, {
                    _overlayFill: X.fill
                }))
            }
            if (!Y || Y.type === y) {
                return W
            }
            delete X.overlay;
            X.fill = m(g(X.fill, Y), {
                opacity: X.fillOpacity
            });
            return W
        }
    };

    function L(W) {
        this.view = W
    }
    L.prototype = {
        decorate: function (X) {
            var W = this,
				aa = W.view,
				Z = X.options,
				Y = Z.fill;
            if (Y) {
                if (Y.gradient) {
                    Y = aa.buildGradient(Y)
                }
                if (typeof Y === v) {
                    X.fill = aa.createGradient(Y)
                }
            }
            return X
        }
    };
    var I = j.extend({
        init: function (W) {
            this.view = W
        },
        decorate: function (Z) {
            var Y = this,
				ab = Y.view,
				aa = ab.options,
				W = Z.options.animation,
				X;
            if (W && W.type === k && aa.transitions) {
                X = new J(new h(0, 0, aa.width, aa.height), {
                    id: E()
                });
                ab.animations.push(new r(X, {
                    size: aa.width
                }));
                X.children.push(Z);
                return X
            } else {
                return Z
            }
        }
    });

    function t() {
        return a.browser.msie && !B() && typeof window.performance !== "undefined"
    }
    function f(Y, ab, W) {
        var Z = new l(Y),
			ac = new l(ab),
			ad = e(Z.r, ac.r, W),
			aa = e(Z.g, ac.g, W),
			X = e(Z.b, ac.b, W);
        return new l(ad, aa, X).toHex()
    }
    function e(W, Y, X) {
        return u.round(X * Y + (1 - X) * W)
    }
    function g(W, X) {
        var ab = X.stops,
			ad = ab.length,
			Z = m({}, X),
			Y, ac, aa;
        Z.stops = [];
        for (Y = 0; Y < ad; Y++) {
            ac = ab[Y];
            aa = Z.stops[Y] = m({}, ab[Y]);
            aa.color = f(W, ac.color, ac.opacity);
            aa.opacity = 0
        }
        return Z
    }
    m(i, {
        VMLView: V,
        VMLText: U,
        VMLRotatedText: R,
        VMLStroke: T,
        VMLFill: K,
        VMLPath: Q,
        VMLLine: N,
        VMLSector: S,
        VMLCircle: H,
        VMLGroup: M,
        VMLClipRect: J,
        VMLLinearGradient: O,
        VMLOverlayDecorator: P,
        VMLClipAnimationDecorator: I,
        blendColors: f,
        blendGradient: g
    })
})(jQuery);
(function (a) {
    var b = a.easyui,
		e = b.chart.Chart,
		f = e.deepExtend;
    var d = "#000",
		m = "#fff",
		h = "Arial,Helvetica,sans-serif",
		i = "11px " + h,
		j = "12px " + h,
		k = "16px " + h,
		g = {
		    overlay: null
		};
    var c = {
        title: {
            font: k
        },
        legend: {
            labels: {
                font: j
            }
        },
        seriesDefaults: {
            labels: {
                font: i
            },
            area: {
                opacity: 0.4,
                markers: {
                    size: 6,
                    visible: false
                }
            },
            verticalArea: {
                opacity: 0.4,
                markers: {
                    size: 6,
                    visible: false
                }
            }
        },
        axisDefaults: {
            labels: {
                font: j
            },
            title: {
                font: k,
                margin: 5
            }
        },
        tooltip: {
            font: j
        }
    };
    var l = {};
    l.black = f({}, c, {
        title: {
            color: m
        },
        legend: {
            labels: {
                color: m
            }
        },
        seriesDefaults: {
            labels: {
                color: m
            },
            line: {
                markers: {
                    background: "#3d3d3d"
                }
            },
            verticalLine: {
                markers: {
                    background: "#3d3d3d"
                }
            },
            scatter: {
                markers: {
                    background: "#3d3d3d"
                }
            },
            scatterLine: {
                markers: {
                    background: "#3d3d3d"
                }
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#f9a319", "#1edee2", "#9eda29", "#ffce00", "#dd007f"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#919191"
            },
            labels: {
                color: m
            },
            majorGridLines: {
                color: "#636363"
            },
            minorGridLines: {
                color: "#464646"
            },
            title: {
                color: m
            }
        }
    });
    l["default"] = f({}, c, {
        chartArea: {
            background: ""
        },
        seriesColors: ["#f6921e", "#d6de23", "#8bc53f", "#26a9e0", "#9e1f63"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            majorGridLines: {
                color: "#aaaaaa"
            },
            minorGridLines: {
                color: "#cccccc"
            },
            line: {
                color: "#828282"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.forest = f({}, c, {
        title: {
            color: "#3c4c30"
        },
        legend: {
            labels: {
                color: "#3c4c30"
            }
        },
        seriesDefaults: {
            labels: {
                color: "#3c4c30"
            },
            verticalLine: {
                markers: {
                    background: "#d3e0c2"
                }
            },
            line: {
                markers: {
                    background: "#d3e0c2"
                }
            },
            scatter: {
                markers: {
                    background: "#d3e0c2"
                }
            },
            scatterLine: {
                markers: {
                    background: "#d3e0c2"
                }
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#4d7924", "#6dba3a", "#efab22", "#f05a28", "#603813"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            majorGridLines: {
                color: "#a7bc75"
            },
            minorGridLines: {
                color: "#cad7ac"
            },
            line: {
                color: "#5a8533"
            },
            labels: {
                color: "#3c4c30"
            },
            title: {
                color: "#3c4c30"
            }
        },
        tooltip: {
            background: "#D3E0C2",
            color: d
        }
    });
    l.hay = f({}, c, {
        title: {
            color: "#3c4c30"
        },
        legend: {
            labels: {
                color: "#3c4c30"
            }
        },
        seriesDefaults: {
            labels: {
                color: "#3c4c30"
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#205b02", "#61c407", "#9cd65f", "#bbbe94", "#323323"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            majorGridLines: {
                color: "#bfbdac"
            },
            minorGridLines: {
                color: "#d9d7cd"
            },
            line: {
                color: "#898772"
            },
            labels: {
                color: "#3c4c30"
            },
            title: {
                color: "#3c4c30"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.metro = f({}, c, {
        seriesDefaults: {
            bar: g,
            pie: g,
            column: g,
            pie: g
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#25a0da", "#309b46", "#d8e404", "#e61e26", "#313131"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            majorGridLines: {
                color: "#b4b4b4"
            },
            line: {
                color: "#b4b4b4"
            },
            minorGridLines: {
                color: "#d2d2d2"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.office2007 = f({}, c, {
        chartArea: {
            background: ""
        },
        seriesColors: ["#99c62a", "#27adcc", "#2477c9", "#7042b2", "#d83636"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            majorGridLines: {
                color: "#bdcce2"
            },
            minorGridLines: {
                color: "#d7e0ee"
            },
            line: {
                color: "#688CAF"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.office2010black = f({}, c, {
        title: {
            color: m
        },
        legend: {
            labels: {
                color: m
            }
        },
        seriesDefaults: {
            labels: {
                color: m
            },
            verticalLine: {
                markers: {
                    background: "#6f6f6f"
                }
            },
            line: {
                markers: {
                    background: "#6f6f6f"
                }
            },
            scatter: {
                markers: {
                    background: "#6f6f6f"
                }
            },
            scatterLine: {
                markers: {
                    background: "#6f6f6f"
                }
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#99c62a", "#27adcc", "#2477c9", "#7042b2", "#d83636"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#999999"
            },
            labels: {
                color: m
            },
            majorGridLines: {
                color: "#888888"
            },
            minorGridLines: {
                color: "#7c7c7c"
            },
            title: {
                color: m
            }
        },
        tooltip: {
            background: "#6F6F6F",
            color: m
        }
    });
    l.office2010blue = f({}, c, {
        title: {
            color: "#384E73"
        },
        legend: {
            labels: {
                color: "#384E73"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#384E73"
            }
        },
        seriesColors: ["#99c62a", "#27adcc", "#2477c9", "#7042b2", "#d83636"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#8ba0bc"
            },
            labels: {
                color: "#384e73"
            },
            majorGridLines: {
                color: "#d1dbe5"
            },
            minorGridLines: {
                color: "#e3e9ef"
            },
            title: {
                color: "#384e73"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.office2010silver = f({}, c, {
        title: {
            color: "#3b3b3b"
        },
        legend: {
            labels: {
                color: "#3b3b3b"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#3b3b3b"
            }
        },
        seriesColors: ["#99c62a", "#27adcc", "#2477c9", "#7042b2", "#d83636"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#a4abb2"
            },
            labels: {
                color: "#3b3b3b"
            },
            majorGridLines: {
                color: "#dbdfe4"
            },
            minorGridLines: {
                color: "#e9ecef"
            },
            title: {
                color: "#3b3b3b"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.outlook = f({}, c, {
        chartArea: {
            background: ""
        },
        seriesColors: ["#231f20", "#1b75bb", "#7da5e0", "#f9ec31", "#faaf40"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#5d8cc9"
            },
            majorGridLines: {
                color: "#aac3e8"
            },
            minorGridLines: {
                color: "#ccdbf1"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.simple = f({}, c, {
        title: {
            color: "#606060"
        },
        legend: {
            labels: {
                color: "#606060"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#606060"
            }
        },
        seriesColors: ["#231f20", "#404041", "#58595b", "#808184", "#929497"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#828282"
            },
            majorGridLines: {
                color: "#d1d1d1"
            },
            minorGridLines: {
                color: "#e3e3e3"
            },
            labels: {
                color: "#606060"
            },
            title: {
                color: "#606060"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.sitefinity = f({}, c, {
        chartArea: {
            background: ""
        },
        seriesColors: ["#a2d5e2", "#95b979", "#f9d67b", "#ea9d73", "#f19ca8", "#d06c6c"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#636363"
            },
            majorGridLines: {
                color: "#919191"
            },
            minorGridLines: {
                color: "#a1a1a1"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.sunset = f({}, c, {
        title: {
            color: "#854324"
        },
        legend: {
            labels: {
                color: "#854324"
            }
        },
        seriesDefaults: {
            labels: {
                color: "#854324"
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#3f1c12", "#ba3b01", "#d95a1a", "#e7931e", "#f9bc12"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#b7836a"
            },
            labels: {
                color: "#854324"
            },
            majorGridLines: {
                color: "#cebab1"
            },
            minorGridLines: {
                color: "#e2d6d0"
            },
            title: {
                color: "#854324"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.easyui = f({}, c, {
        chartArea: {
            background: ""
        },
        seriesColors: ["#7e7e7e", "#cbcbcb", "#a2ea8b", "#63ac39", "#000000"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#828282"
            },
            majorGridLines: {
                color: "#c6c6c6"
            },
            minorGridLines: {
                color: "#b4b4b4"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.transparent = f({}, c, {
        seriesDefaults: {
            opacity: 0.6,
            verticalLine: {
                markers: {
                    background: ""
                }
            },
            line: {
                markers: {
                    background: ""
                }
            },
            scatter: {
                markers: {
                    background: ""
                }
            },
            scatterLine: {
                markers: {
                    background: ""
                }
            }
        },
        chartArea: {
            background: ""
        },
        seriesColors: ["#f2f2f2", "#4d4d4d", "#d4d4d4", "#0d0d0d", "#999999"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#828282"
            },
            majorGridLines: {
                color: "#828282"
            },
            minorGridLines: {
                color: "#b4b4b4"
            }
        },
        tooltip: {
            background: m,
            color: d,
            opacity: 0.7
        }
    });
    l.vista = f({}, c, {
        title: {
            color: "#333333"
        },
        legend: {
            labels: {
                color: "#333333"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#333333"
            }
        },
        seriesColors: ["#83abc0", "#64d6f4", "#3399ff", "#03597a", "#000000"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#a7bac5"
            },
            majorGridLines: {
                color: "#d3d3d3"
            },
            labels: {
                color: "#333333"
            },
            minorGridLines: {
                color: "#e5e5e5"
            },
            title: {
                color: "#333333"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.web20 = f({}, c, {
        title: {
            color: "#001454"
        },
        legend: {
            labels: {
                color: "#001454"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#001454"
            }
        },
        seriesColors: ["#0e4302", "#64ba36", "#a0beea", "#3460b9", "#2c4072"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#708dc3"
            },
            majorGridLines: {
                color: "#cfd9e7"
            },
            labels: {
                color: "#001454"
            },
            minorGridLines: {
                color: "#e2e8f1"
            },
            title: {
                color: "#001454"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.webblue = f({}, c, {
        title: {
            color: "#0d202b"
        },
        legend: {
            labels: {
                color: "#0d202b"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#0d202b"
            }
        },
        seriesColors: ["#a2b3c7", "#76c8e8", "#358db0", "#426682", "#2d3d4f"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#708dc3"
            },
            majorGridLines: {
                color: "#d0d8dd"
            },
            labels: {
                color: "#0d202b"
            },
            minorGridLines: {
                color: "#e2e8f1"
            },
            title: {
                color: "#0d202b"
            }
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    l.windows7 = f({}, c, {
        title: {
            color: "#4c607a"
        },
        legend: {
            labels: {
                color: "#4c607a"
            }
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            labels: {
                color: "#4c607a"
            }
        },
        seriesColors: ["#a5b3c5", "#82afe5", "#358db0", "#03597a", "#152435"],
        categoryAxis: {
            majorGridLines: {
                visible: true
            }
        },
        axisDefaults: {
            line: {
                color: "#a5b3c5"
            },
            majorGridLines: {
                color: "#dae2e8"
            },
            labels: {
                color: "#4c607a"
            },
            minorGridLines: {
                color: "#e9eef1"
            },
            title: {
                color: "#4c607a"
            }
        },
        tooltip: {
            background: m,
            color: d
        },
        tooltip: {
            background: m,
            color: d
        }
    });
    e.themes = l;
    e.prototype.options.theme = "default"
})(jQuery);