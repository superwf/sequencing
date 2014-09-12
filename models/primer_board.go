package models

import(
  "net/http"
  "time"
  "strconv"
  "errors"
)

type PrimerBoard struct {
  Id int `json:"id"`
  Sn string `json:"sn"`
  CreateDate time.Time `json:"create_date"`
  Number int `json:"number"`
  BoardHeadId int `json:"board_head_id"`
  Creator
}

func (record *PrimerBoard) BeforeSave() error {
  head := BoardHead{Id: record.BoardHeadId}
  Db.First(&head)
  if head.Name == "" || !head.Available {
    return errors.New("board_head not_exist")
  }
  if head.WithDate {
    record.Sn = record.CreateDate.Format("20060102") + "-" + head.Name + strconv.Itoa(record.Number)
  } else {
    record.Sn = head.Name + strconv.Itoa(record.Number)
  }
  var exist_count int
  if record.Id > 0 {
    Db.Table("primer_boards").Where("sn = ? AND id != ?", record.Sn, record.Id).Count(&exist_count)
  } else {
    Db.Table("primer_boards").Where("sn = ?", record.Sn).Count(&exist_count)
  }
  if exist_count > 0 {
    return errors.New("sn repeat")
  }
  return nil
}

func GetPrimerBoards(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("primer_boards").Select("primer_boards.id, primer_boards.sn, primer_boards.board_head_id, primer_boards.number, primer_boards.create_date, board_heads.name").Joins("LEFT JOIN board_heads ON primer_boards.board_head_id = board_heads.id")
  sn := req.FormValue("sn")
  board_head := req.FormValue("board_head")
  date_from := req.FormValue("date_from")
  date_to := req.FormValue("date_to")
  if sn != "" {
    db = db.Where("sn = ?", sn)
  }
  if board_head != "" {
    db = db.Where("board_heads.name = ?", board_head)
  }
  if date_from != "" {
    db = db.Where("primer_boards.create_date >= ?", date_from)
  }
  if date_to != "" {
    db = db.Where("primer_boards.create_date <= ?", date_to)
  }
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var id, board_head_id, number int
    var sn, board_head string
    var create_date time.Time
    rows.Scan(&id, &sn, &board_head_id, &number, &create_date, &board_head)
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "board_head_id": board_head_id,
      "number": number,
      "create_date": create_date.Format("2006-01-02"),
      "board_head": board_head,
    }
    result = append(result, d)
  }
  return result, count
}
