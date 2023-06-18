package datum

import "core:mem"
import "core:strings"
import "core:slice"
import "core:fmt"
import "core:log"

Datum :: struct {
    ptr : rawptr,
    len : int,
    clone : #type proc (self: Datum) -> Datum,
    reclaim : #type proc (pself: Datum),
    repr: #type proc (self: Datum) -> string,
    reflection: string
}

clone_datum :: proc (self: Datum) -> Datum {
    d := new (Datum)
    new_ptr, _ := mem.alloc (self.len)
    mem.copy (new_ptr, self.ptr, self.len)
    d.ptr = new_ptr
    d.len = self.len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.repr = self.repr
    d.reflection = strings.clone (self.reflection)
    return d^
}

reclaim_datum :: proc (self: Datum) {
    mem.free_with_size (self.ptr, self.len)
    reclaim_reflection (self)
}

clone_reflection :: proc (refl : string) -> string {
  return strings.clone (refl)
}

reclaim_reflection :: proc (self: Datum) {
    // this POC uses strings in the reflection field
    // later, we might want to beef up what .reflection contains
    // so we provide this proc to clean that up, whatever it will be
    delete_string (self.reflection)
}
    
create_datum :: proc (p : rawptr, len : int, rep : (#type proc (Datum) -> string), info: string) -> Datum {
    d := new (Datum)
    d.ptr, _ = mem.alloc (len)
    mem.copy (d.ptr, p, len)
    d.len = len
    d.clone = clone_datum
    d.reclaim = reclaim_datum
    d.repr = rep
    d.reflection = strings.clone (info)
    return d^
}

datum_to_string :: proc (d : Datum) -> string {
    return strings.string_from_ptr (transmute(^u8)d.ptr, d.len)
}

str :: proc (s : string) -> Datum {
    repr_string :: proc (sd : Datum) -> string {
        return fmt.aprint (strings.string_from_ptr (transmute(^u8)sd.ptr, sd.len))
    }
    d := create_datum (raw_data (s), len (s), repr_string, "string")
    return d
}



bytes :: proc (d : Datum) -> [dynamic]byte {
    fixedbytes := slice.bytes_from_ptr (d.ptr, d.len)
    bytes := slice.into_dynamic (fixedbytes)
    return bytes
}