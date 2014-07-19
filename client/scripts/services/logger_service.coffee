App.service 'LoggerService', ->

  @logIt = (message, type, timeout) ->
    toastr.options =
      "closeButton": true
      "positionClass": "toast-bottom-right"
      "timeOut": "#{timeout}"

    toastr[type](message)

  @info = (msg, timeout = 3000) -> @logIt(msg, 'info', timeout)
  @warning = (msg, timeout = 3000) -> @logIt(msg, 'warning', timeout)
  @success = (msg, timeout = 3000) -> @logIt(msg, 'success', timeout)
  @error = (msg, timeout = 3000) -> @logIt(msg, 'error', timeout)

  @