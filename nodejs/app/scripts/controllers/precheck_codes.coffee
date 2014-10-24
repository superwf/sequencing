'use strict'
angular.module('sequencingApp').controller 'PrecheckCodesCtrl', ['$scope', 'PrecheckCode', 'Modal', '$modal', ($scope, PrecheckCode, Modal, $modal) ->
  PrecheckCode.query (data) ->
    $scope.records = data.records || []
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    PrecheckCode.delete {id: id}
    $scope.records.splice index, 1

  $scope.create = ()->
    Modal.record = {available: true, ok: true}
    $modal.open {
      templateUrl: '/views/precheckCode.html'
      controller: 'PrecheckCodeCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    $modal.open {
      templateUrl: '/views/precheckCode.html'
      controller: 'PrecheckCodeCtrl'
    }
]
