'use strict'

angular.module('sequencingApp').controller 'VectorCtrl', ['$scope', 'Vector', 'SequencingConst', '$routeParams', 'Modal', ($scope, Vector, SequencingConst, $routeParams, Modal) ->
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Vector.get id: $routeParams.id

  $scope.save = ->
    if $scope.record.id
      Vector.update $scope.record
    else
      Vector.create $scope.record, (data)->
        $scope.record = data
  null
]
