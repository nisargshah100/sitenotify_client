App.config (RestangularProvider, $httpProvider) ->
  # RestangularProvider.setBaseUrl('http://server.sitenotify.dev/api')
  RestangularProvider.setBaseUrl('http://107.170.92.102/api')

App.run (Restangular, $state) ->
  Restangular.setErrorInterceptor (response, deferred, responseHandler) ->
    if response.status not in [422, 401, 404]
      alert 'Unable to process this request'
      return false

    if response.status == 401
      $state.go('special.login')
      return false

    if response.status == 404
      alert 'Unable to contact server. Make sure your internet connection is fine.'
      return false

    return true