package models

import(
  "net/http"
  "errors"
)

type Company struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Code string `json:"code"`
  ParentId int `json:"parent_id"`
  Price float64 `json:"price"`
  FullName string `json:"full_name"`
  FullCode string `json:"full_code"`
  Client []Client
  Creator
}

// tested
func GetCompanies(req *http.Request)([]Company, int){
  page := getPage(req)
  db := Db.Model(Company{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }

  code := req.FormValue("code")
  absolute_code := req.FormValue("absolute_code")
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

// tesetd
func (c *Company)GenerateFullName(){
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
  c.FullName = full_name
}

// tested
func (c *Company)GenerateFullCode(){
  parent_id := c.ParentId
  full_code := c.Code
  for {
    if parent_id > 0 {
      parent := Company{Id: parent_id}
      Db.First(&parent)
      full_code = parent.Code + full_code
      parent_id = parent.ParentId
    } else {
      break
    }
  }
  c.FullCode = full_code
}

// tested
func (record *Company) BeforeSave() error {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  if len(record.Code) > 255 || len(record.Code) == 0 {
    return errors.New("code length error")
  }
  if record.ParentId != 0 && record.ParentId == record.Id {
    return errors.New("parent self_parent")
  }
  r := &record
  r.GenerateFullCode()
  r.GenerateFullName()
  return nil
}

// tested
func (c *Company)Children()([]Company) {
  records := []Company{}
  Db.Table("companies").Where("parent_id = ?", c.Id).Find(&records)
  return records
}

// tested
func (c Company)ChildrenCount()(int){
  var count int
  Db.Model(Company{}).Where("parent_id = ?", c.Id).Count(&count)
  return count
}

// tested
func (c Company)Parent()(Company) {
  if c.ParentId == 0 {
    return Company{}
  } else {
    parent := Company{Id: c.ParentId}
    Db.First(&parent)
    return parent
  }
}


// client restirct by forign key
// tested
func (company *Company)BeforeDelete()error{
  if company.ChildrenCount() > 0 {
    return errors.New("children company exist")
  }
  return nil
}
