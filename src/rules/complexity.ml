open rule

let threshold = 80

let apply_max_line_length_rule content =
  let issues = ref [] in
  let lines = Str.split (Str.regexp "\n") content in
  let rec scan lines line_no =
    match lines with
    | [] -> ()
    | line :: rest ->
       if String.length line > threshold then
         issues := { line = line_no; column = threshold; message = "line exceeds " ^ string_of_int threshold ^ " characters" } :: !issues;
       scan rest (line_no + 1)
  in
  scan lines 1;
  List.rev !issues

let fix_max_line_length content = content

let rule = make_rule ~name:"max_line_length" ~apply:apply_max_line_length_rule ~fix:fix_max_line_length ~enabled:(fun config -> config.enable_max_line_length_rule)
