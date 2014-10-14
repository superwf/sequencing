'use strict'
angular.module('sequencingApp').factory 'SequencingConst', ['$http', ($http)->
  sequencing = {
    consts: '/api/consts'
    auth: '/api/auth'
    api: '/api/v1'
    yesno: {true: 'yes', false: 'no'}
    interpreteCodeColor: {pass: "alert-success", rework: "alert-danger", concession: "alert-info", reshake: "alert-warning"}
    copyWithDate: (record, field)->
      r= angular.copy(record)
      if typeof(field) == 'string'
        r[field] = new Date(record[field])
      else
        angular.forEach field, (k, v)->
          r[v] = new Date(record[v])
      r
    date2string: (datefield)->
      if datefield
        time = new Date(datefield)
      else
        time = new Date()
      m = (time.getMonth() + 1) + ''
      if m.length == 1
        m = '0' + m
      d = time.getDate() + ''
      if d.length == 1
        d = '0' + d
      time.getFullYear() + '-' + m + '-' + d
    camelcase: (string)->
      string = string.charAt(0).toUpperCase() + string.slice(1)
      string.replace /_(.)/g, (match, group1)->
        group1.toUpperCase()
    boardSn: (board)->
      if board.board_head
        if board.board_head.with_date
          datestring = board.create_date.replace(/-/g, '')
          datestring + '-' + board.board_head.name + board.number
        else
          board.board_head.name + board.number
    fileExist: (url, success)->
      http = new XMLHttpRequest()
      http.open('HEAD', url, false)
      http.send()
      if http.status != 404
        success()
    quadrant: (hole)->
      result = hole.match /(\d+)(\w)/
      colIndex = result[1] * 1 - 1
      row = result[2]
      rows = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      rowIndex = rows.indexOf(row)
      colRemainder = colIndex % 2
      rowRemainder = rowIndex % 2
      if colRemainder == 0 && rowRemainder == 0
        1
      else if colRemainder == 0 && rowRemainder == 1
        2
      else if colRemainder == 1 && rowRemainder == 0
        3
      else if colRemainder == 1 && rowRemainder == 1
        4
  }
  $http.get(sequencing.consts).success (data)->
    for i, v of data
      sequencing[i] = v
    null
  sequencing.procedures = {}
  $http.get(sequencing.api + '/procedures?all=true&available=true').success (data)->
    for i, v of data
      sequencing.procedures[v.id] = v
    null

  sequencing.users = {}
  $http.get(sequencing.api + '/users?all=true').success (data)->
    for i, v of data
      sequencing.users[v.id] = v
    null

  sequencing.boardHeads = {}
  $http.get(sequencing.api + '/boardHeads?all=true&available=true').success (data)->
    for i, v of data
      sequencing.boardHeads[v.id] = v
    null

  sequencing.plasmidCodes = {}
  $http.get(sequencing.api + '/plasmidCodes?all=true&available=true').success (data)->
    for i, v of data
      sequencing.plasmidCodes[v.id] = v
    null
  sequencing.precheckCodes = {}
  $http.get(sequencing.api + '/precheckCodes?all=true&available=true').success (data)->
    for i, v of data
      sequencing.precheckCodes[v.id] = v
    null

  sequencing.interpreteCodes = {}
  $http.get(sequencing.api + '/interpreteCodes?all=true&available=true').success (data)->
    for i, v of data
      sequencing.interpreteCodes[v.id] = v
    null
  sequencing
]
