open yojson.basic
open config
open rules.rule

let report_issues file config issues =
  let output =
    match config.output_format with
    | "json" ->
       let json_issues = `List (List.map (fun issue ->
         `Assoc [("file", `String file); ("line", `Int issue.line); ("column", `Int issue.column); ("message", `String issue.message)]
       ) issues) in
       Yojson.Basic.pretty_to_string json_issues
    | _ ->
       if issues = [] then "no issues found in " ^ file
       else String.concat "\n" (List.map (fun issue ->
         Printf.sprintf "file: %s, line %d, column %d: %s" file issue.line issue.column issue.message
       ) issues)
  in
  match config.output_file with
  | Some out_file when out_file <> "" ->
     let oc = open_out_gen [Open_creat; Open_append; Open_text] 0o644 out_file in
     output_string oc (output ^ "\n");
     close_out oc
  | _ -> print_endline output
