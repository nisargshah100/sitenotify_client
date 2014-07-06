App.run (Restangular, $state, DevProdService) ->
  if DevProdService.isDev()
    Restangular.setBaseUrl("http://server.#{DevProdService.host()}/api")
  else
    Restangular.setBaseUrl("http://sitenotify.net/api")

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