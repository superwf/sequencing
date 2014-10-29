package models_test
import (
  "sequencing/models"
)

func prepare_flows(count int) {
  prepare_board_heads(count)
  prepare_procedures(count)
  for i := 0; i < count; i++ {
    head := models.BoardHead{}
    models.Db.First(&head)
    procedure := models.Procedure{}
    models.Db.First(&procedure)
    flow := models.Flow{BoardHeadId: head.Id, ProcedureId: procedure.Id}
    models.Db.Save(&flow)
  }
}
