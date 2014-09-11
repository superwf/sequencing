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
  CreateDate time.Time `json:"create_date"`
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
    record.Sn = record.CreateDate.Format("20060102") + "-" + head.Name + strconv.Itoa(record.Number)
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
  db := Db.Table("primer_boards").Select("primer_boards.id, primer_boards.sn, primer_boards.primer_head_id, primer_boards.number, primer_boards.create_date, primer_heads.name").Joins("LEFT JOIN primer_heads ON primer_boards.primer_head_id = primer_heads.id")
  sn := req.FormValue("sn")
  primer_head := req.FormValue("primer_head")
  date_from := req.FormValue("date_from")
  date_to := req.FormValue("date_to")
  if sn != "" {
    db = db.Where("sn = ?", sn)
  }
  if primer_head != "" {
    db = db.Where("primer_heads.name = ?", primer_head)
  }
  if date_from != "" {
    db = db.Where("primer_boards.create_date >= ?", date_from)
  }
  if date_to != "" {
    db = db.Where("primer_boards.create_date <= ?", date_to)
  }
  var count int
  db.Count(&count)
  //records := []PrimerBoard{}
  //db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  //defer rows.Close()
  var result []map[string]interface{}
  for rows.Next() {
    var id, primer_head_id, number int
    var sn, primer_head string
    var create_date time.Time
    rows.Scan(&id, &sn, &primer_head_id, &number, &create_date, &primer_head)
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "primer_head_id": primer_head_id,
      "number": number,
      "create_date": create_date.Format("2006-01-02"),
      "primer_head": primer_head,
    }
    result = append(result, d)
  }
  return result, count
}
