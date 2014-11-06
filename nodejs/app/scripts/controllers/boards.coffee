'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', '$location', 'Procedure', 'Sequencing', '$routeParams', 'BoardRecord', ($scope, Board, Modal, $modal, $location, Procedure, Sequencing, $routeParams, BoardRecord) ->
  $scope.searcher = $location.search()
  if $scope.searcher.board_type
    $scope.$emit 'event:title', $scope.searcher.board_type + '_board'
  $scope.search = ->
    Board.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      angular.forEach $scope.records, (record)->
        record.board_head = Sequencing.boardHeads[record.board_head_id]
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

  $scope.confirm = (board)->
    Board.confirm id: board.id, (procedure)->
      board.status = 'run'
      board.procedure = procedure

  $scope.run = (board)->
    Modal.board = board
    record_name = board.procedure.record_name
    if board.procedure.record_name == 'reaction_files'
      record_name = 'abi_records'
      ctrl = 'BoardRecordsCtrl'
    else if board.procedure.board
      ctrl = 'BoardRecordsCtrl'
    else
      ctrl = Sequencing.camelcase(record_name) + 'Ctrl'
    $modal.open {
      templateUrl: '/views/' + record_name + '.html'
      size: 'lg'
      controller: ctrl
    }
    .result.then ->
      Board.nextProcedure id: board.id, (procedure)->
        if procedure.id
          board.procedure = procedure
          board.procedure_id = procedure.id
        Modal.board = null
        return
    return

  $scope.retypeset = (board)->
    Board.retypeset id: board.id
  return
]
