package models

type Attachment struct {
  Id int `json:"id"`
  TableName string `json:"table_name"`
  RecordId int `json:"record_id"`
  Url string `json:"url"`
  Name string `json:"name"`
}
