package controllers
import (
  "github.com/martini-contrib/render"
  "net/http"
  "sequencing/models"
  //"github.com/go-martini/martini"
  //"strconv"
)

// get the reactions those are not diluted
func DilutePrimers(req *http.Request, r render.Render){
  r.JSON(http.StatusOK, models.DilutingPrimer(req))
}

func CreateDilutePrimer(req *http.Request, r render.Render) {
  models.CreateDilutePrimer(req)
  r.JSON(http.StatusOK, Ok_true)
}
