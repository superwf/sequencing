'use strict'

angular.module('sequencingApp').factory 'InterpreteCode', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/interpreteCodes/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/interpreteCodes/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/interpreteCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET', url: SequencingConst.api + '/interpreteCodes?all=true'}
  }
]
