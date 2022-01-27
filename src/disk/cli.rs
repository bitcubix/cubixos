use clap::{arg, App, ArgMatches, crate_version};

use super::device;

pub fn create() -> App<'static> {
    App::new("disk")
        .version(crate_version!())
        .about("disk utils")
        .arg(arg!(-l --list "list devices"))
}

pub fn handle(matches: &ArgMatches) {
    if matches.is_present("list") {
        device::list_devices();
    }
}
