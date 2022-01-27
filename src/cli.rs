use clap::{app_from_crate, arg};
use std::path::Path;

use super::disk;

pub fn run() {
    let matches = app_from_crate!()
        .mut_arg("help", |a| a.help("display help information"))
        .mut_arg("version", |a| a.help("display version information"))
        .arg(
            arg!(
                -v --verbose "display verbose output"
            )
        )
        .arg(
            arg!(
                -i --interactive "use interactive mode for installation"
            )
        )
        .arg(
            arg!(
                -c --config <FILE> "set custom config file"
            )
            .required(false)
            .allow_invalid_utf8(true),
        )
        .subcommand(
            disk::cli::create(),
        )
        .get_matches();
    
    if let Some(raw_config) = matches.value_of_os("config") {
        let config_path = Path::new(raw_config);
        println!("value for config: {}", config_path.display());
    }

    if matches.occurrences_of("verbose") == 1 {
        println!("verbose mode is on");
    }

    if let Some(matches) = matches.subcommand_matches("disk") {
        disk::cli::handle(matches);
    }
}
