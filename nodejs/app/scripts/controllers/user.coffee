'use strict'
angular.module('sequencingApp').controller 'UserCtrl', ['$scope', 'me', 'User', ($scope, me, User)->
  $scope.user = {}
  $scope.updatePassword = ->
    if !$scope.user.password
      $scope.error = 'password_length_error'
      return
    if $scope.user.password != $scope.user.confirm_password
      $scope.error = 'password_confirm_error'
      return
    User.updatePassword $scope.user, ->
      $scope.$close()
    return
  return
]
