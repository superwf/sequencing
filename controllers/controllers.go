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

func modelsMap(resources string, id int)models.ValidateSave {
  switch resources {
  case "sample_heads":
    return &models.SampleHead{Id: id}
  case "procedures":
    return &models.Procedure{Id: id}
  default:
    return nil
  }
}

func GetRecord(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  record := modelsMap(params["resources"], id)
  models.Db.First(record)
  r.JSON(http.StatusOK, record)
}

func UpdateRecord(params martini.Params, r render.Render, req *http.Request) {
  id, _ := strconv.Atoi(params["id"])
  var record models.ValidateSave
  record = modelsMap(params["resources"], id)
  parseJson(record, req)
  //models.Db.Save(record)
  r.JSON(record.ValidateSave())
}

func CreateRecord(params martini.Params, r render.Render, req *http.Request, session sessions.Session) {
  record := modelsMap(params["resources"], 0)
  parseJson(&record, req)
  //record.CreatorId = session.Get("id").(int)
  r.JSON(record.ValidateSave())
}
