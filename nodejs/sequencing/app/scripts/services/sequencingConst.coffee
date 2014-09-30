'use strict'
angular.module('sequencingApp').factory 'SequencingConst', ->
  api: '/api/v1'
  yesno: {true: 'yes', false: 'no'}
  boardType: ['primer', 'sample', 'reaction']
  primerStoreType: ['90days', '1year', 'infinate']
  primerStatus: ['not_receive', 'ok', 'lack', 'runout']
  primerNewStatus: ['ok', 'not_receive']
  diluteThickness: '5pmol/ul'
  dilutePrimerStatus: ['ok', 'lack', 'runout']
  orderStatus: ['new', 'run', 'checkout', 'finish']
  boardStatus: ['new', 'run', 'finish']
  transportCondition: ['4-10degree', 'dry_ice', 'room_temperature']
  abiInstruments: [1,2,3,4]
  interpreteResults: ['pass', 'concession', 'rework', 'reshake']
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
