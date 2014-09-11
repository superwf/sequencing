'use strict'

angular.module('sequencingApp').controller 'PrimerCtrl', ['$scope', 'Primer', '$routeParams', 'Modal', '$modal', 'SequencingConst', 'Client', '$rootScope', 'PrimerBoard', 'PrimerHead', ($scope, Primer, $routeParams, Modal, $modal, SequencingConst, Client, $rootScope, PrimerBoard, PrimerHead) ->
  $scope.storeType = SequencingConst.primerStoreType
  PrimerHead.query (data)->
    $scope.primer_heads = data.records
    if data.records.length == 0
      $rootScope.$broadcast 'event:notacceptable', {error: 'noexist', field: 'primer_head'}
      return $location.path '/primerHeads/new'
    else
      $scope.primer_head = data.records[0]
  if $routeParams.id == 'new'
    $scope.status = SequencingConst.primerNewStatus
    $scope.record = {status: 'ok', store_type: '90days', need_return: false, origin_thickness: '5'}
  else
    $scope.newStatus = SequencingConst.primerStatus
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Primer.get id: $routeParams.id

  $scope.save = ->
    record = SequencingConst.copyWithDate($scope.record, 'receive_date')
    if $scope.record.id > 0
      Primer.update record
    else
      Primer.create record, (data)->
        $scope.record = data

  $scope.selectClient = ->
    Modal.resource = Client
    Modal.modal = $modal.open {
      templateUrl: '/views/clients.html'
      controller: 'ModalCtrl'
    }

  $scope.selectBoard = ->
    Modal.resource = PrimerBoard
    Modal.modal = $modal.open {
      templateUrl: '/views/primerBoards.html'
      controller: 'ModalCtrl'
    }

  $rootScope.$on 'modal:clicked', (v, data)->
    if Modal.resource == Client
      $scope.record.client = data.name
      $scope.record.client_id = data.id
    if Modal.resource == PrimerBoard
      $scope.record.primer_board = data.name
      $scope.record.primer_board_id = data.id
  null
]
