'use strict'

angular.module('sequencingApp').factory 'Primer', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/primers/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/primers/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/primers/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
