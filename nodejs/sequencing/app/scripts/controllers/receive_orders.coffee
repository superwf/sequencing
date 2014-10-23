'use strict'

angular.module('sequencingApp').controller 'ReceiveOrdersCtrl', ['$scope', 'Order', 'Modal', '$modal', 'ClientReaction', 'Vector', 'Primer', ($scope, Order, Modal, $modal, ClientReaction, Vector, Primer) ->

  getClientReaction = ->
    ClientReaction.query receive: false, (data)->
      $scope.records = data.records || []
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null
    null

  getClientReaction()

  $scope.selectVector = (r)->
    Modal.resource = Vector
    modal = $modal.open {
      templateUrl: '/views/vectors.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      r.vector = data.name
      r.vector_id = data.id
      null
    null

  $scope.selectPrimer = (r)->
    Modal.resource = Primer
    modal = $modal.open {
      templateUrl: '/views/primers.html'
      controller: 'ModalTableCtrl'
      size: 'lg'
      resolve:
        searcher: ->
          {client_id: r.client_id}
    }
    modal.result.then (data)->
      r.primer = data.name
      r.primer_id = data.id
      null
    null

  $scope.vectorErrorClass = {true: 'alert-danger'}
  $scope.primerErrorClass = {true: 'alert-danger'}
  $scope.submit = ->
    records = []
    # validate
    for i, v of $scope.records
      if angular.element('tr.ui-selected[i='+i+']').length
        v.vectorError = false
        v.primerError = false
        if !v.vector_id && v.vector
          v.vectorError = 'true'
          return
        if !v.primer_id
          v.primerError = 'true'
          return
        records.push v
    if records.length
      Order.receive records, ->
        getClientReaction()
        null
    null
  null
]
