package models

import(
  "net/http"
  "errors"
)

type Precheck struct {
  SampleId int `json:"sample_id" gorm:"primary_key:yes"`
  CodeId int `json:"code_id"`
  Creator
}

// this should be checked by mysql forign key constraint
func (record *Precheck)BeforeSave()(error){
  if record.SampleId == 0 {
    return errors.New("sample not_exist")
  }
  return nil
}

func GetPrechecks(req *http.Request)(result []map[string]interface{}, count int){
  //all := req.FormValue("all")
  db := Db.Table("samples").Select("samples.id, samples.name, samples.hole, prechecks.code_id").Joins("LEFT JOIN prechecks ON samples.id = prechecks.sample_id")
  board_id := req.FormValue("board_id")
  if board_id != "" {
    db = db.Where("samples.board_id = ?", board_id)
  }
  rows, _ := db.Rows()
  for rows.Next() {
    var sample_id, code_id int
    var sample, hole string
    rows.Scan(&sample_id, &sample, &hole, &code_id)
    d := map[string]interface{}{
      "sample_id": sample_id,
      "code_id": code_id,
      "sample": sample,
      "hole": hole,
    }
    result = append(result, d)
  }
  return result, count
}
