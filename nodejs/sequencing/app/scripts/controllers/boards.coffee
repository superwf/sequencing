'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', '$location', 'Procedure', 'SequencingConst', '$routeParams', ($scope, Board, Modal, $modal, $location, Procedure, SequencingConst, $routeParams) ->
  $scope.searcher = $location.search()
  $scope.search = ->
    Board.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      angular.forEach $scope.records, (record)->
        if record.procedure_id > 0
          if SequencingConst.procedures[record.procedure_id]
            record.procedure = SequencingConst.procedures[record.procedure_id]
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
      ctrl = SequencingConst.camelcase(record_name) + 'Ctrl'
    modal = $modal.open {
      templateUrl: '/views/' + record_name + '.html'
      controller: ctrl
    }
    modal.result.then ->
      Board.nextProcedure id: board.id, (procedure)->
        board.procedure = procedure
        board.procedure_id = procedure.id
        Modal.board = null
        null
  null
]
