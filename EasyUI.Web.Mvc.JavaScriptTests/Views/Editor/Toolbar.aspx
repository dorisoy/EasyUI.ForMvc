<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        var componentType = $.browser.msie ? 'tSelectBox' : 'tComboBox';

        function value($ui) {
            return $.browser.msie ? $.trim($ui.text()) : $ui.val();
        }

        module("Editor / Toolbar", {
            setup: function() {
                window.editor = getEditor();
            }
        });

        test('initially fontName should have "inherit" value', function () {

            var component = $('.t-fontSize', editor.element).data(componentType);

            equal(component.value(), 'inherit');
        });

        test('exec with node parameter calls exec', function() {
            var editor = getEditor();

            var execArgs = [];

            editor.exec = function() { execArgs = arguments; };

            $('.t-bold', editor.element).click();

            equal(execArgs.length, 1);
            equal(execArgs[0], 'bold');
        });

        test('handle carret selection', function() {
            editor.value('<strong>foo</strong>')
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setEnd(editor.body.firstChild.firstChild, 1);

            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            $(editor.element).trigger('selectionChange');

            ok($('.t-bold', editor.element).hasClass('t-state-active'));
        });

        test('handle word selection', function() {
            editor.value('<strong>foo</strong>')
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);

            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            $(editor.element).trigger('selectionChange');

            ok($('.t-bold', editor.element).hasClass('t-state-active'));
        });

        test('handle mixed selection', function() {
            editor.value('<ul><li>foo</li></ul><ul><li>bar</li></ul>')
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild, 1);
            range.setEnd(editor.body.firstChild.firstChild.firstChild, 1);

            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            $(editor.element).trigger('selectionChange');

            ok(!$('t-insertUnorderedList', editor.element).hasClass('t-state-active'));
        });

        test('handle image selection', function() {
            editor.value('<img style="float:right" src="foo" />');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            $(editor.element).trigger('selectionChange');

            ok($('.t-justifyRight', editor.element).hasClass('t-state-active'));
        });

        test('font size combobox on mixed content', function() {
            editor.selectRange(createRangeFromText(editor, '|foo<span style="font-size:8px;">bar|</span>'));

            $(editor.element).trigger('selectionChange');

            equal(value($('.t-fontSize .t-input', editor.element)), '');
        });

        test('font size combobox on custom font size', function() {
            editor.selectRange(createRangeFromText(editor, '<span style="font-size:8px;">f|o|o</span>'));

            $(editor.element).trigger('selectionChange');

            equal(value($('.t-fontSize .t-input', editor.element)), '8px');
        });        
        
        test('inherited font size', function() {
            editor.selectRange(createRangeFromText(editor, '<span>f|o|o</span>'));

            $(editor.element).trigger('selectionChange');

            equal(value($('.t-fontSize .t-input', editor.element)), editor.localization.fontSizeInherit);
        });

        test('font size combobox on relative font size', function() {
            editor.selectRange(createRangeFromText(editor, '<span style="font-size:x-small;">f|o|o</span>'));

            $(editor.element).trigger('selectionChange');

            equal(value($('.t-fontSize .t-input', editor.element)), '2 (10pt)');
        });

        test('clicking disabled links should not navigate', function() {
            var isDefaultPrevented = false,
                navigationListener = function(e) {
                    isDefaultPrevented = e.isDefaultPrevented();
                };

            $(editor.element).bind('click', navigationListener);

            $('.t-editor-button .t-tool-icon.t-state-disabled').trigger('click');

            $(editor.element).unbind('click', navigationListener);

            ok(isDefaultPrevented);
        });

        test('buttons honor to-be-applied pending formats', function() {
            editor.value('foo')
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);

            editor.selectRange(range);

            editor.pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            $(editor.element).trigger('selectionChange');
            
            ok($('.t-bold', editor.element).hasClass('t-state-active'));
        });

        test('buttons honor to-be-removed pending formats', function() {
            editor.value('<strong>foo</strong>')
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.collapse(true);

            editor.selectRange(range);
            
            editor.pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            $(editor.element).trigger('selectionChange');
            
            ok(!$('.t-bold', editor.element).hasClass('t-state-active'));
        });

        test('combos honor to-be-applied pending formats', function() {
            editor.value('foo')
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);

            editor.selectRange(range);

            editor.pendingFormats.toggle({ name: 'fontsize', params: { value: 'xx-large' }, command: editor.tools.fontSize.command });

            $(editor.element).trigger('selectionChange');
            
            equals($('.t-fontSize', editor.element).data(componentType).value(), 'xx-large');
        });

    </script>

</asp:Content>