App.filter 'formattedDateTime', ->
  (input, format) ->
    format ||= 'MM/DD/YYYY [at] h:mm a'
    moment(input).format(format)