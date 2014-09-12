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
  defer func(){
    if r := recover(); r != nil {
      log.Fatal(r)
    }
  }()
}

func initRecords(resources string, req *http.Request)(interface{}, int) {
  switch resources {
  case "sampleHeads":
    return models.GetSampleHeads(req)
  case "procedures":
    return models.GetProcedures(req)
  case "roles":
    return models.GetRoles(req)
  case "companies":
    return models.GetCompanies(req)
  case "clients":
    return models.GetClients(req)
  case "boardHeads":
    return models.GetBoardHeads(req)
  case "primerBoards":
    return models.GetPrimerBoards(req)
  case "vectors":
    return models.GetVectors(req)
  case "primers":
    return models.GetPrimers(req)
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

// resources and id are the route params
func initRecord(resources string, id int) models.RecordCreator {
  switch resources {
  case "sampleHeads":
    return &models.SampleHead{Id: id}
  case "procedures":
    return &models.Procedure{Id: id}
  case "roles":
    return &models.Role{Id: id}
  case "companies":
    return &models.Company{Id: id}
  case "clients":
    return &models.Client{Id: id}
  case "boardHeads":
    return &models.BoardHead{Id: id}
  case "primerBoards":
    return &models.PrimerBoard{Id: id}
  case "vectors":
    return &models.Vector{Id: id}
  case "primers":
    return &models.Primer{Id: id}
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
  record := initRecord(params["resources"], id)
  parseJson(record, req)
  //r.JSON(record.(models.ValidateSave).ValidateSave())
  saved := models.Db.Save(record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": saved.Error.Error()})
  } else {
    r.JSON(http.StatusAccepted, record)
  }
}

func CreateRecord(params martini.Params, r render.Render, req *http.Request, session sessions.Session) {
  //var record models.ValidateSave
  record := initRecord(params["resources"], 0)
  parseJson(record, req)
  record.SetCreator(session.Get("id").(int))
  saved := models.Db.Save(record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": saved.Error.Error()})
  } else {
    r.JSON(http.StatusAccepted, record)
  }
}

func DeleteRecord(params martini.Params, r render.Render, req *http.Request) {
  id, _ := strconv.Atoi(params["id"])
  record := initRecord(params["resources"], id)
  deleted := models.Db.Delete(record)
  if deleted.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": deleted.Error.Error()})
  } else {
    r.JSON(http.StatusOK, record)
  }
}
