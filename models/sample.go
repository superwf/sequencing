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
  Reactions []Reaction
  ParentId int `json:"parent_id"`
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

func TypesettingSampleHeads()([]BoardHead){
  heads := []BoardHead{}
  Db.Select("DISTINCT board_heads.*").Table("samples").Joins("INNER JOIN orders ON samples.order_id = orders.id INNER JOIN board_heads ON orders.board_head_id = board_heads.id").Where("samples.board_id = 0").Find(&heads)
  return heads
}
func TypesettingSamples(headId string)([]map[string]interface{}){
  samples := []map[string]interface{}{}
  rows, _ := Db.Select("samples.name, orders.sn, board_heads.name, board_heads.id, samples.id").Table("samples").Joins("INNER JOIN orders ON samples.order_id = orders.id INNER JOIN board_heads ON orders.board_head_id = board_heads.id").Where("samples.board_id = 0 AND orders.board_head_id = ?", headId).Rows()
  for rows.Next(){
    var sampleId, headId int
    var sample, order, head string
    rows.Scan(&sample, &order, &head, &headId, &sampleId)
    d := map[string]interface{}{
      "sample_id": sampleId,
      "head_id": headId,
      "sample": sample,
      "order": order,
      "head": head,
    }
    primers := []string{}
    rs, _ := Db.Select("primers.name").Table("reactions").Joins("INNER JOIN primers ON reactions.primer_id = primers.id").Where("sample_id = ?", sampleId).Rows()
    for rs.Next() {
      var primer string
      rs.Scan(&primer)
      primers = append(primers, primer)
    }
    d["primers"] = primers
    samples = append(samples, d)
  }
  return samples
}
