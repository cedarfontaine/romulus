open yojson.basic.util

type config = {
  enable_naming_rule : bool;
  enable_spacing_rule : bool;
  enable_max_line_length_rule : bool;
  enable_complexity_rule : bool;
  enable_unused_variable_rule : bool;
  fix_mode : bool;
  verbose : bool;
  output_format : string;
  output_file : string option;
}

let default_config = {
  enable_naming_rule = true;
  enable_spacing_rule = true;
  enable_max_line_length_rule = true;
  enable_complexity_rule = true;
  enable_unused_variable_rule = true;
  fix_mode = false;
  verbose = false;
  output_format = "text";
  output_file = None;
}

let load_config () =
  try
    let json = Yojson.Basic.from_file "romulus.conf" in
    let enable_naming_rule = json |> member "enable_naming_rule" |> to_bool in
    let enable_spacing_rule = json |> member "enable_spacing_rule" |> to_bool in
    let enable_max_line_length_rule = json |> member "enable_max_line_length_rule" |> to_bool in
    let enable_complexity_rule = json |> member "enable_complexity_rule" |> to_bool in
    let enable_unused_variable_rule = json |> member "enable_unused_variable_rule" |> to_bool in
    let fix_mode = json |> member "fix_mode" |> to_bool in
    let verbose = json |> member "verbose" |> to_bool in
    let output_format = json |> member "output_format" |> to_string in
    let output_file =
      try Some (json |> member "output_file" |> to_string)
      with _ -> None
    in
    { enable_naming_rule; enable_spacing_rule; enable_max_line_length_rule; enable_complexity_rule; enable_unused_variable_rule; fix_mode; verbose; output_format; output_file }
  with _ -> default_config
