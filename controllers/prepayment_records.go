package controllers
import(
  "net/http"
  "sequencing/models"
  "github.com/martini-contrib/render"
)

func PrepaymentRecords(req *http.Request, r render.Render){
  records, _ := models.GetPrepaymentRecords(req)
  r.JSON(http.StatusOK, records)
}
