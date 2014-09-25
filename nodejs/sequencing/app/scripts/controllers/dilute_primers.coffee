'use strict'

angular.module('sequencingApp').controller 'DilutePrimersCtrl', ['$scope', 'Reaction', 'SequencingConst', '$rootScope', 'DilutePrimer', ($scope, Reaction, SequencingConst, $rootScope, DilutePrimer) ->
  getRecords = ->
    Reaction.dilute (data)->
      angular.forEach data, (d)->
        d.status = 'ok'
        d.remark = 'ok'
      $scope.records = data
  getRecords()

  $scope.diluteThickness = SequencingConst.diluteThickness
  $scope.status = SequencingConst.dilutePrimerStatus

  $scope.$watch 'batch_status', (status)->
    if $scope.batch_status
      angular.forEach $scope.records, (r)->
        r.status = status
  $scope.$watch 'batch_remark', (remark)->
    if $scope.batch_remark
      angular.forEach $scope.records, (r)->
        r.remark = remark
  $scope.batch_remark = 'ok'
  $scope.batch_status = 'ok'
  
  $scope.save = ->
    records = []
    angular.element("tbody tr").each (k, v)->
      if angular.element(this).hasClass("ui-selected")
        r = {
          primer_id: $scope.records[k].primer_id
          status: $scope.records[k].status
          remark: $scope.records[k].remark
        }
        records.push r
    if records.length
      DilutePrimer.create records
      #  getRecords()
    null

]
