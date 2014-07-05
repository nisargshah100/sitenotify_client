App.controller 'SettingsCtrl', ($scope, $modal, Restangular, AccountService, $cookies) ->
  $scope.inviteSentUser = {}

  $scope.setup = ->
    $scope.$on 'new_account', =>
      AccountService.fetchMembers()
      AccountService.fetchInvites()

  $scope.canAccess = ->
    AccountService.current.admin

  $scope.account = ->
    AccountService.current

  $scope.inviteNewMemberDialog = ->
    m = $modal.open(
      templateUrl: "newMemberModal"
      controller: 'newMemberModalCtrl'
    )
    m.result.then (data) ->
      $scope.inviteSentUser.data = data
      AccountService.fetchInvites()

App.controller 'settingsGeneralCtrl', ($scope, AccountService) ->
  $scope.account = AccountService.current

App.controller 'settingsMemberCtrl', ($scope, AccountService, Restangular, UserService) ->

  $scope.setup = ->
    AccountService.fetchMembers()

  $scope.members = ->
    AccountService.currentAccountMembers

  $scope.revokeAccess = (user_acc) ->
    Restangular.one('accounts', user_acc.account_id).customPOST({ user_id: user_acc.user.id }, 'revoke_access').then (data) ->
      AccountService.fetchMembers()

  $scope.enableAccess = (user_acc) ->
    Restangular.one('accounts', user_acc.account_id).customPOST({ user_id: user_acc.user.id }, 'enable_access').then (data) ->
      AccountService.fetchMembers()

  $scope.removeAccess = (user_acc) ->
    Restangular.one('accounts', user_acc.account_id).customPOST({ user_id: user_acc.user.id }, 'remove_access').then (data) ->
      AccountService.fetchMembers()

  $scope.setAdmin = (user_acc) ->
    Restangular.one('accounts', user_acc.account_id).customPOST({ user_id: user_acc.user.id, admin: user_acc.admin }, 'set_admin').then (data) ->
      AccountService.fetchMembers()

App.controller 'settingsInviteCtrl', ($scope, AccountService, Restangular) ->

  $scope.setup = ->
    AccountService.fetchInvites()

  $scope.invites = ->
    AccountService.currentAccountInvites

  $scope.setInviteAdmin = (invite) ->
    invite.put().then ->
      AccountService.fetchInvites()

  $scope.remove = (invite) ->
    invite.remove().then ->
      AccountService.fetchInvites()

  $scope.resendDisabled = (invite) ->
    invite.invites_sent >= 3

  $scope.resend = (invite) ->
    invite.customPOST({}, 'resend').then (data) ->
      if data
        $scope.inviteSentUser.data = invite
        AccountService.fetchInvites()
      else
        alert('Unable to send invite')


App.controller 'newMemberModalCtrl', ($scope, $modalInstance, Restangular, AccountService, ErrorService) ->
  $scope.user = {}
  $scope.errors = null

  $scope.ok = ->
    Restangular.one('accounts', AccountService.current.id).all('account_invites').post($scope.user).then(
      (data) =>
        $modalInstance.close $scope.user

      (err) => 
        $scope.errors = ErrorService.fullMessages(err)
    )

  $scope.cancel = ->
    $modalInstance.dismiss "cancel"
    return