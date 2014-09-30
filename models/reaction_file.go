package models

import(
  "time"
  //"strconv"
  //"errors"
  "net/http"
  //"strings"
)

type ReactionFile struct {
  ReactionId int `json:"reaction_id" gorm:"primary_key:yes"`
  CreatedAt time.Time `json:"created_at"`
  UpdatedAt time.Time `json:"updated_at"`
}

// the not interpreted
func DownloadingReactionFiles(req *http.Request)([]map[string]interface{}){
  rows, _ := Db.Select("reaction_files.reaction_id, reaction_files.created_at, samples.name, sample_boards.sn, samples.hole, orders.sn, primers.name, reaction_boards.sn, reactions.hole").Table("reaction_files").Joins("LEFT JOIN interpretes ON reaction_files.reaction_id = interpretes.reaction_id INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN orders ON samples.order_id = orders.id INNER JOIN boards AS sample_boards ON sample_boards.id = samples.board_id INNER JOIN boards AS reaction_boards ON reaction_boards.id = reactions.board_id INNER JOIN clients ON orders.client_id = clients.id INNER JOIN primers ON reactions.primer_id = primers.id").Where("interpretes.reaction_id IS NULL").Rows()
  result := []map[string]interface{}{}
  for rows.Next() {
    var reactionId int
    var uploadTime time.Time
    var sample, sampleBoard, sampleHole, reactionBoard, reactionHole, order, client, primer string
    rows.Scan(&reactionId, &uploadTime, &sample, &sampleBoard, &sampleHole, &order, &primer, &reactionBoard, &reactionHole)
    d := map[string]interface{}{
      "id": reactionId,
      "client": client,
      "order": order,
      "sample": sample,
      "sample_board": sampleBoard,
      "sample_hole": sampleHole,
      "primer": primer,
      "reaction_board": reactionBoard,
      "reaction_hole": reactionHole,
      "upload_time": uploadTime.Local(),
    }
    result = append(result, d)
  }
  return result
}
