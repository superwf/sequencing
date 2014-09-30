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
    //m.Get("/users", controllers.GetUsers)
    m.Get("/me", controllers.Me)
    m.Post("/login", controllers.Login)
    m.Delete("/logout", controllers.Logout)
    //m.Get("/menus", controllers.GetMenus)
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
    m.Post("/reactionFiles/:board/:file", controllers.CreateReactionFile)
    m.Get("/reactionFiles", controllers.ReactionFiles)
    m.Get("/downloadingReactionFiles", controllers.DownloadingReactionFiles)
    m.Get("/downloadReactionFiles", controllers.DownloadReactionFiles)
    //m.Delete("/primerHeads/:id", controllers.DeleteBoardHead)
    m.Get("/testing", controllers.Testing)

    // for simple rest request
    m.Get("/:resources", controllers.GetRecords)
    m.Post("/:resources", controllers.CreateRecord)
    m.Get("/:resources/:id", controllers.GetRecord)
    m.Put("/:resources/:id", controllers.UpdateRecord)
    m.Delete("/:resources/:id", controllers.DeleteRecord)

  })

  http.ListenAndServe(Config["port"].(string), m)
}

func requireLogin(c martini.Context, session sessions.Session, r render.Render, req *http.Request) {
  path := req.URL.String()
  if session.Get("me") == nil && path != "/api/v1/login" && !strings.HasPrefix(path, "/api/v1/reactionFiles") {
    r.JSON(http.StatusUnauthorized, map[string]string{"error": "need login"})
  } else {
    c.Next()
  }
}
