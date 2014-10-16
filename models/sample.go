package models

import(
  "net/http"
  "errors"
)

type Sample struct {
  Id int `json:"id"`
  Name string `json:"name"`
  OrderId int `json:"order_id"`
  VectorId int `json:"vector_id"`
  Fragment string `json:"fragment"`
  Resistance string `json:"resistance"`
  ReturnType string `json:"return_type"`
  BoardId int `json:"board_id"`
  Hole string `json:"hole"`
  IsSplice bool `json:"is_splice"`
  IsThrough bool `json:"is_through"`
  Remark string `json:"remark"`
  Reactions []Reaction
}

func GetSamples(req *http.Request)([]Sample, int){
  page := getPage(req)
  db := Db.Model(Sample{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  records := []Sample{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func (record *Sample) BeforeSave() error {
  nameLength := len(record.Name)
  if nameLength > 255 || nameLength == 0{
    return errors.New("name length error")
  }
  //order := Order{Id: record.OrderId}
  //Db.First(&order)
  //if len(order.Sn) > 0 {
  //  return errors.New("order not_exist")
  //}
  return nil
}
