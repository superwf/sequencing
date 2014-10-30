'use strict'
angular.module('sequencingApp').controller 'ClientsCtrl', ['$scope', 'Client', '$modal', 'Modal', ($scope, Client, $modal, Modal) ->
  $scope.inModal = !!$scope.$close
  if !$scope.inModal
    $scope.$emit 'event:title', 'client'
  $scope.searcher = {}
  $scope.search = ->
    Client.query $scope.searcher, (data) ->
      $scope.records = data.records || []
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    Client.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    $modal.open {
      templateUrl: '/views/client.html'
      controller: 'ClientCtrl'
    }

  $scope.create = ->
    Modal.record = {}
    $modal.open {
      templateUrl: '/views/client.html'
      controller: 'ClientCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record
  null
]
