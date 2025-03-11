open rule

let apply_naming_rule content =
  let issues = ref [] in
  let re = Str.regexp "let[ \t]+\\([A-Za-z_][A-Za-z0-9_]*\\)" in
  let rec scan_lines lines line_no =
    match lines with
    | [] -> ()
    | line :: rest ->
       if Str.string_match re line 0 then
         let var_name = Str.matched_group 1 line in
         if not (Str.string_match (Str.regexp "^[a-z][a-z0-9_]*$") var_name 0) then
           let col =
             try Str.search_forward re line 0 with Not_found -> 0
           in
           issues := { line = line_no; column = col; message = "naming violation: " ^ var_name } :: !issues;
       scan_lines rest (line_no + 1)
  in
  let lines = Str.split (Str.regexp "\n") content in
  scan_lines lines 1;
  List.rev !issues

let fix_naming content = content

let rule = make_rule ~name:"naming" ~apply:apply_naming_rule ~fix:fix_naming ~enabled:(fun config -> config.enable_naming_rule)
