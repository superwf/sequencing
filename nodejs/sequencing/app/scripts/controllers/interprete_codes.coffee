'use strict'
angular.module('sequencingApp').controller 'InterpreteCodesCtrl', ['$scope', 'InterpreteCode', 'Modal', '$modal', ($scope, InterpreteCode, Modal, $modal) ->
  InterpreteCode.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    InterpreteCode.delete {id: id}
    $scope.records.splice index, 1

  $scope.create = ->
    Modal.record = {}
    $modal.open {
      templateUrl: '/views/interpreteCode.html'
      controller: 'InterpreteCodeCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/InterpreteCode.html'
      controller: 'InterpreteCodeCtrl'
    }
]
