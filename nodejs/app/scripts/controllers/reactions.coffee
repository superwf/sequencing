'use strict'
angular.module('sequencingApp').controller 'ReactionsCtrl', ['$scope', 'Reaction', '$modal', 'Board', 'Sequencing', '$translate', 'Modal', 'Primer', 'Vector', 'BoardHead', ($scope, Reaction, $modal, Board, Sequencing, $translate, Modal, Primer, Vector, BoardHead) ->
  $scope.$emit 'event:title', 'reaction'
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.board_heads = data

  $scope.searcher = {}
  $scope.search = ->
    Reaction.query $scope.searcher, (data) ->
      angular.forEach data.records, (v, i)->
        if v.interprete_code_id
          v.interprete_code = Sequencing.interpreteCodes[v.interprete_code_id]
        if v.precheck_code_id
          v.precheck_code = Sequencing.precheckCodes[v.precheck_code_id]
        if v.sample_procedure_id
          v.sample_status = Sequencing.procedures[v.sample_procedure_id].name
        else
          $translate('to_typeset').then (l)->
            v.sample_status = l
            return
        if v.reaction_procedure_id
          v.reaction_status = Sequencing.procedures[v.reaction_procedure_id].name
        else
          $translate('to_typeset').then (l)->
            v.reaction_status = l
            return
        return
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
    return
  $scope.search()

  $scope.save = (r)->
    Reaction.update id: r.reaction_id, {
      id: r.reaction_id,
      remark: r.reaction_remark
      sample_id: r.sample_id
      sample: r.sample
      vector_id: r.vector_id
      primer_id: r.primer_id
    }
    return

  $scope.edit = (r, attr, b)->
    r['edit' + attr] = b
    return

  $scope.select = (r, resource)->
    Modal.resource = eval(resource[0].toUpperCase() + resource.substring(1, resource.length))
    modal = $modal.open {
      templateUrl: '/views/'+resource+'s.html'
      controller: 'ModalTableCtrl'
      size: 'lg'
      resolve:
        searcher: ->
          {available: true, client_id: r.client_id}
    }
    modal.result.then (data)->
      r[resource] = data.name
      r[resource + '_id'] = data.id
      null

  return
]
