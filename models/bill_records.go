package models
import(
  "sequencing/config"
)

type BillRecord struct {
  Id int `json:"id"`
  BillId int `json:"bill_id"`
  Flow string `json:"flow"`
  Data string `json:"data"`
  Creator
}

func (br *BillRecord)AfterCreate()(error){
  var index int
  for i, v := range config.BillFlow {
    if v == br.Flow {
      index = i
      break
    }
  }
  // 4 is payed
  if index < 4 {
    nextFlow := config.BillFlow[index + 1]
    // because mysql forign key, update in a callback will cause lock timeout, so use go routine
    go func(){
      Db.Exec("UPDATE bills SET status = ? WHERE id = ?", nextFlow, br.BillId)
    }()
  }
  return nil
}
