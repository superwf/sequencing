package models

import(
  "net/http"
  "time"
  "errors"
)

type Primer struct {
  Id int `json:"id"`
  Name string `json:"name"`
  OriginThickness string `json:"origin_thickness"`
  Annealing string `json:"annealing"`
  Seq string `json:"seq"`
  ClientId int `json:"client_id"`
  PrimerBoardId int `json:"primer_board_id"`
  Hole string `json:"hole"`
  Status string `json:"status"`
  StoreType string `json:"store_type"`
  ReceiveDate time.Time `json:"receive_date"`
  ExpireDate time.Time `json:"expire_date"`
  OperateDate time.Time `json:"operate_date"`
  NeedReturn bool `json:"need_return"`
  Available bool `json:"available"`
  Remark string `json:"remark"`
  Creator
}

// todo when save generate expire date
func (record *Primer) BeforeSave() error {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  client := Client{Id: record.ClientId}
  Db.First(&client)
  if client.Name == "" {
    return errors.New("client not_exist")
  }
  primer_board := PrimerBoard{Id: record.PrimerBoardId}
  Db.First(&primer_board)
  if primer_board.Sn == "" {
    return errors.New("primer_board not_exist")
  }
  exist := Primer{}
  Db.Where("primer_board_id = ? AND hole = ? AND id <> ?", record.PrimerBoardId, record.Hole, record.Id).First(&exist)
  if exist.Id > 0 {
    return errors.New("hole repeat")
  }
  Db.Save(record)
  return nil
}

func GetPrimers(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("primers").Select("primers.id, primers.name, primers.origin_thickness, primers.annealing, primers.seq, primers.client_id, primers.primer_board_id, primers.hole, primers.status, primers.store_type, primers.receive_date, primers.expire_date, primers.operate_date, primers.need_return, primers.available, primers.remark, primer_boards.sn, clients.name").Joins("LEFT JOIN primer_boards ON primers.primer_board_id = primer_boards.id LEFT JOIN clients ON primers.client_id = clients.id")
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("primers.name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var id, client_id, primer_board_id int
    var name, origin_thickness, annealing, seq, hole, status, store_type, remark, primer_board, client string
    var receive_date, operate_date, expire_date time.Time
    var need_return, available bool
    rows.Scan(&id, &name, &origin_thickness, &annealing, &seq, &client_id, &primer_board_id, &hole, &status, &store_type, &receive_date, &expire_date, &operate_date, &need_return, &available, &remark, &primer_board, &client)
    d := map[string]interface{}{
      "id": id,
      "name": name,
      "origin_thickness": origin_thickness,
      "annealing": annealing,
      "seq": seq,
      "client_id": client_id,
      "primer_board_id": primer_board_id,
      "hole": hole,
      "status": status,
      "store_type": store_type,
      "receive_date": receive_date,
      "expire_date": expire_date,
      "operate_date": operate_date,
      "need_return": need_return,
      "available": available,
      "remark": remark,
      "primer_board": primer_board,
      "client": client}
    result = append(result, d)
  }
  return result, count
}
