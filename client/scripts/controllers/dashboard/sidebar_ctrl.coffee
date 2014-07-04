App.controller 'SidebarCtrl', ($scope, AccountService) ->

  $scope.admin = ->
    AccountService.current.admin