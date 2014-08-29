'use strict'
angular.module('sequencingApp').controller 'LoginCtrl', ['$scope', 'Security', '$rootScope', ($scope, Security, $rootScope) ->
  $scope.user = {}

  $scope.login = ->
    $scope.authError = null
    Security.login($scope.user).success (data)->
      $rootScope.$broadcast 'event:authorized', data
      Security.cancel()
    .error (e)->
      $scope.authError = e.error
      null
  $scope.cancel= ->
    Security.cancel()
  null
]
