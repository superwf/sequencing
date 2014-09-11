'use strict'

angular.module('sequencingApp').controller 'PrimersCtrl', ['$scope', 'Primer', 'Modal', '$modal', 'SequencingConst', ($scope, Primer, Modal, $modal, SequencingConst) ->
  Primer.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    Primer.delete {id: id}
    $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/primer.html'
      controller: 'PrimerCtrl'
    }
]
