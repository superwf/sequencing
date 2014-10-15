package models

import(
  "net/http"
  "time"
  "errors"
  "sequencing/config"
)

type Primer struct {
  Id int `json:"id"`
  Name string `json:"name"`
  OriginThickness string `json:"origin_thickness"`
  Annealing string `json:"annealing"`
  Seq string `json:"seq"`
  ClientId int `json:"client_id"`
  BoardId int `json:"board_id"`
  Hole string `json:"hole"`
  Status string `json:"status"`
  StoreType string `json:"store_type"`
  CreateDate time.Time `json:"create_date"`
  ExpireDate time.Time `json:"expire_date"`
  OperateDate time.Time `json:"operate_date"`
  NeedReturn bool `json:"need_return"`
  Available bool `json:"available"`
  Remark string `json:"remark"`
  Reactions []Reaction
  Creator
}

func (record *Primer) BeforeSave() error {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  client := Client{Id: record.ClientId}
  Db.First(&client)
  if client.Name == "" {
    return errors.New("client not_exist")
  }
  board := Board{Id: record.BoardId}
  Db.First(&board)
  if board.Sn == "" {
    return errors.New("board not_exist")
  }
  exist := Primer{}
  if record.Id > 0 {
    Db.Where("board_id = ? AND hole = ? AND id <> ?", record.BoardId, record.Hole, record.Id).First(&exist)
  } else {
    Db.Where("board_id = ? AND hole = ?", record.BoardId, record.Hole).First(&exist)
  }
  if exist.Id > 0 {
    return errors.New("board hole repeat")
  }

  // generate expire date depend on store_type
  if record.StoreType == config.PrimerStoreType[0] {
    record.ExpireDate = record.CreateDate.Add(time.Hour * 24 * 90)
  }
  if record.StoreType == config.PrimerStoreType[1] {
    record.ExpireDate = record.CreateDate.Add(time.Hour * 24 * 365)
  }
  if record.Status == config.PrimerStatus[0] || record.Status == config.PrimerStatus[3] {
    record.Available = false
  } else {
    record.Available = true
  }

  return nil
}

func GetPrimers(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("primers").Select("primers.id, primers.name, primers.origin_thickness, primers.annealing, primers.seq, primers.client_id, primers.board_id, primers.hole, primers.status, primers.store_type, primers.create_date, primers.expire_date, primers.operate_date, primers.need_return, primers.available, primers.remark, boards.sn, clients.name").Joins("LEFT JOIN boards ON primers.board_id = boards.id LEFT JOIN clients ON primers.client_id = clients.id")
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("primers.name LIKE ?", (name + "%"))
  }
  board_id := req.FormValue("board_id")
  if board_id != "" {
    db = db.Where("primers.board_id = ?", board_id)
  }
  client_id := req.FormValue("client_id")
  if client_id != "" {
    db = db.Where("primers.client_id = ?", client_id)
  }
  date_from := req.FormValue("date_from")
  if date_from != "" {
    db = db.Where("primers.create_date >= ?", date_from)
  }
  date_to := req.FormValue("date_to")
  if date_to != "" {
    db = db.Where("primers.create_date <= ?", date_to)
  }
  status := req.FormValue("status")
  if status != "" {
    db = db.Where("primers.status = ?", status)
  }
  available := req.FormValue("available")
  if available != "" {
    if available != "false" {
      db = db.Where("primers.available = 1")
    } else {
      db = db.Where("primers.available = 0")
    }
  }
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var id, client_id, board_id int
    var name, origin_thickness, annealing, seq, hole, status, store_type, remark, board, client string
    var create_date, operate_date, expire_date time.Time
    var need_return, available bool
    rows.Scan(&id, &name, &origin_thickness, &annealing, &seq, &client_id, &board_id, &hole, &status, &store_type, &create_date, &expire_date, &operate_date, &need_return, &available, &remark, &board, &client)
    d := map[string]interface{}{
      "id": id,
      "name": name,
      "origin_thickness": origin_thickness,
      "annealing": annealing,
      "seq": seq,
      "client_id": client_id,
      "board_id": board_id,
      "hole": hole,
      "status": status,
      "store_type": store_type,
      "create_date": create_date,
      "expire_date": expire_date,
      "operate_date": operate_date,
      "need_return": need_return,
      "available": available,
      "remark": remark,
      "board": board,
      "client": client}
    result = append(result, d)
  }
  return result, count
}
