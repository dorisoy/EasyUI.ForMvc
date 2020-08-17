function ParagraphCommand(options) {
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
};