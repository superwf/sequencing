package controllers
import(
  "net/http"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "sequencing/models"
  "time"
)

func GetBillRecord(params martini.Params, req *http.Request, r render.Render){
  var record models.BillRecord
  models.Db.First(&record)
  r.JSON(http.StatusOK, record)
}

func CreateBillRecord(r render.Render, req *http.Request, session sessions.Session){
  var record models.BillRecord
  parseJson(&record, req)
  creatorId := session.Get("id").(int)
  now := time.Now()
  models.Db.Exec("INSERT INTO bill_records(bill_id, data, creator_id, created_at, updated_at) VALUES(?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE data=VALUES(data), updated_at = VALUES(updated_at)", record.BillId, record.Data, creatorId, now, now)
  r.JSON(http.StatusOK, record)
}

func UpdateBillRecord(r render.Render, req *http.Request){
  var record models.BillRecord
  parseJson(&record, req)
  saved := models.Db.Save(record)
  renderDbResult(r, saved, record)
}
