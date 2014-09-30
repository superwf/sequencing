'use strict'

angular.module('sequencingApp').factory 'InterpreteCode', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/interpretes/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/interpretes/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/interpretes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
