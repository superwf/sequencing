package models

import(
  "net/http"
  "time"
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

func (record *Primer) ValidateSave()(int, interface{}) {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  if record.ClientId <= 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "client",
      "error": "noexist"}
  }
  if record.PrimerBoardId <= 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "primer_board",
      "error": "noexist"}
  }
  Db.Save(record)
  return http.StatusAccepted, record
}

func GetPrimers(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("primers").Select("primers.id, primers.name, primers.origin_thickness, primers.seq, primers.client_id, primers.primer_board_id, primers.hole, primers.status, primers.store_type, primers.receive_date, primers.expire_date, primers.operate_date, primers.need_return, primers.available, primers.remark, primer_boards.sn, clients.name").Joins("LEFT JOIN primer_boards ON primers.primer_board_id = primer_boards.id LEFT JOIN clients ON primers.client_id = clients.id")
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
    var name, origin_thickness, seq, hole, status, store_type, remark, primer_board, client string
    var receive_date, operate_date, expire_date time.Time
    var need_return, available bool
    rows.Scan(&id, &name, &origin_thickness, &seq, &client_id, &primer_board_id, &hole, &status, &store_type, &receive_date, &expire_date, &operate_date, &need_return, &available, &remark, &primer_board, &client)
    d := map[string]interface{}{
      "id": id,
      "name": name,
      "origin_thickness": origin_thickness,
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
      "client": client,
    }
    result = append(result, d)
  }
  return result, count
}
