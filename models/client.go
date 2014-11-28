package models

import(
  "net/http"
  "os/exec"
  "errors"
)

type Client struct{
  Id int `json:"id"`
  CompanyId int `json:"company_id"`
  Name string `json:"name"`
  Email string `json:"email"`
  Address string `json:"address"`
  Tel string `json:"tel"`
  Password string `json:"password" sql:"-"`
  EncryptedPassword string `json:"encrypted_password"`
  Creator
}

// tested
func (record *Client) BeforeSave() error {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  if len(record.Email) > 255 || len(record.Email) == 0 {
    return errors.New("email length error")
  }
  return nil
}

func (c *Client)BeforeCreate()error{
  c.Password = c.Email
  cmd := exec.Command(`./blowfish.php`, c.Password)
  result, _ := cmd.Output()
  c.EncryptedPassword = string(result)
  return nil
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
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Order("clients.id DESC").Rows()
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
