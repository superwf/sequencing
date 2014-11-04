'use strict'

angular.module('sequencingApp').controller 'DilutePrimersCtrl', ['$scope', 'Reaction', 'Sequencing', '$rootScope', 'DilutePrimer', ($scope, Reaction, Sequencing, $rootScope, DilutePrimer) ->
  $scope.$emit 'event:title', 'dilute_primer'
  getRecords = ->
    Reaction.dilute (data)->
      angular.forEach data, (d)->
        d.status = 'ok'
        d.remark = 'ok'
      $scope.records = data
  getRecords()

  $scope.diluteThickness = Sequencing.diluteThickness
  $scope.status = Sequencing.dilutePrimerStatus

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
    angular.forEach $scope.records, (v, i)->
      if v.selected
        r = {
          primer_id: v.primer_id
          order_id: v.order_id
          status: v.status
          remark: v.remark
        }
        records.push r
      return
    if records.length
      DilutePrimer.create records, ->
        getRecords()
    null

]
