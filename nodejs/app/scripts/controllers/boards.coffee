'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', '$location', 'Procedure', 'Sequencing', '$routeParams', ($scope, Board, Modal, $modal, $location, Procedure, Sequencing, $routeParams) ->
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
          else
            Procedure.get id: record.procedure_id, (procedure)->
              record.procedure = procedure
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
    if board.procedure.board
      ctrl = 'BoardRecordsCtrl'
    else
      ctrl = Sequencing.camelcase(record_name) + 'Ctrl'
    if board.procedure.record_name != 'reaction_files'
      modal = $modal.open {
        templateUrl: '/views/' + record_name + '.html'
        size: 'lg'
        controller: ctrl
      }
      modal.result.then ->
        Board.nextProcedure id: board.id, (procedure)->
          if procedure.id
            board.procedure = procedure
            board.procedure_id = procedure.id
          Modal.board = null
          null
    null
  null
]
