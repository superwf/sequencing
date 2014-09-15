'use strict'
angular.module('sequencingApp').controller 'OrderCtrl', ['$scope', 'Order', 'SequencingConst', '$routeParams', 'Modal', '$modal', 'BoardHead', 'Client', ($scope, Order, SequencingConst, $routeParams, Modal, $modal, BoardHead, Client) ->
  $scope.transportCondition = SequencingConst.transportCondition
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.sample_heads = data
    if data.length == 0
      $rootScope.$broadcast 'event:notacceptable', {hint: 'sample_head not_exist'}
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Order.get id: $routeParams.id
  $scope.$watch 'record.sample_head', ()->
    if $scope.record.sample_head
      $scope.cols = $scope.record.sample_head.cols.split(',')
      $scope.rows = $scope.record.sample_head.rows.split(',')

  $scope.selectClient = ->
    Modal.resource = Client
    modal = $modal.open {
      templateUrl: '/views/clients.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.record.client = data.name
      $scope.record.client_id = data.id
      null

  $scope.save = ->
    console.log $scope.sample_head
    #if $scope.record.id
    #  Order.update $scope.record
    #else
    #  Order.create $scope.record, (data)->
    #    $scope.record = data
  null
]
