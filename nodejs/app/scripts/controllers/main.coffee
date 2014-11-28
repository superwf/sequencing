'use strict'
angular.module('sequencingApp').controller 'MainCtrl', ['Security', '$scope', '$rootScope', 'Sequencing', '$modal', (Security, $scope, $rootScope, Sequencing, $modal)->
  $rootScope.selectDate = ($event, attr)->
    $event.preventDefault()
    $event.stopPropagation()
    this[attr] = true
    return true
  $rootScope.dateOptions =
    formatYear: 'yy'
    startingDay: 1
  $rootScope.dateFormat = 'yyyy-MM-dd'

  $rootScope.yesno = Sequencing.yesno

  $scope.title = 'sequencing'
  $scope.$on 'event:unauthorized', ->
    if !Security.modal
      Security.showLogin()
  $scope.$on 'event:authorized', (e, me)->
    $scope.me = me
    me

  $scope.$on 'event:title', (e, title)->
    $scope.title = title

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

  $scope.editPassword = ->
    $modal.open {
      templateUrl: '/views/editPassword.html'
      controller: 'UserCtrl'
      resolve:
        me: ->
          $scope.me
    }
    return

  null
]
