'use strict'

angular.module('sequencingApp').controller 'VectorCtrl', ['$scope', 'Vector', 'SequencingConst', 'Modal', ($scope, Vector, SequencingConst, Modal) ->
  $scope.record = Modal.record
  $scope.save = ->
    if $scope.record.id
      Vector.update $scope.record
    else
      Vector.create $scope.record, (data)->
        $scope.$close data
  null
]
