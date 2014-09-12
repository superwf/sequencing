package models

import(
  "time"
  "strconv"
  "errors"
)

type Order struct {
  Id int `json:"id"`
  ClientId int `json:"client_id"`
  DayNumber string `json:"day_number"`
  BoardHeadId int `json:"board_head_id"`
  ParentId int `json:"parent_id"`
  ReceiveDate time.Time `json:"receive_date"`
  Sn string `json:"sn"`
  Urgent bool `json:"urgent"`
  IsTest bool `json:"is_test"`
  TransportCondition string `json:"transport_condition"`
  Status string `json:"status"`
  Remark string `json:"remark"`
  Creator
}

func (record *Order)BeforeSave() error {
  client := Client{Id: record.ClientId}
  Db.First(&client)
  if client.Name == "" {
    return errors.New("client not_exist")
  }
  board_head := BoardHead{}
  Db.Where("available = 1 AND id = ?", record.BoardHeadId).First(&board_head)
  if board_head.Name == "" {
    return errors.New("board_head not_exist")
  }
  // todo valid parent
  // generate sn
  var max_day_number int
  Db.Select("MAX(day_number)").Where("receive_date = ?", record.ReceiveDate).Row().Scan(&max_day_number)
  record.Sn = record.ReceiveDate.Format("20060102") + "-" + strconv.Itoa(max_day_number + 1)
  Db.Save(record)
  return nil
}
