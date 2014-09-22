package models

import(
  "net/http"
  "errors"
)

type Plasmid struct {
  Id int `json:"id"`
  SampleId int `json:"sample_id"`
  PlasmidCodeId int `json:"plasmid_code_id"`
  Creator
}

func (record *Plasmid)BeforeSave()(error){
  if record.SampleId == 0 {
    return errors.New("sample not_exist")
  }
  return nil
}

func GetPlasmids(req *http.Request)([]map[string]interface{}, int){
  //all := req.FormValue("all")
  db := Db.Table("samples").Select("samples.id, samples.name, samples.hole, plasmids.plasmid_code_id").Joins("LEFT JOIN plasmids ON samples.id = plasmids.sample_id")
  board_id := req.FormValue("board_id")
  if board_id != "" {
    db = db.Where("samples.board_id = ?", board_id)
  }
  rows, _ := db.Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var sample_id, plasmid_code_id int
    var sample, hole string
    rows.Scan(&sample_id, &sample, &hole, &plasmid_code_id)
    d := map[string]interface{}{
      "sample_id": sample_id,
      "plasmid_code_id": plasmid_code_id,
      "sample": sample,
      "hole": hole,
    }
    result = append(result, d)
  }
  return result, 0
}
