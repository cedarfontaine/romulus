let rec get_ml_files dir =
  let rec aux acc path =
    let items = Sys.readdir path in
    Array.fold_left (fun acc item ->
      let full = Filename.concat path item in
      if Sys.is_directory full then aux acc full
      else if Filename.check_suffix item ".ml" then full :: acc
      else acc
    ) acc items
  in
  aux [] dir
