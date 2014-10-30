package controllers
import(
  "net/http"
  "github.com/martini-contrib/render"
  "sequencing/models"
  "encoding/json"
)

func TypesettingSampleHeads(req *http.Request, r render.Render){
  r.JSON(http.StatusOK, models.TypesettingSampleHeads())
}

func TypesettingSamples(req *http.Request, r render.Render){
  headId := req.FormValue("board_head_id")
  samples := models.TypesettingSamples(headId)
  r.JSON(http.StatusOK, samples)
}

func TypesetSamples(req *http.Request, r render.Render){
  samples := []models.Sample{}
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&samples)
  if err == nil {
    for _, sample := range samples {
      models.Db.Exec("UPDATE samples SET board_id = ?, hole = ? WHERE id = ?", sample.BoardId, sample.Hole, sample.Id)
    }
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}
