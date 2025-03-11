open rule

let apply_unused_variable_rule content =
  let issues = ref [] in
  let lines = Str.split (Str.regexp "\n") content in
  let var_defs = ref [] in
  let rec collect_defs lines line_no =
    match lines with
    | [] -> ()
    | line :: rest ->
       if Str.string_match (Str.regexp "let[ \t]+\\([a-zA-Z_][a-zA-Z0-9_']*\\)") line 0 then
         let var_name = Str.matched_group 1 line in
         var_defs := (var_name, line_no) :: !var_defs;
       collect_defs rest (line_no + 1)
  in
  collect_defs lines 1;
  List.iter (fun (var, line_no) ->
    if not (Str.string_match (Str.regexp (".*\\b" ^ var ^ "\\b.*")) content 0) then
      issues := { line = line_no; column = 0; message = "unused variable: " ^ var } :: !issues
  ) !var_defs;
  List.rev !issues

let fix_unused_variable content = content

let rule = make_rule ~name:"unused_variable" ~apply:apply_unused_variable_rule ~fix:fix_unused_variable ~enabled:(fun config -> config.enable_unused_variable_rule)
