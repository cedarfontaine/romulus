open config

let config = ref default_config
let paths = ref []

let set_fix_mode b =
  config := { !config with fix_mode = b }

let set_verbose b =
  config := { !config with verbose = b }

let set_output_format s =
  config := { !config with output_format = s }

let set_output_file s =
  config := { !config with output_file = Some s }

let anon_fun s =
  paths := s :: !paths

let parse_args () =
  let speclist = [
    ("-fix", Arg.Bool set_fix_mode, "enable fix mode");
    ("-v", Arg.Bool set_verbose, "enable verbose mode");
    ("-o", Arg.String set_output_file, "output file for lint issues");
    ("-format", Arg.String set_output_format, "output format (text|json)")
  ] in
  Arg.parse speclist anon_fun "usage: romulus [options] <file or directory> ...";
  (!config, List.rev !paths)
