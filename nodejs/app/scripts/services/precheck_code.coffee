'use strict'

angular.module('sequencingApp').factory 'PrecheckCode', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/precheckCodes/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/precheckCodes/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/precheckCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
