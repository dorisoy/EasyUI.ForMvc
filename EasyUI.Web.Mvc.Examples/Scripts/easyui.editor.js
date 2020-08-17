(function ($) {

    var $t = $.easyui;

    $t.scripts.push("easyui.editor.js");

    function makeMap(items) {
        var obj = {};

        for (var i = 0; i < items.length; i++)
            obj[items[i]] = true;

        return obj;
    }

    var empty = makeMap('area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed'.split(',')),
        blockElements = 'div,p,h1,h2,h3,h4,h5,h6,address,applet,blockquote,button,center,dd,dir,dl,dt,fieldset,form,frameset,hr,iframe,isindex,li,map,menu,noframes,noscript,object,ol,pre,script,table,tbody,td,tfoot,th,thead,tr,ul'.split(','),
        block = makeMap(blockElements),
        inlineElements = 'span,em,a,abbr,acronym,applet,b,basefont,bdo,big,br,button,cite,code,del,dfn,font,i,iframe,img,input,ins,kbd,label,map,object,q,s,samp,script,select,small,strike,strong,sub,sup,textarea,tt,u,var'.split(','),
        inline = makeMap(inlineElements),
        fillAttrs = makeMap('checked,compact,declare,defer,disabled,ismap,multiple,nohref,noresize,noshade,nowrap,readonly,selected'.split(','));


    var normalize = function (node) {
        if (node.nodeType == 1)
            node.normalize();
    };

    if ($.browser.msie && parseInt($.browser.version) >= 8) {
        normalize = function (parent) {
            if (parent.nodeType == 1 && parent.firstChild) {
                var prev = parent.firstChild,
                    node = prev;

                while (node = node.nextSibling) {
                    if (node.nodeType == 3 && prev.nodeType == 3) {
                        node.nodeValue = prev.nodeValue + node.nodeValue;
                        dom.remove(prev);
                    }
                    prev = node;
                }
            }
        }
    }

    function findNodeIndex(node) {
        var i = 0;
        while (node = node.previousSibling) i++;
        return i;
    }

    function isDataNode(node) {
        return node && node.nodeValue !== null && node.data !== null;
    }

    function isAncestorOf(parent, node) {
        try {
            return !isDataNode(parent) && ($.contains(parent, isDataNode(node) ? node.parentNode : node) || node.parentNode == parent);
        } catch (e) {
            return false;
        }
    }

    function isAncestorOrSelf(root, node) {
        return isAncestorOf(root, node) || root == node;
    }

    function findClosestAncestor(root, node) {
        if (isAncestorOf(root, node))
            while (node && node.parentNode != root)
                node = node.parentNode;

        return node;
    }

    function getNodeLength(node) {
        return isDataNode(node) ? node.length : node.childNodes.length;
    }

    function splitDataNode(node, offset) {
        var newNode = node.cloneNode(false);
        node.deleteData(offset, node.length);
        newNode.deleteData(0, offset);
        dom.insertAfter(newNode, node);
    }

    function attrEquals(node, attributes) {
        for (var key in attributes) {
            var value = node[key];

            if (key == 'float')
                value = node[$.support.cssFloat ? "cssFloat" : "styleFloat"];

            if (typeof value == 'object') {
                if (!attrEquals(value, attributes[key]))
                    return false;
            } else if (value != attributes[key])
                return false;
        }

        return true;
    }

    var whitespace = /^\s+$/;
    var rgb = /rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/i;
    var cssAttributes = ('color,padding-left,padding-right,padding-top,padding-bottom,\
background-color,background-attachment,background-image,background-position,background-repeat,\
border-top-style,border-top-width,border-top-color,\
border-bottom-style,border-bottom-width,border-bottom-color,\
border-left-style,border-left-width,border-left-color,\
border-right-style,border-right-width,border-right-color,\
font-family,font-size,font-style,font-variant,font-weight,line-height'
    ).split(',');

    var dom = {
        blockParentOrBody: function (node) {
            return dom.parentOfType(node, blockElements) || node.ownerDocument.body;
        },
        normalize: normalize,
        toHex: function (color) {
            var matches = rgb.exec(color);

            if (!matches) return color;

            return '#' + $.map(matches.slice(1), function (x) {
                return x = parseInt(x).toString(16), x.length > 1 ? x : '0' + x;
            }).join('');
        },

        encode: function (value) {
            return value.replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/\u00a0/g, '&nbsp;');
        },

        name: function (node) {
            return node.nodeName.toLowerCase();
        },

        significantChildNodes: function (node) {
            return $.grep(node.childNodes, function (child) {
                return child.nodeType != 3 || !dom.isWhitespace(child);
            });
        },

        lastTextNode: function (node) {
            if (node.nodeType == 3)
                return node;

            var result = null;

            for (var child = node.lastChild; child; child = child.previousSibling)
                if (result = dom.lastTextNode(child))
                    return result;

            return result;
        },

        is: function (node, nodeName) {
            return dom.name(node) == nodeName;
        },

        isMarker: function (node) {
            return node.className == 't-marker';
        },

        isWhitespace: function (node) {
            return whitespace.test(node.nodeValue);
        },

        isBlock: function (node) {
            return block[dom.name(node)];
        },

        isEmpty: function (node) {
            return empty[dom.name(node)];
        },

        isInline: function (node) {
            return inline[dom.name(node)];
        },

        scrollTo: function (node) {
            node.ownerDocument.body.scrollTop = $(isDataNode(node) ? node.parentNode : node).offset().top;
        },

        insertAt: function (parent, newElement, position) {
            parent.insertBefore(newElement, parent.childNodes[position] || null);
        },

        insertBefore: function (newElement, referenceElement) {
            if (referenceElement.parentNode)
                return referenceElement.parentNode.insertBefore(newElement, referenceElement);
            else
                return referenceElement;
        },

        insertAfter: function (newElement, referenceElement) {
            return referenceElement.parentNode.insertBefore(newElement, referenceElement.nextSibling);
        },

        remove: function (node) {
            node.parentNode.removeChild(node);
        },

        trim: function (parent) {
            for (var i = parent.childNodes.length - 1; i >= 0; i--) {
                var node = parent.childNodes[i];
                if (isDataNode(node)) {
                    if (node.nodeValue.replace(/\ufeff/g, '').length == 0)
                        dom.remove(node);
                    if (dom.isWhitespace(node))
                        dom.insertBefore(node, parent);
                } else if (node.className != 't-marker') {
                    dom.trim(node);
                    if (node.childNodes.length == 0 && !dom.isEmpty(node))
                        dom.remove(node);
                }
            }

            return parent;
        },

        parentOfType: function (node, tags) {
            do {
                node = node.parentNode;
            } while (node && !(dom.ofType(node, tags)));

            return node;
        },

        ofType: function (node, tags) {
            return $.inArray(dom.name(node), tags) >= 0;
        },

        changeTag: function (referenceElement, tagName) {
            var newElement = dom.create(referenceElement.ownerDocument, tagName);
            var attributes = referenceElement.attributes;

            for (var i = 0; i < attributes.length; i++) {
                var attribute = attributes[i];
                if (attribute.specified) {
                    // IE < 8 cannot set class or style via setAttribute
                    var name = attribute.nodeName;
                    var value = attribute.nodeValue;
                    if (name == 'class')
                        newElement.className = value;
                    else if (name == 'style')
                        newElement.style.cssText = referenceElement.style.cssText;
                    else
                        newElement.setAttribute(name, value);
                }
            }

            while (referenceElement.firstChild)
                newElement.appendChild(referenceElement.firstChild);

            dom.insertBefore(newElement, referenceElement);
            dom.remove(referenceElement);
            return newElement;
        },

        wrap: function (node, wrapper) {
            dom.insertBefore(wrapper, node);
            wrapper.appendChild(node);
            return wrapper;
        },

        unwrap: function (node) {
            var parent = node.parentNode;
            while (node.firstChild)
                parent.insertBefore(node.firstChild, node);

            parent.removeChild(node);
        },

        create: function (document, tagName, attributes) {
            return dom.attr(document.createElement(tagName), attributes);
        },

        attr: function (element, attributes) {
            attributes = $.extend({}, attributes);

            if (attributes && 'style' in attributes) {
                dom.style(element, attributes.style);
                delete attributes.style;
            }
            return $.extend(element, attributes);
        },

        style: function (node, value) {
            $(node).css(value || {});
        },

        unstyle: function (node, value) {
            for (var key in value) {
                if (key == 'float')
                    key = $.support.cssFloat ? "cssFloat" : "styleFloat";

                node.style[key] = '';
            }

            if (node.style.cssText == '')
                node.removeAttribute('style');
        },

        inlineStyle: function (document, name, attributes) {
            var span = dom.create(document, name, attributes);

            document.body.appendChild(span);

            var $span = $(span);

            var style = $.map(cssAttributes, function (value) {
                if ($.browser.msie && value == 'line-height' && $span.css(value) == "1px")
                    return 'line-height:1.5';
                else
                    return value + ':' + $span.css(value);
            }).join(';');

            $span.remove();

            return style;
        },

        commonAncestor: function () {
            var count = arguments.length;

            if (!count)
                return null;

            if (count == 1)
                return arguments[0];

            var paths = [];
            var minPathLength = Infinity;

            for (var i = 0; i < count; i++) {
                var ancestors = [];
                var node = arguments[i];
                while (node) {
                    ancestors.push(node);
                    node = node.parentNode;
                }
                paths.push(ancestors.reverse());
                minPathLength = Math.min(minPathLength, ancestors.length);
            }

            if (count == 1)
                return paths[0][0];

            var output = null;
            for (i = 0; i < minPathLength; i++) {
                var first = paths[0][i];

                for (var j = 1; j < count; j++)
                    if (first != paths[j][i])
                        return output;

                output = first;
            }
            return output;
        }
    }
var fontSizeMappings = 'xx-small,x-small,small,medium,large,x-large,xx-large'.split(','),
    quoteRe = /"/g,
    brRe = /<br[^>]*>/i,
    emptyPRe = /<p><\/p>/i;

function domToXhtml(root) {
    var result = [];
    var tagMap = {
        'easyui:script': { start: function (node) { result.push('<script'); attr(node); result.push('>'); }, end: function () { result.push('</script>') } },
        b: { start: function () { result.push('<strong>') }, end: function () { result.push('</strong>') } },
        i: { start: function () { result.push('<em>') }, end: function () { result.push('</em>') } },
        u: { start: function () { result.push('<span style="text-decoration:underline;">') }, end: function () { result.push('</span>') } },
        font: {
            start: function (node) {
                result.push('<span style="');

                var color = node.getAttribute('color');
                var size = fontSizeMappings[node.getAttribute('size')];
                var face = node.getAttribute('face');

                if (color) {
                    result.push('color:')
                    result.push(dom.toHex(color));
                    result.push(';');
                }

                if (face) {
                    result.push('font-face:');
                    result.push(face);
                    result.push(';');
                }

                if (size) {
                    result.push('font-size:');
                    result.push(size);
                    result.push(';');
                }

                result.push('">');
            },
            end: function (node) {
                result.push('</span>');
            }
        }
    };

    function attr(node) {
        var specifiedAttributes = [],
            attributes = node.attributes,
            trim = $.trim;

        if (dom.is(node, 'img')) {
            var width = node.style.width,
                height = node.style.height,
                $node = $(node);

            if (width) {
                $node.attr('width', parseInt(width));
                dom.unstyle(node, { width: undefined });
            }

            if (height) {
                $node.attr('height', parseInt(height));
                dom.unstyle(node, { height: undefined });
            }
        }

        for (var i = 0, l = attributes.length; i < l; i++) {
            var attribute = attributes[i];
            var name = attribute.nodeName;
            // In IE < 8 the 'value' attribute is not returned as 'specified'. The same goes for type="text"
            if (attribute.specified || (name == 'value' && node.value != '') || (name == 'type' && attribute.nodeValue == 'text'))
                if (name.indexOf('_moz') < 0 && name != 'complete')
                    specifiedAttributes.push(attribute);
        }

        if (!specifiedAttributes.length)
            return;

        specifiedAttributes.sort(function (a, b) {
            return a.nodeName > b.nodeName ? 1 : a.nodeName < b.nodeName ? -1 : 0;
        });

        for (var i = 0, l = specifiedAttributes.length; i < l; i++) {
            var attribute = specifiedAttributes[i];
            var attributeName = attribute.nodeName;
            var attributeValue = attribute.nodeValue;

            result.push(' ');
            result.push(attributeName);
            result.push('="');
            if (attributeName == 'style') {
                // In IE < 8 the style attribute does not return proper nodeValue
                var css = trim(attributeValue || node.style.cssText).split(';');

                for (var cssIndex = 0, len = css.length; cssIndex < len; cssIndex++) {
                    var pair = css[cssIndex];
                    if (pair.length) {
                        var propertyAndValue = pair.split(':');
                        var property = trim(propertyAndValue[0].toLowerCase()),
                            value = trim(propertyAndValue[1]);

                        if (property == "font-size-adjust" || property == "font-stretch") {
                            continue;
                        }

                        if (property.indexOf('color') >= 0)
                            value = dom.toHex(value);
                        
                        if (property.indexOf('font') >= 0) {
                            value = value.replace(quoteRe, "'");
                        }

                        result.push(property);
                        result.push(':');
                        result.push(value);
                        result.push(';');
                    }
                };
            } else if (attributeName == 'src' || attributeName == 'href') {
                result.push(node.getAttribute(attributeName, 2));
            } else {
                result.push(fillAttrs[attributeName] ? attributeName : attributeValue);
            }

            result.push('"');
        }
    }

    function children(node, skip) {
        for (var childNode = node.firstChild; childNode; childNode = childNode.nextSibling)
            child(childNode, skip);
    }

    function child(node, skip) {
        var nodeType = node.nodeType;
        if (nodeType == 1) {
            if (node.attributes['_moz_dirty'] && dom.is(node, 'br'))
                return;

            var tagName = dom.name(node);
            var mapper = tagMap[tagName];

            if (mapper) {
                mapper.start(node);
                children(node);
                mapper.end(node);
                return;
            }

            result.push('<');
            result.push(tagName);

            attr(node);

            if (empty[tagName]) {
                result.push(' />');
            } else {
                result.push('>');
                children(node, skip || dom.is(node, 'pre'));
                result.push('</');
                result.push(tagName);
                result.push('>');
            }
        } else if (nodeType == 3) {
            var value = node.nodeValue;
                
            if (!skip && $.support.leadingWhitespace) {
                var parent = node.parentNode;
                var previous = node.previousSibling;

                if (!previous) {
                     previous = (dom.isInline(parent) ? parent : node).previousSibling;
                }

                if (!previous || previous.innerHTML == '' || dom.isBlock(previous))
                    value = value.replace(/^[\r\n\v\f\t ]+/, '');
                    
                value = value.replace(/ +/, ' ');
            }
                
            result.push(dom.encode(value));
            
        } else if (nodeType == 4) {
            result.push('<![CDATA[');
            result.push(node.data);
            result.push(']]>');
        } else if (nodeType == 8) {
            if (node.data.indexOf('[CDATA[') < 0) {
                result.push('<!--');
                result.push(node.data);
                result.push('-->');
            } else {
                result.push('<!');
                result.push(node.data);
                result.push('>');
            }
        }
    }

    children(root);

    result = result.join('');

    // if serialized dom contains only whitespace elements, consider it empty (required field validation)
    if (result.replace(brRe, "").replace(emptyPRe, "") == "") {
        return "";
    }

    return result;
}
var START_TO_START = 0,
    START_TO_END = 1,
    END_TO_END = 2,
    END_TO_START = 3;


function documentFromRange(range) {
    var startContainer = range.startContainer;
    return startContainer.nodeType == 9 ? startContainer : startContainer.ownerDocument;
}

function selectionFromWindow(window) {
    if ($.browser.msie && $.browser.version < 9) {
        return new W3CSelection(window.document);
    }
    
    return window.getSelection(); 
}

function selectionFromRange(range) {
    var document = documentFromRange(range);
    return selectionFromDocument(document);
}

function selectionFromDocument(document) {
    return selectionFromWindow(windowFromDocument(document));
}

function windowFromDocument(document) {
    return document.defaultView || document.parentWindow;
}

function split(range, node, trim) {
    function partition(start) {
        var partitionRange = range.cloneRange();
        partitionRange.collapse(start);
        partitionRange[start ? 'setStartBefore' : 'setEndAfter'](node);
        var contents = partitionRange.extractContents();
        if (trim)
            contents = dom.trim(contents);
        dom[start ? 'insertBefore' : 'insertAfter'](contents, node);
    }
    partition(true);
    partition(false);
}

function selectRange(range) {
    var image = RangeUtils.image(range);
    if (image) {
        range.setStartAfter(image);
        range.setEndAfter(image);
    }
    var selection = selectionFromRange(range);
    selection.removeAllRanges();
    selection.addRange(range);
}

function W3CRange(doc) {
    $.extend(this, {
        ownerDocument: doc, /* not part of the spec; used when cloning ranges, traversing the dom and creating fragments */
        startContainer: doc,
        endContainer: doc,
        commonAncestorContainer: doc,
        startOffset: 0,
        endOffset: 0,
        collapsed: true
    });
};

W3CRange.prototype = {
    // Positioning Methods

    setStart: function (node, offset) {
        this.startContainer = node;
        this.startOffset = offset;
        updateRangeProperties(this);
        fixIvalidRange(this, true);
    },

    setEnd: function (node, offset) {
        this.endContainer = node;
        this.endOffset = offset;
        updateRangeProperties(this);
        fixIvalidRange(this, false);
    },

    setStartBefore: function (node) {
        this.setStart(node.parentNode, findNodeIndex(node));
    },

    setStartAfter: function (node) {
        this.setStart(node.parentNode, findNodeIndex(node) + 1);
    },

    setEndBefore: function (node) {
        this.setEnd(node.parentNode, findNodeIndex(node));
    },

    setEndAfter: function (node) {
        this.setEnd(node.parentNode, findNodeIndex(node) + 1);
    },

    selectNode: function (node) {
        this.setStartBefore(node);
        this.setEndAfter(node);
    },

    selectNodeContents: function (node) {
        this.setStart(node, 0);
        this.setEnd(node, node[node.nodeType === 1 ? 'childNodes' : 'nodeValue'].length);
    },

    collapse: function (toStart) {
        if (toStart)
            this.setEnd(this.startContainer, this.startOffset);
        else
            this.setStart(this.endContainer, this.endOffset);
    },

    // Editing Methods

    deleteContents: function () {
        var range = this.cloneRange();

        if (this.startContainer != this.commonAncestorContainer)
            this.setStartAfter(findClosestAncestor(this.commonAncestorContainer, this.startContainer));

        this.collapse(true);

        (function deleteSubtree(iterator) {
            while (iterator.next())
                iterator.hasPartialSubtree() ? deleteSubtree(iterator.getSubtreeIterator())
                                            : iterator.remove();
        })(new RangeIterator(range));
    },
    
    cloneContents: function () {
        // clone subtree
        var document = documentFromRange(this);
        return (function cloneSubtree(iterator) {
                for (var node, frag = document.createDocumentFragment(); node = iterator.next(); ) {
                        node = node.cloneNode(!iterator.hasPartialSubtree());
                        if (iterator.hasPartialSubtree())
                                node.appendChild(cloneSubtree(iterator.getSubtreeIterator()));
                        frag.appendChild(node);
                }
                return frag;
        })(new RangeIterator(this));
    },

    extractContents: function () {
        var range = this.cloneRange();

        if (this.startContainer != this.commonAncestorContainer)
            this.setStartAfter(findClosestAncestor(this.commonAncestorContainer, this.startContainer));

        this.collapse(true);

        var self = this;

        var document = documentFromRange(this);

        return (function extractSubtree(iterator) {
            for (var node, frag = document.createDocumentFragment(); node = iterator.next(); ) {
                iterator.hasPartialSubtree() ? node = node.cloneNode(false) : iterator.remove(self.originalRange);

                if (iterator.hasPartialSubtree())
                    node.appendChild(extractSubtree(iterator.getSubtreeIterator()));

                frag.appendChild(node);
            }

            return frag;
        })(new RangeIterator(range));
    },

    insertNode: function (node) {
        if (isDataNode(this.startContainer)) {
            if (this.startOffset != this.startContainer.nodeValue.length)
                splitDataNode(this.startContainer, this.startOffset);

            dom.insertAfter(node, this.startContainer);
        } else {
            dom.insertAt(this.startContainer, node, this.startOffset);
        }

        this.setStart(this.startContainer, this.startOffset);
    },

    cloneRange: function () {
        // fast copy
        return $.extend(new W3CRange(this.ownerDocument), {
            startContainer: this.startContainer,
            endContainer: this.endContainer,
            commonAncestorContainer: this.commonAncestorContainer,
            startOffset: this.startOffset,
            endOffset: this.endOffset,
            collapsed: this.collapsed,

            originalRange: this /* not part of the spec; used to update the original range when calling extractContents() on clones */
        });
    },

    // used for debug purposes
    toString: function () {
        var startNodeName = this.startContainer.nodeName,
            endNodeName = this.endContainer.nodeName;

        return [startNodeName == "#text" ? this.startContainer.nodeValue : startNodeName, '(', this.startOffset, ') : ',
                endNodeName == "#text" ? this.endContainer.nodeValue : endNodeName, '(', this.endOffset, ')'].join('');
    }
}
/* can be used in Range.compareBoundaryPoints if we need it one day */
function compareBoundaries(start, end, startOffset, endOffset) {
    if (start == end)
        return endOffset - startOffset;

    // end is child of start
    var container = end;
    while (container && container.parentNode != start)
        container = container.parentNode;

    if (container)
        return findNodeIndex(container) - startOffset;

    // start is child of end
    container = start;
    while (container && container.parentNode != end)
        container = container.parentNode;

    if (container)
        return endOffset - findNodeIndex(container) - 1;

    // deep traversal
    var root = dom.commonAncestor(start, end);
    var startAncestor = start;

    while (startAncestor && startAncestor.parentNode != root)
        startAncestor = startAncestor.parentNode;

    if (!startAncestor)
        startAncestor = root;

    var endAncestor = end;
    while (endAncestor && endAncestor.parentNode != root)
        endAncestor = endAncestor.parentNode;

    if (!endAncestor)
        endAncestor = root;

    if (startAncestor == endAncestor)
        return 0;

    return findNodeIndex(endAncestor) - findNodeIndex(startAncestor);
}

function fixIvalidRange(range, toStart) {
    function isInvalidRange(range) {
        try {
            return compareBoundaries(range.startContainer, range.endContainer, range.startOffset, range.endOffset) < 0;
        } catch (ex) {
            // range was initially invalid (e.g. when cloned from invalid range) - it must be fixed
            return true;
        }
    }

    if (isInvalidRange(range)) {
        if (toStart) {
            range.commonAncestorContainer = range.endContainer = range.startContainer;
            range.endOffset = range.startOffset;
        } else {
            range.commonAncestorContainer = range.startContainer = range.endContainer;
            range.startOffset = range.endOffset;
        }

        range.collapsed = true;
    }
}

function updateRangeProperties(range) {
    range.collapsed = range.startContainer == range.endContainer && range.startOffset == range.endOffset;

    var node = range.startContainer;
    while (node && node != range.endContainer && !isAncestorOf(node, range.endContainer))
        node = node.parentNode;

    range.commonAncestorContainer = node;
}

function createRange(document) {
    if ($.browser.msie && $.browser.version < 9) {
        return new W3CRange(document);
    }
    
    return document.createRange();
}


function RangeIterator(range) {
    $.extend(this, {
        range: range,
        _current: null,
        _next: null,
        _end: null
    });

    if (range.collapsed)
        return;

    var root = range.commonAncestorContainer;

    this._next = range.startContainer == root && !isDataNode(range.startContainer) ?
    range.startContainer.childNodes[range.startOffset] :
    findClosestAncestor(root, range.startContainer);

    this._end = range.endContainer == root && !isDataNode(range.endContainer) ?
    range.endContainer.childNodes[range.endOffset] :
    findClosestAncestor(root, range.endContainer).nextSibling;
}

RangeIterator.prototype = {
    hasNext: function () {
        return !!this._next;
    },

    next: function () {
        var current = this._current = this._next;
        this._next = this._current && this._current.nextSibling != this._end ?
        this._current.nextSibling : null;

        if (isDataNode(this._current)) {
            if (this.range.endContainer == this._current)
                (current = current.cloneNode(true)).deleteData(this.range.endOffset, current.length - this.range.endOffset);

            if (this.range.startContainer == this._current)
                (current = current.cloneNode(true)).deleteData(0, this.range.startOffset);
        }

        return current;
    },

    traverse: function (callback) {
        function next() {
            this._current = this._next;
            this._next = this._current && this._current.nextSibling != this._end ? this._current.nextSibling : null;
            return this._current;
        }

        var current;

        while (current = next.call(this)) {
            if (this.hasPartialSubtree())
                this.getSubtreeIterator().traverse(callback);
            else
                callback(current)
        }

        return current;
    },

    remove: function (originalRange) {
        var inStartContainer = this.range.startContainer == this._current;
        var inEndContainer = this.range.endContainer == this._current;

        if (isDataNode(this._current) && (inStartContainer || inEndContainer)) {
            var start = inStartContainer ? this.range.startOffset : 0;
            var end = inEndContainer ? this.range.endOffset : this._current.length;
            var delta = end - start;

            if (originalRange && (inStartContainer || inEndContainer)) {
                if (this._current == originalRange.startContainer && start <= originalRange.startOffset)
                    originalRange.startOffset -= delta;

                if (this._current == originalRange.endContainer && end <= originalRange.endOffset)
                    originalRange.endOffset -= delta;
            }

            this._current.deleteData(start, delta);
        } else {
            var parent = this._current.parentNode;

            if (originalRange && (this.range.startContainer == parent || this.range.endContainer == parent)) {
                var nodeIndex = findNodeIndex(this._current);

                if (parent == originalRange.startContainer && nodeIndex <= originalRange.startOffset)
                    originalRange.startOffset -= 1;

                if (parent == originalRange.endContainer && nodeIndex < originalRange.endOffset)
                    originalRange.endOffset -= 1;
            }

            dom.remove(this._current);
        }
    },

    hasPartialSubtree: function () {
        return !isDataNode(this._current) &&
        (isAncestorOrSelf(this._current, this.range.startContainer) ||
            isAncestorOrSelf(this._current, this.range.endContainer));
    },

    getSubtreeIterator: function () {
        var subRange = this.range.cloneRange();
        subRange.selectNodeContents(this._current);

        if (isAncestorOrSelf(this._current, this.range.startContainer))
            subRange.setStart(this.range.startContainer, this.range.startOffset);
        if (isAncestorOrSelf(this._current, this.range.endContainer))
            subRange.setEnd(this.range.endContainer, this.range.endOffset);

        return new RangeIterator(subRange);
    }
};

function W3CSelection(doc) {
    this.ownerDocument = doc;
    this.rangeCount = 1;
};

W3CSelection.prototype = {
    addRange: function (range) {
        var textRange = this.ownerDocument.body.createTextRange();

        // end container should be adopted first in order to prevent selection with negative length
        adoptContainer(textRange, range, false);
        adoptContainer(textRange, range, true);

        textRange.select();
    },

    removeAllRanges: function () {
        this.ownerDocument.selection.empty();
    },

    getRangeAt: function () {
        var textRange, range = new W3CRange(this.ownerDocument), selection = this.ownerDocument.selection, element;
        
        try {
            textRange = selection.createRange();
            element = textRange.item ? textRange.item(0) : textRange.parentElement();
			if (element.ownerDocument != this.ownerDocument) {
				return range;
            }
        } catch (ex) {
            return range;
        }

        if (selection.type == 'Control') {
            range.selectNode(textRange.item(0));
        } else {
            adoptEndPoint(textRange, range, true);
            adoptEndPoint(textRange, range, false);

            if (range.startContainer.nodeType == 9)
                range.setStart(range.endContainer, range.startOffset);
                
            if (range.endContainer.nodeType == 9)
                range.setEnd(range.startContainer, range.endOffset);

            if (textRange.compareEndPoints('StartToEnd', textRange) == 0)
                range.collapse(false);
                
            var startContainer = range.startContainer,
                endContainer = range.endContainer,
                body = this.ownerDocument.body;
                
            if (!range.collapsed && range.startOffset == 0 && range.endOffset == getNodeLength(range.endContainer) // check for full body selection
            && !(startContainer == endContainer && isDataNode(startContainer) && startContainer.parentNode == body)) { // but not when single textnode is selected
                var movedStart = false,
                    movedEnd = false;

                while (findNodeIndex(startContainer) == 0 && startContainer == startContainer.parentNode.firstChild && startContainer != body) {
                    startContainer = startContainer.parentNode;
                    movedStart = true;
                }

                while (findNodeIndex(endContainer) == getNodeLength(endContainer.parentNode) - 1 && endContainer == endContainer.parentNode.lastChild && endContainer != body) {
                    endContainer = endContainer.parentNode;
                    movedEnd = true;
                }

                if (startContainer == body && endContainer == body && movedStart && movedEnd) {
                    range.setStart(startContainer, 0);
                    range.setEnd(endContainer, getNodeLength(body));
                }
            }
        }
        return range;
    }
}

function adoptContainer(textRange, range, start) {
    // find anchor node and offset
    var container = range[start ? 'startContainer' : 'endContainer'];
    var offset = range[start ? 'startOffset' : 'endOffset'], textOffset = 0;
    var anchorNode = isDataNode(container) ? container : container.childNodes[offset] || null;
    var anchorParent = isDataNode(container) ? container.parentNode : container;
    // visible data nodes need a text offset
    if (container.nodeType == 3 || container.nodeType == 4)
        textOffset = offset;

    // create a cursor element node to position range (since we can't select text nodes)
    var cursorNode = anchorParent.insertBefore(dom.create(range.ownerDocument, 'a'), anchorNode);

    var cursor = range.ownerDocument.body.createTextRange();
    cursor.moveToElementText(cursorNode);
    dom.remove(cursorNode);
    cursor[start ? 'moveStart' : 'moveEnd']('character', textOffset);
    cursor.collapse(false);
    textRange.setEndPoint(start ? 'StartToStart' : 'EndToStart', cursor);
}

function adoptEndPoint(textRange, range, start) {
    var cursorNode = dom.create(range.ownerDocument, 'a'), cursor = textRange.duplicate();
    cursor.collapse(start);
    var parent = cursor.parentElement();
    do {
        parent.insertBefore(cursorNode, cursorNode.previousSibling);
        cursor.moveToElementText(cursorNode);
    } while (cursor.compareEndPoints(start ? 'StartToStart' : 'StartToEnd', textRange) > 0 && cursorNode.previousSibling);

    cursor.setEndPoint(start ? 'EndToStart' : 'EndToEnd', textRange);

    var target = cursorNode.nextSibling;

    if (!target) {
        // at end of text node
        target = cursorNode.previousSibling;

        if (target && isDataNode(target)) { // in case of collapsed range in empty tag
            range.setEnd(target, target.nodeValue.length);
            dom.remove(cursorNode);
        } else {
            range.selectNodeContents(parent);
            dom.remove(cursorNode);
            range.endOffset -= 1; // cursorNode was in parent
        }

        return;
    }

    dom.remove(cursorNode);

    if (isDataNode(target))
        range[start ? 'setStart' : 'setEnd'](target, cursor.text.length);
    else
        range[start ? 'setStartBefore' : 'setEndBefore'](target);
}

 function RangeEnumerator(range) {
    this.enumerate = function () {
        var nodes = [];

        function visit(node) {
            if (dom.is(node, 'img') || (node.nodeType == 3 && !dom.isWhitespace(node))) {
                nodes.push(node);
            } else {
                node = node.firstChild;
                while (node) {
                    visit(node);
                    node = node.nextSibling;
                }
            }
        }

        new RangeIterator(range).traverse(visit);

        return nodes;
    }
}

function textNodes(range) {
    return new RangeEnumerator(range).enumerate();
}

function blockParents(nodes) {
    var blocks = [];

    for (var i = 0, len = nodes.length; i < len; i++) {
        var block = dom.parentOfType(nodes[i], blockElements);
        if (block && $.inArray(block, blocks) < 0)
            blocks.push(block);
    }

    return blocks;
}

function getMarkers(range) {
    var markers = [];

    new RangeIterator(range).traverse(function (node) {
        if (node.className == 't-marker')
            markers.push(node);
    });

    return markers;
}

function RestorePoint(range) {
    var rootNode = documentFromRange(range);

    this.body = rootNode.body;

    this.html = this.body.innerHTML;
        
    function index(node) {
        var result = 0, lastType = node.nodeType;

        while (node = node.previousSibling) {
            var nodeType = node.nodeType;
                
            if (nodeType != 3 || lastType != nodeType)
                result ++;
                
            lastType = nodeType;
        }
            
        return result;
    }

    function offset(node, value) {
        if (node.nodeType == 3) {
            while ((node = node.previousSibling) && node.nodeType == 3)
                value += node.nodeValue.length;
        }
        return value;
    }

    function nodeToPath(node) {
        var path = [];
            
        while (node != rootNode) {
            path.push(index(node));
            node = node.parentNode;
        }

        return path;
    }

    function toRangePoint(range, start, path, denormalizedOffset) {
        var node = rootNode, length = path.length, offset = denormalizedOffset;

        while (length--)
            node = node.childNodes[path[length]];

        while (node.nodeType == 3 && node.nodeValue.length < offset) {
            offset -= node.nodeValue.length;
            node = node.nextSibling;
        }

        range[start ? 'setStart' : 'setEnd'](node, offset);
    }

    this.startContainer = nodeToPath(range.startContainer);
    this.endContainer = nodeToPath(range.endContainer);
    this.startOffset = offset(range.startContainer, range.startOffset);
    this.endOffset = offset(range.endContainer, range.endOffset);

    this.toRange = function () {
        var result = range.cloneRange();

        toRangePoint(result, true, this.startContainer, this.startOffset);
        toRangePoint(result, false, this.endContainer, this.endOffset);

        return result;
    }
}

function Marker() {
    var caret;

    this.addCaret = function (range) {
        caret = dom.create(documentFromRange(range), 'span', { className: 't-marker' });
        range.insertNode(caret);
        range.selectNode(caret);
        return caret;
    }

    this.removeCaret = function (range) {
        var previous = caret.previousSibling;
        var startOffset = 0;
            
        if (previous)
            startOffset = isDataNode(previous) ? previous.nodeValue.length : findNodeIndex(previous);

        var container = caret.parentNode;
        var containerIndex = previous ? findNodeIndex(previous) : 0;

        dom.remove(caret);
        normalize(container);

        var node = container.childNodes[containerIndex];
            
        if (isDataNode(node))
            range.setStart(node, startOffset);
        else if (node) {
            var textNode = dom.lastTextNode(node);
            if (textNode)
                range.setStart(textNode, textNode.nodeValue.length);
            else
                range[previous ? 'setStartAfter' : 'setStartBefore'](node);
        } else {
            if (!$.browser.msie && container.innerHTML == '')
                container.innerHTML = '<br _moz_dirty="" />';
                
            range.selectNodeContents(container);
        }
        range.collapse(true);
    }

    this.add = function (range, expand) {
        if (expand && range.collapsed) {
            this.addCaret(range);
            range = RangeUtils.expand(range);
        }

        var rangeBoundary = range.cloneRange();

        rangeBoundary.collapse(false);
        this.end = dom.create(documentFromRange(range), 'span', { className: 't-marker' });
        rangeBoundary.insertNode(this.end);

        rangeBoundary = range.cloneRange();
        rangeBoundary.collapse(true);
        this.start = this.end.cloneNode(true);
        rangeBoundary.insertNode(this.start);

        range.setStartBefore(this.start);
        range.setEndAfter(this.end);

        normalize(range.commonAncestorContainer);

        return range;
    }

    this.remove = function (range) {
        var start = this.start, end = this.end;

        normalize(range.commonAncestorContainer);

        while (!start.nextSibling && start.parentNode) start = start.parentNode;
        while (!end.previousSibling && end.parentNode) end = end.parentNode;

        var shouldNormalizeStart = (start.previousSibling && start.previousSibling.nodeType == 3)
                                && (start.nextSibling && start.nextSibling.nodeType == 3);

        var shouldNormalizeEnd = (end.previousSibling && end.previousSibling.nodeType == 3)
                                && (end.nextSibling && end.nextSibling.nodeType == 3);

        start = start.nextSibling;
        end = end.previousSibling;

        var collapsed = false;
        var collapsedToStart = false;
        // collapsed range
        if (start == this.end) {
            collapsedToStart = !!this.start.previousSibling;
            start = end = this.start.previousSibling || this.end.nextSibling;
            collapsed = true;
        }

        dom.remove(this.start);
        dom.remove(this.end);

        if (start == null || end == null) {
            range.selectNodeContents(range.commonAncestorContainer);
            range.collapse(true);
            return;
        }

        var startOffset = collapsed ? isDataNode(start) ? start.nodeValue.length : start.childNodes.length : 0;
        var endOffset = isDataNode(end) ? end.nodeValue.length : end.childNodes.length;

        if (start.nodeType == 3)
            while (start.previousSibling && start.previousSibling.nodeType == 3) {
                start = start.previousSibling;
                startOffset += start.nodeValue.length;
            }

        if (end.nodeType == 3)
            while (end.previousSibling && end.previousSibling.nodeType == 3) {
                end = end.previousSibling;
                endOffset += end.nodeValue.length;
            }
        var startIndex = findNodeIndex(start), startParent = start.parentNode;
        var endIndex = findNodeIndex(end), endParent = end.parentNode;

        for (var startPointer = start; startPointer.previousSibling; startPointer = startPointer.previousSibling)
            if (startPointer.nodeType == 3 && startPointer.previousSibling.nodeType == 3) startIndex--;

        for (var endPointer = end; endPointer.previousSibling; endPointer = endPointer.previousSibling)
            if (endPointer.nodeType == 3 && endPointer.previousSibling.nodeType == 3) endIndex--;

        normalize(startParent);

        if (start.nodeType == 3)
            start = startParent.childNodes[startIndex];

        normalize(endParent);
        if (end.nodeType == 3)
            end = endParent.childNodes[endIndex];

        if (collapsed) {
            if (start.nodeType == 3)
                range.setStart(start, startOffset);
            else
                range[collapsedToStart ? 'setStartAfter' : 'setStartBefore'](start);
                
            range.collapse(true);

        } else {
            if (start.nodeType == 3)
                range.setStart(start, startOffset);
            else
                range.setStartBefore(start);

            if (end.nodeType == 3)
                range.setEnd(end, endOffset);
            else
                range.setEndAfter(end);
        }
        if (caret)
            this.removeCaret(range);
    }
}

var boundary = /[\u0009-\u000d]|\u0020|\u00a0|\ufeff|\.|,|;|:|!|\(|\)|\?/;

var RangeUtils = {
    nodes: function(range) {
        var nodes = textNodes(range);
        if (!nodes.length) {
            range.selectNodeContents(range.commonAncestorContainer);
            nodes = textNodes(range);
            if (!nodes.length)
                nodes = dom.significantChildNodes(range.commonAncestorContainer);
        }
        return nodes;
    },

    image: function (range) {
        var nodes = [];

        new RangeIterator(range).traverse(function (node) {
            if (dom.is(node, 'img'))
                nodes.push(node);
        });

        if (nodes.length == 1)
            return nodes[0];
    },

    expand: function (range) {
        var result = range.cloneRange();

        var startContainer = result.startContainer.childNodes[result.startOffset == 0 ? 0 : result.startOffset - 1];
        var endContainer = result.endContainer.childNodes[result.endOffset];

        if (!isDataNode(startContainer) || !isDataNode(endContainer))
            return result;

        var beforeCaret = startContainer.nodeValue;
        var afterCaret = endContainer.nodeValue;

        if (beforeCaret == '' || afterCaret == '')
            return result;

        var startOffset = beforeCaret.split('').reverse().join('').search(boundary);
        var endOffset = afterCaret.search(boundary);

        if (startOffset == 0 || endOffset == 0)
            return result;

        endOffset = endOffset == -1 ? afterCaret.length : endOffset;
        startOffset = startOffset == -1 ? 0 : beforeCaret.length - startOffset;

        result.setStart(startContainer, startOffset);
        result.setEnd(endContainer, endOffset);

        return result;
    },

    isExpandable: function (range) {
        var node = range.startContainer;
        var document = documentFromRange(range);

        if (node == document || node == document.body)
            return false;

        var result = range.cloneRange();

        var value = node.nodeValue;
        if (!value)
            return false;

        var beforeCaret = value.substring(0, result.startOffset);
        var afterCaret = value.substring(result.startOffset);

        var startOffset = 0, endOffset = 0;

        if (beforeCaret != '')
            startOffset = beforeCaret.split('').reverse().join('').search(boundary);

        if (afterCaret != '')
            endOffset = afterCaret.search(boundary);

        return startOffset != 0 && endOffset != 0;
    }
};function Command(options) {
    var restorePoint = new RestorePoint(options.range);
    var marker = new Marker();

    this.formatter = options.formatter;

    this.getRange = function () {
        return restorePoint.toRange();
    }

    this.lockRange = function (expand) {
        return marker.add(this.getRange(), expand);
    }

    this.releaseRange = function (range) {
        marker.remove(range);
        selectRange(range);
    }

    this.undo = function () {
        restorePoint.body.innerHTML = restorePoint.html;
        selectRange(restorePoint.toRange());
    }

    this.redo = function () {
        this.exec();
    }

    this.exec = function () {
        var range = this.lockRange(true);
        this.formatter.editor = this.editor;
        this.formatter.toggle(range);
        this.releaseRange(range);
    }
}

function GenericCommand(startRestorePoint, endRestorePoint) {
    var body = startRestorePoint.body;

    this.redo = function () {
        body.innerHTML = endRestorePoint.html;
        selectRange(endRestorePoint.toRange());
    }

    this.undo = function () {
        body.innerHTML = startRestorePoint.html;
        selectRange(startRestorePoint.toRange());
    }
}

function InsertHtmlCommand(options) {
    Command.call(this, options);

    this.managesUndoRedo = true;

    this.exec = function () {
        var editor = this.editor;
        var range = editor.getRange();
        var startRestorePoint = new RestorePoint(range);

        editor.clipboard.paste(options.value || '');
        editor.undoRedoStack.push(new GenericCommand(startRestorePoint, new RestorePoint(editor.getRange())));

        editor.focus();
    }
}

function InsertHtmlTool() {
    Tool.call(this);

    this.command = function (commandArguments) {
        return new InsertHtmlCommand(commandArguments);
    }
    
    this.update = function($ui, nodes) {
        $ui.data('tSelectBox').close();
    }

    this.init = function($ui, initOptions) {
        var editor = initOptions.editor;
        
        $ui.tSelectBox({
            data: editor['insertHtml'],
            onItemCreate: function (e) {
                e.html = '<span unselectable="on">' + e.dataItem.Text + '</span>';
            },
            onChange: function (e) {
                Tool.exec(editor, 'insertHtml', e.value);
            },
            highlightFirst: false
        }).find('.t-input').html(editor.localization.insertHtml);
    }
}

function UndoRedoStack() {
    var stack = [], currentCommandIndex = -1;

    this.push = function (command) {
        stack = stack.slice(0, currentCommandIndex + 1);
        currentCommandIndex = stack.push(command) - 1;
    }

    this.undo = function () {
        if (this.canUndo())
            stack[currentCommandIndex--].undo();
    }

    this.redo = function () {
        if (this.canRedo())
            stack[++currentCommandIndex].redo();
    }

    this.canUndo = function () {
        return currentCommandIndex >= 0;
    }

    this.canRedo = function () {
        return currentCommandIndex != stack.length - 1;
    }
}

function TypingHandler(editor) {
    this.keydown = function (e) {
        var keyboard = editor.keyboard;
        var isTypingKey = keyboard.isTypingKey(e);

        if (isTypingKey && !keyboard.typingInProgress()) {
            var range = editor.getRange();
            this.startRestorePoint = new RestorePoint(range);

            keyboard.startTyping($.proxy(function () {
                editor.selectionRestorePoint = this.endRestorePoint = new RestorePoint(editor.getRange());
                editor.undoRedoStack.push(new GenericCommand(this.startRestorePoint, this.endRestorePoint));
            }, this));

            return true;
        }

        return false;
    }

    this.keyup = function (e) {
        var keyboard = editor.keyboard;

        if (keyboard.typingInProgress()) {
            keyboard.endTyping();
            return true;
        }

        return false;
    }
}

function SystemHandler(editor) {
    var systemCommandIsInProgress = false;

    this.createUndoCommand = function () {
        this.endRestorePoint = new RestorePoint(editor.getRange());
        editor.undoRedoStack.push(new GenericCommand(this.startRestorePoint, this.endRestorePoint));
        this.startRestorePoint = this.endRestorePoint;
    }

    this.changed = function () {
        if (this.startRestorePoint)
            return this.startRestorePoint.html != editor.body.innerHTML;

        return false;
    }

    this.keydown = function (e) {
        var keyboard = editor.keyboard;

        if (keyboard.isModifierKey(e)) {

            if (keyboard.typingInProgress())
                keyboard.endTyping(true);

            this.startRestorePoint = new RestorePoint(editor.getRange());
            return true;
        }

        if (keyboard.isSystem(e)) {
            systemCommandIsInProgress = true;

            if (this.changed()) {
                systemCommandIsInProgress = false;
                this.createUndoCommand();
            }

            return true;
        }

        return false;
    }

    this.keyup = function (e) {
        if (systemCommandIsInProgress && this.changed()) {
            systemCommandIsInProgress = false;
            this.createUndoCommand(e);
            return true;
        }

        return false;
    }
}

function Keyboard(handlers) {
    var typingInProgress = false;
    var timeout;
    var onEndTyping;

    function isCharacter(keyCode) {
        return (keyCode >= 48 && keyCode <= 90) || (keyCode >= 96 && keyCode <= 111) ||
            (keyCode >= 186 && keyCode <= 192) || (keyCode >= 219 && keyCode <= 222);
    }

    this.toolFromShortcut = function (tools, e) {
        var key = String.fromCharCode(e.keyCode);

        for (var toolName in tools) {
            var tool = tools[toolName];

            if ((tool.key == key || tool.key == e.keyCode) && !!tool.ctrl == e.ctrlKey && !!tool.alt == e.altKey && !!tool.shift == e.shiftKey)
                return toolName;
        }
    }

    this.isTypingKey = function (e) {
        var keyCode = e.keyCode;
        return (isCharacter(keyCode) && !e.ctrlKey && !e.altKey) || keyCode == 32 || keyCode == 13
        || keyCode == 8 || (keyCode == 46 && !e.shiftKey && !e.ctrlKey && !e.altKey);
    }

    this.isModifierKey = function (e) {
        var keyCode = e.keyCode;
        return (keyCode == 17 && !e.shiftKey && !e.altKey)
                || (keyCode == 16 && !e.ctrlKey && !e.altKey)
                || (keyCode == 18 && !e.ctrlKey && !e.shiftKey);
    }

    this.isSystem = function (e) {
        return e.keyCode == 46 && e.ctrlKey && !e.altKey && !e.shiftKey;
    }

    this.startTyping = function (callback) {
        onEndTyping = callback;
        typingInProgress = true;
    }

    function stopTyping() {
        typingInProgress = false;
        if (onEndTyping)
            onEndTyping();
    }

    this.endTyping = function (force) {
        this.clearTimeout();
        if (force)
            stopTyping();
        else
            timeout = window.setTimeout(stopTyping, 1000);
    }

    this.typingInProgress = function () {
        return typingInProgress;
    }

    this.clearTimeout = function () {
        window.clearTimeout(timeout);
    }

    function notify(e, what) {
        for (var i = 0; i < handlers.length; i++)
            if (handlers[i][what](e))
                break;
    }

    this.keydown = function (e) {
        notify(e, 'keydown');
    }

    this.keyup = function (e) {
        notify(e, 'keyup');
    }
}

function Clipboard (editor) {
    var cleaners = [new MSWordFormatCleaner()];

    function htmlToFragment (html) {
        var container = dom.create(editor.document, 'div');
        container.innerHTML = html;
            
        var fragment = editor.document.createDocumentFragment();
            
        while (container.firstChild)
            fragment.appendChild(container.firstChild);
            
        return fragment;
    }

    function isBlock(html) {
        return /<(div|p|ul|ol|table|h[1-6])/i.test(html);
    }
        
    this.oncut = function(e) {
        var startRestorePoint = new RestorePoint(editor.getRange());
        setTimeout(function() {
            editor.undoRedoStack.push(new GenericCommand(startRestorePoint, new RestorePoint(editor.getRange())));
        });
    }

    this.onpaste = function(e) {
        var range = editor.getRange();
        var startRestorePoint = new RestorePoint(range);
            
        var clipboardNode = dom.create(editor.document, 'div', {className:'t-paste-container', innerHTML: '\ufeff'});

        editor.body.appendChild(clipboardNode);
            
        if (editor.body.createTextRange) {
            e.preventDefault();
            var r = editor.createRange();
            r.selectNodeContents(clipboardNode);
            editor.selectRange(r);
            var textRange = editor.body.createTextRange();
            textRange.moveToElementText(clipboardNode);
            $(editor.body).unbind('paste');
            textRange.execCommand('Paste');
            $(editor.body).bind('paste', arguments.callee);
        } else {
            var clipboardRange = editor.createRange();
            clipboardRange.selectNodeContents(clipboardNode);
            selectRange(clipboardRange);
        }
            
        setTimeout(function() {
            selectRange(range);
            dom.remove(clipboardNode);
                
            if (clipboardNode.lastChild && dom.is(clipboardNode.lastChild, 'br'))
                dom.remove(clipboardNode.lastChild);
                
            var args = { html: clipboardNode.innerHTML };
            $t.trigger(editor.element, "paste", args);
            editor.clipboard.paste(args.html, true);
            editor.undoRedoStack.push(new GenericCommand(startRestorePoint, new RestorePoint(editor.getRange())));
            selectionChanged(editor);
        });
    }

    function splittableParent(block, node) {
        if (block)
            return dom.parentOfType(node, ['p', 'ul', 'ol']) || node.parentNode;
            
        var parent = node.parentNode;
        var body = node.ownerDocument.body;
            
        if (dom.isInline(parent)) {
            while (parent.parentNode != body && !dom.isBlock(parent.parentNode))
                parent = parent.parentNode;
        }
            
        return parent;
    }

    this.paste = function (html, clean) {
        var i, l;

        for (i = 0, l = cleaners.length; i < l; i++)
            if (cleaners[i].applicable(html))
                html = cleaners[i].clean(html);
            
        if (clean) {
            // remove br elements which immediately precede block elements
            html = html.replace(/(<br>(\s|&nbsp;)*)+(<\/?(div|p|li|col|t))/ig, "$3");
            // remove empty inline elements
            html = html.replace(/<(a|span)[^>]*><\/\1>/ig, "");
        }

        // It is possible in IE to copy just <li> tags
        html = html.replace(/^<li/i, '<ul><li').replace(/li>$/g, 'li></ul>');

        var block = isBlock(html);

        var range = editor.getRange();
        range.deleteContents();

        if (range.startContainer == editor.document)
            range.selectNodeContents(editor.body);
            
        var marker = new Marker();
        var caret = marker.addCaret(range)
            
        var parent = splittableParent(block, caret);
        var unwrap = false;
            
        if (!/body|td/.test(dom.name(parent)) && (block || dom.isInline(parent))) {
            range.selectNode(caret);
            split(range, parent, true);
            unwrap = true;
        }
            
        var fragment = htmlToFragment(html);
        
        if (fragment.firstChild && fragment.firstChild.className === "t-paste-container") {
            var fragmentsHtml = [];
            for (i = 0, l = fragment.childNodes.length; i < l; i++) {
                fragmentsHtml.push(fragment.childNodes[i].innerHTML);
            }

            fragment = htmlToFragment(fragmentsHtml.join('<br />'));
        }

        range.insertNode(fragment);
                
        parent = splittableParent(block, caret);
        if (unwrap) {
            while (caret.parentNode != parent)
                dom.unwrap(caret.parentNode);
                
            dom.unwrap(caret.parentNode);
        }
            
        normalize(range.commonAncestorContainer);
        caret.style.display = 'inline';
        dom.scrollTo(caret);
        marker.removeCaret(range);
        selectRange(range);
    }
}

function MSWordFormatCleaner() {
    var replacements = [
        /<!--(.|\n)*?-->/g, '', /* comments */
        /&quot;/g, "'", /* encoded quotes (in attributes) */
        /(?:<br>&nbsp;[\s\r\n]+|<br>)*(<\/?(h[1-6]|hr|p|div|table|tbody|thead|tfoot|th|tr|td|li|ol|ul|caption|address|pre|form|blockquote|dl|dt|dd|dir|fieldset)[^>]*>)(?:<br>&nbsp;[\s\r\n]+|<br>)*/g, '$1',
        /<br><br>/g, '<BR><BR>', 
        /<br>/g, ' ',
        /<BR><BR>/g, '<br>',
        /^\s*(&nbsp;)+/gi, '',
        /(&nbsp;|<br[^>]*>)+\s*$/gi, '',
        /mso-[^;"]*;?/ig, '', /* office-related CSS attributes */
        /<(\/?)b(\s[^>]*)?>/ig, '<$1strong$2>',
        /<(\/?)i(\s[^>]*)?>/ig, '<$1em$2>',
        /<\/?(meta|link|style|o:|v:)[^>]*>((?:.|\n)*?<\/(meta|link|style|o:|v:)[^>]*>)?/ig, '', /* external references and namespaced tags */
        /style=(["|'])\s*\1/g, '' /* empty style attributes */
    ];
        
    this.applicable = function(html) {
        return /class="?Mso|style="[^"]*mso-/i.test(html);
    }
        
    function listType(html) {
        if (/^[\u2022\u00b7\u00a7\u00d8o]\u00a0+/.test(html))
            return 'ul';
            
        if (/^\s*\w+[\.\)]\u00a0{2,}/.test(html))
            return 'ol';
    }

    function lists(html) {
        var placeholder = dom.create(document, 'div', {innerHTML: html});
        var blockChildren = $(blockElements.join(','), placeholder);
            
        var lastMargin = -1, lastType, levels = {'ul':{}, 'ol':{}}, li = placeholder;
            
        for (var i = 0; i < blockChildren.length; i++) {
            var p = blockChildren[i];
            var html = p.innerHTML.replace(/<\/?\w+[^>]*>/g, '').replace(/&nbsp;/g, '\u00a0');      
            var type = listType(html);
                
            if (!type || dom.name(p) != 'p') { 
                if (p.innerHTML == '') {
                    dom.remove(p);
                } else {
                    levels = {'ul':{}, 'ol':{}};
                    li = placeholder;
                    lastMargin = -1;
                }
                continue;
            }
                
            var margin = parseFloat(p.style.marginLeft || 0);
            var list = levels[type][margin];

            if (margin > lastMargin || !list) {
                list = dom.create(document, type);
                    
                if (li == placeholder)
                    dom.insertBefore(list, p);
                else 
                    li.appendChild(list);
                    
                levels[type][margin] = list;
            }
                
            if (lastType != type) {
                for (var key in levels)
                    for (var child in levels[key])
                        if ($.contains(list, levels[key][child]))
                            delete levels[key][child];
            }

            dom.remove(p.firstChild);
            li = dom.create(document, 'li', {innerHTML:p.innerHTML});
            list.appendChild(li);
            dom.remove(p);
            lastMargin = margin;
            lastType = type;
        }
        return placeholder.innerHTML;
    }

    function stripEmptyAnchors(html) {
        return html.replace(/<a([^>]*)>\s*<\/a>/ig, function(a, attributes) {
            if (!attributes || attributes.indexOf("href") < 0) {
                return "";
            }

            return a;
        });
    }

    this.clean = function(html) {
        for (var i = 0, l = replacements.length; i < l; i+= 2)
            html = html.replace(replacements[i], replacements[i+1]);

        html = stripEmptyAnchors(html);
        html = lists(html);
        html = html.replace(/\s+class="?[^"\s>]*"?/ig, '');
           
        return html;
    }
};function InlineFormatFinder(format) {
    function numberOfSiblings(referenceNode) {
        var textNodesCount = 0, elementNodesCount = 0, markerCount = 0,
            parentNode = referenceNode.parentNode;

        for (var node = parentNode.firstChild; node; node = node.nextSibling) {
            if (node != referenceNode) {
                if (node.className == 't-marker') {
                    markerCount++;
                } else if (node.nodeType == 3) {
                    textNodesCount++;
                } else {
                    elementNodesCount++;
                }
            }
        }

        if (markerCount > 1 && parentNode.firstChild.className == 't-marker' && parentNode.lastChild.className == 't-marker') {
            // full node selection
            return 0;
        } else {
            return elementNodesCount + textNodesCount;
        }
    }

    this.findSuitable = function (sourceNode, skip) {
        if (!skip && numberOfSiblings(sourceNode) > 0)
            return null;

        return dom.parentOfType(sourceNode, format[0].tags);
    }

    this.findFormat = function (sourceNode) {
        for (var i = 0; i < format.length; i++) {
            var node = sourceNode;
            var tags = format[i].tags;
            var attributes = format[i].attr;

            if (node && dom.ofType(node, tags) && attrEquals(node, attributes))
                return node;

            while (node) {
                node = dom.parentOfType(node, tags);
                if (node && attrEquals(node, attributes))
                    return node;
            }
        }

        return null;
    }

    this.isFormatted = function (nodes) {
        for (var i = 0; i < nodes.length; i++)
            if (this.findFormat(nodes[i]))
                return true;

        return false;
    }
}

function InlineFormatter(format, values) {
    this.finder = new InlineFormatFinder(format);

    var attributes = $.extend({}, format[0].attr, values);

    var tag = format[0].tags[0];

    function wrap(node) {
        return dom.wrap(node, dom.create(node.ownerDocument, tag, attributes));
    }

    this.activate = function(range, nodes) {
        if (this.finder.isFormatted(nodes)) {
            this.split(range);
            this.remove(nodes);
        } else
            this.apply(nodes);
    }

    this.toggle = function (range) {
        var nodes = textNodes(range);

        if (nodes.length > 0)
            this.activate(range, nodes);
    }

    this.apply = function (nodes) {
        var formatNodes = [];
        for (var i = 0, l = nodes.length; i < l; i++) {
            var node = nodes[i];

            var formatNode = this.finder.findSuitable(node);
            if (formatNode)
                dom.attr(formatNode, attributes);
            else
                formatNode = wrap(node);

            formatNodes.push(formatNode);
        }

        this.consolidate(formatNodes);
    }

    this.remove = function (nodes) {
        for (var i = 0, l = nodes.length; i < l; i++) {
            var formatNode = this.finder.findFormat(nodes[i]);
            if (formatNode) {
                if (attributes && attributes.style) {
                    dom.unstyle(formatNode, attributes.style);
                    if (!formatNode.style.cssText) {
                        dom.unwrap(formatNode);
                    }
                } else {
                    dom.unwrap(formatNode);
                }
            }
        }
    }

    this.split = function (range) {
        var nodes = textNodes(range);

        if (nodes.length > 0) {
            for (var i = 0, l = nodes.length; i < l; i++) {
                var formatNode = this.finder.findFormat(nodes[i]);
                if (formatNode)
                    split(range, formatNode, true);
            }
        }
    }

    this.consolidate = function (nodes) {
        while (nodes.length > 1) {
            var node = nodes.pop();
            var last = nodes[nodes.length - 1];

            if (node.previousSibling && node.previousSibling.className == 't-marker') {
                last.appendChild(node.previousSibling);
            }

            if (node.tagName == last.tagName && node.previousSibling == last && node.style.cssText == last.style.cssText) {
                while (node.firstChild)
                    last.appendChild(node.firstChild);
                dom.remove(node);
            }
        }
    }
}

function GreedyInlineFormatFinder(format, greedyProperty) {
    InlineFormatFinder.call(this, format);

    function getInlineCssValue(node) {
        var attributes = node.attributes,
            trim = $.trim;

        if (!attributes) return;

        for (var i = 0, l = attributes.length; i < l; i++) {
            var attribute = attributes[i],
                name = attribute.nodeName,
                attributeValue = attribute.nodeValue;

            if (attribute.specified && name == 'style') {
                
                var css = trim(attributeValue || node.style.cssText).split(';');

                for (var cssIndex = 0, len = css.length; cssIndex < len; cssIndex++) {
                    var pair = css[cssIndex];
                    if (pair.length) {
                        var propertyAndValue = pair.split(':');
                        var property = trim(propertyAndValue[0].toLowerCase()),
                            value = trim(propertyAndValue[1]);

                        if (property != greedyProperty)
                            continue;

                        return property.indexOf('color') >= 0 ? dom.toHex(value) : value;
                    }
                }
            }
        }

        return;
    }

    function getFormat (node) {
        var $node = $(isDataNode(node) ? node.parentNode : node);
        var parents = $node.parents().andSelf();

        for (var i = 0, len = parents.length; i < len; i++) {
            var value = greedyProperty == 'className' ? parents[i].className : getInlineCssValue(parents[i]);
            if (value)
                return value;
        }

        return 'inherit';
    }

    this.getFormat = function (nodes) {
        var result = getFormat(nodes[0]);

        for (var i = 1, len = nodes.length; i < len; i++)
            if (result != getFormat(nodes[i]))
                return '';

        return result;
    }

    this.isFormatted = function (nodes) {
        return this.getFormat(nodes) !== '';
    }
}

function GreedyInlineFormatter(format, values, greedyProperty) {
    InlineFormatter.call(this, format, values);

    this.finder = new GreedyInlineFormatFinder(format, greedyProperty)

    this.activate = function(range, nodes) {
        this.split(range);

        if (greedyProperty) {
            var camelCase = greedyProperty.replace(/-([a-z])/, function(all, letter){return letter.toUpperCase()});
            this[values.style[camelCase] == 'inherit' ? 'remove' : 'apply'](nodes);
        } else {
            this.apply(nodes);
        }
    }
}

function inlineFormatWillDelayExecution (range) {
    return range.collapsed && !RangeUtils.isExpandable(range);
}

function InlineFormatTool(options) {
    FormatTool.call(this, $.extend(options, {
        finder: new InlineFormatFinder(options.format),
        formatter: function () { return new InlineFormatter(options.format) }
    }));

    this.willDelayExecution = inlineFormatWillDelayExecution;
}

function FontTool(options){
    Tool.call(this, options);
    
    // IE has single selection hence we are using select box instead of combobox
    var type = $.browser.msie ? 'tSelectBox' : 'tComboBox',
        format = [{ tags: ['span'] }],
        finder = new GreedyInlineFormatFinder(format, options.cssAttr);

    this.command = function (commandArguments) {
        return new FormatCommand($.extend(commandArguments, {
            formatter: function () { 
                var style = {};
                style[options.domAttr] = commandArguments.value;

                return new GreedyInlineFormatter(format, { style: style }, options.cssAttr); 
            }
        }))        
    }

    this.willDelayExecution = inlineFormatWillDelayExecution;
    
    this.update = function($ui, nodes, pendingFormats) {
        var list = $ui.data(type);
        list.close();

        var pendingFormat = pendingFormats.getPending(this.name);

        var format = (pendingFormat && pendingFormat.params) ? pendingFormat.params.value : finder.getFormat(nodes)

        list.value(format);
    }

    this.init = function ($ui, initOptions) {
        var editor = initOptions.editor;

        $ui[type]({
            data: editor[options.name],
            onChange: function (e) {
                Tool.exec(editor, options.name, e.value);
            },
            onItemCreate: function (e) {
                e.html = '<span unselectable="on" style="display:block;">' + e.dataItem.Text + '</span>';
            },
            highlightFirst: false
        });

        $ui.data(type).value('inherit');
    }
};

function ColorTool (options) {
    Tool.call(this, options);

    var format = [{ tags: inlineElements }];
    
    this.update = function($ui) {
        $ui.data('tColorPicker').close();
    }
    
    this.command = function (commandArguments) {

        return new FormatCommand($.extend(commandArguments, {
            formatter: function () { 
                var style = {};
                style[options.domAttr] = commandArguments.value;

                return new GreedyInlineFormatter(format, { style: style }, options.cssAttr); 
            }
        }))        
    }

    this.willDelayExecution = inlineFormatWillDelayExecution;

    this.init = function($ui, initOptions) {
        var editor = initOptions.editor;
        
        $ui.tColorPicker({
            selectedColor: '#000000',
            onChange: function (e) {
                Tool.exec(editor, options.name, e.value);
            }
        });
    }
}

function StyleTool() {
    Tool.call(this);
    var format = [{ tags: ['span'] }],
        finder = new GreedyInlineFormatFinder(format, 'className');
    
    this.command = function (commandArguments) {
        return new FormatCommand($.extend(commandArguments, {
            formatter: function () { 
                return new GreedyInlineFormatter(format, { className: commandArguments.value }); 
            }
        }));
    }
    
    this.update = function($ui, nodes) {
        var list = $ui.data('tSelectBox');
        list.close();
        list.value(finder.getFormat(nodes));
    }

    this.init = function($ui, initOptions) {
        var editor = initOptions.editor;
        
        $ui.tSelectBox({
            data: editor['style'],
            title: editor.localization.style,
            onItemCreate: function (e) {
                var style = dom.inlineStyle(editor.document, 'span', {className : e.dataItem.Value});
                
                e.html = '<span unselectable="on" style="display:block;' + style +'">' + e.html + '</span>';
            },
            onChange: function (e) {
                Tool.exec(editor, 'style', e.value);
            }
        });
    } 
};function BlockFormatFinder(format) {
    function contains(node, children) {
        for (var i = 0; i < children.length; i++) {
            var child = children[i];
            if (child == null || !isAncestorOrSelf(node, child))
                return false;
        }

        return true;
    }

    this.findSuitable = function (nodes) {
        var suitable = [];

        for (var i = 0; i < nodes.length; i++) {
            var candidate = dom.ofType(nodes[i], format[0].tags) ? nodes[i] : dom.parentOfType(nodes[i], format[0].tags);
            if (!candidate)
                return [];
            if ($.inArray(candidate, suitable) < 0)
                suitable.push(candidate);
        }

        for (var i = 0; i < suitable.length; i++)
            if (contains(suitable[i], suitable))
                return [suitable[i]];

        return suitable;
    }

    this.findFormat = function (sourceNode) {
        for (var i = 0; i < format.length; i++) {
            var node = sourceNode;
            var tags = format[i].tags;
            var attributes = format[i].attr;

            while (node) {
                if (dom.ofType(node, tags) && attrEquals(node, attributes))
                    return node;
                node = node.parentNode;
            }
        }
        return null;
    }

    this.getFormat = function (nodes) {
        var findFormat = $.proxy(function(node) { return this.findFormat(isDataNode(node) ? node.parentNode : node); }, this),
            result = findFormat(nodes[0]);

        if (!result)
            return '';

        for (var i = 1, len = nodes.length; i < len; i++)
            if (result != findFormat(nodes[i]))
                return '';

        return result.nodeName.toLowerCase();
    }

    this.isFormatted = function (nodes) {
        for (var i = 0; i < nodes.length; i++)
            if (!this.findFormat(nodes[i]))
                return false;

        return true;
    }
}

function BlockFormatter(format, values) {
    var finder = new BlockFormatFinder(format);

    function wrap(tag, attributes, nodes) {
        var commonAncestor = nodes.length == 1 ? dom.blockParentOrBody(nodes[0]) : dom.commonAncestor.apply(null, nodes);

        if (dom.isInline(commonAncestor))
            commonAncestor = dom.blockParentOrBody(commonAncestor);

        var ancestors = dom.significantChildNodes(commonAncestor);

        var position = findNodeIndex(ancestors[0]);

        var wrapper = dom.create(commonAncestor.ownerDocument, tag, attributes);

        for (var i = 0; i < ancestors.length; i++) {
            var ancestor = ancestors[i];
            if (dom.isBlock(ancestor)) {
                dom.attr(ancestor, attributes);

                if (wrapper.childNodes.length) {
                    dom.insertBefore(wrapper, ancestor);
                    wrapper = wrapper.cloneNode(false);
                }

                position = findNodeIndex(ancestor) + 1;

                continue;
            }

            wrapper.appendChild(ancestor);
        }

        if (wrapper.firstChild)
            dom.insertAt(commonAncestor, wrapper, position);
    }

    this.apply = function (nodes) {
        var formatNodes = dom.is(nodes[0], 'img') ? [nodes[0]] : finder.findSuitable(nodes);

        var formatToApply = formatNodes.length ? formatByName(dom.name(formatNodes[0]), format) : format[0];

        var tag = formatToApply.tags[0];
        var attributes = $.extend({}, formatToApply.attr, values);

        if (formatNodes.length)
            for (var i = 0; i < formatNodes.length; i++)
                dom.attr(formatNodes[i], attributes);
        else
            wrap(tag, attributes, nodes);
    }

    this.remove = function (nodes) {
        for (var i = 0, l = nodes.length; i < l; i++) {
            var formatNode = finder.findFormat(nodes[i]);
            if (formatNode)
                if (dom.ofType(formatNode, ['p', 'img', 'li']))
                    dom.unstyle(formatNode, formatByName(dom.name(formatNode), format).attr.style);
                else
                    dom.unwrap(formatNode);
        }
    }

    this.toggle = function (range) {
        var nodes = RangeUtils.nodes(range);
        if (finder.isFormatted(nodes))
            this.remove(nodes);
        else
            this.apply(nodes);
    }
}

function GreedyBlockFormatter(format, values) {
    var finder = new BlockFormatFinder(format);

    this.apply = function (nodes) {
        var blocks = blockParents(nodes);
        var formatTag = format[0].tags[0];
        if (blocks.length) {
            for (var i = 0, len = blocks.length; i < len; i++) {
                if (dom.is(blocks[i], 'li')) {
                    var list = blocks[i].parentNode;
                    var formatter = new ListFormatter(list.nodeName.toLowerCase(), formatTag);
                    var range = this.editor.createRange();
                    range.selectNode(blocks[i]);
                    formatter.toggle(range);
                } else {
                    dom.changeTag(blocks[i], formatTag);
                }
            }
        } else {
            new BlockFormatter(format, values).apply(nodes);
        }
    }

    this.toggle = function (range) {
        var nodes = textNodes(range);
        if (!nodes.length) {
            range.selectNodeContents(range.commonAncestorContainer);
            nodes = textNodes(range);
            if (!nodes.length)
                nodes = dom.significantChildNodes(range.commonAncestorContainer);
        }

        this.apply(nodes);
    }
}

function FormatCommand(options) {
    options.formatter = options.formatter();
    Command.call(this, options);
}

function BlockFormatTool (options) {
    FormatTool.call(this, $.extend(options, {
        finder: new BlockFormatFinder(options.format),
        formatter: function () { return new BlockFormatter(options.format) }
    }));
}

function FormatBlockTool() {
    Tool.call(this);
    var finder = new BlockFormatFinder([{ tags: blockElements }])

    this.command = function (commandArguments) {
        return new FormatCommand($.extend(commandArguments, {
            formatter: function () { return new GreedyBlockFormatter([{ tags: [commandArguments.value] }], {}); }
        }))
    }
    
    this.update = function($ui, nodes) {
        var list = $ui.data('tSelectBox');
        list.close();
        list.value(finder.getFormat(nodes));
    }

    this.init = function($ui, initOptions) {
        var editor = initOptions.editor;
        
        $ui.tSelectBox({
            data: editor.formatBlock,
            title: editor.localization.formatBlock,
            onItemCreate: function (e) {
                var tagName = e.dataItem.Value;
                e.html = '<' + tagName + ' unselectable="on" style="margin: .3em 0;' + dom.inlineStyle(editor.document, tagName) + '">' + e.dataItem.Text + '</' + tagName + '>';
            },
            onChange: function (e) {
                Tool.exec(editor, 'formatBlock', e.value);
            },
            highlightFirst: false
        });
    }
};function ParagraphCommand(options) {
    Command.call(this, options);

    this.exec = function () {
        var range = this.getRange(),
            document = documentFromRange(range),
            parent, previous, next,
            emptyParagraphContent = $.browser.msie ? '' : '<br _moz_dirty="" />',
            paragraph, marker, li, heading, rng,
            // necessary while the emptyParagraphContent is empty under IE
            blocks = 'p,h1,h2,h3,h4,h5,h6'.split(','),
            startInBlock = dom.parentOfType(range.startContainer, blocks),
            endInBlock = dom.parentOfType(range.endContainer, blocks),
            shouldTrim = (startInBlock && !endInBlock) || (!startInBlock && endInBlock);

        range.deleteContents();

        marker = dom.create(document, 'a');
        range.insertNode(marker);

        normalize(marker.parentNode);

        li = dom.parentOfType(marker, ['li']);
        heading = dom.parentOfType(marker, 'h1,h2,h3,h4,h5,h6'.split(','));

        if (li) {
            rng = range.cloneRange();
            rng.selectNode(li);
            
            // hitting 'enter' in empty li
            if (textNodes(rng).length == 0) {
                paragraph = dom.create(document, 'p');

                if (li.nextSibling) {
                    split(rng, li.parentNode);
                }

                dom.insertAfter(paragraph, li.parentNode);
                dom.remove(li.parentNode.childNodes.length == 1 ? li.parentNode : li);
                paragraph.innerHTML = emptyParagraphContent;
                next = paragraph;
            }
        } else if (heading && !marker.nextSibling) {
            paragraph = dom.create(document, 'p');

            dom.insertAfter(paragraph, heading);
            paragraph.innerHTML = emptyParagraphContent;
            dom.remove(marker);
            next = paragraph;
        }

        if (!next) {
            if (!(li || heading)) {
                new BlockFormatter([{ tags: ['p']}]).apply([marker]);
            }

            range.selectNode(marker);

            parent = dom.parentOfType(marker, [li ? 'li' : heading ? dom.name(heading) : 'p']);

            split(range, parent, shouldTrim);

            previous = parent.previousSibling;

            if (dom.is(previous, 'li') && previous.firstChild && !dom.is(previous.firstChild, 'br')) {
                previous = previous.firstChild;
            }

            next = parent.nextSibling;

            if (dom.is(next, 'li') && next.firstChild && !dom.is(next.firstChild, 'br')) {
                next = next.firstChild;
            }

            dom.remove(parent);

            function clean(node) {
                if (node.firstChild && dom.is(node.firstChild, 'br')) {
                    dom.remove(node.firstChild);
                }

                if (isDataNode(node) && node.nodeValue == '') {
                    node = node.parentNode;
                }

                if (node && !dom.is(node, 'img') && node.innerHTML == '') {
                    node.innerHTML = emptyParagraphContent;
                }
            }

            clean(previous);
            clean(next);

            // normalize updates the caret display in Gecko
            normalize(previous);
        }

        normalize(next);

        if (dom.is(next, 'img')) {
            range.setStartBefore(next);
        } else {
            range.selectNodeContents(next);
        }

        range.collapse(true);

        dom.scrollTo(next);

        selectRange(range);
    }
}

function NewLineCommand(options) {
    Command.call(this, options);

    this.exec = function () {
        var range = this.getRange();
        range.deleteContents();
        var br = dom.create(documentFromRange(range), 'br');
        range.insertNode(br);
        normalize(br.parentNode);
        
        if (!$.browser.msie && (!br.nextSibling || dom.isWhitespace(br.nextSibling))) { 
            //Gecko and WebKit cannot put the caret after only one br.
            var filler = br.cloneNode(true);
            filler.setAttribute('_moz_dirty', '');
            dom.insertAfter(filler, br);
        }
        range.setStartAfter(br);
        range.collapse(true);
        selectRange(range);
    }
};function ListFormatFinder(tag) {
    var tags = [tag == 'ul' ? 'ol' : 'ul', tag];
        
    BlockFormatFinder.call(this, [{ tags: tags}]);

    this.isFormatted = function (nodes) {
        var formatNodes = [], formatNode;
            
        for (var i = 0; i < nodes.length; i++)
            if ((formatNode = this.findFormat(nodes[i])) && dom.name(formatNode) == tag)
                formatNodes.push(formatNode);

        if (formatNodes.length < 1) {
            return false;
        }

        if (formatNodes.length != nodes.length) {
            return false;
        }

        for (i = 0; i < formatNodes.length; i++) {
            if (formatNodes[i] != formatNode) {
                return false;
            }
        }

        return true;
    }

    this.findSuitable = function (nodes) {
        var candidate = dom.parentOfType(nodes[0], tags)
        if (candidate && dom.name(candidate) == tag)
            return candidate;
        return null;
    }
}

function ListFormatter(tag, unwrapTag) {
    var finder = new ListFormatFinder(tag);

    function wrap(list, nodes) {
        var li = dom.create(list.ownerDocument, 'li');

        for (var i = 0; i < nodes.length; i++) {
            var node = nodes[i];

            if (dom.is(node, 'li')) {
                list.appendChild(node);
                continue;
            }

            if (dom.is(node, 'ul') || dom.is(node, 'ol')) {
                while (node.firstChild) {
                    list.appendChild(node.firstChild);
                }
                continue;
            }
            
            if (dom.is(node, "td")) {
                while (node.firstChild) {
                    li.appendChild(node.firstChild);
                }
                list.appendChild(li);
                node.appendChild(list);
                list = list.cloneNode(false);
                li = li.cloneNode(false);
                continue;
            }

            li.appendChild(node);

            if (dom.isBlock(node)) {
                list.appendChild(li);
                dom.unwrap(node);
                li = li.cloneNode(false);
            }
        }

        if (li.firstChild)
            list.appendChild(li);
    }

    function containsAny(parent, nodes) {
        for (var i = 0; i < nodes.length; i++)
            if (isAncestorOrSelf(parent, nodes[i]))
                return true;

        return false;
    }

    function suitable(candidate, nodes) {
        if (candidate.className == "t-marker") {
            var sibling = candidate.nextSibling;

            if (sibling && dom.isBlock(sibling)) {
                return false;
            }

            sibling = candidate.previousSibling;

            if (sibling && dom.isBlock(sibling)) {
                return false;
            }
        }

        return containsAny(candidate, nodes) || dom.isInline(candidate) || candidate.nodeType == 3;
    }

    this.split = function (range) {
        var nodes = textNodes(range);
        if (nodes.length) {
            var start = dom.parentOfType(nodes[0], ['li']);
            var end = dom.parentOfType(nodes[nodes.length - 1], ['li'])
            range.setStartBefore(start);
            range.setEndAfter(end);

            for (var i = 0, l = nodes.length; i < l; i++) {
                var formatNode = finder.findFormat(nodes[i]);
                if (formatNode) {
                    var parents = $(formatNode).parents("ul,ol");
                    if (parents[0]) {
                        split(range, parents.last()[0], true);
                    } else {
                        split(range, formatNode, true);
                    }
                }
            }
        }
    }

    this.apply = function (nodes) {
        var commonAncestor = nodes.length == 1 ? dom.parentOfType(nodes[0], ['ul','ol']) : dom.commonAncestor.apply(null, nodes);
            
        if (!commonAncestor)
            commonAncestor = dom.parentOfType(nodes[0], ["td"]) || nodes[0].ownerDocument.body;

        if (dom.isInline(commonAncestor))
            commonAncestor = dom.blockParentOrBody(commonAncestor);

        var ancestors = [];

        var formatNode = finder.findSuitable(nodes);

        if (!formatNode)
            formatNode = new ListFormatFinder(tag == 'ul' ? 'ol' : 'ul').findSuitable(nodes);
        
        var childNodes = dom.significantChildNodes(commonAncestor);
        
        if (/table|tbody/.test(dom.name(commonAncestor))) {
            childNodes = $.map(nodes, function(node) { return dom.parentOfType(node, ["td"]) });
        }

        for (var i = 0; i < childNodes.length; i++) {
            var child = childNodes[i];
            var nodeName = dom.name(child);
            if (suitable(child, nodes) && (!formatNode || !isAncestorOrSelf(formatNode, child))) {

                if (formatNode && (nodeName == 'ul' || nodeName == 'ol')) {
                    // merging lists
                    $.each(child.childNodes, function () { ancestors.push(this) });
                    dom.remove(child);
                } else {
                    ancestors.push(child);
                }
            }
        }

        if (ancestors.length == childNodes.length && commonAncestor != nodes[0].ownerDocument.body && !/table|tbody|tr|td/.test(dom.name(commonAncestor)))
            ancestors = [commonAncestor];

        if (!formatNode) {
            formatNode = dom.create(commonAncestor.ownerDocument, tag);
            dom.insertBefore(formatNode, ancestors[0]);
        }

        wrap(formatNode, ancestors);

        if (!dom.is(formatNode, tag))
            dom.changeTag(formatNode, tag);

        var prev = formatNode.previousSibling;
        while (prev && (prev.className == "t-marker" || (prev.nodeType == 3 && dom.isWhitespace(prev)))) prev = prev.previousSibling;

        // merge with previous list
        if (prev && dom.name(prev) == tag) {
            while(formatNode.firstChild) {
                prev.appendChild(formatNode.firstChild);
            }
            dom.remove(formatNode);
            formatNode = prev;
        }

        var next = formatNode.nextSibling;
        while (next && (next.className == "t-marker" || (next.nodeType == 3 && dom.isWhitespace(next)))) next = next.nextSibling;

        // merge with next list
        if (next && dom.name(next) == tag) {
            while(formatNode.lastChild) {
                next.insertBefore(formatNode.lastChild, next.firstChild);
            }
            dom.remove(formatNode);
        }
    }

    function unwrap(ul) {
        var fragment = document.createDocumentFragment(), 
            parents,
            li,
            p,
            child;

        for (li = ul.firstChild; li; li = li.nextSibling) {
            p = dom.create(ul.ownerDocument, unwrapTag || 'p');
                
            while(li.firstChild) {
                child = li.firstChild;

                if (dom.isBlock(child)) {

                    if (p.firstChild) {
                        fragment.appendChild(p);
                        p = dom.create(ul.ownerDocument, unwrapTag || 'p');
                    }

                    fragment.appendChild(child);
                } else {
                    p.appendChild(child);
                }
            }

            if (p.firstChild) {
                fragment.appendChild(p);
            }
        }
            
        parents = $(ul).parents('ul,ol');

        if (parents[0]) {
            dom.insertAfter(fragment, parents.last()[0]);
            parents.last().remove();
        } else {
            dom.insertAfter(fragment, ul);
        }

        dom.remove(ul);
    }

    this.remove = function (nodes) {
        var formatNode;
        for (var i = 0, l = nodes.length; i < l; i++)
            if (formatNode = finder.findFormat(nodes[i]))
                unwrap(formatNode);
    }

    this.toggle = function (range) {
        var nodes = textNodes(range),
            ancestor = range.commonAncestorContainer;

        if (!nodes.length) {
            range.selectNodeContents(ancestor);
            nodes = textNodes(range);
            if (!nodes.length && (dom.is(range.startContainer, 'li') || dom.parentOfType(range.startContainer, ['li']))) {
                var text = ancestor.ownerDocument.createTextNode("");
                range.startContainer.appendChild(text);
                nodes = [text];
                range.selectNode(text.parentNode);
            }
        }
            
        if (finder.isFormatted(nodes)) {
            this.split(range);
            this.remove(nodes);
        } else {
            this.apply(nodes);
        }
    }
}

function ListCommand(options) {
    options.formatter = new ListFormatter(options.tag);
    Command.call(this, options);
}

function ListTool(options) {
    FormatTool.call(this, $.extend(options, {
        finder: new ListFormatFinder(options.tag)
    }));

    this.command = function (commandArguments) { 
        return new ListCommand($.extend(commandArguments, { tag: options.tag }));
    }
};function LinkFormatFinder() {
    this.findSuitable = function (sourceNode) {
        return dom.parentOfType(sourceNode, ['a']);
    }
}

function LinkFormatter() {
    this.finder = new LinkFormatFinder();

    this.apply = function (range, attributes) {
        var nodes = textNodes(range);
        if (attributes.innerHTML != undefined) {
            var markers = getMarkers(range);
            var document = documentFromRange(range);
            range.deleteContents();
            var a = dom.create(document, 'a', attributes);
            range.insertNode(a);

            if (markers.length > 1) {
                dom.insertAfter(markers[markers.length - 1], a);
                dom.insertAfter(markers[1], a);
                dom[nodes.length > 0 ? 'insertBefore' : 'insertAfter'](markers[0], a);
            }
        } else {
            var formatter = new InlineFormatter([{ tags: ['a']}], attributes);
            formatter.finder = this.finder;
            formatter.apply(nodes);
        }
    }
}

function UnlinkCommand(options) {
    options.formatter = {
        toggle : function(range) {
            new InlineFormatter([{ tags: ['a']}]).remove(textNodes(range));
        }
    };
    
    Command.call(this, options);
}

function LinkCommand(options) {
    Command.call(this, options);

    var attributes;

    this.async = true;

    var formatter = new LinkFormatter();

    this.exec = function () {
        var range = this.getRange();

        var collapsed = range.collapsed;

        range = this.lockRange(true);

        var nodes = textNodes(range);

        var initialText = null;

        var self = this;

        function apply(e) {
            var href = $('#t-editor-link-url', dialog.element).val();

            if (href && href != 'http://') {
                attributes = { href: href };

                var title = $('#t-editor-link-title', dialog.element).val();
                if (title)
                    attributes.title = title;

                var text = $('#t-editor-link-text', dialog.element).val();
                if (text !== initialText)
                    attributes.innerHTML = text;

                var target = $('#t-editor-link-target', dialog.element).is(':checked');
                if (target)
                    attributes.target = '_blank';

                formatter.apply(range, attributes);
            }
            close(e);
            if (self.change)
                self.change();
        }

        function close(e) {
            e.preventDefault();
            dialog.destroy();

            windowFromDocument(documentFromRange(range)).focus();

            self.releaseRange(range);
        }

        var a = nodes.length ? formatter.finder.findSuitable(nodes[0]) : null;

        var shouldShowText = nodes.length <= 1 || (nodes.length == 2 && collapsed);

        var dialog = $t.window.create($.extend({}, this.editor.dialogOptions, {
            title: "\u63d2\u5165\u94fe\u63a5",
            html: new $.easyui.stringBuilder()
                .cat('<div class="t-editor-dialog">')
                    .cat('<ol>')
                        .cat('<li class="t-form-text-row"><label for="t-editor-link-url">\u7f51\u7edc\u5730\u5740</label><input type="text" class="t-input" id="t-editor-link-url"/></li>')
                        .catIf('<li class="t-form-text-row"><label for="t-editor-link-text">\u6587\u672c</label><input type="text" class="t-input" id="t-editor-link-text"/></li>', shouldShowText)
                        .cat('<li class="t-form-text-row"><label for="t-editor-link-title">\u63d0\u793a</label><input type="text" class="t-input" id="t-editor-link-title"/></li>')
                        .cat('<li class="t-form-checkbox-row"><input type="checkbox" id="t-editor-link-target"/><label for="t-editor-link-target">\u5728\u65b0\u7a97\u53e3\u6253\u5f00</label></li>')
                    .cat('</ol>')
                    .cat('<div class="t-button-wrapper">')
                        .cat('<button class="t-dialog-insert t-button">\u63d2\u5165</button>')
                        .cat('&nbsp;&nbsp;')
                        .cat('<button class="t-dialog-close t-button">\u5173\u95ed</button>')
                    .cat('</div>')
                .cat('</div>')
                .string(),
            onClose: close
        }))
            .hide()
            .find('.t-dialog-insert').click(apply).end()
            .find('.t-dialog-close').click(close).end()
            .find('.t-form-text-row input').keydown(function (e) {
                if (e.keyCode == 13)
                    apply(e);
                else if (e.keyCode == 27)
                    close(e);
            }).end()
            // IE < 8 returns absolute url if getAttribute is not used
            .find('#t-editor-link-url').val(a ? a.getAttribute('href', 2) : 'http://').end()
            .find('#t-editor-link-text').val(nodes.length > 0 ? (nodes.length == 1 ? nodes[0].nodeValue : nodes[0].nodeValue + nodes[1].nodeValue) : '').end()
            .find('#t-editor-link-title').val(a ? a.title : '').end()
            .find('#t-editor-link-target').attr('checked', a ? a.target == '_blank' : false).end()
            .show()
            .data('tWindow')
            .center();

        if (shouldShowText && nodes.length > 0)
            initialText = $('#t-editor-link-text', dialog.element).val();

        $('#t-editor-link-url', dialog.element).focus().select();
    },

    this.redo = function () {
        var range = this.lockRange(true);
        formatter.apply(range, attributes);
        this.releaseRange(range);
    }
}

function UnlinkTool(options){
    Tool.call(this, $.extend(options, {command:UnlinkCommand}));
    
    var finder = new InlineFormatFinder([{tags:['a']}]);

    this.init = function($ui) {
        $ui.attr('unselectable', 'on')
           .addClass('t-state-disabled');
    }
    
    this.update = function ($ui, nodes) {
        $ui.toggleClass('t-state-disabled', !finder.isFormatted(nodes))
            .removeClass('t-state-hover');
    }
}
function ImageCommand(options) {
    Command.call(this, options);
    this.async = true;
    var attributes;

    function insertImage(img, range) {
        if (attributes.src && attributes.src != 'http://') {
            if (!img) {
                img = dom.create(documentFromRange(range), 'img', attributes);
                img.onload = img.onerror = function () {
                    img.removeAttribute('complete');
                    img.removeAttribute('width');
                    img.removeAttribute('height');
                }
                range.deleteContents();
                range.insertNode(img);
                range.setStartAfter(img);
                range.setEndAfter(img);
                selectRange(range);
                return true;
            } else
                dom.attr(img, attributes);
        }

        return false;
    }

    this.redo = function () {
        var range = this.lockRange();
        if (!insertImage(RangeUtils.image(range), range))
            this.releaseRange(range);
    }

    this.exec = function () {
        var range = this.lockRange();

        var applied = false;

        var img = RangeUtils.image(range);

        var self = this;

        function apply(e) {
            attributes = {
                src: $('#t-editor-image-url', dialog.element).val(),
                alt: $('#t-editor-image-title', dialog.element).val()
            };

            applied = insertImage(img, range);

            close(e);

            if (self.change)
                self.change();
        }

        function close(e) {
            e.preventDefault();
            dialog.destroy();

            windowFromDocument(documentFromRange(range)).focus();
            if (!applied)
                self.releaseRange(range);
        }

        var fileBrowser = this.editor.fileBrowser;
        var showBrowser = fileBrowser && fileBrowser.selectUrl !== undefined;
        
        function activate() {  
            if (showBrowser) {
                new $t.imageBrowser($(this).find(".t-image-browser"), $.extend(fileBrowser, { apply: apply, element: self.editor.element, localization: self.editor.localization }));
            }
        }        
        
        var dialog = $t.window.create($.extend({ width: 750 }, this.editor.dialogOptions, {
            title: "\u6dfb\u52a0\u56fe\u7247",
            html: new $.easyui.stringBuilder()
                        .cat('<div class="t-editor-dialog">')                        
                            .catIf('<div class="t-image-browser"></div>', showBrowser)
                            .cat('<ol>')
                                .cat('<li class="t-form-text-row"><label for="t-editor-image-url">\u7f51\u7edc\u5730\u5740</label><input type="text" class="t-input" id="t-editor-image-url"/></li>')
                                .cat('<li class="t-form-text-row"><label for="t-editor-image-title">\u63d0\u793a</label><input type="text" class="t-input" id="t-editor-image-title"/></li>')
                            .cat('</ol>')
                            .cat('<div class="t-button-wrapper">')
                                .cat('<button class="t-dialog-insert t-button">\u63d2\u5165</button>')
                                .cat('&nbsp;&nbsp;')
                                .cat('<button class="t-dialog-close t-button">\u5173\u95ed</button>')
                            .cat('</div>')
                        .cat('</div>')
                    .string(),
            onClose: close,
            onActivate: activate
        }))
        .hide()
        .find('.t-dialog-insert').click(apply).end()
        .find('.t-dialog-close').click(close).end()
        .find('.t-form-text-row input').keydown(function (e) {
            if (e.keyCode == 13)
                apply(e);
            else if (e.keyCode == 27)
                close(e);
        }).end()                
        .toggleClass("t-imagebrowser", showBrowser)
        // IE < 8 returns absolute url if getAttribute is not used
        .find('#t-editor-image-url').val(img ? img.getAttribute('src', 2) : 'http://').end()
        .find('#t-editor-image-title').val(img ? img.alt : '').end()
        .show()
        .data('tWindow').center();

        $('#t-editor-image-url', dialog.element).focus().select();
    }
};/* select box */

$t.selectbox = function (element, options) {
    var selectedValue;
    var $element = $(element).attr("tabIndex", 0);
    var $text = $element.find('.t-input');

    var dropDown = this.dropDown = new $t.dropDown({
        effects: $t.fx.slide.defaults(),
        onItemCreate: options.onItemCreate,
        onClick: function (e) {
            select(options.data[$(e.item).index()].Value);
            options.onChange({ value: selectedValue })
        }
    });

    function fill() {
        if (!dropDown.$items)
            dropDown.dataBind(options.data);
    }

    function text(value) {
        $text.html(value ? value : '&nbsp;');
    }

    function select(item) {
        fill();
        var index = -1;

        for (var i = 0, len = options.data.length; i < len; i++) {
            if (options.data[i].Value == item) {
                index = i;
                break;
            }
        }

        if (index != -1) {

            dropDown.$items
                    .removeClass('t-state-selected')
                    .eq(index).addClass('t-state-selected');

            text($(dropDown.$items[index]).text());
            selectedValue = options.data[index].Value;
        }
    }

    this.value = function (value) {
        if (value == undefined)
            return selectedValue;

        select(value);

        if (selectedValue != value)
            text(options.title || value);       
    }

    this.close = function () {
        dropDown.close();
    }

    text(options.title || $text.text());

    $element.click(function (e) {
        fill();
        if (dropDown.isOpened())
            dropDown.close();
        else
            dropDown.open({
                offset: $element.offset(),
                outerHeight: $element.outerHeight(),
                outerWidth: $element.outerWidth(),
                zIndex: $t.getElementZIndex($element[0])
            });
    })
    .find('*')
    .attr('unselectable', 'on')
    .end()
    .keydown(function(e) {
        var key = e.keyCode, selected, prev, next;

        if (key === 40) {
            if (!dropDown.isOpened()) {
                $element.click();
            } else {
                selected = dropDown.$items.filter(".t-state-selected");
                if (!selected[0]) {
                    next = dropDown.$items.first();
                } else {
                    next = selected.next();
                }
                if (next[0]) {
                    selected.removeClass("t-state-selected");
                    next.addClass("t-state-selected");
                }
            }
            e.preventDefault();
        } else if (key === 38) {
            if (dropDown.isOpened()) {
                selected = dropDown.$items.filter(".t-state-selected");
                prev = selected.prev();
                if (prev[0]) {
                    selected.removeClass("t-state-selected");
                    prev.addClass("t-state-selected");
                }
            }
            e.preventDefault();
        } else if (key == 13) {
            selected = dropDown.$items.filter(".t-state-selected");
            if (selected[0]) {
                selected.click();
            }
            e.preventDefault();
        } else if (e.keyCode == 9 || e.keyCode == 39 || e.keyCode == 37) {
            dropDown.close();
        }
    });

    if ($.browser.msie) {
        $element.focus(function() {
            $element.css("outline", "1px dotted #000");
        })
        .blur(function() {
            $element.css("outline", "");
        });
    }

    dropDown.$element.css('direction', $element.closest('.t-rtl').length > 0 ? 'rtl' : '');

    $(document.documentElement).bind('mousedown', $.proxy(function (e) {
        var $dropDown = dropDown.$element;
        var isDropDown = $dropDown && $dropDown.parent().length > 0;

        if (isDropDown && !$.contains(element, e.target) && !$.contains($dropDown.parent()[0], e.target)) {
            dropDown.close();
        }

    }, this));
}

$.fn.tSelectBox = function (options) {
    return $t.create(this, {
        name: 'tSelectBox',
        init: function (element, options) {
            return new $t.selectbox(element, options)
        },
        options: options
    });
};

$.fn.tSelectBox.defaults = {
    effects: $t.fx.slide.defaults()
};

/* color picker */

$t.colorpicker = function (element, options) {
    var that = this;

    that.element = element;
    var $element = $(element);

    $.extend(that, options);

    $element.attr("tabIndex", 0)
            .click($.proxy(that.click, that))
            .keydown(function(e) {
                var popup = that.popup(), selected, next, prev;
                if (e.keyCode == 40) {
                    if (!popup.is(":visible")) {
                        that.open();
                    } else {
                       selected = popup.find(".t-state-selected");
                       if (selected[0]) {
                           next = selected.next();
                       } else {
                           next = popup.find("li:first");
                       }
                       if (next[0]) {
                            selected.removeClass("t-state-selected");
                            next.addClass("t-state-selected");
                       } 
                    }
                    e.preventDefault();
                } else if (e.keyCode == 38) {
                    if (popup.is(":visible")) {
                       selected = popup.find(".t-state-selected");
                       prev = selected.prev();
                       if (prev[0]) {
                            selected.removeClass("t-state-selected");
                            prev.addClass("t-state-selected");
                       } 
                    }
                    e.preventDefault();
                } else if (e.keyCode == 9 || e.keyCode == 39 || e.keyCode == 37) {
                    that.close();
                } else if (e.keyCode == 13) {
                   popup.find(".t-state-selected").click();
                   e.preventDefault();
                }
            })
            .find('*')
            .attr('unselectable', 'on');

    if ($.browser.msie) {
        $element.focus(function () {
            $element.css("outline", "1px dotted #000");
        })
        .blur(function() {
            $element.css("outline", "");
        });
    }    

    if (that.selectedColor)
        $element.find('.t-selected-color').css('background-color', this.selectedColor);

    $(element.ownerDocument.documentElement)
        .bind('mousedown', $.proxy(function (e) {
            if (!$(e.target).closest('.t-colorpicker-popup').length)
                this.close();
        }, that));

    $t.bind(that, {
        change: that.onChange,
        load: that.onLoad
    });
}

$t.colorpicker.prototype = {
    select: function(color) {
        if (color) {
            color = dom.toHex(color);
            if (!$t.trigger(this.element, 'change', { value: color })) {
                this.value(color);
                this.close();
            }
        } else
            $t.trigger(this.element, 'change', { value: this.selectedColor })
    },

    open: function() {
        var $popup = this.popup();
        var $element = $(this.element);

        var elementPosition = $element.offset();
        elementPosition.top += $element.outerHeight();

        if ($element.closest('.t-rtl').length)
            elementPosition.left -= $popup.outerWidth() - $element.outerWidth();

        var zIndex = 'auto';

        $element.parents().andSelf().each(function () {
            zIndex = $(this).css('zIndex');
            if (Number(zIndex)) {
                zIndex = Number(zIndex) + 1;
                return false;
            }
        });

        $t.fx._wrap($popup).css($.extend({
            position: 'absolute',
            zIndex: zIndex
        }, elementPosition));
        
        $popup
            .find('.t-item').bind('click', $.proxy(function(e) {
                var color = $(e.currentTarget, e.target.ownerDocument).find("div").css('background-color');
                this.select(color);
            }, this));

        // animate
        $t.fx.play(this.effects, $popup, { direction: 'bottom' });
    },

    close: function() {
        if (!this.$popup) return;

        $t.fx.rewind(this.effects, this.$popup, { direction: 'bottom' }, $.proxy(function() {
            dom.remove(this.$popup[0].parentNode);
            this.$popup = null;
        }, this));
    },

    toggle: function() {
        if (!this.$popup || !this.$popup.is(':visible'))
            this.open();
        else
            this.close();
    },

    click: function(e) {
        if ($(e.target).closest('.t-tool-icon').length > 0)
            this.select();
        else
            this.toggle();
    },

    value: function(color) {
        if (!color)
            return this.selectedColor;

        color = dom.toHex(color);

        this.selectedColor = color;

        $('.t-selected-color', this.element)
            .css('background-color', color);
    },

    popup: function() {
        if (!this.$popup)
            this.$popup = $($t.colorpicker.buildPopup(this))
                    .hide()
                    .appendTo(document.body)
                    .find('*')
                    .attr('unselectable', 'on')
                    .end();

        return this.$popup;
    }
}

$.extend($t.colorpicker, {
    buildPopup: function(component) {
        var html = new $t.stringBuilder();

        html.cat('<div class="t-popup t-group t-colorpicker-popup">')
            .cat('<ul class="t-reset">');

        var data = component.data;
        var currentColor = (component.value() || '').substring(1);

        for (var i = 0, len = data.length; i < len; i++) {
            html.cat('<li class="t-item')
                .catIf(' t-state-selected', data[i] == currentColor)
                .cat('"><div style="background-color:#')
                .cat(data[i])
                .cat('"></div></li>');
        }

        html.cat('</ul></div>');

        return html.string();
    }
});

$.fn.tColorPicker = function (options) {
    return $t.create(this, {
        name: 'tColorPicker',
        init: function (element, options) {
            return new $t.colorpicker(element, options)
        },
        options: options
    });
};

$.fn.tColorPicker.defaults = {
    data: '000000,7f7f7f,880015,ed1c24,ff7f27,fff200,22b14c,00a2e8,3f48cc,a349a4,ffffff,c3c3c3,b97a57,ffaec9,ffc90e,efe4b0,b5e61d,99d9ea,7092be,c8bfe7'.split(','),
    selectedColor: null,
    effects: $t.fx.slide.defaults()
};
function indent(node, value) {
    var property = dom.name(node) != 'td' ? 'marginLeft' : 'paddingLeft';
    if (value === undefined) {
        return node.style[property] || 0;
    } else {
        if (value > 0) {
            node.style[property] = value + "px";
        } else {
            node.style[property] = "";
            if (node.style.cssText == "") {
                node.removeAttribute("style");
            }
        }
    }
}

function IndentFormatter() {
    var finder = new BlockFormatFinder([{tags:blockElements}]);
    

    this.apply = function (nodes) {
        var formatNodes = finder.findSuitable(nodes);
        if (formatNodes.length) {
            var targets = [];
            for (var i = 0; i < formatNodes.length;i++)
                if (dom.is(formatNodes[i], 'li')) {
                    if ($(formatNodes[i]).index() == 0)
                        targets.push(formatNodes[i].parentNode);
                    else if ($.inArray(formatNodes[i].parentNode, targets) < 0)
                        targets.push(formatNodes[i]);
                }
                else
                    targets.push(formatNodes[i]);
            
            while (targets.length) {
                var formatNode = targets.shift();
                if (dom.is(formatNode, 'li')) {
                    var parentList = formatNode.parentNode;
                    var $sibling = $(formatNode).prev('li');
                    var $siblingList = $sibling.find('ul,ol').last();

                    var nestedList = $(formatNode).children('ul,ol')[0];
                    
                    if (nestedList && $sibling[0]) {
                        if ($siblingList[0]) {
                           $siblingList.append(formatNode);
                           $siblingList.append($(nestedList).children()); 
                           dom.remove(nestedList);
                        } else {
                            $sibling.append(nestedList);
                            nestedList.insertBefore(formatNode, nestedList.firstChild);                        
                        }
                    } else {
                        nestedList = $sibling.children('ul,ol')[0];
                        if (!nestedList) {
                            nestedList = dom.create(formatNode.ownerDocument, dom.name(parentList));
                            $sibling.append(nestedList);
                        }
                        
                        while (formatNode && formatNode.parentNode == parentList) {
                            nestedList.appendChild(formatNode);
                            formatNode = targets.shift();
                        }
                    }
                } else {
                    var marginLeft = parseInt(indent(formatNode)) + 30;
                    indent(formatNode, marginLeft);
                }
            }
        } else {
            var formatter = new BlockFormatter([{tags:blockElements}], {style:{marginLeft:30}});

            formatter.apply(nodes);
        }
    }
    
    this.remove = function(nodes) {
        var formatNodes = finder.findSuitable(nodes), targetNode;
        for (var i = 0; i < formatNodes.length; i++) {
            var $formatNode = $(formatNodes[i]);
            
            if ($formatNode.is('li')) {
                var $list = $formatNode.parent();
                var $listParent = $list.parent();
                // $listParent will be ul or ol in case of invalid dom - <ul><li></li><ul><li></li></ul></ul>   
                if ($listParent.is('li,ul,ol') && !indent($list[0])) {
                    var $siblings = $formatNode.nextAll('li');
                    if ($siblings.length)
                        $($list[0].cloneNode(false)).appendTo($formatNode).append($siblings);
                                        
                    if ($listParent.is("li")) {
                        $formatNode.insertAfter($listParent);
                    } else {
                        $formatNode.appendTo($listParent);
                    } 

                    if (!$list.children('li').length)
                        $list.remove();
                        
                    continue;
                } else {
                    if (targetNode == $list[0]) {
                        // removing format on sibling LI elements
                        continue;
                    }
                    targetNode = $list[0];
                }
            } else {
                targetNode = formatNodes[i];
            }
                
            var marginLeft = parseInt(indent(targetNode)) - 30;
            indent(targetNode, marginLeft);
        }
    }
}

function IndentCommand(options) {
    options.formatter = {
        toggle : function(range) {
            new IndentFormatter().apply(RangeUtils.nodes(range));
        }
    };
    Command.call(this, options);
}

function OutdentCommand(options) {
    options.formatter = {
        toggle : function(range) {
            new IndentFormatter().remove(RangeUtils.nodes(range));
        }
    };
    
    Command.call(this, options);
}

function OutdentTool() {
    Tool.call(this, {command:OutdentCommand});
    
    var finder = new BlockFormatFinder([{tags:blockElements}]);  

    this.init = function($ui) {
        $ui.attr('unselectable', 'on')
           .addClass('t-state-disabled');
    }
    
    this.update = function ($ui, nodes) {
        var suitable = finder.findSuitable(nodes),
            isOutdentable, listParentsCount;

        for (var i = 0; i < suitable.length; i++) {
            isOutdentable = indent(suitable[i]);

            if (!isOutdentable) {
                listParentsCount = $(suitable[i]).parents('ul,ol').length;
                isOutdentable = (dom.is(suitable[i], 'li') && (listParentsCount > 1 || indent(suitable[i].parentNode)))
                             || (dom.ofType(suitable[i], ['ul','ol']) && listParentsCount > 0);
            }

            if (isOutdentable) {
                $ui.removeClass('t-state-disabled');
                return;
            }
        }
    
        $ui.addClass('t-state-disabled').removeClass('t-state-hover');
    }
};function PendingFormats(editor) {
    this.editor = editor;
    this.formats = [];
}

PendingFormats.prototype = {
    apply: function(range) {
        if (!this.hasPending())
            return;
            
        var marker = new Marker();
        
        marker.addCaret(range);

        var caret = range.startContainer.childNodes[range.startOffset];

        var target = caret.previousSibling;

        /* under IE, target is a zero-length text node. go figure. */
        if (!target.nodeValue)
            target = target.previousSibling;

        range.setStart(target, target.nodeValue.length - 1);

        marker.add(range);

        if (textNodes(range).length == 0) {
            marker.remove(range);
            range.collapse(true);
            this.editor.selectRange(range);
            return;
        }

        var textNode = marker.end.previousSibling.previousSibling;

        var pendingFormat, formats = this.formats;

        for (var i = 0; i < formats.length; i++) {
            pendingFormat = formats[i];
            
            var command = pendingFormat.command($.extend({ range: range }, pendingFormat.params));
            command.editor = this.editor;
            command.exec();

            range.selectNode(textNode);
        }

        marker.remove(range);

        if (textNode.parentNode) {
            range.setStart(textNode, 1);
            range.collapse(true);
        }
        
        this.clear();

        this.editor.selectRange(range);
    },
    hasPending: function() {
        return this.formats.length > 0;
    },
    isPending: function(format) {
        return !!this.getPending(format);
    },
    getPending: function(format) {
        var formats = this.formats;
        for (var i = 0; i < formats.length; i++)
            if (formats[i].name == format)
                return formats[i];

        return;
    },
    toggle: function(format) {
        var formats = this.formats;

        for (var i = 0; i < formats.length; i++)
            if (formats[i].name == format.name) {
                if (formats[i].params && formats[i].params.value != format.params.value)
                    formats[i].params.value = format.params.value;
                else
                    formats.splice(i, 1);

                return;
            }

        formats.push(format);
    },
    clear: function() {
        this.formats = [];
    }
};
function createContentElement($textarea, stylesheets) {
    $textarea.hide();
    var iframe = $('<iframe />', { src: 'javascript:"<html></html>"', frameBorder: '0' })
                    .css('display', '')
                    .addClass("t-content")
                    .insertBefore($textarea)[0];

    var window = iframe.contentWindow || iframe;
    var document = window.document || iframe.contentDocument;
    
    var html = $textarea.val()
                // <img>\s+\w+ creates invalid nodes after cut in IE
                .replace(/(<\/?img[^>]*>)[\r\n\v\f\t ]+/ig, '$1')
                // indented HTML introduces problematic ranges in IE
                .replace(/[\r\n\v\f\t ]+/ig, ' ');

    if (!html.length && $.browser.mozilla)
        html = '<br _moz_dirty="true" />';

    document.designMode = 'On';
    document.open();
    document.write(
        new $t.stringBuilder()
            .cat('<!DOCTYPE html><html><head>')
            .cat('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />')
            .cat('<style type="text/css">')
                .cat('html,body{padding:0;margin:0;font-family:Verdana,Geneva,sans-serif;background:#fff;}')
                .cat('html{font-size:100%}body{font-size:.75em;line-height:1.5;padding-top:1px;margin-top:-1px;')
                    .catIf('direction:rtl;', $textarea.closest('.t-rtl').length)
                .cat('}')
                .cat('h1{font-size:2em;margin:.67em 0}h2{font-size:1.5em}h3{font-size:1.16em}h4{font-size:1em}h5{font-size:.83em}h6{font-size:.7em}')
                .cat('p{margin:0 0 1em;padding:0 .2em}.t-marker{display:none;}.t-paste-container{position:absolute;left:-10000px;width:1px;height:1px;overflow:hidden}')
                .cat('ul,ol{padding-left:2.5em}')
                .cat('a{color:#00a}')
                .cat('code{font-size:1.23em}')
            .cat('</style>')
            .cat($.map(stylesheets, function(href){ return ['<link type="text/css" href="', href, '" rel="stylesheet"/>'].join(''); }).join(''))
            .cat('</head><body spellcheck="false">')
            .cat(html)
            .cat('</body></html>')
        .string());
        
    document.close();

    return window;
}

function selectionChanged(editor) {
    $t.trigger(editor.element, 'selectionChange');
}

var focusable = ".t-colorpicker,a.t-tool-icon:not(.t-state-disabled),.t-selectbox, .t-combobox .t-input";

function initializeContentElement(editor) {
    var isFirstKeyDown = true;

    editor.window = createContentElement($(editor.textarea), editor.stylesheets);
    editor.document = editor.window.contentDocument || editor.window.document;
    editor.body = editor.document.body;

    $(editor.document)
        .bind({
            keydown: function (e) {
                if (e.keyCode === 121) {
                    //Using the timeout to avoid the default IE menu when F10 is pressed
                    setTimeout(function() {
                        var tabIndex = $(editor.element).attr("tabIndex");
    
                        //Chrome can't focus something which has already been focused
                        $(editor.element).attr("tabIndex", tabIndex || 0).focus().find(focusable).first().focus();
    
                        if (!tabIndex && tabIndex !== 0) {
                           $(editor.element).removeAttr("tabIndex"); 
                        } 

                    }, 100);
                    e.preventDefault();
                    return;
                }
                var toolName = editor.keyboard.toolFromShortcut(editor.tools, e);

                if (toolName) {
                    e.preventDefault();
                    if (!/undo|redo/.test(toolName)) {
                        editor.keyboard.endTyping(true);
                    }
                    editor.exec(toolName);
                    return false;
                }

                if (editor.keyboard.isTypingKey(e) && editor.pendingFormats.hasPending()) {
                    if (isFirstKeyDown) {
                        isFirstKeyDown = false;
                    } else {
                        var range = editor.getRange();
                        editor.pendingFormats.apply(range);
                        editor.selectRange(range);
                    } 
                }

                editor.keyboard.clearTimeout();

                editor.keyboard.keydown(e);
            },
            keyup: function (e) {
                var selectionCodes = [8, 9, 33, 34, 35, 36, 37, 38, 39, 40, 40, 45, 46];

                if ($.browser.mozilla && e.keyCode == 8) {
                    fixBackspace(editor, e);
                }
                
                if ($.inArray(e.keyCode, selectionCodes) > -1 || (e.keyCode == 65 && e.ctrlKey && !e.altKey && !e.shiftKey)) {
                    editor.pendingFormats.clear();
                    selectionChanged(editor);
                }
                
                if (editor.keyboard.isTypingKey(e)) {
                    if (editor.pendingFormats.hasPending()) {
                        var range = editor.getRange();
                        editor.pendingFormats.apply(range);
                        editor.selectRange(range);
                    }
                } else {
                    isFirstKeyDown = true;
                }

                editor.keyboard.keyup(e);
            },
            mousedown: function(e) {
                editor.pendingFormats.clear();

                var target = $(e.target);

                if (!$.browser.gecko && e.which == 2 && target.is('a[href]'))
                window.open(target.attr('href'), '_new');
            },
            mouseup: function () {
                selectionChanged(editor);
            }
        });

    $(editor.window)
        .bind('blur', function () {
            var old = editor.textarea.value,
            value = editor.encodedValue();

            editor.update(value);

            if (value != old) {
                $t.trigger(editor.element, 'change');
            }
        });
    
    $(editor.body)
        .bind('cut paste', function (e) {
              editor.clipboard['on' + e.type](e);
          });
}

$t.editor = function (element, options) {
    /* suppress initialization in mobile webkit devices (w/o proper contenteditable support) */
    if (/Mobile.*Safari/.test(navigator.userAgent))
        return;

    var self = this;

    this.element = element;

    var $element = $(element);

    $element.closest('form').bind('submit', function () {
        self.update();
    });

    $.extend(this, options);

    $t.bind(this, {
        load: this.onLoad,
        selectionChange: this.onSelectionChange,
        change: this.onChange,
        execute: this.onExecute,
        error: this.onError,
        paste: this.onPaste
    });

    for (var id in this.tools)
        this.tools[id].name = id.toLowerCase();
        
    this.textarea = $element.find('textarea').attr('autocomplete', 'off')[0];
    initializeContentElement(this);
    this.keyboard = new Keyboard([new TypingHandler(this), new SystemHandler(this)]);
        
    this.clipboard = new Clipboard(this);

    this.pendingFormats = new PendingFormats(this);
        
    this.undoRedoStack = new UndoRedoStack();

    function toolFromClassName(element) {
        var tool = $.grep(element.className.split(' '), function (x) {
            return !/^t-(widget|tool-icon|state-hover|header|combobox|dropdown|selectbox|colorpicker)$/i.test(x);
        });
        return tool[0] ? tool[0].substring(2) : 'custom';
    }

    function appendShortcutSequence(localizedText, tool) {
        if (!tool.key)
            return localizedText;

        return new $t.stringBuilder()
            .cat(localizedText)
            .cat(' (')
                .catIf('Ctrl + ', tool.ctrl)
                .catIf('Shift + ', tool.shift)
                .catIf('Alt + ', tool.alt)
                .cat(tool.key)
            .cat(')')
            .string();
    }

    var toolbarItems = '.t-editor-toolbar > li > *',
        buttons = '.t-editor-button .t-tool-icon',
        enabledButtons = buttons + ':not(.t-state-disabled)',
        disabledButtons = buttons + '.t-state-disabled';

     $element.find(".t-combobox .t-input").keydown(function(e) {
        var combobox = $(this).closest(".t-combobox").data("tComboBox"),
            key = e.keyCode;

        if (key == 39 || key == 37) {
            combobox.close();
        } else if (key == 40) {
            if (!combobox.dropDown.isOpened()) {
                e.stopImmediatePropagation();
                combobox.open();
            }
        }
    });

    $element
        .delegate(enabledButtons, 'mouseenter', $t.hover)
        .delegate(enabledButtons, 'mouseleave', $t.leave)
        .delegate(buttons, 'mousedown', $t.preventDefault)
        .delegate(focusable, "keydown", function(e) {
            if (e.keyCode == 39) {
                $(this).closest("li").nextAll("li:has(" + focusable + ")").first().find(focusable).focus();
            } else if (e.keyCode == 37) {
                $(this).closest("li").prevAll("li:has(" + focusable + ")").last().find(focusable).focus();
            } else if (e.keyCode == 27) {
                self.focus();
            }
        })
        .delegate(enabledButtons, 'click', $t.stopAll(function (e) {
            self.exec(toolFromClassName(this));
        }))
        .delegate(disabledButtons, 'click', function(e) { e.preventDefault(); })
        .find(toolbarItems)
            .each(function () {
                var toolName = toolFromClassName(this),
                    tool = self.tools[toolName],
                    description = self.localization[toolName],
                    $this = $(this);

                if (!tool)
                    return;
                    
                if (toolName == 'fontSize' || toolName == 'fontName') {
                    var inheritText = self.localization[toolName + 'Inherit'] || localization[toolName + 'Inherit']
                    self[toolName][0].Text = inheritText;
                    $this.find('input').val(inheritText).end()
                         .find('span.t-input').text(inheritText).end();
                }

                tool.init($this, {
                    title: appendShortcutSequence(description, tool),
                    editor: self
                });

            }).end()
        .bind('selectionChange', function() {
            var range = self.getRange();

            var nodes = textNodes(range);

            if (!nodes.length) {
                nodes = [range.startContainer];
            }

            $element.find(toolbarItems)
                .each(function () {
                    var tool = self.tools[toolFromClassName(this)];
                    if (tool) {
                        tool.update($(this), nodes, self.pendingFormats);
                    }
                });
        });

   
    $(document)
        .bind('DOMNodeInserted', function(e) {
            if ($.contains(e.target, self.element) || self.element == e.target) {
                // preserve updated value before re-initializing
                // don't use update() to prevent the editor from encoding the content too early
                self.textarea.value = self.value();
                $(self.element).find('iframe').remove();
                initializeContentElement(self);
            }
        })
        .bind('mousedown', function(e) {
            try {
                if (self.keyboard.typingInProgress())
                    self.keyboard.endTyping(true);
                
                if (!self.selectionRestorePoint) {
                    self.selectionRestorePoint = new RestorePoint(self.getRange());
                } 
            } catch (e) { }
        });
};

function fixBackspace(editor, e) {

    var range = editor.getRange(),
        startContainer = range.startContainer;

	if (startContainer == editor.body.firstChild || !dom.isBlock(startContainer)
    || (startContainer.childNodes.length > 0 && !(startContainer.childNodes.length == 1 && dom.is(startContainer.firstChild, 'br'))))
        return;
			
	var previousBlock = startContainer.previousSibling;

	while (previousBlock && !dom.isBlock(previousBlock))
        previousBlock = previousBlock.previousSibling;

	if (!previousBlock)
        return;

	var walker = editor.document.createTreeWalker(previousBlock, NodeFilter.SHOW_TEXT, null, false);

    var textNode;

	while (textNode = walker.nextNode())
		previousBlock = textNode;

	range.setStart(previousBlock, isDataNode(previousBlock) ? previousBlock.nodeValue.length : 0);
	range.collapse(true);
	selectRange(range);

	dom.remove(startContainer);

    e.preventDefault();
}

$.extend($t.editor, {
    BlockFormatFinder: BlockFormatFinder,
    BlockFormatter: BlockFormatter,
    Dom: dom,
    FormatCommand: FormatCommand,
    GenericCommand: GenericCommand,
    GreedyBlockFormatter: GreedyBlockFormatter,
    GreedyInlineFormatFinder: GreedyInlineFormatFinder,
    GreedyInlineFormatter: GreedyInlineFormatter,
    ImageCommand: ImageCommand,
    IndentCommand: IndentCommand,
    IndentFormatter: IndentFormatter,
    InlineFormatFinder: InlineFormatFinder,
    InlineFormatter: InlineFormatter,
    InsertHtmlCommand: InsertHtmlCommand,
    Keyboard: Keyboard,
    LinkCommand: LinkCommand,
    LinkFormatFinder: LinkFormatFinder,
    LinkFormatter: LinkFormatter,
    ListCommand: ListCommand,
    ListFormatFinder: ListFormatFinder,
    ListFormatter: ListFormatter,
    MSWordFormatCleaner: MSWordFormatCleaner,
    Marker: Marker,
    NewLineCommand: NewLineCommand,
    OutdentCommand: OutdentCommand,
    ParagraphCommand: ParagraphCommand,
    PendingFormats: PendingFormats,
    RangeEnumerator: RangeEnumerator,
    RangeUtils: RangeUtils,
    RestorePoint: RestorePoint,
    SystemHandler: SystemHandler,
    TypingHandler: TypingHandler,
    UndoRedoStack: UndoRedoStack,
    UnlinkCommand: UnlinkCommand
});

// public api
$t.editor.prototype = {
    value: function (html) {
        var body = this.body;
        if (html === undefined) return domToXhtml(body);

        this.pendingFormats.clear();

        // Some browsers do not allow setting CDATA sections through innerHTML so we encode them as comments
        html = html.replace(/<!\[CDATA\[(.*)?\]\]>/g, '<!--[CDATA[$1]]-->');

        // Encode script tags to avoid execution and lost content (IE)
        html = html.replace(/<script([^>]*)>(.*)?<\/script>/ig, '<easyui:script $1>$2<\/easyui:script>');

        // Add <br/>s to empty paragraphs in mozilla
        if ($.browser.mozilla)
            html = html.replace(/<p([^>]*)>(\s*)?<\/p>/ig, '<p $1><br _moz_dirty="" /><\/p>');

        if ($.browser.msie && parseInt($.browser.version) < 9) {
            // Internet Explorer removes comments from the beginning of the html
            html = '<br/>' + html;

            var originalSrc = 'originalsrc',
                originalHref = 'originalhref';

            // IE < 8 makes href and src attributes absolute
            html = html.replace(/href\s*=\s*(?:'|")?([^'">\s]*)(?:'|")?/, originalHref + '="$1"');
            html = html.replace(/src\s*=\s*(?:'|")?([^'">\s]*)(?:'|")?/, originalSrc + '="$1"');

            body.innerHTML = html;
            dom.remove(body.firstChild);

            $(body).find('easyui\\:script,script,link,img,a').each(function () {
                var node = this;
                if (node[originalHref]) {
                    node.setAttribute('href', node[originalHref]);
                    node.removeAttribute(originalHref);
                }
                if (node[originalSrc]) {
                    node.setAttribute('src', node[originalSrc]);
                    node.removeAttribute(originalSrc);
                }
            });
        } else {
            body.innerHTML = html;
            if ($.browser.msie) {
                // having unicode characters creates denormalized DOM tree in IE9
                normalize(body);
            }
        }
        
        this.selectionRestorePoint = null;
        this.update();
    },

    focus: function () {
        this.window.focus();
    },

    update: function (value) {
        this.textarea.value = value || this.encoded ? this.encodedValue() : this.value();
    },

    encodedValue: function () {
        return dom.encode(this.value());
    },

    createRange: function (document) {
        return createRange(document || this.document);
    },

    getSelection: function () {
        return selectionFromDocument(this.document);
    },
        
    selectRange: function(range) {
        this.focus();
        var selection = this.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
    },

    getRange: function () {
        var selection = this.getSelection();
        var range = selection.rangeCount > 0 ? selection.getRangeAt(0) : this.createRange();

        if (range.startContainer == this.document && range.endContainer == this.document && range.startOffset == 0 && range.endOffset == 0) {
            range.setStart(this.body, 0);
            range.collapse(true);
        }

        return range;
    },

    selectedHtml: function() {
        return domToXhtml(this.getRange().cloneContents());
    },
    
    paste: function (html) {
        this.clipboard.paste(html);
    },

    exec: function (name, params) {
        var range, body, id, tool = '';

        name = name.toLowerCase();

        // restore selection
        if (!this.keyboard.typingInProgress()) {
            this.focus();

            range = this.getRange();
            body = this.document.body;
        }

        // exec tool
        for (id in this.tools)
            if (id.toLowerCase() == name) {
                tool = this.tools[id];
                break;
            }

        if (tool) {
            range = this.getRange();

            if (!/undo|redo/i.test(name) && tool.willDelayExecution(range)) {
                this.pendingFormats.toggle({ name: name, params: params, command: tool.command });
                selectionChanged(this);
                return;
            }

            var command = tool.command ? tool.command($.extend({ range: range }, params)) : null;

            $t.trigger(this.element, 'execute', { name: name, command: command });

            if (/undo|redo/i.test(name)) {
                this.undoRedoStack[name]();
            } else if (command) {
                if (!command.managesUndoRedo) {
                    this.undoRedoStack.push(command);
                }
                    
                command.editor = this;
                command.exec();

                if (command.async) {
                    command.change = $.proxy(function () { selectionChanged(this); }, this);
                    return;
                }
            }

            selectionChanged(this);
        }
    }
}

$.fn.tEditor = function (options) {
    return $t.create(this, {
        name: 'tEditor',
        init: function (element, options) {
            return new $t.editor(element, options);
        },
        options: options
    });
}

var formats = {
    bold: [
        { tags: ['strong'] },
        { tags: ['span'], attr: { style: { fontWeight: 'bold'}} }
    ],

    italic: [
        { tags: ['em'] },
        { tags: ['span'], attr: { style: { fontStyle: 'italic'}} }
    ],

    underline: [{ tags: ['span'], attr: { style: { textDecoration: 'underline'}}}],

    strikethrough: [
        { tags: ['del'] },
        { tags: ['span'], attr: { style: { textDecoration: 'line-through'}} }
    ],
    
    justifyLeft: [
        { tags: blockElements, attr: { style: { textAlign: 'left'}} },
        { tags: ['img'], attr: { style: { 'float': 'left'}} }
    ],

    justifyCenter: [
        { tags: blockElements, attr: { style: { textAlign: 'center'}} },
        { tags: ['img'], attr: { style: { display: 'block', marginLeft: 'auto', marginRight: 'auto'}} }
    ],

    justifyRight: [
        { tags: blockElements, attr: { style: { textAlign: 'right'}} },
        { tags: ['img'], attr: { style: { 'float': 'right'}} }
    ],

    justifyFull: [
        { tags: blockElements, attr: { style: { textAlign: 'justify'}} }
    ]
};

function formatByName(name, format) {
    for (var i = 0; i < format.length; i++)
        if ($.inArray(name, format[i].tags) >= 0)
            return format[i];
}

function Tool(options) {
    $.extend(this, options);

    this.init = function($ui, options) {
        $ui.attr({ unselectable: 'on', title: options.title });
    }

    this.command = function (commandArguments) {
        return new options.command(commandArguments);
    }

    this.update = function() {
    }

    this.willDelayExecution = function() {
        return false;
    }
}

Tool.exec = function (editor, name, value) {
    editor.exec(name, { value: value });
}

function FormatTool(options) {
    Tool.call(this, options);

    this.command = function (commandArguments) {
        return new FormatCommand($.extend(commandArguments, {
                formatter: options.formatter
            }));
    }

    this.update = function($ui, nodes, pendingFormats) {
        var isPending = pendingFormats.isPending(this.name),
            isFormatted = options.finder.isFormatted(nodes),
            isActive = isPending ? !isFormatted : isFormatted;

        $ui.toggleClass('t-state-active', isActive);
    }
}

var emptyFinder = function () { return { isFormatted: function () { return false } } };

var localization = {
    bold: 'Bold',
    italic: 'Italic',
    underline: 'Underline',
    strikethrough: 'Strikethrough',
    justifyCenter: 'Center text',
    justifyLeft: 'Align text left',
    justifyRight: 'Align text right',
    justifyFull: 'Justify',
    insertUnorderedList: 'Insert unordered list',
    insertOrderedList: 'Insert ordered list',
    indent: 'Indent',
    outdent: 'Outdent',
    createLink: 'Insert hyperlink',
    unlink: 'Remove hyperlink',
    insertImage: 'Insert image',
    insertHtml: 'Insert HTML',
    fontName: 'Select font family',
    fontNameInherit: '(inherited font)',
    fontSize: 'Select font size',
    fontSizeInherit: '(inherited size)',
    formatBlock: 'Format',
    style: 'Styles',
    emptyFolder: 'Empty Folder',
    uploadFile: 'Upload',
    orderBy: 'Arrange by:',
    orderBySize: 'Size',
    orderByName: 'Name',
    invalidFileType: "The selected file \"{0}\" is not valid. Supported file types are {1}.",
    deleteFile: 'Are you sure you want to delete "{0}"?',
    overwriteFile: 'A file with name "{0}" already exists in the current directory. Do you want to overwrite it?',
    directoryNotFound: 'A directory with this name was not found.'
};

$.fn.tEditor.defaults = {
    localization: localization,
    formats: formats,
    encoded: true,
    stylesheets: [],
    dialogOptions: {
        modal: true, resizable: false, draggable: true,
        effects: {list:[{name:'toggle'}]}
    },
    fontName: [
        { Text: localization.fontNameInherit,  Value: 'inherit' },
        { Text: 'Arial', Value: "Arial,Helvetica,sans-serif" },
        { Text: 'Courier New', Value: "'Courier New',Courier,monospace" },
        { Text: 'Georgia', Value: "Georgia,serif" },
        { Text: 'Impact', Value: "Impact,Charcoal,sans-serif" },
        { Text: 'Lucida Console', Value: "'Lucida Console',Monaco,monospace" },
        { Text: 'Tahoma', Value: "Tahoma,Geneva,sans-serif" },
        { Text: 'Times New Roman', Value: "'Times New Roman',Times,serif" },
        { Text: 'Trebuchet MS', Value: "'Trebuchet MS',Helvetica,sans-serif" },
        { Text: 'Verdana', Value: "Verdana,Geneva,sans-serif" }
    ],
    fontSize: [
        { Text: localization.fontSizeInherit,  Value: 'inherit' },
        { Text: '1 (8pt)',  Value: 'xx-small' },
        { Text: '2 (10pt)', Value: 'x-small' },
        { Text: '3 (12pt)', Value: 'small' },
        { Text: '4 (14pt)', Value: 'medium' },
        { Text: '5 (18pt)', Value: 'large' },
        { Text: '6 (24pt)', Value: 'x-large' },
        { Text: '7 (36pt)', Value: 'xx-large' }
    ],
    formatBlock: [
        { Text: 'Paragraph', Value: 'p' },
        { Text: 'Quotation', Value: 'blockquote' },
        { Text: 'Heading 1', Value: 'h1' },
        { Text: 'Heading 2', Value: 'h2' },
        { Text: 'Heading 3', Value: 'h3' },
        { Text: 'Heading 4', Value: 'h4' },
        { Text: 'Heading 5', Value: 'h5' },
        { Text: 'Heading 6', Value: 'h6' }
    ],
    tools: {
        bold: new InlineFormatTool({ key: 'B', ctrl: true, format: formats.bold}),
        italic: new InlineFormatTool({ key: 'I', ctrl: true, format: formats.italic}),
        underline: new InlineFormatTool({ key: 'U', ctrl: true, format: formats.underline}),
        strikethrough: new InlineFormatTool({format: formats.strikethrough}),
        undo: { key: 'Z', ctrl: true },
        redo: { key: 'Y', ctrl: true },
        insertLineBreak: new Tool({ key: 13, shift: true, command: NewLineCommand }),
        insertParagraph: new Tool({ key: 13, command: ParagraphCommand }),
        justifyCenter: new BlockFormatTool({format: formats.justifyCenter}),
        justifyLeft: new BlockFormatTool({format: formats.justifyLeft}),
        justifyRight: new BlockFormatTool({format: formats.justifyRight}),
        justifyFull: new BlockFormatTool({format: formats.justifyFull}),
        insertUnorderedList: new ListTool({tag:'ul'}),
        insertOrderedList: new ListTool({tag:'ol'}),
        createLink: new Tool({ key: 'K', ctrl: true, command: LinkCommand}),
        unlink: new UnlinkTool({ key: 'K', ctrl: true, shift: true}),
        insertImage: new Tool({ command: ImageCommand }),
        indent: new Tool({ command: IndentCommand }),
        outdent: new OutdentTool(),
        insertHtml: new InsertHtmlTool(),
        style: new StyleTool(),
        fontName: new FontTool({cssAttr:'font-family', domAttr: 'fontFamily', name:'fontName'}),
        fontSize: new FontTool({cssAttr:'font-size', domAttr:'fontSize', name:'fontSize'}),
        formatBlock: new FormatBlockTool(),
        foreColor: new ColorTool({cssAttr:'color', domAttr:'color', name:'foreColor'}),
        backColor: new ColorTool({cssAttr:'background-color', domAttr: 'backgroundColor', name:'backColor'})
    }
}


})(jQuery);
