'use strict'

angular.module('sequencingApp').factory 'User', ['$resource', 'api', ($resource, api)->
  $resource api + '/users/:id', id: '@id', {
    update: {method: 'PUT', url: '/messages/:id'}
    'delete': {method: 'DELETE', url: '/messages/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
