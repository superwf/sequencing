'use strict'

angular.module('sequencingApp').controller 'BoardsCtrl', ['$scope', 'Board', 'Modal', '$modal', '$location', 'Procedure', 'SequencingConst', ($scope, Board, Modal, $modal, $location, Procedure, SequencingConst) ->
  $scope.searcher = $location.search()
  $scope.search = ->
    Board.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
      $scope.records = data.records
      angular.forEach $scope.records, (record)->
        if record.procedure_id > 0
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
    table_name = board.procedure.table_name
    modal = $modal.open {
      templateUrl: '/views/' + table_name + '.html'
      controller: SequencingConst.camelcase(table_name) + 'Ctrl'
    }
    modal.result.then ->
      Board.nextProcedure id: board.id, (procedure)->
        board.procedure = procedure
        board.procedure_id = procedure.id
        Modal.board = null
        null
  null
]
