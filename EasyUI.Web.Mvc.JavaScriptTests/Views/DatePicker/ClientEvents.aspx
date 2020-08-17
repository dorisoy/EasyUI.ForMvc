<%@ Page Title="SingleExpandItem ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<style type="text/css">
                
        .t-state-focus
        {
            border-color: Red !important;
            border-width: 2px !important;
        }
    </style>


    <h2>Client API Tests</h2>
    
   <script type="text/javascript">

       function getDatePicker() {
           return $('#DatePicker').data('tDatePicker');
       }

       function isValidDate(date1, date2) {
           var isValid = true;

           if (date1.getFullYear() != date2.getFullYear())
               isValid = false;
           else if (date1.getMonth() != date2.getMonth())
               isValid = false;
           else if (date1.getDate() != date2.getDate())
               isValid = false;

           return isValid;
       }

       var isChanged;
       var isRaised;
       var callPreventDefault = false;
       var newValue;

       //handlers

       function onChange(e) {
           isChanged = true;

           newValue = $(this).data("tDatePicker").value();

           if (callPreventDefault) {
               e.preventDefault();
           }
       }

       function onClose() {
           isRaised = true;
       }

       function onOpen() {
           isRaised = true;
       }

       var onLoadDatePicker;

       function onLoad() {
           onLoadDatePicker = $(this).data('tDatePicker');
       }
   </script>

 <%= Html.EasyUI().DatePicker().Name("DatePicker")
                   .Effects(e => e.Toggle())
                   .Min(new DateTime(1600, 1,1))
                   .Max(new DateTime(2400, 1, 1))
                   .ClientEvents(events => events.OnLoad("onLoad")
                                                 .OnChange("onChange")
                                                 .OnClose("onClose")
                                                 .OnOpen("onOpen"))
                                                 
 %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



       test('client object is available in on load', function() {
           ok(null !== onLoadDatePicker);
           ok(undefined !== onLoadDatePicker);
       });

       test('value should return selected date', function() {
           getDatePicker().open();

           var $calendar = getDatePicker().dateView.$calendar;

           var today = new Date();

           var days = $calendar.find('td:not(.t-other-month)');

           var day = $.grep(days, function(n) {
               return $('.t-link', n).html() == today.getDate();
           });

           $(day).click();

           ok(isValidDate(today, getDatePicker().value()));
       });
              
       test('focusing input should raise onOpen event', function() {
           var datepicker = getDatePicker();
           datepicker.openOnFocus = true;
           
           var input = $('#DatePicker');

           isRaised = false;

           input.focus();

           datepicker.openOnFocus = false;

           ok(isRaised);
       });

       test('focusing input should not raise onOpen event if openOnFocus is set to false', function () {
           var datepicker = getDatePicker();
           
           datepicker.close();
           
           var input = $('#DatePicker');

           isRaised = false;

           input.focus();

           ok(!isRaised);

           datepicker.openOnFocus = true;
       });

       test('clicking tab should raise onClose', function() {

           getDatePicker().open();

           isRaised = false;
           var input = $('#DatePicker');
           input.trigger({ type: "keydown", keyCode: 9});        

           ok(isRaised);
       });

       test('clicking escape should raise onClose', function() {

           getDatePicker().open();

           isRaised = false;
           
           var input = $('#DatePicker');
           input.trigger({ type: "keydown", keyCode: 27 });

           ok(isRaised);
       });

       test('clicking enter should raise onClose', function() {

           getDatePicker().open();

           isRaised = false;

           var input = $('#DatePicker');
           input.trigger({ type: "keydown", keyCode: 13 });

           ok(isRaised);
       });

       test('change event should not raise if value is set with value() and document is clicked', function () {
           isChanged = false;
           var datepicker = getDatePicker();
           datepicker.value(new Date());

           $(document.documentElement).mousedown();

           ok(!isChanged, "change event was raised incorrectly");
       });

       test('change event should not raise when call min() method', function () {
           isChanged = false;

           var datepicker = getDatePicker();
           datepicker.min(new Date());

           ok(!isChanged, "change event was raised incorrectly");
       });

       test('if defaultPrevented in change event, then old value should be chosen', function () {
           isChanged = false;

           var datepicker = getDatePicker();

           callPreventDefault = true;

           var oldDate = datepicker.value();
           var newDate = new Date();
           newDate.setMonth(newDate.getMonth() + 1);
           datepicker._update(newDate);

           equal(+datepicker.value(), +oldDate);
           
           callPreventDefault = false;
       });

       test('In change event handler, component value should be the new one', function () {
           var datepicker = getDatePicker();

           callPreventDefault = true;

           var newDate = new Date();
           newDate.setMonth(newDate.getMonth() + 2);

           datepicker._update(newDate);

           equal(+newValue, +newDate);

           callPreventDefault = false;
       });

</script>

</asp:Content>