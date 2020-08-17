<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

	<h3><a href="http://twitter.com/" class="twitter-icon"></a> Search</h3>

	<label for="searchText">See what people are saying about&#8230;</label>
	<input type="text" id="searchText" value="#aspnetmvc" /><a href="#" id="searchButton">search</a>

	<%: Html.EasyUI().Grid<TwitterItem>()
            .Name("Grid")
            .Columns(columns =>
            {
                columns.Template(o => { }).Title("Author").Width(100);
                columns.Template(o => { }).Title("Avatar").Width(80);
                columns.Bound(o => o.text).Title("Post");
            })
            .ClientEvents(events => events
                .OnDataBinding("onDataBinding")
                .OnRowDataBound("onRowDataBound")
            )
            .Scrollable(scrolling=>scrolling.Height(400))
    %>
    <%
        Html.EasyUI().ScriptRegistrar()
            .OnDocumentReady(() =>
            {
                %>
                    $('#searchButton').click(function(e) {
                        e.preventDefault();
                        $('#Grid').data('tGrid').ajaxRequest();
                    });
                    $('#searchText').keydown(function(e) {
                        if (e.keyCode == 13)
                            $('#searchButton').trigger('click');
                        });
                <%
                    });
        %>

<script type="text/javascript">
    function onRowDataBound(e) {
        var row = e.row;
        var dataItem = e.dataItem;
        
        // update `Author` cell with template
        row.cells[0].innerHTML = [
            '<a class="t-link" href="http://www.twitter.com/', dataItem.from_user, '">',
            dataItem.from_user,
            '</a>'
        ].join('');

        // update `Avatar` cell with template
        row.cells[1].innerHTML = [
            '<img width="48" height="48"',
            ' src="', dataItem.profile_image_url,
            '" alt="', dataItem.from_user, '" />'
            ].join('');
    }

    function onDataBinding(e) {
        var grid = $(this).data('tGrid');
        
        $('.t-status .t-icon', grid.element).addClass('t-loading');

        // call the twitter search api
        $.ajax({
            url: 'http://search.twitter.com/search.json',
            contentType: 'application/json; charset=utf-8',
            type: 'GET',
            dataType: 'jsonp',
            error: function(xhr, status) {
                alert(status);
            },
            data: {
                q: $('#searchText').val()
            },
            success: function(result) {
                grid.dataBind(result.results);
                $('.t-status .t-icon', grid.element).removeClass('t-loading');
            }
        });
    }
</script>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .twitter-icon
        {
            background: url('<%: ResolveUrl("~/Content/Grid/ExternalServiceTwitter/twitter-logo.png") %>') no-repeat 0 0;
            width: 100px;
            height: 25px;
            line-height: 25px;
            display: inline-block;
            vertical-align: top;
            margin-top: -6px;
        }
        label
        {
            display: block;
            padding-bottom: 3px;
        }
        #searchText, #searchButton
        {
            padding: 8px 10px;
            font-size: 16px;
            border: 1px solid #aaa;
            color: #333;
            display: inline-block; *display:inline;zoom:1;vertical-align:top;margin-bottom:30px;height:18px;line-height:18px;}
        #searchText
        {
            width: 330px;
            -moz-border-radius: 5px 0 0 5px;
            -webkit-border-radius: 5px 0 0 5px;
            border-radius: 5px 0 0 5px;
            border-right: 0;
        }
        #searchButton
        {
            -moz-border-radius: 0 5px 5px 0;
            -webkit-border-radius: 0 5px 5px 0;
            border-radius: 0 5px 5px 0;
            background: #bbb;
            text-shadow: 0 1px 0 #fff;
            text-decoration: none;
            color: #333;
        }
        #searchButton:hover, #searchButton:focus
        {
            color: #111;
        }
    </style>
</asp:content>
