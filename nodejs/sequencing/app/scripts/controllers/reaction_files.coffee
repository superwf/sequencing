'use strict'

angular.module('sequencingApp').controller 'ReactionFilesCtrl', ['$scope', 'ReactionFile', 'Modal', '$modal', 'SequencingConst', '$window', '$timeout', 'InterpreteCode', ($scope, ReactionFile, Modal, $modal, SequencingConst, $window, $timeout, InterpreteCode) ->
  $scope.interpreteCodeColor = SequencingConst.interpreteCodeColor
  showCode = (fn)->
    $scope.codes = {}
    if !$scope.codes.length
      InterpreteCode.all (data)->
        angular.forEach data, (v, i)->
          $scope.codes[v.id] = v
        fn()

  showInterpreting = ->
    ReactionFile.interpreting (data)->
      if data.length > 0
        showCode ->
          $scope.interpretingRecords = data
          console.log $scope.codes
          for v, i in $scope.interpretingRecords
            $scope.interpretingRecords[i].instrument = JSON.parse($scope.interpretingRecords[i].instrument)
            $scope.interpretingRecords[i].quadrant = SequencingConst.quadrant($scope.interpretingRecords[i].reaction_hole)
            $scope.interpretingRecords[i].code = $scope.codes[v.code_id]
      else
        ReactionFile.download (data) ->
          if data.length
            $scope.downloadingRecords = data
          else
            $scope.interpretingRecords = []
            null
      null
  showInterpreting()

  $scope.download = ->
    selected = angular.element('.ui-selected')
    if selected.length
      ids = []
      selected.each ->
        i = parseInt(this.getAttribute('i'))
        ids.push $scope.downloadingRecords[i].id
        $window.open SequencingConst.api + '/downloadReactionFiles?ids=' + ids, ->
        $timeout ->
          $scope.downloadingRecords = []
          showCode ->
            ReactionFile.interpreting (data)->
              $scope.interpretingRecords = data
        , 1
    null
  $scope.selectCode = (code)->
    angular.element('tr.ui-selected').each ->
      i = this.getAttribute('i')
      $scope.interpretingRecords[i].code = code
    null
  $scope.clearCode = ->
    angular.element('tr.ui-selected').each ->
      i = this.getAttribute('i')
      $scope.interpretingRecords[i].code = null
    null

  $scope.$watch 'proposal.text', (n, o)->
    angular.forEach $scope.interpretingRecords, (v, i)->
      if angular.element('tr.ui-selected[i='+i+']').length
        $scope.interpretingRecords[i]['proposal'] = n
    null

  $scope.save = (status)->
    records = []
    angular.forEach $scope.interpretingRecords, (v, i)->
      if v.code
        code_id = v.code.id
      else
        code_id = 0
      records.push {
        id: v.id
        proposal: v.proposal || ''
        code_id: code_id
        status: status
      }
    if records.length
      ReactionFile.interprete records, ->
        if status == 'interpreted'
          showInterpreting()

]
