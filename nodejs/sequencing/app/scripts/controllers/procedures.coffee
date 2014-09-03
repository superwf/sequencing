'use strict'

angular.module('sequencingApp').controller 'ProceduresCtrl', ['$scope', 'Procedure', ($scope, Procedure) ->
  Procedure.query (data) ->
    $scope.records = data
    return
  $scope.ny = {true: 'yes', false: 'no'}
  $scope.type = {sample: 'sample', reaction: 'reaction'}
 
  $scope.delete = (id, index)->
    Procedure.delete {id: id}
    $scope.records.splice index, 1
]
