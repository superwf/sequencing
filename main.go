package main

import (
  "github.com/go-martini/martini"
  "net/http"
  "github.com/martini-contrib/sessions"
  "sequencing/config"
  "github.com/martini-contrib/render"
  "sequencing/controllers"
  "strings"
)

var m *martini.ClassicMartini

func main() {
  Config := config.Config

  // load session cache config
  redis_config := Config["redis"].(map[interface{}]interface{})
  session_config := Config["session"].(map[interface{}]interface{})

  m = martini.Classic()
  store, err := sessions.NewRediStore(session_config["size"].(int), redis_config["network"].(string), redis_config["address"].(string), redis_config["password"].(string), []byte(session_config["key"].(string)))
  if(err != nil) {
    panic(err)
  }
  m.Use(sessions.Sessions(session_config["name"].(string), store))
  m.Use(render.Renderer())
  m.Use(requireLogin)
  m.Group("/api/v1", func(r martini.Router) {
    m.Put("/roles/:id", controllers.UpdateRole)
    m.Get("/companyTree/:id", controllers.GetCompanyTree)
    m.Post("/orders", controllers.CreateOrder)
    m.Post("/boards", controllers.CreateBoard)
    m.Post("/flows", controllers.CreateFlow)
    m.Delete("/flows/:id", controllers.DeleteFlow)
    m.Get("/boardRecords/:idsn", controllers.BoardRecords)
    m.Put("/boards/:id/confirm", controllers.ConfirmBoard)
    m.Put("/boards/:id/nextProcedure", controllers.BoardNextProcedure)
    m.Get("/boards/:id", controllers.GetBoard)
    m.Post("/plasmids", controllers.CreatePlasmid)
    m.Post("/prechecks", controllers.CreatePrecheck)
    m.Get("/dilutePrimers", controllers.DilutePrimers)
    m.Post("/dilutePrimers", controllers.CreateDilutePrimer)
    //m.Get("/typeset/reactions", controllers.TypesetReactions)
    m.Get("/typeset/reactionSampleBoards", controllers.TypesetReactionSampleBoards)
    m.Get("/sampleBoardPrimers/:id", controllers.SampleBoardPrimers)
    m.Put("/reactions", controllers.UpdateReactions)
    m.Get("/downloadingReactionFiles", controllers.DownloadingReactionFiles)
    m.Get("/downloadReactionFiles", controllers.DownloadReactionFiles)
    m.Get("/interpretingReactionFiles", controllers.InterpretingReactionFiles)
    m.Put("/interprete", controllers.Interprete)
    //m.Delete("/primerHeads/:id", controllers.DeleteBoardHead)
    m.Get("/sendingOrderMails", controllers.SendingOrderMails)
    m.Get("/interpretedReactionFiles/:id", controllers.InterpretedReactionFiles)
    m.Post("/orderMails", controllers.CreateOrderMail)
    m.Put("/submitInterpretedReactionFiles", controllers.SubmitInterpretedReactionFiles)
    m.Put("/reinterprete", controllers.Reinterprete)
    m.Post("/bills", controllers.CreateBill)
    m.Get("/menus", controllers.GetMenus)
    m.Get("/testing", controllers.Testing)
    m.Get("/billOrders/:bill_id", controllers.GetBillOrders)

    // for simple rest request
    m.Get("/:resources", controllers.GetRecords)
    m.Post("/:resources", controllers.CreateRecord)
    m.Get("/:resources/:id", controllers.GetRecord)
    m.Put("/:resources/:id", controllers.UpdateRecord)
    m.Delete("/:resources/:id", controllers.DeleteRecord)

  })
  m.Group("/api/auth", func(r martini.Router) {
    m.Get("/me", controllers.Me)
    m.Post("/login", controllers.Login)
    m.Delete("/logout", controllers.Logout)
  })
  m.Group("/api/reactionFiles", func(r martini.Router) {
    m.Get("/uploading", controllers.UploadingReactionBoards)
    m.Post("/:board/:file", controllers.CreateReactionFile)
  })
  m.Get("/api/consts", controllers.Consts)

  http.ListenAndServe(Config["port"].(string), m)
}

// skip /reactionFiles, /api/login
func requireLogin(c martini.Context, session sessions.Session, r render.Render, req *http.Request) {
  path := req.URL.String()
  if session.Get("me") == nil && strings.HasPrefix(path, "/api/v1") {
    r.JSON(http.StatusUnauthorized, map[string]string{"hint": "need login"})
  } else {
    c.Next()
  }
}
