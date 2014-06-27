(function() {
  App.service('ErrorService', function() {
    return {
      fullMessages: function(response) {
        var field, msgs, value, _ref;
        msgs = [];
        _ref = response.data.errors;
        for (field in _ref) {
          value = _ref[field];
          msgs.push("" + field + " " + value[0]);
        }
        return msgs;
      }
    };
  });

}).call(this);
