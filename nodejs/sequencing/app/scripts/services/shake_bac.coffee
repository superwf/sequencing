'use strict'

angular.module('sequencingApp').factory 'ShakeBac', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/shakeBacs/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/shakeBacs/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/shakeBacs/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
