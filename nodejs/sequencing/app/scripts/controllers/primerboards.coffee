'use strict'

angular.module('sequencingApp').controller 'PrimerBoardsCtrl', ['$scope', 'PrimerBoard', '$modal', 'Modal', 'SequencingConst', ($scope, PrimerBoard, $modal, Modal, SequencingConst) ->
  $scope.searcher = {}
  $scope.search = ->
    PrimerBoard.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    PrimerBoard.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/primerBoard.html'
      controller: 'PrimerBoardCtrl'
    }
  null
]
