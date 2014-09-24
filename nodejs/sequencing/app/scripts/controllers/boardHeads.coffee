'use strict'

angular.module('sequencingApp').controller 'BoardHeadsCtrl', ['$scope', 'BoardHead', '$modal', 'Modal', ($scope, BoardHead, $modal, Modal) ->
  $scope.searcher = {}
  $scope.search = ->
    BoardHead.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    BoardHead.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.create = ->
    Modal.record = {with_date: true, available: true}
    $modal.open {
      templateUrl: '/views/boardHead.html'
      controller: 'BoardHeadCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/boardHead.html'
      controller: 'BoardHeadCtrl'
    }
  null
]
