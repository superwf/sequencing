'use strict'

angular.module('sequencingApp').controller 'VectorsCtrl', ['$scope', 'Vector', 'Modal', '$modal', ($scope, Vector, Modal, $modal) ->
  $scope.$emit 'event:title', 'vector'

  $scope.inModal = !!$scope.$close

  $scope.searcher = {}

  $scope.search = ->
    Vector.query $scope.searcher, (data) ->
      $scope.records = data.records || []
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null

  $scope.search()
  $scope.$watch 'searcher.name', (name)->
    if name
      $scope.search()
 
  $scope.delete = (id, index)->
    Vector.delete {id: id}, ->
      $scope.records.splice index, 1

  $scope.create = ->
    Modal.record = {}
    $modal.open {
      templateUrl: '/views/vector.html'
      controller: 'VectorCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/vector.html'
      controller: 'VectorCtrl'
    }
]
