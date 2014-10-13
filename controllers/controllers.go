/*
  some common methods of controller are here
*/
package controllers
import(
  "github.com/jinzhu/gorm"
  "net/http"
  "encoding/json"
  "log"
  "sequencing/models"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/sessions"
  "strconv"
  "reflect"
)

// for common json render
var Ok_true map[string]bool = map[string]bool{"ok": true}
var Ok_false map[string]bool = map[string]bool{"ok": false}

// parse json from req.Body to struct
func parseJson(record interface{}, req *http.Request) {
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(record)
  if err != nil {
    panic(err)
  }
  defer func(){
    if r := recover(); r != nil {
      log.Fatal(r)
    }
  }()
}

func initRecords(resources string, req *http.Request)(interface{}, int) {
  switch resources {
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
  case "vectors":
    return models.GetVectors(req)
  case "primers":
    return models.GetPrimers(req)
  case "orders":
    return models.GetOrders(req)
  case "samples":
    return models.GetSamples(req)
  case "reactions":
    return models.GetReactions(req)
  case "boards":
    return models.GetBoards(req)
  case "plasmidCodes":
    return models.GetPlasmidCodes(req)
  case "precheckCodes":
    return models.GetPrecheckCodes(req)
  case "plasmids":
    return models.GetPlasmids(req)
  case "prechecks":
    return models.GetPrechecks(req)
  case "interpreteCodes":
    return models.GetInterpreteCodes(req)
  case "orderMails":
    return models.GetOrderMails(req)
  case "bills":
    return models.GetBills(req)
  //case "reactinoFiles":
  //  return models.GetReactionFiles(req)
  default:
    return nil, 0
  }
}

func GetRecords(params martini.Params, req *http.Request, r render.Render) {
  all := req.FormValue("all")
  records, count := initRecords(params["resources"], req)
  if len(all) > 0 {
    r.JSON(http.StatusOK, records)
  } else {
    result := map[string]interface{}{
      "records": records,
      "totalItems": count,
      "perPage": models.PerPage,
    }
    r.JSON(http.StatusOK, result)
  }
}

// resources and id are the route params
func initRecord(resources string, id int)(interface{}) {
  switch resources {
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
  case "vectors":
    return &models.Vector{Id: id}
  case "primers":
    return &models.Primer{Id: id}
  case "orders":
    return &models.Order{Id: id}
  case "boardRecords":
    return &models.BoardRecord{Id: id}
  case "plasmidCodes":
    return &models.PlasmidCode{Id: id}
  case "precheckCodes":
    return &models.PrecheckCode{Id: id}
  case "interpreteCodes":
    return &models.InterpreteCode{Id: id}
  case "bills":
    return &models.Bill{Id: id}
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
  renderDbResult(r, saved, record)
}

func CreateRecord(params martini.Params, r render.Render, req *http.Request, session sessions.Session) {
  record := initRecord(params["resources"], 0)
  parseJson(record, req)
  creatorId := session.Get("id").(int)
  e := reflect.ValueOf(record).Elem()
  f := e.FieldByName("CreatorId")
  if f.IsValid() && f.CanSet() {
    f.Set(reflect.ValueOf(creatorId))
  }
  saved := models.Db.Save(record)
  renderDbResult(r, saved, record)
}

func DeleteRecord(params martini.Params, r render.Render, req *http.Request) {
  id, _ := strconv.Atoi(params["id"])
  record := initRecord(params["resources"], id)
  deleted := models.Db.Delete(record)
  renderDbResult(r, deleted, record)
}

func renderDbResult(r render.Render, result *gorm.DB, record interface{}) {
  if result.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": result.Error.Error()})
  } else {
    r.JSON(http.StatusOK, record)
  }
}
