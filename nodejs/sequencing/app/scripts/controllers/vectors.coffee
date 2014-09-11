'use strict'

angular.module('sequencingApp').controller 'VectorsCtrl', ['$scope', 'Vector', 'Modal', '$modal', ($scope, Vector, Modal, $modal) ->
  Vector.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    Vector.delete {id: id}
    $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/vector.html'
      controller: 'VectorCtrl'
    }
]
