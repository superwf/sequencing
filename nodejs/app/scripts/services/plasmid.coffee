'use strict'
angular.module('sequencingApp').factory 'Plasmid', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/plasmids/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/plasmids/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/plasmids/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
