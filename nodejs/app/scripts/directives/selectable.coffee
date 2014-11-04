'use strict'

angular.module('sequencingApp').directive 'selectable', [->
  restrict: 'A'
  link: (scope, element, attrs) ->
    if attrs.selectableOptions
      options = scope.$eval(attrs.selectableOptions)
    else
      options = {}
    if options.data
      options.selected = (e, ui)->
        i = ui.selected.getAttribute('i') * 1
        scope[options.data][i].selected = true
        null

      options.unselected = (e, ui)->
        i = ui.unselected.getAttribute('i') * 1
        scope[options.data][i].selected = false
        null

    jQuery(element).selectable options
    null
]
