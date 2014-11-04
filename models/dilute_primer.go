package models
import (
  "net/http"
  "strconv"
  "encoding/json"
)

type DilutePrimer struct {
  Id int `json:"id"`
  PrimerId int `json:"primer_id"`
  OrderId int `json:"order_id"`
  Status string `json:"status"`
  Remark string `json:"remark"`
  Creator
}

func DilutingPrimer(req *http.Request)([]map[string]interface{}) {
  rows, _ := Db.Table("reactions").Select("DISTINCT primers.id, primers.name, primer_boards.sn, clients.name, orders.id, orders.sn, sample_boards.sn, primers.origin_thickness, primers.remark").Joins("INNER JOIN samples ON samples.id = reactions.sample_id INNER JOIN boards AS sample_boards ON samples.board_id = sample_boards.id INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id INNER JOIN primers ON reactions.primer_id = primers.id INNER JOIN boards AS primer_boards ON primers.board_id = primer_boards.id").Where("reactions.dilute_primer_id = 0 AND sample_boards.status <> 'new'").Rows()
  result := []map[string]interface{}{}
  for rows.Next() {
    var orderId, primerId, reactionsCount int
    var order, client, primer, primerBoard, sampleBoard, originThickness, primerRemark string
    rows.Scan(&primerId, &primer, &primerBoard, &client, &orderId, &order, &sampleBoard, &originThickness, &primerRemark)
    Db.Select("COUNT(reactions.id)").Table("reactions").Where("reactions.dilute_primer_id = 0 AND boards.status <> 'new' AND reactions.primer_id = ?", primerId).Row().Scan(&reactionsCount)
    d := map[string]interface{}{
      "primer_id": primerId,
      "primer": primer,
      "primer_board": primerBoard,
      "client": client,
      "order": order,
      "order_id": orderId,
      "sample_board": sampleBoard,
      "origin_thickness": originThickness,
      "reactions_count": reactionsCount,
      "primer_remark": primerRemark,
    }
    result = append(result, d)
  }
  return result
}

func CreateDilutePrimer(req *http.Request) {
  var records []DilutePrimer
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&records)
  if err != nil {
    panic(err)
  }
  for _, r := range(records) {
    Db.Save(&r)
    if r.Id > 0 {
      Db.Begin()
      Db.Exec("UPDATE reactions, samples, boards SET reactions.dilute_primer_id = " + strconv.Itoa(r.Id) + " WHERE boards.status <> 'new' AND reactions.primer_id = " + strconv.Itoa(r.PrimerId) + " AND reactions.dilute_primer_id = 0 AND samples.id = reactions.sample_id AND boards.id = samples.board_id")
      var count int
      Db.Table("reactions").Where("dilute_primer_id = ?", r.Id).Count(&count)
      //if count == 0 {
      //  Db.Rollback()
      //}
    }
    //else {
    //  Db.Rollback()
    //}
    //Db.Commit()
  }
}
