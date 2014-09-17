'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', ($scope, Board, Modal, $modal) ->
  $scope.searcher = {}
  $scope.search = ->
    Board.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    Board.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/primerBoard.html'
      controller: 'BoardCtrl'
    }
  null
]