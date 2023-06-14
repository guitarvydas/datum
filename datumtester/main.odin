package datumtester

import "core:fmt"
import datum "../"

main :: proc() {
    fmt.println("*** Begin ***")
    s := "hello world"
    fmt.println("--- A ---")
    d := datum.create_datum (raw_data (s), len (s), datum.datum_to_string, "StringDatum")
    fmt.println("--- B ---")
    fmt.println (d)
    fmt.println("--- b ---")
    s2 := d.repr (d)
    fmt.println (s2)
    fmt.println("--- C ---")
    d2 := d.clone (d)
    fmt.println("--- D ---")
    fmt.println ("after cloning", d2)
    fmt.println("--- E ---")
    s3 := d2.repr (d2)
    fmt.println (s3)
    fmt.println("*** Finish ***")
}
