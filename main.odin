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
    new_data, _ := mem.alloc (self.len)
    mem.copy (new_data, &self.data, self.len)
    d.data = new_data
    d.len = self.len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.reflection = self.reflection
    return d^
}

reclaim_datum :: proc (self: ^Datum) {
  free (self)
}

create_datum :: proc (p : rawptr, len : int, info: string) -> Datum {
    d := new (Datum)
    mem.copy (&d.data, p, len)
    d.len = len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.reflection = info
    return d^
}


main :: proc() {
    fmt.println("*** Begin ***")
    s := "hello world"
    fmt.println("--- A ---")
    d := create_datum (raw_data (s), len (s), "StringDatum")
    fmt.println("--- B ---")
    fmt.println (d)
    fmt.println("--- C ---")
    d2 := d.clone (&d)
    fmt.println("--- D ---")
    fmt.println (d2)
    fmt.println("*** Finish ***")
}