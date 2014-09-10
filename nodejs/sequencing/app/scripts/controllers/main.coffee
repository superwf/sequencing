'use strict'
angular.module('sequencingApp').controller 'MainCtrl', ['Security', '$scope', '$rootScope', (Security, $scope, $rootScope)->
  $rootScope.dateOption =
    changeYear: true
    changeMonth: true
    dateFormat: 'yy-mm-dd'
  $rootScope.yesno = {true: 'yes', false: 'no'}

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
