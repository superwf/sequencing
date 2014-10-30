'use strict'
angular.module('sequencingApp').controller 'HomeCtrl', ['$scope', 'User', ($scope, User) ->
  $scope.$emit 'event:title', 'sequencing'
  null
]
