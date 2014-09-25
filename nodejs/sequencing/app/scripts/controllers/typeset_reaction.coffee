'use strict'

angular.module('sequencingApp').controller 'TypesetReactionCtrl', ['$scope', 'Vector', 'SequencingConst', '$routeParams', 'Modal', ($scope, Vector, SequencingConst, $routeParams, Modal) ->
  $scope.record = Modal.record
  $scope.save = ->
    if $scope.record.id
      Vector.update $scope.record
    else
      Vector.create $scope.record, (data)->
        $scope.$close data
  null
]
