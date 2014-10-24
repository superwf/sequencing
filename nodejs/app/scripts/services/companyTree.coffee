'use strict'
angular.module('sequencingApp').factory 'CompanyTree', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/companies/:id'}
    records: {isArray: true, method: 'GET', url: SequencingConst.api + '/companyTree/:id'}
  }
]
