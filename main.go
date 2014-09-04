package main

import (
  "github.com/go-martini/martini"
  "net/http"
  "github.com/martini-contrib/sessions"
  "sequencing/config"
  "github.com/martini-contrib/render"
  "sequencing/controllers"
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
    m.Get("/users", controllers.GetUsers)
    m.Get("/me", controllers.Me)
    m.Post("/login", controllers.Login)
    m.Delete("/logout", controllers.Logout)
    m.Get("/procedures", controllers.GetProcedures)
    //m.Post("/procedures", controllers.CreateProcedure)
    //m.Put("/procedures/:id", controllers.UpdateProcedure)
    m.Delete("/procedures/:id", controllers.DeleteProcedure)

    m.Get("/sample_heads", controllers.GetSampleHeads)
    //m.Post("/sample_heads", controllers.CreateSampleHead)
    m.Post("/:resources", controllers.CreateRecord)
    m.Get("/:resources/:id", controllers.GetRecord)
    m.Put("/:resources/:id", controllers.UpdateRecord)
    //m.Delete("/sample_heads/:id", controllers.DeleteSampleHead)

    //m.Get("/testing", controllers.Testing)
  })

  http.ListenAndServe(Config["port"].(string), m)
}

func requireLogin(c martini.Context, session sessions.Session, r render.Render, req *http.Request) {
  if session.Get("me") == nil && req.URL.String() != "/api/v1/login" {
    r.JSON(http.StatusUnauthorized, map[string]string{"error": "need login"})
  } else {
    c.Next()
  }
}