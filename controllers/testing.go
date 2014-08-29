package controllers
import (
  "net/http"
)
func Testing(req *http.Request) string {
  return req.URL.String()
}
