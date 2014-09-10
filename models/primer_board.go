package models

import(
  "net/http"
  "time"
  "log"
  "strconv"
)

type PrimerBoard struct {
  Id int `json:"id"`
  Sn string `json:"sn"`
  CreatedDate time.Time `json:"created_date"`
  Number int `json:"number"`
  PrimerHeadId int `json:"primer_head_id"`
  Creator
}

func (record *PrimerBoard) ValidateSave()(int, interface{}) {
  head := PrimerHead{Id: record.PrimerHeadId}
  Db.First(&head)
  if head.Name == "" {
    return http.StatusNotAcceptable, map[string]string{
      "field": "primer_head",
      "error": "needed"}
  }
  if head.WithDate {
    record.Sn = record.CreatedDate.Format("20060102") + "-" + head.Name + strconv.Itoa(record.Number)
  } else {
    record.Sn = head.Name + strconv.Itoa(record.Number)
  }
  log.Println(record)
  saved := Db.Save(record)
  if saved.Error != nil {
    return http.StatusNotAcceptable, map[string]string{
      "field": "mysql",
      "error": saved.Error.Error()}
  }
  return http.StatusAccepted, record
}

func GetPrimerBoards(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("primer_boards").Select("primer_boards.id, primer_boards.sn, primer_boards.primer_head_id, primer_boards.number, primer_boards.created_date, primer_heads.name").Joins("LEFT JOIN primer_heads ON primer_boards.primer_head_id = primer_heads.id")
  sn := req.FormValue("sn")
  if sn != "" {
    db = db.Where("sn = ?", sn)
  }
  var count int
  db.Count(&count)
  //records := []PrimerBoard{}
  //db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  defer rows.Close()
  var result []map[string]interface{}
  for rows.Next() {
    var id, primer_head_id, number int
    var sn, primer_head string
    var created_date time.Time
    rows.Scan(&id, &sn, &primer_head_id, &number, &created_date, &primer_head)
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "primer_head_id": primer_head_id,
      "number": number,
      "created_date": created_date.Format("2006-01-02"),
      "primer_head": primer_head,
    }
    result = append(result, d)
  }
  return result, count
}
