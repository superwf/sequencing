'use strict'
angular.module('sequencingApp').controller 'ClientsCtrl', ['$scope', 'Client', '$modal', 'Modal', ($scope, Client, $modal, Modal) ->
  $scope.inModal = false
  $scope.searcher = {}
  $scope.search = ->
    Client.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    Client.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/client.html'
      controller: 'ClientCtrl'
    }
  null
]
