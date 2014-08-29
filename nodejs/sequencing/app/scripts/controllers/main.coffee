'use strict'
angular.module('sequencingApp').controller 'MainCtrl', ['Security', '$scope', '$rootScope', (Security, $scope, $rootScope)->
  $scope.title = 'sequencing'
  $scope.$on 'event:unauthorized', ->
    if !Security.modal
      Security.showLogin()
  $scope.$on 'event:authorized', (e, me)->
    $scope.me = me
    me

  Security.requestCurrentUser().then (me)->
    $rootScope.$broadcast 'event:authorized'
    $scope.me = me
    me

  $scope.logout = ->
    Security.logout()
    $rootScope.$broadcast 'event:logout'
    $scope.me = null
    null

  $scope.showLogin = ->
    Security.showLogin()

  null
]
