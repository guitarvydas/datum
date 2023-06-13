package datumtester

import "core:fmt"
import "../"

main :: proc() {
    fmt.println("*** Begin ***")
    s := "hello world"
    fmt.println("--- A ---")
    d := datum.create_datum (raw_data (s), len (s), "StringDatum")
    fmt.println("--- B ---")
    fmt.println (d)
    fmt.println("--- b ---")
    s2 := datum.datum_to_string (d)
    fmt.println (s2)
    fmt.println("--- C ---")
    d2 := d.clone (d)
    fmt.println("--- D ---")
    fmt.println ("after cloning", d2)
    fmt.println("--- E ---")
    s3 := datum.datum_to_string (d2)
    fmt.println (s3)
    fmt.println("*** Finish ***")
}
