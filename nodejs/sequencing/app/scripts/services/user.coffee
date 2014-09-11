'use strict'

angular.module('sequencingApp').factory 'User', ['$resource', 'SequencingConst', ($resource, SequencingConst)->
  $resource SequencingConst.api + '/users/:id', id: '@id', {
    query: {isArray: false, method: 'GET'}
  }
]
