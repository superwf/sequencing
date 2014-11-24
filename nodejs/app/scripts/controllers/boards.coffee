'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', '$location', 'Procedure', 'Sequencing', '$routeParams', 'BoardRecord', 'BoardHead', ($scope, Board, Modal, $modal, $location, Procedure, Sequencing, $routeParams, BoardRecord, BoardHead) ->
  $scope.searcher = $location.search()

  $scope.board_status = Sequencing.boardStatus

  uploadOptions = {
    add: (e, data)->
      data.submit()
    success: (f)->
      $scope.$broadcast 'event:uploaded', f
  }

  if $scope.searcher.board_type
    $scope.$emit 'event:title', $scope.searcher.board_type + '_board'
  $scope.search = ->
    Board.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      angular.forEach $scope.records, (record)->
        $scope.$watch ->
          record.status
        , (n, o)->
          if n != o
            Board.update record
          return
        record.board_head = Sequencing.boardHeads[record.board_head_id]
        if record.board_head.board_type == 'sample'
          Board.attachments id: record.id, (data)->
            record.electrophorogram = data
        if !record.board_head.procedures
          BoardHead.procedures id: record.board_head_id, (data)->
            Sequencing.boardHeads[record.board_head_id].procedures = data
            record.board_head.procedurs = data
        record.uploadOptions = {}
        angular.copy(uploadOptions, record.uploadOptions)
        angular.extend(record.uploadOptions, {
          url: Sequencing.api + '/attachments/boards/' + record.id
          success: (f)->
            record.electrophorogram.push f
        })
        if record.procedure_id > 0
          if Sequencing.procedures[record.procedure_id]
            record.procedure = Sequencing.procedures[record.procedure_id]
            abi_record_procedure = null
            abi_record_procedure_id = null
            for i, p of Sequencing.procedures
              if p.record_name == 'abi_records'
                abi_record_procedure_id = i
                abi_record_procedure = p
                break
            if record.procedure.record_name == 'reaction_files'
              BoardRecord.query board_id: record.id, procedure_id: abi_record_procedure_id, (data)->
                if data.records[0]
                  record.abi_record = $scope.$eval(data.records[0].data)
                return
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return

  $scope.search()
 
  $scope.delete = (id, index)->
    Board.delete {id: id}, ()->
      $scope.records.splice index, 1

  $scope.show = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/boardHole.html'
      controller: 'BoardCtrl'
    }

  #$scope.confirm = (board)->
  #  Board.confirm id: board.id, (procedure)->
  #    board.status = 'run'
  #    board.procedure = procedure

  $scope.procedure = (board, procedure)->
    board.procedure_id = procedure.id
    board.procedure = procedure
    Modal.board = board
    record_name = procedure.record_name
    if record_name == 'reaction_files'
      return
    else if procedure.board
      ctrl = 'BoardRecordsCtrl'
    else
      ctrl = Sequencing.camelcase(record_name) + 'Ctrl'
    $modal.open {
      templateUrl: '/views/' + record_name + '.html'
      size: 'lg'
      controller: ctrl
    }
    .result.then ->
      Board.update board
      return
    return

  $scope.abi_record = (board)->
    Modal.board = board
    $modal.open {
      templateUrl: '/views/abi_records.html'
      size: 'lg'
      controller: 'BoardRecordsCtrl'
    }
    return

  $scope.retypeset = (board)->
    Board.retypeset id: board.id, ->
      $scope.search()

  $scope.upload_board = {}
  $scope.uploadUrl = Sequencing.api + '/attachments/board/'

  $scope.attachment = (a, r, index)->
    $modal.open {
      templateUrl: '/views/attachment.html'
      controller: 'AttachmentCtrl'
      resolve:
        attachment: ->
          a
    }
    .result.then (a)->
      r.electrophorogram.splice index, 1
    return
  return
]
