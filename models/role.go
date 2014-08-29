package models

type Role struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Menus []Menu `gorm:"many2many:menus_roles"`
  Users []User
}
