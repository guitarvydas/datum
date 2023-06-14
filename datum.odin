package datum

import "core:mem"
import "core:strings"
import "core:fmt"

Datum :: struct {
    data : rawptr,
    len : int,
    clone : #type proc (self: Datum) -> Datum,
    reclaim : #type proc (pself: ^Datum),
    repr: #type proc (self: Datum) -> string,
    reflection: string
}

clone_datum :: proc (self: Datum) -> Datum {
    d := new (Datum)
    fmt.println ("clone new d", &d, d)
    new_data, _ := mem.alloc (self.len)
    mem.copy (new_data, self.data, self.len)
    d.data = new_data
    d.len = self.len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.repr = self.repr
    d.reflection = self.reflection
    return d^
}

reclaim_datum :: proc (pself: ^Datum) {
  free (pself)
}

create_datum :: proc (p : rawptr, len : int, rep : (#type proc (Datum) -> string), info: string) -> Datum {
    d := new (Datum)
    d.data, _ = mem.alloc (len)
    mem.copy (d.data, p, len)
    d.len = len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.repr = rep
    d.reflection = info
    fmt.println ("create_datum", p, len, d)
    return d^
}

datum_to_string :: proc (d : Datum) -> string {
    return strings.string_from_ptr (transmute(^u8)d.data, d.len)
}



