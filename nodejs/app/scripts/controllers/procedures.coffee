'use strict'

angular.module('sequencingApp').controller 'ProceduresCtrl', ['$scope', 'Procedure', 'Modal', '$modal', ($scope, Procedure, Modal, $modal) ->
  Procedure.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
  $scope.ny = {true: 'yes', false: 'no'}
  $scope.type = {sample: 'sample', reaction: 'reaction'}
 
  $scope.delete = (id, index)->
    Procedure.delete {id: id}, ->
      $scope.records.splice index, 1

  $scope.create = ->
    Modal.record = {flow_type: 'sample', board: false}
    $modal.open {
      templateUrl: '/views/procedure.html'
      controller: 'ProcedureCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/procedure.html'
      controller: 'ProcedureCtrl'
    }
]
