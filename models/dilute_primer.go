package models

type DilutePrimer struct {
  PrimerId int `json:"primer_id"`
  Status string `json:"status"`
  Remark string `json:"remark"`
  Creator
}

func NewDilutePrimer() {
  Db.Query("SELECT primers.name, boards.sn, orders.sn, clients.name FROM primers INNER JOIN reactions ON primers.id = reactions.primer_id INNER JOIN boards ON primers.board_id = boards.id INNER JOIN samples ON reactions.sample_id  = samples.id INNER JOIN orders ON orders.id = samples.order_id INNER JOIN clients ON clients.id = orders.client_id WHERE reactions.dilute_primer_id = 0")
}
