'use strict'
angular.module('sequencingApp').factory 'Menu', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/menus/:id', id: '@id', {
    query: {isArray: true, method: 'GET'}
  }
]
