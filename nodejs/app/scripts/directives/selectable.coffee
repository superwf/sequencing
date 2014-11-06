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
        i = ui.selected.getAttribute('i')
        if i
          scope[options.data][i*1].selected = true
        null

      options.unselected = (e, ui)->
        i = ui.unselected.getAttribute('i')
        if i
          scope[options.data][i*1].selected = false
        null

    jQuery(element).selectable options
    null
]
