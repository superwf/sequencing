package models

func SavePcRelation(parentId int, childId int, tableName string){
  Db.Exec("INSERT INTO pc_relations(parent_id, child_id, table_name) VALUES(?, ?, ?)", parentId, childId, tableName)
}
