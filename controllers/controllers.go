/*
  some common methods of controller are here
*/
package controllers
import(
  "net/http"
  "encoding/json"
  "log"
  "sequencing/models"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/sessions"
  "strconv"
)

// for common json render
var Ok_true map[string]bool = map[string]bool{"ok": true}
var Ok_false map[string]bool = map[string]bool{"ok": false}

// parse json from req.Body to struct
func parseJson(record interface{}, req *http.Request) {
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(record)
  if err != nil {
    log.Fatal(err)
  }
}

func initRecords(resources string, req *http.Request)(interface{}, int) {
  switch resources {
  case "sample_heads":
    return models.GetSampleHeads(req)
  case "procedures":
    return models.GetProcedures(req)
  case "roles":
    return models.GetRoles(req)
  case "companies":
    return models.GetCompanies(req)
  default:
    return nil, 0
  }
}

func GetRecords(params martini.Params, req *http.Request, r render.Render) {
  records, count := initRecords(params["resources"], req)
  result := map[string]interface{}{
    "records": records,
    "totalItems": count,
    "perPage": models.PerPage}
  r.JSON(http.StatusOK, result)
}

func initRecord(resources string, id int) models.ValidateSave {
  switch resources {
  case "sample_heads":
    return &models.SampleHead{Id: id}
  case "procedures":
    return &models.Procedure{Id: id}
  case "roles":
    return &models.Role{Id: id}
  case "companies":
    return &models.Company{Id: id}
  default:
    return nil
  }
}

func GetRecord(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  record := initRecord(params["resources"], id)
  models.Db.First(record)
  r.JSON(http.StatusOK, record)
}

// if the creator_id is passed too, it may be updated
// todo: make the creator_id can not be updated
// may be use reflect to make raw sql is a better way
func UpdateRecord(params martini.Params, r render.Render, req *http.Request) {
  id, _ := strconv.Atoi(params["id"])
  //var record models.ValidateSave
  record := initRecord(params["resources"], id)
  parseJson(record, req)
  r.JSON(record.(models.ValidateSave).ValidateSave())
}

func CreateRecord(params martini.Params, r render.Render, req *http.Request, session sessions.Session) {
  //var record models.ValidateSave
  record := initRecord(params["resources"], 0)
  parseJson(record, req)
  record.SetCreator(session.Get("id").(int))
  r.JSON(record.ValidateSave())
}

func DeleteRecord(params martini.Params, r render.Render, req *http.Request) {
  id, _ := strconv.Atoi(params["id"])
  record := initRecord(params["resources"], id)
  models.Db.Delete(record)
  r.JSON(http.StatusOK, record)
}
