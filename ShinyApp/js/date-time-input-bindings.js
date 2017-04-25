(function() {

var dateTimeInputBinding = new Shiny.InputBinding();
$.extend(dateTimeInputBinding, {
      find : function(scope) {
        return $(scope).find(".date-time-input");
      },
      
      initialize : function(el) {
        $(el).find("input").datetimepicker({
                format     : $(el).find("input").attr('data-date-time-format'),
                defaultDate: $(el).find("input").attr('data-initial-date-time'),
                minDate    : $(el).find("input").attr('data-min-date-time'),
                maxDate    : $(el).find("input").attr('data-max-date-time')
        });     
      },
      
      getValue : function(el) {      
        return $(el).find("input").val()
      
      },
      
      setValue : function(el, value) {
          var date = this._newDate(value);
          // If date is invalid, do nothing
          if (isNaN(date))
                return;

          $(el).find('input').data("DateTimePicker").date(date);
      },
      
      subscribe : function(el, callback) {
        $(el).on("dp.change.date-time-input", function(e) {
          callback();
        });
      },
      
      unsubscribe : function(el) {
        $(el).off(".date-time-input");
      },
      
      getType : function() {
        return "shiny.dateTimeInput";
      },
});
Shiny.inputBindings.register(dateTimeInputBinding, "shiny.dateTimeInput");

})();