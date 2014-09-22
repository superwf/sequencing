'use strict'

angular.module('sequencingApp').factory 'Electro', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/electros/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/electros/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/electros/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
