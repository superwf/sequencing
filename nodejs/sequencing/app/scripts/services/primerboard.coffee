'use strict'

angular.module('sequencingApp').factory 'PrimerBoard', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/primerBoards/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/primerBoards/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/primerBoards/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
