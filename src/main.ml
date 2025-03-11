open config
open reporter
open arg_parser
open file_util
open fixer
open rules
open logger

let process_file config file =
  let content =
    try
      let ic = open_in file in
      let n = in_channel_length ic in
      let s = really_input_string ic n in
      close_in ic;
      s
    with Sys_error err ->
      logger.log_error ("error reading file " ^ file ^ ": " ^ err);
      ""
  in
  if config.fix_mode then begin
    let fixed = fixer.apply_fixes config content in
    let oc = open_out file in
    output_string oc fixed;
    close_out oc;
    if config.verbose then logger.log_info ("fixed file: " ^ file)
  end else
    let issues = rules.run_all config content in
    if config.verbose then logger.log_info ("linted file: " ^ file);
    reporter.report_issues file config issues

let () =
  let (config, paths) = arg_parser.parse_args () in
  let files =
    List.fold_left (fun acc path ->
      if Sys.file_exists path && Sys.is_directory path then
        acc @ (file_util.get_ml_files path)
      else if Sys.file_exists path then path :: acc
      else acc
    ) [] paths
  in
  List.iter (process_file config) files
