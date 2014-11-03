package models

import(
  "net/http"
  "database/sql"
  //"encoding/json"
  //"strings"
  //"errors"
)

type Reaction struct {
  Id int `json:"id"`
  OrderId int `json:"order_id"`
  SampleId int `json:"sample_id"`
  PrimerId int `json:"primer_id"`
  DilutePrimerId int `json:"dilute_primer_id"`
  BoardId int `json:"board_id"`
  Hole string `json:"hole"`
  ParentId int `json:"parent_id"`
  Remark string `json:"remark"`
}

func GetReactions(req *http.Request)([]Reaction, int){
  page := getPage(req)
  joinSql := "INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN orders ON samples.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id LEFT JOIN vectors ON samples.vector_id = vectors.id LEFT JOIN boards AS sample_boards ON samples.board_id = sample_boards.id LEFT JOIN prechecks ON samples.id = prechecks.sample_id LEFT JOIN reaction_files ON reactions.id = reaction_files.reaction_id LEFT JOIN primers ON reactions.primer_id = primers.id LEFT JOIN boards AS reaction_boards ON reactions.board_id = reaction_boards.id"
  db := Db.Table("reactions").Select("orders.sn, orders.remark, clients.name, clients.tel, reactions.id, orders.board_head_id, samples.name, sample_boards.sn, samples.hole, primers.name, reaction_boards.sn, reactions.hole, prechecks.code_id, reaction_files.code_id, reaction_files.proposal, reaction_files.interpreter_id, vectors.name")
  sample_id := req.FormValue("sample_id")
  if sample_id != "" {
    db = db.Where("sample_id = ?", sample_id)
  }
  client := req.FormValue("client")
  if client != "" {
    db = db.Where("clients.name = ?", client)
  }
  order := req.FormValue("order")
  if order != "" {
    db = db.Where("orders.sn = ?", order)
  }
  dateFrom := req.FormValue("dateFrom")
  if dateFrom != "" {
    db = db.Where("orders.create_date >= ?", dateFrom)
  }
  dateTo := req.FormValue("dateTo")
  if dateTo != "" {
    db = db.Where("orders.create_date <= ?", dateTo)
  }
  companyCode := req.FormValue("company_code")
  if companyCode != "" {
    db = db.Where("companies.full_code LIKE ?", companyCode + "%")
  }

  db = db.Joins(joinSql)
  var count int
  db.Count(&count)
  result := []Reaction{}
  all := req.FormValue("all")
  if all == "" {
    rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
    for rows.Next() {
      //var vector, sampleBoard, reactionBoard sql.NullString
      //var precheckCodeId, interpreteCodeId sql.NullInt
    }
  } else {
    db.Find(&result)
  }
  return result, count
}


func ReworkingReactions(req *http.Request)([]map[string]interface{}){
  joins := "INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN orders ON samples.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id LEFT JOIN vectors ON samples.vector_id = vectors.id LEFT JOIN boards ON samples.board_id = boards.id LEFT JOIN primers ON reactions.primer_id = primers.id"
  db := Db.Table("reactions").Select("orders.sn, clients.name, reactions.id, reactions.parent_id, orders.board_head_id, samples.name, boards.sn, samples.hole, primers.name, prechecks.code_id, reaction_files.code_id, reaction_files.proposal, reaction_files.interpreter_id, vectors.name")
  sample_id := req.FormValue("sample_id")
  if sample_id != "" {
    db = db.Where("sample_id = ?", sample_id)
  }
  req.ParseForm()
  boardHeadId := req.Form["board_head_id"]
  if len(boardHeadId) > 0 {
    db = db.Where("orders.board_head_id IN(?)", boardHeadId)
  }
  client := req.FormValue("client")
  if client != "" {
    db = db.Where("clients.name = ?", client)
  }
  order := req.FormValue("order")
  if order != "" {
    db = db.Where("orders.sn = ?", order)
  }
  dateFrom := req.FormValue("date_from")
  if dateFrom != "" {
    db = db.Where("orders.create_date >= ?", dateFrom)
  }
  dateTo := req.FormValue("date_to")
  if dateTo != "" {
    db = db.Where("orders.create_date <= ?", dateTo)
  }
  precheckOk := req.FormValue("precheck_ok")
  if precheckOk != "" {
    joins = joins + " INNER JOIN prechecks ON samples.id = prechecks.sample_id INNER JOIN precheck_codes ON prechecks.code_id = precheck_codes.id"
    if precheckOk == "true" {
      db = db.Where("precheck_codes.ok = 1")
    }
    if precheckOk == "false" {
      db = db.Where("precheck_codes.ok = 0")
    }
  } else {
    joins = joins + " LEFT JOIN prechecks ON samples.id = prechecks.sample_id"
  }
  interpreteResult := req.FormValue("interprete_result")
  if interpreteResult != "" {
    joins = joins + " INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id"
    db = db.Where("interprete_codes.result = ?", interpreteResult)
  } else {
    joins = joins + " LEFT JOIN reaction_files ON reactions.id = reaction_files.reaction_id"
  }
  result := []map[string]interface{}{}
  all := req.FormValue("all")
  if all == "" {
    db = db.Joins(joins).Limit(500)
  }
  rows, _ := db.Rows()
  for rows.Next() {
    var order, client, sample, primer, board, hole, proposal string
    var vector sql.NullString
    var reactionId, parentId, precheckCodeId, interpreteCodeId, interpreterId, boardHeadId int
    rows.Scan(&order, &client, &reactionId, &parentId, &boardHeadId, &sample, &board, &hole, &primer, &precheckCodeId, &interpreteCodeId, &proposal, &interpreterId, &vector)
    if parentId == 0 {
      parentId = reactionId
    }
    reworks := map[string]int{}
    rs, _ := Db.Select("board_heads.name, COUNT(*)").Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN board_heads ON orders.board_head_id = board_heads.id").Where("reactions.parent_id = ?", parentId).Rows()
    for rs.Next(){
      var head string
      var reworkCount int
      rs.Scan(&head, &reworkCount)
      reworks[head] = reworkCount
    }
    d := map[string]interface{}{
      "id": reactionId,
      "order": order,
      "client": client,
      "sample": sample,
      "sample_board": board,
      "sample_hole": hole,
      "vector": vector.String,
      "primer": primer,
      "proposal": proposal,
      "board_head_id": boardHeadId,
      "precheck_code_id": precheckCodeId,
      "interprete_code_id": interpreteCodeId,
      "interpreter_id": interpreterId,
      "reworks": reworks,
    }
    result = append(result, d)
  }
  return result
}
