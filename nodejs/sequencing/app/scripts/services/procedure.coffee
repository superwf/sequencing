'use strict'
angular.module('sequencingApp').factory 'Procedure', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/procedures/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/procedures/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/procedures/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
