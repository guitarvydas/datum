package datum

import "core:mem"
import "core:fmt"

Datum :: struct {
    data : rawptr,
    len : int,
    clone : #type proc (self: ^Datum) -> Datum,
    reclaim : #type proc (self: ^Datum),
    reflection: string
}

clone_datum :: proc (self: ^Datum) -> Datum {
    d := new (Datum)
    mem.copy (cast(rawptr)d.data, cast(rawptr)self.data, self.len)
    d.len = self.len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.reflection = self.reflection
    return d^
}

reclaim_datum :: proc (self: ^Datum) {
  free (self)
}


main :: proc() {
    fmt.println("*** Begin ***")
    fmt.println("*** Finish ***")
}