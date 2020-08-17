<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">
   
    <% Html.EasyUI().Editor()
           .Name("Editor")
           .Value(() =>
           { %>
                &lt;p&gt;&nbsp;
                    &lt;img src=&quot;<%: Url.Content("~/Content/Editor/editor.png") %>&quot;
                            alt=&quot;Editor for ASP.NET MVC logo&quot;
                            style=&quot;display:block;margin-left:auto;margin-right:auto;&quot; /&gt;

                    EasyUI Editor for ASP.NET MVC allows your users to edit HTML in a familiar,
                    user-friendly way.&lt;br /&gt;
                    In this version, the Editor provides the core HTML editing engine, which includes
                    basic text formatting, hyperlinks, lists, and image handling.
                    The extension &lt;strong&gt;outputs identical HTML&lt;/strong&gt;
                    across all major browsers, follows accessibility standards
                    and provides an extended programming API for content manipulation.
                &lt;/p&gt;

                &lt;p&gt;Features include:&lt;/p&gt;

                &lt;ul&gt;
                    &lt;li&gt;Text formatting &amp; alignment&lt;/li&gt;
                    &lt;li&gt;Bulleted and numbered lists&lt;/li&gt;
                    &lt;li&gt;Hyperlink and image dialogs&lt;/li&gt;
                    &lt;li&gt;Cross-browser support&lt;/li&gt;
                    &lt;li&gt;Identical HTML output across browsers&lt;/li&gt;
                    &lt;li&gt;Gracefully degrades to a &lt;code&gt;textarea&lt;/code&gt;
                              when JavaScript is turned off&lt;/li&gt;
                &lt;/ul&gt;

                &lt;p&gt;
                    Read &lt;a href=&quot;http://www.easyui.com/products/aspnet-mvc/editor.aspx&quot;&gt;more details&lt;/a&gt;
                    or send us your
                    &lt;a href=&quot;http://www.easyui.com/community/forums/aspnet-mvc.aspx&quot;&gt;feedback&lt;/a&gt;!
                &lt;/p&gt;
           <% }).Render();
    %>

    <script type="text/javascript">

        function selectAll() {
            var editor = $("#Editor").data("tEditor");

            var range = editor.createRange();
            range.selectNodeContents(editor.body);
            editor.focus();
            editor.selectRange(range);
        }

        function textBold() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("bold");
        }

        function textItalic() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("italic");
        }

        function textUnderline() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("underline");
        }

        function textStrikethrough() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("strikethrough");
        }

        function textJustifyLeft() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("justifyleft");
        }

        function textJustifyCenter() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("justifycenter");
        }

        function textJustifyRight() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("justifyright");
        }

        function textJustifyFull() {
            var editor = $("#Editor").data("tEditor");

            editor.focus();
            editor.exec("justifyfull");
        }

        function textForeColor()
        {
            var editor = $("#Editor").data("tEditor");

            editor.focus();

            editor.exec("foreColor", { value: $("#TextBoxColor").val() });
        }

    </script>

    <% using ( Html.Configurator("Editor client API")
                   .Begin() )
       { %>

        <ul class="funtionList">
            <li>
                <button class="t-button" onclick="selectAll()">
                    Select All</button>
            </li>
            <li>
                <button class="t-button" onclick="textBold()">
                    Bold</button>
            </li>
            <li>
                <button class="t-button" onclick="textItalic()">
                    Italic</button>
            </li>
            <li>
                <button class="t-button" onclick="textUnderline()">
                    Underline</button>
            </li>
            <li>
                <button class="t-button" onclick="textStrikethrough()">
                    Strikethrough</button>
            </li>
        </ul>

        <ul class="funtionList">
            <li>
                <button class="t-button" onclick="textJustifyLeft()">
                    Justify left</button>
            </li>
            <li>
                <button class="t-button" onclick="textJustifyCenter()">
                    Justify center</button>
            </li>
            <li>
                <button class="t-button" onclick="textJustifyRight()">
                    Justify right</button>
            </li>
            <li>
                <button class="t-button" onclick="textJustifyFull()">
                    Justify full</button>
            </li>
        </ul>

        <ul class="funtionList">
            <li>
                <input type="text" id="TextBoxColor" title="" />
                <button class="t-button" onclick="textForeColor()">
                        Change Fore Color</button>
            </li>
        </ul>

     <% } %>

    <h3>Generated HTML:</h3>

    <button onclick="$('#generated-markup').val($('#Editor').data('tEditor').value());">Get HTML</button>
    <button onclick="$('#Editor').data('tEditor').value($('#generated-markup').val());" style="float: right;">Set HTML</button><br />
    <textarea id="generated-markup" rows="10" cols="80" title="generated-markup" style="width:884px;"></textarea>

    <% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() =>
       { 
           %>
                window.editor = $('#Editor').data('tEditor');

                $('#Editor').bind('selectionChange', function() {
                    $('#generated-markup').val(editor.value());
                });
           <%
        }); %>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    
    <style type="text/css">
        .funtionList li {
            margin-left: 2px;
            padding:.5em;
            list-style: none;
            display: inline;
        }
        
        #generated-markup
        {
            font: normal 12px Consolas,Courier New,monospace;
        }
        
        .configurator .t-button
        {
            margin: 0 0 1em;
            display: inline-block;
            *display: inline;
            zoom: 1;
            width: auto;
            min-width: 6em;
        }
    </style>

</asp:content>