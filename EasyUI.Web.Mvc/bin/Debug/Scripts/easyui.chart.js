(function ($, undefined) {

    // Imports ================================================================
    var doc = document,
        $t = $.easyui,
        Class = $t.Class,
        Widget = $t.Component,
        DataSource = $t.DataSource,
        baseTemplate = $t.template,
        format = function() { return $t.formatString.apply($t, arguments); },
        formatFunctionName = "$t.formatString",
        map = $.map,
        math = Math,
        proxy = $.proxy,
        getter = $t.getter,
        extend = $.extend;

    var template = function(template) {
        var paramName = "d",
            useWithBlock = false,
            functionBody = "var o,e=$.easyui.htmlEncode;",
            encodeRegExp = /\${([^}]*)}/g,
            parts,
            part,
            idx;

        if ($.isFunction(template)) {
            if (template.length === 2) {
                //looks like jQuery.template
                return function(d) {
                    return template($, { data: d }).join("");
                }
            }
            return template;
        }

        functionBody += useWithBlock ? "with(" + paramName + "){" : "";

        functionBody += "o=";

        parts = template
            .replace(/\n/g, '\\n')
            .replace(/\r/g, '\\r')
            .replace(/\t/g, '\\t')
            .replace(encodeRegExp, "#=e($1)#")
            .replace(/\\#/g, "__SHARP__")
            .split("#");

        for (idx = 0; idx < parts.length; idx ++) {
            part = parts[idx];

            if (idx % 2 === 0) {
            functionBody += "\'" + part.split("'").join("\\'") + "'";
            } else {
            if (part.charAt(0) === "=") {
                functionBody += "+(" + part.substring(1) + ")+";
            } else {
                functionBody += ";" + part + ";o+=";
            }
            }
        }

        functionBody += useWithBlock ? ";}" : ";";

        functionBody += "return o;";

        functionBody = functionBody.replace(/__SHARP__/g, '#');

        return new Function(paramName, functionBody);
    }

    // Constants ==============================================================
    var ABOVE = "above",
        DEFAULT_FONT = "12px sans-serif",
        ANIMATION_STEP = 10,
        BASELINE_MARKER_SIZE = 1,
        BAR = "bar",
        BAR_BORDER_BRIGHTNESS = 0.8,
        BAR_GAP = 1.5,
        BAR_SPACING = 0.4,
        BELOW = "below",
        BLACK = "#000",
        BOTTOM = "bottom",
        CENTER = "center",
        CHANGE = "change",
        CIRCLE = "circle",
        CLICK = "click",
        CLIP = "clip",
        COLUMN = "column",
        COORD_PRECISION = 3,
        DATABOUND = "dataBound",
        DEFAULT_HEIGHT = 400,
        DEFAULT_PRECISION = 6,
        DEFAULT_WIDTH = 600,
        DEGREE = math.PI / 180,
        FADEIN = "fadeIn",
        GLASS = "glass",
        HEIGHT = "height",
        HORIZONTAL = "horizontal",
        INITIAL_ANIMATION_DURATION = 600,
        INSIDE_BASE = "insideBase",
        INSIDE_END = "insideEnd",
        INTERPOLATE = "interpolate",
        LEFT = "left",
        LINE = "line",
        LINE_MARKER_SIZE = 8,
        LINEAR = "linear",
        MOUSEMOVE_TRACKING = "mousemove.tracking",
        MOUSEOVER = "mouseover",
        NONE = "none",
        NUM_AXIS_PADDING = 1.05,
        OBJECT = "object",
        ON_MINOR_TICKS = "onMinorTicks",
        OUTSIDE = "outside",
        OUTSIDE_END = "outsideEnd",
        OUTLINE_SUFFIX = "_outline",
        PIE = "pie",
        PIE_SECTOR_ANIM_DELAY = 70,
        RADIAL = "radial",
        RIGHT = "right",
        ROUNDED_BEVEL = "roundedBevel",
        SERIES_CLICK = "seriesClick",
        SQUARE = "square",
        SWING = "swing",
        TOP = "top",
        TOOLTIP_ANIMATION_DURATION = 150,
        TOOLTIP_OFFSET = 5,
        TOOLTIP_SHOW_DELAY = 100,
        TRIANGLE = "triangle",
        UNDEFINED = "undefined",
        VERTICAL = "vertical",
        WIDTH = "width",
        WHITE = "#fff",
        X = "x",
        Y = "y",
        ZERO = "zero",
        ZERO_THRESHOLD = 0.2;

    // Chart ==================================================================
    var Chart = Widget.extend({
        init: function(element, options) {
            var chart = this,
                themeOptions,
                theme;

            Widget.fn.init.call(chart, element);

            if (options && options.dataSource) {
                chart.dataSource = DataSource
                    .create(options.dataSource)
                    .bind(CHANGE, proxy(chart._onDataChanged, chart));
            }

            options = deepExtend({}, chart.options, options);
            theme = options.theme;
            themeOptions = theme ? Chart.themes[theme] || Chart.themes[theme.toLowerCase()] : {};
            applyAxisDefaults(options, themeOptions);
            applySeriesDefaults(options, themeOptions);

            chart.options = deepExtend({}, themeOptions, options);

            applySeriesColors(chart.options);

            chart.bind([
                DATABOUND,
                SERIES_CLICK
            ], chart.options);

            $(element).addClass("k-chart");

            chart._refresh();
            chart._attachEvents();
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
                type: COLUMN,
                data: [],
                bar: {
                    gap: BAR_GAP,
                    spacing: BAR_SPACING
                },
                column: {
                    gap: BAR_GAP,
                    spacing: BAR_SPACING
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

        refresh: function() {
            var chart = this;

            applySeriesDefaults(chart.options);
            applyAxisDefaults(chart.options);

            chart._refresh();
        },

        _refresh: function() {
            var chart = this;
            if (chart.options.dataSource && chart.options.autoBind) {
                chart.dataSource.query();
            } else {
                chart._redraw();
            }
        },

        _redraw: function() {
            var chart = this,
                options = chart.options,
                element = chart.element,
                model = chart._model = chart._getModel(),
                plotArea = chart._plotArea = model._plotArea,
                viewClass = chart._supportsSVG() ? Chart.SVGView : Chart.VMLView,
                view = chart._view = viewClass.fromModel(model);

            element.css("position", "relative");
            chart._viewElement = view.renderTo(element[0]);
            chart._tooltip = new Tooltip(element, options.tooltip);
            chart._highlight = new Highlight(view, chart._viewElement);
        },

        svg: function() {
            var model = this._getModel(),
                view = Chart.SVGView.fromModel(model);

            return view.render();
        },

        _getModel: function() {
            var chart = this,
                options = chart.options,
                element = chart.element,
                model = new RootElement(deepExtend({
                    width: element.width() || DEFAULT_WIDTH,
                    height: element.height() || DEFAULT_HEIGHT,
                    transitions: options.transitions
                    }, options.chartArea)),
                plotArea;

            if (options.title && options.title.visible && options.title.text) {
                model.append(new Title(options.title));
            }

            plotArea = model._plotArea = new PlotArea(options);
            if (options.legend.visible) {
                model.append(new Legend(plotArea.options.legend));
            }
            model.append(plotArea);
            model.reflow();

            return model;
        },

        // Needs to be overridable in tests
        _supportsSVG: supportsSVG,

        _attachEvents: function() {
            var chart = this,
                element = chart.element;

            element.bind(CLICK, proxy(chart._click, chart));
            element.bind(MOUSEOVER, proxy(chart._mouseOver, chart));
        },

        _getPoint: function(e) {
            var chart = this,
                model = chart._model,
                coords = chart._eventCoordinates(e),
                targetId = e.target.id,
                chartElement = model.idMap[targetId],
                metadata = model.idMapMetadata[targetId],
                point;

            if (chartElement) {
                if (chartElement.getNearestPoint && metadata) {
                    point = chartElement.getNearestPoint(coords.x, coords.y, metadata.seriesIx);
                } else {
                    point = chartElement;
                }
            }

            return point;
        },

        _eventCoordinates: function(e) {
            var chart = this,
                chartOffset = chart.element.offset(),
                win = $(window);

            return({
                x: e.clientX - chartOffset.left + win.scrollLeft(),
                y: e.clientY - chartOffset.top + win.scrollTop()
            });
        },

        _click: function(e) {
            var chart = this,
                point = chart._getPoint(e);

            if (point) {
                chart.trigger(SERIES_CLICK, {
                    value: point.value,
                    category: point.category,
                    series: point.series,
                    dataItem: point.dataItem,
                    element: $(e.target)
                });
            }
        },

        _mouseOver: function(e) {
            var chart = this,
                tooltip = chart._tooltip,
                highlight = chart._highlight,
                point;

            if (!highlight || highlight.element === e.target) {
                return;
            }

            point = chart._getPoint(e);
            if (point) {
                chart._activePoint = point;

                if (chart.options.tooltip.visible) {
                    tooltip.show(point);
                }

                highlight.show(point);

                $(doc.body).bind(MOUSEMOVE_TRACKING, proxy(chart._mouseMove, chart));
            }
        },

        _mouseMove: function(e) {
            var chart = this,
                tooltip = chart._tooltip,
                highlight = chart._highlight,
                coords = chart._eventCoordinates(e),
                point = chart._activePoint,
                owner,
                seriesPoint;

            if (chart._plotArea.box.containsPoint(coords.x, coords.y)) {
                if (point && point.series.type === LINE) {
                    owner = point.owner;
                    seriesPoint = owner.getNearestPoint(coords.x, coords.y, point.seriesIx);
                    if (seriesPoint && seriesPoint != point) {
                        chart._activePoint = seriesPoint;

                        if (tooltip.visible) {
                            tooltip.show(seriesPoint);
                        }
                        highlight.show(seriesPoint);
                    }
                }
            } else {
                $(doc.body).unbind(MOUSEMOVE_TRACKING);

                delete chart._activePoint;
                tooltip.hide();
                highlight.hide();
            }
        },

        _onDataChanged: function() {
            var chart = this,
                options = chart.options,
                series = options.series,
                categoryAxis = options.categoryAxis,
                data = chart.dataSource.view(),
                row,
                category,
                currentSeries,
                value;

            for (var seriesIdx = 0, seriesLength = series.length; seriesIdx < seriesLength; seriesIdx++) {
                var currentSeries = series[seriesIdx];
                if (currentSeries.field || (currentSeries.xField && currentSeries.yField)) {
                    currentSeries.data = [];
                    currentSeries.dataItems = [];
                }
            }

            for (var dataIdx = 0, dataLength = data.length; dataIdx < dataLength; dataIdx++) {
                row = data[dataIdx];

                if (categoryAxis.field) {
                    category = getter(categoryAxis.field, true)(row);
                    if (dataIdx === 0) {
                        categoryAxis.categories = [category];
                    } else {
                        categoryAxis.categories.push(category);
                    }
                }

                for (var seriesIdx = 0, seriesLength = series.length; seriesIdx < seriesLength; seriesIdx++) {
                    currentSeries = series[seriesIdx];

                    if (currentSeries.field) {
                        value = getter(currentSeries.field, true)(row);
                    } else if (currentSeries.xField && currentSeries.yField) {
                        value = [getter(currentSeries.xField, true)(row), getter(currentSeries.yField, true)(row)];
                    } else {
                        value = undefined;
                    }

                    if (defined(value)) {
                        if (dataIdx === 0) {
                            currentSeries.data = [value];
                            currentSeries.dataItems = [row];
                        } else {
                            currentSeries.data.push(value);
                            currentSeries.dataItems.push(row);
                        }
                    }
                }
            }

            chart.trigger(DATABOUND);
            chart._redraw();
        }
    });


    // **************************
    // View Model
    // **************************
    var Point2D = Class.extend({
        init: function(x, y) {
            var point = this;
            point.x = round(x, COORD_PRECISION);
            point.y = round(y, COORD_PRECISION);
        }
    });

    var Box2D = Class.extend({
        init: function(x1, y1, x2, y2) {
            var box = this;
            box.x1 = x1 || 0;
            box.x2 = x2 || 0;
            box.y1 = y1 || 0;
            box.y2 = y2 || 0;
        },

        width: function() {
            return this.x2 - this.x1;
        },

        height: function() {
            return this.y2 - this.y1;
        },

        translate: function(dx, dy) {
            var box = this;

            box.x1 += dx;
            box.x2 += dx;
            box.y1 += dy;
            box.y2 += dy;

            return box;
        },

        move: function(x, y) {
            var box = this,
                height = box.height(),
                width = box.width();

            box.x1 = x;
            box.y1 = y;
            box.x2 = box.x1 + width;
            box.y2 = box.y1 + height;

            return box;
        },

        wrap: function(targetBox) {
            var box = this;

            box.x1 = math.min(box.x1, targetBox.x1);
            box.y1 = math.min(box.y1, targetBox.y1);
            box.x2 = math.max(box.x2, targetBox.x2);
            box.y2 = math.max(box.y2, targetBox.y2);

            return box;
        },

        snapTo: function(targetBox, axis) {
            var box = this;

            if (axis == X || !axis) {
                box.x1 = targetBox.x1;
                box.x2 = targetBox.x2;
            }

            if (axis == Y || !axis) {
                box.y1 = targetBox.y1;
                box.y2 = targetBox.y2;
            }

            return box;
        },

        alignTo: function(targetBox, edge) {
            var box = this,
                height = box.height(),
                width = box.width(),
                axis = edge == TOP || edge == BOTTOM ? Y : X,
                offset = axis == Y ? height : width;

            if (edge == TOP || edge == LEFT) {
                box[axis + 1] = targetBox[axis + 1] - offset;
            } else {
                box[axis + 1] = targetBox[axis + 2];
            }

            box.x2 = box.x1 + width;
            box.y2 = box.y1 + height;

            return box;
        },

        shrink: function(dw, dh) {
            var box = this;

            box.x2 -= dw;
            box.y2 -= dh;

            return box;
        },

        expand: function(dw, dh) {
            this.shrink(-dw, -dh);
            return this;
        },

        pad: function(padding) {
            var box = this,
                spacing = getSpacing(padding);

            box.x1 -= spacing.left;
            box.x2 += spacing.right;
            box.y1 -= spacing.top;
            box.y2 += spacing.bottom;

            return box;
        },

        unpad: function(padding) {
            var box = this,
                spacing = getSpacing(padding);

            spacing.left = -spacing.left;
            spacing.top = -spacing.top;
            spacing.right = -spacing.right;
            spacing.bottom = -spacing.bottom;

            return box.pad(spacing);
        },

        clone: function() {
            var box = this;

            return new Box2D(box.x1, box.y1, box.x2, box.y2);
        },

        center: function() {
            var box = this;

            return {
                x: box.x1 + box.width() / 2,
                y: box.y1 + box.height() / 2
            };
        },

        containsPoint: function(x, y) {
            var box = this;

            return x >= box.x1 && x <= box.x2 &&
                   y >= box.y1 && y <= box.y2;
        },

        points: function() {
            var box = this;

            return [
                new Point2D(box.x1, box.y1),
                new Point2D(box.x2, box.y1),
                new Point2D(box.x2, box.y2),
                new Point2D(box.x1, box.y2)
            ];
        }
    });

    var Sector = Class.extend({
        init: function(c, r, startAngle, angle) {
            var sector = this;

            sector.c = c;
            sector.r = r;
            sector.startAngle = startAngle;
            sector.angle = angle;
        },

        clone: function() {
            var s = this;
            return new Sector(s.c, s.r, s.startAngle, s.angle);
        },

        expand: function(value) {
            this.r += value;
            return this;
        },

        middle: function() {
            return this.startAngle + this.angle / 2;
        },

        radius: function(newRadius) {
            this.r = newRadius;
            return this;
        },

        point: function(angle) {
            var sector = this,
                radianAngle = angle * DEGREE,
                ax = math.cos(radianAngle),
                ay = math.sin(radianAngle),
                x = sector.c.x - (ax * sector.r),
                y = sector.c.y - (ay * sector.r);

            return new Point2D(x, y);
        }
    });

    var ChartElement = Class.extend({
        init: function(options) {
            var element = this;
            element.children = [];

            element.options = deepExtend({}, element.options, options);
        },

        reflow: function(targetBox) {
            var element = this,
                children = element.children,
                box,
                i,
                currentChild;

            for (i = 0; i < children.length; i++) {
                currentChild = children[i];

                currentChild.reflow(targetBox);
                box = box ? box.wrap(currentChild.box) : currentChild.box.clone();
            }

            element.box = box;
        },

        getViewElements: function(view) {
            var element = this,
                viewElements = [],
                children = element.children,
                childrenCount = children.length;

            for (var i = 0; i < childrenCount; i++) {
                viewElements.push.apply(viewElements,
                    children[i].getViewElements(view));
            }

            return viewElements;
        },

        registerId: function(id, metadata) {
            var element = this,
                root;

            root = element.getRoot();
            if (root) {
                root.idMap[id] = element;
                if (metadata) {
                    root.idMapMetadata[id] = metadata;
                }
            }
        },

        translateChildren: function(dx, dy) {
            var element = this,
                children = element.children,
                childrenCount = children.length,
                i;

            for (i = 0; i < childrenCount; i++) {
                children[i].box.translate(dx, dy);
            }
        },

        append: function() {
            var element = this,
                i,
                length = arguments.length;

            append(element.children, arguments);

            for (i = 0; i < length; i++) {
                arguments[i].parent = element;
            }
        },

        getRoot: function() {
            var element = this,
                parent = element.parent;

            return parent ? parent.getRoot() : null;
        }
    });

    var RootElement = ChartElement.extend({
        init: function(options) {
            var root = this;

            root.idMap = {};
            root.idMapMetadata = {};

            ChartElement.fn.init.call(root, options);
        },

        options: {
            width: DEFAULT_WIDTH,
            height: DEFAULT_HEIGHT,
            background: WHITE,
            border: {
                color: BLACK,
                width: 0
            },
            margin: getSpacing(5),
            zIndex: -1
        },

        reflow: function() {
            var root = this,
                options = root.options,
                children = root.children,
                currentBox = new Box2D(0, 0, options.width, options.height);

            root.box = currentBox.unpad(options.margin);

            for (var i = 0; i < children.length; i++) {
                children[i].reflow(currentBox);
                currentBox = boxDiff(currentBox, children[i].box);
            }
        },

        getViewElements: function(view) {
            var root = this,
                options = root.options,
                border = options.border || {},
                box = root.box.clone().pad(options.margin).unpad(border.width),
                elements = [
                    view.createRect(box, {
                        stroke: border.width ? border.color : "",
                        strokeWidth: border.width,
                        dashType: border.dashType,
                        fill: options.background,
                        zIndex: options.zIndex })
                ];

            return elements.concat(
                ChartElement.fn.getViewElements.call(root, view)
            );
        },

        getRoot: function() {
            return this;
        }
    });

    var BoxElement = ChartElement.extend({
        init: function(options) {
            ChartElement.fn.init.call(this, options);
        },

        options: {
            align: LEFT,
            vAlign: TOP,
            margin: {},
            padding: {},
            border: {
                color: BLACK,
                width: 0
            },
            background: "",
            width: 0,
            height: 0,
            visible: true
        },

        reflow: function(targetBox) {
            var element = this,
                box,
                contentBox,
                options = element.options,
                children = element.children,
                margin = getSpacing(options.margin),
                padding = getSpacing(options.padding),
                border = options.border,
                borderWidth = border.width;

            ChartElement.fn.reflow.call(element, targetBox);

            if (children.length === 0) {
                box = element.box = new Box2D(0, 0, options.width, options.height);
            } else {
                box = element.box;
            }

            contentBox = element.contentBox = box.clone();

            box.pad(padding).pad(borderWidth).pad(margin);

            element.align(targetBox, X, options.align);
            element.align(targetBox, Y, options.vAlign);

            element.paddingBox = box.clone().unpad(margin).unpad(borderWidth);

            element.translateChildren(
                box.x1 - contentBox.x1 + margin.left + borderWidth + padding.left,
                box.y1 - contentBox.y1 + margin.top + borderWidth + padding.top);
        },

        align: function(targetBox, axis, alignment) {
            var element = this,
                box = element.box,
                c1 = axis + 1,
                c2 = axis + 2,
                sizeFunc = axis === X ? WIDTH : HEIGHT,
                size = box[sizeFunc]();

            if (inArray(alignment, [LEFT, TOP])) {
                box[c1] = targetBox[c1];
                box[c2] = box[c1] + size;
            } else if (inArray(alignment, [RIGHT, BOTTOM])) {
                box[c2] = targetBox[c2];
                box[c1] = box[c2] - size;
            } else if (alignment == CENTER) {
                box[c1] = targetBox[c1] + (targetBox[sizeFunc]() - size) / 2;
                box[c2] = box[c1] + size;
            }
        },

        hasBox: function() {
            var options = this.options;
            return options.border.width || options.background;
        },

        getViewElements: function(view, renderOptions) {
            var boxElement = this,
                options = boxElement.options;

            if (!options.visible) {
                return [];
            }

            var border = options.border || {},
                elements = [];

            if (boxElement.hasBox()) {
                elements.push(
                    view.createRect(boxElement.paddingBox, deepExtend({
                        id: options.id,
                        stroke: border.width ? border.color : "",
                        strokeWidth: border.width,
                        dashType: border.dashType,
                        strokeOpacity: options.opacity,
                        fill: options.background,
                        fillOpacity: options.opacity,
                        animation: options.animation,
                        zIndex: options.zIndex
                    }, renderOptions))
                );
            }

            return elements.concat(
                ChartElement.fn.getViewElements.call(boxElement, view)
            );
        }
    });

    var Text = ChartElement.extend({
        init: function(content, options) {
            var text = this;

            ChartElement.fn.init.call(text, options);

            // Calculate size
            text.content = content;
            text.reflow(new Box2D());
        },

        options: {
            font: DEFAULT_FONT,
            color: BLACK,
            align: LEFT,
            vAlign: ""
        },

        reflow: function(targetBox) {
            var text = this,
                options = text.options,
                size = options.size = measureText(
                                        text.content,
                                        { font: options.font },
                                        options.rotation);

            text.baseline = size.baseline;

            if (options.align == LEFT) {
                text.box = new Box2D(
                    targetBox.x1, targetBox.y1,
                    targetBox.x1 + size.width, targetBox.y1 + size.height);
            } else if (options.align == RIGHT) {
                text.box = new Box2D(
                    targetBox.x2 - size.width, targetBox.y1,
                    targetBox.x2, targetBox.y1 + size.height);
            } else if (options.align == CENTER) {
                var margin = (targetBox.width() - size.width) / 2;
                text.box = new Box2D(
                    round(targetBox.x1 + margin, COORD_PRECISION), targetBox.y1,
                    round(targetBox.x2 - margin, COORD_PRECISION), targetBox.y1 + size.height);
            }

            if (options.vAlign == CENTER) {
                var margin = (targetBox.height() - size.height) /2;
                text.box = new Box2D(
                    text.box.x1, targetBox.y1 + margin,
                    text.box.x2, targetBox.y2 - margin);
            } else if (options.vAlign == BOTTOM) {
                text.box = new Box2D(
                    text.box.x1, targetBox.y2 - size.height,
                    text.box.x2, targetBox.y2);
            } else if (options.vAlign == TOP) {
                text.box = new Box2D(
                    text.box.x1, targetBox.y1,
                    text.box.x2, targetBox.y1 + size.height);
            }
        },

        getViewElements: function(view) {
            var text = this,
                options = text.options;

            ChartElement.fn.getViewElements.call(this, view);

            return [
                view.createText(text.content,
                    deepExtend({}, options, {
                        x: text.box.x1, y: text.box.y1,
                        baseline: text.baseline
                    })
                )
            ];
        }
    });

    var TextBox = BoxElement.extend({
        init: function(content, options) {
            var textBox = this,
                text;

            BoxElement.fn.init.call(textBox, options);
            options = textBox.options;

            if (!options.template) {
                content = options.format ? format(options.format, content) : content
            }

            text = new Text(content, deepExtend({ }, options, { align: LEFT, vAlign: TOP }));
            textBox.append(text);

            if (textBox.hasBox()) {
                text.options.id = uniqueId();
            }

            // Calculate size
            textBox.reflow(new Box2D());
        }
    });

    var BarLabel = ChartElement.extend({
        init: function(content, options) {
            var barLabel = this;
            ChartElement.fn.init.call(barLabel, options);

            barLabel.append(new TextBox(content, barLabel.options));
        },

        options: {
            position: OUTSIDE_END,
            margin: getSpacing(3),
            padding: getSpacing(4),
            color: BLACK,
            background: "",
            border: {
                width: 1,
                color: ""
            },
            aboveAxis: true,
            isVertical: false,
            animation: {
                type: FADEIN,
                delay: INITIAL_ANIMATION_DURATION
            },
            zIndex: 1
        },

        reflow: function(targetBox) {
            var barLabel = this,
                options = barLabel.options,
                isVertical = options.isVertical,
                aboveAxis = options.aboveAxis,
                text = barLabel.children[0],
                box = text.box,
                padding = text.options.padding;

            text.options.align = isVertical ? CENTER : LEFT;
            text.options.vAlign = isVertical ? TOP : CENTER;

            if (options.position == INSIDE_END) {
                if (isVertical) {
                    text.options.vAlign = TOP;

                    if (!aboveAxis && box.height() < targetBox.height()) {
                        text.options.vAlign = BOTTOM;
                    }
                } else {
                    text.options.align = aboveAxis ? RIGHT : LEFT;
                }
            } else if (options.position == CENTER) {
                text.options.vAlign = CENTER;
                text.options.align = CENTER;
            } else if (options.position == INSIDE_BASE) {
                if (isVertical) {
                    text.options.vAlign = aboveAxis ? BOTTOM : TOP;
                } else {
                    text.options.align = aboveAxis ? LEFT : RIGHT;
                }
            } else if (options.position == OUTSIDE_END) {
                if (isVertical) {
                    if (aboveAxis) {
                        targetBox = new Box2D(
                            targetBox.x1, targetBox.y1 - box.height(),
                            targetBox.x2, targetBox.y1
                        );
                    } else {
                        targetBox = new Box2D(
                            targetBox.x1, targetBox.y2,
                            targetBox.x2, targetBox.y2 + box.height()
                        );
                    }
                } else {
                    text.options.align = CENTER;
                    if (aboveAxis) {
                        targetBox = new Box2D(
                            targetBox.x2 + box.width(), targetBox.y1,
                            targetBox.x2, targetBox.y2
                        );
                    } else {
                        targetBox = new Box2D(
                            targetBox.x1 - box.width(), targetBox.y1,
                            targetBox.x1, targetBox.y2
                        );
                    }
                }
            }

            if (isVertical) {
                padding.left = padding.right =
                    (targetBox.width() - text.contentBox.width()) / 2;
            } else {
                padding.top = padding.bottom =
                    (targetBox.height() - text.contentBox.height()) / 2;
            }

            text.reflow(targetBox);
        }
    });

    var Title = ChartElement.extend({
        init: function(options) {
            var title = this;
            ChartElement.fn.init.call(title, options);

            title.append(
                new TextBox(title.options.text, deepExtend({}, title.options, {
                    vAlign: title.options.position
                }))
            );
        },

        options: {
            text: "",
            color: BLACK,
            position: TOP,
            align: CENTER,
            margin: getSpacing(5),
            padding: getSpacing(5)
        },

        reflow: function(targetBox) {
            var title = this;

            ChartElement.fn.reflow.call(title, targetBox);
            title.box.snapTo(targetBox, X);
        }
    });

    var Legend = ChartElement.extend({
        init: function(options) {
            var legend = this;

            ChartElement.fn.init.call(legend, options);

            legend.createLabels();
        },

        options: {
            position: RIGHT,
            items: [],
            labels: {},
            offsetX: 0,
            offsetY: 0,
            margin: getSpacing(10),
            padding: getSpacing(5),
            border: {
                color: BLACK,
                width: 0
            },
            background: "",
            zIndex: 1
        },

        createLabels: function() {
            var legend = this,
                items = legend.options.items,
                count = items.length,
                label,
                name,
                i;

            for (i = 0; i < count; i++) {
                name = items[i].name;
                    label = new Text(name, legend.options.labels);

                legend.append(label);
            }
        },

        reflow: function(targetBox) {
            var legend = this,
                options = legend.options,
                childrenCount = legend.children.length;

            if (childrenCount === 0) {
                legend.box = targetBox.clone();
                return;
            }

            if (options.position == "custom") {
                legend.customLayout(targetBox);
                return;
            }

            if (options.position == TOP || options.position == BOTTOM) {
                legend.horizontalLayout(targetBox);
            } else {
                legend.verticalLayout(targetBox);
            }
        },

        getViewElements: function(view) {
            var legend = this,
                children = legend.children,
                options = legend.options,
                items = options.items,
                count = items.length,
                markerSize = legend.markerSize(),
                group = view.createGroup({ zIndex: options.zIndex }),
                border = options.border || {},
                markerBox,
                labelBox,
                color,
                label,
                box,
                i;

            append(group.children, ChartElement.fn.getViewElements.call(legend, view));

            for (i = 0; i < count; i++) {
                color = items[i].color;
                label = children[i];
                markerBox = new Box2D();
                    box = label.box;

                labelBox = labelBox ? labelBox.wrap(box) : box.clone();

                markerBox.x1 = box.x1 - markerSize * 2;
                markerBox.x2 = markerBox.x1 + markerSize;

                if (options.position == TOP || options.position == BOTTOM) {
                    markerBox.y1 = box.y1 + markerSize / 2;
                } else {
                    markerBox.y1 = box.y1 + (box.height() - markerSize) / 2;
                }

                markerBox.y2 = markerBox.y1 + markerSize;

                group.children.push(view.createRect(markerBox, { fill: color, stroke: color }));
            }

            if (children.length > 0) {
                var padding = getSpacing(options.padding);
                padding.left += markerSize * 2;
                labelBox.pad(padding);
                group.children.unshift(view.createRect(labelBox, {
                    stroke: border.width ? border.color : "",
                    strokeWidth: border.width,
                    dashType: border.dashType,
                    fill: options.background })
                );
            }

            return [ group ];
        },

        verticalLayout: function(targetBox) {
            var legend = this,
                options = legend.options,
                children = legend.children,
                childrenCount = children.length,
                labelBox = children[0].box.clone(),
                offsetX,
                offsetY,
                margin = getSpacing(options.margin),
                markerSpace = legend.markerSize() * 2;

            // Position labels below each other
            for (var i = 1; i < childrenCount; i++) {
                var label = legend.children[i];
                label.box.alignTo(legend.children[i - 1].box, BOTTOM);
                labelBox.wrap(label.box);
            }

            // Vertical center is calculated relative to the container, not the parent!
            if (options.position == LEFT) {
                offsetX = targetBox.x1 + markerSpace + margin.left;
                offsetY = (targetBox.y2 - labelBox.height()) / 2;
                labelBox.x2 += markerSpace + margin.left + margin.right;
            } else {
                offsetX = targetBox.x2 - labelBox.width() - margin.right;
                offsetY = (targetBox.y2 - labelBox.height()) / 2;
                labelBox.translate(offsetX, offsetY);
                labelBox.x1 -= markerSpace + margin.left;
            }

            legend.translateChildren(offsetX + options.offsetX,
                    offsetY + options.offsetY);

            var labelBoxWidth = labelBox.width();
            labelBox.x1 = math.max(targetBox.x1, labelBox.x1);
            labelBox.x2 = labelBox.x1 + labelBoxWidth;

            labelBox.y1 = targetBox.y1;
            labelBox.y2 = targetBox.y2;

            legend.box = labelBox;
        },

        horizontalLayout: function(targetBox) {
            var legend = this,
                options = legend.options,
                children = legend.children,
                childrenCount = children.length,
                box = children[0].box.clone(),
                markerWidth = legend.markerSize() * 3,
                offsetX,
                offsetY,
                margin = getSpacing(options.margin),
                boxWidth = children[0].box.width() + markerWidth,
                plotAreaWidth = targetBox.width(),
                label,
                labelY = 0,
                i;

            // Position labels next to each other
            for (i = 1; i < childrenCount; i++) {
                label = children[i];

                boxWidth += label.box.width() + markerWidth;
                if (boxWidth > plotAreaWidth - markerWidth) {
                    label.box = new Box2D(box.x1, box.y2,
                        box.x1 + label.box.width(), box.y2 + label.box.height());
                    boxWidth = label.box.width() + markerWidth;
                    labelY = label.box.y1;
                } else {
                    label.box.alignTo(children[i - 1].box, RIGHT);
                    label.box.y2 = labelY + label.box.height();
                    label.box.y1 = labelY;
                    label.box.translate(markerWidth, 0);
                }
                box.wrap(label.box);
            }

            offsetX = (targetBox.width() - box.width() + markerWidth) / 2;
            if (options.position === TOP) {
                offsetY = targetBox.y1 + margin.top;
                box.y2 = targetBox.y1 + box.height() + margin.top + margin.bottom;
                box.y1 = targetBox.y1;
            } else {
                offsetY = targetBox.y2 - box.height() - margin.bottom;
                box.y1 = targetBox.y2 - box.height() - margin.top - margin.bottom;
                box.y2 = targetBox.y2;
            }

            legend.translateChildren(offsetX + options.offsetX,
                    offsetY + options.offsetY);

            box.x1 = targetBox.x1;
            box.x2 = targetBox.x2;

            legend.box = box;
        },

        customLayout: function (targetBox) {
            var legend = this,
                options = legend.options,
                children = legend.children,
                childrenCount = children.length,
                labelBox = children[0].box.clone(),
                markerWidth = legend.markerSize() * 2,
                i;

            // Position labels next to each other
            for (i = 1; i < childrenCount; i++) {
                labelBox = legend.children[i].box;
                labelBox.alignTo(legend.children[i - 1].box, BOTTOM);
                labelBox.wrap(labelBox);
            }

            legend.translateChildren(options.offsetX + markerWidth, options.offsetY);

            legend.box = targetBox;
        },

        markerSize: function() {
            var legend = this,
                children = legend.children;

            if (children.length > 0) {
                return children[0].box.height() / 2;
            } else {
                return 0;
            }
        }
    });

    var Axis = ChartElement.extend({
        init: function(options) {
            var axis = this;

            ChartElement.fn.init.call(axis, options);
        },

        options: {
            labels: {
                rotation: 0
            },
            line: {
                width: 1,
                color: BLACK
            },
            majorTickType: OUTSIDE,
            majorTickSize: 4,
            minorTickType: NONE,
            minorTickSize: 3,
            axisCrossingValue: 0,
            minorGridLines: {
                visible: false,
                width: 1,
                color: BLACK
            },
            margin: 5
        },

        renderTicks: function(view) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                box = axis.box,
                majorTicks = axis.getMajorTickPositions(),
                ticks = [];

            if (options.majorTickType.toLowerCase() === OUTSIDE) {
                ticks = ticks.concat(map(majorTicks, function(pos) {
                    return {
                        pos: pos,
                        size: options.majorTickSize,
                        width: options.line.width,
                        color: options.line.color
                    };
                }));
            }

            if (options.minorTickType.toLowerCase()  === OUTSIDE) {
                ticks = ticks.concat(map(axis.getMinorTickPositions(), function(pos) {
                    if (options.majorTickType.toLowerCase() !== NONE) {
                        if (!inArray(pos, majorTicks)) {
                            return {
                                pos: pos,
                                size: options.minorTickSize,
                                width: options.line.width,
                                color: options.line.color
                            };
                        }
                    } else {
                        return {
                            pos: pos,
                            size: options.minorTickSize,
                            width: options.line.width,
                            color: options.line.color
                        };
                    }
                }));
            }

            return map(ticks, function(tick) {
                if (isVertical) {
                    return view.createLine(
                        box.x2 - tick.size, tick.pos, box.x2, tick.pos,
                        {
                            strokeWidth: tick.width,
                            stroke: tick.color
                        }
                    );
                } else {
                    return view.createLine(
                        tick.pos, box.y1, tick.pos, box.y1 + tick.size,
                        {
                            strokeWidth: tick.width,
                            stroke: tick.color
                        }
                    );
                }
            });
        },

        getActualTickSize: function () {
            var axis = this,
                options = axis.options,
                tickSize = 0;

            if (options.majorTickType != NONE && options.minorTickType != NONE ) {
                tickSize = math.max(options.majorTickSize, options.minorTickSize);
            } else if (options.majorTickType != NONE) {
                tickSize = options.majorTickSize;
            } else if (options.minorTickType != NONE) {
                tickSize = options.minorTickSize;
            }

            return tickSize;
        },

        arrangeLabels: function(maxLabelWidth, maxLabelHeight, positions) {
            var axis = this,
                options = axis.options,
                isVertical = axis.options.orientation === VERTICAL,
                children = axis.children,
                tickPositions = axis.getMajorTickPositions(),
                tickSize = axis.getActualTickSize(),
                labelBox,
                labelY,
                i;

            for (i = 0; i < children.length; i++) {
                var label = children[i],
                    tickIx = isVertical ? (children.length - 1 - i) : i,
                    labelSize = isVertical ? label.box.height() : label.box.width(),
                    labelPos = tickPositions[tickIx] - (labelSize / 2),
                    firstTickPosition,
                    nextTickPosition,
                    middle,
                    labelX;

                if (isVertical) {
                    if (positions == ON_MINOR_TICKS) {
                        firstTickPosition = tickPositions[i];
                        nextTickPosition = tickPositions[i + 1];

                        middle = firstTickPosition + (nextTickPosition - firstTickPosition) / 2;
                        labelPos = middle - (labelSize / 2);
                    }
                    labelX = axis.box.x2 - options.margin - tickSize;

                    labelBox = new Box2D(labelX - label.box.width(), labelPos,
                                         labelX, labelPos)
                } else {
                    if (positions == ON_MINOR_TICKS) {
                        firstTickPosition = tickPositions[i];
                        nextTickPosition = tickPositions[i + 1];
                    } else {
                        firstTickPosition = labelPos;
                        nextTickPosition = labelPos + labelSize;
                    }
                    labelY = axis.box.y1 + tickSize + options.margin;

                    labelBox = new Box2D(firstTickPosition, labelY,
                                         nextTickPosition, labelY);
                }

                label.reflow(labelBox);
            }
        }
    });

    var NumericAxis = Axis.extend({
        init: function(seriesMin, seriesMax, options) {
            var axis = this,
                defaultOptions = axis.initDefaults(seriesMin, seriesMax, options),
                labelTemplate,
                text,
                i;

            Axis.fn.init.call(axis, defaultOptions);
            options = axis.options;

            var majorDivisions = axis.getDivisions(options.majorUnit),
                currentValue = options.min,
                align = options.orientation === VERTICAL ? RIGHT : CENTER,
                labelOptions = deepExtend({ }, options.labels, {
                    align: align, zIndex: options.zIndex
                }),
                labelText;

            for (i = 0; i < majorDivisions; i++) {
                if (labelOptions.template) {
                    labelTemplate = baseTemplate(labelOptions.template);
                    labelText = labelTemplate({ value: currentValue });
                }

                text = new TextBox(labelText || currentValue, labelOptions);

                axis.append(text);

                currentValue = round(currentValue + options.majorUnit, DEFAULT_PRECISION);
            }
        },

        options: {
            min: 0,
            max: 1,
            orientation: VERTICAL,
            majorGridLines: {
                visible: true,
                width: 1,
                color: BLACK
            },
            zIndex: 1
        },

        initDefaults: function(seriesMin, seriesMax, options) {
            var axis = this,
                autoMin = axis.autoAxisMin(seriesMin, seriesMax),
                autoMax = axis.autoAxisMax(seriesMin, seriesMax),
                autoMajorUnit = axis.autoMajorUnit(autoMin, autoMax),
                autoOptions = {
                    min: autoMin,
                    max: autoMax,
                    majorUnit: autoMajorUnit
                },
                userSetLimits;

            autoOptions.min = floor(autoMin * NUM_AXIS_PADDING, autoMajorUnit);
            autoOptions.max = ceil(autoMax * NUM_AXIS_PADDING, autoMajorUnit);

            if (options) {
                userSetLimits = defined(options.min) || defined(options.max);
                if (userSetLimits) {
                    if (options.min === options.max) {
                        if (options.min > 0) {
                            options.min = 0;
                        } else {
                            options.max = 1;
                        }
                    }
                }

                if (options.majorUnit) {
                    autoOptions.min = floor(autoOptions.min, options.majorUnit);
                    autoOptions.max = ceil(autoOptions.max, options.majorUnit);
                } else if (userSetLimits) {
                    options = deepExtend(autoOptions, options);

                    // Determine an auto major unit after min/max have been set
                    autoOptions.majorUnit = axis.autoMajorUnit(options.min, options.max);
                }
            }

            return deepExtend(autoOptions, options);
        },

        reflow: function(targetBox) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                children = axis.children,
                space = axis.getActualTickSize() + options.margin,
                maxLabelWidth = 0,
                maxLabelHeight = 0,
                count = children.length,
                label,
                i;

            for (i = 0; i < count; i++) {
                label = children[i];
                maxLabelWidth = math.max(maxLabelWidth, label.box.width());
                maxLabelHeight = math.max(maxLabelHeight, label.box.height());
            }

            if (isVertical) {
                axis.box = new Box2D(
                    targetBox.x1, targetBox.y1,
                    targetBox.x1 + maxLabelWidth + space, targetBox.y2
                );
            } else {
                axis.box = new Box2D(
                    targetBox.x1, targetBox.y1,
                    targetBox.x2, targetBox.y1 + maxLabelHeight + space
                );
            }

            axis.arrangeLabels(maxLabelWidth, maxLabelHeight);
        },

        getViewElements: function(view) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                childElements = ChartElement.fn.getViewElements.call(axis, view),
                tickPositions = axis.getMinorTickPositions(),
                lineOptions;

            if (options.line.width > 0) {
                lineOptions = {
                        strokeWidth: options.line.width,
                        stroke: options.line.color,
                        dashType: options.line.dashType,
                        zIndex: options.zIndex
                    };
                if (isVertical) {
                    childElements.push(view.createLine(
                        axis.box.x2, tickPositions[0],
                        axis.box.x2, tickPositions[tickPositions.length - 1],
                        lineOptions));
                } else {
                    childElements.push(view.createLine(
                        tickPositions[0], axis.box.y1,
                        tickPositions[tickPositions.length - 1], axis.box.y1,
                        lineOptions));
                }

                append(childElements, axis.renderTicks(view));
            }

            return childElements;
        },

        autoMajorUnit: function (min, max) {
            var diff = max - min;

            if (diff == 0) {
                if (max == 0) {
                    return 0.1;
                }

                diff = math.abs(max);
            }

            var scale = math.pow(10, math.floor(math.log(diff) / math.log(10))),
                relativeValue = round((diff / scale), DEFAULT_PRECISION),
                scaleMultiplier = 1;

            if (relativeValue < 1.904762) {
                scaleMultiplier = 0.2;
            } else if (relativeValue < 4.761904) {
                scaleMultiplier = 0.5;
            } else if (relativeValue < 9.523809) {
                scaleMultiplier = 1;
            } else {
                scaleMultiplier = 2;
            }

            return round(scale * scaleMultiplier, DEFAULT_PRECISION);
        },

        autoAxisMax: function(min, max) {
            if (min == 0 && max == 0) {
                return 1;
            }

            var axisMax;
            if (min <= 0 && max <= 0) {
                max = min == max ? 0 : max;

                var diff = math.abs((max - min) / max);
                if(diff > ZERO_THRESHOLD) {
                    return 0;
                }

                axisMax = max - ((min - max) / 2);
            } else {
                min = min == max ? 0 : min;
                axisMax = max;
            }

            return axisMax;
        },

        autoAxisMin: function(min, max) {
            if (min == 0 && max == 0) {
                return 0;
            }

            var axisMin;
            if (min >= 0 && max >= 0) {
                min = min == max ? 0 : min;

                var diff = (max - min) / max;
                if(diff > ZERO_THRESHOLD) {
                    return 0;
                }

                axisMin = min - ((max - min) / 2);
            } else {
                max = min == max ? 0 : max;
                axisMin = min;
            }

            return axisMin;
        },

        getDivisions: function(stepValue) {
            var options = this.options,
                range = options.max - options.min;

            return math.floor(round(range / stepValue, COORD_PRECISION)) + 1;
        },

        getTickPositions: function(stepValue) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                lineBox = axis.getAxisLineBox(),
                lineSize = isVertical ? lineBox.height() : lineBox.width(),
                range = options.max - options.min,
                scale = lineSize / range,
                step = stepValue * scale,
                divisions = axis.getDivisions(stepValue),
                pos = lineBox[isVertical ? "y2" : "x1"],
                multuplier = isVertical ? -1 : 1,
                positions = [],
                i;

            for (i = 0; i < divisions; i++) {
                positions.push(round(pos, COORD_PRECISION));
                pos = pos + step * multuplier;
            }

            return isVertical ? positions.reverse() : positions;
        },

        getMajorTickPositions: function() {
            var axis = this;

            return axis.getTickPositions(axis.options.majorUnit);
        },

        getMinorTickPositions: function() {
            var axis = this;

            return axis.getTickPositions(axis.options.majorUnit / 5);
        },

        getAxisLineBox: function() {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                labelSize = isVertical ? "height" : "width",
                children = axis.children,
                box = axis.box,
                startMargin = 0,
                endMargin = 0;

            if (children.length > 1) {
                startMargin = children[0].box[labelSize]() / 2;
                endMargin = children[children.length - 1].box[labelSize]() / 2;
            }

            if (isVertical) {
               return new Box2D(box.x2, box.y1 + startMargin,
                 box.x2, box.y2 - endMargin);
            } else {
               return new Box2D(box.x1 + startMargin, box.y1,
                 box.x2 - endMargin, box.y1);
            }
        },

        getSlot: function(a, b) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                valueAxis = isVertical ? Y : X,
                lineBox = axis.getAxisLineBox(),
                lineStart = lineBox[valueAxis + 1],
                lineSize = isVertical ? lineBox.height() : lineBox.width(),
                scale = lineSize / (options.max - options.min),
                a = defined(a) ? a : options.axisCrossingValue,
                b = defined(b) ? b : options.axisCrossingValue,
                a = math.max(math.min(a, options.max), options.min),
                b = math.max(math.min(b, options.max), options.min),
                p1,
                p2,
                slotBox = new Box2D(lineBox.x1, lineBox.y1, lineBox.x1, lineBox.y1);

            if (isVertical) {
                p1 = lineStart + scale * (options.max - math.max(a, b));
                p2 = lineStart + scale * (options.max - math.min(a, b));
            } else {
                p1 = lineStart + scale * (math.min(a, b) - options.min);
                p2 = lineStart + scale * (math.max(a, b) - options.min);
            }

            slotBox[valueAxis + 1] = p1;
            slotBox[valueAxis + 2] = p2;

            return slotBox;
        }
    });

    var CategoryAxis = Axis.extend({
        init: function(options) {
            var axis = this;
            Axis.fn.init.call(axis, options);

            var options = axis.options,
                align = options.orientation === VERTICAL ? RIGHT : CENTER,
                labelOptions = deepExtend({ }, options.labels,
                    { align: align, zIndex: options.zIndex }
                ),
                labelTemplate,
                count = options.categories.length,
                content,
                i;

            for (i = 0; i < count; i++) {
                content = options.categories[i];

                if (labelOptions.template) {
                    labelTemplate = baseTemplate(labelOptions.template);
                    content = labelTemplate({ value: content });
                }

                axis.append(new TextBox(content, labelOptions));
            }
        },

        options: {
            categories: [],
            orientation: HORIZONTAL,
            majorGridLines: {
                visible: false,
                width: 1,
                color: BLACK
            },
            zIndex: 1
        },

        reflow: function(targetBox) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                children = axis.children,
                space = axis.getActualTickSize() + options.margin,
                maxLabelHeight = 0,
                maxLabelWidth = 0,
                label,
                i;

            for (i = 0; i < children.length; i++) {
                label = children[i];
                maxLabelHeight = math.max(maxLabelHeight, label.box.height());
                maxLabelWidth = math.max(maxLabelWidth, label.box.width());
            }

            if (isVertical) {
                axis.box = new Box2D(
                    targetBox.x1, targetBox.y1,
                    targetBox.x1 + maxLabelWidth + space, targetBox.y2
                );
            } else {
                axis.box = new Box2D(
                    targetBox.x1, targetBox.y1,
                    targetBox.x2, targetBox.y1 + maxLabelHeight + space
                );
            }

            axis.arrangeLabels(maxLabelWidth, maxLabelHeight, ON_MINOR_TICKS);
        },

        getViewElements: function(view) {
            var axis = this,
                options = axis.options,
                line = options.line,
                isVertical = options.orientation === VERTICAL,
                childElements = ChartElement.fn.getViewElements.call(axis, view),
                lineOptions;

            if (line.width > 0) {
                lineOptions = {
                    strokeWidth: line.width,
                    stroke: line.color,
                    dashType: line.dashType,
                    zIndex: line.zIndex
                };

                if (isVertical) {
                    childElements.push(view.createLine(
                        axis.box.x2, axis.box.y1, axis.box.x2, axis.box.y2,
                        lineOptions));
                } else {
                    childElements.push(view.createLine(
                        axis.box.x1, axis.box.y1, axis.box.x2, axis.box.y1,
                        lineOptions));
                }

                append(childElements, axis.renderTicks(view));
            }

            return childElements;
        },

        getTickPositions: function(itemsCount) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                size = isVertical ? axis.box.height() : axis.box.width(),
                step = size / itemsCount,
                pos = isVertical ? axis.box.y1 : axis.box.x1,
                positions = [],
                i;

            for (i = 0; i < itemsCount; i++) {
                positions.push(round(pos, COORD_PRECISION));
                pos += step;
            }

            positions.push(isVertical ? axis.box.y2 : axis.box.x2);

            return positions;
        },

        getMajorTickPositions: function() {
            var axis = this;

            return axis.getTickPositions(axis.options.categories.length);
        },

        getMinorTickPositions: function() {
            var axis = this;

            return axis.getTickPositions(axis.options.categories.length * 2);
        },

        getSlot: function(categoryIx) {
            var axis = this,
                options = axis.options,
                isVertical = options.orientation === VERTICAL,
                children = axis.children,
                box = axis.box,
                size = isVertical ? box.height() : box.width(),
                startPos = isVertical ? box.y1 : box.x1,
                step = size / math.max(1, children.length),
                p1 = startPos + (categoryIx * step),
                p2 = p1 + step;

            return isVertical ?
                   new Box2D(box.x2, p1, box.x2, p2) :
                   new Box2D(p1, box.y1, p2, box.y1);
        },

        getAxisLineBox: function() {
            var axis = this,
                options = axis.options;

            return axis.getSlot(0).wrap(axis.getSlot(options.categories.length - 1));
        }
    });

    var ClusterLayout = ChartElement.extend({
        init: function(options) {
            var cluster = this;
            ChartElement.fn.init.call(cluster, options);
        },

        options: {
            isVertical: false,
            gap: 0,
            spacing: 0
        },

        reflow: function(box) {
            var cluster = this,
                options = cluster.options,
                isVertical = options.isVertical,
                axis = isVertical ? Y : X,
                children = cluster.children,
                gap = options.gap,
                spacing = options.spacing,
                count = children.length,
                slots = count + gap + (spacing * (count - 1)),
                slotSize = (isVertical ? box.height() : box.width()) / slots,
                position = box[axis + 1] + slotSize * (gap / 2),
                childBox,
                i;

            for (i = 0; i < count; i++) {
                childBox = (children[i].box || box).clone();

                childBox[axis + 1] = position;
                childBox[axis + 2] = position + slotSize;

                children[i].reflow(childBox);
                if (i < count - 1) {
                    position += (slotSize * spacing);
                }

                position += slotSize;
            }
        }
    });

    var StackLayout = ChartElement.extend({
        init: function(options) {
            var stack = this;
            ChartElement.fn.init.call(stack, options);
        },

        options: {
            isVertical: true,
            isReversed: false
        },

        reflow: function(targetBox) {
            var stack = this,
                options = stack.options,
                isVertical = options.isVertical,
                isReversed = options.isReversed,
                positionAxis = isVertical ? X : Y,
                stackAxis = isVertical ? Y : X,
                stackBase = targetBox[stackAxis + 2],
                children = stack.children,
                box = stack.box = new Box2D(),
                childrenCount = children.length,
                stackDirection,
                i;

            if (options.isReversed) {
                stackDirection = isVertical ? BOTTOM : LEFT;
            } else {
                stackDirection = isVertical ? TOP : RIGHT;
            }

            for (i = 0; i < childrenCount; i++) {
                var currentChild = children[i],
                    childBox = currentChild.box.clone();

                childBox.snapTo(targetBox, positionAxis)
                if (currentChild.options) {
                    currentChild.options.stackBase = stackBase;
                }

                if (i == 0) {
                    box = stack.box = childBox.clone();
                } else {
                    childBox.alignTo(children[i - 1].box, stackDirection);
                }

                currentChild.reflow(childBox);

                box.wrap(childBox);
            }
        }
    });

    var Bar = ChartElement.extend({
        init: function(value, options) {
            var bar = this;

            bar.value = value;
            bar.options.id = uniqueId();

            ChartElement.fn.init.call(bar, options);
        },

        options: {
            color: WHITE,
            border: {
                width: 1
            },
            isVertical: true,
            overlay: {
                gradient: GLASS
            },
            aboveAxis: true,
            labels: {
                visible: false
            },
            animation: {
                type: BAR
            },
            opacity: 1
        },

        render: function() {
            var bar = this,
                value = bar.value,
                options = bar.options,
                labels = options.labels,
                labelText = value,
                labelTemplate;

            if (bar._rendered) {
                return;
            } else {
                bar._rendered = true;
            }

            if (labels.visible && value) {
                if (labels.template) {
                    labelTemplate = baseTemplate(labels.template);
                    labelText = labelTemplate({
                        dataItem: bar.dataItem,
                        category: bar.category,
                        value: bar.value,
                        series: bar.series
                    });
                }

                bar.append(
                    new BarLabel(labelText, deepExtend({
                            isVertical: options.isVertical,
                            id: uniqueId()},
                        options.labels)
                    )
                );
            }
        },

        reflow: function(targetBox) {
            this.render();

            var bar = this,
                options = bar.options,
                children = bar.children,
                label = children[0];

            bar.box = targetBox;

            if (label) {
                label.options.aboveAxis = options.aboveAxis;
                label.reflow(targetBox);
            }
        },

        getViewElements: function(view) {
            var bar = this,
                options = bar.options,
                isVertical = options.isVertical,
                normalAngle = isVertical ? 0 : 90,
                border = options.border.width > 0 ? {
                    stroke: bar.getBorderColor(),
                    strokeWidth: options.border.width,
                    dashType: options.border.dashType
                } : {},
                box = bar.box,
                rectStyle = deepExtend({
                    id: options.id,
                    fill: options.color,
                    normalAngle: normalAngle,
                    aboveAxis: options.aboveAxis,
                    fillOpacity: options.opacity,
                    strokeOpacity: options.opacity,
                    stackBase: options.stackBase,
                    animation: options.animation
                }, border),
                elements = [],
                label = bar.children[0];

            if (options.overlay) {
                rectStyle.overlay = deepExtend({rotation: normalAngle }, options.overlay);
            }

            elements.push(view.createRect(box, rectStyle));

            append(elements,
                ChartElement.fn.getViewElements.call(bar, view));

            bar.registerId(options.id);
            if (label) {
                bar.registerId(label.options.id);
            }

            return elements;
        },

        getOutlineElement: function(view, options){
            var bar = this,
                box = bar.box,
                outlineId = bar.options.id + OUTLINE_SUFFIX;

            bar.registerId(outlineId);
            options = deepExtend({}, options, { id: outlineId });

            return view.createRect(box, options);
        },

        getBorderColor: function() {
            var bar = this,
                options = bar.options,
                color = options.color,
                borderColor = options.border.color;

            if (!defined(borderColor)) {
                borderColor =
                    new Color(color).brightness(BAR_BORDER_BRIGHTNESS).toHex();
            }

            return borderColor;
        },

        tooltipAnchor: function(tooltipWidth, tooltipHeight) {
            var bar = this,
                options = bar.options,
                box = bar.box,
                isVertical = options.isVertical,
                aboveAxis = options.aboveAxis,
                x,
                y;

            if (isVertical) {
                x = box.x2 + TOOLTIP_OFFSET;
                y = aboveAxis ? box.y1 : box.y2 - tooltipHeight;
            } else {
                if (options.isStacked) {
                    x = box.x2 - tooltipWidth;
                    y = box.y1 - tooltipHeight - TOOLTIP_OFFSET;
                } else {
                    x = box.x2 + TOOLTIP_OFFSET;
                    y = box.y1;
                }
            }

            return new Point2D(x, y);
        },

        formatPointValue: function(format) {
            var point = this;

            return point.owner.formatPointValue(point.value, format);
        }
    });

    var CategoricalChart = ChartElement.extend({
        init: function(plotArea, options) {
            var chart = this;

            ChartElement.fn.init.call(chart, options);

            chart.plotArea = plotArea;
            chart._seriesMin = Number.MAX_VALUE;
            chart._seriesMax = - Number.MAX_VALUE;

            chart.points = [];
            chart.categoryPoints = [];
            chart.seriesPoints = [];

            chart.render();
        },

        options: {
            series: [],
            isVertical: true,
            isStacked: false
        },

        render: function() {
            var chart = this;

            chart.traverseDataPoints(proxy(chart.addValue, chart));
        },

        addValue: function(value, category, categoryIx, series, seriesIx) {
            var chart = this,
                point,
                categoryPoints = chart.categoryPoints[categoryIx],
                seriesPoints = chart.seriesPoints[seriesIx];

            if (!categoryPoints) {
                chart.categoryPoints[categoryIx] = categoryPoints = [];
            }

            if (!seriesPoints) {
                chart.seriesPoints[seriesIx] = seriesPoints = [];
            }

            chart.updateRange(value, categoryIx);

            point = chart.createPoint(value, category, categoryIx, series, seriesIx);
            if (point) {
                point.category = category;
                point.series = series;
                point.seriesIx = seriesIx;
                point.owner = chart;
                point.dataItem = series.dataItems ?
                    series.dataItems[categoryIx] : { value: value };
            }

            chart.points.push(point);
            seriesPoints.push(point);
            categoryPoints.push(point);
        },

        updateRange: function(value, categoryIx) {
            var chart = this;

            if (defined(value)) {
                chart._seriesMin = math.min(chart._seriesMin, value);
                chart._seriesMax = math.max(chart._seriesMax, value);
            }
        },

        valueRange: function() {
            var chart = this;

            if (chart.points.length) {
                return { min: chart._seriesMin, max: chart._seriesMax };
            }

            return null;
        },

        reflow: function(targetBox) {
            var chart = this,
                options = chart.options,
                isVertical = options.isVertical,
                plotArea = chart.plotArea,
                pointIx = 0,
                categorySlots = chart.categorySlots = [],
                chartPoints = chart.points,
                valueAxis = isVertical ? plotArea.axisY : plotArea.axisX,
                axisCrossingValue = valueAxis.options.axisCrossingValue,
                point;

            chart.traverseDataPoints(function(value, category, categoryIx) {
                point = chartPoints[pointIx++];
                if (point && point.plotValue) {
                    value = point.plotValue;
                }

                var slotX = plotArea.axisX.getSlot(isVertical ? categoryIx : value),
                    slotY = plotArea.axisY.getSlot(isVertical ? value : categoryIx),
                    pointSlot = new Box2D(slotX.x1, slotY.y1, slotX.x2, slotY.y2),
                    aboveAxis = value >= axisCrossingValue;

                if (point) {
                    point.options.aboveAxis = aboveAxis;
                    point.reflow(pointSlot);
                }

                if(!categorySlots[categoryIx]) {
                    categorySlots[categoryIx] = isVertical ? slotX : slotY;
                }
            });

            chart.reflowCategories(categorySlots);

            chart.box = targetBox;
        },

        reflowCategories: function() { },

        traverseDataPoints: function(callback) {
            var chart = this,
            options = chart.options,
            series = options.series,
            categories = chart.plotArea.options.categoryAxis.categories || [],
            count = categoriesCount(series),
            categoryIx,
            seriesIx,
            value,
            currentCategory,
            currentSeries;

            for (categoryIx = 0; categoryIx < count; categoryIx++) {
                for (seriesIx = 0; seriesIx < series.length; seriesIx++) {
                    currentCategory = categories[categoryIx];
                    currentSeries = series[seriesIx];
                    value = currentSeries.data[categoryIx];
                    callback(value, currentCategory, categoryIx, currentSeries, seriesIx);
                }
            }
        },

        formatPointValue: function(value, tooltipFormat) {
            return format(tooltipFormat, value);
        }
    });

    var BarChart = CategoricalChart.extend({
        init: function(plotArea, options) {
            var chart = this;

            chart._categoryTotalsPos = [];
            chart._categoryTotalsNeg = [];

            CategoricalChart.fn.init.call(chart, plotArea, options);
        },

        createPoint: function(value, category, categoryIx, series, seriesIx) {
            var barChart = this,
                options = barChart.options,
                children = barChart.children,
                isStacked = barChart.options.isStacked,
                labelOptions = deepExtend({}, series.labels);

            if (isStacked) {
                if (labelOptions.position == OUTSIDE_END) {
                    labelOptions.position = INSIDE_END;
                }
            }

            var bar = new Bar(value, {
                color: series.color,
                opacity: series.opacity,
                border: series.border,
                isVertical: options.isVertical,
                overlay: series.overlay,
                labels: labelOptions,
                isStacked: isStacked
            });

            var cluster = children[categoryIx];
            if (!cluster) {
                cluster = new ClusterLayout({
                    isVertical: !options.isVertical,
                    gap: options.gap,
                    spacing: options.spacing
                });
                barChart.append(cluster);
            }

            if (isStacked) {
                var stackWrap = cluster.children[0],
                    positiveStack,
                    negativeStack;

                if (!stackWrap) {
                    stackWrap = new ChartElement();
                    cluster.append(stackWrap);

                    positiveStack = new StackLayout({
                        isVertical: options.isVertical
                    });
                    negativeStack = new StackLayout({
                        isVertical: options.isVertical,
                        isReversed: true
                    });
                    stackWrap.append(positiveStack, negativeStack);
                } else {
                    positiveStack = stackWrap.children[0];
                    negativeStack = stackWrap.children[1];
                }

                if (value > 0) {
                    positiveStack.append(bar);
                } else {
                    negativeStack.append(bar);
                }
            } else {
                cluster.append(bar);
            }

            return bar;
        },

        updateRange: function(value, categoryIx) {
            var chart = this,
                options = chart.options,
                isStacked = options.isStacked,
                totalsPos = chart._categoryTotalsPos,
                totalsNeg = chart._categoryTotalsNeg;

            if (defined(value)) {
                if (isStacked) {
                    incrementSlot(value > 0 ? totalsPos : totalsNeg, categoryIx, value);
                } else {
                    CategoricalChart.fn.updateRange.apply(chart, arguments);
                }
            }
        },

        valueRange: function() {
            var chart = this,
                options = chart.options,
                isStacked = options.isStacked,
                totalsPos = chart._categoryTotalsPos,
                totalsNeg = chart._categoryTotalsNeg;

            if (isStacked) {
                chart._seriesMin = sparseArrayMin(totalsNeg.concat(0));
                chart._seriesMax = sparseArrayMax(totalsPos.concat(0));
            }

            return CategoricalChart.fn.valueRange.call(chart);
        },

        reflowCategories: function(categorySlots) {
            var chart = this,
                children = chart.children,
                childrenLength = children.length,
                i;

            for (i = 0; i < childrenLength; i++) {
                children[i].reflow(categorySlots[i]);
            }
        }
    });

    var ShapeElement = BoxElement.extend({
        init: function(options) {
            var marker = this;

            BoxElement.fn.init.call(marker, options);
        },

        options: {
            type: SQUARE,
            align: CENTER,
            vAlign: CENTER
        },

        getViewElements: function(view, renderOptions) {
            var marker = this,
                options = marker.options,
                type = options.type,
                box = marker.paddingBox,
                element = BoxElement.fn.getViewElements.call(marker, view, renderOptions)[0],
                halfWidth = box.width() / 2;

            if (!element) {
                return [];
            }

            if (type === TRIANGLE) {
                element = view.createPolyline([
                    new Point2D(box.x1 + halfWidth, box.y1),
                    new Point2D(box.x1, box.y2),
                    new Point2D(box.x2, box.y2)
                ], true, element.options);
            } else if (type === CIRCLE) {
                element = view.createCircle([
                    round(box.x1 + halfWidth, COORD_PRECISION),
                    round(box.y1 + box.height() / 2, COORD_PRECISION)
                ], halfWidth, element.options);
            }

            return [ element ];
        }
    });

    var LinePoint = ChartElement.extend({
        init: function(value, options) {
            var point = this;

            point.value = value;

            ViewElement.fn.init.call(point, options);
        },

        options: {
            aboveAxis: true,
            isVertical: true,
            markers: {
                visible: true,
                background: WHITE,
                size: LINE_MARKER_SIZE,
                type: CIRCLE,
                border: {
                    width: 2
                },
                opacity: 1
            },
            labels: {
                visible: false,
                position: ABOVE,
                margin: getSpacing(3),
                padding: getSpacing(4),
                animation: {
                    type: FADEIN,
                    delay: INITIAL_ANIMATION_DURATION
                }
            }
        },

        render: function() {
            var point = this,
                options = point.options,
                markers = options.markers,
                labels = options.labels,
                markerBackground = markers.background,
                markerBorder = deepExtend({}, markers.border),
                labelText = point.value;

            if (point._rendered) {
                return;
            } else {
                point._rendered = true;
            }

            if (!defined(markerBorder.color)) {
                markerBorder.color =
                    new Color(markerBackground).brightness(BAR_BORDER_BRIGHTNESS).toHex();
            }

            point.marker = new ShapeElement({
                id: uniqueId(),
                visible: markers.visible,
                type: markers.type,
                width: markers.size,
                height: markers.size,
                background: markerBackground,
                border: markerBorder,
                opacity: markers.opacity
            });

            point.append(point.marker);

            if (labels.visible) {
                if (labels.template) {
                    var labelTemplate = baseTemplate(labels.template);
                    labelText = labelTemplate({
                        dataItem: point.dataItem,
                        category: point.category,
                        value: point.value,
                        series: point.series
                    });
                } else if (labels.format) {
                    labelText = point.formatPointValue(labels.format);
                }
                point.label = new TextBox(labelText,
                    deepExtend({
                        id: uniqueId(),
                        align: CENTER,
                        vAlign: CENTER,
                        margin: {
                            left: 5,
                            right: 5
                        }
                    }, labels, { format: "" })
                );
                point.append(point.label);
            }
        },

        markerBox: function() {
            return this.marker.box;
        },

        reflow: function(targetBox) {
            var point = this,
                options = point.options,
                isVertical = options.isVertical,
                aboveAxis = options.aboveAxis,
                childBox;

            point.render();

            point.box = targetBox;
            childBox = targetBox.clone();

            if (isVertical) {
                if (aboveAxis) {
                    childBox.y1 -= childBox.height();
                } else {
                    childBox.y2 += childBox.height();
                }
            } else {
                if (aboveAxis) {
                    childBox.x1 += childBox.width();
                } else {
                    childBox.x2 -= childBox.width();
                }
            }

            point.marker.reflow(childBox);
            point.reflowLabel(childBox);
        },

        reflowLabel: function(box) {
            var point = this,
                options = point.options,
                marker = point.marker,
                label = point.label,
                edge = options.labels.position;

            if (label) {
                edge = edge === ABOVE ? TOP : edge;
                edge = edge === BELOW ? BOTTOM : edge;

                label.reflow(box);
                label.box.alignTo(marker.box, edge);
                label.reflow(label.box);
            }
        },

        getViewElements: function(view) {
            var element = this,
                marker = element.marker,
                label = element.label;

            element.registerId(marker.options.id);

            if (label) {
                element.registerId(label.options.id);
            }

            return ChartElement.fn.getViewElements.call(element, view);
        },

        getOutlineElement: function(view, options) {
            var element = this,
                marker = element.marker,
                outlineId = element.marker.options.id + OUTLINE_SUFFIX;

            element.registerId(outlineId);
            options = deepExtend({}, options, { id: outlineId });

            return marker.getViewElements(view, deepExtend(options, {
                fill: marker.options.border.color,
                fillOpacity: 1,
                strokeOpacity: 0
            }))[0];
        },

        tooltipAnchor: function(tooltipWidth, tooltipHeight) {
            var point = this,
                markerBox = point.marker.box,
                aboveAxis = point.options.aboveAxis;

            return new Point2D(
                markerBox.x2 + TOOLTIP_OFFSET,
                aboveAxis ? markerBox.y1 - tooltipHeight : markerBox.y2
            );
        },

        formatPointValue: function(format) {
            var point = this;

            return point.owner.formatPointValue(point.value, format);
        }
    });

    var LineChartMixin = {
        createLines: function(view) {
            var chart = this,
                options = chart.options,
                series = options.series,
                seriesPoints = chart.seriesPoints,
                currentSeries,
                seriesIx,
                seriesCount = seriesPoints.length,
                currentSeriesPoints,
                linePoints,
                point,
                pointCount,
                lines = [];

            for (seriesIx = 0; seriesIx < seriesCount; seriesIx++) {
                currentSeriesPoints = seriesPoints[seriesIx];
                pointCount = currentSeriesPoints.length;
                currentSeries = series[seriesIx];
                linePoints = [];

                for (pointIx = 0; pointIx < pointCount; pointIx++) {
                    point = currentSeriesPoints[pointIx];
                    if (point) {
                        pointCenter = point.markerBox().center();
                        linePoints.push(new Point2D(pointCenter.x, pointCenter.y));
                    } else if (currentSeries.missingValues !== INTERPOLATE) {
                        if (linePoints.length > 1) {
                            lines.push(
                                chart.createLine(uniqueId(), view, linePoints, currentSeries, seriesIx)
                            );
                        }
                        linePoints = [];
                    }
                }

                if (linePoints.length > 1) {
                    lines.push(
                        chart.createLine(uniqueId(), view, linePoints, currentSeries, seriesIx));
                }
            }

            return lines;
        },

        createLine: function(lineId, view, points, series, seriesIx) {
            this.registerId(lineId, { seriesIx: seriesIx });
            return view.createPolyline(points, false, {
                id: lineId,
                stroke: series.color,
                strokeWidth: series.width,
                strokeOpacity: series.opacity,
                fill: "",
                dashType: series.dashType
            });
        },

        getNearestPoint: function(x, y, seriesIx) {
            var chart = this,
                isVertical = chart.options.isVertical,
                axis = isVertical ? X : Y,
                pos = isVertical ? x : y,
                points = chart.seriesPoints[seriesIx],
                nearestPointDistance = Number.MAX_VALUE,
                pointsLength = points.length,
                currentPoint,
                pointBox,
                pointDistance,
                nearestPoint,
                i;

            for (i = 0; i < pointsLength; i++) {
                currentPoint = points[i];

                if (currentPoint && defined(currentPoint.value) && currentPoint.value !== null) {
                    pointBox = currentPoint.box;
                    pointDistance = math.abs(pointBox.center()[axis] - pos);

                    if (pointDistance < nearestPointDistance) {
                        nearestPoint = currentPoint;
                        nearestPointDistance = pointDistance;
                    }
                }
            }

            return nearestPoint;
        }
    };

    var LineChart = CategoricalChart.extend({
        init: function(plotArea, options) {
            var chart = this;

            chart._categoryTotals = [];

            CategoricalChart.fn.init.call(chart, plotArea, options);
        },

        createPoint: function(value, category, categoryIx, series, seriesIx) {
            var chart = this,
                options = chart.options,
                isStacked = options.isStacked,
                categoryPoints = chart.categoryPoints[categoryIx],
                stackPoint,
                plotValue = 0;

            if (!defined(value) || value === null) {
                if (isStacked || series.missingValues === ZERO) {
                    value = 0;
                } else {
                    return null;
                }
            }

            var point = new LinePoint(value,
                deepExtend({
                    isVertical: options.isVertical,
                    markers: {
                        border: {
                            color: series.color
                        },
                        opacity: series.opacity
                    }
                }, series)
            );

            if (isStacked) {
                stackPoint = categoryPoints[categoryPoints.length - 1];
                if (stackPoint) {
                    plotValue = stackPoint.plotValue;
                }

                point.plotValue = value + plotValue;
            }

            chart.append(point);

            return point;
        },

        updateRange: function(value, categoryIx) {
            var chart = this,
                options = chart.options,
                isStacked = options.isStacked,
                totals = chart._categoryTotals;

            if (defined(value)) {
                if (isStacked) {
                    incrementSlot(totals, categoryIx, value);
                    chart._seriesMin = math.min(chart._seriesMin, sparseArrayMin(totals));
                    chart._seriesMax = math.max(chart._seriesMax, sparseArrayMax(totals));
                } else {
                    CategoricalChart.fn.updateRange.apply(chart, arguments);
                }
            }
        },

        getViewElements: function(view) {
            var chart = this,
                elements = CategoricalChart.fn.getViewElements.call(chart, view),
                group = view.createGroup({
                    animation: {
                        type: CLIP
                    }
                }),
                lines = chart.createLines(view);


            group.children = lines.concat(elements);
            return [group];
        }
    });
    deepExtend(LineChart.fn, LineChartMixin);

    var ScatterChart = ChartElement.extend({
        init: function(plotArea, options) {
            var chart = this;

            ChartElement.fn.init.call(chart, options);

            chart.plotArea = plotArea;
            chart._seriesMin = [Number.MAX_VALUE, Number.MAX_VALUE];
            chart._seriesMax = [-Number.MAX_VALUE, -Number.MAX_VALUE];
            chart.points = [];
            chart.seriesPoints = [];

            chart.render();
        },

        options: {
            series: []
        },

        render: function() {
            var chart = this;

            chart.traverseDataPoints(proxy(chart.addValue, chart));
        },

        addValue: function(value, fields) {
            var chart = this,
                point,
                seriesIx = fields.seriesIx,
                seriesPoints = chart.seriesPoints[seriesIx];

            chart.updateRange(value);

            if (!seriesPoints) {
                chart.seriesPoints[seriesIx] = seriesPoints = [];
            }

            point = chart.createPoint(value, fields.series, seriesIx);
            if (point) {
                extend(point, fields);
            }

            chart.points.push(point);
            seriesPoints.push(point);
        },

        updateRange: function(value) {
            var chart = this,
                x = value.x,
                y = value.y,
                seriesMin = chart._seriesMin,
                seriesMax = chart._seriesMax;

            if (defined(x)) {
                seriesMin[0] = math.min(seriesMin[0], x);
                seriesMax[0] = math.max(seriesMax[0], x);
            }

            if (defined(y)) {
                seriesMin[1] = math.min(seriesMin[1], y);
                seriesMax[1] = math.max(seriesMax[1], y);
            }
        },

        valueRange: function() {
            var chart = this;

            if (chart.points.length) {
                return { min: chart._seriesMin, max: chart._seriesMax };
            }

            return null;
        },

        createPoint: function(value, series, seriesIx) {
            var chart = this,
                options = chart.options;

            if (!defined(value.x) || !defined(value.y)) {
                return null;
            }

            var point = new LinePoint(value,
                deepExtend({
                    markers: {
                        border: {
                            color: series.color
                        },
                        opacity: series.opacity
                    },
                    tooltip: {
                        format: "{0}, {1}"
                    },
                    labels: {
                        format: "{0}, {1}"
                    }
                }, series)
            );

            chart.append(point);

            return point;
        },

        reflow: function(targetBox) {
            var chart = this,
                options = chart.options,
                plotArea = chart.plotArea,
                chartPoints = chart.points,
                axisX = plotArea.axisX,
                axisY = plotArea.axisY,
                pointIx = 0,
                point;

            chart.traverseDataPoints(function(value) {
                point = chartPoints[pointIx++];

                var slotX = plotArea.axisX.getSlot(value.x, value.x),
                    slotY = plotArea.axisY.getSlot(value.y, value.y),
                    pointSlot = new Box2D(slotX.x1, slotY.y1, slotX.x2, slotY.y2);

                if (point) {
                    point.reflow(pointSlot);
                }
            });

            chart.box = targetBox;
        },

        getViewElements: function(view) {
            var chart = this,
                elements = ChartElement.fn.getViewElements.call(chart, view),
                group = view.createGroup({
                    animation: {
                        type: CLIP
                    }
                });

            group.children = elements;
            return [group];
        },

        traverseDataPoints: function(callback) {
            var chart = this,
                options = chart.options,
                series = options.series,
                pointIx = 0,
                seriesIx,
                currentSeries,
                dataItems,
                value,
                pointData;

            for (seriesIx = 0; seriesIx < series.length; seriesIx++) {
                currentSeries = series[seriesIx];
                for (pointIx = 0; pointIx < currentSeries.data.length; pointIx++) {
                    pointData = currentSeries.data[pointIx] || [];
                    dataItems = currentSeries.dataItems;
                    value = { x: pointData[0], y: pointData[1] };

                    callback(value, {
                        pointIx: pointIx,
                        series: currentSeries,
                        seriesIx: seriesIx,
                        dataItem: dataItems ? dataItems[pointIx] : value,
                        owner: chart
                    });
                }
            }
        },

        formatPointValue: function(value, tooltipFormat) {
            return format(tooltipFormat, value.x, value.y);
        }
    });

    var ScatterLineChart = ScatterChart.extend({
        getViewElements: function(view) {
            var chart = this,
                elements = ScatterChart.fn.getViewElements.call(chart, view),
                group = view.createGroup({
                    animation: {
                        type: CLIP
                    }
                }),
                lines = chart.createLines(view);

            group.children = lines.concat(elements);
            return [group];
        }
    });
    deepExtend(ScatterLineChart.fn, LineChartMixin);

    var PieSegment = ChartElement.extend({
        init: function(value, sector, options) {
            var segment = this;

            segment.value = value;
            segment.sector = sector;

            ChartElement.fn.init.call(segment, options);
        },

        options: {
            color: WHITE,
            overlay: {
                gradient: ROUNDED_BEVEL
            },
            border: {
                width: 0.5
            },
            labels: {
                visible: false,
                distance: 35,
                font: DEFAULT_FONT,
                margin: getSpacing(0.5),
                align: CIRCLE,
                zIndex: 1,
                position: OUTSIDE_END
            },
            animation: {
                type: PIE
            },
            highlight: {
                visible: true,
                border: {
                    width: 1
                }
            }
        },

        render: function() {
            var segment = this,
                options = segment.options,
                labels = options.labels,
                labelText = segment.value,
                labelTemplate;

            if (segment._rendered) {
                return;
            } else {
                segment._rendered = true;
            }

            if (labels.template) {
                labelTemplate = baseTemplate(labels.template);
                labelText = labelTemplate({
                    dataItem: segment.dataItem,
                    category: segment.category,
                    value: segment.value,
                    series: segment.series
                });
            }

            if (labels.visible) {
                segment.label = new TextBox(labelText, deepExtend({}, labels, {
                        id: uniqueId(),
                        align: CENTER,
                        vAlign: "",
                        animation: {
                            type: FADEIN,
                            delay: segment.categoryIx * PIE_SECTOR_ANIM_DELAY
                        }
                    }));

                segment.append(segment.label);
                segment.registerId(segment.label.options.id);
            }
        },

        reflow: function(targetBox) {
            var segment = this,
                options = segment.options,
                childBox;

            segment.render();

            segment.box = targetBox;
            childBox = targetBox.clone();

            segment.reflowLabel();
        },

        reflowLabel: function() {
            var segment = this,
                sector = segment.sector.clone(),
                options = segment.options,
                label = segment.label,
                labelsOptions = options.labels,
                labelsDistance = labelsOptions.distance,
                startAngle = segment.sector.startAngle % 90,
                lp,
                x1,
                y1,
                angle = sector.middle(),
                labelWidth,
                labelHeight;

            if (label) {
                labelHeight = label.box.height();
                labelWidth = label.box.width();
                if (labelsOptions.position == "center") {
                    sector.r = math.abs((sector.r - labelHeight) / 2) + labelHeight;
                    lp = sector.point(angle);
                    label.reflow(new Box2D(lp.x, lp.y - labelHeight / 2, lp.x, lp.y));
                } else if (labelsOptions.position == "insideEnd") {
                    sector.r = sector.r - labelHeight / 2;
                    lp = sector.point(angle);
                    label.reflow(new Box2D(lp.x, lp.y - labelHeight / 2, lp.x, lp.y));
                } else {
                    lp = sector.clone().expand(labelsDistance).point(angle);
                    if (lp.x >= sector.c.x) {
                        x1 = lp.x + labelWidth;
                        label.orientation = RIGHT;
                    } else {
                        x1 = lp.x - labelWidth;
                        label.orientation = LEFT;
                    }
                    label.reflow(new Box2D(x1, lp.y - labelHeight, lp.x, lp.y));
                }
            }
        },

        getViewElements: function(view) {
            var segment = this,
                sector = segment.sector,
                segmentID = uniqueId(),
                options = segment.options,
                borderOptions = options.border || {},
                border = borderOptions.width > 0 ? {
                    stroke: borderOptions.color,
                    strokeWidth: borderOptions.width,
                    dashType: borderOptions.dashType
                } : {},
                elements = [],
                overlay = options.overlay;

            if (overlay) {
                overlay = deepExtend({}, options.overlay, {
                    r: sector.r,
                    cx: sector.c.x,
                    cy: sector.c.y
                })
            }

            elements.push(view.createSector(sector, deepExtend({
                id: options.id,
                fill: options.color,
                overlay: overlay,
                fillOpacity: options.opacity,
                strokeOpacity: options.opacity,
                animation: deepExtend(options.animation, {
                    delay: segment.categoryIx * PIE_SECTOR_ANIM_DELAY
                })
            }, border)));

            append(elements,
                ChartElement.fn.getViewElements.call(segment, view)
            );

            return elements;
        },

        getOutlineElement: function(view, options) {
            var segment = this,
                highlight = segment.options.highlight || {},
                border = highlight.border || {},
                outlineId = segment.options.id + OUTLINE_SUFFIX;

            segment.registerId(outlineId);
            options = deepExtend({}, options, { id: outlineId });

            return view.createSector(segment.sector, deepExtend({}, options, {
                fill: highlight.color,
                fillOpacity: highlight.opacity,
                strokeOpacity: border.opacity,
                strokeWidth: border.width,
                stroke: border.color
            }));
        },

        tooltipAnchor: function(tooltipWidth, tooltipHeight) {
            var w = tooltipWidth / 2,
                h = tooltipHeight / 2,
                r = math.sqrt((w * w) + (h * h)),
                sector = this.sector.clone().expand(r + TOOLTIP_OFFSET),
                tooltipCenter = sector.point(sector.middle());

            return new Point2D(tooltipCenter.x - w, tooltipCenter.y - h);
        },

        formatPointValue: function(format) {
            var point = this;

            return point.owner.formatPointValue(point.value, format);
        }
    });

    var PieChart = ChartElement.extend({
        init: function(plotArea, options) {
            var chart = this;

            ChartElement.fn.init.call(chart, options);

            chart.plotArea = plotArea;
            chart.segments = [];
            chart.seriesPoints = [];
            chart.render();
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

        render: function() {
            var chart = this;

            chart.traverseDataPoints(proxy(chart.addValue, chart));
        },

        traverseDataPoints: function(callback) {
            var chart = this,
                options = chart.options,
                colors = chart.plotArea.options.seriesColors || [],
                startAngle = options.startAngle,
                colorsCount = colors.length,
                series = options.series,
                dataItems,
                currentName,
                currentSeries,
                currentData,
                currentColor,
                totalAngle,
                seriesIx,
                angle,
                data,
                total,
                anglePerValue,
                value,
                explode,
                i;

            for (seriesIx = 0; seriesIx < series.length; seriesIx++) {
                currentSeries = series[seriesIx];
                dataItems = currentSeries.dataItems,
                data = currentSeries.data;
                anglePerValue = 360 / chart.pointsTotal(data);

                for (i = 0; i < data.length; i++) {
                    currentData = chart.pointData(currentSeries, i);
                    value = currentData.value;
                    angle = value * anglePerValue;
                    currentName = currentData.category;
                    explode = data.length != 1 && !!currentData.explode;
                    currentSeries.color = currentData.color ?
                        currentData.color : colors[i % colorsCount];

                    callback(value, new Sector(null, 0, startAngle, angle), {
                        owner: chart,
                        category: currentName,
                        categoryIx: i,
                        series: currentSeries,
                        seriesIx: seriesIx,
                        dataItem: dataItems ? dataItems[i] : currentData,
                        explode: explode
                    });

                    startAngle += angle;
                }
            }
        },

        addValue: function(value, sector, fields) {
            var chart = this,
                segment;

            segment = new PieSegment(value, sector, fields.series);
            segment.options.id = uniqueId();
            extend(segment, fields);
            chart.append(segment);
            chart.segments.push(segment);
        },

        addValue: function(value, sector, fields) {
            var chart = this,
                segment;

            segment = new PieSegment(value, sector, fields.series);
            segment.options.id = uniqueId();
            extend(segment, fields);
            chart.append(segment);
            chart.segments.push(segment);
        },

        pointValue: function(point) {
            return defined(point.value) ? point.value : point;
        },

        pointData: function(series, index) {
            var chart = this,
                dataItems = series.dataItems,
                data = series.data[index];

            return {
                value: chart.pointValue(data),
                category: chart.pointGetter(series, index, "category"),
                color: chart.pointGetter(series, index, "color"),
                explode: chart.pointGetter(series, index, "explode")
            };
        },

        pointGetter: function(series, index, prop) {
            var valueField = series[prop + "Field"],
                data = series.data[index],
                value = data[prop];

            if (valueField && series.dataItems) {
                return getter(valueField, true)(series.dataItems[index]);
            } else {
                return defined(value) ? value : "";
            }
        },

        pointsTotal: function(data) {
            var chart = this,
                length = data.length,
                sum = 0,
                i;

            for(i = 0; i < length; i++) {
                sum += chart.pointValue(data[i]);
            }

            return sum;
        },

        reflow: function(targetBox) {
            var chart = this,
                options = chart.options,
                padding = options.padding,
                box = targetBox.clone(),
                minWidth = math.min(box.width(), box.height()),
                space = 5,
                padding = options.padding > minWidth / 2 - space ? minWidth / 2 - space : options.padding,
                newBox = new Box2D(box.x1, box.y1,
                    box.x1 + minWidth, box.y1 + minWidth),
                newBoxCenter = newBox.center(),
                boxCenter = box.center(),
                segments = chart.segments,
                count = segments.length,
                leftSideLabels = [],
                rightSideLabels = [],
                label,
                segment,
                sector,
                i;

            newBox.translate(boxCenter.x - newBoxCenter.x, boxCenter.y - newBoxCenter.y);

            for (i = 0; i < count; i++) {
                segment = segments[i];

                sector = segment.sector;
                sector.r = minWidth / 2 - padding;
                sector.c = new Point2D(
                    sector.r + newBox.x1 + padding,
                    sector.r + newBox.y1 + padding
                );

                if (segment.explode) {
                    sector.c = sector.clone().radius(sector.r * 0.15).point(sector.middle());
                }

                segment.reflow(newBox);

                label = segment.label;
                if (label) {
                    if (label.options.position === OUTSIDE_END) {
                        if (label.orientation === RIGHT) {
                            rightSideLabels.push(label);
                        } else {
                            leftSideLabels.push(label);
                        }
                    }
                }
            }

            if (leftSideLabels.length > 0) {
                leftSideLabels.sort(chart.labelComparator(true));
                chart.leftLabelsReflow(leftSideLabels);
            }

            if (rightSideLabels.length > 0) {
                rightSideLabels.sort(chart.labelComparator(false));
                chart.rightLabelsReflow(rightSideLabels);
            }

            chart.box = newBox;
        },

        leftLabelsReflow: function(labels) {
            var chart = this,
                distances = chart.distanceBetweenLabels(labels);

            chart.distributeLabels(distances, labels);
        },

        rightLabelsReflow: function(labels) {
            var chart = this,
                distances = chart.distanceBetweenLabels(labels);

            chart.distributeLabels(distances, labels);
        },

        distanceBetweenLabels: function(labels) {
            var chart = this,
                segment = chart.segments[0],
                sector = segment.sector,
                firstBox = labels[0].box,
                secondBox,
                count = labels.length - 1,
                distances = [],
                distance,
                lr = sector.r + segment.options.labels.distance,
                i;

            distance = round(firstBox.y1 - (sector.c.y - lr - firstBox.height() - firstBox.height() / 2));
            distances.push(distance);
            for (i = 0; i < count; i++) {
                firstBox = labels[i].box;
                secondBox = labels[i + 1].box;
                distance = round(secondBox.y1 - firstBox.y2);
                distances.push(distance);
            }
            distance = round(sector.c.y + lr - labels[count].box.y2 - labels[count].box.height() / 2);
            distances.push(distance);

            return distances;
        },

        distributeLabels: function(distances, labels) {
            var chart = this,
                count = distances.length,
                remaining,
                left,
                right,
                i;

            for (i = 0; i < count; i++) {
                left = right = i;
                remaining = -distances[i];
                while(remaining > 0 && (left >= 0 || right < count)) {
                    remaining = chart._takeDistance(distances, i, --left, remaining);
                    remaining = chart._takeDistance(distances, i, ++right, remaining);
                }
            }

            chart.reflowLabels(distances, labels);
        },

        _takeDistance: function(distances, anchor, position, amount) {
            if (distances[position] > 0) {
                var available = math.min(distances[position], amount);
                amount -= available;
                distances[position] -= available;
                distances[anchor] += available;
            }

            return amount;
        },

        reflowLabels: function(distances, labels) {
            var chart = this,
                connectors = chart.options,
                segments = chart.segments,
                segment = segments[0],
                sector = segment.sector,
                labelsCount = labels.length,
                labelOptions = segment.options.labels,
                labelDistance = labelOptions.distance,
                boxY = sector.c.y - (sector.r + labelDistance) - labels[0].box.height(),
                label,
                boxX,
                box,
                i;

            distances[0] += 2;
            for (i = 0; i < labelsCount; i++) {
                label = labels[i];
                boxY += distances[i];
                box = label.box;
                boxX = chart.hAlignLabel(
                    box.x2,
                    sector.clone().expand(labelDistance),
                    boxY,
                    boxY + box.height(),
                    label.orientation == RIGHT);

                if (label.orientation == RIGHT) {
                    if (labelOptions.align !== CIRCLE) {
                        boxX = sector.r + sector.c.x + labelDistance;
                    }
                    label.reflow(new Box2D(boxX + box.width(), boxY,
                        boxX, boxY));
                } else {
                    if (labelOptions.align !== CIRCLE) {
                        boxX = sector.c.x - sector.r - labelDistance;
                    }
                    label.reflow(new Box2D(boxX - box.width(), boxY,
                        boxX, boxY));
                }

                boxY += box.height();
            }
        },

        getViewElements: function(view) {
            var chart = this,
                options = chart.options,
                connectors = options.connectors,
                segments = chart.segments,
                connectorLine,
                sector,
                count = segments.length,
                space = 4,
                angle,
                lines = [],
                points,
                segment,
                seriesIx,
                label,
                i;

            for (i = 0; i < count; i++) {
                segment = segments[i];
                sector = segment.sector;
                angle = sector.middle();
                label = segment.label;
                seriesIx = { seriesId: segment.seriesIx };

                if (label) {
                    points = [];
                    if (label.options.position === OUTSIDE_END) {
                        var box = label.box,
                            centerPoint = sector.c,
                            start = sector.point(angle),
                            middle = new Point2D(box.x1, box.center().y),
                            sr,
                            end,
                            crossing;

                        start = sector.clone().expand(connectors.padding).point(angle);
                        points.push(start);
                        if (label.orientation == RIGHT) {
                            end = new Point2D(box.x1 - connectors.padding, box.center().y);
                            crossing = intersection(centerPoint, start, middle, end);
                            middle = new Point2D(end.x - space, end.y);
                            crossing = crossing || middle;
                            crossing.x = math.min(crossing.x, middle.x);

                            if (chart.pointInCircle(crossing, sector.c, sector.r + space) ||
                                crossing.x < sector.c.x) {
                                sr = sector.c.x + sector.r + space;
                                if (segment.options.labels.align !== COLUMN) {
                                    if (sr < middle.x) {
                                        points.push(new Point2D(sr, start.y));
                                    } else {
                                        points.push(new Point2D(start.x + space * 2, start.y));
                                    }
                                } else {
                                    points.push(new Point2D(sr, start.y));
                                }
                                points.push(new Point2D(middle.x, end.y));
                            } else {
                                crossing.y = end.y;
                                points.push(crossing);
                            }
                        } else {
                            end = new Point2D(box.x2 + connectors.padding, box.center().y);
                            crossing = intersection(centerPoint, start, middle, end);
                            middle = new Point2D(end.x + space, end.y);
                            crossing = crossing || middle;
                            crossing.x = math.max(crossing.x, middle.x);

                            if (chart.pointInCircle(crossing, sector.c, sector.r + space) ||
                                crossing.x > sector.c.x) {
                                sr = sector.c.x - sector.r - space;
                                if (segment.options.labels.align !== COLUMN) {
                                    if (sr > middle.x) {
                                        points.push(new Point2D(sr, start.y));
                                    } else {
                                        points.push(new Point2D(start.x - space * 2, start.y));
                                    }
                                } else {
                                    points.push(new Point2D(sr, start.y));
                                }
                                points.push(new Point2D(middle.x, end.y));
                            } else {
                                crossing.y = end.y;
                                points.push(crossing);
                            }
                        }

                        points.push(end);
                        connectorLine = view.createPolyline(points, false, {
                            id: uniqueId(),
                            stroke: connectors.color,
                            strokeWidth: connectors.width,
                            animation: {
                                type: FADEIN,
                                delay: segment.categoryIx * PIE_SECTOR_ANIM_DELAY
                            }
                        });
                        lines.push(connectorLine);
                        segment.registerId(connectorLine.options.id, seriesIx);
                    }
                    segment.registerId(label.options.id, seriesIx);
                }

                segment.registerId(segment.options.id, seriesIx);
            }

            append(lines,
                ChartElement.fn.getViewElements.call(chart, view));

            return lines;
        },

        labelComparator: function (reverse) {
            reverse = (reverse) ? -1 : 1;

            return function(a, b) {
                var startAngle = a.parent.sector.startAngle;
                a = (a.parent.sector.middle() + 270) % 360;
                b = (b.parent.sector.middle() + 270) % 360;
                return (a - b) * reverse;
            }
        },

        hAlignLabel: function(originalX, sector, y1, y2, direction) {
            var cx = sector.c.x,
                cy = sector.c.y,
                r = sector.r,
                t = math.min(math.abs(cy - y1), math.abs(cy - y2));

            if (t > r) {
                return originalX;
            } else {
                return cx + math.sqrt((r * r) - (t * t)) * (direction ? 1 : -1);
            }
        },

        pointInCircle: function(point, c, r) {
            return sqr(c.x - point.x) + sqr(c.y - point.y) < sqr(r);
        },

        formatPointValue: function(value, tooltipFormat) {
            return format(tooltipFormat, value);
        }
    });

    var PlotArea = ChartElement.extend({
        init: function(options) {
            var plotArea = this;

            ChartElement.fn.init.call(plotArea, options);

            plotArea.render();
        },

        options: {
            categoryAxis: {},
            valueAxis: {},
            series: [],
            plotArea: {
                margin: {}
            },
            background: "",
            border: {
                color: BLACK,
                width: 0
            },
            range: {},
            legend: {}
        },

        render: function() {
            var plotArea = this,
                options = plotArea.options,
                series = options.series,
                seriesLength = series.length,
                currentSeries,
                pieSeries = [],
                barSeries = [],
                lineSeries = [],
                scatterSeries = [],
                scatterLineSeries = [],
                i;

            options.legend.items = [];
            options.range = { min: 0, max: 1 };
            plotArea.charts = [];
            for (i = 0; i < seriesLength; i++) {
                currentSeries = series[i];

                if (currentSeries.type === BAR || currentSeries.type === COLUMN) {
                    barSeries.push(currentSeries);
                } else if (currentSeries.type === LINE) {
                    lineSeries.push(currentSeries);
                } else if (currentSeries.type === PIE) {
                    pieSeries.push(currentSeries);
                } else if (currentSeries.type === "scatter") {
                    scatterSeries.push(currentSeries);
                } else if (currentSeries.type === "scatterLine") {
                    scatterLineSeries.push(currentSeries);
                }
            }

            if (barSeries.length > 0) {
                plotArea.createBarChart(barSeries);
            }

            if (lineSeries.length > 0) {
                plotArea.createLineChart(lineSeries);
            }

            if (pieSeries.length > 0) {
                plotArea.createPieChart(pieSeries);
            }

            if (scatterSeries.length > 0 || scatterLineSeries.length > 0) {
                if (scatterSeries.length > 0) {
                    plotArea.createScatterChart(scatterSeries);
                } else {
                    plotArea.createScatterLineChart(scatterLineSeries);
                }

                plotArea.axisX = new NumericAxis(options.range.min[0], options.range.max[0],
                    deepExtend({}, options.xAxis, { orientation: HORIZONTAL })
                );

                plotArea.axisY = new NumericAxis(options.range.min[1], options.range.max[1],
                    deepExtend({}, options.yAxis, { orientation: VERTICAL })
                );

                plotArea.append(plotArea.axisY);
                plotArea.append(plotArea.axisX);
            } else if (seriesLength != pieSeries.length || seriesLength == 0) {
                plotArea.createAxes(options.range.min, options.range.max, options.invertAxes);
            }

            plotArea.append.apply(plotArea, plotArea.charts);
        },

        addToLegend: function(series) {
            var plotArea = this,
                count = series.length,
                data = [],
                item,
                i;

            for (i = 0; i < count; i++) {
                item = { name: series[i].name || "", color: series[i].color };
                data.push(item);
            }

            append(plotArea.options.legend.items, data);
        },

        createBarChart: function(series) {
            var plotArea = this,
                options = plotArea.options,
                firstSeries = series[0],
                invertAxes = options.invertAxes = firstSeries.type === BAR,
                categories = options.categoryAxis.categories,
                barChart = new BarChart(plotArea, {
                    series: series,
                    isVertical: !invertAxes,
                    isStacked: firstSeries.stack,
                    gap: firstSeries.gap,
                    spacing: firstSeries.spacing
                }),
                categoriesToAdd = math.max(0, categoriesCount(series) - categories.length);

            append(categories, new Array(categoriesToAdd));
            options.range = barChart.valueRange() || options.range;
            plotArea.charts.push(barChart);

            plotArea.addToLegend(series);
        },

        createLineChart: function(series) {
            var plotArea = this,
                options = plotArea.options,
                firstSeries = series[0],
                categoryAxis = options.categoryAxis,
                categories = categoryAxis.categories,
                // Override the original invertAxes
                invertAxes = options.invertAxes = categoryAxis.orientation === VERTICAL,
                lineChart = new LineChart(plotArea, {
                    // TODO: Rename isVertical to invertAxes, flip logic
                    isVertical: !invertAxes,
                    isStacked: firstSeries.stack,
                    series: series
                }),
                categoriesToAdd = math.max(0, categoriesCount(series) - categories.length),
                lineChartRange = lineChart.valueRange() || options.range;

            append(categories, new Array(categoriesToAdd));
            // Override the original range
            options.range.min = math.min(options.range.min, lineChartRange.min);
            options.range.max = math.max(options.range.max, lineChartRange.max);
            plotArea.charts.push(lineChart);

            plotArea.addToLegend(series);
        },

        createScatterChart: function(series) {
            var plotArea = this,
                options = plotArea.options,
                firstSeries = series[0],
                categoryAxis = options.categoryAxis,
                categories = categoryAxis.categories,
                // Override the original invertAxes
                scatterChart = new ScatterChart(plotArea, { series: series }),
                scatterChartRange = scatterChart.valueRange() || options.range;

            // Override the original range
            options.range = scatterChartRange;
            plotArea.charts.push(scatterChart);

            plotArea.addToLegend(series);
        },

        createScatterLineChart: function(series) {
            var plotArea = this,
                options = plotArea.options,
                firstSeries = series[0],
                categoryAxis = options.categoryAxis,
                categories = categoryAxis.categories,
                // Override the original invertAxes
                scatterLineChart = new ScatterLineChart(plotArea, { series: series }),
                scatterLineChartRange = scatterLineChart.valueRange() || options.range;

            // Override the original range
            options.range = scatterLineChartRange;
            plotArea.charts.push(scatterLineChart);

            plotArea.addToLegend(series);
        },

        createPieChart: function(series) {
            var plotArea = this,
                options = plotArea.options,
                firstSeries = series[0],
                pieChart = new PieChart(plotArea, {
                    series: series,
                    padding: firstSeries.padding,
                    startAngle: firstSeries.startAngle,
                    connectors: firstSeries.connectors
                }),
                segments = pieChart.segments,
                count = segments.length,
                i;

            plotArea.charts.push(pieChart);
            for (i = 0; i < count; i++) {
                options.legend.items.push({
                    name: segments[i].category,
                    color: segments[i].options.color });
            }
        },

        createAxes: function(seriesMin, seriesMax, invertAxes) {
            var plotArea = this,
                options = plotArea.options,
                categoriesCount = options.categoryAxis.categories.length,
                categoryAxis = new CategoryAxis(deepExtend({
                        orientation: invertAxes ? VERTICAL : HORIZONTAL,
                        axisCrossingValue: invertAxes ? categoriesCount : 0
                    },
                    options.categoryAxis,
                    invertAxes ? options.yAxis : options.xAxis)
                ),
                valueAxis = new NumericAxis(seriesMin, seriesMax, deepExtend({
                        orientation: invertAxes ? HORIZONTAL : VERTICAL
                    },
                    options.valueAxis,
                    invertAxes ? options.xAxis : options.yAxis)
                );

            plotArea.axisX = invertAxes ? valueAxis : categoryAxis;
            plotArea.axisY = invertAxes ? categoryAxis : valueAxis;

            plotArea.append(plotArea.axisY);
            plotArea.append(plotArea.axisX);
        },

        alignAxes: function() {
            var plotArea = this,
                axisY = plotArea.axisY,
                axisX = plotArea.axisX,
                crossingValueY = axisY.options.axisCrossingValue,
                axisCrossingY = axisY.getSlot(crossingValueY, crossingValueY),
                crossingValueX = axisX.options.axisCrossingValue,
                axisCrossingX = axisX.getSlot(crossingValueX, crossingValueX);

            axisY.reflow(
                axisY.box.translate(axisCrossingX.x1 - axisCrossingY.x1, 0)
            );

            axisX.reflow(
                axisX.box.translate(0, axisCrossingY.y1 - axisCrossingX.y1)
            );
        },

        reflow: function(targetBox) {
            var plotArea = this,
                options = plotArea.options.plotArea,
                margin = getSpacing(options.margin)

            plotArea.box = targetBox.clone();

            plotArea.box.unpad(margin);
            plotArea.reflowAxes();
            plotArea.reflowCharts();
            plotArea.wrapAxes();
        },

        reflowAxes: function() {
            var plotArea = this,
                axisY = plotArea.axisY,
                axisX = plotArea.axisX,
                box = plotArea.box;

            if (axisY || axisX) {
                axisY.reflow(box);
                axisX.reflow(box);

                plotArea.alignAxes();

                var axisBox = axisY.box.clone().wrap(axisX.box),
                    overflowY = axisBox.height() - box.height(),
                    overflowX = axisBox.width() - box.width(),
                    offsetX = box.x1 - axisBox.x1,
                    offsetY = box.y1 - axisBox.y1;

                axisY.reflow(
                    axisY.box.translate(offsetX, offsetY).shrink(0, overflowY)
                );

                axisX.reflow(
                    axisX.box.translate(offsetX, offsetY).shrink(overflowX, 0)
                );

                plotArea.alignAxes();
            }
        },

        reflowCharts: function() {
            var plotArea = this,
                charts = plotArea.charts,
                count = charts.length,
                box = plotArea.box,
                i;

            for (i = 0; i < count; i++) {
                charts[i].reflow(box);
            }

            plotArea.box = box;
        },

        wrapAxes: function() {
            var plotArea = this,
                axisY = plotArea.axisY,
                axisX = plotArea.axisX,
                boxX,
                boxY;

            if (axisY || axisX) {
                boxX = axisX.getAxisLineBox();
                boxY = axisY.getAxisLineBox();
                plotArea.box = boxX.clone().wrap(boxY);
            }
        },

        renderGridLines: function(view, axis, secondaryAxis) {
            var options = axis.options,
                isVertical = options.orientation === VERTICAL,
                boundaries = secondaryAxis.getMajorTickPositions(),
                crossingSlot = axis.getSlot(options.axisCrossingValue),
                secAxisPos = round(crossingSlot[isVertical ? "y1" : "x1"]),
                lineStart = boundaries[0],
                lineEnd = boundaries.pop(),
                linePos,
                majorTicks = axis.getMajorTickPositions(),
                gridLines = [],
                gridLine = function (pos, options) {
                    return {
                        pos: pos,
                        options: options
                    };
                };

                if (options.majorGridLines.visible) {
                    gridLines = map(majorTicks, function(pos) {
                                    return gridLine(pos, options.majorGridLines);
                                });
                }

                if (options.minorGridLines.visible) {
                    gridLines = gridLines.concat(
                        map(axis.getMinorTickPositions(), function(pos) {
                            if (options.majorGridLines.visible) {
                                if (!inArray(pos, majorTicks)) {
                                    return gridLine(pos, options.minorGridLines);
                                }
                            } else {
                                return gridLine(pos, options.minorGridLines);
                            }
                        }
                    ));
                }

                return map(gridLines, function(line) {
                    var gridLineOptions = {
                            strokeWidth: line.options.width,
                            stroke: line.options.color,
                            dashType: line.options.dashType
                        },
                        linePos = round(line.pos);

                    if (secAxisPos === linePos) {
                        return null;
                    }

                    if (isVertical) {
                        return view.createLine(
                            lineStart, linePos, lineEnd, linePos,
                            gridLineOptions);
                    } else {
                        return view.createLine(
                            linePos, lineStart, linePos, lineEnd,
                            gridLineOptions);
                    }
                });
        },

        getViewElements: function(view) {
            var plotArea = this,
                options = plotArea.options.plotArea,
                axisY = plotArea.axisY,
                axisX = plotArea.axisX,
                gridLinesY = axisY ? plotArea.renderGridLines(view, axisY, axisX) : [],
                gridLinesX = axisX ? plotArea.renderGridLines(view, axisX, axisY) : [],
                childElements = ChartElement.fn.getViewElements.call(plotArea, view),
                border = options.border || {},
                elements = [
                    view.createRect(plotArea.box, {
                        fill: options.background,
                        zIndex: -1
                    }),
                    view.createRect(plotArea.box, {
                        stroke: border.width ? border.color : "",
                        strokeWidth: border.width,
                        fill: "",
                        zIndex: 0,
                        dashType: border.dashType
                    })
                ];

            return [].concat(gridLinesY, gridLinesX, childElements, elements);
        }

    });

    // **************************
    // Visual elements
    // **************************

    var ViewElement = Class.extend({
        init: function(options) {
            var element = this;
            element.children = [];
            element.options = deepExtend({}, element.options, options);
        },

        render: function() {
            return this.template(this);
        },

        renderContent: function() {
            var output = "",
                element = this,
                sortedChildren = element.sortChildren(),
                childrenCount = sortedChildren.length;

            for (var i = 0; i < childrenCount; i++) {
                output += sortedChildren[i].render();
            }

            return output;
        },

        sortChildren: function() {
            var element = this,
                children = element.children;

            for (var i = 0, length = children.length; i < length; i++) {
                children[i]._childIndex = i;
            }

            return children.slice(0).sort(element.compareChildren);
        },

        compareChildren: function(a, b) {
            var aValue = a.options.zIndex || 0,
                bValue = b.options.zIndex || 0;

            if (aValue !== bValue) {
                return aValue - bValue;
            }

            return a._childIndex - b._childIndex;
        },

        renderAttr: function (name, value) {
            return defined(value) ? " " + name + "='" + value + "' " : "";
        }
    });

    var ViewBase = ViewElement.extend({
        init: function(options) {
            var view = this;

            ViewElement.fn.init.call(view, options);

            view.definitions = {};
            view.decorators = [];
            view.animations = [];
        },

        renderDefinitions: function() {
            var view = this,
                definitions = view.definitions,
                definitionId,
                output = "";

            for (definitionId in definitions) {
                if (definitions.hasOwnProperty(definitionId)) {
                    output += definitions[definitionId].render();
                }
            }

            return output;
        },

        decorate: function(element) {
            var view = this,
                decorators = view.decorators,
                i,
                length = decorators.length,
                currentDecorator,
                j;

            for (i = 0; i < length; i++) {
                currentDecorator = decorators[i];
                view._decorateChildren(currentDecorator, element);
                element = currentDecorator.decorate.call(currentDecorator, element);
            }

            return element;
        },

        _decorateChildren: function(decorator, element) {
            var view = this,
                children = element.children,
                i,
                length = children.length;

            for (i = 0; i < length; i++) {
                view._decorateChildren(decorator, children[i]);
                children[i] = decorator.decorate.call(decorator, children[i]);
            }
        },

        setupAnimations: function() {
            var animations = this.animations,
                i,
                count = animations.length;

            for (i = 0; i < count; i++) {
                animations[i].setup();
            }
        },

        playAnimations: function() {
            var view = this,
                anim;

            while(anim = view.animations.shift()) {
                anim.play();
            }
        },

        buildGradient: function(options) {
            var view = this,
                cache = view._gradientCache,
                hashCode,
                overlay,
                definition;

            if (!cache) {
                cache = view._gradientCache = [];
            }

            if (options) {
                hashCode = getHash(options);
                overlay = cache[hashCode];
                definition = Chart.Gradients[options.gradient];
                if (!overlay && definition) {
                    overlay = deepExtend({ id: uniqueId() }, definition, options);
                    cache[hashCode] = overlay;
                }
            }

            return overlay;
        }
    });

    function supportsSVG() {
        return doc.implementation.hasFeature(
            "http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
    }

    // Animations
    var BarAnimationDecorator = Class.extend({
        init: function(view) {
            this.view = view;
        },

        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                box = element.options.box,
                animation = element.options.animation;

            if (animation && view.options.transitions) {
                if (animation.type === BAR) {
                    view.animations.push(
                        new BarAnimation(element)
                    );
                }
            }

            return element;
        }
    });

    var PieAnimationDecorator = Class.extend({
        init: function(view) {
            this.view = view;
        },

        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                animation = element.options.animation;

            if (animation && animation.type === PIE && view.options.transitions) {
                view.animations.push(
                    new PieAnimation(element, animation)
                );
            }

            return element;
        }
    });

    var FadeAnimationDecorator = Class.extend({
        init: function(view) {
            this.view = view;
        },

        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                options = view.options,
                animation = element.options.animation;

            if (animation && animation.type === FADEIN && options.transitions) {
                view.animations.push(
                    new FadeAnimation(element, animation)
                );
            }

            return element;
        }
    });

    var ElementAnimation = Class.extend({
        init: function(element, options) {
            var anim = this;

            anim.options = deepExtend({}, anim.options, options);
            anim.element = element;
        },

        options: {
            duration: INITIAL_ANIMATION_DURATION,
            easing: SWING
        },

        play: function() {
            var anim = this,
                options = anim.options,
                element = anim.element,
                delay = options.delay || 0,
                start = +new Date() + delay,
                duration = options.duration,
                finish = start + duration,
                domElement = doc.getElementById(element.options.id),
                easing = jQuery.easing[options.easing],
                time,
                pos,
                easingPos;

            setTimeout(function() {
                var loop = function() {
                    time = +new Date();
                    pos = time > finish ? 1 : (time - start) / duration;
                    easingPos = easing(pos, time - start, 0, 1, duration);

                    anim.step(easingPos);

                    element.refresh(domElement);

                    if (time < finish) {
                        requestAnimFrame(loop, domElement);
                    }
                };

                loop();
            }, delay);
        },

        setup: function() {
        },

        step: function(pos) {
        }
    });

    var FadeAnimation = ElementAnimation.extend({
        options: {
            duration: 200,
            easing: LINEAR
        },

        setup: function() {
            var anim = this,
                options = anim.element.options;

            anim.targetFillOpacity = options.fillOpacity;
            anim.targetStrokeOpacity = options.strokeOpacity;
            options.fillOpacity = options.strokeOpacity = 0;
        },

        step: function(pos) {
            var anim = this,
                options = anim.element.options;

            options.fillOpacity = pos * anim.targetFillOpacity;
            options.strokeOpacity = pos * anim.targetStrokeOpacity;
        }
    });

    var ExpandAnimation = ElementAnimation.extend({
        options: {
            size: 0,
            easing: LINEAR
        },

        setup: function() {
            var anim = this,
                points = anim.element.points;

            points[1].x = points[2].x = points[0].x;
        },

        step: function(pos) {
            var anim = this,
                options = anim.options,
                size = interpolateValue(0, options.size, pos),
                points = anim.element.points;

            // Expands rectangle to the right
            points[1].x = points[2].x = points[0].x + size;
        }
    });

    var requestAnimFrame =
        window.requestAnimationFrame       ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame    ||
        window.oRequestAnimationFrame      ||
        window.msRequestAnimationFrame     ||
        function(callback, element) {
            setTimeout(callback, ANIMATION_STEP);
        };

    var BarAnimation = ElementAnimation.extend({
        options: {
            easing: SWING
        },

        setup: function() {
            var anim = this,
                element = anim.element,
                points = element.points,
                options = element.options,
                axis = options.normalAngle === 0 ? Y : X,
                stackBase = options.stackBase,
                aboveAxis = options.aboveAxis,
                startPosition,
                endState = anim.endState = {
                    top: points[0].y,
                    right: points[1].x,
                    bottom: points[3].y,
                    left: points[0].x
                };

            if (axis === Y) {
                startPosition = defined(stackBase) ? stackBase :
                    aboveAxis ? endState.bottom : endState.top;
            } else {
                startPosition = defined(stackBase) ? stackBase :
                    aboveAxis ? endState.left : endState.right;
            }

            anim.startPosition = startPosition;

            updateArray(points, axis, startPosition);
        },

        step: function(pos) {
            var anim = this,
                startPosition = anim.startPosition,
                endState = anim.endState,
                element = anim.element,
                points = element.points;

            if (element.options.normalAngle === 0) {
                points[0].y = points[1].y =
                    interpolateValue(startPosition, endState.top, pos);

                points[2].y = points[3].y =
                    interpolateValue(startPosition, endState.bottom, pos);
            } else {
                points[0].x = points[3].x =
                    interpolateValue(startPosition, endState.left, pos);

                points[1].x = points[2].x =
                    interpolateValue(startPosition, endState.right, pos);
            }
        }
    });

    var PieAnimation = ElementAnimation.extend({
        options: {
            easing: "easeOutElastic",
            duration: INITIAL_ANIMATION_DURATION
        },

        setup: function() {
            var anim = this,
                sector = anim.element.circleSector;

            anim.endRadius = sector.r;
            sector.r = 0;
        },

        step: function(pos) {
            var anim = this,
                endRadius = anim.endRadius,
                sector = anim.element.circleSector;

            sector.r = interpolateValue(0, endRadius, pos);
        }
    });

    var Highlight = Class.extend({
        init: function(view, viewElement, options) {
            var highlight = this;
            highlight.options = deepExtend({}, highlight.options, options);

            highlight.view = view;
            highlight.viewElement = viewElement;
        },

        options: {
            fill: WHITE,
            fillOpacity: 0.2,
            stroke: WHITE,
            strokeWidth: 1,
            strokeOpacity: 0.2
        },

        show: function(point) {
            var highlight = this,
                chart = highlight.chart,
                view = highlight.view,
                viewElement = highlight.viewElement,
                outline,
                element;

            highlight.hide();

            if (point.getOutlineElement) {
                outline = point.getOutlineElement(view, highlight.options);

                if (outline) {
                    element = view.renderElement(outline);
                    viewElement.appendChild(element);

                    highlight.element = element;
                    highlight.visible = true;
                }
            }
        },

        hide: function() {
            var highlight = this,
                element = highlight.element;

            if (element) {
                element.parentNode.removeChild(element);

                delete highlight.element;
                highlight.visible = false;
            }
        }
    });

    var Tooltip = Class.extend({
        init: function(chartElement, options) {
            var tooltip = this;

            tooltip.options = deepExtend({}, tooltip.options, options);
            options = tooltip.options;

            tooltip.chartElement = chartElement;

            tooltip.template = Tooltip.template;
            if (!tooltip.template) {
                tooltip.template = Tooltip.template = template(
                    "<div style='display:none; position: absolute; font: #= d.font #;" +
                    "border-radius: 4px; -moz-border-radius: 4px; -webkit-border-radius: 4px;" +
                    "border: #= d.border.width #px solid;" +
                    "opacity: #= d.opacity #; filter: alpha(opacity=#= d.opacity * 100 #);" +
                    "padding: 2px 6px; white-space: nowrap;'></div>"
                );
            }

            tooltip.element = $(tooltip.template(tooltip.options)).appendTo(chartElement);
        },

        options: {
            background: BLACK,
            color: WHITE,
            border: {
                width: 3
            },
            opacity: 1,
            animation: {
                duration: TOOLTIP_ANIMATION_DURATION
            }
        },

        show: function(point) {
            var tooltip = this;

            tooltip.point = point;
            setTimeout(proxy(tooltip._show, tooltip), TOOLTIP_SHOW_DELAY);
        },

        _show: function() {
            var tooltip = this,
                point = tooltip.point,
                element = tooltip.element,
                options = tooltip.options,
                anchor,
                template,
                content,
                pointTooltipOptions,
                tooltipFormat,
                tooltipTemplate,
                top,
                left;

            if (!point) {
                return;
            }
            content = point.value.toString();
            pointTooltipOptions = point.options.tooltip;
            tooltipFormat = defined(pointTooltipOptions) ? pointTooltipOptions.format : options.format;
            tooltipTemplate = defined(pointTooltipOptions) ? pointTooltipOptions.template : options.template;

            if (tooltipTemplate) {
                template = baseTemplate(options.template);
                content = template({
                    value: point.value,
                    category: point.category,
                    series: point.series,
                    dataItem: point.dataItem
                });
            } else if (tooltipFormat) {
                content = point.formatPointValue(tooltipFormat);
            }

            element.html(content);

            anchor = point.tooltipAnchor(element.outerWidth(), element.outerHeight());
            top = round(anchor.y) + "px";
            left = round(anchor.x) + "px";

            if (!tooltip.visible) {
                tooltip.element.css({top: top, left: left});
            }

            tooltip.element
                .css({
                   backgroundColor: options.background,
                   borderColor: options.border.color || point.options.color,
                   color: options.color,
                   opacity: options.opacity
                })
                .stop(true, true)
                .show()
                .animate({
                    left: left,
                    top: top
                }, options.animation.duration);

            tooltip.visible = true;
        },

        hide: function() {
            var tooltip = this;

            if (tooltip.visible) {
                tooltip.element.fadeOut();

                tooltip.point = null;
                tooltip.visible = false;
            }
        }
    });

    // Helper functions
    function ceil(value, step) {
        return round(math.ceil(value / step) * step, DEFAULT_PRECISION);
    }

    function floor(value, step) {
        return round(math.floor(value / step) * step, DEFAULT_PRECISION);
    }

    function round(value, precision) {
        var power = math.pow(10, precision || 0);
        return math.round(value * power) / power;
    }

    function measureText(text, style, rotation) {
        var styleHash = getHash(style),
            cacheKey = text + styleHash + rotation,
            cachedResult = measureText.cache[cacheKey];

        if (cachedResult) {
            return cachedResult;
        }

        var measureBox = measureText.measureBox,
            baselineMarker = measureText.baselineMarker.cloneNode(false);

        if (!measureBox) {
            measureBox = measureText.measureBox =
                $("<div style='position: absolute; top: -4000px; left: -4000px;" +
                              "line-height: normal; visibility: hidden;' />")
                .appendTo(doc.body)[0];
        }

        for (var styleKey in style) {
            measureBox.style[styleKey] = style[styleKey];
        }
        measureBox.innerHTML = text;
        measureBox.appendChild(baselineMarker);

        var size = {
                width: measureBox.offsetWidth - BASELINE_MARKER_SIZE,
                height: measureBox.offsetHeight,
                baseline: baselineMarker.offsetTop + BASELINE_MARKER_SIZE
            };

        if (rotation) {
            var width = size.width,
                height = size.height,
                cx = width / 2,
                cy = height / 2,
                r1 = rotatePoint(0, 0, cx, cy, rotation),
                r2 = rotatePoint(width, 0, cx, cy, rotation),
                r3 = rotatePoint(width, height, cx, cy, rotation);
                r4 = rotatePoint(0, height, cx, cy, rotation);

            size.normalWidth = width;
            size.normalHeight = height;
            size.width = math.max(r1.x, r2.x, r3.x, r4.x) - math.min(r1.x, r2.x, r3.x, r4.x);
            size.height = math.max(r1.y, r2.y, r3.y, r4.y) - math.min(r1.y, r2.y, r3.y, r4.y);
        }

        measureText.cache[cacheKey] = size;

        return size;
    }

    measureText.cache = [];
    measureText.baselineMarker =
        $("<div style='display: inline-block; vertical-align: baseline;" +
                  "width: " + BASELINE_MARKER_SIZE + "px; height: " + BASELINE_MARKER_SIZE + "px;" +
                  "zoom: 1; *display: inline; overflow: hidden;' />")[0];

    function getHash(object) {
        var hash = [];
        for (var key in object) {
            hash.push(key + object[key]);
        }

        return hash.sort().join(" ");
    }

    function rotatePoint(x, y, cx, cy, angle) {
        var theta = angle * DEGREE;
        return {
            x: cx + (x - cx) * math.cos(theta) + (y - cy) * math.sin(theta),
            y: cy - (x - cx) * math.sin(theta) + (y - cy) * math.cos(theta)
        }
    }

    function boxDiff(r, s) {
        if (r.x1 == s.x1 && r.y1 == s.y1 && r.x2 == s.x2 && r.y2 == s.y2) {
            return s;
        }

        var a = math.min(r.x1, s.x1);
        var b = math.max(r.x1, s.x1);
        var c = math.min(r.x2, s.x2);
        var d = math.max(r.x2, s.x2);

        var e = math.min(r.y1, s.y1);
        var f = math.max(r.y1, s.y1);
        var g = math.min(r.y2, s.y2);
        var h = math.max(r.y2, s.y2);

        // X = intersection, 0-7 = possible difference areas
        // h +-+-+-+
        // . |5|6|7|
        // g +-+-+-+
        // . |3|X|4|
        // f +-+-+-+
        // . |0|1|2|
        // e +-+-+-+
        // . a b c d

        var result = [];

        // we'll always have rectangles 1, 3, 4 and 6
        result[0] = new Box2D(b, e, c, f);
        result[1] = new Box2D(a, f, b, g);
        result[2] = new Box2D(c, f, d, g);
        result[3] = new Box2D(b, g, c, h);

        // decide which corners
        if( r.x1 == a && r.y1 == e || s.x1 == a && s.y1 == e )
        { // corners 0 and 7
            result[4] = new Box2D(a, e, b, f);
            result[5] = new Box2D(c, g, d, h);
        }
        else
        { // corners 2 and 5
            result[4] = new Box2D(c, e, d, f);
            result[5] = new Box2D(a, g, b, h);
        }

        return $.grep(result, function(box) {
            return box.height() > 0 && box.width() > 0
        })[0];
    }

    function sparseArrayMin(arr) {
        return sparseArrayLimits(arr).min;
    }

    function sparseArrayMax(arr) {
        return sparseArrayLimits(arr).max;
    }

    function sparseArrayLimits(arr) {
        var min = Number.MAX_VALUE,
            max = - Number.MAX_VALUE;
        for (var i = 0, length = arr.length; i < length; i++) {
            var n = arr[i];
            if (defined(n)) {
                min = math.min(min, n);
                max = math.max(max, n);
            }
        }

        return { min: min, max: max };
    }

    function getSpacing(value) {
        var spacing = {};

        if (typeof(value) === "number") {
            spacing[TOP] = spacing[RIGHT] = spacing[BOTTOM] = spacing[LEFT] = value;
        } else {
            spacing[TOP] = value[TOP] || 0;
            spacing[RIGHT] = value[RIGHT] || 0;
            spacing[BOTTOM] = value[BOTTOM] || 0;
            spacing[LEFT] = value[LEFT] || 0;
        }

        return spacing;
    }

    function inArray(value, array) {
        return $.inArray(value, array) != -1;
    }

    function deepExtend(destination) {
        var i = 1,
            length = arguments.length,
            source,
            property,
            propValue,
            propType;

        for (i = 1; i < length; i++) {
            source = arguments[i];

            for (property in source) {
                propValue = source[property];
                propType = typeof propValue;
                if (propType === OBJECT && propValue !== null && propValue.constructor !== Array) {
                    if (typeof(destination[property]) === OBJECT) {
                        destination[property] = destination[property] || {};
                    } else {
                        destination[property] = {};
                    }
                    deepExtend(destination[property], propValue);
                } else if (propType !== UNDEFINED) {
                    destination[property] = propValue;
                }
            }
        }

        return destination;
    }

    function intersection(a1, a2, b1, b2) {
        var result,
            ua_t = (b2.x - b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x),
            ub_t = (a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x),
            u_b = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y),
            ua,
            ub;

        if (u_b != 0) {
            ua = (ua_t / u_b);
            ub = (ub_t / u_b);

            result = new Point2D(
                a1.x + ua * (a2.x - a1.x),
                a1.y + ua * (a2.y - a1.y)
            );
        }

        return result;
    }

    function append(first, second) {
        [].push.apply(first, second);
    }

    function interpolateValue(start, end, progress) {
        return round(start + (end - start) * progress, COORD_PRECISION);
    }

    function applySeriesDefaults(options, themeOptions) {
        var series = options.series,
            i,
            seriesLength = series.length,
            seriesType,
            seriesDefaults = options.seriesDefaults,
            baseSeriesDefaults = deepExtend({}, options.seriesDefaults),
            themeSeriesDefaults = themeOptions ? deepExtend({}, themeOptions.seriesDefaults) : {};

        delete baseSeriesDefaults.bar;
        delete baseSeriesDefaults.column;
        delete baseSeriesDefaults.line;
        delete baseSeriesDefaults.pie;
        delete baseSeriesDefaults.scatter;
        delete baseSeriesDefaults.scatterLine;

        for (i = 0; i < seriesLength; i++) {
            seriesType = series[i].type || options.seriesDefaults.type;

            series[i] = deepExtend(
                {},
                themeSeriesDefaults,
                themeSeriesDefaults[seriesType],
                baseSeriesDefaults,
                seriesDefaults[seriesType],
                series[i]);
        }
    }

    function applySeriesColors(options) {
        var series = options.series,
            i,
            seriesLength = series.length,
            currentSeries,
            colors = options.seriesColors || [];

        for (i = 0; i < seriesLength; i++) {
            series[i].color = series[i].color || colors[i % colors.length];
        }
    }

    function applyAxisDefaults(options, themeOptions) {
        var themeAxisDefaults = themeOptions ? deepExtend({}, themeOptions.axisDefaults) : {};

        $.each(["category", "value", "x", "y"], function() {
            var axisName = this + "Axis";
            options[axisName] = deepExtend({},
                themeAxisDefaults,
                themeAxisDefaults[axisName],
                options.axisDefaults,
                options[axisName]
            );
        });
    }

    function incrementSlot(slots, index, value) {
        slots[index] = (slots[index] || 0) + value;
    }

    function uniqueId() {
        var id = "k", i;

        for (i = 0; i < 16; i++) {
            id += (math.random() * 16 | 0).toString(16);
        }

        return id;
    }

    function defined(value) {
        return typeof value !== UNDEFINED;
    }

    var Color = function(value) {
        var color = this,
            formats = Color.formats,
            re,
            processor,
            parts,
            i,
            channels;

        if (arguments.length === 1) {
            value = color.resolveColor(value);

            for (i = 0; i < formats.length; i++) {
                re = formats[i].re;
                processor = formats[i].process;
                parts = re.exec(value);

                if (parts) {
                    channels = processor(parts);
                    color.r = channels[0];
                    color.g = channels[1];
                    color.b = channels[2];
                }
            }
        } else {
            color.r = arguments[0];
            color.g = arguments[1];
            color.b = arguments[2];
        }

        color.r = color.normalizeByte(color.r);
        color.g = color.normalizeByte(color.g);
        color.b = color.normalizeByte(color.b);
    };

    Color.prototype = {
        toHex: function() {
            var color = this,
                pad = color.padDigit,
                r = color.r.toString(16),
                g = color.g.toString(16),
                b = color.b.toString(16);

            return "#" + pad(r) + pad(g) + pad(b);
        },

        resolveColor: function(value) {
            value = value || BLACK;

            if (value.charAt(0) == "#") {
                value = value.substr(1, 6);
            }

            value = value.replace(/ /g, "");
            value = value.toLowerCase();
            value = Color.namedColors[value] || value;

            return value;
        },

        normalizeByte: function(value) {
            return (value < 0 || isNaN(value)) ? 0 : ((value > 255) ? 255 : value);
        },

        padDigit: function(value) {
            return (value.length === 1) ? "0" + value : value;
        },

        brightness: function(value) {
            var color = this,
                round = math.round;

            color.r = round(color.normalizeByte(color.r * value));
            color.g = round(color.normalizeByte(color.g * value));
            color.b = round(color.normalizeByte(color.b * value));

            return color;
        }
    };

    Color.formats = [{
            re: /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/,
            process: function(parts) {
                return [
                    parseInt(parts[1], 10), parseInt(parts[2], 10), parseInt(parts[3], 10)
                ];
            }
        }, {
            re: /^(\w{2})(\w{2})(\w{2})$/,
            process: function(parts) {
                return [
                    parseInt(parts[1], 16), parseInt(parts[2], 16), parseInt(parts[3], 16)
                ];
            }
        }, {
            re: /^(\w{1})(\w{1})(\w{1})$/,
            process: function(parts) {
                return [
                    parseInt(parts[1] + parts[1], 16),
                    parseInt(parts[2] + parts[2], 16),
                    parseInt(parts[3] + parts[3], 16)
                ];
            }
        }
    ];

    Color.namedColors = {
        aqua: "00ffff", azure: "f0ffff", beige: "f5f5dc",
        black: "000000", blue: "0000ff", brown: "a52a2a",
        coral: "ff7f50", cyan: "00ffff", darkblue: "00008b",
        darkcyan: "008b8b", darkgray: "a9a9a9", darkgreen: "006400",
        darkorange: "ff8c00", darkred: "8b0000", dimgray: "696969",
        fuchsia: "ff00ff", gold: "ffd700", goldenrod: "daa520",
        gray: "808080", green: "008000", greenyellow: "adff2f",
        indigo: "4b0082", ivory: "fffff0", khaki: "f0e68c",
        lightblue: "add8e6", lightgrey: "d3d3d3", lightgreen: "90ee90",
        lightpink: "ffb6c1", lightyellow: "ffffe0", lime: "00ff00",
        limegreen: "32cd32", linen: "faf0e6", magenta: "ff00ff",
        maroon: "800000", mediumblue: "0000cd", navy: "000080",
        olive: "808000", orange: "ffa500", orangered: "ff4500",
        orchid: "da70d6", pink: "ffc0cb", plum: "dda0dd",
        purple: "800080", red: "ff0000", royalblue: "4169e1",
        salmon: "fa8072", silver: "c0c0c0", skyblue: "87ceeb",
        slateblue: "6a5acd", slategray: "708090", snow: "fffafa",
        steelblue: "4682b4", tan: "d2b48c", teal: "008080",
        tomato: "ff6347", turquoise: "40e0d0", violet: "ee82ee",
        wheat: "f5deb3", white: "ffffff", whitesmoke: "f5f5f5",
        yellow: "ffff00", yellowgreen: "9acd32"
    };

    Chart.Gradients = {
        glass: {
            type: LINEAR,
            rotation: 0,
            stops: [{
                offset: 0,
                color: WHITE,
                opacity: 0
            }, {
                offset: 0.1,
                color: WHITE,
                opacity: 0
            }, {
                offset: 0.25,
                color: WHITE,
                opacity: 0.3
            }, {
                offset: 0.92,
                color: WHITE,
                opacity: 0
            }, {
                offset: 1,
                color: WHITE,
                opacity: 0
            }]
        },
        sharpBevel: {
            type: RADIAL,
            stops: [{
                offset: 0,
                color: WHITE,
                opacity: 0.55
            }, {
                offset: 0.65,
                color: WHITE,
                opacity: 0
            }, {
                offset: 0.95,
                color: WHITE,
                opacity: 0
            }, {
                offset: 0.95,
                color: WHITE,
                opacity: 0.25
            }]
        },
        roundedBevel: {
            type: RADIAL,
            stops: [{
                offset: 0.33,
                color: WHITE,
                opacity: 0.06
            }, {
                offset: 0.83,
                color: WHITE,
                opacity: 0.2
            }, {
                offset: 0.95,
                color: WHITE,
                opacity: 0
            }]
        }
    };

    function updateArray(arr, prop, value) {
        var i,
            length = arr.length;

        for(i = 0; i < length; i++) {
            arr[i][prop] = value;
        }
    }

    function categoriesCount(series) {
        var seriesCount = series.length,
            categories = 0,
            i;

        for (i = 0; i < seriesCount; i++) {
            categories = math.max(categories, series[i].data.length);
        }

        return categories;
    }

    function sqr(value) {
        return value * value;
    }

    jQuery.extend(jQuery.easing, {
        easeOutElastic: function (n, d, first, diff) {
            var s = 1.70158,
                p = 0,
                a = diff;

            if ( n === 0 ) {
                return first;
            }

            if ( n === 1) {
                return first + diff;
            }

            if (!p) {
                p = 0.5;
            }

            if (a < Math.abs(diff)) {
                a=diff;
                s = p / 4;
            } else {
                s = p / (2 * Math.PI) * Math.asin(diff / a);
            }

            return a * Math.pow(2,-10 * n) *
                   Math.sin((n * 1 - s) * (1.1 * Math.PI) / p) +
                   diff + first;
        }
    });

    // Exports ================================================================

    $t.scripts.push("easyui.chart.js");

    $t.chart = function (element, options) {
        var wrapper = this;
        wrapper.element = element;

        $t.bind(wrapper.element, {
            load: options.onLoad
        });

        wrapper._chart = new Chart(element,
            deepExtend(options, {
                dataBound: options.onDataBound,
                seriesClick: options.onSeriesClick
            })
        );
        wrapper.options = wrapper._chart.options;
    };

    $t.chart.prototype = {
        rebind: function(data) {
            this._chart.dataSource.read(data);
        },

        refresh: function() {
            var wrapper = this,
                chart = wrapper._chart;

            chart.options = wrapper.options;
            chart.refresh();
        },

        svg: function() {
            return this._chart.svg();
        }
    };

    $.fn.tChart = function(options) {
        return $t.create(this, {
            name: "tChart",
            init: function(element, options) {
                return new $t.chart(element, options);
            },
            options: options
        });
    };

    $.fn.tChart.defaults = { };

    $t.chart.Chart = Chart;

    deepExtend(Chart, {
        COORD_PRECISION: COORD_PRECISION,
        CLIP: CLIP,
        DEFAULT_WIDTH: DEFAULT_WIDTH,
        DEFAULT_HEIGHT: DEFAULT_HEIGHT,
        DEFAULT_FONT: DEFAULT_FONT,
        defined: defined,
        template: template,
        rotatePoint: rotatePoint,
        round: round,
        supportsSVG: supportsSVG,
        uniqueId: uniqueId,
        Box2D: Box2D,
        Point2D: Point2D,
        Sector: Sector,
        Text: Text,
        BarLabel: BarLabel,
        ChartElement: ChartElement,
        RootElement: RootElement,
        BoxElement: BoxElement,
        TextBox: TextBox,
        NumericAxis: NumericAxis,
        CategoryAxis: CategoryAxis,
        Bar: Bar,
        BarChart: BarChart,
        ShapeElement: ShapeElement,
        LinePoint: LinePoint,
        LineChart: LineChart,
        ClusterLayout: ClusterLayout,
        StackLayout: StackLayout,
        Title: Title,
        Legend: Legend,
        PlotArea: PlotArea,
        Tooltip: Tooltip,
        Highlight: Highlight,
        PieSegment: PieSegment,
        PieChart: PieChart,
        ViewElement: ViewElement,
        ScatterChart: ScatterChart,
        ScatterLineChart: ScatterLineChart,
        ViewBase: ViewBase,
        deepExtend: deepExtend,
        Color: Color,
        measureText: measureText,
        ExpandAnimation: ExpandAnimation,
        BarAnimation: BarAnimation,
        BarAnimationDecorator: BarAnimationDecorator,
        PieAnimation: PieAnimation,
        PieAnimationDecorator: PieAnimationDecorator,
        FadeAnimation: FadeAnimation,
        FadeAnimationDecorator: FadeAnimationDecorator,
        categoriesCount: categoriesCount
    });

})(jQuery);
(function () {

    // Imports ================================================================
    var $ = jQuery,
        $t = $.easyui,
        Class = $t.Class,
        Chart = $t.chart.Chart,
        BarAnimationDecorator = Chart.BarAnimationDecorator,
        PieAnimationDecorator = Chart.PieAnimationDecorator,
        FadeAnimationDecorator = Chart.FadeAnimationDecorator,
        Box2D = Chart.Box2D,
        Point2D = Chart.Point2D,
        ExpandAnimation = Chart.ExpandAnimation,
        ViewBase = Chart.ViewBase,
        ViewElement = Chart.ViewElement,
        deepExtend = Chart.deepExtend,
        defined = Chart.defined,
        template = Chart.template,
        uniqueId = Chart.uniqueId,
        round = Chart.round,
        doc = document,
        math = Math;

    // Constants ==============================================================
    var CLIP = Chart.CLIP,
        COORD_PRECISION = Chart.COORD_PRECISION,
        DEFAULT_WIDTH = Chart.DEFAULT_WIDTH,
        DEFAULT_HEIGHT = Chart.DEFAULT_HEIGHT,
        DEFAULT_FONT = Chart.DEFAULT_FONT,
        GLOBAL_CLIP = "globalClip",
        NONE = "none",
        RADIAL = "radial",
        SQUARE = "square",
        SVG_NS = "http://www.w3.org/2000/svg",
        SVG_DASH_TYPE = {
            dot: [1.5, 3.5],
            dash: [4, 3.5],
            longdash: [8, 3.5],
            dashdot: [3.5, 3.5, 1.5, 3.5],
            longdashdot: [8, 3.5, 1.5, 3.5],
            longdashdotdot: [8, 3.5, 1.5, 3.5, 1.5, 3.5]
        },
        UNDEFINED = "undefined";

    // View ===================================================================
    var SVGView = ViewBase.extend({
        init: function(options) {
            var view = this;

            ViewBase.fn.init.call(view, options);

            view.decorators.push(
                new SVGOverlayDecorator(view),
                new SVGGradientDecorator(view),
                new BarAnimationDecorator(view),
                new PieAnimationDecorator(view),
                new SVGClipAnimationDecorator(view),
                new FadeAnimationDecorator(view)
            );

            view.template = SVGView.template;
            if (!view.template) {
                view.template = SVGView.template = template(
                    "<svg xmlns='" + SVG_NS + "' version='1.1' " +
                    "width='#= d.options.width #px' height='#= d.options.height #px' " +
                    "style='position: relative;'>" +
                    "#= d.renderDefinitions() #" +
                    "#= d.renderContent() #</svg>"
                );
            }
        },

        options: {
            width: DEFAULT_WIDTH,
            height: DEFAULT_HEIGHT,
            idPrefix: ""
        },

        renderTo: function(container) {
            var view = this,
                viewElement;

            view.setupAnimations();

            renderSVG(container, view.render());
            viewElement = container.firstChild;
            view.alignToScreen(viewElement);

            view.playAnimations();

            return viewElement;
        },

        renderDefinitions: function() {
            var view = this,
                output = ViewBase.fn.renderDefinitions.call(view);

            return output.length > 0 ? "<defs>" + output + "</defs>" : "";
        },

        renderElement: function(element) {
            var container = doc.createElement("div"),
                element;

            renderSVG(container,
                "<svg xmlns='" + SVG_NS + "' version='1.1'>" +
                element.render() +
                "</svg>"
            );

            element = container.firstChild.firstChild;

            return element;
        },

        createGroup: function(options) {
            return this.decorate(
                new SVGGroup(options)
            );
        },

        createText: function(content, options) {
            return this.decorate(
                new SVGText(content, options)
            );
        },

        createRect: function(box, style) {
            return this.decorate(
                new SVGLine(box.points(), true, style)
            );
        },

        createLine: function(x1, y1, x2, y2, options) {
            return this.decorate(
                new SVGLine([new Point2D(x1, y1),
                             new Point2D(x2, y2)], false, options)
            );
        },

        createPolyline: function(points, closed, options) {
            return this.decorate(
                new SVGLine(points, closed, options)
            );
        },

        createCircle: function(center, radius, options) {
            return this.decorate(
                new SVGCircle(center, radius, options)
            );
        },

        createSector: function(sector, options) {
            return this.decorate(
                new SVGSector(sector, options)
            );
        },

        createGradient: function(options) {
            if (options.type === RADIAL) {
                return new SVGRadialGradient(options);
            } else {
                return new SVGLinearGradient(options)
            }
        },

        alignToScreen: function(element) {
            try {
                var ctm = element.getScreenCTM ? element.getScreenCTM() : null;
            } catch (e) { }

            if (ctm) {
                var left = - ctm.e % 1,
                    top = - ctm.f % 1,
                    style = element.style;

                if (left !== 0 || top !== 0) {
                    style.left = left + "px";
                    style.top = top + "px";
                }
            }
        }
    });

    SVGView.fromModel = function(model) {
        var view = new SVGView(model.options);
        [].push.apply(view.children, model.getViewElements(view));

        return view;
    }

    // Primitives =============================================================
    var SVGText = ViewElement.extend({
        init: function(content, options) {
            var text = this;
            ViewElement.fn.init.call(text, options);

            text.content = content;
            text.template = SVGText.template;
            if (!text.template) {
                text.template = SVGText.template = template(
                    "<text #= d.renderAttr(\"id\", d.options.id) # " +
                    "x='#= Math.round(d.options.x) #' " +
                    "y='#= Math.round(d.options.y + d.options.baseline) #' " +
                    "fill-opacity='#= d.options.fillOpacity #' " +
                    "#= d.options.rotation ? d.renderRotation() : '' # " +
                    "style='font: #= d.options.font #' fill='#= d.options.color #'>" +
                    "#= d.content #</text>"
                );
            }
        },

        options: {
            x: 0,
            y: 0,
            baseline: 0,
            font: DEFAULT_FONT,
            size: {
                width: 0,
                height: 0
            },
            fillOpacity: 1
        },

        refresh: function(domElement) {
            var options = this.options;

            $(domElement).attr({
                "fill-opacity": options.fillOpacity
            });
        },

        clone: function() {
            var text = this;
            return new SVGText(text.content, deepExtend({}, text.options));
        },

        renderRotation: function() {
            var text = this,
                options = text.options,
                size = options.size,
                cx = round(options.x + size.normalWidth / 2, COORD_PRECISION),
                cy = round(options.y + size.normalHeight / 2, COORD_PRECISION),
                rcx = round(options.x + size.width / 2, COORD_PRECISION),
                rcy = round(options.y + size.height / 2, COORD_PRECISION),
                offsetX = round(rcx - cx, COORD_PRECISION),
                offsetY = round(rcy - cy, COORD_PRECISION);

            return "transform='translate(" + offsetX + "," + offsetY + ") " +
                   "rotate(" + options.rotation + "," + cx + "," + cy + ")'";
        }
    });

    var SVGPath = ViewElement.extend({
        init: function(options) {
            var path = this;
            ViewElement.fn.init.call(path, options);

            path.template = SVGPath.template;
            if (!path.template) {
                path.template = SVGPath.template = template(
                    "<path #= d.renderAttr(\"id\", d.options.id) #" +
                    "d='#= d.renderPoints() #' " +
                    "#= d.renderAttr(\"stroke\", d.options.stroke) # " +
                    "#= d.renderAttr(\"stroke-width\", d.options.strokeWidth) #" +
                    "#= d.renderDashType() # " +
                    "stroke-linecap='#= d.renderLinecap() #' " +
                    "stroke-linejoin='round' " +
                    "fill-opacity='#= d.options.fillOpacity #' " +
                    "stroke-opacity='#= d.options.strokeOpacity #' " +
                    "fill='#= d.options.fill || \"none\" #'></path>"
                );
            }
        },

        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        },

        refresh: function(domElement) {
            var options = this.options;

            $(domElement).attr({
                "d": this.renderPoints(),
                "fill-opacity": options.fillOpacity,
                "stroke-opacity": options.strokeOpacity
            });
        },

        clone: function() {
            var path = this;
            return new SVGPath(deepExtend({}, path.options));
        },

        renderPoints: function() {
            // Overriden by inheritors
        },

        renderDashType: function () {
            var path = this,
                options = path.options;

            return renderSVGDash(options.dashType, options.strokeWidth);
        },

        renderLinecap: function() {
            var dashType = this.options.dashType;

            return (dashType && dashType != "solid") ? "butt" : "square";
        }
    });

    var SVGLine = SVGPath.extend({
        init: function(points, closed, options) {
            var line = this;
            SVGPath.fn.init.call(line, options);

            line.points = points;
            line.closed = closed;
        },

        renderPoints: function() {
            var line = this,
                points = line.points,
                i,
                count = points.length,
                first = points[0],
                result = "M" + line._print(first);

            for (i = 1; i < count; i++) {
                result += " " + line._print(points[i]);
            }

            if (line.closed) {
                result += " z";
            }

            return result;
        },

        clone: function() {
            var line = this;
            return new SVGLine(
                deepExtend([], line.points), line.closed,
                deepExtend({}, line.options)
            );
        },

        _print: function(point) {
            var line = this,
                strokeWidth = line.options.strokeWidth,
                shouldAlign = strokeWidth && strokeWidth % 2 !== 0,
                align = shouldAlign ? alignToPixel : math.round;

            return align(point.x) + " " + align(point.y);
        }
    });

    var SVGSector = SVGPath.extend({
        init: function(circleSector, options) {
            var sector = this;
            SVGPath.fn.init.call(sector, options);

            sector.pathTemplate = SVGSector.pathTemplate;
            if (!sector.pathTemplate) {
                sector.pathTemplate = SVGSector.pathTemplate = template(
                    "M #= d.firstPoint.x # #= d.firstPoint.y # " +
                    "A#= d.r # #= d.r # " +
                    "0 #= d.isReflexAngle ? '1' : '0' #,1 " +
                    "#= d.secondPoint.x # #= d.secondPoint.y # " +
                    "L #= d.cx # #= d.cy # z"
                );
            }

            sector.circleSector = circleSector || {};
        },

        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1,
            strokeLineCap: SQUARE
        },

        clone: function() {
            var sector = this;
            return new SVGSector(
                deepExtend({}, sector.circleSector),
                deepExtend({}, sector.options)
            );
        },

        renderPoints: function() {
            var sector = this,
                circleSector = sector.circleSector,
                startAngle = circleSector.startAngle,
                endAngle = circleSector.angle + startAngle,
                endAngle = (endAngle - startAngle) == 360 ? endAngle - 0.001 : endAngle,
                isReflexAngle = (endAngle - startAngle) > 180,
                r = math.max(circleSector.r, 0),
                cx = circleSector.c.x,
                cy = circleSector.c.y,
                firstPoint = circleSector.point(startAngle),
                secondPoint = circleSector.point(endAngle);

            return sector.pathTemplate({
                firstPoint: firstPoint,
                secondPoint: secondPoint,
                isReflexAngle: isReflexAngle,
                r: r,
                cx: cx,
                cy: cy
            });
        }
    });

    var SVGCircle = ViewElement.extend({
        init: function(center, radius, options) {
            var circle = this;
            ViewElement.fn.init.call(circle, options);

            circle.center = center;
            circle.radius = radius;

            circle.template = SVGCircle.template;
            if (!circle.template) {
                circle.template = SVGCircle.template = template(
                    "<circle #= d.renderAttr(\"id\", d.options.id) # " +
                    "cx='#= d.center[0] #' cy='#= d.center[1] #' " +
                    "r='#= d.radius #' " +
                    "#= d.renderAttr(\"stroke\", d.options.stroke) # " +
                    "#= d.renderAttr(\"stroke-width\", d.options.strokeWidth) #" +
                    "fill-opacity='#= d.options.fillOpacity #' " +
                    "stroke-opacity='#= d.options.strokeOpacity #'  " +
                    "fill='#= d.options.fill || \"none\" #'></circle>"
                );
            }
        },

        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        }
    });

    var SVGGroup = ViewElement.extend({
        init: function(options) {
            var group = this;
            ViewElement.fn.init.call(group, options);

            group.template = SVGGroup.template;
            if (!group.template) {
                group.template = SVGGroup.template =
                template("<g#= d.renderAttr(\"id\", d.options.id) #" +
                           "#= d.renderAttr(\"clip-path\", d.options.clipPath) #>" +
                         "#= d.renderContent() #</g>");
            }
        }
    });

    var SVGClipPath = ViewElement.extend({
        init: function(options) {
            var clip = this;
            ViewElement.fn.init.call(clip, options);

            clip.template = SVGClipPath.template;
            if (!clip.template) {
                clip.template = SVGClipPath.template =
                template("<clipPath#= d.renderAttr(\"id\", d.options.id) #>" +
                         "#= d.renderContent() #</clipPath>");
            }
        }
    });

    var SVGLinearGradient = ViewElement.extend({
        init: function(options) {
            var gradient = this;
            ViewElement.fn.init.call(gradient, options);

            gradient.template = SVGLinearGradient.template;
            gradient.stopTemplate = SVGLinearGradient.stopTemplate;
            if (!gradient.template) {
                gradient.template = SVGLinearGradient.template = template(
                    "<linearGradient id='#= d.options.id #' " +
                    "gradientTransform='rotate(#= d.options.rotation #)'> " +
                    "#= d.renderStops() #" +
                    "</linearGradient>"
                );

                gradient.stopTemplate = SVGLinearGradient.stopTemplate = template(
                    "<stop offset='#= Math.round(d.offset * 100) #%' " +
                    "style='stop-color:#= d.color #;stop-opacity:#= d.opacity #' />");
            }
        },

        options: {
            id: "",
            rotation: 0
        },

        renderStops: function() {
            var gradient = this,
                stops = gradient.options.stops,
                stopTemplate = gradient.stopTemplate,
                i,
                length = stops.length,
                currentStop,
                output = '';

            for (i = 0; i < length; i++) {
                currentStop = stops[i];
                output += stopTemplate(currentStop);
            }

            return output;
        }
    });

    var SVGRadialGradient = ViewElement.extend({
        init: function(options) {
            var gradient = this;

            ViewElement.fn.init.call(gradient, options);

            gradient.template = SVGRadialGradient.template;
            gradient.stopTemplate = SVGRadialGradient.stopTemplate;
            if (!gradient.template) {
                gradient.template = SVGRadialGradient.template = template(
                    "<radialGradient id='#= d.options.id #' " +
                    "cx='#= d.options.cx #' cy='#= d.options.cy #' " +
                    "fx='#= d.options.cx #' fy='#= d.options.cy #' " +
                    "r='#= d.options.r #' gradientUnits='userSpaceOnUse'>" +
                    "#= d.renderStops() #" +
                    "</radialGradient>"
                );

                gradient.stopTemplate = SVGRadialGradient.stopTemplate = template(
                    "<stop offset='#= Math.round(d.offset * 100) #%' " +
                    "style='stop-color:#= d.color #;stop-opacity:#= d.opacity #' />");
            }
        },

        options: {
            id: "",
            rotation: 0
        },

        renderStops: function() {
            var gradient = this,
                stops = gradient.options.stops,
                stopTemplate = gradient.stopTemplate,
                length = stops.length,
                currentStop,
                output = '',
                i;

            for (i = 0; i < length; i++) {
                currentStop = stops[i];
                output += stopTemplate(currentStop);
            }

            return output;
        }
    });

    // Decorators =============================================================
    function SVGOverlayDecorator(view) {
        this.view = view;
    }

    SVGOverlayDecorator.prototype = {
        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                options = element.options,
                id = options.id,
                group,
                overlay;

            if (options.overlay) {
                element.options.id = uniqueId();

                group = view.createGroup();
                overlay = element.clone();

                group.children.push(element, overlay);

                overlay.options.id = id;
                overlay.options.fill = options.overlay;

                return group;
            } else {
                return element;
            }
        }
    }

    function SVGGradientDecorator(view) {
        this.view = view;
    }

    SVGGradientDecorator.prototype = {
        decorate: function(element) {
            var decorator = this,
                options = element.options;

            options.fill = decorator.getPaint(options.fill);

            return element;
        },

        getPaint: function(paint) {
            var decorator = this,
                view = decorator.view,
                definitions = view.definitions,
                overlay,
                overlayId,
                gradient;

            if (paint && defined(paint.gradient)) {
                overlay = view.buildGradient(paint);
                if (overlay) {
                    overlayId = overlay.id;
                    gradient = definitions[overlayId];
                    if (!gradient) {
                        gradient = view.createGradient(overlay);
                        definitions[overlayId] = gradient;
                    }

                    return "url(#" + gradient.options.id + ")";
                } else {
                    return NONE;
                }
            } else {
                return paint;
            }
        }
    };

    var SVGClipAnimationDecorator = Class.extend({
        init: function(view) {
            this.view = view;
        },

        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                options = view.options,
                animation = element.options.animation,
                definitions = view.definitions,
                clipPath = definitions[GLOBAL_CLIP],
                clipRect;

            if (animation && animation.type === CLIP && options.transitions) {
                if (!clipPath) {
                    clipPath = new SVGClipPath({ id: GLOBAL_CLIP });
                    clipRect = view.createRect(
                        new Box2D(0, 0, 0, options.height), { id: uniqueId() });
                    clipPath.children.push(clipRect);
                    definitions[GLOBAL_CLIP] = clipPath;

                    view.animations.push(
                        new ExpandAnimation(clipRect, { size: options.width })
                    );
                }

                element.options.clipPath = "url(#" + GLOBAL_CLIP + ")";
            }

            return element;
        }
    });

    // Helpers ================================================================
    function alignToPixel(coord) {
        return math.round(coord) + 0.5;
    }

    function renderSVGDash(dashType, strokeWidth) {
        var result = [],
            dashType = dashType ? dashType.toLowerCase() : null,
            dashTypeArray,
            i;

        if (dashType && dashType != "solid" && strokeWidth) {
            dashTypeArray = SVG_DASH_TYPE[dashType];
            for (i = 0; i < dashTypeArray.length; i++) {
                result.push(dashTypeArray[i] * strokeWidth);
            }

            return "stroke-dasharray='" + result.join(" ") + "' ";
        }

        return "";
    }

    function renderSVG(container, svg) {
        container.innerHTML = svg;
    }

    (function() {
        var testFragment = "<svg xmlns='" + SVG_NS + "'></svg>",
            testContainer = doc.createElement("div"),
            hasParser = typeof DOMParser != UNDEFINED;

        testContainer.innerHTML = testFragment;

        if (hasParser && testContainer.firstChild.namespaceURI != SVG_NS) {
            renderSVG = function(container, svg) {
                var parser = new DOMParser(),
                    chartDoc = parser.parseFromString(svg, "text/xml"),
                    importedDoc = doc.adoptNode(chartDoc.documentElement);

                container.innerHTML = "";
                container.appendChild(importedDoc);
            };
        }
    })();

    // Exports ================================================================
    deepExtend(Chart, {
        SVGView: SVGView,
        SVGText: SVGText,
        SVGPath: SVGPath,
        SVGLine: SVGLine,
        SVGSector: SVGSector,
        SVGCircle: SVGCircle,
        SVGGroup: SVGGroup,
        SVGClipPath: SVGClipPath,
        SVGLinearGradient: SVGLinearGradient,
        SVGRadialGradient: SVGRadialGradient,
        SVGOverlayDecorator: SVGOverlayDecorator,
        SVGGradientDecorator: SVGGradientDecorator,
        SVGClipAnimationDecorator: SVGClipAnimationDecorator
    });

})(jQuery);
(function () {

    // Imports ================================================================
    var $ = jQuery,
        $t = $.easyui,
        Class = $t.Class,
        Chart = $t.chart.Chart,
        Color = Chart.Color,
        Box2D = Chart.Box2D,
        Point2D = Chart.Point2D,
        BarAnimationDecorator = Chart.BarAnimationDecorator,
        PieAnimationDecorator = Chart.PieAnimationDecorator,
        FadeAnimationDecorator = Chart.FadeAnimationDecorator,
        ExpandAnimation = Chart.ExpandAnimation,
        ViewBase = Chart.ViewBase,
        ViewElement = Chart.ViewElement,
        deepExtend = Chart.deepExtend,
        template = Chart.template,
        uniqueId = Chart.uniqueId,
        rotatePoint = Chart.rotatePoint,
        round = Chart.round,
        supportsSVG = Chart.supportsSVG,
        doc = document,
        math = Math;

    // Constants ==============================================================
    var BLACK = "#000",
        CLIP = Chart.CLIP,
        DEFAULT_WIDTH = Chart.DEFAULT_WIDTH,
        DEFAULT_HEIGHT = Chart.DEFAULT_HEIGHT,
        DEFAULT_FONT = Chart.DEFAULT_FONT,
        OBJECT = "object",
        RADIAL = "radial";

    // View ===================================================================
    var VMLView = ViewBase.extend({
        init: function(options) {
            var view = this;
            ViewBase.fn.init.call(view, options);

            view.decorators.push(
                new VMLOverlayDecorator(view),
                new VMLGradientDecorator(view),
                new BarAnimationDecorator(view),
                new PieAnimationDecorator(view),
                new VMLClipAnimationDecorator(view)
            );

            if (!isIE9CompatibilityView()) {
                // Setting opacity on VML elements is broken in
                // IE9 Compatibility View
                view.decorators.push(
                    new FadeAnimationDecorator(view)
                );
            }

            view.template = VMLView.template;
            if (!view.template) {
                view.template = VMLView.template = template(
                    "<div style='width:#= d.options.width #px; " +
                    "height:#= d.options.height #px; " +
                    "position: relative;'>" +
                    "#= d.renderContent() #</div>"
                );
            }
        },

        options: {
            width: DEFAULT_WIDTH,
            height: DEFAULT_HEIGHT
        },

        renderTo: function(container) {
            var view = this;

            if (doc.namespaces) {
                doc.namespaces.add("kvml", "urn:schemas-microsoft-com:vml", "#default#VML");
            }

            view.setupAnimations();
            container.innerHTML = view.render();
            view.playAnimations();

            return container.firstChild;
        },

        renderElement: function(element) {
            var container = doc.createElement("div"),
                element;

            container.style.display = "none";
            doc.body.appendChild(container);
            container.innerHTML = element.render();

            element = container.firstChild;
            doc.body.removeChild(container);

            return element;
        },

        createText: function(content, options) {
            return this.decorate(
                (options && options.rotation) ?
                    new VMLRotatedText(content, options) :
                    new VMLText(content, options)
            );
        },

        createRect: function(box, style) {
            return this.decorate(
                new VMLLine(box.points(), true, style)
            );
        },

        createLine: function(x1, y1, x2, y2, options) {
            return this.decorate(
                new VMLLine([new Point2D(x1, y1),
                    new Point2D(x2, y2)], false, options)
            );
        },

        createPolyline: function(points, closed, options) {
            return this.decorate(
                new VMLLine(points, closed, options)
            );
        },

        createCircle: function(center, radius, options) {
            return this.decorate(
                new VMLCircle(center, radius, options)
            );
        },

        createSector: function(sector, options) {
            return this.decorate(
                new VMLSector(sector, options)
            );
        },

        createGroup: function(options) {
            return this.decorate(
                new VMLGroup(options)
            );
        },

        createGradient: function(options) {
            return new VMLLinearGradient(options);
        }
    });

    VMLView.fromModel = function(model) {
        var view = new VMLView(model.options);
        [].push.apply(view.children, model.getViewElements(view));

        return view;
    }

    // Primitives =============================================================
    var VMLText = ViewElement.extend({
        init: function(content, options) {
            var text = this;
            ViewElement.fn.init.call(text, options);

            text.content = content;
            text.template = VMLText.template;
            if (!text.template) {
                text.template = VMLText.template = template(
                    "<kvml:textbox #= d.renderAttr(\"id\", d.options.id) # " +
                    "style='position: absolute; " +
                    "left: #= d.options.x #px; top: #= d.options.y #px; " +
                    "font: #= d.options.font #; color: #= d.options.color #; " +
                    "visibility: #= d.renderVisibility() #; white-space: nowrap;'>" +
                    "#= d.content #</kvml:textbox>"
                );
            }
        },

        options: {
            x: 0,
            y: 0,
            font: DEFAULT_FONT,
            color: BLACK,
            fillOpacity: 1
        },

        refresh: function(domElement) {
            $(domElement).css("visibility", this.renderVisibility());
        },

        clone: function() {
            var text = this;
            return new VMLText(text.content, deepExtend({}, text.options));
        },

        renderVisibility: function() {
            return this.options.fillOpacity > 0 ? "visible" : "hidden";
        }
    });

    var VMLRotatedText = ViewElement.extend({
        init: function(content, options) {
            var text = this;
            ViewElement.fn.init.call(text, options);

            text.content = content;
            text.template = VMLRotatedText.template;
            if (!text.template) {
                text.template = VMLRotatedText.template = template(
                    "<kvml:shape #= d.renderAttr(\"id\", d.options.id) # " +
                    "style='position: absolute; top: 0px; left: 0px; " +
                    "width: 1px; height: 1px;' stroked='false' coordsize='1,1'>" +
                    "#= d.renderPath() #" +
                    "<kvml:fill color='#= d.options.color #' />" +
                    "<kvml:textpath on='true' style='font: #= d.options.font #;' " +
                    "fitpath='false' string='#= d.content #' /></kvml:shape>"
                );
            }
        },

        options: {
            x: 0,
            y: 0,
            font: DEFAULT_FONT,
            color: BLACK,
            size: {
                width: 0,
                height: 0
            }
        },

        renderPath: function() {
            var text = this,
                options = text.options,
                width = options.size.width,
                height = options.size.height,
                cx = options.x + width / 2,
                cy = options.y + height / 2,
                angle = -options.rotation,
                r1 = rotatePoint(options.x, cy, cx, cy, angle),
                r2 = rotatePoint(options.x + width, cy, cx, cy, angle);

            return "<kvml:path textpathok='true' " +
                   "v='m " + round(r1.x) + "," + round(r1.y) +
                   " l " + round(r2.x) + "," + round(r2.y) +
                   "' />";
        }
    });

    var VMLStroke = ViewElement.extend({
        init: function(options) {
            var stroke = this;
            ViewElement.fn.init.call(stroke, options);

            stroke.template = VMLStroke.template;
            if (!stroke.template) {
                stroke.template = VMLStroke.template = template(
                    "<kvml:stroke on='#= !!d.options.stroke #' " +
                    "#= d.renderAttr(\"color\", d.options.stroke) #" +
                    "#= d.renderAttr(\"weight\", d.options.strokeWidth) #" +
                    "#= d.renderAttr(\"dashstyle\", d.options.dashType) #" +
                    "#= d.renderAttr(\"opacity\", d.options.strokeOpacity) # />"
                );
            }
        }
    });

    var VMLFill = ViewElement.extend({
        init: function(options) {
            var stroke = this;
            ViewElement.fn.init.call(stroke, options);

            stroke.template = VMLFill.template;
            if (!stroke.template) {
                stroke.template = VMLFill.template = template(
                    "<kvml:fill on='#= !!d.options.fill #' " +
                    "#= d.renderAttr(\"color\", d.options.fill) #" +
                    "#= d.renderAttr(\"weight\", d.options.fillWidth) #" +
                    "#= d.renderAttr(\"opacity\", d.options.fillOpacity) # />"
                );
            }
        }
    });

    var VMLPath = ViewElement.extend({
        init: function(options) {
            var path = this;
            ViewElement.fn.init.call(path, options);

            path.template = VMLPath.template;
            if (!path.template) {
                path.template = VMLPath.template = template(
                    "<kvml:shape #= d.renderAttr(\"id\", d.options.id) # " +
                    "style='position:absolute; width:1px; height:1px;' " +
                    "coordorigin='0 0' coordsize='1 1'>" +
                        "<kvml:path v='#= d.renderPoints() # e' />" +
                        "#= d.fill.render() + d.stroke.render() #" +
                    "</kvml:shape>"
                );
            }

            path.stroke = new VMLStroke(path.options);
            path.fill = new VMLFill(path.options);
        },

        options: {
            fill: "",
            fillOpacity: 1,
            strokeOpacity: 1
        },

        render: function() {
            var path = this;
            path.fill.options.fillOpacity = path.options.fillOpacity;
            path.stroke.options.strokeOpacity = path.options.strokeOpacity;

            return ViewElement.fn.render.call(path);
        },

        renderPoints: function() {
            // Overriden by inheritors
        },

        refresh: function(domElement) {
            var path = this,
                options = path.options,
                element = $(domElement),
                parentNode = element[0].parentNode;

            if (parentNode) {
                element.find("path")[0].v = this.renderPoints();
                try {
                    element.find("fill")[0].opacity = options.fillOpacity;
                    element.find("stroke")[0].opacity = options.strokeOpacity;
                } catch(e) {
                    // Random exceptions in IE 8 Compatibility View
                }

                // Force redraw in order to remove artifacts in IE < 7
                parentNode.style.cssText = parentNode.style.cssText;
            }
        }
    });

    var VMLLine = VMLPath.extend({
        init: function(points, closed, options) {
            var line = this;
            VMLPath.fn.init.call(line, options);

            line.points = points;
            line.closed = closed;
        },

        renderPoints: function() {
            var line = this,
                points = line.points,
                i,
                count = points.length,
                result = "m " + line._print(points[0]);

            if (count > 1) {
                result += " l ";

                for (i = 1; i < count; i++) {
                    result += line._print(points[i]);

                    if (i < count - 1) {
                        result += ", ";
                    }
                }
            }

            if (line.closed) {
                result += " x";
            }

            return result;
        },

        clone: function() {
            var line = this;
            return new VMLLine(
                deepExtend([], line.points), line.closed,
                deepExtend({}, line.options)
            );
        },

        _print: function(point) {
            return math.round(point.x) + "," + math.round(point.y);
        }
    });

    var VMLSector = VMLPath.extend({
        init: function(circleSector, options) {
            var sector = this;
            VMLPath.fn.init.call(sector, options);

            sector.pathTemplate = VMLSector.pathTemplate;
            if (!sector.pathTemplate) {
                sector.pathTemplate = VMLSector.pathTemplate = template(
                   "M #= d.cx # #= d.cy # " +
                   "AE #= d.cx # #= d.cy # " +
                   "#= d.r # #= d.r # " +
                   "#= d.sa # #= d.a # X E"
                );
            }

            sector.circleSector = circleSector;
        },

        renderPoints: function() {
            var sector = this,
                circleSector = sector.circleSector,
                r = math.max(round(circleSector.r), 0),
                cx = round(circleSector.c.x),
                cy = round(circleSector.c.y),
                sa = -round((circleSector.startAngle + 180) * 65535),
                a = -round(circleSector.angle * 65536);

            return sector.pathTemplate({ r: r, cx: cx, cy: cy, sa: sa, a: a });
        },

        clone: function() {
            var sector = this;
            return new VMLSector(
                deepExtend({}, sector.circleSector),
                deepExtend({}, sector.options)
            );
        }
    });

    var VMLCircle = ViewElement.extend({
        init: function(center, radius, options) {
            var circle = this;
            ViewElement.fn.init.call(circle, options);

            circle.center = center;
            circle.radius = radius;

            circle.template = VMLCircle.template;
            if (!circle.template) {
                circle.template = VMLCircle.template = template(
                    "<kvml:oval #= d.renderAttr(\"id\", d.options.id) # " +
                            "style='position:absolute; " +
                            "width:#= d.radius * 2 #px; height:#= d.radius * 2 #px; " +
                            "top:#= d.center[1] - d.radius #px; " +
                            "left:#= d.center[0] - d.radius #px;'>" +
                        "#= d.fill.render() + d.stroke.render() #" +
                    "</kvml:oval>"
                );
            }

            circle.stroke = new VMLStroke(circle.options);
            circle.fill = new VMLFill(circle.options);
        },

        options: {
            fill: ""
        }
    });

    var VMLGroup = ViewElement.extend({
        init: function(options) {
            var group = this;
            ViewElement.fn.init.call(group, options);

            group.template = VMLGroup.template;
            if (!group.template) {
                group.template = VMLGroup.template = template(
                    "<div #= d.renderAttr(\"id\", d.options.id) #" +
                    "style='position: absolute; white-space: nowrap;'>" +
                    "#= d.renderContent() #</div>"
                );
            }
        }
    });

    var VMLClipRect = ViewElement.extend({
        init: function(box, options) {
            var clipRect = this;
            ViewElement.fn.init.call(clipRect, options);

            clipRect.template = VMLClipRect.template;
            clipRect.clipTemplate = VMLClipRect.clipTemplate;
            if (!clipRect.template) {
                clipRect.template = VMLClipRect.template = template(
                    "<div #= d.renderAttr(\"id\", d.options.id) #" +
                        "style='position:absolute; " +
                        "width:#= d.box.width() #px; height:#= d.box.height() #px; " +
                        "top:#= d.box.y1 #px; " +
                        "left:#= d.box.x1 #px; " +
                        "clip:#= d._renderClip() #;' >" +
                    "#= d.renderContent() #</div>"
                );

                clipRect.clipTemplate = VMLClipRect.clipTemplate = template(
                    "rect(#= d.points[0].y #px #= d.points[1].x #px " +
                         "#= d.points[2].y #px #= d.points[0].x #px)"
                );
            }

            clipRect.box = box;

            // Points defining the clipping rectangle
            clipRect.points = box.points();
        },

        clone: function() {
            var clipRect = this;
            return new VMLClipRect(
                clipRect.box, deepExtend({}, clipRect.options)
            );
        },

        refresh: function(domElement) {
            $(domElement).css(CLIP, this._renderClip());
        },

        _renderClip: function() {
            return this.clipTemplate(this);
        }
    });

    var VMLLinearGradient = ViewElement.extend({
        init: function(options) {
            var gradient = this;
            ViewElement.fn.init.call(gradient, options);

            gradient.template = VMLLinearGradient.template;
            if (!gradient.template) {
                gradient.template = VMLLinearGradient.template = template(
                    "<kvml:fill type='gradient' angle='#= 270 - d.options.rotation #' " +
                    "colors='#= d.renderColors() #' opacity='#= d.options.opacity #' />"
                );
            }
        },

        options: {
            rotation: 0,
            opacity: 1
        },

        renderColors: function() {
            var gradient = this,
                options = gradient.options,
                stops = options.stops,
                currentStop,
                i,
                length = stops.length,
                output = [],
                round = math.round;

            for (i = 0; i < length; i++) {
                currentStop = stops[i];
                output.push(
                    round(currentStop.offset * 100) + "% " +
                    currentStop.color
                );
            }

            return output.join(",");
        }
    });

    // Decorators =============================================================
    function VMLOverlayDecorator(view) {
        this.view = view;
    }

    VMLOverlayDecorator.prototype = {
        decorate: function(element) {
            var options = element.options,
                view = this.view,
                overlay;

            if (options.overlay) {
                overlay = view.buildGradient(
                    deepExtend({}, options.overlay, {
                        // Make the gradient definition unique for this color
                        _overlayFill: options.fill
                    })
                );
            }

            if (!overlay || overlay.type === RADIAL) {
                return element;
            }

            delete options.overlay;
            options.fill = deepExtend(
                blendGradient(options.fill, overlay),
                { opacity: options.fillOpacity }
            );

            return element;
        }
    };

    function VMLGradientDecorator(view) {
        this.view = view;
    }

    VMLGradientDecorator.prototype = {
        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                options = element.options,
                fill = options.fill;

            if (fill) {
                if (fill.gradient) {
                    fill = view.buildGradient(fill);
                }

                if (typeof fill === OBJECT) {
                    element.fill = view.createGradient(fill);
                }
            }

            return element;
        }
    };

    var VMLClipAnimationDecorator = Class.extend({
        init: function(view) {
            this.view = view;
        },

        decorate: function(element) {
            var decorator = this,
                view = decorator.view,
                options = view.options,
                animation = element.options.animation,
                clipRect;

            if (animation && animation.type === CLIP && options.transitions) {
                clipRect = new VMLClipRect(
                    new Box2D(0, 0, 0, options.height),
                    { id: uniqueId() }
                );

                view.animations.push(
                    new ExpandAnimation(clipRect, { size: options.width })
                );

                clipRect.children.push(element);

                return clipRect;
            } else {
                return element;
            }
        }
    });

    // Helpers ================================================================
    function isIE9CompatibilityView() {
        return $.browser.msie && !supportsSVG() && typeof window.performance !== "undefined";
    }

    function blendColors(base, overlay, alpha) {
        var baseColor = new Color(base),
            overlayColor = new Color(overlay),
            r = blendChannel(baseColor.r, overlayColor.r, alpha),
            g = blendChannel(baseColor.g, overlayColor.g, alpha),
            b = blendChannel(baseColor.b, overlayColor.b, alpha);

        return new Color(r, g, b).toHex();
    }

    function blendChannel(a, b, alpha) {
        return math.round(alpha * b + (1 - alpha) * a);
    }

    function blendGradient(color, gradient) {
        var srcStops = gradient.stops,
            stopsLength = srcStops.length,
            result = deepExtend({}, gradient),
            i,
            stop,
            resultStop;

        result.stops = [];

        for (i = 0; i < stopsLength; i++) {
            stop = srcStops[i];
            resultStop = result.stops[i] = deepExtend({}, srcStops[i]);
            resultStop.color = blendColors(color, stop.color, stop.opacity);
            resultStop.opacity = 0;
        }

        return result;
    }

    // Exports ================================================================
    deepExtend(Chart, {
        VMLView: VMLView,
        VMLText: VMLText,
        VMLRotatedText: VMLRotatedText,
        VMLStroke: VMLStroke,
        VMLFill: VMLFill,
        VMLPath: VMLPath,
        VMLLine: VMLLine,
        VMLSector: VMLSector,
        VMLCircle: VMLCircle,
        VMLGroup: VMLGroup,
        VMLClipRect: VMLClipRect,
        VMLLinearGradient: VMLLinearGradient,
        VMLOverlayDecorator: VMLOverlayDecorator,
        VMLClipAnimationDecorator: VMLClipAnimationDecorator,
        blendColors: blendColors,
        blendGradient: blendGradient
    });

})(jQuery);
(function () {

    // Imports ================================================================
    var $t = $.easyui,
        Chart = $t.chart.Chart,
        deepExtend = Chart.deepExtend;

    // Constants ==============================================================
    var BLACK = "#000",
        WHITE = "#fff",
        SANS = "Arial,Helvetica,sans-serif",
        SANS11 = "11px " + SANS,
        SANS12 = "12px " + SANS,
        SANS16 = "16px " + SANS,
        NO_OVERLAY = {
            overlay: null
        };

    // Themes =================================================================
    var baseTheme = {
            title: {
                font: SANS16
            },
            legend: {
                labels: {
                    font: SANS12
                }
            },
            seriesDefaults: {
                labels: {
                    font: SANS11
                }
            },
            categoryAxis: {
                labels: {
                    font: SANS12
                }
            },
            valueAxis: {
                labels: {
                    font: SANS12
                }
            },
            tooltip: {
                font: SANS12
            }
        };

    var themes = { };
    themes.black = deepExtend({}, baseTheme, {
        title: {
            color: WHITE
        },
        legend: {
            labels: {
                color: WHITE
            }
        },
        seriesDefaults: {
            labels: {
                color: WHITE
            },
            markers: {
                background: "#3d3d3d"
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
                color: WHITE
            },
            majorGridLines: {
                color: "#636363"
            },
            minorGridLines: {
                color: "#464646"
            }
        }
    });

    themes["default"] = deepExtend({}, baseTheme, {
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.forest = deepExtend({}, baseTheme, {
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
            markers: {
                background: "#d3e0c2"
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
            }
        },
        tooltip: {
            background: "#D3E0C2",
            color: BLACK
        }
    });

    themes.hay = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.metro = deepExtend({}, baseTheme, {
        seriesDefaults: {
            bar: NO_OVERLAY,
            pie: NO_OVERLAY,
            column: NO_OVERLAY,
            pie: NO_OVERLAY
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.office2007 = deepExtend({}, baseTheme, {
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.office2010black = deepExtend({}, baseTheme, {
        title: {
            color: WHITE
        },
        legend: {
            labels: {
                color: WHITE
            }
        },
        seriesDefaults: {
            labels: {
                color: WHITE
            },
            markers: {
                background: "#6f6f6f"
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
                color: WHITE
            },
            majorGridLines: {
                color: "#888888"
            },
            minorGridLines: {
                color: "#7c7c7c"
            }
        },
        tooltip: {
            background: "#6F6F6F",
            color: WHITE
        }
    });

    themes.office2010blue = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.office2010silver = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.outlook = deepExtend({}, baseTheme, {
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.simple = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.sitefinity = deepExtend({}, baseTheme, {
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.sunset = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.easyui = deepExtend({}, baseTheme, {
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
            background: WHITE,
            color: BLACK
        }
    });

    themes.transparent = deepExtend({}, baseTheme, {
        seriesDefaults: {
            opacity: 0.6
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
            background: WHITE,
            color: BLACK,
            opacity: 0.7
        }
    });

    themes.vista = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.web20 = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.webblue = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    themes.windows7 = deepExtend({}, baseTheme, {
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
            }
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        },
        tooltip: {
            background: WHITE,
            color: BLACK
        }
    });

    // Exports ================================================================
    Chart.themes = themes;
    Chart.prototype.options.theme = "default";

})(jQuery);