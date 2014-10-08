'use strict'

angular.module('sequencingApp').controller 'ReactionFilesCtrl', ['$scope', 'ReactionFile', 'Modal', '$modal', 'SequencingConst', '$window', '$timeout', 'InterpreteCode', ($scope, ReactionFile, Modal, $modal, SequencingConst, $window, $timeout, InterpreteCode) ->
  $scope.interpreteCodeColor = SequencingConst.interpreteCodeColor
  showCode = ->
    if !$scope.codes
      InterpreteCode.all (data)->
        $scope.codes = data

  ReactionFile.interpreting (data)->
    if data.length > 0
      $scope.interpretingRecords = data
      for _, i in $scope.interpretingRecords
        $scope.interpretingRecords[i].instrument = JSON.parse($scope.interpretingRecords[i].instrument)
        $scope.interpretingRecords[i].quadrant = SequencingConst.quadrant($scope.interpretingRecords[i].reaction_hole)
      showCode()
    else
      ReactionFile.download (data) ->
        $scope.downloadingRecords = data
        null
    null

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
          showCode()
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

  $scope.save = ->
    records = []
    angular.forEach $scope.interpretingRecords, (v, i)->
      if v.code
        records.push {
          id: v.id
          proposal: v.proposal
          code_id: v.code.id
        }
    if records.length
      ReactionFile.interprete records

]
