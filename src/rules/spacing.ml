open rule

let apply_spacing_rule content =
  let issues = ref [] in
  let lines = Str.split (Str.regexp "\n") content in
  let rec scan lines line_no =
    match lines with
    | [] -> ()
    | line :: rest ->
       if Str.string_match (Str.regexp ".*[ \t]+$") line 0 then
         issues := { line = line_no; column = String.length line; message = "trailing whitespace" } :: !issues;
       let rec find_double_spaces idx =
         try
           let i = String.index_from line idx ' ' in
           if i + 1 < String.length line && line.[i+1] = ' ' then
             issues := { line = line_no; column = i; message = "multiple consecutive spaces" } :: !issues;
           find_double_spaces (i+1)
         with Not_found -> ()
       in
       find_double_spaces 0;
       scan rest (line_no + 1)
  in
  scan lines 1;
  List.rev !issues

let fix_spacing content =
  let lines = Str.split (Str.regexp "\n") content in
  let fixed_lines = List.map (fun line ->
    let line = Str.global_replace (Str.regexp "[ \t]+$") "" line in
    Str.global_replace (Str.regexp "  +") " " line
  ) lines in
  String.concat "\n" fixed_lines

let rule = make_rule ~name:"spacing" ~apply:apply_spacing_rule ~fix:fix_spacing ~enabled:(fun config -> config.enable_spacing_rule)
