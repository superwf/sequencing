'use strict'
angular.module('sequencingApp').factory 'Bill', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/bills/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/bills/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/bills/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
