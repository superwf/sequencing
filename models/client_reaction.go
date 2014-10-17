package models

import(
  "net/http"
  "time"
  "errors"
  "database/sql"
)

type ClientReaction struct {
  Id int `json:"id"`
  Sample string `json:"sample"`
  Primer string `json:"primer"`
  SampleType string `json:"sample_type"`
  Structure string `json:"structure"`
  ClientId int `json:"client_id"`
  Vector string `json:"vector"`
  Resistance string `json:"resistance"`
  Fragment string `json:"fragment"`
  IsSplice bool `json:"is_splice"`
  Remark string `json:"remark"`
  ReactionId int `json:"reaction_id"`
  CreatedAt time.Time `json:"created_at"`
  UpdatedAt time.Time `json:"updated_at"`
}

func GetClientReactions(req *http.Request)(map[string]interface{}){
  db := Db.Select("client_reactions.id, client_reactions.sample, client_reactions.primer, client_reactions.is_splice, client_reactions.sample_type, client_reactions.structure, client_reactions.client_id, client_reactions.vector, client_reactions.resistance, client_reactions.fragment, client_reactions.remark, vectors.id").Table("client_reactions").Joins("LEFT JOIN vectors ON client_reactions.vector = vectors.name").Order("client_reactions.id DESC")
  page := getPage(req)
  receive := req.FormValue("receive")
  if receive == "false" {
    db = db.Where("reaction_id = 0")
  }
  var count int
  db.Count(&count)
  perPage := 96
  result := []map[string]interface{}{}
  rows, _ := db.Limit(perPage).Offset(page * PerPage).Rows()
  for rows.Next(){
    var sample, primer, sampleType, structure, vector, resistance, fragment, remark string
    var id, clientId int
    var vectorId sql.NullInt64
    var isSplice bool
    rows.Scan(&id, &sample, &primer, &isSplice, &sampleType, &structure, &clientId, &vector, &resistance, &fragment, &remark, &vectorId)
    d := map[string]interface{}{
      "id": id,
      "sample": sample,
      "primer": primer,
      "is_splice": isSplice,
      "board_head": sampleType + structure,
      "client_id": clientId,
      "vector": vector,
      "vector_id": vectorId.Int64,
      "resistance": resistance,
      "fragment": fragment,
      "remark": remark,
    }
    var p Primer
    Db.Where("client_id = ? AND name = ? AND available = 1", d["client_id"], d["primer"]).First(&p)
    if p.Id > 0 {
      d["primer_id"] = p.Id
    }
    result = append(result, d)
  }
  return map[string]interface{}{
    "records": result,
    "totalItems": count,
    "perPage": perPage,
  }
}

func (clientReaction *ClientReaction)BeforeDelete()error{
  Db.First(clientReaction)
  if clientReaction.ReactionId > 0 {
    return errors.New("already receive")
  }
  return nil
}
