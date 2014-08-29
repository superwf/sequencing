package controllers
import(
  "net/http"
  "encoding/json"
  "log"
)

var Ok_true map[string]bool = map[string]bool{"ok": true}
var Ok_false map[string]bool = map[string]bool{"ok": false}

// parse json from req.Body to struct
func parseJson(record interface{}, req *http.Request) {
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&record)
  if err != nil {
    log.Fatal(err)
  }
}
