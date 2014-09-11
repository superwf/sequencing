'use strict'

angular.module('sequencingApp').controller 'PrimerHeadsCtrl', ['$scope', 'PrimerHead', '$modal', 'Modal', ($scope, PrimerHead, $modal, Modal) ->
  $scope.searcher = {}
  $scope.search = ->
    PrimerHead.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    PrimerHead.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/primerHead.html'
      controller: 'PrimerHeadCtrl'
    }
  null
]
