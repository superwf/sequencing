package models

import(
  "net/http"
)

type Client struct{
  Id int `json:"id"`
  CompanyId int `json:"company_id"`
  Name string `json:"name"`
  Email string `json:"email"`
  Address string `json:"address"`
  Tel string `json:"tel"`
  Creator
}

func (record Client) ValidateSave()(int, interface{}) {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  if len(record.Email) > 200 || len(record.Email) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "email",
      "error": "length"}
  }
  if record.CompanyId == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "company",
      "error": "needed"}
  }
  Db.Save(&record)
  return http.StatusAccepted, record
}

func GetClients(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("clients").Select("clients.id, clients.name, clients.email, clients.tel, clients.address, companies.id, companies.full_name").Joins("LEFT JOIN companies ON companies.id = clients.company_id")
  name := req.FormValue("name")
  email := req.FormValue("email")
  companyName := req.FormValue("companyName")
  companyCode := req.FormValue("companyCode")
  if name != "" {
    db = db.Where("clients.name LIKE ?", (name + "%"))
  }
  if email != "" {
    db = db.Where("clients.email LIKE ?", (email + "%"))
  }
  if companyName != "" {
    db = db.Where("companies.name LIKE ?", (companyName + "%"))
  }
  if companyCode != "" {
    db = db.Where("companies.code LIKE ?", (companyCode + "%"))
  }
  var count int
  db.Count(&count)
  //records := []Client{}
  //db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  defer rows.Close()
  var result []map[string]interface{}
  for rows.Next() {
    var id, companyId int
    var name, email, tel, address, company string
    rows.Scan(&id, &name, &email, &tel, &address, &companyId, &company)
    d := map[string]interface{}{
      "id": id,
      "name": name,
      "email": email,
      "tel": tel,
      "address": address,
      "company_id": companyId,
      "company": company,
    }
    result = append(result, d)
  }
  return result, count
}
