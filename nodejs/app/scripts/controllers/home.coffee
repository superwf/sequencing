'use strict'
angular.module('sequencingApp').controller 'HomeCtrl', ['$scope', ($scope) ->
  $scope.$emit 'event:title', 'sequencing'
  return
]
