'use strict'
angular.module('sequencingApp').controller 'ReactionStatisticCtrl', ['$scope', '$translate', 'Reaction', 'Sequencing', ($scope, $translate, Reaction, Sequencing) ->
  $scope.data = []
  date = new Date()
  $scope.searcher = {
    date_from: date
    date_to: date
    heads: ''
  }
  heads = []
  for i, v of Sequencing.boardHeads
    if v.available && !v.is_redo && v.board_type == 'sample'
      heads.push v.name
  $scope.searcher.heads = heads.join(' ')
  $scope.submit = ->
    if $scope.searcher.heads
      params = {
        date_from: Sequencing.date2string($scope.searcher.date_from)
        date_to: Sequencing.date2string($scope.searcher.date_to)
        heads: $scope.searcher.heads
      }
      Reaction.statistic params, (d)->
        $scope.records = d
        return
    return
  $scope.totalCountChart = ->
    if $scope.records.length
      $scope.data = []
      data = []
      angular.forEach $scope.records, (v, i)->
        data.push [v[0], v[1]]
      $scope.data.push data
    $scope.chartOptions.title = 'total_count'
    return

  $scope.reworkCountChart = ->
    if $scope.records.length
      $scope.data = []
      data = []
      angular.forEach $scope.records, (v, i)->
        data.push [v[0], v[5]]
      $scope.data.push data
    $scope.chartOptions.title = 'rework_count'
    return

  $scope.chartOptions = {
    animate: true
    title: 'statistic'
    seriesDefaults:
      renderer: jQuery.jqplot.BarRenderer
      rendererOptions:
        varyBarColor: true
      pointLabels:
        show: true
    axes:
      xaxis:
        renderer: jQuery.jqplot.CategoryAxisRenderer
        labelRenderer: jQuery.jqplot.CanvasAxisLabelRenderer
        tickRenderer: jQuery.jqplot.CanvasAxisTickRenderer
        #tickOptions:
        #  angle: -20
      yaxis:
        pad: 1.2
        max: 30
        label: 'count'
        labelRenderer: jQuery.jqplot.CanvasAxisLabelRenderer
  }
  #$translate('reaction_statistic').then (l)->
  return
]
