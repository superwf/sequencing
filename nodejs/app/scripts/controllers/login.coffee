'use strict'
angular.module('sequencingApp').controller 'LoginCtrl', ['$scope', 'Security', '$rootScope', 'Sequencing', ($scope, Security, $rootScope, Sequencing) ->
  $scope.user = {}
  $scope.login = ->
    $scope.authError = null
    Security.login($scope.user).success (data)->
      Sequencing.getConfig()
      $rootScope.$broadcast 'event:authorized', data
      Security.cancel()
    .error (e)->
      $scope.authError = e.error
      null
  $scope.cancel= ->
    Security.cancel()
  null
]
