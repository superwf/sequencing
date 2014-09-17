'use strict'

angular.module('sequencingApp').controller 'PrimerCtrl', ['$scope', 'Primer', '$routeParams', 'Modal', '$modal', 'SequencingConst', 'Client', '$rootScope', 'Board', 'BoardHead', '$location', ($scope, Primer, $routeParams, Modal, $modal, SequencingConst, Client, $rootScope, Board, BoardHead, $location) ->
  $scope.storeType = SequencingConst.primerStoreType
  $scope.board_number = 1
  BoardHead.all {all: true, board_type: 'primer', available: 1}, (data)->
    $scope.primer_heads = data
    if data.length == 0
      $rootScope.$broadcast 'event:notacceptable', {hint: 'primer_head not_exist'}
      #return $location.path '/primerHeads/new'
    else
      $scope.primer_head = data[0]
  if $routeParams.id == 'new'
    $scope.status = SequencingConst.primerNewStatus
    $scope.record = {status: 'ok', store_type: '90days', need_return: false, origin_thickness: '5', create_date: SequencingConst.date2string()}
  else
    $scope.status = SequencingConst.primerStatus
    if Modal.record
      $scope.record = Modal.record
      $scope.record.create_date = SequencingConst.date2string(Modal.record.create_date)
    else
      $scope.record = Primer.get id: $routeParams.id

  save_primer = ->
    record = SequencingConst.copyWithDate($scope.record, 'create_date')
    if $scope.record.id > 0
      Primer.update record
    else
      Primer.create record, (data)->
        if $scope.continue
          $scope.record.name = ''
          $scope.record.id = null
        else
          $scope.record.id = data.id

  $scope.save = ->
    if $scope.primer_board.id
      $scope.record.board_id = $scope.primer_board.id
      save_primer()
    else
      record =
        create_date: $scope.record.create_date
        number: $scope.board_number
        board_head_id: $scope.primer_head.id
      record = SequencingConst.copyWithDate(record, 'create_date')
      Board.create record, (data)->
        $scope.primer_board = data
        $scope.record.board_id = data.id
        save_primer()

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

  $scope.selectBoard = ->
    Modal.resource = Board
    if $scope.primer_head && $scope.board_number && $scope.record.create_date
      modal = $modal.open {
        templateUrl: '/views/boardHole.html'
        controller: 'BoardHoleCtrl'
        resolve:
          head: ->
            $scope.primer_head
          type: ->
            'primer'
          number: ->
            $scope.board_number
          sn: ->
            if $scope.primer_head.with_date
              $scope.record.create_date.replace(/-/g, '') + '-' + $scope.primer_head.name + $scope.board_number
            else
              $scope.primer_head.name + $scope.board_number
      }
      modal.result.then (data)->
        $scope.record.hole = data.hole
        $scope.record.primer_board = data.sn
        $scope.primer_board = data.board
        $scope.board_hole = data.sn + ' : ' + data.hole
        null

  null
]
