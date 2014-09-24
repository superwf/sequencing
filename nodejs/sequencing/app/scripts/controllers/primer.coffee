'use strict'

angular.module('sequencingApp').controller 'PrimerCtrl', ['$scope', 'Primer', '$routeParams', 'Modal', '$modal', 'SequencingConst', 'Client', '$rootScope', 'Board', 'BoardHead', '$location', ($scope, Primer, $routeParams, Modal, $modal, SequencingConst, Client, $rootScope, Board, BoardHead, $location) ->
  $scope.storeType = SequencingConst.primerStoreType
  $scope.board_number = 1
  $scope.obj = {continue: false}
  BoardHead.all {all: true, board_type: 'primer', available: 1}, (data)->
    $scope.primer_heads = data
    if data.length == 0
      $rootScope.$broadcast 'event:notacceptable', {hint: 'primer_head not_exist'}
      #return $location.path '/primerHeads/new'
    else
      $scope.obj.primer_head = data[0]
  if $routeParams.id == 'new'
    $scope.status = SequencingConst.primerNewStatus
    $scope.record = {status: 'ok', store_type: '90days', need_return: false, origin_thickness: '5', create_date: SequencingConst.date2string()}
  else
    $scope.status = SequencingConst.primerStatus
    if Modal.record
      $scope.board_hole = Modal.record.board + ' : ' + Modal.record.hole
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
        if $scope.obj.continue
          $scope.record.name = ''
          $scope.record.id = null
        else
          $scope.record.id = data.id

  $scope.save = ->
    if $scope.board && $scope.board.id
      $scope.record.board_id = $scope.board.id
      save_primer()
    else
      record =
        create_date: $scope.record.create_date
        number: $scope.board_number
        board_head_id: $scope.obj.primer_head.id
      record = SequencingConst.copyWithDate(record, 'create_date')
      Board.create record, (data)->
        $scope.board = data
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
    if $scope.obj.primer_head && $scope.board_number && $scope.record.create_date
      modal = $modal.open {
        templateUrl: '/views/boardHole.html'
        controller: 'BoardHoleCtrl'
        resolve:
          head: ->
            $scope.obj.primer_head
          number: ->
            $scope.board_number
          sn: ->
            if $scope.obj.primer_head.with_date
              $scope.record.create_date.replace(/-/g, '') + '-' + $scope.obj.primer_head.name + $scope.board_number
            else
              $scope.obj.primer_head.name + $scope.board_number
      }
      modal.result.then (data)->
        $scope.record.hole = data.hole
        $scope.record.board = data.sn
        $scope.board = data.board
        $scope.board_hole = data.sn + ' : ' + data.hole
        null

  null
]
