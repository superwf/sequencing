'use strict'
angular.module('sequencingApp').factory 'Procedure', ['api', '$resource', (api, $resource)->
  $resource api + '/procedures/:id', id: '@id', {
    update: {method: 'PUT', url: api + '/procedures/:id'}
    'delete': {method: 'DELETE', url: api + '/procedures/:id'}
    create: {method: 'POST'}
    query: {isArray: true, method: 'GET'}
  }
]
