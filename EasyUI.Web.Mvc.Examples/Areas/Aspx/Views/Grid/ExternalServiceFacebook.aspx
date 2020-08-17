<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

<div class="fb-background">
    <div class="introduction">
        <!-- initial screen before connecting to Facebook -->
        <h3>Binding to External Web Service: Facebook</h3>
        <p>
            To view this example, you need to connect with a <strong>Facebook application</strong>,
            which gives us access to your <strong>name and friends list</strong>.
        </p>
        <p>
            <strong>We won't collect your information, nor write on your Wall.</strong><br />
            If you don't take our word for it, you can check the source code below.<br />
        </p>

        <p class="button-area">
            <a href="#" class="fb-connect">Connect to Facebook</a>
        </p>
    
        <div class="loading"></div>
    </div>

    <div class="profile">
        <!-- showing facebook user info and a list of friends -->
        <div id="profile-info">
            Welcome, <span id="fb-name"></span>
            <img src="<%: Url.Content("~/Content/Grid/ExternalServiceFacebook/fb_silhouette.png") %>"
                 id="fb-pic" width="50" height="50" alt="Welcome Screen Facebook" />
        </div>

        <%: Html.EasyUI().Grid<object>()
                .Name("friend-list")
                .Columns(columns =>
                {
                    columns.Template(o => { }).Title("Picture").Width(65);
                    columns.Template(o => { }).Title("Name");
                })
                .ClientEvents(events => events
                    .OnRowDataBound("onRowDataBound")
                    .OnDataBinding("onDataBinding")
                )
                .Pageable()
        %>
    </div>
</div>

<p class="disclaimer">Facebook is a registered trademark of Facebook, Inc.</p>

<script type="text/javascript">
    var appID = '172172924366';

    function onPageLoad() {
        if (window.location.hash.length == 0) {
            // initial screen
            $('.fb-connect').one("click", function(e) { 
                e.preventDefault();

                var path = 'https://www.facebook.com/dialog/oauth?',
                    queryParams = ['client_id=' + appID, 'redirect_uri=' + window.location, 'response_type=token'],
                    query = queryParams.join('&'),
                    url = path + query;

                location.href = url;
            });
        } else {
            window.accessToken = window.location.hash.substring(1);
            
            // assume that page was redirected from facebook
            var path = "https://graph.facebook.com/me?",
                queryParams = [accessToken, 'callback=onUserInfoLoaded'],
                query = queryParams.join('&'),
                url = path + query,
                script = document.createElement('script');
    
            $('.loading').show();

            script.src = url;
            document.body.appendChild(script);
        }
    }
    
    function onUserInfoLoaded(user) {
        $('#fb-name').text(user.name);
        $('#fb-pic').attr("src", "http://graph.facebook.com/" + user.username + "/picture");

        window.user = user;

        // show friends list, page 1
        onDataBinding({ page: 1 });
                
        $('.introduction').hide();
        $('.profile').show();
    }

    function onFriendsDataLoaded(data) {
        var grid = $('#friend-list').data('tGrid');

        data = data.data;

        // necessary for first pager update,
        //  but can be set each time (in case friends are added)
        grid.total = data.length;
        // show the data in the grid
        grid.dataBind(data.slice((page - 1) * 10, page * 10));
    }
    
    function onDataBinding(e) {

        // discard databinding prior to intialization of Graph API
        if (typeof user == "undefined")
            return;

        window.page = e.page;

        // assume that page was redirected from facebook
        var path = "https://graph.facebook.com/me/friends?",
            queryParams = [accessToken, 'callback=onFriendsDataLoaded'],
            query = queryParams.join('&'),
            url = path + query,
            script = document.createElement('script');

        script.src = url;
        document.body.appendChild(script);
    }
    
    function onRowDataBound(e) {
        var row = e.row;
        var dataItem = e.dataItem;
        
        row.cells[0].innerHTML = ['<img src="http://graph.facebook.com/' + dataItem.id + '/picture" width="50" height="50" />'].join('');
        row.cells[1].innerHTML = dataItem['name'];
    }
    
</script>

<div id="loading-overlay"></div>

<% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => {%>onPageLoad();<%}); %>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .fb-background
        {
            background: #cfd6e6 url('<%: Url.Content("~/Content/Grid/ExternalServiceFacebook/background.png") %>') no-repeat 0 0;
            border-bottom: 7px solid #3b5998;
            padding-top: 53px;
            color: #3b5998;
            font-size: 14px;
            line-height: 1.3;
            width: 568px;
            margin: 0 auto;
        }
        
        .introduction
        {
            padding: 40px 50px 35px;
            position: relative;
        }
        
        .button-area
        {
            text-align: right;
            padding-top: 30px;
        }
        
        .fb-connect
        {
            background-image: url('<%: Url.Content("~/Content/Grid/ExternalServiceFacebook/fb_connect.png") %>');
            width: 96px;
            height: 25px;
            text-indent: 9999px;
            white-space: nowrap;
            overflow: hidden;
            outline: none;
            display: inline-block;
            *display: inline;
            zoom: 1;
        }
        
        .loading
        {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: .5;
            display: none;
            background: #fff url('<%: Url.Content("~/Content/Grid/ExternalServiceFacebook/loading.gif") %>') no-repeat 50% 50%;
        }
        
        .profile
        {
            display: none;
        }
        
        #profile-info
        {
            height: 70px;
            position: relative;
            padding: 32px 0 0 93px;
        }
        #fb-name { display: block; font-size: 18px; font-weight: bold; }
        #fb-pic { position: absolute; top: 27px; left: 29px; }
        
        .disclaimer
        {
            font-style: italic;
            width: 568px;
            text-align: center;
            margin: 20px auto 40px;
        }
    </style>
</asp:content>
