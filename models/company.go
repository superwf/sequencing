package models

import(
  "net/http"
)

type Company struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Code string `json:"code"`
  ParentId int `json:"parent_id"`
  Price float64 `json:"price"`
  FullName string `json:"full_name"`
  Client []Client
  Creator
}

func (record Company) ValidateSave()(int, interface{}) {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  if record.ParentId != 0 && record.ParentId == record.Id {
    return http.StatusNotAcceptable, map[string]string{
      "field": "parent",
      "error": "self_parent"}
  }
  record.FullName = record.GetFullName()
  Db.Save(&record)
  return http.StatusAccepted, record
}

func GetCompanies(req *http.Request)([]Company, int){
  page := getPage(req)
  db := Db.Model(Company{})
  name := req.FormValue("name")
  code := req.FormValue("code")
  absolute_code := req.FormValue("absolute_code")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  if code != "" {
    if absolute_code == "true" {
      db = db.Where("code = ?", code)
    } else {
      db = db.Where("code LIKE ?", (code + "%"))
    }
  }
  var count int
  db.Count(&count)
  records := []Company{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func GetRootCompanies()([]Company){
  records := []Company{}
  Db.Model(Company{}).Scopes(RootTree).Find(&records)
  return records
}

func GetCompanyTree(id int)([]Company) {
  records := []Company{}
  Db.Model(Company{}).Scopes(ChildrenTree(id)).Find(&records)
  return records
}

func (c Company)GetChildrenCount()(int){
  var count int
  Db.Model(Company{}).Scopes(ChildrenTree(c.Id)).Count(&count)
  return count
}

func (c Company)Parent()(Company) {
  if c.ParentId == 0 {
    return Company{}
  } else {
    parent := Company{Id: c.ParentId}
    Db.First(&parent)
    return parent
  }
}

func (c Company)GetFullName()(string){
  parent_id := c.ParentId
  full_name := c.Name
  for {
    if parent_id > 0 {
      parent := Company{Id: parent_id}
      Db.First(&parent)
      full_name = parent.Name + "-" + full_name
      parent_id = parent.ParentId
    } else {
      break
    }
  }
  return full_name
}

func DeleteCompany(id int)(int, interface{}){
  company := Company{Id: id}
  Db.Model(Company{}).First(&company)
  if company.GetChildrenCount() > 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "company",
      "error": "exist"}
  }
  var client Client
  Db.Model(Client{}).Where("company_id = ?", id).First(&client)
  if client.Id > 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "client",
      "error": "exist"}
  }
  Db.Delete(&company)
  return http.StatusAccepted, company
}
